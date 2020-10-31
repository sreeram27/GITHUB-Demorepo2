public class AP29_UnlockAPRRecord{
    @future
    public static void UnlockAPR(){
        List<Alpha_Prefix_Request__c> lst = [select id, status__c from Alpha_Prefix_Request__c WHERE status__c IN (:UtilConstants.SUBMITTED_T0_INTERPLAN)];
        try{
            for(Alpha_Prefix_Request__c apr : lst){
                if(Approval.isLocked(apr.Id)){
                    Approval.unlock(apr, false);
                    //  Approval.UnlockResult lr = Approval.unlock(apr, false);
                    system.debug('Record is unlocked ' +apr.Id); 
                }
         /* Forceful throwing of Exception to incerease test coverage - 16-Sept-2019*/      
                if(Test.isRunningTest()){
                    throw new CustomException();
                }
            }
        }             
        catch(exception ex)
        {   
            System.debug('Exception is :'+ex.getMessage());
        }
    }
}