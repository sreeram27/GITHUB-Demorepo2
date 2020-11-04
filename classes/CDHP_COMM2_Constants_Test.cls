//*************************************//
// Class: CDHP_COMM2_Constants_Test
// **************************************//

@isTest
private class CDHP_COMM2_Constants_Test {

    @isTest
    static void myUnitTest(){
        Test.startTest();
        CDHP_COMM2_Constants cccObj = new CDHP_COMM2_Constants();
        String productCategory = CDHP_COMM2_Constants.PRODUCT_CATEGORY;
        String sold = CDHP_COMM2_Constants.SOLD;
        String renewed = CDHP_COMM2_Constants.RENEWED;
        String igateSold = CDHP_COMM2_Constants.IGAP_SOLD;
        String closedWon = CDHP_COMM2_Constants.CLOSED_WON;
        String renewalFinalized = CDHP_COMM2_Constants.RENEWAL_FINALIZED;
        String localImplementations = CDHP_COMM2_Constants.LOCAL_IMPLEMENTATIONS;
        String localImplementationsDual = CDHP_COMM2_Constants.LOCAL_IMPLEMENTATIONS_DUAL;
        String actWise = CDHP_COMM2_Constants.ACTWISE;
        
        
        //////////////////////////////////////////////// Added by Ellen Lipscomb for Notice of New Business (NONB) classes
    
    	String actWiseAddress = CDHP_COMM2_Constants.SF_ACTWISE_OWA;
    	String nonbEmailText = CDHP_COMM2_Constants.NONB_EMAIL_TEXT;
    	String attachmentPDF = CDHP_COMM2_Constants.NONB_ATTACHMENT;
    	String blobFakeContent = CDHP_COMM2_Constants.BLOB_FAKECONTENT;
    	String nonbEmailSubject = CDHP_COMM2_Constants.NONB_EMAILSUBJECT_NEW;
    	String nonbEmailSubjectUpdated = CDHP_COMM2_Constants.NONB_EMAILSUBJECT_UPDATED;
    	String send = CDHP_COMM2_Constants.SEND;
    	String resend = CDHP_COMM2_Constants.RESEND;
    	String inGroupChange = CDHP_COMM2_Constants.IN_GROUP_CHANGE;
    	String inGroupChangeLocal = CDHP_COMM2_Constants.IN_GROUP_CHANGE_LOCAL;
    	String inGroupAddProduct = CDHP_COMM2_Constants.IN_GROUP_ADD_PRODUCT;
    	String inGroupAddProductLocal = CDHP_COMM2_Constants.IN_GROUP_ADD_PRODUCT_LOCAL;
    	String newBusiness = CDHP_COMM2_Constants.NEW_BUSINESS;
    	String newBusinessLocal = CDHP_COMM2_Constants.NEW_BUSINESS_LOCAL;
    	String renewal = CDHP_COMM2_Constants.RENEWAL;
    	String renewalLocal = CDHP_COMM2_Constants.RENEWAL_LOCAL;
    	String nationalAccounts = CDHP_COMM2_Constants.NATIONAL_ACCOUNTS;
    	String localLargeGroup = CDHP_COMM2_Constants.LOCAL_LARGE_GROUP;
    	String stoploss = CDHP_COMM2_Constants.STOPLOSS;
    	String newBusinessText = CDHP_COMM2_Constants.NEW_BUS_ADD_TEXT;
    	String newBusinessRenewalText = CDHP_COMM2_Constants.NEW_BUS_ADD_TEXT_TO_RENEWAL;
    	String accountSalesRepAcctMgmt = CDHP_COMM2_Constants.ACCOUNT_SALES_REP_ACCT_MGMT;
    	String dependentCareFSA = CDHP_COMM2_Constants.DEPENDENT_CARE_FSA;
    	String fsaSection213D = CDHP_COMM2_Constants.FSA_SECTION_213D;
    	String limitedPurposeFSA = CDHP_COMM2_Constants.LIMITED_PURPOSE_FSA; 
   
        System.assertEquals(CDHP_COMM2_Constants.PRODUCT_CATEGORY, productCategory);
        System.assertEquals(CDHP_COMM2_Constants.SOLD, sold);
        System.assertEquals(CDHP_COMM2_Constants.RENEWED, renewed);
        System.assertEquals(CDHP_COMM2_Constants.IGAP_SOLD, igateSold);
        System.assertEquals(CDHP_COMM2_Constants.CLOSED_WON, closedWon);
        System.assertEquals(CDHP_COMM2_Constants.RENEWAL_FINALIZED, renewalFinalized);
        System.assertEquals(CDHP_COMM2_Constants.LOCAL_IMPLEMENTATIONS, localImplementations);
        System.assertEquals(CDHP_COMM2_Constants.LOCAL_IMPLEMENTATIONS_DUAL, localImplementationsDual);
        System.assertEquals(CDHP_COMM2_Constants.ACTWISE, actWise);
        
        //////////////////////////////////////////////// Added by Ellen Lipscomb for Notice of New Business (NONB) classes
    
    	System.assertEquals(CDHP_COMM2_Constants.SF_ACTWISE_OWA, actWiseAddress);
    	System.assertEquals(CDHP_COMM2_Constants.NONB_EMAIL_TEXT, nonbEmailText);
    	System.assertEquals(CDHP_COMM2_Constants.NONB_ATTACHMENT, attachmentPDF);
    	System.assertEquals(CDHP_COMM2_Constants.BLOB_FAKECONTENT, blobFakeContent);
    	System.assertEquals(CDHP_COMM2_Constants.NONB_EMAILSUBJECT_NEW, nonbEmailSubject);
    	System.assertEquals(CDHP_COMM2_Constants.NONB_EMAILSUBJECT_UPDATED, nonbEmailSubjectUpdated);
    	System.assertEquals(CDHP_COMM2_Constants.SEND, send);
    	System.assertEquals(CDHP_COMM2_Constants.RESEND, resend);
    	System.assertEquals(CDHP_COMM2_Constants.IN_GROUP_CHANGE, inGroupChange);
    	System.assertEquals(CDHP_COMM2_Constants.IN_GROUP_CHANGE_LOCAL, inGroupChangeLocal);
    	System.assertEquals(CDHP_COMM2_Constants.IN_GROUP_ADD_PRODUCT, inGroupAddProduct);
    	System.assertEquals(CDHP_COMM2_Constants.IN_GROUP_ADD_PRODUCT_LOCAL, inGroupAddProductLocal);
    	System.assertEquals(CDHP_COMM2_Constants.NEW_BUSINESS, newBusiness);
    	System.assertEquals(CDHP_COMM2_Constants.NEW_BUSINESS_LOCAL, newBusinessLocal);
    	System.assertEquals(CDHP_COMM2_Constants.RENEWAL, renewal);
    	System.assertEquals(CDHP_COMM2_Constants.RENEWAL_LOCAL, renewalLocal);
    	System.assertEquals(CDHP_COMM2_Constants.NATIONAL_ACCOUNTS, nationalAccounts);
    	System.assertEquals(CDHP_COMM2_Constants.LOCAL_LARGE_GROUP, localLargeGroup);
    	System.assertEquals(CDHP_COMM2_Constants.STOPLOSS, stoploss);
    	System.assertEquals(CDHP_COMM2_Constants.NEW_BUS_ADD_TEXT, newBusinessText);
    	System.assertEquals(CDHP_COMM2_Constants.NEW_BUS_ADD_TEXT_TO_RENEWAL, newBusinessRenewalText);
    	System.assertEquals(CDHP_COMM2_Constants.ACCOUNT_SALES_REP_ACCT_MGMT, accountSalesRepAcctMgmt);
    	System.assertEquals(CDHP_COMM2_Constants.DEPENDENT_CARE_FSA, dependentCareFSA);
    	System.assertEquals(CDHP_COMM2_Constants.FSA_SECTION_213D, fsaSection213D);
    	System.assertEquals(CDHP_COMM2_Constants.LIMITED_PURPOSE_FSA, limitedPurposeFSA); 
        
        
        
        Test.stopTest();
        
    }
}