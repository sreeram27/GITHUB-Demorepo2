/*
 * @description : This needs to be merged to CMIntegration Service class
 * Using without sharing keyword because API user profile may not have access for all objects/fields/rules.
 * Hence we need to run all our jobs/processes in system context to make sure data is brought down for all object/fields values.
 * **/
public class CMPartialJSONRequest {
    static final Boolean TRUE_CONST = True;
    static final String SPIDER_CONST = 'Spider Network Id';
    static final String METALLEVEL_CONST = 'Metal Level Code';
    static final String EXCHANGEIND_CONST = 'Exchange Indicator';
    static final String LEGALENT_CONST = 'Legal Entity';
    static final String CDHP_CONST = 'CDHP Product Type';
    static final String BILLING_CONST = 'Billing';
    static final String MAILING_CONST = 'Mailing';
    static final String GENERALAGENT_CONST ='General Agent';
    static final String ANY_CONST ='Any';
    static final String NAVITUS_CONST = 'Navitus';
    static final String MEDICAL_CONST = 'Medical';
    static final String DENTAL_CONST = 'Dental';
    static final String VISION_CONST = 'Vision';
    
    public static void buildProductsCustInfo(CMIntegrationRequest jsonCMPayload, Account acc, Order od, Group__c grp,
                                                                               List<ServiceProviderRelationship__c> sprList,
                                                                               List<Eligibility__c> eliList, List<Account_Preferences__c> grpPrefList){
        
        CMIntegrationRequest.cls_accountInfo accountInfo = jsonCMPayload.accountInfo;
         
        List<CMIntegrationRequest.cls_customers> customers = accountInfo.customerInfo.customers;
        CMIntegrationRequest.cls_customers customer = customers[0];                                                                           
                                                                                   
        List<CMIntegrationRequest.cls_products> productsList;
        Map<String, List<Group_Plan_Design__c>> qliGrpPlanDesignMap = new Map<String, List<Group_Plan_Design__c>>();
        Map<String, List<QuoteLineItemRates__c>> qliratesMap = new Map<String, List<QuoteLineItemRates__c>>();
        Set<Id> productIdSet = new Set<Id>();
        //Put product Id and respective attribute value in the maps from attribute assignment object 
        Map<String, String> spiderNetworkMap = new Map<String, String>();
        Map<String, String> metalLevelMap = new Map<String, String>();
        Map<String, String> exchangeIndMap = new Map<String, String>();
        Map<String, String> legalEntityMap = new Map<String, String>();
        Map<String, String> cdhpProductMap = new Map<String, String>();
        Set<String> fundingSet = new Set<String>();                                                                            
        
        //Get all active groups related to the Account 
        List<Group__c> grps = [Select Id, Name
                               FROM Group__c 
                               WHERE Account__c =: acc.Id 
                               AND IsActive__c =: TRUE_CONST
                               LIMIT 100]; 
        
        //Get all group plan design records related to above groups
        List<Group_Plan_Design__c> grpPlanDesignsList = [Select Id,  Group__c, Employee_Class_Name__c, Employee_category__c, 
                                                         QuoteLineItem_Record_ID__c, Group_Suffix_Effective_Date__c, Sequence_Number__c, 
                                                         Group_Suffix_Cancel_Date__c, Assigned_Prefix_APN__c, Group_Plan_Description__c
                                                         FROM Group_Plan_Design__c 
                                                         WHERE Is_Active_Indicator__c = true
                                                         //AND Implementation_Case__c = :od.id
                                                         AND Group__c IN :grps
                                                         LIMIT 5000];
        if(grpPlanDesignsList.size() >0){
            for(Group_Plan_Design__c grpPlan: grpPlanDesignsList){
                if(!qliGrpPlanDesignMap.containsKey(grpPlan.QuoteLineItem_Record_ID__c)){
                    qliGrpPlanDesignMap.put(grpPlan.QuoteLineItem_Record_ID__c, new List<Group_Plan_Design__c>{grpPlan});
                }
                else{
                    List<Group_Plan_Design__c> grpPlansList = qliGrpPlanDesignMap.get(grpPlan.QuoteLineItem_Record_ID__c);
                    grpPlansList.add(grpPlan);
                    qliGrpPlanDesignMap.put(grpPlan.QuoteLineItem_Record_ID__c,grpPlansList );
                }
            }
        }
        //Get all quote line items related to group plan designs 
        List<QuoteLineItem> qliList = [Select Id, Product_Family_Local__c, vlocity_ins__ContractCode__c, Contract_Codes__c, Product2.Id, Quote.OpportunityId,
                                       product2.Product_Type__c, Product2.Network__c, Product_Type__c, ProductName__c, Market__c, Funding__c, Financing__c,
                                       Benefit_Period__c, EffectiveDate__c, TermDate__c, HSABankingPartner__c, HPCC_Code__c, Product2.HPCC_Code__c, Network__c,
                                       Employee_Assistance_Program__c, Quote.OAD_Auto_Delete__c, Add_Reason_Code__c, Claims_Route_Code__c, Alphanumeric_Prefix_Network__r.Assigned_Prefix__c,
                                       Quote.Duplicate_Supplemental_Coverage_Allowed__c, Quote.WGSCompanySizeCode__c, Reason__c, Vision_Exam_Copay__c,
                                       Vision_Lens_Copay__c, EyeMed_Benefit_Plan_Code__c, EyeMed_Benefit_Level_1__c, Who_Pays_Bank_Fee__c, Rate_Structure__c,
                                       ID_Card_Design__c, Claims_Grace_Days__c, EyeMed_Benefit_Level_2__c, EyeMed_Benefit_Level_3__c, EyeMed_Benefit_Level_4__c,
                                       Vision_Adult_CoMingle__c, Vision_Child_CoMingle__c, Pharmacy_Benefit_Identifier__c
                                       FROM QuoteLineItem 
                                       WHERE Id IN : qliGrpPlanDesignMap.keySet()
                                       LIMIT 5000];
                                       
        //Get all product2 Ids for the qli list  -- Used in Attribute assignment query  
          if(qliList.size()>0){
              for(QuoteLineItem qli: qliList){
                  productIdSet.add(qli.Product2.Id);
              }
          }
          
         //To-DO get below attributes from attribute assignment object
         //select all the records from attribute assignment object where vlocity_ins__ObjectId__c = qli.product2.id and vlocity_ins__AttributeName__c
         //in ('Spider Network Id','Metal Level Code','Exchange Indicator','Legan Entity','CDHP Product Type')
         // map vlocity_ins__Value__c field on product record  
         Set<String> attributeNamesSet = new Set<String>();
         attributeNamesSet.add(SPIDER_CONST);  
         attributeNamesSet.add(METALLEVEL_CONST);
         attributeNamesSet.add(EXCHANGEIND_CONST);  
         attributeNamesSet.add(LEGALENT_CONST);  
         attributeNamesSet.add(CDHP_CONST);  
                                                                                   
       List<vlocity_ins__AttributeAssignment__c> attributeAssgnmntList =[Select Id, vlocity_ins__CategoryName__c, vlocity_ins__CategoryCode__c, vlocity_ins__ObjectId__c,
                                                                         vlocity_ins__AttributeName__c, vlocity_ins__Value__c
                                                                         FROM vlocity_ins__AttributeAssignment__c
                                                                         WHERE vlocity_ins__ObjectId__c IN: productIdSet
                                                                         AND vlocity_ins__AttributeName__c IN: attributeNamesSet
                                                                         LIMIT 5000];
        System.debug('Attribute Assignment list size : '+attributeAssgnmntList.size());
        
        //separate all products and it's related attribute types 
        if(attributeAssgnmntList.size()>0){
           for(vlocity_ins__AttributeAssignment__c attrb: attributeAssgnmntList){
               if(attrb.vlocity_ins__AttributeName__c == SPIDER_CONST){
                   spiderNetworkMap.put(attrb.vlocity_ins__ObjectId__c, attrb.vlocity_ins__Value__c);
               }else if(attrb.vlocity_ins__AttributeName__c == METALLEVEL_CONST){
                   metalLevelMap.put(attrb.vlocity_ins__ObjectId__c, attrb.vlocity_ins__Value__c);
               }else if(attrb.vlocity_ins__AttributeName__c == EXCHANGEIND_CONST){
                   exchangeIndMap.put(attrb.vlocity_ins__ObjectId__c, attrb.vlocity_ins__Value__c);
               }else if(attrb.vlocity_ins__AttributeName__c == LEGALENT_CONST){
                   legalEntityMap.put(attrb.vlocity_ins__ObjectId__c, attrb.vlocity_ins__Value__c);
               }else if(attrb.vlocity_ins__AttributeName__c == CDHP_CONST){
                   cdhpProductMap.put(attrb.vlocity_ins__ObjectId__c, attrb.vlocity_ins__Value__c);
               }
           } 
        }
        
        //Get all QLI rates related to QLIs from group plan design
        List<QuoteLineItemRates__c> qliRatesList = [Select Id, Rate_Id__c, QuoteLineItem__c
                                                    FROM QuoteLineItemRates__c
                                                    WHERE QuoteLineItem__c IN :qliGrpPlanDesignMap.keySet()
                                                    LIMIT 5000];
        
        if(qliRatesList.size()>0){
            for(QuoteLineItemRates__c qliRate : qliRatesList){
                if(!qliratesMap.containsKey(qliRate.QuoteLineItem__c)){
                    qliratesMap.put(qliRate.QuoteLineItem__c, new List<QuoteLineItemRates__c>{qliRate});
                }
                else{
                    List<QuoteLineItemRates__c> qliRateList = qliratesMap.get(qliRate.QuoteLineItem__c);
                    qliRateList.add(qliRate);
                    qliratesMap.put(qliRate.QuoteLineItem__c, qliRateList);
                }
            }
        }
        System.debug('Rates Map Size: '+ qliratesMap.size());
      
        if(qliList.size()>0){
            productsList = new List<CMIntegrationRequest.cls_products>();
            for(QuoteLineItem qli: qliList){
                CMIntegrationRequest.cls_products clsProd = new CMIntegrationRequest.cls_products();
                // clsProd.productId = ;
                clsProd.networkType 					= qli.Product_Family_Local__c;
                clsProd.contractCode 		   			= qli.vlocity_ins__ContractCode__c != null? qli.vlocity_ins__ContractCode__c : qli.Contract_Codes__c; //To confirm
                clsProd.networkName 					= qli.Product2.Network__c; 
                clsProd.type  							= qli.Product_Type__c;
                clsProd.name  							= qli.ProductName__c;
                clsProd.stateCode 						= qli.Market__c;  
                clsProd.fundingType 					= qli.Funding__c;
                clsProd.financingOption 				= qli.Financing__c;
   
                // clsProd.benefitYearOrCalendarYearCode 	= qli.Benefit_Period__c; //Should we populate BY or Benefit year??
                clsProd.effectiveDate 					= String.valueOf(qli.EffectiveDate__c); 
                clsProd.healthPlanContractCode          = qli.HPCC_Code__c!= null ? qli.HPCC_Code__c : qli.Product2.HPCC_Code__c;
                // clsProd.expirationDate					= String.valueOf(qli.TermDate__c);
                
                clsProd.networkId                       = spiderNetworkMap.get(qli.Product2.Id);
               // clsProd.legalEntityDescription          = legalEntityMap.get(qli.Product2.Id); //To confirm??
                clsProd.metalLevel                      = metalLevelMap.get(qli.Product2.Id);
                clsProd.exchangeIndicator               = exchangeIndMap.get(qli.Product2.Id);
                clsProd.workLocation					= acc.Work_location__c;
                clsProd.consumerDrivenHealthPlanProductType = cdhpProductMap.get(qli.Product2.Id);
                
                clsProd.productClasses 		= buildProductClasses(qli, qliGrpPlanDesignMap);
                clsProd.rates 		  	 	= buildRates(qli, qliratesMap);
                
                CMIntegrationRequest.cls_productQuestion prodQuestion = new CMIntegrationRequest.cls_productQuestion();
                prodQuestion.sizeBand = Integer.valueOf(acc.Eligible_Employees__c);
                prodQuestion.hsaHraBankingType = ServiceIntegrationMappingUtility.getExternalSystemValue('CM Integration', 'HSA Banking Partner',qli.HSABankingPartner__c);//qli.HSABankingPartner__c;
                clsProd.productQuestion = prodQuestion;
                
                //To confirm ??? -- if this section should be populated only if Product_Type == 'Vision'
                CMIntegrationRequest.cls_vision vision = new CMIntegrationRequest.cls_vision();
                CMIntegrationRequest.cls_coPay coPay = new CMIntegrationRequest.cls_coPay();
                vision.coPay 			= coPay;
                coPay.examCopay 		= qli.Vision_Exam_Copay__c;
                coPay.lensCopay 		= qli.Vision_Lens_Copay__c;
                CMIntegrationRequest.cls_benefitLevel benefitLevel = new CMIntegrationRequest.cls_benefitLevel();
                vision.benefitLevel     = benefitLevel;
                benefitLevel.eyeMedPlanCode   = qli.EyeMed_Benefit_Plan_Code__c;
                benefitLevel.benefitLevel1 	= qli.EyeMed_Benefit_Level_1__c;
                benefitLevel.benefitLevel2  = qli.EyeMed_Benefit_Level_2__c;
                benefitLevel.benefitLevel3  = qli.EyeMed_Benefit_Level_3__c;
                benefitLevel.benefitLevel4  = qli.EyeMed_Benefit_Level_4__c;
                benefitLevel.adultCoMingle  = qli.Vision_Adult_CoMingle__c ? 'Y' : 'N';
                benefitLevel.childCoMingle  = qli.Vision_Child_CoMingle__c ? 'Y' : 'N';
                clsProd.vision = vision;
                
                CMIntegrationRequest.cls_proxy proxy = new CMIntegrationRequest.cls_proxy();
                proxy.id    				= qli.Pharmacy_Benefit_Identifier__c;
                clsProd.proxy 				= proxy;
                
				buildProductConfig(clsProd, qli, acc, od, sprList, eliList, grpPrefList);
                
                fundingSet.add(qli.Funding__c);
                
                productsList.add(clsProd);
            }
            System.debug('Products List Size: '+productsList.size());
        }
        customer.products = productsList; 
                                                                                   
        String fundingRollup; 
        List<String> fundingCodes = new List<String>{'FI', 'ASO','ASO/FI'};            
        List<String> fundingList = new List<String>(fundingSet);
        fundingList.sort();
                                                                                   
            if(fundingList.size() == 1 && fundingCodes.contains(fundingList[0])){
                fundingRollup = fundingList[0];
            } else if (fundingList.size() > 1 && fundingList.contains('ASO/FI')){
                fundingRollup = 'ASO/FI';
            } else if(fundingList.size() > 1){
                for(String s : fundingList){
                    if(fundingCodes.contains(s) && s != 'ASO/FI'){
                       fundingRollup = fundingRollup == null ? s : fundingRollup+'/'+s;
                    } 
                }
            }
           CMIntegrationRequest.cls_masterBusinessUnit masterBusinessUnit = accountInfo.parentInfo.parentConfig.masterBusinessUnit;
           masterBusinessUnit.fundingType =  String.isNotBlank(fundingRollup) ? fundingRollup : null;                                                                          
          System.debug('Funding Rollup : ' + fundingRollup);                                                                         
                                                                                   
        //return productsList;
    }
    
