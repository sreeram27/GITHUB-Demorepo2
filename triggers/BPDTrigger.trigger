trigger BPDTrigger on BPD__c (before insert, before update) {
 
  if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
       AP28_BPD_Handler.BeforeInsertOrUpdate(Trigger.New);
  }

}