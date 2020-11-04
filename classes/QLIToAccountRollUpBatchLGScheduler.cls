/**************************************************************************************
Apex Class Name:  QLIToAccountRollUpBatchLGScheduler
Version     : 1.0 
Created Date    : 13 June 2019
* @Author: Legato Vikings Team
Function    : class to call Batch Apex 
*************************************************************************************/
global class QLIToAccountRollUpBatchLGScheduler implements schedulable
{
  /**
* Methods that calls the batch apex
* 
* @Date:   13 June 2019
* @Author: Legato Vikings Team
  @UStory: PRDCRM-35604
* 
*/
   global void execute(SchedulableContext sc)
    {
     QLIToAccountRollUpBatchLG  b = new QLIToAccountRollUpBatchLG(); 
     database.executebatch(b,200);
    }
    
    
   Public static void SchedulerMethod() {
   
    Batch_Job_Cron_Expression__mdt m=[select id,DeveloperName,Cron_Expression__c from Batch_Job_Cron_Expression__mdt where DeveloperName='QLIToAccountRollUpBatchLG_Class'];     
    string cronexpression1=m.Cron_Expression__c.split(';')[0];
    string cronexpression2=m.Cron_Expression__c.split(';')[1];
    System.schedule('QLIToAccountRollUpBatchLG Job 1', cronexpression1, new QLIToAccountRollUpBatchLGScheduler());
    System.schedule('QLIToAccountRollUpBatchLG Job 2',cronexpression2, new QLIToAccountRollUpBatchLGScheduler());
   }
}