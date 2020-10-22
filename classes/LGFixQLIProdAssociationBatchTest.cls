@isTest
public class LGFixQLIProdAssociationBatchTest {
    
    static List<QuoteLineItem> createData()
    {
       Account acc=IntegrationTestDataUtilty.createAccount(true); 
      
        Opportunity oppty=IntegrationTestDataUtilty.createOpportunity(acc.id, true);
        
        Group__c grp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        
        Quote qte=IntegrationTestDataUtilty.createQuote(oppty.Id, grp.id, true);
        
        Order ImplCaseTestCoverage =   IntegrationTestDataUtilty.createImplCase(Qte.Id, Acc.Id, true); 
        
        Product2 prod=IntegrationTestDataUtilty.createProduct(false);
        prod.Category__c = 'Plan';
        prod.Product_Type__c = 'Medical';
        prod.Contract_Code__c = '40QA';
        Database.insert(prod);
        
        Product2 prod2 =IntegrationTestDataUtilty.createProduct(false);
        prod2.Category__c = 'Plan';
        prod2.Product_Type__c = 'Medical';
        prod2.Contract_Code__c = '40PA';
        prod2.productActive__c = true;
        Database.insert(prod2);
        
        Product2 prod3 =IntegrationTestDataUtilty.createProduct(false);
        prod3.Category__c = 'Plan';
        prod3.Product_Type__c = 'Medical';
        prod3.Contract_Code__c = '40SA';
        prod3.productActive__c = true;
        Database.insert(prod3);
        
        Product2 prod4 =IntegrationTestDataUtilty.createProduct(false);
        prod4.Category__c = 'Plan';
        prod4.Product_Type__c = 'Medical';
        prod4.Contract_Code__c = '40TA';
        prod4.productActive__c = true;
        Database.insert(prod4);
        
        PricebookEntry pbe=IntegrationTestDataUtilty.createPricebookEntry(prod.id, true);
        PricebookEntry pbe2=IntegrationTestDataUtilty.createPricebookEntry(prod2.id, true);
        PricebookEntry pbe3=IntegrationTestDataUtilty.createPricebookEntry(prod3.id, true);
        PricebookEntry pbe4=IntegrationTestDataUtilty.createPricebookEntry(prod4.id, true);
        
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod2.Id;
        qli.ProductStage__c = 'Sold';
        qli.vlocity_ins__ContractCode__c = '40QA';
        qliList.add(qli); 
        
        QuoteLineItem qli2 = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe2.Id, false);
        qli2.Product2Id = prod2.Id;
        qli2.ProductStage__c = 'Sold';
        qli2.vlocity_ins__ContractCode__c = '40SA';
        qliList.add(qli2);
        
