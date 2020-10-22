/**
@author : Ravideep (XMEN)
@createdDate : 03/06/200
@description This is test class for server side 'CatalogController' Class
*/
@isTest
public class CatalogControllerTest{
    
/*******************************************************************************************************
* @description: Sets up test data
* @param: null 
* @return: Doesn't return anything
*/  
    @testSetup
    public static void testSetUpMethod(){
          
        PG_Catalog_Item__c pgitem = new PG_Catalog_Item__c();
        pgitem = TestDataFactory.createPGCatalogItem(staticVariableClass.STANDARD,staticVariableClass.IMPLEMENTATION,staticVariableClass.OPERATIONS);
        insert pgitem;
    }
    
/*******************************************************************************************************
* @description test method for CatalogController unit tests
* @param null 
* @return Doesn't return anything
*/  
    @isTest
    public static void testPGCatalogItems(){
        List<PG_Catalog_Item__c> pgCatalogItemList = new List<PG_Catalog_Item__c>([select id,PG_Type__c,Performance_Category__c,Broad_Contract_Category__c from PG_Catalog_Item__c limit 1]);
        system.debug('pgCatalogItemList---> '+ pgCatalogItemList);
        
        CatalogController.Filters filter = new CatalogController.Filters();
        PagedResult PR = new PagedResult();
        
        if(pgCatalogItemList.size()>0){
            filter.searchKey = staticVariableClass.IMPLEMENTATION;    
            filter.pgtypes = new List<String>{pgCatalogItemList[0].PG_Type__c};
            filter.contractcategories = new List<String>{pgCatalogItemList[0].Broad_Contract_Category__c};
            filter.performancecategories = new List<String>{pgCatalogItemList[0].Performance_Category__c};
            test.startTest();
            PR = CatalogController.getPGCatalogItems(filter,Integer.valueOf(system.label.MetricListPageSize));
            }
            system.debug('PR--> ' + PR );
            system.assertEquals(1, PR.totalItemCount);
            
            test.stopTest();
    }
}