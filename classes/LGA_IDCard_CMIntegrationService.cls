/*******************************************************************************************
@class Name  : LGA_IDCard_CMIntegrationService
@created By  : IDC Offshore
@createdDate : 01/06/2020
@description : This class used for displaying error message
********************************************************************************************/
global  with sharing class LGA_IDCard_CMIntegrationService implements vlocity_ins.VlocityOpenInterface2 {
    /*******************************************************************************************
@method Name  : invokeMethod
@description : Get the data from Omni Script 
@return : Boolean
@param : methodName,inputMap,outMap,optns
********************************************************************************************/
    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String,Object > outMap, Map < String, Object > optns) {
        if(LGA_Constants.IDCARDTRIGGER.equalsIgnoreCase(methodName)){
            IDCardTrigger(inputMap, outMap, optns);
        } 
        return true;   
    }
    /*******************************************************************************************
@method Name  : IDCardTrigger
@description : This method is used for displaying error message
@param : inputMap,outMap,optns
********************************************************************************************/
    global void IDCardTrigger(Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns){
        try{
            List<String> suffixList = New List<String>();
            String response = '';
            String iMPcaseId=(String)optns.get(LGA_Constants.IMPLSCASEID);
            String ImpCaseType = (String)optns.get(LGA_Constants.IMPCASETYPE);
            system.debug('######iMPcaseId'+iMPcaseId);
            system.debug('######iMPcaseId'+ImpCaseType);
            system.debug('######iMPcaseId'+ optns.get(LGA_Constants.GROUPSUFFIX));
            system.debug('######iMPcaseId'+ (ImpCaseType == 'New Business'));
            
            if(iMPcaseId!= '' && ImpCaseType == LGA_Constants.NEWBUSINESS){
                response = CMIntegrationService.triggerIDCardCaseLevel(iMPcaseId);
                system.debug('@@@response123' +response);
                system.debug('@@@response' +response.contains(LGA_Constants.SUCCESS));
                if(!response.equalsIgnoreCase(LGA_Constants.SUCCESS)){
                    outMap.put(LGA_Constants.ERROR, response);   
                }
                
                
                system.debug('@@@response' +response.contains(LGA_Constants.SUCCESS));
                //outMap.put(LGA_Constants.ERROR, response);
                //outMap.put(SUCCESS, response);
                
            }else if(iMPcaseId!= '' && (ImpCaseType == LGA_Constants.CHANGEREQOFFCYC || ImpCaseType == LGA_Constants.RENEWALS)){
                for(Object obj : (List<Object>)optns.get(LGA_Constants.GROUPSUFFIX) ){
                    system.debug('@@@@@@@' + (String)obj);
                    suffixList.add((String)obj);
                }
                
                response = CMIntegrationService.triggerIDCardSuffixLevel(iMPcaseId,suffixList);
                system.debug('@@response'+response);
                if(!response.equalsIgnoreCase(LGA_Constants.SUCCESS)){
                    outMap.put(LGA_Constants.ERROR, response);   
                }
            }
        }
        
        Catch(Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }    
    }
}