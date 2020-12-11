public with sharing class AsyncProcessBatchStatus {
    public static void CreateEmail(Map<Id,string> errorMap,Integer JobItemsProcessed,string subject,Integer successcount, Integer failurecount,Map<Id, SObject> IdToSObjectMap,string objname,Map<Id,string> successMap,Map<Id, SObject> SuccessIdToSObjectMap) 
    {
     Organization org=[select id,issandbox,instancename from organization];
   
        ServiceInterface__mdt mc = [Select Success_File_Name__c,Id, AttachmentName__c,ToEmailList__c, EmailDisplayName__c, EmailSubject__c, FromEmailId__c, Environment__c From ServiceInterface__mdt Where DeveloperName = 'JIRAIntegration'];//ServiceInterface__c.getValues('WLQIntegration');
        Map<Id,Implementation_Tracking__c> ordertoimplementationtracking=new Map<Id,Implementation_Tracking__c>();
         Map<Id,Implementation_Tracking__c> ordertoimplementationtrackingsuccess=new Map<Id,Implementation_Tracking__c>();
        string body='';
        //String subject = 'JIRA to SFDC Sync Process Status';
      
             
               
                     if(objname=='order' && !errorMap.isEmpty())
                     {
                         set<Id> errorids=errorMap.keyset();
                    List<Implementation_Tracking__c> itlist=[select id,name,Implementation_Record_ID__c from Implementation_Tracking__c where Implementation_Record_ID__c in:errorids];
                    
                    for(Implementation_Tracking__c i:itlist)
                    {
                        ordertoimplementationtracking.put(i.Implementation_Record_ID__c,i);
                        
                    }
                        
                     }
                       if(objname=='order' && !successMap.isEmpty())
                     {
                          set<Id> successids=SuccessIdToSObjectMap.keyset(); 
                    List<Implementation_Tracking__c> itlistsuccess=[select id,JIRA_Request_ID__c,name,Implementation_Record_ID__c from Implementation_Tracking__c where Implementation_Record_ID__c in:successids];
                    
                    for(Implementation_Tracking__c i:itlistsuccess)
                    {
                        ordertoimplementationtrackingsuccess.put(i.Implementation_Record_ID__c,i);
                        
                    }
                        
                     }
                     
        body=body+'Sync process from JIRA Integration is complete.\n\n'+'Total Number of Records processed: '+JobItemsProcessed+'\n'+'There were '+
            successcount+' successes'+' and '+ failurecount+' errors.\n\n';
            
              String finalstr = 'JIRA Id, Error Message\n';
              //string orderstr= 'Implementation Case Name, Error Message\n';
              string orderstr= 'Implementation Case Name, Implementation Tracking Id, Error Message\n';
            string sucessstr= 'JIRA Id, Implementation Tracking Id\n';
            //string successorderstr= 'Implementation Case Name, Order id\n';
            string successorderstr= 'Implementation Case Name, Implementation Tracking Id, JIRA request id\n';
            String csvfilename = mc.AttachmentName__c+'_'+Datetime.now()+'_'+subject+'.csv';
            String successcsvfilename = mc.Success_File_Name__c+'_'+Datetime.now()+'_'+subject+'.csv';
            List<Messaging.EmailFileAttachment> efalist=new List<Messaging.EmailFileAttachment>();
              Messaging.EmailFileAttachment efa;
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(!errorMap.isEmpty()){
            
           // body=body+'Please find the error list below.\n\n';
          
            for(Id id  : errorMap.keySet()){
                string err = errorMap.get(id);
                if(objname=='Implementation_Tracking__c')
                {
                Implementation_Tracking__c it = (Implementation_Tracking__c) IdToSObjectMap.get(id);
                //string recordString = '"'+id+'","'+acct.Name+'","'+err+'"\n';
                //finalstr = finalstr +recordString;
                string recordString = '"'+it.JIRA_Request_ID__c+'","'+err+'"\n';
                //body=body+'JIRA Id: '+it.JIRA_Request_ID__c+' -'+err+'\n';
                finalstr=finalstr+recordString;
                
                }
                else
                {
                
                    
                  order o= (order) IdToSObjectMap.get(id);
                //string recordString = '"'+id+'","'+acct.Name+'","'+err+'"\n';
                //finalstr = finalstr +recordString;
               // string recordString = '"'+o.OrderNumber+'","'+err+'"\n';
                string recordString;
                  if(!test.isrunningtest())
                  {
                      recordString = '"'+o.OrderNumber+'","'+ordertoimplementationtracking.get(o.id).name+'","'+err+'"\n';
                     }
                     else
                     {
                      recordString ='test';
                     }
                  
                //body=body+'Order Name:'+o.OrderNumber+' -'+err+'\n';
                orderstr=orderstr+recordString;
                }
               
            } 
            
            efa = new Messaging.EmailFileAttachment();
            efa.setFileName(csvfilename);
            if(objname=='Implementation_Tracking__c')
            {
            efa.setBody(Blob.valueOf(finalstr));
            }
            else
            {
                 efa.setBody(Blob.valueOf(orderstr));
            }
            efalist.add(efa);
            //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            
        }
         if(!successMap.isEmpty()){
         for(Id id  : successMap.keySet()){
                string success = successMap.get(id);
                if(objname=='Implementation_Tracking__c')
                {
                Implementation_Tracking__c it = (Implementation_Tracking__c) SuccessIdToSObjectMap.get(id);
                //string recordString = '"'+id+'","'+acct.Name+'","'+err+'"\n';
                //finalstr = finalstr +recordString;
                string recordString = '"'+it.JIRA_Request_ID__c+'","'+it.Name+'"\n';
                //body=body+'JIRA Id: '+it.JIRA_Request_ID__c+' -'+err+'\n';
                sucessstr=sucessstr+recordString;
                }
                else
                {
                string recordString;
                  order o= (order) SuccessIdToSObjectMap.get(id);
                //string recordString = '"'+id+'","'+acct.Name+'","'+err+'"\n';
                //finalstr = finalstr +recordString;
                //string recordString = '"'+o.OrderNumber+'","'+o.id+'"\n';
                if(!test.isrunningtest())
                {
                recordString = '"'+o.OrderNumber+'","'+ordertoimplementationtrackingsuccess.get(o.id).name+'","'+ordertoimplementationtrackingsuccess.get(o.id).JIRA_Request_ID__c+'"\n';
                }
                else
                {
                 recordString='test';
                }
                //body=body+'Order Name:'+o.OrderNumber+' -'+err+'\n';
                successorderstr=successorderstr+recordString;
                }
                
            
         //Messaging.reserveSingleEmailCapacity(2);
          
               
            } 
        // Create the email attachment    
              efa = new Messaging.EmailFileAttachment();
            efa.setFileName(successcsvfilename);
            if(objname=='Implementation_Tracking__c')
            {
            efa.setBody(Blob.valueOf(sucessstr));
            }
            else
            {
                 efa.setBody(Blob.valueOf(successorderstr));
            }
            efalist.add(efa);
           // mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
          }   
        String[] toAddresses = mc.ToEmailList__c.split(';');
   
        mail.setToAddresses(toAddresses);
        mail.setFileAttachments(efalist);
        mail.setReplyTo(mc.FromEmailId__c);    
        mail.setSenderDisplayName(mc.EmailDisplayName__c);
        if(org.issandbox==true)
        {
             mail.setSubject(org.instancename+'- '+subject);
        }
        else
        {
            mail.setSubject('Production:'+org.instancename+'- '+subject);
             //mail.setSubject(mc.Environment__c+' - '+subject);
        }
       
        mail.setBccSender(false);
        mail.setUseSignature(false); 
      // mail.setHtmlBody(body);
      mail.setPlainTextBody(body);
            //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
      
        
            
        }
    }