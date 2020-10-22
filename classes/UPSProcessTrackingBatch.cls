/****************************************************************
Class Name   : UPSProcessTrackingBatch
Description  : Batch for retrieving UPS Order Fulfillment Records for update
                - updates Location__c field to 'Status Update Pending' 
                to tag records to be processed for UPS tracking update
                - picks up records with carrier = UPS, tracking number != null 
                and delivery status != 'DELIVERED'
*****************************************************************/
global class UPSProcessTrackingBatch implements Database.Batchable<SObject>, Schedulable {
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new UPSProcessTrackingBatch(), 2000);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){                                          
        return Database.getQueryLocator('SELECT Id FROM Order_Fulfillment__c WHERE Status__c != \'DELIVERED\' ' + 
           ' AND Location__c != \'' + Label.UPS_Status_Update_Pending + '\'' +
           ' AND Carrier__c LIKE \'%UPS%\' AND Tracking_Number__c != null ' + 
           ' ORDER BY Estimated_Delivery_Date__c');
    }
    
    global void execute(Database.BatchableContext BC, List<Order_Fulfillment__c> scope){
        //System.debug('Tagging records to be processed/updated ');
        for(Order_Fulfillment__c order : scope) {
            order.Location__c = Label.UPS_Status_Update_Pending;
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){
        Integer batchSize = (UPS_Constants.UPS_TRACKING_BATCH_SIZE != null || UPS_Constants.UPS_TRACKING_BATCH_SIZE != 0)?UPS_Constants.UPS_TRACKING_BATCH_SIZE:100;
        // call batch for updating from UPS
        Database.executeBatch(new UPSUpdateStatusBatch(), batchSize);
    }    
}