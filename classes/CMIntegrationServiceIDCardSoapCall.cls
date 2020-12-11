/*
@Author : Anthem Dev team
@name : CMIntegrationService
@CreateDate : 09-19-2019
@Description : This is to provide a soap UI call methods for id card testing
for case level:
/services/apexrest/testcmidcard/
{"option":"case", "recordid":"80163000001iASm", "suffix":[]}

for account:
/services/apexrest/testcmidcard/
{"option":"account", "recordid":"0016300000fwZ1L", "suffix":[]}

for suffix:
/services/apexrest/testcmidcard/
{"option":"suffix", "recordid":"80163000001iASm", "suffix":["L12345D000", "L12345D001"]}
*/
@RestResource(urlMapping='/testcmidcard/*')
global class CMIntegrationServiceIDCardSoapCall {

    @HttpPost
    global static String UICall(String option, String recordid, List<String> suffix) {
        CMIntegrationRequest res = new CMIntegrationRequest();
        Integration_Event_Log__c r = new Integration_Event_Log__c();
        try {
            RestRequest request = RestContext.request;
            Order od = CMIntegrationService.prepareOrder(recordid);
            String eventType = CMIntegrationConstants.EVENT_TYPE_IDCARDREQUEST;
            CMIntegrationRequest.cls_eventMetaData eventMetaData = CMIntegrationService.buildEventMetaData(eventType);
	        res = CMIntegrationIdCards.buildCMPayloadIdCard(od, option, suffix, eventMetaData);
        	
        } catch(Exception e) {
            res.payloadInformation = new CMIntegrationRequest.cls_payloadInformation();
            res.payloadInformation.errorMessage = e.getMessage() + '\n' + e.getStackTraceString();
        }
        //r.Status_Message__c = JSON.serialize(res, true);
        //return r;
        return JSON.serialize(res, true);
    }

}