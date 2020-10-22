/**
@Author : Accenture Offshore Dev team
@name : AP18_SMEApproval
@CreateDate :2/21/2018
@Description :This class creates 'SME Approval' records for respective departments based on 'Auto-Engaged' & 'Manually-ENgaged' departments.
*/
global without sharing class AP18_SMEApproval implements vlocity_ins.VlocityOpenInterface2  {
     
    private static Map<String,Set<Object>> STAutoDepartmentFinal = new Map<String,Set<Object>>();
    private static final string CLASS_NAME=UtilConstants.CLASS_NAME;
    private static final String TEST_CLASS =UtilConstants.TEST_CLASS;
    
    /*Implementation of invokeMEthod from VlocityOpenInterface2 interface.*/
    global static Boolean invokeMethod(String methodName,Map<String,Object> inputMap,
                                        Map<String,Object> outMap,Map<String,Object> optns)
    {   
        String  otherDptVal = '';
        String preImplementationType         =  String.valueOf(inputMap.get(UtilConstants.PRE_IMPLEMENTATION_TYPE));
        String implementationCaseType        =  String.valueOf(inputMap.get(UtilConstants.IMPLEMENTATION_TYPE));
        if(UtilConstants.RETRIEVE_DEPARTMENT.equalsIgnoreCase(methodName))
        {
            returnValue(inputMap, outMap, optns);   
        }                                 
        else
        {         
            if(UtilConstants.SAVE_SME_DEPARTMENT.equalsIgnoreCase(methodName))
            {                                    
                 Map<String,String> deptJSONMap = new Map<String,String>{
                                                 UtilConstants.ST_AUTO_DEPARTMENT => UtilConstants.SI_AUTO_DEPARTMENT
                                                 ,UtilConstants.ST_MANUAL_DEPARTMENT => UtilConstants.SI_MANUAL_DEPARTMENT    
                 };         
                 Set<Object> finalizedDepts = new Set<Object>();                                                         
                 Map<String,Set<Object>> finalizedAutoDeptsList = new  Map<String,Set<Object>>
                                                   (AP18_SMEApproval.returnValue(inputMap, outMap, optns));
                if(finalizedAutoDeptsList.get(UtilConstants.SI_AUTO_DEPARTMENT) != null)
                {
                   Set<Object> autoDepts= new Set<Object>{finalizedAutoDeptsList.get(UtilConstants.SI_AUTO_DEPARTMENT)};               
                   if(autoDepts.size()>0)
                   {
                        Set<Object> engageAutoDeptMap2 = new Set<Object>();                               
                        for(Object tempObj : autoDepts) 
                        {                                   
                            engageAutoDeptMap2 = (Set<Object>) tempObj; 
                        }                   
                        if(engageAutoDeptMap2 != null)
                        {                                           
                            for(Object tempEngage : engageAutoDeptMap2 )
                            {
                                Map<String,Object> engageDeptMap = (Map<String,Object>) tempEngage;                    
                                if(engageDeptMap.get(UtilConstants.JSON_NAME_FIELD) != null)  
                                {                          
                                    finalizedDepts.add(engageDeptMap.get(UtilConstants.JSON_NAME_FIELD));  
                                }                           
                            }
                        }                    
                    }
                }
                System.debug('asa'+inputMap.containsKey('IdentifySmeApprovalSubmit'));   
                //System.debug('asa'+inputMap.get('IdentifySmeApprovalSubmit'));                    
                //Since Manual departments should not be engaged when Implementation Type is 'Pre Work' and Pre Implementation Type is 'RFP, we are filtering them below.
                if(!inputMap.containsKey('IdentifySmeApprovalSubmit'))
                {
                    if(inputMap.get(UtilConstants.ST_MANUAL_DEPARTMENT) != null)
                    {
                         Set<Object> manualDepts = new Set<Object>{inputMap.get(UtilConstants.ST_MANUAL_DEPARTMENT)};   
                         Map<String,Object> engageManualDeptMap = new Map<String,Object>();       
                         for(Object tempObj : manualDepts)
                         {               
                             engageManualDeptMap = (Map<String,Object>) tempObj;
                         }                                 
                         if(engageManualDeptMap.get(UtilConstants.SI_MANUAL_DEPARTMENT) != null)
                         {
                             List<Object> engageManualDeptMap2 = (List<Object>) engageManualDeptMap.get(UtilConstants.SI_MANUAL_DEPARTMENT);
                             for(Object tempEngage : engageManualDeptMap2)
                             {
                                 Map<String,Object> engageDeptMap = (Map<String,Object>) tempEngage;                    
                                 if(engageDeptMap.get(UtilConstants.JSON_NAME_FIELD) != null) 
                                 {   
                                     if(engageDeptMap.get(UtilConstants.JSON_NAME_FIELD) == UtilConstants.OTHER)
                                     {                                        
                                        otherDptVal = string.valueof(engageDeptMap.get(UtilConstants.JSON_OTHER_DEPT));
                                     }                                                                          
                                     finalizedDepts.add(engageDeptMap.get(UtilConstants.JSON_NAME_FIELD));   
                                 }                                                                 
                             }                    
                         }
                     }
                 }                      
                 if(finalizedDepts != null)
                 {                     
                     createSMEApprovals(inputMap,finalizedDepts,outMap,OtherDptVal);                            
                 }                                                                       
            }                               
        }   
        return true; 
    }
    
    /*
    Method Name: createSMEApprovalOutmap
    Method Signature:public static Set<String> createSMEApprovalOutmap(Map<String,Object> outMap,String departmentout,Map<String,String> SIAutoDepartmenttMap,
                             Set<Object> SIAutoDepartment,Map<String,Set<Object>> STAutoDepartment,Set<String> actualDept)
    Method Return Type: Set<String>
    Method Description: This method is called from return value method to autoengageDepartmentList and send it back to OmniScript
    */
    public static Set<String> createSMEApprovalOutmap(Map<String,Object> outMap,String departmentout,Map<String,String> SIAutoDepartmenttMap,
                             Set<Object> SIAutoDepartment,Map<String,Set<Object>> STAutoDepartment,Set<String> actualDept)
    {        
        try
        {           
            //SIAutoDepartmenttMap.put(UtilConstants.JSON_NAME_FIELD,departmentout.substring(4));
            SIAutoDepartmenttMap.put(UtilConstants.JSON_NAME_FIELD,departmentout);
            SIAutoDepartmenttMap.put(UtilConstants.VLC_SELECTED,UtilConstants.TRUE_VAL);
            SIAutoDepartment.add(SIAutoDepartmenttMap);            
            STAutoDepartment.put(UtilConstants.SI_AUTO_DEPARTMENT,SIAutoDepartment);                                                
            outMap.put(UtilConstants.ST_AUTO_DEPARTMENT, STAutoDepartment);             
            actualDept.add(departmentout);          
         }   
         catch(Exception excp)
         { 
             UTIL_LoggingService.logHandledException(excp, UtilConstants.ORGID, UtilConstants.APPNAME, 
                                                       CLASS_NAME, UtilConstants.CANCEL,TEST_CLASS,LoggingLevel.ERROR); 
         }                            
       return actualDept;         
     }
     
   /*
    Method Name: createAssignDepartment
    Method Signature:public static Set<String> createAssignDepartment(String  productname ,Boolean  resultofMedicalProducts,Boolean resultofLiteMedicalProducts,
                                                      String  GroupNumberclaimSystem,Set<String> department ) 
    Method Return Type: Set<String>
    Method Description: This method is called from return value method to get the list of department based on the available products
    */ 
   public static Set<String> createAssignDepartment(String  productname ,Boolean  resultofMedicalProducts,Boolean resultofLiteMedicalProducts,
                                                     String  GroupNumberclaimSystem,Set<String> department,String implementationCaseType,String productStage )         
   {                                               
        try
        {           
            if(productname.equalsIgnoreCase(UtilConstants.ONSITE_CLINICS))
            {
                department.add(UtilConstants.SME_ONSITE_CLINIC); 
            } 
            if(productname.equalsIgnoreCase(UtilConstants.HEALTH_GUIDE_PRODUCT))
            {                
                department.add(UtilConstants.SME_HEALTH_GUIDE); 
                //Since we are not supposed to engage 'CCM' when there is an 'Other-Anthem Health Guide' product for a 'Pre Work' Implementation case.
                if(implementationCaseType.equalsIgnoreCase(UtilConstants.CHANGE_REQUEST_OFF_CYCLE) && (productStage !=UtilConstants.RENEWED &&  productStage !=UtilConstants.SOLD))
                {                   
                    department.add(UtilConstants.SME_COORDINATED_CARE_MODEL);
                }
            } 
            if(productname.equalsIgnoreCase(UtilConstants.MEDICAL_ACTWISE_CDHP_HRA) || productname.equalsIgnoreCase(UtilConstants.MEDICAL_ACTWISE_CDHP_HSA))
            {
                department.add(UtilConstants.SME_ACT_WISE_CDH);
            } 
            if(Utilconstants.BENEFITSADMIN.contains(productname))            
            {
                department.add(UtilConstants.SME_ACTWISEFSA); 
            }   
            //Checking if current product belongs to Dental family                               
            if((UtilConstants.listOfAllDentalProducts).contains(productname)) 
            {           
                department.add(UtilConstants.SME_DENTAL);
            }
            if(UtilConstants.EAPPRODUCTS.contains(productname)) 
            {           
                department.add(UtilConstants.SME_EAP); 
            }
            if(UtilConstants.PHARMACYPRODUCTS.contains(productname)) 
            {           
                department.add(UtilConstants.SME_PHARMACY); 
            }                                            
            if(Utilconstants.LIFEANDDISABILITY.contains(productname))  
            {          
                department.add(UtilConstants.SME_LIFE);   
            }                                     
            if(UtilConstants.HEALTHEQUITY_PRODUCTS.contains(productname)) 
            {           
                department.add(UtilConstants.SME_HEALTHEQUITY);     
            } 
            if(productname.equalsIgnoreCase(UtilConstants.VIRTUAL_SECOND_OPINION))
            {
               department.add(UtilConstants.SME_Virtual_Second_Opinion);
            } 
            
            // 27413 Added Products BLUE VIEW VISION INSIGHT SAFETY AND BLUE VIEW VISION SAFETY
            if(productname.equalsIgnoreCase(UtilConstants.VISION_BLUE_VIEW_VISION) || productname.equalsIgnoreCase(UtilConstants.VISION_BLUE_VIEW_VISION_INSIGHT) || productname.equalsIgnoreCase(UtilConstants.VISION_BLUE_VIEW_VISION_SELECT) || productname.equalsIgnoreCase(UtilConstants.VISION_NASCO_VISION)
              || productname.equalsIgnoreCase(UtilConstants.VISION_BLUE_VIEW_VISION_SAFETY) || productname.equalsIgnoreCase(UtilConstants.VISION_BLUE_VIEW_VISION_INSIGHT_SAFETY))          
            {
                department.add(UtilConstants.SME_VISION); 
            }
            
            if(UtilConstants.listOfAnthemFlexProducts.contains(productname)) 
            {           
                department.add(UtilConstants.SME_ANTHEM_FLEX_HOUR);     
            }                                             
            if(productname.equalsIgnoreCase(UtilConstants.MERCER) && resultofMedicalProducts)
            {            
                department.add(UtilConstants.SME_MERCER);
            }            
            if( (UtilConstants.listOfAllMedicalProducts.Contains(productname)) &&
                (implementationCaseType.equalsIgnoreCase(UtilConstants.CHANGE_REQUEST_OFF_CYCLE)) && 
               (productStage==UtilConstants.IGAP_SOLD || productStage==UtilConstants.TERMED ||
                productStage==UtilConstants.RENEWED   || productStage==UtilConstants.SOLD ))
            {
                department.add(UtilConstants.SME_CLAIMS);
                department.add(UtilConstants.SME_UM_INTAKE);
            }                      
            if(productname.equalsIgnoreCase(UtilConstants.LIVEHEALTH_ONLINE)) 
            {           
                department.add(UtilConstants.SME_LIVEHEALTH); 
            }
            if(productname.equalsIgnoreCase(UtilConstants.NCN_PRODUCT))
            {            
                department.add(UtilConstants.SME_NCN);
            }
            if(productname.equalsIgnoreCase(UtilConstants.TELEHEALTH_PRODUCT))
            {            
                department.add(UtilConstants.SME_TELEHEALTH);    
            }
            //-- PRDCRM-44831 ; cmh 10/8/19
            if(productname.equalsIgnoreCase(UtilConstants.DENTALCOMPLETE) || productname.equalsIgnoreCase(UtilConstants.DENTALPRIME) || productname.equalsIgnoreCase('Dental: Anthem Dental Essential Choice (DeCare)') )            
            {
                department.add(UtilConstants.SME_DECARE); 
            }
            //Removed the Existing Conditions as per the defect 24494 because of this,for different productstages
            // code is not working. exisiting conditions. 
            //(productname.equalsIgnoreCase(UtilConstants.Medical_CDHP_HIA) && productStage == UtilConstants.SOLD || 
            //productname.equalsIgnoreCase(UtilConstants.Medical_CDHP_HRA) && productStage == UtilConstants.SOLD ||
            //productname.equalsIgnoreCase(UtilConstants.Medical_CDHP_HSA) && productStage == UtilConstants.SOLD)
          
                      
            if(resultofLiteMedicalProducts && (GroupNumberclaimSystem == UtilConstants.NASCO ||
               GroupNumberclaimSystem == UtilConstants.WGS))               
            {   
                if(implementationCaseType.equalsIgnoreCase(UtilConstants.NEW_BUSINESS)){
                    if((productname.equalsIgnoreCase(UtilConstants.Medical_CDHP_HIA) && productStage == UtilConstants.SOLD || 
                       productname.equalsIgnoreCase(UtilConstants.Medical_CDHP_HRA) && productStage == UtilConstants.SOLD ||
                       productname.equalsIgnoreCase(UtilConstants.Medical_CDHP_HSA) && productStage == UtilConstants.SOLD))
                        {
                            department.add(UtilConstants.SME_LITES); 
                        }
                }
                else{
                    department.add(UtilConstants.SME_LITES); 
                }
                                                
            }                                    
            if(productname.equalsIgnoreCase(UtilConstants.BOLD_VAL))
            {                            
                department.add(UtilConstants.SME_BOLD);
                department.add(UtilConstants.SME_MERCER);  
                department.add(UtilConstants.SME_IHM);
                department.add(UtilConstants.SME_HEALTH_GUIDE);                
            }           
            if((productname.equalsIgnoreCase(UtilConstants.IHM) || 
                productname.equalsIgnoreCase(UtilConstants.CUSTOMER_CARE_MANAGEMENT)) && resultofMedicalProducts)
            {                   
                if(productname.equalsIgnoreCase(UtilConstants.IHM)) 
                {               
                    department.add(UtilConstants.SME_IHM);  
                }              
                else 
                {               
                    department.add(UtilConstants.SME_CCMU);
                }                                            
            }            
            
        }
        catch(Exception excp)
        { 
            UTIL_LoggingService.logHandledException(excp, UtilConstants.ORGID, UtilConstants.APPNAME, 
                                                      CLASS_NAME, UtilConstants.CANCEL,TEST_CLASS,LoggingLevel.ERROR); 
        } 
        
        return department;
     }            
    
  /*
    Method Name: returnValue
    Method Signature:public static Map<String,Set<Object>> returnValue(Map<String,Object> inputMap, Map<String,
                                   Object> outMap,Map<String,Object> optns)
    Method Return Type: Map<String,Set<Object>>
    Method Description: This method is called from invoke method, here based on 'Implementation Type' of 'Implementation Case', 'Product' 
                        of 'Quote Line Item' and conditions below Auto and Manual departments are set at Omni-Script End.
    */
    public static Map<String,Set<Object>> returnValue(Map<String,Object> inputMap, Map<String,
                                   Object> outMap,Map<String,Object> optns)
    {
       
       //Variable Declaration 
        Boolean resultofAvailProducts        = false;
        Boolean resultofMedicalProducts      = false;
        Boolean resultofLiteMedicalProducts  = false; 
        Boolean resultOfNotCCMRelatedProducts= false; 
        //Boolean resultOfCCMRelatedProducts   = false;  
        Boolean resOfNotSpeciltyPharmaRelProd= false;
        Boolean resultOfTHTYRelatedProducts  = false;
        String implementationType            = '';           
        String contextId                     =  String.valueOf(inputMap.get(UtilConstants.CONTEXT_ID));  
        Set<String> department               =  new Set<String>(); //Considering List as ther can be different departments('Quote Line Items').
        Set<String> actualDept               =  new Set<String>(); // Department values will be prefixed with 'SME', since they are defined that way in 'Department' picklist of 'SME Routing object', but for front end we do not want 'SME' prefixed. Hence getting actual values from 'QLI'
        Set<String> autoengdepartment        =  UtilConstants.autoengdepartment;                    
        Set<String> filteredAutoDepts        =  new Set<String>();
        Set<String> availableProducts        =  new Set<String>();
        String preImplementationType         =  String.valueOf(inputMap.get(UtilConstants.PRE_IMPLEMENTATION_TYPE));
        String implementationCaseType        =  String.valueOf(inputMap.get(UtilConstants.IMPLEMENTATION_TYPE));
        String SelectionReport               =  String.valueof(inputMap.get(UtilConstants.SELECT_REPORT));
        String GroupTerm                     =  String.valueof(inputMap.get(UtilConstants.GROUPTERM));  
        String intakeRetro                   =  String.valueof(inputMap.get(UtilConstants.INTAKE_RETRO));
        String requestBenifits               =  String.valueof(inputMap.get(UtilConstants.REQUEST_BENEFITS));
        String eligibility                   =  String.valueof(inputMap.get(UtilConstants.CHANGES_TO_ELIGIBILITY));  
        String billingOrFunding              =  String.valueof(inputMap.get(UtilConstants.CHANGES_TO_BILLINGORFUNDING));  
        String idCardChanges                 =  String.valueof(inputMap.get(UtilConstants.ID_CARD_CHANGES));  
        String claimSystem                   =  String.valueof(inputMap.get(UtilConstants.CLAIM_SYSTEM));
        String reqChanges                    =  String.valueof(inputMap.get(UtilConstants.REQCHANGES));
        String apprvdbyoutsourcing           =  String.valueof(inputMap.get(UtilConstants.APROUT));
        String changeRate                    =  String.valueof(inputMap.get(UtilConstants.CHANGERATE));
        String partialApply                  =  String.valueof(inputMap.get(UtilConstants.PARTIALAPPLY));   
        String projectPlan                   =  String.valueof(inputMap.get(UtilConstants.PROJECT_PLAN_NEEDED));
        String decisionsAndDeliverables      =  String.valueof(inputMap.get(UtilConstants.DECISIONS_DELIVERABLES_LIST));
        String doesAnthemProdSME             =  String.valueof(inputMap.get(UtilConstants.Does_Anthem_Prod_SME));
        String wantTheSBCCreatedBySME        =  String.valueof(inputMap.get(UtilConstants.Want_The_SBC_Created_By_SME));
        String doesAnthemProdBenefitSME      =  String.valueof(inputMap.get(UtilConstants.Does_Anthem_Prod_Benefit_SME));
        String doesthisrequireanewBenefitSME =  String.valueof(inputMap.get(UtilConstants.Does_This_Require_A_New_Benefit_SME));  
        String existingShiftJaaField         =  String.valueof(inputMap.get(UtilConstants.EXISTINGSHIFTJAAFIELD));      
        Set<String> listOfAllProducts        =  UtilConstants.listOfAllProducts;  
        Set<String> listOfAllMedicalProducts =  new Set<String>(UtilConstants.listOfAllMedicalProducts);   
        Set<String> liteRelatedMedicals      =  UtilConstants.liteRelatedMedicals;
        Set<String> ccmRelatedProducts       =  new Set<String>(UtilConstants.ccmRelatedProducts); 
        Set<String> ccmRelatedProductsForCROC=  new Set<String>(UtilConstants.ccmRelatedProducts); //Since for CROC we are considering "If the listed Products are present" where as in the above variable we will remove the item which we cannot check in CROC condition as that item will be lost and our condition will fail.        
        Set<String> thtyRelatedProducts      =  UtilConstants.thtyRelatedproducts; 
        Set<String> specialtyPharmacyProducts=  UtilConstants.listOfSpecialtyPharmacyProducts;
        Set<Object> SIAutoDepartment         =  new Set<Object>();
        Set<Object> SIManualDepartment       =  new Set<Object>(); 
        Set<String> SISortedManualDepartment =  autoengdepartment.clone();                                              
        Map<String,Set<Object>> STAutoDepartment  = new Map<String,Set<Object>>();    
        Map<String,Set<Object>>STManualDepartment = new Map<String,Set<Object>>(); 
        Map<String,String> fundingMap         =  new Map<String,String>();          
        Set<String> availMedProdForQLI = new Set<String>(); 
        Set<String> additonalDept = new Set<String>();
        String jaaFieldValueToUseInImplementation  = '';

        //---- get IMPL more info ; PRDCRM-42480 ; cmh 
        Order implMoreInfo = [select Modification_to_existing_booklet__c,claim_system__c,Implementation_Type__c,Intake_Type_Migration__c,Are_there_changes_to_COB__c,Pre_Implementation_Type__c
                                ,quote.opportunity.Account.Region__c
             from Order where Id = :contextId];
        implMoreInfo = (implMoreInfo==null) ? (new Order()) : implMoreInfo;
        String Modificationtoexisting_booklet = implMoreInfo.Modification_to_existing_booklet__c;
        //--PRDCRM-42480
        String AcctRegion =  (implMoreInfo.quote.opportunity.Account.Region__c <>null ) ? implMoreInfo.quote.opportunity.Account.Region__c : '' ;
        
        //---- add COB ; PRDCRM-39088 cmh 
        if ( implMoreInfo.claim_system__c == 'WGS 2.0'
            &&  (      ( implMoreInfo.Implementation_Type__c == 'New Business' )
                    || ( implMoreInfo.Implementation_Type__c == 'Renewal' && implMoreInfo.Intake_Type_Migration__c == true )
                    || ( implMoreInfo.Implementation_Type__c == 'Renewal'  && implMoreInfo.Are_there_changes_to_COB__c == 'Yes' )
                    || ( implMoreInfo.Implementation_Type__c == 'Change Request Off Cycle' && implMoreInfo.Are_there_changes_to_COB__c == 'Yes')
                    || ( implMoreInfo.Implementation_Type__c == 'Pre Work' && implMoreInfo.Pre_Implementation_Type__c == 'RFP')
                 )
         ) { additonalDept.add('Coordination of Benefits'); }
         autoengdepartment.add('Coordination of Benefits');
         SISortedManualDepartment.add('Coordination of Benefits');

        
        List<QuoteLineItem> items = new List<QuoteLineItem>
           ([SELECT Id,productname__c,ProductStage__c,Renewed_with_Changes__c,
            Quote.GroupNumber__r.ClaimSystem__c,Product_Family__c,
            Membership_Split_Between_MHA_and_Non_MHA__c,IsMembershipSplitBetweenCCMUnonCCMU__c,
            MembershipsplitbetweenIHMandnonIHM__c,ProductLOB__c FROM Quotelineitem
            WHERE QuoteID IN (select Quoteid from Order 
            where Id = :contextId and Implementation_type__c IN 
            (:UtilConstants.NEW_BUSINESS,:UtilConstants.RENEWAL,
            :UtilConstants.CHANGE_REQUEST_OFF_CYCLE,:UtilConstants.PRE_WORK)) LIMIT :Limits.getLimitDmlRows()]);                                        
         
        if(inputMap.get(UtilConstants.QLI) != null)
        {               
            List<Object> quoteLineItemFields      =  new List<Object>{inputMap.get(UtilConstants.QLI)}; 
                
            List<Object> quoteLineItemFields2 = new List<Object>();                           
            for(Object tempObj : quoteLineItemFields) 
            {                
               if(tempObj instanceof Map<String,Object>)                     
               {   Map<String,Object> quoteLineItemFieldsMap = (Map<String,Object>) tempObj;   
                   String s = string.valueof(quoteLineItemFieldsMap.get(UtilConstants.QLITPRODNAME));               
                   if(listOfAllMedicalProducts.contains(s))
                   {
                       availMedProdForQLI.add(string.valueof(quoteLineItemFieldsMap.get(UtilConstants.QLITID)));
                   }        
                   if(quoteLineItemFieldsMap.get(UtilConstants.FUNDING) != null)  
                   {  
                       if((quoteLineItemFieldsMap.get(UtilConstants.FUNDING) == UtilConstants.ASO 
                                                   || quoteLineItemFieldsMap.get(UtilConstants.FUNDING) == UtilConstants.FI)
                       && quoteLineItemFieldsMap.get(UtilConstants.FINANCING) == UtilConstants.JAAT)
                       {
                            jaaFieldValueToUseInImplementation = UtilConstants.TRUE_VAL;
                       }                                             
                   }       
               }                                    
               else  
               {   
                   quoteLineItemFields2 = (List<Object>) tempObj;                          
               }           
            }                       
            for(Object tempEngage : quoteLineItemFields2 )
            {               
                Map<String,Object> quoteLineItemFieldsMap = (Map<String,Object>) tempEngage;                       
                String s = string.valueof(quoteLineItemFieldsMap.get(UtilConstants.QLITPRODNAME));
                if(listOfAllMedicalProducts.contains(s))
                {
                     availMedProdForQLI.add(string.valueof(quoteLineItemFieldsMap.get(UtilConstants.QLITID)));
                }  
                if(quoteLineItemFieldsMap.get(UtilConstants.FUNDING) != null)                       
                {  
                    if((quoteLineItemFieldsMap.get(UtilConstants.FUNDING) == UtilConstants.ASO 
                                                   || quoteLineItemFieldsMap.get(UtilConstants.FUNDING) == UtilConstants.FI)
                       && quoteLineItemFieldsMap.get(UtilConstants.FINANCING) == UtilConstants.JAAT)
                    {
                                jaaFieldValueToUseInImplementation = UtilConstants.TRUE_VAL;
                    }                                             
                }                           
            }               
        }
        List<AlternateNetwork__c> forDeptNetWrkManagement  = [select id from AlternateNetwork__c  where QuoteLineItem__c in :availMedProdForQLI
                              and AltNetStateOptions__c in : UtilConstants.availAltSetOpt limit :Limits.getLimitDmlRows()];
                            
                                                
       //Iterating over QuoteLineItems to know about the available products present on it               
        if(items.size()>0)
        {                                 
            //We will be collecting existing Products.
            for(QuoteLineItem tempItem : items)
            {
                availableProducts.add(tempItem.productname__c);
            }                        
            //Below check is to find if current Product/QLI is a part of valid Products.
            resultofAvailProducts       = listOfAllProducts.removeAll(availableProducts);
            //Below check is to check if any 'availableProduct' is part of Medical Product.
            resultofMedicalProducts     = listOfAllMedicalProducts.removeAll(availableProducts);            
            //Below check is to check if any 'availableProduct' is part of Lite related Medical Product.
            resultofLiteMedicalProducts = liteRelatedMedicals.removeAll(availableProducts);
            //Below check is to check if any 'availableProduct' is part of Cordinate Care Model Related Product.
            resultOfNotCCMRelatedProducts = ccmRelatedProducts.removeAll(availableProducts);
            //Below check is to verify if any 'availableProduct' is part of products with subtype as Specialty Pharmacy.
            resOfNotSpeciltyPharmaRelProd = specialtyPharmacyProducts.removeAll(availableProducts);
            //we are not using this variable
            resultOfTHTYRelatedProducts  = thtyRelatedProducts.removeAll(availableProducts);
            
        } 

        if(items.size()>0)
        {   for(QuoteLineItem tempItem : items)
            {                                                    
                implementationType = UtilConstants.PERCENTAGE + implementationCaseType + UtilConstants.PERCENTAGE;  
                if(forDeptNetWrkManagement.size()>0 && preImplementationType != UtilConstants.BENEFIT_INQUIRY)
                {
                   department.add(UtilConstants.SME_NETWORK_MANAGEMENT);  
                }   
                if(((tempItem.productname__c.equalsIgnoreCase(UtilConstants.IHM) || tempItem.Product_Family__c == UtilConstants.PRODUCTFAMILY)  && tempItem.MembershipsplitbetweenIHMandnonIHM__c == UtilConstants.YES_VAL) ||
                  (tempItem.productname__c.equalsIgnoreCase(UtilConstants.MERCER)                   && tempItem.Membership_Split_Between_MHA_and_Non_MHA__c == UtilConstants.YES_VAL) ||
                  (tempItem.productname__c.equalsIgnoreCase(UtilConstants.CUSTOMER_CARE_MANAGEMENT) && tempItem.IsMembershipSplitBetweenCCMUnonCCMU__c == UtilConstants.YES_EXPLAIN))
                {                                         
                    department.add(UtilConstants.SME_COORDINATED_CARE_MODEL);
                    implementationType = UtilConstants.PERCENTAGE + implementationCaseType + UtilConstants.PERCENTAGE;     
                }                
                if(((apprvdbyoutsourcing == UtilConstants.TRUE_VAL && preImplementationType != UtilConstants.BENEFIT_INQUIRY)|| 
                   ((changeRate == UtilConstants.YES_VAL || reqChanges== UtilConstants.YES_VAL) && 
                   !implementationCaseType.equalsIgnoreCase(UtilConstants.PRE_WORK))) || 
                    (tempItem.ProductLOB__c == UtilConstants.STOP_LOSS && preImplementationType != UtilConstants.BENEFIT_INQUIRY) || 
                    ((tempItem.ProductStage__c ==UtilConstants.IGAP_SOLD  || tempItem.ProductStage__c == UtilConstants.TERMED  ||
                     tempItem.ProductStage__c == UtilConstants.SOLD)&& preImplementationType != UtilConstants.BENEFIT_INQUIRY))  
                {
                    department.add(UtilConstants.SME_UNDERWRITING);
                }   
                
                //Since SBC SME's are not dependent on 'Implementation Type', we wil be executing below logic to engage SBC SME.
                if((String.isNotBlank(doesAnthemProdSME) && doesAnthemProdSME.equalsIgnoreCase(UtilConstants.YES_VAL)) &&
                   (String.isNotBlank(wantTheSBCCreatedBySME) && wantTheSBCCreatedBySME.equalsIgnoreCase(UtilConstants.YES_VAL)) )
                {                    
                    department.add(UtilConstants.SME_SBC);
                }  
                doesthisrequireanewBenefitSME = (doesthisrequireanewBenefitSME==NULL) ? 'No' : doesthisrequireanewBenefitSME;   
                Modificationtoexisting_booklet = (Modificationtoexisting_booklet==NULL) ? 'No' : Modificationtoexisting_booklet;           
                
                //--PRDCRM-42480
                if (AcctRegion == 'West'){
                    //Since Benefit SME's are not dependent on 'Implementation Type', we wil be executing below logic to engage Benefit SME.
                    if((String.isNotBlank(doesAnthemProdBenefitSME) && doesAnthemProdBenefitSME.equalsIgnoreCase(UtilConstants.YES_VAL)) &&
                       (String.isNotBlank(doesthisrequireanewBenefitSME) && 
                       (doesthisrequireanewBenefitSME.equalsIgnoreCase(UtilConstants.YES_VAL) || Modificationtoexisting_booklet.equalsIgnoreCase(UtilConstants.YES_VAL) )) )
                    {department.add(UtilConstants.SME_BENEFIT); }
                }  // if (AcctRegion == 'West')
                
                
                //For any Department if Implementation Type is 'Change Request Off Cycle', it must be included in below loop wth additional 'if' condition 
                if(implementationCaseType.equalsIgnoreCase(UtilConstants.CHANGE_REQUEST_OFF_CYCLE))
                {                         
                     if(jaaFieldValueToUseInImplementation == UtilConstants.TRUE_VAL  &&
                        (tempItem.ProductStage__c ==UtilConstants.IGAP_SOLD  || tempItem.ProductStage__c == UtilConstants.TERMED  ||
                         tempItem.ProductStage__c == UtilConstants.SOLD))
                     {
                            department.add(UtilConstants.SME_JAANTS);
                     }  
                     department.addAll(UtilConstants.listOfSMEHGIDepartments); //These are the common departments which do not have more filters
                     implementationType = UtilConstants.PERCENTAGE + implementationCaseType + UtilConstants.PERCENTAGE;
                     if(partialApply ==  UtilConstants.YES_VAL)
                     {
                         department.add(UtilConstants.SME_UNDERWRITING);
                     }
                     //if(idCardChanges == UtilConstants.YES_VAL)  // cmh PRDCRM-26539
                     //{
                         department.add(UtilConstants.SME_ID_CARDS);
                     //}
                     //if(eligibility == UtilConstants.YES_VAL || billingOrFunding == UtilConstants.YES_VAL) // cmh PRDCRM-39766
                     //{
                         department.add(UtilConstants.SME_ENROLL);
                     //}
                     
                     if((resultofMedicalProducts)  && (tempItem.Product_Family__c == UtilConstants.PRODUCTFAMILY) &&
                                  (tempItem.ProductStage__c ==UtilConstants.IGAP_SOLD  || tempItem.ProductStage__c == UtilConstants.TERMED  ||
                                   tempItem.ProductStage__c == UtilConstants.RENEWED     || tempItem.ProductStage__c == UtilConstants.SOLD))                                            
                     {
                         department.add(UtilConstants.SME_THTY);
                     }  
                     if(tempItem.ProductLOB__c == UtilConstants.STOP_LOSS || 
                        (tempItem.ProductStage__c ==UtilConstants.IGAP_SOLD  || tempItem.ProductStage__c == UtilConstants.TERMED  ||
                         tempItem.ProductStage__c == UtilConstants.SOLD ) || reqChanges == UtilConstants.YES_VAL)
                     {
                         department.add(UtilConstants.SME_MEDICAL_BENEFITS); 
                     }      
                     if((resultofAvailProducts || resultofMedicalProducts || resultOfNotCCMRelatedProducts)  &&                                  
                        (tempItem.ProductStage__c ==UtilConstants.IGAP_SOLD  || tempItem.ProductStage__c == UtilConstants.TERMED  ||
                        tempItem.ProductStage__c == UtilConstants.RENEWED     || tempItem.ProductStage__c == UtilConstants.SOLD))                                            
                     {                                                     
                         department = createAssignDepartment(tempItem.productname__c,resultofMedicalProducts,resultofLiteMedicalProducts,
                                                             tempItem.Quote.GroupNumber__r.ClaimSystem__c,department,implementationCaseType,tempItem.ProductStage__c );
                         implementationType = UtilConstants.PERCENTAGE +UtilConstants.CHANGE_REQUEST_OFF_CYCLE + UtilConstants.PERCENTAGE;                                                                       
                     }
                    if( resultofMedicalProducts && String.isNotBlank(claimSystem) && intakeRetro == UtilConstants.TRUE_VAL)
                    {   
                       if(claimSystem.equalsIgnoreCase(UtilConstants.WGS))
                       {
                        department.add(UtilConstants.SME_CLAIMS);
                       }
                       else if(claimSystem.equalsIgnoreCase(UtilConstants.NASCO))
                       {
                        department.add(UtilConstants.SME_CLAIMS_RETRO);
                        department.add(UtilConstants.SME_SERVICE_OPERATIONS_RETRO);
                       }
                       else
                       {
                       
                       }       
                    }
                    if( String.isNotBlank(claimSystem)     && claimSystem.equalsIgnoreCase(UtilConstants.NASCO)    && 
                        String.isNotBlank(intakeRetro)     && intakeRetro.equalsIgnoreCase(UtilConstants.TRUE_VAL) && 
                        String.isNotBlank(requestBenifits) && requestBenifits.equalsIgnoreCase(UtilConstants.YES_VAL))
                    { 
                        department.add(UtilConstants.SME_MEDICAL_NASCO_RETRO);
                        
                    }
                    if( resultofMedicalProducts && String.isNotBlank(claimSystem) && claimSystem.equalsIgnoreCase(UtilConstants.NASCO) &&
                      (tempItem.ProductStage__c ==UtilConstants.IGAP_SOLD || 
                      tempItem.ProductStage__c == UtilConstants.RENEWED || 
                      tempItem.ProductStage__c == UtilConstants.SOLD))
                    {
                        department.add(UtilConstants.SME_BLUE_EXCHANGE);
                    }                    
                    
                    if((ccmRelatedProductsForCROC.contains(tempItem.ProductName__c) || 
                        tempItem.ProductName__c == UtilConstants.HEALTH_GUIDE_PRODUCT) &&
                        (tempItem.ProductStage__c == UtilConstants.IGAP_SOLD  || 
                        tempItem.ProductStage__c == UtilConstants.TERMED  ))
                     {                                                                          
                         department.add(UtilConstants.SME_COORDINATED_CARE_MODEL);                        
                     } 
                 }
                                
                 //For any Department if Implementation Type is 'New Business', it must be included in below loop wth additional 'if' condition             
                 else if(implementationCaseType.equalsIgnoreCase(UtilConstants.NEW_BUSINESS))
                 {   
                     if(jaaFieldValueToUseInImplementation == UtilConstants.TRUE_VAL)
                     {
                         department.add(UtilConstants.SME_JAANTS);
                     }       
                     department.addAll(UtilConstants.listOfSMEHGIDepartments); //These are the common departments which do not have more filters
                     department.add(UtilConstants.SME_ID_CARDS);
                     department.add(UtilConstants.SME_ENROLL);
                     department.add(UtilConstants.SME_UNDERWRITING);                      
                     department.add(UtilConstants.SME_CLAIMS); 
                     department.add(UtilConstants.SME_UM_INTAKE);
                     implementationType = UtilConstants.PERCENTAGE + implementationCaseType + UtilConstants.PERCENTAGE;  
                     if(tempItem.ProductLOB__c == UtilConstants.STOP_LOSS || 
                        claimSystem == UtilConstants.NASCO)
                     {
                         department.add(UtilConstants.SME_MEDICAL_BENEFITS); 
                     }
                     if(claimSystem == UtilConstants.WGS && !resOfNotSpeciltyPharmaRelProd)
                     {
                         department.add(UtilConstants.SME_SPIDER); 
                     }
                     if(String.isNotBlank(claimSystem) && claimSystem.equalsIgnoreCase(UtilConstants.NASCO))
                     {
                         department.add(UtilConstants.SME_BLUE_EXCHANGE); 
                     }                      
                     if((resultofMedicalProducts) && (tempItem.Product_Family__c == UtilConstants.PRODUCTFAMILY) &&  
                     tempItem.ProductStage__c == UtilConstants.SOLD)
                     {                          
                          department.add(UtilConstants.SME_THTY);
                     }                      
                     if((!resultOfNotCCMRelatedProducts) && (tempItem.Product_Family__c != UtilConstants.PRODUCTFAMILY) )
                     {                                                                        
                         department.add(UtilConstants.SME_COORDINATED_CARE_MODEL);
                         implementationType = UtilConstants.PERCENTAGE + UtilConstants.NEW_BUSINESS + UtilConstants.PERCENTAGE;
                     }                                           
                     if((resultofAvailProducts || resultofMedicalProducts)  &&  tempItem.ProductStage__c == UtilConstants.SOLD)
                     {                                               
                         department = createAssignDepartment(tempItem.productname__c,resultofMedicalProducts,resultofLiteMedicalProducts,
                                                             tempItem.Quote.GroupNumber__r.ClaimSystem__c,department,implementationCaseType,tempItem.ProductStage__c);
                         implementationType = UtilConstants.PERCENTAGE + UtilConstants.NEW_BUSINESS + UtilConstants.PERCENTAGE;                                                  
                     }
                 }
                    
                 //For any Department if Implementation Type is 'Renewal', it must be included in below loop wth additional 'if' condition   
                 else if(implementationCaseType.equalsIgnoreCase(UtilConstants.RENEWAL))
                 {   
                     department.addAll(UtilConstants.listOfSMEHGIDepartments); //These are the common departments which do not have more filters
                     implementationType = UtilConstants.PERCENTAGE + implementationCaseType + UtilConstants.PERCENTAGE; 
                                                       
                     //if(idCardChanges == UtilConstants.YES_VAL)  // cmh PRDCRM-26539
                     //{ 
                         department.add(UtilConstants.SME_ID_CARDS);
                     //}
                     if(GroupTerm == UtilConstants.TRUE_VAL)
                     {
                         department.add(UtilConstants.SME_UNDERWRITING);
                         department.add(UtilConstants.SME_ID_CARDS);
                         department.add(UtilConstants.SME_UM_INTAKE);
                     }
                     if(jaaFieldValueToUseInImplementation == UtilConstants.TRUE_VAL && ((tempItem.ProductStage__c == UtilConstants.IGAP_SOLD
                          || tempItem.ProductStage__c == UtilConstants.TERMED) || 
                          (GroupTerm == UtilConstants.TRUE_VAL || existingShiftJaaField == UtilConstants.TRUE_VAL)))
                     {
                          department.add(UtilConstants.SME_JAANTS);           
                     } 
                     if(resultofMedicalProducts && String.isNotBlank(claimSystem) && claimSystem.equalsIgnoreCase(UtilConstants.NASCO) &&
                       (tempItem.Renewed_with_Changes__c == UtilConstants.YES_VAL || tempItem.ProductStage__c == UtilConstants.IGAP_SOLD))
                     {
                         department.add(UtilConstants.SME_BLUE_EXCHANGE); 
                     }     
                     
                     //check we can include this condition in above if only
                     // cmh PRDCRM-39766
                     //if(groupTerm == UtilConstants.TRUE_VAL ||
                     //    (eligibility == UtilConstants.YES_VAL || billingOrFunding == UtilConstants.YES_VAL )) 
                     //{
                        department.add(UtilConstants.SME_ENROLL);
                     //}                                             
                     if(tempItem.ProductLOB__c == UtilConstants.STOP_LOSS ||  
                        (GroupTerm == UtilConstants.TRUE_VAL ||  (UtilConstants.listOfAllMedicalProducts.Contains(tempItem.productname__c)  && 
                        (tempItem.Renewed_with_Changes__c == UtilConstants.YES_VAL || tempItem.ProductStage__c == UtilConstants.TERMED))))
                     {
                         department.add(UtilConstants.SME_MEDICAL_BENEFITS); 
                     } 
                     if((resultofMedicalProducts) && tempItem.Product_Family__c == UtilConstants.PRODUCTFAMILY 
                            && ( tempItem.ProductStage__c == UtilConstants.IGAP_SOLD  || 
                                     (tempItem.Renewed_with_Changes__c == UtilConstants.YES_VAL && 
                                        tempItem.ProductStage__c == UtilConstants.RENEWED )||
                                      tempItem.ProductStage__c == UtilConstants.TERMED))
                     {
                         department.add(UtilConstants.SME_THTY);
                     } 
                     if(!resultOfNotCCMRelatedProducts)
                     {                        
                         department.add(UtilConstants.SME_COORDINATED_CARE_MODEL);
                         implementationType = UtilConstants.PERCENTAGE + UtilConstants.RENEWAL + UtilConstants.PERCENTAGE;
                     }
                     if( ( resultofAvailProducts || resultofMedicalProducts )  && 
                         tempItem.ProductStage__c == UtilConstants.IGAP_SOLD  || (tempItem.ProductStage__c == UtilConstants.RENEWED && 
                         tempItem.Renewed_with_Changes__c == UtilConstants.YES_VAL) || tempItem.ProductStage__c ==UtilConstants.TERMED )                                   
                     {                                    
                         department = createAssignDepartment(tempItem.productname__c,resultofMedicalProducts,resultofLiteMedicalProducts,                                                           
                                                             tempItem.Quote.GroupNumber__r.ClaimSystem__c,department,implementationCaseType,tempItem.ProductStage__c);                         
                         implementationType = UtilConstants.PERCENTAGE + UtilConstants.RENEWAL + UtilConstants.PERCENTAGE;                             
                     }
                     //Since for 'Claims' we do not have check for 'Renewed with Changes' we are writing below condition. 
                     if(GroupTerm == UtilConstants.TRUE_VAL || (UtilConstants.listOfAllMedicalProducts.Contains(tempItem.productname__c) && 
                       (tempItem.ProductStage__c == UtilConstants.IGAP_SOLD  || tempItem.ProductStage__c == UtilConstants.RENEWED  || 
                        tempItem.ProductStage__c == UtilConstants.TERMED)))                                   
                     {                                                             
                         department.add(UtilConstants.SME_CLAIMS);
                         implementationType = UtilConstants.PERCENTAGE + UtilConstants.RENEWAL + UtilConstants.PERCENTAGE;                             
                     } 
                     //for UM Intake we don't have check for Product stage = Renewed So writting below condition
                      if(groupTerm == UtilConstants.TRUE_VAL || 
                        (tempItem.ProductStage__c == UtilConstants.IGAP_SOLD || 
                            tempItem.ProductStage__c == UtilConstants.TERMED))                                   
                     {                                                             
                         department.add(UtilConstants.SME_UM_INTAKE);
                     }  
                     /* Commenting as part of US 21918                       
                     if(tempItem.productname__c.equalsIgnoreCase( UtilConstants.HEALTH_GUIDE_PRODUCT) && (tempItem.ProductStage__c == UtilConstants.IGAP_SOLD || tempItem.ProductStage__c == UtilConstants.RENEWED || tempItem.ProductStage__c ==  UtilConstants.TERMED))
                     {
                         system.debug('f');
                         department.add(UtilConstants.SME_COORDINATED_CARE_MODEL);
                         implementationType = UtilConstants.PERCENTAGE + UtilConstants.RENEWAL + UtilConstants.PERCENTAGE;
                     } 
                     */                                        
                 }
                     
                 //For any Department if Implementation Type is 'Pre Work', it must be included in below loop with additional 'if' condition 
                 //US23377 Adding Benefit Enquiry PreImplementation Type  for the existing condition Implementation Type = Pre-work with Pre-Work type = 'RFP' OR 'Castlight Products'
                 else if(implementationCaseType.equalsIgnoreCase(UtilConstants.PRE_WORK))
                 {                                             
                     if(tempItem.ProductLOB__c == UtilConstants.STOP_LOSS || SelectionReport == UtilConstants.YES_VAL
                        || preImplementationType == UtilConstants.RFP || preImplementationType == UtilConstants.CASTPROD ||  preImplementationType == UtilConstants.BENEFIT_INQUIRY)
                     {
                        department.add(UtilConstants.SME_MEDICAL_BENEFITS);  
                     }
                     if(String.isNotBlank(preImplementationType) && preImplementationType == UtilConstants.RFP)
                     {
                         department.add(UtilConstants.SME_HEALTH_AND_WELLNESS);
                         department.add(UtilConstants.SME_ENROLL);
                         //department.add(UtilConstants.SME_SUBROGATION);
                         if( projectPlan == UtilConstants.YES_VAL || decisionsAndDeliverables == UtilConstants.YES_VAL)
                         {
                             department.add(UtilConstants.SME_IMPLEMENTATIONS);
                         }
                         if((resultofMedicalProducts) && 
                         (tempItem.Product_Family__c == UtilConstants.PRODUCTFAMILY) 
                         &&(String.isNotBlank(preImplementationType) &&
                          preImplementationType == UtilConstants.RFP))
                         {
                             department.add(UtilConstants.SME_THTY);
                         } 
                         if(claimSystem == UtilConstants.WGS && !resOfNotSpeciltyPharmaRelProd)
                         {
                             department.add(UtilConstants.SME_SPIDER); 
                         } 
                         if(!resultOfNotCCMRelatedProducts)
                         {                                                       
                             department.add(UtilConstants.SME_COORDINATED_CARE_MODEL);                             
                         }
                         department = createAssignDepartment(tempItem.productname__c,resultofMedicalProducts,resultofLiteMedicalProducts,                                                          
                                                                tempItem.Quote.GroupNumber__r.ClaimSystem__c,department,implementationCaseType,tempItem.ProductStage__c);        
                     }                         
                     else if (String.isNotBlank(preImplementationType) && preImplementationType.equalsIgnoreCase(UtilConstants.NEW_ELIG))
                     {
                         department.add(UtilConstants.SME_GROUP_SERVICES);
                         department.add(UtilConstants.SME_DIT);
                         department.add(UtilConstants.SME_IMPLEMENTATIONS);     
                     } 
                     else if(String.isNotBlank(preImplementationType) && preImplementationType.equalsIgnoreCase(UtilConstants.DATA_INTERFACE))
                     {
                         department.add(UtilConstants.SME_DIT);
                         department.add(UtilConstants.SME_IMPLEMENTATIONS); 
                     }
                     else if(String.isNotBlank(preImplementationType) && (preImplementationType.equalsIgnoreCase(UtilConstants.SBC) || preImplementationType.equalsIgnoreCase(UtilConstants.CASTPROD) || 
                         preImplementationType.equalsIgnoreCase(UtilConstants.BENEFIT_INQUIRY) || preImplementationType.equalsIgnoreCase(UtilConstants.CLIENT_CUSTOMIZATION)))
                     {                                 
                         department.add(UtilConstants.SME_IMPLEMENTATIONS); 
                     }
                     else
                     {
                     
                     }
                     
                     implementationType = UtilConstants.PERCENTAGE + UtilConstants.PRE_WORK + UtilConstants.PERCENTAGE;                                                                                                                  
                 }
                 else
                 {
                 
                 }                                 
            }                              
        }            
            
        //Querying Sme_Approval_Routing_Logic Record which are Active based on department &implementation type gathered from previous block
        // to get Auto-Engage departments which are Active       
        List<SME_Approval_Routing_Logic__c> routingRecords = new List<SME_Approval_Routing_Logic__c>
                  ([SELECT Id,SME_Department__c,Active__c, Criteria__c FROM SME_Approval_Routing_Logic__c 
                    where SME_Department__c in :department and  Active__c = true
                     AND Criteria__c LIKE :implementationType  LIMIT :Limits.getLimitDmlRows()]);           
        
        
        // To store the department names, this Set will further be added to a List to sort it in Ascending Order.
        
        Set<String> autoDepartments = new Set<String>(); 
        //---- add additional department ; PRDCRM-39088 cmh 
        for(String o : additonalDept){
           autoDepartments.add(o);
        }
        try
        {   if(routingRecords.size()>0)
            {   for(SME_Approval_Routing_Logic__c tempRouting : routingRecords)
                {                                                              
                    autoDepartments.add(tempRouting.SME_Department__c.substring(4));                                
                }                           
                //To print the departments in Ascending Order we have to introduce List and sort it.             
                List<String> sortedAutoDepartment = new List<String>();
                sortedAutoDepartment.addAll(autoDepartments);
                sortedAutoDepartment.sort();                
                for(String tempDepartment : sortedAutoDepartment)
                {     
                    Map<String,String> SIAutoDepartmenttMap= new Map<String,String>();                    
                    actualDept  = createSMEApprovalOutmap(outMap, tempDepartment,SIAutoDepartmenttMap,SIAutoDepartment,
                                                          STAutoDepartment,actualDept);                
                }                                                                           
                STAutoDepartmentFinal =  STAutoDepartment.clone();                   
             }                       
             outMap.put(UtilConstants.FILTERED_AUTO_DEPTS, filteredAutoDepts);
        }
        catch(Exception excp)
        {
           UTIL_LoggingService.logHandledException(excp, UtilConstants.ORGID, UtilConstants.APPNAME, 
                                                       CLASS_NAME, UtilConstants.CANCEL,TEST_CLASS,LoggingLevel.ERROR); 
        }                
        
        SISortedManualDepartment.removeall(actualDept);
        actualDept.removeall(autoengdepartment);
        SISortedManualDepartment.addall(actualDept);
        //----sort
        List<String> SISortedManualDepartmentList = new List<String>();
        for(String tempManual : SISortedManualDepartment){SISortedManualDepartmentList.add(tempManual);}
        SISortedManualDepartmentList.sort();
        
        for(String tempManual : SISortedManualDepartmentList)
        {
           Map<String,String> SIManualDepartmentMap = new Map<String,String>(); 
            SIManualDepartmentMap.put(UtilConstants.JSON_NAME_FIELD,tempManual); 
            SIManualDepartment.add(SIManualDepartmentMap);                      
        }                         
        STManualDepartment.put(UtilConstants.SI_MANUAL_DEPARTMENT,SIManualDepartment);               
        outMap.put(UtilConstants.ST_MANUAL_DEPARTMENT, STManualDepartment);   
             
        return STAutoDepartmentFinal;       
    }
    
    /*
    Method Name: createSMEApprovals
    Method Signature: public static void createSMEApprovals(Map<String,Object> inputMap, Set<Object> deptList, Map<String,Object> outMap)
    Method Return Type: void
    Method Description: This method is called from 'invoke' method.
    */        
    public static void createSMEApprovals(Map<String,Object> inputMap, 
        Set<Object> deptList, Map<String,Object> outMap,String OtherDptVal)
    {                                                       
        String contextId                =  String.valueOf(inputMap.get(UtilConstants.CONTEXT_ID));
        String implementationType       =  String.valueOf(inputMap.get(UtilConstants.IMPLEMENTATION_TYPE));  
        String productEffectiveDate     =  String.valueOf(inputMap.get(UtilConstants.PRODUCT_EFFECTIVE_DATE));
        Order currentOrder              =  [Select Id,SME_Service_Operations__c,
                                                Account.RecordType.DeveloperName from Order where Id = :contextId 
                                                    limit :Limits.getLimitDmlRows()];
                               
        if (!deptList.isEmpty())
        {                        
            //Fetching Quote Line Items related to present Order.
            List<SME_Approvals__c> relatedSMEAprovals = [SELECT Id,SME_Department__c FROM SME_Approvals__c 
                                                            WHERE Implementation_Record_ID__c = :contextId LIMIT :Limits.getLimitDmlRows()] ;
            Set<String> existingSMEAPDepartments = new Set<String>(); //We store all the existeng 'SME Approval' records departments related to the Implementation Case.   
            
            if(!relatedSMEAprovals.isEmpty())
            {                            
                for(SME_Approvals__c tempSMEApproval : relatedSMEAprovals)
                {
                    existingSMEAPDepartments.add(tempSMEApproval.SME_Department__c);
                }                
            }            
            for (Object deptname : deptList)                              
            {
                 String checkBoxDepartment = '';
                 if(String.valueOf(deptname).equalsIgnoreCase(UtilConstants.PRICING_CONFIGURATION_MANAGEMENT_PCM))
                 {
                     checkBoxDepartment = UtilConstants.API_PRICING_CONFIGURATION_MANAGEMENT_PCM;
                 }
                 else
                 {
                     checkBoxDepartment = String.valueOf(deptname).replace(' - ','_');
                     checkBoxDepartment = 'SME_' + String.valueOf(checkBoxDepartment).replaceAll('[/ / /]','_') + '__c';
                     checkBoxDepartment = checkBoxDepartment.replaceAll('[/( )/]',''); 
                 }                 
                 currentOrder.put(checkBoxDepartment, true);                    
            }                   
            List<SME_Approvals__c> sme_approvalList = new List<SME_Approvals__c>();
            
            for (Object deptname : deptList)
            {                                                                  
                 SME_Approvals__c sme_apprnew = new  SME_Approvals__c();
                 if(String.valueOf(deptname).equalsIgnoreCase( UtilConstants.OTHER))
                 {                     
                     sme_apprnew.If_Other_List_Department__c = OtherDptVal;                     
                     sme_apprnew.SME_Department__c = String.valueOf(deptname);
                 }                     
                 
                 if(!existingSMEAPDepartments.Contains(String.valueOf(deptname)) &&  String.valueOf(deptname) != UtilConstants.IHM)
                 {                 
                     if(String.valueOf(deptname) != null)
                     {                                                                                                                                                                                                                                                                                                               
                         sme_apprnew.SME_Department__c = String.valueOf(deptname);
                         if(String.valueOf(deptname).equalsIgnoreCase(UtilConstants.SBC_DEPT))
                         {
                            sme_apprnew.Status__c = UtilConstants.APPROVED;
                            Date weekStart = System.Today().toStartofWeek();
                            Integer daydifference = weekStart.daysBetween(System.Today());                                                        
                            if( daydifference < 4)
                            {    
                                sme_apprnew.Production_Date__c = Date.valueOf(System.Today()).addDays(9);                          
                            }
                            else 
                            {
                                sme_apprnew.Production_Date__c = Date.valueOf(System.Today()).addDays(11);    
                            }   
                         } 
                     }                                                                                                               
                 }
                 if(String.valueOf(deptname).equalsIgnoreCase(UtilConstants.IHM) && !existingSMEAPDepartments.Contains(UtilConstants.IHMM)) 
                 {                             
                     sme_apprnew.SME_Department__c =  UtilConstants.IHMM;                        
                 }
                 if(!String.isBlank(productEffectiveDate) && !String.valueOf(deptname).equalsIgnoreCase(UtilConstants.SBC_DEPT))
                 {
                     if (implementationType.equals(UtilConstants.NEW_BUSINESS) || implementationType.equals(UtilConstants.RENEWAL)) 
                     {                                  
                            sme_apprnew.Production_Date__c = Date.valueOf(productEffectiveDate);                    
                     }                                      
                 }
                 sme_apprnew.AccountRecordTypeSMEAppr__c = currentOrder.Account.RecordType.DeveloperName;
                 sme_apprnew.Implementation_Record_ID__c = contextId;
                 sme_approvalList.add(sme_apprnew);                 
              }              
             
              if (sme_approvalList.size() >0)
              {
                  Savepoint sp = Database.setSavepoint();
                  try
                  {                      
                      Database.insert(sme_approvalList,false);
                      Database.update(currentOrder,false);                                   
                  }
                  catch(Exception excp)
                  {                                         
                       UTIL_LoggingService.logHandledException(excp, UtilConstants.ORGID, UtilConstants.APPNAME, 
                                                       CLASS_NAME, UtilConstants.CANCEL,TEST_CLASS,LoggingLevel.ERROR); 
                      outMap.put(UtilConstants.ERROR, excp.getMessage());
                      Database.rollback(sp);                        
                  }
              }    
        }  
    } 
}