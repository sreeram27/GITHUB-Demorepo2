/**
@Author : Deloitte
@name : LGSMENotApprovedSchedulable
@CreateDate :18-01-2019
@Description : This is a schedular class which will run on 30 min basis and will invoke the batch class.
*/

global class LGSMENotApprovedSchedulable implements Schedulable {

  global void execute(SchedulableContext sc) {
    
    
    LGSMENotApproved b = new LGSMENotApproved();
    Database.executeBatch(b,1);
  }
   Public static void SchedulerMethod() {
   
   Batch_Job_Cron_Expression__mdt m=[select id,DeveloperName,Cron_Expression__c from Batch_Job_Cron_Expression__mdt where DeveloperName='LGSMENotApprovedBatchClass'];
     //System.schedule('Scheduled Job 1', '0 0 * * * ?', new LGSMENotApprovedSchedulable());
    //System.schedule('Scheduled Job 2', '0 30 * * * ?', new LGSMENotApprovedSchedulable());
    string cronexpression1=m.Cron_Expression__c.split(';')[0];
    string cronexpression2=m.Cron_Expression__c.split(';')[1];
    System.schedule('LGSMENotApproved Job 1', cronexpression1, new LGSMENotApprovedSchedulable());
    System.schedule('LGSMENotApproved Job 2',cronexpression2, new LGSMENotApprovedSchedulable());
   }
}