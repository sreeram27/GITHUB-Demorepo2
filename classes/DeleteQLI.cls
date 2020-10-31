/*
_________________________________________________________________________________________

@author         Deloitte offshore
@date           23/03/2018
@name           DeleteQLI
@description    Used in vlocity omniscript to Generate Group Number for Group record.
_________________________________________________________________________________________
*/
global without sharing class DeleteQLI implements vlocity_ins.VlocityOpenInterface2
{
   /*
    _________________________________________________________________________________________
    
    *@description  Implementation of invokeMEthod from VlocityOpenInterface2 interface.
    *@param methodName - hold the name of specified method - String
    *@param inputMap - Whole JSON from Omniscript - Map<String,Object>
    *@param outMap - Whole JSON to Omniscript - Map<String,Object>
    *@param optns - Optional parameter - Map<String,Object>
    *@return true Boolean
    _________________________________________________________________________________________
    
    */
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> optns) {
        
        String sGetQLI = staticVariableClass.DeleteQliGETQLI;
        String sGetQLIPlans = staticVariableClass.DeleteQliGETQLIPlans;
        String sClassName = DeleteQLI.class.getName();
        String sGetQLIMethod = staticVariableClass.DeleteQliGETQLI;
    
        if(sGetQLI.equalsIgnoreCase(methodName)) {
            
            //This method will be called when Generate Group # button is clicked
            getQLI(inputMap, outMap);
            
        } else if(sGetQLIPlans.equalsIgnoreCase(methodName)) {
            
            //This method will be called when Generate Group # button is clicked
            getQLIPlans(inputMap, outMap);   
        }
        
        return true;
    }
    /*
    _________________________________________________________________________________________
    
    *@description Implementation of getQLI method.
    *@param inputMap - Whole JSON from Omniscript - Map<String,Object>
    *@param outMap - Whole JSON to Omniscript - Map<String,Object>
    _________________________________________________________________________________________
    
    */
    global void getQLI(Map<String, Object> inputMap, Map<String,Object> outMap) {
        
        String sSplitRecordSelection = staticVariableClass.DeleteQliSPLITRECORDSELECTION;
        String sQLIProdList = staticVariableClass.DeleteQliQLIPRODLIST;
        String sQLIId = staticVariableClass.DeleteQliQLIID;
        String sClassName = DeleteQLI.class.getName();
        String sGetQLIMethod = staticVariableClass.DeleteQliGETQLI;
        
        try {
            
            Set<Id> qliSet = new Set<Id>();
            Id quoteId = (Id)inputMap.get(staticVariableClass.CreateGrpQUOTEID);
            Map<String, Object> qliList = (Map<String, Object>) inputMap.get(sSplitRecordSelection);
            List<Object> qliIdList = (List<Object>) qliList.get(sQLIProdList);
            
            if(qliIdList != null) {
                //Iterating accross all the JSON and getting the Quote Line Item Ids
                for(Object obj : qliIdList) {
                    Map<String, Object> qliMap = (Map<String, Object>) obj;
                    qliSet.add((Id)qliMap.get(sQLIId));
                }
            }
            
            User currentUser = [select Id,AllowQLIDelete__c from User where Id =:userinfo.getuserid() limit 1];
            
            if(!currentUser.AllowQLIDelete__c) {
                
                currentUser.AllowQLIDelete__c= true;
                update currentUser;
                
                //Calling below method with quoteId and quote line Item Id set as parameters
                createQuoteLineItems(quoteId, qliSet, outMap);
                
                currentUser.AllowQLIDelete__c = false;
                update currentUser;
                
            } 
            else {
                //Calling below method with quoteId and quote line Item Id set as parameters
                createQuoteLineItems(quoteId, qliSet, outMap);
            }
        }
        catch(Exception excn){
            UTIL_LoggingService.logHandledException(excn, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME,
            sClassName, sGetQLIMethod, null, LoggingLevel.ERROR);
        }
    }
    
    /*
    _________________________________________________________________________________________
     
    User Story : 43206
    Date: 11/09/2019
    _________________________________________________________________________________________
    
    *@description To create new Quote, Quote Line Item and delete old QLI records
    *@param qliId - hold the Quote ID - Id
    *@param outMap - Whole JSON to Omniscript - Map<String,Object>
    *@param qliSet - hold the Quote Line Item Set - Set<ID>
    _________________________________________________________________________________________
    */
    
    private void createQuoteLineItems(Id qliId, Set<Id> qliSet, Map<String,Object> outMap) {
        
        Map<Id, Id> qliMap = new Map<Id, Id>();
        List<QuoteLineItem> deleteList = new List<QuoteLineItem>();
        List<QuoteLineItem> parentQuoteLineItemList = new List<QuoteLineItem>();
        List<QuoteLineItem> childQuoteLineItemList = new List<QuoteLineItem>();
        Set<String> quoteFieldNames = Quote.sObjectType.getDescribe().fields.getMap().keySet();
        Set<String> qliFieldNames = QuoteLineItem.sObjectType.getDescribe().fields.getMap().keySet();
        
        //Quering for the record ans storing in a Quote Instance
        Quote quoteInstance = Database.query('select ' + string.join((Iterable<String>)quoteFieldNames, ',') + ' from Quote where Id =: qliId limit 1');
        
        //Cloning the above queried Quote Instance
        Quote newQuoteInstance= quoteInstance.clone(false);
        newQuoteInstance.GroupNumber__c = null;
        
        //Inserting the Quote Instance
        insert newQuoteInstance;
           
        //Dynamically getting all the fields from quote line Item
        String qliSOQL = 'select ' + string.join((Iterable<String>)qliFieldNames, ',') + ' from QuoteLineItem ';
        
        //Adding where condition here to query all the products with qliSet (parameter input from the method)
        String parentQliSOQL = qliSOQL+ ' where Id IN : qliSet';
        
        //Iterating across the query and cloning the parent record and associating with new quote inserted
        for(QuoteLineItem qli: Database.query(parentQliSOQL)) {
            
            QuoteLineItem cloneQli = qli.clone(false);
            //New Quote Association
            cloneQli.QuoteId = newQuoteInstance.Id;
            cloneQli.AutorabitExtId__c = qli.Id; 
            parentQuoteLineItemList.add(cloneQli);
            //Adding the current quote to the delete list
            deleteList.add(qli);
        }
        
        if(!parentQuoteLineItemList.isEmpty()) {
            
            // INserting the parent quote line item
            insert parentQuoteLineItemList;
            
            //Iterating across the new list and creating a map <Old ID, New ID> for maintaining hierachy across the child quote line item
            for(QuoteLineItem qli: parentQuoteLineItemList) {
                qliMap.put(qli.AutorabitExtId__c, qli.Id);
            }
            
            //Adding where condition to query all the plans/programs with qliSet (parameter input from the method)
            String childQliSOQL = qliSOQL+ ' where ParentQuoteLineItem__c IN : qliSet';
            
            //Child quote line item record and associating with new quote inserted and new parent qli inserted
            for(QuoteLineItem qli : Database.query(childQliSOQL)) {
                
                QuoteLineItem cloneQli = qli.clone(false);
                cloneQli.Id = null;
                cloneQli.ParentQuoteLineItem__c = qliMap.get(cloneQli.ParentQuoteLineItem__c);
                cloneQli.QuoteId = newQuoteInstance.Id;
                childQuoteLineItemList.add(cloneQli);
                deleteList.add(qli);
            }
            
            // Inserting the child quote line item
            if(!childQuoteLineItemList.isEmpty()) {
                insert childQuoteLineItemList;
            }
        }
        
        // deleting the existing quote line item
        if(!deleteList.isEmpty()) {
            delete deleteList;
        }
        
        outMap.put(staticVariableClass.QUOTE_ID, newQuoteInstance.Id);
    }
    
    /*
    Date : 26/07/2019
    _________________________________________________________________________________________
    
    *@description Implementation of getQLIPlans method to delete QLI records for H&W flow
    *@param inputMap - Whole JSON from Omniscript - Map<String,Object>
    *@param outMap - Whole JSON to Omniscript - Map<String,Object>
    _________________________________________________________________________________________
    
    */
    global void getQLIPlans(Map<String, Object> inputMap, Map<String,Object> outMap) {
        
        String sClassName = DeleteQLI.class.getName();
        String sGetQLIMethod = staticVariableClass.DeleteQliGETQLI;
        
        try {
            
            // Getting the context ID from the Omniscript
            Id qliId = (Id)inputMap.get(staticVariableClass.CreateGrpQUOTEID);
            List<QuoteLineItem> updateQLIIdList = new List<QuoteLineItem>();
            
            //Iterating across the query and cloning the parent record and associating with new quote inserted
            for(QuoteLineItem qli : [SELECT Id, ProductStage__c, OppType__c, ParentQuoteLineItem__c,
                                    (select ID, OppType__c, ProductStage__c from Quote_Line_Items__r) 
                                    FROM QuoteLineItem 
                                    where ParentQuoteLineItem__c =: qliId]) {
                
                updateQLIIdList .add(qli);
                
                //Checking for plans and addig it to the list
                if(!qli.Quote_Line_Items__r.isEmpty()) {
                    updateQLIIdList.addAll(qli.Quote_Line_Items__r);
                }
            }
            
            // deleting the existing quote line item
            if(!updateQLIIdList.isEmpty()) {
                delete updateQLIIdList;
            }
            
            // Updating the Package Attached flag to true for the plan quote line item
               update new QuoteLineItem (Id = qliId, Package_has_been_attached__c= staticVariableClass.UpsellYes);
        }
        catch(Exception excn){
            UTIL_LoggingService.logHandledException(excn, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME,
            sClassName, sGetQLIMethod, null, LoggingLevel.ERROR);
        }
    }
}