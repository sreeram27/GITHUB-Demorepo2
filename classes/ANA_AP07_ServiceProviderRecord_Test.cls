/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest(SeeAllData=false)
private without sharing class ANA_AP07_ServiceProviderRecord_Test {
    private static List<Quote> qteList=new List<Quote>();
    private static List<QuoteLineItem> qliList = new List<QuoteLineItem>();
    private static final string NATIONALAMPROFILE='National Sales';
    /*This method is used to covers the SPR class using Account competitor true*/
     static testMethod void upsertsprecordAccComp(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user1=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user1){
            Test.StartTest();
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Service Provider');
            brAcc.Competitor__c=true;
            system.assertEquals(true, brAcc.Competitor__c);
            database.insert(brAcc);
            List<Opportunity> opties=ANA_UTIL01_TestMethods.createOpportunities(100,true,brAcc.Id);
            for(Opportunity opt:opties){
                qteList.add(ANA_UTIL01_TestMethods.createQuote(false,opt.id));
            }
            database.insert(qteList); 
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            quotelineitem alite = ANA_UTIL01_TestMethods.createQuoteLineItem(false,qteList.get(0).id,pbe.id);
            alite.Competitor__c = brAcc.id;
            alite.ProductStage__c = 'Sold';
            database.insert(alite);
            ServiceProviderRelationship__c  sprec= ANA_UTIL01_TestMethods.createServiceProviderRelationshipRecord(false,brAcc.id);
            sprec.Account__c = brAcc.id;
            sprec.Vendor__c= brAcc.id;
            database.insert(sprec);
            system.debug('inserted sprec is '+sprec);
            list<ServiceProviderRelationship__c>  listsprec= new list<ServiceProviderRelationship__c>();
            listsprec.add(sprec);
            //Added the below lines to increase the test coverage of the class ANA_UTIL05_AccessSPRDataUtil-start  
            list<ServiceProviderRelationship__c>  listsprec2;
            List<QuotelineItem> listqlitems;
            //Added the lines to increase the test coverage of the class ANA_UTIL05_AccessSPRDataUtil-end
              
            ANA_UTIL05_AccessSPRDataUtil.upsertServiceProviderRecord(listsprec);
            //Added the below lines to increase the test coverage of the class ANA_UTIL05_AccessSPRDataUtil-start
            ANA_UTIL05_AccessSPRDataUtil.upsertServiceProviderRecord(listsprec2);
            ANA_UTIL05_AccessSPRDataUtil.updateQuotelineitem(listqlitems);
             //Added the lines to increase the test coverage of the class ANA_UTIL05_AccessSPRDataUtil-end
            map<Id,QuotelineItem> mapqlitem = new map<Id,QuotelineItem>([select ProductStage__c,associatedAccountId__c,Competitor__c from QuotelineItem where Id =: alite.Id limit 1]);
            ANA_AP07_ServiceProviderRecord.qlineitemids.addAll(mapqlitem.keyset());
            ANA_AP07_ServiceProviderRecord.serviceProviderRecordupsert(mapqlitem);
            Test.StopTest();
        }
    }
     static testMethod void upsertnonsprecordAccComp(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user1=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user1){
            Test.StartTest();
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Service Provider');
            brAcc.Competitor__c=true;
            database.insert(brAcc);
            
            Account venacc=ANA_UTIL01_TestMethods.createAccount(false);
            venacc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Service Provider');
            venacc.Competitor__c=false;
            database.insert(venacc);
            system.assertEquals(true, brAcc.Competitor__c);
            
            List<Opportunity> opties=ANA_UTIL01_TestMethods.createOpportunities(100,true,brAcc.Id);
            for(Opportunity opt:opties){
                qteList.add(ANA_UTIL01_TestMethods.createQuote(false,opt.id));
            }
            database.insert(qteList); 
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            quotelineitem alite = ANA_UTIL01_TestMethods.createQuoteLineItem(false,qteList.get(0).id,pbe.id);
            alite.Competitor__c = brAcc.id;
            alite.ProductStage__c = 'Sold';
            database.insert(alite);
            ServiceProviderRelationship__c  sprec= ANA_UTIL01_TestMethods.createServiceProviderRelationshipRecord(false,brAcc.id);
            sprec.Account__c = brAcc.id;
            sprec.Vendor__c= venacc.id;
            database.insert(sprec);
            list<ServiceProviderRelationship__c> sprlist = new list<ServiceProviderRelationship__c>();
            sprlist.add(sprec);
            map<Id,QuotelineItem> mapqlitem = new map<Id,QuotelineItem>([select ProductStage__c,associatedAccountId__c,Competitor__c from QuotelineItem where Id =: alite.Id limit 1]);
            ANA_AP07_ServiceProviderRecord.serviceProviderRecordupsert(mapqlitem);
            ANA_AP07_ServiceProviderRecord.assignsprtoqlitem(sprlist,mapqlitem);
            Test.StopTest();
        }
    }
    
}