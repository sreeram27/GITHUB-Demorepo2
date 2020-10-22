/*
@Author : Accenture Offshore Dev team
@name : ANA_OpportunityTrigger_Handler
@CreateDate :25-05-2017
@Description : This class calls persistLineItemData method of ANA_AP04_Process_QuoteLineItems class to process QuoteLineItems.
*/

public with sharing class ANA_OpportunityTrigger_Handler{  
    private Static Final string CLASS_NAME='ANA_OpportunityTrigger_Handler';
    public Static Final String TRIGGER_NAME = 'ANA_OpportunityBeforeUpdate';
    public static boolean afterUpdateRecursive = false;
    public static boolean beforeUpdateRecursive = false;        
    /* This method process the QuoteLineItems */   
    public static void beforeUpdate(List<Opportunity> newList,Map<Id,Opportunity> oldMap){          
       if(beforeUpdateRecursive) {
            return;
       }
       try{
           beforeUpdateRecursive = true;
           ANA_AP04_Process_QuoteLineItems helper = new ANA_AP04_Process_QuoteLineItems();
           helper.persistLineItemData(newList,oldMap);  
       }
      catch(Exception excp){
          	//trigger.new[0].addError(excp.getMessage());
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TRIGGER_NAME,LoggingLevel.ERROR);    
            
        } 
   }
		//Commented below method - 38037, 38416, CDHP Functionality
       /*public static void afterUpdate(List<Opportunity> newList,Map<Id,Opportunity> oldMap){          
       if(afterUpdateRecursive) {
            return;
       }
       try{
           afterUpdateRecursive = true;
           CDHP_ISG_Send_Opportunity helper = new CDHP_ISG_Send_Opportunity();
           helper.sendOpportunityData(newList,oldMap);  
       }
      catch(Exception excp){
            trigger.new[0].addError(excp.getMessage());
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TRIGGER_NAME,LoggingLevel.ERROR);    
            
        } 
     }*/

}