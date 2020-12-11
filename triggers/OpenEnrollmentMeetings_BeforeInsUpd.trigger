/***************************************************************
    * Purpose:  Assign OE Coordinator
    * Mod:      5 August 2019
    * Author:   Mehaboob
    * Story :   PRDCRM-37974
    ***************************************************************/

trigger OpenEnrollmentMeetings_BeforeInsUpd on Open_Enrollment_Meetings__c (before insert, before update) {
   
   //PRDCRM-37974 changes
   if (trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
          OpenEnrollmentMeetingsHandler.assignOECoordinator(Trigger.new, Label.Open_Enrollment_Account);
         }
    } 

}