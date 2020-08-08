@isTest(SeeAllData=false)
public class LGProductUploadServiceTest {
    
    /*

    Test case 1 : Assert all the attributes in each category 
    attributes - plan, MedicalBenefits, Contract code, Riders, Pharmacy, Vision
    all the fields at  product level 
    all the fields at plan level
    assert that records are created in product child relationship object
    Test Case 2  : Product active flag based on market status and product approved state
    Test Case 3 :  Update scenario.	Load data using first JSON static resource , do assert all the fields as in test case 1 
    Load second JSON static resource, assert if updates ared one accurately
    
    Test case 4 : Exception scenario.
	**/    
    static void testLoadAttributes(String productType) {
        
        List<sObject> prodAttributes = Test.loadData(LG_Product_Load_Mapping__c.sObjectType, 'PMTProductAttributes_Test');
        
        List<LG_Product_Load_Mapping__c> prodAttrmdtlist = [SELECT JSON_Field_Location__c, JSON_Field_Name__c,Benefit_Id__c,
                                                            Benefit_Category_Id__c,Attribute_Code__c,Attribute_Category_Code__c,transform__c,filter__c
                                                            FROM LG_Product_Load_Mapping__c where product_type__c=:productType];
        List<sObject> prodAttributesCat = Test.loadData(vlocity_ins__AttributeCategory__c.sObjectType, 'PMTProductAttributeCat_Test');
        system.debug('vlocity_ins__AttributeCategory__c size*******:' + prodAttributesCat.size());
        List<vlocity_ins__AttributeCategory__c> attrCatList = [select id,Name,VLOCITY_INS__CODE__C from vlocity_ins__AttributeCategory__c];
        System.assertEquals(14, attrCatList.size());
        Id inNetworkId;
        Id specialtyCareProvider;
        Id primaryCareProvider;
        Id pharmacyPlan;
        Id other;
        Id visionPlan;
        Id inNetworkLvl2Id;
        Id urgentCareId;
        Id emergencyRoomId;
        Id inVisionNetworkId;
        Id otherVision;
        Id ooVisionNetworkId;
        Id frequencyVision;
        
        for(vlocity_ins__AttributeCategory__c eachCat : attrCatList) {
            if(eachCat.name =='In Network') {
                inNetworkId = eachCat.Id;
            } else if(eachCat.name =='Specialty Care Provider'){
                specialtyCareProvider = eachCat.Id;
            }else if(eachCat.name =='Primary Care Provider'){
                primaryCareProvider = eachCat.Id;
            }else if(eachCat.name =='Pharmacy Plan'){
                pharmacyPlan = eachCat.Id;
            }else if(eachCat.name =='Other Plan Details'){
                other = eachCat.Id;
            }else if(eachCat.name =='Vision Plan'){
                visionPlan = eachCat.Id;
            }else if(eachCat.name =='In Network Lvl2'){
                inNetworkLvl2Id = eachCat.Id;
            }else if(eachCat.name =='Urgent Care'){
                urgentCareId = eachCat.Id;
            }else if(eachCat.name =='Emergency Room'){
                emergencyRoomId = eachCat.Id;
            }
            if(eachCat.name =='Vision In Network') {
                inVisionNetworkId = eachCat.Id;
            } else if(eachCat.name =='Vision Other Plan Details'){
                otherVision = eachCat.Id;
            }
            else if(eachCat.name =='Vision Out of Network'){
                ooVisionNetworkId = eachCat.Id;
            }
            else if(eachCat.name =='Vision Plan Frequencies'){
                frequencyVision = eachCat.Id;
            }
        }
        List<vlocity_ins__Attribute__c> attrInsList = new List<vlocity_ins__Attribute__c>();
        vlocity_ins__Attribute__c testAttr = new vlocity_ins__Attribute__c();
        testAttr.name = 'In Network Coinsurance';
        testAttr.vlocity_ins__Code__c ='inn_defaultCoinsurance_inn';
        testAttr.vlocity_ins__DisplaySequence__c = 1;
        testAttr.vlocity_ins__AttributeCategoryId__c = inNetworkId; 
        attrInsList.add(testAttr);
        vlocity_ins__Attribute__c testAttr1 = new vlocity_ins__Attribute__c();
        testAttr1.name = 'Primary Care Provider';
        testAttr1.vlocity_ins__Code__c ='PCP_copayAmount_2_inn';
        testAttr1.vlocity_ins__DisplaySequence__c = 1;
        testAttr1.vlocity_ins__AttributeCategoryId__c = primaryCareProvider; 
        attrInsList.add(testAttr1);
        vlocity_ins__Attribute__c testAttr2 = new vlocity_ins__Attribute__c();
        testAttr2.name = 'Other Plan Details';
        testAttr2.vlocity_ins__Code__c ='OTHER_riderName';
        testAttr2.vlocity_ins__DisplaySequence__c = 6;
        testAttr2.vlocity_ins__AttributeCategoryId__c = other; 
        attrInsList.add(testAttr2);
        vlocity_ins__Attribute__c testAttr3 = new vlocity_ins__Attribute__c();
        testAttr3.name = 'Rx Plan Name';
        testAttr3.vlocity_ins__Code__c ='RXPLAN_rxPlanName';
        testAttr3.vlocity_ins__DisplaySequence__c = 1;
        testAttr3.vlocity_ins__AttributeCategoryId__c = pharmacyPlan; 
        attrInsList.add(testAttr3); 
        
        vlocity_ins__Attribute__c testAttr4 = new vlocity_ins__Attribute__c();
        testAttr4.name = 'Co Ins - Specialty Care Provider (INN)';
        testAttr4.vlocity_ins__Code__c ='SCP_coinsurancePercentage_12_inn';
        testAttr4.vlocity_ins__DisplaySequence__c = 1;
        testAttr4.vlocity_ins__AttributeCategoryId__c = inNetworkId; 
        attrInsList.add(testAttr4);
        
        vlocity_ins__Attribute__c testAttr5 = new vlocity_ins__Attribute__c();
        testAttr5.name = 'Master  Branding';
        testAttr5.vlocity_ins__Code__c ='OTHER_masterBrand';
        testAttr5.vlocity_ins__DisplaySequence__c = 1;
        testAttr5.vlocity_ins__AttributeCategoryId__c = other; 
        attrInsList.add(testAttr5); 
        
        vlocity_ins__Attribute__c testAttr6 = new vlocity_ins__Attribute__c();
        testAttr6.name = 'Urgent Care Plan';
        testAttr6.vlocity_ins__Code__c ='UCARE_coinsurancePercentage_33_oon1';
        testAttr6.vlocity_ins__DisplaySequence__c = 1;
        testAttr6.vlocity_ins__AttributeCategoryId__c = urgentCareId; 
        attrInsList.add(testAttr6); 
        vlocity_ins__Attribute__c testAttr7 = new vlocity_ins__Attribute__c();
        testAttr7.name = 'copayAmount.186.inn';
        testAttr7.vlocity_ins__Code__c ='VISION_INN_examcopay';
        testAttr7.vlocity_ins__DisplaySequence__c = 1;
        testAttr7.vlocity_ins__AttributeCategoryId__c = inVisionNetworkId; 
        attrInsList.add(testAttr7);
        vlocity_ins__Attribute__c testAttr8 = new vlocity_ins__Attribute__c();
        testAttr8.name = 'benefitLevelCode';
        testAttr8.vlocity_ins__Code__c ='VISION_OTHER_wgseyemedbenefitlevelcode';
        testAttr8.vlocity_ins__DisplaySequence__c = 1;
        testAttr8.vlocity_ins__AttributeCategoryId__c = otherVision; 
        attrInsList.add(testAttr8); 
        vlocity_ins__Attribute__c testAttr9 = new vlocity_ins__Attribute__c();
        testAttr9.name = 'copayAmount.186.oon';
        testAttr9.vlocity_ins__Code__c ='VISION_OON_examreimbursement';
        testAttr9.vlocity_ins__DisplaySequence__c = 1;
        testAttr9.vlocity_ins__AttributeCategoryId__c = ooVisionNetworkId; 
        attrInsList.add(testAttr9); 
        vlocity_ins__Attribute__c testAttr10 = new vlocity_ins__Attribute__c();
        testAttr10.name = 'examFrequencyDescription';
        testAttr10.vlocity_ins__Code__c ='VISION_frequency_exam';
        testAttr10.vlocity_ins__DisplaySequence__c = 1;
        testAttr10.vlocity_ins__AttributeCategoryId__c = frequencyVision; 
        attrInsList.add(testAttr10); 
        vlocity_ins__Attribute__c testAttr11 = new vlocity_ins__Attribute__c();
        testAttr11.name = 'Rider Paln Name';
        testAttr11.vlocity_ins__Code__c ='OTHER_riderName1';
        testAttr11.vlocity_ins__DisplaySequence__c = 1;
        testAttr11.vlocity_ins__AttributeCategoryId__c = other; 
        attrInsList.add(testAttr11); 
        insert attrInsList;
    }
    
