/***********************************************************************
@class Name   : LGA_CreateDocChecklistHelper
@date Created : 08/19/2019 (MM/DD/YYYY)
@created By   : Accenture Offshore
@description  : This class is used called from LGA_CreateDocumentChecklist
@change History : 08/27/2019 (As a Part of PRDCRM-41239, PRDCRM-40178, PRDCRM-41195, PRDCRM-41197, PRDCRM-40609, PRDCRM-41841 & PRDCRM-40610 )
**************************************************************************/
public with sharing class LGA_CreateDocChecklistHelper {
    
    /****************************************************************************************************
@method Name : createDocumentsforImplCase
@description : This method returns the DocumentChecklist List that has to be created.
@return : This method returns a list of Application_Document_Checklist__c
@param : This methods accepts Application_Document_Config__c, Order, Boolean & Integer as parameters
******************************************************************************************************/
    public Map<String,Application_Document_Checklist__c>  createDC(Application_Document_Config__c docConfig, Order implCase,Boolean checkLOB, Integer noOfDC, List<String> dcNameExtensionList){
        //Creating the required Document CheckList
        String docName;
        List<Application_Document_Checklist__c> docCheckLst = new List<Application_Document_Checklist__c>();
        Map<String,Application_Document_Checklist__c> dcToInsert = New Map<String,Application_Document_Checklist__c>();
        Try{
            
            //Application_Document_Checklist__c newDocCheck = new Application_Document_Checklist__c();
            //if(docConfig.Line_Of_Business__c != Null && checkLOB){
            system.debug('@@@@@noOfDC' + noOfDC);
            system.debug('dcNameExtensionList'+dcNameExtensionList);
            system.debug('dcNameExtensionList'+dcNameExtensionList.size());
            if(checkLOB && !dcNameExtensionList.isEmpty()){
                for(Integer i = 1; i <= noOfDC ;i++){
                    Application_Document_Checklist__c newDocCheck = new Application_Document_Checklist__c();
                    newDocCheck.Implementation_Case__c = implCase.Id;
                    system.debug('@@implCase.Id'+implCase.Id);
                    String documentName = docConfig.Document_Name__c + LGA_Constants.HYPHEN + dcNameExtensionList[(i-1)];
                    system.debug('@@@@documentName'+ documentName);
                    if(documentName.length() > 255){
                        docName = documentName.substring(0,255); //substring(0,255)
                        system.debug('@@@@documentName'+ docName);
                        newDocCheck.Document_Name__c = docName;
                    }
                    else{
                        newDocCheck.Document_Name__c = documentName;
                    }
                    
                    
                    newDocCheck.Application_Document_Config__c = docConfig.Id;
                    //newDocCheck.Document_Order__c = i;
                    if(docConfig.Required__c){
                        newDocCheck.Required__c = True;
                    } Else {
                        newDocCheck.Required__c = False;
                    }
                    if(docConfig.Underwriter__c){
                        newDocCheck.Underwriter__c = True;
                    } Else {
                        newDocCheck.Underwriter__c = False;
                    }
                    system.debug('@@newDocCheck'+newDocCheck);
                    docCheckLst.add(newDocCheck);
                    dcToInsert.put(newDocCheck.Document_Name__c , newDocCheck );
                } 
                system.debug('@@docCheckLst'+docCheckLst);
            }
            else if(checkLOB && dcNameExtensionList.isEmpty()){
                for(Integer i = 1; i <= noOfDC ;i++){
                    Application_Document_Checklist__c newDocCheck = new Application_Document_Checklist__c();
                    newDocCheck.Implementation_Case__c = implCase.Id;
                    system.debug('@@implCase.Id'+implCase.Id);
                    newDocCheck.Document_Name__c = docConfig.Document_Name__c;
                    newDocCheck.Application_Document_Config__c = docConfig.Id;
                    //newDocCheck.Document_Order__c = i;
                    if(docConfig.Required__c){
                        newDocCheck.Required__c = True;
                    } Else {
                        newDocCheck.Required__c = False;
                    }
                    if(docConfig.Underwriter__c){
                        newDocCheck.Underwriter__c = True;
                    } Else {
                        newDocCheck.Underwriter__c = False;
                    }
                    system.debug('@@newDocCheck'+newDocCheck);
                    docCheckLst.add(newDocCheck);
                    dcToInsert.put(newDocCheck.Document_Name__c , newDocCheck );
                } 
                system.debug('@@docCheckLst'+docCheckLst);
            }
        }
        Catch(Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
        return dcToInsert;
    }
    
}