/*
@Author : Olympians Dev Team 
@name : ShowNONBSendButtonTest
@CreateDate :11-08-2019
*/
@isTest
private class ShowNONBSendButtonTest {  
    
    /*String myUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        					EmailEncodingKey='UTF-8', 
                          	LastName='Testing', 
                          	LanguageLocaleKey='en_US',
        					LocaleSidKey='en_US', 
                          	ProfileId = p1.Id,
        					TimeZoneSidKey='America/Los_Angeles',
        					UserName=myUserName);
  
        System.runAs(u) {  */
    
    static testmethod void myUnitTest(){
        Test.startTest();      
        
        testDataFactoryCDHP.createAccount();
        testDataFactoryCDHP.createContact();
        testDataFactoryCDHP.createOpp();
        testDataFactoryCDHP.createQuote();
        testDataFactoryCDHP.createProducts();
        testDataFactoryCDHP.createQuoteLineItem();        
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true,
            QLIRecordType__c = 'ActWise'
            
        );
        insert prod; 
        
        
        
        //Create your pricebook entry
         PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id =  pricebookId ,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry; 
        
        Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
        Database.insert(acc);
        
        Opportunity opp=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
        opp.StageName = 'New Business';
        opp.Pricebook2Id=pricebookId;
        Database.insert(opp);
        
        Opportunity opp1=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
        opp1.StageName = 'Renewal Finalized';
        opp1.Pricebook2Id=pricebookId;
        Database.insert(opp1);
        
        Quote quote = new Quote();
        quote.Name = 'Test Quote 1';
        quote.OpportunityId = opp.Id;
        quote.Pricebook2Id = opp.Pricebook2Id;
        quote.CDHP_SF_Id_From_ISG__c = '123';
        quote.NONB_Sent__c = 0;
        quote.NONB_Resent__c = 0;
        //quote.NONB_Sent_Date_Time__c = datetime.newInstance(2019, 10, 31, 13, 30, 0);

        Database.insert(quote);  
        
        List<QuoteLineItem> qliRecords = new List<QuoteLineItem>();
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli.ProductStage__c='Sold';
        qli.PLComplete__c =true;
        qli.PricebookEntryId=pbEntry.Id;
        qli.Quantity =1; 
        qli.UnitPrice=1000;
        qli.RecordType__c = 'ActWise HSA';
        qliRecords.add(qli);
        
        QuoteLineItem qli1 = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli1.ProductStage__c='Sold';
        qli1.PLComplete__c =true;
        qli1.PricebookEntryId=pbEntry.Id;
        qli1.Quantity =1; 
        qli1.UnitPrice=1000;
        qli1.RecordType__c = 'Anthem Blue Access PPO HSA';
        qliRecords.add(qli1);        
        
        insert qliRecords;    
                    
        Profile p = [Select Id from Profile where Name='System Administrator' limit 1]; 
    	User user = new User(	Alias = 'sysadmin', 
							Email='mytestuser1@testorg.com', 
        					EmailEncodingKey='UTF-8', 	
							LastName='Testing', 
							LanguageLocaleKey='en_US', 
        					LocaleSidKey='en_US', 	
							ProfileId = p.Id, 
        					TimeZoneSidKey='America/Los_Angeles', 
							UserName='mytestuser1@testorg.com');
        
        insert user;
        
        PageReference pageRef = Page.ActWiseNONB;
        Test.setCurrentPage(pageRef); 
                        
        ApexPages.currentPage().getParameters().put('id', quote.id);
                                        
        list<String> addresses = new list<String>();
        addresses.add('test@test.com');
        addresses.add('test1@test.com');              
        
    	Blob b = Blob.ValueOf('test');
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();            
        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1.setFileName('test.pdf');
        efa1.setBody(b);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
                        
        ShowNONBSendButton.initController(quote.Id);
        
        quote.NONB_Sent__c = 1;
        update quote;
        ShowNONBSendButton.initController(quote.Id);
        
        NONB_Email__c customSet = new NONB_Email__c(Name='Test User');
        customSet.Email__c = 'test@gmail.com';
        insert customSet;
        
        system.runAs(user) {
        	ShowNONBSendButton.sendProductEmail(quote.Id, 'Resend');
        }  
        system.assert(quote != null);
        Test.stopTest(); 
    }         
}