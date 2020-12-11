/**
  * @author        Indra Lugina
  * @date          08/08/2018
  * @description   Test Class for VlocityInterface class.
  * LastModifiedDate : 02/04/2020
  */

@isTest
private class VlocityInterfaceTest {

    static Account acct {get;set;}
    static Contact con {get;set;}
    static Opportunity opp {get;set;}
    static Quote q1 {get;set;}
    static Group__C grp {get;set;}
    static List<Quote> quoteList {get;set;}
    
    
    static testMethod void testValidationReason() {
        Map<String,Object> reasonMap = new Map<String,Object>();
        reasonMap.put('Reason','Need finalized benefits');
        reasonMap.put('Tx1',null);
        
        List<Map<String,Object>> blockList = new List<Map<String,Object>>();
        blockList.add(reasonMap);
        blockList.add(reasonMap);

        Map<String,Object> blockMap = new Map<String,Object>();
        blockMap.put('Block1',blockList);
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('IntakeReason',blockMap);

        Test.startTest();
            Boolean result = VlocityInterface.invokeMethod('ValidateReason', inputMap, new Map<String,Object>(), new Map<String,Object>());        
            System.assert(result);
        Test.stopTest();
    }
    
    static testMethod void testInternalCommissionAssignApproverV2() {
        acct=ANA_UTIL01_TestMethods.createAccount(true);
        
        //Setup team member
        //Set<String> atmRoleSet = new Set<String> {'Account Executive','Director Sales/AM','Regional Manager','Sales Executive','VP'};
        Set<String> atmRoleSet = new Set<String> {'Account Manager'};
        List<AccountTeamMember> atmList = new List<AccountTeamMember>();
        for(String s:atmRoleSet) {
            AccountTeamMember atm = new AccountTeamMember();
            atm.TeamMemberRole = s;
            atm.AccountAccessLevel = 'Edit';
            atm.AccountId = acct.Id;
            atm.ContactAccessLevel='Edit';
            atm.OpportunityAccessLevel='Edit';
            atm.UserId=UserInfo.getUserId();
            atmList.add(atm);
        }
        System.debug('>>> atmList size ='+atmList.size());
        System.debug('>>> atmList ='+atmList);
        insert atmList;
        System.debug('>>> atmList ='+atmList);
        
        con =ANA_UTIL01_TestMethods.createContact(true,acct.Id);
        
        opp = ANA_UTIL01_TestMethods.createOpportunity(true,acct.Id);
        
        grp = ANA_UTIL01_TestMethods.createGroup(acct.Id,true);
        
        q1 = ANA_UTIL01_TestMethods.createQuote(true,opp.Id);
        
        q1.DivisionName__c = 'Test 1';
        q1.GroupNumber__c = grp.Id;
        update q1;
        
        Product2 prod = ANA_UTIL01_TestMethods.createProduct(true);
        prod.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';
        prod.Compensated_Start_Date__c = date.today();
        prod.Compensated_End_Date__c  = date.today().addDays(2);
        update prod;        
        
        Product2 prodAP = ANA_UTIL01_TestMethods.createProduct(true);
        prodAP.Name = 'Pharmacy - Anthem Pharmacy Services';
        prodAP.Compensated_Start_Date__c = date.today();
        prodAP.Compensated_End_Date__c  = date.today().addDays(2);
        prodAP.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';
        update prodAP;
        
        PricebookEntry pbe = ANA_UTIL01_TestMethods.createPricebookEntry(true,prod.Id);
        PricebookEntry pbeAP = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodAP.Id);
        
