/**************************************************************************************
Apex Class Name:  OEAmbassadorVolunteerTrigger
Version     : 1.0
Description : This trigger is used to check the meeting for contact
Created Date : 13 Feb 2019
*************************************************************************************/

/**************************************************************************************
Mod                : 30 Sep 2019
@Author            : Poonam Goturi(Xmen)
@description       : Updated Trigger name to OEAmbassadorVolunteerTrigger, Splitted Trigger actions for OEAmbassadorVolunteerTriggerHandler
*************************************************************************************

Mod                : 28 Jan 2020
@Author            : Poonam Goturi(Xmen)
@description       :Commented isbefore and isInsert call
*************************************************************************************/

trigger OEAmbassadorVolunteerTrigger on SFDC_Volunteer_Participant__c (before insert,before update,before delete,after insert) {
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            ambassadorVolunteerHelper.contactCalMethod(trigger.new);
        }
    } 
    /*
    if(trigger.isBefore && trigger.isInsert){
        OEAmbassadorVolunteerTriggerHandler.onBeforeInsert(Trigger.New, Trigger.oldMap, Trigger.isDelete,Trigger.isInsert);
    }*/
    
    if(trigger.isBefore && trigger.isUpdate){
        OEAmbassadorVolunteerTriggerHandler.onBeforeUpdate(Trigger.New, Trigger.oldMap, Trigger.isDelete,Trigger.isInsert);
    }
    
    if(trigger.isBefore && trigger.isDelete){
        OEAmbassadorVolunteerTriggerHandler.onBeforeDelete(Trigger.New, Trigger.oldMap, Trigger.isDelete,Trigger.isInsert);
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {    
       VolunteerParticipantHandler handler = new VolunteerParticipantHandler();
       handler.sendEmail(Trigger.newMap);
    }
}