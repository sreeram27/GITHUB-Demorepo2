/***********************************************************************
@author         Accenture offshore
@date           07/12/2019
@name           LGA_AP01_FetchQLIBasedOnType 
@description    Fetching Quote Line Items based 
                on type and will return to Load Group Omni script
************************************************************************/

global without sharing class LGA_AP01_FetchQLIBasedOnType implements vlocity_ins.VlocityOpenInterface2 {
    public static final String FETCHQLISBASEDONTYPE = 'fetchQLIsBasedOnType';
    public static final String REPLACEPRODNAME = 'ReplacePercentBlank';
    public static final String QUOTEID = 'quoteId';
    public static final String IMPACTEDPRODUCTIDS = 'impactedProductIds';
    public static final String MEDICALPLANNAME = 'MedicalPlanQLI';
    public static final String MEDICALPRODUCTNAME = 'MedicalProductQLI';
    public static final String VISIONPLANNAME = 'VisionQLI';
    public static final String DENTALPLANNAME = 'DentalQLI';
    public static final String FSAPLANNAME = 'FSAQLI';
    public static final String EAPPLANNAME = 'EAPQLI';
    public static final String LDPLANNAME = 'LifeDisabilityQLI';
    public static final String PERCENT = '%';
    public static final String BLANKWITHPERCENT = '% %';
    public static final String PERCENTREPLACER = '%ProductWithPercent%';
    public static final String BLANKSTRING = '';
    
    public static final String MEDICAL = 'Medical';
    public static final String LIFE = 'Life';
    public static final String DISABILITY = 'Disability';   
    public static final String LIFEANDDISABILITY = 'LifeAndDisability'; 
    
    public static final String LOADGROUPIMPACTEDPRODUCTS = 'ImpactedProducts';
    public  Map<String,Object> inputMap = new Map<String,Object>();
    public  Map<String,Object> outMap = new Map<String,Object>();
    public  Map<String,Object> optns = new Map<String,Object>();
    private Map<String,DataWrapper> impactedProductDetails = new Map<String,DataWrapper>();
    

  
    /*********************************************************************************
     * @description Implementation of invokeMethod from VlocityOpenInterface2 interface.
     * @param methodName
     * @param inputMap
     * @param outMap
     * @param optns
     * @return true
     */
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String,Object > outMap, Map < String, Object > optns) {

        if (FETCHQLISBASEDONTYPE.equalsIgnoreCase(methodName)) {
            this.inputMap = inputMap;
            this.outMap = outMap;
            this.optns = optns;
            fetchQLIs();
        }

        if(REPLACEPRODNAME.equalsIgnoreCase(methodName)){
            this.inputMap = inputMap;
            this.outMap = outMap;
            this.optns = optns;
            transformProdDetails();
        }

        return true;
    }


    
     /***************************************************************************************************
     * @description replaces % from productname
     * to output map
     */
    private void transformProdDetails() {

       Map<String,List<Object>> jsonNodeValueMap = new Map<String,List<Object>>();
       List<Object> medPlanProductNameList = inputMap.get(MEDICALPLANNAME) instanceof List<Object> ? (List<Object>)inputMap.get(MEDICALPLANNAME) : null;
       List<Object> medProductNameList = inputMap.get(MEDICALPRODUCTNAME) instanceof List<Object> ? (List<Object>)inputMap.get(MEDICALPRODUCTNAME) : null;
       List<Object> dentalProductNameList = inputMap.get(DENTALPLANNAME) instanceof List<Object> ? (List<Object>)inputMap.get(DENTALPLANNAME) : null;
       List<Object> visionProductNameList = inputMap.get(VISIONPLANNAME) instanceof List<Object> ?(List<Object>)inputMap.get(VISIONPLANNAME) : null;
       List<Object> ldProductNameList = inputMap.get(LDPLANNAME) instanceof List<Object> ? (List<Object>)inputMap.get(LDPLANNAME) : null;

       List<Object> fsaProductNameList = inputMap.get(FSAPLANNAME) instanceof List<Object> ? (List<Object>)inputMap.get(FSAPLANNAME) : null;
       List<Object> eapProductNameList = inputMap.get(EAPPLANNAME) instanceof List<Object> ? (List<Object>)inputMap.get(EAPPLANNAME) : null;

       jsonNodeValueMap.put(MEDICALPLANNAME, medPlanProductNameList);       
       jsonNodeValueMap.put(MEDICALPRODUCTNAME, medProductNameList);       
       jsonNodeValueMap.put(DENTALPLANNAME, dentalProductNameList);       
       jsonNodeValueMap.put(VISIONPLANNAME, visionProductNameList);     
       jsonNodeValueMap.put(LDPLANNAME, ldProductNameList);  
       jsonNodeValueMap.put(FSAPLANNAME, fsaProductNameList);       
       jsonNodeValueMap.put(EAPPLANNAME, eapProductNameList);
       
      transformPercentBlankInJSON(jsonNodeValueMap);
       
    }


     /***************************************************************************************************
     * @description replaces % and null from JSOn node
     * @param Map<String,List<Object>> jsonNodeValueMap
     * 
     */
    private void transformPercentBlankInJSON(Map<String,List<Object>> jsonNodeValueMap){

        for(String jsonNodeName : jsonNodeValueMap.keySet()){
            List<Object> productNameList = jsonNodeValueMap.get(jsonNodeName);    
            List<Object> tranformedProductNameList = new List<Object>();    
            if(productNameList != null && !productNameList.isEmpty()){
                for(Object obj : productNameList){
                    tranformedProductNameList = transform(jsonNodeName, obj,tranformedProductNameList);
            }
            outMap.put(jsonNodeName, tranformedProductNameList);
            }else{               
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

         Map<String,Object> singleProductMap = (Map<String,Object>)inputMap.get(nodeName);
            if(singleProductMap != null){

                List<String> jsonNodeNameListToReplaceBlnk = new List<String>();          

                jsonNodeNameListToReplaceBlnk.add('ProductName');
                jsonNodeNameListToReplaceBlnk.add('Prefix');
                jsonNodeNameListToReplaceBlnk.add('parentQLIProdName');
                
                singleProductMap = replacePercentNBlankWithSpace(jsonNodeNameListToReplaceBlnk,singleProductMap,true);    

               /* String prodName = (String)singleProductMap.get('ProductName');                
                String updatedProdName = (String.isNotBlank(prodName) && prodName.contains(PERCENT)) ? prodName.replace(PERCENT,PERCENTREPLACER) : prodName;
                   
                String parentQLIProdName = (String)singleProductMap.get('ProductName');   
                singleProductMap.put('ProductName', updatedProdName);
                    if(parentQLIProdName != null){
                        String updatedParentQLI = (String.isNotBlank(parentQLIProdName) && parentQLIProdName.contains(PERCENT)) ? parentQLIProdName.replace(PERCENT,PERCENTREPLACER) : parentQLIProdName;
                        singleProductMap.put('ParentQuoteLineItem', updatedParentQLI);
                    }*/
                    
                outMap.put(nodeName, singleProductMap);
        }
    }

    /***************************************************************************************************
     * @description transform % and null from Multiple product
     * @param String nodeName
     * @param Object productObj
     * @param List<Object> transformList
     * 
     */
    private List<Object> transform(String jsonNodeName, Object productObj,List<Object> transformList){

        Map<String,Object> jsonNodeMap = (Map<String,Object>)productObj;

        List<String> jsonNodeNameListToReplaceBlnk = new List<String>();

        jsonNodeNameListToReplaceBlnk.add('ProductContractCode');
        jsonNodeNameListToReplaceBlnk.add('Prefix');
        jsonNodeNameListToReplaceBlnk.add('ParentQuoteLineItem');
        jsonNodeNameListToReplaceBlnk.add('BenefitPeriod');
        jsonNodeNameListToReplaceBlnk.add('AddReasonCode');
        jsonNodeNameListToReplaceBlnk.add('ClaimsRouteCode');
        jsonNodeNameListToReplaceBlnk.add('ProductName');
        
        jsonNodeMap = replacePercentNBlankWithSpace(jsonNodeNameListToReplaceBlnk,jsonNodeMap,false);    
        transformList.add(jsonNodeMap);
        return transformList;
    }


     /***************************************************************************************************
     * @description transform % and null from transformMedicalSpecific Multiple Product
     * @param String jsonNodeName
     * @param Map<String,Object> jsonNodeMap
     * 
     */
  /*  private Map<String,Object> transformMedicalSpecificItem(String jsonNodeName,Map<String,Object> jsonNodeMap){
       
        String planContractCode = (String)jsonNodeMap.get('ProductContractCode');
        String prefix = (String)jsonNodeMap.get('Prefix');
        String parentQuoteLineItem = (String)jsonNodeMap.get('ParentQuoteLineItem');
        jsonNodeMap.put('ProductContractCode',String.isNotBlank(planContractCode) ? planContractCode : BLANKWITHPERCENT);
        jsonNodeMap.put('Prefix',String.isNotBlank(prefix) ? prefix : BLANKWITHPERCENT);                
        jsonNodeMap.put('ParentQuoteLineItem', (String.isNotBlank(parentQuoteLineItem) && parentQuoteLineItem.contains(PERCENT)) ? 
                                                       parentQuoteLineItem.replace(PERCENT,PERCENTREPLACER): (String.isBlank(parentQuoteLineItem)) ? BLANKWITHPERCENT :  parentQuoteLineItem);       
        return jsonNodeMap;
    } */


    private Map<String,Object> replacePercentNBlankWithSpace(List<String> jsonNodeNameList, Map<String,Object> jsonMap, boolean isSingleProduct){
        for(String jsonNodeName:jsonNodeNameList){
            String jsonNodeVal  = (String)jsonMap.get(jsonNodeName);
            if(isSingleProduct && jsonNodeVal != null){
                jsonMap.put(jsonNodeName,String.isNotBlank(jsonNodeVal) ? (jsonNodeVal.contains(PERCENT) ? jsonNodeVal.replace(PERCENT,PERCENTREPLACER):jsonNodeVal) : BLANKWITHPERCENT);
            }else{
                 jsonMap.put(jsonNodeName,String.isNotBlank(jsonNodeVal) ? (jsonNodeVal.contains(PERCENT) ? jsonNodeVal.replace(PERCENT,PERCENTREPLACER):jsonNodeVal) : BLANKWITHPERCENT);
            }
        }

        return jsonMap;

    }



   


   
     /***************************************************************************************************
     * @description Adds a list of impacted products based on product type from Parent Quote
     * to output map
     */
    private void fetchQLIs() {
        system.debug('***********************************TEST PRH START*******************************************');
        //string quoteId = (String) optns.get(QUOTEID);
        string impactedProductIds = (String) optns.get(IMPACTEDPRODUCTIDS);
        List<String> qliIdsList = impactedProductIds.split(',');
        List<QuoteLineItem> listQuoteLineItems = checkAccessibilityAndQuery(qliIdsList);

        if(!listQuoteLineItems.isEmpty())
        {
            for(QuoteLineItem qli : listQuoteLineItems)
            {               
                putDataIntoImpactedProductMap(qli);              
            }
        
        } 

        outMap.put(LOADGROUPIMPACTEDPRODUCTS, impactedProductDetails);
    }

  
     /**
     * @description This method validates FLS on SOQL before querying it and returns impacted quote line item product list 
     * @param qliList
     * @return qliList
     */
    private List<QuoteLineItem> checkAccessibilityAndQuery(List<String> qliIdsList){
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
         if (Schema.sObjectType.QuoteLineItem.isAccessible() && 
          Schema.sObjectType.Product2.isAccessible() && 
          Schema.sObjectType.QuoteLineItem.fields.ProductCategory__c.isAccessible() &&     
          Schema.sObjectType.QuoteLineItem.fields.Contract_Codes__c.isAccessible()) {

        qliList = [Select id,Product2.Name,Product2.Product_Type__c, QuoteId, ProductCategory__c, Contract_Codes__c, ParentQuoteLineItem__c,ParentQuoteLineItem__r.Product2.Name,Prefix__c,Benefit_Period__c,Add_Reason_Code__c,Claims_Route_Code__c from QuoteLineItem where Id IN : qliIdsList];
        
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
                String keyName = (productType == MEDICAL) ? (productType + productCategory) : 
                                 (productType == LIFE || productType == DISABILITY) ? LIFEANDDISABILITY : productType;
               
                ProductDetail product = new ProductDetail(qli);
                if(impactedProductDetails.containsKey(keyName)){
                    DataWrapper dw = impactedProductDetails.get(keyName);
                    dw.productDetail.add(product);
                }else{
                    List<productDetail> newProdTypeList = new List<productDetail>();
                    newProdTypeList.add(product);
                    DataWrapper newProdDw = new DataWrapper(newProdTypeList, productType, productCategory);
                    impactedProductDetails.put(keyName, newProdDw); 
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
        
        
      
        ProductDetail(QuoteLineItem qli){
            this.id = qli.id;
             this.quoteId = qli.QuoteId;
            this.productName = qli.Product2.Name;           
            this.parentQuoteLineItemId = qli.ParentQuoteLineItem__c;
            transformBlankValue(qli);
            transformPercent(qli);
            
        }

        private void transformPercent(QuoteLineItem qli){

            if(String.isNotBlank(this.productName) && this.productName.contains(PERCENT)){
               this.productName = this.productName.replace(PERCENT, PERCENTREPLACER);
            }
            
            if(!(this.parentQuoteLineItem.equals(BLANKWITHPERCENT)) && this.parentQuoteLineItem.contains(PERCENT)){
               this.parentQuoteLineItem = this.parentQuoteLineItem.replace(PERCENT, PERCENTREPLACER);
            }
        }

        private void transformBlankValue(QuoteLineItem qli){

            
            this.benefitPeriod= String.isNotBlank(qli.Benefit_Period__c) ? qli.Benefit_Period__c : BLANKWITHPERCENT;  
            this.addReasonCode= String.isNotBlank(qli.Add_Reason_Code__c) ? qli.Add_Reason_Code__c : BLANKWITHPERCENT;
            this.claimsRouteCode= String.isNotBlank(qli.Claims_Route_Code__c) ? qli.Claims_Route_Code__c : BLANKWITHPERCENT;
            this.prefix = String.isNotBlank(qli.Prefix__c) ? qli.Prefix__c : BLANKWITHPERCENT;
           
            this.productCategory = String.isNotBlank(qli.ProductCategory__c) ? qli.ProductCategory__c : BLANKWITHPERCENT;           
            this.contractCodes = String.isNotBlank(qli.Contract_Codes__c) ? qli.Contract_Codes__c : BLANKWITHPERCENT;    
            this.parentQuoteLineItem = String.isNotBlank(qli.ParentQuoteLineItem__r.Product2.name) ? qli.ParentQuoteLineItem__r.Product2.name : BLANKWITHPERCENT;            
           
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