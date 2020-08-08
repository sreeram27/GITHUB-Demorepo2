/**
@author : Smita (XMEN)
@createdDate 03/12/2020
@description This is the server side class for metricCard lightning web component
*/



public class CreateMetricRecord {

@AuraEnabled


public static PG_Metric__c createMetric(String id,String measurementPeriod,String reportingPeriod,String pgReqId,String tieringValue) {
    
  
   PG_Metric__c  metric=new PG_Metric__c();
    
    try{
    
       
        metric.PG_Request_ID__c=pgReqId;
        metric.Status__c='Initiated';
        metric.PG_Catalog_Item__c=id;
        System.debug('MP'+measurementPeriod);
        metric.Measurement_Period__c=measurementPeriod;
        metric.Reporting_Period__c=reportingPeriod;
        metric.Tiering_Result_and_Penalty_Option__c=tieringValue;
        System.debug('MP'+metric.Measurement_Period__c);
        insert metric;
        
     }
    
    
    catch(DmlException e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
        throw new AuraHandledException('');
       
    }
    
    return metric;
}
}