/*
@Author : Accenture Offshore Dev team
@name : ASMEApprovalTrigger
@CreateDate :25-04-2018
@Description : This trigger calls AP23_SMEApprovalTrigger_Handler on after update and after insert operations.
*/

trigger SMEApprovalTrigger on SME_Approvals__c (after insert,after update) {   
 
  if(trigger.Isupdate && trigger.IsAfter){
      AP23_SMEApprovalTrigger_Handler.AfterUpdate(Trigger.new,Trigger.oldMap);         
    }
    /*
    if(trigger.IsInsert && trigger.IsAfter){
       AP23_SMEApprovalTrigger_Handler.AfterInsert(Trigger.new);
       
    }
    */
}