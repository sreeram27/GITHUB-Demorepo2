/***************************************************************************
* @Date : 10/25/2019
* @Author : Ellen Lipscomb
* @description : controller for ActWiseNONB.vfp
* @comments : PRDCRM-44996
* @version : 2.0
**************************************************************************/

public with sharing class ActWiseNONBController {	    
    
    public Quote myQuote { get; set;}          
    public Boolean isHSA { get; set;}
    public Boolean isHRA { get; set;}
    public Boolean isFSA { get; set;}
    public Boolean isDCFSA { get; set;}
    public Boolean isLPFSA { get; set;}
    public Boolean isCommuter { get; set;}  
    
    public Boolean isNewBusiness { get; set;}    
    public String typeOfBusiness { get; set;}
    public String tobHRA { get; set;}
    public String tobHSA { get; set;}
    public String tobCommuter { get; set;}
    public String tobFSA { get; set;}
    public String tobDCFSA { get; set;}
    public String tobLPFSA { get; set;}
            
    public ActWiseNONBController(ApexPages.StandardController stdController) {
        this.myQuote = (Quote)stdController.getRecord();          
    }      
            
    List<QuoteLineItem> products;
    List<AccountTeamMember> members;
       
    /*
	@method Name : getMembers
	@Parameters used: None
	@Return Type: List<AccountTeamMember>
	@method Description : For Section D of NONB form. This method returns a list with the name, email address, and role of the 
	@account team members that have the following roles: Account Manager, Account Executive, and Sales Account Rep - Acct Mgmt. 
	@Last Modified Date: 01/20/2020
	*/
    public List<AccountTeamMember> getMembers()
    {
        members = [select UserId, User.Name, User.Email, TeamMemberRole from AccountTeamMember where 
                   AccountTeamMember.AccountID =: this.myQuote.AccountId And 
                   (AccountTeamMember.TeamMemberRole =: CDHP_COMM2_Constants.ACCOUNT_MANAGER Or 
                   AccountTeamMember.TeamMemberRole =: CDHP_COMM2_Constants.ACCOUNT_EXECUTIVE Or
                   AccountTeamMember.TeamMemberRole =: CDHP_COMM2_Constants.ACCOUNT_SALES_REP_ACCT_MGMT)];               
        
        if (members !=null) { 		        	
        	return members;
        } else {
		return null;  
        }
	}       
     
	/*
	@method Name : getProducts
	@Parameters used: None
	@Return Type: List<QuoteLineItem>
	@method Description : For Section E of NONB form. This method returns a list of Act Wise Products that meet the specified criteria. 
	@Last Modified Date: 01/20/2020
	*/    
	public List<QUoteLineItem> getProducts()	{   
		
        List<String> RenewalOppType = new List<String>{CDHP_COMM2_Constants.RENEWAL_LOCAL, CDHP_COMM2_Constants.IN_GROUP_ADD_PRODUCT_LOCAL, CDHP_COMM2_Constants.New_BUSINESS_LOCAL,
        											   CDHP_COMM2_Constants.RENEWAL, CDHP_COMM2_Constants.STOPLOSS, CDHP_COMM2_Constants.IN_GROUP_CHANGE_LOCAL};
                                                                 
        List<String> productStage = new List<String>{CDHP_COMM2_Constants.SOLD, CDHP_COMM2_Constants.IGAP_SOLD};     
                           
        products =[select Is_New_Business__c, Is_Existing_Product__c, IsArea3__c, Quote.Opportunity.Is_Renewed__c, 
                   Quote.Opportunity.AnthemEntity__c, Quote.Opportunity.OpportunityRecordTypeName__c, FSA_Plan_Options__c, 
                   RecordType__c from QuoteLineItem where QuoteId =:this.myQuote.Id 
                   and ProductStage__c =:productStage and RecordType__c LIKE '%actwise%'];
        
        
        system.debug('products::'+products);
        system.debug('products::'+products.size());
        		
        if(products.size()>0) { 
        	                     
            isHSA = false;
    		isHRA = false;
    		isFSA = false;
    		isDCFSA = false;
    		isLPFSA = false;
    		isCommuter = false;            
            isNewBusiness = false;                       
            
        	for (QuoteLineItem qli : products) {
                system.debug('qli::'+qli);
                system.debug('Quote Opportunity OpportunityRecordTypeName__c::'+qli.Quote.Opportunity.OpportunityRecordTypeName__c);
                //new code added to indicate new and renewal business
                typeOfBusiness = '';   
                                
                Boolean is_RenewalLocalType = false;
                Boolean is_RenewalNationalType = false;           
                //QuoteLineItem:{Is_New_Business__c=true, 
                //Is_Existing_Product__c=false, IsArea3__c=true,
                // QuoteId=0Q08A00000071j2SAA, 
                // RecordType__c=ActWise HSA, Id=0QL8A0000007owSWAQ}
                //check for LG/Local renewal Opportunity with new business - opp record type is 'Renewal Local'    
                if(qli.Is_New_Business__c && !qli.Is_Existing_Product__c && qli.Quote.Opportunity.OpportunityRecordTypeName__c == CDHP_COMM2_Constants.RENEWAL_LOCAL
                     && qli.Quote.Opportunity.AnthemEntity__c == CDHP_COMM2_Constants.LOCAL_LARGE_GROUP) {
                          is_RenewalLocalType = true;                         
                }           
                
                //Check for National renewal opportunity with new business	
                if(qli.Is_New_Business__c && qli.Quote.Opportunity.OpportunityRecordTypeName__c == CDHP_COMM2_Constants.RENEWAL 
                     && !qli.Is_Existing_Product__c && !qli.Quote.Opportunity.Is_Renewed__c 
                     && qli.Quote.Opportunity.AnthemEntity__c == CDHP_COMM2_Constants.NATIONAL_ACCOUNTS) {
                          is_RenewalNationalType = true;                         
                }                
              
                //if any of the conditions are true new business has been added to a renewal
                if(is_RenewalLocalType || is_RenewalNationalType) {
                	typeOfBusiness = CDHP_COMM2_Constants.NEW_BUS_ADD_TEXT_TO_RENEWAL;    
                } //else new business was added to non-renewal opportunity
                else if (qli.Is_New_Business__c && !qli.Is_Existing_Product__c) {
                    typeofBusiness = CDHP_COMM2_Constants.NEW_BUS_ADD_TEXT;
                } else {
                	typeOfBusiness = '';    
                }                                               
                
                if (qli.RecordType__c.contains(CDHP_COMM2_Constants.ACTWISE_HRA)) {
                	isHRA = true;
                    tobHRA = typeOfBusiness;    
                } else if (qli.RecordType__c.contains(CDHP_COMM2_Constants.ACTWISE_HSA)) {
                    isHSA = true;
                    tobHSA = typeOfBusiness;
                } else if (qli.RecordType__c.contains(CDHP_COMM2_Constants.ACTWISE_COMMUTER)) {
                    isCommuter = true;
                    tobCommuter = TypeOfBusiness;
                } else if (qli.RecordType__c.contains(CDHP_COMM2_Constants.ACTWISE_FSA)) {
                  	if (qli.FSA_Plan_Options__c != null) {                			
                    	if (qli.FSA_Plan_Options__c.contains(CDHP_COMM2_Constants.DEPENDENT_CARE_FSA)) {
                    		isDCFSA = true;
                            tobDCFSA = TypeOfBusiness;                                
                    	}
                    	if (qli.FSA_Plan_Options__c.contains(CDHP_COMM2_Constants.FSA_SECTION_213D)) {
                    		isFSA = true;
                            tobFSA = TypeOfBusiness;                                
                    	} 
                    	if (qli.FSA_Plan_Options__c.contains(CDHP_COMM2_Constants.LIMITED_PURPOSE_FSA)) {
                    		isLPFSA = true;
                            tobLPFSA = TypeOfBusiness;                                
                    	}
                   	} else {
                      	isFSA = true; 
                        tobFSA = TypeOfBusiness;
                    }
                } else {
                    system.debug('QLI does not have an ActWise record type or FSA Plan Option');
                }	                
            }  
            system.debug('products::Line 156'+products);
            return products;
        } else {
            return null;
        }   
	}   
}