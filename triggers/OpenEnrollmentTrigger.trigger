trigger OpenEnrollmentTrigger on SFDC_Volunteer_Event__c (before insert, before update, after insert, after update){
    
    OpenEnrollmentTriggerHelper handler = new OpenEnrollmentTriggerHelper(trigger.new, trigger.oldMap);
    
    if (trigger.isBefore){
        if (trigger.isInsert) handler.beforeInsert();
        if (trigger.isUpdate) handler.beforeUpdate();
    }
    
    if (trigger.isAfter){
        if (trigger.isInsert) handler.afterInsert();
        if (trigger.isUpdate) handler.afterUpdate();
    }
}