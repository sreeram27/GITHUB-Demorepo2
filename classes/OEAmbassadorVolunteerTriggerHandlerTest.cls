/**************************************************************************************
@description : Test Class for OEAmbassadorVolunteerActions
@Author               : X-men Offshore
US                    : PRDCRM-30730 . Modified Test class as part of PRDCRM-41975
*************************************************************************************/
/**************************************************************************
* Mod 				  : 10/24/2019
* @Author             : Poonam Goturi - xmen
* @description		  : As part of PRDCRM-43212, added TestDataFactory reference (Xmen)
*************************************************************************************/

@isTest
public class OEAmbassadorVolunteerTriggerHandlerTest {
    public static final String COORDINATOR_EMAIL = 'coordinator@test.com';
    
    @testSetup
    static void setupTestData(){
        Test.setMock(HttpCalloutMock.class, New MockBingTravelResponse());
        
        Id conrtID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        Id accrtID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        
		//Insert Account records
        List<Account> accRec = new List<Account>();
        Account accOeRec = new Account();
        accOeRec.Name = 'Open Enrollment';
        accOeRec.Anthem_Entity__c = 'National Accounts';
        accOeRec.Region__c = 'Central';
        accRec.add(accOeRec);
        insert accRec;
        
        Account acc = (Account)TestFactory.createSObject(new Account(name='Open Enrollment'), true);
        
        List<Contact> ambassadors = new List<Contact>();
        Contact ambassador = 
        (Contact)TestFactory.createSObject(new Contact(accountId = acc.Id,Facilitator_Type__c = VolunteerParticipantEmailServiceImpl.OE_AMBASSADOR_TYPE));
        insert ambassador;
          
        Contact coordinator = (Contact)TestFactory.createSObject(new Contact(accountId = acc.Id, email = COORDINATOR_EMAIL,Facilitator_Type__c = VolunteerParticipantEmailServiceImpl.OE_COORDINATOR_TYPE), true); 
        
        //Insert contact records
		List<Contact> conRec = new List<Contact>();
        conRec = TestDataFactory.createContact(1,'Tony','Test1',accRec[0],conrtID,'OE Ambassador','Central','test22@test.com',true,-1,-1);
        insert conRec;
        
		List<Contact> conRec1 = new List<Contact>();
        conRec1 = TestDataFactory.createContact(1,'Tony','Test2',accRec[0],conrtID,'OE Ambassador','Central','test11@test.com',true,NULL,NULL);
        insert conRec1;
        
		List<Contact> conRec5 = new List<Contact>();
        conRec5 = TestDataFactory.createContact(1,'Tony','Test3',accRec[0],conrtID,'OE Ambassador','Central','test55@test.com',true,NULL,NULL);
        insert conRec5;
        
		List<Contact> conRec6=new List<Contact>();
        conRec6 = TestDataFactory.createContact(1,'test','Test4',accRec[0],conrtID,'OE Coordinator','Central','test@test.com',true,0,0);
        insert conRec6;
        
        //Insert OE meeting record
		List<Open_Enrollment_Meetings__c> oemeetingRec = new List<Open_Enrollment_Meetings__c>();
        oemeetingRec = TestDataFactory.createOpenEnrollmentMeeting(1,'Test123',accRec[0],'Georgia',conRec6[0],UtilConstants.Plan_Type,'Commercial Medical','Yes','Test Performance comment','Renewal - Growth Opportunity','Sole Carrier','Test tally fields','3534353453',UtilConstants.Dress_Code_for_Event);
        insert oemeetingRec;
        
        //Insert Open Enrollment record
		List<SFDC_Volunteer_Event__c> oeRec = new List<SFDC_Volunteer_Event__c>();
        oeRec = TestDataFactory.createOpenEnrollment(1,'Test123',oemeetingRec[0],'No',FALSE,'321 N Clark','Chicago','IL','60654','N/A','N/A',System.Today(),'No',UtilConstants.Meeting_Type,100,true,'DRAFT','Yes',41.8882434,-87.6328535,true,false,false,accRec[0],'New Request',conRec6[0]);
        insert oeRec;
        
        Open_Enrollment_Meetings__c meeting =(Open_Enrollment_Meetings__c)TestFactory.createSObject(new Open_Enrollment_Meetings__c(account__c = acc.Id, source__c = 'Central', Plan_Type__c='MED CDHP- HIA',OE_Coordinator_Contact__c = coordinator.Id), true);

        SFDC_Volunteer_Event__c event = (SFDC_Volunteer_Event__c)TestFactory.createSObject(new SFDC_Volunteer_Event__c(OE_Grouping__c = meeting.Id, name = 'Test Event', bilingual__c = 'No', Buddy_Program_Eligible__c = FALSE,Meeting_Type__c='Benefit Fair',Recruitment_of_Facilitator_Needed__c='Yes',meeting_city__c = 'Poway', meeting_state__c = 'CA', Date__c = system.today()), true);                
        
        List<SFDC_Volunteer_Participant__c> participants = new List<SFDC_Volunteer_Participant__c>();
        
        SFDC_Volunteer_Participant__c sp = (SFDC_Volunteer_Participant__c)TestFactory.createSObject(new SFDC_Volunteer_Participant__c(OE_Ambassador_Volunteer__c = ambassador.Id, Volunteer_Event__c = event.Id));
        insert sp;
       
		//Insert OE Ambassador Volunteer records
		List<SFDC_Volunteer_Participant__c> oeVolunteer2 = new List<SFDC_Volunteer_Participant__c>();
        oeVolunteer2 = TestDataFactory.createOEAmbassadorVolunteer(1,oeRec[0],conRec[0],true,true);
        insert oeVolunteer2;
        
		List<SFDC_Volunteer_Participant__c> oeAmbUpdateList1 = new List<SFDC_Volunteer_Participant__c>();
        oeAmbUpdateList1 = [select id,Selected_For_Facilitator__c,Thanks_but_No_Thanks__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__r.id =: conRec[0].id LIMIT 1];
        oeAmbUpdateList1 [0].Thanks_but_No_Thanks__c = false;
		Update oeAmbUpdateList1;
        
		List<SFDC_Volunteer_Participant__c> oeVolunteer10 = new List<SFDC_Volunteer_Participant__c>();
        oeVolunteer10 = TestDataFactory.createOEAmbassadorVolunteer(1,oeRec[0],conRec5[0],false,false);
        insert oeVolunteer10;
        
		List<SFDC_Volunteer_Participant__c> oeAmbUpdateList2 = new List<SFDC_Volunteer_Participant__c>();
        oeAmbUpdateList2 = [select id,Selected_For_Facilitator__c,Thanks_but_No_Thanks__c from SFDC_Volunteer_Participant__c where (OE_Ambassador_Volunteer__r.id =: conRec5[0].id and Selected_For_Facilitator__c = false and Thanks_but_No_Thanks__c = false) LIMIT 1];
        oeAmbUpdateList2[0].Selected_For_Facilitator__c = true;
        oeAmbUpdateList2[0].Thanks_but_No_Thanks__c = true;
        Update oeAmbUpdateList2;
        
		List<SFDC_Volunteer_Participant__c> oeVolunteer = new List<SFDC_Volunteer_Participant__c>();
        oeVolunteer = TestDataFactory.createOEAmbassadorVolunteer(1,oeRec[0],conRec1[0],false,false);
        insert oeVolunteer;
        
		List<SFDC_Volunteer_Participant__c> oeVolunteer7 = new List<SFDC_Volunteer_Participant__c>();
        oeVolunteer7 = TestDataFactory.createOEAmbassadorVolunteer(1,oeRec[0],conRec1[0],true,true);
        insert oeVolunteer7;
        
		List<Contact> contactUpdateList = new List<Contact>();
        contactUpdateList = [select id,OE_Amb_No_Thanks_Current_Year_Tally__c ,OE_Amb_Selected_Current_Year_Tally__c from Contact where id =: conRec5[0].id LIMIT 1];
        contactUpdateList[0].OE_Amb_No_Thanks_Current_Year_Tally__c = -2;
        contactUpdateList[0].OE_Amb_Selected_Current_Year_Tally__c = -2;
        update contactUpdateList;
        
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
               
        List<SFDC_Volunteer_Participant__c> oeVolDelete10 = [select id from SFDC_Volunteer_Participant__c where id =: oeVolunteer10[0].id];
        delete oeVolDelete10;
        
        Test.StopTest();
        System.assertEquals(null,oeVolunteer10[0].Selected_for_Facilitator_Tally__c , 'selected fac tally should be null as we have initialised with NULL ,thus no modification from OE amb records ');
        System.assertEquals(-1,conRec[0].OE_Amb_Selected_Current_Year_Tally__c, 'selected current year tally should should get update after change in OE amb volunteer');
    }    
       static testMethod void testMethodAccExec(){
           Test.startTest();
           OEAmbassadorVolunteerActions obj = new OEAmbassadorVolunteerActions();
           List<SFDC_Volunteer_Participant__c> oeAmbVolList= [select id,Selected_For_Facilitator__c,Thanks_but_No_Thanks__c from SFDC_Volunteer_Participant__c limit 1];
           System.assertEquals(oeAmbVolList[0].Selected_For_Facilitator__c,true,'Selected for facilator expected true');
           System.assertEquals(oeAmbVolList[0].Thanks_but_No_Thanks__c ,false,'Thanks but no thanks expected false');
           Test.StopTest();
       }
}