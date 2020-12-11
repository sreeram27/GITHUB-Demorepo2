/*
@Author : Accenture Offshore Dev team
@name : ANA_VFC02_CustomNetworksApprovalRequest
@CreateDate : 23-06-2017
@Description : This class process the value to visualfore page Email Template.
*/
public with sharing class ANA_VFC02_CustomNetworksApprovalRequest {
    public String qlitemapp{get;set;}
    private static final string NEWBUSS='New Business';
    private static final string NEWVAL='New';
    private static final string EXSVAL='Existing';
    public String qlitemappNewId;


/****************************************************************************************************
@Method Name : setQlitemappNewId
@Parameters  : String
@Description : This method is used to set a value from page and assign to controller variable
******************************************************************************************************/
    public void setQlitemappNewId(String qlitemappId){
        qlitemappNewId = qlitemappId;
    }

/****************************************************************************************************
@Method Name : getQlitemappNewId
@ReturnType: string
@Description : This method is used to get a value from page
******************************************************************************************************/
    public String getQlitemappNewId(){
        return qlitemappNewId;
    }
    
    /*This method is used for setting/getting values to/from bean.*/
    public Quotelineitembean qlibean{get;set;}
    /*This method is a constructor that calls the  BeanAssignment method.*/
    public ANA_VFC02_CustomNetworksApprovalRequest(){
        system.debug('qlitemappNewId========'+qlitemappNewId);
        qlitemapp = qlitemappNewId;
    }   
    private static final string STRQRY = 'Select id,name,QuoteLineItem__c,Owner.Name,QuoteLineItem__r.RequestType__c,QuoteLineItem__r.Quote.Opportunity.Account.Name,'+
        'QuoteLineItem__r.Quote.Opportunity.Account.VP__r.Name,QuoteLineItem__r.RFPorCriticalMeetingdaterequired__c,QuoteLineItem__r.Quote.Opportunity.Account.Eligible_Employees__c,'+
        'QuoteLineItem__r.IntegrationWith3rdPartyVendor__c,QuoteLineItem__r.MarketsAffectedByRequest__c,QuoteLineItem__r.Quote.Opportunity.Account.Total_Employees__c,'+
        'QuoteLineItem__r.CompetitorStatus__c,QuoteLineItem__r.Quote.Opportunity.HQState__c,QuoteLineItem__r.Quote.GroupNumber__r.ClaimSystem__c,QuoteLineItem__r.Quote.Opportunity.Recordtype.Name,'+
        'QuoteLineItem__r.DoesAnthemcurrentlyworkwithvendor__c,QuoteLineItem__r.CustomSolutionBenefitToOtherAccts__c,QuoteLineItem__r.RequiresITWorkToImplement__c,'+
        'QuoteLineItem__r.SolutionRequiresLocalInvolvement__c,QuoteLineItem__r.AdditionalDetails__c,QuoteLineItem__r.BackgroundFurtherExplanation__c,QuoteLineItem__r.AlternativesDiscussedWithClient__c,'+
        'QuoteLineItem__r.AnthemVendor__r.Name, QuoteLineItem__r.EstimatedCostIfRequestApproved__c,QuoteLineItem__r.RequestTypeComment__c from QuoteLineItemApproval__c  where id =: qlitemappNewId limit 100';

/****************************************************************************************************
@Method Name : Quotelineitembean
@Description : this class has contain all  the quote line item bean values
******************************************************************************************************/
    public with sharing class Quotelineitembean{
        public string ANASalesorAccountrep{get;set;} //mapped
        public string GROUPNAME{get;set;}//mapped
        public string RVP{get;set;}//mapped
        public string RequestType{get;set;}//mapped
        public string RequestTypeComment{get;set;}//mapped
        public date RFPORCriticalMeetingdaterequired{get;set;}//mapped
        public string DoesrequestincludeintegratingwiththirdpartyVendor{get;set;}//mapped
        public string Marketsaffectedbyrequest{get;set;}//mapped
        public string NewSalesorCurrentAccount{get;set;}
        public string NumberofEmployees{get;set;}//mapped
        public string NumberofMembers{get;set;}//mapped
        public string HQState{get;set;}//mapped
        public string Consultant{get;set;}//QL
        public string CompetitorStatus{get;set;}//mapped
        public string ClaimSystem{get;set;}//mapped
        public string RenewalofBaseExpenseCovered{get;set;}//QL
        public string RenewalofTotalExpenseCovered{get;set;}//QL
        public string DurationofGuarantee{get;set;}//QL
        public string CurrentYearofGuarantee{get;set;}//QL
        public string WillrequestrequireITWImpl{get;set;} //mapped
        public string Estimateddlrcost2AnthemreqApp{get;set;}//QL
        public string Alternativesdiscussedwithclient{get;set;}//mapped
        public string Vendorname{get;set;}//mapped
        public string DoesAnthemcurrentlyworkwiththisvendor{get;set;}//mapped
        public string WouldcustomslBenfOthANAaccounts{get;set;}//mapped
        public string Willthissolreqlocalcontrteaminv{get;set;}//mapped
        public string Plzdescribeanyadddetbackghistory{get;set;}//mapped
        
    }
    

/****************************************************************************************************
@Method Name : getBeanAssignment
@Description : This method assigns the values to the bean variables.
******************************************************************************************************/
    public void getBeanAssignment(){

        qlibean = new Quotelineitembean();
        Profile usrProfile = [Select Name from Profile where ID =: userinfo.getProfileId()];
        for(QuoteLineItemApproval__c qli :listQuotelineItem()){

            if(qli.Owner.Name != null){
                qlibean.ANASalesorAccountrep = qli.Owner.Name;
            }if(qli.QuoteLineItem__r.Quote.Opportunity.Account.Name != null){
                qlibean.GROUPNAME = qli.QuoteLineItem__r.Quote.Opportunity.Account.Name;
            }if(qli.QuoteLineItem__r.Quote.Opportunity.Account.VP__r.Name != null){
                qlibean.RVP = qli.QuoteLineItem__r.Quote.Opportunity.Account.VP__r.Name;
            }if(qli.QuoteLineItem__r.RequestType__c != null){
                qlibean.RequestType = qli.QuoteLineItem__r.RequestType__c;
            }if(qli.QuoteLineItem__r.RFPorCriticalMeetingdaterequired__c != null){
                qlibean.RFPORCriticalMeetingdaterequired = qli.QuoteLineItem__r.RFPorCriticalMeetingdaterequired__c;
            }if(qli.QuoteLineItem__r.IntegrationWith3rdPartyVendor__c != null){
                qlibean.DoesrequestincludeintegratingwiththirdpartyVendor = qli.QuoteLineItem__r.IntegrationWith3rdPartyVendor__c;
            }if(qli.QuoteLineItem__r.MarketsAffectedByRequest__c != null){
                qlibean.Marketsaffectedbyrequest = qli.QuoteLineItem__r.MarketsAffectedByRequest__c;
            }if(qli.QuoteLineItem__r.CompetitorStatus__c != null){
                qlibean.CompetitorStatus = qli.QuoteLineItem__r.CompetitorStatus__c;
            }if(qli.QuoteLineItem__r.Quote.Opportunity.HQState__c != null){
                qlibean.HQState = qli.QuoteLineItem__r.Quote.Opportunity.HQState__c;
            }if(qli.QuoteLineItem__r.Quote.GroupNumber__r.ClaimSystem__c != null){
                qlibean.ClaimSystem = qli.QuoteLineItem__r.Quote.GroupNumber__r.ClaimSystem__c;
            }if(qli.QuoteLineItem__r.DoesAnthemcurrentlyworkwithvendor__c != null){
                qlibean.DoesAnthemcurrentlyworkwiththisvendor = qli.QuoteLineItem__r.DoesAnthemcurrentlyworkwithvendor__c;
            }if(qli.QuoteLineItem__r.CustomSolutionBenefitToOtherAccts__c != null){
                qlibean.WouldcustomslBenfOthANAaccounts = qli.QuoteLineItem__r.CustomSolutionBenefitToOtherAccts__c;
            }if(qli.QuoteLineItem__r.SolutionRequiresLocalInvolvement__c !=null){
                qlibean.Willthissolreqlocalcontrteaminv = qli.QuoteLineItem__r.SolutionRequiresLocalInvolvement__c;
            }if(qli.QuoteLineItem__r.AdditionalDetails__c !=null){
                qlibean.Plzdescribeanyadddetbackghistory = qli.QuoteLineItem__r.AdditionalDetails__c;
            }if(qli.QuoteLineItem__r.Quote.Opportunity.Account.Eligible_Employees__c != null){
                qlibean.NumberofEmployees = String.valueOf(qli.QuoteLineItem__r.Quote.Opportunity.Account.Eligible_Employees__c);
            }if(qli.QuoteLineItem__r.Quote.Opportunity.Account.Total_Employees__c != null){
                qlibean.NumberofMembers = String.valueOf(qli.QuoteLineItem__r.Quote.Opportunity.Account.Total_Employees__c);
            }if(qli.QuoteLineItem__r.RequiresITWorkToImplement__c != null){
                qlibean.WillrequestrequireITWImpl = qli.QuoteLineItem__r.RequiresITWorkToImplement__c;
            }if(qli.QuoteLineItem__r.AlternativesDiscussedWithClient__c != null){
                qlibean.Alternativesdiscussedwithclient = qli.QuoteLineItem__r.AlternativesDiscussedWithClient__c;
            }
            if(qli.QuoteLineItem__r.AnthemVendor__r.Name != null){
                qlibean.Vendorname = qli.QuoteLineItem__r.AnthemVendor__r.Name;
            }
            if(qli.QuoteLineItem__r.EstimatedCostIfRequestApproved__c != null){
                qlibean.Estimateddlrcost2AnthemreqApp = String.valueOf(qli.QuoteLineItem__r.EstimatedCostIfRequestApproved__c);
            }
            if(qli.QuoteLineItem__r.RequestTypeComment__c != null){
                qlibean.RequestTypeComment = qli.QuoteLineItem__r.RequestTypeComment__c;
            }

            // Start : Deloitte Offshore
            if( (qli.QuoteLineItem__r.Quote.Opportunity.Recordtype.Name != null && NEWBUSS.equalsIgnoreCase(qli.QuoteLineItem__r.Quote.Opportunity.Recordtype.Name)) 
               ||

               /**Changes made my Accenture team to fix Code Scan Issue PRDCRM-45407 Date(MM:DD:YYYY): 11/7/2019**/
               (qli.QuoteLineItem__r.Quote.Opportunity.Recordtype.Name != null &&( (usrProfile.Name == LGA_Constants.LOCAL_SALES) || (usrProfile.Name == LGA_Constants.LOCAL_SALES_DUAL) ) && LGA_Constants.NEW_BUSINESS_LOCAL.equalsIgnoreCase(qli.QuoteLineItem__r.Quote.Opportunity.Recordtype.Name)))
            {
                qlibean.NewSalesorCurrentAccount = NEWVAL;
            }
            //End
            else{
                qlibean.NewSalesorCurrentAccount = EXSVAL;
            }
        }
    }

/****************************************************************************************************
@Method Name : listQuotelineItem
@Description : This method returns a list of QuoteLineItem Approval records
******************************************************************************************************/
    public list<QuoteLineItemApproval__c> listQuotelineItem(){
        list<QuoteLineItemApproval__c> listqli = new list<QuoteLineItemApproval__c>();
        
        system.debug('STRQRY=========='+STRQRY);
        listqli = Database.query(STRQRY);
        system.debug('listqli======='+listqli);
        return listqli;
    }
}