        List<QuoteLineItem> qliList = ANA_UTIL01_TestMethods.createQuoteLineItems(3, true,q1.Id,pbe.Id);
        List<QuoteLineItem> qliAPList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeAP.Id);

        Set<Id> qliIdAPSet = new Set<Id>();
        for(QuoteLineItem qli:qliAPList) {
            qliIdAPSet.add(qli.Id);
        }
        
        qliList.addAll(qliAPList);
        for(QuoteLineItem qli:qliList) {
            qli.ProductStage__c = 'Sold';
            //qli.IC_ProductStage__c = 'Sold';
           // qli.Compensated_Product__c = true;
        }
        qliAPList[0].ProductStage__c = 'Sold';
        update qliAPList;
        update qliList;
        
        Map<String,Object> inputMap = new Map<String,Object>();
        
        //setup data
        Map<String,Object> objMap = new Map<String,Object>();
        objMap.put('QuoteId',q1.Id);
        objMap.put('GroupId',grp.Id);
        objMap.put('GroupNumber',grp.Name);
        objMap.put('AM1Lookup',UserInfo.getUserId());
        objMap.put('AM2Lookup','');
        objMap.put('AM3Lookup','');
        objMap.put('QLIMembersValidated','QLIMembersValidated');
        objMap.put('QLIValidatedRenewWithGrowthMembers','QLIMembersValidated');
        objMap.put('AnnualizedPremium','QLIMembersValidated');
        objMap.put('QLISubscribersValidated','QLIMembersValidated');
        objMap.put('QLIId',qliList[0].Id);
        
        
        Map<String,Object> approvalBlockMap = new Map<String,Object>();
        approvalBlockMap.put('ApprovalReviewBlock', objMap);
        inputMap.put('ApprovalReviewStep',approvalBlockMap);        
        
        inputMap.put('ContextId',opp.Id);


        List<Object> QLISoldRenewedList = new List<Object>();
        for(QuoteLineItem qli:qliList) {
            Map<String,Object> QLISoldRenewedMap = new Map<String,Object>();
            QLISoldRenewedMap.put('QLIId',q1.Id);
            QLISoldRenewedMap.put('QLIEstimatedRenew',10);
            QLISoldRenewedMap.put('QLIRenewWithGrowth',true);
            QLISoldRenewedList.add(QLISoldRenewedMap);
        }
        
        
        Map<String,Object> QLISoldRenewedStepMap = new Map<String,Object>();
        QLISoldRenewedStepMap.put('QLISoldRenewed', QLISoldRenewedList);
        inputMap.put('QLISoldRenewedStep',QLISoldRenewedStepMap);        
        
        //Internal_Commission__c icObj = new Internal_Commission__c();
        //icObj.Commissions_Approval_Status__c='Not Started';
        //icObj.Opportunity_Name__c = opp.Id;
        //icObj.Account_Executive__c = UserInfo.getUserId();
        //insert icObj;
        //inputMap.put('DRId_Internal_Commission__c',icObj.Id);

        //Proration Percentage
        Map<String, Object> ppMap = new Map<String,Object>();
        ppMap.put('AEMultiplierPercentage',100);
        ppMap.put('RMMultiplierPercentage',100);
        ppMap.put('DSAMMultiplierPercentage',100);
        ppMap.put('RVPMultiplierPercentage',100);
        inputMap.put('ProrationPercentages',ppMap);
        
        //Changes for 29084
        inputMap.put('SelectRequestType','Account Team');
        Map<String,Object> selectICTypeRequestMap = new Map<String,Object>();
        selectICTypeRequestMap.put('SelectRequestType','Account Team'); 
        inputMap.put('SelectICTypeRequest',selectICTypeRequestMap);

        //Confirm Multiplier Percentage
        Map<String,Object> confirmMultiplierStepMap = new Map<String,Object>();
        confirmMultiplierStepMap.put('SEMultiplierPercentage',100);
        confirmMultiplierStepMap.put('SRVPMultiplierPercentage',100);
        inputMap.put('ConfirmMultiplierStep',confirmMultiplierStepMap); 

        //Anthem Pharmacy
        List<Object> QLISoldAPList = new List<Object>();
        for(QuoteLineItem qli:qliAPList) {
            Map<String,Object> QLISoldAPMap = new Map<String,Object>();
            QLISoldAPMap.put('QLIId',qli.Id);
            QLISoldAPMap.put('QLIDurationGuarantee','1');
            QLISoldAPMap.put('QLICurrentYearGuarantee','1');
            QLISoldAPList.add(QLISoldAPMap);
        }
        
        
        Map<String,Object> QLISoldAPStepMap = new Map<String,Object>();
        QLISoldAPStepMap.put('QLIAnthemPharmacy', QLISoldAPList);
        inputMap.put('AnthemPharmacyStep',QLISoldAPStepMap);        
        
        //Note        
        Map<String,Object> doneStepMap = new Map<String,Object>();
        doneStepMap.put('Note','THIS IS TEST');
        inputMap.put('Done',doneStepMap); 

        Test.startTest();
            Boolean result = VlocityInterface.invokeMethod('InternalCommissionAssignApprover', inputMap, new Map<String,Object>(), new Map<String,Object>());        
            System.assert(result);
            inputMap.put('ContextId',opp.Id); 
            result = VlocityInterface.invokeMethod('populateAccountManager', inputMap, new Map<String,Object>(), new Map<String,Object>());        
            System.assert(result);
        Test.stopTest();
        
    }
    
    static testMethod void testMedicalFSACommuter() {
        acct=ANA_UTIL01_TestMethods.createAccount(true);
        
        //Setup team member
        Set<String> atmRoleSet = new Set<String> {'Account Manager'};
        List<AccountTeamMember> atmList = new List<AccountTeamMember>();
        for(String s:atmRoleSet) {
            AccountTeamMember atm = new AccountTeamMember();
            atm.TeamMemberRole = s;
            atm.AccountAccessLevel = 'Edit';
            atm.AccountId = acct.Id;
            atm.ContactAccessLevel='Edit';
            atm.OpportunityAccessLevel='Edit';
            atm.UserId=UserInfo.getUserId();
            atmList.add(atm);
        }
        insert atmList;
        
        con =ANA_UTIL01_TestMethods.createContact(true,acct.Id);
        opp = ANA_UTIL01_TestMethods.createOpportunity(true,acct.Id);
        grp = ANA_UTIL01_TestMethods.createGroup(acct.Id,true);
        q1 = ANA_UTIL01_TestMethods.createQuote(true,opp.Id);
        
        q1.DivisionName__c = 'Test 1';
        q1.GroupNumber__c = grp.Id;
        update q1;
        
        Product2 prodMed = ANA_UTIL01_TestMethods.createProduct(true);
        prodMed.QLIRecordType__c = 'LocalType';
        prodMed.Product_Type__c= 'Medical';
        prodMed.LOB__c = 'Medical';
        prodMed.Product_Family__c = 'PPO';
        prodMed.ProductActive__c=true;
        prodMed.IsActive = true;
        update prodMed;

        Product2 prodFSA = ANA_UTIL01_TestMethods.createProduct(true);
        prodFSA.Name = 'Benefits Admin - Act Wise FSA';
        prodFSA.QLIRecordType__c = 'ActWise FSA';
        prodFSA.Product_Type__c = 'Commercial Act Wise';
        prodFSA.Product_Family__c = 'Benefits Admin';
        prodFSA.LOB__c = 'Benefits Admin';
        prodFSA.ProductActive__c=true;
        prodFSA.IsActive = true;
        update prodFSA;

        Product2 prodComm = ANA_UTIL01_TestMethods.createProduct(true);
        prodComm.Name = 'Benefits Admin - Act Wise Commuter';
        prodComm.QLIRecordType__c = 'ActWise Commuter';
        prodComm.Product_Type__c = 'Commercial Act Wise';
        prodComm.Product_Family__c = 'Benefits Admin';
        prodComm.LOB__c = 'Benefits Admin';
        prodComm.ProductActive__c=true;
        prodComm.IsActive = true;
        update prodComm;
        
        PricebookEntry pbeMed = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodMed.Id);
        PricebookEntry pbeFSA = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodFSA.Id);
        PricebookEntry pbeComm = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodComm.Id);
        
        List<QuoteLineItem> qliList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeMed.Id);
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',qliList[0].Id);
        inputMap.put('DRId_QuoteLineItem',qliList[0].Id);

        Test.startTest();
            Boolean result = VlocityInterface.invokeMethod('MedicalFSACommuter', inputMap, new Map<String,Object>(), new Map<String,Object>());        
            System.assert(result);
            result = VlocityInterface.invokeMethod('MedicalFSACommuter', inputMap, new Map<String,Object>(), new Map<String,Object>());        
            System.assert(result);
        Test.stopTest();
        
    }    
    
    static testMethod void testisHRAHSAProducts(){
         Product2 pr2 = new Product2(Name='Anthem Blue Access Choice PPO HSAs Option 2',IsActive=true,QLIRecordType__c='LocalType',
                                    vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}'
                                   );
         List<Product2> lstProduct;  
          lstProduct = new List<Product2>();
        lstProduct.add(pr2);
         insert lstProduct;
        
        Map<String,Object>  undefined = new Map<String,Object> ();
        Map<String,Object>  inputMap = new Map<String,Object> ();
        Map<String,Object> selectedPlansMap = new Map<String,Object>();
        Map<string,string> tempMap = new Map<string,string>();
        tempMap.put(lstProduct[0].Id,'attributeCategories'); 
        
        
        //selectedPlansMap.add(tempMap);

        undefined.put('selectedPlansMap',tempMap); 
        inputMap.put('undefined',undefined);
        system.debug('inputMap'+ inputMap);
        Test.startTest();
            Boolean result = VlocityInterface.invokeMethod('isHRAHSAProducts', inputMap, new Map<String,Object>(), new Map<String,Object>());        
            System.assert(result);
            result = VlocityInterface.invokeMethod('isHRAHSAProducts', inputMap, new Map<String,Object>(), new Map<String,Object>());        
            System.assert(result);
        Test.stopTest();
      
        
        
    }
    static testMethod void updateHSAProducts(){
        
          List<Account> lstAcc;
     List<Contact> lstCont;
     List<Quote> lstQuote;   
     List<Product2> lstProduct;  
     List<PricebookEntry> lstPBEntry;
     List<QuoteLineItem> lstQLItem;   
     List<Opportunity> lstOpp;
       Id standardPB; 
       lstProduct = new List<Product2>();
        
        
        
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
        Product2 pr2 = new Product2(Name='Anthem Blue Access Choice PPO HSAs Option 2',IsActive=true,QLIRecordType__c='LocalType',
                                    vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}'
                                   );
           
         lstProduct = new List<Product2>();
         lstProduct.add(pr2);
         insert lstProduct;
        
        Pricebook2 prb= new Pricebook2(Name='Standard Price Book 2009',Description ='Price Book 2009 Products',IsActive = true);
        insert prb;
        lstPBEntry = new List<PricebookEntry>();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB, Product2Id = lstProduct[0].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        lstPBEntry.add(standardPrice);
        //PricebookEntry pbe = new PricebookEntry(Pricebook2Id = prb.Id, Product2Id = lstProduct[0].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
       // lstPBEntry.add(pbe);
       // PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = standardPB, Product2Id = lstProduct[0].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
       // lstPBEntry.add(pbe1);
        insert lstPBEntry;
        
        QuoteLineItem qlt = new QuoteLineItem(RecordType__c = 'ActWise HRA', Product2Id = lstProduct[0].Id, QuoteId = lstQuote[0].id ,Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[0].Id, ProductStage__c = 'IGAP Sold',PLComplete__c=true);
        // lstQLItem.add(qlt);
        insert qlt;
     
        Map<String,Object>  undefined = new Map<String,Object> ();
        Map<String,Object>  inputMap = new Map<String,Object> ();
        inputMap.put('ContextId', qlt.id);
        List<Map<String,String>> ProductList = new List<Map<String, String>>();
        Map<String, String> tempMap = new Map<String, String>();
        tempMap.put('Id',lstProduct[0].id ); // Language Independent
        tempMap.put('Name',lstProduct[0].name); // Displayed in Picklist UI
        ProductList.add(tempMap);
        Map<String,Object> HSAIntegratedPlanMap = new Map<String,Object>();
        HSAIntegratedPlanMap.put('HSAIntegratedPlan',ProductList);
        inputMap.put('HSAIntegratedBlock',HSAIntegratedPlanMap);
        
        Test.startTest();
            Boolean result = VlocityInterface.invokeMethod('updateHSAProducts', inputMap, new Map<String,Object>(), new Map<String,Object>());        
            System.assert(result);
            result = VlocityInterface.invokeMethod('updateHSAProducts', inputMap, new Map<String,Object>(), new Map<String,Object>());        
            System.assert(result);
        Test.stopTest();
       
        
    }
    
    static testMethod void testupdateOtherPlans() {
        acct=ANA_UTIL01_TestMethods.createAccount(true);
        
        //Setup team member
        Set<String> atmRoleSet = new Set<String> {'Account Manager'};
        List<AccountTeamMember> atmList = new List<AccountTeamMember>();
        for(String s:atmRoleSet) {
            AccountTeamMember atm = new AccountTeamMember();
            atm.TeamMemberRole = s;
            atm.AccountAccessLevel = 'Edit';
            atm.AccountId = acct.Id;
            atm.ContactAccessLevel='Edit';
            atm.OpportunityAccessLevel='Edit';
            atm.UserId=UserInfo.getUserId();
            atmList.add(atm);
        }
        insert atmList;
        
        con =ANA_UTIL01_TestMethods.createContact(true,acct.Id);
        opp = ANA_UTIL01_TestMethods.createOpportunity(true,acct.Id);
        grp = ANA_UTIL01_TestMethods.createGroup(acct.Id,true);
        q1 = ANA_UTIL01_TestMethods.createQuote(true,opp.Id);
        
        q1.DivisionName__c = 'Test 1';
        q1.GroupNumber__c = grp.Id;
        update q1;
        
        Product2 prodMed = ANA_UTIL01_TestMethods.createProduct(true);
        prodMed.QLIRecordType__c = 'LocalType';
        prodMed.Product_Type__c= 'Medical';
        prodMed.LOB__c = 'Medical';
        prodMed.Product_Family__c = 'PPO';
        prodMed.ProductActive__c=true;
        prodMed.IsActive = true;
        prodMed.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';
        update prodMed;

        Product2 prodFSA = ANA_UTIL01_TestMethods.createProduct(true);
        prodFSA.Name = 'Benefits Admin - Act Wise FSA';
        prodFSA.QLIRecordType__c = 'ActWise FSA';
        prodFSA.Product_Type__c = 'Commercial Act Wise';
        prodFSA.Product_Family__c = 'Benefits Admin';
        prodFSA.LOB__c = 'Benefits Admin';
        prodFSA.ProductActive__c=true;
        prodFSA.IsActive = true;
        prodFSA.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';
        update prodFSA;

        
        Product2 prodComm = ANA_UTIL01_TestMethods.createProduct(true);
        prodComm.Name = 'Benefits Admin - Act Wise Commuter';
        prodComm.QLIRecordType__c = 'ActWise Commuter';
        prodComm.Product_Type__c = 'Commercial Act Wise';
        prodComm.Product_Family__c = 'Benefits Admin';
        prodComm.LOB__c = 'Benefits Admin';
        prodComm.ProductActive__c=true;
        prodComm.IsActive = true;
        prodComm.vlocity_ins__AttributeDefaultValues__c = 'Test';
        update prodComm;
        
        Product2 prodComm2 = ANA_UTIL01_TestMethods.createProduct(true);
        prodComm2.Name = 'Benefits Admin - Act Wise Commuter';
        prodComm2.QLIRecordType__c = 'ActWise HRA';
        prodComm2.Product_Type__c = 'Commercial Act Wise';
        prodComm2.Product_Family__c = 'Benefits Admin';
        prodComm2.LOB__c = 'Benefits Admin';
        prodComm2.ProductActive__c=true;
        prodComm2.IsActive = true;
        prodComm2.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';

        update prodComm2;
        
        Product2 prodComm3 = ANA_UTIL01_TestMethods.createProduct(true);
        prodComm3.Name = 'Benefits Admin - Act Wise Commuter';
        prodComm3.QLIRecordType__c = 'ActWise HSA';
        prodComm3.Product_Type__c = 'Commercial Act Wise';
        prodComm3.Product_Family__c = 'Benefits Admin';
        prodComm3.LOB__c = 'Benefits Admin';
        prodComm3.ProductActive__c=true;
        prodComm3.IsActive = true;
        prodComm3.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';
        update prodComm3;
        
        PricebookEntry pbeMed = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodMed.Id);
        PricebookEntry pbeFSA = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodFSA.Id);
        PricebookEntry pbeComm = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodComm.Id);
        
        List<QuoteLineItem> qliMedList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeMed.Id);
        List<QuoteLineItem> qliFSAList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeFSA.Id);
        List<QuoteLineItem> qliCommList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeComm.Id);
        
        
        qliMedList[0].ParentQuoteLineItem__c = qliCommList[0].Id;
        qliMedList[0].Is_HSA_Selected_Plan__c=true;
        qliMedList[0].ActWiseChildQuote__c=qliFSAList[0].Id;
        update qliMedList;
            
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',qliMedList[0].Id);
        inputMap.put('ParentMedical',qliCommList[0].Id);
        inputMap.put('PlanQLIID',qliMedList[0].Id);
        inputMap.put('ProductStage','Sold');

        
        
        Plan_Relationship__c plan = new Plan_Relationship__c();
        plan.Qli1__c=qliMedList[0].Id;
        plan.Qli2__c =qliMedList[0].Id;
        insert plan;
        

        
        
        Map<String,Object> actWiseCompanionStepMap = new Map<String,Object>();
        List<Object> otherPlanList = new List<Object>();
        Map<String,Object> otherPlanObjMap = new Map<String,Object>();
        otherPlanObjMap.put('Id',qliFSAList[0].Id);
        otherPlanList.add((Object) otherPlanObjMap);    
        actWiseCompanionStepMap.put('OtherPlanList',otherPlanList);
        inputMap.put('ActWiseCompanionStep',actWiseCompanionStepMap);        
        Test.startTest();
        Boolean result = VlocityInterface.invokeMethod('updateOtherPlans', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('FetchProductType', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('moreThanTwoJunctionObject', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('isPermissionSetAssigned', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('isHRAorHSAPlanSelected', inputMap, new Map<String,Object>(), new Map<String,Object>());        
       // VlocityInterface.invokeMethod('createFSACommuterForMedical', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('AddHRAHSAProduct', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('AddPlansToMedical', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('ReConfigPlansToMedical', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('contactSearch', inputMap, new Map<String,Object>(), new Map<String,Object>());        

        VlocityInterface.invokeMethod('UpdateOrCreateActWise', inputMap, new Map<String,Object>(), new Map<String,Object>());   
        
        VlocityInterface.invokeMethod('fetchMedicalRxType', inputMap, new Map<String,Object>(), new Map<String,Object>());  


        
        
        prodComm3.vlocity_ins__AttributeDefaultValues__c='';
        update prodComm3;
        
       
        prodFSA.vlocity_ins__AttributeDefaultValues__c='';
        update prodFSA;
        
        prodComm.vlocity_ins__AttributeDefaultValues__c='';
        update prodComm;
        
        prodComm2.vlocity_ins__AttributeDefaultValues__c='';
        update prodComm2;
        
        prodComm3.vlocity_ins__AttributeDefaultValues__c='';
        update prodComm3;
        
        PricebookEntry pbeMed2 = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodMed.Id);
        List<QuoteLineItem> qliMedList2 = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeMed2.Id);
        inputMap.put('PlanQLIID',qliMedList2[0].Id);
        
        VlocityInterface.invokeMethod('ReConfigPlansToMedical', inputMap, new Map<String,Object>(), new Map<String,Object>());        

        
        System.assert(result);
        Test.stopTest();
        
    }   
    static testMethod void testupdateOtherPlans2() {
        acct=ANA_UTIL01_TestMethods.createAccount(true);
        
        //Setup team member
        Set<String> atmRoleSet = new Set<String> {'Account Manager'};
        List<AccountTeamMember> atmList = new List<AccountTeamMember>();
        for(String s:atmRoleSet) {
            AccountTeamMember atm = new AccountTeamMember();
            atm.TeamMemberRole = s;
            atm.AccountAccessLevel = 'Edit';
            atm.AccountId = acct.Id;
            atm.ContactAccessLevel='Edit';
            atm.OpportunityAccessLevel='Edit';
            atm.UserId=UserInfo.getUserId();
            atmList.add(atm);
        }
        insert atmList;
        
        con =ANA_UTIL01_TestMethods.createContact(true,acct.Id);
        opp = ANA_UTIL01_TestMethods.createOpportunity(true,acct.Id);
        grp = ANA_UTIL01_TestMethods.createGroup(acct.Id,true);
        q1 = ANA_UTIL01_TestMethods.createQuote(true,opp.Id);
        
        q1.DivisionName__c = 'Test 1';
        q1.GroupNumber__c = grp.Id;
        update q1;
        
        Product2 prodMed = ANA_UTIL01_TestMethods.createProduct(true);
        prodMed.QLIRecordType__c = 'LocalType';
        prodMed.Product_Type__c= 'Medical';
        prodMed.LOB__c = 'Medical';
        prodMed.Product_Family__c = 'PPO';
        prodMed.ProductActive__c=true;
        prodMed.IsActive = true;
        prodMed.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';
        update prodMed;

        Product2 prodFSA = ANA_UTIL01_TestMethods.createProduct(true);
        prodFSA.Name = 'Benefits Admin - Act Wise FSA';
        prodFSA.QLIRecordType__c = 'ActWise FSA';
        prodFSA.Product_Type__c = 'Commercial Act Wise';
        prodFSA.Product_Family__c = 'Benefits Admin';
        prodFSA.LOB__c = 'Benefits Admin';
        prodFSA.ProductActive__c=true;
        prodFSA.IsActive = true;
        prodFSA.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';
        update prodFSA;

        Product2 prodComm = ANA_UTIL01_TestMethods.createProduct(true);
        prodComm.Name = 'Benefits Admin - Act Wise Commuter';
        prodComm.QLIRecordType__c = 'ActWise Commuter';
        prodComm.Product_Type__c = 'Commercial Act Wise';
        prodComm.Product_Family__c = 'Benefits Admin';
        prodComm.LOB__c = 'Benefits Admin';
        prodComm.ProductActive__c=true;
        prodComm.IsActive = true;
        prodComm.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';

        update prodComm;
        
        PricebookEntry pbeMed = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodMed.Id);
        PricebookEntry pbeFSA = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodFSA.Id);
        PricebookEntry pbeComm = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodComm.Id);
        
        List<QuoteLineItem> qliMedList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeMed.Id);
        List<QuoteLineItem> qliFSAList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeFSA.Id);
        List<QuoteLineItem> qliCommList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeComm.Id);
        
        
        qliCommList[0].ParentQuoteLineItem__c = qliMedList[0].Id;
        //qliMedList[0].product2id=prodMed.Id;
        update qliMedList;
            
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',qliMedList[0].Id);
        inputMap.put('ParentMedical',qliCommList[0].Id);
        inputMap.put('PlanQLIID',qliMedList[0].Id);
        
        Map<String,Object> actWiseCompanionStepMap = new Map<String,Object>();
        List<Object> otherPlanList = new List<Object>();
        Map<String,Object> otherPlanObjMap = new Map<String,Object>();
        otherPlanObjMap.put('Id',qliFSAList[0].Id);
        otherPlanList.add((Object) otherPlanObjMap);    
        actWiseCompanionStepMap.put('OtherPlanList',otherPlanList);
        inputMap.put('ActWiseCompanionStep',actWiseCompanionStepMap);        
        Test.startTest();
        Boolean result = VlocityInterface.invokeMethod('updateOtherPlans', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        //VlocityInterface.invokeMethod('FetchProductType', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('moreThanTwoJunctionObject', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('isPermissionSetAssigned', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('isHRAorHSAPlanSelected', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        
        System.assert(result);
        Test.stopTest();
        
    } 
    static testMethod void testupdateOtherPlans3() {
        acct=ANA_UTIL01_TestMethods.createAccount(true);
        
        //Setup team member
        Set<String> atmRoleSet = new Set<String> {'Account Manager'};
        List<AccountTeamMember> atmList = new List<AccountTeamMember>();
        for(String s:atmRoleSet) {
            AccountTeamMember atm = new AccountTeamMember();
            atm.TeamMemberRole = s;
            atm.AccountAccessLevel = 'Edit';
            atm.AccountId = acct.Id;
            atm.ContactAccessLevel='Edit';
            atm.OpportunityAccessLevel='Edit';
            atm.UserId=UserInfo.getUserId();
            atmList.add(atm);
        }
        insert atmList;
        
        con =ANA_UTIL01_TestMethods.createContact(true,acct.Id);
        opp = ANA_UTIL01_TestMethods.createOpportunity(true,acct.Id);
        grp = ANA_UTIL01_TestMethods.createGroup(acct.Id,true);
        q1 = ANA_UTIL01_TestMethods.createQuote(true,opp.Id);
        
        q1.DivisionName__c = 'Test 1';
        q1.GroupNumber__c = grp.Id;
        update q1;
        
        Product2 prodMed = ANA_UTIL01_TestMethods.createProduct(true);
        prodMed.QLIRecordType__c = 'LocalType';
        prodMed.Product_Type__c= 'Medical';
        prodMed.LOB__c = 'Medical';
        prodMed.Product_Family__c = 'PPO';
        prodMed.ProductActive__c=true;
        prodMed.IsActive = true;
        prodMed.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';

        update prodMed;

        Product2 prodFSA = ANA_UTIL01_TestMethods.createProduct(true);
        prodFSA.Name = 'Benefits Admin - Act Wise FSA';
        prodFSA.QLIRecordType__c = 'ActWise FSA';
        prodFSA.Product_Type__c = 'Commercial Act Wise';
        prodFSA.Product_Family__c = 'Benefits Admin';
        prodFSA.LOB__c = 'Benefits Admin';
        prodFSA.ProductActive__c=true;
        prodFSA.IsActive = true;
        prodFSA.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';

        update prodFSA;

        Product2 prodComm = ANA_UTIL01_TestMethods.createProduct(true);
        prodComm.Name = 'Benefits Admin - Act Wise Commuter';
        prodComm.QLIRecordType__c = 'ActWise Commuter';
        prodComm.Product_Type__c = 'Commercial Act Wise';
        prodComm.Product_Family__c = 'Benefits Admin';
        prodComm.LOB__c = 'Benefits Admin';
        prodComm.ProductActive__c=true;
        prodComm.IsActive = true;
        prodComm.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';

        update prodComm;
        
        PricebookEntry pbeMed = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodMed.Id);
        PricebookEntry pbeFSA = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodFSA.Id);
        PricebookEntry pbeComm = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodComm.Id);
        
        List<QuoteLineItem> qliMedList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeMed.Id);
        List<QuoteLineItem> qliFSAList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeFSA.Id);
        List<QuoteLineItem> qliCommList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeComm.Id);
        
        
        qliCommList[0].ParentQuoteLineItem__c = qliMedList[0].Id;
        //qliMedList[0].product2id=prodMed.Id;
        update qliMedList;
            
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',qliMedList[0].Id);
        inputMap.put('ParentMedical',qliCommList[0].Id);
        inputMap.put('PlanQLIID',qliMedList[0].Id);
        
        Map<String,Object> actWiseCompanionStepMap = new Map<String,Object>();
        List<Object> otherPlanList = new List<Object>();
        Map<String,Object> otherPlanObjMap = new Map<String,Object>();
        otherPlanObjMap.put('Id',qliFSAList[0].Id);
        otherPlanList.add((Object) otherPlanObjMap);    
        actWiseCompanionStepMap.put('OtherPlanList',otherPlanList);
        inputMap.put('ActWiseCompanionStep',actWiseCompanionStepMap);        
        Test.startTest();
        Boolean result = VlocityInterface.invokeMethod('updateOtherPlans', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        //VlocityInterface.invokeMethod('FetchProductType', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        //VlocityInterface.invokeMethod('moreThanTwoJunctionObject', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('isPermissionSetAssigned', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('isHRAorHSAPlanSelected', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        
        System.assert(result);
        Test.stopTest();
        
    } 
    static testMethod void testupdateOtherPlans5() {
        acct=ANA_UTIL01_TestMethods.createAccount(true);
        
        //Setup team member
        Set<String> atmRoleSet = new Set<String> {'Account Manager'};
        List<AccountTeamMember> atmList = new List<AccountTeamMember>();
        for(String s:atmRoleSet) {
            AccountTeamMember atm = new AccountTeamMember();
            atm.TeamMemberRole = s;
            atm.AccountAccessLevel = 'Edit';
            atm.AccountId = acct.Id;
            atm.ContactAccessLevel='Edit';
            atm.OpportunityAccessLevel='Edit';
            atm.UserId=UserInfo.getUserId();
            atmList.add(atm);
        }
        insert atmList;
        
        con =ANA_UTIL01_TestMethods.createContact(true,acct.Id);
        opp = ANA_UTIL01_TestMethods.createOpportunity(true,acct.Id);
        grp = ANA_UTIL01_TestMethods.createGroup(acct.Id,true);
        q1 = ANA_UTIL01_TestMethods.createQuote(true,opp.Id);
        
        q1.DivisionName__c = 'Test 1';
        q1.GroupNumber__c = grp.Id;
        update q1;
        
        Product2 prodMed = ANA_UTIL01_TestMethods.createProduct(true);
        prodMed.QLIRecordType__c = 'LocalType';
        prodMed.Product_Type__c= 'Medical';
        prodMed.LOB__c = 'Medical';
        prodMed.Product_Family__c = 'PPO';
        prodMed.ProductActive__c=true;
        prodMed.IsActive = true;
        prodMed.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';

        update prodMed;

        Product2 prodFSA = ANA_UTIL01_TestMethods.createProduct(true);
        prodFSA.Name = 'Benefits Admin - Act Wise FSA';
        prodFSA.QLIRecordType__c = 'ActWise FSA';
        prodFSA.Product_Type__c = 'Commercial Act Wise';
        prodFSA.Product_Family__c = 'Benefits Admin';
        prodFSA.LOB__c = 'Benefits Admin';
        prodFSA.ProductActive__c=true;
        prodFSA.IsActive = true;
        prodFSA.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';

        update prodFSA;

        Product2 prodComm = ANA_UTIL01_TestMethods.createProduct(true);
        prodComm.Name = 'Benefits Admin - Act Wise Commuter';
        prodComm.QLIRecordType__c = 'ActWise Commuter';
        prodComm.Product_Type__c = 'Commercial Act Wise';
        prodComm.Product_Family__c = 'Benefits Admin';
        prodComm.LOB__c = 'Benefits Admin';
        prodComm.ProductActive__c=true;
        prodComm.IsActive = true;
        prodComm.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';
        update prodComm;
        
        Product2 prodCommHRA = ANA_UTIL01_TestMethods.createProduct(true);
        prodCommHRA.Name = 'Benefits Admin - Act Wise Commuter';
        prodCommHRA.QLIRecordType__c = 'ActWise HRA';
        prodCommHRA.Product_Type__c = 'Commercial Act Wise';
        prodCommHRA.Product_Family__c = 'Benefits Admin';
        prodCommHRA.LOB__c = 'Benefits Admin';
        prodCommHRA.ProductActive__c=true;
        prodCommHRA.IsActive = true;
        prodCommHRA.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';

        update prodCommHRA;
        
        Product2 prodCommHSA = ANA_UTIL01_TestMethods.createProduct(true);
        prodCommHSA.Name = 'Benefits Admin - Act Wise Commuter';
        prodCommHSA.QLIRecordType__c = 'ActWise HSA';
        prodCommHSA.Product_Type__c = 'Commercial Act Wise';
        prodCommHSA.Product_Family__c = 'Benefits Admin';
        prodCommHSA.LOB__c = 'Benefits Admin';
        prodCommHSA.ProductActive__c=true;
        prodCommHSA.IsActive = true;
        prodCommHSA.vlocity_ins__AttributeDefaultValues__c='{"OTHER_cdhProductType":"HSA","OTHER_legalEntity":"Healthy Alliance Life Insurance Company","OTHER_branding":"LG 51+","OTHER_masterBrand":"Anthem","RXPLAN_rxPlanName":"WGS-LG-RX Ded/20%","UCARE_coinsurancePercentage_33_oon":"0.40","UCARE_coinsurancePercentage_33_inn":"0.20","EMRM_coinsurancePercentage_43_inn":"0.20","PCP_coinsurancePercentage_2_oon":"0.40","PCP_coinsurancePercentage_2_inn":"0.20","SCP_coinsurancePercentage_12_oon":"0.40","SCP_coinsurancePercentage_12_inn":"0.20","oon_outOfPocketFamily_oon":"20550.00","oon_outOfPocketSingle_oon":"10275.00","oon_deductibleFamily_oon":"18000.00","oon_deductibleSingle_oon":"9000.00","oon_defaultCoinsurance_oon":"0.40","inn_outOfPocketFamily_inn":"6850.00","inn_outOfPocketSingle_inn":"3425.00","inn_deductibleFamily_inn":"6000.00","inn_deductibleSingle_inn":"3000.00","inn_defaultCoinsurance_inn":"0.20"}';

        update prodCommHSA;
        
        PricebookEntry pbeMed = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodMed.Id);
        PricebookEntry pbeFSA = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodFSA.Id);
        PricebookEntry pbeComm = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodComm.Id);
        PricebookEntry pbeCommHRA = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodCommHRA.Id);
        PricebookEntry pbeCommHSA = ANA_UTIL01_TestMethods.createPricebookEntry(true,prodCommHSA.Id);
        
        List<QuoteLineItem> qliMedList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeMed.Id);
        List<QuoteLineItem> qliFSAList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeFSA.Id);
        List<QuoteLineItem> qliCommList = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeComm.Id);
        List<QuoteLineItem> qliCommListHRA = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeCommHRA.Id);
        List<QuoteLineItem> qliCommListHSA = ANA_UTIL01_TestMethods.createQuoteLineItems(1, true,q1.Id,pbeCommHSA.Id);
        
        
        qliCommList[0].ParentQuoteLineItem__c = qliMedList[0].Id;
        //qliMedList[0].product2id=prodMed.Id;
        update qliMedList;
            
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',qliMedList[0].Id);
        inputMap.put('ParentMedical',qliCommList[0].Id);
        inputMap.put('PlanQLIID',qliMedList[0].Id);
        
        Map<String,Object> actWiseCompanionStepMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        options.put('searchString', 'Test');
        
        List<Object> otherPlanList = new List<Object>();
        Map<String,Object> otherPlanObjMap = new Map<String,Object>();
        otherPlanObjMap.put('Id',qliFSAList[0].Id);
        otherPlanList.add((Object) otherPlanObjMap);    
        actWiseCompanionStepMap.put('OtherPlanList',otherPlanList);
        inputMap.put('ActWiseCompanionStep',actWiseCompanionStepMap);        
        Test.startTest();
        Boolean result = VlocityInterface.invokeMethod('updateOtherPlans', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        //VlocityInterface.invokeMethod('FetchProductType', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        //VlocityInterface.invokeMethod('moreThanTwoJunctionObject', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        //VlocityInterface.invokeMethod('isPermissionSetAssigned', inputMap, new Map<String,Object>(), new Map<String,Object>());        
        VlocityInterface.invokeMethod('isHRAorHSAPlanSelected', inputMap, new Map<String,Object>(), new Map<String,Object>());   
        
        inputMap.put('ParentMedical','');
        VlocityInterface.invokeMethod('fetchMedicalRxType', inputMap, new Map<String,Object>(), new Map<String,Object>());
        
        inputMap.put('capturePlanID',qliMedList[0].Id);
        VlocityInterface.invokeMethod('fetchMedicalRxType', inputMap, new Map<String,Object>(), new Map<String,Object>());
        
        qliCommListHRA[0].ParentQuoteLineItem__c = qliMedList[0].Id;
        update qliCommListHRA[0];
        inputMap.put('ParentMedical','');
        inputMap.put('PlanQLIID',qliCommListHRA[0].Id);
        VlocityInterface.invokeMethod('FetchProductType', inputMap, new Map<String,Object>(), new Map<String,Object>());
        
        
        VlocityInterface.contactSearch(inputMap,  new Map<String,Object>(), options);
        
        System.assert(result);
        Test.stopTest();
        
    }
    
    static testMethod void testupdateLineItemsAsTermed(){
        Id recTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('LG Full Group Term').getRecordTypeId();
        Account testAcc = ANA_UTIL01_TestMethods.createAccount(true);
        Opportunity testOpp = ANA_UTIL01_TestMethods.createOpportunity(true, testAcc.Id);
        Quote testQuote = ANA_UTIL01_TestMethods.createQuote(true, testOpp.Id);
        Order testOrd = ANA_UTIL01_TestMethods.CreateOrder(null, testAcc.Id, null, testQuote.Id);
        testOrd.RecordTypeId = recTypeId;
        Insert testOrd;
        
        Product2 testProd = ANA_UTIL01_TestMethods.createProduct(true);
        PricebookEntry testPbe = ANA_UTIL01_TestMethods.createPricebookEntry(true, testProd.Id);
        List<QuoteLineItem> testQlis = ANA_UTIL01_TestMethods.createQuoteLineItems(5, true, testQuote.Id, testPbe.Id);
       
        
        Test.startTest();
            testOrd = [SELECT Id,Implementation_Type__c,User_Group__c FROM Order LIMIT 1];
            
            Map<String,Object> inputMap = new Map<String,Object>();
            inputMap.put(CDHP_COMM2_Constants.CONTEXTID,testOrd.Id);
        
            VlocityInterface.invokeMethod('updateLineItemsAsTermed', inputMap, new Map<String,Object>(), new Map<String,Object>());         
            List<QuoteLineItem> results = [SELECT Id FROM QuoteLineItem WHERE Status__c = :staticVariableClass.TERMED];
            System.assert(results.isEmpty());
            
            testOrd.Implementation_Type__c = staticVariableClass.FULL_GROUP_TERM;  
            testOrd.User_Group__c= staticVariableClass.LOCAL_RENEWAL;
            update testOrd;
        
            VlocityInterface.invokeMethod('updateLineItemsAsTermed', inputMap, new Map<String,Object>(), new Map<String,Object>());     
            results = [SELECT Id FROM QuoteLineItem WHERE Status__c = :staticVariableClass.TERMED];
            System.assert(!results.isEmpty());
            
            results = [SELECT Id FROM QuoteLineItem WHERE Status__c != :staticVariableClass.TERMED];
            System.assert(results.isEmpty());
            
        Test.stopTest();
        
    }
   
}