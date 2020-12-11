public class ContCodeReservServiceUtility {
    
    public static String authToken;
    public static string endpoint;
    public static string endpointRelease;
    public static String accessTokenURL;
    public String apiKey;
    public String clientId;
    public String clientSecret;
    public String host;
    public ContCodeReservServiceUtility() {
        Organization org = [Select IsSandbox, InstanceName From Organization];
        Cont_Code_Service_Endpoint_Setting__mdt connectiondetails;
        if (org.IsSandbox == true) {
            connectiondetails = [Select AccessToken__c, label,Release_Endpoint__c,Reserv_Endpoint__c,ApiKey__c, ClientID__c, ClientSecret__c,Host__c From Cont_Code_Service_Endpoint_Setting__mdt Where label = 'Cont Code Sandbox'];
        } else {
            connectiondetails = [Select AccessToken__c, label,Release_Endpoint__c,Reserv_Endpoint__c,ApiKey__c, ClientID__c, ClientSecret__c,Host__c From Cont_Code_Service_Endpoint_Setting__mdt Where label = 'Cont Code Production'];
        }
        apiKey = connectiondetails.ApiKey__c;
        clientId = connectiondetails.ClientID__c;
        clientSecret = connectiondetails.ClientSecret__c;
        host = connectiondetails.Host__c;
        endpoint = connectiondetails.Reserv_EndPoint__c;
        accessTokenURL=connectiondetails.AccessToken__c;
        endpointRelease = connectiondetails.Release_EndPoint__c;
        
    }
    
    public  ContCodeReserveResponse reserveContractCode(ContCodeReservRequest CCReq) {
        ContCodeReserveResponse serviceRes = new ContCodeReserveResponse();
        
        System.debug('Req:' + JSON.serializePretty(CCReq));
        HttpRequest req = new HttpRequest();
        ContCodeAPITokenDetails tokenDetails = getAuthToken();
        system.debug('tokenDetails******:' + tokenDetails.access_token);
        //TODO: Need to have check for valid tocken
        /* if(String.isEmpty(tokenDetails.access_token)){

        }*/
        
        String authorizationHeader = 'Bearer ' + tokenDetails.access_token;
        Http httpReq = new Http();
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setTimeout(120000);
        req.setBody(JSON.serialize(CCReq,true));
        req.setHeader('authorization', authorizationHeader);
        req.setHeader('apikey', apiKey);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Host', host);
        HttpResponse res = new HttpResponse();
        system.debug('req*****:' + req.getBody());
        system.debug('req.getEndpoint()*****:' + req.getEndpoint());
        
        res = httpReq.send(req);
        system.debug('res*****:' + res);
        system.debug('Response body : '+ res.getBody());
        
        /*if(res.getStatusCode() == 200){*/
        if(res.getBody() != null){
        serviceRes =(ContCodeReserveResponse) JSON.deserialize(res.getBody(), ContCodeReserveResponse.class);
        }
        else{
            ContCodeReserveResponse.status statusRes = new ContCodeReserveResponse.status();
            statusRes.Code = String.ValueOf(res.getStatusCode());
            statusRes.Message = res.getStatus();
            
           serviceRes.Status = statusRes;
        } 
        system.debug('response*****:' + serviceRes);
        
        return serviceRes;
            
    }
   /* public  ContCodeReleaseResponse releaseContractCode(ContCodeReleaseRequest CCReq) {
        ContCodeReleaseResponse releaseRes = new ContCodeReleaseResponse();
        System.debug('Req:' + JSON.serializePretty(CCReq));
        HttpRequest req = new HttpRequest();
        ContCodeAPITokenDetails tokenDetails = getAuthToken();
        String authorizationHeader = 'Bearer ' + tokenDetails.access_token;
        Http httpReq = new Http();
        req.setMethod('POST');
        req.setEndpoint(endpointRelease);
        req.setTimeout(120000);
        req.setBody(JSON.serialize(CCReq,true));
        req.setHeader('authorization', authorizationHeader);
        req.setHeader('apikey', apiKey);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Host', host);
        HttpResponse res = new HttpResponse();
        system.debug('req*****:' + req.getBody());
        system.debug('req.getEndpoint()*****:' + req.getEndpoint());
        
        res = httpReq.send(req);
        system.debug('res*****:' + res);
        
        releaseRes =(ContCodeReleaseResponse) JSON.deserialize(res.getBody(), ContCodeReleaseResponse.class);
        system.debug('releaseRes:' + releaseRes);
        return releaseRes;
    } */
    
    //This method is to get the auth tocken from DP
    public ContCodeAPITokenDetails getAuthToken(){
        ContCodeReservServiceUtility.ContCodeAPITokenDetails tockenDetails = new ContCodeAPITokenDetails();
        String authString = clientId + ':' + clientSecret;
        Blob headerValue = Blob.valueOf(authString);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
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
        
        HttpResponse res = h.send(req);
        System.debug('Status - '+res.toString());
        tockenDetails = (ContCodeReservServiceUtility.ContCodeAPITokenDetails)JSON.deserialize(res.getbody(), ContCodeReservServiceUtility.ContCodeAPITokenDetails.class);
        System.debug('tockenDetails*******:'+tockenDetails);
        
        return tockenDetails;
    }
    
    public class ContCodeAPITokenDetails {
        public String issued_at{get;set;}
        public String application_name{get;set;}
        public String status{get;set;}
        public String expires_in{get;set;}
        public String client_id{get;set;}    
        public String access_token{get;set;}
        public Datetime currentTime{get;set;}
        public Boolean isNewToken{get;set;}
    }
    
    public ContCodeReservRequest buildRequest(String qliID, Order implCase){
        ContCodeReservRequest contCodeReservRequest = new contCodeReservRequest();
        /* To DO - develop code to populate contCodeReservRequest Object */
        
        List<QuoteLineItem> qlineitemList = [Select Id, Contract_Codes__c, vlocity_ins__ContractCode__c, Actwise_Member_Provider_Pay_Indicator__c, Anthem_Engage_Indicators__c, HPCC_Code__c, Product2.HPCC_code__c, Product_Type__c,
                                             Funding__c, Situs_State_Abbrev__c, Quote.Account.Situs_State__c, EffectiveDate__c, Quote.GroupNumber__r.Effective_Date__c, Quote.GroupSize__c, Plan_Type__c, Product2.Plan_Type__c,  
                                             CEP_Indicator__c, Group_Number__c, Quote.Non_Pooled__c, OpportunityEffectiveDate__c, Quote.GroupNumber__r.Performance_Indicator__c, P2AModified__c,  Quote.Account_Name__c,
                                             Quote.GroupNumber__r.Date_Migrated_to_WGS__c, HCR_Status__c
                                             FROM QuoteLineItem 
                                             WHERE Id =: qliID];
        
        contCodeReservRequest.baseContract          = qlineitemList[0].vlocity_ins__ContractCode__c!=null? qlineitemList[0].vlocity_ins__ContractCode__c: qlineitemList[0].Contract_Codes__c;
        contCodeReservRequest.planModifiedInd       = qlineitemList[0].P2AModified__c == 'Yes'?'Y':'N';
       // contCodeReservRequest.actwiseIndicator      = qlineitemList[0].Actwise_Member_Provider_Pay_Indicator__c;
        contCodeReservRequest.engageIndicators      = qlineitemList[0].Anthem_Engage_Indicators__c;
        contCodeReservRequest.hpcc                  = qlineitemList[0].HPCC_Code__c != null? qlineitemList[0].HPCC_Code__c : qlineitemList[0].Product2.HPCC_code__c;
        contCodeReservRequest.fundingTypeCode       = qlineitemList[0].Funding__c;
        contCodeReservRequest.stateCode             = qlineitemList[0].Situs_State_Abbrev__c;  
        contCodeReservRequest.quoteLineItem         = qlineitemList[0].Id;
        contCodeReservRequest.effectiveDate         = String.valueOf(qlineitemList[0].OpportunityEffectiveDate__c);
        contCodeReservRequest.groupSize             = qlineitemList[0].Quote.GroupSize__c;
        
        List<Product2> prod = [Select Id, Contract_Code__c, Plan_Type__c from Product2 where Contract_Code__c =:contCodeReservRequest.baseContract LIMIT 1];
        /* select product2 record with contract_code__c =contCodeReservRequest.baseContract. 
           If you find product2 record with this contract code. take value of plan_type__c field from product2 record
           If no product record found then take the value from quotelineitem.plan_type__c*/
        
        contCodeReservRequest.baseContractType      = prod.size()>0? prod[0].Plan_Type__c: qlineitemList[0].Plan_Type__c;
        contCodeReservRequest.CEPIndicator          = qlineitemList[0].CEP_Indicator__c == 'Yes'?'Y':'N';
        contCodeReservRequest.performanceGuarantee  = qlineitemList[0].Quote.GroupNumber__r.Performance_Indicator__c;
        contCodeReservRequest.wgsGroupId            = qlineitemList[0].Group_Number__c;
        contCodeReservRequest.poolingStatus         = qlineitemList[0].Quote.Non_Pooled__c;
        
        contCodeReservRequest.lob					= qlineitemList[0].Product_Type__c; //To Confirm if Product2.LOB__c should be used? 
        contCodeReservRequest.implRecordId          = implCase.OrderNumber;
        contCodeReservRequest.wgsGroupName          = qlineitemList[0].Quote.Account_Name__c;
        contCodeReservRequest.groupType				= implCase.Implementation_Type__c; //implCase.RecordType.Name; //To confirm if any transformation is needed?? 
        contCodeReservRequest.wgsGroupMigrationDate = String.valueOf(qlineitemList[0].Quote.GroupNumber__r.Date_Migrated_to_WGS__c);
        contCodeReservRequest.hcrStatus             = qlineitemList[0].HCR_Status__c;
        
        //Get Riders related to this qli from ProductSelectionDetail Object 
        List<ProductSelectionDetail__c> ridersList = [Select Id, Rider__r.Name 
                                                      FROM ProductSelectionDetail__c
                                                      WHERE QuoteLineItem__c =: qlineitemList[0].id
                                                      AND RecordType.Name = 'LG_Rider_Plan_Assoc'];
        System.debug('Rider size: '+ridersList);
        if(ridersList.size()>0){
            List<ContCodeReservRequest.riders> riders = new List<ContCodeReservRequest.riders>();
            contCodeReservRequest.riders = riders;
            for(ProductSelectionDetail__c productSelection : ridersList){
               ContCodeReservRequest.riders rider = new ContCodeReservRequest.riders();
                rider.name = productSelection.Rider__r.Name ;
                riders.add(rider);
            }
        }
               
        contCodeReservRequest.callingSystem         = 'SFDCCOM2';
        contCodeReservRequest.transactionId         = qlineitemList[0].Id + '-'+ String.valueOf(DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')); 
        contCodeReservRequest.transactionTimestamp  = String.valueOf(DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
        
        System.debug(contCodeReservRequest);
        return contCodeReservRequest;
        
    }
    
   //Generate GUID to pass as transactionID in the request
  /*  public static String getUniqueTransactionID(){
        Blob b = Crypto.GenerateAESKey(128);
        String hexValue = EncodingUtil.ConvertTohex(b);
        String txnid= hexValue.SubString(0,8)+ '-' + hexValue.SubString(8,12) + '-' + hexValue.SubString(12,16) + '-' + hexValue.SubString(16,20) + '-' + hexValue.substring(20);
        System.debug(txnid);
        
        return txnid; 
    } */
}