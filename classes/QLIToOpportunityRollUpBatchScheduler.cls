/*
* Purpose: Rolls up field values to respective Opportunity records
* Version: 1.0
* 
* JIRA NUMBER    DATE           DEVELOPER    DESCRIPTION 
* ===========    ===========    =========    =======================================================
*PRDCRM-33940    03-July-2019    Sharath KN   Created scheduler class
*/
global class QLIToOpportunityRollUpBatchScheduler implements schedulable{
	global void execute(SchedulableContext sc)
    {
     QLIToOpportunityRollUpBatch  b = new QLIToOpportunityRollUpBatch(); 
     database.executebatch(b,200);
    }
    
    
   Public static void SchedulerMethod() {
   
    Batch_Job_Cron_Expression__mdt m=[select id,DeveloperName,Cron_Expression__c from Batch_Job_Cron_Expression__mdt where DeveloperName='LG_QLIToOpportunityRollUpBatch'];     
    string cronexpression1=m.Cron_Expression__c.split(';')[0];
    string cronexpression2=m.Cron_Expression__c.split(';')[1];
    System.schedule('QLIToOpportunityRollUpBatch Job 1', cronexpression1, new QLIToOpportunityRollUpBatchScheduler());
    System.schedule('QLIToOpportunityRollUpBatch Job 2',cronexpression2, new QLIToOpportunityRollUpBatchScheduler());
   }
}