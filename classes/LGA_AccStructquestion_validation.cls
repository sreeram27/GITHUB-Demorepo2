/*******************************************************************************************
@class Name  : LGA_AccStructquestion_validation
@created By  : IDC Offshore
@createdDate : 14/02/2019
@description : This class is for displaying error message
********************************************************************************************/
global with sharing class LGA_AccStructquestion_validation implements vlocity_ins.VlocityOpenInterface2{

/*******************************************************************************************
@method Name  : invokeMethod
@description : Get the data from Omni Script 
@return : Boolean
@param : methodName,inputMap,outMap,optns
********************************************************************************************/    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String,Object > outMap, Map < String, Object > optns) {
        if(LGA_Constants.CLAIMSRTVALIDATION.equalsIgnoreCase(methodName)){
            claimsRouteValidation(inputMap, outMap, optns);
        }
        
        return true;
    }

/*******************************************************************************************
@method Name  : claimsRouteValidation
@description : This method is to throw error based on the flag value. 
@param : inputMap,outMap,optns
********************************************************************************************/    
    global void claimsRouteValidation (Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns){
        String errorMessage = 'Please fill all the required details.';
        Boolean flagValue = (boolean)optns.get(LGA_Constants.FLAGVAL);
        system.debug('flagValue'+flagValue);
        if(flagValue || LGA_Constants.CLAIMSRTCODE== Null){
            outMap.put(LGA_Constants.ERROR, errorMessage);
        }
    }   
}