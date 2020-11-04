/*
@Author : Accenture Offshore Dev team
@name : ANA_ProductSelectionDetailAfterDelete 
@CreateDate :20-06-2017
@Description : This trigger fires when a Product Selection detail gets created and updates the count for Parent Quote Line Item.
*/

trigger ANA_ProductSelectionDetailAfterDelete on ProductSelectionDetail__c (after delete) {
ANA_ProductSelectionTrigger_Handler.afterDelete(trigger.oldMap);
}