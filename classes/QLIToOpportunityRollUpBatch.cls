/*
* Purpose: Rolls up field values to respective Opportunity records
* Version: 1.0
* 
* JIRA NUMBER    DATE           DEVELOPER    DESCRIPTION 
* ===========    ===========    =========    =======================================================
*PRDCRM-33940    06-June-2019    Sharath KN   Created batch class
*History 
1) PRDCRM-37695 : Adding logic to rollup members and subscribers from QLI to Opportunity : Ravideep(Vikings)
2) PRDCRM-40695 : Adding logic to rollup members and subscribers from Medical only QLI's to Opportunity : Ravideep(Vikings)
3) PRDCRM-44200 : Added filter criteria for the changes made as part of PRDCRM-40695 : Sharath KN(Vikings)
*/

global class QLIToOpportunityRollUpBatch implements Database.Batchable<sObject>{
    String headerStr = 'Opportunity Id,Error \n';
    global String oppStr = headerStr;
    global Boolean isError = false;
    global String Query = 'SELECT Id, OpportunityId__c FROM QuoteLineItem WHERE lastmodifieddate >: lastRun OR Product2.lastmodifieddate >: lastRun ORDER By OpportunityId__c ASC nulls last ALL RoWS';
    global AccountRoles__c roles = AccountRoles__c.getValues('OppReport');//Custom setting that stores the batch last run datetime
    DateTime lastRun = roles.LastRun__c; // Holds the date when this batch was run last time
    DateTime jobStartTime = DateTime.now();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<QuoteLineItem> QLIList){
        Set<Id> oppIds = new Set<Id>(); // Set that holds unique opportunity IDs
        
        //generate list of unique Opportunity IDs
        for(QuoteLineItem thisQLI : QLIList){
            if(thisQLI.OpportunityId__c != null)
                oppIds.add(thisQLI.OpportunityId__c);
        }
        Set<Id> finalOppIds = new Set<Id>();
        Set<Id> nonDeletedQLIOppIds = new Set<Id>(); // stores OppIds for which atleast one QLI exists
        Map<String,Set<String>> masterFieldMap = new Map<String,Set<String>>();
        Map<String,decimal> masterNumberFieldMap = new Map<String,decimal>();
        for(QuoteLineItem thisQLI : [SELECT Id, Funding__c, Financing__c, OpportunityId__c,quote.opportunity.IsDeleted, ProductLOB__c, Product_Family_Local__c, ProductStage__c, Competitor__c, Competitor__r.Name, Competitor2__c, Competitor2__r.Name, Competitor3__c, Competitor3__r.Name,Subscribers__c,Members__c,ProductCategory__c FROM QuoteLineItem WHERE quote.opportunity.Id IN: oppIds]){
            nonDeletedQLIOppIds.add(thisQLI.OpportunityId__c);
            if(thisQLI.quote.opportunity.IsDeleted == false){
                finalOppIds.add(thisQLI.OpportunityId__c);
                if (!masterFieldMap.containsKey(thisQLI.OpportunityId__c + 'Funding__c')) {
                    masterFieldMap.put(thisQLI.OpportunityId__c + 'Funding__c', new Set<String>());
                    if(!String.isBlank(thisQLI.Funding__c))
                        masterFieldMap.get(thisQLI.OpportunityId__c + 'Funding__c').add(thisQLI.Funding__c);
                }
                else {
                    if(!String.isBlank(thisQLI.Funding__c))
                        masterFieldMap.get(thisQLI.OpportunityId__c + 'Funding__c').add(thisQLI.Funding__c);
                }
                if (!masterFieldMap.containsKey(thisQLI.OpportunityId__c + 'Financing_Rollup__c')) {
                    masterFieldMap.put(thisQLI.OpportunityId__c + 'Financing_Rollup__c', new Set<String>());
                    if(!String.isBlank(thisQLI.Financing__c))
                        masterFieldMap.get(thisQLI.OpportunityId__c + 'Financing_Rollup__c').add(thisQLI.Financing__c);
                }
                else {
                    if(!String.isBlank(thisQLI.Financing__c))
                        masterFieldMap.get(thisQLI.OpportunityId__c + 'Financing_Rollup__c').add(thisQLI.Financing__c);
                }
                if (!masterFieldMap.containsKey(thisQLI.OpportunityId__c + 'Product_Families__c')) {
                    masterFieldMap.put(thisQLI.OpportunityId__c + 'Product_Families__c', new Set<String>());
                    if(!String.isBlank(thisQLI.Product_Family_Local__c))
                        masterFieldMap.get(thisQLI.OpportunityId__c + 'Product_Families__c').add(thisQLI.Product_Family_Local__c);
                }
                else {
                    if(!String.isBlank(thisQLI.Product_Family_Local__c))
                        masterFieldMap.get(thisQLI.OpportunityId__c + 'Product_Families__c').add(thisQLI.Product_Family_Local__c);
                }
                if (!masterFieldMap.containsKey(thisQLI.OpportunityId__c + 'Lines_of_Business__c')) {
                    masterFieldMap.put(thisQLI.OpportunityId__c + 'Lines_of_Business__c', new Set<String>());
                    if(!String.isBlank(thisQLI.ProductLOB__c))
                        masterFieldMap.get(thisQLI.OpportunityId__c + 'Lines_of_Business__c').add(thisQLI.ProductLOB__c);
                }
                else {
                    if(!String.isBlank(thisQLI.ProductLOB__c))
                        masterFieldMap.get(thisQLI.OpportunityId__c + 'Lines_of_Business__c').add(thisQLI.ProductLOB__c);
                }
                if (!masterFieldMap.containsKey(thisQLI.OpportunityId__c + 'Sold_Lines_of_Business__c')) {
                    masterFieldMap.put(thisQLI.OpportunityId__c + 'Sold_Lines_of_Business__c', new Set<String>());
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (thisQLI.ProductStage__c.containsIgnoreCase('sold') || thisQLI.ProductStage__c.containsIgnoreCase('renew'))){
                        if(!String.isBlank(thisQLI.ProductLOB__c))
                            masterFieldMap.get(thisQLI.OpportunityId__c + 'Sold_Lines_of_Business__c').add(thisQLI.ProductLOB__c);
                    }
                }
                else {
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (thisQLI.ProductStage__c.containsIgnoreCase('sold') || thisQLI.ProductStage__c.containsIgnoreCase('renew')))
                        if(!String.isBlank(thisQLI.ProductLOB__c))
                        masterFieldMap.get(thisQLI.OpportunityId__c + 'Sold_Lines_of_Business__c').add(thisQLI.ProductLOB__c);
                }
                if (!masterFieldMap.containsKey(thisQLI.OpportunityId__c + 'Sold_Product_Families__c')) {
                    masterFieldMap.put(thisQLI.OpportunityId__c + 'Sold_Product_Families__c', new Set<String>());
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (thisQLI.ProductStage__c.containsIgnoreCase('sold') || thisQLI.ProductStage__c.containsIgnoreCase('renew'))){
                        if(!String.isBlank(thisQLI.Product_Family_Local__c))
                            masterFieldMap.get(thisQLI.OpportunityId__c + 'Sold_Product_Families__c').add(thisQLI.Product_Family_Local__c);
                    }
                }
                else {
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (thisQLI.ProductStage__c.containsIgnoreCase('sold') || thisQLI.ProductStage__c.containsIgnoreCase('renew')))
                        if(!String.isBlank(thisQLI.Product_Family_Local__c))
                        masterFieldMap.get(thisQLI.OpportunityId__c + 'Sold_Product_Families__c').add(thisQLI.Product_Family_Local__c);
                }
                if (!masterFieldMap.containsKey(thisQLI.OpportunityId__c + 'Competitors__c')) {
                    masterFieldMap.put(thisQLI.OpportunityId__c + 'Competitors__c', new Set<String>());
                    if(!String.isBlank(thisQLI.Competitor__r.Name)) masterFieldMap.get(thisQLI.OpportunityId__c + 'Competitors__c').add(thisQLI.Competitor__r.Name);
                    if(!String.isBlank(thisQLI.Competitor2__r.Name)) masterFieldMap.get(thisQLI.OpportunityId__c + 'Competitors__c').add(thisQLI.Competitor2__r.Name);
                    if(!String.isBlank(thisQLI.Competitor3__r.Name)) masterFieldMap.get(thisQLI.OpportunityId__c + 'Competitors__c').add(thisQLI.Competitor3__r.Name);
                }
                else {
                    if(!String.isBlank(thisQLI.Competitor__r.Name)) masterFieldMap.get(thisQLI.OpportunityId__c + 'Competitors__c').add(thisQLI.Competitor__r.Name);
                    if(!String.isBlank(thisQLI.Competitor2__r.Name)) masterFieldMap.get(thisQLI.OpportunityId__c + 'Competitors__c').add(thisQLI.Competitor2__r.Name);
                    if(!String.isBlank(thisQLI.Competitor3__r.Name)) masterFieldMap.get(thisQLI.OpportunityId__c + 'Competitors__c').add(thisQLI.Competitor3__r.Name);
                }
                // PRDCRM-37695 : Adding logic to rollup members and subscribers from QLI to Opportunity : Ravideep(Vikings)
                if (!masterNumberFieldMap.containsKey(thisQLI.OpportunityId__c + staticVariableClass.SubscribersRollup)) {
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Sold) || thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Renew))){
                        if(thisQLI.Subscribers__c != null){
                            system.debug('thisQLI.Subscribers__c 1 ' + thisQLI.Subscribers__c);
                            masterNumberFieldMap.put(thisQLI.OpportunityId__c + staticVariableClass.SubscribersRollup,thisQLI.Subscribers__c);
                        }
                    }
                }
                else {
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Sold) || thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Renew))){
                        if(thisQLI.Subscribers__c != null){
                            system.debug('thisQLI.Subscribers__c 2 ' + thisQLI.Subscribers__c);
                            masterNumberFieldMap.put(thisQLI.OpportunityId__c + staticVariableClass.SubscribersRollup,masterNumberFieldMap.get(thisQLI.OpportunityId__c + staticVariableClass.SubscribersRollup)+thisQLI.Subscribers__c);
                        }
                    }
                }

                if(!masterNumberFieldMap.containsKey(thisQLI.OpportunityId__c + staticVariableClass.MembersRollup )) {
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Sold) || thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Renew))){
                        if(thisQLI.Members__c != null){
                            system.debug('thisQLI.Members__c 1 ' + thisQLI.Members__c);
                            masterNumberFieldMap.put(thisQLI.OpportunityId__c + staticVariableClass.MembersRollup , thisQLI.Members__c);
                        }
                    }
                }
                else{
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Sold) || thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Renew))){
                        if(thisQLI.Members__c != null){
                            system.debug('thisQLI.Members__c 2 ' + thisQLI.Members__c);
                            masterNumberFieldMap.put(thisQLI.OpportunityId__c + staticVariableClass.MembersRollup ,masterNumberFieldMap.get(thisQLI.OpportunityId__c + staticVariableClass.MembersRollup )+thisQLI.Members__c);
                        }
                    }
                }
                //PRDCRM-40695 : Adding logic to rollup members and subscribers from Medical only QLI's to Opportunity : Ravideep(Vikings)
                //PRDCRM-44200 : Added filter criteria to consider only 'Product' type categories : Sharath KN(Vikings)
                if(!masterNumberFieldMap.containsKey(thisQLI.OpportunityId__c + staticVariableClass.TotalMedicalSubscribers)) {
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (!String.isBlank(thisQLI.ProductCategory__c)) && thisQLI.ProductCategory__c.containsIgnoreCase(staticVariableClass.PRODUCT_CATEGORY) && (thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Sold) || thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Renew)) && (!String.isBlank(thisQLI.ProductLOB__c)) && (thisQLI.ProductLOB__c.equalsIgnoreCase(staticVariableClass.Medical))){
                        if(thisQLI.Subscribers__c != null){
                            masterNumberFieldMap.put(thisQLI.OpportunityId__c + staticVariableClass.TotalMedicalSubscribers,thisQLI.Subscribers__c);
                        }
                    }
                }
                else {
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (!String.isBlank(thisQLI.ProductCategory__c)) && thisQLI.ProductCategory__c.containsIgnoreCase(staticVariableClass.PRODUCT_CATEGORY) && (thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Sold) || thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Renew)) && (!String.isBlank(thisQLI.ProductLOB__c)) && (thisQLI.ProductLOB__c.equalsIgnoreCase(staticVariableClass.Medical))){
                        if(thisQLI.Subscribers__c != null){
                            masterNumberFieldMap.put(thisQLI.OpportunityId__c + staticVariableClass.TotalMedicalSubscribers,masterNumberFieldMap.get(thisQLI.OpportunityId__c + staticVariableClass.TotalMedicalSubscribers)+thisQLI.Subscribers__c);
                        }
                    }
                }
                if(!masterNumberFieldMap.containsKey(thisQLI.OpportunityId__c + staticVariableClass.TotalMedicalMembers)) {
                   if((!String.isBlank(thisQLI.ProductStage__c)) && (!String.isBlank(thisQLI.ProductCategory__c)) && thisQLI.ProductCategory__c.containsIgnoreCase(staticVariableClass.PRODUCT_CATEGORY) && (thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Sold) || thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Renew)) && (!String.isBlank(thisQLI.ProductLOB__c)) && (thisQLI.ProductLOB__c.equalsIgnoreCase(staticVariableClass.Medical))){
                        if(thisQLI.Members__c != null){
                            masterNumberFieldMap.put(thisQLI.OpportunityId__c + staticVariableClass.TotalMedicalMembers, thisQLI.Members__c);
                        }
                    }
                }
                else {
                    if((!String.isBlank(thisQLI.ProductStage__c)) && (!String.isBlank(thisQLI.ProductCategory__c)) && thisQLI.ProductCategory__c.containsIgnoreCase(staticVariableClass.PRODUCT_CATEGORY) && (thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Sold) || thisQLI.ProductStage__c.containsIgnoreCase(staticVariableClass.Renew)) && (!String.isBlank(thisQLI.ProductLOB__c)) && (thisQLI.ProductLOB__c.equalsIgnoreCase(staticVariableClass.Medical))){
                        if(thisQLI.Members__c != null){
                            masterNumberFieldMap.put(thisQLI.OpportunityId__c + staticVariableClass.TotalMedicalMembers,masterNumberFieldMap.get(thisQLI.OpportunityId__c + staticVariableClass.TotalMedicalMembers)+thisQLI.Members__c);
                        }
                    }
                }
                
            }
        }
        system.debug('Master Field Map ======' + masterFieldMap);
        system.debug('Master Number Field Map ======' + masterNumberFieldMap);
        List<opportunity> oppsToBeUpdated = new List<opportunity>();
        List<String> oppFields = new List<String>{'Funding__c','Lines_of_Business__c','Financing_Rollup__c','Product_Families__c','Sold_Lines_of_Business__c','Sold_Product_Families__c','Competitors__c',staticVariableClass.SubscribersRollup,staticVariableClass.MembersRollup,staticVariableClass.TotalMedicalSubscribers,staticVariableClass.TotalMedicalMembers};
            for(String thisOppId : finalOppIds){
                Opportunity thisOpp = new Opportunity();
                thisOpp.Id = thisOppId;
                for(String thisField : oppFields){
                    if (!masterNumberFieldMap.isEmpty() && masterNumberFieldMap.get(thisOppId.substring(0, 15) + thisField) != null){
                        thisOpp.put(thisField,masterNumberFieldMap.get(thisOppId.substring(0, 15) + thisField)) ;
                    }
                    else {
                        if ((masterFieldMap.get(thisOppId.substring(0, 15) + thisField)) != null && !(masterFieldMap.get(thisOppId.substring(0, 15) + thisField)).isEmpty()) {
                            Set<String> fieldValues = masterFieldMap.get(thisOppId.substring(0, 15) + thisField);
                            List<string> fieldValuesList = new List<String>(fieldValues);
                            fieldValuesList.sort();
                            String str = String.join(fieldValuesList, ';');
                            thisOpp.put(thisField, (str.length() > 255 ? str.substring(0, 254) : str));
                        }else{
                            thisOpp.put(thisField, null);
                        }
                    }
                    
                }
                oppsToBeUpdated.add(thisOpp);
            }
        oppIds.removeAll(nonDeletedQLIOppIds);        
        if(oppIds.size() > 0){
            Set<Id> nonDelOpps = new Set<Id>();
            for(Opportunity thisOpp :[SELECT id FROM Opportunity WHERE Id IN: oppIds AND isDeleted = false] ){
                nonDelOpps.add(thisOpp.id);
            }
            if(nonDelOpps.size() > 0)
                for(Id thisOppId : nonDelOpps){
                    Opportunity thisOpp = new Opportunity(Id = thisOppId,Funding__c = null,Financing_Rollup__c = null,Competitors__c = null,Lines_of_Business__c = null,Product_Families__c = null,Sold_Lines_of_Business__c = null,Sold_Product_Families__c = null,Subscribers_Rollup__c= null,Members_Rollup__c = null,Total_Medical_Subscribers__c = null,Total_Medical_Members__c = null);
                    oppsToBeUpdated.add(thisOpp);
                }
        }
        
        if(oppsToBeUpdated.size() > 0){
            Database.SaveResult[] sR =  Database.update(oppsToBeUpdated,false);
            for(Integer i=0;i<oppsToBeUpdated.size();i++){
                If(!sR[i].isSuccess()){
                    isError = true;string errorMsg = '';
                    for(Database.Error error : sR[i].getErrors()){
                        errorMsg += ' ' + error.getMessage();
                    }
                    oppStr += oppsToBeUpdated[i].Id + ',' +  errorMsg + '\n';
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        AsyncApexJob batchStatus = [Select Id, NumberOfErrors, Status, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
        if(isError == true || batchStatus.NumberOfErrors > 0){ Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            Blob csvBlob = Blob.valueOf(oppStr);string csvname= 'Opportunity Errors.csv';csvAttc.setFileName(csvname);csvAttc.setBody(csvBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();String subject ='QLIToOpportunityRollUpBatch :'+batchStatus.Status;
            email.setSubject(subject);email.setToAddresses(new list<string>{System.label.Admin_Email});email.setPlainTextBody('QLIToOpportunityRollUpBatch has errors in Org - '+ UserInfo.getOrganizationId());
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});Messaging.SendEmailResult [] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }else{
            roles.LastRun__c =jobStartTime;
            update roles;
        }
    }
}