    //////////// Added by Harry from here
    public static void buildProductConfig(CMIntegrationRequest.cls_products clsProd, 
                                          QuoteLineItem qli, Account acc, Order od,
                                          List<ServiceProviderRelationship__c> sprList,
                                          List<Eligibility__c> eliList, List<Account_Preferences__c> grpPrefList
                                         ) {
        // productConfig section
        CMIntegrationRequest.cls_productConfig productConfig = new CMIntegrationRequest.cls_productConfig();
        clsProd.productConfig = productConfig;
        
        // productBilling
        CMIntegrationRequest.cls_productBilling productBilling = new CMIntegrationRequest.cls_productBilling();
        productConfig.productBilling = productBilling;
       // productBilling.prorateRule = 'D';
        
        // benefitYearOrCalendarYear
        CMIntegrationRequest.cls_benefitYearOrCalendarYear benefitYearOrCalendarYear = new CMIntegrationRequest.cls_benefitYearOrCalendarYear();
        productConfig.benefitYearOrCalendarYear = benefitYearOrCalendarYear;
        benefitYearOrCalendarYear.code = qli.Benefit_Period__c;
        benefitYearOrCalendarYear.asofDate = qli.EffectiveDate__c != null ? String.valueOf(qli.EffectiveDate__c) : '';
        
   /*    List<Enrollment_and_Billing__c> membershipList = [Select Id, Ongoing_Enrollment_Submission_Type__c
                                                          FROM Enrollment_and_Billing__c
                                              			  WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c =: od.Id];  */                                    
        
        // productConfigurationIndicator
        CMIntegrationRequest.cls_productConfigurationIndicator productConfigurationIndicator = new CMIntegrationRequest.cls_productConfigurationIndicator();
        productConfig.productConfigurationIndicator = productConfigurationIndicator;
        
        productConfigurationIndicator.groupTapeEnrollment = od.Ongoing_Enrollment_Submission_Type__c; //membershipList.size()>0 ? membershipList[0].Ongoing_Enrollment_Submission_Type__c : '';  // Membership object?? 
        //productConfigurationIndicator.etIndicator = '';
        //productConfigurationIndicator.mhsOptOutIndicator = '';
		if (eliList!= null && eliList.size() > 0) {                                        
        	productConfigurationIndicator.mhSaSvcLevelIndicator =  eliList[0].MHSA_Service_Level_Indicator__c;
        	productConfigurationIndicator.domesticPartnerIndicator = eliList[0].Domestic_Partner_Indicator__c;
        }
        
        //If Network__c="Alt Net", populate "Y", else populate "N"
        productConfigurationIndicator.alternateNetworkIndicator = qli.Network__c == 'Alt Net' ? 'Y' : 'N';
       // productConfigurationIndicator.privateExchangeIndicator = '';
        productConfigurationIndicator.employeeAssistanceProgram = qli.Employee_Assistance_Program__c ? 'Y' : 'N';
        
        // eligibility
        if (eliList!= null && eliList.size() > 0) {
        	Eligibility__c eli = eliList[0];
        
            CMIntegrationRequest.cls_eligibility eligibility = new CMIntegrationRequest.cls_eligibility();
            productConfig.eligibility = eligibility;
            eligibility.employerSubscriberPercent = String.valueOf(eli.Prem_Paid_for_Each_Sub_per_Month__c);
            eligibility.employerDependentPercent = String.valueOf(eli.Prem_Paid_for_Each_Sub_Dep_per_Month__c);
            eligibility.newHiresCode = '1';
            eligibility.probationPeriodCode = acc.ProbationaryPeriod__c; //eli.New_Hire_Probationary_Period__c;
            eligibility.deleteDependentCode = eli.Delete_Dependent_Code__c;
            eligibility.overSixtyFiveCode = eli.Over_65_Code__c;
            eligibility.openEnrollmentCode = od.Open_Enrollment_Date__c == null ? null : String.valueOf(od.Open_Enrollment_Date__c.month());
            eligibility.companySizeCategoryCode = Integer.valueOf(acc.Eligible_Employees__c);
            eligibility.duplicateCoverageSupplemental = qli.Quote.Duplicate_Supplemental_Coverage_Allowed__c;
            eligibility.vendorReferral = acc.Vendor_Referral__c;
            
            // When the product2 product_type=Vision, Dental, Life, or Disability, 
            // the Benefit_period__c field will be blank. If the field is blank, pass “Calendar Year”?? how to map, there can be multiple qli
            eligibility.calendarOrBenefitYearCode = qli.Benefit_Period__c;
            
            eligibility.domesticPartnerCode = eli.Domestic_Partner_Indicator__c;
            eligibility.overageMailing = eli.Overage_dep_term_Itrs_be_mailed_to_sub__c;
            eligibility.oadAutoDelete = qli.Quote.OAD_Auto_Delete__c;                
            
            eligibility.addReasonCode = qli.Add_Reason_Code__c;
            eligibility.employeeExcludedCode = ServiceIntegrationMappingUtility.getExternalSystemValue(CMIntegrationConstants.INTEGRATION_NAME, 'Employee Ex code',eli.Employee_Excluded_Code__c);
           // eligibility.eocIndicator = acc.EOC_Paperless_Option_Indicator__c;  
            eligibility.washoutCode = grpPrefList!=null && grpPrefList.size()>0 ? grpPrefList[0].Washout_Code__c : null;
        }
        
        // productVendorSegment
        CMIntegrationRequest.cls_productVendorSegment productVendorSegment = new CMIntegrationRequest.cls_productVendorSegment();
        productConfig.productVendorSegment = productVendorSegment;
        // productVendorSegment.wageWorks = '';
        // If the Account has a Service Provider Relationship record, where the field Vendor__c=Navitus, populate "Y", else "N". 
        productVendorSegment.navitusFeed = 'N';
                                             
        for(ServiceProviderRelationship__c spr : sprList) {
            if (spr.VendorName__c == NAVITUS_CONST) {
                productVendorSegment.navitusFeed = 'Y';
                break;
            }
        }

		// productSegmentIndicator
        CMIntegrationRequest.cls_productSegmentIndicator productSegmentIndicator = new CMIntegrationRequest.cls_productSegmentIndicator();
        productConfig.productSegmentIndicator = productSegmentIndicator;
 
        if (grpPrefList != null && grpPrefList.size() > 0) {
            Account_Preferences__c grpPref = grpPrefList[0];
            productSegmentIndicator.liveHealthOnline = grpPref.Opt_Out_of_LHO_URL_on_ID_Cards__c; // not confirmed
            productSegmentIndicator.asoNewbornOptOut = grpPref.ASO_Newborn_Opt_Out_Indicator__c;
    
            CMIntegrationRequest.cls_letterSuppression letterSuppression = new CMIntegrationRequest.cls_letterSuppression();
            productSegmentIndicator.letterSuppression = letterSuppression;
            
            letterSuppression.delinquencyCancellationLetter = grpPref.Delinquency_Cancellation_Letter_Suppress__c;
            letterSuppression.certificateOfCreditableCoverage = grpPref.Certificate_of_creditable_coverage_suppr__c;
            letterSuppression.conversionLetter = grpPref.Conversion_letter_suppression__c;
            letterSuppression.terminationLetter = grpPref.Termination_letter_suppression__c;
    
        }
		    
        productSegmentIndicator.womensContraceptive = (eliList!=null && eliList.size()> 0)?eliList[0].Women_s_Contraceptive_Exemption_Ind__c:''; // To add from eligibility 
        productSegmentIndicator.healthSpendingAccountBankFeeIndicator = qli.Who_Pays_Bank_Fee__c; 
    
        // councilOfAffordableQualityHealthPlanCoordinationOfBenefitsIndicator not confirmed*/
        //idCards
        CMIntegrationRequest.cls_idCard idCard = new CMIntegrationRequest.cls_idCard();
        productConfig.idCard = idCard;
        idCard.idDistributionInitialIndicator = od.ID_Cards_Sent_To__c; // Add field to Order query
        idCard.idDistributionOngoing = od.Maintenance_Cards_Sent_To__c;
        idCard.idDesignCode = qli.ID_Card_Design__c;                                      
            
        //exempt
      /*  CMIntegrationRequest.cls_exempt exempt = new  CMIntegrationRequest.cls_exempt();
        productConfig.exempt = exempt;
        exempt.typeEffectiveDate = od.Maintenance_Cards_Sent_To__c;      */                               
        
        //process                                                                                                              
        CMIntegrationRequest.cls_process process = new CMIntegrationRequest.cls_process();
        productConfig.process = process;                                     
        process.groupProcessCode = (qli.Product_Type__c == MEDICAL_CONST || qli.Product_Type__c == VISION_CONST) ? '00' :
                                        qli.Product_Type__c ==DENTAL_CONST ? '12': null;  
        process.groupTapeEnrollment = od.Ongoing_Enrollment_Submission_Type__c; //membershipList.size()>0 ? membershipList[0].Ongoing_Enrollment_Submission_Type__c : ''; //To confirm??
       
       //miscellaneous
       CMIntegrationRequest.cls_miscellaneous miscellaneous = new CMIntegrationRequest.cls_miscellaneous();
       productConfig.miscellaneous = miscellaneous;
       miscellaneous.rateType = 'AH'; //qli.Rate_Structure__c;                                      
                                             
        // cancel
        /*CMIntegrationRequest.cls_cancel cancel = new CMIntegrationRequest.cls_cancel();
        productConfig.cancel = cancel;
        cancel.cancelReason = qli.Reason__c;
        */
        // claim
        CMIntegrationRequest.cls_claim claim = new CMIntegrationRequest.cls_claim();
        productConfig.claim = claim;
        claim.route = qli.Claims_Route_Code__c;
       // claim.graceDays = ''; // TODO to be confirmed
        claim.claimGraceDays = qli.Claims_Grace_Days__c; // TODO to be confirmed
        
        // itsHome
        CMIntegrationRequest.cls_itsHome itsHome = new CMIntegrationRequest.cls_itsHome();
        productConfig.itsHome = itsHome;
        itsHome.itsPrefix = qli.Alphanumeric_Prefix_Network__r.Assigned_Prefix__c;
        
    }
    //////////// Added by Harry until here
        
