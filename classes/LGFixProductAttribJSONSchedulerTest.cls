@istest
public class LGFixProductAttribJSONSchedulerTest {
@istest 
    static void testExecute(){
        Test.startTest();
        //LGFixProductAttribJSONScheduler a = new LGFixProductAttribJSONScheduler();
        //a.executeBatchJob();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        String jobId = System.schedule('LGFixProductAttribJSONScheduler',CRON_EXP,new LGFixProductAttribJSONScheduler());
        Test.stopTest();
        
        /*Test.startTest();
        String sch = '0 30 8 10 2 ?'
        Sting jobId = System.schedule('LGFixProductAttribJSONScheduler',sch,LGFixProductAttribJSONScheduler);
       */
    }
}