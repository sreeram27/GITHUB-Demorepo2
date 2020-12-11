/**************************************************************************************
Apex Class Name:  SBCSOBRequestTriggerHandler
Version     : 1.0 
Created Date    : 11 September 2019
* @Author: X-men Offshore(Smita)
US          : PRDCRM-42116
*************************************************************************************/

public with sharing class SBCSOBRequestTriggerHandler {
    
    public static void onBeforeInsert(List<SBC_SOB_Request__c> sbcList) {
        SBCSOBActions.updateSBC(sbcList);
    }
     
    public static void onBeforeUpdate( List<SBC_SOB_Request__c> sbcList, List<SBC_SOB_Request__c> oldsbcList, Map<ID, SBC_SOB_Request__c> newSbcMap, Map<ID, SBC_SOB_Request__c> oldSbcMap) {
        SBCSOBActions.updateSBC(sbcList);
    }
}