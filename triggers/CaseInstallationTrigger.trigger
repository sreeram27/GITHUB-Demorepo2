/*
@Author : Ravideep (Vikings)
@Name : CaseInstallationTrigger
@CreateDate :- 04/03/2019
@Description : This trigger deals with Case Installation events.
*/
trigger  CaseInstallationTrigger on Issue_Control__c (before insert,after insert,after update) { 
CaseInstallationTriggerHandler cshandler = new CaseInstallationTriggerHandler();
    if (trigger.isBefore){
    
    cshandler.showErrorBeforeInsert(trigger.new);
    }
    
    if (trigger.isafter){
    System.debug('inside trigger'+trigger.new);
    if(Trigger.isInsert){
    cshandler.assignTriggerReadyDate(trigger.New,trigger.OldMap);
   cshandler.populateCaseInstallationOnIDCard(trigger.new);
    }
    if(Trigger.isUpdate){
    cshandler.assignTriggerReadyDate(trigger.New,trigger.OldMap);
    }
    }
}