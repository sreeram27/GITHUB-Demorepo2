/***************************************************************
    * Purpose:  Test class for VolunteerParticipantEmailServiceImpl
    * Mod:      6 December 2016
    * Author:   Martin Kona
    * Mehaboob: Lifted and Shifted from COM1 - PRDCRM-39696  
    ***************************************************************/

@isTest
public class VolunteerParticipantEmailServiceImplTest {

    public static final List<String> NOTIFICATION_USERS = new List<String>{'a@bluewolf.com','b@bluewolf.com','c@bluewolf.com'}; 
    public static final String COORDINATOR_EMAIL = 'mehaboobpasha.kallur@legatohealth.com';
    public static final String CONSULTANT_EMAIL = 'smita.ganiger@legatohealth.com';
    public static final String AMBASADDOR_EMAIL = 'rishav.kumar@legatohealth.com';

    @testSetup
    public static void initData() {

        initCustomSettings();
        Test.setMock(HttpCalloutMock.class, TravelResponseServiceTest.getDefaultBingGeocodeMock());

        Account acc = (Account)TestFactory.createSObject(new Account(name='Open Enrollment'), true);

        Contact consultant = 
            (Contact)TestFactory.createSObject(new Contact(accountId = acc.Id, email = CONSULTANT_EMAIL,
                Facilitator_Type__c = VolunteerParticipantEmailServiceImpl.CONSULTANT_TYPE), true);

        Contact ambassador = 
            (Contact)TestFactory.createSObject(new Contact(accountId = acc.Id, email = AMBASADDOR_EMAIL,
                Facilitator_Type__c = VolunteerParticipantEmailServiceImpl.OE_AMBASSADOR_TYPE), true);

        Contact coordinator = 
            (Contact)TestFactory.createSObject(new Contact(accountId = acc.Id, email = COORDINATOR_EMAIL,
                Facilitator_Type__c = VolunteerParticipantEmailServiceImpl.OE_COORDINATOR_TYPE), true);         

        Open_Enrollment_Meetings__c meeting = 
            (Open_Enrollment_Meetings__c)TestFactory.createSObject(
                new Open_Enrollment_Meetings__c(account__c = acc.Id, source__c = 'Central',Plan_Type__c='MED CDHP- HIA',
                    OE_Coordinator_Contact__c = coordinator.Id), true);

        SFDC_Volunteer_Event__c event = 
            (SFDC_Volunteer_Event__c)TestFactory.createSObject(
                new SFDC_Volunteer_Event__c(OE_Grouping__c = meeting.Id, name = 'Test Event', bilingual__c = 'No', Buddy_Program_Eligible__c = FALSE, Meeting_Type__c='Benefit Fair',Recruitment_of_Facilitator_Needed__c='Yes',
                OE_Coordinator_Contact__c=coordinator.Id,OE_Consultant_Lead__c=coordinator.Id,meeting_city__c = 'Poway', meeting_state__c = 'CA', Date__c = system.today()), true);                
        
        SFDC_Volunteer_Participant__c sp1 = 
            (SFDC_Volunteer_Participant__c)TestFactory.createSObject(
                new SFDC_Volunteer_Participant__c(OE_Ambassador_Volunteer__c = consultant.Id, Volunteer_Event__c = event.Id), true);

        SFDC_Volunteer_Participant__c sp2 = 
            (SFDC_Volunteer_Participant__c)TestFactory.createSObject(
                new SFDC_Volunteer_Participant__c(OE_Ambassador_Volunteer__c = ambassador.Id, Volunteer_Event__c = event.Id), true);            
    }

    @isTest
    public static void testNotificationUsers() {        

        VolunteerParticipantEmailServiceImpl service = new VolunteerParticipantEmailServiceImpl();

        System.assertEquals(NOTIFICATION_USERS, service.notificationUsers);
    }

