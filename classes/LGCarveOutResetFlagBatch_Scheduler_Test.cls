@isTest
private class LGCarveOutResetFlagBatch_Scheduler_Test
{

    static testmethod void schedulerTest() {
        String CRON_EXP1 = '0 0 * * * ?';
        String CRON_EXP2 = '0 30 * * * ?';
    
        
        Test.startTest();

            String jobId1 = System.schedule('ScheduleApexClassTest1',  CRON_EXP1, new LGCarveOutResetBatchFlagBatch_Scheduler());
            String jobId2 = System.schedule('ScheduleApexClassTest2',  CRON_EXP2, new LGCarveOutResetBatchFlagBatch_Scheduler());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId1];
            System.assertEquals(CRON_EXP1, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        
          try
        {
            cronjobdetail cjd1 = [select id,name from cronjobdetail where name = 'LGCarveOutResetBatchFlag Job 1'];
            cronjobdetail cjd2 = [select id,name from cronjobdetail where name = 'LGCarveOutResetBatchFlag Job 2'];
            
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
            LGCarveOutResetBatchFlagBatch_Scheduler.SchedulerMethod();
        }
             
          // system.abortJob(jobId1);
          //  system.abortJob(jobId2);
          //  LGCarveOutResetBatchFlagBatch_Scheduler.SchedulerMethod();
        Test.stopTest();
    }

	static testmethod void schedulerTest1() {
        String CRON_EXP1 = '0 0 * * * ?';
        String CRON_EXP2 = '0 30 * * * ?';
    
        
        Test.startTest();
            String jobId3 = System.schedule('ScheduleApexClassTest3',  CRON_EXP1, new LGCarveOutTimeBatch_Scheduler());
            String jobId4 = System.schedule('ScheduleApexClassTest4',  CRON_EXP2, new LGCarveOutTimeBatch_Scheduler());
            CronTrigger ct1 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId3];
            System.assertEquals(CRON_EXP1, ct1.CronExpression);
            System.assertEquals(0, ct1.TimesTriggered);
        
         try
        {
            cronjobdetail cjd1 = [select id,name from cronjobdetail where name = 'LGCarveOutTimeBatch Job 1'];
            cronjobdetail cjd2 = [select id,name from cronjobdetail where name = 'LGCarveOutTimeBatch Job 2'];
            
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
           LGCarveOutTimeBatch_Scheduler.SchedulerMethod();
        }
            // system.abortJob(jobId3);
            //system.abortJob(jobId4);
            //LGCarveOutTimeBatch_Scheduler.SchedulerMethod();
            Test.stopTest();
    }	
}