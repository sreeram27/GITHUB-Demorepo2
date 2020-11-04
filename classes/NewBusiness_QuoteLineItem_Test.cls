@isTest
private class NewBusiness_QuoteLineItem_Test {
    
    static Quote quote;
    static Product2 prod;
    static PricebookEntry pbEntry;
    
    static void init(){
        Id pricebookId = Test.getStandardPricebookId();
        
        prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true,
            QLIRecordType__c = 'ActWise'
            
        );
        insert prod; 
        
        //Create your pricebook entry
        pbEntry = new PricebookEntry(
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
        
        quote = new Quote();
        quote.Name = 'Test Quote 1';
        quote.OpportunityId = opp.Id;
        quote.Pricebook2Id = opp.Pricebook2Id;
        quote.CDHP_SF_Id_From_ISG__c = '123';
        quote.NONB_Sent__c = 0;
        quote.NONB_Resent__c = 0;
        Database.insert(quote);
    }
    
    static testMethod void myUnitTest(){
        
        Test.startTest();
        init();
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli.ProductStage__c='Sold';
        qli.PLComplete__c =true;
        qli.PricebookEntryId=pbEntry.Id;
        qli.Quantity =1; 
        qli.UnitPrice=1000;
        qli.RecordType__c = 'ActWise HSA';
        qli.Is_New_Business__c = false;
        insert qli;
        Test.stopTest();
    }
    
    static testMethod void  myUNitTest2(){
        Test.startTest();
        init();
        
        //Test.startTest();
        
        QuoteLineItem qli2 = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli2.ProductStage__c='Sold';
        qli2.PLComplete__c =true;
        qli2.PricebookEntryId=pbEntry.Id;
        qli2.Quantity =1; 
        qli2.UnitPrice=1000;
        qli2.RecordType__c = 'ActWise HSA';
        qli2.Is_New_Business__c = false;
        qli2.Is_Existing_Product__c = true;
        insert qli2;
        
        Test.stopTest();
        
    }
}