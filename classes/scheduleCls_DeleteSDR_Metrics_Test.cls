@isTest
public class scheduleCls_DeleteSDR_Metrics_Test {
    @isTest
    public static void Test_Schedulable_Class_Method(){
        Test.startTest();
        scheduleCls_DeleteSDR_Metrics SchDelMetrics = new scheduleCls_DeleteSDR_Metrics();
        String runTrigger = '0 0 23 * * ?';
        System.schedule('Deletion', runTrigger, SchDelMetrics);
        Test.stopTest();
    }

}