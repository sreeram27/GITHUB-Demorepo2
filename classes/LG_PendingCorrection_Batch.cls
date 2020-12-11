global class LG_PendingCorrection_Batch implements Database.Batchable<sObject>,Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // string q='select id,Anthem_Entity_Transform__c,Pending_Correction_Time__c from Pending_Correction__c where (Contracts__c != null OR ID_Cards__c != '' OR Medical_Benefits__c != '' OR Underwriting__c != '' OR Rx__c != '' OR Dental_Complete__c != '' OR Life_and_Disability__c != '' OR Enrollment_and_Billing__c != '' OR Vision__c!= '' OR Issue_Control__c != '' OR FI_Id__c!= '' OR SBC__c!= '' OR InterPlan__c	!= '') AND Anthem_Entity_Transform__c = 'Local'';
        //string q='select id,Anthem_Entity_Transform__c,Pending_Correction_Time__c,Medical_Benefits__c,FI_Id__c,Contracts__c,ID_Cards__c,Underwriting__c,Rx__c,Dental_Complete__c,Life_and_Disability__c,Enrollment_and_Billing__c,Vision__c,Issue_Control__c,SBC__c,InterPlan__c from Pending_Correction__c where (Contracts__c != null OR ID_Cards__c != null OR Medical_Benefits__c != null OR Underwriting__c != null OR Rx__c != null OR Dental_Complete__c != null OR Life_and_Disability__c != null OR Enrollment_and_Billing__c != null OR Vision__c!= null OR Issue_Control__c != null OR FI_Id__c!= null OR SBC__c!= null OR InterPlan__c != null) AND Anthem_Entity_Transform__c  = \'' + 'Local' + '\'';    
        return database.getQueryLocator('select id,Anthem_Entity_Transform__c,Pending_Correction_Time__c,Medical_Benefits__c,FI_Id__c,Contracts__c,ID_Cards__c,Underwriting__c,Rx__c,Dental_Complete__c,Life_and_Disability__c,Enrollment_and_Billing__c,Vision__c,Issue_Control__c,SBC__c,InterPlan__c from Pending_Correction__c where (Contracts__c != null OR ID_Cards__c != null OR Medical_Benefits__c != null OR Underwriting__c != null OR Rx__c != null OR Dental_Complete__c != null OR Life_and_Disability__c != null OR Enrollment_and_Billing__c != null OR Vision__c!= null OR Issue_Control__c != null OR FI_Id__c!= null OR SBC__c!= null OR InterPlan__c != null) AND Anthem_Entity_Transform__c  = \'' + 'Local' + '\'');
    }
    global void execute(Database.BatchableContext bc, List<Pending_Correction__c> PCList){
        // process each batch of records
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
        //this is for IDCards
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
        
        //this is for Medical Benefits	
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
        //this is for Underwriting
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
        //this is for RX
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
        system.debug(RXList);
        if(!RXList.isEmpty())
        {
            update RXList;
        }
        //this is for Dental_Complete__c
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
        //this is for Life_and_Disability__c
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
        //this is for Enrollment_and_Billing__c
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
        //this is for Vision__c	
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
        //this is for Issue_Control__c
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
        //this is for First_Impressions__c
        set<Id> FIId=new set<Id>();
        for(Pending_Correction__c P: PCList)
        {
            FIId.add(P.FI_Id__c);
        }
        list<First_Impressions__c> FIList = new list<First_Impressions__c>();
        for(First_Impressions__c FI : [select ID,Pending_Correction_Time__c,(select Pending_Correction_Time__c from Pending_Corrections__r) from First_Impressions__c where ID IN : FIId ])
        {
            Double sumOfPending_Correction_Time = 0.0;
            
            for(Pending_Correction__c P: FI.Pending_Corrections__r)
            {
                if(P.Pending_Correction_Time__c != null)
                {
                    sumOfPending_Correction_Time += P.Pending_Correction_Time__c;
                }
            }
            
            FI.Pending_Correction_Time__c = sumOfPending_Correction_Time;
            FIList.add(FI);
            
        }
        system.debug(FIList);
        if(!FIList.isEmpty())
        {
            update FIList;
        }
        //this is for SBC__c
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
        
        //this is for InterPlan__c
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
    }    
    global void finish(Database.BatchableContext bc)
    {
        // execute any post-processing operations
    }    
}