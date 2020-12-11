/*
@Author : Ravideep (Vikings)
@name : CaseInstallationTriggerHandler
@CreateDate : 04/03/2019
@Description : This is handler class for CaseInstallationTrigger.
@Updates 1) 04/25/2019 - PRDCRM-33525 : Covering scenario if case installation record is created when membership already exists - Ravideep
2) 7/18/2019 - PRDCRM-38796 : Associate RX and Medical Installation records to CI record when a new case installation is created
*/
public class CaseInstallationTriggerHandler{  
    
    /* PRDCRM-32122 : This method gives error while creating a new record if an existing record has been tagged to implementation case: Ravideep */ 
    public Set<Id> ImplTrackingIds = new Set<id>();
    public Map<Id,List<Issue_Control__c>> MapCaseInstallation = New Map<Id,List<Issue_Control__c>>();
    public Map<Id,Id> MapITtoIC = New Map<Id,Id>();
    public List<Enrollment_and_Billing__c> MembershipList = New List<Enrollment_and_Billing__c>();
    
    public List<Rx__c> RxList = New List<Rx__c>();
    public List<Medical_Benefit__c> MedBenList = New List<Medical_Benefit__c>();
    
    public Map<Id,Id> MapITIdtoMembershipId = New Map<Id,Id>();
    
    public Map<Id,Id> MapITIdtoRxId = New Map<Id,Id>();
    public Map<Id,Id> MapITIdtoMedBenId = New Map<Id,Id>();
    
    public List<Issue_Control__c> CaseInstallationList = new List<Issue_Control__c>();
    public List<Order> ImplementationCaseList = new List<Order>();
    public String local = staticVariableClass.Entity;
    
