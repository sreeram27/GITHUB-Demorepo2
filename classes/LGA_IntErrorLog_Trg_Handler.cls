/*******************************************************************************************
@class Name  : LGA_IntErrorLog_Trg_Handler
@created By  : IDC Offshore
@createdDate : 11/19/2019
@description : This is the Handler Class for LGA_IntErrorLog_Trg Trigger.
********************************************************************************************/
public with sharing class LGA_IntErrorLog_Trg_Handler {
    
    /*******************************************************************************************
@method Name  : calculate_Avg_ResTime
@description : Get the Integration Error Log list 
@param : intErrorLogList
********************************************************************************************/
    public void calculateAvgResTime(List<Integration_Error_Log__c> intErrorLogList){
        try {
            List<Integration_Event_Log__c> intEventsUpdateLst = new List<Integration_Event_Log__c>();
            List<String> relatedIntEventIDLst = new List<String>();
            for(Integration_Error_Log__c intError : intErrorLogList){
                relatedIntEventIDLst.add(intError.Integration_Event_Log__c);
            }
            List<Integration_Error_Log__c> intErrorsList;
            Map<Id,List<Integration_Error_Log__c>> intErrorsLogMap = new Map<Id,List<Integration_Error_Log__c>>() ;
            if(Schema.sObjectType.Integration_Error_Log__c.isAccessible() && (!relatedIntEventIDLst.isEmpty())){
                for(Integration_Error_Log__c intError :[Select Id,Status__c,Integration_Event_Log__c,
                                                        Category__c,Elapsed_Time__c,
                                                        Resolution_Time__c 
                                                        FROM Integration_Error_Log__c 
                                                        where Integration_Event_Log__c IN: relatedIntEventIDLst lIMIT 50000 ]){
                                                            if(intErrorsLogMap.containsKey(intError.Integration_Event_Log__c)){
                                                                intErrorsLogMap.get(intError.Integration_Event_Log__c).add(intError);
                                                            }else{
                                                                //List<Integration_Error_Log__c> intErrorsList = new List<Integration_Error_Log__c>();
                                                                intErrorsList = new List<Integration_Error_Log__c>();
                                                                intErrorsList.add(intError);
                                                                intErrorsLogMap.put(intError.Integration_Event_Log__c, intErrorsList);
                                                            }
                                                        }
            }
            
            Integration_Event_Log__c newIntEvent;
            if(!relatedIntEventIDLst.IsEmpty()){
                for(String intevent : relatedIntEventIDLst){
                    if(!intErrorsLogMap.get(intevent).isEmpty()){
                        Integer technicalErrorRecCount = 0;
                        Integer functionalErrorRecCount = 0;
                        Integer totalRecCount = 0;
                        Integer closedRecordCount = 0;
                        Decimal totalTechnicalErrResolutionTime = 0;
                        Decimal totalFunctionalErrResolutionTime = 0;
                        Decimal totalElapsedTime = 0;
                        Decimal totalErrorClosedResolutionTime = 0;
                        
                        for(Integration_Error_Log__c intError : intErrorsLogMap.get(intevent)){
                            if(intError.Status__c == LGA_Constants.CLOSED && intError.Category__c.Contains(LGA_Constants.TECHNICAL_ERROR)){
                                technicalErrorRecCount ++ ;
                                totalTechnicalErrResolutionTime = totalTechnicalErrResolutionTime+ intError.Resolution_Time__c;
                                
                            }else if(intError.Status__c == LGA_Constants.CLOSED && intError.Category__c.Contains(LGA_Constants.FUNCTIONAL_ERROR)){
                                functionalErrorRecCount ++ ;
                                totalFunctionalErrResolutionTime = totalFunctionalErrResolutionTime+ intError.Resolution_Time__c;
                                
                            }
                            if(intError.Status__c == LGA_Constants.CLOSED){
                                closedRecordCount ++ ;
                                totalErrorClosedResolutionTime = totalErrorClosedResolutionTime + intError.Resolution_Time__c ;
                                
                            }
                            totalRecCount ++;
                            totalElapsedTime = totalElapsedTime + intError.Elapsed_Time__c;
                        } 
                        
                        
                        //Integration_Event_Log__c newIntEvent = new Integration_Event_Log__c() ;
                        newIntEvent = new Integration_Event_Log__c() ;
                        newIntEvent.Id = intevent;
                        newIntEvent.Average_Elapsed_Time__c = (totalElapsedTime/totalRecCount); 
                        
                        if(closedRecordCount != 0){
                            newIntEvent.Total_Resolution_Time__c = (totalErrorClosedResolutionTime/closedRecordCount); 
                        }else{
                            newIntEvent.Total_Resolution_Time__c = 0; 
                        }
                        
                        if(functionalErrorRecCount != 0){
                            newIntEvent.Average_Resolution_Time_Functional_Error__c = (totalFunctionalErrResolutionTime/functionalErrorRecCount);
                        }else{
                            newIntEvent.Average_Resolution_Time_Functional_Error__c = 0; 
                        }
                        
                        if(technicalErrorRecCount != 0){
                            newIntEvent.Average_Resolution_Time_Technical_Errors__c = (totalTechnicalErrResolutionTime/technicalErrorRecCount);
                        }else{
                            newIntEvent.Average_Resolution_Time_Technical_Errors__c = 0; 
                        }
                        
                        intEventsUpdateLst.add(newIntEvent);
                    }
                }
            }
            
            if(!intEventsUpdateLst.IsEmpty()){
                database.Update(intEventsUpdateLst,false);
            }
            
        } catch (Exception ex) {
            system.debug('****The following exception has occurred: ' + ex.getMessage());
        }
        //String prossedEventId ;
        
    }
    
}