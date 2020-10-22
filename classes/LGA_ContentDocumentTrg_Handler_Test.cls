/**********************************************************************************
Class Name :   LGA_ContentDocumentTrg_Handler_Test
Date Created : 5-August-2019
Created By   : IDC Offshore
@description : Test class for LGA_ContentDocumentTrg_Handler
*************************************************************************************/
@isTest(SeeAllData=false)
public with sharing class LGA_ContentDocumentTrg_Handler_Test {
    @isTest(SeeAllData=false)
    public static void method(){
        // User Creation
        User testUser = Util02_TestData.createUser();
        System.runAs(testUser){
        //Account Record Creation
        Account testAcc = Util02_TestData.createGroupAccount();
        database.insert(testAcc);

        
        //Opportunity record creation
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test_Opp';
        testOpp.AccountId = testAcc.Id;
        testOpp.StageName = 'Initiated';
        testOpp.CloseDate = date.newInstance(2020, 01, 01);
        database.insert(testOpp); 
            
        //Application record creation
        vlocity_ins__Application__c testApp = Util02_TestData.createApplicationRec(testAcc.Id, testOpp.Id);
        testApp.AccountLegalName__c = testAcc.Id;
        database.insert(testApp);
            
        //Implementation record creation
        Order testimpl = new Order();
        testimpl.Implementation_Case_Name__c = 'Test IMPL';
        testimpl.AccountId = testAcc.Id;
        testimpl.Status = 'Draft';
        testimpl.Implementation_Effective_Date__c = date.newInstance(2018, 07, 30);
        testimpl.Discovery_Call_Desired__c = 'Yes';
        testimpl.Account_Manager__c = testUser.Id;
        testimpl.EffectiveDate = date.newInstance(2019, 07, 30);
        database.insert(testimpl);

            
        //Document Checklist creation
        List<Application_Document_Checklist__c> dclst = new List<Application_Document_Checklist__c>();
        Application_Document_Checklist__c dc1 = new Application_Document_Checklist__c();
        dc1.Document_Name__c = 'Test_1123';
        dc1.Implementation_Case__c = testimpl.Id;
        dclst.add(dc1); 
        database.insert(dclst);
            

        /***ContentVersion Creation***/
        List<ContentVersion>  cvlst = new List<ContentVersion>();  
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test_1123';
        cv.PathOnClient = 'test';
        cv.VersionData = beforeblob;
        cvlst.add(cv);
        database.insert(cvlst);
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where LatestPublishedVersionId IN: cvlst Limit 50000];

            
         /**************ContentDocumentLink*************/
        List<ContentDocumentLink> cdlinklst = new List<ContentDocumentLink>();    
        ContentDocumentLink cdlink1 = new ContentDocumentLink();
        cdlink1.ContentDocumentId = documents[0].id;
        cdlink1.LinkedEntityId = dc1.Id;
        cdlink1.ShareType = 'V';
        cdlink1.Visibility = 'AllUsers';
        cdlinklst.add(cdlink1); 
        database.insert(cdlinklst);
        system.assert(cdlinklst.size()>0,'Hii Success');
            
         LGA_ContentDocumentTrg_Handler var1 = new LGA_ContentDocumentTrg_Handler();
         var1.removeOrderFileDetails(documents);
            
        }
    }
}