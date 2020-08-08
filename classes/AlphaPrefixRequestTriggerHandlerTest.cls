/**************************************************************************************
Class Name: AlphaPrefixRequestTriggerHandlerTest  
Version     : 1.0 
Created Date    : 12 May 2019
@Author: Neha Prasad ,Legato 
@UStory: PRDCRM-32826    

Change Logs :
Date                Modified By              User Story               Remarks
9 July 2019       Partha Baruah         PRDCRM-37163         Added Team Member roles :: AE Support Rep;AM Support Rep
*************************************************************************************/ 

@isTest
private class AlphaPrefixRequestTriggerHandlerTest {
    
    /**
     * @description Test Data Setup Method that executes for every testmethod to create 
                    test account, associated account team members, users and alpha request
     */
    @TestSetup
    static void testDataSetup() {
        Integer noOfTestUsers = 3;
        Account testAccount  = new Account(name='testAccount');
        Insert testAccount;
        Id sysAdminProfileId = [SELECT Id from Profile Where Name = 'System Administrator' LIMIT 1].Id;
        String orgId         = userInfo.getOrganizationId();
        List<User> testUsers = new List<User>();
        for(Integer i=0; i<noOfTestUsers-1; i++) {
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName = orgId + dateString + randomInt;
            User testUser     = new User(   firstname = 'testFirstName',
                                            lastName = 'testLastName',
                                            email = uniqueName + '@test' + orgId + '.org',
                                            Username = uniqueName + '@test' + orgId + '.org',
                                            EmailEncodingKey = 'ISO-8859-1',
                                            Alias = uniqueName.substring(18, 23),
                                            TimeZoneSidKey = 'America/Los_Angeles',
                                            LocaleSidKey = 'en_US',
                                            LanguageLocaleKey = 'en_US',
                                            ProfileId = sysAdminProfileId
                                        );
            testUsers.add(testUser);
        }
        Insert testUsers;
      //  List<String> teamMemberRoles = new List<String>{'Account Executive','Account Manager','Underwriter'};
      
        LG_Op_Helper__mdt mdtRoles=[select LG_Field_Value__c from LG_Op_Helper__mdt where DeveloperName='APR_Account_Roles']; // Contains list of relevant Account Team Roles: Account Executive;Account Manager;Underwriter;AE Support Rep;AM Support Rep
    
        List <String>  teamMemberRoles = mdtRoles.LG_Field_Value__c.split(';'); 
        List<AccountTeamMember> testTeamMembers = new List<AccountTeamMember>();
        for(Integer i=0; i<noOfTestUsers-1; i++) {
            AccountTeamMember testTeamMember = new AccountTeamMember(AccountAccessLevel='Read',
                                                                     AccountId = testAccount.Id,
                                                                     TeamMemberRole = teamMemberRoles[i],
                                                                     UserId = testUsers[i].Id
                                                                    );
            testTeamMembers.add(testTeamMember);            
        }
        Insert testTeamMembers;
        List<Alpha_Prefix_Request__c> testRequests = new List<Alpha_Prefix_Request__c>();
        for(Integer i=0; i<noOfTestUsers; i++) {
            Alpha_Prefix_Request__c testRequest = new Alpha_Prefix_Request__c(Account__c = testAccount.Id,
                                                                              Status__c = 'Entered'
                                                                             );
            testRequests.add(testRequest);      
        }
        Insert testRequests;        
    }
    
    /**
     * @description Test Method to valid Trigger.AfterInsert Functionality
     */
    
    public static testMethod void afterInsertCallTest() {
        Id testAccountId = [SELECT Id from Account LIMIT 1].Id;
        Alpha_Prefix_Request__c testRequest = new Alpha_Prefix_Request__c(Account__c = testAccountId,
                                                                              Status__c = 'Entered'
                                                                         );
        Integer emailMethodInvocations = 0;
        Test.startTest();
            Insert testRequest;
            emailMethodInvocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(0, emailMethodInvocations, 'Something Went Wrong!');        
    }
    
    /**
     * @description Test Method to valid Trigger.AfterUpdate Functionality
     */
    
    public static testMethod void afterUpdateCallTest() {
        List<Alpha_Prefix_Request__c> existingRequests= [SELECT Id,Status__c from Alpha_Prefix_Request__c];
        if(!existingRequests.isEmpty()) {
            for(Integer i=0; i<existingRequests.size()-1; i++) {
            existingRequests[i].Status__c = 'Prefix Assigned';
        }
        existingRequests[2].Status__c = 'Request Complete';
        Integer emailMethodInvocations = 0;     
        Test.startTest();
            Update existingRequests;
            emailMethodInvocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(1, emailMethodInvocations, 'Something Went Wrong!');        
    }
    
}
}