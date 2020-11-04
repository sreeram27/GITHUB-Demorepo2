trigger CaseTrigger on Case (before Insert, before Update) {
    system.debug('trigger.newMap '+trigger.newMap);
    CaseTriggerHelper csHelper = new CaseTriggerHelper();
    if(trigger.isBefore && (trigger.IsInsert || trigger.isUpdate)){
        csHelper.updateMailBox(trigger.new);
        csHelper.removeAccountContact(trigger.new,trigger.newMap);
    }
}