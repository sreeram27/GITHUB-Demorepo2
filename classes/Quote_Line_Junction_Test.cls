@isTest
private class Quote_Line_Junction_Test {
    
    static testMethod void myUnitTest(){
        Test.startTest();
        
        Account acct = ANA_UTIL01_TestMethods.createAccount(true);
        Contact con = ANA_UTIL01_TestMethods.createContact(true,acct.Id);
        Opportunity opp = ANA_UTIL01_TestMethods.createOpportunity(true,acct.Id);
        Quote q1 = ANA_UTIL01_TestMethods.createQuote(true,opp.Id);
        
        Product2 prod = ANA_UTIL01_TestMethods.createProduct(true);
        Product2 prodAP = ANA_UTIL01_TestMethods.createProduct(true);
        prodAP.Name = 'Pharmacy - Anthem Pharmacy Services';
        update prodAP;
        
        
        PricebookEntry pbe = ANA_UTIL01_TestMethods.createPricebookEntry(true,prod.Id);
        PricebookEntry pbeAP = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodAP.Id);
        
        set<Id> ParentQuoteLineItem = new set<Id>();
        list<Plan_Relationship__c> planList = new list<Plan_Relationship__c>();
        
        list<QuoteLineItem> qliLIst = ANA_UTIL01_TestMethods.createQuoteLineItems(3, true,q1.Id,pbe.Id);
            
        for(QuoteLineItem qli : qliLIst){
            ParentQuoteLineItem.add(qli.id);
           
        }
        
        list<QuoteLineItem> qli2 = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbe.Id);
        qliLIst[0].ActWiseChildQuote__c = qli2[0].Id;
        update qliLIst;
      
        Plan_Relationship__c plan = new Plan_Relationship__c();
        plan.Qli2__c = qli2[0].id;
        planList.add(plan);
        insert planList;
        
        Quote_Line_Junction.deleteParentToChild(ParentQuoteLineItem); 
        
        Plan_Relationship__c plan2 = new Plan_Relationship__c();
        plan2.Qli2__c = qli2[0].id;
        planList.add(plan2);
        
        Plan_Relationship__c plan3 = new Plan_Relationship__c();
        plan3.Qli2__c = qli2[0].id;
        plan3.Qli1__c = qliLIst[0].Id;
        planList.add(plan3);
        upsert planList;
        
        Quote_Line_Junction.deleteParentToChild(ParentQuoteLineItem);
        
        system.assert(planList.size()==3);

        Test.stopTest();
    }
    
}