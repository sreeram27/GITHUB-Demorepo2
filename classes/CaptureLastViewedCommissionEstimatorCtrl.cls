public class CaptureLastViewedCommissionEstimatorCtrl {
    @AuraEnabled
    public static Boolean captureCeId( String CeId ) {
        Last_Viewed_Commission_Estimator__c lvc = Last_Viewed_Commission_Estimator__c.getInstance( UserInfo.getUserId() );
        
        if( lvc.Commission_Estimator_Id__c != CeId ) {
            lvc.SetupOwnerId = UserInfo.getUserId();
            lvc.Commission_Estimator_Id__c = CeId;
            
            UPSERT lvc Id;

            return true;
        }
        else {
            return false;
        }
    }
}