/* ***************************************************************************
Class Name   : QLIUpdateForAccountBatch 
Date Created : 12-Feb-2020
Created By   : Partha Pratim Baruah (Vikings)
Description  : This gets called from the Process Builder "UpdateQLIProdStage"
******************************************************************************* */
global class QLIUpdateForAccountBatch {

    @InvocableMethod
    public static void QLIUpdate(List<Id> lstOppId){
    try{
        List<QuoteLineItem> lstQliUpdate = new List<QuoteLineItem>();
        System.debug('@@@lstOppId'+lstOppId);
        List<String> lstOp = new List<String>();
        for(String opp:lstOppId){
          String s = String.valueOf(opp);
          lstOp.add(s.substring(0, 15));
        }
        
        System.debug('@@@@@lstOp'+lstOp);
        if(!lstOp.isEmpty()){
        List<QuoteLineItem> lstQLI =[SELECT id,ProductStage__c ,OpportunityId__c,TimeofStageOrEffectiveDateChange__c  FROM QuoteLineItem WHERE OpportunityId__c IN: lstOp and ProductLOB__c='Medical' ];
        if(!lstQLI.isEmpty()){
            for(QuoteLineItem qli : lstQLI ){                
                qli.TimeofStageOrEffectiveDateChange__c = system.now();              
                lstQliUpdate.add(qli);
            }
        }
        if(!lstQliUpdate.isEmpty()){
            UPDATE lstQliUpdate;
        }
        }
    }
    catch(Exception e){
        System.debug('Exception'+e);
    }
    
}
}