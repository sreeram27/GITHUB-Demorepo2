/**************************************************************************************
Apex Class Name :  LGBatchSyncJiraLGSchedulerTest
Version         : 1.0 
Created Date    : 03 May 2019
@Author         : Praveen Yerram
Function        : Test Class for LGBatchSyncJiraLGScheduler Apex class
*************************************************************************************/
@isTest
public class LGBatchSyncJiraLGSchedulerTest {
    static testMethod void testMethodScheduler() 
    {
        Test.startTest();
        LGBatchSyncJiraLGScheduler sch= new LGBatchSyncJiraLGScheduler();
        String cronExpr = '0 0 * * * ?';
        String jobId = System.schedule('SFDC To JIRA LG Batch', cronExpr, sch);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronExpr, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }

}