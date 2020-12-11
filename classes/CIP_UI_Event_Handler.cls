/*
@Author : Arun Siddappa
@name : CIP_UI_Event_Handler
@CreateDate :06-10-2017
@Description : This class is a controller class for VF Page to send data to Old Org 
*/
public class CIP_UI_Event_Handler{
    
    public String quoteId{get;set;}    
    public CIP_UI_Event_Handler(ApexPages.StandardController controller) {
        quoteId = controller.getRecord().id;
    }    
    private Quote getQuoteDetails(String quoteId){
        Quote quoteRec;
        try{
            quoteRec = [SELECT Name, Id, Claim_System__c, DivisionName__c, TotalMembers__c, UseDivisionNameasGroupName__c, AccountId, AdditionalAddress, ContactId, OpportunityId, QuoteNumber, GrpNumber__c, GroupNumber__c FROM Quote where Id = :quoteId LIMIT 1];
        }catch(Exception e){
            System.debug('Exception - '+e.getMessage());
            return null;
        }
        return quoteRec;
    }
    
    private Opportunity getOpportunityDetails(String OptyId){
        Opportunity optyRec;
        try{
            optyRec = [SELECT Id, CloseDate,Name,  RecordType.Name, Received_Date__c, Type from Opportunity Where Id = :OptyId LIMIT 1];
        }catch(Exception e){
            System.debug('Exception - '+e.getMessage());
            return null;
        }
        return optyRec;
    }
    
    private Account getAccountDetails(String AccntId){
        Account accntRec;
        try{
            accntRec = [SELECT Name, AccountNumber,Account_Name_DBA__c,  OwnerId, Site, Group_Size__c, Industry, ShippingAddress, vlocity_ins__NPNNumber__c, BillingStreet, 
            BillingCity,BillingState,BillingPostalCode  ,BillingCountry ,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,
            Plan_State__c, SIC__c, TotalDentalMembers__c, TotalMedicalMembers__c, Branding__c, Duns_Number__c, HQ_State__c, Original_Effective_Date__c, Region__c, Website,
            NumberOfEmployees, Eligible_Employees__c from Account Where Id = :AccntId LIMIT 1];
        }catch(Exception e){
            System.debug('Exception - '+e.getMessage());
            return null;
        }
        return accntRec;
    }      
    public PageReference NavigateToCIP(){    
        Quote quoteRec = getQuoteDetails(quoteId);
        if(GetDocument(quoteId))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please generate the ASF first prior to launching CIP.'));
            return null;
   
        }
        if(quoteRec != null)
        {
            System.debug('quoteId'+quoteRec.Id);
            CIP_RestAPI_Session_Handler.SessionObject sessionObj = CIP_RestAPI_Session_Handler.restTest();
            System.debug('Session'+sessionObj.access_token);
            System.debug('instance_url'+sessionObj.instance_url);        
            CIP_RestAPI_Client_Handler.CIPFields cipflds = new CIP_RestAPI_Client_Handler.CIPFields();
            Opportunity opty = getOpportunityDetails(quoteRec.OpportunityId);
            Account accnt = getAccountDetails(quoteRec.AccountId);
            cipflds.GroupNumber=  quoteRec.GrpNumber__c;                      
            cipflds.topic = quoteRec.Name;
            cipflds.ParentId = quoteRec.Id;
            cipflds.recType='NEW';
            cipflds.AnthemEntity='National';
            cipflds.Status ='REQUEST';
            cipflds.DivisionName = quoteRec.DivisionName__c;
            cipflds.UseDivisionNameAsGroupName= quoteRec.UseDivisionNameasGroupName__c;
            cipflds.ClaimSystem= quoteRec.Claim_System__c;
            cipflds.MemberCount = quoteRec.TotalMembers__c+'';
            if(opty != null){
                cipflds.OpportunityName =   opty.Name;
                cipflds.OpportunityEffectiveDate =   opty.CloseDate+'';
                cipflds.OpportunityId=  opty.Id; 
                cipflds.OpportunityReceivedDt=  opty.Received_Date__c+''; 
                cipflds.OpportunityType =  opty.RecordType.Name; 
            }
            if(accnt != null){
                cipflds.name= accnt.Name;
                cipflds.topic=accnt.Name;
                cipflds.AccountName=accnt.Name;
                cipflds.AccountNumber=accnt.AccountNumber;
                cipflds.SIC=accnt.SIC__c;
                cipflds.Total_Employees=accnt.NumberOfEmployees+'';
                cipflds.Total_Eligibles=accnt.Eligible_Employees__c+'';
                cipflds.HQ_State=accnt.HQ_State__c;
                cipflds.Original_Effective_Date=accnt.Original_Effective_Date__c+'';
                cipflds.Group_Size=accnt.Group_Size__c;
                cipflds.Region=accnt.Region__c;
                cipflds.Branding=accnt.Branding__c;
                cipflds.Duns_Number=accnt.Account_Name_DBA__c;
                cipflds.Segment ='NATIONAL';
                cipflds.Website=accnt.Website;
                cipflds.BillingStreet=accnt.BillingStreet;
                cipflds.BillingCity=accnt.BillingCity;
                cipflds.BillingState=accnt.BillingState;
                cipflds.BillingPostalCode=accnt.BillingPostalCode;    
                cipflds.BillingCountry=accnt.BillingCountry;    
                cipflds.ShippingStreet=accnt.ShippingStreet;
                cipflds.ShippingCity=accnt.ShippingCity;
                cipflds.ShippingState=accnt.ShippingState;
                cipflds.ShippingPostalCode=accnt.ShippingPostalCode;    
                cipflds.ShippingCountry=accnt.ShippingCountry;                                 
            }           
            CIP_RestAPI_Client_Handler.CIPFields retCIPFlds = CIP_RestAPI_Client_Handler.CreateCIP(sessionObj.instance_url, sessionObj.access_token, cipflds); 
            String id = retCIPFlds.CIPId;  
            String quoteId = retCIPFlds.GroupNumberSFDCId; 
            CIPIntegration__c cipSF = CIPIntegration__c.getOrgDefaults();
            String CIPURL = cipSF.CIP_SF_Org_URL__c;        
            return new PageReference(CIPURL +quoteId);            
        }
        return null;
    
    }
    public static boolean GetDocument(String qtId)
    {   
        List<ContentDocumentLink> documents = [SELECT Id FROM ContentDocumentLink where LinkedEntityId = :qtId];
    if(documents.isEmpty()) return true; else return false;    
    }   

}