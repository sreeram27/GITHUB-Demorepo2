global class BatchCls_DeleteSDR_Metrics implements Database.Batchable<Sobject>{
    
    global final String query;
    global BatchCls_DeleteSDR_Metrics(String q){
        query  = q;
    }
    
    global  database.queryLocator start(Database.BatchableContext Bc){
        return database.getQueryLocator(query);
    }
    
    global static void Execute(Database.BatchableContext bc,List<SDR_Metrics__c> listSDRMetrics){
        Database.Delete(listSDRMetrics,false);
    }
    
    global void finish(Database.BatchableContext Bc){
        
        Database.executeBatch(new CLS_InsertSdrData());
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new list<string> {'sreekanth.u@autorabit.com'};
        
        AsyncApexJob asyncJob = [Select asyncJob.TotalJobItems,asyncJob.Status,asyncJob.NumberOfErrors,asyncJob.JobItemsProcessed,asyncJob.ExtendedStatus from AsyncApexJob asyncJob Where id =: bc.getJobId()];
        email.setToAddresses(toAddresses);
        email.setSenderDisplayName('SDR Metrics Deletion Job');
    email.setSubject('Processing Status'+asyncJob.Status);
        email.setPlainTextBody('The Batch Job Processed'+' ' + asyncJob.TotalJobItems +' ' + 'batches with'+' ' +asyncJob.NumberOfErrors +' ' + 'Failures' + 'Job Item Processed are' +' ' + asyncJob.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.singleEmailMessage[]{email});
    }
}