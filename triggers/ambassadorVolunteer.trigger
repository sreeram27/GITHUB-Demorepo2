/**
Description : This trigger is used to check the meeting for contact
Created Date : 13/02/2019
Last Modified Date : 13/02/2019
**/

trigger ambassadorVolunteer on SFDC_Volunteer_Participant__c (before insert,before update,before delete,after insert) {
 

    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            ambassadorVolunteerHelper.contactCalMethod(trigger.new);
        }
    }
    
    if(trigger.isBefore   ){
        if(trigger.isInsert || trigger.isUpdate || Trigger.isDelete){
            OEAmbVolCountTallyFields.countTallyFields(Trigger.New, Trigger.oldMap, Trigger.isDelete,Trigger.isInsert);
        }
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {    
       VolunteerParticipantHandler handler = new VolunteerParticipantHandler();
       handler.sendEmail(Trigger.newMap);
    }
    
    
       
}