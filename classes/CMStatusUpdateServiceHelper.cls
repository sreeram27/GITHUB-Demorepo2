public class CMStatusUpdateServiceHelper {
     
    static final String SFDC_SYSTEM_CONST =CMIntegrationConstants.SOURCE_SYSTEM_SFDCCOM2;
    //static final String WGS_SYSTEM_CONST = CMIntegrationConstants.SOURCE_SYSTEM_C;
    static final String COMPASS_SYSTEM_CONST =CMIntegrationConstants.CLAIM_SYSTEM_COMPASS;
    static final String CM_SYSTEM_CONST = CMIntegrationConstants.SOURCE_SYSTEM_CM;
    static final String WGS_CLMSYS_CONST = 'WGS 2.0';
    static final String CMWGS_CLMSYS_CONST ='WGS';
    static final String COMPASS_CLMSYS_CONST = CMIntegrationConstants.CLAIM_SYSTEM_COMPASS ;
    static final String EVENT_TYPE_PREVIEW = CMIntegrationConstants.TRANSACTION_TYPE_PREVIEW;
    static final String EVENT_TYPE_ADD = CMIntegrationConstants.EVENT_TYPE_ADD;
    static final String EVENT_TYPE_MAINT = CMIntegrationConstants.EVENT_TYPE_MAINTENANCE;
    static final String MAINT_TYPE_ADD_PRODUCT =CMIntegrationConstants.ADD_PRODCT_MAINT;
    static final String EVENT_TYPE_IDCARDREQUEST =CMIntegrationConstants.EVENT_TYPE_IDCARDREQUEST;
    public enum ResponseType {ACCOUNT_STRUCTURE,IDCARD_REQUEST,OTHER}

    
  //      public static final String SOURCE_SYSTEM_SFDCCOM2 = 'SFDCCOM2';
  //  public static final String SOURCE_SYSTEM_WGS = 'WGS';
   // public static final String SOURCE_SYSTEM_CM = 'CM';
        //public static final String TRANSACTION_TYPE_PREVIEW = 'Preview';
    //public static final String TRANSACTION_TYPE_ADDUPDATE = 'AddUpdate';
    //public static final String EVENT_TYPE_ADD = 'addCustomer';
    //public static final String EVENT_TYPE_MAINTENANCE = 'Maintenance';
    //public static final String EVENT_TYPE_IDCARDREQUEST = 'IDCardrequest';
    
    
    public static CMUpdateStatusDetails updateResponse(String cmResponseString){
        
        CMUpdateStatusDetails retStatus = new CMUpdateStatusDetails();
        CMResponse response = new CMResponse();
        Integration_Event_Log__c eventLog;
        // Parse response payload and log any message parsing error in event log
        try{
            
            if(cmResponseString != null){
                response = (CMResponse)JSON.deserialize(cmResponseString, CMResponse.class);
            }
            retStatus = validateEventMeta(response);
            if(retStatus.Status=='ERROR'){ 
                //throw new Exceptions.SystemException('Invalid response payload');
                eventLog    = logInvalidPayload(cmResponseString,'Invalid response payload.'+retStatus.StatusMessage);
                createAttachment(cmResponseString, eventLog);
                retStatus.status = 'ERROR';
                retStatus.statusMessage = 'Invalid response payload.'+retStatus.StatusMessage;
                sendEmail(cmResponseString,retStatus.status,retStatus.statusMessage);
                return retStatus;
            } 
        }catch(Exception ex){
            //Insert event log record for this response message
            
            eventLog    = logInvalidPayload(cmResponseString,ex.getMessage());
            
            //Load payload as attachment to event log record
            createAttachment(cmResponseString, eventLog);
            retStatus.status = 'ERROR';
            retStatus.statusMessage = 'Exception occured: '+ex.getMessage();
            sendEmail(cmResponseString,retStatus.status,retStatus.statusMessage);
            return retStatus;
        }
        
        try{
            //Insert event log record for this response message
            
            
            eventLog    = logEvent(response);
            
            //Load payload as attachment to event log record
            createAttachment(cmResponseString, eventLog);
            
            //Insert error log records
            logErrors(response, eventLog );
            
            //List<CMResponse.cls_ids> customerIdsList;//  =  response.responseMsg[0].responseDetails.accountInfo.CustomerInfo.customers[0].ids; 
            //CMResponse.cls_responseDetails respDetails
            
            //If success, update group suffix on group plan design record ang wgs group number on group record
            if(response.responseMsg[0].statusCode == 'SUCCESS'){
                ResponseType respType = getResponseType(eventLog.Event_Type__c,eventLog.Implementation_Case__c);
                if(respType==ResponseType.ACCOUNT_STRUCTURE && eventLog.System_Name__c ==CM_SYSTEM_CONST){
                    retStatus=processAccountStructure(response); 
                    if(retStatus.status=='ERROR'){
                       eventLog.status__c = 'FAILURE';
                       eventLog.Status_Message__c = 'Error while processing response payload.'+retStatus.statusMessage ;
                       Database.update(eventLog);
                       sendEmail(cmResponseString,retStatus.status,retStatus.statusMessage);
                       return retStatus;  
                    } 
                   }else if(respType==ResponseType.IDCARD_REQUEST){
                        processIDCardResponse(response,eventLog.Implementation_Case__c);
                   }
            }
            retStatus.status = 'SUCCESS';
            retStatus.statusMessage = 'Response from CM is processed successfully';  
            sendEmail(cmResponseString,retStatus.status,retStatus.statusMessage);
        }catch(Exception ex){
            if(eventLog!=null){
                eventLog.status__c = 'FAILURE';
                eventLog.Status_Message__c = 'Error while processing response payload.'+'Exception occured:'+ex.getMessage() ;
                Database.update(eventLog);
            }   
            //Load payload as attachment to event log record
            retStatus.status = 'ERROR';
            retStatus.statusMessage = 'Exception occured: '+ex.getMessage();
            sendEmail(cmResponseString,retStatus.status,retStatus.statusMessage);
        }    
        return retStatus;
    }
    
    
    public static void logErrors(CMResponse response, Integration_Event_Log__c eventLog ){
        if(response.responseMsg[0].statusCode == 'FAILURE'){
            List<CMResponse.cls_listOfErrorCodes> errorCodesList = response.responseMsg[0].responseDetails.listOfErrorCodes;
            
            
            List<Integration_Error_Log__c> errorLogs = new List<Integration_Error_Log__c>();
            
            for(CMResponse.cls_listOfErrorCodes errorCode: errorCodesList){
                Integration_Error_Log__c errorLog = new Integration_Error_Log__c();
                errorLog.Category__c                = errorCode.category;
                errorLog.Error_Code__c              = errorCode.errorCode;
                errorLog.Binding_Field__c           = errorCode.bindingField;
                errorLog.Entity_Name_c__c           = errorCode.entityName;
                errorLog.Error_Message__c           = errorCode.errorMessage;
                errorLog.Implementation_Case__c     = eventLog.Implementation_Case__c;
                errorLog.Integration_Event_Log__c   = eventLog.Id;
                
                errorLogs.add(errorLog);
            }
            
            if(errorLogs.size()>0){
                Database.insert(errorLogs);
            }
        }
    }
    
    
    public static CMUpdateStatusDetails validateEventMeta(CMResponse response) {
        CMUpdateStatusDetails retStatus = new CMUpdateStatusDetails();
        retStatus.Status = 'SUCCESS';
        if((response.eventMetaData==null)){
            retStatus.Status = 'ERROR';
            retStatus.StatusMessage = 'Event metadata is missing';
        } else if(String.isBlank(response.eventMetaData.sourceSystemId)||String.isBlank(response.eventMetaData.trackingId)
           ||String.isBlank(response.eventMetaData.eventType)||response.responseMsg==null ){
            retStatus.Status = 'ERROR';
            retStatus.StatusMessage = 'Key data elements in event metadata is missing';
               
        }else if(!response.eventMetaData.eventType.equalsIgnoreCase(EVENT_TYPE_PREVIEW)
                     &&!response.eventMetaData.eventType.equalsIgnoreCase(EVENT_TYPE_ADD)
                     &&!response.eventMetaData.eventType.equalsIgnoreCase(EVENT_TYPE_MAINT)
                     &&!response.eventMetaData.eventType.equalsIgnoreCase(EVENT_TYPE_IDCARDREQUEST)){
                         
                retStatus.Status = 'ERROR';
                retStatus.StatusMessage = 'Invalid event type in response payload.';

           } else if(response.responseMsg.Size()==0){
                retStatus.Status = 'ERROR';
                retStatus.StatusMessage = 'Missing status code or system id in response payload.';

        }else if(String.isBlank(response.responseMsg[0].statusCode)||String.isBlank(response.responseMsg[0].systemID)){
           //||String.isBlank(response.responseMsg[0].accountID)){
                retStatus.Status = 'ERROR';
                retStatus.StatusMessage = 'Missing status code or system id in response payload.';

        }
        List<Integration_Event_Log__c> reqEventLog = new List<Integration_Event_Log__c>();
        //Retring 5 times to introduce some delay in case request record is not committed before
        // response is received due to asynchronous nature of this process. This should happen in very rare case.
        for(Integer i=0;i<5;i++){
               reqEventLog = [Select Id, Implementation_Case__c
                                                      FROM Integration_Event_Log__c
                                                      WHERE Tracking_ID__c =:response.eventMetaData.trackingId
                                                      AND System_Name__c =:SFDC_SYSTEM_CONST
                                                      AND Status__c ='SUCCESS'
                                                      ORDER BY CreatedDate DESC
                                                      LIMIT 1];
               if(reqEventLog.size()>0) break;
        
        }
        
        if(reqEventLog.size()==0){
                retStatus.Status = 'ERROR';
                retStatus.StatusMessage = 'Not able to find corresponding request message with tracking id-'+response.eventMetaData.trackingId+' in event log.';
        }

        return retStatus;
    }
    
    public static Integration_Event_Log__c logEvent(CMResponse response ) {
        Integration_Event_Log__c eventLog   = new Integration_Event_Log__c();
        if(response.eventMetaData != null){
            eventLog.System_Name__c             = response.eventMetaData.sourceSystemId;
            eventLog.System_Name__c             = response.responseMsg[0].SystemId;
            eventLog.Tracking_ID__c             = response.eventMetaData.trackingId;
            eventLog.Event_Type__c              = response.eventMetaData.eventType;
            eventLog.Master_ID__c               = response.eventMetaData.masterId;
            eventLog.Sub_Tracking_ID__c         = response.eventMetaData.subTrackingId;
        }
        eventLog.Transaction_Date_Time__c   = System.now();
        eventLog.Status__c                  = response.responseMsg[0].statusCode; // To confirm if we've multiple response msgs in single JSON
        eventLog.Status_Message__c          = response.responseMsg[0].statusMsg;
        eventLog.Process_Name__c            = 'CM Integration Response';
        
        
        //Retrieve implementation case id from input event log for this tracking id
                
        List<Integration_Event_Log__c> reqEventLog = [Select Id, Implementation_Case__c
                                                      FROM Integration_Event_Log__c
                                                      WHERE Tracking_ID__c =:response.eventMetaData.trackingId
                                                      AND System_Name__c =:SFDC_SYSTEM_CONST
                                                      AND Status__c ='SUCCESS'
                                                      ORDER BY CreatedDate DESC
                                                      LIMIT 1];
        
        if(reqEventLog.size()>0){
            eventLog.Implementation_Case__c   =  reqEventLog[0].Implementation_Case__c;
        }
        Database.insert(eventLog);
        return eventLog;
        
    }
    public static Integration_Event_Log__c logInvalidPayload(String response, String errorMsg ) {
        Integration_Event_Log__c eventLog   = new Integration_Event_Log__c();
        eventLog.System_Name__c             = SFDC_SYSTEM_CONST;
        eventLog.Tracking_ID__c             = 'CM_'+Datetime.now().formatGMT('yyyyMMddHHmmssSSS') + Integer.valueof(10000 +(Math.random() * 10000));
        eventLog.Event_Type__c              = 'Invalid response from CM';
        eventLog.Transaction_Date_Time__c   = System.now();
        eventLog.Status__c                  = 'FAILURE'; 
        eventLog.Status_Message__c          = errorMsg;
        eventLog.Process_Name__c = 'CM Integration Response';   
        Database.insert(eventLog);
        return eventLog;
        
    }
    public static ResponseType getResponseType(String eventType, String orderId){
        ResponseType respType =ResponseType.OTHER ;
        
        if(eventType==EVENT_TYPE_PREVIEW||eventType==EVENT_TYPE_ADD){
            respType = ResponseType.ACCOUNT_STRUCTURE;
        } else if(eventType==EVENT_TYPE_MAINT){
            
            List<Order> odList = [select  Maintenance_Reason_Customer_Master__c
                                  from Order 
                                  where id =:orderId Limit 1];
            if(odList.size()>0){
                if(odList[0].Maintenance_Reason_Customer_Master__c.contains(MAINT_TYPE_ADD_PRODUCT)){
                    respType = ResponseType.ACCOUNT_STRUCTURE ;
                }
            }
        } else if(eventType == EVENT_TYPE_IDCARDREQUEST){
            respType = ResponseType.IDCARD_REQUEST;
        }
        return respType;
        
    }
    public static CMUpdateStatusDetails processAccountStructure(CMResponse response){
        String grpPlanDesignId;
        String wgsGroupNumber;
        String lndCaseNumber;
        String grpSuffixId;
        String sfdcAccountId;
        String globalCustomerId;
        //Get WGS group number from the response 
        CMUpdateStatusDetails retStatus = new CMUpdateStatusDetails();
        List<CMResponse.cls_ids> customerIdsList;//  =  response.responseMsg[0].responseDetails.accountInfo.CustomerInfo.customers[0].ids; 
        CMResponse.cls_responseDetails respDetails = response.responseMsg[0].responseDetails;
        if(respDetails!=null && respDetails.accountInfo !=null && respDetails.accountInfo.CustomerInfo!=null
           && respDetails.accountInfo.CustomerInfo.customers!=null&&respDetails.accountInfo.CustomerInfo.customers.size() >0
           &&respDetails.accountInfo.CustomerInfo.customers[0].ids!=null){
               
               //Get all the key ids from response message
               customerIdsList =response.responseMsg[0].responseDetails.accountInfo.CustomerInfo.customers[0].ids; 
               
               for(CMResponse.cls_ids idSec: customerIdsList){
                   if(idSec.name == 'accountId' && idSec.sourceSystem ==SFDC_SYSTEM_CONST){
                       sfdcAccountId = idSec.value; 
                       System.debug('Salesforce account id: '+ sfdcAccountId);
                   }
                   if(idSec.name == 'globalCustomerId' && idSec.sourceSystem ==CM_SYSTEM_CONST){
                       globalCustomerId = idSec.value; 
                       System.debug('CM Global Customer Id: '+ globalCustomerId);
                       
                   }
                   
               }
               //TODO: Validate Account Id
               
           }
        
        
        //Get bill group records from the response
        Map<String,String> billGroupMap = new Map<String,String>(); //map of sfdc bill group id to CM bill group id
        Map<String,String> billGroupSuffixMap = new Map<String,String>();//map of group suffixes to CM bill group id
        
        buildGroupConfig(billGroupMap,billGroupSuffixMap,response);
        
        System.debug('Bill Group Map :'+billGroupMap);
        System.debug('Bill Group Suffix Map:'+billGroupSuffixMap);
        Map<String,Group__c> grpUpdateMap = new Map<String,Group__c>();
        List<Group_Plan_Design__c> grpPlanDesignsListToUpdate = new List<Group_Plan_Design__c>();
        
        retStatus = buildGPDListforUpdate(billGroupMap,billGroupSuffixMap,grpUpdateMap,grpPlanDesignsListToUpdate,sfdcAccountId,response);
        if(retStatus.Status=='ERROR') return retStatus;        
        updateGroupStructure(sfdcAccountId,globalCustomerId,  billGroupMap,grpUpdateMap,grpPlanDesignsListToUpdate );
        retStatus.Status = 'SUCCESS';
        return retStatus;

    }
    
    public static void buildGroupConfig(Map<String,String>billGroupMap,Map<String,String>billGroupSuffixMap,CMResponse response){
        String sfdcBillGroupId;
        String cbpBillGroupId;
        CMResponse.cls_responseDetails respDetails = response.responseMsg[0].responseDetails;
        List<CMResponse.cls_AccountBillGroups> accountBillGroupsList;
        if(respDetails!=null && respDetails.accountInfo !=null && respDetails.accountInfo.AccountBillGroups!=null
           &&respDetails.accountInfo.AccountBillGroups.size() >0){
               
               accountBillGroupsList =response.responseMsg[0].responseDetails.accountInfo.AccountBillGroups; 
               
               
           }
        
        if(accountBillGroupsList!=null&&accountBillGroupsList.size()>0){
            for(CMResponse.cls_AccountBillGroups accBillGrp : accountBillGroupsList){
                List<CMResponse.cls_ids> billGroupIdsList = accBillGrp.ids;
                for(CMResponse.cls_ids idSec: billGroupIdsList){
                    if(idSec.name == 'sfdcBillGroupId' && idSec.sourceSystem ==SFDC_SYSTEM_CONST){
                        sfdcBillGroupId = idSec.value; 
                        System.debug('Salesforce bill group Id: '+ sfdcBillGroupId);
                    }
                    else if(idSec.name == 'billGroupId' && idSec.sourceSystem ==CM_SYSTEM_CONST){
                        cbpBillGroupId = idSec.value;
                        System.debug('CM bill group Id: '+ cbpBillGroupId);
                    }
                    
                } 
                if(String.isNotBlank(sfdcBillGroupId) && String.isNotBlank(cbpBillGroupId) ) billGroupMap.put(sfdcBillGroupId,cbpBillGroupId);
                List<CMResponse.cls_billLevelParameters> billLevelParametersList;
                if(accBillGrp.billConfig!=null) billLevelParametersList = accBillGrp.billConfig.billLevelParameters;
                if(billLevelParametersList!=null&&billLevelParametersList.size()>0){
                    for(CMResponse.cls_billLevelParameters billParameters: billLevelParametersList){
                        if(String.isNotBlank(cbpBillGroupId)&& String.isNotBlank(billParameters.billLevel2)) billGroupSuffixMap.put(billParameters.billLevel2,cbpBillGroupId);
                    }
                }
                
            }
        }
    }
    
    public static CMUpdateStatusDetails buildGPDListforUpdate(Map<String,String>billGroupMap,Map<String,String>billGroupSuffixMap,
                                                              Map<String,Group__c>grpUpdateMap,List<Group_plan_design__c>grpPlanDesignsListToUpdate,String sfdcAccountId,CMResponse response){
                                                                  CMUpdateStatusDetails retStatus = new CMUpdateStatusDetails();
                                                                  Map<String, CMResponse.cls_subGroups> grpPlanDesignSuffixMap = new Map<String, CMResponse.cls_subGroups>(); //Put group plan design id as Key and group suffix as value
                                                                  Map<String, String> groupRecMap = new Map<String,String>(); //Put group number plus claim system as key and group plan design id as Key and group suffix as value
                                                                  
                                                                  List<CMResponse.cls_subGroups> groupSuffixIdsResponseList ;
                                                                  
                                                                  CMResponse.cls_responseDetails respDetails = response.responseMsg[0].responseDetails;
                                                                  if(respDetails!=null && respDetails.accountInfo !=null && respDetails.accountInfo.CustomerInfo!=null
                                                                     && respDetails.accountInfo.CustomerInfo.customers!=null&&respDetails.accountInfo.CustomerInfo.customers.size() >0
                                                                     &&respDetails.accountInfo.CustomerInfo.customers[0].subGroups!=null){
                                                                         
                                                                         groupSuffixIdsResponseList =response.responseMsg[0].responseDetails.accountInfo.customerInfo.customers[0].subGroups; 
                                                                         
                                                                         
                                                                     }                                                 
                                                                  
                                                                  if(groupSuffixIdsResponseList!=null && groupSuffixIdsResponseList.size()>0){
                                                                      for(CMResponse.cls_subGroups grpSuffixes : groupSuffixIdsResponseList){
                                                                          if(String.isNotBlank(grpSuffixes.sfgroupNumber)&& String.isNotBlank(grpSuffixes.groupSuffixId)&&
                                                                             String.isNotBlank(grpSuffixes.TargetSystem)&&String.isNotBlank(grpSuffixes.TargetSystemId)){
                                                                                 
                                                                                 grpPlanDesignSuffixMap.put(grpSuffixes.sfgroupNumber,grpSuffixes);
                                                                                 
                                                                                 
                                                                             } else{
                                                                                 
                                                                                 retStatus.Status = 'ERROR';
                                                                                 retStatus.StatusMessage = 'Invlaid subgroup record in CM response payload';
                                                                                 return retStatus;
                                                                             }
                                                                          
                                                                          
                                                                          System.debug('GRoup Suffix:'+grpSuffixes.sfgroupNumber);
                                                                      }
                                                                  }                                                 
                                                                  List<Group__c> grpRecList = [Select Id, name,ClaimSystem__c
                                                                                               FROM Group__c
                                                                                               Where ClaimSystem__c in (:COMPASS_CLMSYS_CONST,:WGS_CLMSYS_CONST)
                                                                                               AND Account__c = :sfdcAccountId AND isActive__c = true
                                                                                               Order by Effective_Date__c ];
                                                                  Map<String,Group__c> grpRecMap = new Map<String,Group__c>();
                                                                  if(grpRecList.size()>0){
                                                                      for(Group__c grpRec: grpRecList){
                                                                          grpRecMap.put(grpRec.ClaimSystem__c , grpRec);
                                                                      }
                                                                  }
                                                                  
                                                                  List<Group_Plan_Design__c> grpPlanDesignList= [Select Id, Group_Suffix__c,CBP_Bill_Group_ID__c, Group__c, Group__r.Name, Group__r.ClaimSystem__c,
                                                                                                                 Group__r.id
                                                                                                                 FROM Group_Plan_Design__c
                                                                                                                 WHERE Id IN :grpPlanDesignSuffixMap.keySet()];
                                                                  
                                                                  
                                                                  System.debug('group plan design size:'+grpPlanDesignList.size() );
                                                                  System.debug('grpPlanDesignSuffixMap:'+grpPlanDesignSuffixMap );
                                                                  //Update group suffix id on the associated group plan design record
                                                                  Group__c wgsGroupRec;
                                                                  Group__c compassGroupRec;
                                                                  Group__c groupRecforupsert;
                                                                  
                                                                  //Map<String,Group__c> grpUpdateMap = new Map<String,Group__c>();
                                                                  //Map<String,String> grpClmSysMap = new Map<String,String>(); //map of claim system to id for group record
                                                                  if(grpPlanDesignList.size()>0){
                                                                      for(Group_Plan_Design__c grpPlnDsgn: grpPlanDesignList){
                                                                          //if(!String.isNotBlank(grpPlnDsgn.Group_Suffix__c)){
                                                                          
                                                                          groupRecforupsert = grpPlnDsgn.Group__r;
                                                                          String responseClmSystem = grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).TargetSystem;
                                                                          //if(groupRecforupsert != null){
                                                                          
                                                                          //}
                                                                          if(String.isNotBlank(responseClmSystem)){
                                                                              if(responseClmSystem==grpPlnDsgn.Group__r.claimsystem__c||
                                                                                 (responseClmSystem==CMWGS_CLMSYS_CONST 
                                                                                  &&grpPlnDsgn.Group__r.claimsystem__c==WGS_CLMSYS_CONST)){
                                                                                      if(String.isNotBlank(groupRecforupsert.Name)&&groupRecforupsert.Name!='TBD'&&
                                                                                         grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).TargetSystemId!=groupRecforupsert.Name){
                                                                                             retStatus.Status = 'ERROR';
                                                                                             retStatus.StatusMessage = 'Group Number('+groupRecforupsert.Name+') already exist and group number('
                                                                                                                        +grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).TargetSystemId
                                                                                                                        +') on response payload does not match with existing group number';
                                                                                             return retStatus;
                                                                                         }
                                                                                      groupRecforupsert.Name =  grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).TargetSystemId;
                                                                                  }else{
                                                                                      groupRecforupsert = grpRecMap.get(responseClmSystem);
                                                                                      if(groupRecforupsert!= null&&(String.isBlank(groupRecforupsert.Name)
                                                                                                                    ||groupRecforupsert.Name=='TBD'
                                                                                                                    ||grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).TargetSystemId==groupRecforupsert.Name)
                                                                                        ){
                                                                                          grpPlnDsgn.Group__c =groupRecforupsert.id;
                                                                                          groupRecforupsert.Name = grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).TargetSystemId;
                                                                                      }else {
                                                                                          groupRecforupsert = new Group__c();
                                                                                          groupRecforupsert.Account__c =sfdcAccountId;
                                                                                          groupRecforupsert.Name =grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).TargetSystemId;
                                                                                          groupRecforupsert.ClaimSystem__c =grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).TargetSystem;
                                                                                          grpPlnDsgn.Group__r =groupRecforupsert;
                                                                                          
                                                                                      }
                                                                                  }
                                                                          }
                                                                          
                                                                          grpUpdateMap.put(groupRecforupsert.ClaimSystem__c,groupRecforupsert);
                                                                          //if (wgsGroupRec!=null) wgsGroupRec.Name=grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).TargetSystemId;
                                                                          if(String.isNotBlank(grpPlnDsgn.Group_Suffix__c)&&grpPlnDsgn.Group_Suffix__c!=grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).groupSuffixId){
                                                                               retStatus.Status = 'ERROR';
                                                                               retStatus.StatusMessage = 'Group suffix('+grpPlnDsgn.Group_Suffix__c+') already exist and group suffix('
                                                                                   +grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).groupSuffixId
                                                                                   +') on response payload does not match with existing group suffix';
                                                                               return retStatus;
                                                                          }else{
                                                                              grpPlnDsgn.Group_Suffix__c =  grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).groupSuffixId; 
                                                                          }
                                                                          //grpPlnDsgn.Group_Suffix__c =  grpPlanDesignSuffixMap.get(grpPlnDsgn.Id).groupSuffixId; 
                                                                          grpPlnDsgn.CBP_Bill_Group_ID__c = billGroupSuffixMap.get(grpPlnDsgn.Group_Suffix__c);
                                                                          grpPlanDesignsListToUpdate.add(grpPlnDsgn);
                                                                          system.debug('adding group plan design for update'+ grpPlnDsgn);
                                                                          //}
                                                                      }
                                                                     
                                                                      
                                                                  }
                                                                  retStatus.Status='SUCCESS';
                                                                  return retStatus;
                                                              }
    
    
    
    public static void updateGroupStructure(String sfdcAccountId,String globalCustomerId,Map<String,String>billGroupMap,Map<String,Group__c>grpUpdateMap,List<Group_plan_design__c>grpPlanDesignsListToUpdate ){

                
        List<Invoices_Local__c> invoiceList= [Select Id, CBP_Bill_Group_ID__c
                                              FROM Invoices_Local__c
                                              WHERE Id IN:  billGroupMap.keySet()];
        
        if(invoiceList.size()>0){
            for(Invoices_Local__c invoice: invoiceList){
                invoice.CBP_Bill_Group_ID__c = billGroupMap.get(invoice.id);
            }
        }
        
        //Update CM global customer id
        Account acnt = new Account();
        acnt.Id = sfdcAccountId;
        acnt.Global_Customer_ID__c = globalCustomerId;
        Database.Update(acnt);
        
        //Update wgs group record
        List<Group__c> groupList = new List<Group__c>();
        groupList.addAll(grpUpdateMap.values());
        if(groupList != null){
            for(Group__c gp :groupList ){
                System.debug('Group  update record:'+ gp);
            }
            Database.upsert(groupList);
        }
        //Update Group Plan Design Record
        
        if(grpPlanDesignsListToUpdate.size()>0){
           for(Group_plan_design__c gpd :grpPlanDesignsListToUpdate ){
                if(gpd.Group__c==null){
                    gpd.Group__c = gpd.Group__r.id;
                }
                System.debug('Group Plan Design group ref:'+ gpd.Group__r);
                System.debug('Group Plan Design group__c:'+ gpd.Group__c);
            }
            Database.update(grpPlanDesignsListToUpdate);
        }

        
        // Update invoice records
        if(invoiceList.size()>0){
            Database.update(invoiceList);
        }
        
    }
    public static void processIDCardResponse(CMResponse response,String orderId){
        String sfdcAccountId;
        
        List<CMResponse.cls_ids> customerIdsList;//  =  response.responseMsg[0].responseDetails.accountInfo.CustomerInfo.customers[0].ids; 
        CMResponse.cls_responseDetails respDetails = response.responseMsg[0].responseDetails;
        
        List<ID_Cards__c> idCardList = [Select id,ID_Cards_Triggered__c
                                        From ID_Cards__c 
                                        Where Implementation_Tracking_ID__r.Implementation_Record_ID__c =:orderId
                                        ];
        System.debug(respDetails);
        if(respDetails!=null && respDetails.accountInfo !=null && respDetails.accountInfo.customerInfo!=null
           && respDetails.accountInfo.customerInfo.customers!=null&&respDetails.accountInfo.customerInfo.customers.size() >0
           &&respDetails.accountInfo.customerInfo.customers[0].miscellaneousInfo!=null
            &&respDetails.accountInfo.customerInfo.customers[0].miscellaneousInfo.idcards!=null
            &&String.isNotBlank(respDetails.accountInfo.customerInfo.customers[0].miscellaneousInfo.idcards.triggereddate)){
                                                                                  
               
               //Get all the key ids from response message
               //customerIdsList =response.responseMsg[0].responseDetails.accountInfo.CustomerInfo.customers[0].ids; 
               
               String triggerDate =  respDetails.accountInfo.customerInfo.customers[0].miscellaneousInfo.idcards.triggereddate;
               
               if(idCardList.size()>0){
                   idCardList[0].ID_Cards_Triggered__c  = date.valueOf(triggerDate);
                   Database.update(idCardList[0]);
               }
              
           }
        

    }
    
    public static void createAttachment(String response, Integration_Event_Log__c eventLog) {
        
        // Log response payload as attachment to this event log record
        Attachment att = new Attachment();
        att.Body = Blob.valueOf(response);
        att.Name = 'CMStatusResponse_' + eventLog.Tracking_ID__c + '.txt';
        att.parentId = eventLog.id;
        insert att;
    }
    
    
    public class CMUpdateStatusDetails{
        public String status;
        public String statusMessage;
    }   
   public static void sendEmail(String AttachmntBody, String Status,String StatusMsg ){
        ServiceInterface__mdt mdt = [Select Id, AttachmentName__c, Success_file_name__c, ToEmailList__c, EmailDisplayName__c, EmailSubject__c, FromEmailId__c From ServiceInterface__mdt Where Label = 'CM Integration Response']; 
        Organization org=[select id,issandbox,instancename from organization];
        if(Status=='SUCCESS'&& String.isBlank(mdt.Success_File_Name__c)) return;  

        List<Messaging.EmailFileAttachment> attchmntsList = new List<Messaging.EmailFileAttachment>();
        
        Messaging.EmailFileAttachment jsonAttc = new Messaging.EmailFileAttachment();
       // finalStr = finalStr + String.join(errorStringRows, '\n');
        Blob jsonBlob = Blob.valueOf(AttachmntBody);
        string attfileName= mdt.AttachmentName__c+'_'+Date.today()+'JSON.txt';
        jsonAttc.setFileName(attfileName);
        jsonAttc.setBody(jsonBlob);
        attchmntsList.add(jsonAttc);     
        
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = mdt.ToEmailList__c.split(';');
        String subject = mdt.EmailSubject__c;
        if(org.issandbox==true)
        {
             subject=org.instancename+'- '+subject;
        }
        else
        {
            subject='Production:'+org.instancename+'- '+subject;
      
        }
        email.setToAddresses( toAddresses );
        email.setSenderDisplayName(mdt.EmailDisplayName__c);
        email.setReplyTo(mdt.FromEmailId__c);
       
        String body ;
        
       if(Status=='ERROR'){
           email.setSubject(subject+'-Error');
           body = 'Failed to process CM response message'+'<br/>';
           body+= 'Error message:'+ StatusMsg; 
       }
       if(Status=='SUCCESS'){
           email.setSubject(subject+'-Success');
           body = 'CM Response payload processed successfully'+'<br/>';
           body+= 'Status message:'+ StatusMsg; 
       }
       
        email.setHtmlBody(body);
        email.setFileAttachments(attchmntsList);
        Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});        
            
    }
}