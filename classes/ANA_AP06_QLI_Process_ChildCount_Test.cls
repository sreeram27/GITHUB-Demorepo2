/**
@Author : Accenture Offshore Dev team
@name : ANA_AP06_QLI_Process_ChildCount_Test
@CreateDate :01-06-2017
@Description : ANA_AP06_QLI_Process_ChildCount class. 
checks for positive and negative cases.
*/
@isTest(SeeAllData=false)
private without sharing class ANA_AP06_QLI_Process_ChildCount_Test {
    private static Opportunity oppt;
    private static List<Quote> qteList=new List<Quote>();
    private static List<QuoteLineItem> parentQliList = new List<QuoteLineItem>();
    private static List<QuoteLineItem> childQliList = new List<QuoteLineItem>();
    private static List<QuoteLineItem> updateQliList = new List<QuoteLineItem>();
    private static List<QuoteLineItem> newQliList = new List<QuoteLineItem>();
    //Added the below line to increase the test coverage of the class ANA_UTIL11_AccessAlternateNetworkUtil-start
    private static List<AlternateNetwork__c> newAltNetworklist = new List<AlternateNetwork__c>();
    //Added the line to increase the test coverage of the class ANA_UTIL11_AccessAlternateNetworkUtil-end
    
    //Added the below line to increase the test coverage of the class ANA_UTIL10_AccessProductSelectionUtil-start   
    private static List<ProductSelectionDetail__c> Prdctseldetail = new List<ProductSelectionDetail__c>();
    //Added the line to increase the test coverage of the class ANA_UTIL10_AccessProductSelectionUtil-end
    
    private static final string NATIONALAMPROFILE='National Sales';
    private static final Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
    /*This method will create Account,Opportunity,Quote and QuoteLineItem records and assigns parent QLI with child QLI to test the trigger for positive scenario.*/
     static testMethod void processQLIPositive(){
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        user.AllowQLIDelete__c =true;
        system.runAs(user){
              Test.StartTest();
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Customer');
            database.insert(brAcc);
            Opportunity opty1=ANA_UTIL01_TestMethods.createOpportunity(false,brAcc.Id);
            database.insert(opty1);
            Quote qte=ANA_UTIL01_TestMethods.createQuote(false,opty1.id);
            database.insert(qte);
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd);
            Product2 prd1=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd1);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            PricebookEntry pbe1=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd1.id);
            database.insert(pbe1);
            vlocity_ins__ProductChildItem__c Vlc = ANA_UTIL01_TestMethods.createChildProduct(prd.id,prd1.id,false);
            database.insert(Vlc);
            parentQliList.addAll(ANA_UTIL01_TestMethods.createQuoteLineItems(2,false,qte.id,pbe.id)); 
            database.insert(parentQliList);

            //Add Begin - PRDCRM-40725:ActWise Companion Product
            List<QuoteLineItem> actWiseQLIList = ANA_UTIL01_TestMethods.createQuoteLineItems(1,true,qte.id,pbe.id);
            QuoteLineItem actWiseQLI = actWiseQLIList[0];    
            //Add End - PRDCRM-40725:ActWise Companion Product

            for(QuoteLineItem qli:parentQliList){
                qli.ProductLineApprovalStatus__c = 'Approved';
                qli.ActWiseChildQuote__c = actWiseQLI.Id;
                newQliList.add(qli);
            }

            //Add Begin - PRDCRM-40725:ActWise Companion Product
            actWiseQLI.ParentQuoteLineItem__c = newQliList[0].Id; //Add PRDCRM-40725:ActWise Companion Product
            update actWiseQLI;
            //Add End - PRDCRM-40725:ActWise Companion Product
            
            update newQliList;
            childQliList.addAll(ANA_UTIL01_TestMethods.createChildQuoteLineItems(parentQliList,false,qte.id,pbe.id));
            Database.SaveResult[] srList = database.insert(childQliList);
            System.assertEquals(srList.size(), 2);
            // below code will update child QLI with different parent//
            updateQliList = ANA_UTIL01_TestMethods.swapAssignParentToChildQLI(childQliList,parentQliList);
            ANA_QuoteLineItemTrigger_Handler.isRecursiveupdate  = false;
            Database.SaveResult[] upList = database.update(updateQliList);
            System.assertEquals(upList.size(), 2);
            // below code will delete child QLI//
            Database.DeleteResult[] drList = database.delete(updateQliList);
            System.assertEquals(drList.size(), 2);
            // below code will delete parent QLI//
            Database.DeleteResult[] drList1 = database.delete(parentQliList);
            System.assertEquals(drList.size(), 2);
            Test.StopTest();
        }
    }
    /*This method created for executing negative scenario*/
     static testMethod void processQLINegative(){
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user){
            Test.StartTest();
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
            
            system.assertNotEquals(null, parentQliList);
            
            childQliList.addAll(ANA_UTIL01_TestMethods.createChildQuoteLineItemsList(parentQliList,false,qteList,pbe.id));
            database.insert(childQliList);
            ANA_AP06_QLI_Process_ChildCount pcc= new ANA_AP06_QLI_Process_ChildCount();
            pcc.processChildCount(null,NULL,null,NULL);
            ANA_AP06_QLI_Process_ChildCount pcc1= new ANA_AP06_QLI_Process_ChildCount();
            pcc1.deleteChildQLI(null,NULL,null,NULL);
            ANA_AP06_QLI_Process_ChildCount pp1 = new ANA_AP06_QLI_Process_ChildCount();
            pp1.insertChildQLI(null,NULL,null,NULL);
            
            //ANA_UTIL11_AccessAlternateNetworkUtil acc = new ANA_UTIL11_AccessAlternateNetworkUtil();
            //acc.deleteNetworks(newAltNetworklist);
            ////Added the below line to increase the test coverage of the class ANA_UTIL11_AccessAlternateNetworkUtil-start
            ANA_UTIL11_AccessAlternateNetworkUtil.deleteNetworks(newAltNetworklist);
            //Added the line to increase the test coverage of the class ANA_UTIL11_AccessAlternateNetworkUtil-end
            
            //Added the below line to increase the test coverage of the class ANA_UTIL10_AccessProductSelectionUtil-start
            ANA_UTIL10_AccessProductSelectionUtil.deleteSelections(Prdctseldetail);
            //Added the line to increase the test coverage of the class ANA_UTIL10_AccessProductSelectionUtil-end
             Test.StopTest();
            
        }
    }
    /*This method created for bulk operations*/
    static testMethod void processBulkQLI(){ 
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        user.AllowQLIDelete__c =true;
        system.runAs(user){
             Test.StartTest();
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Customer');
            database.insert(brAcc);
            Opportunity opty1=ANA_UTIL01_TestMethods.createOpportunity(false,brAcc.Id);
            database.insert(opty1);  
            Quote qte=ANA_UTIL01_TestMethods.createQuote(false,opty1.id);
            database.insert(qte);
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd);
            Product2 prd1=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd1);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            vlocity_ins__ProductChildItem__c Vlc = ANA_UTIL01_TestMethods.createChildProduct(prd.id,prd1.id,false);
            database.insert(Vlc);
            parentQliList.addAll(ANA_UTIL01_TestMethods.createQuoteLineItems(5,false,qte.id,pbe.id)); 
            database.insert(parentQliList);
            for(QuoteLineItem qli1:parentQliList){
                qli1.ProductLineApprovalStatus__c = 'Approved';
                newQliList.add(qli1);
            }
            update newQliList;
            childQliList.addAll(ANA_UTIL01_TestMethods.createChildQuoteLineItems(parentQliList,false,qte.id,pbe.id));
            system.debug('childQliList size - ' + childQliList.size());
            system.debug('childQliList - ' + childQliList);
            Database.SaveResult[] srList = database.insert(childQliList);
            System.assertEquals(srList.size(), 5);
            // below code will update child QLI with different parent//
            updateQliList = ANA_UTIL01_TestMethods.swapAssignParentToChildQLI(childQliList,parentQliList);
            ANA_QuoteLineItemTrigger_Handler.isRecursiveupdate  = false;
            Database.SaveResult[] upList = database.update(updateQliList);
            System.assertEquals(upList.size(), 5);
            database.update(updateQliList);
            // below code will delete child QLI//
            Database.DeleteResult[] drList = database.delete(updateQliList);
            System.assertEquals(drList.size(), 5);
            Test.StopTest();
        }
    }
}