    public static List<CMIntegrationRequest.cls_productClasses> buildProductClasses(QuoteLineItem qli, 
                                                                                    Map<String, List<Group_Plan_Design__c>> qliGrpPlanDesignMap){
        List<CMIntegrationRequest.cls_productClasses> productClasses ;
        
        if(qliGrpPlanDesignMap!= null && qliGrpPlanDesignMap.size()>0 && qliGrpPlanDesignMap.containsKey(qli.Id)){
               productClasses = new List<CMIntegrationRequest.cls_productClasses>();
            for(Group_Plan_Design__c grpPlanDsgn:qliGrpPlanDesignMap.get(qli.Id)){
                CMIntegrationRequest.cls_productClasses productClass = new CMIntegrationRequest.cls_productClasses();
                productClass.sequenceNumber 			= String.valueOf(grpPlanDsgn.Sequence_Number__c);
                productClass.referenceId				= grpPlanDsgn.Id;
                productClass.employmentCategoryCode 	= grpPlanDsgn.Employee_category__c; //Status__c; //To confirm
                productClass.employmentClass 			= grpPlanDsgn.Employee_Class_Name__c;
                productClass.requestedName   			= grpPlanDsgn.Group_Plan_Description__c;
                productClass.effectiveDate 				= String.valueOf(grpPlanDsgn.Group_Suffix_Effective_date__c);
                productClass.expirationDate				= String.valueOf(grpPlanDsgn.Group_Suffix_Cancel_Date__c);
                
                productClasses.add(productClass);
            }
        }
        return productClasses;
    }
    