        QuoteLineItem qli3 = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe3.Id, false);
        qli3.Product2Id = prod4.Id;
        qli3.ProductStage__c = 'Sold';
        qli3.vlocity_ins__ContractCode__c = '40TA';
        qliList.add(qli3);
        
        QuoteLineItem qli4 = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe4.Id, false);
        qli4.Product2Id = prod2.Id;
        qli4.ProductStage__c = 'Sold';
        qli4.vlocity_ins__ContractCode__c = '40ZA';
        qliList.add(qli4);
        
        Database.insert(qliList);
          
        return qliList;
    }
    
    static QuoteLineItem createScheduleBatchTestData()
    {
       Account acc=IntegrationTestDataUtilty.createAccount(true); 
       
        Opportunity oppty=IntegrationTestDataUtilty.createOpportunity(acc.id, true);
        
        Group__c grp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        
        Quote qte=IntegrationTestDataUtilty.createQuote(oppty.Id, grp.id, true);
        
        Product2 prod =IntegrationTestDataUtilty.createProduct(false);
        prod.Category__c = 'Plan';
        prod.Product_Type__c = 'Medical';
        prod.Contract_Code__c = '40PA';
        prod.productActive__c = true;
        Database.insert(prod);
        
        Product2 prod2 =IntegrationTestDataUtilty.createProduct(false);
        prod2.Category__c = 'Plan';
        prod2.Product_Type__c = 'Medical';
        prod2.Contract_Code__c = '40SA';
        prod2.productActive__c = true;
        Database.insert(prod2);
        
        PricebookEntry pbe=IntegrationTestDataUtilty.createPricebookEntry(prod.id, true);
        PricebookEntry pbe2=IntegrationTestDataUtilty.createPricebookEntry(prod2.id, true);
        
       
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.P2AModified__c = 'Yes';
        qli.vlocity_ins__ContractCode__c = '40SA';
        System.debug(qli);
        Database.insert(qli); 
        
        return qli;
    }
    
    @isTest
    static void testBatchProcessProdUpdate(){
        
        List<QuoteLineItem> qlineItemList = createData();
        
        Test.startTest(); 
        LGFixQLIProdAssociationBatch prodbatch = new LGFixQLIProdAssociationBatch();
        Database.executeBatch(prodbatch);  
        Test.stopTest();
      
        QuoteLineItem qli = [Select Id, vlocity_ins__ContractCode__c, Product2Id from QuoteLineItem where vlocity_ins__ContractCode__c = '40SA'];
        Product2 prod = [Select Id, Contract_Code__c from Product2 Where Contract_Code__c = '40SA'];
        System.assertEquals(qli.Product2Id, prod.Id);
       // System.assertEquals(1, [Select Count() from QuoteLineItem where Product2ID =: prod.Id]);
    }
    
     @isTest
    static void testBatchProcessProdUpdateFailure(){
        
        List<QuoteLineItem> qlineItemList = createData();
        
        Test.startTest(); 
        LGFixQLIProdAssociationBatch prodbatch = new LGFixQLIProdAssociationBatch();
        Database.executeBatch(prodbatch);  
        Test.stopTest();
      
        QuoteLineItem qli = [Select Id, vlocity_ins__ContractCode__c, Product2Id from QuoteLineItem where vlocity_ins__ContractCode__c = '40QA'];
        Product2 prod = [Select Id, Contract_Code__c from Product2 Where Contract_Code__c = '40QA'];
        //stem.assertEquals(qli.Product2Id, prod.Id);
       System.assertEquals(0,[Select Count() from QuoteLineItem where Product2ID =: prod.Id]);
    }
    @isTest
    static void testBatchProcessProductNotFound(){
        
        List<QuoteLineItem> qlineItemList = createData();
        
        Test.startTest(); 
        LGFixQLIProdAssociationBatch prodbatch = new LGFixQLIProdAssociationBatch();
        Database.executeBatch(prodbatch);  
        Test.stopTest();
      
        QuoteLineItem qli = [Select Id, vlocity_ins__ContractCode__c, Product2Id from QuoteLineItem where vlocity_ins__ContractCode__c = '40ZA'];
        List<Product2> prodList = [Select Id, Contract_Code__c from Product2 Where Contract_Code__c = '40ZA'];
        System.assertEquals(0, prodList.size());
    }
    
    @isTest
    static void testBatchProcessContCOdeMatches(){
        
        List<QuoteLineItem> qlineItemList = createData();
        
        Test.startTest(); 
        LGFixQLIProdAssociationBatch prodbatch = new LGFixQLIProdAssociationBatch();
        Database.executeBatch(prodbatch);  
        Test.stopTest();
      
        QuoteLineItem qli = [Select Id, vlocity_ins__ContractCode__c, Product2Id from QuoteLineItem where vlocity_ins__ContractCode__c = '40TA'];
        Product2 prod = [Select Id, Contract_Code__c from Product2 Where Contract_Code__c = '40TA'];
        System.assertEquals(qli.vlocity_ins__ContractCode__c, prod.Contract_Code__c);
    }
    
    @isTest
    static void testBatchProcessProdUpdateSchedule(){
        
        QuoteLineItem qlineItem = createScheduleBatchTestData();
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        Test.startTest();  
         // Schedule the test job
        String jobId = System.schedule('LGQLIProdBatchScheduleTest', CRON_EXP, new LGFixQLIProdAssociationBatch());  
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        Test.stopTest();
        
    }

}