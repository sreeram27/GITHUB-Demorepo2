/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
/*******************************************************************************************
@class Name  : ANA_VFC02_CustomNetworksApprlReq_Test
@created By  : IDC Offshore
@description : This test class is for ANA_VFC02_CustomNetworksApprlReq
********************************************************************************************/
@isTest
private class ANA_VFC02_CustomNetworksApprlReq_Test {
    private static final string CLAIMSYSTEM= 'CS90';
    private static final string NATIONALAMPROFILE='National Sales';
    

/*******************************************************************************************
@ method Name  : custNetworkApprovalCall
@ description : This method is used to cretae QLI object records from Util class
********************************************************************************************/
    static testMethod void custNetworkApprovalCall() {
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user1=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user1){
            // TO DO: implement unit test
            QuoteLineItem qli= createData();
            qli.RequestType__c = 'Narrow Network';
            qli.RFPorCriticalMeetingdaterequired__c = system.today();
            qli.IntegrationWith3rdPartyVendor__c ='Yes';
            qli.MarketsAffectedByRequest__c ='AL';
            qli.CompetitorStatus__c = 'Incumbent';
            qli.DoesAnthemcurrentlyworkwithvendor__c = 'Yes';
            qli.CustomSolutionBenefitToOtherAccts__c = 'Yes';
            qli.SolutionRequiresLocalInvolvement__c = 'Yes';
            qli.BackgroundFurtherExplanation__c = 'test';
            qli.RequiresITWorkToImplement__c ='Yes';
            qli.AlternativesDiscussedWithClient__c='Yes';
            qli.Funding__c='ASO';           
            qli.MedicalManagementPlatform__c='HRS/WMDS';
            qli.MembershipSplitBetweenAHGandNonAHG__c='No';
            qli.Members__c=52;
            qli.AdditionalDetails__c = 'Test'; //New Line
            qli.EstimatedCostIfRequestApproved__c = 100; //New Line
            qli.RequestTypeComment__c = 'Test Request Comment'; //New Line
            qli.ClinicalDeliveryModel__c='IHM'; 
            qli.ServiceTier__c='AHG';
            qli.RecordType__c='AIM';            
            Database.insert(qli);
            QuoteLineItemApproval__c qlia=ANA_UTIL01_TestMethods.createQuoteLineItemApproval(QLI.id,1)[0];
            
            Database.insert(qlia);       
            ANA_VFC02_CustomNetworksApprovalRequest.quotelineitembean cbean=beanassignment();
            ANA_VFC02_CustomNetworksApprovalRequest cn_AppRequest= new ANA_VFC02_CustomNetworksApprovalRequest();
            cn_AppRequest.qlitemappNewId = qlia.id;
            cn_AppRequest.qlitemapp = qlia.Id;
            cn_AppRequest.qlibean = cbean;
            cn_AppRequest.getBeanAssignment();
            system.assertEquals(cbean.Vendorname,cbean.DurationofGuarantee,'Success');      
        }  
    }

/*******************************************************************************************
@ method Name  : beanassignment
@ description : class bean assignmen
********************************************************************************************/
    static ANA_VFC02_CustomNetworksApprovalRequest.quotelineitembean beanassignment(){
        
        ANA_VFC02_CustomNetworksApprovalRequest.quotelineitembean cbean= new ANA_VFC02_CustomNetworksApprovalRequest.quotelineitembean();    
        cbean.ANASalesorAccountrep = 'test';
        cbean.GROUPNAME = 'test';
        cbean.RVP = 'test';
        cbean.RequestType = 'test';
        cbean.RequestTypeComment = 'test';
        cbean.RFPORCriticalMeetingdaterequired = system.today();
        cbean.DoesrequestincludeintegratingwiththirdpartyVendor = 'test';
        cbean.Marketsaffectedbyrequest = 'test';
        cbean.NewSalesorCurrentAccount = 'test';
        cbean.NumberofEmployees = 'test';
        cbean.NumberofMembers = 'test';
        cbean.HQState = 'test';
        cbean.Consultant = 'test';
        cbean.CompetitorStatus = 'test';
        cbean.ClaimSystem = 'test';
        cbean.RenewalofBaseExpenseCovered = 'test';
        cbean.RenewalofTotalExpenseCovered = 'test';
        cbean.DurationofGuarantee = 'test';
        cbean.CurrentYearofGuarantee = 'test';
        cbean.WillrequestrequireITWImpl = 'test';
        cbean.Estimateddlrcost2AnthemreqApp = 'test';
        cbean.Alternativesdiscussedwithclient = 'test';
        cbean.Vendorname = 'test';
        cbean.DoesAnthemcurrentlyworkwiththisvendor = 'test';
        cbean.WouldcustomslBenfOthANAaccounts = 'test';
        cbean.Willthissolreqlocalcontrteaminv = 'test';
        cbean.Plzdescribeanyadddetbackghistory = 'test';
        return cbean;
    }
    
/*******************************************************************************************
@ method Name  : createData
@ description : This method is used to perform DML operations on object records
********************************************************************************************/
    static QuoteLineItem createData()
    {
        Account acc=ANA_UTIL01_TestMethods.createAccount(false);
        acc.HQ_State__c = 'CA';
        acc.Eligible_Employees__c = 100; //New Line
        acc.Total_Employees__c = 100; //New Line
        Database.insert(acc);
        Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
        oppty.closedate = Date.newInstance(system.today().year()+1, 1, 1 );//system.today().adddays(10);
        Database.insert(oppty);
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        grp.ClaimSystem__c=CLAIMSYSTEM;
        Database.insert(grp);
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,oppty.Id);
        qte.GroupNumber__c=grp.id;
        Database.insert(qte);
        Product2 prod=ANA_UTIL01_TestMethods.createProduct(false);
        Database.insert(prod);
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
        Database.insert(pbe);
        QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.Id, pbe.id);
        return qli;
    }
}