    /**
    * This method covers
    * 1.Create prdouct/plans and attributes successfully for medical prod type
    * 2.Inactivate product based on status 
    * */
    @isTest static void testMedProductLoadForSuccess() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Pricebook2 testPriceBook = new Pricebook2(Id = Test.getStandardPricebookId(),isActive=true); 
        update testPriceBook  ;
        
        String reqBody = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.1","keys":{"productId":34188,"portfolioYear":2019,"effectiveDate":"2019-07-01",'+
            +'"productType":"medical"},"version":"3.1","productInfo":{"planAttributes":{"status":"Approved"},"productAttributes":{"fundingTypeId":2,"fundingTypeDescription":"FI",'+
            +'"branding":"LG 51+","networkName":"Anthem HealthSync","stateCode":"IN","quotedType":"Internal Only","networkType":"POS","productName":"Anthem HealthSync Options POS HSAs with Copays (3-Tier) Option E1 with Rx Option T12 (PrevRx)",'+
            +'"marketingStatus":"Marketed"},"networks":[{"deductibleSingle":2700,"networkLevelName":"In-Network","defaultCoinsurance":0},{"deductibleSingle":9000,"networkLevelName":"Non-Network","defaultCoinsurance":0.5}],'+
            +'"contractCodes":[{"contractCode":"46E9","alternateId":null,"effectiveDate":"2019-07-01","dateChanged":"02042019151121878","portfolioYear":2019,"adminstrationCodeType":"B","adminstrationCodeDescription":"Both PY/CY","hpcc":"HM96","pcpSelectionRequiredId":1,"pcpReferralRequiredFlag":"No","pcpSelectionRequiredDescription":"Yes",'+
            +'"productId":34188,"marketSegmentCode":"LG","marketSegment":"Large Group","state":"Indiana","stateCode":"IN","productName":"Anthem HealthSync Options POS HSAs with Copays (3-Tier) Option E1 with Rx Option T12 (PrevRx)","riderContractCodeId":258918,"riders":[{"riderId":1,"riderName":"Contraceptive"}],"healthWellnessInfo":{"clinicalEnterprisePlanId":21606,"clinicalEnterprisePlanName":"FI Foundational (HM96)"},'+
            +'"serviceAreas":[{"serviceAreaId":null,"serviceAreaName":null,"hiosComponentId":null,"variantContractCodeServiceAreaId":null}]},{"contractCode":null,"alternateId":null,"effectiveDate":"2019-07-01","dateChanged":"02042019151121878","portfolioYear":2019,"adminstrationCodeType":"B","adminstrationCodeDescription":"Both PY/CY","hpcc":null,"pcpSelectionRequiredId":1,"pcpReferralRequiredFlag":"No","pcpSelectionRequiredDescription":"Yes","productId":34188,"marketSegmentCode":"LG","marketSegment":"Large Group","state":"Indiana","stateCode":"IN","productName":"Anthem HealthSync Options POS HSAs with Copays (3-Tier) Option E1 with Rx Option T12 (PrevRx)","riderContractCodeId":258919,"riders":[{"riderId":22,"riderName":"ACA Religious Exemption"}],"healthWellnessInfo":{"clinicalEnterprisePlanId":21606,"clinicalEnterprisePlanName":"FI Foundational (HM96)"} ,"serviceAreas":[]},{"contractCode":null,"alternateId":null,"effectiveDate":"2019-07-01","dateChanged":"02042019151121878","portfolioYear":2019,"adminstrationCodeType":"B","adminstrationCodeDescription":"Both PY/CY","hpcc":null,"pcpSelectionRequiredId":1,"pcpReferralRequiredFlag":"No","pcpSelectionRequiredDescription":"Yes","productId":34188,"marketSegmentCode":"LG","marketSegment":"Large Group","state":"Indiana","stateCode":"IN","productName":"Anthem HealthSync Options POS HSAs with Copays (3-Tier) Option E1 with Rx Option T12 (PrevRx)","riderContractCodeId":258920,"riders":[{"riderId":4,"riderName":"Association/Alliance/Chamber"}],"healthWellnessInfo":{"clinicalEnterprisePlanId":21606,"clinicalEnterprisePlanName":"FI Foundational (HM96)"},"serviceAreas":[]}],"healthAccountInfo":{"cdhVendorName":"Anthem Act Wise"}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        testLoadAttributes('Medical');  
        
