@isTest
private class LG_PendingCorrectionBatch_Scheduler_Test
{
    
    static testmethod void schedulerTest() 
    {
        string CRON_EXP1=staticVariableClass.String_CarveCron_Exp1;
        string CRON_EXP2=staticVariableClass.String_CarveCron_Exp2;
        
        
        Test.startTest();
        
        String jobId1 = System.schedule('test1',  CRON_EXP1, new LG_PendingCorrection_Batch_Scheduler());
        String jobId2 = System.schedule('test2',  CRON_EXP2, new LG_PendingCorrection_Batch_Scheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId1];
        System.assertEquals(CRON_EXP1, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        try
        {
            cronjobdetail cjd1 = [select id,name from cronjobdetail where name = 'Scheduled Job 1'];
            cronjobdetail cjd2 = [select id,name from cronjobdetail where name = 'Scheduled Job 2'];
            CronTrigger aj1 = [SELECT Id,cronjobdetailid FROM CronTrigger WHERE cronjobdetailid = :cjd1.id];
            CronTrigger aj2 = [SELECT Id,cronjobdetailid FROM CronTrigger WHERE cronjobdetailid = :cjd2.id];
            system.abortJob(aj1.Id);
            system.abortJob(aj2.Id);
        }
        Catch(Exception ex)
        {
            
        }
        finally
        {
            LG_PendingCorrection_Batch_Scheduler.SchedulerMethod();
        }
        
        Test.stopTest();
        
    }
}