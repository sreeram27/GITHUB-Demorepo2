//***************************************************//
// Created By : Suresh Parishwad
// Reason : To cover CDHP Button Functionality
// Name : ANA_OpportunityTrigger_Handler_Test
// Modified: 6/28/2019
// *************************************************//
@isTest
public class ANA_OpportunityTrigger_Handler_Test {
    static testMethod void testMethod1(){
        Test.setMock(HttpCalloutMock.class, new CDHPHttpCalloutMock()); 
        testDataFactoryCDHP.createAccount();
        testDataFactoryCDHP.createContact();
        testDataFactoryCDHP.createOpp();
        testDataFactoryCDHP.createQuote();
        testDataFactoryCDHP.createProducts();
        testDataFactoryCDHP.createQuoteLineItem();
        testDataFactoryCDHP.createSessionData();
        testDataFactoryCDHP.createHRA();
 
        
        testDataFactoryCDHP.lstOpp[0].StageName = 'Closed Won';
        update testDataFactoryCDHP.lstOpp[0];
        Test.startTest();
        //Calling TestMethod to return Quote List
        CDHP_ISG_Send_Opportunity CDHP_ISG = new CDHP_ISG_Send_Opportunity();
        
        String qId = testDataFactoryCDHP.returnCreateQuote();
        CDHP_ISG.sendOpportunityData(qId);//Calling sendOpportunityData function of CDHP_ISG_Send_Opportunity to cover the class
        
        String qId1 = testDataFactoryCDHP.returnCreateQuote1();
        CDHP_ISG.sendOpportunityData(qId1);//Calling sendOpportunityData function of CDHP_ISG_Send_Opportunity to cover the class
        
        String qId2 = testDataFactoryCDHP.returnCreateQuote2();
        CDHP_ISG.sendOpportunityData(qId2);//Calling sendOpportunityData function of CDHP_ISG_Send_Opportunity to cover the class
        
        try{
            Opportunity opp = new Opportunity(StageName = NULL);
            List<Opportunity> oppLst =new List<Opportunity>();
            oppLst.add(opp);
            Map<id,Opportunity> mapOp = new Map<id,Opportunity>();
            mapOp.put(null,null);
            ANA_OpportunityTrigger_Handler.beforeUpdateRecursive = false;
            ANA_OpportunityTrigger_Handler.beforeUpdate(oppLst,mapOp);
        }catch(Exception ex){
            System.debug('exception '+ex.getMessage() + ' ' +ex.getLineNumber());
        }
        
        testDataFactoryCDHP.lstHRA[0].Covered_Services__c='Out of Network Copays;Out of Network Medical Deductible';
        testDataFactoryCDHP.lstHRA[0].HRA_Upfront_Deductible__c='Yes';
        testDataFactoryCDHP.lstHRA[0].Medical__c='Provider Pay;Member Pay (Debit Card)';
        update testDataFactoryCDHP.lstHRA[0];
        testDataFactoryCDHP.lstOpp[0].StageName = 'Initiated';
        update testDataFactoryCDHP.lstOpp[0];
        
        testDataFactoryCDHP.lstOpp[0].StageName = 'Closed Won';
        update testDataFactoryCDHP.lstOpp[0];
        
        System.assertEquals([Select Id,CDHP_SF_Id_From_ISG__c from Quote where id =: qId1].CDHP_SF_Id_From_ISG__c, null);
        
        Test.stopTest();
        
    }
    static testMethod void testMethod3(){
        
        Test.setMock(HttpCalloutMock.class, new CDHPHttpCalloutMock()); 
        testDataFactoryCDHP.createAccount();
        testDataFactoryCDHP.createContact();
        testDataFactoryCDHP.createOpp();
        testDataFactoryCDHP.createQuote();
        testDataFactoryCDHP.createProducts();
        testDataFactoryCDHP.createQuoteLineItem();
        testDataFactoryCDHP.createSessionData();
        testDataFactoryCDHP.createHRA();
        Test.startTest();
        testDataFactoryCDHP.lstOpp[0].StageName = 'Closed Won';
        update testDataFactoryCDHP.lstOpp[0];
        
        testDataFactoryCDHP.lstHRA[0].Covered_Services__c='In Network Coinsurance;In Network Copays';
        testDataFactoryCDHP.lstHRA[0].HRA_Upfront_Deductible__c='No';
        testDataFactoryCDHP.lstHRA[0].HRA_Split_Percentage__c = 'Yes';
        testDataFactoryCDHP.lstHRA[0].Split_Percentage_Covered_Services__c = 'Auto Pay Medical;	In Network Medical Deductible';
        testDataFactoryCDHP.lstHRA[0].Medical__c='Provider Pay;Member Pay (Debit Card)';
        testDataFactoryCDHP.lstHRA[0].Type_of_HRA__c='Auto-Pay Provider Only';
        testDataFactoryCDHP.lstHRA[0].Rollover_Different_Admin__c='Yes';
        testDataFactoryCDHP.lstHRA[0].UpfrontDedEE__c=12.00;
        testDataFactoryCDHP.lstHRA[0].UpFrontDedEA__c=12.00;
        testDataFactoryCDHP.lstHRA[0].UpfrontDedEChild__c=12.00;
        testDataFactoryCDHP.lstHRA[0].UpFrontDedEEChildren__c=12.00;
        testDataFactoryCDHP.lstHRA[0].UpFrontDedFamily__c=12.00;
        testDataFactoryCDHP.lstHRA[0].Up_Front_Deductible_Tiers__c='2 Tier';
        testDataFactoryCDHP.lstHRA[0].HRA_Lites_Rollover__c='Yes';
        
        update testDataFactoryCDHP.lstHRA[0];
        testDataFactoryCDHP.lstOpp[0].StageName = 'Initiated';
        update testDataFactoryCDHP.lstOpp[0];
        
        testDataFactoryCDHP.lstOpp[0].StageName = 'Closed Won';
        update testDataFactoryCDHP.lstOpp[0];
        
        TriggerHelperUtility.clearStopTrigger();
        TriggerHelperUtility.shouldRunTrigger();
        TriggerHelperUtility.setStopTrigger();
        
        System.assertEquals([Select Id,CDHP_SF_Id_From_ISG__c from Opportunity where id =: testDataFactoryCDHP.lstOpp[0].Id].CDHP_SF_Id_From_ISG__c, null);
        
        Test.stopTest();
        
        
    }
    static testMethod void testMethod4(){
        ANA_OpportunityTrigger_Handler anaOpp = new ANA_OpportunityTrigger_Handler();
        testDataFactoryCDHP.createAccount();
        testDataFactoryCDHP.createContact();
        testDataFactoryCDHP.createOpp();
        List<Opportunity> newList;
        Map<Id,Opportunity> oldMap;
        
        try{
            
            CDHPIntegrationController cdIntCont = new CDHPIntegrationController();
            cdIntCont.GetAccountAddress(testDataFactoryCDHP.lstAcc[0].ID);
            
            
            System.assertEquals([Select Id,CDHP_SF_Id_From_ISG__c from Opportunity where id =: testDataFactoryCDHP.lstOpp[0].Id].CDHP_SF_Id_From_ISG__c, null);
        } 
        catch(Exception e){
            System.debug('exception '+e.getMessage());
        }
    }
    static testMethod void testMethod5(){
        ANA_OpportunityTrigger_Handler anaOpp = new ANA_OpportunityTrigger_Handler();
        
        Test.setMock(HttpCalloutMock.class, new CDHPHttpCalloutMock()); 
        testDataFactoryCDHP.createAccount();
        testDataFactoryCDHP.createContact();
        testDataFactoryCDHP.createOpp();
        testDataFactoryCDHP.createQuote();
        testDataFactoryCDHP.createProducts();
        testDataFactoryCDHP.createQuoteLineItem();
        testDataFactoryCDHP.createSessionData();
        testDataFactoryCDHP.createHRA();
        
        List<Opportunity> newList;
        Map<Id,Opportunity> oldMap;
        
        List<RecordType> lstRcdType = [Select Id From RecordType Where Name =: 'Renewal Local' Limit 1];
        
        testDataFactoryCDHP.lstOpp[0].StageName = 'Renewal Finalized';
        testDataFactoryCDHP.lstOpp[0].RecordTypeId = lstRcdType[0].Id;
        update testDataFactoryCDHP.lstOpp[0];
        
        //  ANA_OpportunityTrigger_Handler.afterUpdate(newList,oldMap);
        try{
            ANA_OpportunityTrigger_Handler.beforeUpdate(newList,oldMap);
            
            Map<Id,QuoteLineItem> newMap = new Map<Id,QuoteLineItem>();
			newMap.put(testDataFactoryCDHP.lstQLItem[0].id,testDataFactoryCDHP.lstQLItem[0]);
			ANA_QuoteLineItemTrigger_Handler.afterCreate(newMap);
            
            testDataFactoryCDHP.lstQLItem[0].Description = 'test';
            update testDataFactoryCDHP.lstQLItem[0];
            
            Delete testDataFactoryCDHP.lstQLItem[0];
            
            
            System.assertEquals([Select Id,CDHP_SF_Id_From_ISG__c from Opportunity where id =: testDataFactoryCDHP.lstOpp[0].Id].CDHP_SF_Id_From_ISG__c, null);
        } 
        catch(Exception e){
            System.debug('exception '+e.getMessage());
        }
        
    }
    static testMethod void testMethod2(){
        
        //List<RecordType> lstRcdType = [Select Id From RecordType Where Name =: 'Large Group/National Account' Limit 1];
        //Account acc = new Account(Name = 'Test Account', RecordTypeId = lstRcdType[0].Id);
        //Insert acc;
        //System.debug('in testMethod2');
        CDHPISGRestAPIClient.quoteDetails qt = new CDHPISGRestAPIClient.quoteDetails();
        
        CDHPISGRestAPIClient.GroupDetails cdhpGrp = new CDHPISGRestAPIClient.GroupDetails();
        cdhpGrp.EmployerName = 'EmployerName';
        //cdhpGrp.SFAccountId = acc.Id;
        cdhpGrp.TaxId = 'TaxId';
        cdhpGrp.EmployerIdCaseNumber = '1234';
        cdhpGrp.NumberOfEligibleEmpl = 1.0;
        cdhpGrp.EstimatedNumberOfParticipanets = 20;
        cdhpGrp.Brand = 'Anthem BlueCross';
        cdhpGrp.Sic = 'Sic';
        cdhpGrp.SicDesc = 'SicDesc';
        cdhpGrp.Type = 'Type';
        cdhpGrp.DUNSNumber = 'DUNSNumber';
        cdhpGrp.PhysicalStreet = 'PhysicalStreet';
        cdhpGrp.PhysicalCity = 'PhysicalCity';
        cdhpGrp.PhysicalState = 'AR';
        cdhpGrp.PhysicalZip = '00000';
        
        CDHPISGRestAPIClient.OpportunityDetails cdhpOppDet = new CDHPISGRestAPIClient.OpportunityDetails();
        cdhpOppDet.SFORGOpportunityId = 'TestGroupId';
        cdhpOppDet.OptyName = 'TestOpptyName';
        cdhpOppDet.GroupNumber = 'TestGroupNumber';
        cdHpOppDet.OptyEffectiveDate = System.today();
        cdhpOppDet.OptyRecordType = 'TestOpptyRTID';
        cdhpOppDet.StageName = 'TestStageName';
        cdhpOppDet.OpportunityOwner = 'TestOpptyOwner';
        
        
        List<CDHPISGRestAPIClient.ProductDetails> lstcdhpPrdtDetail = new List<CDHPISGRestAPIClient.ProductDetails>();
        CDHPISGRestAPIClient.ProductDetails cdhpPrdtDetail = new CDHPISGRestAPIClient.ProductDetails();
        cdhpPrdtDetail.AccountType = 'TestHSA';
        cdhpPrdtDetail.FSAPlan = 'TestPlan'; 
        cdhpPrdtDetail.SFORGQuoteId = 'TestQuoteId';
        cdhpPrdtDetail.SFORGQuoteLineId = 'TestQuoteLineId';
        cdhpPrdtDetail.ProdName = 'TestProdName';
        cdhpPrdtDetail.Limited_Purpose_FSA_Plan = True;
        cdhpPrdtDetail.Dependent_Care_FSA_Plan = True;
        cdhpPrdtDetail.Commuter_Account_Type = True; 
        cdhpPrdtDetail.Transit_Plan_Option = True;
        cdhpPrdtDetail.Parking_Plan_Option = True; 
        cdhpPrdtDetail.Member_Pay_HRA_with_Debit_Card = True;
        cdhpPrdtDetail.HRA_Auto_Pay_with_Rx_Debit_Card = True;
        cdhpPrdtDetail.Prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay = True;
        cdhpPrdtDetail.Provider_Pay_Split_HRA = True;
        cdhpPrdtDetail.HRA_Provider_Pay = True;
        cdhpPrdtDetail.HRA_Rollover = True;
        cdhpPrdtDetail.HSA_Custodian = 'PNC'; 
        cdhpPrdtDetail.HRA_Plan_Start_Date = System.today();
        cdhpPrdtDetail.HRA_Plan_End_Date = System.today() + 12;
        cdhpPrdtDetail.FSA_Plan_Start_Date = System.today() + 22; 
        cdhpPrdtDetail.FSA_Section_213_d_Plan = True; 
        cdhpPrdtDetail.Who_pays_bank_fee = 'TestWhoPay';
        cdhpPrdtDetail.FSA_Plan_End_Date = System.today() + 12; 
        cdhpPrdtDetail.CDHPBrand = 'TestCdhpBrand';
        cdhpPrdtDetail.HSA_Account_Type = True; 
        cdhpPrdtDetail.HRA_Account_Type = True; 
        cdhpPrdtDetail.FSA_Account_Type = True;
        lstcdhpPrdtDetail.add(cdhpPrdtDetail);
        
        List<CDHPISGRestAPIClient.ContactDetails> lstCdhpContDetail = new List<CDHPISGRestAPIClient.ContactDetails>();
        CDHPISGRestAPIClient.ContactDetails cdhpContDetail = new CDHPISGRestAPIClient.ContactDetails();
        cdhpContDetail.FirstName = 'TestContFirstName';
        cdhpContDetail.LastName = 'TestContLastName';
        cdhpContDetail.eMail = 'test@test.com';
        cdhpContDetail.Phone = '2221113232';
        cdhpContDetail.Title = 'TestTitle';
        cdhpContDetail.Type = 'Customer';
        cdhpContDetail.AgencyName = 'TestAgencyName';
        cdhpContDetail.BrokerState = 'CA';
        cdhpContDetail.IsPrimary = True;
        cdhpContDetail.IsActive = True;
        lstCdhpContDetail.add(cdhpContDetail);
        
        CDHPISGRestAPIClient.UserDetails cdhpUsrDetail = new CDHPISGRestAPIClient.UserDetails();
        cdhpUsrDetail.FirstName = 'TestUserFirstName';
        cdhpUsrDetail.LastName = 'TestUserLastName';
        cdhpUsrDetail.eMail = 'test@test.com';
        cdhpUsrDetail.Phone = '2121212121';
        cdhpUsrDetail.Title = 'TestTitle';
        cdhpUsrDetail.USDomainId = 'TestDomainId';
        cdhpUsrDetail.UserRole = 'Standard';
        
        CDHPISGRestAPIClient.AccountAddress accountAdd = new CDHPISGRestAPIClient.AccountAddress();
        accountAdd.BillingStreet = 'Test';
        accountAdd.BillingCity='Test';
        accountAdd.BillingState='Test';
        accountAdd.BillingPostalCode = '1651';
        accountAdd.BillingCountry = 'Test';
        
        CDHPISGRestAPIClient.CDHPFields cdhp =new CDHPISGRestAPIClient.CDHPFields();
        cdhp.AccountAddress = accountAdd;
        CDHPISGRestAPIClient.quoteDetails quotede= new CDHPISGRestAPIClient.quoteDetails();
        Map<String,CDHPISGRestAPIClient.CDHPFields> quotePrdHRA = new Map<String,CDHPISGRestAPIClient.CDHPFields>();
        quotePrdHRA.put('Test',cdhp);
        quotede.quoteProdHRA = quotePrdHRA;
        
        CDHPISGRestAPIClient.AccountAddress cdhpAccntAddr = new CDHPISGRestAPIClient.AccountAddress();
        cdhpAccntAddr.BillingStreet = 'TestBillingSt';
        cdhpAccntAddr.BillingCity = 'TestBillingCity';
        cdhpAccntAddr.BillingState = 'TEstBillingState';
        cdhpAccntAddr.BillingPostalCode = '00000';
        cdhpAccntAddr.BillingCountry = 'US';
        
        CDHPISGRestAPIClient.HRAProductDetails cdhpHRA = new CDHPISGRestAPIClient.HRAProductDetails();
        cdhpHRA.SFORGOpportunityId = 'test';
        cdhpHRA.HRA_Debit_Card_OTC_Services = true;
        cdhpHRA.HRA_Debit_Card_Rx_Services = true;
        cdhpHRA.HRA_Debit_Card_Vision_Services = true;
        cdhpHRA.HRA_Prov_Pay_Med_w_Opt_Rx_Den_Vis_Deb_Cd = true;
        cdhpHRA.HRA_ProvPay_Opt_DebCd_INN_Med_Coins = true;
        cdhpHRA.HRA_ProvPay_Opt_DebCd_INN_Med_Copay = true;
        cdhpHRA.HRA_ProvPay_Opt_DebCd_ONN_Med_Coins = true;
        cdhpHRA.HRA_ProvPay_Opt_DebCd_Rx_Option = true;
        cdhpHRA.HRA_Rollover = true;
        cdhpHRA.HRA_Terminated_Employees_Other_Value = 'abc';
        cdhpHRA.HRA_Upfront_Ded_Amt_Emp = 12.00;
        cdhpHRA.HRA_Upfront_Ded_Amt_Emp_Adult = 12.00;
        cdhpHRA.HRA_Upfront_Ded_Amt_Emp_Child = 12.00;
        cdhpHRA.HRA_Upfront_Ded_Amt_Emp_Children = 12.00;
        cdhpHRA.HRA_Upfront_Ded_Amt_Family = 12.00;
        cdhpHRA.Legacy_Lumenos_HRA = 'test';
        cdhpHRA.Member_Pay_HRA_with_Debit_Card = true;
        cdhpHRA.Quoted_Product_Name = 'test';
        cdhpHRA.Sequence = 'test';
        cdhpHRA.SF_Quote_Item_Id = 'test';
        cdhpHRA.HRA_Provider_Pay = true;
        cdhpHRA.HRA_Auto_Pay_with_Rx_Debit_Card = true;
        
         System.assertNotEquals(cdhpHRA, null);
        
    }
    static testMethod void myUnitTest(){
        
        List<RecordType> lstRcdType = [Select Id From RecordType Where Name =: 'Brokerage' Limit 1];
        Account acc = new Account(Cancel_Date__c = System.today().addDays(2),Name = 'Test Account', RecordTypeId = lstRcdType[0].Id);
        insert acc;
        
        Opportunity opp = new Opportunity(AccountId = acc.Id,Name = 'Test Opp', StageName = 'Initiated',CloseDate = System.today().toStartOfMonth());
		insert opp;
        map<String,String> cdhParentId = new map<String,String>();
        CDHPIntegrationController.UpdateOpportunityRecord(String.valueOf(opp.Id), cdhParentId, 'status', 'statusMessage');
        list<CDHPISGRestAPIClient.ContactDetails> CDHPConDetails = new list<CDHPISGRestAPIClient.ContactDetails>();
        CDHPIntegrationController ctrl = new CDHPIntegrationController();
        ctrl.GetAccountAddress('accountId');
        CDHPIntegrationController.canIRun();
        ctrl.GetGroupDetails(String.valueOf(123));
        ctrl.GetContactDetails(String.valueOf(123));
        ctrl.GetBrokerDetails(String.valueOf(123), CDHPConDetails);
    }
}