/*
@Author : Arun Siddappa
@name : CIP_RestAPI_Client_Handler 
@CreateDate :05-30-2017
@Description : This class is to send the quote data to Old Org by making REST API Call to create Opportunity Group Number Record 
*/
public class CIP_RestAPI_Client_Handler {
    public static CIPFields CreateCIP(String InstanceUri, String accessToken, CIPFields cipFlds) {
        HttpRequest httpReq = new HttpRequest(); 
        Http http = new Http(); 
        httpReq.setMethod('POST');
        httpReq.setEndpoint(InstanceUri+'/services/apexrest/CIPFromSales');
        httpReq.setHeader('Authorization', 'OAuth '+accessToken);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');     
        httpReq.setTimeout(120000);  
        String jsonStr = SetCIPObject(cipFlds);
        jsonStr = EncodingUtil.urlEncode(jsonStr, 'UTF-8');        
        httpReq.setBody('{"JSONStr":"'+jsonStr+'"}');
        HTTPResponse httpResp = http.send(httpReq);
        System.debug('RESPONSE ' +httpResp);
        System.debug('BODY: '+httpResp.getBody());
        System.debug('STATUS:'+httpResp.getStatus());
        System.debug('STATUS_CODE:'+httpResp.getStatusCode());
        String retJsonStr = EncodingUtil.urlDecode(httpResp.getBody(), 'UTF-8');
        System.debug(retJsonStr);
        retJsonStr = retJsonStr.replace('\\"', '"');
        retJsonStr = retJsonStr.substring(1,retJsonStr.length()-1);
        System.debug(retJsonStr);
        return GetCIPObject(retJsonStr);
    }
    
 /*
 Below data attributes are used to send data as JSON 
 */   
    public class CIPFields {
        public String name;
        public String recType;
        public String topic;
        public String Status;
        public String ErrorCode;
        public String Message;
        public String CIPId;
        public List<AttachedFile> attachedFiles;
        public String fileContent;
        public String fileName;
        public String ParentId;
        public String AccountName;
        public String AccountNumber;
        public String SIC;
        public String Total_Employees;
        public String Total_Eligibles;
        public String HQ_State;
        public String Original_Effective_Date;
        public String RecordType;
        public String AnthemEntity;
        public String Group_Size;
        public String Region;
        public String Branding;
        public String Duns_Number;
        public String Segment ;
        public String Website;
        public String BillingAddress;
        public String ShippingAddress;           
        public String GroupNumber;
        public String GroupNumberSFDCId;
        public String OpportunityId;     
        public String OpportunityEffectiveDate;                 
        public String OpportunityName;  
        public String OpportunityReceivedDt;  
        public String OpportunityType;  
        public String BillingStreet;
        public String BillingCity;
        public String BillingState;
        public String BillingPostalCode;    
        public String BillingCountry;    
        public String ShippingStreet;
        public String ShippingCity;
        public String ShippingState;
        public String ShippingPostalCode;    
        public String ShippingCountry;    
        public String DivisionName;
        public Boolean UseDivisionNameAsGroupName;
        public String ClaimSystem;    
        public String MemberCount;                     
    }
    
    public static CIPFields GetCIPObject(String json) {
        return (CIPFields) System.JSON.deserialize(json, CIPFields.class);
    }
    public static String SetCIPObject(CIPFields cipFlds) {
        return System.JSON.serialize(cipFlds, true);
    }   

}