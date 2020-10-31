@isTest
public class LGJiraUtilityMockTest implements HttpCalloutMock {
    public static String jiraSuccessResponse = '{"id":"103829","key":"EWM-49704","self":"https://jiraewm-dev.anthem.com/rest/api/2/issue/103829"}';
    String jiraResponseWithResponse = '{"id":"103829","key":"EWM-49704","self":"https://jiraewm-dev.anthem.com/rest/api/2/issue/103829","response":"Test Response"}';
    String jiraErrorResponse = '{"id":"103829","key":"EWM-49704","self":"https://jiraewm-dev.anthem.com/rest/api/2/issue/103829","exceptions":[{"type":"errors","code":"400","message":"Test errors Exception","detail":"Test Detail"}]}';
    Integer Code =200;

   
    
   public LGJiraUtilityMockTest(Integer code)
    {
        //this.resBody = jiraResponseWithException;
        this.code = code;
    }
    
   public HttpResponse respond(HTTPRequest request)
    {
       String reqBody = request.getBody();
        HTTPResponse resp = new HTTPResponse();
        resp.setHeader('Content-Type', 'application/json');
        resp.setStatusCode(code);
        if(code!=200){
            resp.setBody(jiraErrorResponse);
        }else {
            resp.setBody(jiraSuccessResponse);
        }
        
        return resp;
    }
}