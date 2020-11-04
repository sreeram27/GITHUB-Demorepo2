/**************************************************************************************
Apex Class Name :  LGBatchSyncJiraLGScheduler
Version         : 1.0 
Created Date    : 03 May 2019
@Author         : Praveen Yerram
Function        : Schedulable class for LGBatchSyncJira Batch Apex class for Local/Large Group 
*************************************************************************************/

global class LGBatchSyncJiraLGScheduler implements schedulable{
    
    global void execute(SchedulableContext sc)
    {
        LGBatchSyncJira lgBatch = new LGBatchSyncJira('LG'); 
        database.executebatch(lgBatch,1);
    }
    
}