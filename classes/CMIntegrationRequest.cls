/*
@Author : Accenture Dev team
@name : CMIntegrationRequest
@CreateDate : 09-19-2019
@Description : This class will represent JSON payload need to be sent to CM. 
The supplied json has fields with names that are not valid in apex
and so can only be parsed with explicitly generated code

https://www.adminbooster.com/tool/json2apex

Need to replace invalid field:
life&Disability

and rename reserved keyword: 
trigger -> triggerStr
system -> systemStr

and make each inner class public

there are two idCard section, one is under customerConfig, the other is under productConfig, 
so rename the first one to be cls_idCardCustomerConfig 

there are two clsection, one is under customerConfig, the other is under productConfig, 
so rename the first one to be cls_claimCustomerConfig

there are two miscellaneous, one is under customerConfig, the other is under productConfig, 
so rename the first one to be cls_miscellaneousCustomerConfig

add a temporary errorMessage field to payloadInformation field for debug purpose
*/
global class CMIntegrationRequest{
	
    public cls_payloadInformation payloadInformation;

    public cls_eventMetaData eventMetaData;
    public cls_maintenance[] maintenance;
    public cls_accountInfo accountInfo;
	public class cls_payloadInformation {
		public String entryName;
		public String version;
		public String versionEffectiveBeginDate;	
		public String versionDescription;	
        public String errorMessage = '';
	}
    public class cls_eventMetaData {
        public String userId;    
        public String sourceSystemId;    
        public String trackingId;    
        public String eventType;    
        public String masterId;    
        public String subTrackingId;    
    }
    public class cls_maintenance {
        public String entity;    
        public String change;    
        public cls_ids[] ids;
    }
  /*  public class cls_id {
        public Integer sequence;    
        public String id;    
    } */
    public class cls_accountInfo {
        public cls_parentInfo parentInfo;
        public cls_customerInfo customerInfo;
        public cls_accountBillGroups[] accountBillGroups;
    }
    public class cls_parentInfo {
        public cls_ids[] ids;
        public cls_demographic demographic;
        public cls_status status;
        public cls_notes[] notes;
        public cls_parentConfig parentConfig;
    }
    public class cls_ids {
        public String sourceSystem; 
        public String name; 
        public String value;    
    }
    public class cls_demographic {
        public cls_organizationName organizationName;
        public cls_contact contact;
    }
    public class cls_organizationName {
        public String name; 
        public String dbaName;  
    }
    public class cls_contact {
        public cls_persons[] persons;
        public cls_addresses[] addresses;
        public cls_phones[] phones;
        public cls_emails[] emails;
    }
    public class cls_persons {
        public String id;   
		public String referenceId;	
        public String lastName; 
        public String firstName;    
        public String middleName;   
		public cls_purposes[] purposes;
        public String organization; 
        public String title;    
	
        public cls_addresses addresses;
        public cls_phones phones;
        public cls_emails emails;
    }
	public class cls_purposes {
		public String purpose;	
	}
    public class cls_addresses {
        public String id;   
        public String attn; 
        public String line1;    
        public String line2;    
        public String city; 
        public String countyName;   
        public String stateCode;    
        public String zipCode;  
        public String zipCodePlus;  
        public String foreignCountryFlg;    
        public String foreignPostalCode;    
        public String countryCode;  
        public String countryName;  
        public String useType;  
        public String validationFlag;   
		public String primaryIndicator;	
        public cls_coordinate coordinate;
        public String effectiveDtm; 
    }
    public class cls_coordinate {
        public String longitude;    
        public String latitude; 
    }
    public class cls_phones {
        public String id;   
        public String useType;  
        public String type; 
        public String value;    
        public String authorizeTxtFlg;  
		public String primaryIndicator;	
        public String effectiveDtm; 
    }
    public class cls_emails {
        public String id;   
        public String useType;  
		public String primaryIndicator;	
        public String value;    
        public String effectiveDtm; 
    }
    public class cls_status {
        public cls_timeline[] timeline;
    }
    public class cls_timeline {
        public String status;   
        public String effectiveDate;    
        public String endDate;  
        public cls_reasons[] reasons;
    }
    public class cls_reasons {
        public String code; 
        public String description;  
    }
    public class cls_notes {
        public String id;   
        public String name; 
        public String value;    
        public String fromDate; 
    }
    public class cls_parentConfig {
        public cls_legalEntity legalEntity;
        public cls_masterBusinessUnit masterBusinessUnit;
        public cls_marketSegmentBilling marketSegmentBilling;
    }
    public class cls_legalEntity {
        public String name; 
        public String taxId; 
        public String type;
    public String effectiveDate;    
    }
    public class cls_masterBusinessUnit {
        public String code; 
        public String contractStateCode;    
        public String fundingType;  
        public String effectiveDate;    
    }
    public class cls_marketSegmentBilling {
        public String marketSegment;    
        public String billingSystemPreference;  
    }

    public class cls_customerInfo {
        public cls_customers[] customers;
    }
    public class cls_customers {
        public cls_ids[] ids;
        public cls_demographic demographic;
        public cls_status status;
        public cls_idCardsTrigger[] idCardsTrigger;
        public cls_customerConfig customerConfig;
        public cls_notes[] notes;
        public cls_broker broker;
        public cls_products[] products;
    }

    public class cls_customerConfig {
        public cls_legalEntity legalEntity;
        public cls_miscellaneousCustomerConfig miscellaneous;
        public cls_thirdPartyAdministrator thirdPartyAdministrator;
        public cls_customerVendorSegment customerVendorSegment;
        public cls_customerIndicators customerIndicators;
        public cls_dentalCensus dentalCensus;
        public cls_salesOfficeLocation salesOfficeLocation;

        public cls_enrollment enrollment;
        public cls_idCardCustomerConfig idCard;
        public cls_claimCustomerConfig claim;
        public cls_cobra cobra;
        public cls_membershipDescriptors[] membershipDescriptors;
        public cls_renewal renewal;
        public cls_report report;
        public cls_underWriting underWriting;
        public cls_representatives[] representatives;
        public cls_quotes[] quotes;
	public cls_speciality  speciality ;
    }
    
    public class cls_miscellaneousCustomerConfig {
        public String prefixAccountId;
        public String prefixIndicator;
        public String membershipLocationCode;
        public String overPaymentService;
        public String eocIndicator;
        public String standardIndustryClassification;
    }
    public class cls_miscellaneous {
		public String rateType;	
        public String occuranceCode;    
        public String minAmnt;  
        public String payType;  
        public String employerIdNumber; 
        public String groupCategoryType;    
        public String maxAge;   
        public String classificationCode;   
        public String multipleCode; 
        public String billingChargeCode;    
        public String medicareRate; 
        public String groupId;  
    }
    public class cls_thirdPartyAdministrator {
        public String code; 
        public String effectiveDate;    
    }
    public class cls_customerVendorSegment {
        public String planSource;   
    }
    public class cls_customerIndicators {
        public String eligibilityChange;    
        public String eligibilityTerm;  
    }
    public class cls_dentalCensus {
        public Integer numberofEligibleEmployees;   
        public String participationRequirementsForEmployee; 
        public String participationRequirementsForDependent;    
        public String dentalExchangeName;   
        public String medlock;  
		public String blockRated;	
		public String performanceGuarantee;	
    }


    public class cls_salesOfficeLocation {
        public String code; 
        public String effectiveDate;    
    }

    public class cls_enrollment {
        public cls_retro retro;
        public String oadRiderCode; 
        public String fullDepEligibilityFlag;   
        public String hcidEnrollCode;   
        public String effectiveDate;    
    }
    public class cls_retro {
        public String daysOL;  
        public String daysGT;  
    }
    public class cls_idCardsTrigger {
        public String entityID; 
        public String entityType;   
        public String effectiveDate;    
		public String triggerTypeIndicator;	
    }
    public class cls_idCardCustomerConfig {
        public String nonHmoldCards;
        public String idCardCompanyLogo;
        public String genIdCardIndicator;
        public String effectiveDate;
    }
    
    public class cls_idCard {
        public String sequence; 
        public String idDistributionInitialIndicator;   
        public String idDistributionOngoing;    
        public String idDesignCode; 
     //   public String triggerStr;   
        public String stickerIndicator; 
    }

    public class cls_claimCustomerConfig {
        public String paperlessEobExcl; 
        public String claimReporting;   
        public String runInClaims;  
        public String claimCategories;  
        public String runOutClaims; 
        public String claimFundingOff;  
        public cls_flexBenefit flexBenefit;
        public cls_minimumPremiumPlan minimumPremiumPlan;
        public cls_nationalCareNetwork nationalCareNetwork;
        public cls_claimVendors[] claimVendors;
        public cls_customerCouncilOfAffordableQualityHealthPlanCoordinationOfBenefitsIndicator customerCouncilOfAffordableQualityHealthPlanCoordinationOfBenefitsIndicator;
    }
    
    
    public class cls_claim {
        public String route;    
       // public String graceDays;    
        public String claimGraceDays;   
    }
    public class cls_flexBenefit {
        public String effectiveDate;    
    }
    public class cls_minimumPremiumPlan {
        public String mppInsuranceRunout;   
        public String termReservelessMppCheckStock; 
    }
    public class cls_nationalCareNetwork {
        public String referralIndicator;    
        public String referralEffectiveDate;    
    }
    public class cls_claimVendors {
        public String code; 
        public String effectiveDate;    
    }
    public class cls_customerCouncilOfAffordableQualityHealthPlanCoordinationOfBenefitsIndicator {
        public String notSubjectToCoordinationOfBenefits;   
        public String notSubjectToCoordinationOfBenefitsReasonCode; 
    }
    public class cls_cobra {
        public String adminServicesFlag;    
        public String erisaFlag;    
    }
    public class cls_membershipDescriptors {
        public cls_department[] department;
    }
    public class cls_department {
        public cls_info info;
    }
    public class cls_info {
        public String code; 
        public String name; 
    }
    public class cls_renewal {
        public String nextAnniversaryDate;  
    }

    public class cls_report {
        public String customKeyAccess;  
    }
    public class cls_underWriting {
        public String underWriter;  
        public String uwWorkMonth;  
        public String focalRenewalDate; 
    }
    public class cls_representatives {
        public cls_internalSalesRepresentative internalSalesRepresentative;
    }
    public class cls_internalSalesRepresentative {

        public String salesType;    
        public String representativeNumber; 

    }
    public class cls_quotes {
        public String quoteID;  
        public String type; 
        public String effectiveDate;    
    }
	public class cls_speciality  {
		public String principleEmployerIndicator;	
		public String gsmCreator;	
	}
    public class cls_broker {
      //  public String defaultAgent; 
        public cls_agents[] agents;
    }
    public class cls_agents {
        public String type; 
        public String generalAgent; 
        public String onLineApplicationIndicator;   
      //  public String defaultAgentIndicator;    
        public cls_writingAgent writingAgent;
        public cls_parentTax parentTax;
        public String agentCode;    
        public cls_agentInformation agentInformation;
        public cls_productPercent[] productPercent;
    }
    public class cls_writingAgent {
        public String corpCode; 
        public String taxIdentificationNumber; 
    }
    public class cls_parentTax {
        public String corpCode; 
        public String identificationNumber;    
    }
    public class cls_agentInformation {
        public cls_agentName agentName;
        public String brokerAgencyName; 
        public String contactType;  
        public String phone;    
        public String email;    
        public cls_address address;
    }
    public class cls_agentName {
        public String lastName; 
        public String firstName;    
        public String middleName;   
    }
    public class cls_address {
        public String attn; 
        public String line1;    
        public String line2;    
        public String city; 
        public String stateCode;    
        public String countyName;   
        public String foreignCountryFlg;    
        public String foreignPostalCode;    
        public String countryCode;  
        public String countryName;  
        public String useType;  
        public String effectiveDtm; 
        public String zipCode;  
        public String zipCodePlus;  
        public cls_coordinate coordinate;
    }
    public class cls_productPercent {
        public String contractCode; 
        public String productType;  
        public Integer percent; 
        public String effectiveDate;    
        public String expirationDate;   
    }
    public class cls_products {
        public Integer productId;   
        public String networkType;  
		public String contractCode;	
        public String networkName;  
        public String networkId;    
        public String type; 
        public String name; 
        public String stateCode;    
        public String fundingType;  
        public String legalEntityDescription;   
        public String financingOption;  
        public String metalLevel;   
        public String qhpIndicator; 
        public String exchangeIndicator;    
        public String workLocation;    
        public String healthPlanContractCode;   
        public String consumerDrivenHealthPlanProductType;  
        public String memberProductCode;    
        public String benefitYearOrCalendarYearCode;    
        public String effectiveDate;    
        public String expirationDate;   
        public cls_productClasses[] productClasses;
        public cls_rates[] rates;
        public cls_productQuestion productQuestion;
        public cls_vision vision;
        public cls_proxy proxy;
        public cls_productConfig productConfig;
    }
    public class cls_productClasses {
        public String sequenceNumber;   
        public String referenceId;  
        public String employmentCategoryCode;   
        public String employmentClass;  
        public String requestedName;    
        public String effectiveDate;    
        public String expirationDate;   
    }
    public class cls_rates {
        public String id;   
        public String opportunityId;
    }
    public class cls_productQuestion {
        public Integer sizeBand;    
        public String hsaHraBankingType;    
    }
    public class cls_vision {
        public cls_coPay coPay;
        public cls_benefitLevel benefitLevel;
    }
    public class cls_coPay{
        public Decimal examCopay;    
        public Decimal lensCopay; 
    }
    public class cls_benefitLevel{
       public String eyeMedPlanCode;    
       public String benefitLevel1;
       public String benefitLevel2; 
       public String benefitLevel3; 
       public String benefitLevel4; 
       public String adultCoMingle;
       public String childCoMingle;
    }
    public class cls_proxy {
        public String id;        
    }
    public class cls_productConfig {
        public cls_productBilling productBilling;
        public cls_benefitYearOrCalendarYear benefitYearOrCalendarYear;
		public cls_productConfigurationIndicator productConfigurationIndicator;
        public cls_lifeAndDisability[] lifeAndDisability;
        public cls_dds[] dds;
        public cls_eligibility eligibility;
        public cls_productVendorSegment productVendorSegment;
		public cls_productSegmentIndicator productSegmentIndicator;
        public cls_idCard idCard;
        public cls_exempt exempt;
        public cls_location location;
        public cls_process process;
        public cls_rateMethod rateMethod;
        public cls_nationalEligibility nationalEligibility;
        public cls_miscellaneous miscellaneous;
        public cls_productDates productDates;
        public cls_oadPairedGroup oadPairedGroup;
        public cls_promptPay promptPay;
        public cls_locationStateCode locationStateCode;
        public cls_cancel cancel;
        public cls_company company;
        public cls_claim claim;
        public cls_itsHome itsHome;
        public cls_groupAdminOverride groupAdminOverride;
    }
    public class cls_productBilling {
        public String prorateRule;  
        public String billComponentsCode;   
    }
    public class cls_benefitYearOrCalendarYear {
        public String code; 
        public String asofDate; 
    }
	public class cls_productConfigurationIndicator {
        public String groupTapeEnrollment;  
        public String etIndicator;  
        public String mhsOptOutIndicator;   
        public String mhSaSvcLevelIndicator;    
        public String hsaQualIndicator; 
        public String domesticPartnerIndicator; 
        public String alternateNetworkIndicator;    
        public String healthWellnessIndicator;  
        public String privateExchangeIndicator; 
        public String mbrSalaryIndicator;   
        public String employeeAssistanceProgram;    
        public String hsaFamilySingleIndicator; 
        public String hallmarkGiftCardBillIndicator;    
        public String autoPicIndicatorForVivity;    
        public String transitionIndicator;  
        public String pediatricHealthPlan;  
        public String combinedBillingIndicator; 
        public String attestationIndicator; 
        public String rdsGroupAttestationIndicator; 
    }
    public class cls_lifeAndDisability {
        public String employmentCategoryCode;   
        public String employmentClass;  
        public String priorEmployerWaitingPeriod;   
        public String waitType; 
        public String priorEmployDateADJRule;   
        public String subsWaitPer;  
        public String subsEmployWaitType;   
        public String subEmployDateADJRule; 
        public String minEligibilityHours;  
        public String minHoursUnit; 
        public String salaryDefinition; 
        public String maxProductAge;    
        public String minProductAge;    
    }
    public class cls_dds {
        public String employmentCategoryCode;   
        public String employmentClass;  
        public String performanceGuaranteeClaimsTurnaroundTime; 
        public String marketingContact; 
        public String association;  
        public String contactType;  
        public String benefitTemplateId;    
        public cls_dentalBenefits dentalBenefits;
    }
    public class cls_dentalBenefits {
        public Integer dentalCopay;    
        public Integer dentalCoin;    
        public Integer dentalDeductable;    
        public String effectiveDate;    
        public Integer dentalService;    
        public Integer dentalBenefitCode;    
    }
    public class cls_eligibility {
        public String employerSubscriberPercent;   
        public String employerDependentPercent;    
        public String newHiresCode; 
        public String probationPeriodCode; 
        public String deleteDependentCode;  
        public String overSixtyFiveCode;   
        public String openEnrollmentCode;   
        public String healthStatementCode;  
        public Integer companySizeCategoryCode;  
        public String duplicateCoverageSupplemental;    
        public String vendorReferral;   
        public String handWPairedGroupAndEffectiveDate; 
        public String retroDaysCodeOlGt;    
        public String preferredDrugCode;    
        public String eligibilityCode;  
        public String calendarOrBenefitYearCode;    
        public String domesticPartnerCode;  
        public String overageMailing;   
        public String oadAutoDelete;    
        public String addReasonCode;    
        public String employeeExcludedCode; 
      //  public String eocIndicator; 
        public String eligibilityCodeEffectiveDate; 
		public String washoutCode;	
    }
    public class cls_productVendorSegment {
		public String wageWorks;	
		public String navitusFeed;	
    }
	public class cls_productSegmentIndicator {
        public String liveHealthOnline; 
        public String asoNewbornOptOut;    
        public cls_letterSuppression letterSuppression;
        public String womensContraceptive;  
        public String healthSpendingAccountBankFeeIndicator;    
        public cls_councilOfAffordableQualityHealthPlanCoordinationOfBenefitsIndicator councilOfAffordableQualityHealthPlanCoordinationOfBenefitsIndicator;
        public String fundingOffIndicator;  
    }
    public class cls_letterSuppression {
        public String delinquencyCancellationLetter;    
        public String certificateOfCreditableCoverage;  
        public String conversionLetter; 
        public String terminationLetter;    
    }
    public class cls_councilOfAffordableQualityHealthPlanCoordinationOfBenefitsIndicator {
        public String notSubjectToCoordinationOfBenefits;   
        public String notSubjectToCoordinationOfBenefitsReasonCode; 
    }

    public class cls_exempt {
        public String type; 
        public String typeEffectiveDate;    
        public String typeTermDate; 
    }
    public class cls_location {
        public String lobCode;  
    }
    public class cls_process {
        public String groupProcessCode; 
        public String groupTapeEnrollment;  
    }
    public class cls_rateMethod {
        public String code; 
        public String codeEffectiveDate;    
    }
    public class cls_nationalEligibility {
        public String primaryNetwork;   
        public String primaryNetworkEffectiveDate;  
        public String primaryNetworkTermDate;   
    }
    public class cls_productDates {
        public String originalEffectiveDate;    
        public String addProcessDate;   
        public String reinstateEffectiveDate;   
        public String reinstateProcessDate; 
        public String cancelEffectiveDate;  
        public String cancelProcessDate;    
        public String preferredDrugCodeEffectiveDate;   
        public String eligibilityCodeEffectiveDate; 
        public String hcbcLastProcessDate;  
    }
    public class cls_oadPairedGroup {
        public String oadPairedGroup;   
        public String oadPairedGroupEffectiveDate;  
        public String oadPairedGroupEndDate;    
        public String billingPairedGroups;  
    }
    public class cls_promptPay {
        public String indicator;    
        public String effectiveDate;    
    }
    public class cls_locationStateCode {
        public String locationStateCode;    
        public String locationStateCodeEffectiveDate;   
    }
    public class cls_cancel {
        public String cancelReason; 
    }
    public class cls_company {
        public String companyCode;  
        public String companyCodeEffectiveDate; 
    }
    public class cls_itsHome {
        public String indicator;    
        public String effectiveDate;    
        public String itsPrefix;    
        public String blueCardExtraTerritorialIndicator;    
        public String blueCardExtraTerritorialIndicatorEffectiveDate;   
    }
    public class cls_groupAdminOverride {
        public String overrideIndicator;    
        public cls_groupContactOverride[] groupContactOverride;
    }
    public class cls_groupContactOverride {
        public String employmentCategoryCode;   
        public String employmentClass;  
        public String groupSuffix;  
        public String adminName;    
        public cls_address address;
    }
    public class cls_accountBillGroups {
        public cls_ids[] ids;
        public cls_demographic demographic;
        public cls_status status;
        public cls_billConfig billConfig;
    }
    public class cls_billConfig {
        public cls_billInvoice billInvoice;
        public cls_billArrangements[] billArrangements;
        public cls_invoiceSortingOptions[] invoiceSortingOptions;
        public cls_delinquency delinquency;
        public cls_format format;
        public cls_otherConfig otherConfig;
    }
    public class cls_billInvoice {
        public String billOrSelfBillCode;   
        public String billCycle;    
        public String billRouteType;    
        public String customerClass;    
        public String division; 
        public String workLocation; 
        public String invoiceFormat;    
    }
    public class cls_billArrangements {
        public String customerId;   
        public String productType;  
		public String contractCode;	
		public String employmentCategory;	
        public String employmentClass;  
    }
    public class cls_invoiceSortingOptions {
        public Integer sequence;    
        public String field;    
        public String order;    
        public cls_customLists[] customLists;
    }
    public class cls_customLists {
        public String value;    
    }
    public class cls_delinquency {
        public String graceDays;    
        public String tolerancePercent; 
        public String payType;  
    }
    public class cls_format {
        public String billCopies;   
        public String invoiceType;  
        public String hcidForBillPrintIndicator;    
    }
    public class cls_otherConfig {
        public String refund;   
        public String entityType;   
        public Integer billFromDay; 
    }
}