    public static List<CMIntegrationRequest.cls_rates> buildRates(QuoteLineItem qli, Map<String, List<QuoteLineItemRates__c>> qliratesMap){
        List<CMIntegrationRequest.cls_rates> clsRates;
        
        if(qliratesMap.size()>0 && qliratesMap.containsKey(qli.Id)){
            clsRates = new List<CMIntegrationRequest.cls_rates>();
            for(QuoteLineItemRates__c qliRate:qliratesMap.get(qli.Id)){
                CMIntegrationRequest.cls_rates clsRate = new CMIntegrationRequest.cls_rates();
                clsRate.id 			  = qliRate.Rate_Id__c;
                clsRate.opportunityID = qli.Quote.OpportunityId;
                clsRates.add(clsRate);
            }
        }
        
        return clsRates;
    }
    
    public static CMIntegrationRequest.cls_broker buildBrokerCustomerInfo(String accId, Order od){
        
        CMIntegrationRequest.cls_broker broker;
         Map<String, Broker_Consultant_Commissions1__c> brokerCommissionMap  = new Map<String, Broker_Consultant_Commissions1__c>();
      /*  Map<String, Brokerage_and_Consultant1__c> brokerConsultantMap	 	= new Map<String, Brokerage_and_Consultant1__c>();
        Map<Contact, ContactRelationship__c> consultantContactMap 	  		= new  Map<Contact, ContactRelationship__c>(); */
       
        
        //Get all Broker and consultants related to given Account Id -- Confirm the object name
        //To-DO  take the opportunity associated to implementation case
        List<Brokerage_and_Consultant1__c> brokerConsultantsList = [Select Id, Account__c, Brokerage__c, Brokerage__r.Name, Consultant__c, Tax_ID__c, Broker_Tax_ID__c, Broker_Role__c,
                                                                    Line_of_Business__c, Brokerage_Effective_Date__c, Consultant__r.Contact__c, 
                                                                    Consultant__r.Contact__r.FirstName, Consultant__r.Contact__r.LastName,
                                                          		    Consultant__r.Contact__r.vlocity_ins__MiddleName__c, Consultant__r.Contact_Type__c, Consultant__r.Contact__r.Phone,
                                                           		    Consultant__r.Contact__r.Email, Consultant__r.Contact__r.MailingStreet, Consultant__r.Contact__r.MailingCity,
                                                           		    Consultant__r.Contact__r.MailingState,Consultant__r.Contact__r.MailingCountry, Consultant__r.Contact__r.MailingPostalCode 
                                                                    from Brokerage_and_Consultant1__c
                                                                    WHERE Opportunity__c =: od.OpportunityId 
                                                                    AND (Brokerage_of_Record__c =: TRUE_CONST
                                                                         OR Consultant_of_Record__c =: TRUE_CONST
                                                                         OR Broker_Role__c =: GENERALAGENT_CONST)
                                                                    LIMIT 5000];
        
         //Get all Broker and Commission records related to Brokerage and consultants
        List<Broker_Consultant_Commissions1__c> brokerCommissionList = [Select Id, BrokerageAndConsultant__c, Commission_Percentage__c, Commission_Start_Date__c,
                                                                        Contact_Relationship__c, Line_of_Business__c, BrokerageAndConsultant__r.Consultant__c, Brokerage_Commission_Split__c 
                                                                        FROM Broker_Consultant_Commissions1__c
                                                                        WHERE BrokerageAndConsultant__c IN: brokerConsultantsList];
                                                                        /*AND Contact_Relationship__c IN: brokerContactsList*/
        //Populate the map to get Consultant LOB commission related values
        if(brokerCommissionList.size()>0){
            for(Broker_Consultant_Commissions1__c com: brokerCommissionList){
                brokerCommissionMap.put(com.BrokerageAndConsultant__r.Consultant__c+com.Line_of_Business__c, com);
                System.debug('Commission map key:'+ com.BrokerageAndConsultant__r.Consultant__c+com.Line_of_Business__c);
            }
        }
        
       System.debug('Commission list size: '+ brokerCommissionList.size());
        
        //Create one broker record for each Broker and Consultant1 record in the list 
        if(brokerConsultantsList.size()>0){
             broker 						= new CMIntegrationRequest.cls_broker();
             broker.agents				    = new List<CMIntegrationRequest.cls_agents>();
             
             for(Brokerage_and_Consultant1__c brokerCons: brokerConsultantsList){
                 CMIntegrationRequest.cls_agents agent = new CMIntegrationRequest.cls_agents(); 
                 agent.type							  = brokerCons.Broker_Role__c == GENERALAGENT_CONST ? 'Y' : 'N';
                 agent.generalAgent					  = brokerCons.Broker_Role__c == GENERALAGENT_CONST ? 'Y' : 'N';
                // agent.agentCode 					  = '';
                 agent.agentInformation               = buildAgentInformation(brokerCons.Consultant__r.Contact__r, brokerCons);
                 agent.productPercent                 = buildProductPercent(brokerCons, brokerCommissionMap);
                 
                 agent.writingAgent                         = new CMIntegrationRequest.cls_writingAgent();
                 agent.writingAgent.TaxIdentificationNumber = brokerCons.Broker_Tax_ID__c!= null? brokerCons.Broker_Tax_ID__c: null;
                 agent.parentTax                            = new CMIntegrationRequest.cls_parentTax();
                 agent.parentTax.IdentificationNumber       = brokerCons.Tax_ID__c != null? brokerCons.Tax_ID__c : null;
            
                 broker.agents.add(agent);
             }
        }
         
        return broker;
           //Get all consultant ids from above list
   /*     for(Brokerage_and_Consultant1__c brokerCons: brokerConsultantsList){
            if(brokerCons.Consultant__c !=null){
                brokerConsultantMap.put(brokerCons.Consultant__c, brokerCons); 
            }
        }
        
        List<ContactRelationship__c> brokerContactsList = [Select Id, Contact__c, Contact__r.FirstName, Contact__r.LastName,
                                                           Contact__r.vlocity_ins__MiddleName__c, Contact_Type__c, Contact__r.Phone,
                                                           Contact__r.Email, Contact__r.MailingStreet, Contact__r.MailingCity, Contact__r.MailingState,
                                                           Contact__r.MailingCountry, Contact__r.MailingPostalCode
                                                           FROM ContactRelationship__c
                                                           WHERE Id IN : brokerConsultantMap.keySet()
                                                           LIMIT 1000];
        if(brokerContactsList.size()>0){
            for(ContactRelationship__c contRelatn:brokerContactsList){
                if(contRelatn.Contact__c!=null){
                    consultantContactMap.put(contRelatn.Contact__r, contRelatn);
                }
            }
        } */
      /*   //Assuming there is only one contact relationship record for each contact -- else change this to contact map
        if(consultantContactMap.size()>0){
           broker 						= new CMIntegrationRequest.cls_broker();
           broker.agents				= new List<CMIntegrationRequest.cls_agents>();
            
            for(Contact con: consultantContactMap.keySet()){
                CMIntegrationRequest.cls_agents agent = new CMIntegrationRequest.cls_agents(); 
                agent.type							  = '';
                agent.generalAgent					  = 'Y';
                agent.agentCode 					  = '';
                agent.agentInformation 				  = buildAgentInformation(con, brokerConsultantMap, consultantContactMap);
                agent.productPercent                  = buildProductPercent(con, brokerConsultantMap, consultantContactMap, brokerCommissionMap);
                
                broker.agents.add(agent);
            }            
        }  */
        
    }
    
