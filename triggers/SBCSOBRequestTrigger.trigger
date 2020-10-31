trigger SBCSOBRequestTrigger on SBC_SOB_Request__c (before insert,before update) {
    
    if(SBCSOBActions.sbcCheck==false){
        
        if(trigger.isInsert && trigger.isBefore){
            SBCSOBRequestTriggerHandler.onBeforeInsert(trigger.new);  
        }
        
        if(trigger.isUpdate && trigger.isBefore){
            SBCSOBRequestTriggerHandler.onBeforeUpdate(trigger.new,trigger.old,trigger.newMap,trigger.oldMap);  
        }
        
    }
    
}