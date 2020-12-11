/*
@Author : Accenture Offshore Dev team
@name : ANA_QuoteLineItemsAfterUpdate 
@CreateDate :30-05-2017
@Description : This trigger fires when QLI gets updated.
*/
trigger ANA_QuoteLineItemsAfterUpdate on QuoteLineItem (after update, before update) {   
    //Edited as part of ICR Issue
    if(trigger.isBefore && trigger.isUpdate){
        NewBusiness_QuoteLineItem.updateQuote(trigger.new);
        QuoteLineItemsUtility.lgUpdateProbability(Trigger.new, Trigger.oldMap);
        QuoteLineItemsUtility.anaQLI01UpdateChildQLIs(Trigger.newMap, Trigger.oldMap);
    }else if(trigger.isAfter && trigger.isUpdate){
        if(checkRecursive_trgrecursive.runOnce()){
            ANA_QuoteLineItemTrigger_Handler.afterUpdate(trigger.newMap,trigger.oldMap);
        }
        QuoteLineItemsUtility.lHOLUpdateQuote(Trigger.newMap, Trigger.oldMap);
        QuoteLineItemsUtility.castlightIndicatorInsert(Trigger.new, Trigger.oldMap);
    }   
}