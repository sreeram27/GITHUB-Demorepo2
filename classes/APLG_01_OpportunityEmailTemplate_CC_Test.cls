/*@author        Accenture offshore
@Request         
@date           16/05/2019
@name           APLG_01_OpportunityEmailTemplate_CC_Test 
@description    Test class to test APLG_01_OpportunityEmailTemplate_CC_Test */


@isTest(SeeAllData=False)
public class APLG_01_OpportunityEmailTemplate_CC_Test {
    
    static testMethod void testOpportuniityQuoteLineItemEmailList (){
        
        Test.startTest();         
        List<Id> accRecordTypeList = new List<Id>();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();         
        accRecordTypeList.add(accountRecordTypeId);
        List<Account> accountList = Anthem_TestDataFactory.generateAccount(accRecordTypeList);
        
        insert accountList;
        System.assertEquals([Select count() From Account],1);
        
        List<Id> oppRecordTypeList = new List<Id>();
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business Local').getRecordTypeId();
        oppRecordTypeList.add(opportunityRecordTypeId);
        List<Opportunity> oppList = Anthem_TestDataFactory.generateOpportunity(oppRecordTypeList,accountList.get(0).Id);        
        insert oppList; 
        System.assertEquals([Select count() From Opportunity],1);
        
        Product2 product = Anthem_TestDataFactory.generateProduct2();   
        insert product;
        System.assertEquals([Select count() From Product2],1);
        
        Id priceBookId = Anthem_TestDataFactory.generatePricebookId();
        
        
        PricebookEntry priceBookEntry = Anthem_TestDataFactory.generatePricebookEntry(product.Id,priceBookId);
        system.debug(priceBookEntry);
        insert priceBookEntry;
        System.assertEquals([Select count() From PriceBookEntry],1);
        
        List<Id> quoteRecIdList = new List<Id>();
        Id largeGroupQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Large Group Quote').getRecordTypeId();         
        quoteRecIdList.add(largeGroupQuoteRecordTypeId);
        List<Quote> quoteList = Anthem_TestDataFactory.generateQuote(quoteRecIdList, priceBookId, oppList.get(0).Id);
        insert quoteList;
        System.assertEquals([Select count() From Quote],1);
        
        List<Id> quoteLineItem = new List<Id>();
        List<QuoteLineItem> QuoteLineItemTest = Anthem_TestDataFactory.generateSoldQuoteLineItem(3, product.Id, quoteList.get(0).Id, priceBookEntry);       
        insert QuoteLineItemTest;
        System.assertEquals([Select count() From QuoteLineItem],3);
        
        List<Id> taxList = new List<Id>();
        taxList.add(accountList.get(0).id);
        List<Tax_ID__c> tax1 = Anthem_TestDataFactory.generateTax(taxList);
        insert tax1;
        System.assertEquals([Select count() From Tax_ID__c],1);
        
        APLG_01_OpportunityEmailTemplate_CC aplg01=new APLG_01_OpportunityEmailTemplate_CC();
        aplg01.accId = accountList.get(0).Id;
        aplg01.opporId = oppList.get(0).Id;
        aplg01.sAccSitusCode = 'test';
        aplg01.sAccBranding = 'test';
        aplg01.getQuoteLineItemsByOpprId();
        aplg01.getDynamicFooter();
        aplg01.getTaxIdsByAccountId();
        Test.stopTest(); 
    }
    
}