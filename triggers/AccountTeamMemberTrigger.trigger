trigger AccountTeamMemberTrigger on AccountTeamMember (after delete, after update) {
	
    if(Trigger.isAfter && Trigger.isDelete){
        AccTeamMemberTriggerHandler.clearDeleteTeamMembersOnAccount(Trigger.old);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        AccTeamMemberTriggerHandler.updateTeamMembersOnAccount(Trigger.oldMap, Trigger.newMap);
    }
}