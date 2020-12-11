/**************************************************************************************
Apex Class Name:  AccTeamReportSchedulerTest
Version     : 1.0 
Created Date    : 21 August 2018
* @Author: Accenture Offshore
Function    : AccTeamReportScheduler Test Class 
*************************************************************************************/


@isTest
public class AccTeamReportSchedulerTest {
    
    
    static testMethod void testMethodSchedular() 
    {
        
        Test.startTest();
        AccountRoles__c roles = new AccountRoles__c();
        roles.Name = 'AccountTeamReport';
        roles.LastRun__c = Datetime.now();
        insert roles;
        
		AccTeamReportScheduler sch= new AccTeamReportScheduler();
        String cronExpr = '0 0 * * * ?';
		String jobId = System.schedule('Account Team Report Batch Test', cronExpr, sch);
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(cronExpr, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
		Test.stopTest();
    }
    

}