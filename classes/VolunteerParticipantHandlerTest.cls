/***************************************************************
  * Purpose:  Test class for VolunteerParticipantHandler
  * Mod:     6 December 2016
  * Author:  Martin Kona
  * Mehaboob: Lifted and Shifted from COM1 - PRDCRM-39696
***************************************************************/

@isTest
public with sharing class VolunteerParticipantHandlerTest {
  
  public static final String COORDINATOR_EMAIL = 'coordinator@bluewolf.com';
  public static final Integer NUM_OF_PARTICIPANTS = 1;

  @isTest
  public static void testSendEmail() {
    Test.setMock(HttpCalloutMock.class, TravelResponseServiceTest.getDefaultBingGeocodeMock());


    VolunteerParticipantHandler handler = new VolunteerParticipantHandler();


    Messaging.SendEmailResult[] results = handler.sendEmail(createParticipants());


    system.assertEquals(NUM_OF_PARTICIPANTS, results.size());

    for (Messaging.SendEmailResult result : results) {
      system.assert(result.isSuccess());      
    }
        
  }
  
  public static Map<Id, SFDC_Volunteer_Participant__c> createParticipants() {

    Account acc = (Account)TestFactory.createSObject(new Account(name='Open Enrollment'), true);

    List<Contact> ambassadors = new List<Contact>();

    for (Integer i = 0; i < NUM_OF_PARTICIPANTS; i++) {

      Contact ambassador = 
        (Contact)TestFactory.createSObject(new Contact(accountId = acc.Id, 
          Facilitator_Type__c = VolunteerParticipantEmailServiceImpl.OE_AMBASSADOR_TYPE));  

      ambassadors.add(ambassador);
    }

    insert ambassadors;

    Contact coordinator = 
      (Contact)TestFactory.createSObject(new Contact(accountId = acc.Id, email = COORDINATOR_EMAIL,
        Facilitator_Type__c = VolunteerParticipantEmailServiceImpl.OE_COORDINATOR_TYPE), true);    
    

    Open_Enrollment_Meetings__c meeting = 
      (Open_Enrollment_Meetings__c)TestFactory.createSObject(
        new Open_Enrollment_Meetings__c(account__c = acc.Id, source__c = 'Central', Plan_Type__c='MED CDHP- HIA',
                  OE_Coordinator_Contact__c = coordinator.Id), true);

    SFDC_Volunteer_Event__c event = 
      (SFDC_Volunteer_Event__c)TestFactory.createSObject(
        new SFDC_Volunteer_Event__c(OE_Grouping__c = meeting.Id, name = 'Test Event', bilingual__c = 'No', Buddy_Program_Eligible__c = FALSE,Meeting_Type__c='Benefit Fair',Recruitment_of_Facilitator_Needed__c='Yes',
        meeting_city__c = 'Poway', meeting_state__c = 'CA', Date__c = system.today()), true);                
        
    List<SFDC_Volunteer_Participant__c> participants = new List<SFDC_Volunteer_Participant__c>();

    for (Contact ambas : ambassadors) {
      SFDC_Volunteer_Participant__c sp = 
        (SFDC_Volunteer_Participant__c)TestFactory.createSObject(
          new SFDC_Volunteer_Participant__c(OE_Ambassador_Volunteer__c = ambas.Id, Volunteer_Event__c = event.Id));

      participants.add(sp);
    }

    insert participants;


    return new Map<Id, SFDC_Volunteer_Participant__c>(participants);    
  }  


}