/*
@Author : Ravideep (Vikings)
@Name : MembershipTrigger
@CreatedDate :- 04/05/2019
@Description : This trigger deals with Membership object events.
*/
trigger  MembershipTrigger on Enrollment_and_Billing__c(before insert,after insert ) { 
    MembershipTriggerHandler cshandler = new MembershipTriggerHandler();
    if (trigger.isBefore){
        cshandler.showErrorBeforeInsert(trigger.new);
    }
    if(trigger.isAfter){
        cshandler.updateMembershipOnCaseInstall(trigger.new);
    }
    
}