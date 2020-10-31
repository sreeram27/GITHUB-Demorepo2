/***********************************************************************
@class Name   : LGA_CreateDocumentChecklist
@date Created : 08/01/2019 (MM/DD/YYYY)
@created By   : Accenture Offshore
@description  : This class is used called from OrderAfterUpdate Trigger
@change History : 08/27/2019 (As a Part of PRDCRM-41239, PRDCRM-40178, PRDCRM-41195, PRDCRM-41197, PRDCRM-40609, PRDCRM-41841 & PRDCRM-40610 )
**************************************************************************/
public with sharing class LGA_CreateDocumentChecklist {
    
    /****************************************************************************************************
@method Name : createDocumentsforImplCase
@description : This method checks the criteria and creates the required Document Checklist for the  Implementation Case.
@param: This method accepts List of Orders as parameter.
******************************************************************************************************/
    public static void createDocumentsforImplCase(List<Order> newOrderLst){
        
        List<Application_Document_Checklist__c> docCheckLst = new List<Application_Document_Checklist__c>();
        List<Application_Document_Checklist__c> docCheckLstFinal = new List<Application_Document_Checklist__c>();
        List<Application_Document_Config__c> docConfigLst = new List<Application_Document_Config__c>();
        Map<String,Application_Document_Checklist__c> dcToInsert = New Map<String,Application_Document_Checklist__c>();
        //List<String> dcNameExtensionList =  new List<String>();
        LGA_CreateDCChecks dcChecks = new LGA_CreateDCChecks();
        LGA_CreateDocChecklistHelper helper = new LGA_CreateDocChecklistHelper();
        Boolean checkLOB = LGA_Constants.CHECKLOB ;
        Integer noOfDC ; 
        try{
            if (Schema.sObjectType.Application_Document_Config__c.isAccessible() ){
                docConfigLst = [Select Id,Profiles__c,Implementation_Type__c,Product_Family__c,Underwriter__c,
                                Files_Parameter__c,Line_Of_Business__c,State__c,Name,
                                Document_Name__c,ERISA_Qualified__c,Product_Category__c,
                                Additional_Checks__c,Funding__c,
                                Required__c,Pooled_Non_Pooled__c,CEP_Indicator__c,
                                Product_Name__c,Financing__c,
                                Product_Stage__c,
                                Employee_Assistance_Program__c
                                From Application_Document_Config__c 
                                WHERE Inactive__c=:LGA_Constants.FALSEVALUE 
                                Limit 50000];
            }
            List<Id> impQuoteIdList = new List<Id>();
            for(Order ord: newOrderLst){
                impQuoteIdList.add(ord.QuoteId);
            }
            Map<Id,List<QuoteLineItem>> qliMap = new Map<Id,List<QuoteLineItem>>(); 
            List<QuoteLineItem> qliList2;           
            if(!impQuoteIdList.isEmpty() && Schema.sObjectType.QuoteLineItem.isAccessible()){
                for(QuoteLineItem qli : [Select Id, QuoteId,ProductLOB__c,
                                         ProductStage__c,ProductCategory__c,
                                         Funding__c,Product2.Name,
                                         Product2.Product_Type__c,Product2.Contract_Code__c,
                                         Product2.Product_Family__c,CEP_Indicator__c, 
                                         Contract_Codes__c,Financing__c from QuoteLineItem 
                                         where QuoteId IN : impQuoteIdList Limit 50000]){
                                             if(qliMap.containskey(qli.QuoteId)){
                                                 qliMap.get(qli.QuoteId).add(qli);
                                             }else{
                                                 //List<QuoteLineItem> qliList2 = new List<QuoteLineItem>();
                                                 qliList2 = new List<QuoteLineItem>();
                                                 qliList2.add(qli);
                                                 qliMap.put(qli.QuoteId , qliList2);
                                             }
                                         }
            }
            List<String> dcNameExtensionList;
            for(Order ord:[Select Id,Implementation_Type__c,QuoteId,
                           Quote.Employee_Assistance_Program__c,
                           Quote.JAAIndicator__c, Quote.Is_JAA__c,
                           AccountId,Account.Situs_State__c, 
                           Account.Is_this_Group_subject_to_ERISA__c,
                           Account.Pooled_Non_Pooled__c from Order 
                           where Id IN:newOrderLst Limit 50000]){
                               if(!docConfigLst.isEmpty() && !qliMap.get(ord.QuoteId).isEmpty() ){
                                   for(Application_Document_Config__c docConfig: docConfigLst){
                                       //List<String> dcNameExtensionList =  new List<String>();
                                       dcNameExtensionList =  new List<String>();
                                       if(docConfig.Line_Of_Business__c == Null){
                                           Boolean checkLOBbyPass = True;
                                           noOfDC = dcChecks.checkNoOfDC(docConfig,checkLOBbyPass,qliMap.get(ord.QuoteId));
                                       }else if(docConfig.Line_Of_Business__c != Null){
                                           checkLOB = dcChecks.checkLOB(docConfig,qliMap.get(ord.QuoteId));
                                           noOfDC = dcChecks.checkNoOfDC(docConfig,checkLOB,qliMap.get(ord.QuoteId));
                                       }
                                       //}
                                       /*system.debug('@@@@@@@checkLOB' + checkLOB);
                                       system.debug('@@@@@@@ Criteria for all Objs' + ( docConfig.Line_Of_Business__c == Null));
                                       system.debug('@@@@@@@ Criteria for all Objs' + ( docConfig.ERISA_Qualified__c == Null ));
                                       system.debug('@@@@@@@ Criteria for all Objs' + ( docConfig.Product_Category__c == Null));
                                       system.debug('@@@@@@@ Criteria for all Objs' + ( docConfig.Product_Stage__c == Null));
                                       system.debug('@@@@@@@ Criteria for all Objs' + ( !checkLOB ));
                                       system.debug('@@@@@@@ Criteria for all Objs' + ( docConfig.Line_Of_Business__c == Null && !checkLOB 
                                                                                       && docConfig.ERISA_Qualified__c == Null 
                                                                                       && docConfig.Product_Category__c == Null 
                                                                                       && docConfig.Product_Stage__c == Null
                                                                                       && (noOfDC > 0) )); */
                                       //Checking the conditions (State AND Profile)
                                       if(String.isNotBlank(docConfig.State__c)){
                                           if(docConfig.State__c.contains(ord.Account.Situs_State__c)){
                                               //Checking the conditions Implementation Type for 'New Business' & has LOB
                                               if( String.isNotBlank(docConfig.Implementation_Type__c) 
                                                  && docConfig.Implementation_Type__c.CONTAINS(ord.Implementation_Type__c) ){
                                                      system.debug('@@@@@@@ Criteria for all Objs' + docConfig.Implementation_Type__c );
                                                      if(!docConfig.Additional_Checks__c && String.isNotBlank(docConfig.Line_Of_Business__c)){   
                                                          //Checking the conditions LOB dcNameExtensionList
                                                          if (docConfig.Files_Parameter__c == LGA_Constants.QLI || docConfig.Files_Parameter__c == LGA_Constants.LOB){
                                                              dcNameExtensionList = dcChecks.dcNameExtension(docConfig,qliMap.get(ord.QuoteId),ord);
                                                          }
                                                          dcToInsert.putAll(helper.createDC(docConfig,ord,checkLOB,noOfDC,dcNameExtensionList));
                                                          
                                                      }
                                                      //Creating DC for all config with no LOB, No Product Stage & No Product Category
                                                      
                                                      else if ( String.isBlank(docConfig.Line_Of_Business__c) 
                                                               && !docConfig.Additional_Checks__c
                                                               && String.isBlank(docConfig.Product_Category__c) 
                                                               && String.isBlank(docConfig.Product_Stage__c)
                                                               && (noOfDC > 0) ){
                                                                   // code for other Implementation_Type__c for other values
                                                                   Boolean createAll = true;
                                                                   if (docConfig.Files_Parameter__c == LGA_Constants.QLI || docConfig.Files_Parameter__c == LGA_Constants.LOB){
                                                                       dcNameExtensionList = dcChecks.dcNameExtension(docConfig,qliMap.get(ord.QuoteId),ord);
                                                                   }
                                                                   dcToInsert.putAll(helper.createDC(docConfig,ord,createAll,noOfDC,dcNameExtensionList));
                                                                   
                                                               }
                                                      //Creating DC for all config with no LOB But has  Product Stage &  Product Category
                                                      else if ( String.isBlank(docConfig.Line_Of_Business__c) 
                                                               && !docConfig.Additional_Checks__c 
                                                               && String.isNotBlank(docConfig.Product_Category__c) 
                                                               && String.isNotBlank(docConfig.Product_Stage__c)
                                                               && (noOfDC > 0) ){
                                                                   // code for other Implementation_Type__c for other values
                                                                   Boolean createAll = false;
                                                                   for(QuoteLineItem qli: qliMap.get(ord.QuoteId)){
                                                                       if(qli.ProductCategory__c == docConfig.Product_Category__c 
                                                                          && qli.ProductStage__c == docConfig.Product_Stage__c) {
                                                                              createAll = true;
                                                                          }
                                                                   }
                                                                   if (docConfig.Files_Parameter__c == LGA_Constants.QLI || docConfig.Files_Parameter__c == LGA_Constants.LOB){
                                                                       dcNameExtensionList = dcChecks.dcNameExtension(docConfig,qliMap.get(ord.QuoteId),ord);
                                                                   }
                                                                   dcToInsert.putAll(helper.createDC(docConfig,ord,createAll,noOfDC,dcNameExtensionList));
                                                               }
                                                      
                                                      //Creating for Other Criteria with LOB Null
                                                      else if (String.isBlank(docConfig.Line_Of_Business__c)
                                                               && docConfig.Additional_Checks__c
                                                               && String.isNotBlank(docConfig.Product_Category__c)
                                                               && String.isNotBlank(docConfig.Product_Stage__c)
                                                               && (noOfDC > 0) ){
                                                                   Boolean createAll = dcChecks.additionalChecks(docConfig,qliMap.get(ord.QuoteId),ord);                                                                      
                                                                   
                                                                   
                                                                   if (docConfig.Files_Parameter__c == LGA_Constants.QLI || docConfig.Files_Parameter__c == LGA_Constants.LOB){
                                                                       dcNameExtensionList = dcChecks.dcNameExtension(docConfig,qliMap.get(ord.QuoteId),ord);
                                                                   }
                                                                   dcToInsert.putAll(helper.createDC(docConfig,ord,createAll,noOfDC,dcNameExtensionList));
                                                                   
                                                               }
                                                      //Creating for Other Criteria With LOB Not Null
                                                      else if (String.isNotBlank(docConfig.Line_Of_Business__c)
                                                               && docConfig.Additional_Checks__c
                                                               && String.isNotBlank(docConfig.Product_Category__c) 
                                                               && String.isNotBlank(docConfig.Product_Stage__c)
                                                               && (noOfDC > 0) ){
                                                                   Boolean createAll = dcChecks.additionalChecks(docConfig,qliMap.get(ord.QuoteId),ord);                                                                      
                                                                                                                              
                                                                   if (docConfig.Files_Parameter__c == LGA_Constants.QLI || docConfig.Files_Parameter__c == LGA_Constants.LOB){
                                                                       dcNameExtensionList = dcChecks.dcNameExtension(docConfig,qliMap.get(ord.QuoteId),ord);
                                                                   }
                                                                   dcToInsert.putAll(helper.createDC(docConfig,ord,createAll,noOfDC,dcNameExtensionList));
                                                                   
                                                               }
                                                      else {
                                                          system.debug('@@@@@@Inside Else docConfig Details' + docConfig.Document_Name__c );
                                                      }
                                                  }
                                           }
                                       }
                                       
                                   }
                               }
                           }
            
            for(Application_Document_Checklist__c dc: dcToInsert.values()){
                docCheckLst.add(dc);
            }
            if (!docCheckLst.isempty()){
                Database.SaveResult[] srList = Database.insert(docCheckLst, false) ;
            }
        }
        Catch(Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
    }
}