    //Build agent information based on the Consultant record on BrokerConsultant1 record
    public static CMIntegrationRequest.cls_agentInformation buildAgentInformation(Contact con, Brokerage_and_Consultant1__c brokerConsultant){
        CMIntegrationRequest.cls_agentInformation agentInformation;
        if(con!=null){
        agentInformation  = new CMIntegrationRequest.cls_agentInformation();
      /*  agentInformation.agentName 				= new CMIntegrationRequest.cls_agentName ();
        agentInformation.agentName.lastName 	= con.LastName;
        agentInformation.agentName.firstName	= con.FirstName;
        agentInformation.agentName.MiddleName 	= con.vlocity_ins__MiddleName__c; */
        
        agentInformation.brokerAgencyName 		= brokerConsultant.Brokerage__r.Name;
      //  agentInformation.contactType 			= brokerConsultant.Consultant__r.Contact_Type__c;
        String conPhone = con.phone != null ? con.phone.replaceAll('[^0-9]', '') : null; 
        agentInformation.phone 					= String.isNotBlank(conPhone) ? conPhone : null;
        agentInformation.email 					= con.Email;
        
        //To confirm the complete address mapping
        CMIntegrationRequest.cls_address  agentAddress = new CMIntegrationRequest.cls_address();
        agentAddress.line1				= con.MailingStreet;
        agentAddress.city 				= con.MailingCity;
        agentAddress.stateCode 			= con.MailingState;
        //agentAddress.countryCode		= con.MailingCountry;// 
        agentAddress.countryName 		= con.MailingCountry;
        agentAddress.useType 			= BILLING_CONST;
        agentAddress.effectiveDtm 		= String.ValueOf(brokerConsultant.Brokerage_Effective_Date__c); // To confirm - consultant effective date?? 
        agentAddress.zipCode 			= con.MailingPostalCode; 
        
        agentInformation.address  		= agentAddress;
        }
        return agentInformation;
    }
    
