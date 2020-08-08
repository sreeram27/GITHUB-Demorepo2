public with sharing class LGJiraUtility {
    
    
    public String apiKey;
    public String clientId;
    public String clientSecret;
    public String userName;
    public String passWord;
    public String host;
    public String accessTokenURL;
    public String createIssueURL;
    public String modifyIssueURL;
    public String deleteIssueURL;
    public String searchGetIssueURL;
    public String searchPostIssueURL;
    public String healthCheckURL;
    public String jiraGenericURL;
    public Integer tokenRefreshTime;
    private String accessTokenValue;
    private Datetime createTokenTime;
    private class ErrorResponse {
        public List<String> errorMessages;
        public Errors errors;
    }
    
    private class Errors {
        
    }
    public LGJiraUtility() {
        
        Organization org = [Select IsSandbox, InstanceName From Organization];
        Jira_EndPoint_Setting__mdt endPointInfo;
        
        if (org.IsSandbox == true) {
            
            endPointInfo = [Select AccessToken__c, ApiKey__c, ClientID__c, ClientSecret__c, Create_Issue__c, Delete_Issue__c, 
                            healthCheck__c, Jira_Generic__c, Modify_Issue__c, Search_GET__c, Search_POST__c, Host__c, Application_Username__c, 
                            Application_Password__c, TokenRefreshTime__c From Jira_EndPoint_Setting__mdt Where IsSandbox__c = true limit 1];
            
        } else {
            
            endPointInfo = [Select AccessToken__c, ApiKey__c, ClientID__c, ClientSecret__c, Create_Issue__c, Delete_Issue__c, 
                            healthCheck__c, Jira_Generic__c, Modify_Issue__c, Search_GET__c, Search_POST__c, Host__c, Application_Username__c, 
                            Application_Password__c, TokenRefreshTime__c From Jira_EndPoint_Setting__mdt Where IsSandbox__c = false limit 1];
            
        }
        
        
        //JiraEndpointSetting__c endPointInfo = JiraEndpointSetting__c.getValues('');
        
        
        apiKey = endPointInfo.ApiKey__c;
        clientId = endPointInfo.ClientID__c;
        clientSecret = endPointInfo.ClientSecret__c;
        userName = endPointInfo.Application_Username__c;
        passWord = endPointInfo.Application_Password__c;
        host = endPointInfo.Host__c;
        accessTokenURL = endPointInfo.AccessToken__c;
        createIssueURL = endPointInfo.Create_Issue__c;
        modifyIssueURL = endPointInfo.Modify_Issue__c;
        deleteIssueURL = endPointInfo.Delete_Issue__c;
        searchGetIssueURL = endPointInfo.Search_GET__c;
        searchPostIssueURL = endPointInfo.Search_POST__c;
        healthCheckURL = endPointInfo.healthCheck__c;
        tokenRefreshTime = Integer.valueOf(endPointInfo.TokenRefreshTime__c);
        
    }
    
    public LGJiraCreateIssueResponse CreateIssue(String reqBody) {
        
        HttpRequest req = new HttpRequest();
        
        req.setBody(reqBody);
        HttpResponse resp = sendRequest(req, 'POST', createIssueURL, false);
        String responseString = resp.getBody();
        
        system.debug('** Response : ' +responseString);
        if (responseString.contains('errors')) {
            
            //responseString = responseString.remove('\{');
            //responseString = responseString.remove('\}');
            responseString = responseString.remove('\"');
            responseString = '{"response" : \"' + responseString + '\"}';
            
        }
        LGJiraCreateIssueResponse res = (LGJiraCreateIssueResponse)JSON.deserialize(responseString, LGJiraCreateIssueResponse.class);
        
        
        return res;
        
    }
    
/*    public String ModifyIssue(String issueId, String reqBody) {
        
        HttpRequest req = new HttpRequest();
        
        req.setBody(reqBody);
        String getIssueURL = modifyIssueURL + issueId;
        HttpResponse res = sendRequest(req, 'PUT', getIssueURL, false);
        String responseString = res.getBody();
        system.debug('** Response : ' +responseString);
        return responseString;
        
    }
    
    public String DeleteIssue(String issueId, String reqBody) {
        
        HttpRequest req = new HttpRequest();
        
        //req.setBody(reqBody);
        HttpResponse res = sendRequest(req, 'DELETE', deleteIssueURL, false);
        String responseString = res.getBody();
        
        return responseString;
        
    }
    
    public String SearchGetIssue(String issueId) {
        
        HttpRequest req = new HttpRequest();
        
        HttpResponse res = sendRequest(req, 'GET', searchGetIssueURL, false);
        String responseString = res.getBody();//sendRequest(req, 'GET', searchGetIssueURL, false);
        
        return responseString;
        
    }
    
    //public JSON2Apex GetIssue(String issueId) {
    public String GetIssue(String issueId) {
        
        //JIRAResponse.JSON2Apex getIssueDetails = null;
        HttpRequest req = new HttpRequest();
        
        String getIssueURL = modifyIssueURL + issueId;
        HttpResponse res = sendRequest(req, 'GET', getIssueURL, false);
        String responseString = res.getBody();
        
        return '{"Response" : ' +responseString + '}';
        
    }
*/    
    public HttpResponse GetIssue(String issueId, Boolean getFullResponse) {
        
        //JIRAResponse.JSON2Apex getIssueDetails = null;
        HttpRequest req = new HttpRequest();
        
        String getIssueURL = modifyIssueURL + issueId;
        return sendRequest(req, 'GET', getIssueURL, getFullResponse);
        
        //return '{"Response" : ' +responseString + '}';
        
    }
    
    public String SearchPostIssue(String reqBody) {
        
        HttpRequest req = new HttpRequest();
        
        req.setBody(reqBody);
        HttpResponse res = sendRequest(req, 'POST', searchPostIssueURL, false);
        String responseString = res.getBody();
        
        return responseString;
        
    }
    
    public JiraSearchIssueResponse SearchPostIssue(List<String> issueids, List<String> fields) {
        JiraSearchIssueRequest searchRequest = new JiraSearchIssueRequest();
        searchRequest.startAt =0;
        searchRequest.maxResults =500;
        searchRequest.jql = 'key in (' + String.join(issueids, ',') +')';
        searchRequest.fields = fields;
        String searchRequestJson = JSON.serialize(searchRequest);
        System.debug('SearchPostIssue Request : '+searchRequestJson);
        HttpRequest req = new HttpRequest();
        
        req.setBody(searchRequestJson);
        HttpResponse res = sendRequest(req, 'POST', searchPostIssueURL, false);
        String responseString = res.getBody();
        System.debug('Http response: '+responseString);
        if(res.getStatusCode() != 200) {
            //String responseBody = resplinkedIssueTasks.getBody();
            
            //ErrorResponse errResp = (ErrorResponse)JSON.deserialize(responseString, ErrorResponse.class);
            
            //throw new CustomException(errResp.errorMessages[0]);
            throw new CustomException(responseString);
        } 
        JiraSearchIssueResponse resObj = (JiraSearchIssueResponse)JSON.deserialize(responseString, JiraSearchIssueResponse.class);
        return resObj;
        
    }
/*    public String HealthCheck() {
        
        HttpRequest req = new HttpRequest();
        
        HttpResponse res = sendRequest(req, 'GET', healthCheckURL, false);
        String responseString = res.getBody();
        
        return responseString;
        
    }
    public String JiraGeneric() {
        
        HttpRequest req = new HttpRequest();
        
        
        HttpResponse res = sendRequest(req, 'GET', jiraGenericURL, false);
        String responseString = res.getBody();
        
        return responseString;
        
    }
*/    
    public HttpResponse SendRequest(HttpRequest req, String method, String url, Boolean refreshToken) {
        
        LGJira2TokenDetail getTokenDetails = new LGJira2TokenDetail();
        getTokenDetails = GetAccessToken(refreshToken);
        
        String bearerToken = getTokenDetails.access_token;
        String authString = userName + ':' + passWord;
        //byte[] authEncBytes = Base64.encodeBase64(authString.getBytes());
        //String basicToken = new String(authEncBytes);
        
        Blob headerValue = Blob.valueOf(authString);
        String authorizationHeader = 'Bearer ' + bearerToken + ',Basic ' + EncodingUtil.base64Encode(headerValue);
        
        system.debug('**** access_token 123 : ' + authorizationHeader);
        
        Http h = new Http();
        req.setMethod(method);
        req.setEndpoint(url);
        req.setTimeout(120000);
        req.setHeader('authorization', authorizationHeader);
        req.setHeader('apikey', apiKey);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Host', host);
        
        
        HttpResponse res;
        /* if (Test.isRunningTest()) {
            if (url.contains('EWM-00000')) {
                
                String respBody = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                    '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                    '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                    '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                    '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                    '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key": "EWM-00000"}] } }';
                
                HttpResponse resp = new HttpResponse();
                resp.setBody(respBody);
                return resp;
                
            } else if (url.contains('EWM-11111')) {
                
                String respBody = '{"id":"test","key": "EWM-11111","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-11111", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                    '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-11111", "fields":{   "summary":"Test New Request 001",' +
                    '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                    '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                    '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                    '"customfield_11500":{"value":"NASCO"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key": "EWM-11111"}] } }';
                HttpResponse resp = new HttpResponse();
                resp.setBody(respBody);
                return resp;
            }
            
            HttpResponse resp = new HttpResponse();
            resp.setBody('{"id":"test"}');
            return resp;
        } else { 
        */
            system.debug('request : '+req);
            res = h.send(req);
            system.debug('**** Response: ');
            system.debug(res);
            system.debug(res.getBody());
        /*}
        if(test.isrunningtest())
        {
            getTokenDetails.isNewToken =true;
        } 
		*/
        
        if (getTokenDetails.isNewToken == true) {
            
            accessTokenValue = getTokenDetails.access_token;
            createTokenTime = getTokenDetails.currentTime;
            //UpdateTokenTable(getTokenDetails.access_token, getTokenDetails.currentTime);
        }
        return res;
        
    }
    
    public LGJira2TokenDetail AccessToken() {
        
        LGJira2TokenDetail getTokenDetails = new LGJira2TokenDetail();
        
        String authString = clientId + ':' + clientSecret;
        //byte[] authEncBytes = Base64.encodeBase64(authString.getBytes());
        //String basicToken = new String(authEncBytes);
        
        Blob headerValue = Blob.valueOf(authString);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        System.debug('Access Token Auth Header :'+authorizationHeader);
        system.debug(' search info : ' + accessTokenURL + ' ' + host);
        
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(accessTokenURL);
        req.setTimeout(120000);
        req.setHeader('authorization', authorizationHeader);
        req.setHeader('apikey', apiKey);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Host', host);
        req.setBody('scope=public&grant_type=client_credentials');
        
        /*
        if (Test.isRunningTest()) {
            //Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            //String output = WebSvcCallout.callEchoString('Hello World!');
            getTokenDetails.issued_at = 'test';
            getTokenDetails.application_name = 'test';
            getTokenDetails.status = 'test';
            getTokenDetails.expires_in = 'test';
            getTokenDetails.client_id = 'test';
            getTokenDetails.access_token = 'test';
            getTokenDetails.currentTime = system.now();
        } else { 
        */
            HttpResponse res = h.send(req);
            
            System.debug('Status - '+res.toString());
            System.debug('Response'+res.getbody());
            getTokenDetails = (LGJira2TokenDetail)JSON.deserialize(res.getbody(), LGJira2TokenDetail.class);
            getTokenDetails.currentTime = datetime.now();
            System.debug('LGJira2TokenDetail - '+getTokenDetails);
            System.debug('***************Returning OAuth From Server - '+getTokenDetails.access_token);
        //}
        
        getTokenDetails.isNewToken = true;
        
        return getTokenDetails;
        
    }
    
    
    
    public LGJira2TokenDetail GetAccessToken (Boolean refreshToken){
        LGJira2TokenDetail getTokenDetails = new LGJira2TokenDetail();
        
        //String tokenCode = QueryTokenTable();
        if (refreshToken == true) {
            
            getTokenDetails  = AccessToken();
        } else {
            getTokenDetails = QueryTokenTable();
            if(getTokenDetails.access_token == null)
            {
                getTokenDetails  = AccessToken();
                //tokenCode  = getTokenDetails.access_token;
            }
        }
        
        
        system.debug('**** search 123 : ' + getTokenDetails);
        
        return getTokenDetails;
    }
    
    public LGJira2TokenDetail QueryTokenTable(){
        LGJira2TokenDetail tempTokenDetail = new LGJira2TokenDetail();
        String tokenCode;
        List<LGJiraAccessToken__c> oAuthTablLst = [select Id, CreatedTime__c, Access_Token__c from LGJiraAccessToken__c where Name = 'Token4Jira' limit 1];
        LGJiraAccessToken__c oAuthTabl;
        if(oAuthTablLst.size() > 0){
            oAuthTabl = (LGJiraAccessToken__c) oAuthTablLst.get(0);
            if(oAuthTabl != null && oAuthTabl.CreatedTime__c != null){
                
                Datetime dtTime = oAuthTabl.CreatedTime__c;
                DateTime newDateTime = dtTime.addminutes(tokenRefreshTime);
                Datetime currentDateTime = datetime.now();
                System.debug('System Time - '+newDateTime);
                System.debug('Current Time - '+currentDateTime);
                if(newDateTime > currentDateTime) {
                    
                    tokenCode = oAuthTabl.Access_Token__c; 
                    tempTokenDetail.access_token = tokenCode;
                    tempTokenDetail.currentTime = oAuthTabl.CreatedTime__c;
                    
                }            
            }
        }
        System.debug('***************Returning OAuth From DB - '+tokenCode);
        
        
        return tempTokenDetail;
    }
    
    
    public void UpdateTokenTable(){
        
        List<LGJiraAccessToken__c> oAuthTablLst = [select Id, CreatedTime__c, Access_Token__c from LGJiraAccessToken__c where Name = 'Token4Jira' limit 1];
        LGJiraAccessToken__c oAuthTabl;
        if(oAuthTablLst.size() > 0){
            oAuthTabl = (LGJiraAccessToken__c) oAuthTablLst.get(0);
            if(oAuthTabl != null){
                oAuthTabl.Access_Token__c = accessTokenValue;
                oAuthTabl.CreatedTime__c = createTokenTime;
                update oAuthTabl;
            }
            
        } else{
            oAuthTabl = new LGJiraAccessToken__c();
            oAuthTabl.Access_Token__c = accessTokenValue;
            oAuthTabl.CreatedTime__c = createTokenTime;
            oAuthTabl.Name = 'Token4Jira';
            insert oAuthTabl;
        }
    }
    
    
    
}