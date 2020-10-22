/*******************************************************************************************
@class Name  : LGA_RequiredDcList_Test
@created By  : IDC Offshore
@createdDate : 8/01/2019
@description : This test class is for LGA_RequiredDcList
********************************************************************************************/
@isTest(SeeAllData=false)
public with sharing class LGA_RequiredDcList_Test {
    
    private static LGA_RequiredDcList reqDcList;
    
    /*******************************************************************************************
@method Name  : fileUploadPositiveTest
@description : This is test method for LGA_RequiredDcList
********************************************************************************************/
    public static testMethod void  fileUploadPositiveTest(){
        try {
            String implementationCaseId = LGA_Constants.IMPCASEID;
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            //Map<String,Object> OutMap1 = new Map<String,Object>();
            User testUser = Util02_TestData.createUser();
            Account testAccount = Util02_TestData.createGroupAccount();
            System.runAs(testUser){
                Database.insert(testAccount);
               
                /***Account Record Creation***/
                Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(LGA_Constants.LGPROSPECT_ACC_RECORDTYPE).getRecordTypeId();
                List<Id> accRecordTypeList = new List<Id>();
                accRecordTypeList.add(accRecordTypeId);
                List<Account> testAccList = new List<Account>();
                testAccList.addAll(Anthem_TestDataFactory.generateAccount(accRecordTypeList));
                database.insert(testAccList);
                /***Opportunity Record Creation***/
                List<Id> oppRecordTypeList = new List<Id>();
                Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(LGA_Constants.NEWBUSINESSLOC_OPP_RECORDTYPE).getRecordTypeId();
                oppRecordTypeList.add(opportunityRecordTypeId);
                List<Opportunity> oppList = Anthem_TestDataFactory.generateOpportunity(oppRecordTypeList,testAccList[0].Id);        
                Database.insert(oppList, false);
                /***Product2 Record Creation***/
                Product2 product = Anthem_TestDataFactory.generateProduct2();   
                Database.insert(product, false);
                /***Pricebook Record Creation***/
                Id priceBookId = Anthem_TestDataFactory.generatePricebookId();
                
                /***PricebookEntry Record Creation***/
                PricebookEntry priceBookEntry = Anthem_TestDataFactory.generatePricebookEntry(product.Id,priceBookId);
                Database.insert(priceBookEntry, false);
                /***Quote Record Creation***/
                List<Id> quoteRecIdList = new List<Id>();
                Id largeGroupQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get(LGA_Constants.LARGEGRP_QUOTE).getRecordTypeId();         
                quoteRecIdList.add(largeGroupQuoteRecordTypeId);
                List<Quote> quoteList = Anthem_TestDataFactory.generateQuote(quoteRecIdList, priceBookId, oppList[0].Id);
                Database.insert(quoteList, false);
                system.assertNotEquals(null, quoteList,'Inserted Sucessfully');
                
                /***Quotelineitem Record Creation***/
                List<Id> quoteLineItem = new List<Id>();
                List<QuoteLineItem> quoteLineItemTest = Anthem_TestDataFactory.generateSoldQuoteLineItem(3, product.Id, quoteList[0].Id, priceBookEntry);       
                Database.insert(quoteLineItemTest, false);
                system.debug('*******QLI******' + quoteLineItemTest);
                
                /***Implementation Case Record Creation***/
                List<Order> testimplList = Anthem_TestDataFactory.generateImplementationCase(testAccList[0].Id, quoteList[0].Id, oppList[0].Id);
                database.insert(testimplList);
                // system.debug('@@@@@testimpl'+testimpl);
                
                /***document checklist record cration***/
                List<Application_Document_Checklist__c> adcsList = Anthem_TestDataFactory.generateDocumentChecklist(testimplList[0].Id);
                adcsList[0].Required__c = true;
                Database.insert(adcsList);
                
                List<Application_Document_Checklist__c> adcsList1 = Anthem_TestDataFactory.generateDocumentChecklist(testimplList[0].Id);
                adcsList1[0].Required__c = true;
                adcsList1[0].Status__c = LGA_Constants.DC_STATUS_SELF_INPUT;
                Database.insert(adcsList1);
                /***ContentVersion record Creation***/
                ContentVersion cv = Anthem_TestDataFactory.insertContentVersion();
                List<ContentVersion>  cvlst = new List<ContentVersion>();  
                Blob beforeblob=Blob.valueOf(LGA_Constants.TEST_FILENAME1);
                cv.VersionData = beforeblob;
                cvlst.add(cv);    
                
                Blob beforeblob1=Blob.valueOf(LGA_Constants.TEST_FILENAME2);
                ContentVersion cv1 = new ContentVersion();
                cv1.Title = LGA_Constants.TEST_CVTITLE2;
                cv1.PathOnClient = LGA_Constants.TEST_CVTITLE2;
                cv1.VersionData = beforeblob1;
                cvlst.add(cv1);     
                database.insert(cvlst);
                
                /*** Content Document record Creation***/
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId=:cvlst[0].id LIMIT 50000];
                /*** ContentDocumentLink record Creation***/
                List<ContentDocumentLink> cdlink = Anthem_TestDataFactory.generateContentDocumentLink(adcsList[0].Id,documents[0].id);
                Database.insert(cdlink); 
                Test.startTest();
                reqDcList = new LGA_RequiredDcList();
                String impId =  (String)testimplList[0].Id;
                List<String>deletedfiles = New List<String>();
                deletedfiles.add(adcsList[0].Id); //
                deletedfiles.add(adcsList1[0].Id);
                options.put(implementationCaseId,testimplList[0].Id);
                options.put(LGA_Constants.REMOTE_VALUE,LGA_Constants.SUBMIT_IPC);
                options.put(LGA_Constants.FILES_TO_BE_DELETED,deletedfiles);
                reqDcList.invokeMethod(LGA_Constants.GET_VALIDATION_ERROR,inputMap,outMap,options);
                LGA_RequiredDcList.deleteDCFiles(adcsList1[0].Id);
                Test.stopTest();
            }
        } catch (Exception ex) {
            system.debug('****The following exception has occurred: ' + ex.getMessage());
        }

    }    
}