    //Build productpercent for each consultant and for each line of business 
    public static List<CMIntegrationRequest.cls_productPercent> buildProductPercent(Brokerage_and_Consultant1__c brokerConsultant, Map<String, Broker_Consultant_Commissions1__c> brokerCommissionMap ){
        List<CMIntegrationRequest.cls_productPercent> productPercentList;
        //Get Line of Business multi picklist values for this broker consultant record                                                                                   
        String lineOfBusinessValues = brokerConsultant.Line_of_Business__c;
        
        if(lineOfBusinessValues != null){
            productPercentList = new List<CMIntegrationRequest.cls_productPercent>();
            for(String lob: lineOfBusinessValues.split(';')){
                //Check if that LOB has a related commission record 
                if(brokerCommissionMap.size()>0 && brokerCommissionMap.containsKey(brokerConsultant.Consultant__c+lob)){
                    System.debug('LOB Commissions : '+ lob);
                    CMIntegrationRequest.cls_productPercent productPercentInfo = new CMIntegrationRequest.cls_productPercent();
                    Broker_Consultant_Commissions1__c commissionRec = brokerCommissionMap.get(brokerConsultant.Consultant__c+lob);
                    if(commissionRec.BrokerageAndConsultant__c == brokerConsultant.Id){
                    productPercentInfo.contractCode    =''; //?? 
                    productPercentInfo.productType     = lob; //??
                    productPercentInfo.percent         = Integer.ValueOf(commissionRec.Brokerage_Commission_Split__c);
                    productPercentInfo.effectiveDate   = String.ValueOf(commissionRec.Commission_Start_Date__c); // To confirm - consultant effective date??;
                    productPercentInfo.expirationDate  = ''; 
                    productPercentList.add(productPercentInfo); 
                    }      
                }
            }
            System.Debug('Commissions list : '+productPercentList.size());
        }
        return productPercentList;                                                                            
    }                                                                                                   
    
    //Customer -- CustomerConfig -- representatives section 
    public static List<CMIntegrationRequest.cls_representatives> buildRepresentatives(String accId, Order od, 
                                                                                      List<AccountTeamMember> accTeamList){
        
                
        // Added by Harry 12/11 from here
		// The representative section may be repeated up until 4 times. 
		// Not all 4 roles are required, but if one section is populated, all fields are required. 
		// Use Account Team to populate the sections
		// Allowed values: 
		// Account Service Representative= SR, 
		// Account Manager= AM, 
		// Account Executive= AE, 
		// Specialty Sales Account Rep = SS
		Map<String, String> teamRoleMap = new Map<String, String>();
        teamRoleMap.put(CMIntegrationConstants.TEAMMEMBER_ROLE_ACCOUNT_SERVICE_REPRESENTIVE, 'SR'); // 'Account Service Representative'
        teamRoleMap.put(CMIntegrationConstants.TEAMMEMBER_ROLE_ACCOUNT_MANAGER, 'AM'); // 'Account Manager'
        teamRoleMap.put(CMIntegrationConstants.TEAMMEMBER_ROLE_ACCOUNT_EXECUTIVE, 'AE'); // 'Account Executive'
        teamRoleMap.put(CMIntegrationConstants.TEAMMEMBER_ROLE_SPECIALTY_SALES_ACCOUNT_REP, 'SS'); // 'Specialty Sales Account Rep'
        
        List<CMIntegrationRequest.cls_representatives> representatives = new List<CMIntegrationRequest.cls_representatives>();
        for(AccountTeamMember accTeam : accTeamList) {
            if (!teamRoleMap.keySet().contains(accTeam.TeamMemberRole)) continue;
            
            CMIntegrationRequest.cls_representatives representative = new CMIntegrationRequest.cls_representatives();
            representatives.add(representative);                   
            CMIntegrationRequest.cls_internalSalesRepresentative internalSalesRepresentative = new CMIntegrationRequest.cls_internalSalesRepresentative();
            representative.internalSalesRepresentative = internalSalesRepresentative;
            
            internalSalesRepresentative.salesType = teamRoleMap.get(accTeam.TeamMemberRole);   
	        internalSalesRepresentative.representativeNumber = accTeam.User != null ? accTeam.User.Rep_ID_Code__c : null;

        // end loop for representatives population
        }
        return representatives;
        
        /*
        List<CMIntegrationRequest.cls_representatives> repsList;
        List<Sales_Compensation__c> salesCompnstnList = new List<Sales_Compensation__c>();
        List<Internal_Broker__c> agentRepsList = new List<Internal_Broker__c>();
        
        //Get all opportunities related to account -- Refine the filters to get a single opportunity
        //To-Do  get opporutnity related to implemenation case
        List<Opportunity> oppsList = [Select Id
                                      FROM Opportunity
                                      WHERE Id =: od.OpportunityId];
                                     
        if(oppsList.Size() >0){
            salesCompnstnList = [Select Id, Opportunity__c, Product_Type__c
                                 FROM Sales_Compensation__c
                                 WHERE Opportunity__c IN : oppsList
                                 LIMIT 5000];
        }
        if(salesCompnstnList.size()>0){
            agentRepsList = [Select Id, Type__c, Line_of_Business__c, Effective_Date__c, Split_Percentage__c,
                             Sales_Rep__c, Term_Date__c, Sales_Rep_Full_Name__c, Rep_Num__c, Sales_Rep__r.FirstName,
                             Sales_Rep__r.LastName
                             FROM Internal_Broker__c
                             WHERE Sales_Comp_Master__c IN : salesCompnstnList
                             LIMIT 5000];
        }
        if(agentRepsList.size()>0){
            repsList = new List<CMIntegrationRequest.cls_representatives>();
            for(Internal_Broker__c salesRep: agentRepsList){
                CMIntegrationRequest.cls_representatives rep = new CMIntegrationRequest.cls_representatives();
                rep.internalSalesRepresentative  = buildInternalSalesRep(salesRep);    
                repsList.add(rep);     
            }
            System.debug('RepsList Size: '+ repsList.Size());
        }
        return repsList; */
    }
    /*
    public static CMIntegrationRequest.cls_internalSalesRepresentative buildInternalSalesRep(Internal_Broker__c salesRep){
        

		CMIntegrationRequest.cls_internalSalesRepresentative internalRep = new CMIntegrationRequest.cls_internalSalesRepresentative();
        
        //internalRep.employeeName  		 = salesRep.Sales_Rep_Full_Name__c; 
        internalRep.salesType     		 = salesRep.Type__c;   
        internalRep.representativeNumber = salesRep.Rep_Num__c;
        //internalRep.firstName     		 = salesRep.Sales_Rep__r.FirstName;
        //internalRep.lastName      		 = salesRep.Sales_Rep__r.LastName;
        //internalRep.splitPercent         = String.ValueOf(salesRep.Split_Percentage__c);
        //internalRep.effectiveDate 		 = String.ValueOf(salesRep.Effective_Date__c);
        //internalRep.endDate              = String.ValueOf(salesRep.Term_Date__c);
        return internalRep;
    }*/
    
    //Build AccountBillGroups Section 
    
