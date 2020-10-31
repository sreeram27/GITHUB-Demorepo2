/*******************************************************************************************
@class Name  : LGA_RequiredDcList
@created By  : IDC Offshore
@createdDate : 8/01/2019
@description : In this class get the all required documents to upload
********************************************************************************************/
global with sharing class LGA_RequiredDcList implements vlocity_ins.VlocityOpenInterface2 {
    
    List<string> selectedItems = new List<string>();
    
    /*******************************************************************************************
@method Name  : invokeMethod
@description : Get the data from Omni Script 
@return : Boolean
@param : methodName,inputMap,outMap,optns
********************************************************************************************/
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String,Object > outMap, Map < String, Object > optns) {
        String callingmethod = (String)optns.get(LGA_Constants.REMOTE_VALUE) ;
        List<String> dcFilestobeDeleted = new List<String>();

        if(LGA_Constants.GET_VALIDATION_ERROR.equalsIgnoreCase(methodName) && callingmethod.equalsIgnoreCase(LGA_Constants.SUBMIT_IPC))
        {
            
            
            getValidationError(inputMap, outMap, optns);
         }

        return true;
    }
    
    /*******************************************************************************************
@method Name  : getValidationError
@description : This is test method for LGA_CreateDocumentChecklist
@param : inputMap,outMap,optns
********************************************************************************************/
    global void getValidationError(Map < String, Object > input, Map < String, Object > outMap, Map < String, Object > optns) {
        String iMPcaseId = (String) optns.get(LGA_Constants.IMPCASEID);
        String errorMessage = 'Please upload all required documentation to proceed.';
                
        List<Id> requiredDCIdlist = new  List<Id>();
        Map<id,list<ContentDocumentLink>> condoclin = new Map<id,list<ContentDocumentLink>>();
        Boolean requiredcheck = false;
        for(Application_Document_Checklist__c dc: [SELECT Id FROM Application_Document_Checklist__c 
                                                   where Implementation_Case__c =: iMPcaseId and Required__c = true 
                                                   AND status__c =: LGA_Constants.EMPTY_STRING limit 50000]){
                                                       system.debug('######dc'+dc);
                                                       requiredDCIdlist.add(dc.Id);
                                                   } 
          try{
            
            if(!requiredDCIdlist.isempty()) {
                outMap.put(LGA_Constants.ERROR, errorMessage);
            }
        } Catch(Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
        
    }
 
/*******************************************************************************************
@method Name  : deleteDCFiles
@description : This method Deletes Doc checklist files.
@param : docID
********************************************************************************************/ 
    @RemoteAction
    global static void deleteDCFiles(string docID) {
        List<Id> filesToBeDeleted = new List<Id>();
        List<Application_Document_Checklist__c> dcToUpdate = new List<Application_Document_Checklist__c>();
        Application_Document_Checklist__c dc;
        for (ContentDocumentLink cdlink : [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink 
                                           where LinkedEntityId =: docID Limit 50000 ]) {
                                               filesToBeDeleted.add(cdlink.ContentDocumentId);
                                           }
        for(Application_Document_Checklist__c dcChecklist : [SELECT Id, Status__c FROM Application_Document_Checklist__c 
                                                             WHERE Id =: docID AND Status__c =: LGA_Constants.DC_STATUS_SELF_INPUT Limit 50000] ){
                                                                 //Application_Document_Checklist__c dc = new Application_Document_Checklist__c();
                                                                 dc = new Application_Document_Checklist__c();
                                                                 dc.Id = dcChecklist.id;
                                                                 dc.Status__c = LGA_Constants.EMPTY_STRING;
                                                                 dcToUpdate.add(dc);
                                                             }
        
        if (!dcToUpdate.isEmpty()) {
            //outputMap.put(LGA_Constants.OUTPUT_DCLIST,LGA_Constants.EMPTY_STRING);
            Database.Update(dcToUpdate,false);
        }
        
        if (!filesToBeDeleted.isEmpty()) {
            //outputMap.put(LGA_Constants.OUTPUT_DCLIST,LGA_Constants.EMPTY_STRING);
            Database.delete(filesToBeDeleted,false);
        }   
        
    }
    
}