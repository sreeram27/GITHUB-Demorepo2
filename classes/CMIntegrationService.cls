/*
@Author : Anthem Dev team
@name : CMIntegrationService
@CreateDate : 09-19-2019
@Description : This is service class to build CMIntegationRequest, 
call RestAPI to pass request message and process service response.
When populate the fields, search keywords:
od, acc, accParent, accChild, con, cr, grp, qt, currentUser
search in code:
serviceProviderRelationshipMap, groupLogisticsList, accTeamList
test in workbench in post: 

/services/apexrest/cm/
{"orderId":"80163000001iASm"}

test in workbench in get method to return no null string: 
/services/apexrest/cm/80163000001iASm
*/
@RestResource(urlMapping='/cm/*')
global class CMIntegrationService {

    @HttpPost
    global static CMIntegrationRequest cmIntRestServicePostCall(String orderId) {
        try {
            // submitCaseToCM(orderId);
            String eventType = CMIntegrationConstants.TRANSACTION_TYPE_PREVIEW; //'Preview';
        	return CMIntegrationGroupLoad.buildCMPayload(prepareOrder(orderId), buildEventMetaData(eventType));
        } catch(Exception e) {
            CMIntegrationRequest res = new CMIntegrationRequest();
            res.payloadInformation = new CMIntegrationRequest.cls_payloadInformation();
            res.payloadInformation.errorMessage = e.getMessage() + '\n' + e.getStackTraceString();
            return res;
        }
    }

    @HttpGet
    global static String cmRestServicePostCallNoNull() {
        CMIntegrationRequest res = new CMIntegrationRequest();
        Integration_Event_Log__c r = new Integration_Event_Log__c();
        try {
            RestRequest request = RestContext.request;
	        String orderId = request.requestURI.substring(   request.requestURI.lastIndexOf('/')+1);
            // submitCaseToCM(orderId);
            String eventType = CMIntegrationConstants.TRANSACTION_TYPE_PREVIEW; //'Preview';
        	res = CMIntegrationGroupLoad.buildCMPayload(prepareOrder(orderId), buildEventMetaData(eventType));
        } catch(Exception e) {
            res.payloadInformation = new CMIntegrationRequest.cls_payloadInformation();
            res.payloadInformation.errorMessage = e.getMessage() + '\n' + e.getStackTraceString();
        }
        //r.Status_Message__c = JSON.serialize(res, true);
        //return r;
        return JSON.serialize(res, true);
    }
    
    public static String submitCaseToCMforPreview(String orderId){
        Order od = prepareOrder(orderId);
        return submitCaseToCM(od, CMIntegrationConstants.TRANSACTION_TYPE_PREVIEW); //'Preview'
    }
    
    public static String submitCaseToCMforAddUpdate(String orderId){
        Order od = prepareOrder(orderId);
        return submitCaseToCM(od, CMIntegrationConstants.TRANSACTION_TYPE_ADDUPDATE); // 'AddUpdate'      
    }
    
    public static String triggerIDCardAccountLevel(String accountId) {
        // not needed for now
        return '';
    }
        
    public static String triggerIDCardCaseLevel(String orderId){
        return triggerIDCardAndValidate(orderId, CMIntegrationConstants.EVENT_TYPE_IDCARDREQUEST, 
                                        CMIntegrationConstants.IDCARD_TYPE_CASE, null); // 'IdCardRequest'
    }
    public static String triggerIDCardSuffixLevel(String orderId, List<String> suffixList){
        return triggerIDCardAndValidate(orderId, CMIntegrationConstants.EVENT_TYPE_IDCARDREQUEST, 
                                        CMIntegrationConstants.IDCARD_TYPE_SUFFIX, suffixList); // 'IdCardRequest'
    }
	
    public static String triggerIDCardAndValidate(String orderId, String transactionType, String idCardType, List<String> suffixList) {
        Order od = prepareOrder(orderId);
        // Return error message 'Invalid ID Card Request. ID Card request is supported only for WGS claim system';
        if (od.Claim_System__c != CMIntegrationConstants.CLAIM_SYSTEM_WGS) {
            return 'Invalid ID Card Request. ID Card request is supported only for WGS claim system';
        } else {
            return submitCaseToCM(od, transactionType, true, idCardType, suffixList);
        }        
    }
    
    
   // The method will prepare the Order data
    public static Order prepareOrder(String orderId) {
        Order od = [select accountId, account.ParentId, account.name, account.Global_Customer_ID__c, Group_Name__c, Group_Name__r.name, Claim_System__c, 
                    Additional_comments__c, OpportunityId, QuoteId, Implementation_Effective_Date__c, Implementation_Type__c,
                    Opportunity.CloseDate, Opportunity.Funding__c, Non_HMO_ID_Cards__c, Open_Enrollment_Date__c, Maintenance_Reason_Customer_Master__c,
                    Maintenance_Cards_Sent_To__c, ID_Cards_Sent_To__c, Ongoing_Enrollment_Submission_Type__c
                    from Order 
                    where id =:orderId];
			
        return od;
    }    
    
   
   // The method will prepare the primary payload and send the request. It's used only for primary payload
    public static String submitCaseToCM(Order od, String transactionType) {
		return submitCaseToCM(od, transactionType, false, null, null);
	}
    
    /*
    The method will prepare the payload and send the request. It's reused by both primary payload and id card
	When it's for idCard, forIdCard will be true, and pass option/suffixList. 
	Otherwise forIdCard will be false, and pass option/suffixList as null. 
    */
    public static String submitCaseToCM(Order od, String transactionType, boolean forIdCard,
                                       String idCardType, List<String> idCardSuffixList) {
        // Call sendCMReqInfo method in CMIntegrationUtility class to send request payload to CM  Queue
        Integration_Event_Log__c iel = new Integration_Event_Log__c();
		String retMsg;
        CMIntegrationRequest req = null;
        try {
            
             // if impl type == 'New Business' and transaction type = 'AddUpdate' then 
             // 	event type = 'Add'
             // else if   impl type == 'Change Request Off Cycle' and transaction type = 'AddUpdate' then
             //  event type = 'Maintenance'
             // else if transaction type = 'Preview' then 
             // 	event type = 'Preview'
             // else if transaction type = 'ID Card Request' then
             // 	event type = IDCardRequest
             // 
    
            String eventType = '';
            if (transactionType == CMIntegrationConstants.TRANSACTION_TYPE_ADDUPDATE) {
                if (od.Implementation_Type__c == CMIntegrationConstants.IMPLEMENTATION_TYPE_NEW) { // 'New Business'
                    eventType = CMIntegrationConstants.EVENT_TYPE_ADD; // 'Add'
                } else if (od.Implementation_Type__c == CMIntegrationConstants.IMPLEMENTATION_TYPE_CHANGE) { // 'Change Request Off Cycle'
                    eventType = CMIntegrationConstants.EVENT_TYPE_MAINTENANCE; // 'Maintenance'
                } else {
                    return 'Error: Implementation type ' + od.Implementation_Type__c + ' not in scope for CM Integration';
                }
            } else if (transactionType == CMIntegrationConstants.TRANSACTION_TYPE_PREVIEW) {
                eventType = CMIntegrationConstants.TRANSACTION_TYPE_PREVIEW;
                if (od.Implementation_Type__c != CMIntegrationConstants.IMPLEMENTATION_TYPE_NEW && od.Implementation_Type__c != CMIntegrationConstants.IMPLEMENTATION_TYPE_CHANGE) { // 'Change Request Off Cycle'
                    return 'Error: Implementation type ' + od.Implementation_Type__c + ' not in scope for CM Integration';
                }


            } if (transactionType == CMIntegrationConstants.EVENT_TYPE_IDCARDREQUEST) {
                eventType = CMIntegrationConstants.EVENT_TYPE_IDCARDREQUEST; // 'IDCardrequest'
            }

            // Log this event in event log with data from event metadata section. Put process name as 'CM Integratoin'
            iel.Process_Name__c = CMIntegrationConstants.LOG_PROCESS_NAME; // 'CM Integratoin Request'
            iel.Event_Type__c = eventType;
            iel.Implementation_Case__c = od.id;

            // build eventMetaData before building the main contents
        	CMIntegrationRequest.cls_eventMetaData eventMetaData = buildEventMetaData(eventType);
            iel.Tracking_ID__c = eventMetaData.trackingId;
            iel.System_Name__c = eventMetaData.sourceSystemId;
                          
            // use different methods for primary payload and forIdCard
            if (forIdCard) {
                req = CMIntegrationIdCards.buildCMPayloadIdCard(od, idCardType, idCardSuffixList, eventMetaData);
            } else {
                req = CMIntegrationGroupLoad.buildCMPayload(od, eventMetaData);
            }
            
            CMIntegrationUtility util =  new CMIntegrationUtility();
        	CMIntegrationUtility.StatusDetails sd = util.sendCMReqInfo(req);
            // if status code returned from CM Queue = 200 then return success else return status message
            if (sd.statusCode == 200) {
                iel.Status__c = CMIntegrationConstants.LOG_STATUS_SUCCESS; // 'SUCCESS'
                iel.Status_Message__c = CMIntegrationConstants.LOG_STATUS_SUCCESS; // 'SUCCESS'
                //return CMIntegrationConstants.LOG_STATUS_SUCCESS; // 'SUCCESS'
                retMsg = CMIntegrationConstants.LOG_STATUS_SUCCESS;
            } else {
                iel.Status__c = CMIntegrationConstants.LOG_STATUS_ERROR; // 'ERROR'
                String s = sd.statusMessage;
                if (s.length() > 255) s = s.substring(0, 255);
                iel.Status_Message__c = s;
                retMsg = sd.statusMessage;
                //return sd.statusMessage;
            }
            iel.Transaction_Date_Time__c = system.now();
            insert iel;
            createAttachment(req, iel);
            return retMsg;
        } catch (Exception e) {
            iel.Status__c = 'ERROR';
            String s = e.getMessage() + '\n' + e.getStackTraceString();
            if (s.length() > 255) s = s.substring(0, 255);
            iel.Status_Message__c = s;
            iel.Transaction_Date_Time__c = system.now();
            insert iel;
            createAttachment(req, iel);            
            return e.getMessage();

        }
        /*finally {
            
            iel.Transaction_Date_Time__c = system.now();
            insert iel;
            
            createAttachment(req, iel);
            
        }*/
    }
    
 
   // The method is used to create attachment file and attach to target event log record
    public static void createAttachment(CMIntegrationRequest req, Integration_Event_Log__c iel) {
        // if request is null, do nothing
        if (req == null) return;
        
        // Log payload as attachment to this event log record with title CMRequestPayload_<TrackingID>.txt
		Attachment att = new Attachment();
        att.Body = Blob.valueOf(JSON.serializePretty(req, true));
        att.Name = 'CMRequestPayload_' + iel.Tracking_ID__c + '.txt';
        att.parentId = iel.id;
        insert att;
    }

    
   // The method is used to build event meta data section
    public static CMIntegrationRequest.cls_eventMetaData buildEventMetaData(String eventType) {
        
        User currentUser = [select FederationIdentifier, Rep_ID_Code__c
                            from User 
                            where id =:UserInfo.getUserId()];
        
        CMIntegrationRequest.cls_eventMetaData eventMetaData = new CMIntegrationRequest.cls_eventMetaData();
        eventMetaData.userId = currentUser.FederationIdentifier;
        eventMetaData.sourceSystemId = CMIntegrationConstants.SOURCE_SYSTEM_SFDCCOM2;
        eventMetaData.trackingId = 'CM_'+Datetime.now().formatGMT('yyyyMMddHHmmssSSS')+Integer.valueof(10000 + (Math.random() * 10000));
        eventMetaData.eventType = eventType;
        eventMetaData.masterId = '';
        eventMetaData.subTrackingId = '';
        
        return eventMetaData;
    }
         
//This method makes a service callout to the group number creation service 
    public static String generateGroupNumber(String quoteId, String reqGroupNumber){
        
        String eventLogId = CMIntegrationGrpNumGeneration.generateGroupNumber(quoteId, reqGroupNumber);
        return eventLogId;
    }
}