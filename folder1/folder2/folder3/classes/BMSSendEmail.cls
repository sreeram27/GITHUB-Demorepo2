public with sharing class BMSSendEmail {
    public void CreateEmail(BMSQuotingObject.BMSQuoteOpportunity bmsQOppObj,String exceptionStr, 
    String SendQuoteReq) 
    {
         Organization org=[select id,issandbox,instancename from organization];

        ServiceInterface__mdt mc = [Select Id, ToEmailList__c, EmailDisplayName__c, EmailSubject__c, FromEmailId__c, Environment__c From ServiceInterface__mdt Where DeveloperName = 'WLQIntegration'];//ServiceInterface__c.getValues('WLQIntegration');
        String brokerId = bmsQOppObj.BrokerNumber;
        String accntCode = bmsQOppObj.AccountCode;
        String salesRep = bmsQOppObj.SalesRepCode;
        String affDt = bmsQOppObj.CloseDate+'';
        String htmlBody;         
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = mc.ToEmailList__c.split(';'); 
        mail.setToAddresses(toAddresses);
        mail.setReplyTo(mc.FromEmailId__c);    
        mail.setSenderDisplayName(mc.EmailDisplayName__c);
        if(org.issandbox==true)
        {
        mail.setSubject(org.instancename+'- '+mc.EmailSubject__c);
        }
        else
        {
         mail.setSubject('Production:'+org.instancename+'- '+mc.EmailSubject__c);
        
        }
        mail.setBccSender(false);
        mail.setUseSignature(false); 
        htmlBody = '<h4> Exception in Processing Quote Request from BMS Wellquote</h4>';
        htmlBody = htmlBody +'<p><b><font color="red"> <u>'+exceptionStr+'</u></font></b></p>';
        htmlBody = htmlBody +'<p><b><u>Required Data Elements From the Request</u></b></p>';
        htmlBody = htmlBody +'Account Code: '+accntCode+' <br>';
        htmlBody = htmlBody +'Sales Rep Id: '+salesRep+'<br>';
        htmlBody = htmlBody +'Effective Date: '+affDt+' <br>';
        htmlBody = htmlBody +'<p><b>***Request Received From Wellquote***</b></p>';
        htmlBody = htmlBody +SendQuoteReq;   
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}