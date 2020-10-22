global class LG_PendingCorrection_Batch_Scheduler implements Schedulable {

  global void execute(SchedulableContext sc) {
    
    
    LG_PendingCorrection_Batch b = new LG_PendingCorrection_Batch();
    Database.executeBatch(b,1);
  }
   Public static void SchedulerMethod() {
   
   Batch_Job_Cron_Expression__mdt m=[select id,DeveloperName,Cron_Expression__c from Batch_Job_Cron_Expression__mdt where DeveloperName='LG_PendingCorrection_Batch_Cron_Expr'];
     //System.schedule('Scheduled Job 1', '0 0 * * * ?', new LGSMENotApprovedSchedulable());
    //System.schedule('Scheduled Job 2', '0 30 * * * ?', new LGSMENotApprovedSchedulable());
    string cronexpression1=m.Cron_Expression__c.split(';')[0];
    string cronexpression2=m.Cron_Expression__c.split(';')[1];
    System.schedule('Scheduled Job 1', cronexpression1, new LG_PendingCorrection_Batch_Scheduler());
    System.schedule('Scheduled Job 2',cronexpression2, new LG_PendingCorrection_Batch_Scheduler());
   }
}