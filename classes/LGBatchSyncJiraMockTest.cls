/*
 * @Author - Legato Health Technologies
 * Mock class for REST Callouts in LGBatchSyncJiraRefinedTest class
 * 
 * Date : 30 - October - 2018
 */

@isTest
public class LGBatchSyncJiraMockTest implements HttpCalloutMock{
   
    String accessTokenResponse = '{"api_product_list_json": ["Default_Product","OAuth_Product","JIRABiz_Product"],"token_type": "BearerToken","issued_at": "1543586724153","client_id": "dv2JGaEOEl6p40WTKd17tMCw2ebNAV31","access_token": "eyJhbGciOiJSUzI1NiIsIng1dCI6IlpNNGYtZy1ZNXV4Q0V2SDRtSm43OXBXZlNPUSIsImtpZCI6IlpNNGYtZy1ZNXV4Q0V2SDRtSm43OXBXZlNPUSIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhMmFlNmU5YjZkZTA0YmRjODM2MTVhMWM3ZGEwM2I5ZCIsInNjb3BlIjoicHVibGljIiwiY2xpZW50X2lkIjoiMTc5MDgwODA2OTJiNDY4OTg4MDc1MWVkYzVjZjY2NDQiLCJzdWIiOiIxNzkwODA4MDY5MmI0Njg5ODgwNzUxZWRjNWNmNjY0NCIsImlzcyI6Imh0dHBzOi8vdmExMG41MDg1MC51cy5hZC53ZWxscG9pbnQuY29tL3NlY3VyZWF1dGgzIiwiYXVkIjoiaHR0cHM6Ly92YTEwbjUwODUwLnVzLmFkLndlbGxwb2ludC5jb20vc2VjdXJlYXV0aDMiLCJleHAiOjE1NDM1ODc2MjQsIm5iZiI6MTU0MzU4NjcyNH0.YUGBsnZqGVV6LFE6mF6Pvt5PP7pLtOZvsj6zXj0sExw83vZjWw9QuSuwo5d9gM6lXwKGDl0XojADULqelLqgYfHwiHX5RXrtX8bCeh9ZgTrabZTSXpR3FzjkmqpVioCXGAYHfVnH62xzylpdESzTgVX2JyOfkh80lmx088wOsdsXGd-o5ukf9zQm2UZPDmZQpLeAvF-fXkDKBaINPUywp5f8Ifu-PqY4_S9OH6wQyVzS4hN_UgAkbgzKh993J83zycfJkzbh2RSCoALk0JvATSjHjOIUmCo5YuGsnr00Hl9571PqcbLzdN8I8lv3Ql_cXtazU3PAnarPTfMhLc_aow","application_name": "salesforce-large-group-national","scope": "","expires_in": "899","status": "approved"}';
    String jiraResponse = '{"id":"103829","key":"EWM-49704","self":"https://jiraewm-dev.anthem.com/rest/api/2/issue/103829"}';
    String jiraResponseWithResponse = '{"id":"103829","key":"EWM-49704","self":"https://jiraewm-dev.anthem.com/rest/api/2/issue/103829","response":"Test Response"}';
    String jiraResponseWithException = '{"id":"103829","key":"EWM-49704","self":"https://jiraewm-dev.anthem.com/rest/api/2/issue/103829","exceptions":[{"type":"Exception","code":"400","message":"Test Exception","detail":"Test Detail"}]}';
    String jiraResponseWithNoKey = '{"id":"103829","self":"https://jiraewm-dev.anthem.com/rest/api/2/issue/103829"}';
    String resBody;
    Integer code;
    Map<String,String> comparableMap;
    
    public LGBatchSyncJiraMockTest(Map<String , String> requestMap)
    {
        this.comparableMap = requestMap;
        this.code = 200;
        
    }
     public LGBatchSyncJiraMockTest(Integer code)
    {
        //this.resBody = jiraResponseWithException;
        this.code = code;
    }
    public HttpResponse respond(HTTPRequest request)
    {
        if(request.getEndpoint().contains('accesstoken'))
        {
            this.resBody = accessTokenResponse;
        }
        else
        {	
            if(code ==200)
        	{    
                
            String reqBody = request.getBody().substringBetween('{"fields":','}}');
            LGJira2IssueDetail.FieldDetails fields = (LGJira2IssueDetail.FieldDetails)JSON.deserializeStrict(reqBody+'}', LGJira2IssueDetail.FieldDetails.class);
            if(fields.customfield_11483!=null)
            {
            System.assertEquals(comparableMap.get('anthemEntity'), fields.customfield_11483.value);
            }   
            System.assertEquals(comparableMap.get('claimSystem'), fields.customfield_11500.value);
            System.assertEquals(comparableMap.get('project'), fields.project.name);
            System.assertEquals(comparableMap.get('recordLink'), fields.customfield_11447);
            //Datetime recCorpRecDate = Datetime.valueOf(comparableMap.get('corporateReceiptDate'));
            //Datetime newDate = recCorpRecDate.addHours(5);
            //System.assertEquals(String.valueOf(newDate),fields.customfield_13000);
            //System.assertEquals(comparableMap.get('state'),fields.customfield_14108);
            Date prodDate = Date.valueOf(fields.customfield_11561);
            System.assertEquals(comparableMap.get('productionDate'), String.valueOf(prodDate));
            System.assertEquals(comparableMap.get('LHOL'), fields.customfield_11495.value);
            System.assertEquals(comparableMap.get('summary'), fields.summary);
            System.assertEquals(comparableMap.get('issueType'), fields.issuetype.name);
            System.assertEquals(comparableMap.get('referenceType'), fields.customfield_11481.value);
            if(fields.customfield_14318 != null)
            {
            	//System.assertEquals(comparableMap.get('salesMarket'), fields.customfield_14318[0].value);
            }
            System.assertEquals(comparableMap.get('funding'), fields.customfield_15105[0].value);
            System.assertEquals(comparableMap.get('system'), fields.customfield_11491.value);
            System.assertEquals(comparableMap.get('accountTeamMember'), fields.customfield_11493);
            System.assertEquals(comparableMap.get('totalMember'),fields.customfield_11492);
            System.assertEquals(comparableMap.get('assignedImplementer'),fields.customfield_12301);
            this.resBody = jiraResponse;
            this.code=200;
            }
            else if(code == 400)
            {
                this.resBody = jiraResponseWithException;
            }
            else if(code == 401)
            {
                this.resBody = jiraResponseWithResponse;
            }
            else if(code == 405)
            {
                this.resBody = jiraResponseWithNoKey;
            }
            
        }
        String reqBody = request.getBody();
        HTTPResponse resp = new HTTPResponse();
        resp.setHeader('Content-Type', 'application/json');
        resp.setStatusCode(code);
        resp.setBody(resBody);
        return resp;
    }
    

}