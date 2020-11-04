@isTest
public with sharing class emailHandlerTest2 {
    /**************************************************************
    * Purpose:  Test Mail handler for transactional email sends
    * Mod:      6/15/2014
    * Author:   Tony Angle
    ***************************************************************/
    public static testMethod void sendMailTest(){
        emailHandler eh=new emailHandler();
        
        eh.sendMail('tony.angle@wellpoint.com', 'tony_angle@msn.com', 'Test Email', 'Test Email');
    }
}