/**************************************************************************************
Apex Class Name:  AccTeamReportScheduler
Version     : 1.0 
Created Date    : 02 August 2018
* @Author: Accenture Offshore
Function    : class to call Batch Apex 
*************************************************************************************/

global class AccTeamReportScheduler implements schedulable{
 global void execute(SchedulableContext sc)
    {
      AccTeamReportBatch batch = new AccTeamReportBatch(); 
      database.executebatch(batch);
    }
}