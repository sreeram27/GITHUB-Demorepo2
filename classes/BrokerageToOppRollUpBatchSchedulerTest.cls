/**************************************************************************************
    Class Name:   QLIToAccountRollUpBatchLGScheduler_Test
    Version     : 1.0 
    Created Date    : 03 July 2019
    @Author: Sharath KN ,Legato 
    Function    : Batch to rollup QLIs to Opportunity records
    *************************************************************************************/

@isTest
private class BrokerageToOppRollUpBatchSchedulerTest
{
    
    @testSetup    
    static  void setupTestData(){
        AccountRoles__c roles = new AccountRoles__c();
        roles.Name = 'BrokerageOppReport';        
        DateTime dt = DateTime.newInstance(2012,2,3,13,20,30);
        roles.LastRun__c = dt;
        insert roles;
        
    }
    static testmethod void schedulerTest() 
    {
        String CRON_EXP1 = '0 0 * * * ?';
        String CRON_EXP2 = '0 15 * * * ?';
    
        
        Test.startTest();

            String jobId1 = System.schedule('test1',  CRON_EXP1, new BrokerageToOppRollUpBatchScheduler());
            String jobId2 = System.schedule('test2',  CRON_EXP2, new BrokerageToOppRollUpBatchScheduler());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId1];
            System.assertEquals(CRON_EXP1, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            BrokerageToOppRollUpBatchScheduler.SchedulerMethod();

        Test.stopTest();
     
    }
}