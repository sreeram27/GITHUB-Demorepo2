/*
@Author : Accenture Offshore Dev team
@name : ANA_OpportunityBeforeUpdate
@CreateDate :25-05-2017
@Description : This trigger fires when Opportunity gets updated.
*/
trigger ANA_OpportunityBeforeUpdate on Opportunity (before update) {   
    /* This method checks whether Opportunity stageName changed or not. */
    if (!Trigger.isExecuting || Test.isRunningTest()) {
        ANA_OpportunityTrigger_Handler.beforeUpdate(trigger.new,trigger.oldMap);
    }    
}