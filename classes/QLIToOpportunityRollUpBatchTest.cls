@isTest
public class QLIToOpportunityRollUpBatchTest {
    @testSetup
    static  void setupTestData(){
        Account acc1 = new Account();
        acc1.Name = 'testAcc1';
        insert acc1;
        Account acc2 = new Account();
        acc2.Name = 'testAcc2';
        insert acc2;
        
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'testOpp1';
        opp1.StageName = 'Initiated';
        opp1.CloseDate = system.today();
        opp1.AccountId = acc1.Id;
        oppList.add(opp1);
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'testOpp2';
        opp2.StageName = 'Closed Won';
        opp2.CloseDate = system.today();
        opp2.AccountId = acc1.Id;
        oppList.add(opp2);
        insert oppList;
        
        List<Product2> prodlist = new List<Product2>();
        product2 thisProd1 = new Product2();
        thisProd1.Name = 'testProd1';
        thisProd1.LOB__c = null;
        thisProd1.Product_Family__c = 'Medical';
        thisProd1.Category__c = 'Product';
        prodList.add(thisProd1);
        product2 thisProd2 = new Product2();
        thisProd2.Name = 'testProd2';
        thisProd2.LOB__c = 'Medical';
        thisProd2.Category__c = 'Product';
        prodList.add(thisProd2);
        product2 thisProd3 = new Product2();
        thisProd3.Name = 'testProd3';
        thisProd3.LOB__c = 'Benefits Admin';
        thisProd3.Category__c = 'Product';
        prodList.add(thisProd3);
        insert prodList;
        List<PricebookEntry> PBEList = new List<PricebookEntry>();
        PricebookEntry PBE1 = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodList[0].id);
        PricebookEntry PBE2 = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodList[1].id);
        PricebookEntry PBE3 = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodList[2].id);
        PBEList.add(PBE1);
        PBEList.add(PBE2);
        PBEList.add(PBE3);
        List<Quote> quoteList = new List<Quote>();
        Quote q1 =  new Quote();
        q1.Name = 'testQuote1';
        q1.OpportunityId = opp1.Id;
        q1.Pricebook2Id = PBEList[0].pricebook2id;
       
        Quote q2 = new Quote();
        q2.Name = 'testQuote2';
        q2.OpportunityId = opp2.Id;
        q2.Pricebook2Id = PBEList[1].pricebook2id;
       
        quoteList.add(q1);
        quoteList.add(q2);
        insert quoteList;
      
        List<String> fundingList = new List<String>{'ASO','FI'};
            List<String> financeList = new List<String>{'Modified Cost Plus','Non-Refunding'};
                List<String> stageList = new List<String>{'In Progress','Sold'};
                    List<QuoteLineitem> QLIList = new List<QuoteLineitem>();
        QuoteLineitem thisQLI1 = new QuoteLineItem();
        thisQLI1.QuoteId = quoteList[1].Id;
        thisQLI1.Funding__c = null;
        thisQLI1.Financing__c = null;
        thisQLI1.Product2Id = prodList[1].id;
        thisQLI1.Quantity = 1+1;
        thisQLI1.UnitPrice = 20.10;
        thisQLI1.ProductStage__c = stageList[1];
        thisQLI1.Members__c = 100;
        thisQLI1.Subscribers__c = 100;
        thisQLI1.PricebookEntryId = PBEList[1].Id;
        QLIList.add(thisQLI1);
        QuoteLineitem thisQLI2 = new QuoteLineItem();
        thisQLI2.QuoteId = quoteList[1].Id;
        thisQLI2.Funding__c = null;
        thisQLI2.Financing__c = financeList[1];
        thisQLI2.Product2Id = prodList[1].id;
        thisQLI2.Quantity = 1;
        thisQLI2.UnitPrice = 20.10;
        thisQLI2.ProductStage__c = stageList[0];
        thisQLI2.PricebookEntryId = PBEList[1].Id;
        QLIList.add(thisQLI2);
        QuoteLineitem thisQLI13 = new QuoteLineItem();
        thisQLI13.QuoteId = quoteList[1].Id;
        thisQLI13.Funding__c = null;
        thisQLI13.Financing__c = null;
        thisQLI13.Product2Id = prodList[1].id;
        thisQLI13.Quantity = 1+1;
        thisQLI13.UnitPrice = 20.10;
        thisQLI13.ProductStage__c = stageList[1];
        thisQLI13.Members__c = 100;
        thisQLI13.Subscribers__c = 100;
        thisQLI13.PricebookEntryId = PBEList[1].Id;
        QLIList.add(thisQLI13);
       // thisQLI.Competitor3__c = acc2.Id;
        
        for(integer j =0; j<2 ; j++){
            for(integer i =0; i<2 ; i++){
                QuoteLineitem thisQLI = new QuoteLineItem();
                thisQLI.QuoteId = quoteList[j].Id;
                thisQLI.Funding__c = fundingList[i];
                thisQLI.Financing__c = financeList[i];
                thisQLI.Product2Id = prodList[j].id;
                thisQLI.Quantity = 1+i;
                thisQLI.UnitPrice = 20.10;
                thisQLI.ProductStage__c = stageList[i];
                //thisQLI.Competitor__c = acc1.Id;
                thisQLI.PricebookEntryId = PBEList[j].Id;
                system.debug('========' + thisQLI.Product2Id + ' AND '+PBEList[j].product2id);
                QLIList.add(thisQLI);
            }
            AccountRoles__c roles = new AccountRoles__c();
        roles.Name = 'OppReport';
        roles.LastRun__c = Datetime.now().addDays(-5);
        insert roles;
        }
        
        insert QLIList;
    }
       static testMethod void testMethodAccExec()
    {
        Test.startTest();
        QLIToOpportunityRollUpBatch obj = new QLIToOpportunityRollUpBatch();
        database.executeBatch(obj); 
        Test.StopTest();
    }
    
    static testMethod void testMethodAccExec1()
    {
        Test.startTest();
        QLIToOpportunityRollUpBatch obj = new QLIToOpportunityRollUpBatch();
        obj.isError = true;
        database.executeBatch(obj); 
        Test.StopTest();
    }
}