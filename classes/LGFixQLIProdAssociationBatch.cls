//This batch process updates the QuoteLineItem to reference Product record with new reserved contract code 
global class LGFixQLIProdAssociationBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable{

    public Integer totalNoOfRecords = 0;
    public Integer NoOfSuccesses =0;
    public Integer NoOfFailures = 0;
    public Integer matchingRecCount = 0;
    public Integer productNotFoundCount = 0;
    public List<String> statusStringRows = new List<String>();
    public String headerStr = 'QuoteLineItem Id, Status, Error Message \n';
    public String finalStr = headerStr;
    
    global Database.QueryLocator start(Database.BatchableContext bc){
      
        return Database.getQueryLocator([Select Id, Product2Id, AnthemEntity__c, ProductStage__c, Product_Type__c, ProductCategory__c, 
                                         vlocity_ins__ContractCode__c , Product2.Contract_Code__c
                                         from QuoteLineItem where AnthemEntity__c IN ('Local/Large Group', 'Labor and Trust')
                                        AND ProductStage__c IN ('Sold', 'IGAP Sold', 'Renewed') AND Product_Type__c = 'Medical' AND ProductCategory__c = 'Plan' 
                                        and vlocity_ins__ContractCode__c!=null] );
    }
    
    global void execute(Database.BatchableContext bc, List<QuoteLineItem> scope){
         totalNoOfRecords += scope.size();
        
        Set<String> contCodeSet = new Set<String>(); 
        
        for(QuoteLineItem qli : scope){
            contCodeSet.add(qli.vlocity_ins__ContractCode__c);
        }
        
        Map<String, Product2> productMap = new Map<String, Product2>();
        List<Product2> prodList = [Select Id, Contract_Code__c, vlocity_ins__EffectiveDate__c from Product2 where Contract_Code__c IN : contCodeSet Order by vlocity_ins__EffectiveDate__c ASC];
        
        if(prodList.size()>0){
        	for(Product2 prodct: prodList){
            productMap.put(prodct.Contract_Code__c, prodct);
        	}
        }
        
            for(QuoteLineItem qli: scope){
                
                if(productMap.containsKey(qli.vlocity_ins__ContractCode__c)){
                   
                    if(qli.vlocity_ins__ContractCode__c != qli.Product2.Contract_Code__c){
                        
                    QLIUpdateUtility qliUtility = new QLIUpdateUtility();
                    QLIUpdateUtility.QLIUpdateStatus updateStatus = qliUtility.updateQLIProduct(qli.Id, qli.vlocity_ins__ContractCode__c);                        
                    
                        if(updateStatus.StatusCode == 'SUCCESS'){
                            NoOfSuccesses++;
                        }
                        else{
                            NoOfFailures++;        
                        }
                        String StatusStr = qli.Id+','+updateStatus.StatusCode+','+updateStatus.StatusMessage;
                        System.debug(StatusStr);
                        statusStringRows.add(StatusStr);  
                    }
                    else{
                        matchingRecCount++;
                        String StatusStr = qli.Id+','+' '+','+'QLI is Associated to right Product Already';
                    	System.debug(StatusStr);
                    	statusStringRows.add(StatusStr);
                    }
                }
                else{
                    productNotFoundCount++;
                    String StatusStr = qli.Id+','+'Error'+','+'Product not found with this contract code: '+qli.vlocity_ins__ContractCode__c;
                    System.debug(StatusStr);
                    statusStringRows.add(StatusStr);
                }
            } 
    }
    
    global void finish(Database.BatchableContext bc){
        
       ServiceInterface__mdt mdt = [Select Id, AttachmentName__c, ToEmailList__c, EmailDisplayName__c, EmailSubject__c, FromEmailId__c From ServiceInterface__mdt Where Label = 'QLIProdAssociationBatch']; 
       List<Messaging.EmailFileAttachment> attchmntsList = new List<Messaging.EmailFileAttachment>();
        
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        finalStr = finalStr + String.join(statusStringRows, '\n');
        Blob csvBlob = Blob.valueOf(finalStr);
        string attfileName= mdt.AttachmentName__c+'_'+Date.today()+'.csv';
        csvAttc.setFileName(attfileName);
        csvAttc.setBody(csvBlob);
        attchmntsList.add(csvAttc);   
        
        
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = mdt.ToEmailList__c.split(';');
        String subject = mdt.EmailSubject__c;
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setSenderDisplayName(mdt.EmailDisplayName__c);
        email.setReplyTo(mdt.FromEmailId__c);
        String body = 'Total Number of Records Processed in the bacth : '+ totalNoOfRecords + '<br/>';
        body += 'Number of QLIs Processed Successfully: '+NoOfSuccesses + '<br/>';
        body += 'Number of QLIs failed : '+NoOfFailures + '<br/>';
        body += 'Number of QLIs that have matching Contract Codes already : '+ matchingRecCount + '<br/>';
        body += 'Number of QLIs with contract codes that do not have matching Products in the System : '+ productNotFoundCount + '<br/>';
        email.setHtmlBody(body);
        email.setFileAttachments(attchmntsList);
        Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});        
            
    }
    
    global void execute(SchedulableContext sc){
        
        Database.executeBatch(new LGFixQLIProdAssociationBatch(), 1);
    }
}