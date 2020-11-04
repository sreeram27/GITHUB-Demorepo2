/**************************************************************************************
Apex Class Name :  JIRAToSFDCSyncBatchScheduler
Version         : 1.0 
Created Date    : 03 May 2019
@Author         : Praveen Yerram
Function        : Schedulable class for JIRAToSFDCSyncBatch_v2 Batch Apex class
*************************************************************************************/

global class JIRAToSFDCSyncBatchScheduler implements schedulable{
    
    global void execute(SchedulableContext sc)
    {
        JIRAToSFDCSyncBatch_v2 JiraBS = new JIRAToSFDCSyncBatch_v2();
        Database.executeBatch(JiraBS, 1);
    }
    
}