        List<vlocity_ins__AttributeCategory__c> attrCatList = [select id,Name,VLOCITY_INS__CODE__C from vlocity_ins__AttributeCategory__c];
        
        LGProductUploadService.doPost();
        List<Product2> existingProdRec = [Select id,Name,Category__c,ProductActive__c,HPCC_Code__c,Benefit_Period__c,Contract_code__c,Quoted_Status__c
                                          from Product2];
        System.debug('existingProdRec*******:' + existingProdRec);
        
        String childRecId;
        String parentRecId;
        String prodName;
        String planName;
        String planCat;
        String prodCat;
        String prodContractCode;
        Boolean prodActive;
        String hpPccCode;
        String benefitPeriod;
        String quotedStatus;
        for(Product2 prodRec : existingProdRec) {
            if(prodRec.Category__c=='Product') {
                parentRecId = prodRec.Id;
                prodName = prodRec.name;
                prodCat = prodRec.Category__c;
            } else if(prodRec.Category__c=='Plan'){
                childRecId = prodRec.Id;
                planName = prodRec.name;
                planCat = prodRec.Category__c;
                prodContractCode = prodRec.Contract_code__c;
                prodActive = prodRec.ProductActive__c;
                hpPccCode = prodRec.HPCC_Code__c;
                benefitPeriod=prodRec.Benefit_Period__c;
                quotedStatus =prodRec.Quoted_Status__c;
            }
        }
        System.debug('Existing Prod :'+existingProdRec.size());
        system.assertEquals(true, existingProdRec.size()==2);
        system.assertEquals(true,prodName== 'POS Anthem HealthSync');
        system.assertEquals(true,planName== 'Anthem HealthSync Options POS HSAs with Copays (3-Tier) Option E1 with Rx Option T12 (PrevRx)');
        system.assertEquals(true,planCat== 'Plan');
        system.assert(true,prodActive == true);
        system.assertEquals(true,prodCat== 'Product');
        system.debug('prodContractCode**********:' + prodContractCode);
        system.assertEquals(true,prodContractCode== '46E9');
        system.assertEquals(true,hpPccCode== 'HM96');
        system.assert(true,benefitPeriod == 'Both PY/CY');
        system.assertEquals(true,quotedStatus== 'Internal Only');
        
        List<vlocity_ins__AttributeAssignment__c> attrList = [select id,name,vlocity_ins__AttributeName__c,vlocity_ins__Value__c from vlocity_ins__AttributeAssignment__c];
        System.debug('attrList****:' + attrList);
        String otherPlanValue;
        String inNetworkCoinsurance;
        String primaryCare;
        String coInsSpecialtyCareProvider;
        for(vlocity_ins__AttributeAssignment__c currRec:attrList){
            if(currRec.vlocity_ins__AttributeName__c =='Other Plan Details' ){
                otherPlanValue = currRec.vlocity_ins__Value__c;
            }
            if(currRec.vlocity_ins__AttributeName__c =='Primary Care Provider' ){
                primaryCare = currRec.vlocity_ins__Value__c;
            }
            if(currRec.vlocity_ins__AttributeName__c =='In Network Coinsurance' ){
                inNetworkCoinsurance = currRec.vlocity_ins__Value__c;
            }
            if(currRec.vlocity_ins__AttributeName__c =='Co Ins - Specialty Care Provider (INN)'){
                coInsSpecialtyCareProvider = currRec.vlocity_ins__Value__c;
            }
            if(currRec.vlocity_ins__AttributeName__c =='Master  Branding'){
                coInsSpecialtyCareProvider = currRec.vlocity_ins__Value__c;
            }
            if(currRec.vlocity_ins__AttributeName__c =='Rx Plan Name'){
                coInsSpecialtyCareProvider = currRec.vlocity_ins__Value__c;
            }
        }
        System.assertEquals(inNetworkCoinsurance, '0');
        System.assertEquals(true, attrList.size()>0);
        LGProductUploadService.StatusDetails resBody = (LGProductUploadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGProductUploadService.StatusDetails.class);
        System.assertEquals(200, resBody.statusCode);
        System.assertEquals('Request processed successfully', resBody.statusMessage);
        
