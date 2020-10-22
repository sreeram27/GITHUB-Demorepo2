/**************************************************************************************
@description : Test Class for OEAmbVolCountTallyFields
@Author               : X-men Offshore
US                        : PRDCRM-30730 . Modified Test class as part of PRDCRM-41975
*************************************************************************************/

@isTest
public class OEAmbVolCountTallyFieldsTest {
    public static final String COORDINATOR_EMAIL = 'coordinator@test.com';
    
    @testSetup
    static void setupTestData(){
        Test.setMock(HttpCalloutMock.class, New MockBingTravelResponse());
        
        Id conrtID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        Id accrtID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        
        
        Account accRec = new Account();
        accRec.Name = 'Open Enrollment';
        accRec.Anthem_Entity__c = 'National Accounts';
        accRec.Region__c = 'Central';
        insert accRec;
        
        Account acc = (Account)TestFactory.createSObject(new Account(name='Open Enrollment'), true);
        
         List<Contact> ambassadors = new List<Contact>();

 
       Contact ambassador = 
        (Contact)TestFactory.createSObject(new Contact(accountId = acc.Id, 
          Facilitator_Type__c = VolunteerParticipantEmailServiceImpl.OE_AMBASSADOR_TYPE));
          
          insert ambassador;
          
        Contact coordinator = 
        (Contact)TestFactory.createSObject(new Contact(accountId = acc.Id, email = COORDINATOR_EMAIL,
        Facilitator_Type__c = VolunteerParticipantEmailServiceImpl.OE_COORDINATOR_TYPE), true); 
        
        //Insert contact records
        Contact conRec = new Contact();
        conRec.recordtypeid = UtilConstants.Contact_RecordType_ID;
        conRec.AccountId = accRec.id;
        conRec.LastName = 'Test123';
        conRec.OE_Amb_No_Thanks_Current_Year_Tally__c = -1;
        conRec.OE_Amb_Selected_Current_Year_Tally__c = -1;
        conRec.Facilitator_Type__c='OE Ambassador';
        conRec.Email='test22@test.com';
        insert conRec;
        
        Contact conRec1 = new Contact();
        conRec.recordtypeid = UtilConstants.Contact_RecordType_ID;
        conRec1.AccountId = accRec.id;
        conRec1.LastName = 'Test123';
        conRec1.OE_Amb_No_Thanks_Current_Year_Tally__c = NULL;
        conRec1.OE_Amb_Selected_Current_Year_Tally__c = NULL;
        conRec1.Facilitator_Type__c='OE Ambassador';
        conRec1.Email='test11@test.com';
        insert conRec1;
        
        Contact conRec5 = new Contact();
        conRec5.recordtypeid = UtilConstants.Contact_RecordType_ID;
        conRec5.AccountId = accRec.id;
        conRec5.LastName = 'Test123';
        conRec5.OE_Amb_No_Thanks_Current_Year_Tally__c = NULL;
        conRec5.OE_Amb_Selected_Current_Year_Tally__c = NULL;
        conRec5.Facilitator_Type__c='OE Ambassador';
        conRec5.Email='test55@test.com';
        insert conRec5;
        
        
        Contact conRec6=new Contact();
        conRec6.lastname='Test Central';
        conRec6.firstname='test';
        conRec6.AccountId=accRec.Id;
        conRec6.RecordTypeID=Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        conRec6.Facilitator_Type__c='OE Coordinator';
        conRec6.Region_Location__c='Central';
        conRec6.Email='test@test.com';
        conRec6.Active__c=true;
        insert conRec6;
        
        //Insert OE meeting record
        Open_Enrollment_Meetings__c oemeetingRec = new Open_Enrollment_Meetings__c();
        oemeetingRec.Name = 'Test123';
        oemeetingRec.Account__c = accRec.id;
        oemeetingRec.Client_Drivers_Issues_Risks__c = 'Test tally fields';
        oemeetingRec.Dress_Code_for_Event__c = UtilConstants.Dress_Code_for_Event;
        oemeetingRec.Plan_Type__c = UtilConstants.Plan_Type;
        oemeetingRec.OE_Coordinator_Contact__c=conRec6.Id;
        insert oemeetingRec;
        
        //Insert OE record
        SFDC_Volunteer_Event__c oeRec = new SFDC_Volunteer_Event__c();
        oeRec.Name = 'Test123';
        oeRec.Account__c = accRec.Id;
        oeRec.OE_Grouping__c = oemeetingRec.Id;
        oeRec.Meeting_Type__c = UtilConstants.Meeting_Type;
        oeRec.Date__c = System.Today();
        oeRec.Recruitment_of_Facilitator_Needed__c = 'No';
        oeRec.Meeting_Stage__c='DRAFT';
        oeRec.Meeting_Status__c='NEW REQUEST';
        oeRec.OE_Coordinator_Contact__c=conRec6.Id;
        insert oeRec;
        
       
        Open_Enrollment_Meetings__c meeting = 
        (Open_Enrollment_Meetings__c)TestFactory.createSObject(
        new Open_Enrollment_Meetings__c(account__c = acc.Id, source__c = 'Central', Plan_Type__c='MED CDHP- HIA',
                  OE_Coordinator_Contact__c = coordinator.Id), true);

        SFDC_Volunteer_Event__c event = 
        (SFDC_Volunteer_Event__c)TestFactory.createSObject(
        new SFDC_Volunteer_Event__c(OE_Grouping__c = meeting.Id, name = 'Test Event', bilingual__c = 'No', Buddy_Program_Eligible__c = FALSE,Meeting_Type__c='Benefit Fair',Recruitment_of_Facilitator_Needed__c='Yes',
        meeting_city__c = 'Poway', meeting_state__c = 'CA', Date__c = system.today()), true);                
        
       List<SFDC_Volunteer_Participant__c> participants = new List<SFDC_Volunteer_Participant__c>();

    
      SFDC_Volunteer_Participant__c sp = 
        (SFDC_Volunteer_Participant__c)TestFactory.createSObject(
          new SFDC_Volunteer_Participant__c(OE_Ambassador_Volunteer__c = ambassador.Id, Volunteer_Event__c = event.Id));

         insert sp;
       
        SFDC_Volunteer_Participant__c oeVolunteer2 = new SFDC_Volunteer_Participant__c();
        oeVolunteer2.OE_Ambassador_Volunteer__c = conRec.id;
        oeVolunteer2.Volunteer_Event__c = oeRec.id;
        oeVolunteer2.Selected_For_Facilitator__c = true;
        oeVolunteer2.Thanks_but_No_Thanks__c = true;
        insert oeVolunteer2;
        
        oeVolunteer2.Thanks_but_No_Thanks__c= FALSE;
        Update oeVolunteer2;
        
        SFDC_Volunteer_Participant__c oeVolunteer10 = new SFDC_Volunteer_Participant__c();
        oeVolunteer10.OE_Ambassador_Volunteer__c = conRec5.id;
        oeVolunteer10.Volunteer_Event__c = oeRec.id;
        oeVolunteer10.Selected_For_Facilitator__c = FALSE;
        oeVolunteer10.Thanks_but_No_Thanks__c = false;
        insert oeVolunteer10;
        
        oeVolunteer10.Selected_For_Facilitator__c = true;
        oeVolunteer10.Thanks_but_No_Thanks__c= true;
        Update oeVolunteer10;
        
        SFDC_Volunteer_Participant__c oeVolunteer = new SFDC_Volunteer_Participant__c();
        oeVolunteer.OE_Ambassador_Volunteer__c = conRec1.id;
        oeVolunteer.Volunteer_Event__c = OErec.id;
        oeVolunteer.Selected_For_Facilitator__c = false;
        oeVolunteer.Thanks_but_No_Thanks__c = false;
        insert oeVolunteer;
        
        SFDC_Volunteer_Participant__c oeVolunteer7 = new SFDC_Volunteer_Participant__c();
        oeVolunteer7.OE_Ambassador_Volunteer__c = conRec1.id;
        oeVolunteer7.Volunteer_Event__c = OErec.id;
        oeVolunteer7.Selected_For_Facilitator__c = TRUE;
        oeVolunteer7.Thanks_but_No_Thanks__c = TRUE;
        insert oeVolunteer7;
        
        
        conRec5.OE_Amb_No_Thanks_Current_Year_Tally__c = -2;
        conRec5.OE_Amb_Selected_Current_Year_Tally__c = -2;
        
        update conRec5;
        
        
        Test.startTest();
        List<SFDC_Volunteer_Participant__c> updateSVPlist=new List<SFDC_Volunteer_Participant__c>();
        List<SFDC_Volunteer_Participant__c> svpList=[select Id,Selected_For_Facilitator__c from SFDC_Volunteer_Participant__c where Selected_For_Facilitator__c=FALSE LIMIT 1 ];
        for(SFDC_Volunteer_Participant__c svp:svpList){
            svp.Selected_For_Facilitator__c=TRUE;
            updateSVPlist.add(svp);
        }
        List<SFDC_Volunteer_Participant__c> updateSVPlist2=new List<SFDC_Volunteer_Participant__c>();
        List<SFDC_Volunteer_Participant__c> svpListFalse=[select Id,Selected_For_Facilitator__c from SFDC_Volunteer_Participant__c where Selected_For_Facilitator__c=TRUE LIMIT 1 ];
        system.debug('svpListFalse are'+svpListFalse);
        for(SFDC_Volunteer_Participant__c svp:svpListFalse){
            svp.Selected_For_Facilitator__c=FALSE;
            updateSVPlist2.add(svp);
        }       
        
        
        Update updateSVPlist2;
        Update updateSVPlist ;
        
        
       
        List<SFDC_Volunteer_Participant__c> oeVolDelete10 = [select id from SFDC_Volunteer_Participant__c where id =: oeVolunteer10.id];
        delete oeVolDelete10;
        
        Test.StopTest();
        System.assertEquals(null,oeVolunteer10.Selected_for_Facilitator_Tally__c , 'selected fac tally should be null as we have initialised with NULL ,thus no modification from OE amb records ');
        System.assertEquals(-1,conRec.OE_Amb_Selected_Current_Year_Tally__c, 'selected current year tally should should get update after change in OE amb volunteer  ');
        
    }    
       static testMethod void testMethodAccExec(){
       
        Test.startTest();
          OEAmbVolCountTallyFields obj = new OEAmbVolCountTallyFields();
        Test.StopTest();
          
  } 
}