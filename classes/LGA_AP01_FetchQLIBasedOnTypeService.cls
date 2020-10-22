/***********************************************************************
@author         Accenture offshore
@date           07/12/2019
@name           LGA_AP01_FetchQLIBasedOnType 
@description    Fetching Quote Line Items based 
on type and will return to Load Group Omni script
************************************************************************/

global with sharing class LGA_AP01_FetchQLIBasedOnTypeService implements vlocity_ins.VlocityOpenInterface2 {
    
    public  Map<String,Object> inputJSONMapVlocity = new Map<String,Object>();
    public  Map<String,Object> outputJsonToVlocityMap = new Map<String,Object>();
    public  Map<String,Object> optnsVlocityMap = new Map<String,Object>();
    private Map<String,DataWrapper> impactedProductDetailsMap = new Map<String,DataWrapper>();
    
  
    /*********************************************************************************
* @description Implementation of invokeMethod from VlocityOpenInterface2 interface.
* @param methodName
* @param inputMap
* @param outMap
* @param optns
* @return true
*/
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String,Object > outMap, Map < String, Object > optns) {
        
        Boolean isMethodInvoked = false;
        if (LGA_UTIL_Constants.FETCH_QLIS_BASED_ON_TYPE.equalsIgnoreCase(methodName)) {
            this.inputJSONMapVlocity = inputMap;
            this.outputJsonToVlocityMap = outMap;
            this.optnsVlocityMap = optns;
            fetchImpactedQLIs();
            isMethodInvoked = true;
        } else if(LGA_UTIL_Constants.REPLACE_PROD_NAME.equalsIgnoreCase(methodName)){
            this.inputJSONMapVlocity = inputMap;
            this.outputJsonToVlocityMap = outMap;
            this.optnsVlocityMap = optns;
            transformProdDetails();
            isMethodInvoked = true;
        }
        return isMethodInvoked;
    }

    /***************************************************************************************************
* @description replaces % from productname
* to output map
*/
    private void transformProdDetails() {
        
        Map<String,List<Object>> jsonNodeValueMap = new Map<String,List<Object>>();
        List<Object> medPlanProductNameList = inputJSONMapVlocity.get(LGA_UTIL_Constants.MEDICAL_PLAN_NAME) instanceof List<Object> 
            ? (List<Object>)inputJSONMapVlocity.get(LGA_UTIL_Constants.MEDICAL_PLAN_NAME) : null;
        List<Object> medProductNameList = inputJSONMapVlocity.get(LGA_UTIL_Constants.MEDICAL_PRODUCT_NAME) instanceof List<Object> 
            ? (List<Object>)inputJSONMapVlocity.get(LGA_UTIL_Constants.MEDICAL_PRODUCT_NAME) : null;
        List<Object> dentalProductNameList = inputJSONMapVlocity.get(LGA_UTIL_Constants.DENTAL_PLAN_NAME) instanceof List<Object> 
            ? (List<Object>)inputJSONMapVlocity.get(LGA_UTIL_Constants.DENTAL_PLAN_NAME) : null;
        List<Object> visionProductNameList = inputJSONMapVlocity.get(LGA_UTIL_Constants.VISION_PLAN_NAME) instanceof List<Object> 
            ? (List<Object>)inputJSONMapVlocity.get(LGA_UTIL_Constants.VISION_PLAN_NAME) : null;
        List<Object> ldProductNameList = inputJSONMapVlocity.get(LGA_UTIL_Constants.LD_PLAN_NAME) instanceof List<Object> 
            ? (List<Object>)inputJSONMapVlocity.get(LGA_UTIL_Constants.LD_PLAN_NAME) : null;
        List<Object> fsaProductNameList = inputJSONMapVlocity.get(LGA_UTIL_Constants.FSA_PLAN_NAME) instanceof List<Object> 
            ? (List<Object>)inputJSONMapVlocity.get(LGA_UTIL_Constants.FSA_PLAN_NAME) : null;
        List<Object> eapProductNameList = inputJSONMapVlocity.get(LGA_UTIL_Constants.EAP_PLAN_NAME) instanceof List<Object> 
            ? (List<Object>)inputJSONMapVlocity.get(LGA_UTIL_Constants.EAP_PLAN_NAME) : null;
        jsonNodeValueMap.put(LGA_UTIL_Constants.MEDICAL_PLAN_NAME, medPlanProductNameList);       
        jsonNodeValueMap.put(LGA_UTIL_Constants.MEDICAL_PRODUCT_NAME, medProductNameList);       
        jsonNodeValueMap.put(LGA_UTIL_Constants.DENTAL_PLAN_NAME, dentalProductNameList);       
        jsonNodeValueMap.put(LGA_UTIL_Constants.VISION_PLAN_NAME, visionProductNameList);     
        jsonNodeValueMap.put(LGA_UTIL_Constants.LD_PLAN_NAME, ldProductNameList);  
        jsonNodeValueMap.put(LGA_UTIL_Constants.FSA_PLAN_NAME, fsaProductNameList);       
        jsonNodeValueMap.put(LGA_UTIL_Constants.EAP_PLAN_NAME, eapProductNameList);       
        transformPercentBlankInJSON(jsonNodeValueMap);
        
    }
     
    /***************************************************************************************************
* @description replaces % and null from JSOn node
* @param Map<String,List<Object>> jsonNodeValueMap
* 
*/
    private void transformPercentBlankInJSON(Map<String,List<Object>> jsonNodeValueMap){
        
        List<Object> tranformedProductNameList = new List<Object>();
        for(String jsonNodeName : jsonNodeValueMap.keySet()){
            List<Object> productNameList = jsonNodeValueMap.get(jsonNodeName);    
            //List<Object> tranformedProductNameList = new List<Object>();    
            if(productNameList != null && !productNameList.isEmpty()){
                for(Object obj : productNameList){
                    tranformedProductNameList = handleMultipleProducts(jsonNodeName, obj,tranformedProductNameList);
                }
                outputJsonToVlocityMap.put(jsonNodeName, tranformedProductNameList);            
            } else{               
                handleSingleProduct(jsonNodeName);
            }
        }
        
    }
    
    /***************************************************************************************************
* @description replaces % and null from Single Product
* @param String nodeName
* 
*/
    
    private void handleSingleProduct(String nodeName){
        
        Map<String,Object> singleProductMap = (Map<String,Object>)inputJSONMapVlocity.get(nodeName);
        if(singleProductMap != null){
            List<String> jsonNodeNameListToReplaceBlnk = new List<String>();
            jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.PRODUCT_NAME);
            jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.PREFIX);
            jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.PARENT_QLI_PRODUCT_NAME);
            jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.HSA_BANKING_PARTNER);
            singleProductMap = replacePercentNBlankWithSpace(jsonNodeNameListToReplaceBlnk,singleProductMap,true);   
            outputJsonToVlocityMap.put(nodeName, singleProductMap);
        }
    }
    
    /***************************************************************************************************
* @description transform % and null from Multiple product
* @param String nodeName
* @param Object productObj
* @param List<Object> transformList
* 
*/
    private List<Object> handleMultipleProducts(String jsonNodeName, Object productObj,List<Object> transformList){
        
        Map<String,Object> jsonNodeMap = (Map<String,Object>)productObj;
        List<String> jsonNodeNameListToReplaceBlnk = new List<String>();
        jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.PRODUCT_CONTRACT_CODE);
        jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.PREFIX);
        jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.PARENT_QLI);
        jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.BENEFIT_PERIOD);
        jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.ADD_REASON_CODE);
        jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.CLAIMS_ROUTE_CODE);
        jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.HSA_BANKING_PARTNER);
        
        jsonNodeNameListToReplaceBlnk.add(LGA_UTIL_Constants.PRODUCT_NAME);        
        jsonNodeMap = replacePercentNBlankWithSpace(jsonNodeNameListToReplaceBlnk,jsonNodeMap,false);    
        transformList.add(jsonNodeMap);
        return transformList;
    }
    
    private Map<String,Object> replacePercentNBlankWithSpace(List<String> jsonNodeNameList, Map<String,Object> jsonMap, boolean isSingleProduct){
        for(String jsonNodeName:jsonNodeNameList){
            String jsonNodeVal  = (String)jsonMap.get(jsonNodeName);
            if(isSingleProduct && jsonNodeVal != null){
                jsonMap.put(jsonNodeName,String.isNotBlank(jsonNodeVal) ? (jsonNodeVal.contains(LGA_UTIL_Constants.PERCENT) 
                                                                           ? jsonNodeVal.replace(LGA_UTIL_Constants.PERCENT,LGA_UTIL_Constants.PERCENT_REPLACER):jsonNodeVal)
                            : LGA_UTIL_Constants.BLANK_WITH_PERCENT);
            }else{
                jsonMap.put(jsonNodeName,String.isNotBlank(jsonNodeVal) ? (jsonNodeVal.contains(LGA_UTIL_Constants.PERCENT)
                                                                           ? jsonNodeVal.replace(LGA_UTIL_Constants.PERCENT,LGA_UTIL_Constants.PERCENT_REPLACER):jsonNodeVal) 
                            : LGA_UTIL_Constants.BLANK_WITH_PERCENT);
            }
        }
        return jsonMap;
        
    }
    
    /***************************************************************************************************
* @description Adds a list of impacted products based on product type from Parent Quote
* to output map
*/
    private void fetchImpactedQLIs() {
        
        string impactedProductIds = (String) optnsVlocityMap.get(LGA_UTIL_Constants.IMPACTED_PRODUCT_IDS);
        List<String> qliIdsList = impactedProductIds.split(LGA_UTIL_Constants.COMMA);
        List<QuoteLineItem> listQuoteLineItems = checkAccessibilityAndQuery(qliIdsList);
        if(!listQuoteLineItems.isEmpty())
        {
            for(QuoteLineItem qli : listQuoteLineItems)
            {               
                putDataIntoImpactedProductMap(qli);              
            }
            
        } 
        outputJsonToVlocityMap.put(LGA_UTIL_Constants.LOAD_GROUP_IMPACTED_PRODUCTS, impactedProductDetailsMap);
    }
    
    
    /**
* @description This method validates FLS on SOQL before querying it and returns impacted quote line item product list 
* @param qliList
* @return qliList
*/
    private List<QuoteLineItem> checkAccessibilityAndQuery(List<String> qliIdsList){
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        try{        
            if (Schema.sObjectType.QuoteLineItem.isAccessible() && 
                Schema.sObjectType.Product2.isAccessible() && 
                Schema.sObjectType.QuoteLineItem.fields.ProductCategory__c.isAccessible() &&     
                Schema.sObjectType.QuoteLineItem.fields.Contract_Codes__c.isAccessible()) {
                    
                    qliList = [Select id,Product2.Name,Product2.Product_Type__c, QuoteId, 
                               ProductCategory__c, Contract_Codes__c, ParentQuoteLineItem__c,
                               ParentQuoteLineItem__r.Product2.Name,Prefix__c,Benefit_Period__c,
                               Add_Reason_Code__c,Claims_Route_Code__c,HSABankingPartner__c
                               from QuoteLineItem 
                               WHERE Id IN : qliIdsList
                               LIMIT 50000];
                    
                }            
        }catch(QueryException  queryEx){
            System.debug('QueryException  is caught  : ' + queryEx.getMessage());
        } catch(SObjectException soEx) {
            System.debug('SObjectException caught: ' + soEx.getMessage()); 
        } catch(Exception ex) {
            System.debug('Exception caught: ' + ex.getMessage()); 
        }
        return qliList;
    }
        
    /**
* @description This method puts Product and related details into a Map     * 
* @param qli
*/
    private void putDataIntoImpactedProductMap(QuoteLineItem qli){
        String productCategory = qli.ProductCategory__c;
        String productType = qli.Product2.Product_Type__c;
        String keyName = (productType == LGA_UTIL_Constants.MEDICAL) ? (productType + productCategory) : 
        (productType == LGA_UTIL_Constants.LIFE || productType == LGA_UTIL_Constants.DISABILITY) 
        ? LGA_UTIL_Constants.LIFE_AND_DISABILITY : productType;               
        ProductDetail product = new ProductDetail(qli);
        if(impactedProductDetailsMap.containsKey(keyName)){
            DataWrapper dw = impactedProductDetailsMap.get(keyName);
            dw.productDetail.add(product);
        }else{
            List<productDetail> newProdTypeList = new List<productDetail>();
            newProdTypeList.add(product);
            DataWrapper newProdDw = new DataWrapper(newProdTypeList, productType, productCategory);
            impactedProductDetailsMap.put(keyName, newProdDw); 
        }
    }
    
    
    class ProductDetail{
        
        public String id;
        public String productName;
        public String productType;
        public String quoteId;
        public String productCategory;
        public String contractCodes;
        public String parentQuoteLineItem;
        public String parentQuoteLineItemId;
        public String prefix;
        public String claimsRouteCode;
        public String addReasonCode;
        public String benefitPeriod;
        public String hsaBankingPartner;
        
        
        
        ProductDetail(QuoteLineItem qli){
            this.id = qli.id;
            this.quoteId = qli.QuoteId;
            this.productName = qli.Product2.Name;           
            this.parentQuoteLineItemId = qli.ParentQuoteLineItem__c;
            replaceNullValueWithPercent(qli);
            transformPercentValueWithPercentReplacer(qli);            
        }
        
        private void replaceNullValueWithPercent(QuoteLineItem qli){            
            this.benefitPeriod= String.isNotBlank(qli.Benefit_Period__c) ? qli.Benefit_Period__c : LGA_UTIL_Constants.BLANK_WITH_PERCENT;  
            this.addReasonCode= String.isNotBlank(qli.Add_Reason_Code__c) ? qli.Add_Reason_Code__c : LGA_UTIL_Constants.BLANK_WITH_PERCENT;
            this.claimsRouteCode= String.isNotBlank(qli.Claims_Route_Code__c) ? qli.Claims_Route_Code__c : LGA_UTIL_Constants.BLANK_WITH_PERCENT;
            this.hsaBankingPartner= String.isNotBlank(qli.HSABankingPartner__c) ? qli.HSABankingPartner__c: LGA_UTIL_Constants.BLANK_WITH_PERCENT;
            this.prefix = String.isNotBlank(qli.Prefix__c) ? qli.Prefix__c : LGA_UTIL_Constants.BLANK_WITH_PERCENT;
            
            this.productCategory = String.isNotBlank(qli.ProductCategory__c) ? qli.ProductCategory__c : LGA_UTIL_Constants.BLANK_WITH_PERCENT;           
            this.contractCodes = String.isNotBlank(qli.Contract_Codes__c) ? qli.Contract_Codes__c : LGA_UTIL_Constants.BLANK_WITH_PERCENT;    
            this.parentQuoteLineItem = String.isNotBlank(qli.ParentQuoteLineItem__r.Product2.name) ? qli.ParentQuoteLineItem__r.Product2.name 
                : LGA_UTIL_Constants.BLANK_WITH_PERCENT;  
        }
        
        private void transformPercentValueWithPercentReplacer(QuoteLineItem qli){
            this.productName = (String.isNotBlank(this.productName) 
                                && this.productName.contains(LGA_UTIL_Constants.PERCENT)) 
                ? this.productName.replace(LGA_UTIL_Constants.PERCENT, LGA_UTIL_Constants.PERCENT_REPLACER) 
                : this.productName;
            this.parentQuoteLineItem = (!(this.parentQuoteLineItem.equals(LGA_UTIL_Constants.BLANK_WITH_PERCENT)) 
                                        && this.parentQuoteLineItem.contains(LGA_UTIL_Constants.PERCENT)) 
                ? this.parentQuoteLineItem.replace(LGA_UTIL_Constants.PERCENT,
                                                   LGA_UTIL_Constants.PERCENT_REPLACER): this.parentQuoteLineItem;
        }
    }
    
    
    class DataWrapper
    {
        public List<ProductDetail> productDetail;
        public String productType;
        public String productCategory;       
        
        DataWrapper(List<ProductDetail> productDetail, String productType, String productCategory){
            this.productDetail = productDetail;
            this.productType = productType;
            this.productCategory = productCategory;
        }
    }
}