/**
 * Batch class to create QLIs based on custom object
 **/
global class UpdateQLIProductBatch implements Database.Batchable<sObject>, Database.Stateful{
    String status = 'Pending';
     global Database.QueryLocator start(Database.batchableContext BC) {
        String query = 'Select Id, SFDCLegacyID__c,Com2_QLIID__c,Status__c, Contract_code__c,Status_Message__c from WGS_Renewal_QLIs__c where status__c =: status';
         system.debug('query********:' + query);
          return Database.getQueryLocator(query);  
       }
      //
      global void execute(Database.BatchableContext BC, List<WGS_Renewal_QLIs__c> scope){
          try{
              
              for(WGS_Renewal_QLIs__c qli : scope){
                  String QLIid = qli.Com2_QLIID__c;
                  String SFDCLegId = qli.SFDCLegacyID__c;
                  if(QLIid== null && SFDCLegId != null){
                      List<QuoteLineItem> qliRec = [select id,SFDCLegacyID__c from QuoteLineItem where SFDCLegacyID__c=:SFDCLegId LIMIT 1];
                      if(qliRec!= null && qliRec.size()>0)  QLIid = qliRec[0].Id;
                   }
                  if(QLIid!= null) {
                      QLIUpdateUtility.QLIUpdateStatus  status ;
                      QLIUpdateUtility qliUtil = new QLIUpdateUtility();
                      status = qliUtil.updateQLIProduct(QLIid,qli.Contract_code__c);
                      qli.Status__c = status.StatusCode;
                      qli.Status_Message__c = status.StatusMessage;
                  }else {
                    qli.Status__c = 'Error';
                    qli.Status_Message__c= 'No QuotelineItem record found with QLI Id :' + QLIid;
                  }
                  system.debug('scope********:' + scope);
                  update qli;
                 
              }
          } Catch(Exception ex) {
              system.debug('batch failed due to :' + ex.getMessage());
          }
   }   
    global void finish(Database.BatchableContext bc){
        
    } 

     

}