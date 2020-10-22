/**
@Author : Accenture Offshore Dev team
@name : LGA_UTIL_Constants
@CreateDate :04-09-2019
@Description : This class contains the Constant variables which will be used in the actual classes for Large Groups
*/

public with sharing class LGA_UTIL_Constants {
    
    /* ################################################################
       ################    IMPACTED QLIS to be shown in LOAD Group Omniscript  for impacted product step ###################
       ################################################################ */

    public static final String FETCH_QLIS_BASED_ON_TYPE = 'fetchQLIsBasedOnType';
    public static final String REPLACE_PROD_NAME = 'ReplacePercentBlank';
    public static final String QUOTE_ID = 'quoteId';
    public static final String IMPACTED_PRODUCT_IDS = 'impactedProductIds';
    public static final String MEDICAL_PLAN_NAME = 'MedicalPlanQLI';
    public static final String MEDICAL_PRODUCT_NAME = 'MedicalProductQLI';
    public static final String VISION_PLAN_NAME = 'VisionQLI';
    public static final String DENTAL_PLAN_NAME = 'DentalQLI';
    public static final String FSA_PLAN_NAME = 'FSAQLI';
    public static final String EAP_PLAN_NAME = 'EAPQLI';
    public static final String LD_PLAN_NAME = 'LifeDisabilityQLI';
    public static final String PERCENT = '%';
    public static final String BLANK_WITH_PERCENT = '% %';
    public static final String PERCENT_REPLACER = '%ProductWithPercent%';
    public static final String BLANK_STRING = '';
    public static final String COMMA = ',';
    
    public static final String MEDICAL = 'Medical';
    public static final String LIFE = 'Life';
    public static final String DISABILITY = 'Disability';   
    public static final String LIFE_AND_DISABILITY = 'LifeAndDisability'; 
    public static final String DENTAL = 'Dental';
    public static final String VISION = 'Vision';
    public static final String FSA = 'FSA';
    public static final String EAP = 'EAP';
    
    public static final String LOAD_GROUP_IMPACTED_PRODUCTS = 'ImpactedProducts';


    /* ################################################################
       ################    JSON node names to be shown in LOAD Group Product Type & Coverage Info Steps
        ################   of LOAD GROUP Omniscript   ###################
       ################################################################ */

    public static final String PRODUCT_CONTRACT_CODE = 'ProductContractCode';
    public static final String PREFIX = 'Prefix';
    public static final String PARENT_QLI = 'ParentQuoteLineItem';
    public static final String BENEFIT_PERIOD = 'BenefitPeriod';
    public static final String ADD_REASON_CODE = 'AddReasonCode';
    public static final String CLAIMS_ROUTE_CODE = 'ClaimsRouteCode';
    public static final String PRODUCT_NAME = 'ProductName';
    public static final String PARENT_QLI_PRODUCT_NAME = 'parentQLIProdName';
    public static final String HSA_BANKING_PARTNER = 'HSABankingPartner';


    /****** Account Structure Questionaire Constants - create Group Plan Designs (PRDCRM-43568) and 
               Employee categoty selection retrieval and Post Back (PRDCRM-43938) ********/

    public static final string CREATE_GROUP_PLAN_REMOTE_METHOD_NAME = 'createGroupPlan';
    public static final string  CREATE_GROUP_PLAN_OPTIONS_ATTR_IMPLCASE = 'implCaseId';
    public static final string ACCOUNTSTRUCTUREINT_METHODNAME = 'accountStructureInt';
    public static final string ACCOUNTSTRUCTUREINT_IMPLCASE = 'implCaseId';
    
    public static final string LOADGROUP_INT_METHODNAME = 'loadGroupInt';
    public static final string LOADGROUP_INT_IMPLCASE = 'implCaseId';
    
    public static final string DELETE_EMP_CLASS_METHODNAME = 'deleteEmployeeClasses';
    public static final string DELETED_EMPLOYEE_CLASS = 'recordId';

    public static final string FETCH_EMP_CATEGORY_OPTIONS = 'fetchEmpCategoryOptions';
    public static final string FETCH_BILLING_OPTIONS = 'fetchBillingArrangement';
    public static final string SELECTED_EMP_CATEGORY = 'SelectedEmpCategory';
    public static final string SELECTED_BILLING = 'SelectedBilling';
    public static final string CREATE_GROUP_PLAN_REMOTE_EMPLOYEE_CLASS = 'Gpdemployeecreation';

    public static final string EMP_CATEGORY_NODE_NAME = 'EmployeeCategories';
    public static final string BILLING_NODE_NAME = 'BillingArrangement';
    
    public static final string FETCH_QLI_DEMOSTIC_PARTNER_NEW_HIRE = 'fetchQLIDemosticParnerNewHireValues';
    public static final string DOMESTIC_PARTNER_VALS = 'DomesticPartnerValues';
    public static final string NEW_HIRE_PROB_VALS = 'NewHireProbValues';
    
    public static final string NONE_PICKLIST_LABEL = '--None--';
    
    public static final string ATTACH_BILLING_INVOICE_ACCTSTRUC = 'attachInvoiceBillingArrangToActiveGPDs';
    public static final string ACCOUNT_LEGAL_NAME_ID = 'selectedAccountId';
    public static final string SELECTED_GROUP_ID = 'selectedGroupId';
    public static final string SELECTED_BILLING_ARRANGEMENT_NODE = 'selectedBillingOption';
    public static final string SELECTED_BILLING_OPTION_SINGLE_INVOICE_ALL = 'Single Invoice (containing all Suffixes)';
    
    public static final string BILLING_PATTERN_SELECTED = 'NoBillingPatternSelected';
    
    // PRDCRM2-1254
    public static final String UPDATE_EMP_CATEGORY_DEL_GPDS = 'updateEmpCategoryDelGPds'; 
    public static final String PRESELCTED_EMP_CATEGORY = 'PreSelectedEmpCategory';
    public static final String ACCOUNT_ID = 'AccountId';
    public static final String GROUP_ID = 'GroupID';
    
    // PRDCRM2-1090
    
    public static final string SELECTED_BILLING_OPTION_PER_EMP_CLASS = 'One Invoice per Employee Class';
    

    
}