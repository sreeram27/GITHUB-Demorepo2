@isTest
global class ContCodeReserveResponseMockTest implements HttpCalloutMock {
    public static String mockTokenRes ='{"access_token":"eyJhbGciOiJSUzI1NiIs ","application_name":"salesforce-large-gro","client_id":"dv2JGaEOEl6p40WTKd17","expires_in":"899","issued_at":"1557336486513","status":"approved","isNewToken": true}';
    public static String mockRes ='{ "transactionId": "1234567", "transactionTimestamp":"2019-07-17T15:53:21.721Z","status":{"code": 200,"message": "Contract codes(s) reserved successfully for the domain"},"input":{"baseContract": "47KB","modifiedByP2A": "Y","hpcc": "HM26","fundingType": "ASO","state": "OH","groupSize": "100 - 249"}, "contractCode": "4BMQ", "callingSystem": "SFDCCOM2"}'; 
    // Implement this interface method
	 
    
    global HTTPResponse respond(HTTPRequest req) {
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
            res.setBody(mockRes);
            
        }
        return res;
    }
    
    static testmethod void parseResponseTest(){
        ContCodeReserveResponse res = new  ContCodeReserveResponse();
        ContCodeReserveResponse.parse(mockRes);
    }
}