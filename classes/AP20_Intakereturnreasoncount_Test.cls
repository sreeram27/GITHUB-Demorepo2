@isTest(seealldata=true)
public class AP20_Intakereturnreasoncount_Test {
    private static final string NATIONALIMPLEMENTATIONPROFILE='National Implementations'; 
    
    static testMethod void testIntakeReturn() {
       Profile profileNA = [select id from profile where name=:NATIONALIMPLEMENTATIONPROFILE limit 1];
       User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
       
        test.starttest();
          system.runAs(user) { 
              intakeCountTesting();
          }
       test.stoptest(); 
     } 
    public static void  intakeCountTesting() {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> optns = new Map<String,Object>();
        
        Map<String,List<Object>> AddIntakeReasons = new Map<String,List<Object>>();
        List<Object> AddIntakeReturn = new List<Object>();
            Map<String,String> TestIntake = new Map<String,String>(); 
                TestIntake.put('ImpReasons', 'Documents not attached');
                TestIntake.put('ImplementerComments', 'TestComments');
            Map<String,String> TestReason = new Map<String,String>(); 
                TestReason.put('reasonCount', '1');
        AddIntakeReturn.add(TestIntake);
        AddIntakeReturn.add(TestReason);
        AddIntakeReasons.put('AddIntakeReturn',AddIntakeReturn);
        inputMap.put('AddIntakeReasons', AddIntakeReasons);
        String methodName = UtilConstants.REASON_COUNT;
        
        AP20_Intakereturnreasoncount.invokeMethod(methodName, inputMap, outMap, optns);
    }

}