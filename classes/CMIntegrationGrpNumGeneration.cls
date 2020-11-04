public class CMIntegrationGrpNumGeneration {
	
    //This method makes a service callout to the group number creation service 
    public static String generateGroupNumber(String quoteId, String reqGroupNumber){
        Map<String, List<Group__c>> groupClmSysMap = new Map<String, List<Group__c>>();
        Set<String> productTypes = new Set<String>();
        
        // Get account details from quote
        List<Quote> quote = [Select Id, AccountId, Account_Name__c, Opportunity.Account.Situs_State_Abbrev__c, GroupNumber__c
                             FROM Quote
                             WHERE Id =: quoteId];
        
        // Get existing group numbers for WGS and Compass
         List<Group__c> groupList = [Select Id, ClaimSystem__c, Name
                                        FROM Group__c
                                   		WHERE Account__c =: quote[0].AccountId
                                      	AND IsActive__c = True
                                        AND ClaimSystem__c IN (:CMIntegrationConstants.CLAIM_SYSTEM_COMPASS, :CMIntegrationConstants.CLAIM_SYSTEM_WGS)];
           
        //Build claim system to group number list map      
            if(groupList.Size()>0){
            	for(Group__c grp: groupList){
                    String clmSystem = grp.ClaimSystem__c == CMIntegrationConstants.CLAIM_SYSTEM_WGS? CMIntegrationConstants.SOURCE_SYSTEM_WGS : grp.ClaimSystem__c;
                    if(!groupClmSysMap.containsKey(clmSystem)){
                        groupClmSysMap.put(clmSystem, new List<Group__c>{grp});
                    }else{
                        List<Group__c> grpList = groupClmSysMap.get(clmSystem);
                        grpList.add(grp);
                        groupClmSysMap.put(clmSystem, grpList);
                    }
            	}
            }
       System.debug('Group Map:  '+groupClmSysMap.size());
        
       Integration_Event_Log__c eventLog = new Integration_Event_Log__c();
       eventLog.Process_Name__c = CMIntegrationConstants.LOG_GROUPREQ_NAME;
       eventLog.Event_Type__c   = CMIntegrationConstants.EVENT_TYPE_CREATEEXTID;
       eventLog.Transaction_Date_Time__c = System.now();
       eventLog.Quote__c        =  quote[0].Id; 
       
        // Validate if more than one active group number exist for given claim system
        if(!groupClmSysMap.isEmpty()){
            for(String clmSys : groupClmSysMap.keySet()){
                if(groupClmSysMap.get(clmSys).size()>1){
                    eventLog.Status_Message__c  = 'More than one group records exist for claim system '+ clmSys;
                    eventLog.Tracking_ID__c = 'CM_'+Datetime.now().formatGMT('yyyyMMddHHmmssSSS') + Integer.valueof(10000 + (Math.random() * 10000));
                    //To-DO set error code as - SFDC-ERR-F0001
                    String eventLogId = logvalidationErrorLog(eventLog, CMIntegrationConstants.FUNCTIONAL_ERROR, 'SFDC-ERR-F0001');
                  return eventLogId;
                }
            }
        }
        
        //Get QLIs related to this quote to send all the product Types
        List<QuoteLineItem> qliList = [SELECT Id, Product_Type__c
                                       FROM QuoteLineItem
                                       WHERE quoteId =: quoteId
                                       AND ProductStage__c IN : CMIntegrationConstants.PRODUCT_STAGES];  
        
        //Get the corresponding CM Mapping value from Metadata and add it to product types
        if(qliList != null && qliList.size()>0){
            for(QuoteLineItem qli: qliList){
                String cmProdTypemapping = ServiceIntegrationMappingUtility.getExternalSystemValue(CMIntegrationConstants.INTEGRATION_NAME, CMIntegrationConstants.FIELD_PRODCTTYPE,qli.Product_Type__c);
                if(cmProdTypemapping != null){
                   productTypes.add(cmProdTypemapping); 
               }
            }
        } 
        
        if(productTypes.size() == 0){
            eventLog.Status_Message__c  = 'No Quote Line Items with the required criteria exists to request a group number';
            eventLog.Tracking_ID__c = 'CM_'+Datetime.now().formatGMT('yyyyMMddHHmmssSSS') + Integer.valueof(10000 + (Math.random() * 10000));
           // Error code SFDC-ERR-F0002        
            String eventLogId = logvalidationErrorLog(eventLog, CMIntegrationConstants.FUNCTIONAL_ERROR,'SFDC-ERR-F0002');
            return eventLogId;
        }
        //build request message       
        CMGroupNumberRequest groupNoRequest = buildGroupNoRequest(reqGroupNumber, quote[0], productTypes, groupClmSysMap);
        
        eventLog.Tracking_ID__c  = groupNoRequest.eventMetaData.trackingId;
        eventLog.System_Name__c  = groupNoRequest.eventMetaData.sourceSystemId;
        
        //Make the callout to endpoint
        CMIntegrationUtility utility = new CMIntegrationUtility();
        CMIntegrationUtility.StatusDetails retStatus= utility.sendGroupNumberRequestInfo(groupNoRequest);
        CMGroupNumberResponse response; 
        
        if(retStatus.response!=null && retStatus.response.responseMsg != null){
         	response = retStatus.response;   
        }else{
             String errorMsg = 'Group number generation failed, Invalid response payload – Error Message: '+ retStatus.statusMessage;
             eventLog.Status_Message__c = errorMsg.length() > 255 ? errorMsg.substring(0, 255) : errorMsg;
             //Error code SFDC-ERR-T0001
             // To-Doinsert eventLog Error
             String eventLogId = logValidationErrorLog(eventLog, CMIntegrationConstants.TECHNICAL_ERROR,'SFDC-ERR-T0001');
             createCMGrpNoReqAttchmnt(groupNoRequest, eventLog);
             
            //Attach Raw Response to the integration event Log  
            if(retStatus.rawResponse != null){
                createRawResponseAttachment(retStatus.rawResponse, eventLog);
            }
            return eventLogId;
        }
        
        String eventLogId = processGroupNumberResponse(response, eventLog, quote[0], groupClmSysMap, qliList);
       
        createCMGrpNoReqAttchmnt(groupNoRequest, eventLog);
       // createCMGrpNoRespAttchmnt(response, eventLog);
         
        //Attach Raw Response to the integration event Log
        if(retStatus.rawResponse != null){
            createRawResponseAttachment(retStatus.rawResponse, eventLog);
        }
        
        return eventLogId;
    }
    
    public static CMGroupNumberRequest buildGroupNoRequest(String reqGroupNumber, Quote qte, Set<String> productTypes, Map<String, List<Group__c>> groupClmSysMap){
    
        String wgsGroupId 		= groupClmSysMap.size()>0 && groupClmSysMap.containsKey('WGS')? groupClmSysMap.get('WGS')[0].Name : null;
        String compassGroupId 	= groupClmSysMap.size()>0 && groupClmSysMap.containsKey(CMIntegrationConstants.CLAIM_SYSTEM_COMPASS)? groupClmSysMap.get(CMIntegrationConstants.CLAIM_SYSTEM_COMPASS)[0].Name : null;
        
        System.debug('wgsGroupId:  '+wgsGroupId);
        System.debug('compassGroupId:  '+compassGroupId);
        
         User currentUser = [select FederationIdentifier, Rep_ID_Code__c
                            from User 
                            where id =:UserInfo.getUserId()];
        
        //Build Group No Request
        CMGroupNumberRequest groupNoRequest = new CMGroupNumberRequest();
        CMGroupNumberRequest.cls_eventMetaData eventMetaData = new CMGroupNumberRequest.cls_eventMetaData();
        
        groupNoRequest.eventMetaData = eventMetadata;
        eventMetaData.userId = currentUser.FederationIdentifier;
        eventMetaData.sourceSystemId = CMIntegrationConstants.SOURCE_SYSTEM_SFDCCOM2;
        eventMetaData.trackingId = 'CM_'+Datetime.now().formatGMT('yyyyMMddHHmmssSSS') + Integer.valueof(10000 + (Math.random() * 10000));
        eventMetaData.eventType = CMIntegrationConstants.EVENT_TYPE_CREATEEXTID;
        
        CMGroupNumberRequest.cls_customerInfo customerInfo = new CMGroupNumberRequest.cls_customerInfo();
        groupNoRequest.customerInfo     = customerInfo;
        customerInfo.accountId 			= qte.AccountId;
        customerInfo.customerName 		= qte.Account_Name__c;
        customerInfo.state 				= qte.Opportunity.Account.Situs_State_Abbrev__c;
        customerInfo.productTypes 		= new List<String>(productTypes);
        customerInfo.marketSegment 		= 'LG';
        customerInfo.requestedWgsCaseId = reqGroupNumber;
        customerInfo.existingCaseId     = wgsGroupId != null && !wgsGroupId.equalsIgnoreCase('TBD') ? wgsGroupId : null;
        customerInfo.existingSchemeId   = compassGroupId != null && !compassGroupId.equalsIgnoreCase('TBD') ? compassGroupId : null;    
        
			System.debug('Group Number Request :'+ JSON.serializePretty(groupNoRequest));
        return groupNoRequest;
    }
    
    public static String processGroupNumberResponse(CMGroupNumberResponse response, Integration_Event_Log__c eventLog, Quote qte, 
                                                    Map<String, List<Group__c>> groupClmSysMap, List<QuoteLineItem> qliList){
  
        Map<String, String> prodctTypeGrpNumbrMap  = new Map<String, String>();
        Map<String, String> prodctTypeClaimSysMap  = new Map<String, String>();                                               
        
        String validationMsg = validateGroupNumberResponse(response);
        if(validationMsg != 'SUCCESS'){
            eventLog.Status_Message__c = validationMsg;
            
            String eventLogId = logValidationErrorLog(eventLog, CMIntegrationConstants.TECHNICAL_ERROR,'SFDC-ERR-T0002'); 
            return eventLogId;
        }                                                                                                
                                                        
        if(response.responseMsg.statusCode.equalsIgnoreCase('SUCCESS') || response.responseMsg.statusCode.equalsIgnoreCase('PARTIAL SUCCESS')){                       
            List<Group__c> groupsToUpsert = new List<Group__c>();
            
            //Validate and process group numbers returned in CM response
                for(CMGroupNumberResponse.cls_externalNumber extNo : response.responseMsg.externalNumber){
                    Group__c grp;
                    if(groupClmSysMap.containsKey(extNo.claimSystem) && groupClmSysMap.get(extNo.claimSystem)[0].Name.equalsIgnoreCase('TBD')){
                        grp      = groupClmSysMap.get(extNo.claimSystem)[0];
                        grp.Name = extNo.id;
                        groupsToUpsert.add(grp);
                    }
                    else if(groupClmSysMap.containsKey(extNo.claimSystem) && !extNo.id.equalsIgnoreCase(groupClmSysMap.get(extNo.claimSystem)[0].Name)){
                        //SFDC Error Code = SFDC-ERR-F0003
                        eventLog.Status_Message__c = 'Group number '+ groupClmSysMap.get(extNo.claimSystem)[0].Name+' already exists for this claim System '+ extNo.claimSystem;
                     
            			String eventLogId = logValidationErrorLog(eventLog, CMIntegrationConstants.FUNCTIONAL_ERROR,'SFDC-ERR-F0003'); 
            			return eventLogId; 
                    }
                    else if(!groupClmSysMap.containsKey(extNo.claimSystem)){
                       grp = new Group__c(Name = extNo.id, Account__c = qte.AccountId, IsActive__c = True); 
                       grp.ClaimSystem__c = extNo.claimSystem == 'WGS' ? CMIntegrationConstants.CLAIM_SYSTEM_WGS : extNo.claimSystem;
                       groupClmSysMap.put(extNo.claimSystem, new List<group__c>{grp}); 
                       groupsToUpsert.add(grp);
                    }
                    
                    if(!prodctTypeGrpNumbrMap.containsKey(extNo.productType)){
                      prodctTypeGrpNumbrMap.put(extNo.productType, extNo.id);  
                      prodctTypeClaimSysMap.put(extNo.productType, extNo.claimSystem);
                    }
                    else if(prodctTypeGrpNumbrMap.containsKey(extNo.productType) && extNo.id != prodctTypeGrpNumbrMap.get(extNo.productType)){       
                        eventLog.Status_Message__c = 'More than one case numbers linked to same product type '+extNo.productType;
           
            			String eventLogId = logValidationErrorLog(eventLog, CMIntegrationConstants.FUNCTIONAL_ERROR,'SFDC-ERR-F0004'); 
            			return eventLogId;     
                        	//SFDC Error Code = SFDC-ERR-F0004
                	}
           	 	} 
           
            if(groupsToUpsert.size() >0){
            Database.upsert(groupsToUpsert);
            }
               
            List<QuoteLineItem> qliListToUpdate = new List<QuoteLineItem>(); 
            //Update quoteLineItem group lookup 
           for(QuoteLineItem qli : qliList){
                  String cmMapProdType =  ServiceIntegrationMappingUtility.getExternalSystemValue(CMIntegrationConstants.INTEGRATION_NAME, CMIntegrationConstants.FIELD_PRODCTTYPE, qli.Product_Type__c);    
					if(cmMapProdType != null && prodctTypeClaimSysMap.containsKey(cmMapProdType)){
                	qli.Group__c = groupClmSysMap.get(prodctTypeClaimSysMap.get(cmMapProdType))[0].Id;
					qliListToUpdate.add(qli);
				   }
            }
             
            //Update Global Customer Id on account
            Account accnt = new Account(Id = qte.AccountId, Global_Customer_ID__c = response.responseMsg.globalCustomerNumber);
            Database.update(accnt);
            
           if(qliListToUpdate.size()>0){
               Database.update(qliListToUpdate);
            }
           //Get the respective group numbers and claim systems from the map 
           List<AggregateResult> agrList = [SELECT Count(Id) cnt, Group__r.name, Group__r.ClaimSystem__c, Group__r.Id
                                        	FROM QuoteLineItem
                                        	WHERE Group__r.ClaimSystem__c != null 
                                            AND QuoteId =: qte.Id
                                            AND ProductStage__c IN : CMIntegrationConstants.PRODUCT_STAGES
                                            GROUP BY Group__r.name, Group__r.ClaimSystem__c, Group__r.Id 
                                        	ORDER By Group__r.ClaimSystem__c desc];
               
               if(agrList.size() >0){
                   for(AggregateResult agr: agrList){
                       String clmSys = (String)agr.get('ClaimSystem__c');
                       if(clmSys.equalsIgnoreCase(CMIntegrationConstants.CLAIM_SYSTEM_WGS)){
                           qte.GroupNumber__c = (String)agr.get('Id');
                           break;
                       }
                       else{
                           qte.GroupNumber__c = (String)agr.get('Id');
                       }
                   }
               }
            Database.update(qte);        
        }
                                                        
         if(response.responseMsg.statusCode == 'FAILURE' || response.responseMsg.statusCode == 'PARTIAL SUCCESS'){
            
            String eventLogId = logErrors(response, eventLog);
            return eventLogId;
        }                                                
         eventLog.Status__c = 'SUCCESS';
         eventLog.Status_Message__c = 'Group number generation request processed successfully';                                               
         Database.insert(eventLog);  
                                                        
        return eventLog.Id;
    }
    
    //Validate group number generation response
    public static String validateGroupNumberResponse(CMGroupNumberResponse response) {
        //Validate Status code. StausCode should not be null. It should be 'FAILURE','PARTIAL SUCCESS', 'SUCCESS'
        //if StatusCode = 'SUCCESS' or 'PARTIAL SUCCESS' then at least one external numbers record should be present
        //For each external number record, productType,Id, Claimsystem should not be blank
        
        List<String> statusCodesList = new List<String>{'SUCCESS', 'FAILURE','PARTIAL SUCCESS'};           
        if(response.responseMsg != null && (String.isBlank(response.responseMsg.statusCode)  || !statusCodesList.contains(response.responseMsg.StatusCode))){
			return 'Error - Invalid Status Code found in the response';
        }
        else if((response.responseMsg.StatusCode.equalsIgnoreCase('SUCCESS') || response.responseMsg.StatusCode.equalsIgnoreCase('PARTIAL SUCCESS')) 
                && (response.responseMsg.externalNumber == null || (response.responseMsg.externalNumber != null && response.responseMsg.externalNumber.size() == 0))){
            return 'Error - Missing external numbers for Success scenario';
        }
        else {
            List<CMGroupNumberResponse.cls_externalNumber> extNumbers = response.responseMsg.externalNumber;
            if(extNumbers != null && extNumbers.size() > 0){
                for(CMGroupNumberResponse.cls_externalNumber extNo : extNumbers){
                    if(String.isBlank(extNo.productType) || String.isBlank(extNo.claimSystem) || String.isBlank(extNo.id)){
                        return 'Error - Missing Product Type or Claim System or Id for external numbers in the response'; 
                    }
                }
            }
        }
        
        return 'SUCCESS';
    }
    
    public static String logErrors(CMGroupNumberResponse response, Integration_Event_Log__c eventLog){
        List<CMGroupNumberResponse.cls_listOfErrorCodes> errorCodesList = response.responseMsg.responseDetails.listOfErrorCodes;
         String errorMsg;
        
        eventLog.Status__c = response.responseMsg.statusCode;
        eventLog.Status_Message__c = 'Group number generation failed';
        Database.insert(eventLog);  
        
         List<Integration_Error_Log__c> errorLogs = new List<Integration_Error_Log__c>();  
          if(errorCodesList != null && errorCodesList.size() >0){
            for(CMGroupNumberResponse.cls_listOfErrorCodes errorCode: errorCodesList){
                Integration_Error_Log__c errorLog = new Integration_Error_Log__c();
                errorLog.Category__c    			= errorCode.category;
                errorLog.Error_Code__c  			= errorCode.errorCode;
                errorLog.Binding_Field__c			= errorCode.bindingField;
                errorLog.Entity_Name_c__c 			= errorCode.entityName;
                errorLog.Error_Message__c 			= errorCode.errorMessage;
                errorLog.Integration_Event_Log__c 	= eventLog.Id;
                
                errorMsg = errorMsg != null ? errorMsg + ' - '+errorCode.errorMessage : errorCode.errorMessage;
                errorLogs.add(errorLog);
            }
        }         
           
            if(errorLogs.size()>0){
                Database.insert(errorLogs);
            }
          return eventLog.Id;  
    }
    
    public static String logValidationErrorLog(Integration_Event_Log__c eventLog, String category, String errorCode){ 
        	
        eventLog.Status__c ='FAILURE';
        Database.insert(eventLog);
        
          Integration_Error_Log__c errorLog = new Integration_Error_Log__c();
        	errorLog.Category__c    			= category;
            errorLog.Error_Code__c  			= errorCode;
            errorLog.Error_Message__c 			= eventLog.Status_Message__c;
            errorLog.Integration_Event_Log__c 	= eventLog.Id;
        
        Database.insert(errorLog);
        
        return eventLog.Id;
    }
    
    public static void createCMGrpNoReqAttchmnt(CMGroupNumberRequest groupNoRequest, Integration_Event_Log__c eventLog){
        		Attachment att = new Attachment();
                att.Body = Blob.valueOf(JSON.serializePretty(groupNoRequest, true));
                att.Name = 'CMgrpNmbrRequestPayload_'+eventLog.Tracking_ID__c + '.txt';
                att.parentId = eventLog.id;
                insert att; 
    }
  /*  public static void createCMGrpNoRespAttchmnt(CMGroupNumberResponse response, Integration_Event_Log__c eventLog){
        		Attachment att = new Attachment();
                att.Body = Blob.valueOf(JSON.serializePretty(response));
                att.Name = 'CMgrpNmbrResponsePayload_'+eventLog.Tracking_ID__c + '.txt';
                att.parentId = eventLog.id;
                insert att; 
    } */
    
    public static void createRawResponseAttachment(String rawResponse, Integration_Event_Log__c eventLog){
        		Attachment att = new Attachment();
                att.Body = Blob.valueOf(rawResponse);
                att.Name = 'CMgrpNmbrRawResponse_'+eventLog.Tracking_ID__c + '.txt';
                att.parentId = eventLog.id;
                insert att; 
    }    
}