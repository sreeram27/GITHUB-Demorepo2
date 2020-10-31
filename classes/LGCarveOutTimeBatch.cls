/**
@Author : Deloitte
@name : LGCarveOutTimeBatch
@CreateDate :30-03-2019
@Description : This class will stamp the value of Pening Correction time from SME object to corresponding Implementation Case when the SME tracking record exists.
*/
global class LGCarveOutTimeBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    public Map<Id, String> errorMap {get; set;}
    public Map<Id, String> successMap{get; set;}
    String queryString;
    set<Id> orderIdSet = new set<ID>();
    //public  Map<Id,List<string>> orderIdToPendingDepartments {get;set;}
    
    public LGCarveOutTimeBatch()
    {
        //orderIdToPendingDepartments=new Map<Id,List<string>>();
        successMap=new Map<Id, String>();
        errorMap=new Map<Id, String>();
        //queryString ='select Carve_Out_Process_Records__c,id,Anthem_Entity__c,Current_SME_Stage__c,Pending_Correction_Time__c,Implementation_Status__c,Tracking_Record_Exists__c from order where Tracking_Record_Exists__c=true and Carve_Out_Process_Records__c=false and Anthem_Entity__c in ('+ '\'Local/Large Group\'' +',' + '\'Labor and Trust\'' +')';
        queryString ='select Carve_Out_Process_Records__c,id,Anthem_Entity__c,Current_SME_Stage__c,Pending_Correction_Time__c,Implementation_Status__c,Tracking_Record_Exists__c from order where Carve_Out_Process_Records__c=false and Anthem_Entity__c in ('+ '\'Local/Large Group\'' +',' + '\'Labor and Trust\'' +')';
    }
    public LGCarveOutTimeBatch(Set<Id> orderIdSet_actual)
    {
        //orderIdToPendingDepartments=new Map<Id,List<string>>();
        successMap=new Map<Id, String>();
        errorMap=new Map<Id, String>();
        orderIdSet = orderIdSet_actual;
       // queryString ='select Carve_Out_Process_Records__c,id,Anthem_Entity__c,Current_SME_Stage__c,Pending_Correction_Time__c,Implementation_Status__c,Tracking_Record_Exists__c from order where id IN : orderIdSet and Tracking_Record_Exists__c=true and Carve_Out_Process_Records__c=false and Anthem_Entity__c in ('+ '\'Local/Large Group\'' +',' + '\'Labor and Trust\'' +')';
        queryString ='select Carve_Out_Process_Records__c,id,Anthem_Entity__c,Current_SME_Stage__c,Pending_Correction_Time__c,Implementation_Status__c,Tracking_Record_Exists__c from order where id IN : orderIdSet and Carve_Out_Process_Records__c=false and Anthem_Entity__c in ('+ '\'Local/Large Group\'' +',' + '\'Labor and Trust\'' +')';
  
    }
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
          System.debug(queryString);
        return database.getQueryLocator(queryString);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Order> orderList) { 
        System.debug('orderList'+orderList);
        set<Id> orderid=new set<Id>();
        set<Id> orderidwithoutTrack=new set<Id>();
        List<order> orderToBeUpdated=new List<Order>();
       
        for(order o:orderList)
        {
           //orderid.add(o.id);
           if(o.Tracking_Record_Exists__c == true){
                orderid.add(o.id);
            }else{
                orderidwithoutTrack.add(o.id);
            }
        }
        System.debug('orderidwithoutTrack'+orderidwithoutTrack);
        if(!orderid.isEmpty() && orderid != null){
        Map<string,string> OrderidtoImpTrackId=new Map<string,string>();
        for(Implementation_Tracking__c eachtrackrec:[select id,Implementation_Record_ID__c from Implementation_Tracking__c where Implementation_Record_ID__c in :orderid])
        {
            OrderidtoImpTrackId.put(eachtrackrec.Implementation_Record_ID__c,eachtrackrec.id);
        }
        
       
        List<Pending_Correction__c> PCList = [select id,Anthem_Entity_Transform__c,Pending_Correction_Time__c,Medical_Benefits__c,FI_Id__c,Contracts__c,ID_Cards__c,Underwriting__c,Rx__c,Dental_Complete__c,Life_and_Disability__c,Enrollment_and_Billing__c,Vision__c,Issue_Control__c,SBC__c,InterPlan__c from Pending_Correction__c where (Contracts__c != null OR ID_Cards__c != null OR Medical_Benefits__c != null OR Underwriting__c != null OR Rx__c != null OR Dental_Complete__c != null OR Life_and_Disability__c != null OR Enrollment_and_Billing__c != null OR Vision__c!= null OR Issue_Control__c != null OR FI_Id__c!= null OR SBC__c!= null OR InterPlan__c != null) AND Anthem_Entity_Transform__c  =  'Local' AND Implementation_Case__c IN:orderid];
        Map<Id,double> orderIdToPendingCorrection=new Map<Id,double>();
        //Rx
        //for pending correction
        //Pratibha Added on 06/06-Start
         set<Id> RXId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            RXId.add(P.RX__c);
        }   
        list<RX__c> RXList = new list<RX__c>();
        for(Rx__c RX : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from Rx__c where ID IN : RXId ])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: RX.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            RX.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            RXList.add(RX);
            
            
        }
        system.debug('RXList'+ RXList);
        if(!RXList.isEmpty())
        {
            update RXList;
        }
        //Pratibha Added on 06/06-end
        
       // agrList.clear();
        List<AggregateResult> agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM Rx__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        // for Dental
        // for pending correction
        //Pratibha Added on 06/06-Start
        set<Id> DentalCompId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            DentalCompId.add(P.Dental_Complete__c);
        }
        list<Dental_Complete__c> DCList = new list<Dental_Complete__c>();
        for(Dental_Complete__c DC : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from Dental_Complete__c where ID IN : DentalCompId])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: DC.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            DC.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            DCList.add(DC);
           
        }
        system.debug(DCList); 
        if(!DCList.isEmpty())
        {
            update DCList;
        }
        //Pratibha Added on 06/06-End
       // Map<Id,double> orderIdToPendingCorrection=new Map<Id,double>();
       agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM Dental_Complete__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums')); //Pratibha added to handle null reference exception.
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        //Vision
        // pending correction
        //Pratibha Added on 06/06-Start
        set<Id> VisionId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            VisionId.add(P.Vision__c);
        }
        list<Vision__c> VList = new list<Vision__c>();
        for(Vision__c V : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from Vision__c where ID IN : VisionId ])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: V.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            V.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            VList.add(V);
            
        }
        system.debug(VList);
        if(!VList.isEmpty())
        {
            update VList;
        }
        //Pratibha Added on 06/06-end
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM Vision__c WHERE Implementation_Tracking__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        //UnderWriting
        //for Pending correction
        //Pratibha Added on 06/06-Start
         set<Id> UnderWriId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            UnderWriId.add(P.Underwriting__c);
        }
        list<Underwriting__c> UnderList = new list<Underwriting__c>();
        for(Underwriting__c UD : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from Underwriting__c where ID IN : UnderWriId])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: UD.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            UD.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            UnderList.add(UD);
            system.debug(UnderList);
            
        }
        system.debug(UnderList);
        if(!UnderList.isEmpty())
        {
            update UnderList;
        }
        //Pratibha Added on 06/06-end
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM Underwriting__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        //Membership
        //for pending correction
        //Pratibha Added on 06/06-Start
        set<Id> EnBId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            EnBId.add(P.Enrollment_and_Billing__c);
        }       
        list<Enrollment_and_Billing__c> EBList = new list<Enrollment_and_Billing__c>();
        for(Enrollment_and_Billing__c EB : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from Enrollment_and_Billing__c where ID IN : EnBId])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: EB.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            EB.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            EBList.add(EB);
            
        }
        system.debug(EBList);
        if(!EBList.isEmpty())
        {
            update EBList;
        }
        //Pratibha Added on 06/06-end
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM Enrollment_and_Billing__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        //Interplan
        //for pending correction
        //Pratibha Added on 06/06-Start
        set<Id> InterPlanId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            InterPlanId.add(P.InterPlan__c);
        }
        list<InterPlan__c> IPList = new list<InterPlan__c>();
        for(InterPlan__c IP : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from InterPlan__c where ID IN : InterPlanId])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: IP.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            IP.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            IPList.add(IP);
            
        }
        system.debug(IPList);
        if(!IPList.isEmpty())
        {
            update IPList;
        }
        //Pratibha Added on 06/06-end
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM InterPlan__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        
        //Case Installation
        //for pending correction
        //Pratibha Added on 06/06-Start
        set<Id> ICId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            ICId.add(P.Issue_Control__c);
        }
        list<Issue_Control__c> ICList = new list<Issue_Control__c>();
        for(Issue_Control__c IC : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from Issue_Control__c where ID IN : ICId])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: IC.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            IC.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            ICList.add(IC);
            
        }
        system.debug(ICList);
        if(!ICList.isEmpty())
        {
            update ICList;
        }
        //Pratibha Added on 06/06-end
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM Issue_Control__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        //Life and Disability
        //for pending correction
        //Pratibha Added on 06/06-Start
        set<Id> LnDId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            LnDId.add(P.Life_and_Disability__c);
        }   
        list<Life_and_Disability__c> LDList = new list<Life_and_Disability__c>();
        for(Life_and_Disability__c LD : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from Life_and_Disability__c where ID IN : LnDId ])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: LD.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            LD.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            LDList.add(LD);
             
            
        }
        system.debug(LDList);
        if(!LDList.isEmpty())
        {
            update LDList;
        }
        //Pratibha Added on 06/06-end
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM Life_and_Disability__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        //SBC
        //for pending correction
        //Pratibha Added on 06/06-Start
        set<Id> SBCId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            SBCId.add(P.SBC__c);
        }
        list<SBC__c> SBList = new list<SBC__c>();
        for(SBC__c SB : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from SBC__c where ID IN : SBCId ])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: SB.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            SB.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            SBList.add(SB);
            
        }
        system.debug(SBList);
        if(!SBList.isEmpty())
        {
            update SBList;
        }
        //Pratibha Added on 06/06-end
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM SBC__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        //Contracts
        //for pending correction
        //Pratibha Added on 06/06-Start     
        set<Id> ContractsId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            ContractsId.add(P.Contracts__c);
        }
        //this is for Contracts
        list<Contracts__c> ContractsList = new list<Contracts__c>();
        for(Contracts__c C : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from Contracts__c where ID IN:  ContractsId])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: C.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            C.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            ContractsList.add(C);
             
        }
        system.debug(ContractsList);
        if(!ContractsList.isEmpty())
        {
            update  ContractsList;
        }
        //Pratibha Added on 06/06-end
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM Contracts__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);   
        
        //ID Card
        //for pending correction
        //Pratibha Added on 06/06-Start     
        set<Id> IdcardsId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            IdcardsId.add(P.ID_Cards__c);
        }   
        list<ID_Cards__c> IdCardsList = new list<ID_Cards__c>();
        for(ID_Cards__c IdCards : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from ID_Cards__c where ID IN : IdcardsId])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: IdCards.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            IdCards.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            IdCardsList.add(IdCards);
            
        }
        system.debug(IdCardsList);
        if(!IdCardsList.isEmpty())
        {
            update  IdCardsList;
        }
        //Pratibha Added on 06/06-end
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM ID_Cards__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        
        //Medical Benefit
        // for pending correction
        //Pratibha Added on 06/06-Start
        set<Id> MedId= new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            MedId.add(P.Medical_Benefits__c);
        }
        list<Medical_Benefit__c> MBList = new list<Medical_Benefit__c>();
        for(Medical_Benefit__c MB : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from Medical_Benefit__c where ID IN: MedId ])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: MB.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            MB.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            MBList.add(MB);
            system.debug(MBList);
        }
        system.debug(MBList);
        if(!MBList.isEmpty())
        {
            update MBList;
        }
        //Pratibha Added on 06/06-end
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM Medical_Benefit__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        //First Impression
        //for pending correction
        //Map<Id,double> orderIdToPendingCorrection=new Map<Id,double>();
        agrList.clear();
        agrList =  [SELECT Implementation_Tracking_ID__r.Implementation_Record_ID__c OrderId, SUM(Pending_correction_time__c) Sums FROM First_Impressions__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in :orderid AND Pending_correction_time__c != NULL group by Implementation_Tracking_ID__r.Implementation_Record_ID__c];
        system.debug(agrList);
        for(AggregateResult sr : agrList)
        {
            //orderIdToPendingCorrection.put(sr.get('OrderId'),sr.get('Sums'));
            //orderIdToPendingCorrection.put((id)sr.get('OrderId'),orderIdToPendingCorrection.get((id)sr.get('OrderId'))  + (double)sr.get('Sums'));
            Double pendingCorrectionTime = orderIdToPendingCorrection.get((id)sr.get('OrderId')) == null ? 0.0 :  orderIdToPendingCorrection.get((id)sr.get('OrderId'));
            orderIdToPendingCorrection.put((id)sr.get('OrderId'),pendingCorrectionTime  +(double)sr.get('Sums'));
        }
        system.debug('orderIdToPendingCorrection-->'+orderIdToPendingCorrection);
        
        
        //Pending correction update on Order -- V1
      /*  List<order>orderToBeUpdated=new List<Order>();
        for(order PendingCorrorder: [select id,Current_SME_Stage__c,Pending_Correction_Time__c,Total_Time__c,Imp_Time__c,SME_time__c,Int_Ret_Rev_time__c,Tracking_Record_Exists__c,Carve_Out_Process_Records__c from order where id in:orderIdToPendingCorrection.keyset()])
        {
            PendingCorrorder.Pending_Correction_Time__c= orderIdToPendingCorrection.get(PendingCorrorder.id);
            PendingCorrorder.Total_Time__c = PendingCorrorder.Imp_Time__c + PendingCorrorder.SME_time__c + PendingCorrorder.Int_Ret_Rev_time__c + PendingCorrorder.Pending_Correction_Time__c ;
            PendingCorrorder.Carve_Out_Process_Records__c =true;
            orderToBeUpdated.add(PendingCorrorder);
        }*/
        
        //Pending correction update on Order -- V2
      //  List<order>orderToBeUpdated=new List<Order>();
        if(orderIdToPendingCorrection.size() >0){
        for(order PendingCorrorder: [select id,Current_SME_Stage__c,Pending_Correction_Time__c,Total_Time__c,Imp_Time__c,SME_time__c,Int_Ret_Rev_time__c,Tracking_Record_Exists__c,Carve_Out_Process_Records__c from order where id in:orderIdToPendingCorrection.keyset()])
        {
            PendingCorrorder.Pending_Correction_Time__c= orderIdToPendingCorrection.get(PendingCorrorder.id);
            PendingCorrorder.Total_Time__c = PendingCorrorder.Imp_Time__c + PendingCorrorder.SME_time__c + PendingCorrorder.Int_Ret_Rev_time__c + PendingCorrorder.Pending_Correction_Time__c ;
            PendingCorrorder.Carve_Out_Process_Records__c =true;
            
           system.debug('PendingCorrorder.Pending_Correction_Time__c'+ PendingCorrorder.Pending_Correction_Time__c);
            system.debug('PendingCorrorder.Total_Time__c'+ PendingCorrorder.Total_Time__c);
            system.debug('PendingCorrorder.Imp_Time__c'+ PendingCorrorder.Imp_Time__c);
            system.debug('PendingCorrorder.Int_Ret_Rev_time__c'+ PendingCorrorder.Int_Ret_Rev_time__c);
            //system.debug('PendingCorrorder.Pending_Correction_Time__clist'+ orderIdToPendingCorrection.get(PendingCorrorder.id));
            orderToBeUpdated.add(PendingCorrorder);
            system.debug('PendingCorrorder'+ orderToBeUpdated);
        }
        }
        else{
        for(order PendingCorrorder: [select id,Current_SME_Stage__c,Pending_Correction_Time__c,Total_Time__c,Imp_Time__c,SME_time__c,Int_Ret_Rev_time__c,Tracking_Record_Exists__c,Carve_Out_Process_Records__c from order where id in:orderid])
        {
            System.debug('PendingCorrorder ****************8'+PendingCorrorder);
             system.debug('PendingCorrorder.Total_Time__c'+ PendingCorrorder.Total_Time__c);
            system.debug('PendingCorrorder.Imp_Time__c'+ PendingCorrorder.Imp_Time__c);
            system.debug('PendingCorrorder.Int_Ret_Rev_time__c'+ PendingCorrorder.Int_Ret_Rev_time__c);
           // PendingCorrorder.Pending_Correction_Time__c= orderIdToPendingCorrection.get(PendingCorrorder.id);
            PendingCorrorder.Total_Time__c = PendingCorrorder.Imp_Time__c + PendingCorrorder.SME_time__c + PendingCorrorder.Int_Ret_Rev_time__c; //+ PendingCorrorder.Pending_Correction_Time__c ;
            PendingCorrorder.Carve_Out_Process_Records__c =true;
            orderToBeUpdated.add(PendingCorrorder);
        }   
        }
      //v2-END  
        
        if(!orderToBeUpdated.isempty() && orderToBeUpdated.size() >0)
        {
            //update orderToBeUpdated;
            Database.SaveResult[] srList = Database.update(orderToBeUpdated, false);
            for(Integer i=0;i<srList.size();i++)
            {
                if (!srList.get(i).isSuccess()){
                    // DML operation failed
                    Database.Error error = srList.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    //orderToBeUpdated.get(i);//failed record from the list
                    system.debug('Failed ID'+orderToBeUpdated.get(i).Id+':'+failedDML);
                    errorMap.put(orderToBeUpdated.get(i).Id,failedDML);
                    
                }
                
            }
            
            
        }
        }
         if(!orderidwithoutTrack.isEmpty() && orderidwithoutTrack!=null){
            system.debug('Entered');
              List<order> orderToBeUpdatedWithouttracking=new List<Order>();
            for(order PendingCorrorder: [select id,Current_SME_Stage__c,Pending_Correction_Time__c,Total_Time__c,Imp_Time__c,SME_time__c,Int_Ret_Rev_time__c,Tracking_Record_Exists__c,Carve_Out_Process_Records__c from order where id in:orderidwithoutTrack])
        {
            System.debug('PendingCorrorder'+PendingCorrorder);
              System.debug('PendingCorrorder.Imp_Time__c'+PendingCorrorder.Imp_Time__c);
            System.debug('PendingCorrorder.SME_time__c'+PendingCorrorder.SME_time__c);
            System.debug('PendingCorrorder.Int_Ret_Rev_time__c'+PendingCorrorder.Int_Ret_Rev_time__c);
         
           // PendingCorrorder.Pending_Correction_Time__c= orderIdToPendingCorrection.get(PendingCorrorder.id);
            PendingCorrorder.Total_Time__c = PendingCorrorder.Imp_Time__c + PendingCorrorder.SME_time__c + PendingCorrorder.Int_Ret_Rev_time__c; //+ PendingCorrorder.Pending_Correction_Time__c ;
            PendingCorrorder.Carve_Out_Process_Records__c =true;
            orderToBeUpdatedWithouttracking.add(PendingCorrorder);
            system.debug('isupdated');
        } 
           if(!orderToBeUpdatedWithouttracking.isempty() && orderToBeUpdatedWithouttracking.size() >0)
        {
            //update orderToBeUpdated;
            Database.SaveResult[] srList = Database.update(orderToBeUpdatedWithouttracking, false);
            for(Integer i=0;i<srList.size();i++)
            {
                if (!srList.get(i).isSuccess()){
                    // DML operation failed
                    Database.Error error = srList.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    //orderToBeUpdated.get(i);//failed record from the list
                    system.debug('Failed ID'+orderToBeUpdatedWithouttracking.get(i).Id+':'+failedDML);
                    errorMap.put(orderToBeUpdatedWithouttracking.get(i).Id,failedDML);
                    
                }
                
            }
            
            
        }  
             
        }
        /* if(!orderToBeUpdated.isempty() && orderToBeUpdated.size() >0)
        {
            //update orderToBeUpdated;
            Database.SaveResult[] srList = Database.update(orderToBeUpdated, false);
            for(Integer i=0;i<srList.size();i++)
            {
                if (!srList.get(i).isSuccess()){
                    // DML operation failed
                    Database.Error error = srList.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    //orderToBeUpdated.get(i);//failed record from the list
                    system.debug('Failed ID'+orderToBeUpdated.get(i).Id+':'+failedDML);
                    errorMap.put(orderToBeUpdated.get(i).Id,failedDML);
                    
                }
                
            }
            
            
        }*/
        List<ExceptionLog__c> excepreclst=new List<ExceptionLog__c>();
        for(Id i: errorMap.keyset())
        {
            excepreclst.add(new ExceptionLog__c(ClassName__c='LGCarveOutTimeBatch', ExceptionLogTimestamp__c=Datetime.now(),
                                                Order__c=i,ExceptionDetails__c=errorMap.get(i),Order_Id__c=i));
        }
        try
        {
            if(!excepreclst.isempty() && excepreclst.size() >0)
            {
                upsert excepreclst ExceptionLog__c.Fields.Order_Id__c;
            }
        }
        
        Catch(Exception ex) { system.debug('The exception is:'+ex.getmessage()+'and line no is:'+ex.getlinenumber());
                            }
        
    }
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}