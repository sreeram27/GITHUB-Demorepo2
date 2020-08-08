public with sharing class OpportunityTeamMemberHandler{

    public OpportunityTeamMemberHandler(){
    }
    
    public static void beforeInsert(List<OpportunityTeamMember> oppTeamMemList){
    }
    
    public static void beforeUpdate(List<OpportunityTeamMember> oppTeamMemList,Map<Id,OpportunityTeamMember> oldMap){
        OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList,oldMap,false);
    }
    
    public static void afterInsert(List<OpportunityTeamMember> oppTeamMemList,Map<Id,OpportunityTeamMember> oldMap){
    }
    
    public static void afterUpdate(List<OpportunityTeamMember> oppTeamMemList,Map<Id,OpportunityTeamMember> oldMap){
    }
    
    public static void beforeDelete(List<OpportunityTeamMember> oppTeamMemList){
        OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList,null,true);
    }
    
    public static void afterDelete(List<OpportunityTeamMember> oppTeamMemList){
    }
    
}