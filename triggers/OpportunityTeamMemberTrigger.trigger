trigger OpportunityTeamMemberTrigger on OpportunityTeamMember (before insert,before update,after insert,after update,before delete,after delete){
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            OpportunityTeamMemberHandler.beforeInsert(Trigger.New);
        }
        if(Trigger.isUpdate){
            OpportunityTeamMemberHandler.beforeUpdate(Trigger.New,Trigger.oldMap);
        }
        if(Trigger.isDelete){
            OpportunityTeamMemberHandler.beforeDelete(Trigger.old);
        }
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            OpportunityTeamMemberHandler.afterInsert(Trigger.New,Trigger.oldMap);
        }
        if(Trigger.isUpdate){
            OpportunityTeamMemberHandler.afterUpdate(Trigger.New,Trigger.oldMap);
        }
        if(Trigger.isDelete){
            OpportunityTeamMemberHandler.afterDelete(Trigger.old);
        }
    }
}