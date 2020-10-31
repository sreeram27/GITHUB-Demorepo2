/**
* ------------------------------------------------------------------------------------------------------
* Name          LGBatchRenewalStatus
* Author        Deloitte Offshore
* CreatedDate   12/18/2019
* UsedBy        LGCreateRenewalOpportunityBatch
* ------------------------------------------------------------------------------------------------------
* 
* @description
* This class used to send email to a particular DL specified in custom metadata type after the batch 
* renwal is complete
* 
* JIRA ID:  46384
* ------------------------------------------------------------------------------------------------------
* Changes
* 
* ------------------------------------------------------------------------------------------------------
**/
public with sharing class LGBatchRenewalStatus 
{
    /**
     * ------------------------------------------------------------------------------------------------------
     * @description 
     * CreateEmail method (to send and email to a particular DL after the batch processed)
     * ------------------------------------------------------------------------------------------------------
     * @param Map<Id, String>   (mapStatus) map of opportunity Id and error/success
     * @param Integer           (iJobItemsProcessed) total number of records processed
     * @param String            (sSubject) specifies the sSubject of the email
     * @param Integer           (iSuccesscount) specifies number of record processed successfully
     * @param Integer           (iFailurecount) specifies number of records failed
     * ------------------------------------------------------------------------------------------------------
     **/
    public static void createEmail( Map<Id, String> mapStatus, Integer iJobItemsProcessed, 
                                    Integer iSuccesscount, Integer iFailurecount) {
    String sBody;
    String sFieldLabels;
    String sCsvFileName;
    
    //Getting the confuguration properties from custom meta data type record called BatchRenewalStatus
    ServiceInterface__mdt batchRenewalIns = [Select Success_File_Name__c, Id, AttachmentName__c, ToEmailList__c, 
                                                    EmailDisplayName__c, EmailSubject__c, FromEmailId__c, 
                                                    Environment__c  from ServiceInterface__mdt 
                                                                    where DeveloperName =: staticVariableClass.BATCH_RENEWAL_STATUS];
    //Stores field labels to be displayed in the excel
    sFieldLabels = 'Opportunity Id, Opportunity Name, Account Name, Stage Name, RecordType Name, Anthem Entity, Record Insertion Status, Error Message\n';
    
    //Stores email body content
    sBody = 'Renewal Batch process is complete\n\n' + 'Total Number of Records processed: ' + 
            iJobItemsProcessed + '\n' + 'There were ' + iSuccesscount + ' successes and '+ iFailurecount + 
            ' errors.\n\n';
            
    //Stores attachment name sent in email       
    sCsvFileName =  batchRenewalIns.AttachmentName__c + '_' + Datetime.now() + '_' + 
                    batchRenewalIns.EmailSubject__c + '.csv';
    
    if(!mapStatus.isEmpty()){
        
        //Iterating across the opportunity and taking the values
        for(Opportunity oppIns : [select ID, Name, Account.Name, StageName, RecordTypeName__c, 
                                        AnthemEntity__c from Opportunity where ID IN: mapStatus.keyset()]) {
            
            String sFieldNames =  '"'+oppIns.id+'","'+oppIns.Name+'","'+oppIns.Account.Name+'","'+
                                            oppIns.StageName+'","'+oppIns.RecordTypeName__c+'","'+
                                            oppIns.AnthemEntity__c+'","';
            if (!test.isrunningtest()) {
                 sFieldNames =   mapStatus.get(oppIns.Id) == staticVariableClass.RECORD_PROCESSED_SUCCESS ?
                                 sFieldNames + staticVariableClass.RECORD_PROCESSED_SUCCESS+'"\n' :
                                 sFieldNames + staticVariableClass.RECORD_PROCESSED_FAILED+'","'+mapStatus.get(oppIns.Id)+'"\n';
        } else {
          sFieldNames = staticVariableClass.DNCStrPath;
        }
        
        sFieldLabels += sFieldNames;
        }
    }
    
    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
    efa.setFileName(sCsvFileName);
        efa.setBody(Blob.valueOf(sFieldLabels));
 
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    email.setToAddresses(batchRenewalIns.ToEmailList__c.split(';'));
    email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
    email.setReplyTo(batchRenewalIns.FromEmailId__c);
    email.setSenderDisplayName(batchRenewalIns.EmailDisplayName__c);
    email.setSubject(URL.getSalesforceBaseUrl().getHost().substringBetween('--','.')+'-'+batchRenewalIns.EmailSubject__c );
    email.setPlainTextBody(sBody);
    
    //Sending the email
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
  }
}