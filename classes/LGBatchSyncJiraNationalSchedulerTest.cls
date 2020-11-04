/**************************************************************************************
Apex Class Name :  LGBatchSyncJiraNationalSchedulerTest
Version         : 1.0 
Created Date    : 03 May 2019
@Author         : Praveen Yerram
Function        : Test Class for LGBatchSyncJiraNationalScheduler Apex class
*************************************************************************************/ 
@isTest
public class LGBatchSyncJiraNationalSchedulerTest {
    static testMethod void testMethodScheduler() 
    {
        Test.startTest();
        LGBatchSyncJiraNationalScheduler sch= new LGBatchSyncJiraNationalScheduler();
        String cronExpr = '0 0 * * * ?';
        String jobId = System.schedule('SFDC To JIRA National Batch', cronExpr, sch);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronExpr, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}