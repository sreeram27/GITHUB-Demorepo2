trigger ContactRelationshipTrigger on ContactRelationship__c (before insert,before update,after insert,after update,before delete,after delete){
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ContactRelationshipHandler.beforeInsert(Trigger.New);
        }
        if(Trigger.isUpdate){
            ContactRelationshipHandler.beforeUpdate(Trigger.New,Trigger.oldMap);
        }      
    }
       
}