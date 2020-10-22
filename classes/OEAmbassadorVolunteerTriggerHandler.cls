/**************************************************************************************
Apex Class Name:  OEAmbassadorVolunteerTriggerHandler
Version     : 1.0 
Created Date    : 27 September 2019
* @Author       : Poonam Goturi (X-men)
* @description  : Created class as part of PRDCRM-43210
*************************************************************************************/

public with sharing class OEAmbassadorVolunteerTriggerHandler{
    //Method to call OEAmbassadorVolunteerActions before insert
    public static void onBeforeInsert(List<SFDC_Volunteer_Participant__c> newOAVList,Map<Id, SFDC_Volunteer_Participant__c> oldOAVMap, Boolean isDelete,Boolean isInsert){
        OEAmbassadorVolunteerActions.countTallyFields(newOAVList,oldOAVMap,isDelete,isInsert);
    }
    
    //Method to call OEAmbassadorVolunteerActions before update
    public static void onBeforeUpdate(List<SFDC_Volunteer_Participant__c> newOAVList,Map<Id, SFDC_Volunteer_Participant__c> oldOAVMap, Boolean isDelete,Boolean isInsert){
        OEAmbassadorVolunteerActions.countTallyFields(newOAVList,oldOAVMap,isDelete,isInsert);
    }
    
    //Method to call OEAmbassadorVolunteerActions before delete
    public static void onBeforeDelete(List<SFDC_Volunteer_Participant__c> newOAVList,Map<Id, SFDC_Volunteer_Participant__c> oldOAVMap, Boolean isDelete,Boolean isInsert){
        OEAmbassadorVolunteerActions.countTallyFields(newOAVList,oldOAVMap,isDelete,isInsert);
    }
}