/* ***************************************************************************
Class Name   : QLIUpdate 
Date Created : 09-MAY-2018
Created By   : Accenture
Description  : This gets called from the Process Builder "UpdateQLIReason"
******************************************************************************* */
global class QLIUpdate {

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
        List<QuoteLineItem> lstQLI =[SELECT id,Reason__c,Reason_Update__c,OpportunityId__c FROM QuoteLineItem WHERE OpportunityId__c IN: lstOp];
        if(!lstQLI.isEmpty()){
            for(QuoteLineItem qli : lstQLI ){
                //qli.ProductStage__c = 'Declined to Quote';
                qli.Reason__c= qli.Reason_Update__c;
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