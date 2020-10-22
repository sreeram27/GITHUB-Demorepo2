@isTest
global class ContCodeReserveResponsefailureMockTest implements HttpCalloutMock {
    public static String mockTokenRes ='{"access_token":"eyJhbGciOiJSUzI1NiIs ","application_name":"salesforce-large-gro","client_id":"dv2JGaEOEl6p40WTKd17","expires_in":"899","issued_at":"1557336486513","status":"approved", "currentTime": null, "isNewToken": true}';
    public static String mockRes ='{"transactionId": "1234567", "transactionTimestamp":"2019-07-17T15:53:21.721Z", "status":{"code": 400,"message": "Invalid Input Parameter -  baseContract cannot be empty for processing the request"}}'; 
    // Implement this interface method
	 
    global HTTPResponse respond(HTTPRequest req) {
        // Create a mock response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        System.assertEquals('POST', req.getMethod());
        if(req.getEndpoint().contains('accesstoken'))
        {
            res.setStatusCode(200);
            res.setBody(mockTokenRes);
        }
        else
        {	  
           /* res.setStatusCode(400); 
            res.setStatus('Bad Request'); */
            res.setBody(mockRes);
                   }
        
        return res;
    }
}