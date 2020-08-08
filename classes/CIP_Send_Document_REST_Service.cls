/*
@Author : Arun Siddappa
@name : CIP_Send_Document_REST_Service 
@CreateDate :06-10-2017
@Description : This class enables the REST API calls for Old Org to call and get the latest ASF document tied to the related Quote 
*/

@RestResource(urlMapping='/CIPFromSales/*')
global class CIP_Send_Document_REST_Service { 
    /**
    @description : Method to doPost
	@return : String
    @param : String
    */
    @HttpPost
    global static String doPost(String JSONStr)
    {
        RestRequest req = RestContext.request;
        System.debug ('Request from Client - '+req);
        System.debug ('Parameters - '+EncodingUtil.urlDecode(JSONStr, 'UTF-8'));
        CIPFields cipFlds = (CIPFields) System.JSON.deserialize(EncodingUtil.urlDecode(JSONStr, 'UTF-8'), CIPFields.class);
        CIPFields  retFlds = getAttchment(cipFlds); 
        String retjsonStr = System.JSON.serialize(retFlds, true);        
        return EncodingUtil.urlEncode(retjsonStr, 'UTF-8');       
    }
    /**
    @description : Method to get Latest Quote For GroupNumber
	@return : String
    @param : String
    */
    global static String getLatestQuoteForGroupNumber(String groupNumber){
        Quote quoteRec;
        try{
            quoteRec = [SELECT Id, GrpNumber__c FROM Quote where GrpNumber__c = :groupNumber ORDER BY CreatedDate DESC LIMIT 1];
        }catch(Exception e){
            System.debug('Exception- '+e.getMessage());
            return null;
        }
        return quoteRec.Id;
    }
    /**
    @description : Method to get attchment
	@return : CIPFields
    @param : CIPFields
    */
    global static CIPFields getAttchment(CIPFields  cipflds)
    {
        CIPFields cipRetFlds = new CIPFields();
        List<ContentVersion> contVerList = new List<ContentVersion>();
        if(cipflds.ParentId != null)
        {
            contVerList = getAttachPDF(cipflds.ParentId);
            createCIPForAccountManagement(cipflds.name, cipflds.ParentId, cipflds.CIPId);
        } else if(cipflds.GroupNumber != null){
            String quoteId = getLatestQuoteForGroupNumber(cipflds.GroupNumber);
            if(quoteId != null){
                createCIPForAccountManagement(cipflds.name, quoteId, cipflds.CIPId);
                contVerList = getAttachPDF(quoteId);                        
            }
        } else {
            contVerList = new List<ContentVersion>();
        }
        
        if (!contVerList.isEmpty())
        {                
            for(ContentVersion cv : contVerList)
            {
                cipRetFlds.fileName = cv.Title;
                cipRetFlds.fileContent = EncodingUtil.base64Encode(cv.VersionData);
            }
        }             
        System.debug('cipflds - '+cipRetFlds);                        
        return cipRetFlds ;
    }
    /**
    @description : Method to get attached PDF
	@return : List<ContentVersion>
    @param : String
    */
    global static List<ContentVersion> getAttachPDF(String parId)
    {
        List<ContentVersion> contVerList = new List<ContentVersion>();
        try
        {
            List<ContentDocumentLink> contLinkList = [Select ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :parId and ContentDocument.Title LIKE 'ASF%' ORDER BY SystemModstamp DESC NULLS FIRST LIMIT 1];
            if(contLinkList != null)
            {
				//Start | PRDCRM-47803 : Tech Debt story(to remove SOQL inside for loop) | 25th Nov, 2019 | Accenture - Panthers
                Id contentDocId = contLinkList[0].ContentDocumentId;                               
                contVerList = [Select Id, VersionData, Title from ContentVersion Where ContentDocumentId = :contentDocId ORDER BY CreatedDate DESC LIMIT 1]; 
				//End | PRDCRM-47803 : Tech Debt story(to remove SOQL inside for loop) | 25th Nov, 2019 | Accenture - Panthers
            }
        }catch(Exception e)
        {
            System.debug('Exception - '+e.getMessage());
            return contVerList;
        }
        return contVerList;
    }
    /**
    @description : Method to create CIP for Account Management
    @param : String, String, String
    */ 
    global static void createCIPForAccountManagement(String name, String quoteId, String cipId)
    {      
        Client_Intake_Process__c newCIP;
        if([select Id from Client_Intake_Process__c where CIP_Id__c = :cipId].isEmpty()){
            newCIP = new Client_Intake_Process__c();
            newCIP.Name = name;
            newCIP.Quote__c = quoteId;            
            newCIP.CIP_Id__c = cipId;
            insert newCIP;         
        }
    } 
    /**
    @description : Wrapper class for CIP fields
    */ 
    global class CIPFields {
        global String name{ get; set; }
        global String recType{ get; set; }
        global String topic{ get; set; }
        global String Status { get; set; }
        global String ErrorCode { get; set; }
        global String Message { get; set; }
        global String CIPId { get; set; }
        global String fileContent { get; set; }    
        global String fileName { get; set; }   
        global String ParentId { get; set; }     
        global String AccountName{ get; set; }
        global String AccountNumber{ get; set; }
        global String GroupNumberSFDCId{ get; set; }
        global String SIC{ get; set; }
        global String Total_Employees{ get; set; }
        global String Total_Eligibles{ get; set; }
        global String HQ_State{ get; set; }
        global String Original_Effective_Date{ get; set; }
        global String RecordType{ get; set; }
        global String AnthemEntity{ get; set; }
        global String Group_Size{ get; set; }
        global String Region{ get; set; }
        global String Branding{ get; set; }
        global String Duns_Number{ get; set; }
        global String Segment { get; set; }
        global String Website{ get; set; }
        global String BillingAddress{ get; set; }
        global String ShippingAddress{ get; set; }    
        global String GroupNumber{ get; set; }
        global String OpportunityId{ get; set; }       
        global String OpportunityEffectiveDate{ get; set; }                   
        global String OpportunityName{ get; set; }                   
        global String OpportunityReceivedDt{ get; set; }
        global String OpportunityType{ get; set; }              
        global String BillingStreet{ get; set; }     
        global String BillingCity{ get; set; }     
        global String BillingState{ get; set; }     
        global String BillingPostalCode{ get; set; }         
        global String BillingCountry{ get; set; }         
        global String ShippingStreet{ get; set; }     
        global String ShippingCity{ get; set; }     
        global String ShippingState{ get; set; }     
        global String ShippingPostalCode{ get; set; }         
        global String ShippingCountry{ get; set; }         
    }       
}