@isTest
private class LGSMENotApprovedSchedulable_Test
{

    static testmethod void schedulerTest() 
    {
        //String CRON_EXP1 = '0 0 * * * ?';
        //String CRON_EXP2 = '0 30 * * * ?';
        string CRON_EXP1=staticVariableClass.String_CarveCron_Exp1;
        string CRON_EXP2=staticVariableClass.String_CarveCron_Exp2;
        
        Test.startTest();

            String jobId1 = System.schedule('ScheduleApexClassTest1',  CRON_EXP1, new LGSMENotApprovedSchedulable());
            String jobId2 = System.schedule('ScheduleApexClassTest2',  CRON_EXP2, new LGSMENotApprovedSchedulable());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId1];
            System.assertEquals(CRON_EXP1, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        
        try
        {
            cronjobdetail cjd1 = [select id,name from cronjobdetail where name = 'LGSMENotApproved Job 1'];
            cronjobdetail cjd2 = [select id,name from cronjobdetail where name = 'LGSMENotApproved Job 2'];
            
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
            LGSMENotApprovedSchedulable.SchedulerMethod();
        }
        
  
        Test.stopTest();
     
    }
}