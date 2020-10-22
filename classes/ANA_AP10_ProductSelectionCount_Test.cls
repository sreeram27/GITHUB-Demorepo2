/**
@Author : Accenture Offshore Dev team
@name : ANA_AP10_Product_Selection_Count_Test
@CreateDate :27-06-2017
@Description : ANA_AP10_Product_Selection_Count_Test class. 
checks for positive and negative cases.
*/
@isTest
private class ANA_AP10_ProductSelectionCount_Test {
private static List<Quote> qteList=new List<Quote>();
private static List<QuoteLineItem> parentQliList = new List<QuoteLineItem>();
private static List<ProductSelectionDetail__c> pSDList = new List<ProductSelectionDetail__c>();
private static List<ProductSelectionDetail__c> updatePsdList = new List<ProductSelectionDetail__c>();
private static final string NATIONALAMPROFILE='National Sales';
    /*This method will create Account,Opportunity,Quote,QuoteLineItem and Product Selection Detail records and assigns QLI with child ProductSelection to test the trigger for positive scenario.*/
     static testMethod void processPSDPositive(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        //user.BypassValidation__c =true;
        system.runAs(user){
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Customer');
            database.insert(brAcc);
            Opportunity opty1=ANA_UTIL01_TestMethods.createOpportunity(false,brAcc.Id);
            database.insert(opty1);
            Quote qte=ANA_UTIL01_TestMethods.createQuote(false,opty1.id);
            database.insert(qte);
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            parentQliList.addAll(ANA_UTIL01_TestMethods.createQuoteLineItems(2,false,qte.id,pbe.id)); 
            database.insert(parentQliList);
            pSDList.addAll(ANA_UTIL01_TestMethods.createPSDRecord(parentQliList,false));
            Database.SaveResult[] srList = database.insert(pSDList);
            System.assertEquals(srList.size(), 2);
            // below code will update child PSD with different parent//
            updatePsdList = ANA_UTIL01_TestMethods.AssignParentToChild(pSDList,parentQliList);
            ANA_ProductSelectionTrigger_Handler.isRecursiveupdate  = false;
            Database.SaveResult[] upList = database.update(updatePsdList);
            System.assertEquals(upList.size(), 2);
            // below code will delete child PSD//
            Database.DeleteResult[] drList = database.delete(updatePsdList);
            System.assertEquals(drList.size(), 2);
      }
 }
 /*This method created for executing negative scenario*/
    static testMethod void processPSDNegative(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];  
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user){
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Customer');
            database.insert(brAcc);    
            Opportunity opty1=ANA_UTIL01_TestMethods.createOpportunity(false,brAcc.Id);
            database.insert(opty1);         
            qteList=ANA_UTIL01_TestMethods.createQuotes(2,false,opty1.id);
            database.insert(qteList); 
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            parentQliList.addAll(ANA_UTIL01_TestMethods.createQuoteLineItem_ForQuote(false,qteList,pbe.id));                   
            database.insert(parentQliList);
            pSDList.addAll(ANA_UTIL01_TestMethods.createPSDRecord(parentQliList,false));
            Database.SaveResult[] srList = database.insert(pSDList);
            ANA_AP10_ProductSelectionCount pcc= new ANA_AP10_ProductSelectionCount();
            pcc.processChildCount(null,NULL,null,NULL);

        }
    }
        /*This method created for bulk operations*/
     static testMethod void processBulkPSD(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];  
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user){
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Customer');
            database.insert(brAcc);
            Opportunity opty1=ANA_UTIL01_TestMethods.createOpportunity(false,brAcc.Id);
            database.insert(opty1);  
            Quote qte=ANA_UTIL01_TestMethods.createQuote(false,opty1.id);
            database.insert(qte);
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            parentQliList.addAll(ANA_UTIL01_TestMethods.createQuoteLineItems(200,false,qte.id,pbe.id)); 
            database.insert(parentQliList);
            pSDList.addAll(ANA_UTIL01_TestMethods.createPSDRecord(parentQliList,false));
            Database.SaveResult[] srList = database.insert(pSDList);
            System.assertEquals(srList.size(), 200);
            // below code will update child PSD with different parent//
            updatePsdList = ANA_UTIL01_TestMethods.AssignParentToChild(pSDList,parentQliList);
            ANA_ProductSelectionTrigger_Handler.isRecursiveupdate  = false;
            Database.SaveResult[] upList = database.update(updatePsdList);
            System.assertEquals(upList.size(), 200);
            database.update(updatePsdList);
            // below code will delete child PSD//
            Database.DeleteResult[] drList = database.delete(updatePsdList);
            System.assertEquals(drList.size(), 200);
            }
   }         
      }