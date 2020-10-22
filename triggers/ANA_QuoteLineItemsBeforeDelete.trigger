/*@Author : Accenture Offshore Dev team
@name : ANA_QuoteLineItemsBeforeDelete
@CreateDate :20-07-2017
@Description : This trigger fires when Parent QLI's gets deleted.
*/
trigger ANA_QuoteLineItemsBeforeDelete on QuoteLineItem (before delete) {   
		
    	Quote_Line_Junction.deleteParentToChild(trigger.oldMap.keySet());
        ANA_QuoteLineItemTrigger_Handler.beforeDelete(trigger.oldMap);
}