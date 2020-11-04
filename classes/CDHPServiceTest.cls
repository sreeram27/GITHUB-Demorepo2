//Ranjit
@isTest
public class CDHPServiceTest {
    @testSetup
    static void setupTestData() {      
        // Create the custom settings data
        /*CS001_RecordTypeBusinessTrack__c csData = new CS001_RecordTypeBusinessTrack__c();
csData.Name = 'Account_Large Group/National Account';
csData.BusinessTrackName__c = 'LGANA';
insert csData;*/
        //fetch the record type
        List<RecordType> lstRcdType = [Select Id From RecordType Where Name =: 'Standard Account' Limit 1];
        
        Account acc = new Account(Name = 'Test Account', RecordTypeId = lstRcdType[0].Id);
        Insert acc;      
    }
   /* 
    static testMethod void testMethod1(){
        Test.startTest();
        //String s = CDHPService.doPost('{"ORGName":"COM2"}');
        //String s = CDHPService.doPost('"CDHPFields":{"CDHP_Questionnaire_Name":"CDHP-001924","StatusDetails":["CDHPParentId":"006S000000CuA7CIAV", "QuoteId":"0Q0S0000000IbuwKAC", "Status:Alegeus Completed", "StatusMessage":"Alegeus Completed"]}');
        String s = CDHPService.doPost('[{"StatusDetails":{"StatusMessage":"CDHPTest2","Status":"CDHPTest1","QuoteId":"0Q0S0000000IbuwKAC","CDHPParentId":"006S000000CuA7CIAV"},"oppDetails":null,"grpDetails":null,"docSignDetails":null,"CDHP_Questionnaire_Name":"CDHPTest"}]');
        Test.stopTest();        
    }*/
    //*************** testMethod1 *********************//
    static testMethod void testMethod1() {
        List<RecordType> lstRcdType = [Select Id From RecordType Where Name =: 'Prospect' Limit 1];
        Account acc = new Account(Name = 'Test Account', RecordTypeId = lstRcdType[0].Id);
        Insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opp', AccountId = acc.id, StageName = 'Prospecting', CloseDate = system.today().toStartOfMonth());
        insert opp;
        Quote q=new quote(Name='Test', OpportunityId = opp.Id);
        insert q;
        
        opp.Name = 'Test Opp2';
        update opp;
        
        CDHPService.CDHPFields  cdhpFields = new CDHPService.CDHPFields();
        CDHPService.StatusDetails cdhpStatusDetails = new CDHPService.StatusDetails ();
        CDHPService.OpportunityDetails cdhpOpportunityDetails = new CDHPService.OpportunityDetails();
        CDHPService.GroupDetails cdhpGroupDetails = new CDHPService.GroupDetails();
        CDHPService.DocuSignDetails cdhpDocuSignDetails = new CDHPService.DocuSignDetails();
        CDHPService.CDHParDetails cdhpCDHParDetails = new CDHPService.CDHParDetails();
        CDHPService.CDHPCommuterAccount cdhpCDHPCommuterAccount = new CDHPService.CDHPCommuterAccount();
        CDHPService.CDHPHSAAccount cdhpCDHPHSAAccount = new CDHPService.CDHPHSAAccount();
        CDHPService.CDHPFSAAccount cdhpCDHPFSAAccount = new CDHPService.CDHPFSAAccount();
        CDHPService.CDHPHRARepeatingAccount cdhpCDHPHRARepeatingAccount = new CDHPService.CDHPHRARepeatingAccount();
        
        //cdhpStatusDetails.QuoteId = '0Q0S0000000IbuwKAC';
        cdhpStatusDetails.QuoteId = q.id;
        cdhpStatusDetails.CDHPParentId = '006S000000CuA7CIAV';
        cdhpStatusDetails.Status = 'CDHPTest1';
        cdhpStatusDetails.StatusMessage = 'CDHPTest2';
        
        cdhpOpportunityDetails.GroupNumber = 'grp1';
        cdhpOpportunityDetails.OpportunityOwner = 'Avinash';
        cdhpOpportunityDetails.OptyEffectiveDate = System.today();
        cdhpOpportunityDetails.OptyName = 'TestOpp';
        cdhpOpportunityDetails.OptyRecordType = 'test';
        //cdhpOpportunityDetails.SFORGOpportunityId = '006S000000CuA7CIAV';
        cdhpOpportunityDetails.SFORGOpportunityId = opp.id;
        cdhpOpportunityDetails.StageName = 'Prospecting';
        
        cdhpGroupDetails.EmployerIdCaseNumber = '12345';
        cdhpGroupDetails.EmployerName = 'Avinash';
        
        cdhpDocuSignDetails.CDHP_Questionnaire_Name_Status = 'Test';
        cdhpDocuSignDetails.DocuSignCreatedBy = 'Avi';
        cdhpDocuSignDetails.dsfs_Case = 'TestCase';
        cdhpDocuSignDetails.dsfs_Company = 'TestCompany';
        cdhpDocuSignDetails.dsfs_Envelope_Name = 'Avinash';
        cdhpDocuSignDetails.dsfs_Envelope_Status = 'Test';
        cdhpDocuSignDetails.dsfs_Opportunity = 'TestOpp';
        cdhpDocuSignDetails.dsfs_Sent_Age = 12;
        cdhpDocuSignDetails.dsfs_Sent_Date_Time = System.today();
        cdhpDocuSignDetails.OpportunityName = 'TestOpportunity';
        
        cdhpCDHParDetails.EmployerName = 'Test';
        cdhpCDHParDetails.TaxId = 'TestId';
        cdhpCDHParDetails.EmployerIdCaseNumber = 'Test';
        cdhpCDHParDetails.Effective_Date = System.today()+5;
        cdhpCDHParDetails.NumberOfEligibleEmpl = 20;
        cdhpCDHParDetails.EstimatedNumberOfParticipanets = 30;
        cdhpCDHParDetails.Employer_Contact_Name_1 ='Chandra';
        cdhpCDHParDetails.Employer_Contact_Phone_1='1234567890';
        cdhpCDHParDetails.Employer_Contact_Email_1='test@mail.com';
        cdhpCDHParDetails.Broker_Consultant_Contact_Name = 'TestBroker';
        cdhpCDHParDetails.Broker_Consultant_Contact_Phone ='2541789630';
        cdhpCDHParDetails.Broker_Consultant_Contact_Email ='test1@mail.com';
        cdhpCDHParDetails.Brand ='TestBrand';
        cdhpCDHParDetails.Status ='Teststatus';
        cdhpCDHParDetails.HSA_Account_Type=True;
        cdhpCDHParDetails.FSA_Account_Type=True;
        cdhpCDHParDetails.Commuter_Account_Type =True;
        cdhpCDHParDetails.HRA_Account_Type = True;
        cdhpCDHParDetails.Member_Pay_HRA_with_Debit_Card = True;
        cdhpCDHParDetails.Prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay = True;
        cdhpCDHParDetails.Provider_Pay_Split_HRA = True;
        cdhpCDHParDetails.HRA_Provider_Pay = True;
        cdhpCDHParDetails.HRA_Rollover= True;
        
        
        cdhpCDHPCommuterAccount.Transit_Plan_Option = True;
        cdhpCDHPCommuterAccount.Parking_Plan_Option = True;
        cdhpCDHPCommuterAccount.SF_Quote_Item_Id ='TestId';
        
        cdhpCDHPHSAAccount.HSA_Custodian = 'TestCust';
        cdhpCDHPHSAAccount.Administrative_Fees_Responsibility = 'TestFee';
        cdhpCDHPHSAAccount.SF_Quote_Item_Id = 'TestId';
        
        cdhpCDHPFSAAccount.FSA_Plan_Start_Date = System.today();
        cdhpCDHPFSAAccount.FSA_Plan_End_Date = System.today()+2;
        cdhpCDHPFSAAccount.FSA_Section_213_d_Plan = false;
        cdhpCDHPFSAAccount.Limited_Purpose_FSA_Plan = True;
        cdhpCDHPFSAAccount.Dependent_Care_FSA_Plan = True;
        cdhpCDHPFSAAccount.SF_Quote_Item_Id ='TestId';
        
        
        cdhpCDHPHRARepeatingAccount.HRA_Plan_Start_Date = System.today();
        cdhpCDHPHRARepeatingAccount.HRA_Plan_End_Date = System.today()+2;
        cdhpCDHPHRARepeatingAccount.HRA1_Group_Suffix = 'Testsuf';
        cdhpCDHPHRARepeatingAccount.HRA_Ann_Roll_Cap_Amt_Emp = 123;
        cdhpCDHPHRARepeatingAccount.HRA_Ann_Roll_Cap_Amt_Emp_Adult = 12;
        cdhpCDHPHRARepeatingAccount.HRA_Ann_Roll_Cap_Amt_Emp_Child = 23;
        cdhpCDHPHRARepeatingAccount.HRA_Ann_Roll_Cap_Amt_Emp_Children = 14;
        cdhpCDHPHRARepeatingAccount.HRA_Ann_Roll_Cap_Amt_Family = 2;
        cdhpCDHPHRARepeatingAccount.HRA_Annual_Alloc_Amt_Emp_Adult = 5;
        cdhpCDHPHRARepeatingAccount.HRA_Annual_Alloc_Amt_Emp_Child = 6;
        cdhpCDHPHRARepeatingAccount.HRA_Annual_Alloc_Amt_Emp_Children = 5;
        cdhpCDHPHRARepeatingAccount.HRA_Annual_Alloc_Amt_Employee = 8;
        cdhpCDHPHRARepeatingAccount.HRA_Annual_Alloc_Amt_Family = 36;
        cdhpCDHPHRARepeatingAccount.HRA_Annual_Allocation_Tier_Selection = 'Test2tier';
        cdhpCDHPHRARepeatingAccount.HRA_Claim_Run_Out_Date = System.today();
        cdhpCDHPHRARepeatingAccount.HRA_Debit_Card_Dental_Services = True;
        cdhpCDHPHRARepeatingAccount.HRA_Debit_Card_Medical_Services = True;
        cdhpCDHPHRARepeatingAccount.HRA_Debit_Card_OTC_Services = True;
        cdhpCDHPHRARepeatingAccount.HRA_Debit_Card_Rx_Services = True;
        cdhpCDHPHRARepeatingAccount.HRA_Debit_Card_Vision_Services = True;
        cdhpCDHPHRARepeatingAccount.HRA_Embedded_Ded = True;
        cdhpCDHPHRARepeatingAccount.HRA_Employee_Funds_Rollover_Amounts = 'Testrollamt';
        cdhpCDHPHRARepeatingAccount.HRA_Employee_Funds_Rollover_Options = 'TestFunroll';
        cdhpCDHPHRARepeatingAccount.HRA_Fund_Allocation = 'Testfundall';
        cdhpCDHPHRARepeatingAccount.HRA_Funding_Pro_Rate = 'TestFunrate';
        cdhpCDHPHRARepeatingAccount.HRA_Health_Activities = 'TestActvty';
        cdhpCDHPHRARepeatingAccount.HRA_Health_Activities_Options = 'TestHealthactvty';
        cdhpCDHPHRARepeatingAccount.HRA_Individual_Embedded_Ded_Amt = 124;
        cdhpCDHPHRARepeatingAccount.HRA_Max_Rollover_Amt_Cap_Tier = 'Testmaxroll';
        cdhpCDHPHRARepeatingAccount.HRA_Member_Responsibility_by_Claim ='TestMemResp';
        cdhpCDHPHRARepeatingAccount.HRA_Min_Rollover_Amt = 25;
        cdhpCDHPHRARepeatingAccount.HRA_Prov_Pay_Med_w_Opt_Rx_Den_Vis_Deb_Cd = True;
        cdhpCDHPHRARepeatingAccount.HRA_ProvPay_Opt_DebCd_Dental_Option = True;
        cdhpCDHPHRARepeatingAccount.HRA_ProvPay_Opt_DebCd_INN_Med_Coins =True;
        cdhpCDHPHRARepeatingAccount.HRA_ProvPay_Opt_DebCd_INN_Med_Copay = True;
        cdhpCDHPHRARepeatingAccount.HRA_ProvPay_Opt_DebCd_INN_Med_Ded = True;
        cdhpCDHPHRARepeatingAccount.HRA_ProvPay_Opt_DebCd_Medical = True;
        cdhpCDHPHRARepeatingAccount.HRA_ProvPay_Opt_DebCd_ONN_Med_Coins = True;
        cdhpCDHPHRARepeatingAccount.HRA_ProvPay_Opt_DebCd_ONN_Med_Copay = True;
        cdhpCDHPHRARepeatingAccount.HRA_ProvPay_Opt_DebCd_ONN_Med_Ded = True;
        cdhpCDHPHRARepeatingAccount.HRA_ProvPay_Opt_DebCd_Rx_Option = True;
        cdhpCDHPHRARepeatingAccount.HRA_ProvPay_Opt_DebCd_Vision_Option = True;
        cdhpCDHPHRARepeatingAccount.HRA_Rollover = True;
        cdhpCDHPHRARepeatingAccount.HRA_Rollover_Date_recommend_3_months = System.today();
        cdhpCDHPHRARepeatingAccount.HRA_Rollover_Offer = 'TestRolloffer';
        cdhpCDHPHRARepeatingAccount.HRA_Termed_Emp_Claims_Run_out_Deadline = 'TestRollrunout';
        cdhpCDHPHRARepeatingAccount.HRA_Terminated_Employees_Other_Value = 'Testtemempl';
        cdhpCDHPHRARepeatingAccount.HRA_Unused_rollovrfund_diff_Adm_last_yr = 'Testunusedrolladm';
        cdhpCDHPHRARepeatingAccount.HRA_Upfront_Ded_Amt_Emp = 154;
        cdhpCDHPHRARepeatingAccount.HRA_Upfront_Ded_Amt_Emp_Adult =258;
        cdhpCDHPHRARepeatingAccount.HRA_Upfront_Ded_Amt_Emp_Child =54;
        cdhpCDHPHRARepeatingAccount.HRA_Upfront_Ded_Amt_Emp_Children = 541;
        cdhpCDHPHRARepeatingAccount.HRA_Upfront_Ded_Amt_Family = 44;
        cdhpCDHPHRARepeatingAccount.HRA_Upfront_Deductible_Tier_Selection = 'TestUpfront';
        cdhpCDHPHRARepeatingAccount.Legacy_Lumenos_HRA = 'TestLeglum';
        cdhpCDHPHRARepeatingAccount.Member_Pay_HRA_with_Debit_Card = True;
        cdhpCDHPHRARepeatingAccount.Offer_Rx_debit_Card = 'TestOfferdebcrd';
        cdhpCDHPHRARepeatingAccount.Provider_Pay_Split_HRA = True;
        cdhpCDHPHRARepeatingAccount.Quoted_Product_Name = 'TestQuoteProd';
        cdhpCDHPHRARepeatingAccount.Sequence = 'Testseq';
        cdhpCDHPHRARepeatingAccount.SF_Quote_Item_Id ='TestId';
            
             
        
        
        cdhpFields.StatusDetails = cdhpStatusDetails;
        cdhpFields.docSignDetails = cdhpDocuSignDetails;
        cdhpFields.oppDetails = cdhpOpportunityDetails;
        cdhpFields.grpDetails =cdhpGroupDetails;
        cdhpFields.CDHP_Questionnaire_Name = 'CDHPTest' ;
        List<CDHPService.CDHPFields> wr = new List<CDHPService.CDHPFields>();
        wr.add(cdhpFields);
        Test.startTest();
        //String s = CDHPService.doPost('{"Status":"TestStatus","StatusMessage":"TestStatusMessage","CDHPParentId":"TestCdhpParentId"}');
        //String s = CDHPService.doPost('[{"StatusDetails":{"StatusMessage":"CDHPTest2","Status":"CDHPTest1","QuoteId":"0Q0S0000000IbuwKAC","CDHPParentId":"006S000000CuA7CIAV"},"oppDetails":null,"grpDetails":null,"docSignDetails":null,"CDHP_Questionnaire_Name":"CDHPTest"}]');
        String s1 = System.JSON.serialize(wr, true);
        String s = CDHPService.doPost(s1);
        
        Test.stopTest();        
    }
}