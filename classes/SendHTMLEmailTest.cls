@isTest
public with sharing class SendHTMLEmailTest {
	
    private static Boolean EmailDeliverabilityEnabled(){
        Boolean EmailDeliverabilityEnabled = true;
        try {
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.reserveMassEmailCapacity(1);
        } catch (System.NoAccessException e) {
            EmailDeliverabilityEnabled = false;
        }
        return EmailDeliverabilityEnabled;
    }

    @isTest
    public static void CanSendEmail () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.Subject = 'this is the subject';
        testReq.SendTOthisOneEmailAddress = 'test@foo.com';
        testReq.SendCCthisOneEmailAddress = 'test@foo.com';
        testReq.SendBCCthisOneEmailAddress = 'test@foo.com';

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

        List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
	    
        Boolean EmailDeliverabilityEnabled = EmailDeliverabilityEnabled();
        if(EmailDeliverabilityEnabled){
            System.assertEquals(testResponseList[0].isSuccess,true);
        } else {
            System.assertEquals(EmailDeliverabilityEnabled,false);
        }

    }

    @isTest
    public static void errorIfNoAddress () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.Subject = 'this is the subject';
        //testReq.SendTOthisOneEmailAddress = 'test@foo.com';

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

        List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        System.assertEquals(testResponseList[0].isSuccess,false);



    }
    
    @isTest
    public static void canSendToContact () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.Subject = 'this is the subject';
        //testReq.SendTOthisOneEmailAddress = 'test@foo.com';

         
        Contact testContact1 = new Contact(
            FirstName = 'First',
            LastName = 'Last',
            email = 'foo@bar.com');
        insert testContact1;
        
        List<Contact> contactList = new List<Contact>();
        contactList.add(testContact1);
        
        testReq.SendTOtheEmailAddressesFromThisCollectionOfContacts = contactList;
        
        
        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

        List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        System.assertEquals(testResponseList[0].isSuccess,true);
    }

    @isTest
    public static void canSendToLead () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.Subject = 'this is the subject';
        //testReq.SendTOthisOneEmailAddress = 'test@foo.com';

         
        Lead testLead1 = new Lead(
            FirstName = 'First',
            LastName = 'Last',
            email = 'foo@bar.com',
        	company = 'foobarcorp');
        insert testLead1;
        
        List<Lead> leadList = new List<Lead>();
        leadList.add(testLead1);
        
        testReq.SendTOtheEmailAddressesFromThisCollectionOfLeads = leadList;
        
        
        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

        List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        System.assertEquals(testResponseList[0].isSuccess,true);
    }
    
    @isTest
    public static void errorIfBothTemplateandBody () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.templateID = 'temp';
        testReq.Subject = 'this is the subject';
        testReq.SendTOthisOneEmailAddress = 'test@foo.com';

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
        Boolean exceptionHit=false;
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
        }
        System.assertEquals(true, exceptionHit);



    }
    
    //this is bogus
    @isTest static void saveAsWillFail() {
    
        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        testReq.HTMLbody = 'this is the body';
        testReq.Subject = 'this is the subject';
        //testReq.SendTOthisOneEmailAddress = 'test@foo.com';

         
        Lead testLead1 = new Lead(
            FirstName = 'First',
            LastName = 'Last',
            email = 'foo@bar.com',
        	company = 'foobarcorp');
        insert testLead1;
        
        List<Lead> leadList = new List<Lead>();
        leadList.add(testLead1);
        
        testReq.SendTOtheEmailAddressesFromThisCollectionOfLeads = leadList;
        testReq.saveAsActivity = true;
        testReq.recordId = testLead1.Id;
        
        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);

        List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        System.assertEquals(testResponseList[0].isSuccess,false);
	}
    
    //@isTest
    public static void canCreateActivity() {
        
      Lead testLead1 = new Lead(
            FirstName = 'First',
            LastName = 'Last',
            email = 'foo@bar.com',
        	company = 'foobarcorp');
        insert testLead1;
        
        Boolean exceptionHit=false;
        String recordId = testLead1.Id;
        String subject = 'subject';
        String recipientList = 'reciplist';
        try {
            SendHTMLEmail.createActivity(recordId, subject, recipientList);
        } catch (SendHTMLEmail.InvocableActionException e) {
                	    exceptionHit=true;
        }
        System.assertEquals(true, exceptionHit);
        
    }
    

     @isTest
    public static void errorIfTemplateButNoContextRecord () {

        SendHTMLEmail.Request testReq = new SendHTMLEmail.Request();
        //testReq.HTMLbody = 'this is the body';
        testReq.templateID = 'temp';
        testReq.Subject = 'this is the subject';
        testReq.SendTOthisOneEmailAddress = 'test@foo.com';

        List<SendHTMLEmail.Request> reqList = new List<SendHTMLEmail.Request>();
        reqList.add(testReq);
		Boolean exceptionHit=false;
        try {
            List<SendHTMLEmail.Response> testResponseList = SendHTMLEmail.SendEmail(reqList);
        
        } catch (SendHTMLEmail.InvocableActionException e) {
            exceptionHit=true;
        }
        System.assertEquals(true, exceptionHit);
       

    }
}