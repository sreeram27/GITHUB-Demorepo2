/* ***************************************************************************
Class Name   : MedicalBenefitUpdate 
Date Created : 18-June-2019
Created By   : Deloitte
Description  : This gets called from the Process Builder ""
******************************************************************************* */
global class MedicalBenefitUpdate{ 
    
    @InvocableMethod
    public static void StatusUpdate(List<Id> orderlist){
        Set<Id> orderlst= new Set<Id>(orderlist);
        List<order> orderprocesslst= [SELECT Batch_Processed_Records__c from order where id IN :orderlst];
        if(orderprocesslst!= null && !orderprocesslst.isEmpty())
        {
            for(order eachorder: orderprocesslst)
            {
                eachorder.Batch_Processed_Records__c= false;
                //eachorder.MB_Update_Done__c = true;
            }
            update orderprocesslst;
        }
        
    }
}