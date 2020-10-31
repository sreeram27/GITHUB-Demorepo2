/**************************************************************************************
Apex Class Name:  AccTeamMemberTriggerHandlerTest
Version     : 1.0 
Created Date : 3 january 2020
*@Author: Neha Prasad
Function : AccTeamMemberTriggerHandler Test Class 
*************************************************************************************/


@isTest
private class AccTeamMemberTriggerHandlerTest {
    
    @TestSetup
    public static void testDataSetup(){
        List<Account> testAccounts = TestDataFactory.createAccountSICList(1,'Test Accounts','Test Street','Test City','Test State','10000','Test Country', 'TEST001');
        Insert testAccounts;
        
        List<User> testUsers = TestDataFactory.createUserData(28,'System Administrator','');
        Insert testUsers;
        
        System.runAs(testUsers[0]){
            List<AccountTeamMember> teamMemberList = new List<AccountTeamMember>();      
        
            AccountTeamMember teamMember = new AccountTeamMember();
            teamMember.AccountId = testAccounts[0].Id;
            teamMember.TeamMemberRole = 'Account Executive';
            teamMember.UserId = testUsers[0].Id;
            
            AccountTeamMember teamMember1 = new AccountTeamMember();
            teamMember1.AccountId = testAccounts[0].Id;
            teamMember1.TeamMemberRole = 'Account Manager';
            teamMember1.UserId = testUsers[1].Id;
            
            AccountTeamMember teamMember2 = new AccountTeamMember();
            teamMember2.AccountId = testAccounts[0].Id;
            teamMember2.TeamMemberRole = 'Specialty Sales Executive';
            teamMember2.UserId = testUsers[2].Id;
            
            AccountTeamMember teamMember3 = new AccountTeamMember();
            teamMember3.AccountId = testAccounts[0].Id;
            teamMember3.TeamMemberRole = 'ANA Specialty AME';
            teamMember3.UserId = testUsers[3].Id;
            
            AccountTeamMember teamMember4 = new AccountTeamMember();
            teamMember4.AccountId = testAccounts[0].Id;
            teamMember4.TeamMemberRole = 'ANA Specialty SD';
            teamMember4.UserId = testUsers[4].Id;
            
            AccountTeamMember teamMember5 = new AccountTeamMember();
            teamMember5.AccountId = testAccounts[0].Id;
            teamMember5.TeamMemberRole = 'Clinical RPh';
            teamMember5.UserId = testUsers[5].Id;
            
            AccountTeamMember teamMember6 = new AccountTeamMember();
            teamMember6.AccountId = testAccounts[0].Id;
            teamMember6.TeamMemberRole = 'Director Sales/AM';
            teamMember6.UserId = testUsers[6].Id;
            
            AccountTeamMember teamMember7 = new AccountTeamMember();
            teamMember7.AccountId = testAccounts[0].Id;
            teamMember7.TeamMemberRole = 'Implementer';
            teamMember7.UserId = testUsers[7].Id;
            
            AccountTeamMember teamMember8 = new AccountTeamMember();
            teamMember8.AccountId = testAccounts[0].Id;
            teamMember8.TeamMemberRole = 'Pharmacy Service Coordinator';
            teamMember8.UserId = testUsers[8].Id;
            
            AccountTeamMember teamMember9 = new AccountTeamMember();
            teamMember9.AccountId = testAccounts[0].Id;
            teamMember9.TeamMemberRole = 'RVP Underwriting';
            teamMember9.UserId = testUsers[9].Id;
            
            AccountTeamMember teamMember10 = new AccountTeamMember();
            teamMember10.AccountId = testAccounts[0].Id;
            teamMember10.TeamMemberRole = 'Rx Account Management Director';
            teamMember10.UserId = testUsers[10].Id;
            
            AccountTeamMember teamMember11 = new AccountTeamMember();
            teamMember11.AccountId = testAccounts[0].Id;
            teamMember11.TeamMemberRole = 'Rx Account Manager';
            teamMember11.UserId = testUsers[11].Id;
            
            AccountTeamMember teamMember12 = new AccountTeamMember();
            teamMember12.AccountId = testAccounts[0].Id;
            teamMember12.TeamMemberRole = 'Rx Sales Director';
            teamMember12.UserId = testUsers[12].Id;
            
            AccountTeamMember teamMember13 = new AccountTeamMember();
            teamMember13.AccountId = testAccounts[0].Id;
            teamMember13.TeamMemberRole = 'Sales Executive';
            teamMember13.UserId = testUsers[13].Id;
            
            AccountTeamMember teamMember14 = new AccountTeamMember();
            teamMember14.AccountId = testAccounts[0].Id;
            teamMember14.TeamMemberRole = 'Admin Sales/AM';
            teamMember14.UserId = testUsers[14].Id;
            
            AccountTeamMember teamMember15 = new AccountTeamMember();
            teamMember15.AccountId = testAccounts[0].Id;
            teamMember15.TeamMemberRole = 'SR Sales Consultant';
            teamMember15.UserId = testUsers[15].Id;
            
            AccountTeamMember teamMember16 = new AccountTeamMember();
            teamMember16.AccountId = testAccounts[0].Id;
            teamMember16.TeamMemberRole = 'Underwriter';
            teamMember16.UserId = testUsers[16].Id;
            
            AccountTeamMember teamMember17 = new AccountTeamMember();
            teamMember17.AccountId = testAccounts[0].Id;
            teamMember17.TeamMemberRole = 'VP';
            teamMember17.UserId = testUsers[17].Id;
            
            AccountTeamMember teamMemberEBA = new AccountTeamMember();
            teamMemberEBA.AccountId = testAccounts[0].Id;
            teamMemberEBA.TeamMemberRole = 'EBA';
            teamMemberEBA.UserId = testUsers[18].Id;
            
            AccountTeamMember teamMemberIM = new AccountTeamMember();
            teamMemberIM.AccountId = testAccounts[0].Id;
            teamMemberIM.TeamMemberRole = 'Implementation Manager';
            teamMemberIM.UserId = testUsers[19].Id;
            
            AccountTeamMember teamMemberAESup = new AccountTeamMember();
            teamMemberAESup.AccountId = testAccounts[0].Id;
            teamMemberAESup.TeamMemberRole = 'AE Support Rep';
            teamMemberAESup.UserId = testUsers[20].Id;
            
            AccountTeamMember teamMemberAMSup = new AccountTeamMember();
            teamMemberAMSup.AccountId = testAccounts[0].Id;
            teamMemberAMSup.TeamMemberRole = 'AM Support Rep';
            teamMemberAMSup.UserId = testUsers[21].Id;
            
            AccountTeamMember teamMemberSAR = new AccountTeamMember();
            teamMemberSAR.AccountId = testAccounts[0].Id;
            teamMemberSAR.TeamMemberRole = 'Sales Account Representative';
            teamMemberSAR.UserId = testUsers[22].Id;
            
            AccountTeamMember teamMemberSARAM = new AccountTeamMember();
            teamMemberSARAM.AccountId = testAccounts[0].Id;
            teamMemberSARAM.TeamMemberRole = 'Sales Account Rep - Acct Mgmt';
            teamMemberSARAM.UserId = testUsers[23].Id;
            
            AccountTeamMember teamMemberCECS = new AccountTeamMember();
            teamMemberCECS.AccountId = testAccounts[0].Id;
            teamMemberCECS.TeamMemberRole = 'Client Engagement Consultant SAR';
            teamMemberCECS.UserId = testUsers[24].Id;
            
            AccountTeamMember teamMemberGRSAE = TestDataFactory.getAccountTeamMember(testAccounts[0].Id,staticVariableClass.TEAM_ROLE_GRS_ACCOUNT_EXECUTIVE,testUsers[25].Id);
            
            AccountTeamMember teamMemberGRSESR = TestDataFactory.getAccountTeamMember(testAccounts[0].Id,staticVariableClass.TEAM_ROLE_GRS_ESR,testUsers[26].Id);
            
            AccountTeamMember teamMemberVEC = TestDataFactory.getAccountTeamMember(testAccounts[0].Id,staticVariableClass.TEAM_ROLE_VOLUNTARY_ENROLLMENT,testUsers[27].Id);        
            
            teamMemberList.add(teamMember);
            teamMemberList.add(teamMember1);
            teamMemberList.add(teamMember2);
            teamMemberList.add(teamMember3);
            teamMemberList.add(teamMember4);
            teamMemberList.add(teamMember5);
            teamMemberList.add(teamMember6);
            teamMemberList.add(teamMember7);
            teamMemberList.add(teamMember8);
            teamMemberList.add(teamMember9);
            teamMemberList.add(teamMember10);
            teamMemberList.add(teamMember11);
            teamMemberList.add(teamMember12);
            teamMemberList.add(teamMember13);
            teamMemberList.add(teamMember14);
            teamMemberList.add(teamMember15);
            teamMemberList.add(teamMember16);
            teamMemberList.add(teamMember17);
            teamMemberList.add(teamMemberEBA);
            teamMemberList.add(teamMemberIM);
            teamMemberList.add(teamMemberAESup);
            teamMemberList.add(teamMemberAMSup);
            teamMemberList.add(teamMemberSAR);
            teamMemberList.add(teamMemberSARAM);
            teamMemberList.add(teamMemberCECS);
            teamMemberList.add(teamMemberGRSAE);
            teamMemberList.add(teamMemberGRSESR);
            teamMemberList.add(teamMemberVEC);
            
            Insert teamMemberList;
        
        }
    }
    
