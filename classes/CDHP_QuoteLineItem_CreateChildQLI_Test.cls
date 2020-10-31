// Created By : Chandrashekar Jangiti
// Reason : To cover CDHP_QuoteLineItem_CreateChildQLI class
// LastModifiedDate : 02/04/2020
//***************

@isTest
private class CDHP_QuoteLineItem_CreateChildQLI_Test {
    
    @istest
    private static void testMethod1()
    {
        Test.startTest();
        List<Account> lstAcc;
        List<Contact> lstCont;
        List<Quote> lstQuote;   
        List<Product2> lstProduct;  
        List<PricebookEntry> lstPBEntry;
        List<QuoteLineItem> lstQLItem;   
        List<Opportunity> lstOpp;
        Id standardPB; 
        lstProduct = new List<Product2>();
        
        
        //Account
        lstAcc = new List<Account>();
        List<RecordType> lstRcdType = [Select Id From RecordType Where Name =: 'Brokerage' Limit 1];
        Account acc = new Account(Cancel_Date__c = System.today().addDays(2),Name = 'Test Account', RecordTypeId = lstRcdType[0].Id);
        
        lstAcc.add(acc);
        insert lstAcc;
        
        lstCont = new List<Contact>();
        Contact ct = new Contact(AccountId=lstAcc[0].Id,FirstName='test',LastName='Test',Phone='0123456789',Email='Test@test.com',
                                 Primary_Contact__c=true,IsActive1__c=true);
        lstCont.add(ct);
        insert lstCont;
        
        lstOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity(AccountId = lstAcc[0].Id,Name = 'Test Opp', StageName = 'Initiated',
                                          CloseDate = System.today().toStartOfMonth());
        lstOpp.add(opp);
        
        insert lstOpp;
        
        lstQuote = new List<Quote>();
        standardPB = Test.getStandardPricebookId();
        Quote qt1 = new Quote(Name = 'Test Quote1', OpportunityId = lstOpp[0].Id, Pricebook2Id = standardPB);       
        
        lstQuote.add(qt1);
        
        insert lstQuote;
        
        Pricebook2 prb= new Pricebook2(Name='Standard Price Book 2009',Description ='Price Book 2009 Products',IsActive = true);
        insert prb;
        
        Product2 pr = new Product2(vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HRA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}',Name='Medical ActWise HRA',IsActive=true,QLIRecordType__c='ActWise HRA');
        lstProduct.add(pr);
        
        Product2 pr1 = new Product2(vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HRA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}',
                                    Name='Medical ActWise HSA',IsActive=true,QLIRecordType__c='ActWise HSA');
        lstProduct.add(pr1);
        
