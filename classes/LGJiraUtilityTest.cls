@isTest
public class LGJiraUtilityTest {
    
    @isTest static void createIssueSuccessTest()
    {
        
        Test.startTest();
        
        LGJiraUtilityMockTest mockTest = new LGJiraUtilityMockTest(200);
        Test.setMock(HttpCalloutMock.class, mockTest);
        LGJiraUtility lgu = new LGJiraUtility();
        LGJiraCreateIssueResponse resp = lgu.CreateIssue('Test Request');
        Test.stopTest();
        //        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        //        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
        
    }
     
 @isTest static void createIssueErrorTest()
    {
        
        Test.startTest();
        
        LGJiraUtilityMockTest mockTest = new LGJiraUtilityMockTest(400);
        Test.setMock(HttpCalloutMock.class, mockTest);
        LGJiraUtility lgu = new LGJiraUtility();
        LGJiraCreateIssueResponse resp = lgu.CreateIssue('Test Request');
        Test.stopTest();
        //        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        //        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
        
    }
     @isTest static void GetIssueTest()
    {
        
        Test.startTest();
        
        LGJiraUtilityMockTest mockTest = new LGJiraUtilityMockTest(200);
        Test.setMock(HttpCalloutMock.class, mockTest);
        LGJiraUtility lgu = new LGJiraUtility();
        HttpResponse resp = lgu.GetIssue('EWM-TEST', true);
        //LGJiraCreateIssueResponse resp = lgu.CreateIssue('Test Request');
        Test.stopTest();
        //        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        //        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
        
    }
    
    @isTest static void SearchPostIssueTest1()
    {
        
        Test.startTest();
        
        LGJiraUtilityMockTest mockTest = new LGJiraUtilityMockTest(200);
        Test.setMock(HttpCalloutMock.class, mockTest);
        LGJiraUtility lgu = new LGJiraUtility();
        String resp = lgu.SearchPostIssue('EWM-TEST');
        //LGJiraCreateIssueResponse resp = lgu.CreateIssue('Test Request');
        Test.stopTest();
        //        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        //        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
        
    }

    @isTest static void SearchPostIssueTest2()
    {
        
        Test.startTest();
        
        LGJiraUtilityMockTest mockTest = new LGJiraUtilityMockTest(200);
        Test.setMock(HttpCalloutMock.class, mockTest);

        LGJiraUtility lgu = new LGJiraUtility();

        List<String> jiraids = new List<String> {'EWM-001','EWM-002'};
        List<String> fields = new List<String> {'field1','field2'};
                
        JiraSearchIssueResponse resp = lgu.SearchPostIssue(jiraids, fields);
        //LGJiraCreateIssueResponse resp = lgu.CreateIssue('Test Request');
        Test.stopTest();
        //        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        //        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
        
    }


     @isTest static void LGJira2TokenDetailTest() {
        
        Test.startTest();
        CustomException  e = new CustomException();

        LGJira2TokenDetail tokenDetail = new LGJira2TokenDetail();
        tokenDetail.access_token = 'test';
        tokenDetail.currentTime = System.now();
        tokenDetail.isNewToken = true;
        tokenDetail.issued_at='PMO';
        tokenDetail.application_name ='APM';
        tokenDetail.status ='Active';
        tokenDetail.expires_in ='30 days';
        tokenDetail.client_id ='BDF01';

        
        LGJiraAccessToken__c LGJiraAccessToken = new LGJiraAccessToken__c(CreatedTime__c =tokenDetail.currentTime,Access_Token__c=tokenDetail.access_token,Name = 'Token4Jira');
        insert LGJiraAccessToken;
        LGJiraUtility lgu = new LGJiraUtility();
        LGJira2TokenDetail resp = lgu.QueryTokenTable();
        lgu.UpdateTokenTable();
        System.assert(LGJiraAccessToken.Access_Token__c =='test');
        System.assert(LGJiraAccessToken.CreatedTime__c !=null);
        System.assert(LGJiraAccessToken.Name !=null);
        Test.stopTest();
  
    }
    @isTest static void TokenTableTest()
    {
        
        Test.startTest();
        
        LGJiraUtilityMockTest mockTest = new LGJiraUtilityMockTest(200);
        Test.setMock(HttpCalloutMock.class, mockTest);
        LGJiraUtility lgu = new LGJiraUtility();
        lgu.UpdateTokenTable();
        Test.stopTest();
        
    }
    
}