@isTest
public class AccountTrigger_Test {
@isTest static void createIssueNationalWGSTest()
    {
        test.startTest();
        Test.setMock(HttpCalloutMock.class, New MockBingTravelResponse());
        //Accounts creation 
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'Customer', 'National Accounts','South East','NAH00000 GA','ANA');
    	Open_Enrollment_Meetings__c OEMeet = new Open_Enrollment_Meetings__c(Name = 'OEMeetTest', Account__c = acc1.id, Plan_Type__c = 'ANC - AD&D', Dress_Code_for_Event__c='Business Casual',
                                            Client_Drivers_Issues_Risks__c='Test', Plan_Changes__c = 'Test');
        insert OEMeet;
        system.debug('OEMeet-->'+OEMeet);
        SFDC_Volunteer_Event__c OpenE = new SFDC_Volunteer_Event__c(Name = 'Test', Meeting_Type__c = 'Benefit Fair', Date__c = Date.newInstance(2019, 03, 01), OE_Grouping__c = OEMeet.id,Recruitment_of_Facilitator_Needed__c='No');
        insert OpenE;
        
        
        acc1.Account_Executive__c = Userinfo.getUserId(); 
        update acc1;
        //try{
        //delete [select id, name from Open_Enrollment_Meetings__c where id=:OEMeet.id];
        //delete [select id, name from account where id=:acc1.id];
        //}catch(Exception ae){}
        test.stopTest();
    }
}