/***************************************************************
* Purpose:  Test for controller for signup form
* Mod:     6/25/2014
* Author:  Tony Angle
* Mod 5/7/2015
*     Modified to add new required fields to OEAMB-LG
* 
* Mod 12/
* Mod 7/19/16
*     Modified EAmbSignupTest(), testEditProfileRedirect(), GetsomeMeetings().
*     New added getTravelDistance_correctResponse().
* July-2019: Fixed for OE - XMen.
* @description :Also provides test coverage for OpenEnrollmentTrigger, OpenEnrollmentTriggerHandler and OpenEnrollmentTriggerHelper

**************************************************************************

* Mod                      : 9/12/2019
* @Author               : Mehaboob
* @description    :  Modified Test class as part of PRDCRM-41975 and PRDCRM-43038.
* Mod                      : 11/12/2019
* @Author               : X-Men : DK
* @description    :  Modified Test class as part of PRDCRM-44820.
***************************************************************/

@isTest
public class OEAmbSignupControllerTest {    
    @testSetup
    static void testDataMethod() {  
        Test.setMock(HttpCalloutMock.class, New MockBingTravelResponse());
        Id contactFacRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();    
        //Insert account
        List<Account> accountList = new List<Account>();
        accountList =TestDataFactory.createAccountSICList(2,'Test Company Name','CA street','CA','CA State','12345','US','CAA');
        insert accountList;         
        
        List<Account> oeAccountList = new List<Account>();
        oeAccountList =TestDataFactory.createAccountSICList(1,'Open Enrollment','CA street','CA','CA State','12345','US','CAA');
        insert oeAccountList;         
        
        List<Contact> contactList=new List<Contact>();        
        contactList = TestDataFactory.createContact(2,'test','Test4',oeAccountList[0],contactFacRecTypeId,'OE Coordinator','Central','test@test.com',true,0,0);
        insert contactList;  
        
        List<Contact> contactConsultant=new List<Contact>();        
        contactConsultant = TestDataFactory.createContact(2,'test','TestConsultant',oeAccountList[0],contactFacRecTypeId,'Consultant','Central','consultant@test.com',true,0,0);
        insert contactConsultant; 
        
        List<Open_Enrollment_Meetings__c> oemeetingRec = new List<Open_Enrollment_Meetings__c>();
        oemeetingRec = TestDataFactory.createOpenEnrollmentMeeting(1,'Test123',accountList[0],'Georgia',contactList[0],UtilConstants.Plan_Type,'Commercial Medical','Yes','Test Performance comment','Renewal - Growth Opportunity','Sole Carrier','Test tally fields','3534353453',UtilConstants.Dress_Code_for_Event);
        insert oemeetingRec;
        
        List<Open_Enrollment_Meetings__c> oemeetingRec2 = new List<Open_Enrollment_Meetings__c>();
        oemeetingRec2 = TestDataFactory.createOpenEnrollmentMeeting(1,'Test1234',accountList[0],'Georgia',contactList[1],UtilConstants.Plan_Type,'Commercial Medical','Yes','Test Performance comment','Renewal - Growth Opportunity','Sole Carrier','Test tally fields','3534353453',UtilConstants.Dress_Code_for_Event);        
        insert oemeetingRec2;
        
        List<SFDC_Volunteer_Event__c> oeRecList = new List<SFDC_Volunteer_Event__c>();
        oeRecList = TestDataFactory.createOpenEnrollment(1,'StageStatusOE',oemeetingRec[0],'No',FALSE,'321 N Clark','Chicago','IL','60654','12:00 AM','12:30 AM',System.Today(),'No',UtilConstants.Meeting_Type,100,true,'DRAFT','Yes',41.8882434,-87.6328535,true,false,false,accountList[0],'New Request',contactList[0]);        
        insert oeRecList;
    }
    
