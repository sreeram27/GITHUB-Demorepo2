public class CDHPISGSessionAuthenticator {
     public static SessionObject getSessionObject() {
        CDHPISGIntegrationSettings__c sig = CDHPISGIntegrationSettings__c.getOrgDefaults();
        String sessionURL = sig.Session_URL__c;
        String userId = sig.User_Name__c;
        String password = sig.Password__c;
        String consumerSecKey = sig.Consumer_Secret__c;
        String consumerKey = sig.Consumer_Key__c;
        SessionObject jsonObject = oauthLogin(sessionURL, consumerKey, consumerSecKey, userId, password);            
        return jsonObject;
    }
    
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
        System.debug('Response****: ' +httpRes);
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
    
   
    
}