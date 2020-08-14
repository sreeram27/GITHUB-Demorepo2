/*
@Author : Accenture Offshore Dev team
@name : ANA_ProductSelectionDetailAfterUpdate 
@CreateDate :20-06-2017
@Description : This trigger fires when a Product Selection detail gets created and updates the count for Parent Quote Line Item.
*/

trigger ANA_ProductSelectionDetailAfterUpdate on ProductSelectionDetail__c (after update) {
ANA_ProductSelectionTrigger_Handler.afterUpdate(trigger.newMap,trigger.oldMap);
}