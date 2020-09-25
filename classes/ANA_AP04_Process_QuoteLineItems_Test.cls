/**
@Author : Accenture Offshore Dev team
@name : ANA_AP04_Process_QuoteLineItems_Test 
@CreateDate :25-05-2017
@Description : This class is test class for ANA_Process_QuoteLineItems class. 
checks for positive and negative cases.
*/
@isTest
private class ANA_AP04_Process_QuoteLineItems_Test {
private static Account acc;
private static Opportunity oppt;
private static List<Quote> qteList=new List<Quote>();
private static List<QuoteLineItem> qliList = new List<QuoteLineItem>();
private static final string NATIONALAMPROFILE='National Sales';
private static final string QUERYSTRING='abcd';
    /*This method will create Account,Opportunity,Quote and QuoteLineItem records and updates Opportunity to test the trigger for positive scenario.*/
    static testMethod void processQLIPositive(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        test.starttest();
        system.runAs(user){
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Customer');
            database.insert(brAcc);    
            Opportunity opty1=ANA_UTIL01_TestMethods.createOpportunity(false,brAcc.Id);
            opty1.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Opportunity','Renewal');
            database.insert(opty1);            
            qteList=ANA_UTIL01_TestMethods.createQuotes(2,false,opty1.id);
            database.insert(qteList); 
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            qliList.addAll(ANA_UTIL01_TestMethods.createQuoteLineItem_ForQuote(false,qteList,pbe.id));                   
            database.insert(qliList);            
            opty1.StageName='Closed Dead';
            ANA_OpportunityTrigger_Handler.beforeUpdateRecursive = false;
            database.update(opty1);            
        }
        test.stoptest();
    }
    /*This method will create Account ,Opportunity and tests the negative scenario.*/
    static testMethod void processQLINegative(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];  
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        test.starttest();
        system.runAs(user){
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Customer');
            database.insert(brAcc);    
            Opportunity opty1=ANA_UTIL01_TestMethods.createOpportunity(false,brAcc.Id);
            database.insert(opty1);
            try{
            ANA_OpportunityTrigger_Handler.beforeUpdate(new List<Opportunity>{opty1},NULL);
            ANA_UTIL02_AccessQLIDataUtil.queryQuoteLineItems(QUERYSTRING); 
            ANA_UTIL02_AccessQLIDataUtil.updateQuoteLineItems(NULL);
            }
            catch(Exception ecp)
            {
                Boolean expectedExceptionThrown =  ecp.getMessage().contains('Attempt to de-reference a null object') ? true : false;
                System.assertEquals(expectedExceptionThrown, false);
            }
        }
        test.stoptest();
    }
    /*This method created bulk opportunities and updates those records.*/
    static testMethod void processBulkQLI(){
        
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];  
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.Id);
        test.startTest();
        system.runAs(user)
        {
            
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Customer');
            
            database.insert(brAcc);
            
            List<Opportunity> opties=ANA_UTIL01_TestMethods.createOpportunities(2,true,brAcc.Id);
            for(Opportunity opt:opties)
            {
                qteList.add(ANA_UTIL01_TestMethods.createQuote(false,opt.Id));
                opt.stageName='Closed Dead';
            }
            
            database.insert(qteList);
            
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            
            database.insert(prd);
            
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            
            database.insert(pbe);
           
            qliList.addAll(ANA_UTIL01_TestMethods.createQuoteLineItem_ForQuote(false,qteList,pbe.id)); 
            
            database.insert(qliList); 
            
           
            //ANA_OpportunityTrigger_Handler.beforeUpdateRecursive = false;
            
            database.update(opties); 
            
        }
        test.stopTest();
    }
}