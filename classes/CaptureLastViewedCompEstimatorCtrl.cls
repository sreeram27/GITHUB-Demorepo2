public class CaptureLastViewedCompEstimatorCtrl {
    @AuraEnabled
    public static Boolean captureCeId( String CeId ) {
        Last_Viewed_Compensation_Estimator__c lvc = Last_Viewed_Compensation_Estimator__c.getInstance( UserInfo.getUserId() );
        
        if( lvc.Compensation_Estimator_Id__c != CeId ) {
            lvc.SetupOwnerId = UserInfo.getUserId();
            lvc.Compensation_Estimator_Id__c = CeId;
            
            UPSERT lvc Id;

            return true;
        }
        else {
            return false;
        }
    }
}