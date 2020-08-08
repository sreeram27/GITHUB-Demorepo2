/**
 * @author Santosh Gudge
 * @date 05/07/19
 *
 * @description Contains the logic for serializing, deserializing, and creating CDHP Questionnaires from Rest API calls
 */
public with sharing class CDHPISGRestAPIClient {

    /**
     * @description Creates a CDHP Questionnaire from information passed by a Rest API call
     * @param InstanceUri The URI that the call out is made to 
     * @param accessToken The access token used in the HTTP Request
     * @param chdpFields A list of CDHP Questionnaire fields
     * @return The CDHPFields from the Rest API call
     */
    public static CDHPFields createCDHPInISG(String InstanceUri, String accessToken, CDHPFields chdpFields) {
        HttpRequest httpReq = new HttpRequest();
        Http http = new Http();
        httpReq.setMethod('POST');
        httpReq.setEndpoint(Label.CDHP_EndPointURL);
        //PRDCRM 34415       
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        httpReq.setTimeout(120000);
        String jsonStr = serializeCDHPObject(chdpFields);
        jsonStr = EncodingUtil.urlEncode(jsonStr, 'UTF-8');
        httpReq.setBody('{"JSONStr":"' + jsonStr + '"}');
        HTTPResponse httpResp;
        if (!Test.isRunningTest())
            httpResp = http.send(httpReq);
        else {
            httpResp = new HTTPResponse();
            String body = JSON.serialize('{"JSONStr":"' + jsonStr + '"}');
            httpResp.setBody(body);
            httpResp.setStatus('success');
            httpResp.setStatusCode(200);
        }
        String retJsonStr = EncodingUtil.urlDecode(httpResp.getBody(), 'UTF-8');
        retJsonStr = retJsonStr.replace('\\"', '"');
        retJsonStr = retJsonStr.substring(1, retJsonStr.length() - 1);
        return deserializeCDHPObject(retJsonStr);
    }

    /**
     * @description Contains Getter and Setter methods for fields from the CDHP Questionnaire
     */
    public with sharing class CDHPFields {
        public String orgName {
            get;
            set;
        }
        public GroupDetails groupDetails {
            get;
            set;
        }
        public OpportunityDetails opportunityDetails {
            get;
            set;
        }
        public List <ContactDetails> contactDetails {
            get;
            set;
        }
        public List <ProductDetails> productDetails {
            get;
            set;
        }
        public List <HRAProductDetails> hraProductDetails {
            get;
            set;
        }
        public StatusDetails statusDetails {
            get;
            set;
        }
        public UserDetails userDetails {
            get;
            set;
        }
        public AccountAddress accountAddress {
            get;
            set;
        }
        public Map <String, CDHPISGRestAPIClient.CDHPFields> quoteProdHRA = new Map <String, CDHPISGRestAPIClient.CDHPFields> (); //Added by Suresh
    }
    //Added by Suresh
    /**
     * @description Contains Getter and Setter methods for Quote Details
     */
    public with sharing class quoteDetails {
        public Map <String, CDHPISGRestAPIClient.CDHPFields> quoteProdHRA {
            get;
            set;
        }
    }
    /**
     * @description Contains Getter and Setter methods for Group Details
     */
    public class GroupDetails {
        public String employerName {
            get;
            set;
        }
        public String sfAccountId {
            get;
            set;
        }
        public String taxId {
            get;
            set;
        }
        public String employerIdCaseNumber {
            get;
            set;
        }
        public Decimal numberOfEligibleEmpl {
            get;
            set;
        }
        public Decimal estimatedNumberOfParticipanets {
            get;
            set;
        }
        public String brand {
            get;
            set;
        }
        public String sic {
            get;
            set;
        }
        public String sicDesc {
            get;
            set;
        }
        public String type {
            get;
            set;
        }
        public String dunsNumber {
            get;
            set;
        }
        public String physicalStreet {
            get;
            set;
        }
        public String physicalCity {
            get;
            set;
        }
        public String physicalState {
            get;
            set;
        }
        public String physicalZip {
            get;
            set;
        }
        //US-41450, Added to pass Anthem Entity Abbreviation
        public String segmentInformation {
            get;
            set;
        } //PRDCRM-43498
    }
    /**
     * @description Contains Getter and Setter methods for Opportunity Details
     */
    public with sharing class OpportunityDetails {
        public String sfORGOpportunityId {
            get;
            set;
        }
        public String optyName {
            get;
            set;
        }
        public String groupNumber {
            get;
            set;
        }
        public Date optyEffectiveDate {
            get;
            set;
        } // CloseDate 
        public String optyRecordType {
            get;
            set;
        } //OpportunityRecordTypeName__c
        public String stageName {
            get;
            set;
        } // StageName
        public String opportunityOwner {
            get;
            set;
        } // Owner
    }
    /**
     * @description Contains Getter and Setter methods for HRA Product Details
     */
    public with sharing class HRAProductDetails {
        public String sfORGOpportunityId {
            get;
            set;
        }
        public String hra1_Group_Suffix {
            get;
            set;
        }
        public Decimal hra_Ann_Roll_Cap_Amt_Emp {
            get;
            set;
        }
        public Decimal hra_Ann_Roll_Cap_Amt_Emp_Adult {
            get;
            set;
        }
        public Decimal hra_Ann_Roll_Cap_Amt_Emp_Child {
            get;
            set;
        }
        public Decimal hra_Ann_Roll_Cap_Amt_Emp_Children {
            get;
            set;
        }
        public Decimal hra_Ann_Roll_Cap_Amt_Family {
            get;
            set;
        }
        public Decimal hra_Annual_Alloc_Amt_Emp_Adult {
            get;
            set;
        }
        public Decimal hra_Annual_Alloc_Amt_Emp_Child {
            get;
            set;
        }
        public Decimal hra_Annual_Alloc_Amt_Emp_Children {
            get;
            set;
        }
        public Decimal hra_Annual_Alloc_Amt_Employee {
            get;
            set;
        }
        public Decimal hra_Annual_Alloc_Amt_Family {
            get;
            set;
        }
        public String hra_Annual_Allocation_Tier_Selection {
            get;
            set;
        }
        public Date hra_Claim_Run_Out_Date {
            get;
            set;
        }
        public Boolean hra_Debit_Card_Dental_Services {
            get;
            set;
        }
        public Boolean hra_Debit_Card_Medical_Services {
            get;
            set;
        }
        public Boolean hra_Debit_Card_OTC_Services {
            get;
            set;
        }
        public Boolean hra_Debit_Card_Rx_Services {
            get;
            set;
        }
        public Boolean hra_Debit_Card_Vision_Services {
            get;
            set;
        }
        public Boolean hra_Embedded_Ded {
            get;
            set;
        }
        public Decimal hra_Employee_Funds_Rollover_Amounts {
            get;
            set;
        }
        public String hra_Employee_Funds_Rollover_Options {
            get;
            set;
        }
        public String hra_Fund_Allocation {
            get;
            set;
        }
        public String hra_Funding_Pro_Rate {
            get;
            set;
        }
        public String hra_Health_Activities {
            get;
            set;
        }
        public String hra_Health_Activities_Options {
            get;
            set;
        }
        public Decimal hra_Individual_Embedded_Ded_Amt {
            get;
            set;
        }
        public String hra_Max_Rollover_Amt_Cap_Tier {
            get;
            set;
        }
        public String hra_Member_Responsibility_by_Claim {
            get;
            set;
        }
        public Decimal hra_Min_Rollover_Amt {
            get;
            set;
        }
        public Boolean hra_Prov_Pay_Med_w_Opt_Rx_Den_Vis_Deb_Cd {
            get;
            set;
        }
        public Boolean hra_ProvPay_Opt_DebCd_Dental_Option {
            get;
            set;
        }
        public Boolean hra_ProvPay_Opt_DebCd_INN_Med_Coins {
            get;
            set;
        }
        public Boolean hra_ProvPay_Opt_DebCd_INN_Med_Copay {
            get;
            set;
        }
        public Boolean hra_ProvPay_Opt_DebCd_INN_Med_Ded {
            get;
            set;
        }
        public Boolean hra_ProvPay_Opt_DebCd_Medical {
            get;
            set;
        }
        public Boolean hra_ProvPay_Opt_DebCd_ONN_Med_Coins {
            get;
            set;
        }
        public Boolean hra_ProvPay_Opt_DebCd_ONN_Med_Copay {
            get;
            set;
        }
        public Boolean hra_ProvPay_Opt_DebCd_ONN_Med_Ded {
            get;
            set;
        }
        public Boolean hra_ProvPay_Opt_DebCd_Rx_Option {
            get;
            set;
        }
        public Boolean hra_ProvPay_Opt_DebCd_Vision_Option {
            get;
            set;
        }
        public Boolean hra_Rollover {
            get;
            set;
        }
        public Date hra_Rollover_Date_recommend_3_months {
            get;
            set;
        }
        public String hra_Rollover_Offer {
            get;
            set;
        }
        public String hra_Termed_Emp_Claims_Run_out_Deadline {
            get;
            set;
        }
        public String hra_Terminated_Employees_Other_Value {
            get;
            set;
        }
        public String hra_Unused_rollovrfund_diff_Adm_last_yr {
            get;
            set;
        }
        public Decimal hra_Upfront_Ded_Amt_Emp {
            get;
            set;
        }
        public Decimal hra_Upfront_Ded_Amt_Emp_Adult {
            get;
            set;
        }
        public Decimal hra_Upfront_Ded_Amt_Emp_Child {
            get;
            set;
        }
        public Decimal hra_Upfront_Ded_Amt_Emp_Children {
            get;
            set;
        }
        public Decimal hra_Upfront_Ded_Amt_Family {
            get;
            set;
        }
        public String hra_Upfront_Deductible_Tier_Selection {
            get;
            set;
        }
        public String legacy_Lumenos_HRA {
            get;
            set;
        }
        public Boolean member_Pay_HRA_with_Debit_Card {
            get;
            set;
        }
        public String offer_Rx_debit_Card {
            get;
            set;
        }
        public Boolean provider_Pay_Split_HRA {
            get;
            set;
        }
        public String quoted_Product_Name {
            get;
            set;
        }
        public String sequence {
            get;
            set;
        }
        public String sf_Quote_Item_Id {
            get;
            set;
        }
        public Date hra_Plan_End_Date {
            get;
            set;
        }
        public Date hra_Plan_Start_Date {
            get;
            set;
        }
        public Boolean prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay {
            get;
            set;
        }
        public boolean hra_Provider_Pay {
            get;
            set;
        }
        public boolean hra_Auto_Pay_with_Rx_Debit_Card {
            get;
            set;
        }
        public String prodName {
            get;
            set;
        }
        public Date account_Effective_Date_Plus_X {
            get;
            set;
        } //HRARolloverFields
        public Date desired_Rollover_Date_Fund {
            get;
            set;
        }
        public String during_claims_run_out {
            get;
            set;
        }
        public String group_Accumulators_And_HRA_Allocation {
            get;
            set;
        }
        public String will_HRA_rollover_funds_ever_expire {
            get;
            set;
        }
        public String hra_LITES_Rollover {
            get;
            set;
        }
        public String act_Wise_Plan_Changes_HRA {
            get;
            set;
        }

    }
    /**
     * @description Contains Getter and Setter methods for Product Details
     */
    public with sharing class ProductDetails {
        public String accountType {
            get;
            set;
        } //HSA, HSA, HRA etc.,
        public String fsaPlan {
            get;
            set;
        }
        public String sfORGQuoteId {
            get;
            set;
        }
        public String sfORGQuoteLineId {
            get;
            set;
        }
        public String prodName {
            get;
            set;
        }
        public boolean limited_Purpose_FSA_Plan {
            get;
            set;
        }
        public boolean dependent_Care_FSA_Plan {
            get;
            set;
        }
        public boolean commuter_Account_Type {
            get;
            set;
        }
        public boolean transit_Plan_Option {
            get;
            set;
        }
        public boolean parking_Plan_Option {
            get;
            set;
        }

        public boolean member_Pay_HRA_with_Debit_Card {
            get;
            set;
        } //Member_Pay_HRA_with_Debit_Card__c
        public boolean hra_Auto_Pay_with_Rx_Debit_Card {
            get;
            set;
        } //HRA_Debit_Card_Rx_Services__c
        public boolean prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay {
            get;
            set;
        } //Prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay__c
        public boolean provider_Pay_Split_HRA {
            get;
            set;
        } //Provider_Pay_Split_HRA__c
        public boolean hra_Provider_Pay {
            get;
            set;
        } //HRA_Provider_Pay__c

        public boolean hra_Rollover {
            get;
            set;
        } //HRA_Rollover__c
        public String hsa_Custodian {
            get;
            set;
        }
        public Date hra_Plan_Start_Date {
            get;
            set;
        } //HRA_Plan_Start_Date__c
        public Date hra_Plan_End_Date {
            get;
            set;
        } // HRA_Plan_End_Date__c
        public Date fsa_Plan_Start_Date {
            get;
            set;
        }
        public boolean fsa_Section_213_d_Plan {
            get;
            set;
        }
        public String who_pays_bank_fee {
            get;
            set;
        }
        public Date fsa_Plan_End_Date {
            get;
            set;
        }
        public String cdhpBrand {
            get;
            set;
        }
        public boolean hsa_Account_Type {
            get;
            set;
        }
        public boolean hra_Account_Type {
            get;
            set;
        }
        public boolean fsa_Account_Type {
            get;
            set;
        }
        public String estimated_Number_of_Participants {
            get;
            set;
        }
        public String employerId_CaseNumber {
            get;
            set;
        }
        public String funding {
            get;
            set;
        }
        public String financing {
            get;
            set;
        }
        public String quoteId {
            get;
            set;
        }
        public String actWisePlansChanges {
            get;
            set;
        }

    }

    /**
     * @description Contains Getter and Setter methods for Status Details
     */
    public with sharing class StatusDetails {
        public String status {
            get;
            set;
        }
        public String statusMessage {
            get;
            set;
        }
        public String cdhpParentId {
            get;
            set;
        }
        public Map <String, String> cdhpQuoteIDS {
            get;
            set;
        }
    }
    /**
     * @description Contains Getter and Setter methods for Contact Details
     */
    public with sharing class ContactDetails {
        public String name {
            get;
            set;
        } //Added by Michael Regarding Story 27084
        public String firstName {
            get;
            set;
        }
        public String lastName {
            get;
            set;
        }
        public String eMail {
            get;
            set;
        }
        public String type {
            get;
            set;
        }
        public String phone {
            get;
            set;
        }
        public String title {
            get;
            set;
        }
        public String agencyName {
            get;
            set;
        }
        public String brokerState {
            get;
            set;
        }
        public boolean isPrimary {
            get;
            set;
        }
        public boolean isActive {
            get;
            set;
        }

    }
    /**
     * @description Contains Getter and Setter methods for User Details
     */
    public with sharing class UserDetails {
        public String firstName {
            get;
            set;
        }
        public String lastName {
            get;
            set;
        }
        public String eMail {
            get;
            set;
        }
        public String phone {
            get;
            set;
        }
        public String title {
            get;
            set;
        }
        public String usDomainId {
            get;
            set;
        }
        public String userRole {
            get;
            set;
        }
    }
    /**
     * @description Contains Getter and Setter methods for an Account Address
     */
    public with sharing class AccountAddress {
        public String billingStreet {
            get;
            set;
        }
        public String billingCity {
            get;
            set;
        }
        public String billingState {
            get;
            set;
        }
        public String billingPostalCode {
            get;
            set;
        }
        public String billingCountry {
            get;
            set;
        }
    }
    /**
     * @description Deserializes a CDHP Questionnaire from information passed by a Rest API call
     * @param json The JSON used in the deserialization
     * @return The deserialized CDHPFields from the Rest API call
     */
    public static CDHPFields deserializeCDHPObject(String json) {
        try {
            return (CDHPFields) System.JSON.deserialize(json, CDHPFields.class);
        } catch (Exception ex) {
            system.debug('Error: ' + ex);
            return null;
        }
    }
    /**
     * @description Serializes CDHP Fields from information passed by a Rest API call
     * @param cdhpFields The CDHP Fields used in the serialization
     * @return A String of the serialized CDHPFields from the Rest API call
     */
    public static String serializeCDHPObject(CDHPFields cdhpFields) {
        return System.JSON.serialize(cdhpFields, true);
    }
}