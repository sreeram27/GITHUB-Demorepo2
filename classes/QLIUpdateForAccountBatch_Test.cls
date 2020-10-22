/* ***************************************************************************
Class Name   : QLIUpdateForAccountBatch_Test
Date Created : 12-Feb-2020
Created By   : Partha Pratim Baruah (Vikings)
Description  : This gets called from the Process Builder "UpdateQLIProdStage"
******************************************************************************* */

@isTest
public class QLIUpdateForAccountBatch_Test
{


 static testMethod void testOpportuniityQuoteLineItemUpdate (){
        
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
        List<Opportunity> oppList= Anthem_TestDataFactory.generateOpportunity(oppRecordTypeList,accountList.get(0).Id);  
        oppList[0].stageName='Closed Won';
        insert oppList; 
        
        System.assertEquals([Select count() From Opportunity],1);
        
         List<Id> lstOpp= new List<Id>();
         lstOpp.add(oppList[0].id);
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
        
        QLIUpdateForAccountBatch.QLIUpdate(lstOpp);
        Test.StopTest();
        }

}