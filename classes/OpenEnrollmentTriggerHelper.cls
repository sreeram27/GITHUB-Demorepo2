/*************************************************************************************
Version     : 1.0 
@Author: Rahmath
Function    : Trigger Helper for Open enrollment object
@description :Trigger Helper for Open enrollment object
*************************************************************************************/
public with Sharing class OpenEnrollmentTriggerHelper {
    public static boolean bypassTrigger = false;
    public static boolean hasTriggerRun = false;
    
    public List<SFDC_Volunteer_Event__c> newRecords;
    public Map<Id, SFDC_Volunteer_Event__c> oldMap;
    /*
    * @description OpenEnrollmentTriggerHelper constructor
    * @param newRecords
    * @param oldMap
    */ 
    public OpenEnrollmentTriggerHelper(List<SFDC_Volunteer_Event__c> newRecords, Map<Id, SFDC_Volunteer_Event__c> oldMap){
        this.newRecords = newRecords;
        this.oldMap = oldMap;
    }
    /*
    * @description beforeInsert method
    * 
    */
    public void beforeInsert(){
        if(bypassTrigger) {return;}
        //OpenEnrollmentTriggerHandler.updateCoordinator(newRecords);
        
        /*if(OpenEnrollmentTriggerHandler.checkUpdateCount(newRecords)) {
//should only check for address/location fields
for(SFDC_Volunteer_Event__c newRecord : newRecords) {
//newRecord.addError(System.Label.OpenEnrollmentCountLimitExceeded);
}
}*/
        
    }
    /**
    * @description afterInsert method
    * 
    */
    public void afterInsert(){
        if(!hasTriggerRun){
            OpenEnrollmentTriggerHandler.updateChangedAddresses(newRecords);
            hasTriggerRun = true;
        }
        
    }
    /*
    * @description beforeUpdate method
    * 
    */
    public void beforeUpdate(){
        if(bypassTrigger) {return;}
        //Update the History Comments
        OpenEnrollmentTriggerHandler.updateMeetingCommHistory(newRecords,oldMap);	   		
        //OpenEnrollmentTriggerHandler.updateCoordinator(newRecords);
        /*if(OpenEnrollmentTriggerHandler.checkUpdateCount(newRecords)) {
//should only check for address/location fields
for(SFDC_Volunteer_Event__c newRecord : newRecords) {
//newRecord.addError(System.Label.OpenEnrollmentCountLimitExceeded);
}
}*/
    }
    /*
    * @description afterUpdate method
    * 
    */
    public void afterUpdate(){
        List<SFDC_Volunteer_Event__c> modifiedMeetings = OpenEnrollmentTriggerHandler.verifyLocation(newRecords, oldMap);
        
        if(!hasTriggerRun){
            if(System.isFuture() == false){
                if(modifiedMeetings.size() > 0) {
                    OpenEnrollmentTriggerHandler.updateChangedAddresses(newRecords);
                    hasTriggerRun = true;
                }
            }
        }
        
    }
}