public class CastLightIntegrationUtility {
    
    
    
    public static String clientSecret;
    public static String userName;
    public static String passWord;
    public static string consumerKey; //clientid
    public static string oauth;
    public static string endpoint;
    public static Integer sessiontimeout;
    public static String accessTokenURL;
    public static Integer tokenRefreshTime;
    private static String accessTokenValue;
    private static Datetime createTokenTime;
    
    static {
        Organization org = [Select IsSandbox, InstanceName From Organization];
        CastLight_Connection_Details__mdt connectiondetails;
        if (org.IsSandbox == true) {
            
            connectiondetails = [Select TokenRefreshTime__c,AccessToken__c,label,Application_Password__c,Application_Username__c,Client_Secret__c,Consumer_Key__c,Oauth_URL__c,Service_EndPoint__c,Session_Timeout__c From CastLight_Connection_Details__mdt Where label = 'CastLight_Sandbox'];
            
        } else {
            
            connectiondetails = [Select TokenRefreshTime__c,AccessToken__c,label,Application_Password__c,Application_Username__c,Client_Secret__c,Consumer_Key__c,Oauth_URL__c,Service_EndPoint__c,Session_Timeout__c From CastLight_Connection_Details__mdt Where label = 'CastLight_Production'];
            
        }
        
        
        
        passWord = connectiondetails.Application_Password__c;
        userName = connectiondetails.Application_Username__c;
        clientSecret = connectiondetails.Client_Secret__c;
        consumerKey = connectiondetails.Consumer_Key__c;
        oauth = connectiondetails.Oauth_URL__c;
        endpoint = connectiondetails.Service_EndPoint__c;
        sessiontimeout = Integer.valueof(connectiondetails.Session_Timeout__c);
        tokenRefreshTime = Integer.valueOf(connectiondetails.TokenRefreshTime__c);
        accessTokenURL=connectiondetails.AccessToken__c;
        
    }
    Public class Response
    {
        public string statusmessage {get;set;}
        public Integer statuscode {get;set;}
        
    }
   
    public static Response SendDataToCastlight(CastLightRequestResponse.Account request)
    {
        string reqBody = '{"Accounts": ' + '[' + JSON.serialize(request, true) + ']' + '}';
        system.debug('JSON Serialized string---->' + reqBody);
        HttpRequest req = new HttpRequest();
        req.setBody(reqBody);
        HttpResponse response=SendRequest(req,'POST', false);
        Response r=new Response();
        r.statusmessage=response.getBody();
        r.statuscode =response.getStatusCode();
        return r;
        
    }
    
    public static HttpResponse SendRequest(HttpRequest req, String method, Boolean refreshToken) {
        
        //CastLightTokenDetail getTokenDetails = new CastLightTokenDetail();
        CastLightTokenDetail getTokenDetails;
        getTokenDetails = GetAccessToken(refreshToken);
        String bearerToken = getTokenDetails.access_token;
        
        
        Http h = new Http();
        req.setMethod(method);
        req.setEndpoint(endpoint);
        req.setTimeout(sessiontimeout);
        //req.setHeader('Authorization', 'OAuth '+bearerToken);
        req.setHeader('Authorization', 'Bearer '+bearerToken);
        
        //req.setHeader('apikey', apiKey);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        //req.setHeader('Host', host);
        
        
        HttpResponse res;
     
            system.debug('request utility: '+req);
            res = h.send(req);
            system.debug('**** Response utility: ');
            system.debug(res);
            system.debug(res.getBody());
       
       
        if (getTokenDetails.isNewToken == true) {
            system.debug('token val:'+getTokenDetails.access_token);
            accessTokenValue = getTokenDetails.access_token;
            createTokenTime = getTokenDetails.currentTime;
            UpdateTokenTable();
           
        }
        return res;
        
    }
    
    public static CastLightTokenDetail AccessToken() {
        
        CastLightTokenDetail getTokenDetails = new CastLightTokenDetail();
        //Blob consumerKeydecoded=EncodingUtil.base64Decode(consumerKey);
        string consumerKeyret=string.valueof(consumerKey);
        //Blob clientSecretdecoded=EncodingUtil.base64Decode(clientSecret);
        string clientSecretret=string.valueof(clientSecret);
        //Blob passworddecoded=EncodingUtil.base64Decode(passWord);
        string passwordret=string.valueof(passWord);
        system.debug(' search info : ' + accessTokenURL );
        
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(accessTokenURL);
        req.setTimeout(sessiontimeout);
        //req.setHeader('authorization', authorizationHeader);
        //req.setHeader('apikey', apiKey);
        //req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //req.setHeader('Accept', 'application/json');
        //req.setHeader('Host', host);
        req.setBody('grant_type=password&client_id='+consumerKeyret+'&client_secret='+clientSecretret+'&username='+userName+'&password='+passwordret);
        
           
            HttpResponse res = h.send(req);
            
            System.debug('Status - '+res.toString());
            System.debug('Response'+res.getbody());
            getTokenDetails = (CastLightTokenDetail)JSON.deserialize(res.getbody(), CastLightTokenDetail.class);
            getTokenDetails.currentTime = datetime.now();
            System.debug('CastLightTokenDetail - '+getTokenDetails);
            System.debug('***************Returning OAuth From Server - '+getTokenDetails.access_token);
            System.debug('***************Returning Instance URL - '+getTokenDetails.instance_url);
             getTokenDetails.isNewToken = true;
        
        return getTokenDetails;
        
    }
    
    
    
    public static CastLightTokenDetail GetAccessToken (Boolean refreshToken){
        CastLightTokenDetail getTokenDetails = new CastLightTokenDetail();
        
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
    
    public static CastLightTokenDetail QueryTokenTable(){
        system.debug('tokenRefreshTime:'+tokenRefreshTime);
        CastLightTokenDetail tempTokenDetail = new CastLightTokenDetail();
        String tokenCode;
        List<CastLightAccessToken__c> oAuthTablLst = [select Id, CreatedTime__c, Access_Token__c from CastLightAccessToken__c where Name = 'TokenforCastLight' limit 1];
        CastLightAccessToken__c oAuthTabl;
        if(oAuthTablLst.size() > 0){
            oAuthTabl = (CastLightAccessToken__c) oAuthTablLst.get(0);
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
    
    
    public static void UpdateTokenTable(){
        system.debug('update token table:'+accessTokenValue);
        List<CastLightAccessToken__c> oAuthTablLst = [select Id, CreatedTime__c, Access_Token__c from CastLightAccessToken__c where Name = 'TokenforCastLight' limit 1];
        CastLightAccessToken__c oAuthTabl;
        if(oAuthTablLst.size() > 0){
            oAuthTabl = (CastLightAccessToken__c) oAuthTablLst.get(0);
            if(oAuthTabl != null){
                oAuthTabl.Access_Token__c = accessTokenValue;
                oAuthTabl.CreatedTime__c = createTokenTime;
                update oAuthTabl;
            }
            
        } else{
            system.debug('here');
            oAuthTabl = new CastLightAccessToken__c();
            oAuthTabl.Access_Token__c = accessTokenValue;
            oAuthTabl.CreatedTime__c = createTokenTime;
            oAuthTabl.Name = 'TokenforCastLight';
            insert oAuthTabl;
        }
    }
    
    
    
}