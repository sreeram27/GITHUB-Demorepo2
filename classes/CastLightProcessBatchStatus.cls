public class CastLightProcessBatchStatus {
    
    public class CastLightProcessStatusWrapper
    {
        public string statusmessage {get;set;}
        public string status {get;set;}
        public Opportunity opp {get;set;}
    }
    
    public static void AnthToCSLTProcessStatusEmail(List<CastLightProcessStatusWrapper> wrapperobj) {
        Organization org = [select id, issandbox, instancename from organization];
        ServiceInterface__mdt mc = [Select Success_File_Name__c, Id, AttachmentName__c, ToEmailList__c, EmailDisplayName__c, EmailSubject__c, FromEmailId__c, Environment__c From ServiceInterface__mdt Where DeveloperName = 'CastLightIntegration']; 
        
        Integer JobItemsProcessed=0;
        set<Id> failureoppids=new set<Id>();
        Integer successcount=0;
        Integer failurecount=0;
        string errorstr = 'Opportunity Id, Opportunity Name, Account Id,Account Name,Account Anthem Entity,Error Message\n';
        for(CastLightProcessStatusWrapper w: wrapperobj)
        {
            if(w.status=='SUCCESS')
            {
                successcount++;
                
                
            }
            if(w.status=='ERROR')
            {
                failurecount++;
                failureoppids.add(w.opp.id);
                string recordString = '"' + w.opp.id + '","' + w.opp.name + '","' + w.opp.accountid+'","'+w.opp.account.name+'","'+w.opp.account.Anthem_Entity__c + '","' + w.statusmessage + '"\n';
                errorstr = errorstr + recordString;
                
            }
            
        }
        JobItemsProcessed=successcount+failurecount;
        
        string body = '';
        
        body = body + 'Anthem to Castlight integration process completed.\n\n' + 'Total Number of opportunities processed: ' + JobItemsProcessed + '\n\n' + 'Number of opportunities failed : ' +
            failurecount + '\n\n' +'Number of opportunities sent to Castlight : '+successcount+'\n\n';
        
        String errorcsvfilename = mc.AttachmentName__c + '_' + Datetime.now() + '.csv';
        List < Messaging.EmailFileAttachment > efalist = new List < Messaging.EmailFileAttachment > ();
        Messaging.EmailFileAttachment efa;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if (failurecount > 0 ) {
            efa = new Messaging.EmailFileAttachment();
            //efa.setFileName(csvfilename);
            efa.setFileName(errorcsvfilename);
            efa.setBody(Blob.valueOf(errorstr));
            
            efalist.add(efa);
            
            
        }
        
        
        String[] toAddresses = mc.ToEmailList__c.split(';');
        
        mail.setToAddresses(toAddresses);
        mail.setFileAttachments(efalist);
        mail.setReplyTo(mc.FromEmailId__c);
        mail.setSenderDisplayName(mc.EmailDisplayName__c);
        if (org.issandbox == true) {
            mail.setSubject(org.instancename + '- ' + 'Anthem to Castlight Integration Batch Process Status');
        } else {
            mail.setSubject('Production:' + org.instancename + '- ' + 'Anthem to Castlight Integration Batch Process Status');
            
        }
        
        mail.setBccSender(false);
        mail.setUseSignature(false);
        
        mail.setPlainTextBody(body);
        
        
        // Sends the email
        Messaging.SendEmailResult[] r =
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                mail
                    });
        
        
        
    }
    
    //will be used for Castlight-->Anthem Integration
    
    public static void CSLTToAnthProcessStatusEmail(string req, String exceptionStr) {
        
        string body = '';
        
        if(exceptionStr !='Success')
        {
        body = body + 'Error occured in the processing the request during castlight to anthem integration.\n\n' + 'Please find attached the request.'+ '\n\n' + 'Please find the exception detail below:\n\n'+exceptionStr+'\n\n';
        }
        else
        {
        body=body+'Success';
        }
        Organization org = [select id, issandbox, instancename from organization];
        
        ServiceInterface__mdt mc = [Select Success_File_Name__c, Id, AttachmentName__c, ToEmailList__c, EmailDisplayName__c, EmailSubject__c, FromEmailId__c, Environment__c From ServiceInterface__mdt Where DeveloperName = 'CastLightIntegration']; 
        String errorcsvfilename = mc.AttachmentName__c + '_' + Datetime.now() + '.json';
        List < Messaging.EmailFileAttachment > efalist = new List < Messaging.EmailFileAttachment > ();
        Messaging.EmailFileAttachment efa=new Messaging.EmailFileAttachment();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(exceptionStr !='Success')
        {
        efa.setFileName(errorcsvfilename);
        }
        else
        {
        efa.setFileName('Success' + '_' + Datetime.now() + '.json');

        }
        efa.setBody(Blob.valueOf(req));
        
        efalist.add(efa);
        
        
        String[] toAddresses = mc.ToEmailList__c.split(';');
        
        mail.setToAddresses(toAddresses);
        mail.setFileAttachments(efalist);
        mail.setReplyTo(mc.FromEmailId__c);
        mail.setSenderDisplayName(mc.EmailDisplayName__c);
        if (org.issandbox == true) {
            mail.setSubject(org.instancename + '- ' + 'Castlight to Anthem Integration Status');
        } else {
            mail.setSubject('Production:' + org.instancename + '- ' + 'Castlight to Anthem Integration Status');
            
        }
        
        mail.setBccSender(false);
        mail.setUseSignature(false);
        
        mail.setPlainTextBody(body);
        
        
        // Sends the email
        Messaging.SendEmailResult[] r =
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                mail
                    });
        
    }
}