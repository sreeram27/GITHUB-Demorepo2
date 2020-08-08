trigger EmailMessageTrigger on EmailMessage (before insert,after insert, before update) {
  EmailMessageTriggerHelper emtH = new EmailMessageTriggerHelper();
    if((Trigger.isAfter && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)) {
        emTH.checkAndCopyDescription(Trigger.New);
    }
    if(Trigger.isBefore && Trigger.isInsert) {
        emTH.GetAndSaveTrimmedText(Trigger.New);
        AP_LG01_EmailMessageTriggerHandler.beforeInsertOrUpdate(Trigger.new);
    
    }
    
  
}