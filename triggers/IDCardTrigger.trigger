/*
@Author : Rahul Ramadolla(Vikings)
@name : IDCardTrigger
@CreateDate :4thSept2019
@Description : ID card trigger on before update Jira ID: 39701 .
@Modifiedby : 
*/
trigger IDCardTrigger on ID_Cards__c (before insert) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            IDCardTriggerHandler.onBeforeInsert(Trigger.new);
        }
     }
}