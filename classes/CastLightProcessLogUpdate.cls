/* ***************************************************************************
Class Name   : CastLightProcessLogUpdate 
Date Created : 20-Feb-2019
Created By   : Legato
Description  : This gets called from the Process Builder "Reset CastLight Send Indicator for QLI update"
******************************************************************************* */
global class CastLightProcessLogUpdate { 
    
    @InvocableMethod
    public static void StatusUpdate(List<Id> oppList){
        Set<Id> oppSet = new Set<Id>(oppList);
        List<CSLT_Integration_Process_Log__c> csltProcessLogList = [SELECT Send_Update__c from CSLT_Integration_Process_Log__c where OpportunityId__c IN :oppSet];
        if(csltProcessLogList != null && !csltProcessLogList.isEmpty())
        {
            for(CSLT_Integration_Process_Log__c csltProcessLog : csltProcessLogList)
            {
                csltProcessLog.Send_update__c = true;
            }
            update csltProcessLogList;
        }
        
    }
}