/****************************************************************
Class Name   : UPSUpdateStatusBatch
Description  : Batch to update tracking status for UPS Order Fulfillment Records
                - picks up records with carrier = UPS, tracking number != null 
                and location__c = 'Status Update Pending'
*****************************************************************/
global class UPSUpdateStatusBatch implements Database.Batchable<SObject>, Schedulable, Database.AllowsCallouts{
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new UPSUpdateStatusBatch(), 100);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){                                          
        return Database.getQueryLocator('SELECT Id FROM Order_Fulfillment__c WHERE Location__c = \'' + Label.UPS_Status_Update_Pending + '\' ' + 
            ' AND Carrier__c LIKE \'%UPS%\' ORDER BY Estimated_Delivery_Date__c');
    }
    
    global void execute(Database.BatchableContext BC, List<Order_Fulfillment__c> scope){
        System.debug('Executing ups callout and update batch ');
        List<Id> orderIds = new List<Id>();
        for(Order_Fulfillment__c order : scope) {
            orderIds.add(order.Id);
            order.Location__c = Label.UPS_Status_Update_Pending;
        }
        UPS.updateStatus(orderIds);
    }
    
    global void finish(Database.BatchableContext BC){
    }    
}