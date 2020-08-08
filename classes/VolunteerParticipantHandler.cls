/***************************************************************
    * Purpose:  Handler class for SFDCVolunteerParticipant_AfterInsert trigger
    * Mod:      6 December 2016
    * Author:   Martin Kona
    * Mehaboob: Lifted and Shifted from COM1 - PRDCRM-39696
    ***************************************************************/

public class VolunteerParticipantHandler {

    VolunteerParticipantEmailService service;

    @TestVisible
    private VolunteerParticipantHandler(VolunteerParticipantEmailService mockService) {
        this.service = mockService;
    }

    public VolunteerParticipantHandler() {
        this(new VolunteerParticipantEmailServiceImpl());
    }

    public Messaging.SendEmailResult[] sendEmail(Map<Id, SFDC_Volunteer_Participant__c> triggerNewMap) {

        // generate set of Ids
        Set<Id> ids = triggerNewMap.keySet();
        
        // get volunteer related informations records
        List<SFDC_Volunteer_Participant__c> volunteers = service.getVolunteerInfo(ids);

        // configure email messages
        List<Messaging.SingleEmailMessage> msgs = service.configureEmailMessages(volunteers);

        // send email messages
        Messaging.SendEmailResult[] results = Messaging.sendEmail(msgs);    

        return results; 
    }   
}