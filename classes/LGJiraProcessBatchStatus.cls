public with sharing class LGJiraProcessBatchStatus {
   
    
    public static void CreateEmail(Map<Id,string> errorMap,Integer JobItemsProcessed,string subject,Integer successcount, Integer failurecount,Map<Id, SObject> IdToSObjectMap,string objname,Map<Id,string> successMap,Map<Id, SObject> SuccessIdToSObjectMap,Map<string,string> IdtoReqBodyMap) 
    {
        system.debug('req body map:'+IdtoReqBodyMap);
     Organization org=[select id,issandbox,instancename from organization];
   

   
        ServiceInterface__mdt mc = [Select Success_File_Name__c,Id, AttachmentName__c,ToEmailList__c, EmailDisplayName__c, EmailSubject__c, FromEmailId__c, Environment__c From ServiceInterface__mdt Where DeveloperName = 'JIRAIntegration'];
        Map<Id,Implementation_Tracking__c> ordertoimplementationtracking=new Map<Id,Implementation_Tracking__c>();
         Map<Id,Implementation_Tracking__c> ordertoimplementationtrackingsuccess=new Map<Id,Implementation_Tracking__c>();
        string body='';
      
      
             
               
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
          
              string orderstr= 'Implementation Case Name, Implementation Tracking Id, Error Message\n';
            string sucessstr= 'JIRA Id, Implementation Tracking Id,Status\n';
         
            string successorderstr= 'Implementation Case Name, Implementation Tracking Id, JIRA request id\n';
            String csvfilename = mc.AttachmentName__c+'_'+Datetime.now()+'_'+subject+'.csv';
            String successcsvfilename = mc.Success_File_Name__c+'_'+Datetime.now()+'_'+subject+'.csv';
            string jsonerrorattach='';
            List<Messaging.EmailFileAttachment> efalist=new List<Messaging.EmailFileAttachment>();
              Messaging.EmailFileAttachment efa;
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(!errorMap.isEmpty() ){
   
          
            for(Id id  : errorMap.keySet()){
                string err = errorMap.get(id);
                if(objname=='Implementation_Tracking__c')
                {
                Implementation_Tracking__c it = (Implementation_Tracking__c) IdToSObjectMap.get(id);
           
                string recordString = '"'+it.JIRA_Request_ID__c+'","'+err+'"\n';
               
                finalstr=finalstr+recordString;
                
                }
                else
                {
                
                    
                  order o= (order) IdToSObjectMap.get(id);
               
                string recordString='';
                  if(!test.isrunningtest())
                  {
                    if(ordertoimplementationtracking.get(o.id)!=null)
                    {
                    
                    recordString = '"'+o.OrderNumber+'","'+ordertoimplementationtracking.get(o.id).name+'","'+err+'"\n';

                     }
                     else
                     {
                        recordString = '"'+o.OrderNumber+'","'+'null'+'","'+err+'"\n';
                        
                     }
                     }
                     else
                     {
                      recordString ='test';
                     }
            
            
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
          
            
        }
         if(!successMap.isEmpty()){
         for(Id id  : successMap.keySet()){
                string success = successMap.get(id);
                if(objname=='Implementation_Tracking__c')
                {
                Implementation_Tracking__c it = (Implementation_Tracking__c) SuccessIdToSObjectMap.get(id);
                
                //string recordString = '"'+it.JIRA_Request_ID__c+'","'+it.Name+'"\n';
              	string recordString = '"'+it.JIRA_Request_ID__c+'","'+it.Name+'","'+success+'"\n';
                sucessstr=sucessstr+recordString;
                }
                else
                {
                string recordString='';
                  order o= (order) SuccessIdToSObjectMap.get(id);
           
                if(!test.isrunningtest())
                {
                recordString = '"'+o.OrderNumber+'","'+ordertoimplementationtrackingsuccess.get(o.id).name+'","'+ordertoimplementationtrackingsuccess.get(o.id).JIRA_Request_ID__c+'"\n';
                }
                else
                {
                 recordString='test';
                }
            
                successorderstr=successorderstr+recordString;
                }
      
          
               
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
           
          }   
        
        if(IdtoReqBodyMap!=null && IdtoReqBodyMap.size() >0) {
            /* build request body attachment */
            /* File Format -
             Tracking id 1
             JSON Body 2
             *********************
             Tracking id 2
             JSON Body 2
           */
          
           for(Id i  : IdtoReqBodyMap.keySet()){
               jsonerrorattach= jsonerrorattach+ 'Implementation Case Id-'+i+'\r\n';
                jsonerrorattach=jsonerrorattach+IdtoReqBodyMap.get(i)+'\r\n'+'*********************'+'\r\n';
               
            } 
            system.debug('jsonerrorattach:'+jsonerrorattach);
            efa = new Messaging.EmailFileAttachment();
            efa.setFileName(mc.AttachmentName__c+'_'+Datetime.now()+'_'+subject+'.json');
            efa.setBody(Blob.valueOf(jsonerrorattach));
            
            efalist.add(efa);
         
           
            
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
      
        }
       
        mail.setBccSender(false);
        mail.setUseSignature(false); 
    
      mail.setPlainTextBody(body);
       
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
      
        
            
        }
    }