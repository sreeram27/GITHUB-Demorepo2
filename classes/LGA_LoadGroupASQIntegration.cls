/********************************************************************************************
                                  @description:LGA_LoadGroupASQIntegration
     ********************************************************************************************/
global with sharing class LGA_LoadGroupASQIntegration  implements vlocity_ins.VlocityOpenInterface {
     /********************************************************************************************
                                  @description:
     ********************************************************************************************/
      public Static final String ERROR = 'error';
      
     global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
            Boolean executedSuccessfully = false;
           
        
               if (LGA_UTIL_Constants.LOADGROUP_INT_METHODNAME.equalsIgnoreCase(methodName)) 
            {   
                try{
                    
                    loadGroupInt((String)options.get(LGA_UTIL_Constants.LOADGROUP_INT_IMPLCASE),outMap); 
                     executedSuccessfully = true;
                }Catch(Exception ex){
                    executedSuccessfully = false;
                    //System.debug('****The following exception has occurred in createGroupPlan method of LGA_AccountStructureOSRemote : '+ex);
                }             
        
            }
         
          else if (LGA_UTIL_Constants.ACCOUNTSTRUCTUREINT_METHODNAME.equalsIgnoreCase(methodName)) 
            {   
                try{
                    accountStructureInt((String)options.get(LGA_UTIL_Constants.ACCOUNTSTRUCTUREINT_IMPLCASE),outMap); 
                    executedSuccessfully = true;
                }Catch(Exception ex){
                    executedSuccessfully = false;
                   
                }             
        
            }
         
             return executedSuccessfully;
     }
    /********************************************************************************************
                                  @description:
     ********************************************************************************************/
        Public void loadGroupInt(String implCaseId,  Map<String,Object> outMap){
        
        if(implCaseId != ''){
            String message = CMIntegrationService.submitCaseToCMforAddUpdate (implCaseId);  
          //  System.debug('==========message==========='+message);
            outMap.put(ERROR ,message);
            //If (message == 'SUCCESS'){
            If (message.equalsIgnoreCase('SUCCESS')){
            message='Succesfully submitted to Customer Master';
          //  System.debug('==========message==========='+message);
            
            }
            Else{
            message='Not Successful';
           //  System.debug('==========message==========='+message);
            }
            outMap.put(ERROR ,message);
        }

        
        }
    /********************************************************************************************
                                  @description:
     ********************************************************************************************/    
            
     Public void accountStructureInt(String implCaseId, Map<String,Object> outMap){
        if(implCaseId != ''){
            String message = CMIntegrationService.submitCaseToCMforPreview(implCaseId);  
          //  System.debug('==========message==========='+message);
            //If (message == 'SUCCESS')
            If (message.equalsIgnoreCase('SUCCESS')){
            message='Succesfully submitted to Customer Master';
            //System.debug('==========message==========='+message);
            
            }
            Else{
            message='Not Successful';
            // System.debug('==========message==========='+message);
            }
            
            outMap.put(ERROR ,message);
        }

        
        }
        
 }