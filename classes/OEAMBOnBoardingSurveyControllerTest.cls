/***************************************************************
    * Purpose:  Test for controller for onboarding survey form
    * Mod:      4/25/2015
    * Author:   Leslie Getman
    ***************************************************************
    *Mod
    *            4/28/2015
    *            Updated to get better test coverage
    * Moved from COM1 with modifications. - XMen
    * @description OEAMBOnBoardingSurveyControllerTest
    ****************************************************************/
@isTest
public class  OEAMBOnBoardingSurveyControllerTest {
    
    @testSetup
	static void testDataMethod () {
        Test.setMock(HttpCalloutMock.class, New MockBingTravelResponse());
        // Insert Account
        Account acctRec = new Account();
        acctRec.Name = 'Test Company Name';
        acctRec.Anthem_Entity__c = 'National Accounts';
        acctRec.Region__c = 'Central';
        insert acctRec;
        
        //Create contact
        Contact cnt=new Contact();
        cnt.lastname='Test First';
        cnt.firstname='Tony';
        cnt.AccountId=acctRec.Id;
        cnt.RecordTypeID=Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        cnt.Facilitator_Type__c='OE Coordinator';
        cnt.Region_Location__c='Central';
        cnt.Email='tony_angle@msn.com';
        cnt.Active__c=true;
        insert cnt;
		
         // Insert new meeting
        Open_Enrollment_Meetings__c meetRec = new Open_Enrollment_Meetings__c();
        meetRec.Account__c = acctRec.id;       
        meetRec.Plan_Type__c = 'ANC Dental';        
        meetRec.Name='test Meeting';
        meetRec.Source__c='Georgia';
        meetRec.OE_Coordinator_Contact__c=cnt.id;
		meetRec.Plan_Type__c= 'ANC Vision'; 
        meetRec.Request_is_from__c='Commercial Medical';  
        meetRec.Performance_Guarantees__c = 'Yes';
        meetRec.Performance_Guarantees_Comments__c='Test Performance comment';
        meetRec.Client_Arrangement__c='Renewal - Growth Opportunity';
        meetRec.Sole_Carrier_or_Multi_Carriers__c='Sole Carrier';
        meetRec.Client_Drivers_Issues_Risks__c='Test';
        meetRec.Member_Customer_Service_Telephone__c='3534353453';        
        insert meetRec;
		
		// Insert Event
        SFDC_Volunteer_Event__c evntRec = new SFDC_Volunteer_Event__c();        
        evntRec.OE_Grouping__c = meetRec.Id;
        evntRec.bilingual__c = 'No';
        evntRec.Buddy_Program_Eligible__c = FALSE;
        evntRec.meeting_Street__c = '321 N Clark';
        evntRec.meeting_city__c = 'Chicago';
        evntRec.meeting_state__c = 'IL';
        evntRec.Session_1_Start_Time__c = 'N/A';
        evntRec.Session_1_End_Time__c = 'N/A';
        evntRec.Date__c = Date.today().addDays(1);
        evntRec.Recruitment_of_Facilitator_Needed__c='Yes';
        evntRec.Meeting_Type__c = 'Benefit Fair';
        evntRec.Expected_of_Employees__c = 100;
        evntRec.Dates_Flexible__c = true;
        evntRec.Meeting_Stage__c = 'SUBMITTED';
        evntRec.Local_Ambassador_Only__c = 'Yes';
        evntRec.Location__Latitude__s = 41.8882434;
        evntRec.Location__Longitude__s = -87.6328535;
        evntRec.Facilitator_Being_Recruited__c = true;
        evntRec.Recruit_Consultant__c = false;
        evntRec.Facilitator_Secured__c = true;              
        insert evntRec;
        
        //createEvents
		List<SFDC_Volunteer_Event__c> events = new List<SFDC_Volunteer_Event__c>();
        Integer dateCount = 0;
        integer count = 2;

        for(Integer i = 0; i < count; i++) {
            SFDC_Volunteer_Event__c volEvent = new SFDC_Volunteer_Event__c();            
            volEvent.Name='Test'+String.valueOf(i);
            volEvent.OE_Grouping__c = meetRec.Id;
            volEvent.bilingual__c = 'No';
            volEvent.Buddy_Program_Eligible__c = FALSE;
            volEvent.meeting_Street__c = '321 N Clark';
            volEvent.meeting_city__c = 'Chicago';
            volEvent.meeting_state__c = 'IL';
            volEvent.Session_1_Start_Time__c = 'N/A';
            volEvent.Session_1_End_Time__c = 'N/A';
            volEvent.Date__c = Date.today().addDays(dateCount);
            volEvent.Recruitment_of_Facilitator_Needed__c='Yes';
            volEvent.Meeting_Type__c = 'Benefit Fair';
            volEvent.Expected_of_Employees__c = 100;
            volEvent.Dates_Flexible__c = true;
            volEvent.Meeting_Stage__c = 'SUBMITTED';
            volEvent.Local_Ambassador_Only__c = 'Yes';
            volEvent.Location__Latitude__s = 41.8882434;
            volEvent.Location__Longitude__s = -87.6328535;
            volEvent.Facilitator_Being_Recruited__c = true;
            volEvent.Recruit_Consultant__c = false;
            volEvent.Facilitator_Secured__c = false;

            events.add(volEvent);
            dateCount += 1;
        }
        
        insert events;
        
    }
    @isTest
    public static void testOEAmbassadorNewVol() {
        
        //Go to Page
        PageReference pageRef = Page.OEAmbassadorOnBoardingSurvey;
        Test.setCurrentPage(pageRef);
        //instanciate new controller
        OEAMBOnBoardingSurveyController controller = new OEAMBOnBoardingSurveyController();
        //Test validation of new volunteer
        controller.NeworReturning('TRUE');
        controller.facName = 'Leslie Getman';
        system.assert(controller.showNewVol,'controller instantiated');
        system.assert(!controller.showReturnSurvey,'controller instantiated');
        system.assert(controller.showNotCleared,'controller instantiated');
    }
    @isTest
    static void testExistingOEAMB(){
       
        //instanciate new controller
        OEAMBOnBoardingSurveyController controller = new OEAMBOnBoardingSurveyController();        
        Account acctRec = [SELECT id, Name FROM Account WHERE Name='Test Company Name' LIMIT 1];        
        Contact conQuery = [SELECT id, FirstName, LastName,name, Email, Region_Location__c, bilingual__c
                            FROM Contact WHERE Email='tony_angle@msn.com' LIMIT 1];
        // Perform test
        //Set Parameters that would be passed in for existing ambassador
        controller.whichAmbassador(conQuery.Id, conQuery.Email);
        system.assertEquals('Tony', controller.ambassador.firstname,'Assertion success');
        system.assertNotEquals(null, conQuery.id,'Assertion not equals');
        system.assertEquals(system.today(), controller.dateUpdated,'Assertion success');
        //system.assertEquals('Leslie0 Getman0', controller.facName);
        //Go to Page
        PageReference pageRef = Page.OEAmbassadorOnBoardingSurvey;
        Test.setCurrentPage(pageRef);
        
    }
    @isTest
    static void textWithBadParameter(){
        OEAMBOnBoardingSurveyController controller = new OEAMBOnBoardingSurveyController();
        //Test invalid user
        controller.whichAmbassador('1234','2');
        
        system.assert(controller.showNotCleared,'Assertion success');
        system.assert(!controller.showReturnSurvey,'Assertion success'); 
        system.assertEquals(null, controller.facName,'Assertion success');
    }
    @isTest
    static Void callSubmitMethodExisting(){
       
        OEAMBOnBoardingSurveyController controller = new OEAMBOnBoardingSurveyController();
        // Create one one facilitator
        PageReference pageRef = Page.OEAmbassadorOnBoardingSurvey;       
        Account acctRec = [Select id, Name from Account where Name='Test Company Name' LIMIT 1];
        
        Contact conQuery = [Select id, FirstName, LastName,name, Email, Region_Location__c, bilingual__c
                            from Contact where Email='tony_angle@msn.com' LIMIT 1];
         controller.submitAmbassador();

        // Verify that the success page displays        
        system.assert(controller.showReturnSurvey,'Assertion success');
        system.assert(!controller.showThankYouAmb,'Assertion success');
        system.assert(!controller.showThankYouNew,'Assertion success');
        
    }
    @isTest
    static Void callSubmitNew(){
         OEAMBOnBoardingSurveyController controller = new OEAMBOnBoardingSurveyController();
        // Create one one facilitator
        PageReference pageRef = Page.OEAmbassadorOnBoardingSurvey;
        controller.showNewVol = TRUE;
         controller.submitAmbassador();     
        system.assert(!controller.showThankYouNew,'Assertion success');        
        system.assert(!controller.showNewVol,'Assertion success');        
        
    }
    @isTest
    static void testBackToMeeting() {
        Account acctRec = [Select id, Name from Account where Name='Test Company Name' LIMIT 1];        
        Contact conQuery = [Select id, FirstName, LastName,name, Email, Region_Location__c, bilingual__c
                            from Contact where Email='tony_angle@msn.com' LIMIT 1];        
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where Account__c=:acctRec.Id LIMIT 1];

         SFDC_Volunteer_Event__c oeRec = [Select id, name from SFDC_Volunteer_Event__c where Name='Test1' LIMIT 1];        
        PageReference pageRef = page.OEAmbassadorOnBoardingSurvey;        
        Test.setCurrentPage(pageRef);
        OEAMBOnBoardingSurveyController controller = new OEAMBOnBoardingSurveyController();         
        Test.startTest();
        controller.urlFacID = conQuery.Id;
        controller.urlEmail = conQuery.Email;
        controller.meetingId = oeRec.Id;
         
        system.assertEquals('tony_angle@msn.com', controller.urlEmail,'Assertion success');
        controller.backToMeeting();        
        Test.stopTest();
        
        
    }
    

        
}