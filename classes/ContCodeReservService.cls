public class ContCodeReservService {
    
    public static ContCodeReserveResponse reserveContractCode(ContCodeReservRequest CCReq){
        ContCodeReserveResponse serviceRes = new ContCodeReserveResponse();
        ContCodeReservServiceUtility ccReserve = new ContCodeReservServiceUtility();
        serviceRes = ccReserve.reserveContractCode(CCReq);
        return serviceRes;
        
    }
   /* public static ContCodeReleaseResponse releaseContractCode(ContCodeReleaseRequest CCReq){
        ContCodeReleaseResponse serviceRes = new ContCodeReleaseResponse();
        ContCodeReservServiceUtility ccReserve = new ContCodeReservServiceUtility();
        serviceRes = ccReserve.releaseContractCode(CCReq);
        return serviceRes;
        
    } */
    
    /* Process builder on implemenation case */
    
    /* Name - reserveContractCode 
         Trigger criteria  -        On edit  
         
        Condition -

        IMplementation case status = 'Pending SME Review'
        Account.Anthem Entity = 'Local/Large Group' or 'Labor & Trust'
        Quote.Group.claimsystem = 'WGS 2.0'
        
    */
   /* @InvocableMethod(label='Contract Code Reservation Service')
    public static void reserveContractCodesforImplCase(List<Id> Impl_case_ids){
			contractCodeReserveServiceCallout(Impl_case_ids);  
}
        /*
        Loop through each implemenation case id
            retrieve all the qlis with status in ('Sold', 'Renewed','IGAP Sold') and Product_Type__c = 'Medical' and ProductCategory__c = 'Plan' and   qli.quote.implementationcase id = imp case id passed as parameter
            for each QLI
                build contractcode reservation service request
                call service 
                Update QLI with new contract code in Vlocity_ins__contract_code__c field 
         
                         
        
Auditing solution - 

1. Custom object  : Contract_Reservation_Service_Call_log

fields -
    QLI id 
    Request Message
    Response Message
    Status
    Status Message
    Transaction Id
    Transaction Timestamp
    Contract Code        
     */
    
    @future(callout = true)
    public static void contractCodeReserveServiceCallout(Id ImplcaseId){
      
         //List<QuoteLineItem> qliList = new List<QuoteLineItem>();
         List<QuoteLineItem> qliListtoUpdate = new List<QuoteLineItem>();   
         List<Contract_Reservation_Service_Call_Log__c> ServicecallLogs = new List<Contract_Reservation_Service_Call_Log__c>();
         
        List<String> errorStringRows = new List<String>();
        String headerStr = 'QuoteLineItem Id, Status, Error Message \n';
    	String finalStr = headerStr;
        Integer NoOfSuccesses =0;
        Integer NoOfFailures = 0;
        
        	
      /*  for(Order ord: [Select Id, QuoteId from Order where Id = :ImplcaseId]){
            qliList = [Select Id, QuoteId, Product_Type__c, ProductStage__c, ProductCategory__c from QuoteLineItem where QuoteId =:ord.QuoteId AND ProductStage__c IN ('Sold', 'IGAP Sold', 'Renewed') AND Product_Type__c = 'Medical' AND ProductCategory__c = 'Plan'];
        } */
        Order ImpCase = [Select Id, QuoteId, CC_Service_Invoked__c, OrderNumber, RecordType.Name, Implementation_Type__c
                         from Order 
                         where Id = :ImplcaseId];
            
        List<QuoteLineItem> qliList = [Select Id, QuoteId, Product_Type__c, ProductStage__c, ProductCategory__c from QuoteLineItem where QuoteId =:ImpCase.QuoteId AND ProductStage__c IN ('Sold', 'IGAP Sold', 'Renewed') 
                                       AND Product_Type__c = 'Medical' AND ProductCategory__c = 'Plan'];
        
        ContCodeReservServiceUtility reserveServiceutility = new ContCodeReservServiceUtility();
        
        Map<String, Contract_Reservation_Service_Call_Log__c> qliLogMap = new Map<String, Contract_Reservation_Service_Call_Log__c>();
        List<Contract_Reservation_Service_Call_Log__c> logList = [Select Id, Quote_Line_Item_ID__c, Status_Code__c, Implementation_Case_Id__c  from Contract_Reservation_Service_Call_Log__c where Implementation_Case_Id__c = :ImplcaseId AND Status_Code__c = 'SUCCESS'];
        
        for(Contract_Reservation_Service_Call_Log__c log: logList){
            qliLogMap.put(log.Quote_Line_Item_ID__c, log);
        }
       
        if(qliList.size()>0){
            for(QuoteLineItem qli: qliList){
                if(!qliLogMap.containsKey(qli.Id)){
                ContCodeReservRequest request = reserveServiceutility.buildRequest(qli.Id, impCase);
                ContCodeReserveResponse response = reserveContractCode(request); 
                
                //Update Contract Code from the response back to vlocity_ins__ContractCode__c field on the QLI
                if(Integer.valueOf(response.status.code) >= 200 && Integer.valueOf(response.status.code) < 300 &&
                   response.contractCode != null && response.contractCode != request.baseContract){
                    qli.vlocity_ins__ContractCode__c = response.contractCode;
                    qliListtoUpdate.add(qli);
                    NoOfSuccesses++;
                }
                else{
                      NoOfFailures++;
                      String errorStr = qli.Id+','+response.Status.Code+','+response.Status.Message;
                      System.debug(errorStr);
                      errorStringRows.add(errorStr);  
                    }
                
                Contract_Reservation_Service_Call_Log__c log = new Contract_Reservation_Service_Call_Log__c();
                log.Quote_Line_Item_ID__c     = qli.Id;
                log.Implementation_Case_Id__c = ImplcaseId;
                log.Request_Message__c        = JSON.serialize(request);
                log.Response_Message__c       = JSON.serialize(response);
                log.Status_Code__c            = Integer.valueOf(response.status.code) >= 200 && Integer.valueOf(response.status.code) < 300 &&
                  								response.contractCode != null && response.contractCode != request.baseContract? 'SUCCESS': 'ERROR';
                log.Status_Message__c         = response.Status.message;
                log.Service_Response_Code__c  = response.Status.Code;
                log.Transaction_ID__c         = request.transactionId;
                log.Transaction_Timestamp__c  = request.transactionTimestamp;
                log.Contract_Code__c          = response.ContractCode != null ?response.contractCode:'';    
               // log.Contract_Code__c          = response.status.Code == '200'?response.contractCode:'';
                
                System.debug(log);
                ServicecallLogs.add(log);
            }
        }  
        }
        if(qliListtoUpdate.size()>0){
            update qliListtoUpdate;
        }
        if(ServicecallLogs.size()>0){
            insert ServicecallLogs;
        }
        if(NoOfFailures>0){
            finalStr = finalStr + String.join(errorStringRows, '\n');
            sendEmail(finalStr, NoOfFailures, NoOfSuccesses);
        }
        
        if(!ImpCase.CC_Service_Invoked__c){
            ImpCase.CC_Service_Invoked__c = true;
            update ImpCase;
            System.debug(Impcase.CC_Service_Invoked__c);
        }
        
    }

    public static List<ContCodeReserveResponse> contractCodeReserveServiceCalloutImpl(Id ImplcaseId){
        
         List<QuoteLineItem> qliListtoUpdate = new List<QuoteLineItem>();
         List<ContCodeReserveResponse> responseList = new List<ContCodeReserveResponse>();
         List<Contract_Reservation_Service_Call_Log__c> ServicecallLogs = new List<Contract_Reservation_Service_Call_Log__c>();
         
         List<String> errorStringRows = new List<String>();
         String headerStr = 'QuoteLineItem Id, Status, Error Message \n';
    	 String finalStr = headerStr;
         Integer NoOfSuccesses = 0;
         Integer NoOfFailures = 0;
        
        Order ImpCase = [Select Id, QuoteId, CC_Service_Invoked__c, OrderNumber, RecordType.Name, Implementation_Type__c 
                         from Order
                         where Id = :ImplcaseId];
            
        List<QuoteLineItem> qliList = [Select Id, QuoteId, Product_Type__c, ProductStage__c, ProductCategory__c, ProductName__c from QuoteLineItem where QuoteId =:ImpCase.QuoteId AND ProductStage__c IN ('Sold', 'IGAP Sold', 'Renewed') 
                                       AND Product_Type__c = 'Medical' AND ProductCategory__c = 'Plan'];
        
        ContCodeReservServiceUtility reserveServiceutility = new ContCodeReservServiceUtility();
        ContCodeReserveResponse response = new ContCodeReserveResponse();
        
        Map<String, Contract_Reservation_Service_Call_Log__c> qliLogMap = new Map<String, Contract_Reservation_Service_Call_Log__c>();
        List<Contract_Reservation_Service_Call_Log__c> logList = [Select Id, Quote_Line_Item_ID__c, Status_Code__c, Implementation_Case_Id__c  from Contract_Reservation_Service_Call_Log__c where Implementation_Case_Id__c = :ImplcaseId AND Status_Code__c = 'SUCCESS'];
        
        for(Contract_Reservation_Service_Call_Log__c log: logList){
            qliLogMap.put(log.Quote_Line_Item_ID__c, log);
        }
        
        if(qliList.size()>0){
            for(QuoteLineItem qli: qliList){
                
                if(!qliLogMap.containsKey(qli.Id)){
                ContCodeReservRequest request = reserveServiceutility.buildRequest(qli.Id, impCase);
                response = reserveContractCode(request);
                
                //Update Contract Code from the response back to vlocity_ins__ContractCode__c field on the QLI
                if(Integer.valueOf(response.status.code) >= 200 && Integer.valueOf(response.status.code) < 300 &&
                   response.contractCode != null && response.contractCode != request.baseContract){
                    qli.vlocity_ins__ContractCode__c = response.contractCode;
                    qliListtoUpdate.add(qli);
                    NoOfSuccesses++;
                } else{
                    NoOfFailures++;
                    String errorStr = qli.Id+','+response.Status.Code+','+response.Status.Message;
                    System.debug(errorStr);
                    errorStringRows.add(errorStr);  
                }
                
                Contract_Reservation_Service_Call_Log__c log = new Contract_Reservation_Service_Call_Log__c();
                log.Quote_Line_Item_ID__c     = qli.Id;
                log.Implementation_Case_Id__c = ImplcaseId;
                log.Product_Name__c           = qli.ProductName__c;
                log.Request_Message__c        = JSON.serialize(request);
                log.Response_Message__c       = JSON.serialize(response);
                log.Status_Code__c            = Integer.valueOf(response.status.code) >= 200 && Integer.valueOf(response.status.code) < 300 &&
                   								response.contractCode != null && response.contractCode != request.baseContract? 'SUCCESS': 'ERROR';
                log.Status_Message__c         = response.Status.message;
                log.Service_Response_Code__c  = response.Status.Code;
                log.Transaction_ID__c         = request.transactionId;
                log.Transaction_Timestamp__c  = request.transactionTimestamp;
                log.Contract_Code__c          = response.ContractCode != null ?response.contractCode:'';
                
                ServicecallLogs.add(log);
                
                //Add Response status to the return List
                responseList.add(response);
                System.debug(response);
            }
        }
        }
        if(qliListtoUpdate.size()>0){
            update qliListtoUpdate;
        }
        if(ServicecallLogs.size()>0){
            insert ServicecallLogs;
        }
        if(NoOfFailures>0){
            finalStr = finalStr + String.join(errorStringRows, '\n');
            sendEmail(finalStr, NoOfFailures, NoOfSuccesses);
        }
        
        if(!ImpCase.CC_Service_Invoked__c && response.transactionTimestamp!=null){
            ImpCase.CC_Service_Invoked__c = true;
            update ImpCase;
            System.debug(Impcase.CC_Service_Invoked__c);
        }
       
       return responseList;
    }
    
    public static void sendEmail(String AttachmntBody, Integer NoOfFailures, Integer NoOfSuccesses){
        ServiceInterface__mdt mdt = [Select Id, AttachmentName__c, ToEmailList__c, EmailDisplayName__c, EmailSubject__c, FromEmailId__c From ServiceInterface__mdt Where Label = 'CCReservation Integration']; 
        List<Messaging.EmailFileAttachment> attchmntsList = new List<Messaging.EmailFileAttachment>();
        
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
       // finalStr = finalStr + String.join(errorStringRows, '\n');
        Blob csvBlob = Blob.valueOf(AttachmntBody);
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
        String body = 'Number of QLIs Processed Successfully: '+NoOfSuccesses + '<br/>';
        body += 'Number of QLIs failed : '+NoOfFailures + '<br/>';
        email.setHtmlBody(body);
        email.setFileAttachments(attchmntsList);
        Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});        
            
    }
        
}