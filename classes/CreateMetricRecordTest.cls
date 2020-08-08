/**
@author : Smita (XMEN)
@createdDate : 03/12/2020
@description This is test class for server side 'CreateMetricRecord' Class
*/
@isTest
public class CreateMetricRecordTest{
    
/*******************************************************************************************************
* @description: Sets up test data
* @param: null 
* @return: Doesn't return anything
*/  
    @testSetup
    public static void testSetUpMethod(){
          
        PG_Request__c pgRequest = new PG_Request__c();
        pgRequest=TestDataFactory.createPGRequestItem();
        insert pgRequest;
            
            PG_Catalog_Item__c pgitem = new PG_Catalog_Item__c();
        pgitem = TestDataFactory.createPGCatalogItem(staticVariableClass.STANDARD,staticVariableClass.IMPLEMENTATION,staticVariableClass.OPERATIONS);
        insert pgitem; 
        
        PG_Metric__c  pgMetric = new PG_Metric__c  ();
        //createMetricRecord creMetric=new createMetricRecord ();
        pgMetric = createMetricRecord.createMetric(pgitem.ID,'Annual','Annual',pgRequest.ID,'Option 1 (No Tiering)');
        
    }
    
/*******************************************************************************************************
* @description test method for CatalogController unit tests
* @param null 
* @return Doesn't return anything
*/  
    @isTest
    public static void testPGCatalogItems(){
        List<PG_Metric__c  > pgMetric = new List<PG_Metric__c  >([select id,Measurement_Period__c,status__c,Reporting_Period__c from PG_Metric__c  limit 1]);
        system.debug('pgCatalogItemList---> '+ pgMetric );
        
        System.assertEquals(pgMetric[0] .Measurement_Period__c ,'Annual', 'Measurement Period is Equal');
        System.assertEquals(pgMetric[0] .Status__c ,'Initiated', 'Status is Equal');
        System.assertEquals(pgMetric[0] .Reporting_Period__c,'Annual', 'Reporting Period is Equal');
        
        }
}