    static testMethod void clearDeleteTeamMembersOnAccountTest(){
        Account testAcc = [SELECT Id, 
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
                                                    FROM Account LIMIT 1];
        
        List<AccountTeamMember> teams = [SELECT Id,
                                                AccountId,
                                                TeamMemberRole,
                                                UserId,
                                                User.Name
                                           FROM AccountTeamMember];
        
        for(AccountTeamMember teamMember : teams){
            if (teamMember.TeamMemberRole == 'Account Executive')
              testAcc.Account_Executive__c = teamMember.UserId;
            else if (teamMember.TeamMemberRole == 'Account Manager')
              testAcc.Account_Manager__c = teamMember.UserId;
            else if (teamMember.TeamMemberRole == 'ANA Specialty AME') {
              testAcc.ANASpecialtyAME__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'ANA Specialty SD') {
              testAcc.ANASpecialtySD__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Clinical RPh') {
              testAcc.ClinicalRPh__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Director Sales/AM') {
              testAcc.DirectorSalesAccountManagement__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Implementer') {
              testAcc.Implementor__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Pharmacy Service Coordinator') {
              testAcc.PharmacyServiceCoordinator__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'RVP Underwriting') {
              testAcc.RVPUnderwriting__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Rx Account Management Director') {
              testAcc.RxAccountManagementDirector__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Rx Account Manager') {
              testAcc.RxAccountManager__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Rx Sales Director') {
              testAcc.RxSalesDirector__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Sales Executive') {
              testAcc.SalesExecutive__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Admin Sales/AM') {
              testAcc.SalesAMAdmin__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'SR Sales Consultant') {
              testAcc.SRSalesConsultant__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Underwriter') {
              testAcc.Underwriter__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'VP') {
              testAcc.VP__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'EBA') {
              testAcc.EBA__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Implementation Manager') {
              testAcc.Implementation_Manager__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Account Service Coordinator') {
              testAcc.Account_Service_Coordinator__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Account Service Representative') {
              testAcc.Account_service_representative__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Specialty Sales Account Manager') {
              testAcc.Specialty_Sales_Account_Manager__c = teamMember.User.Name;
            } else if (teamMember.TeamMemberRole == Label.Specialty_Clinical_Account_Director) {
              testAcc.Specialty_Clinical_Account_Director__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'AE Support Rep') {
              testAcc.AE_Support_Rep__c = teamMember.User.Name;
            } else if (teamMember.TeamMemberRole == 'AM Support Rep') {
              testAcc.AM_Support_Rep__c = teamMember.User.Name;
            } else if (teamMember.TeamMemberRole == 'Sales Account Representative') {
              testAcc.Sales_Account_Representative__c = teamMember.User.Name;
            } else if (teamMember.TeamMemberRole == 'Sales Account Rep - Acct Mgmt') {
              testAcc.SARAcctMgmt__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Client Engagement Consultant/SAR') {
              testAcc.Client_Engagement_Consultant_SAR1__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Hws Implementer') {
              testAcc.Hws_Implementer__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Chief Client Officer') {
              testAcc.Chief_Client_Officer__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Chief Growth Officer') {
              testAcc.Chief_Growth_Officer__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Group Service Analyst') {
              testAcc.Group_Service_Analyst__c = teamMember.UserId;
            } else if (teamMember.TeamMemberRole == 'Regional Manager') {
              testAcc.Regional_Manager__c = teamMember.User.Name;
            } else if (teamMember.TeamMemberRole == 'Strategic Client Advisor') {
              testAcc.Strategic_Client_Advisor__c = teamMember.User.Name;
            } else if (teamMember.TeamMemberRole == staticVariableClass.TEAM_ROLE_GRS_ACCOUNT_EXECUTIVE) {
              testAcc.GRS_Account_Executive__c = teamMember.User.Name;
            } else if (teamMember.TeamMemberRole == staticVariableClass.TEAM_ROLE_GRS_ESR) {
              testAcc.GRS_ESR__c = teamMember.User.Name;
            } else if (teamMember.TeamMemberRole == staticVariableClass.TEAM_ROLE_VOLUNTARY_ENROLLMENT) {
              testAcc.Voluntary_Enrollment_Consultant__c = teamMember.User.Name;
            }
        }
        update testAcc;
        
        Test.startTest();
            AccTeamMemberTriggerHandler.clearDeleteTeamMembersOnAccount(teams);
        Test.stopTest();
        
        testAcc = [SELECT Id, Account_Executive__c, Account_Manager__c, Voluntary_Enrollment_Consultant__c FROM Account LIMIT 1];
        
        System.assertEquals(testAcc.Account_Executive__c,null);
        System.assertEquals(testAcc.Account_Manager__c,null);
        System.assertEquals(testAcc.Voluntary_Enrollment_Consultant__c , null);
    }
    