    public static void buildAccountBillGroups(CMIntegrationRequest jsonCMPayload, String accId, Order od){
        
        List<Invoices_Local__c> invoiceList = [Select Id, Invoice_Description__c, Invoice_Effective_Date__c, Invoice_Cancel_Date__c, Type_of_Bill__c, Cycle_Code__c,
                                               Invoice_Format__c, Billing_Preference__c, Account_Legal_Name__c, Account_Legal_Name__r.Work_location__c, Invoice_Sorting_Option__c, Email__c, Phone__c,  
                                               Sorting_Order_For_Option_1__c, Invoice_Sorting_Option_2__c, Sorting_Order_For_Option_2__c, Billing_Contact__c,
                                               Billing_Contact__r.FirstName, Billing_Contact__r.vlocity_ins__MiddleName__c, Billing_Contact__r.LastName,
                                               Billing_Contact__r.Title, Billing_Contact__r.Phone, Billing_Contact__r.Email, Billing_Contact__r.Department, Billing_Contact__r.Contract_Start_Date__c,
                                               Street_Address__c, City__c, State__c, Zip_Code__c, Billing_Contact__r.MailingCountry, Billing_Contact__r.MailingCity,
                                               Billing_Contact__r.MailingState, Billing_Contact__r.MailingStreet, Billing_Contact__r.MailingPostalCode, CBP_Bill_Group_ID__c, Grace_Days__c
                                               FROM Invoices_Local__c
                                               WHERE Account_Legal_Name__c =: accId
                                               LIMIT 5000];
          System.debug('Invoice list size: '+invoiceList.size());                                     
        
        List<Billing_Arrangement_Local__c> billingArrangementsList = [Select Id, Product_LOB_for_BA__c, Employee_Class_Name_for_BA__c, Employee_Category__c,
                                                                      Contract_Code_for_BA__c, Invoice_Record_ID__c
                                                                      FROM Billing_Arrangement_Local__c
                                                                      WHERE Invoice_Record_ID__c IN : invoiceList
                                                                      LIMIT 5000];
        
        //Build a map with Invoice record Id and all it's related Billing Arrangements 
        Map<String, List<Billing_Arrangement_Local__c>> invoiceBillingArrgmntMap = new Map<String, List<Billing_Arrangement_Local__c>>();
        
        if(billingArrangementsList.size() >0){
            for(Billing_Arrangement_Local__c billArrgnmnt: billingArrangementsList){
                if(!invoiceBillingArrgmntMap.containsKey(billArrgnmnt.Invoice_Record_ID__c)){
                    invoiceBillingArrgmntMap.put(billArrgnmnt.Invoice_Record_ID__c, new List<Billing_Arrangement_Local__c>{billArrgnmnt});
                }
                else{
                    List<Billing_Arrangement_Local__c> billArgmntList = invoiceBillingArrgmntMap.get(billArrgnmnt.Invoice_Record_ID__c);
                    billArgmntList.add(billArrgnmnt);
                    invoiceBillingArrgmntMap.put(billArrgnmnt.Invoice_Record_ID__c,billArgmntList);
                }
            }
        }
            
        //Build one accountBillgroup record for each invoice record
        if(invoiceList.size()>0){    
            CMIntegrationRequest.cls_accountInfo accountInfo = jsonCMPayload.accountInfo;
            
            accountInfo.accountBillGroups = new List<CMIntegrationRequest.cls_accountBillGroups>();
            for(Invoices_Local__c invoice: invoiceList){
                CMIntegrationRequest.cls_accountBillGroups accBillGrp =  new CMIntegrationRequest.cls_accountBillGroups();
                accBillGrp.ids = buildAccountBillGrpIds(invoice);
                accBillGrp.demographic = buildAccBillGrpDemographic(invoice, od);
                accBillGrp.status = buildAccBillGrpStatus(invoice);
                accBillGrp.billConfig = buildBillConfig(invoice, invoiceBillingArrgmntMap.get(invoice.Id));
                accountInfo.accountBillGroups.add(accBillGrp);
            }    
        }
        
    }
    
    public static List<CMIntegrationRequest.cls_ids> buildAccountBillGrpIds(Invoices_Local__c invoice){  
        List<CMIntegrationRequest.cls_ids> idsList = new List<CMIntegrationRequest.cls_ids>();
        CMIntegrationRequest.cls_ids id1 = new CMIntegrationRequest.cls_ids();
        id1.sourceSystem 	= 'SFDCCOM2';
        id1.name 			= 'sfdcBillGroupId';
        id1.value 			= invoice.Id;
        idsList.add(id1);
        
        if(String.isNotBlank(invoice.CBP_Bill_Group_ID__c)){
          CMIntegrationRequest.cls_ids id2 = new CMIntegrationRequest.cls_ids();
            id2.sourceSystem 	= 'CM';
            id2.name 			= 'billGroupId';
            id2.value 			= invoice.CBP_Bill_Group_ID__c;
            idsList.add(id2);  
        }
        return idsList;
    }  
    
    public static CMIntegrationRequest.cls_demographic buildAccBillGrpDemographic(Invoices_Local__c invoice, Order od){
        CMIntegrationRequest.cls_demographic demographic = new CMIntegrationRequest.cls_demographic();
        
        demographic.organizationName 		 = new CMIntegrationRequest.cls_organizationName();
        demographic.organizationName.name 	 = invoice.Invoice_Description__c;
       // demographic.organizationName.dbaName = '';
        if(invoice.Billing_Contact__r != null){
        demographic.contact = buildContact(invoice, od); 
        }
        return demographic;
    }
    
    public static CMIntegrationRequest.cls_contact buildContact(Invoices_Local__c invoice, Order od){
        CMIntegrationRequest.cls_contact contact = new CMIntegrationRequest.cls_contact();
        //Populate Contact section Billing Contact of Invoice record 
        
        contact.persons = buildPersons(invoice.Billing_Contact__r);     
        contact.addresses = buildBillingAddresses(invoice);
        
        //Build Phones section
        contact.phones = new List<CMIntegrationRequest.cls_phones>();
        CMIntegrationRequest.cls_phones phone = new CMIntegrationRequest.cls_phones();
       // phone.id = invoice.Billing_Contact__c;
        phone.useType = BILLING_CONST;
       // phone.type ='Cell';
        String invoicePhone = invoice.Phone__c != null ? invoice.Phone__c.replaceAll('[^0-9]', '') : null;
        phone.value = String.isNotBlank(invoicePhone) ? invoicePhone : null; 
        phone.authorizeTxtFlg ='N'; //To confirm?? 
        //phone.effectiveDtm ='';
        contact.phones.add(phone);
        
        //Build Emails section
        
        contact.emails = new List<CMIntegrationRequest.cls_emails>();
        CMIntegrationRequest.cls_emails email = new CMIntegrationRequest.cls_emails();
      //  email.id = invoice.Billing_Contact__c;
        email.useType = BILLING_CONST;
        email.value = invoice.Email__c;
        email.effectiveDtm = String.valueOf(od.Implementation_Effective_Date__c); //To confirm
        contact.emails.add(email);
        
        return contact;
    }
    public static List<CMIntegrationRequest.cls_persons> buildPersons(Contact con){
        List<CMIntegrationRequest.cls_persons> persons = new List<CMIntegrationRequest.cls_persons>();
        CMIntegrationRequest.cls_persons person = new CMIntegrationRequest.cls_persons();
       // person.id = con.id; // Confirm
        person.referenceId = con.id;
        person.lastName = con.LastName;
        person.firstName = con.FirstName;
        person.middleName = con.vlocity_ins__MiddleName__c;
        List<CMIntegrationRequest.cls_purposes> purposeList = new List<CMIntegrationRequest.cls_purposes>();
        
        CMIntegrationRequest.cls_purposes purpose = new CMIntegrationRequest.cls_purposes();
        purpose.purpose = BILLING_CONST;
        purposeList.add(purpose);
        person.purposes = purposeList;
        person.organization = con.Department;
        person.title = con.Title;
        
        CMIntegrationRequest.cls_addresses addresses = new CMIntegrationRequest.cls_addresses();
        addresses.line1  = con.MailingStreet;
        addresses.city   = con.MailingCity;
        addresses.stateCode = con.MailingState;
        addresses.zipCode = con.MailingPostalCode;
        addresses.countryName = con.MailingCountry;
        person.addresses = addresses;
        
        CMIntegrationRequest.cls_phones phone = new CMIntegrationRequest.cls_phones();
        String conPhone = con.phone != null ? con.phone.replaceAll('[^0-9]', '') : null; 
        phone.value = String.isNotBlank(conPhone) ? conPhone : null;
        person.phones = phone;
        
        CMIntegrationRequest.cls_emails email = new CMIntegrationRequest.cls_emails();
        email.value = con.email;
        person.emails = email;
        
        persons.add(person);
        
        return persons;
    }
    
