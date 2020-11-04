/**************************************************************************************
Apex Class Name :  JIRAToSFDCSyncBatchSchedulerTest
Version         : 1.0 
Created Date    : 03 May 2019
@Author         : Praveen Yerram
Function        : Test Class for JIRAToSFDCSyncBatchScheduler Apex class
*************************************************************************************/

@isTest
public class JIRAToSFDCSyncBatchSchedulerTest {
    static testMethod void testMethodScheduler() 
    {
        Test.startTest();
        JIRAToSFDCSyncBatchScheduler sch= new JIRAToSFDCSyncBatchScheduler();
        String cronExpr = '0 0 * * * ?';
        String jobId = System.schedule('JIRA To SFDC Batch Test', cronExpr, sch);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronExpr, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }

}