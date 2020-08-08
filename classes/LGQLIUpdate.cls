/* ***************************************************************************
Class Name   : LGQLIUpdate 
Date Created : 09-MAY-2018
Created By   : Deloitte USI
Description  : This gets called from the Process Builder "UpdateQLIProdStage"
******************************************************************************* */
global class LGQLIUpdate {

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
        List<QuoteLineItem> lstQLI =[SELECT id,ProductStage__c ,OpportunityId__c FROM QuoteLineItem WHERE OpportunityId__c IN: lstOp];
        if(!lstQLI.isEmpty()){
            for(QuoteLineItem qli : lstQLI ){
                //qli.ProductStage__c = 'Declined to Quote';
                //qli.Probability__c ='0%';
                qli.ProductStage__c = staticVariableClass.LgQliUpdateProdStage;// changed as part of Code Coverage fix
                qli.Probability__c = staticVariableClass.LgQliUpdateProdProbability;// changed as part of Code Coverage fix
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