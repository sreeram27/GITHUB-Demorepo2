/*
@author         Accenture offshore
@date           9/7/2018
@name           AP28_BPD_Helper
@description    Called from trigger on BPD object to add errors.  
*/

/*This class is used to validate BPD Records*/ 
public with sharing class AP28_BPD_Helper{
    
    /*This method is used to fire and error for BPD Records*/ 
    public static void addError(List<BPD__c >newBpdList){
    try{
        for(BPD__c BPD : newBpdList){  
            
            //Is_Client_Approval_Needed__c is required field for assigned imp approval.
            if(bpd.BPD_Status__c==UtilConstants.PendingResponsefromESR && bpd.Is_Client_Approval_Needed__c==UtilConstants.nullString){
                bpd.addError(UtilConstants.errorMSGBPD); 
                Break;                   
            }
        }
    }catch(Exception excp){
        UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.CLASS_NAMESME,UtilConstants.sendStatusChangemail,UtilConstants.triggerName,LoggingLevel.ERROR);
        
     }
   }
}