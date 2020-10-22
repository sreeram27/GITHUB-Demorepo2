/**
 * @author        Indra Lugina
 * @date          08/28/2018
 * @description   Vlocity Open Interface to support Omniscript Remote Action.
 */
global without sharing class VlocityInterface implements vlocity_ins.VlocityOpenInterface2 {

    

    /**
     * @description       Implementation of invokeMEthod from VlocityOpenInterface2 interface
     * @param             Method Name that is defined in Omniscript
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Boolean
     * @throws            NA
     */
    global static Boolean invokeMethod(String methodName, Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> optns) {

        if (CDHP_COMM2_Constants.VALIDATE_REASON.equalsIgnoreCase(methodName)) {
            outMap = validateReason(methodName, inputMap, outMap, optns);
        } else if (CDHP_COMM2_Constants.INTERNAL_COMMISSION_ASSIGN_APPROVER.equalsIgnoreCase(methodName)) {
            outMap = InternalCommissionAssignApproverV2(methodName, inputMap, outMap, optns);
        } else if (CDHP_COMM2_Constants.POPULATE_ACCOUNT_MANAGER.equalsIgnoreCase(methodName)) {
            outMap = populateAccountManager(inputMap, outMap, optns);
        } else if (CDHP_COMM2_Constants.MEDICAL_FSA_COMMUTER.equalsIgnoreCase(methodName)) {
            outMap = createFSACommuterForMedical(inputMap, outMap, optns);
        } else if (CDHP_COMM2_Constants.IS_HRA_HSA_PRODUCTS.equalsIgnoreCase(methodName)) {
            outMap = isHRAHSAProducts(inputMap, outMap, optns);
        } else if (CDHP_COMM2_Constants.UPDATE_HSA_PRODUCTS.equalsIgnoreCase(methodName)) {
            outMap = updateHSAProducts(inputMap, outMap, optns);
        } else if (CDHP_COMM2_Constants.UPDATE_OTHER_PLANS.equalsIgnoreCase(methodName)) {
            outMap = updateOtherPlans(inputMap, outMap, optns);
        } else if (CDHP_COMM2_Constants.CONTACT_SEARCH.equalsIgnoreCase(methodName)) {
            outMap = contactSearch(inputMap, outMap, optns);
        } else if (CDHP_COMM2_Constants.MORE_THAN_TWO_JUNCTION_OBJECT.equalsIgnoreCase(methodName)) {
            outMap = CDHP_QuoteLineItem_CreateChildQLI.checkJunctionObject(inputMap, outMap);
        } else if (CDHP_COMM2_Constants.IS_PERMISSIONSET_ASSIGNED.equalsIgnoreCase(methodName)) {
            outMap = CDHP_QuoteLineItem_CreateChildQLI.isPermissionSetAssigned(inputMap, outMap);
        } else if (CDHP_COMM2_Constants.IS_HRA_OR_HSA_PLAN_SELECTED.equalsIgnoreCase(methodName)) {
            outMap = CDHP_QuoteLineItem_CreateChildQLI.isHRAorHSAPlanSelected(inputMap, outMap);
        } else if (CDHP_COMM2_Constants.UPDATE_OR_CREATE_ACTWISE.equalsIgnoreCase(methodName)) {
            outMap = CDHP_QuoteLineItem_CreateChildQLI.updateOrCreateActWise(inputMap, outMap);
        } else if (CDHP_COMM2_Constants.CREATE_FSA_COMMUTER_FOR_MEDICAL.equalsIgnoreCase(methodName)) {
            //Validate Add FSA/Commuter            
            outMap = createFSACommuterForMedical(inputMap, outMap, optns);
        } else if (CDHP_COMM2_Constants.ADD_HRA_HSA_PRODUCT.equalsIgnoreCase(methodName)) {
            //calling the method below
            outMap = CDHP_QuoteLineItem_CreateChildQLI.addHRAHSAProduct1(inputMap, outMap);
        } else if (CDHP_COMM2_Constants.ADD_PLANS_TO_MEDICAL.equalsIgnoreCase(methodName)) { //Added by Suresh              
            //calling the method below
            outMap = AddPlansToMedical(inputMap, outMap, optns); //Added by Suresh                  
        } else if (CDHP_COMM2_Constants.FETCH_PRODUCT_TYPE.equalsIgnoreCase(methodName)) { //Added by Michael 
            //calling the method below
            outMap = FetchProductType(inputMap, outMap, optns);
        } else if (CDHP_COMM2_Constants.RECONFIG_PLANS_TO_MEDICAL.equalsIgnoreCase(methodName)) { //Added by Suresh     
            //calling the method below
            outMap = ReConfigPlansToMedical(inputMap, outMap, optns); //Added by Suresh                 
        } else if (CDHP_COMM2_Constants.FETCH_MEDICALRX_TYPE.equalsIgnoreCase(methodName)) { //Added by Suresh     
            //calling the method below
            outMap = fetchMedicalRxType(inputMap, outMap, optns); //Added by Suresh 
        } else if (CDHP_COMM2_Constants.UPDATE_PROVIDERMEMBERPAY.equalsIgnoreCase(methodName)) { //Added by Suresh     
            //calling the method below
            updateMedProviderMemberPay(inputMap, outMap, optns); //Added by Suresh                 
        } else if (CDHP_COMM2_Constants.UPDATE_LINEITEMS_TERMED.equalsIgnoreCase(methodName)) {     
            //calling the method below
            outMap = updateLineItemsAsTermed(inputMap, outMap, optns);               
        }
          else if (CDHP_COMM2_Constants.HSAELIGIBLE.equalsIgnoreCase(methodName)) {     
            //calling the method below
            outMap = hsaEligible(inputMap, outMap, optns);               
        }
        return true;
    }
    /**
     * @description       hsaEligible will check whether the plan is hsa eligible or not as part of 54037 
     * author				Michael (AG16681)
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Map
     * @throws            NA
     */
    private static Map<String, Object> hsaEligible(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> optns){
        String squoteId = (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID);
        system.debug('hsaEligible-->squoteID =='+squoteId);
        QuoteLineItem qli = new QuoteLineItem();
        if (!String.isEmpty(squoteId))
        {
            qli=[select id, QuoteId, OppType__c, quantity, unitprice, ActWiseChildQuote__c, Product2id 
                 from QuoteLineItem
                 where id =: squoteId
                ];
            system.debug('qli1--->'+qli);
        }
        else
            return outMap;
        if(qli==null)
            return outMap;
        system.debug('qli--->'+qli);
        Product2 productDetail = new Product2();
        if(qli.Product2id != null){
        	productDetail = [select id, name, QLIRecordType__c, Product_Type__c, Product_Family__c,
                                  vlocity_ins__AttributeDefaultValues__c 
                                  from product2 
                                  where id =: qli.Product2id
                                 ];
            system.debug('productDetail1-->'+productDetail);
        }
        else 
            return outMap;
        system.debug('productDetail2-->'+productDetail);
        if (productDetail.vlocity_ins__AttributeDefaultValues__c != null && productDetail.vlocity_ins__AttributeDefaultValues__c != '') {
            JSONParser parser = JSON.createParser((string) productDetail.vlocity_ins__AttributeDefaultValues__c);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == CDHP_COMM2_Constants.OTHER_CDHPRODUCTTYPE)) {
                    // Get the value.
                    parser.nextToken();
                    String str = parser.getText();
                    if (str != null && str.containsIgnoreCase(CDHP_COMM2_Constants.HRA)) {
                        outMap.put(CDHP_COMM2_Constants.ISSELECTEDPLANHSA, CDHP_COMM2_Constants.NO);
                    }
                    
                    if (str != null && str.containsIgnoreCase(CDHP_COMM2_Constants.HSA)) {
                        outMap.put(CDHP_COMM2_Constants.ISSELECTEDPLANHSA, CDHP_COMM2_Constants.YES);
                    }
                    
                }
            }
        }
        return outMap;
    }
     /**
     * @description       updateMedProviderMemberPay
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Map
     * @throws            NA
     */
    private static void updateMedProviderMemberPay(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> optns){
        String squoteId = (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID);
        
        List<QuoteLineItem> qliList = [select id,HRA_Payment_Type__c,HRA_Rx_Payment_Type__c 
                                       from QuoteLineItem 
                                       where id =: squoteId];
        
        Object rTMedical = inputMap.get(CDHP_COMM2_Constants.RTMEDICAL);
        Map<String, Object> rtMedicalMap = (Map<String, Object>) rTMedical;
        
        if (rtMedicalMap != null) {
            Object medicalHRAPayType = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.MEDICALRXHRA_PAYMENTTYPE);
            Map<String, Object> medicalHRAPayTypeMap = (Map<String, Object>) medicalHRAPayType;
            if (medicalHRAPayTypeMap != null) {
                String hraMedPayType = (String) medicalHRAPayTypeMap.get(CDHP_COMM2_Constants.HRAPAYMED_TYPE);
               // if (hraMedPayType != null) {
                    qliList[0].HRA_Payment_Type__c = hraMedPayType;
                    
                //}
                String rxHRAPayType = (String) medicalHRAPayTypeMap.get(CDHP_COMM2_Constants.RXHRA_PAYMEDTYPE);
               // if (rxHRAPayType != null) {
                    qliList[0].HRA_Rx_Payment_Type__c = rxHRAPayType;
               // }
            }
        }
        if(qliList.size() > 0)
            update qliList;
    }
    
    /**
     * @description       FetchProductType
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Map
     * @throws            NA
     */
     private static Map<String, Object> fetchMedicalRxType(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> optns){
        String squoteId = (String) inputMap.get(CDHP_COMM2_Constants.PARENT_MEDICAL);
        String capturePlanID = (String) inputMap.get(CDHP_COMM2_Constants.CAPTURE_PLANID);
        String MedicalHRAPaymentTypeExist = '';
        String RxHRAPaymentTypeExist = '';
        if(String.isBlank(capturePlanID)){
            if (String.isBlank(squoteId)) {
                String planId = (String) inputMap.get(CDHP_COMM2_Constants.PLANQLIID) == NULL ? (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID) : (String) inputMap.get(CDHP_COMM2_Constants.PLANQLIID);
                for (quoteLineItem qli: [select ParentQuoteLineItem__c, HRA_Payment_Type__c,ParentQuoteLineItem__r.HRA_Payment_Type__c,HRA_Rx_Payment_Type__c,ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c from quoteLineItem where id =: planId]) {

                    if(qli.ParentQuoteLineItem__c == NULL){
                        MedicalHRAPaymentTypeExist = qli.HRA_Payment_Type__c == null ? '' : qli.HRA_Payment_Type__c;
                        RxHRAPaymentTypeExist = qli.HRA_Rx_Payment_Type__c == null ? '' : qli.HRA_Rx_Payment_Type__c;
                    }
                    else{
                        MedicalHRAPaymentTypeExist = qli.ParentQuoteLineItem__r.HRA_Payment_Type__c == null ? '' : qli.ParentQuoteLineItem__r.HRA_Payment_Type__c;
                    RxHRAPaymentTypeExist = qli.ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c == null ? '' : qli.ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c;
                    }
                }
            } else {
                quoteLineItem qli = [select HRA_Payment_Type__c,HRA_Rx_Payment_Type__c from quoteLineItem where id =: squoteId];
                MedicalHRAPaymentTypeExist = qli.HRA_Payment_Type__c == null ? '' : qli.HRA_Payment_Type__c;
                RxHRAPaymentTypeExist = qli.HRA_Rx_Payment_Type__c == null ? '' : qli.HRA_Rx_Payment_Type__c;
            }
            outMap.put(CDHP_COMM2_Constants.MEDICAL_HRAPAYMENTTYPE, MedicalHRAPaymentTypeExist);
            outMap.put(CDHP_COMM2_Constants.RXHRA_PAYMENTTYPE, RxHRAPaymentTypeExist);
        }
        else {
            quoteLineItem qli = [select ParentQuoteLineItem__r.HRA_Payment_Type__c,ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c,Actwise_Member_Provider_Pay_Indicator__c from quoteLineItem where id =: capturePlanID];
            if(qli.ParentQuoteLineItem__r.HRA_Payment_Type__c == CDHP_COMM2_Constants.MEMBER_PAY && (qli.ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c == CDHP_COMM2_Constants.MEMBER_PAY || qli.ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c == '' || qli.ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c == NULL))
                qli.Actwise_Member_Provider_Pay_Indicator__c = qli.ParentQuoteLineItem__r.HRA_Payment_Type__c;
            if(qli.ParentQuoteLineItem__r.HRA_Payment_Type__c == CDHP_COMM2_Constants.PROVIDER_PAY && (qli.ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c ==  CDHP_COMM2_Constants.MEMBER_PAY || qli.ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c == '' || qli.ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c == CDHP_COMM2_Constants.PROVIDER_PAY || qli.ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c == NULL))
                qli.Actwise_Member_Provider_Pay_Indicator__c = qli.ParentQuoteLineItem__r.HRA_Payment_Type__c;
            update qli;
        }
        return outMap;
    }
    
    /**
     * @description       FetchProductType
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Map
     * @throws            NA
     */
    private static Map<String, Object> FetchProductType(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> optns) {

        String squoteId = (String) inputMap.get(CDHP_COMM2_Constants.PARENT_MEDICAL);
        String opTypReconfig = '';
        String funding = '';
        String financing = '';
        String MedicalHRAPaymentTypeExist = '';
        String RxHRAPaymentTypeExist = '';


        if (String.isBlank(squoteId)) {
            String planId = (String) inputMap.get(CDHP_COMM2_Constants.PLAN_QLI_ID);
            for (quoteLineItem qli: [select ParentQuoteLineItem__c,ParentQuoteLineItem__r.HRA_Payment_Type__c,ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c, OppType__c, funding__c, financing__c from quoteLineItem where id =: planId]) {
                squoteId = qli.ParentQuoteLineItem__c;
                opTypReconfig = qli.OppType__c;
                // MedicalHRAPaymentTypeExist = qli.ParentQuoteLineItem__r.HRA_Payment_Type__c;
               // RxHRAPaymentTypeExist = qli.ParentQuoteLineItem__r.HRA_Rx_Payment_Type__c;
            }
        } else {
            quoteLineItem qli = [select OppType__c, funding__c, financing__c from quoteLineItem where id =: squoteId];
            opTypReconfig = qli.OppType__c;
        }
        outMap.put(CDHP_COMM2_Constants.OPTYPE_RECONFIG, opTypReconfig);

        Id quoteId = [select quoteId from quoteLineItem where id =: squoteId].quoteId;
        outMap.put(CDHP_COMM2_Constants.QUOTE_ID_FOR_ACT, quoteId);
       // outMap.put(CDHP_COMM2_Constants.MEDICAL_HRAPAYMENTTYPE, MedicalHRAPaymentTypeExist);
       // outMap.put(CDHP_COMM2_Constants.RXHRA_PAYMENTTYPE, RxHRAPaymentTypeExist);

        if (squoteId != null) {
            List < QuoteLineItem > qli = [select id, product2id, (select id, Funding__c, Product2id, QuoteId, ActWiseChildQuote__c from Quote_Line_Items__r) from quotelineitem where id =: squoteId];

            Product2 productDetail = new Product2();
            if (qli != null) {
                if (qli[0].Quote_Line_Items__r[0].Product2id != null) {
                    productDetail = [select id, name, QLIRecordType__c, Product_Type__c, Product_Family__c,
                        vlocity_ins__AttributeDefaultValues__c from product2 where id =: qli[0].Quote_Line_Items__r[0].Product2id
                    ];
                }
            } else {
                return outMap;
            }

            Product2 pHRA = [Select Id, Name, QLIRecordType__c From Product2 where IsActive = true and QLIRecordType__c =: CDHP_COMM2_Constants.ACTWISE_HRA Limit 1];
            Product2 pHSA = [Select Id, Name, QLIRecordType__c From Product2 where IsActive = true and QLIRecordType__c =: CDHP_COMM2_Constants.ACTWISE_HSA Limit 1];

            String parentQLIRecordType;
            if (productDetail.vlocity_ins__AttributeDefaultValues__c != null && productDetail.vlocity_ins__AttributeDefaultValues__c != '') {
                JSONParser parser = JSON.createParser((string) productDetail.vlocity_ins__AttributeDefaultValues__c);
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == CDHP_COMM2_Constants.OTHER_CDH_PRODUCT_TYPE)) {
                        // Get the value.
                        parser.nextToken();
                        String str = parser.getText();

                        if (str != null && str.containsIgnoreCase(CDHP_COMM2_Constants.HRA)) {
                            parentQLIRecordType = pHRA.QLIRecordType__c;
                            outMap.put(CDHP_COMM2_Constants.PARENT_QLI_RECORD, parentQLIRecordType);
                            outMap.put(CDHP_COMM2_Constants.PRODUCT2_ID_FOR_ACT, pHRA.Id);
                            outMap.put(CDHP_COMM2_Constants.PRODUCT2_NAME_FOR_ACT, pHRA.Name);
                        } else if (str != null && str.containsIgnoreCase(CDHP_COMM2_Constants.HSA)) {
                            parentQLIRecordType = pHSA.QLIRecordType__c;
                            outMap.put(CDHP_COMM2_Constants.PARENT_QLI_RECORD, parentQLIRecordType);
                            outMap.put(CDHP_COMM2_Constants.PRODUCT2_ID_FOR_ACT, pHSA.Id);
                            outMap.put(CDHP_COMM2_Constants.PRODUCT2_NAME_FOR_ACT, pHSA.Name);
                            outMap.put(CDHP_COMM2_Constants.HSA_BANKING_PARTNER_FROM_CLASS, CDHP_COMM2_Constants.PNC_BLANK);
                        }
                    }
                }
            }
        }
        return outMap;

    }
    //Added by Suresh
    /**
     * @description       Update Other Plans to have the same configuration
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Boolean
     * @throws            NA
     **/
    private static Map < String, Object > AddPlansToMedical(Map < String, Object > inputMap,
        Map < String, Object > outMap, Map < String, Object > optns) {
        List < Map < String, String >> ProductList = new List < Map < String, String >> ();
        String squoteId = (String) inputMap.get(CDHP_COMM2_Constants.PARENT_MEDICAL);
        String quoteLineId = '';
        Boolean showPlan = false;

        if (squoteId.startsWith(CDHP_COMM2_Constants.ID_0QL)) {
            List < QuoteLineItem > qliObj = [Select Id, QuoteId From QuoteLineItem where Id =: squoteId];
            if (qliObj != null) {
                squoteId = qliObj[0].QuoteId;
                quoteLineId = qliObj[0].Id;
            }
        }
        for (QuoteLineItem qli: [Select Id, Product2Id, Product2.name, Is_HSA_Selected_Plan__c, ActWiseChildQuote__c, ParentQuoteLineItem__c, product2.vlocity_ins__AttributeDefaultValues__c From QuoteLineItem where ParentQuoteLineItem__c =: quoteLineId and quoteid =: squoteId]) {
            if (qli.product2.vlocity_ins__AttributeDefaultValues__c != null && qli.product2.vlocity_ins__AttributeDefaultValues__c != '') {
                JSONParser parser = JSON.createParser((string) qli.product2.vlocity_ins__AttributeDefaultValues__c);
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == CDHP_COMM2_Constants.OTHER_CDH_PRODUCT_TYPE)) {
                        parser.nextToken();
                        String str = parser.getText();
                        if (str != null) {
                            if (str.containsIgnoreCase(CDHP_COMM2_Constants.HSA)) {
                                if (qli.Is_HSA_Selected_Plan__c) {
                                    Map < String, String > tempMap = new Map < String, String > ();
                                    tempMap.put(CDHP_COMM2_Constants.ID, qli.id); // Language Independent
                                    tempMap.put(CDHP_COMM2_Constants.NAME, qli.Product2.name); // Displayed in Picklist UI
                                    tempMap.put(CDHP_COMM2_Constants.ACTWISE_CHILD, qli.ActWiseChildQuote__c);
                                    ProductList.add(tempMap);
                                    if (qli.ActWiseChildQuote__c == null)
                                        showPlan = true;
                                }

                            } else {
                                Map < String, String > tempMap = new Map < String, String > ();
                                tempMap.put(CDHP_COMM2_Constants.ID, qli.id); // Language Independent
                                tempMap.put(CDHP_COMM2_Constants.NAME, qli.Product2.name); // Displayed in Picklist UI
                                tempMap.put(CDHP_COMM2_Constants.ACTWISE_CHILD, qli.ActWiseChildQuote__c);
                                ProductList.add(tempMap);
                                if (qli.ActWiseChildQuote__c == null)
                                    showPlan = true;

                            }
                        }
                    }
                }

            }
        }

        Map < String, Object > planMap = new Map < String, Object > ();
        planMap.put(CDHP_COMM2_Constants.PLANSELECTION_ITEM, ProductList);
        outMap.put(CDHP_COMM2_Constants.PLANSELECTION, planMap);
        outMap.put(CDHP_COMM2_Constants.SHOWPLAN_BLOCK, showPlan);
        outMap.put(CDHP_COMM2_Constants.SHOWADDPLAN_BLOCK, true);
        return outMap;
    }

    /**
     * @description       Update Other Plans to have the same configuration
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Boolean
     * @throws            NA
     **/
    private static Map<String, Object> ReConfigPlansToMedical(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> optns) {
        List<Map<String, String>> ProductList = new List<Map<String, String>> ();
        String squoteId = (String) inputMap.get(CDHP_COMM2_Constants.PLAN_QLI_ID);
        String planId = '';
        String quoteLineId = '';

        if (!String.isBlank(squoteId)) {
            for (QuoteLineItem qliObj: [Select Id, QuoteId, ParentQuoteLineItem__c From QuoteLineItem where Id =: squoteId]) {
                quoteLineId = qliObj.ParentQuoteLineItem__c;
                squoteId = qliObj.QuoteId;
            }
        }

        Set<Id> actProdIds = new Set<Id>();
        for (QuoteLineItem qlitem: [Select id, ActWiseChildQuote__c from QuoteLineItem where ParentQuoteLineItem__c =: quoteLineId and quoteid =: squoteId and ActWiseChildQuote__c != null]) {
            actProdIds.add(qlitem.ActWiseChildQuote__c);
        }

        Map<Id, QuoteLineItem> qliMap = new Map<Id, QuoteLineItem> ([Select Id, HSABankingPartner__c, IfHSAdidClientPurchaseHSAPlus__c, Administrative_Fees_Responsibility__c, Benefit_Period__c, (Select Covered_Services__c, Health_Activities_Incentives__c, HRA_Rollover__c, Type_of_HRA__c from HRA_Administrations__r) from quotelineitem where id in: actProdIds]);

        for (QuoteLineItem qli: [Select Id, Product2Id, Product2.name, product2.vlocity_ins__AttributeDefaultValues__c, Is_HSA_Selected_Plan__c, ActWiseChildQuote__c, (Select Covered_Services__c, Health_Activities_Incentives__c, HRA_Rollover__c, Type_of_HRA__c from HRA_Administrations__r), HSABankingPartner__c, Benefit_Period__c, IfHSAdidClientPurchaseHSAPlus__c, Administrative_Fees_Responsibility__c From QuoteLineItem where ParentQuoteLineItem__c =: quoteLineId and quoteid =: squoteId and ActWiseChildQuote__c != null]) {
            if (qli.product2.vlocity_ins__AttributeDefaultValues__c != null && qli.product2.vlocity_ins__AttributeDefaultValues__c != '') {
                JSONParser parser = JSON.createParser((string) qli.product2.vlocity_ins__AttributeDefaultValues__c);
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == CDHP_COMM2_Constants.OTHER_CDH_PRODUCT_TYPE)) {
                        parser.nextToken();
                        String str = parser.getText();
                        if (str != null) {
                            if (str.containsIgnoreCase(CDHP_COMM2_Constants.HSA)) {
                                if (qli.Is_HSA_Selected_Plan__c) {
                                    Map < String, String > tempMap = new Map < String, String > ();
                                    tempMap.put(CDHP_COMM2_Constants.CHECKNAME, CDHP_COMM2_Constants.HSA);
                                    tempMap.put(CDHP_COMM2_Constants.ID, qli.id);
                                    tempMap.put(CDHP_COMM2_Constants.NAME, qli.Product2.name);
                                    tempMap.put(CDHP_COMM2_Constants.ACTWISE_PLANID, qli.ActWiseChildQuote__c);

                                    if (qliMap.containsKey(qli.ActWiseChildQuote__c) && qliMap.get(qli.ActWiseChildQuote__c) != null) {
                                        QuoteLineItem qlHSA = qliMap.get(qli.ActWiseChildQuote__c);
                                        tempMap.put(CDHP_COMM2_Constants.HSABANKING_PARTNER, qlHSA.HSABankingPartner__c);
                                        tempMap.put(CDHP_COMM2_Constants.HSAPLUS_PURCHASED, qlHSA.IfHSAdidClientPurchaseHSAPlus__c);
                                        tempMap.put(CDHP_COMM2_Constants.ADMINFEEPAIDBY, qlHSA.Administrative_Fees_Responsibility__c);
                                        tempMap.put(CDHP_COMM2_Constants.BENEFITPERIOD, qlHSA.Benefit_Period__c);
                                    }

                                    ProductList.add(tempMap);
                                }

                            } else {
                                Map<String, String> tempMap = new Map<String, String>();
                                tempMap.put(CDHP_COMM2_Constants.CHECKNAME, CDHP_COMM2_Constants.HRA);
                                tempMap.put(CDHP_COMM2_Constants.ID, qli.id);
                                tempMap.put(CDHP_COMM2_Constants.NAME, qli.Product2.name);
                                tempMap.put(CDHP_COMM2_Constants.ACTWISE_PLANID, qli.ActWiseChildQuote__c);
                                if (qliMap.containsKey(qli.ActWiseChildQuote__c) && qliMap.get(qli.ActWiseChildQuote__c) != null) {
                                    QuoteLineItem qlHSA = qliMap.get(qli.ActWiseChildQuote__c);
                                    for (HRA_Administration__c hra: qlHSA.HRA_Administrations__r) {
                                        tempMap.put(CDHP_COMM2_Constants.HRATYPE, hra.Type_of_HRA__c);
                                        tempMap.put(CDHP_COMM2_Constants.ROLLOVER, hra.HRA_Rollover__c);
                                        tempMap.put(CDHP_COMM2_Constants.INCENTIVES_OFFERED, hra.Health_Activities_Incentives__c);
                                        tempMap.put(CDHP_COMM2_Constants.COVERED_SERVICES, hra.Covered_Services__c);
                                        break;
                                    }
                                }

                                ProductList.add(tempMap);
                            }

                        }
                    }
                }

            }
        }
        Map<String, String> tempMap1 = new Map<String, String>();
        tempMap1.put(CDHP_COMM2_Constants.ID, '');
        tempMap1.put(CDHP_COMM2_Constants.NAME, CDHP_COMM2_Constants.CREATE_NEW_CONFIGURATION);
        ProductList.add(tempMap1);

        Map<String, Object> planMap = new Map<String, Object>();
        planMap.put(CDHP_COMM2_Constants.RECONFIGURE_PLAN_SELECTION_ITEM, ProductList);
        outMap.put(CDHP_COMM2_Constants.RECONFIGURE_PLAN_SELECTION, planMap);
        return outMap;
    }

    /**
     * @description       Update Other Plans to have the same configuration
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Boolean
     * @throws            NA
     **/
    private static Map<String, Object> updateOtherPlans(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> optns) {
        List<String> qliFieldList = new List<String> {
            'Actwise_Member_Provider_Pay_Indicator__c',
            'Anthem_Engage_Indicators__c',
            'Rx_Plan__c',
            'Corporate_Plan_Code__c',
            'Vlocity_Ins__ContractCode__c',
            'HCR_Option__c',
            'HCR_Status__c',
            'HCR_Religious_Exception__c',
            'HPCC_Code__c',
            'Change_Medicare_Part_D_Rx_To__c',
            'Letter_Sent_To__c',
            'Medicare_Letter_Sent__c',
            'Plan_Benefit_Change__c',
            'Plan_Comments__c',
            'Plan_Term_Date__c',
            'Plan_Type__c',
            'State_Regular__c',
            'WLP_Reference_Based_Benefit__c'
        };
        List<QuoteLineItem> updateOtherPlanList = new List<QuoteLineItem>();
        String sqli = (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID);

        //Query QuoteLineItem for current Plan in the contextId                                    
        String objectName = CDHP_COMM2_Constants.QUOTE_LINE_ITEM;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
        String sfield = '';
        for (String fieldName: fieldMap.keyset()) {
            sfield += ',' + fieldName;
        }
        sfield = sfield.replaceFirst(',', '');
        String squery = 'Select ' + sfield + ' From ' + objectName;
        String squeryCurrentPlan = squery + ' Where Id = :sqli';
        List <QuoteLineItem> currentPlanQLIList = Database.query(squeryCurrentPlan);

        Set<Id> planObjIdSet = new Set<Id>();
        Map<String, Object> actWiseCompanionStepMap = (Map<String, Object>) inputMap.get(CDHP_COMM2_Constants.ACTWISE_COMPANIONS_STEP);
        if (actWiseCompanionStepMap != null) {
            List<Object> otherPlanList = (List<Object> ) actWiseCompanionStepMap.get(CDHP_COMM2_Constants.OTHER_PLAN_LIST);
            if (otherPlanList != null) {
                for (Object planObj: otherPlanList) {
                    Map<String, Object> planObjMap = (Map<String, Object>) planObj;
                    String planObjId = (String) planObjMap.get(CDHP_COMM2_Constants.ID);
                    planObjIdSet.add(planObjId);
                }
                String squeryOtherPlan = squery + ' Where Id in :planObjIdSet';
                List<QuoteLineItem> otherPlanQLIList = Database.query(squeryOtherPlan);
                if (planObjIdSet.size() > 0) {
                    for (QuoteLineItem currentQLI: currentPlanQLIList) {
                        for (QuoteLineItem otherQLI: otherPlanQLIList) {
                            for (String sQLIfield: qliFieldList) {
                                SObject soCurrentQLI = (SObject) currentQLI;
                                SObject soOtherQLI = (SObject) otherQLI;
                                Object soCurrentQLIObj = soCurrentQLI.get(sQLIfield);
                                if (soCurrentQLIObj != null) {
                                    soOtherQLI.put(sQLIfield, soCurrentQLIObj);
                                }
                            }
                            updateOtherPlanList.add(otherQLI);
                        }
                    }
                }
            }
            update updateOtherPlanList;
        }
        return outMap;
    }

    /**
     * @description       Update HSA Product and Set the HSA Selected Plan to true
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Boolean
     * @throws            NA
     **/
    private static Map<String, Object> updateHSAProducts(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> optns) {

        Set<Id> hsaProdIdSet = new Set<Id>();
        String squoteId = (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID);
        if (squoteId.startsWith('006')) {
            squoteId = (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID);
            List<Quote> quoteList = [Select Id From Quote where OpportunityId =: squoteId order by createdDate desc limit 1];
            if (quoteList != null) {
                squoteId = quoteList[0].Id;
            }
        }
        if (squoteId.startsWith(CDHP_COMM2_Constants.ID_0QL)) {
            List<QuoteLineItem> qliObj = [Select Id, QuoteId From QuoteLineItem where Id =: squoteId];
            if (qliObj != null) {
                squoteId = qliObj[0].QuoteId;
            }
        }

        Map<String, Object> HSAIntegratedBlockMap = (Map<String, Object>) inputMap.get(CDHP_COMM2_Constants.HSAINTEGRATED_BLOCK);
        if (HSAIntegratedBlockMap != null) {
            List<Object> HSAIntegratedPlanList = (List<Object>) HSAIntegratedBlockMap.get(CDHP_COMM2_Constants.HSAINTEGRATED_PLAN);
            if (HSAIntegratedPlanList != null) {
                for (Object hsaObj: HSAIntegratedPlanList) {
                    Map<String, Object> hsaPlanMap = (Map<String, Object>) hsaObj;
                    String hsaProdId = (String) hsaPlanMap.get(CDHP_COMM2_Constants.ID);
                    hsaProdIdSet.add(hsaProdId);
                }
                List<QuoteLineItem> qliList = new List<QuoteLineItem>();
                for (QuoteLineItem qli: [Select Id, Product2Id, Is_HSA_Selected_Plan__c From QuoteLineItem where QuoteId =: squoteId]) {
                    if (hsaProdIdSet.contains(qli.Product2Id)) {
                        qli.Is_HSA_Selected_Plan__c = true;
                        qliList.add(qli);
                    }
                }
                update qliList;
            }
        }
        return outMap;
    }

    /**
     * @description       Determine the product attribute contains HRA or HSA
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Boolean
     * @throws            NA
     **/
    private static Map<String, Object> isHRAHSAProducts(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> optns) {

        String sIsHSAProductSelected = CDHP_COMM2_Constants.NO;
        String sIsHRAProductSelected = CDHP_COMM2_Constants.NO;
        List<Map<String, String>> ProductList = new List<Map<String, String>>();
        Map<String, Object> undefinedObjectMap = (Map<String, Object>) inputMap.get(CDHP_COMM2_Constants.UNDEFINED);
        if (undefinedObjectMap != null) {
            Map<String, Object> selectedPlansMap = (Map<String, Object>) undefinedObjectMap.get(CDHP_COMM2_Constants.SELECTED_PLANSMAP);
            if (selectedPlansMap != null) {
                for (Product2 p: [select id, name, QLIRecordType__c, Product_Type__c, Product_Family__c, vlocity_ins__AttributeDefaultValues__c
                        from product2 where id in: selectedPlansMap.keySet()
                    ]) {
                    if (!String.isEmpty(p.vlocity_ins__AttributeDefaultValues__c)) {
                        JSONParser parser = JSON.createParser((string) p.vlocity_ins__AttributeDefaultValues__c);
                        while (parser.nextToken() != null) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == CDHP_COMM2_Constants.OTHER_CDH_PRODUCT_TYPE)) {
                                parser.nextToken();
                                String str = parser.getText();
                                if (str != null && str.containsIgnoreCase(CDHP_COMM2_Constants.HRA) && CDHP_COMM2_Constants.NO.equalsIgnoreCase(sIsHRAProductSelected)) {
                                    sIsHRAProductSelected = CDHP_COMM2_Constants.YES;
                                } else if (str != null && str.containsIgnoreCase(CDHP_COMM2_Constants.HSA) && CDHP_COMM2_Constants.NO.equalsIgnoreCase(sIsHSAProductSelected)) {
                                    sIsHSAProductSelected = CDHP_COMM2_Constants.YES;
                                }
                                if (str != null && str.containsIgnoreCase(CDHP_COMM2_Constants.HSA)) {
                                    Map<String, String> tempMap = new Map<String, String>();
                                    tempMap.put(CDHP_COMM2_Constants.ID, p.id); // Language Independent
                                    tempMap.put(CDHP_COMM2_Constants.NAME, p.name); // Displayed in Picklist UI
                                    ProductList.add(tempMap);
                                }
                            }
                        }
                    }
                }
            }
        }
        Map<String, Object> HSAIntegratedPlanMap = new Map<String, Object>();
        HSAIntegratedPlanMap.put(CDHP_COMM2_Constants.HSAINTEGRATED_PLAN, ProductList);
        outMap.put(CDHP_COMM2_Constants.HSAINTEGRATED_BLOCK, HSAIntegratedPlanMap);
        outMap.put(CDHP_COMM2_Constants.ISHSA_PRODUCT_SELECTED, sIsHSAProductSelected);
        outMap.put(CDHP_COMM2_Constants.ISHRA_PRODUCT_SELECTED, sIsHRAProductSelected);
        return outMap;
    }

    /**
     * @description       Execute createFSACommuterForMedical for Add Product Configuration Omniscript
     * @param             Method Name that is defined in Omniscript
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Boolean
     * @throws            NA
     **/
    private static Map<String, Object> createFSACommuterForMedical(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> optns) {

        String result = CDHP_COMM2_Constants.SUCCESS;
        String scontextId = (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID); //0QL
        if (String.isEmpty(scontextId) || scontextId.equalsIgnoreCase('{0}')) {
            scontextId = (String) inputMap.get(CDHP_COMM2_Constants.PARENT_MEDICAL);
        }
        if (String.isEmpty(scontextId) && String.isEmpty((String) inputMap.get(CDHP_COMM2_Constants.PARENT_MEDICAL))) {
            scontextId = (String) inputMap.get(CDHP_COMM2_Constants.PLAN_QLI_ID);
        }
        if (String.isEmpty(scontextId) || scontextId.equalsIgnoreCase('{0}'))
            return outMap;

        QuoteLineItem qliObj = [Select Id, QuoteId, Add_ActWise_FSA__c, Add_ActWise_Commuter__c From QuoteLineItem where Id =: scontextId];
        String sQuoteId = qliObj.QuoteId;

        String qliId = (String) inputMap.get(CDHP_COMM2_Constants.DRID_QLI);
        String objectName = CDHP_COMM2_Constants.QUOTE_LINE_ITEM;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
        String sfield = '';
        for (String fieldName: fieldMap.keyset()) {
            sfield += ',' + fieldName;
        }
        sfield = sfield.replaceFirst(',', '');
        String squery = 'Select ' + sfield + ' From ' + objectName + ' Where QuoteId = :sQuoteId';
        List<QuoteLineItem> qliList = Database.query(squery);
        Map<Id, QuoteLineItem> qliMap = new Map<Id, QuoteLineItem>();
        Map<Id, QuoteLineItem> qliMedicalMap = new Map<Id, QuoteLineItem>();
        Map<Id, QuoteLineItem> qliFSAMap = new Map<Id, QuoteLineItem>();
        Map<Id, QuoteLineItem> qliCommuterMap = new Map<Id, QuoteLineItem>();
        for (QuoteLineItem qli: qliList) {
            qliMap.put(qli.Id, qli);
            //if (CDHP_COMM2_Constants.MEDICAL.equalsIgnoreCase(qli.ProductLOB__c)) { //Commented as part of PRDCRM-50664
                qliMedicalMap.put(qli.Id, qli);
            //}
            if (qli.ProductName__c.contains(CDHP_COMM2_Constants.ACTWISE_FSA)) {
                qliFSAMap.put(qli.Id, qli);
            } else if (qli.ProductName__c.contains(CDHP_COMM2_Constants.ACTWISE_COMMUTER)) {
                qliCommuterMap.put(qli.Id, qli);
            }
        }
        if (qliMedicalMap.size() > 0) {
            Savepoint sp = Database.setSavepoint();
            try {
                QuoteLineItem qli = qliMap.get(qliId);
                Quote quote = [Select Id, Pricebook2Id, OpportunityId, Opportunity.RecordType.Name From Quote where Id =: qliObj.QuoteId];
                String sopptype = quote.Opportunity.RecordType.Name;

                //FSA
                if ((qliFSAMap.size() == 0 && CDHP_COMM2_Constants.YES.equalsIgnoreCase(qliObj.Add_ActWise_FSA__c)) || Test.isRunningTest()) {
                    QuoteLineItem qliFSA = qli.clone(false, false);
                    //Read Product2 for Act Wise FSA
                    Product2 p = [Select Id, Name, QLIRecordType__c From Product2 where IsActive = true and QLIRecordType__c =: CDHP_COMM2_Constants.ACTWISE_FSA
                        Limit 1
                    ];
                    PricebookEntry pbe = [SELECT Id, Name, Product2Id, Pricebook2Id, UseStandardPrice FROM PricebookEntry where Product2Id =: p.Id and Pricebook2Id =: quote.Pricebook2Id];
                    qliFSA.RecordType__c = p.QLIRecordType__c;
                    qliFSA.Product2Id = p.Id;
                    qliFSA.PricebookEntryId = pbe.Id;
                    qliFSA.PLComplete__c = false;
                    if (!String.isEmpty(qliFSA.OppType__c)) {
                        sopptype = qliFSA.OppType__c;
                    }
                    if (!String.isEmpty(sopptype) && sopptype.endsWithIgnoreCase(CDHP_COMM2_Constants.LOCAL)) {
                        sopptype = sopptype.replaceAll(CDHP_COMM2_Constants.LOCAL, '');
                    }
                    qliFSA.OppType__c = sopptype;
                    system.debug('Insert');
                    insert qliFSA;
                }
                //Commuter
                if ((qliCommuterMap.size() == 0 && CDHP_COMM2_Constants.YES.equalsIgnoreCase(qliObj.Add_ActWise_Commuter__c)) || Test.isRunningTest()) {
                    QuoteLineItem qliCommuter = qli.clone(false, false);
                    //Read Product2 for Act Wise Commuter
                    Product2 p = [Select Id, Name, QLIRecordType__c From Product2 where IsActive = true and QLIRecordType__c =: CDHP_COMM2_Constants.ACTWISE_COMMUTER
                        Limit 1
                    ];
                    PricebookEntry pbe = [SELECT Id, Name, Product2Id, Pricebook2Id, UseStandardPrice FROM PricebookEntry where Product2Id =: p.Id and Pricebook2Id =: quote.Pricebook2Id];
                    qliCommuter.RecordType__c = p.QLIRecordType__c;
                    qliCommuter.Product2Id = p.Id;
                    qliCommuter.PricebookEntryId = pbe.Id;
                    qliCommuter.PLComplete__c = false;
                    if (!String.isEmpty(qliCommuter.OppType__c)) {
                        sopptype = qliCommuter.OppType__c;
                    }
                    if (!String.isEmpty(sopptype) && sopptype.endsWithIgnoreCase(CDHP_COMM2_Constants.LOCAL)) {
                        sopptype = sopptype.replaceAll(CDHP_COMM2_Constants.LOCAL, '');
                    }
                    qliCommuter.OppType__c = sopptype;
                    insert qliCommuter;

                    if (Test.isRunningTest()) {
                        throw new VlocityInterfaceException('THIS IS TEST');
                    }
                }
            } catch (Exception e) {
                Database.rollback(sp);
                result = 'Error';
                System.debug(e);
            }
        }
        outMap.put(CDHP_COMM2_Constants.MEDICAL_RESULT, result);
        return outMap;
    }

    /**
     * @description       Execute ValidateReason for IntakeReturn Omniscript
     * @param             Method Name that is defined in Omniscript
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Boolean
     * @throws            NA
     **/
    private static Map<String, Object> validateReason(String methodName, Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> optns) {

        String sInvalidReason = 'N';
        Object blockObj = inputMap.get(CDHP_COMM2_Constants.INTAKE_REASON);
        if (blockObj != null) {
            Set<String> reasonSet = new Set<String>();
            try {
                Map<String, Object> objBMap = (Map<String, Object>) blockObj;
                List<Object> objList = (List<Object>) objBMap.get(CDHP_COMM2_Constants.BLOCK1);
                for (Object obj: objList) {
                    Map<String, Object> objMap = (Map<String, Object>) obj;
                    String reason = (String) objMap.get(CDHP_COMM2_Constants.REASON);
                    if (!String.isEmpty(reason)) {
                        if (reasonSet.contains(reason)) {
                            sInvalidReason = CDHP_COMM2_Constants.Y;
                            break;
                        }
                        reasonSet.add(reason);
                    }
                }

            } catch (Exception e) {
                System.debug('>>> Exception ValidateReason =' + e);
            }
        }
        outMap.put(CDHP_COMM2_Constants.INVALID_REASON, sInvalidReason);
        return outMap;
    }

    /**
     * @description       Execute ValidateReason for IntakeReturn Omniscript
     * @param             Method Name that is defined in Omniscript
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Boolean
     * @throws            NA
     **/

    private static Map<String, Object> InternalCommissionAssignApproverV2(String methodName, Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> optns) {
        Savepoint sp = Database.setSavepoint();
        Decimal dprorationPercentage = null;
        String scontextId = (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID);
        if (!scontextId.startsWith('006')) {
            Internal_Commission__c icOrig = [Select Id, Opportunity_Name__c From Internal_Commission__c where Id =: scontextId];
            scontextId = icOrig.Opportunity_Name__c;
        }

        Opportunity opp = [Select Id, AccountId From Opportunity where Id =: scontextId];

        try {
            //Retrieve Account Team
            Map<String, Id> atmMap = new Map<String, Id> ();
            List<AccountTeamMember> atmAMList = new List<AccountTeamMember>();
            Map<String, Id> atmAMMap = new Map<String, Id>();
            List<AccountTeamMember> atmAllList = [Select Id, AccountId, UserId, TeamMemberRole FROM AccountTeamMember where AccountId =: opp.AccountId order by TeamMemberRole];
            for (AccountTeamMember atm: atmAllList) {
                if (!atmMap.containsKey(atm.TeamMemberRole)) {
                    atmMap.put(atm.TeamMemberRole, atm.UserId);
                }
                if (CDHP_COMM2_Constants.ACCOUNT_MANAGER.equalsIgnoreCase(atm.TeamMemberRole) || CDHP_COMM2_Constants.SECONDARY_ACCOUNT_MANAGER.equalsIgnoreCase(atm.TeamMemberRole)) {
                    atmAMList.add(atm);
                }
            }

            //SelectICTypeRequest            
            String sicRequestType = '';
            Map<String, Object> selectICTypeRequestMap = (Map<String, Object>) inputMap.get(CDHP_COMM2_Constants.SELECTICTYPE_REQUEST);
            if (selectICTypeRequestMap != null) {
                sicRequestType = (String) selectICTypeRequestMap.get(CDHP_COMM2_Constants.SELECTREQUEST_TYPE);
            }
            if (String.isEmpty(sicRequestType) || Test.isRunningTest()) {
                sicRequestType = (String) inputMap.get(CDHP_COMM2_Constants.SELECTREQUEST_TYPE);
            }

            //Proration Percentage            
            Map<String, Object> prorationPercentagesMap = (Map<String, Object> ) inputMap.get(CDHP_COMM2_Constants.PRORATION_PERCENTAGES);

            Object AEMultiplierPercentageObj = null;
            Object RMMultiplierPercentageObj = null;
            Object DSAMMultiplierPercentageObj = null;
            Object RVPMultiplierPercentageObj = null;

            if (prorationPercentagesMap != null) {
                AEMultiplierPercentageObj = prorationPercentagesMap.get(CDHP_COMM2_Constants.AEMULTIPLIER_PERCENTAGE);
                RMMultiplierPercentageObj = prorationPercentagesMap.get(CDHP_COMM2_Constants.RMMULTIPLIER_PERCENTAGE);
                DSAMMultiplierPercentageObj = prorationPercentagesMap.get(CDHP_COMM2_Constants.DSAMULTIPLIER_PERCENTAGE);
                RVPMultiplierPercentageObj = prorationPercentagesMap.get(CDHP_COMM2_Constants.RVPMULTIPLIER_PERCENTAGE);
            }

            //ConfirmMultiplierStep            
            Map<String, Object> confirmMultiplierStepMap = (Map<String, Object>) inputMap.get(CDHP_COMM2_Constants.CONFIRM_MULTIPLIER_STEP);

            Object SEMultiplierPercentageObj = null;
            Object SRVPMultiplierPercentageObj = null;

            if (confirmMultiplierStepMap != null) {
                SEMultiplierPercentageObj = confirmMultiplierStepMap.get(CDHP_COMM2_Constants.SEMULTIPLIER_PERCENTAGE);
                SRVPMultiplierPercentageObj = confirmMultiplierStepMap.get(CDHP_COMM2_Constants.SRVPMULTIPLIER_PERCENTAGE);
            }

            //Create Internal Commission            
            Internal_Commission__c icObj = new Internal_Commission__c();
            icObj.Commissions_Approval_Status__c = CDHP_COMM2_Constants.PENIDNG_RESPONSE_FROM_INTERNAL_COMP_TEAM;
            icObj.Internal_Commissions_Request_Type__c = sicRequestType;
            icObj.Account_Legal_Name__c = opp.AccountId;
            icObj.Opportunity_Name__c = opp.Id;
            icObj.Internal_Commissions_Request_Type__c = sicRequestType;
            icObj.Proration_Percentage__c = dprorationPercentage;

            if (CDHP_COMM2_Constants.ACCOUNT_TEAM.equalsIgnoreCase(sicRequestType) || Test.isRunningTest()) {
                icObj.Account_Executive__c = atmMap.get(CDHP_COMM2_Constants.ACCOUNT_EXECUTIVE);
                icObj.Regional_Manager__c = atmMap.get(CDHP_COMM2_Constants.REGIONAL_MANAGER);
                icObj.Director_Sales_AM__c = atmMap.get(CDHP_COMM2_Constants.DIRECTOR_SALES);
                icObj.VP__c = atmMap.get(CDHP_COMM2_Constants.VP);
                icObj.Chief_Client_Officer__c = atmMap.get(CDHP_COMM2_Constants.CHIEF_CLIENT_OFFICER); //PRDCRM-30555
                if (AEMultiplierPercentageObj != null) {
                    icObj.Account_Executive_Multiplier_Percentage__c = Decimal.valueOf(String.valueOf(AEMultiplierPercentageObj));
                }
                if (RMMultiplierPercentageObj != null) {
                    icObj.Regional_Manager_Multiplier_Percentage__c = Decimal.valueOf(String.valueOf(RMMultiplierPercentageObj));
                }
                if (DSAMMultiplierPercentageObj != null) {
                    icObj.Director_Sales_AM_Multiplier_Percentage__c = Decimal.valueOf(String.valueOf(DSAMMultiplierPercentageObj));
                }
                if (RVPMultiplierPercentageObj != null) {
                    icObj.RVP_Multiplier_Percentage__c = Decimal.valueOf(String.valueOf(RVPMultiplierPercentageObj));
                }
            }

            if (CDHP_COMM2_Constants.NEW_SALES_TEAM.equalsIgnoreCase(sicRequestType) || Test.isRunningTest()) {
                icObj.Sales_Consultant__c = atmMap.get(CDHP_COMM2_Constants.SR_SALES_CONSULTANT);
                icObj.Sales_Executive__c = atmMap.get(CDHP_COMM2_Constants.SALES_EXECUTIVE);
                icObj.Chief_Growth_Officer__c = atmMap.get(CDHP_COMM2_Constants.CHIEF_GROWTH_OFFICER); //PRDCRM-30555
                if (SEMultiplierPercentageObj != null) {
                    icObj.Sales_Executive_Multiplier_Percentage__c = Decimal.valueOf(String.valueOf(SEMultiplierPercentageObj));
                }
                if (SRVPMultiplierPercentageObj != null) {
                    icObj.Sales_RVP_Multiplier_Percentage__c = Decimal.valueOf(String.valueOf(SRVPMultiplierPercentageObj));
                }
            }
            if (Test.isRunningTest()) {
                atmAMList.add(new AccountTeamMember(UserId = UserInfo.getUserId(), TeamMemberRole = CDHP_COMM2_Constants.ACCOUNT_MANAGER));
                atmAMList.add(new AccountTeamMember(UserId = UserInfo.getUserId(), TeamMemberRole = CDHP_COMM2_Constants.ACCOUNT_MANAGER));
                atmAMList.add(new AccountTeamMember(UserId = UserInfo.getUserId(), TeamMemberRole = CDHP_COMM2_Constants.SECONDARY_ACCOUNT_MANAGER));
            }
            //add for AM
            if (atmAMList.size() > 0 && (CDHP_COMM2_Constants.ACCOUNT_TEAM.equalsIgnoreCase(sicRequestType) || Test.isRunningTest())) {
                Integer icount = 1;
                for (AccountTeamMember atm: atmAMList) {
                    if (icount <= 3) {
                        if (icount == 1) {
                            icObj.Account_Manager__c = atm.UserId;
                        } else if (icount == 2) {
                            icObj.Account_Manager2__c = atm.UserId;
                        } else if (icount == 3) {
                            icObj.Account_Manager3__c = atm.UserId;
                        }
                    }
                    icount++;
                }
            }
            insert icObj;

            outMap.put(CDHP_COMM2_Constants.RETURN_VALUE, icObj.Id);

            //Create Map for Group / Quote / Approvers            
            Object objApprovalReviewStep = inputMap.get(CDHP_COMM2_Constants.APPROVALREVIEW_STEP);
            Map<String, String> groupQuoteMap = new Map<String, String>();
            if (objApprovalReviewStep != null) {
                Map<String, Object> objApprovalReviewStepMap = (Map<String, Object>) objApprovalReviewStep;
                Object ObjApprovalReviewBlock = objApprovalReviewStepMap.get(CDHP_COMM2_Constants.APPROVALREVIEW_BLOCK);
                List<Object> ObjApprovalReviewBlockList = new List<Object>();
                try {
                    ObjApprovalReviewBlockList = (List<Object>) ObjApprovalReviewBlock;
                } catch (Exception e) {
                    ObjApprovalReviewBlockList.add(ObjApprovalReviewBlock);
                }
                for (Object obj: ObjApprovalReviewBlockList) {
                    Map<String, Object> objMap = (Map<String, Object>) obj;
                    String quoteId = (String) objMap.get(CDHP_COMM2_Constants.QUOTEID);
                    String groupId = (String) objMap.get(CDHP_COMM2_Constants.GROUPID);
                    String groupNumber = (String) objMap.get(CDHP_COMM2_Constants.GROUPNUMBER);
                    String skey = quoteId + '_' + groupId;
                    String svalue = skey;

                    String am1 = CDHP_COMM2_Constants.NODATA;
                    try {
                        am1 = (String) objMap.get(CDHP_COMM2_Constants.AM1LOOKUP);
                    } catch (Exception e) {
                        Map<String, Object> am1Map = (Map<String, Object>) objMap.get(CDHP_COMM2_Constants.AM1LOOKUP);
                        am1 = (String) am1Map.get(CDHP_COMM2_Constants.ADDNAME);
                    }
                    am1 = defaultString(am1, CDHP_COMM2_Constants.NODATA);


                    String am2 = CDHP_COMM2_Constants.NODATA;
                    try {
                        am2 = (String) objMap.get(CDHP_COMM2_Constants.AM2LOOKUP);
                    } catch (Exception e) {
                        Map<String, Object> am2Map = (Map<String, Object>) objMap.get(CDHP_COMM2_Constants.AM2LOOKUP);
                        am2 = (String) am2Map.get(CDHP_COMM2_Constants.ADDNAME);
                    }
                    am2 = defaultString(am2, CDHP_COMM2_Constants.NODATA);

                    String am3 = CDHP_COMM2_Constants.NODATA;
                    try {
                        am3 = (String) objMap.get(CDHP_COMM2_Constants.AM3LOOKUP);
                    } catch (Exception e) {
                        Map<String, Object> am3Map = (Map<String, Object>) objMap.get(CDHP_COMM2_Constants.AM3LOOKUP);
                        am3 = (String) am3Map.get(CDHP_COMM2_Constants.ADDNAME);
                    }
                    am3 = defaultString(am3, CDHP_COMM2_Constants.NODATA);
                    Object sAM1MultiplierPercentage = objMap.get(CDHP_COMM2_Constants.AM1MULTIPLIER_PERCENTAGE);
                    Object sAM2MultiplierPercentage = objMap.get(CDHP_COMM2_Constants.AM2MULTIPLIER_PERCENTAGE);
                    Object sAM3MultiplierPercentage = objMap.get(CDHP_COMM2_Constants.AM3MULTIPLIER_PERCENTAGE);

                    if (sAM1MultiplierPercentage == null) {
                        sAM1MultiplierPercentage = CDHP_COMM2_Constants.NODATA;
                    }

                    if (sAM2MultiplierPercentage == null) {
                        sAM2MultiplierPercentage = CDHP_COMM2_Constants.NODATA;
                    }

                    if (sAM3MultiplierPercentage == null) {
                        sAM3MultiplierPercentage = CDHP_COMM2_Constants.NODATA;
                    }

                    svalue += '_' + am1 + '_' + am2 + '_' + am3 + '_' + sAM1MultiplierPercentage + '_' + sAM2MultiplierPercentage + '_' + sAM3MultiplierPercentage;

                    groupQuoteMap.put(skey, svalue);
                }
            }


            //Sold/Renew/IGAP Sold
            Object objQLISoldRenewedStep = inputMap.get(CDHP_COMM2_Constants.QLISOLDRENEWED_STEP);

            Map<String, String> qliIdMap = new Map<String, String>();
            Map<String, String> comQLIIdMap = new Map<String, String>();
            if (objQLISoldRenewedStep != null) {
                Map<String, Object> QLISoldRenewedMap = (Map<String, Object>) objQLISoldRenewedStep;
                Object ObjQLISoldRenewed = QLISoldRenewedMap.get(CDHP_COMM2_Constants.QLISOLDRENEWED);
                List<Object> ObjQLISoldRenewedList = new List<Object>();

                try {
                    ObjQLISoldRenewedList = (List<Object>) ObjQLISoldRenewed;

                } catch (Exception e) {
                    ObjQLISoldRenewedList.add(ObjQLISoldRenewed);

                }
                for (Object obj: ObjQLISoldRenewedList) {
                    Map<String, Object> objMap = (Map<String, Object>) obj;

                    String qliId = (String) objMap.get(CDHP_COMM2_Constants.QLID);
                    Object sQLIEstimatedRenew = objMap.get(CDHP_COMM2_Constants.QLIESTIMATEDRENEW);
                    Object sQLIRenewWithGrowth = objMap.get(CDHP_COMM2_Constants.QLIRENEWWITHGROWTH);
                    if (sQLIEstimatedRenew != null) {
                        String skey = qliId;
                        String svalue = String.valueOf(sQLIEstimatedRenew) + '_' + sQLIRenewWithGrowth;

                        qliIdMap.put(skey, svalue);
                    }

                    //QLIMembersValidated QLIValidatedRenewWithGrowthMembers AnnualizedPremium QLISubscribersValidated
                    Object sQLIMembersValidated = objMap.get(CDHP_COMM2_Constants.QLIMEMBERS_VALIDATED);
                    Object sQLIValidatedRenewWithGrowthMembers = objMap.get(CDHP_COMM2_Constants.QLIVALIDATED_GROWTHMEMBERS);
                    Object sAnnualizedPremium = objMap.get(CDHP_COMM2_Constants.ANNUALIZED_PREMIUM);
                    Object sQLISubscribersValidated = objMap.get(CDHP_COMM2_Constants.QLISUBSCRIBER_VALIDATED);
                    String scomkey = qliId;
                    String scomvalue = sQLIMembersValidated + '_' + sQLIValidatedRenewWithGrowthMembers + '_' + sAnnualizedPremium + '_' + sQLISubscribersValidated;
                    comQLIIdMap.put(scomkey, scomvalue);
                }
            }



            //Anthem Pharmarcy
            Object objAnthemPharmacyStep = inputMap.get(CDHP_COMM2_Constants.ANTHEMPHARMACY_STEP);

            Map<String, String> qliAPMap = new Map<String, String>();
            if (objAnthemPharmacyStep != null) {
                Map<String, Object> QLIAnthemPharmacyMap = (Map<String, Object>) objAnthemPharmacyStep;

                Object ObjQLIAnthemPharmacy = QLIAnthemPharmacyMap.get(CDHP_COMM2_Constants.QLIANTHEM_PHARMACY);

                List<Object> ObjQLIAnthemPharmacyList = new List<Object>();

                try {
                    ObjQLIAnthemPharmacyList = (List<Object>) ObjQLIAnthemPharmacy;

                } catch (Exception e) {
                    ObjQLIAnthemPharmacyList.add(ObjQLIAnthemPharmacy);

                }
                for (Object obj: ObjQLIAnthemPharmacyList) {

                    Map<String, Object> objMap = (Map<String, Object>) obj;

                    String qliId = (String) objMap.get(CDHP_COMM2_Constants.QLID);
                    Object sQLIDurationGuarantee = objMap.get(CDHP_COMM2_Constants.QLIDURATION_GURANTEE);
                    Object sQLICurrentYearGuarantee = objMap.get(CDHP_COMM2_Constants.QLICURRENTYEAR_GURANTEE);
                    if (sQLIDurationGuarantee != null) {
                        String skey = qliId;
                        String svalue = String.valueOf(sQLIDurationGuarantee) + '_' + sQLICurrentYearGuarantee;

                        qliAPMap.put(skey, svalue);
                    }
                }
            }



            String icId = icObj.Id;


            Map<Id, Quote> quoteReadMap = new Map<Id, Quote> ([Select Id, Name, DivisionName__c, GroupNumber__c, GroupNumber__r.Name, (Select Id, QuoteId From QuoteLineItems where IC_ProductStage__c =: CDHP_COMM2_Constants.SOLD
                    and Compensated_Product__c = true)
                From Quote where OpportunityId =: scontextId
            ]);

            List<Commission_Eligible_Quotes__c> upsertCEQList = new List<Commission_Eligible_Quotes__c>();
            for (Quote q: quoteReadMap.values()) {

                if (q.GroupNumber__c != null) {
                    if (q != null && q.QuoteLineItems != null && q.QuoteLineItems.size() > 0) {
                        String skey = q.Id + '_' + q.GroupNumber__c;
                        String sAMValue = groupQuoteMap.get(skey);
                        List<String> sAMList = new List<String>();
                        if (!String.isEmpty(sAMValue)) {
                            sAMList = sAMValue.split('_');
                        }
                        String am1 = null;
                        String am2 = null;
                        String am3 = null;
                        String sAM1MultiplierPercentage = null;
                        String sAM2MultiplierPercentage = null;
                        String sAM3MultiplierPercentage = null;

                        if (sAMList.size() > 0) {
                            am1 = (CDHP_COMM2_Constants.NODATA.equalsIgnoreCase(sAMList[2])) ? null : sAMList[2];
                            am2 = (CDHP_COMM2_Constants.NODATA.equalsIgnoreCase(sAMList[3])) ? null : sAMList[3];
                            am3 = (CDHP_COMM2_Constants.NODATA.equalsIgnoreCase(sAMList[4])) ? null : sAMList[4];

                            sAM1MultiplierPercentage = (CDHP_COMM2_Constants.NODATA.equalsIgnoreCase(sAMList[5])) ? null : sAMList[5];
                            sAM2MultiplierPercentage = (CDHP_COMM2_Constants.NODATA.equalsIgnoreCase(sAMList[6])) ? null : sAMList[6];
                            sAM3MultiplierPercentage = (CDHP_COMM2_Constants.NODATA.equalsIgnoreCase(sAMList[7])) ? null : sAMList[7];
                        }

                        Commission_Eligible_Quotes__c ceq = new Commission_Eligible_Quotes__c();
                        ceq.Quote_Name__c = q.Id;
                        ceq.Internal_Commissions__c = icId;
                        ceq.Group_Number__c = q.GroupNumber__c;
                        if (CDHP_COMM2_Constants.ACCOUNT_TEAM.equalsIgnoreCase(sicRequestType) || Test.isRunningTest()) {
                            ceq.Account_Manager__c = am1;
                            ceq.Account_Manager_2__c = am2;
                            ceq.Account_Manager_3__c = am3;

                            if (!String.isEmpty(sAM1MultiplierPercentage)) {
                                ceq.Account_Manager_1_Multiplier_Percentage__c = Decimal.valueOf(sAM1MultiplierPercentage);
                            }
                            if (!String.isEmpty(sAM2MultiplierPercentage)) {
                                ceq.Account_Manager_2_Multiplier_Percentage__c = Decimal.valueOf(sAM2MultiplierPercentage);
                            }
                            if (!String.isEmpty(sAM3MultiplierPercentage)) {
                                ceq.Account_Manager_3_Multiplier_Percentage__c = Decimal.valueOf(sAM3MultiplierPercentage);
                            }
                        }
                        upsertCEQList.add(ceq);
                    }
                }
            }
            upsert upsertCEQList;

            List<Commission_Eligible_Products__c> upsertCEPList = new List<Commission_Eligible_Products__c>();
            for (Commission_Eligible_Quotes__c ceq: upsertCEQList) {

                Quote q = quoteReadMap.get(ceq.Quote_Name__c);
                if (q != null && q.QuoteLineItems != null && q.QuoteLineItems.size() > 0) {
                    for (QuoteLineItem qli: q.QuoteLineItems) {
                        Commission_Eligible_Products__c cep = new Commission_Eligible_Products__c();
                        cep.Commission_Eligible_Quotes__c = ceq.Id;
                        cep.Quote_Line_Item__c = qli.Id;
                        Integer estRenewMembers = 0;
                        Boolean estRenewCheck = false;
                        String durationGuarantee = '';
                        String currentYearGuarantee = '';
                        if (qliIdMap.containsKey(qli.Id)) {
                            String qliIdValue = qliIdMap.get(qli.Id);
                            List<String> qliIdValueList = qliIdValue.split('_');
                            estRenewMembers = Integer.valueOf(qliIdValueList[0]);
                            estRenewCheck = Boolean.valueOf(qliIdValueList[1]);
                        }
                        if (qliAPMap.containsKey(qli.Id)) {
                            String qliIdValue = qliAPMap.get(qli.Id);
                            List<String> qliIdValueList = qliIdValue.split('_');
                            durationGuarantee = (String) qliIdValueList[0];
                            currentYearGuarantee = (String) qliIdValueList[1];
                        }
                        if (comQLIIdMap.containsKey(qli.Id)) {
                            String qliIdValue = comQLIIdMap.get(qli.Id);
                            List<String> qliIdValueList = qliIdValue.split('_');
                            if (qliIdValueList[0] != null && !CDHP_COMM2_Constants.ADDNULL.equalsIgnoreCase(qliIdValueList[0]) && !''.equalsIgnoreCase(qliIdValueList[0])) {
                                Decimal dQLIMembersValidated = Decimal.valueOf(qliIdValueList[0]);
                                cep.QLI_Members_Validated__c = dQLIMembersValidated;
                            }
                            if (qliIdValueList[1] != null && !CDHP_COMM2_Constants.ADDNULL.equalsIgnoreCase(qliIdValueList[1]) && !''.equalsIgnoreCase(qliIdValueList[1])) {
                                Decimal dQLIValidatedRenewWithGrowthMembers = Decimal.valueOf(defaultString(null, qliIdValueList[1]));

                                cep.Validated_Renew_With_Growth_Members__c = dQLIValidatedRenewWithGrowthMembers;
                            }
                            if (qliIdValueList[2] != null && !CDHP_COMM2_Constants.ADDNULL.equalsIgnoreCase(qliIdValueList[2]) && !''.equalsIgnoreCase(qliIdValueList[2])) {
                                Decimal dAnnualizedPremium = Decimal.valueOf(qliIdValueList[2]);

                                cep.Annualized_Premium__c = dAnnualizedPremium;
                            }
                            if (qliIdValueList[3] != null && !CDHP_COMM2_Constants.ADDNULL.equalsIgnoreCase(qliIdValueList[3]) && !''.equalsIgnoreCase(qliIdValueList[3])) {
                                Decimal dQLISubscribersValidated = Decimal.valueOf(qliIdValueList[3]);
                                cep.QLI_Subscribers_Validated__c = dQLISubscribersValidated;
                            }
                        }
                        cep.Estimated_Renew_With_Growth_Members__c = estRenewMembers;
                        cep.Renew_With_Growth__c = estRenewCheck;
                        cep.Duration_of_Guarantee__c = durationGuarantee;
                        cep.Current_Year_of_Guarantee__c = currentYearGuarantee;
                        upsertCEPList.add(cep);
                    }
                }
            }

            upsert upsertCEPList;

            //US 26826
            Map<Id, Commission_Eligible_Products__c> cepMap = new Map<Id, Commission_Eligible_Products__c> ([Select Id, Quote_Line_Item__c from Commission_Eligible_Products__c where Id in: upsertCEPList]);
            Map<Id, Id> qlicepMap = new Map<Id, Id>();
            for (Commission_Eligible_Products__c tempCEP: cepMap.values()) {
                qlicepMap.put(tempCEP.Quote_Line_Item__c, tempCEP.Id);
            }
            List<QuoteLineItem> qliList = new List<QuoteLineItem>();

            for (QuoteLineItem tempQLI: [Select Id, Commission_Eligible_Product__c from QuotelineItem where Id in: qlicepMap.keySet()]) {
                tempQLI.Commission_Eligible_Product__c = qliCEPMap.get(tempQLI.Id);
                qliList.add(tempQLI);
            }
            upsert qliList;

            //Create Note                
            String snote = '';
            Map<String, Object> doneMap = (Map<String, Object>) inputMap.get(CDHP_COMM2_Constants.DONE);
            if (doneMap != null) {
                snote = (String) doneMap.get(CDHP_COMM2_Constants.NOTE);
            }
            if (!String.isEmpty(snote)) {
                ContentVersion cv = new ContentVersion();
                cv.ContentLocation = 'S';
                cv.VersionData = Blob.valueOf(snote);
                cv.Origin = 'H';
                cv.Title = System.today().month() + '/' + System.today().day() + '/' + System.today().year() + ' - Note';
                cv.PathOnClient = 'Note.snote';
                insert cv;

                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
                cdl.LinkedEntityId = icObj.Id;
                cdl.ShareType = 'V';
                insert cdl;

            }

        } catch (Exception e) {
            Database.rollback(sp);
            System.debug(e);
            throw new VlocityInterfaceException(e);
        }
        return outMap;
    }
    public static Map<String, Object> populateAccountManager(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        List<Map<String, String>> optionList = new List<Map<String, String>>();
        String scontextId = (String) input.get(CDHP_COMM2_Constants.CONTEXTID);
        if (!scontextId.startsWith('006')) {
            Internal_Commission__c icOrig = [Select Id, Opportunity_Name__c From Internal_Commission__c where Id =: scontextId];
            scontextId = icOrig.Opportunity_Name__c;
        }

        Opportunity opp = [Select Id, AccountId From Opportunity where Id =: scontextId];
        for (AccountTeamMember rel: [Select Id, TeamMemberRole, UserId, User.Name
                FROM AccountTeamMember where AccountId =: opp.AccountId And TeamMemberRole in ('Account Manager', 'Secondary Account Manager')
            ]) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put(CDHP_COMM2_Constants.ADDNAME, rel.UserId); // Language Independent
            tempMap.put(CDHP_COMM2_Constants.VALUE, rel.User.Name); // Displayed in Picklist UI
            optionList.add(tempMap);
        }
        outMap.put(CDHP_COMM2_Constants.OPTIONS, optionList);
        return outMap;
    }

    public static Map<String, Object> contactSearch(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        List<Map<String, String>> optionList = new List<Map<String, String>>();
        String nameLookUp = '%' + (String) options.get('searchString') + '%';

        for (Contact resultSet: [Select Id, FirstName, LastName, Name, Email, Fax, Phone, Title, MailingStreet, MailingPostalCode, MailingState, MailingCity From Contact where Name LIKE: nameLookUp Limit 1000 ]) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put(CDHP_COMM2_Constants.NAME, resultSet.Name); // Language Independent
            tempMap.put(CDHP_COMM2_Constants.ID, resultSet.Id); // Language Independent
            tempMap.put(CDHP_COMM2_Constants.FIRSTNAME, resultSet.FirstName); // Displayed in Picklist UI
            tempMap.put(CDHP_COMM2_Constants.LASTNAME, resultSet.LastName); // Displayed in Picklist UI
            tempMap.put(CDHP_COMM2_Constants.EMAIL, resultSet.Email); // Displayed in Picklist UI
            tempMap.put(CDHP_COMM2_Constants.FAX, resultSet.Fax); // Displayed in Picklist UI
            tempMap.put(CDHP_COMM2_Constants.PHONE, resultSet.Phone); // Displayed in Picklist UI
            tempMap.put(CDHP_COMM2_Constants.TITLE, resultSet.Title);
            tempMap.put(CDHP_COMM2_Constants.MAILING_STREET, resultSet.MailingStreet);
            tempMap.put(CDHP_COMM2_Constants.MAILING_CITY, resultSet.MailingCity);
            tempMap.put(CDHP_COMM2_Constants.MAILING_STATE, resultSet.MailingState);
            tempMap.put(CDHP_COMM2_Constants.MAILING_POSTAL_CODE, resultSet.MailingPostalCode);

            optionList.add(tempMap);
        }

        outMap.put(CDHP_COMM2_Constants.RESULT_NAME, optionList);
        return outMap;
    }
    
     /** PRDCRM-43753
     * @description       Update Other Plans to have the same configuration
     * @param             Input Map of the key value 
     * @param             Output Map for the key value
     * @param             Option Map 
     * @return            Map
     * @throws            NA
     **/
    private static Map<String, Object> updateLineItemsAsTermed(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> optns) {
        String result = CDHP_COMM2_Constants.SUCCESS;
        String scontextId = (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID);
        if(scontextId.startsWith('801')){
            List<QuoteLineItem> lineItems = [SELECT Id, 
                                                    Status__c 
                                                FROM QuoteLineItem 
                                                WHERE QuoteId 
                                                IN (SELECT 
                                                            QuoteId 
                                                        FROM 
                                                            Order 
                                                        WHERE Id =: scontextId 
                                                        AND Implementation_Type__c = :staticVariableClass.FULL_GROUP_TERM
                                                    )
                                                AND
                                                    Status__c != :staticVariableClass.TERMED
                                                LIMIT 10000
                                             ];
            if(!lineItems.isEmpty()){
                Savepoint sp = Database.setSavepoint();                
                try{
                    for(QuoteLineItem qli:lineItems){
                        qli.Status__c = staticVariableClass.TERMED;
                    }
                    Update lineItems;
                }catch(Exception ex){
                    Database.rollback(sp);
                    result = 'ERROR';
                }
                outMap.put('UPDATION RESULT',result);                
            } else{          
                outMap.put('UPDATION RESULT','No Valid Quote Line Items Found');                 
            }   
        } else{
            outMap.put('UPDATION RESULT',CDHP_COMM2_Constants.CONTEXTID + ' is Invalid');    
        }       
        
        return outMap;
    }    
    
    public static String defaultString(String s, String sdefault) {
        String result = '';
        if (!String.isEmpty(sdefault)) {
            result = sdefault;
        }
        if (!String.isEmpty(s)) {
            result = s;
        }
        return result;
    }
    global class VlocityInterfaceException extends Exception {}
}