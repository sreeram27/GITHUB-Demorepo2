/**
* @File Name          : LGA_Group_Number_Request_Test.cls
* @Description        : 
* @Author             : Accenture OffShore 
* @Group              : Raptors
* @Modification Log   : 
* Ver       Date            Author      		    Modification
* 1.0    2/14/2020     Accenture OffShore        Initial Version
**/
@isTest
public with sharing class LGA_Group_Number_Request_Test {
    
    /**
* @description : This Method is used to generate the test data.
* @author Accenture OffShore | 2/14/2020 
* @return void 
**/
    @testSetup static void setup(){
        
        Sic__c Sic = new Sic__c(Name = staticVariableClass.SIC);
        insert Sic;
        
        Account acc = new Account
            (
                RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Account).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGProspect).getRecordTypeId(),
                Name = staticVariableClass.AccountName,Account_s_Suppress_Auto_Renewal__c = false,Anthem_Entity__c = staticVariableClass.Entity,
                Region__c= staticVariableClass.Region, Branding__c =staticVariableClass.UniCare,SIC__c = SIC.Id,Group_Size__c =staticVariableClass.size,
                Total_Employees__c =staticVariableClass.emp, HQ_State__c =staticVariableClass.AK, Situs_State__c = staticVariableClass.California,
                Mailing_Address_Same_as_Physical_Address__c = true, BillingStreet = staticVariableClass.testAccBillingStreet, 
                BillingPostalCode = staticVariableClass.testAccBillingPostalCode,BillingCity =staticVariableClass.testAccBillingCity, 
                BillingCountry = staticVariableClass.testAccBillingCountry, BillingState = staticVariableClass.testAccBillingState, Physical_County__c =staticVariableClass.GroupNum
            );
        insert acc;
        
        List<Id> lstOpp= new List<Id>();
        
        Opportunity newOpp = new Opportunity(Name=  (String.valueOf(system.today().year() + 1) + staticVariableClass.NewBusinessLocalhyphen + acc.Name), 
                                             StageName = staticVariableClass.ClosedWon, AccountID = acc.id, CloseDate = ((system.TODAY())-95),                   
                                             RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Opportunity).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.NewBusinessLocal).getRecordTypeId());
        Database.insert(newOpp);
        
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        grp.name = LGA_Constants.TESTGRPNAME;
        grp.ClaimSystem__c= LGA_Constants.COMPASS;
        insert grp;
        
        Group__c grp1=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        grp1.name = 'Test129';
        grp1.ClaimSystem__c= LGA_Constants.COMPASS;
        insert grp1;        
        
        /***Product2 Record Creation***/
        Id prdRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(LGA_Constants.PRODUCT).getRecordTypeId();
        Product2 product = Anthem_TestDataFactory.generateProduct2();  
        product.recordtypeId = prdRecordTypeId ;
        product.Name = LGA_Constants.HRAPRDNAME;
        product.Category__c = LGA_Constants.PRODUCT;
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
        quoteLineItemTest[0].Plan_Type__c =LGA_Constants.CUSTOM;
        Database.insert(quoteLineItemTest, false);
        system.debug('@@@@@@@@@Product: '+ quoteLineItemTest);
        system.debug('@@@@@@@@@Product: '+  quoteLineItemTest[0].ProductCategory__c);
        
        
        Account_preferences__c accountpreferencescObj = new Account_preferences__c (
            Account_Legal_Name__c = acc.Id
            //Name = 'Test Acc Pref'
            //Customer_Requested_Group_Number__c = 'test value'
        );
        insert accountpreferencescObj;
        system.assert(quoteList.size()>0);
        
    }
    
    /**
* @description 
* @author Accenture OffShore| 2/14/2020 
* @return void 
**/
    @isTest static void testGRPNoReqst1() {
        // code_block	LGA_Constants.ACCOUNTID
        system.debug('@@@@@@@Inside testGRPNoReqst1');
        LGA_Group_Number_Request grpNoRqst = new LGA_Group_Number_Request();
        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> options4 = new Map<String,Object>();
        Map<String, Object> optns1 = new Map<String, Object>();
        Map<String, Object> optns2 = new Map<String, Object>();
        Map<String, Object> optns3 = new Map<String, Object>();
        
        List<Map<String,String>> qliGRPlst = new List<Map<String,String>>();
        Map<String,String> grpReqstMap = new Map<String,String>();
        Map<String,String> grpReqstMap1 = new Map<String,String>();
        Map<String,String> grpReqstMap2 = new Map<String,String>();
        String qliId = LGA_Constants.QLIIDSTR;
        String grpNo = LGA_Constants.GRPNOSTR;
        String claimSys = LGA_Constants.CLAIMSYSSTR;
        
        String accId ;
        String qteId;
        for(Account acc : [SELECT Id,Name From Account Where Name =:staticVariableClass.AccountName Limit 50000]){
            accId = (String)acc.Id;
        }
        List<QuoteLineItem> qteLst = new List<QuoteLineItem>();
        qteLst = [SELECT Id From QuoteLineItem Where QuoteId In (Select Id From Quote Where AccountId =:accId ) Limit 50000];
        
        
        grpReqstMap.put(qliId,qteLst[0].Id);
        grpReqstMap.put(grpNo,'Test12');
        grpReqstMap.put(claimSys,LGA_Constants.WGS2);
        qliGRPlst.add(grpReqstMap);
        grpReqstMap1.put(qliId,qteLst[1].Id);
        grpReqstMap1.put(grpNo,LGA_Constants.TESTGRPNAME);
        grpReqstMap1.put(claimSys,LGA_Constants.COMPASS);
        qliGRPlst.add(grpReqstMap1);
        grpReqstMap2.put(qliId,qteLst[2].Id);
        grpReqstMap2.put(grpNo,'Test12');
        grpReqstMap2.put(claimSys,LGA_Constants.WGS2);
        qliGRPlst.add(grpReqstMap2);
        
        //} 
        for(Quote qte : [SELECT Id From Quote Where AccountId =:accId Limit 50000]){
            qteId = (String)qte.Id;
        }
        //LGA_Constants.CHECKBOXVALUE   LGA_Constants.QUOTEID  LGA_Constants.GROUPNUMBER
        system.debug('@@@@@@@Inside testGRPNoReqst1 Before:    '+ accId);
        system.debug('@@@@@@@Inside testGRPNoReqst1 Before:    '+ qteId);
        options.put(LGA_Constants.CHECKBOXVALUE,true);
        options.put(LGA_Constants.QUOTEID,qteId);
        options.put(LGA_Constants.GROUPNUMBER,'test87');
        optns1.put(LGA_Constants.ACCOUNTID,accId);
        optns2.put(LGA_Constants.QLIGRPDETAILS,qliGRPlst);
        optns2.put(LGA_Constants.ACCOUNTID,accId);
        optns2.put(LGA_Constants.QUOTEID,qteId);

        options4.put(LGA_Constants.QUOTEID,qteId);
        options4.put(LGA_Constants.ACCOUNTID,accId);
        
        
        system.debug('@@@@@@@Inside testGRPNoReqst1 After:    '+ options);
        system.debug('@@@@@@@Inside testGRPNoReqst1 After:    '+ optns1);
        system.debug('@@@@@@@Inside testGRPNoReqst1 After:    '+ optns2);
        grpNoRqst.invokeMethod('fetchAccGrpDetails',inputMap,outMap,optns1);
        grpNoRqst.invokeMethod('qliGroupUpdate',inputMap,outMap,optns2);
        grpNoRqst.invokeMethod('accPreferenceUpdate',inputMap,outMap,options);
        grpNoRqst.invokeMethod('quoteGroupUpdate',inputMap,outMap,options4);
        
        system.assert(qteLst.size()>0);
        ///
        optns3.put(LGA_Constants.FLAGVAL,true);
        /**Test Coverage for LGA_AccStructquestion_validation Class**/
        LGA_AccStructquestion_validation accQuest = new LGA_AccStructquestion_validation(); //claimsRouteValidation
        accQuest.invokeMethod('claimsRouteValidation',inputMap,outMap,optns3);
        /***********************************************************/
        LGA_Get_QuotePickList_FieldValues qtepicVals = new LGA_Get_QuotePickList_FieldValues();
        qtepicVals.invokeMethod('getPicklistValues',inputMap,outMap,optns1);
    }
    
    /**
    * @description 
    * @author Accenture OffShore | 3/10/2020 
    * @return void 
    **/
    @isTest static void testGRPNoReqst2() {
        // code_block	LGA_Constants.ACCOUNTID
        system.debug('@@@@@@@Inside testGRPNoReqst1');
        LGA_Group_Number_Request grpNoRqst = new LGA_Group_Number_Request();
        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> options4 = new Map<String,Object>();
        Map<String, Object> optns1 = new Map<String, Object>();
        Map<String, Object> optns2 = new Map<String, Object>();
        Map<String, Object> optns3 = new Map<String, Object>();
        
        List<Map<String,String>> qliGRPlst = new List<Map<String,String>>();
        Map<String,String> grpReqstMap = new Map<String,String>();
        Map<String,String> grpReqstMap1 = new Map<String,String>();
        Map<String,String> grpReqstMap2 = new Map<String,String>();
        String qliId = LGA_Constants.QLIIDSTR;
        String grpNo = LGA_Constants.GRPNOSTR;
        String claimSys = LGA_Constants.CLAIMSYSSTR;
        
        String accId ;
        String qteId;
        for(Account acc : [SELECT Id,Name From Account Where Name =:staticVariableClass.AccountName Limit 50000]){
            accId = (String)acc.Id;
        }
        List<QuoteLineItem> qteLst = new List<QuoteLineItem>();
        qteLst = [SELECT Id From QuoteLineItem Where QuoteId In (Select Id From Quote Where AccountId =:accId ) Limit 50000];//'Test129'
        
        List<Group__c> grpLst = new List<Group__c>();
        Group__c grp1;
        for(Group__c grp:[SELECT Id,Name,ClaimSystem__c From Group__c Where name = 'Test129'   Limit 50000]){
            grp1 = new Group__c();
            grp1.id = grp.id;
            grp1.ClaimSystem__c = LGA_Constants.WGS2;
            
            grpLst.add(grp1);
        }
        List<Quote> qteLsts = new List<Quote>();
        Quote qtes;
        for(Quote qte : [SELECT Id,GroupNumber__c From Quote Where AccountId =:accId Limit 50000]){
            qtes = new Quote();
            qtes.GroupNumber__c = null;
            qtes.Id = qte.Id;
            
            qteLsts.add(qtes);
        }
        
        database.update(grpLst,False);
        database.update(qteLsts,False);
        grpReqstMap.put(qliId,qteLst[0].Id);
        grpReqstMap.put(grpNo,'Test12');
        grpReqstMap.put(claimSys,LGA_Constants.WGS2);
        qliGRPlst.add(grpReqstMap);
        grpReqstMap1.put(qliId,qteLst[1].Id);
        grpReqstMap1.put(grpNo,LGA_Constants.TESTGRPNAME);
        grpReqstMap1.put(claimSys,LGA_Constants.COMPASS);
        qliGRPlst.add(grpReqstMap1);
        grpReqstMap2.put(qliId,qteLst[2].Id);
        grpReqstMap2.put(grpNo,'Test12');
        grpReqstMap2.put(claimSys,LGA_Constants.WGS2);
        qliGRPlst.add(grpReqstMap2);
        
        //} 
        for(Quote qte : [SELECT Id From Quote Where AccountId =:accId Limit 50000]){
            qteId = (String)qte.Id;
        }
        //LGA_Constants.CHECKBOXVALUE   LGA_Constants.QUOTEID  LGA_Constants.GROUPNUMBER
        system.debug('@@@@@@@Inside testGRPNoReqst1 Before:    '+ accId);
        system.debug('@@@@@@@Inside testGRPNoReqst1 Before:    '+ qteId);
        options.put(LGA_Constants.CHECKBOXVALUE,true);
        options.put(LGA_Constants.QUOTEID,qteId);
        options.put(LGA_Constants.GROUPNUMBER,'test87');
        optns1.put(LGA_Constants.ACCOUNTID,accId);
        optns2.put(LGA_Constants.QLIGRPDETAILS,qliGRPlst);
        optns2.put(LGA_Constants.ACCOUNTID,accId);
        optns2.put(LGA_Constants.QUOTEID,qteId);

        options4.put(LGA_Constants.QUOTEID,qteId);
        options4.put(LGA_Constants.ACCOUNTID,accId);
        
        
        system.debug('@@@@@@@Inside testGRPNoReqst1 After:    '+ options);
        system.debug('@@@@@@@Inside testGRPNoReqst1 After:    '+ optns1);
        system.debug('@@@@@@@Inside testGRPNoReqst1 After:    '+ optns2);
        grpNoRqst.invokeMethod('fetchAccGrpDetails',inputMap,outMap,optns1);
        grpNoRqst.invokeMethod('qliGroupUpdate',inputMap,outMap,optns2);
        grpNoRqst.invokeMethod('accPreferenceUpdate',inputMap,outMap,options);
        grpNoRqst.invokeMethod('quoteGroupUpdate',inputMap,outMap,options4);
        
        system.assert(qteLst.size()>0);
        ///
        optns3.put(LGA_Constants.FLAGVAL,true);
        /**Test Coverage for LGA_AccStructquestion_validation Class**/
        LGA_AccStructquestion_validation accQuest = new LGA_AccStructquestion_validation(); //claimsRouteValidation
        accQuest.invokeMethod('claimsRouteValidation',inputMap,outMap,optns3);
        /***********************************************************/
        LGA_Get_QuotePickList_FieldValues qtepicVals = new LGA_Get_QuotePickList_FieldValues();
        qtepicVals.invokeMethod('getPicklistValues',inputMap,outMap,optns1);
    }
    
    /**
    * @description 
    * @author Accenture off Shore | 3/10/2020 
    * @return void 
    **/
    @isTest static void testGRPNoReqst3() {
        // code_block	LGA_Constants.ACCOUNTID
        system.debug('@@@@@@@Inside testGRPNoReqst1');
        LGA_Group_Number_Request grpNoRqst = new LGA_Group_Number_Request();
        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> options4 = new Map<String,Object>();
        Map<String, Object> optns1 = new Map<String, Object>();
        Map<String, Object> optns2 = new Map<String, Object>();
        Map<String, Object> optns3 = new Map<String, Object>();
        
        List<Map<String,String>> qliGRPlst = new List<Map<String,String>>();
        Map<String,String> grpReqstMap = new Map<String,String>();
        Map<String,String> grpReqstMap1 = new Map<String,String>();
        Map<String,String> grpReqstMap2 = new Map<String,String>();
        String qliId = LGA_Constants.QLIIDSTR;
        String grpNo = LGA_Constants.GRPNOSTR;
        String claimSys = LGA_Constants.CLAIMSYSSTR;
        
        String accId ;
        String qteId;
        for(Account acc : [SELECT Id,Name From Account Where Name =:staticVariableClass.AccountName Limit 50000]){
            accId = (String)acc.Id;
        }
        List<QuoteLineItem> qteLst = new List<QuoteLineItem>();
        qteLst = [SELECT Id From QuoteLineItem Where QuoteId In (Select Id From Quote Where AccountId =:accId ) Limit 50000];//'Test129'
        
        List<Group__c> grpLst = new List<Group__c>();
        Group__c grp1;
        for(Group__c grp:[SELECT Id,Name,ClaimSystem__c,IsActive__c From Group__c Where name = 'Test129'   Limit 50000]){
            grp1 = new Group__c();
            grp1.id = grp.id;
            grp1.ClaimSystem__c = LGA_Constants.WGS2;
            grp1.IsActive__c = false;
            
            grpLst.add(grp1);
        }
        database.update(grpLst,False);
        
        List<Quote> qteLsts = new List<Quote>();
        Quote qtes;
        for(Quote qte : [SELECT Id,GroupNumber__c From Quote Where AccountId =:accId Limit 50000]){
            qtes = new Quote();
            qtes.GroupNumber__c = grpLst[0].Id;
            qtes.Id = qte.Id;
            
            qteLsts.add(qtes);
        }
        database.update(qteLsts,False);
        grpReqstMap.put(qliId,qteLst[0].Id);
        grpReqstMap.put(grpNo,'Test12');
        grpReqstMap.put(claimSys,LGA_Constants.WGS2);
        qliGRPlst.add(grpReqstMap);
        grpReqstMap1.put(qliId,qteLst[1].Id);
        grpReqstMap1.put(grpNo,LGA_Constants.TESTGRPNAME);
        grpReqstMap1.put(claimSys,LGA_Constants.COMPASS);
        qliGRPlst.add(grpReqstMap1);
        grpReqstMap2.put(qliId,qteLst[2].Id);
        grpReqstMap2.put(grpNo,'Test12');
        grpReqstMap2.put(claimSys,LGA_Constants.WGS2);
        qliGRPlst.add(grpReqstMap2);
        
        //} 
        for(Quote qte : [SELECT Id From Quote Where AccountId =:accId Limit 50000]){
            qteId = (String)qte.Id;
        }
        //LGA_Constants.CHECKBOXVALUE   LGA_Constants.QUOTEID  LGA_Constants.GROUPNUMBER
        system.debug('@@@@@@@Inside testGRPNoReqst1 Before:    '+ accId);
        system.debug('@@@@@@@Inside testGRPNoReqst1 Before:    '+ qteId);
        options.put(LGA_Constants.CHECKBOXVALUE,true);
        options.put(LGA_Constants.QUOTEID,qteId);
        options.put(LGA_Constants.GROUPNUMBER,'test87');
        optns1.put(LGA_Constants.ACCOUNTID,accId);
        optns2.put(LGA_Constants.QLIGRPDETAILS,qliGRPlst);
        optns2.put(LGA_Constants.ACCOUNTID,accId);
        optns2.put(LGA_Constants.QUOTEID,qteId);

        options4.put(LGA_Constants.QUOTEID,qteId);
        options4.put(LGA_Constants.ACCOUNTID,accId);
        
        
        system.debug('@@@@@@@Inside testGRPNoReqst1 After:    '+ options);
        system.debug('@@@@@@@Inside testGRPNoReqst1 After:    '+ optns1);
        system.debug('@@@@@@@Inside testGRPNoReqst1 After:    '+ optns2);
        grpNoRqst.invokeMethod('fetchAccGrpDetails',inputMap,outMap,optns1);
        grpNoRqst.invokeMethod('qliGroupUpdate',inputMap,outMap,optns2);
        grpNoRqst.invokeMethod('accPreferenceUpdate',inputMap,outMap,options);
        grpNoRqst.invokeMethod('quoteGroupUpdate',inputMap,outMap,options4);
        
        system.assert(qteLst.size()>0);
        ///
        optns3.put(LGA_Constants.FLAGVAL,true);
        /**Test Coverage for LGA_AccStructquestion_validation Class**/
        LGA_AccStructquestion_validation accQuest = new LGA_AccStructquestion_validation(); //claimsRouteValidation
        accQuest.invokeMethod('claimsRouteValidation',inputMap,outMap,optns3);
        /***********************************************************/
        LGA_Get_QuotePickList_FieldValues qtepicVals = new LGA_Get_QuotePickList_FieldValues();
        qtepicVals.invokeMethod('getPicklistValues',inputMap,outMap,optns1);
    }
    
    
}