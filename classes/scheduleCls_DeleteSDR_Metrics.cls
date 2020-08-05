global class scheduleCls_DeleteSDR_Metrics implements Schedulable {
    global void execute(SchedulableContext sc){
        String query = 'Select id from SDR_Metrics__c limit 50000';
        BatchCls_DeleteSDR_Metrics BdsMetrics  = new BatchCls_DeleteSDR_Metrics(query);
        Database.executeBatch(BdsMetrics);
    }
}