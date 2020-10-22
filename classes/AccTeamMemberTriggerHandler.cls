public class AccTeamMemberTriggerHandler {
	
	public static void clearDeleteTeamMembersOnAccount(List<AccountTeamMember> teamMembers){
		Map<Id,List<AccountTeamMember>> accountIdToTeams = new Map<Id,List<AccountTeamMember>>();
		
		for(AccountTeamMember teamMember : teamMembers){
			if(accountIdToTeams.containsKey(teamMember.AccountId)){
				accountIdToTeams.get(teamMember.AccountId).add(teamMember);
			} else{
				accountIdToTeams.put(teamMember.AccountId, new List<AccountTeamMember>{teamMember});
			}
		}
		
		Map<Id,Account> tempAccMap = getRelatedAccounts(accountIdToTeams.keySet());
		
		List<Account> accountsToUpdate = new List<Account>();
		for(Id accountId : accountIdToTeams.keySet()){
			Account acc = tempAccMap.get(accountId);
			List<AccountTeamMember> accountTeam = accountIdToTeams.get(accountId);
			accountsToUpdate.add(clearMemberOnAccount(acc,accountTeam));
		}
		
		if(!accountsToUpdate.isEmpty()){
			update accountsToUpdate;
		}
	
	}
    
    public static void updateTeamMembersOnAccount(Map<Id,AccountTeamMember> oldTeamRecords, Map<Id,AccountTeamMember> updatedTeamRecords){
        Map<Id,Set<Id>> accountIdToTeamMemId = new Map<Id,Set<Id>>();
        Set<Id> userIds = new Set<Id>();
        
        for(AccountTeamMember teamMember : updatedTeamRecords.values()){
            
            userIds.add(teamMember.UserId);
            
            if(accountIdToTeamMemId.containsKey(teamMember.AccountId)){
                accountIdToTeamMemId.get(teamMember.AccountId).add(teamMember.Id);
            } else{
                accountIdToTeamMemId.put(teamMember.AccountId,new Set<Id>{teamMember.Id});
            }
        }
        
        Map<Id,User> users = new Map<Id,User>([SELECT Id, Name, IsActive FROM USER WHERE Id in :userIds]);
        
        Map<Id,Account> tempAccMap = getRelatedAccounts(accountIdToTeamMemId.keySet());
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Id accountId : accountIdToTeamMemId.keySet()){
            Set<Id> teamIds = accountIdToTeamMemId.get(accountId);
            Account acc = tempAccMap.get(accountId);
            
            for(Id teamId : teamIds){
                AccountTeamMember oldRecord = oldTeamRecords.get(teamId);
                AccountTeamMember updateRecord = updatedTeamRecords.get(teamId);
                
                if(oldRecord.TeamMemberRole != updateRecord.TeamMemberRole){
                    User teamUser = users.get(updateRecord.UserId);   
                    clearMember(acc,oldRecord.TeamMemberRole);
                                        
                    if(teamUser.isActive){
                    	updateMember(acc,updateRecord.TeamMemberRole,updateRecord.UserId,teamUser.Name);
                    }
                }
            }
            
            accountsToUpdate.add(acc);
        }
        
        update accountsToUpdate;
    }
    
    private static Map<Id,Account> getRelatedAccounts(Set<Id> accountIds){
        Set<String> accRcdTyps = new Set<String>{Label.Customer, Label.Prospect, Label.LG_Customer, Label.LG_Prospect}; 
		
		Map<Id,Account> tempAccMap = new Map<Id,Account>([SELECT Id, 
                                                              Account_Executive__c, 
                                                              Account_Manager__c, 
                                                              AccountSpecialtySalesExecutive__c, 
                                                              ANASpecialtyAME__c, 
                                                              ANASpecialtySD__c, 
                                                              ClinicalRPh__c, 
                                                              DirectorSalesAccountManagement__c, 
                                                              Implementor__c, 
                                                              PharmacyServiceCoordinator__c, 
                                                              RVPUnderwriting__c, 
                                                              RxAccountManagementDirector__c,
                                                              RxAccountManager__c, 
                                                              RxSalesDirector__c, 
                                                              SalesExecutive__c, 
                                                              SalesAMAdmin__c, 
                                                              SRSalesConsultant__c, 
                                                              Underwriter__c, 
                                                              VP__c, 
                                                              EBA__c, 
                                                              Implementation_Manager__c, 
                                                              Account_Service_Coordinator__c, 
                                                              Account_service_representative__c, 
                                                              Specialty_Sales_Account_Manager__c, 
                                                              Specialty_Clinical_Account_Director__c,
                                                              AE_Support_Rep__c,
                                                              AM_Support_Rep__c,
                                                              Sales_Account_Representative__c,
                                                              SARAcctMgmt__c,
                                                              Client_Engagement_Consultant_SAR1__c,                                                               
                                                              Hws_Implementer__c, 
                                                              Chief_Client_Officer__c, 
                                                              Group_Service_Analyst__c, 
                                                              Chief_Growth_Officer__c,
                                                              Regional_Manager__c,
                                                              Strategic_Client_Advisor__c,
                                                              GRS_ESR__c,
                                                              GRS_Account_Executive__c,
                                                              Voluntary_Enrollment_Consultant__c
                                                              FROM Account WHERE Id IN: accountIds AND RecordType.DeveloperName IN:accRcdTyps]);
        return tempAccMap;
    }

	private static Account clearMemberOnAccount(Account acc, List<AccountTeamMember> accountTeam){
		
		for(AccountTeamMember teamMember : accountTeam){
			String roleName = teamMember.TeamMemberRole;
			clearMember(acc,roleName);			
		}
        
        return acc;
	}
    
    private static void clearMember(Account acc, String roleName){
 		if (roleName.equalsIgnoreCase('Account Executive')) {
          acc.Account_Executive__c = null;
        } else if (roleName.equalsIgnoreCase('Account Manager')) {
          acc.Account_Manager__c = null;
        } else if (roleName.equalsIgnoreCase('Specialty Sales Executive')) {
          acc.AccountSpecialtySalesExecutive__c = null;
        } else if (roleName.equalsIgnoreCase('ANA Specialty AME')) {
          acc.ANASpecialtyAME__c = null;
        } else if (roleName.equalsIgnoreCase('ANA Specialty SD')) {
          acc.ANASpecialtySD__c = null;
        } else if (roleName.equalsIgnoreCase('Clinical RPh')) {
          acc.ClinicalRPh__c = null;
        } else if (roleName.equalsIgnoreCase('Director Sales/AM')) {
          acc.DirectorSalesAccountManagement__c = null;
        } else if (roleName.equalsIgnoreCase('Implementer')) {
          acc.Implementor__c = null;
        } else if (roleName.equalsIgnoreCase('Pharmacy Service Coordinator')) {
          acc.PharmacyServiceCoordinator__c = null;
        } else if (roleName.equalsIgnoreCase('RVP Underwriting')) {
          acc.RVPUnderwriting__c = null;
        } else if (roleName.equalsIgnoreCase('Rx Account Management Director')) {
          acc.RxAccountManagementDirector__c = null;
        } else if (roleName.equalsIgnoreCase('Rx Account Manager')) {
          acc.RxAccountManager__c = null;
        } else if (roleName.equalsIgnoreCase('Rx Sales Director')) {
          acc.RxSalesDirector__c = null;
        } else if (roleName.equalsIgnoreCase('Sales Executive')) {
          acc.SalesExecutive__c = null;
        } else if (roleName.equalsIgnoreCase('Admin Sales/AM')) {
          acc.SalesAMAdmin__c = null;
        } else if (roleName.equalsIgnoreCase('SR Sales Consultant')) {
          acc.SRSalesConsultant__c = null;
        } else if (roleName.equalsIgnoreCase('Underwriter')) {
          acc.Underwriter__c = null;
        } else if (roleName.equalsIgnoreCase('VP')) {
          acc.VP__c = null;
        } else if (roleName.equalsIgnoreCase('EBA')) {
          acc.EBA__c = null;
        } else if (roleName.equalsIgnoreCase('Implementation Manager')) {
          acc.Implementation_Manager__c = null;
        } else if (roleName.equalsIgnoreCase('Account Service Coordinator')) {
          acc.Account_Service_Coordinator__c = null;
        } else if (roleName.equalsIgnoreCase('Account Service Representative')) {
          acc.Account_service_representative__c = null;
        } else if (roleName.equalsIgnoreCase('Specialty Sales Account Manager')) {
          acc.Specialty_Sales_Account_Manager__c = '';
        } else if (roleName.equalsIgnoreCase(Label.Specialty_Clinical_Account_Director)) {
          acc.Specialty_Clinical_Account_Director__c = null;
        } else if (roleName.equalsIgnoreCase('AE Support Rep')) {
          acc.AE_Support_Rep__c = '';
        } else if (roleName.equalsIgnoreCase('AM Support Rep')) {
          acc.AM_Support_Rep__c = '';
        } else if (roleName.equalsIgnoreCase('Sales Account Representative')) {
          acc.Sales_Account_Representative__c = '';
        } else if (roleName.equalsIgnoreCase('Sales Account Rep - Acct Mgmt')) {
          acc.SARAcctMgmt__c = null;
        } else if (roleName.equalsIgnoreCase('Client Engagement Consultant/SAR')) {
          acc.Client_Engagement_Consultant_SAR1__c = null;
        } else if (roleName.equalsIgnoreCase('Hws Implementer')) {
          acc.Hws_Implementer__c = null;
        } else if (roleName.equalsIgnoreCase('Chief Client Officer')) {
          acc.Chief_Client_Officer__c = null;
        } else if (roleName.equalsIgnoreCase('Chief Growth Officer')) {
          acc.Chief_Growth_Officer__c = null;
        } else if (roleName.equalsIgnoreCase('Group Service Analyst')) {
          acc.Group_Service_Analyst__c = null;
        } else if (roleName.equalsIgnoreCase('Regional Manager')) {
          acc.Regional_Manager__c = '';
        } else if (roleName.equalsIgnoreCase('Strategic Client Advisor')) {
          acc.Strategic_Client_Advisor__c = '';
        } else if (roleName.equalsIgnoreCase(staticVariableClass.TEAM_ROLE_GRS_ACCOUNT_EXECUTIVE)) {
          acc.GRS_Account_Executive__c = '';
        } else if (roleName.equalsIgnoreCase(staticVariableClass.TEAM_ROLE_GRS_ESR)) {
          acc.GRS_ESR__c = '';
        } else if (roleName.equalsIgnoreCase(staticVariableClass.TEAM_ROLE_VOLUNTARY_ENROLLMENT)) {
          acc.Voluntary_Enrollment_Consultant__c = '';
        }		
    }
    
    private static void updateMember(Account acc, String roleName, String userId, String userName){
 		if (roleName.equalsIgnoreCase('Account Executive')) {
          acc.Account_Executive__c = userId;
        } else if (roleName.equalsIgnoreCase('Account Manager')) {
          acc.Account_Manager__c = userId;
        } else if (roleName.equalsIgnoreCase('Specialty Sales Executive')) {
          acc.AccountSpecialtySalesExecutive__c = userId;
        } else if (roleName.equalsIgnoreCase('ANA Specialty AME')) {
          acc.ANASpecialtyAME__c = userId;
        } else if (roleName.equalsIgnoreCase('ANA Specialty SD')) {
          acc.ANASpecialtySD__c = userId;
        } else if (roleName.equalsIgnoreCase('Clinical RPh')) {
          acc.ClinicalRPh__c = userId;
        } else if (roleName.equalsIgnoreCase('Director Sales/AM')) {
          acc.DirectorSalesAccountManagement__c = userId;
        } else if (roleName.equalsIgnoreCase('Implementer')) {
          acc.Implementor__c = userId;
        } else if (roleName.equalsIgnoreCase('Pharmacy Service Coordinator')) {
          acc.PharmacyServiceCoordinator__c = userId;
        } else if (roleName.equalsIgnoreCase('RVP Underwriting')) {
          acc.RVPUnderwriting__c = userId;
        } else if (roleName.equalsIgnoreCase('Rx Account Management Director')) {
          acc.RxAccountManagementDirector__c = userId;
        } else if (roleName.equalsIgnoreCase('Rx Account Manager')) {
          acc.RxAccountManager__c = userId;
        } else if (roleName.equalsIgnoreCase('Rx Sales Director')) {
          acc.RxSalesDirector__c = userId;
        } else if (roleName.equalsIgnoreCase('Sales Executive')) {
          acc.SalesExecutive__c = userId;
        } else if (roleName.equalsIgnoreCase('Admin Sales/AM')) {
          acc.SalesAMAdmin__c = userId;
        } else if (roleName.equalsIgnoreCase('SR Sales Consultant')) {
          acc.SRSalesConsultant__c = userId;
        } else if (roleName.equalsIgnoreCase('Underwriter')) {
          acc.Underwriter__c = userId;
        } else if (roleName.equalsIgnoreCase('VP')) {
          acc.VP__c = userId;
        } else if (roleName.equalsIgnoreCase('EBA')) {
          acc.EBA__c = userId;
        } else if (roleName.equalsIgnoreCase('Implementation Manager')) {
          acc.Implementation_Manager__c = userId;
        } else if (roleName.equalsIgnoreCase('Account Service Coordinator')) {
          acc.Account_Service_Coordinator__c = userId;
        } else if (roleName.equalsIgnoreCase('Account Service Representative')) {
          acc.Account_service_representative__c = userId;
        } else if (roleName.equalsIgnoreCase('Specialty Sales Account Manager')) {
          acc.Specialty_Sales_Account_Manager__c = userName;
        } else if (roleName.equalsIgnoreCase(Label.Specialty_Clinical_Account_Director)) {
          acc.Specialty_Clinical_Account_Director__c = userId;
        } else if (roleName.equalsIgnoreCase('AE Support Rep')) {
          acc.AE_Support_Rep__c = userName;
        } else if (roleName.equalsIgnoreCase('AM Support Rep')) {
          acc.AM_Support_Rep__c = userName;
        } else if (roleName.equalsIgnoreCase('Sales Account Representative')) {
          acc.Sales_Account_Representative__c = userName;
        } else if (roleName.equalsIgnoreCase('Sales Account Rep - Acct Mgmt')) {
          acc.SARAcctMgmt__c = userId;
        } else if (roleName.equalsIgnoreCase('Client Engagement Consultant/SAR')) {
          acc.Client_Engagement_Consultant_SAR1__c = userId;
        } else if (roleName.equalsIgnoreCase('Hws Implementer')) {
          acc.Hws_Implementer__c = userId;
        } else if (roleName.equalsIgnoreCase('Chief Client Officer')) {
          acc.Chief_Client_Officer__c = userId;
        } else if (roleName.equalsIgnoreCase('Chief Growth Officer')) {
          acc.Chief_Growth_Officer__c = userId;
        } else if (roleName.equalsIgnoreCase('Group Service Analyst')) {
          acc.Group_Service_Analyst__c = userId;
        } else if (roleName.equalsIgnoreCase('Regional Manager')) {
          acc.Regional_Manager__c = userName;
        } else if (roleName.equalsIgnoreCase('Strategic Client Advisor')) {
          acc.Strategic_Client_Advisor__c = userName;
        } else if (roleName.equalsIgnoreCase(staticVariableClass.TEAM_ROLE_GRS_ACCOUNT_EXECUTIVE)) {
          acc.GRS_Account_Executive__c = userName;
        } else if (roleName.equalsIgnoreCase(staticVariableClass.TEAM_ROLE_GRS_ESR)) {
          acc.GRS_ESR__c = userName;
        } else if (roleName.equalsIgnoreCase(staticVariableClass.TEAM_ROLE_VOLUNTARY_ENROLLMENT)) {
          acc.Voluntary_Enrollment_Consultant__c = userName;
        }
    }
}