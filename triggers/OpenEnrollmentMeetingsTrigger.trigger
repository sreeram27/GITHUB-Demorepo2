/***************************************************************
    * @Purpose:  Assign OE Coordinator
    * @Mod:      5 August 2019
    * @Author:   Mehaboob
    * @Story :   PRDCRM-37974
*****************************************************************
    *@Mod : 14th Oct 2019
    * @Comment : Modified trigger name to follow the best Trigger practices 
    * @description : Modified as part of Stroy PRDCRM-43211
*******************************************************************/

trigger OpenEnrollmentMeetingsTrigger on Open_Enrollment_Meetings__c (before insert, before update) {
  
    //PRDCRM-37974 changes
    if(Trigger.isInsert) {
        if(Trigger.isBefore) {
          OpenEnrollmentMeetingsHandler.assignOECoordinator(Trigger.new, Label.Open_Enrollment_Account);
        }
    }   
    else if(Trigger.isUpdate) {
        if(Trigger.isBefore) {
          OpenEnrollmentMeetingsHandler.assignOECoordinator(Trigger.new, Label.Open_Enrollment_Account);
        }
    }   

}