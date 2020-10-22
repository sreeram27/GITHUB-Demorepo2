/***************************************************************
  * Purpose:  Service class for sending emails to event coordinators, if someone volunteers
  * Mod:     6 December 2016
  * Author:  Martin Kona
  * Mehaboob: Lifted and Shifted from COM1 - PRDCRM-39696
  ***************************************************************/

public class VolunteerParticipantEmailServiceImpl implements VolunteerParticipantEmailService {

  public static final String CONSULTANT_TYPE = 'Consultant';
  public static final String OE_AMBASSADOR_TYPE = 'OE Ambassador';
  public static final String OE_COORDINATOR_TYPE = 'OE Coordinator';
  
  public static final String EMAIL_FROM = 'donotreply@wellpoint.com';
  public static final String EMAIL_SUBJECT = 'Volunteer Submitted';
  public static final String SENDER_DISPLAY_NAME = 'Open Enrollment Ambassador Program';

  @TestVisible
  private List<String> notificationUsers {
    get {
      if (notificationUsers == NULL) {
        notificationUsers = new List<String>();
        List<Enrollment_user_notification__c> mcs = Enrollment_user_notification__c.getall().values();

        for (Enrollment_user_notification__c mc : mcs) {
          notificationUsers.add(mc.Email__c);
        }
      }

      return notificationUsers;
    }
    set;
  }


  public List<SFDC_Volunteer_Participant__c> getVolunteerInfo(Set<Id> volunteerParticipantIds) {

    List<SFDC_Volunteer_Participant__c> volunteers = [select id, 
        Volunteer_Event__r.Name, Volunteer_Event__r.OE_Coordinator_Contact__r.Email,
        Volunteer_Event__r.Date__c, OE_Ambassador_Volunteer__r.FirstName, 
        OE_Ambassador_Volunteer__r.LastName,OE_Ambassador_Volunteer__r.Facilitator_Type__c 
        from SFDC_Volunteer_Participant__c 
      where id IN :volunteerParticipantIds];

    // validation of records?

    return volunteers;
  }

  public List<Messaging.SingleEmailMessage> configureEmailMessages(List<SFDC_Volunteer_Participant__c> emailParameters) {

    List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();

    for (SFDC_Volunteer_Participant__c emailParameter : emailParameters) {

      Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();

      // if consultant, then notify users from custom setting
      if (emailParameter.OE_Ambassador_Volunteer__r.Facilitator_Type__c == CONSULTANT_TYPE) {
        msg.setToAddresses(notificationUsers);
      } else {
        msg.setToAddresses(
          new List<String>{emailParameter.Volunteer_Event__r.OE_Coordinator_Contact__r.Email});
      }

      msg.setReplyTo(EMAIL_FROM);
      msg.setSubject(EMAIL_SUBJECT);
      msg.setSenderDisplayName(SENDER_DISPLAY_NAME);
      msg.setHtmlBody(initBodyHTML(emailParameter));

      msgs.add(msg);
    }

    return msgs;
  }

  public String initBodyHTML(SFDC_Volunteer_Participant__c bodyParameters) {

    String formattedDate=String.valueOf(bodyParameters.Volunteer_Event__r.Date__c);
    formattedDate=formattedDate.substring(0,10);

    String strBody = 'You have a new volunteer for one of your meetings. The details is listed below. <br/><br/>';
      strBody = strBody + '<table width=900px>';
      strBody = strBody + '<tr><td width=15% bgcolor=silver><b>Meeting</b></td><td width=85%>' 
      + bodyParameters.Volunteer_Event__r.Name + '</td></tr>';
      strBody = strBody + '<tr><td width=15% bgcolor=silver><b>Date</b></td><td width=85%>' 
      + formattedDate+'</td></tr>';
      strBody = strBody + '<tr><td width=15% bgcolor=silver><b>Volunteer</b></td><td width=85%>' 
      + bodyParameters.OE_Ambassador_Volunteer__r.FirstName + ' ' 
      + bodyParameters.OE_Ambassador_Volunteer__r.LastName + '</td></tr>';
      strBody = strBody + '</tr></table><br/>';
      strBody = strBody + 'Thank You<br/><br/>';
      strBody = strBody + 'The Open Enrollment Team';  

    return strBody;
  }

  public class MyException extends Exception {}
}