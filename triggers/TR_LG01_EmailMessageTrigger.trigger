trigger TR_LG01_EmailMessageTrigger on EmailMessage (before insert) {
    
    if(Trigger.isInsert && Trigger.isBefore){
        AP_LG01_EmailMessageTrigger_Handler.beforeInsertOrUpdate(Trigger.new);
    }
	
}