/*
@Author : Accenture Offshore Dev team
@name : ANA_QuoteLineItemsAfterDelete
@CreateDate :31-05-2017
@Description : This trigger fires when QLI gets deleted.
*/
trigger ANA_QuoteLineItemsAfterDelete on QuoteLineItem (after delete) {   

    Quote_Line_Junction.deleteParentToChild(trigger.oldMap.keySet());    
    ANA_QuoteLineItemTrigger_Handler.afterDelete(trigger.oldMap);
    	
}