    @isTest 
    static void oeAmbSignupTest(){    
        PageReference pageRef = Page.OE_Amb_Signup;
        Test.setCurrentPage(pageRef);
        OEAmbSignupController controller = new OEAmbSignupController();                 
        
        Contact conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                            from Contact where LastName='Test4' limit 1];        
        
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where OE_Coordinator_Contact__c =: conQuery.id
                                              AND Request_is_from__c='Commercial Medical'];       
        User usr = [Select id from User where Id = :UserInfo.getUserId()];       
        
        System.RunAs(usr){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, TravelResponseServiceTest.getDefaultBingGeocodeMock());
            SFDC_Volunteer_Event__c oeRec = [Select id, name from SFDC_Volunteer_Event__c where OE_Grouping__c=:meetRec.id];       
            
            system.assertNotEquals(null, conQuery.Id,'');
            
            Boolean userBilingual;
            SFDC_Volunteer_Participant__c volunteerP = new SFDC_Volunteer_Participant__c();       
            controller.selectedContact=conQuery.Id;
            controller.userRegions=conQuery.Region_Location__c;
            userBilingual=conQuery.bilingual__c;          
            controller.volComments = 'Comments';
            controller.selectedMeeting = oeRec;        
            controller.BuddyProgramResponse='No';
            controller.relatedMeetingsAreSet=true;
            controller.isRelatedMeetings=true;
            controller.volunteer();            
                        
            system.assert(!controller.showMgrApproval,'Manager Approval');            
            system.assert(controller.isPersonCleared(conQuery.Id, conQuery.email),'Contact Email');
            system.assert(!controller.isPersonCleared('testID','testEmail' ),'Email');
            
            controller.personCleared = TRUE;
            ApexPages.currentPage().getParameters().put('meetingId', oeRec.Id);
            controller.selectMeeting();
            
            ApexPages.currentPage().getParameters().put('Email', 'tony_angle@msn.com');
            ApexPages.currentPage().getParameters().put('facID', conQuery.Id);            
            
            controller.mapit();
            controller.returntoList();
            controller.getBuddyOptions();
            controller.backToSearch();
            controller.StateorRegion = 'Urgent';
            controller.SearchMeetingName='Test';
            controller.BuddyProgramResponse = 'No';
            controller.SortAsc=true;
            controller.personCleared=true;
            controller.getSortOptions();
            controller.selectedMeeting=oeRec;
            controller.showMeeting=true;
            controller.relatedMeetingsAreSet=true;            
            Test.stopTest();
        }        
    }
    
    @isTest
    static void oeAmbSignupTest2(){        
        PageReference pageRef = Page.OE_Amb_Signup;
        Test.setCurrentPage(pageRef);
        OEAmbSignupController controller = new OEAmbSignupController();         
        
        Account acctRec = [Select id, Name from Account where Name='Test Company Name 0'];       
        Contact oeCord = [Select id, name, Email, Region_Location__c, bilingual__c
                          from Contact where Email='test@test.com' limit 1]; 
        Contact conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                            from Contact where Email='test@test.com' limit 1];         
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where Account__c=:acctRec.Id AND OE_Coordinator_Contact__c=:oeCord.Id];       
        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, TravelResponseServiceTest.getDefaultBingGeocodeMock());
            SFDC_Volunteer_Event__c oeRec = [Select id, name,OE_Grouping__c from SFDC_Volunteer_Event__c where OE_Grouping__c=:meetRec.id];       
            system.assertNotEquals(null, conQuery.Id,'Contact Id');
            
            Boolean userBilingual;
            SFDC_Volunteer_Participant__c volunteerP = new SFDC_Volunteer_Participant__c(); 
            controller.relatedMeetingsAreSet=true;      
            controller.selectedContact=conQuery.Id;
            controller.userRegions=conQuery.Region_Location__c;
            userBilingual=conQuery.bilingual__c;          
            controller.volComments = 'Comments';
            controller.selectedMeeting = oeRec;        
            controller.BuddyProgramResponse='No';
            
            List<SFDC_Volunteer_Event__c> oeList=New List<SFDC_Volunteer_Event__c>();
            oeList.add(oeRec);            
            try{
                controller.getUpdatedRelatedMeetings();
            }Catch(Exception e){
                System.debug('exception :'+e.getMessage());
            }
            controller.volunteer();
            
            system.assert(!controller.showMgrApproval,'Manager Approval');            
            system.assert(controller.isPersonCleared(conQuery.Id, conQuery.email),'Contact Email');
            system.assert(!controller.isPersonCleared('testID','testEmail' ),'Email');
            
            controller.personCleared = TRUE;
            ApexPages.currentPage().getParameters().put('meetingId', oeRec.Id);
            controller.selectMeeting();            
            ApexPages.currentPage().getParameters().put('Email', 'tony_angle1@msn.com');
            ApexPages.currentPage().getParameters().put('facID', conQuery.Id);
            controller.mapit();
            controller.returntoList();
            controller.getBuddyOptions();
            controller.backToSearch();
            controller.StateorRegion = 'Urgent';
            controller.SearchMeetingName='Test2';
            controller.BuddyProgramResponse = 'No';
            controller.SortAsc=true;
            controller.personCleared=true;
            controller.getSortOptions();
            controller.selectedMeeting=oeRec;
            controller.showMeeting=true;
            controller.relatedMeetingsAreSet=true;
            Test.stopTest();
        }        
    }
    
    @isTest 
    static void oeHasTriggerRun(){       
        Test.setMock(HttpCalloutMock.class, New MockBingTravelResponse());        
        Account acctRec = [Select id, Name from Account where Name='Test Company Name 0'];       
        Contact conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                            from Contact where Email='test@test.com' limit 1];                
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where Account__c=:acctRec.Id and OE_Coordinator_Contact__c=:conQuery.Id
                                              AND Request_is_from__c='Commercial Medical'];       
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
            SFDC_Volunteer_Event__c oeRec = [Select id, name from SFDC_Volunteer_Event__c where OE_Grouping__c=:meetRec.id limit 1];                   
            system.assertNotEquals(null, conQuery.Id,'Contact Id');            
            Boolean hasTriggerRun;
            oeRec.Meeting_Street__c = '351 S Studio Dr, Lake Buena Vista';
            oeRec.Meeting_Zip_Code__c = '32830';
            oeRec.Meeting_State__c = 'FL';
            update oeRec;                  
            Test.stopTest();
        }        
    }
    
    @isTest
    public static Void openTheSearch(){
        User usr = [Select id from User where Id = :UserInfo.getUserId()];        
        System.RunAs(usr){
            Test.startTest();
            TravelResponseService.TravelResponse responseBody = TravelResponseServiceTest.createGoogleResponseSuccess('Atlanta', 'Chicago', '150', '7550');
            Test.setMock(HttpCalloutMock.class, New SingleRequestMock(200, TravelResponseService.SUCCESS_STATUS,JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));
            
            OEAmbSignupController controller = new OEAmbSignupController();
            PageReference p=controller.openSearch();
            Test.stopTest();
            System.assertEquals(p,null,'Null Expected');             
        }
    }
    
    @isTest
    public static Void getTheRegions(){
        OEAmbSignupController controller = new OEAmbSignupController();
        controller.relatedMeetingsAreSet=true;
        controller.relatedMeetingsAreSet=true;
        controller.isConsultant = true;
        controller.personCleared = true;
        controller.userRegions = 'Central;Wellness Kit';
        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];       
        
        Test.startTest();
        List<SelectOption> options = controller.getRegions();
        Test.stopTest();        
        Set<String> regions = new Set<String>();
        for(SelectOption option : options) {
            regions.add(option.getValue());
        }
        System.assert(!regions.isEmpty(), 'This should not be empty');
        System.assert(regions.contains('Central'), 'This should contain the user region');
        System.assert(regions.contains('Urgent Central'), 'This should contain the user region + Urgent');
        System.assert(regions.contains('Wellness Kit'), 'This should contains wellness kit');
        System.assert(!regions.contains('Urgent'), 'This should not contains Urgent');
        System.assert(!regions.contains('Urgent Wellness Kit'), 'This should not contain Urgent Wellness Kit');
    }
    
    @isTest    
    public static void testEditProfileRedirect() {        
        String email = 'test@test.com';
        String emailExpected = 'test%40test.com'; // @ changed to %40 by encoding
        Contact conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                            from Contact where Email='test@test.com' limit 1];        
        System.assertNotEquals(null, conQuery.Id,'Contact Id');
        
        ApexPages.currentPage().getParameters().put('Email', email);
        ApexPages.currentPage().getParameters().put('facID', conQuery.Id);
        
        OEAmbSignupController controller = new OEAmbSignupController();       
        
        String editPageURL = controller.editProfile().getUrl();
        String expectedURL = '/apex/oeambassadoronboardingsurvey?email=' + 
            emailExpected + '&facId=' + conQuery.Id;
        
        System.assertEquals(expectedURL, editPageURL,'Page Url');                
    }
    
    @isTest    
    public static void testEditProfileRedirect2() {
        
        String email = 'test@test.com';
        String emailExpected = 'test%40test.com'; // @ changed to %40 by encoding
        Contact conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                            from Contact where Email='test@test.com' limit 1];        
        System.assertNotEquals(null, conQuery.Id,'Contact Id');
        
        ApexPages.currentPage().getParameters().put('Email', email);
        ApexPages.currentPage().getParameters().put('facID', conQuery.Id);        
        OEAmbSignupController controller = new OEAmbSignupController();       
        
        String editPageURL = controller.editProfile().getUrl();
        String expectedURL = '/apex/oeambassadoronboardingsurvey?email=' + 
            emailExpected + '&facId=' + conQuery.Id;        
        System.assertEquals(expectedURL, editPageURL,'Page Url');                
    }
    
    /* *************
@comment : Method providing meetings to Consultant and Non Consultants .
*********** */     
    public static void getsomeMeetings(Boolean cons) {
        Contact conQuery = New contact();
        if(cons){
            conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                        from Contact where Facilitator_Type__c= 'Consultant' AND Email='consultant@test.com' limit 1];
        } else {            
            conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                        from Contact where Facilitator_Type__c= 'OE Coordinator' AND Email='test@test.com' limit 1];
        }
        OEAmbSignupController controller = new OEAmbSignupController();
        controller.selectedContact = conQuery.id;
        controller.relatedMeetingsAreSet=true;
        controller.StateorRegion = 'Urgent';
        controller.isConsultant = cons;
        //Date
        controller.SortBy = 'Date__c';
        controller.SortAsc = True;
        controller.getMeetings();
        controller.SortAsc = FALSE;
        controller.getMeetings();
        //Meeting_State__c
        controller.SortBy = 'Meeting_State__c';
        controller.SortAsc = True;
        controller.getMeetings();
        controller.SortAsc = FALSE;
        controller.getMeetings();
        //Meeting_City__c
        controller.SortBy = 'Meeting_City__c';
        controller.SortAsc = True;
        controller.getMeetings();
        controller.SortAsc = FALSE;
        controller.getMeetings();        
        //Meeting Type
        controller.SortBy = 'Meeting_Type__c';
        controller.SortAsc = True;
        controller.getMeetings();
        controller.SortAsc = FALSE;
        controller.getMeetings();
        //Something else
        controller.SortBy = 'SomethingElse';
        controller.SortAsc = True;
        controller.getMeetings();
        controller.SortAsc = FALSE;
        controller.getMeetings();
        //state or region null
        controller.StateorRegion = null;
        controller.getMeetings();
        
        OEAmbSignupController controller2 = new OEAmbSignupController();
        controller2.selectedContact = conQuery.id;
        controller2.relatedMeetingsAreSet=true;
        controller2.StateorRegion = 'Buddy Eligible';        
        controller2.isConsultant = cons;
        //Date
        controller2.SortBy = 'Date__c';
        controller2.SortAsc = True;
        controller2.getMeetings();
        controller2.SortAsc = FALSE;
        controller2.getMeetings();
        //Meeting_State__c
        controller2.SortBy = 'Meeting_State__c';
        controller2.SortAsc = True;
        controller2.getMeetings();
        controller2.SortAsc = FALSE;
        controller2.getMeetings();
        //Meeting_City__c
        controller2.SortBy = 'Meeting_City__c';
        controller2.SortAsc = True;
        controller2.getMeetings();
        controller2.SortAsc = FALSE;
        controller2.getMeetings();
        
        OEAmbSignupController controller3 = new OEAmbSignupController();
        controller3.selectedContact = conQuery.id;
        controller3.relatedMeetingsAreSet=true;
        controller3.StateorRegion = 'GRS';
        controller3.isConsultant = cons;
        //Date
        controller3.SortBy = 'Date__c';
        controller3.SortAsc = True;
        controller3.SortAsc = FALSE;
        //Meeting_State__c
        controller3.SortBy = 'Meeting_State__c';
        controller3.SortAsc = True;
        controller3.SortAsc = FALSE;
        controller3.SortBy = 'Meeting_City__c';
        controller3.SortAsc = True;
        controller3.SortAsc = FALSE;
        
        try{
            controller3.getMeetings();
        }Catch(Exception e){
            System.debug('exception :'+e.getMessage());
        }
        
        OEAmbSignupController controller4 = new OEAmbSignupController();
        controller4.selectedContact = conQuery.id;
        controller4.relatedMeetingsAreSet=true;
        controller4.StateorRegion = 'Specialty/Voluntary';
        controller4.isConsultant = cons;
        //Date
        controller4.SortBy = 'Date__c';
        controller4.SortAsc = True;
        controller4.SortAsc = FALSE;
        //Meeting_State__c
        controller4.SortBy = 'Meeting_State__c';
        controller4.SortAsc = True;
        controller4.SortAsc = FALSE;
        controller4.SortBy = 'Meeting_City__c';
        controller4.SortAsc = True;
        controller4.SortAsc = FALSE;
        
        try{
            controller4.getMeetings();
        }Catch(Exception e){
            System.debug('exception :'+e.getMessage());
        }
        
        
        OEAmbSignupController controller5 = new OEAmbSignupController();
        controller5.selectedContact = conQuery.id;
        controller5.relatedMeetingsAreSet=true;
        controller5.StateorRegion = 'Virtual (Webinar)';
        controller5.isConsultant = cons;
        //Date
        controller5.SortBy = 'Date__c';
        controller5.SortAsc = True;
        controller5.SortAsc = FALSE;
        //Meeting_State__c
        controller5.SortBy = 'Meeting_State__c';
        controller5.SortAsc = True;
        controller5.SortAsc = FALSE;
        controller5.SortBy = 'Meeting_City__c';
        controller5.SortAsc = True;
        controller5.SortAsc = FALSE;
        
        try{
            controller5.getMeetings();
        }Catch(Exception e){
            System.debug('exception :'+e.getMessage());
        }        
    }
    
    @isTest
    public static Void getSomeMeetingsNotConsultant(){
        getsomeMeetings(false);   
        OEAmbSignupController controller = new OEAmbSignupController();
        System.assertEquals(controller.StateorRegion,null,'Should be null as we are not setting stateRegion here');
    }
    @isTest
    public static Void getSomeMeetingsConsultant(){
        getsomeMeetings(true);
        OEAmbSignupController controller = new OEAmbSignupController();
        System.assertEquals(controller.StateorRegion,null,'Should be null as we are not setting stateRegion here');
    }  
    
    @isTest
    public static Void getTravelDistanceCorrectResponse() {
        
        TravelResponseServiceTest.setGoogleAPIKey();
        TravelResponseService.TravelResponse responseBody = TravelResponseServiceTest.createGoogleResponseSuccess('Atlanta', 'Chicago', '150', '7550');
        LocationResponseParser responseBodyLocation = TravelResponseServiceTest.createBingGeoLocationResponseSuccess(10.0.doubleValue(),10.0.doubleValue());
        MultiRequestMock multiMock = new MultiRequestMock();
        
        multiMock.addRequestMock(TravelResponseService.GOOGLE_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'}));
        multiMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseBodyLocation), new Map<String, String> {'Content-Type'=> 'application/json'} ));
        Test.setMock(HttpCalloutMock.class, multiMock);
        
        OEAmbSignupController controller = new OEAmbSignupController(); 
        Account acctRec = [Select id, Name from Account where Name='Test Company Name 0'];
        Contact oeCord = [Select id, name, Email, Region_Location__c, bilingual__c
                          from Contact where Email='test@test.com' limit 1]; 
        Contact conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                            from Contact where FirstName='test' limit 1];           
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where Account__c=:acctRec.Id AND OE_Coordinator_Contact__c=:oeCord.Id];
        List<SFDC_Volunteer_Event__c> evntRec = [Select id,Meeting_Comments__c, name, OE_Grouping__c, Meeting_Street__c, Meeting_City__c,
                                                 Meeting_State__c,Meeting_Zip_Code__c,Date__c from SFDC_Volunteer_Event__c 
                                                 where OE_Grouping__c=: meetRec.Id ];                   
        
        controller.personContact = TestingUtils.createContacts(1, acctRec.Id, true)[0];
        controller.selectedMeeting = evntRec[0];          
        try{
            controller.getUpdatedRelatedMeetings();
        }Catch(Exception e){
            System.debug('exception :'+e.getMessage());
        }
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        System.RunAs(usr){
            test.startTest();
            controller.getTravelDistance();
            test.stopTest();    
        }               
    }
    @isTest
    public static Void getTravelDistanceIncorrectResponse(){        
        TravelResponseServiceTest.setGoogleAPIKey();
        TravelResponseService.TravelResponse responseBody = TravelResponseServiceTest.createGoogleResponseError('Atlanta', 'Chicago', 'INVALID_RESPONSE');
        LocationResponseParser responseBodyLocation = TravelResponseServiceTest.createBingGeoLocationResponseSuccess(10.0.doubleValue(),10.0.doubleValue());
        MultiRequestMock multiMock = new MultiRequestMock();
        
        multiMock.addRequestMock(TravelResponseService.GOOGLE_ENDPOINT, new SingleRequestMock(400, 'INVALID_RESPONSE',JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'}));
        multiMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseBodyLocation), new Map<String, String> {'Content-Type'=> 'application/json'} ));
        Test.setMock(HttpCalloutMock.class, multiMock);
        // test an invalid response from Google API Distance Service
        OEAmbSignupController controller = new OEAmbSignupController(); 
        Account acctRec = [Select id, Name from Account where Name='Test Company Name 0'];
        Contact oeCord = [Select id, name, Email, Region_Location__c, bilingual__c
                          from Contact where Email='test@test.com' limit 1]; 
        Contact conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                            from Contact where FirstName = 'test' limit 1]; 
        // Insert new meeting        
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where Account__c=:acctRec.Id AND OE_Coordinator_Contact__c=:oeCord.Id];
        //AND Request_is_from__c='Group Retiree Solutions'];                  
        
        List<SFDC_Volunteer_Event__c> evntRec = [Select id,Meeting_Comments__c, name, OE_Grouping__c, Meeting_Street__c, Meeting_City__c,
                                                 Meeting_State__c,Meeting_Zip_Code__c from SFDC_Volunteer_Event__c 
                                                 where OE_Grouping__c=: meetRec.Id];                 
        try{
            controller.getUpdatedRelatedMeetings();
        }Catch(Exception e){
            System.debug('exception :'+e.getMessage());
        }       
        
        // create new contact       
        controller.personContact = TestingUtils.createContacts(1, acctRec.Id, true)[0];
        controller.selectedMeeting = evntRec[0];
        controller.StateorRegion = 'Not';      
        
        ApexPages.currentPage().getParameters().put('meetingId', evntRec[0].Id);       
        
        String distance='19357';
        OEAmbSignupController.RelatedMeetingWrapper rmw=new OEAmbSignupController.RelatedMeetingWrapper(evntRec[0],distance);
        List<OEAmbSignupController.RelatedMeetingWrapper> rmwList=new List<OEAmbSignupController.RelatedMeetingWrapper>();
        rmwList.add(rmw);
        controller.meetingWrappers=rmwList;
        controller.getRelatedMeetingWrappers();
        controller.getDisabledTravel();
        controller.getValidResponse();
        controller.getRelatedMeetings();
        controller.disDurEvent=NULL;
        controller.isInMap=true;        
        
        CalloutException exc = (CalloutException) CalloutException.class.newInstance();
        exc.setMessage('Exception error!');
        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        System.RunAs(usr){
            test.startTest();
            controller.getTravelDistance();
            test.stopTest();
        }    
    }
    
    @isTest
    public static void getRelatedMeetingsForDistanceTest() {
        List<TravelResponseParser.Result> results = new List<TravelResponseParser.Result>();
        final Integer NUM_EVENTS_TO_CREATE = 3;
        
        for(Integer i = 0; i < NUM_EVENTS_TO_CREATE; i++){
            TravelResponseParser.Result result = new TravelResponseParser.Result();
            result.travelDistance = 100;
            result.travelDuration = 100;
            results.add(result);
        }
        
        TravelResponseParser responseParser = TravelResponseServiceTest.createBingTravelResponseSuccess(results);
        LocationResponseParser responseBody = TravelResponseServiceTest.createBingGeoLocationResponseSuccess(10.0.doubleValue(),10.0.doubleValue());
        
        MultiRequestMock multiMock = new MultiRequestMock();
        
        multiMock.addRequestMock(TravelResponseService.BING_DISTANCE_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseParser), new Map<String, String> {'Content-Type'=> 'application/json'}));
        multiMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));
        Test.setMock(HttpCalloutMock.class, multiMock);
        
        OEAmbSignupController controller = new OEAmbSignupController();
        Account acctRec = [Select id, Name from Account where Name='Test Company Name 0'];
        Contact oeCord = [Select id, name, Email, Region_Location__c, bilingual__c
                          from Contact where Email='test@test.com' limit 1]; 
        Contact conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                            from Contact where Email='test@test.com' limit 1]; 
        // Insert new meeting s       
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where Account__c=:acctRec.Id AND OE_Coordinator_Contact__c=:oeCord.Id];        
        
        List<SFDC_Volunteer_Event__c> evntRec = [Select id, Meeting_Comments__c,name, OE_Grouping__c, Meeting_Street__c, Meeting_City__c,
                                                 Meeting_State__c,Meeting_Zip_Code__c from SFDC_Volunteer_Event__c 
                                                 where OE_Grouping__c=: meetRec.Id];    
        controller.personContact = TestingUtils.createContacts(1, acctRec.Id, true)[0];        
        try{
            controller.getUpdatedRelatedMeetings();
        }Catch(Exception e){
            System.debug('exception :'+e.getMessage());
        }
        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        System.RunAs(usr){
            Test.startTest();
            ApexPages.currentpage().getParameters().put('meetingId', evntRec[0].Id);
            
            controller.isConsultant = false;
            controller.selectMeeting();
            Test.stopTest();
        }
        List<OEAmbSignupController.RelatedMeetingWrapper> relatedMeetingWrappers = controller.meetingWrappers;
        System.assertEquals(0, relatedMeetingWrappers.size(), 'relatedMeetingWrapper count should be one less than total meetings created');
    } 
    
    @isTest
    private static void testOEUpdates(){
        List<SFDC_Volunteer_Event__c> oeList=[select id,Name,Meeting_Stage__c,Meeting_Status__c,Submit__c,Meeting_Cancelled__c,Materials_Needed__c,Meeting_Contact__c,Contact_Phone_Number__c,Recruitment_of_Facilitator_Needed__c from SFDC_Volunteer_Event__c where Name=:'StageStatusOE0' limit 1];
        System.debug('oeList goes here eeeeee---->'+oeList.size()+ ''+oeList);
        Test.startTest();
        oeList[0].Meeting_Cancelled__c=true;
        oeList[0].Submit__c=true;
        oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
        oeList[0].Meeting_Contact__c='Test contact user';
        oeList[0].Contact_Phone_Number__c='1234567890';
        oeList[0].Recruitment_of_Facilitator_Needed__c='No';        
        update oeList;
        
        oeList[0].Reason_for_Update__c='Date Change';
        oeList[0].Date__c=System.Today()-10;        
        update oeList;
        
        oeList[0].Reason_for_Update__c='Session times change';
        update oeList;
        
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
        oeList[0].Facilitator_Being_Recruited__c=false;
        oeList[0].Facilitator_Secured__c=true;
        oeList[0].Waiting_on_Feedback__c=false;
        oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
        oeList[0].Facilitator_Feedback_Received__c=true;
        oeList[0].Unable_to_secure_facilitator__c=false;
        oeList[0].Submit__c=true;
        oeList[0].Materials_Order_On_Standby__c=false;
        oeList[0].Materials_Order_placed__c=false;
        oeList[0].Materials_Delivered__c=false;
        oeList[0].Meeting_Cancelled__c=false;        
        update oeList;       
        
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
        oeList[0].Facilitator_Being_Recruited__c=false;
        oeList[0].Facilitator_Secured__c=true;
        oeList[0].Waiting_on_Feedback__c=true;
        oeList[0].Feedback_Not_Received_Within_14_Days__c=true;
        oeList[0].Facilitator_Feedback_Received__c=false;
        oeList[0].Unable_to_secure_facilitator__c=false;
        oeList[0].Submit__c=true;
        oeList[0].Materials_Order_On_Standby__c=false;
        oeList[0].Materials_Order_placed__c=false;
        oeList[0].Materials_Delivered__c=false;
        oeList[0].Meeting_Cancelled__c=false;        
        update oeList;
        
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
        oeList[0].Facilitator_Being_Recruited__c=false;
        oeList[0].Facilitator_Secured__c=true;
        oeList[0].Waiting_on_Feedback__c=true;
        oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
        oeList[0].Facilitator_Feedback_Received__c=false;
        oeList[0].Unable_to_secure_facilitator__c=false;
        oeList[0].Submit__c=true;
        oeList[0].Materials_Order_On_Standby__c=false;
        oeList[0].Materials_Order_placed__c=false;
        oeList[0].Materials_Delivered__c=false;
        oeList[0].Meeting_Cancelled__c=false;        
        update oeList;       
        
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
        oeList[0].Facilitator_Being_Recruited__c=true;
        oeList[0].Submit__c=true;
        oeList[0].Facilitator_Secured__c=false;
        oeList[0].Unable_to_secure_facilitator__c=false;
        oeList[0].Waiting_on_Feedback__c=false;
        oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
        oeList[0].Facilitator_Feedback_Received__c=false;
        oeList[0].Materials_Order_On_Standby__c=false;
        oeList[0].Materials_Order_placed__c=false;
        oeList[0].Materials_Delivered__c=false;
        oeList[0].Meeting_Cancelled__c=false;        
        update oeList;     
        
        oeList[0].Date__c=System.TODAY() - 10;
        oeList[0].Meeting_Stage__c='SUBMITTED';        
        update oeList;
        
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='Promo only needed ';
        oeList[0].Facilitator_Being_Recruited__c=false;
        oeList[0].Unable_to_secure_facilitator__c=true;
        oeList[0].Materials_Order_On_Standby__c=false;
        oeList[0].Materials_Order_placed__c=true;
        oeList[0].Materials_Delivered__c=true;
        oeList[0].Submit__c=true;        
        update oeList;       
        
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='Promo only needed';
        oeList[0].Facilitator_Being_Recruited__c=false;
        oeList[0].Unable_to_secure_facilitator__c=true;
        oeList[0].Materials_Order_On_Standby__c=false;
        oeList[0].Materials_Order_placed__c=true;
        oeList[0].Materials_Delivered__c=false;
        oeList[0].Submit__c=true;        
        update oeList;
                
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='Promo only needed';
        oeList[0].Facilitator_Being_Recruited__c=false;
        oeList[0].Facilitator_Secured__c=true;
        oeList[0].Waiting_on_Feedback__c=false;
        oeList[0].Facilitator_Feedback_Received__c=true;
        oeList[0].Materials_Order_On_Standby__c=true;
        oeList[0].Materials_Order_placed__c=true;
        oeList[0].Materials_Delivered__c=true;
        oeList[0].Submit__c=true;        
        update oeList;
                
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='Promo only needed';
        oeList[0].Facilitator_Being_Recruited__c=false;
        oeList[0].Facilitator_Secured__c=true;
        oeList[0].Waiting_on_Feedback__c=false;
        oeList[0].Feedback_Not_Received_Within_14_Days__c=true;
        oeList[0].Materials_Order_placed__c=true;
        oeList[0].Materials_Delivered__c=true;
        oeList[0].Submit__c=true;
        oeList[0].Facilitator_Feedback_Received__c=false;        
        update oeList;        
        
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='Promo only needed';
        oeList[0].Facilitator_Being_Recruited__c=false;
        oeList[0].Waiting_on_Feedback__c=true;
        oeList[0].Materials_Order_placed__c=true;
        oeList[0].Materials_Delivered__c=true;
        oeList[0].Submit__c=true;        
        update oeList;
                
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='Promo only needed';
        oeList[0].Facilitator_Being_Recruited__c=false;
        oeList[0].Unable_to_secure_facilitator__c=true;
        oeList[0].Materials_Order_On_Standby__c=true;
        oeList[0].Submit__c=true;        
        update oeList;
                
        oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
        oeList[0].Materials_Needed__c='Promo only needed';
        oeList[0].Facilitator_Being_Recruited__c=false;
        oeList[0].Facilitator_Secured__c=true;
        oeList[0].Waiting_on_Feedback__c=true;
        oeList[0].Materials_Order_On_Standby__c=false;
        oeList[0].Materials_Order_placed__c=true;
        oeList[0].Submit__c=true;        
        update oeList;
        Test.stopTest();
    }
}