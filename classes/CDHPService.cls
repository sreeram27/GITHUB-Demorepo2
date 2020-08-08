/******************************************************************************
@author        Ranjit
@date          12th December 2018
@description   This is rest resource to update the status and return response.
**********************************************************************************/
@RestResource(urlMapping='/v1/CDHPService/*')
global class CDHPService {
    /******************************************************************************
@author        Ranjit
@date          12th December 2018
@returnType    String
@param 		   String JsonStr
@description   This method is used post data and return response.
*******************************************************************************/  
    @HttpPost
    global static String doPost(String JSONStr){
        system.debug('JSONStr========='+JSONStr);
 		String retJsonStr = EncodingUtil.urlDecode(JSONStr, 'UTF-8');        
        system.debug('retJsonStr========='+retJsonStr);
        CDHPFields wrapper = new CDHPFields();
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        List<CDHPFields> cdhpFlds = (List<CDHPFields>) System.JSON.deserialize(EncodingUtil.urlDecode(JSONStr, 'UTF-8'), List<CDHPFields>.class);
        System.debug('FIELDS FROM COM2 - '+cdhpFlds);
        CDHPFields  retFlds  = CDHPServiceHandler.ProcessRequest(cdhpFlds);     
        return System.JSON.serialize(retFlds, true);    
    }
    
    public class CDHPFields {
        public StatusDetails StatusDetails{ get; set; }
        //US-33021
        public DocuSignDetails docSignDetails{ get; set; }
        public OpportunityDetails oppDetails{ get; set; }
        public GroupDetails grpDetails{ get; set; }
        public String CDHP_Questionnaire_Name{ get; set; }
        //33173 starts
		public CDHParDetails CDHPar{ get; set; }
		public List<CDHPCommuterAccount> CDHPCommuterList{ get; set; }
		public List<CDHPHSAAccount> CDHPHSAList { get; set; }
		public List<CDHPFSAAccount> CDHPFSAList{ get; set; }
		public List<CDHPHRARepeatingAccount> CDHPHRAList{ get; set; }
		//public Map<Id,Hra_fields> quoteIdHRAmap{ get; set; }
		//33173 Ends
    }
    
    public class OpportunityDetails{
         public String SFORGOpportunityId{ get; set; }
         public String OptyName{ get; set; }
         public String GroupNumber{ get; set; }        
        public Date OptyEffectiveDate{ get; set; } // CloseDate 
        public String OptyRecordType{ get; set; } //OpportunityRecordTypeName__c
        public String StageName{ get; set; } // StageName
        public String OpportunityOwner{ get; set; } // Owner
    }
    
    public class GroupDetails{
        public String EmployerName{ get; set; }
        public String EmployerIdCaseNumber{ get; set; }
        
    }
      
    //DocuSign added by Avinash US-33021
    public class DocuSignDetails{
        public String dsfs_Envelope_Name{ get; set; }
        public String dsfs_Envelope_Status{ get; set; }
        public Datetime dsfs_Sent_Date_Time{ get; set; }
        public Integer dsfs_Sent_Age{ get; set; }
        public String OpportunityName{ get; set; }
        public String DocuSignCreatedBy{ get; set; }
        public String dsfs_Company{ get; set; }
        public String CDHP_Questionnaire_Name_Status{ get; set; }
        public String dsfs_Case{ get; set; }
        public String dsfs_Opportunity{ get; set; }
        
    }
    public class StatusDetails{
        public String Status{ get; set; }
        public String StatusMessage { get; set; } 
        public String CDHPParentId{ get; set; }
        public String QuoteId{ get; set; }
    } 
    
	//33173 code starts
	
	public class CDHParDetails{
        public String EmployerName{ get; set; }
        public String TaxId{ get; set; }
        public String EmployerIdCaseNumber{ get; set; }
		public Date Effective_Date{ get; set; }
        public Decimal NumberOfEligibleEmpl{ get; set; }
        public Decimal EstimatedNumberOfParticipanets{ get; set; }
        
		public String Employer_Contact_Name_1{ get; set; }
		public String Employer_Contact_Phone_1{ get; set; }
		public String Employer_Contact_Email_1{ get; set; }
		public String Broker_Consultant_Contact_Name{ get; set; }
		public String Broker_Consultant_Contact_Phone{ get; set; }
		public String Broker_Consultant_Contact_Email{ get; set; }
		public String Brand{ get; set; }
		public String Status{ get; set; }
		public boolean HSA_Account_Type{ get; set; }
		public boolean FSA_Account_Type{ get; set; }
		
		
		
		public boolean Commuter_Account_Type{ get; set; }
	/*}
		public class Hra_fields{*/
		public boolean HRA_Account_Type{ get; set; }
		public boolean Member_Pay_HRA_with_Debit_Card{ get; set; }
		public boolean Prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay{ get; set; }
		public boolean Provider_Pay_Split_HRA{ get; set; }
		public boolean HRA_Provider_Pay{ get; set; }
		public boolean HRA_Rollover{ get; set; }
    }
	public class CDHPCommuterAccount
	{
		public boolean Transit_Plan_Option{ get; set; }
		public boolean Parking_Plan_Option{ get; set; }
		public string SF_Quote_Item_Id{ get; set; }
	}
	public class CDHPHSAAccount
	{
		public String HSA_Custodian{ get; set; }
		public String Administrative_Fees_Responsibility{ get; set; }
		public string SF_Quote_Item_Id{ get; set; }
	}
	public class CDHPFSAAccount
	{
		public Date FSA_Plan_Start_Date{ get; set; }
		public Date FSA_Plan_End_Date{ get; set; }
		public boolean FSA_Section_213_d_Plan{ get; set; }
		public boolean Limited_Purpose_FSA_Plan{ get; set; }
		public boolean Dependent_Care_FSA_Plan{ get; set; }
		public string SF_Quote_Item_Id{ get; set; }
	}
	public class CDHPHRARepeatingAccount{
		
		public Date HRA_Plan_Start_Date { get; set; }
		public Date HRA_Plan_End_Date{ get; set; }
		public String HRA1_Group_Suffix{ get; set; }
		public Decimal HRA_Ann_Roll_Cap_Amt_Emp{ get; set; }
		public Decimal HRA_Ann_Roll_Cap_Amt_Emp_Adult{ get; set; }
		public Decimal HRA_Ann_Roll_Cap_Amt_Emp_Child{ get; set; }
		public Decimal HRA_Ann_Roll_Cap_Amt_Emp_Children{ get; set; }
		public Decimal HRA_Ann_Roll_Cap_Amt_Family{ get; set; }
		public Decimal HRA_Annual_Alloc_Amt_Emp_Adult{ get; set; }
		public Decimal HRA_Annual_Alloc_Amt_Emp_Child{ get; set; }
		public Decimal HRA_Annual_Alloc_Amt_Emp_Children{ get; set; }
		public Decimal HRA_Annual_Alloc_Amt_Employee{ get; set; }
		public Decimal HRA_Annual_Alloc_Amt_Family{ get; set; }
		public String HRA_Annual_Allocation_Tier_Selection{ get; set; }
		public Date HRA_Claim_Run_Out_Date{ get; set; }
		public boolean HRA_Debit_Card_Dental_Services{ get; set; }
		public boolean HRA_Debit_Card_Medical_Services{ get; set; }
		public boolean HRA_Debit_Card_OTC_Services{ get; set; }
		public boolean HRA_Debit_Card_Rx_Services{ get; set; }
		public boolean HRA_Debit_Card_Vision_Services{ get; set; }
		public boolean HRA_Embedded_Ded{ get; set; }
		public String HRA_Employee_Funds_Rollover_Amounts{ get; set; }
		public String HRA_Employee_Funds_Rollover_Options{ get; set; }
		public String HRA_Fund_Allocation{ get; set; }
		public String HRA_Funding_Pro_Rate{ get; set; }
		public String HRA_Health_Activities{ get; set; }
		public String HRA_Health_Activities_Options{ get; set; }
		public Decimal HRA_Individual_Embedded_Ded_Amt{ get; set; }
		public String HRA_Max_Rollover_Amt_Cap_Tier{ get; set; }
		public String HRA_Member_Responsibility_by_Claim{ get; set; }
		public Decimal HRA_Min_Rollover_Amt{ get; set; }
		public boolean HRA_Prov_Pay_Med_w_Opt_Rx_Den_Vis_Deb_Cd{ get; set; }
		public boolean HRA_ProvPay_Opt_DebCd_Dental_Option{ get; set; }
		public boolean HRA_ProvPay_Opt_DebCd_INN_Med_Coins{ get; set; }
		public boolean HRA_ProvPay_Opt_DebCd_INN_Med_Copay{ get; set; }
		public boolean HRA_ProvPay_Opt_DebCd_INN_Med_Ded{ get; set; }
		public boolean HRA_ProvPay_Opt_DebCd_Medical{ get; set; }
		public boolean HRA_ProvPay_Opt_DebCd_ONN_Med_Coins{ get; set; }
		public boolean HRA_ProvPay_Opt_DebCd_ONN_Med_Copay{ get; set; }
		public boolean HRA_ProvPay_Opt_DebCd_ONN_Med_Ded{ get; set; }
		public boolean HRA_ProvPay_Opt_DebCd_Rx_Option{ get; set; }
		public boolean HRA_ProvPay_Opt_DebCd_Vision_Option{ get; set; }
		public boolean HRA_Rollover{ get; set; }
		public Date HRA_Rollover_Date_recommend_3_months{ get; set; }
		public String HRA_Rollover_Offer{ get; set; }
		public String HRA_Termed_Emp_Claims_Run_out_Deadline{ get; set; }
		public String HRA_Terminated_Employees_Other_Value{ get; set; }
		public String HRA_Unused_rollovrfund_diff_Adm_last_yr{ get; set; }
		public Decimal HRA_Upfront_Ded_Amt_Emp{ get; set; }
		public Decimal HRA_Upfront_Ded_Amt_Emp_Adult{ get; set; }
		public Decimal HRA_Upfront_Ded_Amt_Emp_Child{ get; set; }
		public Decimal HRA_Upfront_Ded_Amt_Emp_Children{ get; set; }
		public Decimal HRA_Upfront_Ded_Amt_Family{ get; set; }
		public String HRA_Upfront_Deductible_Tier_Selection{ get; set; }
		public String Legacy_Lumenos_HRA{ get; set; }
		public boolean Member_Pay_HRA_with_Debit_Card{ get; set; }
		public String Offer_Rx_debit_Card{ get; set; }
		public boolean Provider_Pay_Split_HRA{ get; set; }
		public String Quoted_Product_Name{ get; set; }
		public String Sequence{ get; set; }
		public String SF_Quote_Item_Id{ get; set; }

	}
	
	// 33173 code ends
}