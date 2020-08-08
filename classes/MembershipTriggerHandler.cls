/*
@Author : Ravideep (Vikings)
@name : MembershipTriggerHandler
@CreateDate : 04/05/2019
@Description : This is handler class for MembershipTrigger.
*/
public class MembershipTriggerHandler{  
   
    /* PRDCRM-32122 : This method gives error while creating a new record if an existing record has been tagged to implementation case: Ravideep */ 
    public Set<Id> ImplTrackingIds = new Set<id>();
    public Set<Id> MembershipIds = new Set<id>();
    public Map<Id,List<Enrollment_and_Billing__c>> MapMembership = New Map<Id,List<Enrollment_and_Billing__c>>();
    public Map<Id,Id> MapITIdToMemId = New Map<Id,Id>();
    public Map<Id,Id> MapITtoIC = New Map<Id,Id>();
    public List<Enrollment_and_Billing__c> MembershipList = new List<Enrollment_and_Billing__c>();
    public List<Order> ImplementationCaseList = new List<Order>();
    public List<Issue_Control__c> CaseInstallationList = new List<Issue_Control__c>();
    public List<Issue_Control__c> CaseInstallationListToUpdate = new List<Issue_Control__c>();
    public String local = staticVariableClass.Entity;
    
    public void showErrorBeforeInsert(List<Enrollment_and_Billing__c> NewMembershipList){
        for(Enrollment_and_Billing__c mem : NewMembershipList){
            /* PRDCRM-32122 : Retrieving implementation trackings Ids: Ravideep */
            ImplTrackingIds.add(mem.Implementation_Tracking_ID__c); 
        }
        
        system.debug('ImplTrackingIds---> ' + ImplTrackingIds);
        
        /* PRDCRM-32122 : Fetching membership records that already exist for implementation tracking records: Ravideep */
        if(!ImplTrackingIds.isEmpty()){
        MembershipList = [select id,Name,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c from Enrollment_and_Billing__c where Implementation_Tracking_ID__c IN: ImplTrackingIds and Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local];
        }
        system.debug('MembershipList1---> ' + MembershipList);
        
        
        /* PRDCRM-32122 :MapITtoIC links implementation tracking to implementation case : Ravideep */
        /* PRDCRM-32122 :MapMembership links implementation case to Membership Records : Ravideep */
        if(!MembershipList.isEmpty()){
            for(Enrollment_and_Billing__c mem : MembershipList){
                MapITtoIC.put(mem.Implementation_Tracking_ID__c,mem.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                if(MapMembership.containsKey(mem.Implementation_Tracking_ID__r.Implementation_Record_ID__c)){
                    MapMembership.get(mem.Implementation_Tracking_ID__r.Implementation_Record_ID__c).add(mem);
                }
                else{
                    MapMembership.put(mem.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<Enrollment_and_Billing__c> { mem });
                }
            }
        }
        system.debug('MapITtoIC---> ' + MapITtoIC);
        system.debug('MapMembership---> ' + MapMembership);
        
        for(Enrollment_and_Billing__c mem : NewMembershipList){
            if(!MapITtoIC.isEmpty() && MapITtoIC.containsKey(mem.Implementation_Tracking_ID__c) && MapITtoIC.get(mem.Implementation_Tracking_ID__c)!= null){
                if(!MapMembership.isEmpty() && MapMembership.get(MapITtoIC.get(mem.Implementation_Tracking_ID__c))!= null && MapMembership.get(MapITtoIC.get(mem.Implementation_Tracking_ID__c)).size()>0){// If greater than 0, throw error
                    mem.addError(system.label.ErrorMembership);
                }
            }
        }
        
    }
    
    public void updateMembershipOnCaseInstall(List<Enrollment_and_Billing__c> NewMembershipList){
        List<ID_Cards__c> IDcardsListToUpdate = new List<ID_Cards__c>();
        List<ID_Cards__c> idcardList = new List<ID_Cards__c>();
        for(Enrollment_and_Billing__c mem : NewMembershipList){
            /* PRDCRM-32121 : Retrieving implementation trackings Ids: Ravideep */
            MapITIdToMemId.put(mem.Implementation_Tracking_ID__c,mem.Id); 
        }
        
        system.debug('MapITIdToMemId---> ' + MapITIdToMemId);
        
        /* PRDCRM-32121 : Fetching case installation record related to implementation tracking record: Ravideep */
        if(!MapITIdToMemId.isEmpty()){
            CaseInstallationList = [select id,Name,Implementation_Tracking_ID__c,Membership__c,Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c from Issue_Control__c where Implementation_Tracking_ID__c IN: MapITIdToMemId.keyset() and Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local];
            idcardList  =[Select id,Implementation_Tracking_ID__c,Membership__c from ID_Cards__c where Implementation_Tracking_ID__c IN: MapITIdToMemId.keyset() and Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local];     
        }
        system.debug('CaseInstallationList---> ' + CaseInstallationList);
        System.debug('idcardList----->'+ idcardList);
        
        /* PRDCRM-32121 :Iterating over case install records and relating membership record to them : Ravideep */
        if(!CaseInstallationList.isEmpty()){
            for(Issue_Control__c caseins : CaseInstallationList){
                if(MapITIdToMemId.get(caseins.Implementation_Tracking_ID__c) != null ){
                    caseins.Membership__c = MapITIdToMemId.get(caseins.Implementation_Tracking_ID__c);
                    CaseInstallationListToUpdate.add(caseins);
                }
            }
           
        }

         /*Added by Rahul
            * when Membership record is created we are linking it to ID card record available with same implementation tracking ID
             */
        if(!idcardList.isEmpty()){
            for(ID_Cards__c varIDCard1 : idcardList){
                System.debug('test for map '+MapITIdToMemId.containskey(varIDCard1.Implementation_Tracking_ID__c));

                if(MapITIdToMemId.containskey(varIDCard1.Implementation_Tracking_ID__c)){
                    varIDCard1.Membership__c = MapITIdToMemId.get(varIDCard1.Implementation_Tracking_ID__c)==null?'':MapITIdToMemId.get(varIDCard1.Implementation_Tracking_ID__c);
                    System.debug('membership details++++'+varIDCard1.Membership__c);                  
                    IDcardsListToUpdate.add(varIDCard1);
                }
            }
        }
        system.debug('CaseInstallationListToUpdate---> ' + CaseInstallationListToUpdate);
        System.debug('IDcardsListToUpdate---->'+IDcardsListToUpdate);
        if(!CaseInstallationListToUpdate.isEmpty()){
            try{
                database.update(CaseInstallationListToUpdate,False);
            }
             catch(Exception ex){
                System.debug('Exception '+ex.getmessage());
            }
        }

        if(!IDcardsListToUpdate.isEmpty()){
             try{
                database.update(IDcardsListToUpdate,False);
            }
             catch(Exception ex){
                System.debug('Exception '+ex.getmessage());
            }
        }
           
    }
}