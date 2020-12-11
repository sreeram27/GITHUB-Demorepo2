/*
@Author : CDHP Dev Team 
@name : CreateCDHPQuestionnaire_Test
@CreateDate :07-15-2018
*/
@isTest
private class CreateCDHPQuestionnaire_Test {
    
    static testmethod void myUnitTest(){
        Test.setMock(HttpCalloutMock.class, new CDHPHttpCalloutMock());
        testDataFactoryCDHP.createAccount();
        testDataFactoryCDHP.createContact();
        testDataFactoryCDHP.createOpp();
        testDataFactoryCDHP.createQuote();
        testDataFactoryCDHP.createProducts();
        testDataFactoryCDHP.createQuoteLineItem();
        testDataFactoryCDHP.createSessionData();
        testDataFactoryCDHP.createHRA();
        Test.startTest();
        testDataFactoryCDHP.lstOpp[0].StageName = 'Closed Won';
        update testDataFactoryCDHP.lstOpp[0];
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
        
        //Create Account
        Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
        Database.insert(acc);
        Opportunity opp=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
        opp.StageName = 'Renewal Finalized';
        opp.Pricebook2Id=pricebookId;
        Database.insert(opp);
        
        Quote quote = new Quote();
        quote.Name = 'Test Quote 1';
        quote.OpportunityId = opp.Id;
        quote.Pricebook2Id = opp.Pricebook2Id;
        quote.CDHP_SF_Id_From_ISG__c = '123';
        Database.insert(quote);  
        
        List<QuoteLineItem> qliRecords = new List<QuoteLineItem>();
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli.ProductStage__c='Sold';
        qli.PLComplete__c =true;
        qli.PricebookEntryId=pbEntry.Id;
        qli.Quantity =1; 
        qli.UnitPrice=1000;
        qliRecords.add(qli);
        insert qliRecords;
        
        CreateCDHPQuestionnaire.sendOpportunityData(quote.Id);
        CreateCDHPQuestionnaire.initController(quote.Id);
        CreateCDHPQuestionnaire.sendEmailToActWiseSupport(quote.Id);
        
        system.assert(quote != null);
        
        CreateCDHPQuestionnaire.InitializeResponse resp = CreateCDHPQuestionnaire.initController(quote.Id);
        System.assertEquals(resp.showCreatUpdate, True);
        Test.stopTest(); 
    }  
    
}