        // Updating exising record to set the ProductActive__c to false//
        //StaticResource srLGProd1 = [SELECT Id, Body FROM StaticResource WHERE Name = 'PMTProductJSONForFailureScenario_Test2' LIMIT 1];
        //String reqBody1 = srLGProd1.Body.toString();
        String reqBody1 = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.1","keys":{"productId":34188,"portfolioYear":2019,"effectiveDate":"2019-07-01","productType":"medical"},'+
            +'"version":"3.1","productInfo":{"planAttributes":{"status":"Approved"},"productAttributes":{"fundingTypeId":2,"fundingTypeDescription":"FI","branding":"LG 51+","networkName":'+
            +'"Anthem HealthSync","stateCode":"IN","quotedType":"Internal Only","networkType":"POS","productName":"Anthem HealthSync Options POS HSAs with Copays (3-Tier) Option E1 with Rx Option T12 (PrevRx)",'+
            +'"marketingStatus":"Marketed"},"networks":[{"deductibleSingle":2700,"networkLevelName":"In-Network","defaultCoinsurance":0},{"deductibleSingle":9000,"networkLevelName":"Non-Network",'+
            +'"defaultCoinsurance":0.5}],"contractCodes":[{"productId":34188,"portfolioYear":2019,"hpcc":"HM96","state":"Indiana","contractCode":"46E9","effectiveDate":"2020-01-01",'+
            +'"productName":"Anthem HealthSync Options POS HSAs with Copays (3-Tier) Option E1 with Rx Option T12 (PrevRx)","marketSegment":"Large Group"}],"healthAccountInfo":'+
            +'{"cdhVendorName":"Anthem Act Wise"}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody1);
        RestContext.request = req;
        RestContext.response= res;
        // testLoadAttributes();  
        LGProductUploadService.doPost();
        List<Product2> existingPlanRec = [Select id,Name,Category__c,ProductActive__c,HPCC_Code__c,Benefit_Period__c,Contract_code__c,Quoted_Status__c
                                          from Product2 where Category__c='Plan'];
        
