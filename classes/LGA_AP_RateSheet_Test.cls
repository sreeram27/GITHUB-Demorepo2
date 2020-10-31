/**
 * @File Name          : LGA_AP_RateSheet_Test.cls
 * @Description        : 
 * @Author             : Accenture Off Shore
 * @Group              : Raptors
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/9/2020      Accenture Off Shore        Initial Version
**/
@isTest(SeeAllData=false)
/********************************************************** 
@Class Name :   LGA_AP_RateSheet_Test
@Date Created : 21-AUG-2019
@Created By   : Accenture Offshore 
@Description: created for LGA_AP_Ratesheet class coverage
*****************************************************************************/
public with sharing class LGA_AP_RateSheet_Test {
    private static LGA_AP_Ratesheet fileUploadController;
    public Static Final String ORDERID_CONSTANT ='Id';
    private Static Final String TESTADATA_CONSTANT = 'StringToBlobttttt';
    private Static Final String FILENAME_CONSTANT = 'MED-NONABACUS-FINALRATES.xlsx';
    private Static Final String FILETYPE_CONSTANT = 'xlsx';
    private Static Final String FILESIZE_CONSTANT = '600';
    public Static Final String B_CONSTANT = 'B';
    
    /*************************************************************************************
@Method Name : fileUploadPositiveTest
@Parameters  : None
@Return type : void
@Description : This is the testmethod for Upload Documents with positive values
*************************************************************************************/
    private static testMethod void  fileUploadPositiveTest(){
        User testUser = Util02_TestData.createUser();
        
        /***Account Record Creation***/
        Account testAccount = Util02_TestData.createGroupAccount();
        System.runAs(testUser){
            Database.insert(testAccount);
            /***Opportunity Record Creation***/
            List<Id> oppRecordTypeList = new List<Id>();
            Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business Local').getRecordTypeId();
            oppRecordTypeList.add(opportunityRecordTypeId);
            List<Opportunity> oppList = Anthem_TestDataFactory.generateOpportunity(oppRecordTypeList,testAccount.Id);        
            Database.insert(oppList, false);
            
            /***Product Record Creation***/
            Product2 product = Anthem_TestDataFactory.generateProduct2();   
            Database.insert(product, false);
            
            /***PriceBook Record Creation***/
            Id priceBookId = Anthem_TestDataFactory.generatePricebookId();
            PricebookEntry priceBookEntry = Anthem_TestDataFactory.generatePricebookEntry(product.Id,priceBookId);
            Database.insert(priceBookEntry, false);
            
            /***Quote Record Creation***/
            List<Id> quoteRecIdList = new List<Id>();
            Id largeGroupQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('LargeGroupQuote').getRecordTypeId();         
            quoteRecIdList.add(largeGroupQuoteRecordTypeId);
            List<Quote> quoteList = Anthem_TestDataFactory.generateQuote(quoteRecIdList, priceBookId, oppList[0].Id);
            Database.insert(quoteList, false);
            
            
            /***QuoteLineItem Record Creation***/
            List<Id> quoteLineItem = new List<Id>();
            List<QuoteLineItem> quoteLineItemTest = Anthem_TestDataFactory.generateSoldQuoteLineItem(3, product.Id, quoteList[0].Id, priceBookEntry);       
            Database.insert(quoteLineItemTest, false);
            
            
            /***Order Record Creation***/
            List<Order> testimpl =Anthem_TestDataFactory.generateImplementationCase1(testAccount.Id, quoteList[0].Id, oppList[0].Id,testUser.Id);
            database.insert(testimpl);
            
            //code to create to document checklist
            List<Application_Document_Checklist__c>dclist = Anthem_TestDataFactory.generateDocumentChecklist(testimpl[0].id);
            Database.insert(dclist);
            
            List<Underwriter_Rate_Sheet__mdt> uRateList1 = [SELECT Id, Label,UploadedFileName__c FROM Underwriter_Rate_Sheet__mdt where Label = 'MED-ABACUS-FINALRATES.xlsx' Limit 10 ];
            
            /***ContentVersion Record Creation***/
            ContentVersion cv = Anthem_TestDataFactory.insertContentVersion();
            String myString1 = TESTADATA_CONSTANT;
            Blob beforeblob=Blob.valueOf(myString1);
            cv.VersionData =beforeblob;
            Database.insert(cv);
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where LatestPublishedVersionId=:cv.id Limit 10];
            
            /***ContentDocumentLink Record Creation***/
            List<ContentDocumentLink> cdlink = Anthem_TestDataFactory.generateContentDocumentLink(dclist[0].Id,documents[0].id);
            Database.insert(cdlink);
            
            Test.startTest();
            
            PageReference pgRef = Page.LGA_VF_Ratesheet;
            
            Test.setCurrentPage(pgRef);
            ApexPages.currentPage().getParameters().put('id', testimpl[0].Id);//Pass Id to page
            
            fileUploadController = new LGA_AP_Ratesheet();
            fileUploadController.loadApplicationandDocuments();
            
            for(LGA_AP_Ratesheet.WrapFileUploadHolder wrapFileH : fileUploadController.wrapFileUploadHolderList){
                String myString = TESTADATA_CONSTANT;
                Blob myBlob = Blob.valueof(myString);        
                wrapFileH.fileContent = myBlob;   
                wrapFileH.fileName = FILENAME_CONSTANT;
                wrapFileH.documentCheckObj.File_Size__c = FILESIZE_CONSTANT;
                wrapFileH.documentCheckObj.Document_Name__c = 'Medical Non-Abacus Final Rate Sheet';
            }
            
            fileUploadController.saveFiles();
            
            Test.stopTest();
            System.assert(fileUploadController.docCheckIdsList.size() > 0,'Test success');
            System.assert(fileUploadController.wrapFileUploadHolderList.size() > 0,'Test success');
        }
        
    }
    
    /*************************************************************************************
@Method Name : fileUploadPositiveTest
@Parameters  : None
@Return type : void
@Description : This is the testmethod for Upload Documents with positive values
*************************************************************************************/
    
    private static testMethod void  fileUploadPositiveTest1(){
        User testUser = Util02_TestData.createUser();
        
        /***Account Record Creation***/
        Account testAccount = Util02_TestData.createGroupAccount();
        System.runAs(testUser){
            Database.insert(testAccount);
            /***Opportunity Record Creation***/
            List<Id> oppRecordTypeList = new List<Id>();
            Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business Local').getRecordTypeId();
            oppRecordTypeList.add(opportunityRecordTypeId);
            List<Opportunity> oppList = Anthem_TestDataFactory.generateOpportunity(oppRecordTypeList,testAccount.Id);        
            Database.insert(oppList, false);
            
            /***Product Record Creation***/
            Product2 product = Anthem_TestDataFactory.generateProduct2();   
            Database.insert(product, false);
            
            /***PriceBook Record Creation***/
            Id priceBookId = Anthem_TestDataFactory.generatePricebookId();
            PricebookEntry priceBookEntry = Anthem_TestDataFactory.generatePricebookEntry(product.Id,priceBookId);
            Database.insert(priceBookEntry, false);
            
            /***Quote Record Creation***/
            List<Id> quoteRecIdList = new List<Id>();
            Id largeGroupQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('LargeGroupQuote').getRecordTypeId();         
            quoteRecIdList.add(largeGroupQuoteRecordTypeId);
            List<Quote> quoteList = Anthem_TestDataFactory.generateQuote(quoteRecIdList, priceBookId, oppList[0].Id);
            Database.insert(quoteList, false);
            
            
            /***QuoteLineItem Record Creation***/
            List<Id> quoteLineItem = new List<Id>();
            List<QuoteLineItem> quoteLineItemTest = Anthem_TestDataFactory.generateSoldQuoteLineItem(3, product.Id, quoteList[0].Id, priceBookEntry);       
            Database.insert(quoteLineItemTest, false);
            
            
            /***Order Record Creation***/
            List<Order> testimpl =Anthem_TestDataFactory.generateImplementationCase1(testAccount.Id, quoteList[0].Id, oppList[0].Id,testUser.Id);
            database.insert(testimpl);
            
            //code to create to document checklist
            List<Application_Document_Checklist__c>dclist = Anthem_TestDataFactory.generateDocumentChecklist(testimpl[0].id);
            Database.insert(dclist);
            List<Underwriter_Rate_Sheet__mdt> uRateList1 = [SELECT Id, Label,UploadedFileName__c FROM Underwriter_Rate_Sheet__mdt where Label = 'MED-ABACUS-FINALRATES.xlsx'Limit 3 ];
            
            /***ContentVersion Record Creation***/
            ContentVersion cv = Anthem_TestDataFactory.insertContentVersion();
            String myString1 = TESTADATA_CONSTANT;
            Blob beforeblob=Blob.valueOf(myString1);
            cv.VersionData =beforeblob;
            Database.insert(cv);
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where LatestPublishedVersionId=:cv.id Limit 20];
            
            /***ContentDocumentLink Record Creation***/
            List<ContentDocumentLink> cdlink = Anthem_TestDataFactory.generateContentDocumentLink(dclist[0].Id,documents[0].id);
            Database.insert(cdlink);
            
            Test.startTest();
            
            PageReference pgRef = Page.LGA_VF_Ratesheet;
            
            Test.setCurrentPage(pgRef);
            ApexPages.currentPage().getParameters().put('id', testimpl[0].Id);//Pass Id to page
            
            fileUploadController = new LGA_AP_Ratesheet();
            fileUploadController.loadApplicationandDocuments();
            
            for(LGA_AP_Ratesheet.WrapFileUploadHolder wrapFileH : fileUploadController.wrapFileUploadHolderList){
                String myString = TESTADATA_CONSTANT;
                Blob myBlob = Blob.valueof(myString);        
                wrapFileH.fileContent = myBlob;   
                wrapFileH.fileName = FILENAME_CONSTANT;
                wrapFileH.documentCheckObj.File_Size__c = FILESIZE_CONSTANT;
                wrapFileH.documentCheckObj.Document_Name__c = 'Medical Non-Abacus Final Rate Sheet';
                wrapFileH.documentCheckObj.Tech_Content_Document_Id__c = documents[0].id;
            }
            
            fileUploadController.saveFiles();
            
            Test.stopTest();
            System.assert(fileUploadController.docCheckIdsList.size() > 0,'Test success');
            System.assert(fileUploadController.wrapFileUploadHolderList.size() > 0,'Test success');
        }
        
    }
    
}