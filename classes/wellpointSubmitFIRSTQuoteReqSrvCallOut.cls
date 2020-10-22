public with sharing class wellpointSubmitFIRSTQuoteReqSrvCallOut {
    public static wellpointComServiceUtility.SubmitFIRSTQuoteResponse_element submitQuoteRequestToFIRST(wellpointComServiceUtility.SubmitFIRSTQuoteRequest_element soapPayload) {  
        /* Instantiating Port Interface which will be used to make the service callout */
        wellpointComServiceUtilityInterface.UtilityService_HTTP_Port sendReqServ = new wellpointComServiceUtilityInterface.UtilityService_HTTP_Port();
        wellpointComServiceUtility.SubmitFIRSTQuoteResponse_element soapResp = new wellpointComServiceUtility.SubmitFIRSTQuoteResponse_element();
        Organization org=[select id,issandbox,instancename from organization];

        /* Constructing SOAP Header Objects and Passing the Object to Port Interface */
        /* Instantiating Header, Context and QuoteRequest classes which will be used to get the header. context and dummy SOAP Body Objects */
        wellpointPrepareHeader wlpHeaderCreator = new wellpointPrepareHeader();
        //wellpointPrepareHeaderContext wlpHeaderctxTypeCreator = new wellpointPrepareHeaderContext();
        /* Getting the objects */
        wellpointComEsbHeader.ESBHeaderType soapHeader = wlpHeaderCreator.prepareHeaderObject();
        wellpointComEsbContext.ContextType soapHeaderctxType = wellpointPrepareHeaderContext.prepareHeaderContextObject();
        /* Setting the Objects to the Port Interface */
        sendReqServ.header = soapHeader;
        sendReqServ.context = soapHeaderctxType;
        /* Submitting Soap Request to Service Provider */
          ServiceInterface__mdt mc;
          if(org.issandbox==true)
          {
          mc = [Select Id, CertificateName__c, ServiceTimeOut__c, ServiceURL__c From ServiceInterface__mdt Where DeveloperName = 'FIRSTIntegration_Sandbox'];
          }
          else
          {
            mc = [Select Id, CertificateName__c, ServiceTimeOut__c, ServiceURL__c From ServiceInterface__mdt Where DeveloperName = 'FIRSTIntegration_Prod'];
          }

        sendReqServ.clientCertName_x =mc.CertificateName__c;
        system.debug('=====cert name========'+sendReqServ.clientCertName_x);
        system.debug('=====cert name========'+mc.CertificateName__c);
        sendReqServ.timeout_x = Integer.valueOf(mc.ServiceTimeOut__c);
       
        sendReqServ.endpoint_x = mc.ServiceURL__c;
       
        
        System.debug('sendReqServ     : '+sendReqServ);
        system.debug('----soap payload---->>>'+soapPayload);
        soapResp = sendReqServ.SubmitFIRSTQuote(soapPayload);
        
        return soapResp; 
    }
}