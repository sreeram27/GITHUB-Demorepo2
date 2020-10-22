@isTest
public class CMGroupNumberReqCalloutMock implements HttpCalloutMock{

    public static String mockTokenRes ='{"access_token":"eyJhbGciOiJSUzI1NiIs ","application_name":"salesforce-large-gro","client_id":"dv2JGaEOEl6p40WTKd17","expires_in":"899","issued_at":"1557336486513","status":"approved","isNewToken": true}';
    public String body;
  /*  public static String mockRes ='{"responseMsg": {"statusCode": "PARTIAL SUCCESS","externalNumber":[{"productType":"Medical","id": "Test Group","claimSystem":"WGS"},{"productType":"LTD","id": "321456","claimSystem":"COMPASS"}],"globalCustomerNumber":"12345","customerNumber":"2345",'
									+'"responseDetails": {'
									+'"listOfErrorCodes": [{"category": "Functional","errorCode": "EXB1001","bindingFiled":"","entityName": "","errorMessage": "CaseId is already present"}] }}}'; */
	 
    public CMGroupNumberReqCalloutMock(String body){
        this.body = body;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        // Create a mock response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        System.assertEquals('POST', req.getMethod());
        if(req.getEndpoint().contains('accesstoken'))
        {
            res.setBody(mockTokenRes);
        }
        else
        {	
            res.setBody(this.body);
            
        }
        return res;
    }
}