    static testMethod void updateTeamMembersOnAccountTest(){
        List<String> roleNames = new List<String>{'Account Executive','Account Manager','Specialty Sales Executive','ANA Specialty AME','ANA Specialty SD','Clinical RPh','Director Sales/AM','Implementer','Pharmacy Service Coordinator','RVP Underwriting','Rx Account Management Director','Rx Account Manager','Rx Sales Director','Sales Executive','Admin Sales/AM','SR Sales Consultant','Underwriter','VP','EBA','Implementation Manager','AE Support Rep','AM Support Rep','Sales Account Representative','Sales Account Rep - Acct Mgmt','Client Engagement Consultant SAR',staticVariableClass.TEAM_ROLE_GRS_ACCOUNT_EXECUTIVE,staticVariableClass.TEAM_ROLE_GRS_ESR,staticVariableClass.TEAM_ROLE_VOLUNTARY_ENROLLMENT};
        
        Account testAcc = [SELECT Id, 
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
                                                    FROM Account LIMIT 1];
        
        List<AccountTeamMember> teams = [SELECT Id,
                                                AccountId,
                                                TeamMemberRole,
                                                UserId,
                                                User.Name
                                           FROM AccountTeamMember
                                           Order by Id Desc];
        
        for(Integer index=0;index<teams.size();index++){
            AccountTeamMember teamMember = teams[index];
            teamMember.TeamMemberRole = roleNames[index];
            
        }
        
        
        Test.startTest();
            update teams;
        Test.stopTest();
        
        testAcc = [SELECT Id, Chief_Client_Officer__c, Account_Manager__c, Voluntary_Enrollment_Consultant__c FROM Account LIMIT 1];
        
        System.assertEquals(testAcc.Chief_Client_Officer__c,null);
    }
    
    static testMethod void updateTeamMembersOnAccountTestTwo(){
        
        Account testAcc = [SELECT Id, 
                                                              Account_Executive__c, 
                                                              Account_Manager__c
                                                    FROM Account LIMIT 1];
        
        List<AccountTeamMember> teams = [SELECT Id,
                                                AccountId,
                                                TeamMemberRole,
                                                UserId,
                                                User.Name
                                           FROM AccountTeamMember
                                         WHERE TeamMemberRole IN ('Account Executive') ];
        
        teams[0].TeamMemberRole = 'Account Manager';
        
        
        Test.startTest();
            update teams;
        Test.stopTest();
        
        testAcc = [SELECT Id, Account_Executive__c, Account_Manager__c FROM Account LIMIT 1];
        
        System.assertEquals(testAcc.Account_Manager__c,teams[0].UserId);
        System.assertEquals(testAcc.Account_Executive__c,null);
    }
}