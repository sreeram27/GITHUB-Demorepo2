/*
@Author : Arun Siddappa
@name : CIP_RestAPI_Session_Handler 
@CreateDate :06-30-2017
@Description : This class is to get the session identifier from old org to make REST API call to send Quote Data
*/
public class CIP_RestAPI_Session_Handler {
    private static SessionObject oauthLogin(String loginUri, String clientId,
    String clientSecret, String username, String password) {
        HttpRequest httpReq = new HttpRequest();     
        httpReq.setMethod('POST');
        httpReq.setEndpoint(loginUri);
        httpReq.setBody('grant_type=password' +
        '&client_id=' + clientId +
        '&client_secret=' + clientSecret +
        '&username=' + EncodingUtil.urlEncode(username, 'UTF-8') +
        '&password=' + EncodingUtil.urlEncode(password, 'UTF-8'));
        Http http = new Http();
        HTTPResponse httpRes = http.send(httpReq);
        System.debug('RESPONSE ' +httpRes);
        System.debug('BODY: '+httpRes.getBody());
        System.debug('STATUS:'+httpRes.getStatus());
        System.debug('STATUS_CODE:'+httpRes.getStatusCode());        
        return GetSessionObject (httpRes.getBody());
    }
    
    public class SessionObject {
        public String id;
        public String issued_at;
        public String instance_url;
        public String signature;
        public String access_token;
    }
    public static SessionObject GetSessionObject(String json) {
        return (SessionObject) System.JSON.deserialize(json, SessionObject.class);
    }
    
    public static SessionObject restTest() {
        CIPIntegration__c cipSF = CIPIntegration__c.getOrgDefaults();
        String sessionURL = cipSF.SessionURL__c;
        String userId = cipSF.User_Name_For_Old_Org__c;
        String password = cipSF.Password_For_Old_Org__c;
        String consumerSecKey = cipSF.Consumer_Secret_For_Old_Org__c;
        String consumerKey = cipSF.Consumer_Key_For_Old_Org__c;
        SessionObject jsonObject = oauthLogin(sessionURL, consumerKey, consumerSecKey, userId, password);            
        return jsonObject;
    }
    
}