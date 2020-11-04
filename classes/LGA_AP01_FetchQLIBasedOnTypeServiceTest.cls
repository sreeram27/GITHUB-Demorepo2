@isTest
public class LGA_AP01_FetchQLIBasedOnTypeServiceTest {
    
    @testSetup static void setup() {
        List<Id> accountRecordTypeIdList = new List<Id>();
        Id prospectAccRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();
        accountRecordTypeIdList.add(prospectAccRecordType);
        List<Account> accountObjList = Anthem_TestDataFactory.generateAccount(accountRecordTypeIdList);        
        insert accountObjList;
        // Create common test Opportunities
        List<Id> opportunityRecordTypeIdList = new List<Id>();
        Id newBusinsLocalOppRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business Local').getRecordTypeId();
        OpportunityRecordTypeIdList.add(newBusinsLocalOppRecordType);
        List<Opportunity> oppObjList = Anthem_TestDataFactory.generateOpportunity(opportunityRecordTypeIdList, accountObjList.get(0).Id);
        oppObjList.get(0).CloseDate = Date.newInstance(2019, 10,1);       
        String oppCloseDate = oppObjList.get(0).CloseDate.format();
        database.insert (oppObjList);
        // Create common test Products        
        Map<String,Integer> productTypeMap = new Map<String,Integer>();
        productTypeMap.put(LGA_UTIL_Constants.MEDICAL , 10);
        productTypeMap.put(LGA_UTIL_Constants.DENTAL, 10);
        productTypeMap.put(LGA_UTIL_Constants.VISION, 10);
        productTypeMap.put(LGA_UTIL_Constants.LIFE, 10);
        productTypeMap.put(LGA_UTIL_Constants.FSA, 10);
        productTypeMap.put(LGA_UTIL_Constants.EAP, 10);
        List<Product2> prodObjList = Anthem_TestDataFactory.generateProduct2ByType(productTypeMap);
        database.insert (prodObjList);        
        Id pricebookId = Anthem_TestDataFactory.generatePricebookId();        
        // Create common test PricebookEntry        
        PricebookEntry pricebookEntryObj = Anthem_TestDataFactory.generatePricebookEntry(prodObjList.get(0).Id, pricebookId);
        database.insert (pricebookEntryObj);
        // Create common test Quotes        
        List<Id>quoteIdList = new List<Id>();
        quoteIdList.add(oppObjList.get(0).Id);
        List<Quote>quoteObjList = Anthem_TestDataFactory.generateQuote(quoteIdList, pricebookId, oppObjList.get(0).Id);
        database.insert (quoteObjList);
        // Create common test QuoteLineItems        
        List<QuoteLineItem> qliList = Anthem_TestDataFactory.generateQuoteLineItemByProductList(quoteObjList.get(0).Id,prodObjList,
                                                                                                pricebookEntryObj.Id);
        database.insert  (qliList);
        // Create common test Group        
        Group__C grp = new Group__C ();
        grp.name='test';
        grp.Account__C=accountObjList[0].id;
        
        database.insert  (grp);
        // Create common test Implementation Cases         
        String impactedProductIds = '';        
        for(QuoteLineItem qli:qliList){
            impactedProductIds = qli.Id + ',' + impactedProductIds;            
        }  
        
        //System.debug(' ##impactedProductIds in setup : ' + impactedProductIds);
        List<Id>orderList = new List<Id>();
        List<Order>orderObjList = Anthem_TestDataFactory.generateImplementationCase(impactedProductIds,accountObjList.get(0).Id,quoteObjList.get(0).Id,
                                                                                    oppObjList.get(0).Id,grp.id);
        database.insert (orderObjList);         
    }
    
    
    /**
* @description insertQliBasedOnType- insert quoteLineItem based on type.
*/
    
    @isTest
    public static void insertQliBasedOnType()
    {
        try{
            Test.startTest();      
            LGA_AP01_FetchQLIBasedOnTypeService impactedQlIFetchService=new LGA_AP01_FetchQLIBasedOnTypeService();
            Map <String, Object> inputJson = new Map <String,Object>();
            Map <String, Object> outputJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            Account account = [SELECT Id from Account LIMIT 1];
            Opportunity opp = [SELECT Id from Opportunity where AccountId =  :account.Id LIMIT 1];
            Quote quote = [SELECT Id from Quote 
                           WHERE AccountId = :account.Id 
                           AND OpportunityId = :opp.Id
                           LIMIT 1];
            Order implCase = [SELECT Impacted_Products_Id__c from Order 
                              WHERE AccountId = :account.Id
                              AND QuoteId = :quote.Id LIMIT 50000 ];
            
            optnsJson.put('impactedProductIds',implCase != null ? implCase.Impacted_Products_Id__c : '');
            Boolean methodExec = impactedQlIFetchService.invokeMethod(LGA_UTIL_Constants.FETCH_QLIS_BASED_ON_TYPE, inputJson, outputJson, optnsJson);            
            
            Test.stopTest();
            System.assert(implCase != null, 'ImpleCase Found');
            System.assertEquals(true, methodExec, 'Success');
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
        
    }
    
    
    /**
* @description testNoQLIReturned- insert quoteLineItem based on type.
*/
    
    @isTest
    public static void testNoQLIReturned()
    {
        try{
            Test.startTest();      
            LGA_AP01_FetchQLIBasedOnTypeService impactedQliSvc=new LGA_AP01_FetchQLIBasedOnTypeService();
            Map <String, Object> inputJson = new Map <String,Object>();
            Map <String, Object> outputJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();                       
            optnsJson.put('impactedProductIds','test');
            Boolean methodExec = impactedQliSvc.invokeMethod(LGA_UTIL_Constants.FETCH_QLIS_BASED_ON_TYPE, inputJson, outputJson, optnsJson);            
            
            Test.stopTest();
            System.assertEquals(true, methodExec, 'Success'); 
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
        
    }
    
    
    
    /**
* @description testTransformProductDetails- Transforms New Business QLIs JSON.
*/
    
    @isTest
    public static void testTransformProductDetails(){
        try{
            Test.startTest();      
            LGA_AP01_FetchQLIBasedOnTypeService newBusinessQLIService=new LGA_AP01_FetchQLIBasedOnTypeService();
            Map <String, Object> inputJson = Anthem_TestDataFactory.generateQLIProductsJSON();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();        
            boolean result = newBusinessQLIService.invokeMethod('ReplacePercentBlank', inputJson, outJson, optnsJson);            
            
            Test.stopTest();
            System.assertEquals(true, result, 'Success');  
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
        
    }
    
    
    /**
* @description testInvokeMethod- Transforms New Business QLIs JSON.
*/
    
    @isTest
    public static void testInvokeMethodName(){
        try{
            Test.startTest();      
            LGA_AP01_FetchQLIBasedOnTypeService newBusinessQLIService = new LGA_AP01_FetchQLIBasedOnTypeService();
            Map <String, Object> inputJson = Anthem_TestDataFactory.generateQLIProductsJSON();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();        
            boolean result = newBusinessQLIService.invokeMethod('ReplacePercentBlankMethod', inputJson, outJson, optnsJson);            
            
            Test.stopTest();
            System.assertEquals(false, result, 'Success');
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
}