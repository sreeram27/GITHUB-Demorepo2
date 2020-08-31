/*
@Author : Accenture Offshore Dev team
@name : ANA_BrokerConCommissionsBeforeInsert
@CreateDate :27-09-2017
@Description : This trigger fires when Brokerage consultant commission record gets created.
*/
trigger  ANA_BrokerConCommissionsBeforeInsert on Broker_Consultant_Commissions__c (before insert) { 
    ANA_BCCommnissionTrigger_Handler.afterCreate(trigger.new);
    
}