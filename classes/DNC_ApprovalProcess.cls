/***************************************************************************************
Class Name   : DNC_ApprovalProcess 
Date Created : 19-APR-2018
Created By   : Deloitte USI
Description  : Class being called from Omnisript page if DNC Reason is not Contractual
******************************************************************************************/
// implements vlocity_ins.VlocityOpenInterface2
 global  without sharing class DNC_ApprovalProcess implements vlocity_ins.VlocityOpenInterface2
 {
     global Boolean invokeMethod(String methodName, map<String,Object> inputMap, map<String,Object> outMap, map<String,Object> optns) 
    {
         if('DNC_CallApprovalProcess'.equalsIgnoreCase(methodName))
        {
            //This method will be called when Generate Group # button is clicked
            DNC_CallApprovalProcess(inputMap, outMap);   
        }
        return true;
    }
    global static Boolean DNC_CallApprovalProcess(map<String,Object> inputMap, map<String,Object> outMap){
        
       String dncPrefId = String.ValueOf(inputMap.get('DRId_DNC_Preferences__c'));
      System.debug('@@DRId_DNC_Preferences__c'+inputMap.get('DRId_DNC_Preferences__c'));
        try{
        
        DNC_Preferences__c dncPref =[SELECT id,DNC_Reason__c  FROM DNC_Preferences__c WHERE id =: dncPrefId];
        System.debug('@@dncPref '+dncPref);
        if (dncPref.DNC_Reason__c != 'Contractual') {
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(dncPref.Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);   
             if(result.isSuccess()){
             System.debug('@@@'+outMap.get('FlagValue'));
             outMap.put('FlagValue', 'Yes');
              System.debug('@@@'+outMap.get('FlagValue'));
              return true;
             }
        }
        outMap.put('FlagValue', 'No');
        return false;
        }catch(DMLException e){
              System.debug('Exception Error'+e.getMessage());
              outMap.put('FlagValue', 'No');
              return false;
        }
    }
}