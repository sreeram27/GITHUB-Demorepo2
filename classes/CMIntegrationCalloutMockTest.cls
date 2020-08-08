@isTest
public class CMIntegrationCalloutMockTest implements HttpCalloutMock{
 
    public static String mockTokenRes ='{"access_token":"eyJhbGciOiJSUzI1NiIs ","application_name":"salesforce-large-gro","client_id":"dv2JGaEOEl6p40WTKd17","expires_in":"899","issued_at":"1557336486513","status":"approved","isNewToken": true}';
    public static String mockRes ='{"statusCode": 200,"status": "Callout made successfully to CM"}'; 
	 
    
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
            res.setBody(mockRes);
            
        }
        return res;
    }
}