@isTest
public class LG_ContCodeReservServiceWrapper_Test {
    @testSetup 
    static void initialTestData(){
        Account acc = IntegrationTestDataUtilty.createAccount(true); 
        System.assertNotEquals(acc, null,'');
        Opportunity oppty = IntegrationTestDataUtilty.createOpportunity(acc.id, true);
        System.assertNotEquals(oppty, null,'');
        Group__c grp = IntegrationTestDataUtilty.createGroup(acc.id, true);
        System.assertNotEquals(grp, null,'');
        Quote qte = IntegrationTestDataUtilty.createQuote(oppty.Id, grp.id, true); 
        System.assertNotEquals(qte, null,'');
        Product2 prod = IntegrationTestDataUtilty.createProduct(false);
        prod.Category__c = staticVariableClass.Plan;
        prod.Product_Type__c = staticVariableClass.Medical;
        Database.insert(prod);
        System.assertNotEquals(prod, null,'');      
        PricebookEntry pbe = IntegrationTestDataUtilty.createPricebookEntry(prod.id, true);
        System.assertNotEquals(pbe, null,'');      
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.ProductStage__c = staticVariableClass.Sold;
        Database.insert(qli);
        System.assertNotEquals(qli, null,'');  
        Order implCase = IntegrationTestDataUtilty.createImplCase(Qte.Id, Acc.Id, false);
        System.assertNotEquals(implCase, null,'');
        insert implCase;
    }
    
    
    @IsTest  static void testContCodeReservService(){        
        LG_ContCodeReservServiceWrapper obj = new LG_ContCodeReservServiceWrapper();        
        Order odr = [Select id from Order where Name = 'Test'];
        System.assertNotEquals(odr, null,'');
        Test.setMock(HttpCalloutMock.class, new ContCodeReserveResponseMockTest()); 
        Test.startTest(); 
            Boolean trueOrFalse = obj.invokeMethod(staticVariableClass.DNCStrPath,new map<String,Object>{staticVariableClass.CreateGrpQUOTEID => odr.Id},new map<String,Object>(),new map<String,Object>());
            System.assertEquals(trueOrFalse,true,'');
        Test.stopTest();  
    }
}