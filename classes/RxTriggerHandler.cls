/*
@Author : Partha (Vikings)
@name : RxTriggerHandler
@CreateDate : 19/07/2019
@Description : This is handler class for RxTrigger.
ModifiedBy Sharath KN on 18-Aug-2019 to limit only one RX per Implementation Case
*/
public class RxTriggerHandler{  
    
    public Map<Id,Id> MapITIdToRxId = New Map<Id,Id>();    
    public List<RX__c> MembershipList = new List<RX__c>();    
    public List<Issue_Control__c> CaseInstallationList = new List<Issue_Control__c>();
    public List<Issue_Control__c> CaseInstallationListToUpdate = new List<Issue_Control__c>();  
    public String local = staticVariableClass.Entity;
    
    
    /* PRDCRM-38796 :  This method Update the child case install record upon creation of RX records*/ 
    public void updateRxOnCaseInstall(List<RX__c> NewRxList){
        
        for(RX__c rx : NewRxList){           
            MapITIdToRxId.put(rx.Implementation_Tracking_ID__c,rx.Id);  /* PRDCRM-38796 : Retrieving implementation trackings Ids*/
        }
        
        system.debug('MapITIdToRxId---> ' + MapITIdToRxId);
        
        /* PRDCRM-38796 : Fetching case installation record related to implementation tracking record: Partha */
        if(!MapITIdToRxId.isEmpty()){
            CaseInstallationList = [select id,Name,Implementation_Tracking_ID__c,RX__c,Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c from Issue_Control__c where Implementation_Tracking_ID__c IN: MapITIdToRxId.keyset() and Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local];
            
        }
        system.debug('CaseInstallationList---> ' + CaseInstallationList);
        
        
        /* PRDCRM-38796 :Iterating over case install records and relating Rx Records  */
        if(!CaseInstallationList.isEmpty()){
            for(Issue_Control__c caseins : CaseInstallationList){
                if(MapITIdToRxId.get(caseins.Implementation_Tracking_ID__c) != null ){
                    caseins.RX__c = MapITIdToRxId.get(caseins.Implementation_Tracking_ID__c);
                    CaseInstallationListToUpdate.add(caseins);
                }
            }
            
        }
        
        system.debug('CaseInstallationListToUpdate---> ' + CaseInstallationListToUpdate);
        
        if(!CaseInstallationListToUpdate.isEmpty()){
            try{
                database.update(CaseInstallationListToUpdate,False);
            }
            catch(Exception ex){
                System.debug('Exception '+ex.getmessage());
            }
        }
        
    }
    
    Public void limitRXRecords(List<RX__c> RXList){
        Set<Id> implTrackIdS = new Set<Id>();
        Set<Id> implTrackIdSFinal = new Set<Id>();
        for(RX__c thisRX : RXList){
            implTrackIdS.add(thisRX.Implementation_Tracking_ID__c);
        }
        for(RX__c thisRX : [SELECT Id,Implementation_Tracking_ID__c FROM RX__c where Implementation_Tracking_ID__c in: implTrackIdS]){
            implTrackIdSFinal.add(thisRX.Implementation_Tracking_ID__c);
        }
        for(RX__c thisRX : RXList){
            if(implTrackIdSFinal.contains(thisRX.Implementation_Tracking_ID__c)){
                thisRX.addError(System.label.ErrorRX);
            }
        }
    }
}