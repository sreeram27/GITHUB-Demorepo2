@isTest
public class BMSSendEmail_Test{
 
        static testmethod void sendEmailTest(){
          
          BMSSendEmail email=new BMSSendEmail();
          BMSQuotingObject.BMSQuoteOpportunity bmsQOppObj=new BMSQuotingObject.BMSQuoteOpportunity();
          bmsQOppObj.BrokerNumber='123';
          bmsQOppObj.AccountCode='112';
          bmsQOppObj.SalesRepCode='12345';
          bmsQOppObj.CloseDate=system.today();
           
       email.CreateEmail(bmsQOppObj,'Index Out of bound','test');

       
    }
    

   
}