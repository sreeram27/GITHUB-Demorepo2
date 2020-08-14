/*
@Author : Accenture Offshore Dev team
@name : ANA_ProductSelectionDetailAfterCreate 
@CreateDate :20-06-2017
@Description : This trigger fires when a Product Selection detail gets created and updates the count for Parent Quote Line Item.
*/

trigger ANA_ProductSelectionDetailAfterCreate on ProductSelectionDetail__c (after insert) {
ANA_ProductSelectionTrigger_Handler.afterCreate(trigger.newMap);
}