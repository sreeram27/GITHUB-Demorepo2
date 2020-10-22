/*
@Author : Partha (Vikings)
@Name : RxTrigger
@CreatedDate :- 19/07/2019
@Description : PRDCRM-38796 :: This trigger deals with Rx object events.
ModifiedBy Sharath KN on 18-Aug-2019 to limit only one RX per Implementation Case
*/
trigger  RxTrigger on Rx__c(before insert,after insert ) { 
    RxTriggerHandler cshandler = new RxTriggerHandler();

    if(trigger.isAfter){
        cshandler.updateRxOnCaseInstall(trigger.new);
    }
    if(trigger.isBefore && trigger.isInsert){
        cshandler.limitRXRecords(Trigger.New);
    }
    
}