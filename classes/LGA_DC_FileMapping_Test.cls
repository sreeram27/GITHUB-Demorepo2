/*******************************************************************************************
@class Name  : LGA_DC_FileMapping_Test
@created By  : IDC Offshore
@createdDate : 8/01/2019
@description : This test class is for LGA_DC_FileMapping
********************************************************************************************/
@isTest(SeeAllData=false)
public class LGA_DC_FileMapping_Test {
    //public static final string METHODNAME = 'attachFilestoDC';
    //private static string impCaseId = 'ImpCaseId';
    //private static string selectedDC = 'SelectedDC';
    //private static string uFileName = 'UploadedFileName';
    //private static string autoMatchDC = 'autoMatchDC';
        
    

/*******************************************************************************************
@method Name  : method1
@description : This is test method for LGA_DC_FileMapping
********************************************************************************************/
    @isTest
    public static void method1(){
        try {
            LGA_DC_FileMapping fmap = new LGA_DC_FileMapping();
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
           // List<string> selectedItems = new List<string>();
            List<String> fileNames = new List<String>();
            List<string> dclist = new List<string>();
            //List<Application_Document_Checklist__c> doclist = new List<Application_Document_Checklist__c>();
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
                database.insert(testimplList);
                system.debug('****testimpl****'+testimplList);
                
                //Document Checklist creation
                List<Application_Document_Checklist__c> dclst = new List<Application_Document_Checklist__c>();
                Application_Document_Checklist__c dc1 = new Application_Document_Checklist__c();
                dc1.Document_Name__c = 'Test_1123';
                dc1.Implementation_Case__c = testimplList[0].Id;
                dclst.add(dc1); 
                
                Application_Document_Checklist__c dc2 = new Application_Document_Checklist__c();
                dc2.Document_Name__c = 'My DC';
                
                dc2.Implementation_Case__c = testimplList[0].Id;
                dclst.add(dc2);     
                database.insert(dclst);
                
                /***ContentVersion Creation***/
                List<ContentVersion>  cvlst = new List<ContentVersion>();  
                Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
                ContentVersion cv = new ContentVersion();
                cv.Title = 'My DC2.txt';
                cv.PathOnClient = 'My DC2.txt';
                cv.VersionData = beforeblob;
                cvlst.add(cv);    
                fileNames.add(cv.Title);
                Blob beforeblob1=Blob.valueOf('Unit Test Attachment Body');
                ContentVersion cv1 = new ContentVersion();
                cv1.Title = 'Test_1123.csv';
                cv1.PathOnClient = 'Test_1123.csv';
                cv1.VersionData = beforeblob1;
                cvlst.add(cv1);     
                database.insert(cvlst);
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where LatestPublishedVersionId IN: cvlst limit 1000];
                //system.debug('documents'+documents);
                fileNames.add(cv1.Title);
                /**************ContentDocumentLink*************/
                List<ContentDocumentLink> cdlinklst = new List<ContentDocumentLink>();    
                ContentDocumentLink cdlink1 = new ContentDocumentLink();
                cdlink1.ContentDocumentId = documents[0].id;
                cdlink1.LinkedEntityId = testimplList[0].Id;
                cdlink1.ShareType = 'V';
                cdlink1.Visibility = 'AllUsers';
                cdlinklst.add(cdlink1); 
                
                ContentDocumentLink cdlink2 = new ContentDocumentLink();
                cdlink2.ContentDocumentId = documents[1].id;
                cdlink2.LinkedEntityId = testimplList[0].Id;
                cdlink2.ShareType = 'V';
                cdlink2.Visibility = 'AllUsers';
                cdlinklst.add(cdlink2);    
                //database.insert(cdlinklst);
                
                ContentDocumentLink cdlink3 = new ContentDocumentLink();
                cdlink3.ContentDocumentId = documents[1].id;
                cdlink3.LinkedEntityId = dclst[0].Id;
                cdlink3.ShareType = 'V';
                cdlink3.Visibility = 'AllUsers';
                cdlinklst.add(cdlink3);    
                database.insert(cdlinklst);
                            
                dclist.add(dc1.Id);
                dclist.add(dc2.Id);
                options.put(LGA_Constants.IMPLCASEID,testimplList[0].Id);
                options.put(LGA_Constants.SELECTEDDC,dclist);
                options.put(LGA_Constants.UFILENAME,fileNames);
                options.put(LGA_Constants.AUTO_MATCH,true);
                fmap.invokeMethod(LGA_Constants.METHODNAME,inputMap,outMap,options);
                
            }
        } catch (Exception ex) {
            system.debug('****The following exception has occurred: ' + ex.getMessage());
        }

    }
    
    /*******************************************************************************************
@method Name  : method1
@description : This is test method for LGA_DC_FileMapping
********************************************************************************************/
    @isTest
    public static void method2(){
        try {
            LGA_DC_FileMapping fmap = new LGA_DC_FileMapping();
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            //List<string> selectedItems = new List<string>();
            List<String> fileNames = new List<String>();
            List<string> dclist = new List<string>();
            //List<Application_Document_Checklist__c> doclist = new List<Application_Document_Checklist__c>();
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
                database.insert(testimplList);
                //system.debug('****testimpl****'+testimplList);
                
                //Document Checklist creation
                List<Application_Document_Checklist__c> dclst = new List<Application_Document_Checklist__c>();
                Application_Document_Checklist__c dc1 = new Application_Document_Checklist__c();
                dc1.Document_Name__c = 'Test_1123';
                dc1.Implementation_Case__c = testimplList[0].Id;
                dclst.add(dc1); 
                
                Application_Document_Checklist__c dc2 = new Application_Document_Checklist__c();
                dc2.Document_Name__c = 'My DC';
                
                dc2.Implementation_Case__c = testimplList[0].Id;
                dclst.add(dc2);     
                database.insert(dclst);
                
                /***ContentVersion Creation***/
                List<ContentVersion>  cvlst = new List<ContentVersion>();  
                Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
                ContentVersion cv = new ContentVersion();
                cv.Title = 'My DC2.txt';
                cv.PathOnClient = 'My DC2.txt';
                cv.VersionData = beforeblob;
                cvlst.add(cv);    
                fileNames.add(cv.Title);
                Blob beforeblob1=Blob.valueOf('Unit Test Attachment Body');
                ContentVersion cv1 = new ContentVersion();
                cv1.Title = 'Test_1123.csv';
                cv1.PathOnClient = 'Test_1123.csv';
                cv1.VersionData = beforeblob1;
                cvlst.add(cv1);     
                database.insert(cvlst);
                //fileNames.add(cv1.Title);
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where LatestPublishedVersionId IN: cvlst limit 50000];
                system.debug('@@@@@@@@documents'+documents);
                fileNames.add(cv1.Title);
                /**************ContentDocumentLink*************/
                List<ContentDocumentLink> cdlinklst = new List<ContentDocumentLink>();    
                ContentDocumentLink cdlink1 = new ContentDocumentLink();
                cdlink1.ContentDocumentId = documents[0].id;
                cdlink1.LinkedEntityId = testimplList[0].Id;
                cdlink1.ShareType = 'V';
                cdlink1.Visibility = 'AllUsers';
                cdlinklst.add(cdlink1); 
                
                ContentDocumentLink cdlink2 = new ContentDocumentLink();
                cdlink2.ContentDocumentId = documents[1].id;
                cdlink2.LinkedEntityId = testimplList[0].Id;
                cdlink2.ShareType = 'V';
                cdlink2.Visibility = 'AllUsers';
                cdlinklst.add(cdlink2);    
                //database.insert(cdlinklst);
                
                ContentDocumentLink cdlink3 = new ContentDocumentLink();
                cdlink3.ContentDocumentId = documents[1].id;
                cdlink3.LinkedEntityId = dclst[0].Id;
                cdlink3.ShareType = 'V';
                cdlink3.Visibility = 'AllUsers';
                cdlinklst.add(cdlink3);    
                database.insert(cdlinklst);
                            
                dclist.add(dc1.Id);
                dclist.add(dc2.Id);
                options.put(LGA_Constants.IMPLCASEID,testimplList[0].Id);
                options.put(LGA_Constants.SELECTEDDC,dclist);
                options.put(LGA_Constants.UFILENAME,fileNames);
                options.put(LGA_Constants.AUTO_MATCH,false);
                
                //system.debug('@@@@options'+options);
                fmap.invokeMethod(LGA_Constants.METHODNAME,inputMap,outMap,options);
                
            }
        } catch (Exception ex) {
            system.debug('****The following exception has occurred: ' + ex.getMessage());
        }        
    }

}