        Product2 pr2 = new Product2(Name='Anthem Blue Access Choice PPO HSAs Option 2',IsActive=true,QLIRecordType__c='LocalType',
                                    vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}'
                                   );
        Product2 pr3 = new Product2(Name='Anthem Blue Access Choice PPO HSAs Option 2',IsActive=true,QLIRecordType__c='LocalType',
                                    vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HRA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}'
                                   );
        lstProduct.add(pr2);
        lstProduct.add(pr3);
        insert lstProduct;
        
        lstPBEntry = new List<PricebookEntry>();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB, Product2Id = pr.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        lstPBEntry.add(standardPrice);
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = prb.Id, Product2Id = pr.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        lstPBEntry.add(pbe);
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = standardPB, Product2Id = pr1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        lstPBEntry.add(pbe1);
        insert lstPBEntry;
        
        list<QuoteLineItem> qliList = new list<QuoteLineItem>();
        
        QuoteLineItem qlt = new QuoteLineItem(oppType__c='Renewal',Funding__c='ASO',Financing__c='Cost Plus',Probability__c='5%',
                                              Subscribers__c = 123,Members__c=12,Reason__c='Brand',TermDate__c=date.today(),Renewed_with_Changes__c='Yes',
                                              ReceivedDate__c = date.today(),ProductStage__c='Termed',Benefit_Period__c='Benefit Year', 
                                              RecordType__c = 'ActWise HRA', Product2Id = lstProduct[0].Id, QuoteId = lstQuote[0].id ,Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[0].Id,PLComplete__c=true);
        insert qlt;
        QuoteLineItem qlt1 = new QuoteLineItem(RecordType__c = 'ActWise HSA',Product2Id = lstProduct[1].Id, QuoteId = lstQuote[0].id ,Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[0].Id, 
                                               ProductStage__c = 'IGAP Sold',PLComplete__c=true,ParentQuoteLineItem__c=qlt.id);
        qliList.add(qlt1);
        insert qliList;
        
        QuoteLineItem qlt2 = new QuoteLineItem(RecordType__c = 'Medical',Product2Id = lstProduct[2].Id, QuoteId = lstQuote[0].id ,Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[0].Id, 
                                               ProductStage__c = 'IGAP Sold',PLComplete__c=true,ParentQuoteLineItem__c=qlt.id,
                                               Is_HSA_Selected_Plan__c = true);
        insert qlt2;
        QuoteLineItem qlt3 = new QuoteLineItem(RecordType__c = 'Medical',Product2Id = lstProduct[3].Id, QuoteId = lstQuote[0].id ,Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[0].Id, 
                                               ProductStage__c = 'IGAP Sold',PLComplete__c=true,ParentQuoteLineItem__c=qlt.id
                                              );
        insert qlt3;
        
        
        Map<String,Object> inputMapval = new Map<String,Object> ();
        Map<String,Object> CDHPAWHSAMap = new Map<String,Object> ();
        CDHPAWHSAMap.put('AdminFeeResp','Employer');
        CDHPAWHSAMap.put('BenefitPeriod',qlt.Benefit_Period__c);
        CDHPAWHSAMap.put('AccumResetDate',date.today()+'');
       
        Object inputobj1 = qlt.id; // contextid (record id)
        Object inputQuoteobj1 = qlt;
        system.debug( 'qlt.id' +  qlt.id);
        inputMapval.put('ContextId', inputobj1 );
        

        Map<String,Object> NetworkBlockMap = new Map<String,Object>();
        NetworkBlockMap.put('Network', 'Access');
        NetworkBlockMap.put('AlternateNetwork', 'Access');
        NetworkBlockMap.put('Prefix', 'Access');


        Map<String,Object> ProbBlockMap = new Map<String,Object>();
        ProbBlockMap.put('Probability',qlt.Probability__c);
        
        Map<String,Object> CDHPHRAMap = new Map<String,Object> ();
        CDHPHRAMap.put('HRAHIAAdministration','Anthem');
        CDHPHRAMap.put('HRABalanceTransfer','test');
        CDHPHRAMap.put('DidClientPurchaseQUE',true);
      
        Map<String,Object> MedicalCDHPandMedicalCDHPWCICMap = new Map<String,Object>();
        MedicalCDHPandMedicalCDHPWCICMap.put('PBMIntegrationType', 'Test');
        
        Map<String,Object> PBMVendor_BlockMap = new Map<String,Object>();
        PBMVendor_BlockMap.put('SPAccountId',lstAcc[0].Id);

        Map<String,Object> MedicalandMedicalWCICMap = new Map<String,Object>();
        MedicalandMedicalWCICMap.put('MedicalRXAccumulation', 'Yes');

        
        
        Map<String,Object> PharmacyMap = new Map<String,Object>();
        PharmacyMap.put('MedicalCDHPandMedicalCDHPWCIC', MedicalCDHPandMedicalCDHPWCICMap);
        PharmacyMap.put('PBMVendor-Block', PBMVendor_BlockMap);
        PharmacyMap.put('MedicalandMedicalWCIC-Block', MedicalandMedicalWCICMap);


        Map<String,Object> CDHPHSAMap = new Map<String,Object>();
        CDHPHSAMap.put('ClientRemLITES','Test');
        
        
        Map<String,Object> quoteMap = new Map<String,Object> ();
        quoteMap.put(qlt.id,inputQuoteobj1);
        quoteMap.put('RecordType',qlt.RecordType__c); 
        quoteMap.put('OppType',qlt.OppType__c); 
        quoteMap.put('Funding',qlt.Funding__c); 
        quoteMap.put('Financing',qlt.Financing__c); 
        quoteMap.put('ProbBlock',ProbBlockMap);     
        quoteMap.put('Subscribers',qlt.Subscribers__c);
        quoteMap.put('Members',qlt.Members__c);
        quoteMap.put('Reason',qlt.Reason__c);
        quoteMap.put('TermDate',qlt.TermDate__c);
        quoteMap.put('RenewedWithChanges',qlt.Renewed_with_Changes__c);
        quoteMap.put('ReceivedDate',qlt.ReceivedDate__c);
        

        Map<String,Object> MultipleProviderTieringMap = new Map<String,Object>();
        MultipleProviderTieringMap.put('DoesMultipleProviderTieringApply', 'value');

        Map<String,Object> ABAMap = new Map<String,Object>();
        ABAMap.put('ABACovered', 'value');
        ABAMap.put('PreCertificationRequired', 'value');
        ABAMap.put('PurchasedASD', 'value');

        
        Map<String,Object> SetPLCompleteMap = new Map<String,Object>();
        SetPLCompleteMap.put('key', 'value');

        
        Map<String,Object> ParentQLImap = new Map<String,Object>();


        
        
        Map<String,Object> rtGeneralMap = new Map<String,Object> ();
        rtGeneralMap.put('PLCompleteX', true);
        rtGeneralMap.put('QuoteLineDetails',quoteMap);
        rtGeneralMap.put('CDHPAWHSA', CDHPAWHSAMap);
        rtGeneralMap.put('CDHPHRA', CDHPAWHSAMap);
        rtGeneralMap.put('CDHPHSA', CDHPHSAMap);
        rtGeneralMap.put('Pharmacy', PharmacyMap);
        rtGeneralMap.put('NetworkBlock', NetworkBlockMap);
        rtGeneralMap.put('MultipleProviderTiering', MultipleProviderTieringMap);
        rtGeneralMap.put('ABA', ABAMap);
        rtGeneralMap.put('SetPLComplete', SetPLCompleteMap);
        rtGeneralMap.put('FMHPUWReview', 'SetPLCompleteMap');
        rtGeneralMap.put('FMHPFI', 'FMHPFI');
        rtGeneralMap.put('FMHPASO', 'FMHPASO');

        Map<String,Object> HRAARMap = new Map<String,Object>();
        HRAARMap.put('HRA1GroupSuffix','HRA1GroupSuffix');
        HRAARMap.put('PlanStartDate',date.today()+'');
        HRAARMap.put('PlanEndDate',date.today().addDays(1)+'');
        HRAARMap.put('TermCanSubmitClaims','TermCanSubmitClaims');
        HRAARMap.put('IfOtherPleaseSpecify','IfOtherPleaseSpecify');
        HRAARMap.put('BenAccumulation','BenAccumulation');
        HRAARMap.put('AccumResetDate',date.today());
        HRAARMap.put('HRAFundsProRateEntryDate','HRAFundsProRateEntryDate');
        HRAARMap.put('HRAFundstoEEandBasis','HRAFundstoEEandBasis');
        HRAARMap.put('AnnualAllocTiers','AnnualAllocTiers');
        HRAARMap.put('HealthActivitiesIncentivesB','HealthActivitiesIncentivesB');
        HRAARMap.put('AllocEE',12);
        HRAARMap.put('AllocEA',123);
        HRAARMap.put('AllocEChild',12);
        HRAARMap.put('AllocEChildren',123);
        HRAARMap.put('AllocEFamily',123);
        HRAARMap.put('TypeofHRA','TypeofHRA');
        HRAARMap.put('DebitCardServices','DebitCardServices');
        HRAARMap.put('HRAUpFrontDed','HRAUpFrontDed');
        HRAARMap.put('CoveredServices','CoveredServices');
        HRAARMap.put('UpFrontDedTiers','UpFrontDedTiers');
        HRAARMap.put('UFDEE',12);
        HRAARMap.put('UFDEA',123);
        HRAARMap.put('UFDEChild',12);
        HRAARMap.put('UFDEChildren',12);
        HRAARMap.put('UFDEFamily',12);
        
        HRAARMap.put('HasIndDed',true);
        HRAARMap.put('IndDedAmount',12);
        HRAARMap.put('HRASplitPercent','HRASplitPercent');
        HRAARMap.put('MemberRespByClaim','MemberRespByClaim');
        HRAARMap.put('CustMemClaimResp',12);
        HRAARMap.put('SplitPercentCovSvc','SplitPercentCovSvc');
        HRAARMap.put('NonSplitCoveredSvc','NonSplitCoveredSvc');
        HRAARMap.put('Medical','Medical');
        HRAARMap.put('Pharmacy','Pharmacy');
        HRAARMap.put('Specialty','Specialty');

        HRAARMap.put('HRARollover','HRARollover');
        HRAARMap.put('HRARolloverFundsExpire','HRARolloverFundsExpire');
        HRAARMap.put('ClaimRunOutDate',date.today()+'');
        HRAARMap.put('Duringclaimsrunout','Duringclaimsrunout');
        HRAARMap.put('CapEE',12);
        HRAARMap.put('HRARolloverTimePeriod','HRARolloverTimePeriod');
        HRAARMap.put('ActualRolloverDate',date.today()+'');
        HRAARMap.put('CapEA',12);
        HRAARMap.put('CapEChild',12);
        HRAARMap.put('MinRolloverAmount',12);

        HRAARMap.put('CapEChildren',12);
        HRAARMap.put('EEFundsRollverNextPlanYear','EEFundsRollverNextPlanYear');
        HRAARMap.put('CapEFamily',12);
        HRAARMap.put('RolloverPctValue',12);
        HRAARMap.put('RolloverCapTiers','RolloverCapTiers');
        HRAARMap.put('RolloverDiffAdmin','RolloverDiffAdmin');
        HRAARMap.put('HRALITESRollover','HRALITESRollover');
        HRAARMap.put('HRALITESRolloverAllocation','HRALITESRolloverAllocation');
        HRAARMap.put('DesiredRollverDateFromPrevHRA',date.today()+'');
        HRAARMap.put('PriorTrustee','PriorTrustee');
        
        
        Map<String,Object> HRAAMap = new Map<String,Object>();
        HRAAMap.put('HRAAR',HRAARMap);
        
        
        Plan_Relationship__c plan = new Plan_Relationship__c();
        plan.Qli1__c=qlt.Id;
        plan.Qli2__c =qlt.id;
        insert plan;
        
        HRA_Administration__c hra = new HRA_Administration__c();
        hra.QLI__c=qlt.id;
        insert hra;

        object inputobj2 = rtGeneralMap; 
        inputMapval.put('RTGeneral', inputobj2 );
        inputMapval.put('RTMedical', inputobj2 );
        inputMapval.put('CDHPAWHSA', CDHPHRAMap );
        inputMapval.put('isMedProduct', true);
        inputMapval.put('ProductStage', 'ParentQLImap');
        inputMapval.put('HRAA', HRAAMap);
        inputMapval.put('PlanQLIID', qlt.Id);
        inputMapval.put('SelectedPlansForAct', qlt.Id);

        inputMapval.put('isMedProduct', false);
        
        Map<String,Object> outputMapval = new Map<String,Object> ();
        
        CDHP_QuoteLineItem_CreateChildQLI.checkJunctionObject(inputMapval, outputMapval);
        CDHP_QuoteLineItem_CreateChildQLI.AddHRAHSAProduct1(inputMapval, outputMapval);
        CDHP_QuoteLineItem_CreateChildQLI.UpdateOrCreateActWise(inputMapval, outputMapval);
        CDHP_QuoteLineItem_CreateChildQLI.isHRAorHSAPlanSelected(inputMapval,outputMapval);
        CDHP_QuoteLineItem_CreateChildQLI.isPermissionSetAssigned(inputMapval, outputMapval);
        CDHP_QuoteLineItem_CreateChildQLI.createHRAAdminRec(qlt.Id,inputMapval);

        test.stopTest();
        
    }
}