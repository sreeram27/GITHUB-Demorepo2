/*
 * @description This class makes callouts to the CM endpoint 
 */
public class CMIntegrationUtility {

    public static String authToken;
    public static string endPointUrl;
    public static String accessTokenURL;
    public static String grpNoReqEndpointURL;
    public String apiKey;
    public String clientId;
    public String clientSecret;
    public String host;
    public String namedCredential;
    
    public CMIntegrationUtility(){
        Organization org = [Select IsSandbox, InstanceName From Organization];
        
        Service_Interface_Endpoint_Setting__mdt connectionDetails;
        if (org.IsSandbox == true) {
            connectionDetails = [Select AccessToken_URL__c, label,ApiKey__c, Endpoint_URL__c, Named_Credential__c, ClientID__c, ClientSecret__c,Host__c, 
                                 GroupNo_Req_Endpoint__c
                                 From Service_Interface_Endpoint_Setting__mdt 
                                 Where DeveloperName = 'CM_Endpoint_Sandbox'];
        } else {
            connectionDetails = [Select AccessToken_URL__c, label,ApiKey__c, Endpoint_URL__c, Named_Credential__c, ClientID__c, ClientSecret__c,Host__c, 
                                 GroupNo_Req_Endpoint__c
                                 From Service_Interface_Endpoint_Setting__mdt 
                                 Where DeveloperName = 'CM_Endpoint_Production'];
        }
        apiKey = connectiondetails.ApiKey__c;
        clientId = connectiondetails.ClientID__c;
        clientSecret = connectiondetails.ClientSecret__c;
        host = connectiondetails.Host__c;
        endPointUrl = connectiondetails.Endpoint_URL__c;
        grpNoReqEndpointURL = connectiondetails.GroupNo_Req_Endpoint__c;
        accessTokenURL=connectiondetails.AccessToken_URL__c;
        namedCredential = connectiondetails.Named_Credential__c;
    } 
    
    public StatusDetails sendCMReqInfo(CMIntegrationRequest CMReq) {
     
        System.debug('Req:' + JSON.serializePretty(CMReq));
        HttpRequest req = new HttpRequest();
        CMIntgrtnAPITokenDetails tokenDetails = getAuthToken();
        system.debug('tokenDetails******:' + tokenDetails.access_token);
        
        //String endPoint = 'callout:'+namedCredential+endPointUrl;
        //System.debug('Endpoint URL: '+endPoint);
        
        String authorizationHeader = 'Bearer ' + tokenDetails.access_token;
        Http httpReq = new Http();
        req.setMethod('POST');
        req.setEndpoint(endPointUrl);
        req.setTimeout(120000);
        req.setBody(JSON.serialize(CMReq,true));
        req.setHeader('authorization', authorizationHeader);
        req.setHeader('apikey', apiKey);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Host', host);
        HttpResponse res = new HttpResponse();
        system.debug('req*****:' + req.getBody());
        
        res = httpReq.send(req);
        system.debug('res*****:' + res);
        system.debug('Response body : '+ res.getBody());
        
        CMIntegrationUtility.StatusDetails retStatus= new StatusDetails();
        retStatus.statusCode = res.getStatusCode();
        retStatus.statusMessage = res.getStatus();
        
        return retStatus;
    }
    
    //This method is to get the auth tocken from DP
    public CMIntgrtnAPITokenDetails getAuthToken(){
        
        CMIntegrationUtility.CMIntgrtnAPITokenDetails tokenDetails = new CMIntgrtnAPITokenDetails();
        /*String authString = clientId + ':' + clientSecret;
        Blob headerValue = Blob.valueOf(authString);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        */
        String accessTokenEndPoint = 'callout:'+namedCredential+accessTokenURL;
        System.debug('Access Token Endpoint: '+accessTokenEndPoint);
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
       // req.setEndpoint('callout:SOAIntegrationSandbox/v1/oauth/accesstoken');
        req.setMethod('POST');
        req.setEndpoint(accessTokenEndPoint);
        req.setTimeout(120000);
        //req.setHeader('authorization', authorizationHeader);
        req.setHeader('apikey', apiKey);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Host', host);
        req.setBody('scope=public&grant_type=client_credentials');
        
        HttpResponse res = h.send(req);
        System.debug('Status - '+res.toString());
        tokenDetails = (CMIntegrationUtility.CMIntgrtnAPITokenDetails)JSON.deserialize(res.getbody(), CMIntegrationUtility.CMIntgrtnAPITokenDetails.class);
        System.debug('tokenDetails*******:'+tokenDetails);
        
        return tokenDetails;
    }
    
    public class CMIntgrtnAPITokenDetails {
        public String issued_at{get;set;}
        public String application_name{get;set;}
        public String status{get;set;}
        public String expires_in{get;set;}
        public String client_id{get;set;}    
        public String access_token{get;set;}
        public Datetime currentTime{get;set;}
        public Boolean isNewToken{get;set;}
    }
    
    public class StatusDetails {
        public Integer statusCode{get;set;}
        public String statusMessage{get;set;}
        public CMGroupNumberResponse response;
        public String rawResponse;
    }
    
    public StatusDetails sendGroupNumberRequestInfo(CMGroupNumberRequest grpNoReq) {
     
        System.debug('Req:' + JSON.serializePretty(grpNoReq));
        HttpRequest req = new HttpRequest();
        CMIntgrtnAPITokenDetails tokenDetails = getAuthToken();
        system.debug('tokenDetails******:' + tokenDetails.access_token);
        
        String authorizationHeader = 'Bearer ' + tokenDetails.access_token;
        Http httpReq = new Http();
        req.setMethod('POST');
        req.setEndpoint(grpNoReqEndpointURL);
        req.setTimeout(120000);
        req.setBody(JSON.serialize(grpNoReq,true));
        req.setHeader('authorization', authorizationHeader);
        req.setHeader('apikey', apiKey);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Host', host);
        HttpResponse res = new HttpResponse();
        system.debug('req*****:' + JSON.serialize(grpNoReq,true));
        
        res = httpReq.send(req);
        system.debug('res*****:' + res);
        system.debug('Response body : '+ res.getBody());
        
        StatusDetails retStatus = new StatusDetails();
        
       // if(res.getStatusCode() >= 200 && res.getStatusCode() <300){
        retStatus.statusCode = res.getStatusCode();
        retStatus.statusMessage = res.getStatus();
        if(res.getBody() != null){
            retStatus.rawResponse = res.getBody();
            try{
                CMGroupNumberResponse response = (CMGroupNumberResponse)JSON.deserialize(res.getBody(), CMGroupNumberResponse.class);
                retStatus.response = response;
            }
            catch(Exception ex){
                retStatus.statusMessage = 'Exception in parsing resp msg: '+ex.getMessage()+ ' - Error Response Body : '+res.getBody();
            }
        }

        System.debug('CM Group No response: '+retStatus.response);
        System.debug('Ret Status: '+retStatus.statusMessage);
        return retStatus;
    }
}