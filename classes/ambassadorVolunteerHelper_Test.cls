@isTest
private class ambassadorVolunteerHelper_Test {
    static testMethod void test1(){
    Test.setMock(HttpCalloutMock.class, New MockBingTravelResponse());
        List<SFDC_Volunteer_Participant__c> OEList = new List<SFDC_Volunteer_Participant__c>();
        Account acc= new Account(name='Open Enrollment');
        insert acc;
        system.debug('Account-->'+acc);
        Contact con = new Contact (lastname = 'TestCon',AccountId=acc.Id,Facilitator_Type__c='OE Coordinator',Email='smita.ganiger@legatohealth.com');
        insert con;
        system.debug('Contact-->'+con);
        
        Contact con2 = new Contact (lastname = 'TestCon',AccountId=acc.Id,Facilitator_Type__c='OE Coordinator',Email='mehaboobpasha.kallur@legatohealth.com');
        insert con2;
        
        Open_Enrollment_Meetings__c OEMeet = new Open_Enrollment_Meetings__c(Name = 'OEMeetTest', Account__c = acc.id, Plan_Type__c = 'ANC - AD&D', Dress_Code_for_Event__c='Business Casual',
                                            Client_Drivers_Issues_Risks__c='Test', Plan_Changes__c = 'Test',OE_Coordinator_Contact__c=con2.Id);
        insert OEMeet;
        system.debug('OEMeet-->'+OEMeet);
        SFDC_Volunteer_Event__c OpenE = new SFDC_Volunteer_Event__c(Name = 'Test', Meeting_Type__c = 'Benefit Fair', Date__c = Date.newInstance(2019, 03, 01), OE_Grouping__c = OEMeet.id,Recruitment_of_Facilitator_Needed__c='No');
        insert OpenE;
       /* SFDC_Volunteer_Event__c OpenE1 = new SFDC_Volunteer_Event__c(Name = 'Test1', Meeting_Type__c = 'Benefit Fair1', Date__c = Date.newInstance(2019, 03, 01), OE_Grouping__c = OEMeet.id);
        insert OpenE1;*/
        system.debug('OpenE-->'+OpenE);
        SFDC_Volunteer_Participant__c OEAmb1 = new SFDC_Volunteer_Participant__c(Volunteer_Event__c = OpenE.id, OE_Ambassador_Volunteer__c = con.id);
        SFDC_Volunteer_Participant__c OEAmb2 = new SFDC_Volunteer_Participant__c(Volunteer_Event__c = OpenE.id, OE_Ambassador_Volunteer__c = con.id);
        SFDC_Volunteer_Participant__c OEAmb3 = new SFDC_Volunteer_Participant__c(Volunteer_Event__c = OpenE.id, OE_Ambassador_Volunteer__c = con.id);
       
       
        insert OEAmb1;
        insert OEAmb2;
        insert OEAmb3;
        update OEAmb3;
        
        system.debug('OEList-->'+OEList);
        
    }

}