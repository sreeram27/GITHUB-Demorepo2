/*
@author         Accenture offshore
@Request        961
@date           29/06/2017
@name           ANA_QuoteLineItemApprovalBeforeUpdate
@description    This trigger has the logic to pull latest Approval Comment from Approval History and 
					populate "Approval Comments" field on Quote Line Item Approval.
*/
trigger ANA_QuoteLineItemApprovalBeforeUpdate on QuoteLineItemApproval__c (before update) {
    ANA_QuoteLineItemApprovalTrigger_Handler.updateApprovalComments(Trigger.new, Trigger.oldMap);
    
}