    @isTest
    public static void testGetVolunteerInfo() {

        Set<Id> ids = new Map<Id, sObject>([select Id from SFDC_Volunteer_Participant__c]).keySet();

        VolunteerParticipantEmailServiceImpl service = new VolunteerParticipantEmailServiceImpl();
        List<SFDC_Volunteer_Participant__c> participants = service.getVolunteerInfo(ids);

        system.assert(ids.size() > 1);
        system.assertEquals(ids.size(), participants.size());

        for (SFDC_Volunteer_Participant__c part : participants) {
            system.assertNotEquals(part.Volunteer_Event__r.Name, NULL);
            system.assertNotEquals(part.Volunteer_Event__r.OE_Coordinator_Contact__r.Email, NULL);
            system.assertNotEquals(part.Volunteer_Event__r.Date__c, NULL);
            system.assertNotEquals(part.OE_Ambassador_Volunteer__r.FirstName, NULL);
            system.assertNotEquals(part.OE_Ambassador_Volunteer__r.LastName, NULL);
            system.assertNotEquals(part.OE_Ambassador_Volunteer__r.Facilitator_Type__c, NULL);          
        }
    }

    @isTest
    public static void testGetVolunteerInfo_ValidationException() {

    }   

    @isTest
    public static void testConfigureEmailMessages_Ambassador() {

        Set<Id> ids = 
            new Map<Id, sObject>(getTestParticipants(
                VolunteerParticipantEmailServiceImpl.OE_AMBASSADOR_TYPE)).keySet();

        VolunteerParticipantEmailServiceImpl service = new VolunteerParticipantEmailServiceImpl();
        List<SFDC_Volunteer_Participant__c> participants = service.getVolunteerInfo(ids);

        List<Messaging.SingleEmailMessage> msgs = 
            service.configureEmailMessages(participants);

        system.assert(msgs.size() > 0);

        for (Messaging.SingleEmailMessage msg : msgs) {
            system.assert(msg.toAddresses.size() == 1);
            System.assertEquals(msg.toAddresses[0], COORDINATOR_EMAIL);
        }

    }

    @isTest
    public static void testConfigureEmailMessages_Consultant() {
        
        Set<Id> ids = 
            new Map<Id, sObject>(getTestParticipants(
                VolunteerParticipantEmailServiceImpl.CONSULTANT_TYPE)).keySet();

        VolunteerParticipantEmailServiceImpl service = new VolunteerParticipantEmailServiceImpl();
        List<SFDC_Volunteer_Participant__c> participants = service.getVolunteerInfo(ids);

        List<Messaging.SingleEmailMessage> msgs = 
            service.configureEmailMessages(participants);

        system.assert(msgs.size() > 0);

        for (Messaging.SingleEmailMessage msg : msgs) {
            system.assertEquals(NOTIFICATION_USERS.size(),msg.toAddresses.size());      
        }
    }

    @isTest
    public static void testInitBodyHTML() {

        Set<Id> ids = 
            new Map<Id, sObject>(getTestParticipants(
                VolunteerParticipantEmailServiceImpl.CONSULTANT_TYPE)).keySet();

        VolunteerParticipantEmailServiceImpl service = new VolunteerParticipantEmailServiceImpl();
        List<SFDC_Volunteer_Participant__c> participants = service.getVolunteerInfo(ids);

        system.assert(participants.size() > 0);

        for (SFDC_Volunteer_Participant__c part : participants) {
            String htmlBody = service.initBodyHTML(part);

            system.assertNotEquals(htmlBody, NULL);
        }       

    }   

    public static List<SFDC_Volunteer_Participant__c> getTestParticipants(String facilitatorType) {

        List<SFDC_Volunteer_Participant__c> volunteers = [select id, 
                Volunteer_Event__r.Name, Volunteer_Event__r.OE_Coordinator_Contact__r.Email,  
                Volunteer_Event__r.Date__c, OE_Ambassador_Volunteer__r.FirstName, 
                OE_Ambassador_Volunteer__r.LastName,OE_Ambassador_Volunteer__r.Facilitator_Type__c 
                from SFDC_Volunteer_Participant__c
                where OE_Ambassador_Volunteer__r.Facilitator_Type__c = :facilitatorType];

        return volunteers;      
    }   

    public static void initCustomSettings() {

        List<Enrollment_user_notification__c> settings = new List<Enrollment_user_notification__c>();

        for (String email : NOTIFICATION_USERS) {
            Enrollment_user_notification__c eun = new Enrollment_user_notification__c();
            eun.Name = 'Name: ' + email;
            eun.email__c = email;

            settings.add(eun);
        }
   
        insert settings;
    }   

}