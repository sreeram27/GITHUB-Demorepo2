/**************************************************************************************
Apex Class Name:  AccTeamReportBatchTest
Version     : 1.0 
Created Date    : 14 August 2018
Modified Date : 9 November 2019
Modified Date : 10 December 2019
* @Author: Accenture Offshore
Function    : AccTeamReportBatch Test Class 
*************************************************************************************/


@isTest
public class AccTeamReportBatchTest {
   
    static String ERROR_MSG = 'Something went wrong!';
    
    
   
    @testSetup
    static  void setupTestData(){
        AccountRoles__c roles = new AccountRoles__c();
        roles.Name = 'AccountTeamReport';
        roles.LastRun__c = Datetime.now().addDays(-10);
        insert roles;
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        List<User> users = new List<User>();
        User u1=new User(firstname = 'user', 
                         lastName = '1', 
                         Email ='testaccBatch@accenture.com', 
                         UserName = 'testacc@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user1', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        User u2=new User(firstname = 'User', 
                         lastName = '2', 
                         Email ='user2@accenture.com', 
                         UserName = 'user2@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user2', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u3=new User(firstname = 'User', 
                         lastName = '3', 
                         Email ='user3@accenture.com', 
                         UserName = 'user3@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user3', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u4=new User(firstname = 'User', 
                         lastName = '4', 
                         Email ='user4@accenture.com', 
                         UserName = 'user4@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user4', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u5=new User(firstname = 'User', 
                         lastName = '5', 
                         Email ='user5@accenture.com', 
                         UserName = 'user5@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user5', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u6=new User(firstname = 'User', 
                         lastName = '6', 
                         Email ='user6@accenture.com', 
                         UserName = 'user6@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user6', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u7=new User(firstname = 'User', 
                         lastName = '7', 
                         Email ='user7@accenture.com', 
                         UserName = 'user7@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user7', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u8=new User(firstname = 'User', 
                         lastName = '8', 
                         Email ='user8@accenture.com', 
                         UserName = 'user8@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user8', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u9=new User(firstname = 'User', 
                         lastName = '9', 
                         Email ='user9@accenture.com', 
                         UserName = 'user9@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user9', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u10=new User(firstname = 'User', 
                         lastName = '10', 
                         Email ='user10@accenture.com', 
                         UserName = 'user10@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user10', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u11=new User(firstname = 'User', 
                         lastName = '11', 
                         Email ='user11@accenture.com', 
                         UserName = 'user11@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user11', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u12=new User(firstname = 'User', 
                         lastName = '12', 
                         Email ='user12@accenture.com', 
                         UserName = 'user12@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user12', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u13=new User(firstname = 'User', 
                         lastName = '13', 
                         Email ='user13@accenture.com', 
                         UserName = 'user13@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user13', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u14=new User(firstname = 'User', 
                         lastName = '14', 
                         Email ='user14@accenture.com', 
                         UserName = 'user14@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user14', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u15=new User(firstname = 'User', 
                         lastName = '15', 
                         Email ='user15@accenture.com', 
                         UserName = 'user15@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user15', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u16=new User(firstname = 'User', 
                         lastName = '16', 
                         Email ='user16@accenture.com', 
                         UserName = 'user16@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user16', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u17=new User(firstname = 'User', 
                         lastName = '17', 
                         Email ='user17@accenture.com', 
                         UserName = 'user17@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user17', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        User u18=new User(firstname = 'User', 
                         lastName = '18', 
                         Email ='user18@accenture.com', 
                         UserName = 'user18@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user18', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
          User u19=new User(firstname = 'User', 
                         lastName = '19', 
                         Email ='user19@accenture.com', 
                         UserName = 'user19@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user19', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 

        User u20=new User(firstname = 'User', 
                         lastName = '20', 
                         Email ='user20@accenture.com', 
                         UserName = 'user20@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user20', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        );
        User u21=new User(firstname = 'User', 
                         lastName = '21', 
                         Email ='user21@accenture.com', 
                         UserName = 'user21@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user21', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        );
        User u22=new User(firstname = 'User', 
                         lastName = '22', 
                         Email ='user22@accenture.com', 
                         UserName = 'user22@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user22', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        );
        User u23=new User(firstname = 'User', 
                         lastName = '23', 
                         Email ='user23@accenture.com', 
                         UserName = 'user23@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user23', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        );
        User u24=new User(firstname = 'User', 
                         lastName = '24', 
                         Email ='user24@accenture.com', 
                         UserName = 'user24@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user24', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        );
        User u25=new User(firstname = 'User', 
                         lastName = '25', 
                         Email ='user25@accenture.com', 
                         UserName = 'user25@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user25', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        );
        User u26=new User(firstname = 'User', 
                         lastName = '26', 
                         Email ='user26@accenture.com', 
                         UserName = 'user26@anthem.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'user26', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        );
        
        List<User> testUsers = TestDataFactory.createUserData(3,'System Administrator','');
        
        users.add(u1);
        users.add(u2);
        users.add(u3);
        users.add(u4);
        users.add(u5);
        users.add(u6);
        users.add(u7);
        users.add(u8);
        users.add(u9);
        users.add(u10);
        users.add(u11);
        users.add(u12);
        users.add(u13);
        users.add(u14);
        users.add(u15);
        users.add(u16);
        users.add(u17);
        users.add(u18);
        users.add(u19);
        users.add(u20);
        users.add(u21);
        users.add(u22);
        users.add(u23);
        users.add(u24);
        users.add(u25);
        users.add(u26);
        users.addAll(testUsers);
        insert users;
        
        Map<Id,Account> accountMap = new Map<Id,Account>();
        
        List<Account> testAccounts = TestDataFactory.createAccountSICList(2,'Test Accounts','Test Street','Test City','Test State','10000','Test Country', 'TEST001');
        Insert testAccounts;
        
        accountMap.put(testAccounts[0].Id , testAccounts[0]);
        accountMap.put(testAccounts[1].Id , testAccounts[0]);
        List<AccountTeamMember> teamMemberList = new List<AccountTeamMember>();
        
        
        AccountTeamMember teamMember = new AccountTeamMember();
        teamMember.AccountId = testAccounts[0].Id;
        teamMember.TeamMemberRole = 'Account Executive';
        teamMember.UserId = u1.Id;
        
        AccountTeamMember teamMember1 = new AccountTeamMember();
        teamMember1.AccountId = testAccounts[0].Id;
        teamMember1.TeamMemberRole = 'Account Manager';
        teamMember1.UserId = u2.Id;
        
        AccountTeamMember teamMember2 = new AccountTeamMember();
        teamMember2.AccountId = testAccounts[0].Id;
        teamMember2.TeamMemberRole = 'Specialty Sales Executive';
        teamMember2.UserId = u3.Id;
        
        AccountTeamMember teamMember3 = new AccountTeamMember();
        teamMember3.AccountId = testAccounts[0].Id;
        teamMember3.TeamMemberRole = 'ANA Specialty AME';
        teamMember3.UserId = u4.Id;
        
        AccountTeamMember teamMember4 = new AccountTeamMember();
        teamMember4.AccountId = testAccounts[0].Id;
        teamMember4.TeamMemberRole = 'ANA Specialty SD';
        teamMember4.UserId = u5.Id;
        
        AccountTeamMember teamMember5 = new AccountTeamMember();
        teamMember5.AccountId = testAccounts[0].Id;
        teamMember5.TeamMemberRole = 'Clinical RPh';
        teamMember5.UserId = u6.Id;
        
        AccountTeamMember teamMember6 = new AccountTeamMember();
        teamMember6.AccountId = testAccounts[0].Id;
        teamMember6.TeamMemberRole = 'Director Sales/AM';
        teamMember6.UserId = u7.Id;
        
        AccountTeamMember teamMember7 = new AccountTeamMember();
        teamMember7.AccountId = testAccounts[0].Id;
        teamMember7.TeamMemberRole = 'Implementer';
        teamMember7.UserId = u8.Id;
        
        AccountTeamMember teamMember8 = new AccountTeamMember();
        teamMember8.AccountId = testAccounts[0].Id;
        teamMember8.TeamMemberRole = 'Pharmacy Service Coordinator';
        teamMember8.UserId = u9.Id;
        
        AccountTeamMember teamMember9 = new AccountTeamMember();
        teamMember9.AccountId = testAccounts[0].Id;
        teamMember9.TeamMemberRole = 'RVP Underwriting';
        teamMember9.UserId = u10.Id;
        
        AccountTeamMember teamMember10 = new AccountTeamMember();
        teamMember10.AccountId = testAccounts[0].Id;
        teamMember10.TeamMemberRole = 'Rx Account Management Director';
        teamMember10.UserId = u11.Id;
        
        AccountTeamMember teamMember11 = new AccountTeamMember();
        teamMember11.AccountId = testAccounts[0].Id;
        teamMember11.TeamMemberRole = 'Rx Account Manager';
        teamMember11.UserId = u12.Id;
        
        AccountTeamMember teamMember12 = new AccountTeamMember();
        teamMember12.AccountId = testAccounts[0].Id;
        teamMember12.TeamMemberRole = 'Rx Sales Director';
        teamMember12.UserId = u13.Id;
        
        AccountTeamMember teamMember13 = new AccountTeamMember();
        teamMember13.AccountId = testAccounts[0].Id;
        teamMember13.TeamMemberRole = 'Sales Executive';
        teamMember13.UserId = u14.Id;
        
        AccountTeamMember teamMember14 = new AccountTeamMember();
        teamMember14.AccountId = testAccounts[0].Id;
        teamMember14.TeamMemberRole = 'Admin Sales/AM';
        teamMember14.UserId = u15.Id;
        
        AccountTeamMember teamMember15 = new AccountTeamMember();
        teamMember15.AccountId = testAccounts[0].Id;
        teamMember15.TeamMemberRole = 'SR Sales Consultant';
        teamMember15.UserId = u16.Id;
        
        AccountTeamMember teamMember16 = new AccountTeamMember();
        teamMember16.AccountId = testAccounts[0].Id;
        teamMember16.TeamMemberRole = 'Underwriter';
        teamMember16.UserId = u17.Id;
        
        AccountTeamMember teamMember17 = new AccountTeamMember();
        teamMember17.AccountId = testAccounts[0].Id;
        teamMember17.TeamMemberRole = 'VP';
        teamMember17.UserId = u18.Id;
        
        AccountTeamMember teamMemberEBA = new AccountTeamMember();
        teamMemberEBA.AccountId = testAccounts[0].Id;
        teamMemberEBA.TeamMemberRole = 'EBA';
        teamMemberEBA.UserId = u19.Id;
        
        AccountTeamMember teamMemberIM = new AccountTeamMember();
        teamMemberIM.AccountId = testAccounts[0].Id;
        teamMemberIM.TeamMemberRole = 'Implementation Manager';
        teamMemberIM.UserId = u20.Id;
        
        AccountTeamMember teamMemberAESup = new AccountTeamMember();
        teamMemberAESup.AccountId = testAccounts[0].Id;
        teamMemberAESup.TeamMemberRole = 'AE Support Rep';
        teamMemberAESup.UserId = u21.Id;
        
        AccountTeamMember teamMemberAMSup = new AccountTeamMember();
        teamMemberAMSup.AccountId = testAccounts[0].Id;
        teamMemberAMSup.TeamMemberRole = 'AM Support Rep';
        teamMemberAMSup.UserId = u22.Id;
        
        AccountTeamMember teamMemberSAR = new AccountTeamMember();
        teamMemberSAR.AccountId = testAccounts[0].Id;
        teamMemberSAR.TeamMemberRole = 'Sales Account Representative';
        teamMemberSAR.UserId = u23.Id;
        
        AccountTeamMember teamMemberSARAM = new AccountTeamMember();
        teamMemberSARAM.AccountId = testAccounts[0].Id;
        teamMemberSARAM.TeamMemberRole = 'Sales Account Rep - Acct Mgmt';
        teamMemberSARAM.UserId = u24.Id;
        
        AccountTeamMember teamMemberCECS = new AccountTeamMember();
        teamMemberCECS.AccountId = testAccounts[0].Id;
        teamMemberCECS.TeamMemberRole = 'Client Engagement Consultant SAR';
        teamMemberCECS.UserId = u25.Id;
        
        AccountTeamMember teamMemberGRSAE = TestDataFactory.getAccountTeamMember(testAccounts[0].Id,staticVariableClass.TEAM_ROLE_GRS_ACCOUNT_EXECUTIVE,testUsers[0].Id);
        
        AccountTeamMember teamMemberGRSESR = TestDataFactory.getAccountTeamMember(testAccounts[0].Id,staticVariableClass.TEAM_ROLE_GRS_ESR,testUsers[1].Id);
        
        AccountTeamMember teamMemberVEC = TestDataFactory.getAccountTeamMember(testAccounts[0].Id,staticVariableClass.TEAM_ROLE_VOLUNTARY_ENROLLMENT,testUsers[2].Id);        
        
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
        
        
        
        
        AccountTeamMember teamMember18 = new AccountTeamMember();
        teamMember18.AccountId = testAccounts[1].Id;
        teamMember18.TeamMemberRole = 'Account Executive';
        teamMember18.UserId = u1.Id;
        
        AccountTeamMember teamMember19 = new AccountTeamMember();
        teamMember19.AccountId = testAccounts[1].Id;
        teamMember19.TeamMemberRole = 'Account Manager';
        teamMember19.UserId = u2.Id;
        
        AccountTeamMember teamMember20 = new AccountTeamMember();
        teamMember20.AccountId = testAccounts[1].Id;
        teamMember20.TeamMemberRole = 'Specialty Sales Executive';
        teamMember20.UserId = u3.Id;
        
        AccountTeamMember teamMember21 = new AccountTeamMember();
        teamMember21.AccountId = testAccounts[1].Id;
        teamMember21.TeamMemberRole = 'ANA Specialty AME';
        teamMember21.UserId = u4.Id;
        
        AccountTeamMember teamMember22 = new AccountTeamMember();
        teamMember22.AccountId = testAccounts[1].Id;
        teamMember22.TeamMemberRole = 'ANA Specialty SD';
        teamMember22.UserId = u5.Id;
        
        AccountTeamMember teamMember23 = new AccountTeamMember();
        teamMember23.AccountId = testAccounts[1].Id;
        teamMember23.TeamMemberRole = 'Clinical RPh';
        teamMember23.UserId = u6.Id;
        
        AccountTeamMember teamMember24 = new AccountTeamMember();
        teamMember24.AccountId = testAccounts[1].Id;
        teamMember24.TeamMemberRole = 'Director Sales/AM';
        teamMember24.UserId = u7.Id;
        
        AccountTeamMember teamMember25 = new AccountTeamMember();
        teamMember25.AccountId = testAccounts[1].Id;
        teamMember25.TeamMemberRole = 'Implementer';
        teamMember25.UserId = u8.Id;
        
        AccountTeamMember teamMember26 = new AccountTeamMember();
        teamMember26.AccountId = testAccounts[1].Id;
        teamMember26.TeamMemberRole = 'Pharmacy Service Coordinator';
        teamMember26.UserId = u9.Id;
        
        AccountTeamMember teamMember27 = new AccountTeamMember();
        teamMember27.AccountId = testAccounts[1].Id;
        teamMember27.TeamMemberRole = 'RVP Underwriting';
        teamMember27.UserId = u10.Id;
        
        AccountTeamMember teamMember28 = new AccountTeamMember();
        teamMember28.AccountId = testAccounts[1].Id;
        teamMember28.TeamMemberRole = 'Rx Account Management Director';
        teamMember28.UserId = u11.Id;
        
        AccountTeamMember teamMember29 = new AccountTeamMember();
        teamMember29.AccountId = testAccounts[1].Id;
        teamMember29.TeamMemberRole = 'Rx Account Manager';
        teamMember29.UserId = u12.Id;
        
        AccountTeamMember teamMember30 = new AccountTeamMember();
        teamMember30.AccountId = testAccounts[1].Id;
        teamMember30.TeamMemberRole = 'Rx Sales Director';
        teamMember30.UserId = u13.Id;
        
        AccountTeamMember teamMember31 = new AccountTeamMember();
        teamMember31.AccountId = testAccounts[1].Id;
        teamMember31.TeamMemberRole = 'Sales Executive';
        teamMember31.UserId = u14.Id;
        
        AccountTeamMember teamMember32 = new AccountTeamMember();
        teamMember32.AccountId = testAccounts[1].Id;
        teamMember32.TeamMemberRole = 'Admin Sales/AM';
        teamMember32.UserId = u15.Id;
        
        AccountTeamMember teamMember33 = new AccountTeamMember();
        teamMember33.AccountId = testAccounts[1].Id;
        teamMember33.TeamMemberRole = 'SR Sales Consultant';
        teamMember33.UserId = u16.Id;
        
        AccountTeamMember teamMember34 = new AccountTeamMember();
        teamMember34.AccountId = testAccounts[1].Id;
        teamMember34.TeamMemberRole = 'Underwriter';
        teamMember34.UserId = u17.Id;
        
        AccountTeamMember teamMember35 = new AccountTeamMember();
        teamMember35.AccountId = testAccounts[1].Id;
        teamMember35.TeamMemberRole = 'VP';
        teamMember35.UserId = u18.Id;
        
        AccountTeamMember teamMember36 = new AccountTeamMember();
        teamMember36.AccountId = testAccounts[1].Id;
        teamMember36.TeamMemberRole = 'EBA';
        teamMember36.UserId = u19.Id;
        
        AccountTeamMember teamMember37 = new AccountTeamMember();
        teamMember37.AccountId = testAccounts[1].Id;
        teamMember37.TeamMemberRole = 'EBA';
        teamMember37.UserId = u20.Id;

        AccountTeamMember teamMember38 = new AccountTeamMember();
        teamMember38.AccountId = testAccounts[1].Id;
        teamMember38.TeamMemberRole = 'AE Support Rep';
        teamMember38.UserId = u21.Id;
        
        AccountTeamMember teamMember39 = new AccountTeamMember();
        teamMember39.AccountId = testAccounts[1].Id;
        teamMember39.TeamMemberRole = 'AM Support Rep';
        teamMember39.UserId = u22.Id;
        
        AccountTeamMember teamMember40 = new AccountTeamMember();
        teamMember40.AccountId = testAccounts[1].Id;
        teamMember40.TeamMemberRole = 'Sales Account Representative';
        teamMember40.UserId = u23.Id;
        
        AccountTeamMember teamMember41 = new AccountTeamMember();
        teamMember41.AccountId = testAccounts[1].Id;
        teamMember41.TeamMemberRole = 'Sales Account Rep - Acct Mgmt';
        teamMember41.UserId = u24.Id;
        
        AccountTeamMember teamMember42 = new AccountTeamMember();
        teamMember42.AccountId = testAccounts[1].Id;
        teamMember42.TeamMemberRole = 'Client Engagement Consultant SAR';
        teamMember42.UserId = u25.Id;
        
        
        AccountTeamMember teamMember43=  TestDataFactory.getAccountTeamMember(testAccounts[1].Id,staticVariableClass.TEAM_ROLE_GRS_ACCOUNT_EXECUTIVE,testUsers[0].Id);
                
        AccountTeamMember teamMember44 = TestDataFactory.getAccountTeamMember(testAccounts[1].Id,staticVariableClass.TEAM_ROLE_GRS_ESR,testUsers[1].Id);
        
        AccountTeamMember teamMember45 = TestDataFactory.getAccountTeamMember(testAccounts[1].Id,staticVariableClass.TEAM_ROLE_VOLUNTARY_ENROLLMENT,testUsers[2].Id);
        
        teamMemberList.add(teamMember18);
        teamMemberList.add(teamMember19);
        teamMemberList.add(teamMember20);
        teamMemberList.add(teamMember21);
        teamMemberList.add(teamMember22);
        teamMemberList.add(teamMember23);
        teamMemberList.add(teamMember24);
        teamMemberList.add(teamMember25);
        teamMemberList.add(teamMember26);
        teamMemberList.add(teamMember27);
        teamMemberList.add(teamMember28);
        teamMemberList.add(teamMember29);
        teamMemberList.add(teamMember30);
        teamMemberList.add(teamMember31);
        teamMemberList.add(teamMember32);
        teamMemberList.add(teamMember33);
        teamMemberList.add(teamMember34);
        teamMemberList.add(teamMember35);
        teamMemberList.add(teamMember36);
        teamMemberList.add(teamMember37);
        teamMemberList.add(teamMember38);
        teamMemberList.add(teamMember39);
        teamMemberList.add(teamMember40);
        teamMemberList.add(teamMember41);
        teamMemberList.add(teamMember42);
        teamMemberList.add(teamMember43);
        teamMemberList.add(teamMember44);
        teamMemberList.add(teamMember45);
        //inserting team member list
        insert teamMemberList;
     
   
                
    }
    
    static testMethod void testMethodAccExec()
    {
         
        
        Test.startTest();
        AccTeamReportBatch obj = new AccTeamReportBatch();
        database.executeBatch(obj);
        Test.StopTest();
      
      Account testUserAcc = [SELECT Id, 
                             GRS_Account_Executive__c,
                             GRS_ESR__c,
                            Voluntary_Enrollment_Consultant__c
                            FROM Account
                            WHERE Name = 'Test Accounts 0'];

      System.assertEquals(testUserAcc.GRS_Account_Executive__c, 'Testing',ERROR_MSG);
      System.assertEquals(testUserAcc.GRS_ESR__c, 'Testing',ERROR_MSG);
      System.assertEquals(testUserAcc.Voluntary_Enrollment_Consultant__c, 'Testing',ERROR_MSG);

        Account testAccTwo = [SELECT Id, 
                              GRS_Account_Executive__c,
                              GRS_ESR__c,
                              Voluntary_Enrollment_Consultant__c
                              FROM Account
                              WHERE Name = 'Test Accounts 1'];

      System.assertEquals(testAccTwo.GRS_Account_Executive__c, 'Testing',ERROR_MSG);
      System.assertEquals(testAccTwo.GRS_ESR__c, 'Testing',ERROR_MSG);
      System.assertEquals(testAccTwo.Voluntary_Enrollment_Consultant__c, 'Testing',ERROR_MSG);  
        
    }
    static testMethod void testMethodAccExec1()
    {
        
        Test.startTest();
        AccTeamReportBatch obj1 = new AccTeamReportBatch();
        obj1.isError = true;
        database.executeBatch(obj1); 
        Test.StopTest();
       
    }
    
    
  }