/*
@Author :  Accenture Offshore Dev team
@name : ANA_QuoteLineItemsAfterCreate 
@CreateDate : 29-05-2017
@Description : This trigger fires when a child Quote Line Items gets created and updates the count for Parent Quote Line Item.
*/
trigger ANA_QuoteLineItemsAfterCreate on QuoteLineItem (after insert,before insert) {
    //Edited as part of ICR Issue
     if(trigger.isBefore && trigger.isInsert){
            NewBusiness_QuoteLineItem.updateQuote(trigger.new);
            QuoteLineItemsUtility.lgUpdateProbability(Trigger.New,null);
     }else if(trigger.isAfter && trigger.isInsert){
            ANA_QuoteLineItemTrigger_Handler.afterCreate(trigger.newMap);
            LGHWQuoteLineItemActions.createHWPackagePrograms (trigger.new);
            QuoteLineItemsUtility.castlightIndicatorInsert(Trigger.New,null);
            QuoteLineItemsUtility.lHOLUpdateQuoteonAfterCreate(Trigger.New);
            QuoteLineItemsUtility.anaQLI01UpdateChildQLIsOnAfterCreate(Trigger.New);
     }
}