global class LGCarveOutTimeBatch_Scheduler implements Schedulable {

  global void execute(SchedulableContext sc) {
    
    
    LGCarveOutTimeBatch b = new LGCarveOutTimeBatch();
    Database.executeBatch(b,1);
  }
   Public static void SchedulerMethod() {
   
   Batch_Job_Cron_Expression__mdt m=[select id,DeveloperName,Cron_Expression__c from Batch_Job_Cron_Expression__mdt where DeveloperName='LGCarveOutTimeBatch_Cron_Expr'];
     
    string cronexpression1=m.Cron_Expression__c.split(';')[0];
    string cronexpression2=m.Cron_Expression__c.split(';')[1];
    System.schedule('LGCarveOutTimeBatch Job 1', cronexpression1, new LGCarveOutTimeBatch_Scheduler());
    System.schedule('LGCarveOutTimeBatch Job 2',cronexpression2, new LGCarveOutTimeBatch_Scheduler());
   }
}