    public static List<CMIntegrationRequest.cls_addresses> buildBillingAddresses(Invoices_Local__c invoice){
        List<CMIntegrationRequest.cls_addresses> addresses = new List<CMIntegrationRequest.cls_addresses>();
        
        CMIntegrationRequest.cls_addresses billingAddress = new CMIntegrationRequest.cls_addresses();
       // billingAddress.id = invoice.Billing_Contact__c;
        billingAddress.line1 = invoice.Street_Address__c;
        billingAddress.city = invoice.City__c;
        billingAddress.stateCode = invoice.State__c;
        billingAddress.zipCode = invoice.Zip_Code__c;
        billingAddress.countryName = invoice.Billing_Contact__r == null ? '' : invoice.Billing_Contact__r.MailingCountry;
        billingAddress.useType =BILLING_CONST;
       // billingAddress.validationFlag =''; //To confirm
      //  billingAddress.effectiveDtm =''; //To confirm
        addresses.add(billingAddress);
        
        return addresses;
    }
    public static CMIntegrationRequest.cls_status buildAccBillGrpStatus(Invoices_Local__c invoice){
        CMIntegrationRequest.cls_status status = new CMIntegrationRequest.cls_status();
        
        status.timeline 	= new List<CMIntegrationRequest.cls_timeline>();
        CMIntegrationRequest.cls_timeline timeline1 = new CMIntegrationRequest.cls_timeline();
        timeline1.status		= 'A';
        timeline1.effectiveDate = String.valueOf(invoice.Invoice_Effective_Date__c);
       // timeline1.endDate 		= String.valueOf(invoice.Invoice_Cancel_Date__c); //To confirm the field
        status.timeline.add(timeline1);
        
        return status;
    }
    
    public static CMIntegrationRequest.cls_billConfig buildBillConfig(Invoices_Local__c invoice, List<Billing_Arrangement_Local__c> billArrgmntList){
        CMIntegrationRequest.cls_billConfig billConfig = new CMIntegrationRequest.cls_billConfig();
        
        billConfig.billInvoice = new CMIntegrationRequest.cls_billInvoice();
        billConfig.billInvoice.billOrSelfBillCode = invoice.Billing_Preference__c;
        billConfig.billInvoice.billCycle 		  = invoice.Cycle_Code__c!=null? 'MM'+invoice.Cycle_Code__c.leftpad(2, '0'): ''; // Code field or Frequency?? 
        billConfig.billInvoice.billRouteType 	  = invoice.Type_of_Bill__c;
        billConfig.billInvoice.customerClass 	  = 'LGGRP';
        billConfig.billInvoice.division 		  = 'FIGRP'; //To confirm
        billConfig.billInvoice.workLocation 	  = invoice.Account_Legal_Name__r.Work_location__c;
        billConfig.billInvoice.invoiceFormat 	  = ServiceIntegrationMappingUtility.getExternalSystemValue(CMIntegrationConstants.INTEGRATION_NAME, 'Invoice Format',invoice.Invoice_Format__c);
        
        billConfig.billArrangements 	 = buildBillArrangements(invoice, billArrgmntList);
        billConfig.invoiceSortingOptions = buildinvoiceSortingOptions(invoice);
        
       /* billConfig.billDates 	= new CMIntegrationRequest.cls_billDates();
        billConfig.billDates.billFromDate = String.valueOf(invoice.Invoice_Effective_Date__c); // To confirm - Doc says it'll be returned from CM???
        billConfig.billDates.billToDate   = String.valueOf(invoice.Invoice_Cancel_Date__c); // To confirm - Doc says it'll be returned from CM???
        */
        //billConfig.legacy = null; // Leaving Blank for now
        billConfig.delinquency = new CMIntegrationRequest.cls_delinquency();  
        billConfig.delinquency.graceDays = String.valueOf(invoice.Grace_Days__c);
        
        return billConfig; 
    }
    
    public static List<CMIntegrationRequest.cls_billArrangements> buildBillArrangements(Invoices_Local__c invoice, List<Billing_Arrangement_Local__c> billArrgmntList){
        
        List<CMIntegrationRequest.cls_billArrangements> billArrangements;
        
        if(billArrgmntList != null && billArrgmntList.size()>0){
            billArrangements = new List<CMIntegrationRequest.cls_billArrangements>();
        for(Billing_Arrangement_Local__c billingArrgmnt : billArrgmntList){
            CMIntegrationRequest.cls_billArrangements billArg = new CMIntegrationRequest.cls_billArrangements();
            billArg.customerId 			= ANY_CONST; // To confirm if Account id need to be populated?? 
            billArg.productType			= billingArrgmnt.Product_LOB_for_BA__c!=null? billingArrgmnt.Product_LOB_for_BA__c : ANY_CONST;
            billArg.contractCode		= billingArrgmnt.Contract_Code_for_BA__c !=null ? billingArrgmnt.Contract_Code_for_BA__c : ANY_CONST; //To confirm
            billArg.employmentCategory 	= billingArrgmnt.Employee_Category__c != null ? billingArrgmnt.Employee_Category__c : ANY_CONST;
            
            String employeeClassId = billingArrgmnt.Employee_Class_Name_for_BA__c ;
            billArg.employmentClass 	= employeeClassId != null ? employeeClassId : ANY_CONST; //To confirm as this is a lookup field
            billArrangements.add(billArg);
        }
        }
        return  billArrangements;
    }
    
    public static List<CMIntegrationRequest.cls_invoiceSortingOptions> buildinvoiceSortingOptions(Invoices_Local__c invoice){
        List<CMIntegrationRequest.cls_invoiceSortingOptions> invoiceSortingOptions = new  List<CMIntegrationRequest.cls_invoiceSortingOptions>();
        
        CMIntegrationRequest.cls_invoiceSortingOptions sortingOption1 = new CMIntegrationRequest.cls_invoiceSortingOptions();
        sortingOption1.sequence = 1;
        sortingOption1.field 	= invoice.Invoice_Sorting_Option__c;
        sortingOption1.order 	= invoice.Sorting_Order_For_Option_1__c;
        invoiceSortingOptions.add(sortingOption1);
        
        CMIntegrationRequest.cls_invoiceSortingOptions sortingOption2 = new CMIntegrationRequest.cls_invoiceSortingOptions();
        sortingOption2.sequence = 2;
        sortingOption2.field	= invoice.Invoice_Sorting_Option_2__c;
        sortingOption2.order 	= invoice.Sorting_Order_For_Option_2__c;
        invoiceSortingOptions.add(sortingOption2); 
        
        return invoiceSortingOptions;
    }
}