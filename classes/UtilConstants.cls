global without sharing class UtilConstants {

/**
  * @description   UTILConstants Class for saving constant values used across all the apex classes.
  */

    //Role Hirerachy
    public static final String ACCID ='AccountId';
    public static final String SelectICTypeRequest ='SelectICTypeRequest';
    
    //public static final String NULLCOUNT ='NullCount ';
    public static final String DOUBLESLASH ='\'[/ / /]\''; 
    public static final String HYPHEN ='_';
    public static final String REGEX = '\'[/( )/]\'';
    public static final String SPACECHECK  = '\' - \'';
    
    //AP22
    public static final String AIM_Notification=' – AIM Notification ';
    public static final String mailBody ='This e-mail is to advise that a client has purchased or terminated an AIM Product. '; 
    public static final String Account_Name='Account Name: '; 
    public static final String Claims_System='Claims System: ';        
    public static final String Effective_Date='Effective Date: ';                 
    public static final String mailBody2 ='To view all details around the AIM product(s), please see the below link:';
    public static final String mailBody3='To view all details around this specific Implementation Case, please see the below link:';
    //group services and coordinator : AP27
     
     public static final String GroupServicesAPI = 'Group_Services__c';
     public static final String GroupServicesRepAPI='Group_Services_Repeatable__c';
     public static final String ImplementationCoordinatorAPI='Implementation_Coordinator__c';
     public static final String ImplementationCoordinatorRepeatableAPI ='Implementation_Coordinator_Repeatable__c';
     public static final String CLASS_AP27='AP27_RedirectToRecordCreationPage';
     public static final String getGsList='getGsList';
     
     //AP28 labels
    
    public static final String PendingResponsefromESR='Pending Response from ESR';
    public static final String errorMSGBPD='Field Is Client Approval Needed is required.';
    public static final String nullString=null;
   
     //SME Approval : AP19
     public static final String EandB = 'E&B';
     public static final String Specialty = 'Specialty';
     public static final String Contracts = 'Contracts';
     public static final String YES = 'Yes';
     public static final String SME1 = 'SME_';
     public static final string NATIONALIMPLEMENTATIONPROFILE='National Implementations'; 
     
     //SME Approval : AP21_SMENotifyApproverEMail
     public static final String LocalAccounts = 'Local/Large Group';
     public static final String NationalAccounts = 'National Accounts';
     public static final String JAANASCO = 'JAA NASCO';
     public static final String JAAWGS= 'JAA WGS';
     public static final String JAANASCOandWGS =  'JAA NASCO and WGS';
     public static final String NationalNASCO =  'National NASCO';
     public static final String NationalNASCOandWGS =  'National NASCO and WGS';
     public static final String NationalWGS =  'National WGS';
    // public static final String Dit =   'Data Interface Team (DIT)';
     public static final String JAA='JAA (Jointly Administered Arrangement)';
     public static  final String EXISTINGSHIFTJAAFIELD = 'existingShiftJaa';  
     public static final  String  reportMailBody='The Selections Report Required field has been modified.';
     public static final  String  impactHccMailBody='The Impact To HPCC field has been modified.';
     public static final  String  stringsTableMailBody='The Strings/Tables/Contract Codes Impacted field has been modified.';
     //public static final String approved='Approved';
     public static final String approvedcastlight='Approved for Castlight (EBA Only)';
     public static final String healthString='Health and Wellness Solutions';
     public static final String approveddeviation='Approved with Deviations';
     public static final String denied='Denied';
     public static final String na='N/A';
     public static final String medicalString='Medical Benefits';
     public static final String groupString='Group Services';
     //public static final String nasco='Nasco';
     //public static final String wgs='WGS 2.0';
     public static final String idcards='ID Cards';
     public static final String groupServicesForSelectionsReportReuired ='Attention: Group Services For Selections Report Required Update ';
     public static final String groupServicesForImpactHpcc ='Attention: Group Services For Impact To HPCC Update ';
     public static final String medicalBenifitsForSelectionsReportRequired ='Attention: Medical Benefits For Selections Report Required Update ';
     public static final String medicalBenifitsForImpactHpcc ='Attention: Medical Benefits For Impact To HPCC Update ';
     public static final String groupServicesForStringsTablesContract ='Attention: Group Services For Strings/Tables/Contract Codes Impacted Update ';
     public static final String mailBuildermethod = 'mailBuildermethod';
     public static final String sendMailMethod = 'sendMailMethod';
     public static final String sendStatusChangemail = 'sendStatusChangemail';
     public static final String createApprovalRecordsOnUpdate = 'createApprovalRecordsOnUpdate';
     public static final String createApprovalRecordsOnInsert = 'createApprovalRecordsOnInsert'; 
     public static final String triggerName = 'SMEApprovalTrigger';  
     public static final String CLASS_NAMESME ='AP21_SMENotifyApproverEMail';
     public static final String pleaseAddAssignedImplementerIC ='Please notify Implementation Coordinator Lead to add an Assigned Implementer to the attached Implementation Case';
     public static final String implementationCaseRecordBody ='To view the Implementation Case Record, please see the below link:';
     public static final String perviousValue ='Previous Value: ';
     public static final String newValue ='New Value: ';  
     public static final String allSmereviews ='Attention: All SME reviews have been completed for '; 
     public static final String groupServicesNational ='Group Services - National';
     public static final String idCardsNational ='ID Cards - National';
     public static final String idCardsLocal ='ID Cards - Local';
     public static final String queue ='Queue';
     public static final String none ='None';
     public static final String donotreplycom ='donotreply@do-not-reply.com';
     public static final String br ='<br/>'; 
     public static final String to ='To ';     
     public static final String test ='Test';
     public static final String draftstatus ='Draft';
   
   //SME Approval : AP26_NotifyUsers_On_ICStatusChange
   
     public static final String accountExecutive ='Account Executive';
     public static final String accountManager ='Account Manager';
     public static final String eba ='EBA';
     public static final String groupServiceAnalyst ='Group Service Analyst';
     public static final String dataExchangeAnalyst ='Data Exchange Analyst';
     // #PRDCRM-35315 #PRDCRM-36436 Added User Roles HWS Implementor and Underwriter as constants
     public static final String hwsImplementor = 'HWS Implementer';
     public static final String underwriter = 'Underwriter';
     public static final String nofiticationEmailApprovedImplementationCaseRecord ='Notification Email Approved Implementation Case Record';
     public static final String emailNotificationToSpecificSME ='Email Notifications to Specific SME';
     public static final String assigIMpError= 'Assigned Implementer field should not be left blank';
     public static final String keyNumber='51 - 99';
     public static final String othersubrogation ='Other - Anthem Subrogation';
     public static final String emailnotificationforsubrogation ='Email Notification For Subrogation';
     public static final String RevisionPendingImplementationsReview = 'Revision Pending Implementations Review';
     
    //AP25_Email_Controller
    public static final String implementer='Implementer';
        
 //For User Creation
   
//SME Approval : AP18_SMEApproval   

 public static final String RETRIEVE_DEPARTMENT ='returnValue';
 public static final String SAVE_SME_DEPARTMENT = 'saveSMEDepartment';
 public static final String CREATE_SME_DEPARTMENT = 'createSMEApprovalOutmap';
 public static final String GENERATE_SME_DEPARTMENT = 'GenerateSMEApprovalOutmap'; //AP19_Revision class
 public static final String JSON_NAME_FIELD = 'Name';    
 public static final String IMPLEMENTATION_STATUS ='Implementation_Status__c';
 public static final String RETRIEVE_EXAMPLE_SME_DEPARTMENT = 'retrieveExampleSMEDepartment';
 public static final String AUTO_DEPARTMENT ='Auto Department - ';
 public static final String SI_AUTO_DEPARTMENT ='SIAutoDepartment';
 public static final String ST_AUTO_DEPARTMENT ='STAutoDepartment';
 public static final String MANUAL_DEPARTMENT ='Manual Department - ';
 public static final String SI_MANUAL_DEPARTMENT ='SIManualDepartment';
 public static final String ST_MANUAL_DEPARTMENT ='STManualDepartment';
 public static final String CONTEXT_ID ='ContextId';
 public static final String IMP_ID='ImplCaseId';
 public static final String STAT_PENDING = 'Pending';   
 public static final String IT ='IT';
 public static final String INTER_PLAN ='Interplan';
 public static final String ONSITE_CLINIC ='Onsite Clinic';
 public static final String ONSITE_CLINICS ='Onsite Clinics';
 public static final String SME_ONSITE_CLINIC ='SME Onsite Clinic';
  public static final String SLASH_CHAR = '[/ / /]\',\'_\'';
  public static final String NULLCOUNT = 'NullCount';  
 //public static final String OTHER ='Other';        
 public static final String PRICING_CONFIGURATION_MANAGEMENT_PCM ='Pricing Configuration Management (PCM)';
 public static final String API_PRICING_CONFIGURATION_MANAGEMENT_PCM = 'SME_Pricing_Config_Management_PCM__c';
 public static final String SERVICE_OPERATIONS ='Service Operations';
 public static final String PRE_IMPLEMENTATION_TYPE ='preImplementationType';
 public static final String IMPLEMENTATION_TYPE ='ImplementationType';
 public static final String NEW_BUSINESS ='New Business';
 public static final String RENEWAL ='Renewal';
 public static final String CHANGE_REQUEST_OFF_CYCLE ='Change Request Off Cycle';
 public static final String PRE_WORK ='Pre Work';
 public static final String RFP='RFP';
 public static final String YES_VAL = 'yes';
 public static final String YES_EXPLAIN = 'Yes (please explain)';
 
 public static final String IGAP_SOLD ='IGAP Sold';
 public static final String SOLD = 'Sold';
 public static final String TERMED ='Termed';
  public static final String GROUPTERM ='IntakeGroupTerm';
 public static final String RENEWED ='Renewed';
 public static final String VLC_SELECTED ='vlcSelected';
 public static final String TRUE_VAL  = 'true';
 public static final Boolean TRU  = true;
 public static final String HELP_TEXT = 'Omni_Script_Help_Text';
 public static final String FALSE_VAL ='false';
 public static final String SME_BOLD ='SME Bold';
 public static final String BOLD_VAL ='BOLD';
 public static final String BOLD_VALUE ='Bold';
 public static final String MERCER ='Mercer Health Advantage'; 
 public static final String SME_MERCER ='SME Mercer Health Advantage';
 public static final String FILTERED_AUTO_DEPTS ='FilteredAutoDepts';
 public static final String PRODUCT_EFFECTIVE_DATE='ProductEffectiveDate';
 public static final String SME ='SME';
 public static final String OTHER = 'Other';
 public static final String ERROR = 'error';
 public static final String RC= 'reasonCount';
    
 public static final String COMMA = ',';
 public static final String PERCENTAGE = '%';
 public static final string ORGID=UserInfo.getOrganizationId();
 public static final String APPNAME='National Sales';
 public static final String CANCEL='Cancel';
 public static final string CLASS_NAME='AP18_SMEApproval';
 public static final String TEST_CLASS = 'TEST_CLASS';
 public static final String Account_Executive = 'Account Executive'; 
 public static final String Account_Manager='Account Manager';
 public static final String Space=' ';
 public static final String UNDERSCOREC ='__c';   
 public static final String SLASH_QUOTE = '\'';
 
 //Alphanumeric Prefix Request : AP28_UnlockAPRRecord
 public static final String SUBMITTED_T0_INTERPLAN = 'Submitted to InterPlan';
 
 //US654
 public static final String DENTAL = 'Dental';
 public static final String SME_DENTAL = 'SME Dental';
 public static final String DENTAL_NATIONALPPO ='Dental - Anthem Dental National PPO (all)';
 public static final String DENTAL_NET = 'Dental - Dental Net (CA only)';
 public static final String DENTAL_FLEX ='Dental - Flex Dental (CT only)';
 public static final String DENTAL_TRADITIONAL ='Dental - Traditional Dental (not in KY)';
 public static final String DENTAL_BLUE100 ='Dental: Dental Blue 100';
 public static final String DENTAL_BLUE200 ='Dental: Dental Blue 200';
 public static final String DENTAL_BLUE300 ='Dental: Dental Blue 300';
 public static final String DENTAL_COMPCARE ='Dental: Empire Care Network Comprehensive Care (NY Only)';
 public static final String DENTAL_NASCO ='Dental: NASCO Dental'; 
 public static final String DENTAL_CONSUMER ='Dental: Anthem Dental Consumer Choice'; 
 public static final String DENTAL_ESSENTIAL ='Dental: Anthem Dental Essential Choice';
 
 //US652
 public static final String BENIFITS  = 'Benefits';
 public static final String HEALTHEQUITY = 'HealthEquity/WageWorks/FSA/COBRA';
 public static final String SME_HEALTHEQUITY = 'SME HealthEquity/WageWorks/FSA/COBRA';
 public static final String BENIFITS_ADMINCOBRA = 'Benefits Admin: COBRA';
 public static final String BENIFITS_ADMINFSA = 'Benefits Admin: FSA';
 public static final String BENIFITS_ADMINDEPCARESPENDACCT = 'Benefits Admin: Dep Care Spend Acct';
 public static final String BENIFITS_ADMINDIRECTBILL = 'Benefits Admin: Direct Bill';
 public static final String BENIFITS_ADMINTRANSIT = 'Benefits Admin: Transit';
 
 //US 664
 public static final String IHM = 'Integrated Health Model';
 public static final String IHMM = 'IHM';
 public static final String SME_IHM = 'SME IHM';
 public static final String MEDICAL = 'Medical ';
 public static final String ANTHEM_FLEX = 'Anthem FlexHour Medical';
 public static final String Medical_EPO = 'Medical - EPO';
 public static final String Medical_HMO = 'Medical - HMO';
 public static final String Medical_HMO_Vivity = 'Medical - HMO - Vivity';
 public static final String Medical_Indemnity = 'Medical - Indemnity (Traditional)';
 public static final String Medical_POS = 'Medical - POS';
 public static final String Medical_PPO = 'Medical - PPO';
 public static final String MEDICAL_ACTWISE_CDHP_HRA = 'Medical - Act Wise CDHP HRA';
 public static final String MEDICAL_ACTWISE_CDHP_HSA = 'Medical - Act Wise CDHP HSA';
 public static final String Medical_CDHP_HIA = 'Medical-CDHP - HIA';
 public static final String Medical_CDHP_HRA = 'Medical-CDHP - HRA';
 public static final String Medical_CDHP_HSA = 'Medical-CDHP - HSA';
 public static final String Well_Priority_CDHP_HIA = 'Well Priority CDHP HIA';
 public static final String Well_Priority_CDHP_HRA = 'Well Priority CDHP HRA';
 public static final String Well_Priority_CDHP_HSA = 'Well Priority CDHP HSA';
 public static final String Well_Priority_POS = 'Well Priority POS';
   
//US 196
public static final String IGAP_Lost = 'IGAP Lost';
public static final String IGAP_Dead = 'IGAP Dead';
public static final String Lost = 'Lost';
public static final String Dead = 'Dead';

//US 657
  public static final String  LIFE= 'Life and Disability';
  public static final String  LIE= 'Life';
  public static final String  SME_LIFE = 'SME Life and Disability';
  public static final String  LIFE_DEATH  = 'Life - Accidental Death & Dismemberment';
  public static final String  LIFE_DEPEND = 'Life - Dependent Life';
  public static final String  LIFE_GROUP  ='Life - Group Term Life';
  public static final String  LIFE_VOLUNTARY ='Life - Voluntary AD&D';
  public static final String  LIFE_TERM   ='Life - Voluntary Term Life';
  
  //US 663
  public static final String  CCMU = 'CCMU';
  public static final String  CUSTOMER_CARE_MANAGEMENT = 'Health and Wellness: Custom Care Management Unit (CCMU)';
  public static final String  SME_CCMU = 'SME CCMU';  
  
  //US662
  public static final String LITES = 'LITES CDH';
  public static final String SME_LITES = 'SME LITES CDH';
  public static final String NASCO = 'NASCO';
  public static final String WGS = 'WGS 2.0';
  
  //US1059
  public static final String IC_STATUS_INITIATED = 'Initiated';
  public static final String IC_STATUS_READYFORIMPS = 'Ready for Imps';
  public static final String IC_STATUS_PENDINGSMEREVIEW ='Pending SME Review';
  public static final String IC_STATUS_PENDINGFROMSALES = 'Pending Response from Sales/ Account Management';
  public static final String IC_STATUS_APPROVED = 'Approved - Implementation In Progress';
  public static final String IC_STATUS_IMPLCOMPLETED = 'Implementation Completed';
  public static final String IC_STATUS_FINALIZED = 'Finalized';
  public static final String IC_STATUS_WITHDRAWN = 'Withdrawn';
  public static final String  JSON_OTHER_DEPT = 'otherDepartment';
  
  //US668
  public static final String ANTHEM_HEALTH_GUIDE_DEPT = 'Anthem Health Guide';
  public static final String SME_HEALTH_GUIDE = 'SME Anthem Health Guide';
  public static final String HEALTH_GUIDE_PRODUCT = 'Other-Anthem Health Guide';
  
  //US674
  public static final String LIVEHEALTH = 'Live Health Online';
  public static final String SME_LIVEHEALTH = 'SME Live Health Online';
  public static final String LIVEHEALTH_ONLINE ='Health and Wellness - Live Health Online'; 
  
  //US673
  public static final String NCN = 'NCN';
  public static final String SME_NCN = 'SME NCN'; 
  public static final String NCN_PRODUCT = 'Network Based - Non-Par Provider Reimbursement (NCN)';
  
  //US655
  Public static Final Set<String>EAPPRODUCTS = new Set<String>{'EAP - Basic EAP','EAP - Customized EAP','EAP - Enhanced EAP','EAP - Enhanced EAP (4-session model)'};
  
  public static final String EAP = 'EAP';
  public static final String SME_EAP = 'SME EAP';
  public static final String EAP_Basic_EAP ='EAP - Basic EAP';
  public static final String EAP_Customized_EAP = 'EAP - Customized EAP';
  public static final String EAP_Enhanced_EAP ='EAP - Enhanced EAP';
  
  //US665
  Public static Final Set<String>PHARMACYPRODUCTS = new Set<String>{'Pharmacy - Anthem Pharmacy Services'};
  public static final String PHARMACY = 'Pharmacy';
  public static final String SME_PHARMACY = 'SME Pharmacy';
  public static final String PHARMACY_SERVICES_PRODUCT = 'Pharmacy - Anthem Pharmacy Services';
  
   //US207
  public static final String HEALTH_AND_WELLNESS      = 'Health and Wellness Solutions';
  public static final String SME_HEALTH_AND_WELLNESS  = 'SME Health and Wellness Solutions';
  
  //US638
  public static final String GROUP_SERVICES     = 'Group Services';
  public static final String SME_GROUP_SERVICES  = 'SME Group Services';
  public static final String NEW_ELIG ='New Eligibility Vendor Setup';
  
  // 636
  public static final String DIT= 'Data Interface Team (DIT)';
  public static final String SME_DIT = 'SME Data Interface Team (DIT)';
    
  //US643
  public static final String COORDINATED_CARE_MODEL = 'Coordinated Care Model';
  public static final String SME_COORDINATED_CARE_MODEL = 'SME Coordinated Care Model';  
  
  //US660
  public static final String MEDICAL_BENEFITS = 'Medical Benefits';
  public static final String SME_MEDICAL_BENEFITS = 'SME Medical Benefits';  
  public static final String SELECT_REPORT ='SelectionReport';  
  public static final String CLAIM_SYSTEM='claimSystem';  
  public static final String REQCHANGES = 'RequestChanges';
  public static final String CASTPROD  ='Castlight Products';
  public static final String STOP_LOSS ='Stop Loss'; 
   
  //US666
  public static final String TELEHEALTH = 'TeleHealth';
  public static final String SME_TELEHEALTH = 'SME TeleHealth';
  public static final String TELEHEALTH_PRODUCT = 'Health and Wellness - Telehealth - Other Vendor';
  //US23377
   public static final String BENEFIT_INQUIRY = 'Benefit Inquiry';
  //703
  public static final String ACT_WISE_CDH = 'Act Wise CDH';
  public static final String SME_ACT_WISE_CDH = 'SME Act Wise CDH';  
    
  //US705
  public static final String ACTWISEFSA = 'Act Wise FSA';
  public static final String SME_ACTWISEFSA = 'SME Act Wise FSA';
  public static final String BENEFITSADMINFSA ='Benefits Admin - Act Wise FSA';
  public static final String BENEFITSADMINPARK ='Benefits Admin - Act Wise Parking';
  public static final String BENEFITSADMINTRAN ='Benefits Admin - Act Wise Transit';
    
  //US24717
  public static final String BENEFITSADMINCOMM ='Benefits Admin - Act Wise Commuter';
  public static final Set<String>  BENEFITSADMIN = new Set<String>{BENEFITSADMINFSA,BENEFITSADMINPARK,BENEFITSADMINTRAN,BENEFITSADMINCOMM};
  
  //US22489 
  public static final String CRCTILL ='Critical Illness';
  public static final String ACCI ='Accident';
  public static final String HOSPIND ='Hospital Indemnity';
  public static final Set<String>  LIFEANDDISABILITY  = new Set<String>{CRCTILL,ACCI,HOSPIND,LIFE,LIE,SME_LIFE,LIFE_DEATH,LIFE_DEPEND,LIFE_GROUP,LIFE_VOLUNTARY,LIFE_TERM};
    
  //642
  public static final String IMPLEMENTATIONS                = 'Implementations';
  public static final String SME_IMPLEMENTATIONS            = 'SME Implementations'; 
  public static final String PROJECT_PLAN_NEEDED            = 'ProjectPlanNeeded';                 //Order.Is_A_Project_Plan_Needed__c
  public static final String DECISIONS_DELIVERABLES_LIST    = 'DecisionsAndDeliverablesList';     // Order.Is_a_Decisions_Deliverables_List_Needed__c
  public static final String NEW_ELIGIBILITY                = 'New Eligibility Vendor Setup';
  public static final String DATA_INTERFACE                 = 'Data Interface New Vendor Build';
  public static final String CLIENT_CUSTOMIZATION           = 'SSCR Build for Client Customization';
  public static final String SBC                            = 'SBC';
  public static final String APPROVED                       = 'Approved';
  
  //US637
  public static final String ENROLLBILL                     = 'Enrollment and Billing (E/B)';
  public static final String SME_ENROLL                     = 'SME Enrollment and Billing (E/B)';
  public static final String CHANGES_TO_ELIGIBILITY         = 'ChangesToEligibility';                 
  public static final String CHANGES_TO_BILLINGORFUNDING    = 'ChangesToBillingOrFunding'; 
  
  //639
  public static final String ID_CARDS                       = 'ID Cards';
  public static final String SME_ID_CARDS                   = 'SME ID Cards';
  public static final String ID_CARD_CHANGES                = 'IdCardChanges';     
    
  //671
  public static final String SERVICE_OPERATIONS_RETRO      = 'Service Operations Retro';
  public static final String SME_SERVICE_OPERATIONS_RETRO   = 'SME Service Operations Retro';  
  //646
  public static final String Does_Anthem_Prod_SME           = 'DoesAnthemProdSME';
  public static final String Want_The_SBC_Created_By_SME    = 'WantTheSBCCreatedBySME';
  public static final String SBC_DEPT                       = 'SBC';
  public static final String SME_SBC                        = 'SME SBC';
  
  //641
  public static final String Does_Anthem_Prod_Benefit_SME           = 'DoesAnthemProdBenefitSME';
  public static final String Does_This_Require_A_New_Benefit_SME    = 'DoesThisRequireANewBenefitSME';
  public static final String BENEFIT_DEPT                           = 'Contracts'; //'Benefit Booklets/Contracts';  //PRDCRM-42480
  public static final String SME_BENEFIT                            = 'SME Contracts';// 'SME Benefit Booklets/Contracts'; //PRDCRM-42480

    
  //658
   public static final String SPIDER                        = 'Spider';
   public static final String SME_SPIDER                    = 'SME Spider';
   public static final String PHARMACY_STANDARD             = 'Medical - Specialty Pharmacy - Standard';
   public static final String PHARMACY_SELECT               = 'Medical - Specialty Pharmacy - Select';
   public static final String PHARMACY_COMPLETE             = 'Medical - Specialty Pharmacy - Complete';
   public static final String PHARMACY_ALA_CART             = 'Medical - Specialty Pharmacy - A La Carte';
   public static final String PHARMACY_COMPLETE_FI          = 'Medical-Specialty Pharmacy-Complete (FI)';
    
   //633
   public static final String SME_CLAIMS                   = 'SME Claims';
   public static final String INTAKE_RETRO                 = 'IntakeRetro';
    
   //1635
   public static final String aimTrigger                    = 'SendNotifToNationalAIMTeam' ;
   public static final String class_AP22_SendNotifToNationalAIMTeam = 'AP22_SendNotifToNationalAIMTeam';
   
   //677
   Public static final String VIRTUAL_SECOND_OPINION        = 'Virtual Second Opinion';
   Public static final String SME_Virtual_Second_Opinion    ='SME Virtual Second Opinion';
   
   //649
   public static final String UNDERWRITING = 'Underwriting';
   public static final String SME_UNDERWRITING= 'SME Underwriting'; 
   public static final String PARTIALAPPLY='PartialTermApply';
   public static final String APROUT='ApprovedByOut';    
   public static final String CHANGERATE='FinalisedRate'; 
   
   //667
   public static final String VISION = 'Vision';
   public static final String SME_VISION = 'SME Vision';
   public static final String VISION_BLUE_VIEW_VISION ='Vision - Blue View Vision';
   public static final String VISION_BLUE_VIEW_VISION_INSIGHT = 'Vision: Blue View Vision Insight';
   public static final String VISION_BLUE_VIEW_VISION_SELECT ='Vision: Blue View Vision Select';
   public static final String VISION_NASCO_VISION='Vision: NASCO Vision';
   
   // 27413 Added Constants for BLUE VIEW VISION INSIGHT SAFETY AND BLUE VIEW VISION SAFETY
   public static final String VISION_BLUE_VIEW_VISION_INSIGHT_SAFETY = 'Vision: Blue View Vision Insight Safety';
   public static final String VISION_BLUE_VIEW_VISION_SAFETY = 'Vision: Blue View Vision Safety';
   
   
   //675
   public static final String ANTHEM_FLEX_HOUR  = 'Anthem Flex Hour';
   public static final String SME_ANTHEM_FLEX_HOUR  = 'SME Anthem Flex Hour';
   public static final String Anthem_FlexHour_Medical = 'Anthem FlexHour Medical';
   public static final String Anthem_FlexHour_Dental_Plan = 'Anthem FlexHour Dental Plan';
   public static final String Anthem_FlexHour_Vision_Plan = 'Anthem FlexHour Vision Plan';
   public static final String Anthem_FlexHour_Term_Life_Plan =  'Anthem FlexHour Term Life Plan';
   public static final String Anthem_FlexHour_STD_Plan =    'Anthem FlexHour STD Plan';
   public static final String Anthem_FlexHour_Supplemental =    'Anthem FlexHour Supplemental';
   
  //US653
  //public static final String DECARE = 'DeCare';
  public static final String SME_DECARE = 'SME DeCare';
  public static final String DENTALCOMPLETE ='Dental: Dental Complete (DeCare)';
  public static final String DENTALPRIME ='Dental: Dental Prime (DeCare)';
  
  //US1123
  Public static final String SUBROGATION = 'Subrogation';
  Public static final String SME_SUBROGATION = 'SME Subrogation';
  
  //US669
  Public static final String CLAIMS_RETRO   = 'Claims Retro';
  Public static final String SME_CLAIMS_RETRO   = 'SME Claims Retro';
  
   //650- UM Intake 
   public static final String SME_UM_INTAKE    = 'SME UM Intake';
    
  //US676
  public static final String JAANTS = 'JAA/NTS';
  public static final String SME_JAANTS = 'SME JAA/NTS';
  //US644
  public static final String NETWORK_MANAGEMENT = 'Network Management';
  public static final String SME_NETWORK_MANAGEMENT = 'SME Network Management';
  
  //US 632
  public static final String BLUE_EXCHANGE  = 'Blue Exchange (BX)'; 
  public static final String SME_BLUE_EXCHANGE  = 'SME Blue Exchange (BX)';

   //6063
   //public static final String ANTHEM_FLEX_HOUR              = 'Anthem Flex Hour';
   public static final String BENIFIT_BOOKLETS              = 'Contracts';//'Benefit Booklets/Contracts';  //PRDCRM-42480
  //public static final String BLUE_EXCHANGE                 = 'Blue Exchange (BX)';
   public static final String CLAIMS                        = 'Claims';
  //public static final String CLAIMS_RETRO                  = 'Claims Retro';
   public static final String DECARE                        = 'DeCare';
   public static final String JAA_NTS                       = 'JAA/NTS';
   public static final String MEDICAL_NASCO_RETRO           = 'Medical Benefits - NASCO Retro';
   //Public static final String NETWORK_MANAGEMENT            = 'Network Management';
  //Public static final String SERVICE_OPERATIONS_RETRO      = 'Service Operations Retro';
  // Public static final String SUBROGATION                   = 'Subrogation';
   Public static final String UM_INTAKE                     = 'UM Intake';
  // Public static final String UNDERWRITING                  = 'Underwriting';
  // Public static final String VIRTUAL_SECOND_OPINION        = 'Virtual Second Opinion';
  // Public static final String VISION                        = 'Vision';
   Public static final String REASON_COUNT                  = 'reasoncount';
   Public static final String ADDRETURN                     =  'AddIntakeReasons'; 
   Public static final String ADDINRETURN                   =  'AddIntakeReturn';  
   Public static final String IMPREASONS                   = 'ImpReasons';          
  public static final String PROFILE_NATNLSALES = 'National Sales';
  public static final String PROFILE_LOCALSALES = 'Local Sales';
  public static final String QLI ='QLI';
  public static final String FUNDING ='Funding';
  public static final String FINANCING ='Financing';
  public static final String QLITPRODNAME ='QuoteLineItemProductName';
  public static final String QLITID = 'QuoteLineItemId';
  public static final String ASO= 'ASO';
  public static final String FI= 'FI';
  public static final String JAAT= 'JAA (Jointly Administered Arrangement)';
  
  //661
   public static final String REQUEST_BENEFITS          = 'RequestIncludeBenefitChanges';
   public static final String SME_MEDICAL_NASCO_RETRO   = 'SME Medical Benefits - NASCO Retro';
  
  //US 9403

  public static final String PRODUCTFAMILY = 'THTY';
   //US9330
  public static final String THTY = 'Total Health Total You';
  public static final String SME_THTY = 'SME Total Health Total You';
  public static final String THTYTIER1 = 'Total Health Total You - Tier 1';
  public static final String THTYTIER2 = 'Total Health Total You - Tier 2';
  public static final String Issue_Control = 'Issue Control';
  
  public static final String ap25_Email_Controller = 'AP25_Email_Controller'; 
  public static final String triggerName1 = 'Test Name1'; 
  public static final String getCurrUser1 = 'getCurrUser';
  public static final String getLstQLI1 = 'getLstQLI';
  public static final String triggerName2 = 'Test Name2';  
  public static final String getAEDetails1 = 'getAEDetails';
  public static final String triggerName3 = 'Test Name3'; 
  public static final String getAMDetails1 = 'getAMDetails';
  public static final String triggerName4 = 'Test Name4'; 
    
  //US 16616
  public static final String UNDERWRITING_MEDICAL = 'Underwriting Medical'; 
  public static final String UNDERWRITING_LIFE = 'Underwriting Life and Disability'; 
  public static final String UNDERWRITING_DENTAL = 'Underwriting Dental'; 
  public static final String UNDERWRITING_VISION = 'Underwriting Vision'; 
  
  //US 30730 - Related to SFDC_Volunteer_Event__c(Open Enrollment) object
   public static final Id Contact_RecordType_ID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
   public static final Id Account_Recordtype_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
   public static final string Meeting_Type = 'Benefit Fair';
   public static final string Dress_Code_for_Event   = 'Business Casual';
   public static final string Plan_Type = 'ANC - LTD';
  
  //US 45153-Related to SBC_SOB_Request__c(Custom SBC/SOB Request) object
   public static final string Igap_Sold_Stage = 'IGAP Sold';
   public static final string Renewed_Stage = 'Renewed';
   public static final string Sold_Stage = 'Sold';
   public static final string In_Progress_Stage = 'In Progress'; 
   public static final string Igap_In_Progress_Stage = 'IGAP In Progress';
   public static final string Jeopardy_Stage = 'Jeopardy';
   public static final string Api_User = 'API User';
   public static final string System_Admin = 'System Admin';
   public static final string System_Administrator = 'System Administrator';
    
   
  public static final Set<String>  HEALTHEQUITY_PRODUCTS  = new Set<String>{BENIFITS_ADMINCOBRA,BENIFITS_ADMINFSA,BENIFITS_ADMINDEPCARESPENDACCT,BENIFITS_ADMINDIRECTBILL,BENIFITS_ADMINTRANSIT};
  
  //The below list will have all the 47 departments.
  /*public static final Set<String>  autoengdepartment  = new Set<String>{
                                                        ACT_WISE_CDH,ACTWISEFSA,ANTHEM_HEALTH_GUIDE_DEPT,BOLD_VALUE,CCMU,COORDINATED_CARE_MODEL,DENTAL,DIT,
                                                        EAP,ENROLLBILL,GROUP_SERVICES,HEALTH_AND_WELLNESS,HEALTHEQUITY,ID_CARDS,
                                                        IHMM,IMPLEMENTATIONS,INTER_PLAN, IT,LIFE,LITES,LIVEHEALTH,MEDICAL_BENEFITS,MERCER,NCN,ONSITE_CLINIC, 
                                                        OTHER,PHARMACY,PRICING_CONFIGURATION_MANAGEMENT_PCM,SBC_DEPT,SERVICE_OPERATIONS,SPIDER,TELEHEALTH
                                                        }; */
   public static final Set<String>  autoengdepartment  = new Set<String>{
                                                        ACT_WISE_CDH,ACTWISEFSA,ANTHEM_FLEX_HOUR,ANTHEM_HEALTH_GUIDE_DEPT,BENIFIT_BOOKLETS,BLUE_EXCHANGE,
                                                        BOLD_VALUE,CCMU,CLAIMS,CLAIMS_RETRO,COORDINATED_CARE_MODEL,DECARE,DENTAL,DIT,EAP,ENROLLBILL,GROUP_SERVICES,
                                                        HEALTH_AND_WELLNESS,HEALTHEQUITY,ID_CARDS,IHMM,IMPLEMENTATIONS,INTER_PLAN, IT,JAA_NTS,LIFE,LITES,
                                                        MEDICAL_BENEFITS,MEDICAL_NASCO_RETRO,MERCER,NCN,NETWORK_MANAGEMENT,ONSITE_CLINIC,OTHER,PHARMACY,
                                                        PRICING_CONFIGURATION_MANAGEMENT_PCM,SBC_DEPT,SERVICE_OPERATIONS,SERVICE_OPERATIONS_RETRO,SPIDER,SUBROGATION, 
                                                        TELEHEALTH,THTY,UM_INTAKE,UNDERWRITING,VIRTUAL_SECOND_OPINION,VISION,DECARE,JAANTS
                                                        };
  
  //The below list will have all the Products(QLIs) to check as per the logic if the current QLI belongs to this list 
  // 27413 Added Products BLUE VIEW VISION INSIGHT SAFETY AND BLUE VIEW VISION SAFETY
  public static final Set<String>  listOfAllProducts  = new Set<String>{
                                                        ONSITE_CLINICS,DENTAL_NATIONALPPO,DENTAL_NET,
                                                        DENTAL_FLEX,DENTAL_TRADITIONAL,DENTAL_BLUE100,
                                                        DENTAL_BLUE200,DENTAL_BLUE300,DENTAL_COMPCARE,
                                                        DENTAL_NASCO,DENTAL_CONSUMER,DENTAL_NASCO,
                                                        DENTAL_CONSUMER,DENTAL_ESSENTIAL,BOLD_VAL,
                                                        LIFE_DEPEND,LIFE_GROUP,LIFE_VOLUNTARY,CRCTILL,ACCI,HOSPIND,
                                                        LIFE_TERM,LIFE_DEATH,LIVEHEALTH_ONLINE,IHM,       
                                                        BENIFITS_ADMINCOBRA,BENIFITS_ADMINFSA,
                                                        BENIFITS_ADMINDEPCARESPENDACCT,BENIFITS_ADMINDIRECTBILL,
                                                        BENIFITS_ADMINTRANSIT,MERCER,NCN_PRODUCT,
                                                        BENEFITSADMINFSA,BENEFITSADMINPARK,BENEFITSADMINTRAN,BENEFITSADMINCOMM,
                                                        CUSTOMER_CARE_MANAGEMENT,HEALTH_GUIDE_PRODUCT,
                                                        EAP_Basic_EAP,EAP_Customized_EAP,EAP_Enhanced_EAP,
                                                        PHARMACY_SERVICES_PRODUCT,TELEHEALTH_PRODUCT,THTYTIER1,THTYTIER2,
                                                        MEDICAL_ACTWISE_CDHP_HRA,MEDICAL_ACTWISE_CDHP_HSA,
                                                        PHARMACY_STANDARD,PHARMACY_SELECT,PHARMACY_COMPLETE,
                                                        PHARMACY_ALA_CART,PHARMACY_COMPLETE_FI,VIRTUAL_SECOND_OPINION,
                                                        VISION_BLUE_VIEW_VISION,VISION_BLUE_VIEW_VISION_INSIGHT,
                                                        VISION_BLUE_VIEW_VISION_SELECT,VISION_NASCO_VISION,DENTALCOMPLETE,DENTALPRIME,
                                                        VISION_BLUE_VIEW_VISION_INSIGHT_SAFETY,VISION_BLUE_VIEW_VISION_SAFETY
                                                        }; 
 
 //The below list will have all the 'Medical' Products/QLI to check if the current Product/QLI belongs to this list.
 public static final Set<String> listOfAllMedicalProducts = new Set<String>{
                                                        ANTHEM_FLEX,Well_Priority_POS,Medical_EPO,Medical_HMO,
                                                        Medical_HMO_Vivity,Medical_Indemnity,Medical_POS,
                                                        Medical_PPO,
                                                        MEDICAL_ACTWISE_CDHP_HRA,MEDICAL_ACTWISE_CDHP_HSA,
                                                        Medical_CDHP_HIA,Medical_CDHP_HRA,
                                                        Medical_CDHP_HSA,Well_Priority_CDHP_HIA,
                                                        Well_Priority_CDHP_HRA,Well_Priority_CDHP_HSA     
                                                         }; 
 
 //The below list will have all the 'Pharmacy' Products/QLI to check if the current Product/QLI belongs to this list.
 public static final Set<String> listOfSpecialtyPharmacyProducts = new Set<String>{
                                                        PHARMACY_STANDARD,PHARMACY_SELECT,PHARMACY_COMPLETE,
                                                        PHARMACY_ALA_CART,PHARMACY_COMPLETE_FI};                                                             
 
 
 public static final Set<String> listOfSMEHGIDepartments = new Set<String>{
                                                          SME_HEALTH_AND_WELLNESS,SME_GROUP_SERVICES,
                                                          SME_IMPLEMENTATIONS,SME_DIT}; 
 
 //The below list will have 'Lite department related Medical' Products/QLI to check if the current Product/QLI belongs to this list.
 public static final Set<String> liteRelatedMedicals   = new Set<String>{
                                                            Medical_CDHP_HIA,Medical_CDHP_HRA,
                                                            Medical_CDHP_HSA
                                                            }; 
 public static final Set<String> listOfAnthemFlexProducts = new Set<String>{
                                                           Anthem_FlexHour_Medical,Anthem_FlexHour_Dental_Plan,
                                                           Anthem_FlexHour_Vision_Plan,Anthem_FlexHour_Term_Life_Plan,
                                                           Anthem_FlexHour_STD_Plan,Anthem_FlexHour_Supplemental
                                                            };
 //Creating a Set of Dental related Products.
 public static final Set<String> listOfAllDentalProducts = new Set<String>{
                                                        DENTAL_NATIONALPPO,DENTAL_NET,
                                                        DENTAL_FLEX,DENTAL_TRADITIONAL,DENTAL_BLUE100,
                                                         DENTAL_BLUE200,DENTAL_BLUE300,DENTAL_COMPCARE,
                             DENTAL_NASCO,DENTAL_CONSUMER,DENTAL_ESSENTIAL
                                                         };                                                                                                                                                                                                            
 
 //The below list will have 'CCM department related Medical' Products/QLI to check if the current Product/QLI belongs to this list.
 public static final Set<String>  ccmRelatedProducts  = new Set<String>{IHM,MERCER,CUSTOMER_CARE_MANAGEMENT,THTYTIER2,THTYTIER1};
 public static final Set<String>  thtyRelatedproducts = new Set<String>{THTYTIER1,THTYTIER2};
 
/* public static final Set<String> availAltSetOpt = new Set<String>{
 '1G7 - CT Century Preferred Tiered','1G8 - CO Pathway','1G9 - IL BlueChoice Options','1GD - AZ Blue Preferred PPO I',
 '1GE - DC/MD/Northern VA BlueChoice','1GG - CA Select PPO','1GJ - NY Empire POS','1GM - MO POS Adv Net',
 '1GN - MO PPO Adv Net','1GO - GA POS Adv Net','1GP - WI Blue Preferred POS','1GQ - FL PPO Adv Net',
 '1GR - KC MO PPO','1GS - NJ PPO Adv Net','1GT – TN Network S PPO','1GU - GA EPO Adv Net',
'1GY - NH BlueChoice Open Access POS','3GB – CO WellChoice – C','3GC – CO WellChoice – H','3GD – CO WellChoice – U',
'3GE – MO Anthem Alliance' };*/

public static final Set<String> availAltSetOpt = new Set<String>{'1G7 - CT Century Preferred Tiered','1G8 - CO Pathway','1G9 - IL BlueChoice Options','1GT – TN Network S PPO' 
 ,'1GP - WI Blue Preferred POS','1G2 WI Blue Priority','3GB – CO WellChoice – C','3GC – CO WellChoice – H' 
 ,'3GD – CO WellChoice – U','1G0 – IN Anthem HealthSync','3GE – MO Anthem Alliance'};

 //Added by Rahul
     public static final String REVIEW_DONE_04 = '04 Pending ID Card Review - Done';
    public static final String PENDING_MAIL_DATE_04 = '04 Pending Mail Date';
    public static final String REJECTED_05 = '05 Rejected';
    public static final String APPROVED_04 = '04 Approved';
    public static final String APPROVED_ID_CARD_REVIEW_STATUS = 'Approved';
    public static final String PARTIAL_APPROVED_IDCARD_REVIEW_STATUS = 'Partial Approved';
    public static final String PENDING_CARD_REVIEW_04= '04 Pending Card Review';
    public static final String PENDING_CARD_NOT_STARTED_01= '01 Not Started';
    public static final String DECLINED_05= '05 Declined';
    public static final String WITHDRAWN_05 = '05 Withdrawn';
    public static final String CANCELLED = 'Cancelled';
    //Added by Sharath KN - VIKINGS
    public static final String DECLINED= 'Declined';
    public static final String OWNERTYPE = 'User';
    public static final String IMPLCASENUM = '{!IMPL-XXXXXL}';
    public static final String IMPLCASELINK = '{impRecordLink}';
    public static final String SMENUMBER = '{!record.number}';
    public static final String SMERECLINK = '{cRecordLink}';
    public static final String IMPLCASENUM1 = '{!IMPL-XXXX}';
    public static final String ACCNAME = '{!Account.Name}';
    
   //Open Enrollment
   public static final string MEETING_TYPE_OE = 'Conference';
   public static final String STAGE_INREVIEW = 'IN REVIEW';
   public static final String STAGE_INPROCESS = 'In Process';
   public static final String STAGE_COMPLETE='COMPLETE';
   public static final String STAGE_UPDATED_RUSH='Updated - Rush';
   public static final String STAGE_UPDATED='UPDATED';

   public static final String STATUS_SUBMITTED = 'SUBMITTED';
   public static final String STATUS_SUB_RUSH = 'Submitted - Rush';
   public static final String STATUS_COMPLETED_CANCELLED='COMPLETED-CANCELLED';
   public static final String STATUS_COMPLETED_FAC_SEC_AND_MEETING_FEED_REC='COMPLETED - FACILITATOR SECURED &MEETING FEEDBACK RECEIVED';
   public static final String STATUS_COMPLETED_FAC_SEC_AND_FEED_NOT_REC_WITHIN_14_DAYS='COMPLETED- FACILITATOR SECURED AND FEEDBACK NOT RECEIVED WITHIN 14 DAYS';
   public static final String STATUS_INPROCESS_FAC_SEC_AND_WAITING_ON_FEED='IN PROCESS - FACILITATOR SECURED AND WAITING ON FEEDBACK';
   public static final String STATUS_INPROCESS_FAC_BEING_RECR='IN PROCESS – FACILITATOR BEING RECRUITED'; 
   public static final String STATUS_NEW_REQUEST='NEW REQUEST'; 
   public static final String STATUS_COMPLETED_UNABLE_TO_SEC_FAC_AND_MAT_DELIVERED='COMPLETED - UNABLE TO SECURE FACILITATOR & MATERIALS DELIVERED'; 
   public static final String STATUS_INPROCESS_UNABLE_TO_SEC_FAC_ORDER_PLACED='IN PROCESS -UNABLE TO SECURE FACILITATOR - ORDER PLACED'; 
   public static final String STATUS_COMPLETED_FAC_SEC_AND_MAT_DEL_AND_MEET_FEED_REC='COMPLETED - FACILITATOR SECURED & MATERIALS DELIVERED & MEETING FEEDBACK RECEIVED'; 
   public static final String STATUS_COMPLETED_FAC_SEC_AND_MAT_DEL_AND_FEED_NOT_REC_WITHIN_14_DAYS='COMPLETED- FACILITATOR SECURED & MATERIALS DELIVERED & FEEDBACK NOT RECEIVED WITHIN 14 DAYS'; 
   public static final String STATUS_INPROCESS_FAC_SEC_AND_MAT_DEL_AND_WAIT_ON_FEED='IN PROCESS- FACILITATOR SECURED & MATERIALS DELIVERED & WAITING ON FEEDBACK'; 
   public static final String STATUS_INPROCESS_UNABLE_TO_SEC_FAC_ORDER_ON_STANDBY='IN PROCESS - UNABLE TO SECURE FACILITATOR - ORDER ON STANDBY';
   public static final String STATUS_INPROCESS_FAC_SEC_AND_ORDER_PLACED_AND_WAIT_ON_FEED='IN PROCESS - FACILITATOR SECURED & ORDER PLACED & WAITING ON FEEDBACK'; 
   public static final String STATUS_COMPLETED_UNABLE_TO_SEC_FAC='COMPLETED - UNABLE TO SECURE FACILITATOR'; 
   public static final String STATUS_INPROCESS_FAC_BEING_RECR_AND_ORDER_ON_STANDBY='IN PROCESS – FACILITATOR BEING RECRUITED & ORDER on STANDBY'; 
   public static final String STATUS_INPROCESS_FAC_BEING_RECR_AND_MAT_DELIVERED='IN PROCESS -FACILITATOR BEING RECRUITED & MATERIALS DELIVERED'; 
   public static final String STATUS_INPROCESS_FAC_BEING_RECR_AND_ORDER_PLACED='IN PROCESS -FACILITATOR BEING RECRUITED & ORDER PLACED'; 
   public static final String STATUS_INPROCESS_FAC_SEC_AND_WAIT_ON_FEED_AND_ORDER_ON_STANDBY='IN PROCESS -FACILITATOR SECURED & WAITING ON FEEDBACK & ORDER ON STANDBY'; 
   public static final String STATUS_INPROCESS_ORDER_ON_STANDBY='IN PROCESS – ORDER ON STANDBY'; 
   public static final String STATUS_COMPLETED_MAT_DELIVERED='COMPLETED - MATERIALS DELIVERED'; 
   public static final String STATUS_INPROCESS_ORDER_PLACED='IN PROCESS- ORDER PLACED'; 
   
   public static final String NO_PROMO_OR_COLLATERAL_NEEDED ='No Promo or Collateral Needed';
   public static final String PROMO_ONLY_NEEDED='Promo only needed';
   public static final String COLLATERAL_ONLY_NEEDED='Collateral only needed';
   public static final String PROMO_AND_COLLATERAL_NEEDED='Promo and Collateral Needed';
   public static final String REC_OF_FACILITATOR_NEEDED_YES='Yes';
   public static final String REC_OF_FACILITATOR_NEEDED_NO='No';
   
   public static final String GRS ='%'+'Group Retiree Solutions'+'%'; 
   public static final String VOLUNTARYSPECIALTY =  '%'+'Voluntary Specialty'+'%';
   public static final String VIRTUALWEBINAR = '%'+'Virtual (Webinar)'+'%';

   
}