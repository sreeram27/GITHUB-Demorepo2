@isTest
public class LG_ContCodeReservServiceWrapperTest {
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
    
    
    static testMethod void testContCodeReservServicePositiveTestCase(){        
        LG_ContCodeReservServiceWrapper obj = new LG_ContCodeReservServiceWrapper();        
        List<Order> odrList = [Select id from Order where Name = 'Test'];
        System.assertEquals(odrList.size(), 1,'Size of list is grater than zero');
        
        /* Callout using mock test class */
        Test.setMock(HttpCalloutMock.class, new ContCodeReserveResponseMockTest()); 
        Boolean trueOrFalse = false;
        Test.startTest();
            if(!odrList.isEmpty()){
                trueOrFalse = obj.invokeMethod(staticVariableClass.DNCStrPath,new Map<String,Object>{staticVariableClass.CreateGrpQUOTEID => odrList[0].Id},new Map<String,Object>(),new Map<String,Object>());
            }
            System.assertEquals(trueOrFalse,true,'trueOrFalse value is true');
        Test.stopTest();  
    }
    
     static testMethod void testContCodeReservServiceNegativeTestCase(){        
        LG_ContCodeReservServiceWrapper obj = new LG_ContCodeReservServiceWrapper();        
        List<Order> odrList1 = [Select id from Order where Name = 'Test1'];
        System.assertNotEquals(odrList1.size(), 1,'Size of list is less than zero');
        
        /* Callout using mock test class */
        Test.setMock(HttpCalloutMock.class, new ContCodeReserveResponseMockTest());
        Boolean trueOrFalse = false;
        Test.startTest();
            if(!odrList1.isEmpty()){
                trueOrFalse = obj.invokeMethod(staticVariableClass.DNCStrPath,new Map<String,Object>{staticVariableClass.CreateGrpQUOTEID => odrList1[0].Id},new Map<String,Object>(),new Map<String,Object>());
            }
            System.assertNotEquals(trueOrFalse,true,'trueOrFalse value is false');
        Test.stopTest();  
    }
}