    public void showErrorBeforeInsert(List<Issue_Control__c> NewCaseInstallationList){
        for(Issue_Control__c caseins : NewCaseInstallationList){
            /* PRDCRM-32122 : Retrieving implementation trackings Ids: Ravideep */
            ImplTrackingIds.add(caseins.Implementation_Tracking_ID__c); 
        }
        
        system.debug('ImplTrackingIds---> ' + ImplTrackingIds);
        
        /* PRDCRM-32122 : Fetching case installation records already existing for implementation trackin records: Ravideep */
        /* PRDCRM-33525 : Fetching Membership records already existing for implementation trackin records: Ravideep */
        /* PRDCRM-38796 : Fetching RX and Medical Benefit records already existing for implementation tracking records: Partha*/
        
        if(!ImplTrackingIds.isEmpty()){
            CaseInstallationList = [select id,Name,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c from Issue_Control__c where Implementation_Tracking_ID__c IN: ImplTrackingIds and Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local];
            
            MembershipList = [select id,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c from Enrollment_and_Billing__c where Implementation_Tracking_ID__c IN : ImplTrackingIds and Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local];
            
            
            
            RxList=[Select id,Implementation_Tracking_ID__c from RX__c where Implementation_Tracking_ID__c IN: ImplTrackingIds and Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local]; 
            
            MedBenList=[Select id,Implementation_Tracking_ID__c from Medical_Benefit__c where Implementation_Tracking_ID__c IN: ImplTrackingIds and Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local]; 
        }
        system.debug('CaseInstallationList---> ' + CaseInstallationList);
        system.debug('MembershipList---> ' + MembershipList);
        system.debug('RxList---> ' + RxList);
        system.debug('MedBenList---> ' + MedBenList);
        
        
        /* PRDCRM-32122 :MapITtoIC links implementation tracking to implementation case : Ravideep */
        /* PRDCRM-32122 :MapCaseInstallation links implementation case to Case Installation : Ravideep */
        
        if(!CaseInstallationList.isEmpty()){
            for(Issue_Control__c caseins : CaseInstallationList){
                MapITtoIC.put(caseins.Implementation_Tracking_ID__c,caseins.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                if(MapCaseInstallation.containsKey(caseins.Implementation_Tracking_ID__r.Implementation_Record_ID__c)){
                    MapCaseInstallation.get(caseins.Implementation_Tracking_ID__r.Implementation_Record_ID__c).add(caseins);
                }
                else{
                    MapCaseInstallation.put(caseins.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<Issue_Control__c> { caseins });
                }
            }
        }
        system.debug('MapITtoIC---> ' + MapITtoIC);
        system.debug('MapCaseInstallation---> ' + MapCaseInstallation);
        
        /* PRDCRM-33525 : MapITIdtoMembershipId links implementation tracking to membership record ids: Ravideep */
        
        If(!MembershipList.isEmpty()){
            for(Enrollment_and_Billing__c mem :MembershipList){
                MapITIdtoMembershipId.put(mem.Implementation_Tracking_ID__c,mem.id);
            }
            
        }
        system.debug('MapITIdtoMembershipId---> ' + MapITIdtoMembershipId);
        
        
        
        
        
        If(!RxList.isEmpty()){
            for(Rx__c rx :RxList){
                MapITIdtoRxId.put(rx.Implementation_Tracking_ID__c,rx.id);
            }
            
        }
        
        system.debug('MapITIdtoRxId---> ' + MapITIdtoRxId);
        If(!MedBenList.isEmpty()){
            for(Medical_Benefit__c mBen :MedBenList){
                MapITIdtoMedBenId.put(mBen.Implementation_Tracking_ID__c,mBen.id);
            }
            
        }
        
        system.debug('MapITIdtoMedBenId---> ' + MapITIdtoMedBenId);
        for(Issue_Control__c ic : NewCaseInstallationList){
            if(!MapITtoIC.isEmpty() && MapITtoIC.containsKey(ic.Implementation_Tracking_ID__c) && MapITtoIC.get(ic.Implementation_Tracking_ID__c)!= null){
                if(!MapCaseInstallation.isEmpty() && MapCaseInstallation.get(MapITtoIC.get(ic.Implementation_Tracking_ID__c))!= null && MapCaseInstallation.get(MapITtoIC.get(ic.Implementation_Tracking_ID__c)).size()>0){// If greater than 0, throw error
                    ic.addError(system.label.ErrorCaseInstallation);
                }
            }
            
            if(!MapITIdtoMembershipId.isEmpty() && MapITIdtoMembershipId.get(ic.Implementation_Tracking_ID__c) != null){// link membership record
                ic.Membership__c = MapITIdtoMembershipId.get(ic.Implementation_Tracking_ID__c);
            }
            
            
            //  PRDCRM-38796
            if(!MapITIdtoRxId.isEmpty() && MapITIdtoRxId.get(ic.Implementation_Tracking_ID__c) != null){// link Rx record
                ic.RX__c= MapITIdtoRxId.get(ic.Implementation_Tracking_ID__c);
            }
            //  PRDCRM-38796
            if(!MapITIdtoMedBenId.isEmpty() && MapITIdtoMedBenId.get(ic.Implementation_Tracking_ID__c) != null){// link Medical Benefit record
                ic.Medical_Benefits__c = MapITIdtoMedBenId.get(ic.Implementation_Tracking_ID__c);
            }
            
        }
        
    }
    
    //Added by Rahul
    public void populateCaseInstallationOnIDCard(List<Issue_Control__c> NewCaseInstallationList1){
        List<ID_Cards__c> idcardList = new List<ID_Cards__c>();
        List<ID_Cards__c> iDcardsListToUpdate = new List<ID_Cards__c>();
        Map<Id,Id> mapITIdToMemId = New Map<Id,Id>(); 
        
        for(Issue_Control__c caseins : NewCaseInstallationList1){
            mapITIdToMemId.put(caseins.Implementation_Tracking_ID__c,caseins.Id); 
        }
        
        if(!MapITIdToMemId.keyset().isEmpty()){
            idcardList  =[SELECT id,Implementation_Tracking_ID__c,Membership__c,Case_Installation__c from ID_Cards__c 
                          WHERE Implementation_Tracking_ID__c IN: MapITIdToMemId.keyset() 
                          AND Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local]; 
        }
        if(!idcardList.isEmpty()){
            for(ID_Cards__c varIDCard : idcardList){
                if(mapITIdToMemId.containskey(varIDCard.Implementation_Tracking_ID__c)){
                    varIDCard.Case_Installation__c = mapITIdToMemId.get(varIDCard.Implementation_Tracking_ID__c)==null?'':MapITIdToMemId.get(varIDCard.Implementation_Tracking_ID__c);               
                    iDcardsListToUpdate.add(varIDCard);
                }
            }
        }
        if(!IDcardsListToUpdate.isEmpty()){
            database.update(iDcardsListToUpdate,False);
        }
        
        
    }
    /*
@Author : Rahul (Vikings)
@name : assignTriggerReadyDate
@CreateDate : 09/11/2019 
@description : Method to invoke populateTriggerReadyDate, Jira ID:40003
@param : trigger.new,trigger.oldMap
*/
    public void assignTriggerReadyDate(List<Issue_Control__c> NewCaseInstallationList,Map<ID,Issue_Control__c>OldCaseInstallationMap){
        Map<Id,Issue_Control__c> mapTrackingIDInstallationID= New Map<Id,Issue_Control__c>();
        
        if(OldCaseInstallationMap == null){
            for(Issue_Control__c caseInstallation : NewCaseInstallationList){
                if(caseInstallation.Partial_Rates_Loaded__c!= null){
                    mapTrackingIDInstallationID.put(caseInstallation.Implementation_Tracking_ID__c,caseInstallation); 
                }
            } 
        }else{
            for(Issue_Control__c caseInstallation : NewCaseInstallationList){
                if(caseInstallation.Partial_Rates_Loaded__c != OldCaseInstallationMap.get(caseInstallation.id).Partial_Rates_Loaded__c){
                    mapTrackingIDInstallationID.put(caseInstallation.Implementation_Tracking_ID__c,caseInstallation); 
                }
            }
        }
        if(mapTrackingIDInstallationID !=null ){
            populateTriggerReadyDate(mapTrackingIDInstallationID);
        }
    }
    /*
@Author : Rahul (Vikings)
@name : populateTriggerReadyDate
@CreateDate : 09/11/2019
@description : Method To populate Trigger Ready Date on ID card, Jira ID:40003
@param : Map<ID,Issue_Control__c>
*/
    public void populateTriggerReadyDate(Map<Id,Issue_Control__c> MapTrackingIDInstallationID){
        List<ID_Cards__c> listIDCard =new List<ID_Cards__c>();
        List<ID_Cards__c> listIDCardUpdated= new List<ID_Cards__c>();
        
        listIDCard= [SELECT id,Implementation_Tracking_ID__c,Membership__c,Case_Installation__c,Trigger_Ready_Date__c from ID_Cards__c 
                     Where Implementation_Tracking_ID__c IN: MapTrackingIDInstallationID.keyset()
                     AND Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local];
        if(!listIDCard.isEmpty()){
            for(ID_Cards__c varIDCard : listIDCard){
                if(mapTrackingIDInstallationID.containskey(varIDCard.Implementation_Tracking_ID__c)){
                    varIDCard.Trigger_Ready_Date__c = mapTrackingIDInstallationID.get(varIDCard.Implementation_Tracking_ID__c).Partial_Rates_Loaded__c;               
                    listIDCardUpdated.add(varIDCard);
                }
            }
            if(!listIDCardUpdated.isEmpty()){
                database.update(listIDCardUpdated,False);
            }
        }  
    }
    
}