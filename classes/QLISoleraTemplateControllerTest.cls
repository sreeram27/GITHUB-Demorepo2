/**************************************************************************************
@description          : Test Class for QLISoleraTemplateController
@Author                 : Mehaboob
US                        :  Modified Test class as part of PRDCRM-41975,43038
*************************************************************************************/
@isTest
private class QLISoleraTemplateControllerTest{

    static testMethod void testinsertOrUpdateQLI(){
        
        Id qliId;
        User testUser;
        Integer recordCount=1;
        Map<String,ID> profiles = new Map<String,ID>();
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
         System.RunAs(usr){
          List<Profile> ps = [select id, name from Profile where name ='National Sales' or name = 'System Administrator'];
          for(Profile p : ps){
             profiles.put(p.name, p.id);
           }
          UserRole testRole = new UserRole(DeveloperName = 'TestRole', Name = 'Test Role');
          insert testRole;
          testUser = new User(alias = 'solera',email='testuser@testSolera.com',emailencodingkey='UTF-8',lastname='TestSolera', languagelocalekey='en_US',localesidkey='en_US',profileid = profiles.get('National Sales'),UserRoleId = testRole.Id,timezonesidkey='America/New_York',username='test121@testSolera.com');
          insert testUser;
         }
         
         //Insert account
         List<Account> accounts = new List<Account>();
         String accName='newaccount';
         String street='CA street';
         // String accRecordTypeName='Customer';
         //String situsState='ANA';
         String city='CA';
         String state='CA State';
         String zip='12345';
         String country='US';
         String stateCode='CAA';
         accounts =TestDataFactory.createAccountSICList(recordCount,accName,street,city,state,zip,country,stateCode);
         insert accounts; 
         
         //Insert Opportunity 
         List<Opportunity> opportunities = new List<Opportunity>();
         String optyName = 'test Opty';
         String optyRecordTypeName='New Business';
         String stageName='Prospecting';
         Date closeDate=System.Today();
         opportunities=TestDataFactory.createOpportunityList(recordCount,optyName,accounts[0]);
         insert opportunities; 
         
         //Insert Group
         Group__c groupRec=new Group__c();
         //String groupName='Test Group';
         Boolean doInsert=true;
         groupRec=TestDataFactory.createGroup(accounts[0].Id,doInsert);
         //insert groupRec;
       
         //Insert Product
         String prodName='Laptop X200';
         List<Product2> prodlist= new List<Product2>();
         prodlist=TestDataFactory.createProduct(prodName,recordCount);
         insert prodlist;
        
        //Insert PricebookEntry
        List<PricebookEntry> pricebookentrylist= new List<PricebookEntry>();
        pricebookentrylist=TestDataFactory.PricebookEntry(recordCount,prodlist[0]);
        insert pricebookentrylist;
        
        //Insert Quote
        List<Quote> quotelist= new List<Quote>();
        String quoteName='Test Quote';
        quotelist=TestDataFactory.Quote(quoteName,recordCount,opportunities[0]);
        insert quotelist;
        
        //Insert QuoteLineItem
        List<QuoteLineItem> quotelineitemlist= new List<QuoteLineItem>();
        String qliName='Test QLI';
        quotelineitemlist=TestDataFactory.QuoteLineItem(qliName,recordCount,quotelist[0],prodlist[0],pricebookentrylist[0]);
        insert quotelineitemlist;
      
        List<QuoteLineItem> qliFinalList=[SELECT Id,Description,Quote.AccountId,Quote.Account.Name,Prefix_for_Client_Account__c,Quote.Account.NASCO_Contracting_Situs_State__c,Quote.Account.WGS_Contracting_Situs_State__c,Financing__c,Primary_Point_of_Contact__r.Name,Primary_Point_of_Contact__r.Email,Primary_Point_of_Contact__r.Phone,Primary_Point_of_Contact__r.Title,Marketing_outreach__c,Anthem_Account_Manager__r.Name,Anthem_Account_Manager__r.Email,Anthem_Account_Manager__r.Phone,Anthem_Account_Manager__r.Title,Anthem_Account_Manager__r.UserRole.name,Quote.Opportunity.Closedate,Other_Notes__c,Geography_of_the_Population__c,Early_Retiree_Population_Covered__c,Members_Covered__c FROM QuoteLineItem WHERE id =:quotelineitemlist[0].Id Limit 1];

       Test.startTest();
        QuoteLineItem qliFinal=[SELECT Id,Description,Quote.AccountId,Quote.Account.Name,Prefix_for_Client_Account__c,Quote.Account.NASCO_Contracting_Situs_State__c,Quote.Account.WGS_Contracting_Situs_State__c,Financing__c,Primary_Point_of_Contact__r.Name,Primary_Point_of_Contact__r.Email,Primary_Point_of_Contact__r.Phone,Primary_Point_of_Contact__r.Title,Marketing_outreach__c,Anthem_Account_Manager__r.Name,Anthem_Account_Manager__r.Email,Anthem_Account_Manager__r.Phone,Anthem_Account_Manager__r.Title,Anthem_Account_Manager__r.UserRole.name,Quote.Opportunity.Closedate,Other_Notes__c,Geography_of_the_Population__c,Early_Retiree_Population_Covered__c,Members_Covered__c FROM QuoteLineItem WHERE id =:quotelineitemlist[0].Id Limit 1];
        QLISoleraTemplateController q=new QLISoleraTemplateController();
        q.QLIrec=qliFinalList;
        q.qliId=quotelineitemlist[0].Id;
        q.getQLIrec();
        
        System.assertEquals(accounts[0].Name,qliFinal.Quote.Account.Name,'Account returned from controller to template');
       Test.stopTest();       
   }
}