        system.assert(true,existingPlanRec[0].ProductActive__c == false);
        Test.stopTest();
    }
    /**
    * In this test it will not create plan and attribues because 
    *  Product status != Approved and MarketingStaus!=Marketed but we are creating product
    * */
    @isTest static void testMedProductLoadWithoutPlans() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Pricebook2 testPriceBook = new Pricebook2(Id = Test.getStandardPricebookId(),isActive=true); 
        update testPriceBook  ;
        String reqBody = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.1","keys":{"productId":34188,"portfolioYear":2019,'+
            +'"effectiveDate":"2019-07-01","productType":"medical"},"version":"3.1","productInfo":{"hasSiteOfService":"No","planAttributes":'+
            +'{"status":"Rejected"},"hasFacilityTiering":"No","productNotes":null,"maternity":"Global","productAttributes":{"fundingTypeId":2,"fundingTypeDescription":"FI",'+
            +'"branding":"LG 51+","networkName":"Anthem HealthSync","stateCode":"IN","state":"Indiana","quotedType":"Internal Only","networkType":"POS","basePlanFlag":"No",'+
            +'"productName":"Anthem HealthSync Options POS HSAs with Copays (3-Tier) Option E1 with Rx Option T12 (PrevRx)","marketingStatus":"Not Marketed"}'+
            +',"networks":[{"deductibleSingle":2700,"networkLevelName":"In-Network","defaultCoinsurance":0}],"contractCodes":[{"contractCode":"46E9","effectiveDate":"2019-07-01"}],"healthAccountInfo":{"cdhProductType":"HSA"}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        testLoadAttributes('Medical');  
        
        LGProductUploadService.doPost();
        List<Product2> existingProdRec = [Select id,Name,Category__c,Contract_code__c from Product2];
        System.debug('existingProdRec*******:' + existingProdRec);
        String childRecId;
        String parentRecId;
        String prodName;
        String planName;
        String planCat;
        String prodCat;
        String prodContractCode;
        for(Product2 prodRec : existingProdRec) {
            if(prodRec.Category__c=='Product') {
                parentRecId = prodRec.Id;
                prodName = prodRec.name;
                prodCat = prodRec.Category__c;
            } else if(prodRec.Category__c=='Plan'){
                childRecId = prodRec.Id;
                planName = prodRec.name;
                planCat = prodRec.Category__c;
                prodContractCode = prodRec.Contract_code__c;
            }
        }
        System.debug('Existing Prod :'+existingProdRec.size());
        system.assertEquals(true, existingProdRec.size()==1);
        system.assertEquals(true,prodName== 'POS Anthem HealthSync HSA');
        system.assertEquals(true,planName== null);
        system.assertEquals(true,planCat== null);
        system.assertEquals(true,prodCat== 'Product');
        system.assertEquals(true,prodContractCode== null);
        List<vlocity_ins__AttributeAssignment__c> attrList = [select id,name from vlocity_ins__AttributeAssignment__c];
        system.debug('attrList.size()*******:' + attrList.size());
        System.assertEquals(true, attrList.size()==0);
        System.assertEquals(200, res.statusCode);
        Test.stopTest();
        
    }
    /**
    * Test Try catch with dummy JSON
    * */
    @isTest static void testProductUploadServiceCatch() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Pricebook2 testPriceBook = new Pricebook2(Id = Test.getStandardPricebookId(),isActive=true); 
        update testPriceBook  ;
        // StaticResource srLGProd = [SELECT Id, Body FROM StaticResource WHERE Name = 'PMTProductJSONWithoutContCodes_Test3' LIMIT 1];
        // String reqBody = srLGProd.Body.toString();
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        //req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        testLoadAttributes('Medical');  
        LGProductUploadService.doPost();
        LGProductUploadService.StatusDetails resBody = (LGProductUploadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGProductUploadService.StatusDetails.class);
        System.assertEquals(500, resBody.statusCode);
        System.assertEquals('Argument cannot be null.', resBody.statusMessage);
        Test.stopTest();
    }
    
    /**
    * When standard product is there for given CC, don't allow to create custom prodcut for the same CC
    * */
    @isTest static void testStanadardProduct() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Pricebook2 testPriceBook = new Pricebook2(Id = Test.getStandardPricebookId(),isActive=true); 
        update testPriceBook  ;
        String reqBody = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.2","keys":{"productId":29829,"quoteLineItemID":"","portfolioYear":2019,"contractCode":"Q8NK","effectiveDate":"2019-07-01",'+
            +'"productType":"MEDICAL"},"P2APlanType":"standard","productInfo":{"planAttributes":{"marketSegmentCode":"LG","status":"Approved"},"productAttributes":{"fundingTypeDescription":"FI ",'+
            +'"configPlatformCode":"","branding":"LG 100+","networkName":"PPO","masterBrand":"Anthem","isNew":"","quotedType":"Internal Only","productName":"CITY OF SOUTH FULTON - GA9472 - RENEWAL - CHANDRA",'+
            +'"marketingStatus":"Marketed","fundingTypeId":"","quotedTypeId":"","networkId":"","stateCode":"GA","state":"","networkType":"PPO"},"networks":[{"deductibleSingle":1500,"networkLevelName":"In-Network","defaultCoinsurance":0}],'+
            +'"contractCodes":[{"dateChanged":"","marketSegmentCode":"","productId":"","pcpSelectionRequiredId":"","adminstrationCodeType":"","productName":"CITY OF SOUTH FULTON - GA9472 - RENEWAL - Chandra- Q8CE - NS HSAOAP3B 1.5K/10 3K",'+
            +'"alternateId":"","pcpReferralRequiredFlag":"","portfolioYear":"","pcpSelectionRequiredDescription":"","adminstrationCodeDescription":"CY","hpcc":"HFBS","stateCode":"","state":"","contractCode":"Q8NK","effectiveDate":"2019-07-01","marketSegment":""}],"healthAccountInfo":{"cdhProductType":"HSA"}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        testLoadAttributes('Medical');  
        
        LGProductUploadService.doPost();
        
        String reqBody1 = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.2","keys":{"productId":29829,"quoteLineItemID":"","portfolioYear":2019,"contractCode":"Q8NK","effectiveDate":"2019-07-01",'+
            +'"productType":"MEDICAL"},"P2APlanType":"custom","productInfo":{"hasSiteOfService":"","planAttributes":{"marketSegmentCode":"LG","status":"Approved"},"hasFacilityTiering":"","productNotes":"",'+
            +'"pharmacyPlan":{"pharmacyPlanInfo":{"rxPlanName":"10% D-50"}},"productAttributes":{"brandingId":"","fundingTypeDescription":"FI ","branding":"LG 100+","networkName":"PPO","quotedTypeId":"","networkId":"",'+
            +'"stateCode":"GA","state":"","quotedType":"Internal Only","networkType":"PPO","productName":"CITY OF SOUTH FULTON - GA9472 - RENEWAL - 01/01/2019 - Q8CE - NS HSAOAP3B 1.5K/10 3K","marketingStatus":"Marketed"},'+
            +'"networks":[{"deductibleSingle":1500,"networkLevelName":"In-Network","defaultCoinsurance":0}],"contractCodes":[{"dateChanged":"","marketSegmentCode":"","productId":"","productName":"CITY OF SOUTH FULTON - GA9472 - RENEWAL - 01/01/2019 - Q8CE - NS HSAOAP3B 1.5K/10 3K",'+
            +'"alternateId":"","pcpReferralRequiredFlag":"","portfolioYear":"","pcpSelectionRequiredDescription":"","adminstrationCodeDescription":"CY","hpcc":"HFBS","riderContractCodeId":"","healthWellnessInfo":{"clinicalEnterprisePlanId":"","clinicalEnterprisePlanName":""},'+
            +'"stateCode":"","state":"","contractCode":"Q8NK","effectiveDate":"2019-07-01","marketSegment":""}],"healthAccountInfo":{"cdhProductType":"HSA"}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody1);
        RestContext.request = req;
        RestContext.response= res;
        LGProductUploadService.doPost();
        LGProductUploadService.StatusDetails resBody = (LGProductUploadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGProductUploadService.StatusDetails.class);
        System.assert(resBody.statusMessage=='Invalid plan type -<<Modified>>, as there is already a standard product exists for contract code: Q8NK'); 
        Test.stopTest();
    }
    
    /**
    * If prod type!= Medical or vision, then throw an exception
    * */
    @isTest static void testInvalidProductType() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Pricebook2 testPriceBook = new Pricebook2(Id = Test.getStandardPricebookId(),isActive=true); 
        update testPriceBook  ;
        String reqBody = '{"product":{"keys":{"productId":2486,"effectiveDate":"2020-01-01","portfolioYear":2020,"productType":"vision11"}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        testLoadAttributes('Vision');  
        LGProductUploadService.doPost();
        LGProductUploadService.StatusDetails resBody = (LGProductUploadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGProductUploadService.StatusDetails.class);
        System.assertEquals(400, resBody.statusCode);
        System.assertEquals('Invalid Product Type:vision11',resBody.statusMessage,'invalid product type');
        Test.stopTest();
    }
    /**
    * If Request doesnt have Contract codes for medical prod type, then show error message
    * */
    @isTest static void testNoContractCodesMedical() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Pricebook2 testPriceBook = new Pricebook2(Id = Test.getStandardPricebookId(),isActive=true); 
        update testPriceBook  ;
        String reqBody = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.1","keys":{"productId":34188,"portfolioYear":2019,"effectiveDate":"2020-01-01","productType":"medical"},'+
            +'"version":"3.1","productInfo":{"planAttributes":{"status":"Approved"},"productAttributes":{"fundingTypeId":2,"fundingTypeDescription":"FI","branding":"LG 51+","networkName":"Anthem HealthSync",'+
            +'"stateCode":"IN","quotedType":"Internal Only","networkType":"POS","productName":"Anthem HealthSync Options POS HSAs with Copays (3-Tier) Option E1 with Rx Option T12 (PrevRx)","marketingStatus":"Marketed"},'+
            +'"networks":[{"deductibleSingle":2700,"networkLevelName":"In-Network","defaultCoinsurance":0},{"deductibleSingle":9000,"networkLevelName":"Non-Network","defaultCoinsurance":0.5}],'+
            +'"contractCodes":[],"healthAccountInfo":{"cdhVendorName":"Anthem Act Wise"}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        testLoadAttributes('Medical');  
        
        LGProductUploadService.doPost();
        
        LGProductUploadService.StatusDetails resBody = (LGProductUploadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGProductUploadService.StatusDetails.class);
        System.assertEquals(400, resBody.statusCode);
        System.assertEquals('No contract codes part of request',resBody.statusMessage);
        Test.stopTest();
    }
    /**
    * If Request doesnt have Contract codes for vison prod type, then show error message
    * */
    @isTest static void testNoContractCodesVision() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Pricebook2 testPriceBook = new Pricebook2(Id = Test.getStandardPricebookId(),isActive=true); 
        update testPriceBook  ;
        String reqBody = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.4","keys":{"productId":2486,"portfolioYear":2020,"effectiveDate":"2020-01-01","productType":"vision"},'+
            +'"publishAttributes":{"type":"internal","transactionId":"2486VISION09202019081002670","timestamp":9202019081010360},"version":"3.4","productInfo":{"contractCodes":[],"visionPlan":{"planAttributes":{},'+
            +'"benefitDetails":[]}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        testLoadAttributes('Vision');  
        LGProductUploadService.doPost();
        LGProductUploadService.StatusDetails resBody = (LGProductUploadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGProductUploadService.StatusDetails.class);
        System.assertEquals(400, resBody.statusCode);
        System.assertEquals('No local business contract codes part of request',resBody.statusMessage);
        Test.stopTest();
    }
    
    /**
    * This method covers
    * 1.Created prdouct/plans and attributes successfully for Vision Prod Type
    * 2.Inactivate product based on status 
    * */
    @isTest static void testVisionProductLoadForSuccess() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        //StaticResource srLGProd = [SELECT Id, Body FROM StaticResource WHERE Name = 'PMTProductJSONForVisionProdScenario_Test8' LIMIT 1];
        Pricebook2 testPriceBook = new Pricebook2(Id = Test.getStandardPricebookId(),isActive=true); 
        update testPriceBook  ;
  
        
        String reqBody = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.4","keys":{"productId":2486,"portfolioYear":2020,"effectiveDate":"2020-01-01","productType":"vision"},'+
            +'"productInfo":{"contractCodes":[{"brandingId":22,"fundingId":2,"marketSegmentCode":"LG","internalPlanName":"EX.A.0 ","brandingDescription":"Anthem BC","marketingStatusCode":5,'+
            +'"productName":"EX.A.0 Vision","contractCodeId":21665,"marketingStatus":"Marketed","customPlanFlag": "No","network":"Blue View Vision","alternateId":"9999","businessUnitDescription":"Local","networkId":'+
            +'215,"stateCode":"CA","state":"California","termDate":null,"contractCode":"4T4L","fundingDescription":"Fully Insured","effectiveDate":"2020-01-01","marketSegment":"Large Group"}],'+
            +'"visionPlan":{"planAttributes":{"statusCodeId":24,"planDesc":"","inLieuOfDescription":"Lenses","planName":"EX.A.0","planTypeId":2,"newSalesEndDate":null,"isMyopiaCoveredId":1,'+
            +'"portfolioYear":2020,"marketSegment":"Large Group","marketSegmentCode":"LG","planType":"Exam Only","planSubType":"Standard","decliningBalanceId":0,"internalPlanTypeDescription":'+
            +'"Standalone Vision","administrationTypeDescription":"Calendar Year","decliningBalanceDescription":"N/A","isMyopiaCoveredDescription":"No","planCode":"EX.A.0_Standard",'+
            +'"eyeMedBenefitDescription":"Exam Only","administrationTypeCode":"CY","postCataractCoverageId":0,"eyeMedBenefitDescriptionCode":"C","status":"Approved","materialExclusionRuleDescription":'+
            +'"Lenses","postCataractCoverageDescription":"Not Applicable"},"benefitDetails":[{"benefitCategories":[{"benefits":[{"benefitName":"Exam","benefitId":186,"networks":[{"quantity":null,'+
            +'"copayAmount":666,"quantityUnitName":"Not Applicable","isFiled":"Yes","networkLevelCode":"INN","networkLevelName":"In-Network","costShareType":"Copay","quantityUnitCode":"NA",'+
            +'"specialInstructions":null,"limitComments":null,"interval":"NA","intervalName":"Not Applicable","costShareTypeId":12},{"networkLevelCode":"OON","networkLevelName":"Non-Network","costShareTypeId":35,"costShareType":"Reimbursed Up To","copayAmount":42,"quantity":null,"quantityUnitCode":"NA","quantityUnitName":"Not Applicable","interval":"NA","intervalName":"Not Applicable","limitComments":null,"specialInstructions":null,"isFiled":"Yes"}]}],"benefitCategoryName":"Exam","benefitCategoryId":16}],'+
            +'"coverageLevelCode":"C","coverageLevelDescription":"Combined"}]}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        testLoadAttributes('Vision');  
        LGProductUploadService.doPost();
        List<Product2> existingProdRec = [Select id,Name,Category__c,ProductActive__c,HPCC_Code__c,Benefit_Period__c,Contract_code__c,Quoted_Status__c
                                          from Product2];
        System.debug('existingProdRec*******:' + existingProdRec);
        
        system.assertEquals(true,existingProdRec[0].name == 'EX.A.0 Vision');
        system.assertEquals(true,existingProdRec[0].Category__c== 'Plan');
        system.assert(true,existingProdRec[0].ProductActive__c == true);
        system.assertEquals(true,existingProdRec[0].Contract_code__c== '4T4L');
        
        List<vlocity_ins__AttributeAssignment__c> attrList = [select id,name,vlocity_ins__AttributeName__c,vlocity_ins__Value__c from vlocity_ins__AttributeAssignment__c];
        System.debug('attrList****:' + attrList);
        String inCopayAmount;
        String otherBenefitLevelCode;
        String oonCopayAmount;
        String examFrequency;
        for(vlocity_ins__AttributeAssignment__c currRec:attrList){
            if(currRec.vlocity_ins__AttributeName__c =='copayAmount.186.inn' ){
                inCopayAmount = currRec.vlocity_ins__Value__c;
            }
            if(currRec.vlocity_ins__AttributeName__c =='benefitLevelCode' ){
                otherBenefitLevelCode = currRec.vlocity_ins__Value__c;
            }
            if(currRec.vlocity_ins__AttributeName__c =='copayAmount.186.oon' ){
                oonCopayAmount = currRec.vlocity_ins__Value__c;
            }
            if(currRec.vlocity_ins__AttributeName__c =='examFrequencyDescription' ){
                examFrequency = currRec.vlocity_ins__Value__c;
            }
        }
        System.assertEquals('666', inCopayAmount);
        LGProductUploadService.StatusDetails resBody = (LGProductUploadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGProductUploadService.StatusDetails.class);
        System.assertEquals(200, resBody.statusCode);
        System.assertEquals('Request processed successfully', resBody.statusMessage);
        // Updating exising record to set the ProductActive__c to false//
        //StaticResource srLGProd1 = [SELECT Id, Body FROM StaticResource WHERE Name = 'PMTProductJSONForVisionProdScenario_Test8' LIMIT 1];
        //String reqBody1 = srLGProd1.Body.toString();
        String reqBody1 = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.4","keys":{"productId":2486,"portfolioYear":2020,"effectiveDate":"2020-01-01","productType":"vision"},'+
            +'"productInfo":{"contractCodes":[{"brandingId":22,"fundingId":2,"marketSegmentCode":"LG","internalPlanName":"EX.A.0 ","brandingDescription":"Anthem BC","marketingStatusCode":5,'+
            +'"productName":"EX.A.0 Vision","contractCodeId":21665,"marketingStatus":"Marketed","customPlanFlag": "No","network":"Blue View Vision","alternateId":"9999","businessUnitDescription":"Local","networkId":'+
            +'215,"stateCode":"CA","state":"California","termDate":null,"contractCode":"4T4L","fundingDescription":"Fully Insured","effectiveDate":"2020-01-01","marketSegment":"Large Group"}],'+
            +'"visionPlan":{"planAttributes":{"statusCodeId":24,"planDesc":"","inLieuOfDescription":"Lenses","planName":"EX.A.0","planTypeId":2,"newSalesEndDate":null,"isMyopiaCoveredId":1,'+
            +'"portfolioYear":2020,"marketSegment":"Large Group","marketSegmentCode":"LG","planType":"Exam Only","planSubType":"Standard","decliningBalanceId":0,"internalPlanTypeDescription":'+
            +'"Standalone Vision","administrationTypeDescription":"Calendar Year","decliningBalanceDescription":"N/A","isMyopiaCoveredDescription":"No","planCode":"EX.A.0_Standard",'+
            +'"eyeMedBenefitDescription":"Exam Only","administrationTypeCode":"CY","postCataractCoverageId":0,"eyeMedBenefitDescriptionCode":"C","status":"Rejected","materialExclusionRuleDescription":'+
            +'"Lenses","postCataractCoverageDescription":"Not Applicable"},"benefitDetails":[{"benefitCategories":[{"benefits":[{"benefitName":"Exam","benefitId":186,"networks":[{"quantity":null,'+
            +'"copayAmount":666,"quantityUnitName":"Not Applicable","isFiled":"Yes","networkLevelCode":"INN","networkLevelName":"In-Network","costShareType":"Copay","quantityUnitCode":"NA",'+
            +'"specialInstructions":null,"limitComments":null,"interval":"NA","intervalName":"Not Applicable","costShareTypeId":12},{"networkLevelCode":"OON","networkLevelName":"Non-Network","costShareTypeId":35,"costShareType":"Reimbursed Up To","copayAmount":42,"quantity":null,"quantityUnitCode":"NA","quantityUnitName":"Not Applicable","interval":"NA","intervalName":"Not Applicable","limitComments":null,"specialInstructions":null,"isFiled":"Yes"}]}],"benefitCategoryName":"Exam","benefitCategoryId":16}],'+
            +'"coverageLevelCode":"C","coverageLevelDescription":"Combined"}]}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody1);
        RestContext.request = req;
        RestContext.response= res;
        //update product to inactive
        LGProductUploadService.doPost();
        List<Product2> existingPlanRecList = [Select id,Name,Category__c,ProductActive__c,vlocity_ins__EffectiveDate__c,HPCC_Code__c,Benefit_Period__c,Contract_code__c,Quoted_Status__c
                                              from Product2 where Category__c='Plan'];
        system.debug('existingPlanRec***:' + existingPlanRecList);
        System.assertEquals(false, existingPlanRecList[0].ProductActive__c, 'Updated Product Active to False');
        Test.stopTest();
    }
    
    //update eff date for existing product
    @isTest static void testVisionProductLoadUpdateEndDate() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Pricebook2 testPriceBook = new Pricebook2(Id = Test.getStandardPricebookId(),isActive=true); 
        update testPriceBook  ;
        String reqBody = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.4","keys":{"productId":2486,"portfolioYear":2020,"effectiveDate":"2020-01-01","productType":"vision"},'+
            +'"productInfo":{"contractCodes":[{"brandingId":22,"fundingId":2,"marketSegmentCode":"LG","internalPlanName":"EX.A.0 ","brandingDescription":"Anthem BC","marketingStatusCode":5,'+
            +'"productName":"EX.A.0 Vision","contractCodeId":21665,"marketingStatus":"Marketed","customPlanFlag": "No","network":"Blue View Vision","alternateId":"9999","businessUnitDescription":"Local","networkId":'+
            +'215,"stateCode":"CA","state":"California","termDate":null,"contractCode":"4T4L","fundingDescription":"Fully Insured","effectiveDate":"2020-01-01","marketSegment":"Large Group"}],'+
            +'"visionPlan":{"planAttributes":{"statusCodeId":24,"planDesc":"","inLieuOfDescription":"Lenses","planName":"EX.A.0","planTypeId":2,"newSalesEndDate":null,"isMyopiaCoveredId":1,'+
            +'"portfolioYear":2020,"marketSegment":"Large Group","marketSegmentCode":"LG","planType":"Exam Only","planSubType":"Standard","decliningBalanceId":0,"internalPlanTypeDescription":'+
            +'"Standalone Vision","administrationTypeDescription":"Calendar Year","decliningBalanceDescription":"N/A","isMyopiaCoveredDescription":"No","planCode":"EX.A.0_Standard",'+
            +'"eyeMedBenefitDescription":"Exam Only","administrationTypeCode":"CY","postCataractCoverageId":0,"eyeMedBenefitDescriptionCode":"C","status":"Approved","materialExclusionRuleDescription":'+
            +'"Lenses","postCataractCoverageDescription":"Not Applicable"},"benefitDetails":[{"benefitCategories":[{"benefits":[{"benefitName":"Exam","benefitId":186,"networks":[{"quantity":null,'+
            +'"copayAmount":666,"quantityUnitName":"Not Applicable","isFiled":"Yes","networkLevelCode":"INN","networkLevelName":"In-Network","costShareType":"Copay","quantityUnitCode":"NA",'+
            +'"specialInstructions":null,"limitComments":null,"interval":"NA","intervalName":"Not Applicable","costShareTypeId":12},{"networkLevelCode":"OON","networkLevelName":"Non-Network","costShareTypeId":35,"costShareType":"Reimbursed Up To","copayAmount":42,"quantity":null,"quantityUnitCode":"NA","quantityUnitName":"Not Applicable","interval":"NA","intervalName":"Not Applicable","limitComments":null,"specialInstructions":null,"isFiled":"Yes"}]}],"benefitCategoryName":"Exam","benefitCategoryId":16}],'+
            +'"coverageLevelCode":"C","coverageLevelDescription":"Combined"}]}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        testLoadAttributes('Vision');  
        
        LGProductUploadService.doPost();
        List<Product2> existingProdRec = [Select id,Name,Category__c,vlocity_ins__EffectiveDate__c,ProductActive__c,HPCC_Code__c,Benefit_Period__c,Contract_code__c,Quoted_Status__c
                                          from Product2];
        System.debug('existingProdRec*******:' + existingProdRec);
        
        LGProductUploadService.StatusDetails resBody = (LGProductUploadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGProductUploadService.StatusDetails.class);
        System.assertEquals(200, resBody.statusCode);
        System.assertEquals('Request processed successfully', resBody.statusMessage);
        // Updating exising record to set the end date //
       String reqBody1 = '{"product":{"$schema":"https://pmt.anthem.com/bpi/IngestionSchemas/3.4","keys":{"productId":2486,"portfolioYear":2020,"effectiveDate":"2020-01-01","productType":"vision"},'+
            +'"productInfo":{"contractCodes":[{"brandingId":22,"fundingId":2,"marketSegmentCode":"LG","internalPlanName":"EX.A.0 ","brandingDescription":"Anthem BC","marketingStatusCode":5,'+
            +'"productName":"EX.A.0 Vision","contractCodeId":21665,"marketingStatus":"Marketed","customPlanFlag": "No","network":"Blue View Vision","alternateId":"9999","businessUnitDescription":"Local","networkId":'+
            +'215,"stateCode":"CA","state":"California","termDate":null,"contractCode":"4T4L","fundingDescription":"Fully Insured","effectiveDate":"2020-01-10","marketSegment":"Large Group"}],'+
            +'"visionPlan":{"planAttributes":{"statusCodeId":24,"planDesc":"","inLieuOfDescription":"Lenses","planName":"EX.A.0","planTypeId":2,"newSalesEndDate":null,"isMyopiaCoveredId":1,'+
            +'"portfolioYear":2020,"marketSegment":"Large Group","marketSegmentCode":"LG","planType":"Exam Only","planSubType":"Standard","decliningBalanceId":0,"internalPlanTypeDescription":'+
            +'"Standalone Vision","administrationTypeDescription":"Calendar Year","decliningBalanceDescription":"N/A","isMyopiaCoveredDescription":"No","planCode":"EX.A.0_Standard",'+
            +'"eyeMedBenefitDescription":"Exam Only","administrationTypeCode":"CY","postCataractCoverageId":0,"eyeMedBenefitDescriptionCode":"C","status":"Approved","materialExclusionRuleDescription":'+
            +'"Lenses","postCataractCoverageDescription":"Not Applicable"},"benefitDetails":[{"benefitCategories":[{"benefits":[{"benefitName":"Exam","benefitId":186,"networks":[{"quantity":null,'+
            +'"copayAmount":666,"quantityUnitName":"Not Applicable","isFiled":"Yes","networkLevelCode":"INN","networkLevelName":"In-Network","costShareType":"Copay","quantityUnitCode":"NA",'+
            +'"specialInstructions":null,"limitComments":null,"interval":"NA","intervalName":"Not Applicable","costShareTypeId":12},{"networkLevelCode":"OON","networkLevelName":"Non-Network","costShareTypeId":35,"costShareType":"Reimbursed Up To","copayAmount":42,"quantity":null,"quantityUnitCode":"NA","quantityUnitName":"Not Applicable","interval":"NA","intervalName":"Not Applicable","limitComments":null,"specialInstructions":null,"isFiled":"Yes"}]}],"benefitCategoryName":"Exam","benefitCategoryId":16}],'+
            +'"coverageLevelCode":"C","coverageLevelDescription":"Combined"}]}}}}';
        req.requestURI = '/services/apexrest/LGProductUploadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody1);
        RestContext.request = req;
        RestContext.response= res;
        LGProductUploadService.doPost();
        List<Product2> existingPlanRecList = [Select id,Name,Category__c,ProductActive__c,vlocity_ins__EffectiveDate__c,HPCC_Code__c,Benefit_Period__c,Contract_code__c,Quoted_Status__c,vlocity_ins__EndDate__c
                                              from Product2 ];
        system.debug('existingPlanRec***:' + existingPlanRecList);
        for(Product2 eachPlan : existingPlanRecList){
            if(eachPlan.Id == existingProdRec[0].Id ){
                  System.assertEquals(date.valueOf('2020-01-09'), eachPlan.vlocity_ins__EndDate__c, 'Updated End Date for Plan');
            }else {
                  System.assertEquals(date.valueOf('2020-01-10'), eachPlan.vlocity_ins__EffectiveDate__c, 'Created new Plan');
            }
        }
            Test.stopTest();
    }
}