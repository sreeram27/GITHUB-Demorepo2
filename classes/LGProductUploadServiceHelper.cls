/**
* @Description:This class is to create products,plans and plan attributes for Standard and custom CCs
* Using without sharing keyword because API user profile may not have access for all objects/fields/rules.
* Hence we need to run all our jobs/processes in system context to make sure data is brought down for all object/fields values.
* **/
public without sharing class LGProductUploadServiceHelper {
    Static Set<String> benefitIds = new Set<String>();
    Static Set<String> benefitCategoryIds = new Set<String>();
    Static Set<String> jSONPaths = new Set<String>();
    Static Set<String> attributeCodes = new Set<String>();
    Static Set<String> attributeCategoryCodes = new Set<String>();
    Static Map<String,String> jSONtoAttributeMap = new Map<String,String>(); 
    Static Map<String,vlocity_ins__Attribute__c> vlocityAttributeMap = new Map<String,vlocity_ins__Attribute__c>();
    Static List<LG_Product_Load_Mapping__c> prodAttrmdtlist ;
    Static Map<String,LG_Product_Load_Mapping__c> prodAttrmdtMap = new Map<String,LG_Product_Load_Mapping__c>();
    Static Set<String> listTypeAttributes = new Set<String>();
    List<vlocity_ins__AttributeAssignment__c> attributeAssignmentList  ;
    Map<String,vlocity_ins__AttributeAssignment__c> attributeAssignmentMap ;
    List<vlocity_ins__AttributeAssignment__c> attributeAssignmentUpsertList ;
    Map<String,List<String>> listTypeAttributesMap ;
    Id prodId;
    String contCode;
    static final String PLAN_TYPE = 'Standard';
    static final String PLAN_TYPE_MODIFIED = 'Modified';
    //List<ID> planIdList = new List<ID>();
    //Map<String,Object> productJSONMap;
    
    static final String CATEGORY_PRODUCT = 'Product'; 
    static final String CATEGORY_PLAN = 'Plan';
    Static final ID planRecId = (ID)[select id from RecordType where SobjectType = 'product2' and name = 'product'][0].id;
    //START - Added as part of vision plan 
    static final String VISION_PRODUCT = 'Vision'; 
    static final String MEDICAL_PRODUCT = 'Medical'; 
    static final String INN_NOT_COVERED = 'Not Covered';
	static final String NETWORK_LEVEL_CODE_INN = 'INN';
	static final String COST_SHARE_TYPE_ALLOWANCE = 'Allowance';
    static final String COST_SHARE_TYPE_COPAY = 'Copay';
	static final String ISFiled = 'Yes';
    //END - Added as part of vision plan 
    public  StatusDetails loadProductData( String pmtJSONStr){
        StatusDetails resStatus = new StatusDetails();
        Map<String,Object> productJSONMap =    (Map<String,Object>) JSON.deserializeUntyped(pmtJSONStr);
        Map<String,Object> products =  (Map<String,Object>)productJSONMap.get('product');
        Map<String,Object> keysMap = (Map<String,Object>)products.get('keys');
        String productType= (String)keysMap.get('productType');
        if(productType.equalsIgnoreCase('MEDICAL')){
            resStatus = loadMedicalProduct(productJSONMap);
        }else if(productType.equalsIgnoreCase('VISION')){
            system.debug('in vision prod-------------');
            resStatus = loadVisionProduct(productJSONMap);
        }else {
            resStatus.statusMessage='Invalid Product Type:'+productType;
            resStatus.statusCode=1;
            return resStatus;
        }
        return resStatus;
    }
    
    public  StatusDetails loadMedicalProduct( Map<String,Object> productJSONMap) {
        loadMetaData(MEDICAL_PRODUCT);
        StatusDetails resStatus = new StatusDetails();
        Integer productId;
        String prodEffectivedate;
        Integer portfolioYear;
        String productType;
        String networkType;
        String networkName;
        String cdhProductType;
        String fundingType;
        String productName;
        String state;
        String marketingStatus;
        String quotedType;
        String productStatus;
        String planType;
        String p2aPlanType;
        //String externalId ='PMT_';
        Boolean status=true;
        Double deductibleSingle;
        Double defaultCoinsurance;
        String qliId;
        String branding;
        List<Product2> prodInsert = new List<Product2>();
        List<Product2> prodContractUpsert = new List<Product2>();
        List<Product2> prodUpdate= new List<Product2>();
        /*Id priceBookId = !Test.isRunningTest() ? [select name, isactive from Pricebook2 where IsStandard = true limit 1].Id : Test.getStandardPricebookId();
*/
        Id priceBookId = [select name, isactive from Pricebook2 where IsStandard = true limit 1].Id;
        
        //Map<String,Object> productJSONMap =    (Map<String,Object>) JSON.deserializeUntyped(pmtJSONStr);
        
        Map<String,Object> products =  (Map<String,Object>)productJSONMap.get('product');
        p2aPlanType= (String)products.get('P2APlanType');
        planType='Standard';
        if(p2aPlanType!= null && p2aPlanType !=''){
            if(p2aPlanType=='standard'){
                planType='Standard';
            }else if(p2aPlanType == 'custom'){
                planType ='Modified';
            }
        }
        Map<String,Object> keysMap = (Map<String,Object>)products.get('keys');
        
        //qliId = (String)keysMap.get('quoteLineItemID');
        qliId=null;
        productId = (Integer)keysMap.get('productId');
        prodEffectivedate = (String)keysMap.get('effectiveDate');
        portfolioYear=  (Integer)keysMap.get('portfolioYear');
        productType= (String)keysMap.get('productType');
        
        
        Map<String,Object> productInfo = (Map<String,Object>)products.get('productInfo');
        Map<String,Object> productAttributes = (Map<String,Object>)productInfo.get('productAttributes');
        fundingType = (String)productAttributes.get('fundingTypeDescription');
        state = (String)productAttributes.get('stateCode');
        networkType = (String)productAttributes.get('networkType');
        networkName = (String)productAttributes.get('networkName');
        marketingStatus = (String)productAttributes.get('marketingStatus');
        quotedType = (String)productAttributes.get('quotedType');
        Map<String,Object> planAttributes = (Map<String,Object>)productInfo.get('planAttributes');
        productStatus = (String)planAttributes.get('status');
        branding = (String)productAttributes.get('branding');	
        Map<String,Object> healthAccountInfo = (Map<String,Object>)productInfo.get('healthAccountInfo');
        cdhProductType = (String)healthAccountInfo.get('cdhProductType');
        
        productName =networkType;
        if(networkName!=null && networkName !='')
            productName =networkType+' '+networkName;
        if(cdhProductType!= null && cdhProductType!='' && !cdhProductType.equalsIgnoreCase('None') )
            productName =productName +' '+cdhProductType;
        Object conntractCodesObj = productInfo.get('contractCodes');
        List<Object> conntractCodes;
        if (conntractCodesObj instanceOf Map<String,Object>){
            conntractCodes = new List<Object>();
            conntractCodes.add(conntractCodesObj);
        }else{
            conntractCodes = (List<Object>)conntractCodesObj;
        }
        Map<String,String> conCodeEffDateMap = new Map<String,String>();
        Set<String> concodeSet = new Set<String>();
        if(conntractCodes!= null){
            for(Object eachConcode : conntractCodes){
                Map<String,Object> contractCodeMap = (Map<String,Object>)eachConcode;
                String conCode = (String)contractCodeMap.get('contractCode');
                String effDate = (String)contractCodeMap.get('effectiveDate');
                if(conCode !=null && conCode!=''){
                    concodeSet.add(conCode);
                }
                if(conCode !=null && conCode!='' && effDate!= null) {
                    conCodeEffDateMap.put(conCode,effDate);
                }
            }    
        }
        
        
        if(concodeSet.size()==0) {
            resStatus.statusMessage='No contract codes part of request';
            resStatus.statusCode=1;
            return resStatus;
        }
        //check if already standard product available for this CC
        if(planType == PLAN_TYPE_MODIFIED){
            List<Product2> stdProdRecList = [SELECT id,Name, Contract_Code__c
                                             FROM Product2 
                                             WHERE Contract_Code__c = :concodeSet and plan_type__c =: PLAN_TYPE];
            if(stdProdRecList!= null && stdProdRecList.size()>0){
                resStatus.statusMessage='Invalid plan type -<<Modified>>, as there is already a standard product exists for contract code: ' + stdProdRecList[0].Contract_Code__c ;
                resStatus.statusCode=1;
                return resStatus;
            }
        } 
        
        // Check if record is already exists for the combination?
        if(conntractCodes.size()>0) {
            Product2 updateProd;
            List<Product2> existingProdRec = [Select id,Name,isActive from Product2 where Name =: productName and Market__c = :state  
                                              and vlocity_ins__MarketSegment__c='Large Group' and Category__c= :CATEGORY_PRODUCT
                                              ORDER BY isActive desc ];
            if(existingProdRec.size()>0){
                updateProd =existingProdRec[0];
                updateProd.Name=productName;
                updateProd.Category__c=CATEGORY_PRODUCT;
                updateProd.Product_Family__c=networkType;
                updateProd.Market__c=state;
                updateProd.vlocity_ins__MarketSegment__c = 'Large Group';
                updateProd.ProductActive__c = true;
                updateProd.Network__c=networkName;
                updateProd.productCode=productName;
                updateProd.Product_Type__c=productType;
                updateProd.LOB__c =productType;
                updateProd.QLIRecordType__c='LocalType';
                updateProd.IsActive=true;
                //updateProd.Portfolio_Year__c
                prodUpdate.add(updateProd);
            }else{
                Product2 prodRec = new Product2(Name=productName,Category__c=CATEGORY_PRODUCT ,Product_Family__c=networkType,
                                                Market__c=state,vlocity_ins__MarketSegment__c = 'Large Group',
                                                LOB__c= productType, Product_Type__c=productType, ProductActive__c = true,Network__c=networkName, productCode=productName,
                                                isActive=true);
                prodInsert.add(prodRec);
            }
        }
        system.debug('prodInsert**********:' + prodInsert);
        String prodParentId;
        if(prodInsert.size()>0) {
            List<Database.SaveResult> res = Database.insert(prodInsert,true);
            prodParentId =prodInsert[0].id;
            PricebookEntry priceBookEntryRec = new PricebookEntry(Pricebook2Id = priceBookId, Product2Id = prodInsert[0].id,
                                                                  UnitPrice = 1, IsActive = true);
            insert priceBookEntryRec;
        }
        system.debug('prodUpdate**********:' + prodUpdate);
        
        if(prodUpdate.size()>0) {
            List<Database.SaveResult> res = Database.update(prodUpdate,true);
            prodParentId =prodUpdate[0].id;
        }
        //get Network details and set to plan rec   
        Object networkObj = productInfo.get('networks');
        if(networkObj!= null){
            List<Object> networkList = (List<Object>)networkObj;
            if(networkList!= null) {
                for(Object network : networkList){
                    Map<String,Object> networkMap = (Map<String,Object>)network;
                    String networkLvlName = (String)networkMap.get('networkLevelName');
                    if(networkLvlName== 'In-Network'){
                        deductibleSingle =  (Double)networkMap.get('deductibleSingle');
                        defaultCoinsurance =  (Double)networkMap.get('defaultCoinsurance');
                    }
                }
            } 
        }
        system.debug('*********concodeSet:' + concodeSet);
        List<Product2> existingConRec = new List<Product2>();
        //Start: Added code to get the contract code from JSON and check if record is already exist in the object
        existingConRec = [Select Contract_code__c,vlocity_ins__EffectiveDate__c ,id,name,vlocity_ins__EndDate__c from Product2 
                          where Contract_code__c=:concodeSet order by vlocity_ins__EffectiveDate__c desc];
        
        Set<String> contractCdeSet = new Set<String>();
        Map<String,List<Product2>> existingContCodeMap = new Map<String,List<Product2>>(); 
        system.debug('existingConRec******' + existingConRec);
        if(existingConRec.size()>0){
            for(Product2 prdRec : existingConRec) {
                system.debug('existingConRec - prdRec******' + prdRec);
                contractCdeSet.add(prdRec.Contract_Code__c);
                if(existingContCodeMap.containsKey(prdRec.Contract_Code__c)){
                    existingContCodeMap.get(prdRec.Contract_Code__c).add(prdRec);
                    system.debug('old existingConRec - prdRec******' + prdRec);
                }else {
                    system.debug('new existingConRec - prdRec******' + prdRec);
                    List<Product2> curProdList = new List<Product2>();
                    curProdList.add(prdRec);
                    existingContCodeMap.put(prdRec.Contract_Code__c,curProdList);
                }
            }
        }
        System.debug('existingContCodeMap**********:' + existingContCodeMap);
        //END
        String contCde;
        String hpcc;
        String adminstrationCodeDescription;
        //List<Product2> insertPlanRecList = new List<Product2>();
        List<Product2> updatePlanEndDateList = new List<Product2>();
        for(Object contractcode : conntractCodes){
            
            Map<String,Object> contractCodeMap = (Map<String,Object>)contractCode;
            contCde = (String)contractCodeMap.get('contractCode');
            
            if(contCde !=null && contCde!=''){
                
                String contractProdName = (String)contractCodeMap.get('productName');
                hpcc = (String)contractCodeMap.get('hpcc'); 
                adminstrationCodeDescription = (String)contractCodeMap.get('adminstrationCodeDescription');
                if((productStatus.equalsIgnoreCase('Approved') ||
                    productStatus.equalsIgnoreCase('Pending')||
                    productStatus.equalsIgnoreCase('Pending Filing')||
                    productStatus.equalsIgnoreCase('Filed')) && marketingStatus.equalsIgnoreCase('Marketed')){
                        status=true;
                    } else {
                        status = false;     
                    }
                if(planType=='Modified') status = true;
                System.debug('status**************:' + status);
                System.debug('contractCdeSet**************:' + contractCdeSet);
                
                //If status is flase and if record is not there in Object then dont create plan
                if((status == false && contractCdeSet.contains(contCde)) || (status == true))
                {
                    String contEffDate = conCodeEffDateMap.get(contCde);
                    if(contEffDate== null) contEffDate = prodEffectivedate;
                    List<Product2> existingPlans = existingContCodeMap.get(contCde);
                    System.debug('existingPlans**********:' + existingPlans);
                    //  TODO: vlocity_ins__EffectiveDate__c <=: date.valueOf(contEffDate) 
                    
                    Product2 prodConRec = new Product2(Name=contractProdName,Category__c=CATEGORY_PLAN, Product_Family__c=networkType,
                                                       Market__c=state,vlocity_ins__MarketSegment__c = 'Large Group',
                                                       ProductActive__c = status,Network__c=networkName,Contract_code__c=contCde,Funding_type__c=fundingType,
                                                       Product_Type__c=productType, LOB__c =productType, vlocity_ins__EffectiveDate__c=date.valueOf(contEffDate),productCode='PMT-'+contCde,
                                                       ExternalId='PMT-'+productId+'-'+contCde,QLIRecordType__c='LocalType',Portfolio_Year__c=String.ValueOf(portfolioYear),
                                                       HPCC_Code__c=hpcc , Benefit_Period__c=adminstrationCodeDescription, Quoted_Status__c=quotedType,
                                                       recordtypeid = planRecId, isActive = status,vlocity_ins__ProductSpecId__c=prodParentId,
                                                       plan_type__c =planType,Deductible_Amount__c=deductibleSingle, Coinsurance__c=defaultCoinsurance,Branding__c=branding);
                    
                    /*if((existingPlans== null || existingPlans.size()== 0) || 
(existingPlans!= null && existingPlans.size()>0 && existingPlans[0].vlocity_ins__EffectiveDate__c!= date.valueOf(contEffDate))){
prodContractUpsert.add(prodConRec);
System.debug('creating new plan**********:' + prodContractUpsert);
}*/
                    boolean isInsert = true;
                    if(existingPlans!= null && existingPlans.size()>0){
                        for(Product2 eachPlanRec : existingPlans){
                            if(eachPlanRec.vlocity_ins__EffectiveDate__c == date.valueOf(contEffDate)){
                                isInsert = false;
                                prodConRec.Id = eachPlanRec.Id;
                                system.debug('prodConRec1*********:'+ prodConRec);
                                prodContractUpsert.add(prodConRec);
                                System.debug('updating plan**********:' + prodContractUpsert);
                            }else if( eachPlanRec.vlocity_ins__EffectiveDate__c < date.valueOf(contEffDate) &&
                                     eachPlanRec.vlocity_ins__EndDate__c == null){
                                         eachPlanRec.vlocity_ins__EndDate__c = date.valueOf(contEffDate) - 1;
                                         updatePlanEndDateList.add(eachPlanRec);
                                         System.debug('updating end date for plan**********:' + updatePlanEndDateList);
                                     }
                        }
                        
                    }
                    if(isInsert){
                        prodContractUpsert.add(prodConRec);
                        System.debug('creating new plan**********:' + prodContractUpsert);
                    }
                }
            }
        }
        system.debug('update prodContractUpsert2:::::::::'+ prodContractUpsert);
        if(prodContractUpsert.size()>0){
            
            upsert prodContractUpsert;
            Set<Id> prodConIds = (new Map<Id,SObject>(prodContractUpsert)).keySet();
            system.debug('prodContractUpsert2 Ids::::::::::::' + prodConIds);
            List<PricebookEntry> existingList = [select id,Product2Id from PricebookEntry where Product2Id =:prodConIds];
            Set<Id> existingProdIdSet = new Set<Id>();
            
            if(existingList!= null && existingList.size()>0){
                for(PricebookEntry pce : existingList){
                    existingProdIdSet.add(pce.Product2Id);
                }
            }
            List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
            for(Product2 prdRec: prodContractUpsert){
                if(existingProdIdSet!= null && !existingProdIdSet.contains(prdRec.id)){
                    PricebookEntry priceBookEntryRec = new PricebookEntry(Pricebook2Id = priceBookId, Product2Id = prdRec.Id,
                                                                          UnitPrice = 1, IsActive = true);
                    priceBookEntryList.add(priceBookEntryRec);
                }
            }
            if(priceBookEntryList.size()>0){
                insert priceBookEntryList;
            }
        }
        
        //update end date for plan records
        if(updatePlanEndDateList.size()>0) {
            upsert updatePlanEndDateList;
        }
        //QLIUpdateUtility qliUtility = new QLIUpdateUtility();
        //QLIUpdateUtility.QLIUpdateStatus qliUpdateStatus ;
        for(Product2 childRec: prodContractUpsert) {
            loadAttributeAssignments(productJSONMap,childRec.Id,childRec.Contract_Code__c);
            
        }
        /*if(qliId!=null&&qliId!='NA'&&prodContractUpsert.size()>0){
            if(prodContractUpsert[0].ProductActive__c){
                qliUpdateStatus =   qliUtility.updateQLIProduct(qliId, prodContractUpsert[0].Contract_Code__c) ;
                System.debug('qliUpdateStatus--->' + qliUpdateStatus);
            } else{
                resStatus.statusMessage='Product Loaded successfully, QLI is not updated as new product record is inactive';
                resStatus.statusCode=1; return resStatus;
            }
        }
        if(qliUpdateStatus!=null && qliUpdateStatus.StatusCode=='ERROR'){
            resStatus.statusMessage='Product Loaded successfully, failed while updating QLI. QLI Update Error Message - '+qliUpdateStatus.StatusMessage;
            resStatus.statusCode=1;
            
        }else if(qliUpdateStatus!=null && qliUpdateStatus.StatusCode=='SUCCESS'){
            
            resStatus.statusMessage=qliUpdateStatus.StatusMessage;
            resStatus.statusCode=0;
            
        } else {
            resStatus.statusMessage='Request processed successfully';
            resStatus.statusCode=0;
        }*/
        resStatus.statusMessage='Request processed successfully';
        resStatus.statusCode=0;
        return resStatus;
    }
    
    //@Description: This method loads Vision products
    public StatusDetails loadVisionProduct( Map<String,Object> productJSONMap){
        loadMetaData(VISION_PRODUCT);
        StatusDetails resStatus = new StatusDetails();
        Integer productId;
        String prodEffectivedate;
        Integer portfolioYear;
        String productType;
        String networkType;
        String state;
        String marketingStatus;
        String productStatus;
        String planType;
        String planName;
        String contributionDescription;
        String marketSegment;
        String administrationTypeCode;
        String visionNetwork;
        String fundingDescription;
        String branding;
        Boolean status=true;
        String customPlanFlag;
        List<Product2> prodContractUpsert = new List<Product2>();
       // TempLGProductUploadServiceHelper.INNNetWorkDetails innNeworkDetails = new TempLGProductUploadServiceHelper.INNNetWorkDetails();
        Id priceBookId = [select name, isactive from Pricebook2 where IsStandard = true limit 1].Id;
        Map<String,Object> products =  (Map<String,Object>)productJSONMap.get('product');
        Map<String,Object> keysMap = (Map<String,Object>)products.get('keys');
        productId = (Integer)keysMap.get('productId');
        prodEffectivedate = (String)keysMap.get('effectiveDate');
        portfolioYear=  (Integer)keysMap.get('portfolioYear');
        productType= (String)keysMap.get('productType');
        Map<String,Object> productInfo = (Map<String,Object>)products.get('productInfo');
        Map<String,Object> visionPlan =  (Map<String,Object>)productInfo.get('visionPlan');
        Map<String,Object> planAttributes = (Map<String,Object>)visionPlan.get('planAttributes');
        administrationTypeCode = (String)planAttributes.get('administrationTypeCode');
        marketSegment = (String)planAttributes.get('marketSegment');
        productStatus = (String)planAttributes.get('status');
        planType = (String)planAttributes.get('planSubType');
        Object planDetailsObj = planAttributes.get('planDetails');
        List<Object> planDetails = (List<Object>)planDetailsObj;
        
        // Get contract codes from request
        Object conntractCodesObj = productInfo.get('contractCodes');
        List<Object> conntractCodes;
        if (conntractCodesObj instanceOf Map<String,Object>){
            conntractCodes = new List<Object>();
            conntractCodes.add(conntractCodesObj);
        }else{
            conntractCodes = (List<Object>)conntractCodesObj;
        }
        Map<String,String> conCodeEffDateMap = new Map<String,String>();
        Set<String> concodeSet = new Set<String>();
        // get contract codes for local busienss
        if(conntractCodes!= null){
            for(Object eachConcode : conntractCodes){
                Map<String,Object> contractCodeMap = (Map<String,Object>)eachConcode;
                String conCode = (String)contractCodeMap.get('contractCode');
                String effDate = (String)contractCodeMap.get('effectiveDate');
                String businessUnitDesc = (String)contractCodeMap.get('businessUnitDescription');
                String customFlag = (String)contractCodeMap.get('customPlanFlag');
                String marketStatus = (String)contractCodeMap.get('marketingStatus');
                if(String.isNotBlank(conCode) && businessUnitDesc.equalsIgnoreCase('Local') 
                   && customFlag.equalsIgnoreCase('No') && marketStatus.equalsIgnoreCase('Marketed')){
                       system.debug('adding CC to SET ------');
                       concodeSet.add(conCode);
                       if(String.isNotBlank(effDate)){
                           conCodeEffDateMap.put(conCode,effDate);   
                       }
                }
            }
        }
        //validate if any local contract code exist in reqeuest message
        system.debug('concodeSet---:' + concodeSet);
        if(concodeSet.size()==0) {
            resStatus.statusMessage='No local business contract codes part of request';
            resStatus.statusCode=1;
            return resStatus;
        }
        
        system.debug('*********concodeSet:' + concodeSet);
        //Check if any of the contract code alerady exist in Com2
        List<Product2> existingConRec = new List<Product2>();
        //Start: Added code to get the contract code from JSON and check if record is already exist in the object
        existingConRec = [Select Contract_code__c,vlocity_ins__EffectiveDate__c ,id,name,vlocity_ins__EndDate__c from Product2 
                          where Contract_code__c=:concodeSet and Product_Type__c=:VISION_PRODUCT order by vlocity_ins__EffectiveDate__c desc];
        
        Set<String> contractCdeSet = new Set<String>();
        Map<String,List<Product2>> existingContCodeMap = new Map<String,List<Product2>>(); 
        system.debug('existingConRec******' + existingConRec);
        //build a map of existing contract code records
        if(existingConRec.size()>0){
            for(Product2 prdRec : existingConRec) {
                system.debug('existingConRec - prdRec******' + prdRec);
                contractCdeSet.add(prdRec.Contract_Code__c);
                if(existingContCodeMap.containsKey(prdRec.Contract_Code__c)){
                    existingContCodeMap.get(prdRec.Contract_Code__c).add(prdRec);
                    system.debug('old existingConRec - prdRec******' + prdRec);
                }else {
                    system.debug('new existingConRec - prdRec******' + prdRec);
                    List<Product2> curProdList = new List<Product2>();
                    curProdList.add(prdRec);
                    existingContCodeMap.put(prdRec.Contract_Code__c,curProdList);
                }
            }
        }
        System.debug('existingContCodeMap**********:' + existingContCodeMap);
        //END
        String contCde;
        List<Product2> updatePlanEndDateList = new List<Product2>();
        for(Object contractcode : conntractCodes){
            
            Map<String,Object> contractCodeMap = (Map<String,Object>)contractCode;
            contCde = (String)contractCodeMap.get('contractCode');
            state = (String)contractCodeMap.get('stateCode');
            planName = (String)contractCodeMap.get('productName');
            contributionDescription = (String)contractCodeMap.get('contributionDescription');
            marketingStatus = (String)contractCodeMap.get('marketingStatus');
            visionNetwork = (String)contractCodeMap.get('network');
            branding = (String)contractCodeMap.get('brandingDescription');
           customPlanFlag = (String)contractCodeMap.get('customPlanFlag');
            fundingDescription =(String)contractCodeMap.get('fundingDescription');
            fundingDescription = ServiceIntegrationMappingUtility.getExternalSystemValue('Vision Product Load', 'fundingDescription',fundingDescription);    
            String businessUnitDesc = (String)contractCodeMap.get('businessUnitDescription');
            if(String.isNotBlank(contCde)){
                if(productStatus.equalsIgnoreCase('Approved')&& businessUnitDesc.equalsIgnoreCase('Local')  
                   && customPlanFlag.equalsIgnoreCase('No') && marketingStatus.equalsIgnoreCase('Marketed')) {
                    status=true;
                } else {
                    status = false;     
                }
                
                //If status is flase and if record is not there in Object then dont create plan
                if((status == false && contractCdeSet.contains(contCde)) || (status == true))
                {
                    String contEffDate = conCodeEffDateMap.get(contCde);
                    if(contEffDate== null) contEffDate = prodEffectivedate;
                    List<Product2> existingPlans = existingContCodeMap.get(contCde);
                    System.debug('existingPlans**********:' + existingPlans);
                    //  TODO:do we need to set Market__c = state???
                    
                    Product2 prodConRec = new Product2(Name=planName,Category__c=CATEGORY_PLAN, 
                                                       Market__c=state,vlocity_ins__MarketSegment__c = 'Large Group',
                                                       ProductActive__c = status,Network__c=visionNetwork,Contract_code__c=contCde,Funding_type__c=fundingDescription,
                                                       Product_Type__c=productType, LOB__c =productType, vlocity_ins__EffectiveDate__c=date.valueOf(contEffDate),productCode='PMT-'+contCde,
                                                       ExternalId='PMT-'+productId+'-'+contCde,QLIRecordType__c='LocalType',Portfolio_Year__c=String.ValueOf(portfolioYear),
                                                       Benefit_Period__c=administrationTypeCode,
                                                       recordtypeid = planRecId, isActive = status,
                                                       plan_type__c =planType,Branding__c=branding,
                                                       ParticipationType__c=contributionDescription,
                                                       MarketingStatus__c= marketingStatus
                                                      );
                    
                    boolean isInsert = true;
                    if(existingPlans!= null && existingPlans.size()>0){
                        for(Product2 eachPlanRec : existingPlans){
                            System.debug('effec1:'+eachPlanRec.vlocity_ins__EffectiveDate__c);
                            System.debug('effec2:'+date.valueOf(contEffDate));
                            if(eachPlanRec.vlocity_ins__EffectiveDate__c == date.valueOf(contEffDate)){
                                isInsert = false;
                                prodConRec.Id = eachPlanRec.Id;
                                system.debug('prodConRec1*********:'+ prodConRec);
                                prodContractUpsert.add(prodConRec);
                                System.debug('updating plan**********:' + prodContractUpsert);
                            }else if( eachPlanRec.vlocity_ins__EffectiveDate__c < date.valueOf(contEffDate) &&
                                     eachPlanRec.vlocity_ins__EndDate__c == null){
                                         eachPlanRec.vlocity_ins__EndDate__c = date.valueOf(contEffDate) - 1;
                                         updatePlanEndDateList.add(eachPlanRec);
                                         System.debug('updating end date for plan**********:' + updatePlanEndDateList);
                                     }
                        }
                        
                    }
                    if(isInsert){
                        prodContractUpsert.add(prodConRec);
                        System.debug('creating new plan**********:' + prodContractUpsert);
                    }
                }
            }
        }
        system.debug('update prodContractUpsert2:::::::::'+ prodContractUpsert);
        if(prodContractUpsert.size()>0){
            
            upsert prodContractUpsert;
            Set<Id> prodConIds = (new Map<Id,SObject>(prodContractUpsert)).keySet();
            system.debug('prodContractUpsert2 Ids::::::::::::' + prodConIds);
            List<PricebookEntry> existingList = [select id,Product2Id from PricebookEntry where Product2Id =:prodConIds];
            Set<Id> existingProdIdSet = new Set<Id>();
            
            if(existingList!= null && existingList.size()>0){
                for(PricebookEntry pce : existingList){
                    existingProdIdSet.add(pce.Product2Id);
                }
            }
            List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
            for(Product2 prdRec: prodContractUpsert){
                if(existingProdIdSet!= null && !existingProdIdSet.contains(prdRec.id)){
                    PricebookEntry priceBookEntryRec = new PricebookEntry(Pricebook2Id = priceBookId, Product2Id = prdRec.Id,
                                                                          UnitPrice = 1, IsActive = true);
                    priceBookEntryList.add(priceBookEntryRec);
                }
            }
            if(priceBookEntryList.size()>0){
                insert priceBookEntryList;
            }
        }
        
        //update end date for plan records
        if(updatePlanEndDateList.size()>0) {
            upsert updatePlanEndDateList;
        }
        for(Product2 childRec: prodContractUpsert) {
            loadAttributeAssignments(productJSONMap,childRec.Id,childRec.Contract_Code__c);
        }
        resStatus.statusMessage='Request processed successfully';
        resStatus.statusCode=0;
        return resStatus;
        
    }
    public  void loadAttributeAssignments(Map<String,Object> jSONMap, ID productId, String contractCode){
        //String inStr = inputJSON;
        prodId = productId;
        contCode = contractCode;
        attributeAssignmentUpsertList = new List<vlocity_ins__AttributeAssignment__c>();
        listTypeAttributesMap = new Map<String, List<String>>();
        
        
        //load current Attribute Assignments
        attributeAssignmentList = [ SELECT Id,Name,vlocity_ins__ObjectId__c,
                                   vlocity_ins__AttributeId__c, vlocity_ins__AttributeCode__c,vlocity_ins__AttributeName__c,
                                   vlocity_ins__AttributeCategoryId__c,vlocity_ins__AttributeCategory__c,vlocity_ins__AttributeCategoryCode__c,
                                   vlocity_ins__AttributeDisplaySequence__c,vlocity_ins__ValueDataType__c,vlocity_ins__Value__c
                                   FROM vlocity_ins__AttributeAssignment__c 
                                   WHERE vlocity_ins__ObjectId__c = :productId];
        
        
        delete attributeAssignmentList;
        
        attributeAssignmentMap= new Map<String,vlocity_ins__AttributeAssignment__c>();
     
        System.debug('prod attribute assignment list size 3-9:'+attributeAssignmentList.size());
        //System.debug('prod attribute assignment Map size 3-9:'+attributeAssignmentMap.size());
      
        System.debug('benefitIds:'+benefitIds);
        System.debug('benefitCategoryIds:'+benefitCategoryIds);
        System.debug('jSONPaths:'+jSONPaths);
        System.debug('attributeCodes:'+attributeCodes);
        System.debug('attributeCategoryCodes:'+attributeCategoryCodes);
        System.debug('jSONtoAttributeMap:'+jSONtoAttributeMap);
        System.debug('vlocityAttributeMap:'+vlocityAttributeMap);
        System.debug('prodAttrmdtlist:'+prodAttrmdtlist);
        
        //Map<String,Object> jsonMap = (Map<String,Object> )JSON.deserializeUntyped(inStr) ;
        System.debug('***********Starting to parse***********');
        //System.debug(jsonMap);
        processMap(jsonMap,null,'');
        system.debug('attributeAssignmentUpsertList **********:' + attributeAssignmentUpsertList);
        System.debug('prod attribute assign upsert list size 3-9:'+attributeAssignmentUpsertList.size());
        processListTypeAttributes(productId);
        upsert attributeAssignmentUpsertList;
        
    }
    
    void processMap(Map<String,Object> inputMap, String parent,String Suffix){
        
        // if parent is not in product load metadata then skip current JSON node 
        if(parent!=null && !jSONPaths.contains(parent)) return;
        
        if(inputMap.containsKey('contractCode') && (String)inputMap.get('contractCode')!=contCode) return;
        
        String benefitCategoryIdObj = String.valueOf((Integer)inputMap.get('benefitCategoryId'));
        System.debug('benefitCategoryIdObj:' +benefitCategoryIdObj);
        if(benefitCategoryIdObj!=null && !benefitCategoryIds.contains(benefitCategoryIdObj)) return;
        //if(benefitIdobj!=null){benefitId='-'+(Integer)benefitIdobj;}
        
        String currSuffix = '';
        String benefitId='';
        String benefitIdobj = String.valueOf((Integer)inputMap.get('benefitId'));
        if(benefitIdobj!=null && !benefitIds.contains(benefitIdobj)) return;
        if(benefitIdobj!=null){benefitId='.'+benefitIdobj;}
        
        String networkLevelCode;
        Object networkLevelName =inputMap.get('networkLevelName');
        if((String)networkLevelName=='In-Network') {networkLevelCode= '.inn';} 
        else if((String)networkLevelName=='Non-Network'){networkLevelCode='.oon';}
        else if((String)networkLevelName=='In-Network Level 2'){networkLevelCode='.innl2';}
        else {networkLevelCode='';}
        
        currSuffix = suffix+ benefitId+networkLevelCode;
        //suffix=
        
        
        
        
        for(String mapKey :inputMap.keyset() ){
            Object obj = inputMap.get(mapKey);
            
            if(obj instanceof String ||obj instanceof Integer|| obj instanceof Decimal ) {
                String objStr ;
                if(obj instanceof String) {
                    objStr = (String)obj;
                }
                else if (obj instanceof Integer) {
                    objStr = ((Integer)obj).format();
                }
                else {
                    objStr = ((Decimal)obj).toPlainString();
                }
                
                if(obj instanceof String) System.debug('Field is String: ' + parent+'.'+mapKey +currSuffix+', Value: '+(String)obj );
                else System.debug('Field is String: ' + parent+'.'+mapKey +currSuffix+', Value: '+((Decimal)obj).toPlainString() );
                
                
                //Check if attribute exist in attribute metadata
                String attributeMapKey = jSONtoAttributeMap.get(parent+'.'+mapKey+currSuffix);
                if (attributeMapKey==null) continue;
                System.debug('attributeMapKey:'+attributeMapKey);
                
                //Check if attribute is of type list , add to list type attribute map for later processing
                if(listTypeAttributes.contains(parent+'.'+mapKey+currSuffix)){
                    List<String> currentAttributeValueList = listTypeAttributesMap.get(parent+'.'+mapKey+currSuffix);
                    if(currentAttributeValueList == null){
                        currentAttributeValueList = new List<String>();
                        listTypeAttributesMap.put(parent+'.'+mapKey+currSuffix, currentAttributeValueList);
                    }
                    currentAttributeValueList.add(objStr);
                    System.debug('List type attribute value:'+objStr);
                    continue;
                }
                
                //get Attribute Metadata record
                
                //get Vlocity Attribute record
                vlocity_ins__Attribute__c  vlocityAttributeRec= vlocityAttributeMap.get(attributeMapKey);
                if (vlocityAttributeRec == null) continue ;
                String filterStr = prodAttrmdtMap.get(parent+'.'+mapKey+currSuffix).Filter__c;
                system.debug('----------' + filterStr);
                if(String.IsNotBlank(filterStr)){
                    if(!checkFilterCondition(filterStr,inputMap) ) return;
                }
                String transformStr = prodAttrmdtMap.get(parent+'.'+mapKey+currSuffix).Transform__c;
                String objStrTransformVal ;
                if(String.IsNotBlank(transformStr)&&transformStr.equalsIgnoreCase('Yes') ){
                	objStrTransformVal = ServiceIntegrationMappingUtility.getExternalSystemValue('Vision Product Load', parent+'.'+mapKey+currSuffix,objStr);    
                    if(String.isNotBlank(objStrTransformVal)) {
                        objStr = objStrTransformVal;
                    }
                }
                
                
                vlocity_ins__AttributeAssignment__c attributeAssignmentRec = attributeAssignmentMap.get(attributeMapKey);
                
                if(attributeAssignmentRec == null){
                    attributeAssignmentRec = new vlocity_ins__AttributeAssignment__c();
                    attributeAssignmentRec.vlocity_ins__ObjectId__c = prodId;
                    attributeAssignmentRec.vlocity_ins__AttributeId__c = vlocityAttributeRec.Id;
                    attributeAssignmentRec.vlocity_ins__AttributeCategoryId__c = vlocityAttributeRec.vlocity_ins__AttributeCategoryId__c;
                    attributeAssignmentRec.vlocity_ins__AttributeCategory__c =vlocityAttributeRec.vlocity_ins__AttributeCategoryName__c;   
                    attributeAssignmentRec.vlocity_ins__AttributeCategoryCode__c = vlocityAttributeRec.vlocity_ins__AttributeCategoryCode__c;
                    attributeAssignmentRec.vlocity_ins__AttributeCode__c =vlocityAttributeRec.vlocity_ins__Code__c;
                    attributeAssignmentRec.vlocity_ins__AttributeDisplaySequence__c =vlocityAttributeRec.vlocity_ins__DisplaySequence__c.toPlainString();
                    attributeAssignmentRec.vlocity_ins__AttributeName__c =vlocityAttributeRec.Name;
                    attributeAssignmentRec.Name =vlocityAttributeRec.Name;
                    attributeAssignmentRec.vlocity_ins__ValueDataType__c = 'Text';
                    attributeAssignmentRec.vlocity_ins__Value__c =objStr;
                    //attributeAssignmentRec.Name  
                    //attributeAssignmentRec.vlocity_ins__DisplaySequence__c
                    //attributeAssignmentRec
                    //attributeAssignmentRec
                    //attributeAssignmentRec                        
                } else{
                    attributeAssignmentRec.vlocity_ins__ValueDataType__c = 'Text';
                    attributeAssignmentRec.vlocity_ins__Value__c =objStr;
                }
                attributeAssignmentUpsertList.add(attributeAssignmentRec);
                //Check if attribute assignment record exist 
                //Uppdate or add new Attribute assignment record
            }
            if (obj instanceof List<Object>) {
                //System.debug('Field is List: '+parent+'.'+mapKey );
                String currParent='';
                if(parent!=null) currParent=parent+'.'+mapkey; else currParent =mapkey;
                System.debug('Field is List: '+currParent );
                processList((List<Object>)obj,currParent,currSuffix);
            }
            //Map<String,Object> objMap= (Map<String, Object>)obj;
            if (obj instanceof Map<String,Object>){
                
                String currParent='';
                if(parent!=null) currParent=parent+'.'+mapkey; else currParent =mapkey;
                //System.debug('Field is List: '+currParent );               
                System.debug('Field is Map: '+currParent );
                processMap((Map<String,Object>)obj,currParent,currSuffix);
            }
            
            //System.debug("Object Type: " + obj.)
            
        }
    }
    
    void processList(List<Object> objList,String parent,String Suffix){
        for(Object obj : (List<Object>)objList ){
            if(obj instanceof String) {
                System.debug('Field is String: ' + (String)obj );
            }
            if(obj instanceof Decimal){
                System.debug('Field is Decimal: ' +(Decimal)obj );
            }
            if(obj instanceof Map<String,Object>){
                //System.debug('Field is Map: '+parent+'.'+mapKey );
                processMap((Map<String,Object>)obj,parent,Suffix);
            }
            if(obj instanceof List<Object>){
                processList((List<Object>)obj,parent,Suffix); 
            }
        }
    }
    void processListTypeAttributes(ID productId){
        system.debug('productId****:' + productId);
        system.debug('listTypeAttributesMap****:' + listTypeAttributesMap);
        for(String mapKey :listTypeAttributesMap.keyset()){
            // system.debug('attributeValueList****:' + attributeValueList);
            List<String> attributeValueList = listTypeAttributesMap.get(mapKey);
            if(attributeValueList.size()>0){
                attributeValueList.sort();
                Integer i=1;String attributeMapKey = jSONtoAttributeMap.get(MapKey);
                if (attributeMapKey==null) continue;
                for(String attributeValue : attributeValueList){
                    vlocity_ins__Attribute__c  vlocityAttributeRec= vlocityAttributeMap.get(attributeMapKey+i.format());
                    System.debug('List type Attributes map key:'+attributeMapKey+i.format());
                    if (vlocityAttributeRec == null) continue ;
                    vlocity_ins__AttributeAssignment__c attributeAssignmentRec = new vlocity_ins__AttributeAssignment__c();
                    attributeAssignmentRec.vlocity_ins__ObjectId__c = productId;
                    attributeAssignmentRec.vlocity_ins__AttributeId__c = vlocityAttributeRec.Id;
                    attributeAssignmentRec.vlocity_ins__AttributeCategoryId__c = vlocityAttributeRec.vlocity_ins__AttributeCategoryId__c;
                    attributeAssignmentRec.vlocity_ins__AttributeCategory__c =vlocityAttributeRec.vlocity_ins__AttributeCategoryName__c;   
                    attributeAssignmentRec.vlocity_ins__AttributeCategoryCode__c = vlocityAttributeRec.vlocity_ins__AttributeCategoryCode__c;
                    attributeAssignmentRec.vlocity_ins__AttributeCode__c =vlocityAttributeRec.vlocity_ins__Code__c;
                    attributeAssignmentRec.vlocity_ins__AttributeDisplaySequence__c =vlocityAttributeRec.vlocity_ins__DisplaySequence__c.toPlainString();
                    attributeAssignmentRec.vlocity_ins__AttributeName__c =vlocityAttributeRec.Name;
                    attributeAssignmentRec.Name =vlocityAttributeRec.Name;
                    attributeAssignmentRec.vlocity_ins__ValueDataType__c = 'Text';
                    attributeAssignmentRec.vlocity_ins__Value__c =attributeValue;
                    attributeAssignmentUpsertList.add(attributeAssignmentRec);
                    i++;
                    
                }
            }
        }
    }
    //Load static data
    private void loadMetaData(String prodType){
        system.debug('prodType***********:' + prodType);
        //Load product attribute metadata
        prodAttrmdtlist = [SELECT JSON_Field_Location__c, JSON_Field_Name__c,Benefit_Id__c,
                           Benefit_Category_Id__c,Attribute_Code__c,Attribute_Category_Code__c,Attribute_type__c
                           ,Filter__c, Transform__c
                           FROM LG_Product_Load_Mapping__c where Product_Type__c=: prodType];
        
        System.debug('prod meta data size 3-9:'+prodAttrmdtlist.size());
        
        if(prodAttrmdtlist.size()==0) return;
        for(LG_Product_Load_Mapping__c prodAttrmdt : prodAttrmdtlist  ){
            if (prodAttrmdt.Benefit_Id__c !=null) benefitIds.add(prodAttrmdt.Benefit_Id__c);
            if (prodAttrmdt.Benefit_Category_Id__c !=null) benefitCategoryIds.add(prodAttrmdt.Benefit_Category_Id__c);
            if (prodAttrmdt.Attribute_Code__c !=null) attributeCodes.add(prodAttrmdt.Attribute_Code__c);
            if (prodAttrmdt.Attribute_Category_Code__c !=null) attributeCategoryCodes.add(prodAttrmdt.Attribute_Category_Code__c);
            
            if (prodAttrmdt.JSON_Field_Location__c !=null && prodAttrmdt.JSON_Field_Name__c !=null ){
                jSONtoAttributeMap.put(prodAttrmdt.JSON_Field_Location__c+'.'+
                                       prodAttrmdt.JSON_Field_Name__c,prodAttrmdt.Attribute_Category_Code__c+'.'+prodAttrmdt.Attribute_Code__c );
                
                if (prodAttrmdt.Attribute_Type__c=='list'){
                    listTypeAttributes.add(prodAttrmdt.JSON_Field_Location__c+'.'+ prodAttrmdt.JSON_Field_Name__c);
                }
                prodAttrmdtMap.put(prodAttrmdt.JSON_Field_Location__c+'.'+ prodAttrmdt.JSON_Field_Name__c,prodAttrmdt);
            }
            if (prodAttrmdt.JSON_Field_Location__c !=null) {
                //System.debug('prodAttrmdt.JSON_Field_Location__c:'+prodAttrmdt.JSON_Field_Location__c);
                List<String> jSONPathElementList = prodAttrmdt.JSON_Field_Location__c.split('\\.');
                //System.debug('jSONPathElementList:'+jSONPathElementList);
                String parentElement =null;
                for(String jSONPathElement :jSONPathElementList ){
                    if(parentElement==null) parentElement = jSONPathElement;
                    else parentElement = parentElement+'.'+jSONPathElement;
                    jSONPaths.add(parentElement);
                }
                System.debug('jSONPaths:'+jSONPaths);
            }
            
        }
        //Load Vlocity Attribute List
        
        List<vlocity_ins__Attribute__c> vlocityAttributeList = [SELECT Id,vlocity_ins__Code__c,Name,vlocity_ins__DisplaySequence__c,
                                                                vlocity_ins__AttributeCategoryId__c, vlocity_ins__AttributeCategoryCode__c,vlocity_ins__AttributeCategoryName__c
                                                                FROM vlocity_ins__Attribute__c where vlocity_ins__AttributeCategoryCode__c in :attributeCategoryCodes
                                                                //and vlocity_ins__Code__c in :attributeCodes
                                                               ];
        
        //build Vlocity Attribute Map
        For(vlocity_ins__Attribute__c vlocityAttribute : vlocityAttributeList){
            vlocityAttributeMap.put(vlocityAttribute.vlocity_ins__AttributeCategoryCode__c+'.'+vlocityAttribute.vlocity_ins__Code__c,vlocityAttribute);
        }
    }
    public class StatusDetails{
        public Integer statusCode{ get; set; }
        public String statusMessage { get; set; } 
        
    } 
    
   
    public boolean checkFilterCondition(String filterStr, Map<String,Object> inputMap){
        Map<String,Object> filterMap =    (Map<String,Object>) JSON.deserializeUntyped(filterStr);
        String filterValue;
        Object inputMapValue;
        String inputMapValueStr;
        if(filterMap== null) return false;
        //system.debug('filterMap------------:' + filterMap);
        for(String filterMapKey:filterMap.keySet()){
            filterValue = (String)filterMap.get(filterMapKey);
            if(!inputMap.containsKey(filterMapKey)) return false;
            inputMapValue = inputMap.get(filterMapKey);
            //system.debug('inputMapValue---------' + inputMapValue);
            if(inputMapValue!=null){ 
                if(inputMapValue instanceof String) {
                    inputMapValueStr = (String)inputMapValue;
                } else if (inputMapValue instanceof Integer) {
                    inputMapValueStr = ((Integer)inputMapValue).format();
                } else if (inputMapValue instanceof Decimal){
                    inputMapValueStr = ((Decimal)inputMapValue).toPlainString();
                } else{
                    return false;
                }
                
            } else {
                return false;
            }
            if(String.isNotBlank(inputMapValueStr )){
                if(!inputMapValueStr.equalsignorecase(filterValue)){
                    return false;
                }	
            } else {
                return false;
            }
            
        }
        return true;
        
    }
//@Description:get benefit details and network details
  /*  private TempLGProductUploadServiceHelper.INNNetWorkDetails getBenefitDetails(Map<String,Object> visionPlan){
        system.debug('IN setBenefitDetails ---------:'); 
        TempLGProductUploadServiceHelper.INNNetWorkDetails innNetWorkDetails= new TempLGProductUploadServiceHelper.INNNetWorkDetails();
        Object benefitDetailsObj = visionPlan.get('benefitDetails');
        // Map<String,Object> benefitCategories = (Map<String,Object>)benefitDetails.get('benefitCategories');
        List<Object> benefitDetailsList = (List<Object>)benefitDetailsObj;
        if(benefitDetailsList!= null && benefitDetailsList.size()>0 ){
            Map<String,Object> benefitDetailsMap = (Map<String,Object>)benefitDetailsList[0];
            Object benefitCategoriesObj = benefitDetailsMap.get('benefitCategories');
            List<Object> benefitCategories = (List<Object>)benefitCategoriesObj;
            String benefitName;
            Integer benefitId;
            if(benefitCategories!=null) {
                for(Object eachBenefitCat : benefitCategories){
                    Map<String,Object> benefitCatMap = (Map<String,Object>)eachBenefitCat;
                    List<Object> benefitsList = (List<Object>)benefitCatMap.get('benefits');
                    // Map<String,Object> networksMap = (Map<String,Object>)benefitsMap.get('networks');
                    if(benefitsList!= null){
                        for(Object eachBenefit : benefitsList){
                            Map<String,Object> eachBenefitMap = (Map<String,Object>)eachBenefit;
                            benefitName   = (String)eachBenefitMap.get('benefitName');
                            benefitId   = (Integer) eachBenefitMap.get('benefitId');
                            List<Object> networkList = (List<Object>)eachBenefitMap.get('networks');
                           innNetWorkDetails = populateValuesFromNetwork(benefitId, networkList,innNetWorkDetails);
                        }
                    }
                }
            }
        }
        return innNetWorkDetails;
    }    
    // @Description:Iterate through networks and set the values for INN EXam,Vision,lens,frames and other fields
    private TempLGProductUploadServiceHelper.INNNetWorkDetails populateValuesFromNetwork(Integer benefitId, List<Object> networkList,
                                                                                         TempLGProductUploadServiceHelper.INNNetWorkDetails innNetWorkDetails){
       // TempLGProductUploadServiceHelper.INNNetWorkDetails innNetWorkDetails = new TempLGProductUploadServiceHelper.INNNetWorkDetails();
        if(networkList!=null) {
            for(Object networkRec : networkList){
                Map<String,Object> networkRecMap = (Map<String,Object>)networkRec;
                String networkLevelCode = (String) networkRecMap.get('networkLevelCode');
                Double copayAmount = (Double)networkRecMap.get('copayAmount');
                String costShareType = (String)networkRecMap.get('costShareType');
                String isFiled = (String)networkRecMap.get('isFiled');
                if( networkLevelCode.equalsIgnoreCase(NETWORK_LEVEL_CODE_INN) && isFiled.equalsIgnoreCase(ISFILED) && costShareType.equalsIgnoreCase(COST_SHARE_TYPE_COPAY)) {
                    switch on benefitId {
                        when 186 {
                            //system.debug('INN Exam Value:' +copayAmount );
                        	innNetWorkDetails.INNExam = copayAmount;    
                        }
                        when 187{
                            innNetWorkDetails.INNSingleVisionLens = copayAmount;
                        }
                        when 188{
                            innNetWorkDetails.INNBifocalLens = copayAmount;
                        }
                        when 189{
                            innNetWorkDetails.INNTrifocalLens = copayAmount;
                        }
                        when 202{
                            innNetWorkDetails.INNNonElectiveContactLens = copayAmount;
                        }
                    }
                } else if(networkLevelCode.equalsIgnoreCase(NETWORK_LEVEL_CODE_INN)  && isFiled.equalsIgnoreCase(ISFILED) && costShareType.equalsIgnoreCase(COST_SHARE_TYPE_ALLOWANCE)) {
                    switch on benefitId {
                        when 200 {
                        	innNetWorkDetails.INNFrames = copayAmount;    
                        }
                        when 201{
                            innNetWorkDetails.INNElectiveContactLens = copayAmount;
                        }
                   }
                    
                }
                
            }
            //system.debug('innNetWorkDetails:::' + innNetWorkDetails);
        }
        return innNetWorkDetails;
    } 
	 public class INNNetWorkDetails {
        public Double INNExam{get;set;}
        public Double INNSingleVisionLens{get;set;}
        public Double INNBifocalLens{get;set;}
        public Double INNTrifocalLens{get;set;}
        public Double INNFrames{get;set;}
        public Double INNElectiveContactLens{get;set;}
        public Double INNNonElectiveContactLens{get;set;}
    }
    */
    
}