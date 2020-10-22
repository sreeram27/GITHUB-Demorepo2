/*
@Author : Accenture Offshore Dev team
@name : AP23_SMEApprovalTrigger_Handler
@CreateDate :25-04-2018
@Description : This class calls AP21_SMENotifyApproverEMail to send the notifications on differnt scenarios.
*/
public with sharing class AP23_SMEApprovalTrigger_Handler{  

 public static void AfterUpdate(List<SME_Approvals__c> newList,Map<Id,SME_Approvals__c> oldMap){ 
 
   if(AP21_SMENotifyApproverEMail.firstRun){  
         AP21_SMENotifyApproverEMail.mailBuildermethod(newList,oldMap);
         AP21_SMENotifyApproverEMail.sendStatusChangemail(newList,oldMap);
         AP21_SMENotifyApproverEMail.createApprovalRecordsOnUpdate(newList,oldMap);
         AP21_SMENotifyApproverEMail.firstRun = false;   
        } 
  }
  /*
  public static void AfterInsert(List<SME_Approvals__c> newList){  
      AP21_SMENotifyApproverEMail.createApprovalRecordsOnInsert(trigger.new); 
  }
  */
}