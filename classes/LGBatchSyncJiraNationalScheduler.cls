/**************************************************************************************
Apex Class Name :  LGBatchSyncJiraNationalScheduler
Version         : 1.0 
Created Date    : 03 May 2019
@Author         : Praveen Yerram
Function        : Schedulable class for LGBatchSyncJira Batch Apex class for National 
*************************************************************************************/

global class LGBatchSyncJiraNationalScheduler implements schedulable{
    
    global void execute(SchedulableContext sc)
    {
        LGBatchSyncJira nationalBatch = new LGBatchSyncJira('National'); 
        database.executebatch(nationalBatch,1);
    }
    
}