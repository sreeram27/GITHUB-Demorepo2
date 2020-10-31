@isTest
global class wellpointComServiceUtilityMock implements WebServiceMock {
    global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        wellpointComServiceUtility.SubmitFIRSTQuoteResponse_element response_x = new wellpointComServiceUtility.SubmitFIRSTQuoteResponse_element();
       // List<String> lstOfDummyParks = new List<String> {'Park1','Park2','Park3'};
        wellpointComServiceUtility.Status Status=new wellpointComServiceUtility.Status();
        status.StatusDesc='Success';
        status.StatusCode='Success';
        response_x.Status= Status;
        
        response.put('response_x', response_x);
    }
}