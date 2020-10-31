/**************************************************************************************
Apex Class Name:  LGRenewalBatchScheduler
Version     : 1.0 
Created Date    : 14 March 2018
* @Author: Deloitte Offshore
Function    : class to call Batch Apex 
Scheduling Renewal Batch Apex Class
*************************************************************************************/
global class LGRenewalBatchScheduler implements schedulable
{
  /**
* Methods that calls the batch apex
* 
* @Date: 14 March 2018
* @Author: Deloitte Offshore
* 
*/
global void execute(SchedulableContext sc)
    {
    LGCreateRenewalOpportunityBatch  b = new LGCreateRenewalOpportunityBatch(); 
      database.executebatch(b,1);
    }
}