/**************************************************************************************
@description : Test Class for OEAmbFeedbackController. Lifted and shifted from COM1
@Author               : X-men Offshore
US                        :  Modified Test class as part of PRDCRM-41975
*************************************************************************************
@description : Modified test class as part of Stroy PRDCRM-43215 to add best practices
@author      : Mehaboob
****************************************************************************************/
@isTest
private class OEAmbFeedbackControllerTest {
    /***************************************************************
    * Purpose:  Test for controller for feedback form
    * Mod:      6/25/2014
    * Author:   Tony Angle
    * Mod       4/25/2015 - LG added more test  
    ***************************************************************/
    public static Account acct;
    public static User usr;
    public static Open_Enrollment_Meetings__c openEnrollment;
    public static SFDC_Volunteer_Event__c event;
    public static final String COORDINATOREMAIL='coordintor@bluewolf.com';
    
   /**
    * @description : added description tag as part of PRDCRM-41975
    */
    public static void setup() {
        Test.setMock(HttpCalloutMock.class, TravelResponseServiceTest.getDefaultBingGeocodeMock());
        acct = (Account) SObjectFactory.create(Account.SObjectType);
        System.debug('Account values'+acct.id);
        Contact coordinator=(Contact)TestFactory.createSObject(new Contact(accountID=acct.id,email=COORDINATOREMAIL,Facilitator_Type__c='OE Coordinator'),true);
      
        List<Open_Enrollment_Meetings__c> oemeetingRec = new List<Open_Enrollment_Meetings__c>();
        oemeetingRec = TestDataFactory.createOpenEnrollmentMeeting(1,'Test123',acct,'Georgia',coordinator,UtilConstants.Plan_Type,'Commercial Medical','Yes','Test Performance comment','Renewal - Growth Opportunity','Sole Carrier','Test tally fields','3534353453',UtilConstants.Dress_Code_for_Event);
        insert oemeetingRec;
       
        List<SFDC_Volunteer_Event__c> oeRecList = new List<SFDC_Volunteer_Event__c>();
        oeRecList = TestDataFactory.createOpenEnrollment(1,'Test123',oemeetingRec[0],'No',FALSE,'321 N Clark','Chicago','IL','60654','12:00 AM','12:30 AM',System.Today(),'No',UtilConstants.Meeting_Type,100,true,'DRAFT','Yes',41.8882434,-87.6328535,true,false,false,acct,'New Request',coordinator);        
        insert oeRecList;
        
        Test.setCurrentPage(new PageReference('Page.OE_Amb_Feedback'));
        ApexPages.currentPage().getParameters().put('MeetingID', oeRecList[0].Id);
    }
    
    static testMethod void whoIsCallingTest(){
        setup();
        OEAmbFeedbackController oafc=new OEAmbFeedbackController();
        Contact oeaRec = TestDataOEAMBFacilitator.createNewFacilitators(1)[0];
        Contact oeaRec2 = [Select id, email from Contact where id = :oeaRec.id];     
        ApexPages.currentPage().getParameters().put('Email', oeaRec2.Email);
        ApexPages.currentPage().getParameters().put('FacID', OeaRec2.Id);
        string facName;
        
        Test.startTest();
            facName = oafc.whoIsCalling();
        Test.stopTest();

        System.assertEquals('Not Available', facName, 'This should Not have any failitator records');
    }
    
    static testMethod void whoIsCallingTestFacRecord(){
        setup();
        Contact oeaRec = TestDataOEAMBFacilitator.createNewFacilitators(1)[0];
        Contact oeaRec2 = [Select id, email from Contact where id = :oeaRec.id];     
        ApexPages.currentPage().getParameters().put('Email', oeaRec2.Email);
        ApexPages.currentPage().getParameters().put('FacID', OeaRec2.Id);
        string facName;
        
        Test.startTest();
            OEAmbFeedbackController oafc=new OEAmbFeedbackController();
            facName = oafc.whoIsCalling();
        Test.stopTest();
      
        System.assertEquals(oeaRec2.Email ,'leslie.getman@wellpoint.com' ,'This should have any user records');
        System.assertEquals(facName,'Leslie0 Getman0','Contact first name and Last name who is calling' );
    }
    
    static testMethod void whoIsCallingTestNoUserRecord(){
        setup();
        usr = (User) SObjectFactory.create(User.SObjectType);
        OEAmbFeedbackController oafc=new OEAmbFeedbackController();
        ApexPages.currentPage().getParameters().put('UserId', usr.Id);
        string usrName;
        
        Test.startTest();
            usrName = oafc.whoIsCalling();
        Test.stopTest();

        System.assertEquals('Not Available', usrName, 'This should Not have any user records');
    }
    
    static testMethod void whoIsCallingTestUserRecord(){
        setup();
        usr = (User) SObjectFactory.create(User.SObjectType);
        ApexPages.currentPage().getParameters().put('UserId', usr.Id);
        string usrName;
        
        Test.startTest();
            OEAmbFeedbackController oafc=new OEAmbFeedbackController();
            usrName = oafc.whoIsCalling();
        Test.stopTest();

        System.assertEquals(usr.FirstName+' '+usr.LastName, usrName, 'This should have any user records');
    }

    static testMethod void whatMeetingTest(){
        setup();
        string meetingName;
        OEAmbFeedbackController oafc=new OEAmbFeedbackController();
        Contact oeaRec = TestDataOEAMBFacilitator.createNewFacilitators(1)[0];
        Contact oeaRec2 = [Select id, email from Contact where id = :oeaRec.id];        
        ApexPages.currentPage().getParameters().put('Email', oeaRec2.Email);
        ApexPages.currentPage().getParameters().put('FacID', OeaRec2.Id);
       
        Test.startTest();
            meetingName = oafc.whatMeeting();
        Test.stopTest();
        
        System.assertEquals(oeaRec2.Email ,'leslie.getman@wellpoint.com' ,'This should have any user records');
        System.assertEquals(meetingName,'Test1230','Open Enrollment Name from whatMeeting' );
    }

    static testMethod void voidSubmitFeedback() {
        setup();
        OEAmbFeedbackController oafc=new OEAmbFeedbackController();
        Contact oeaRec = TestDataOEAMBFacilitator.createNewFacilitators(1)[0];
        Contact oeaRec2 = [Select id, email from contact where id = :oeaRec.id];        
        ApexPages.currentPage().getParameters().put('Email', oeaRec2.Email);
        ApexPages.currentPage().getParameters().put('FacID', OeaRec2.Id);

        Test.startTest();
            oafc.submitFeedback();
        Test.stopTest();

        System.assert(!oafc.showSurvey, 'This should be not be show the survey');
        System.assert(oafc.showThankYou, 'This should show thanky you');
    }
}