/*******************************************************************************************
@class Name  : LGA_GetPharmacyBenefitData_Test
@created By  : IDC Offshore
@createdDate : 01/30/2020
@description : This test class is for LGA_GetPharmacyBenefitData_Test
********************************************************************************************/
@isTest
public with sharing class LGA_GetPharmacyBenefitData_Test {
    
    
    /**
* @description 
* @author IDC Offshore | 1/31/2020 
* @return void 
**/
    @testSetup static void idCardRecordCreation_TestDataSetup() 
    {
        Sic__c sic = new Sic__c(Name = staticVariableClass.SIC);
        database.insert(sic,false);
        
        Account acc =new Account
            (
                RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Account).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGProspect).getRecordTypeId(),
                Name = staticVariableClass.AccountName,Account_s_Suppress_Auto_Renewal__c = false,Anthem_Entity__c = staticVariableClass.Entity,
                Region__c= staticVariableClass.Region, Branding__c =staticVariableClass.UniCare,SIC__c = SIC.Id,Group_Size__c =staticVariableClass.size,
                Total_Employees__c =staticVariableClass.emp, HQ_State__c =staticVariableClass.AK, Situs_State__c = staticVariableClass.California,
                Mailing_Address_Same_as_Physical_Address__c = true, BillingStreet = staticVariableClass.testAccBillingStreet, 
                BillingPostalCode = staticVariableClass.testAccBillingPostalCode,BillingCity =staticVariableClass.testAccBillingCity, 
                BillingCountry = staticVariableClass.testAccBillingCountry, BillingState = staticVariableClass.testAccBillingState, Physical_County__c =staticVariableClass.GroupNum
            );
            database.insert(acc,false);
        
        List<Id> lstOpp= new List<Id>();
        
        Opportunity newOpp = new Opportunity(Name=  (String.valueOf(system.today().year() + 1) + staticVariableClass.NewBusinessLocalhyphen + acc.Name), 
                                             StageName = staticVariableClass.ClosedWon, AccountID = acc.id, CloseDate = ((system.TODAY())-95),                   
                                             RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Opportunity).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.NewBusinessLocal).getRecordTypeId());
        database.insert(newOpp,false);
        
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        grp.name = LGA_Constants.TESTGRPNAME;
        //grp.ClaimSystem__c='NASCO';
        database.insert(grp);
        
        
        /***Product2 Record Creation***/
        Id prdRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(LGA_Constants.PRODUCT).getRecordTypeId();
        Product2 product = Anthem_TestDataFactory.generateProduct2();  
        product.recordtypeId = prdRecordTypeId ;
        product.Name = LGA_Constants.HRAPRDNAME;
        product.Category__c = LGA_Constants.PLAN;
        Database.insert(product, false);  
        
        system.debug('@@@@@@@@@Product: '+ product);
        /***Pricebook Record Creation***/
        Id priceBookId = Anthem_TestDataFactory.generatePricebookId();
        
        /***PricebookEntry Record Creation***/
        PricebookEntry priceBookEntry = Anthem_TestDataFactory.generatePricebookEntry(product.Id,priceBookId);
        Database.insert(priceBookEntry, false);
        /***Quote Record Creation***/
        List<Id> quoteRecIdList = new List<Id>();
        Id largeGroupQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get(LGA_Constants.LARGEGRP_QUOTE).getRecordTypeId();         
        quoteRecIdList.add(largeGroupQuoteRecordTypeId);
        List<Quote> quoteList = Anthem_TestDataFactory.generateQuote(quoteRecIdList, priceBookId, newOpp.Id);
        //Quote qte=ANA_UTIL01_TestMethods.createQuote(false,newOpp.Id);
        quoteList[0].GroupNumber__c=grp.id;
        Database.insert(quoteList, false);
        
        
        List<QuoteLineItem> quoteLineItemTest = Anthem_TestDataFactory.generateSoldQuoteLineItem(3, product.Id, quoteList[0].Id, priceBookEntry);
        //quoteLineItemTest[0].ProductCategory__c =LGA_Constants.PLAN;
        quoteLineItemTest[0].Plan_Type__c =LGA_Constants.CUSTOM;
        //quoteLineItemTest[0].ProductCategory__c= LGA_Constants.PLAN;
        Database.insert(quoteLineItemTest, false);
        system.debug('@@@@@@@@@Product: '+ quoteLineItemTest);
        system.debug('@@@@@@@@@Product: '+  quoteLineItemTest[0].ProductCategory__c);
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name= :staticVariableClass.LocalImplementations Limit 50000]; 
        User user2 = new User(Alias = staticVariableClass.userAlias, Email=staticVariableClass.userEmail, EmailEncodingKey=staticVariableClass.userEmailEncodingKey, LastName=staticVariableClass.userLastName, 
                              LanguageLocaleKey=staticVariableClass.userLocaleSidKey, LocaleSidKey=staticVariableClass.userLocaleSidKey, ProfileId = p1.Id, TimeZoneSidKey=staticVariableClass.userTimeZoneSidKey, 
                              UserName=staticVariableClass.userUsername);
        database.insert(user2,false);
        Id ordRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get(LGA_Constants.NEWBUSINESS).getRecordTypeId();
        system.debug('@@@@@@@@ordRecordTypeId: '+ ordRecordTypeId);
        Order ord = new Order(Group_Name__c=grp.id,AccountId = acc.Id, EffectiveDate=System.today(), Status = staticVariableClass.Draft,User_Group__c =staticVariableClass.LocalNewBusiness,
                              Implementation_Case_Name__c = staticVariableClass.AIMTesting03, Discovery_Call_Desired__c =staticVariableClass.UpsellYes, Implementation_Status__c = staticVariableClass.ReadyforImps, 
                              Implementation_Effective_Date__c=System.today(), Assigned_Implementer__c=user2.id,QuoteId=quoteList[0].id);
        ord.RecordTypeId = ordRecordTypeId;
        database.insert(new list<Order>{ord}, false) ;
        Group_Plan_Design__c gpd1 = new Group_Plan_Design__c();
        gpd1.Account_Legal_Name__c = acc.Id;
        gpd1.Group__c = grp.Id;
        gpd1.QuoteLineItem_Record_ID__c = quoteLineItemTest[0].Id;
        database.insert(gpd1);
        //system.debug('ord.Implementation_Status__c'+ord.Implementation_Status__c);
    }
    
    /**
* @description 
* @author IDC Offshore | 1/31/2020 
* @return void 
**/
    @isTest static void pharmacyBenefitIdentifierTestMethod() {
        
        Test.startTest();
        
        //Fetch User
        List<User> userList =[SELECT id FROM User WHERE email =:staticVariableClass.userEmail LIMIT 1];
        //'Test123';
        List<Group__c> grp = [SELECT Id FROM Group__c Where Name = 'Test123' Limit 50000];
        // Fetch the parent Order Record
        List<Order> ordList = [SELECT Id,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1];
        ordList[0].Assigned_Implementer__c=userList[0].id;
        database.update(ordList,false);
        
        // Update the Order record status
        ordList[0].Implementation_Status__c = staticVariableClass.PendingSmeReview;
        ordList[0].Implementation_Status__c = 'YES';  
        database.update(ordList,false);
        
        // Create LOCAL Implementation Tracking and it related Records
        Implementation_Tracking__c localImpTrack = new Implementation_Tracking__c();
        localImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(staticVariableClass.LocalNASCOandWGS).getRecordTypeId();
        localImpTrack.Implementation_Record_ID__c = ordList[0].Id;
        localImpTrack.Group_Number__c = grp[0].Id;
        database.insert(localImpTrack,false);
        
        
        Rx__c rx = new Rx__c();
        rx.Implementation_Tracking_ID__c = localImpTrack.ID;
        rx.Stage__c = '04 Approved';
        database.insert(rx,false);
        
        
        List<Map<String,String>> updateQLIList = new List<Map<String,String>>();
        Map<String,String> qliDataMap = new Map<String,String>();
        List<Quotelineitem> qliList = [SELECT Id,Pharmacy_Benefit_Identifier__c From quotelineitem Where QuoteId IN (Select ID From Quote Where Name = 'test quote0') LIMIT 50000] ;
        for(Quotelineitem qli : qliList){
            
            qliDataMap.put(LGA_Constants.ID,qli.Id );
            qliDataMap.put(LGA_Constants.NAME,'Test 123' );
            
            updateQLIList.add(qliDataMap);
        }
        system.debug('@@@@@@@@@@updateQLIList: ' + updateQLIList);
        system.debug('@@@@@@@@@@updateQLIList: ' + updateQLIList.size());
        
        /***User Creation***/
        //User testUser = Util02_TestData.createUser();
        Profile txtProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1]; 
        //UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User tstUser = new User(Alias = 'standt1', Email='standarduser@testorg1.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = txtProfile.Id,
                                TimeZoneSidKey='America/Los_Angeles', UserName='standardUSER989999@testOrg.com'+DateTime.now().millisecond());
        database.insert(tstUser);
        Profile txtProfile2 = [SELECT Id FROM Profile WHERE Name='Local Sales' Limit 1]; 
        //UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User tstUser2 = new User(Alias = 'standt1', Email='standarduser@testorg1.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = txtProfile2.Id,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='standardUSER989999@testOrg.com'+DateTime.now().millisecond());
        database.insert(tstUser2);
        String recId = rx.Id;
        LGA_GetPharmacyBenefitData.getPharmacyBenefitData(rx.Id);
        LGA_GetPharmacyBenefitData.savePBIData(updateQLIList,recId);
        LGA_GetPharmacyBenefitData.showLWCdata(tstUser2.Id);
        LGA_GetPharmacyBenefitData.showLWCdata(tstUser.Id);
        Test.stopTest();
        System.assertNotEquals(null,rx.Id);
    }
    
}