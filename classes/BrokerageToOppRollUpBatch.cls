/*
* Purpose: Rolls up field values to respective Opportunity records
* Version: 1.0
* 
* JIRA NUMBER    DATE           DEVELOPER    DESCRIPTION 
* ===========    ===========    =========    =======================================================
*PRDCRM-36244    22-June-2019    Sharath KN   Created batch class
*/
global class BrokerageToOppRollUpBatch implements Database.Batchable<sObject> , Database.Stateful{
    String headerStr = 'Opportunity Id,Error \n';
    global String oppStr = headerStr;
    global Boolean isError = false;
    global String Query = 'SELECT Id, Opportunity__r.Id FROM Brokerage_and_Consultant1__c WHERE lastmodifieddate >: lastRun '
        +'OR Brokerage__r.lastmodifieddate >: lastRun OR Consultant__r.lastmodifieddate >: lastRun OR Consultant__r.Contact__r.lastmodifieddate >: lastRun' 
        +' ORDER By Opportunity__r.Id ASC nulls last ALL RoWS';
    global AccountRoles__c roles = AccountRoles__c.getValues('BrokerageOppReport');//Custom setting that stores the batch last run datetime
    DateTime lastRun = roles.LastRun__c; // Holds the date when this batch was run last time
    DateTime jobStartTime = DateTime.now();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Brokerage_and_Consultant1__c> BCList){
        Set<Id> oppIds = new Set<Id>(); // Set that holds unique opportunity IDs
        
        //generate list of unique Opportunity IDs
        for(Brokerage_and_Consultant1__c thisBC : BCList){
            if(thisBC.Opportunity__r.Id != null)
                oppIds.add(thisBC.Opportunity__r.Id);
        }
        Set<Id> finalOppIds = new Set<Id>();
        Set<Id> nonDeletedQLIOppIds = new Set<Id>(); // stores OppIds for which atleast one QLI exists
        Map<String,Set<String>> masterFieldMap = new Map<String,Set<String>>();
        for(Brokerage_and_Consultant1__c thisOpp : [SELECT Id,opportunity__r.IsDeleted, Opportunity__r.Id, Brokerage__c, BrokName__c, Consultant__r.Contact__r.FirstName, Consultant__r.Contact__r.LastName, Consultant__c FROM Brokerage_and_Consultant1__c WHERE Opportunity__r.Id IN: oppIds]){
            nonDeletedQLIOppIds.add(thisOpp.Opportunity__r.Id);
            if(thisOpp.opportunity__r.IsDeleted == false){
                finalOppIds.add(thisOpp.Opportunity__r.Id);
                if (!masterFieldMap.containsKey(thisOpp.Opportunity__r.Id + 'All_Opportunity_Brokerages__c')) {
                    masterFieldMap.put(thisOpp.Opportunity__r.Id + 'All_Opportunity_Brokerages__c', new Set<String>());
                    if(!String.isBlank(thisOpp.Brokerage__c))masterFieldMap.get(thisOpp.Opportunity__r.Id + 'All_Opportunity_Brokerages__c').add(thisOpp.BrokName__c);
                }
                else {
                    if(!String.isBlank(thisOpp.Brokerage__c))
                        masterFieldMap.get(thisOpp.Opportunity__r.Id + 'All_Opportunity_Brokerages__c').add(thisOpp.BrokName__c);
                }
                if (!masterFieldMap.containsKey(thisOpp.Opportunity__r.Id + 'Opportunity_Brokers__c')) {
                    masterFieldMap.put(thisOpp.Opportunity__r.Id + 'Opportunity_Brokers__c', new Set<String>());
                    if(!String.isBlank(thisOpp.Consultant__c))
                    {
                        String fName = (thisOpp.Consultant__r.Contact__r.FirstName != null) ? thisOpp.Consultant__r.Contact__r.FirstName : '';
                        String LName = (thisOpp.Consultant__r.Contact__r.LastName != null) ? thisOpp.Consultant__r.Contact__r.LastName : '';
                        masterFieldMap.get(thisOpp.Opportunity__r.Id + 'Opportunity_Brokers__c').add(fName + ' ' + LName);
                    }
                }
                else {
                    if(!String.isBlank(thisOpp.Consultant__c))
                    {
                        String fName = (thisOpp.Consultant__r.Contact__r.FirstName != null) ? thisOpp.Consultant__r.Contact__r.FirstName : '';
                        String LName = (thisOpp.Consultant__r.Contact__r.LastName != null) ? thisOpp.Consultant__r.Contact__r.LastName : '';
                        masterFieldMap.get(thisOpp.Opportunity__r.Id + 'Opportunity_Brokers__c').add(fName + ' ' + LName);
                    }
                }
            }
        }
        List<opportunity> oppsToBeUpdated = new List<opportunity>();
        List<String> oppFields = new List<String>{'All_Opportunity_Brokerages__c','Opportunity_Brokers__c'};
            for(String thisOppId : finalOppIds){
                Opportunity thisOpp = new Opportunity();
                thisOpp.Id = thisOppId;
                for(String thisField : oppFields){
                    if ((masterFieldMap.get(thisOppId + thisField)) != null && !(masterFieldMap.get(thisOppId + thisField)).isEmpty()) {
                        Set<String> fieldValues = masterFieldMap.get(thisOppId + thisField);
                        fieldValues.remove(' ');
                        List<string> fieldValuesList = new List<String>(fieldValues);
                        fieldValuesList.sort();
                        String str = String.join(fieldValuesList, ';');
                        thisOpp.put(thisField, (str.length() > 255 ? str.substring(0, 254) : str));
                    }else{
                        thisOpp.put(thisField,'');
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
                for(Id thisOppId : oppIds){
                    Opportunity thisOpp = new Opportunity(Id = thisOppId,All_Opportunity_Brokerages__c = '',Opportunity_Brokers__c = '');
                    oppsToBeUpdated.add(thisOpp);
                }
        }
        
        if(oppsToBeUpdated.size() > 0){
            Database.SaveResult[] sR =  Database.update(oppsToBeUpdated,false);
            for(Integer i=0;i<oppsToBeUpdated.size();i++){
                If(!sR[i].isSuccess()){isError = true;
                    string errorMsg = '';
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
            Blob csvBlob = Blob.valueOf(oppStr);string csvname= 'Opportunity Errors.csv';csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();String subject ='BrokerageToOppRollUpBatch :'+batchStatus.Status;
            email.setSubject(subject);email.setToAddresses(new list<string>{System.label.Admin_Email});email.setPlainTextBody('BrokerageToOppRollUpBatch has errors in Org - '+ UserInfo.getOrganizationId());
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});Messaging.SendEmailResult [] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }else{
            roles.LastRun__c =jobStartTime;
            update roles;
        }
    }
}