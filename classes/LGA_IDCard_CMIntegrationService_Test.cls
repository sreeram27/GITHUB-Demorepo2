/*******************************************************************************************
@class Name  : LGA_IDCard_CMIntegrationService_Test
@created By  : IDC Offshore
@createdDate : 8/01/2019
@description : This test class is for LGA_IDCard_CMIntegrationService
********************************************************************************************/
@isTest(SeeAllData=false)
public with sharing class LGA_IDCard_CMIntegrationService_Test {
    
    /*******************************************************************************************
@method Name  : method1
@description : This is test method for LGA_IDCard_CMIntegrationService
********************************************************************************************/
    @isTest(SeeAllData=false)
    public static void method1(){
        LGA_IDCard_CMIntegrationService idCardCMIntegration = new LGA_IDCard_CMIntegrationService();
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        //String IDCARDTRIGGER = 'IDCardTrigger';
        //String IMPCASEID = 'IMPCaseId';
        //String IMPCASETYPE = 'IMPCaseType';
        //String SUCCESS = 'success'; 
        //String GROUPSUFFIX = 'GroupSuffix';
        List<string> suffixList = new List<string>();       
        
        //List<Application_Document_Checklist__c> doclist = new List<Application_Document_Checklist__c>();
        // User Creation
         try {
        User testUser = Util02_TestData.createUser();
        System.runAs(testUser){
            /***Account Record Creation***/
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();
            List<Id> accRecordTypeList = new List<Id>();
            accRecordTypeList.add(accRecordTypeId);
            List<Account> testAccList = new List<Account>();
            testAccList.addAll(Anthem_TestDataFactory.generateAccount(accRecordTypeList));
            database.insert(testAccList);
            system.debug('**testAcc**'+testAccList);
            
            List<Id> oppRecordTypeList = new List<Id>();
            Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business Local').getRecordTypeId();
            oppRecordTypeList.add(opportunityRecordTypeId);
            List<Opportunity> oppList = Anthem_TestDataFactory.generateOpportunity(oppRecordTypeList,testAccList[0].Id);        
            Database.insert(oppList, false);
            //system.debug('@@@@@oppList'+oppList);
            Product2 product = Anthem_TestDataFactory.generateProduct2();   
            Database.insert(product, false);
            
            Id priceBookId = Anthem_TestDataFactory.generatePricebookId();
            
            
            PricebookEntry priceBookEntry = Anthem_TestDataFactory.generatePricebookEntry(product.Id,priceBookId);
            Database.insert(priceBookEntry, false);
            List<Id> quoteRecIdList = new List<Id>();
            Id largeGroupQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('LargeGroupQuote').getRecordTypeId();         
            quoteRecIdList.add(largeGroupQuoteRecordTypeId);
            List<Quote> quoteList = Anthem_TestDataFactory.generateQuote(quoteRecIdList, priceBookId, oppList[0].Id);
            Database.insert(quoteList, false);
            //system.debug('*******Quote******' + quoteList);
            
            
            List<Id> quoteLineItem = new List<Id>();
            List<QuoteLineItem> quoteLineItemTest = Anthem_TestDataFactory.generateSoldQuoteLineItem(3, product.Id, quoteList[0].Id, priceBookEntry);       
            Database.insert(quoteLineItemTest, false);
            system.assertNotEquals(null, quoteLineItemTest,'Inserted Sucessfully');
            //system.debug('*******QLI******' + quoteLineItemTest);
            List<Order> testimplList = Anthem_TestDataFactory.generateImplementationCase(testAccList[0].Id, quoteList[0].Id, oppList[0].Id);
            database.insert(testimplList);
            //system.debug('****testimpl****'+testimplList);
            suffixList.add('321465');
            suffixList.add('978465');
            suffixList.add('321978');
            options.put(LGA_Constants.IMPCASEID,testimplList[0].Id);
            options.put(LGA_Constants.IMPCASETYPE,testimplList[0].Implementation_Type__c);
            options.put(LGA_Constants.GROUPSUFFIX,suffixList);
            //system.debug('@@@@options'+options);
            idCardCMIntegration.invokeMethod(LGA_Constants.IDCARDTRIGGER,inputMap,outMap,options);
        }  
        }
        catch (Exception e) {
			System.debug('ERROR ='+e);
		}    		
    }
    
    
    /**
    * @description : This is test method for LGA_IDCard_CMIntegrationService
    * @author : IDC Offshore | 1/13/2020 
    * @return  : void 
    **/
    @isTest(SeeAllData=false)
    public static void method2(){
        LGA_IDCard_CMIntegrationService idCardCMIntegration = new LGA_IDCard_CMIntegrationService();
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        //String IDCARDTRIGGER = 'IDCardTrigger';
        //String IMPCASEID = 'IMPCaseId';
        //String IMPCASETYPE = 'IMPCaseType';
        //String SUCCESS = 'success'; 
        //String GROUPSUFFIX = 'GroupSuffix';
        List<string> suffixList = new List<string>();
        
        try{
        // User Creation
        User testUser = Util02_TestData.createUser();
        System.runAs(testUser){
            /***Account Record Creation***/
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();
            List<Id> accRecordTypeList = new List<Id>();
            accRecordTypeList.add(accRecordTypeId);
            List<Account> testAccList = new List<Account>();
            testAccList.addAll(Anthem_TestDataFactory.generateAccount(accRecordTypeList));
            database.insert(testAccList);
            //system.debug('**testAcc**'+testAccList);
            
            List<Id> oppRecordTypeList = new List<Id>();
            Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business Local').getRecordTypeId();
            oppRecordTypeList.add(opportunityRecordTypeId);
            List<Opportunity> oppList = Anthem_TestDataFactory.generateOpportunity(oppRecordTypeList,testAccList[0].Id);        
            Database.insert(oppList, false);
            //system.debug('@@@@@oppList'+oppList);
            Product2 product = Anthem_TestDataFactory.generateProduct2();   
            Database.insert(product, false);
            
            Id priceBookId = Anthem_TestDataFactory.generatePricebookId();
            
            
            PricebookEntry priceBookEntry = Anthem_TestDataFactory.generatePricebookEntry(product.Id,priceBookId);
            Database.insert(priceBookEntry, false);
            List<Id> quoteRecIdList = new List<Id>();
            Id largeGroupQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('LargeGroupQuote').getRecordTypeId();         
            quoteRecIdList.add(largeGroupQuoteRecordTypeId);
            List<Quote> quoteList = Anthem_TestDataFactory.generateQuote(quoteRecIdList, priceBookId, oppList[0].Id);
            Database.insert(quoteList, false);
            //system.debug('*******Quote******' + quoteList);
            
            
            List<Id> quoteLineItem = new List<Id>();
            List<QuoteLineItem> quoteLineItemTest = Anthem_TestDataFactory.generateSoldQuoteLineItem(3, product.Id, quoteList[0].Id, priceBookEntry);       
            Database.insert(quoteLineItemTest, false);
            system.assertNotEquals(null, quoteLineItemTest,'Inserted Sucessfully');
            //system.debug('*******QLI******' + quoteLineItemTest);
            List<Order> testimplList = Anthem_TestDataFactory.generateImplementationCase(testAccList[0].Id, quoteList[0].Id, oppList[0].Id);
            testimplList[0].Implementation_Type__c = 'Change Request Off Cycle';
            database.insert(testimplList);
            //system.debug('****testimpl****'+testimplList);
            suffixList.add('321465');
            suffixList.add('978465');
            suffixList.add('321978');
            options.put(LGA_Constants.IMPCASEID,testimplList[0].Id);
            options.put(LGA_Constants.IMPCASETYPE,testimplList[0].Implementation_Type__c);
            options.put(LGA_Constants.GROUPSUFFIX,suffixList);
            //system.debug('@@@@options'+options);
            idCardCMIntegration.invokeMethod(LGA_Constants.IDCARDTRIGGER,inputMap,outMap,options);
        } 
        }
        catch (Exception e) {
			System.debug('>>> ERROR ='+e);
		}    		
    }
 
}