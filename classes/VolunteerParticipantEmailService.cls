/***************************************************************
    * Purpose:  Interface class, which is inherited by VolunteerParticipantEmailServiceImpl
    * Mod:      6 December 2016
    * Author:   Martin Kona
    * Mehaboob: Lifted and Shifted from COM1 - PRDCRM-39696  
    ***************************************************************/

public interface VolunteerParticipantEmailService {

    // info must contain first name, last name, eventCoordinator, volunteertype, eventDate
    List<SFDC_Volunteer_Participant__c> getVolunteerInfo(Set<Id> volunteerParticipantIds);

    List<Messaging.SingleEmailMessage> configureEmailMessages(List<SFDC_Volunteer_Participant__c> emailParameters);

    // build HTML body
    String initBodyHTML(SFDC_Volunteer_Participant__c bodyParameters);
}