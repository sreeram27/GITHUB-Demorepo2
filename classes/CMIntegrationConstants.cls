/*
@Author : Anthem Dev team
@name : CMIntegrationConstants
@CreateDate : 12-18-2019
@Description : This class contains constants which are used for CM integration
*/
public class CMIntegrationConstants {
    public static final String TRANSACTION_TYPE_PREVIEW = 'Preview';
    public static final String TRANSACTION_TYPE_ADDUPDATE = 'AddUpdate';
    public static final String EVENT_TYPE_ADD = 'addCustomer';
    public static final String EVENT_TYPE_MAINTENANCE = 'Maintenance';
    public static final String EVENT_TYPE_CREATEEXTID = 'createExtID';
    public static final String EVENT_TYPE_IDCARDREQUEST = 'IDCardrequest';
    public static final String IDCARD_TYPE_CASE = 'case';
    public static final String IDCARD_TYPE_SUFFIX = 'suffix';
    public static final String IDCARD_TYPE_ACCOUNT = 'account';    
    
    public static final String SOURCE_SYSTEM_SFDCCOM2 = 'SFDCCOM2';
    public static final String SOURCE_SYSTEM_WGS = 'WGS';
    public static final String SOURCE_SYSTEM_CM = 'CM';
    public static final String ID_NAME_ACCOUNTID = 'accountID';
    public static final String ID_NAME_CASEID = 'caseID';
    public static final String ID_NAME_SCHEMEID = 'scheme';
    public static final String ID_NAME_GLOBALCUSTOMERID = 'globalCustomerId';
    
    public static final String ENTITY_CUST = 'Customer';
    public static final String ENTITY_PARENTCUST = 'ParentCustomer';
    public static final String ADD_PRODCT_MAINT = 'Add new Product (Medical/Specialty only)';
    public static final String RATE_ADJ_MAINT ='Rate adjustment due to internal error';
    
    public static final String CLAIM_SYSTEM_WGS= 'WGS 2.0';
    public static final String CLAIM_SYSTEM_COMPASS= 'COMPASS';
    public static final String LOG_PROCESS_NAME = 'CM Integration Request';
    public static final String LOG_GROUPREQ_NAME = 'CM Group Number request';
    public static final String LOG_STATUS_SUCCESS = 'SUCCESS';
    public static final String LOG_STATUS_ERROR = 'ERROR';
    
    public static final String IMPLEMENTATION_TYPE_CHANGE = 'Change Request Off Cycle';
    public static final String IMPLEMENTATION_TYPE_NEW = 'New Business';
    
    public static final String ADDRESS_USETYPE_PHYSICAL = 'Physical';
    public static final String ADDRESS_USETYPE_MAILING = 'Mailing';
    
    public static final String RELATIONSHIPTYPE_GROUP_ADMIN = 'Group Administrator';
	public static final String ACCOUNT_STATUS_ACTIVE = 'Active';
    
    public static final String TEAMMEMBER_ROLE_ACCOUNT_MANAGER = 'Account Manager';
    public static final String TEAMMEMBER_ROLE_ACCOUNT_EXECUTIVE = 'Account Executive';
    public static final String TEAMMEMBER_ROLE_ACCOUNT_SERVICE_REPRESENTIVE = 'Account Service Representative';
    public static final String TEAMMEMBER_ROLE_SPECIALTY_SALES_ACCOUNT_REP = 'Specialty Sales Account Rep';
    public static final String TEAMMEMBER_ROLE_UNDERWRITER = 'Underwriter';
    
    public static final String INTEGRATION_NAME = 'CM Integration';
    public static final String FIELD_PRODCTTYPE = 'Product Type';
    public static final String FUNCTIONAL_ERROR = 'Functional';
    public static final String TECHNICAL_ERROR = 'Technical';
    
    public static final Set<String> PRODUCT_STAGES = new Set<String>{'IGAP In Progress', 'IGAP Sold', 'In Progress', 'Jeopardy', 'Renewed', 'Sold'};
}