public with sharing class emailHandler { 
  /**************************************************************
  * Purpose:  Mail handler for transactional email sends
  * Mod:     6/15/2014
  * Author:  Tony Angle
  ***************************************************************/
  public void sendMail(String strTo,String strFrom,String strSubject,String strBody){
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    String[] toAddresses = new String[] {strTo};
    
    mail.setToAddresses(toAddresses);
    mail.setReplyTo(strFrom);
    mail.setSenderDisplayName('Open Enrollment Ambassador Program');
    
    mail.setSubject(strSubject);
    mail.setHtmlBody(strBody);
    
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
  }
  
}