/**
* @author        Michael Khan
* @date          10/05/2019
* @description   Related to PRDCRM-39021 
*                Automatically creates ActWise HRA/HSA record if the plan is of type HRA/HSA
*                Called from Vlocity Open Interface to support Omniscript Remote Action.
*                class name: VlocityInterface
*/
/**
* Story#    Date         Author      Description
* 36729     19/8/19      Michael     Automatically create HSA record if the Is_HSA_Selected_Plan__c is true and Product Configuration is complete.
* 45533     14-Nov-19   Michael   
*/
public with sharing class CDHP_QuoteLineItem_CreateChildQLI {
    /**
* @description       updateOrCreateActWise Updates or Creates Act Wise QLI
* @param             Input Map of the key value 
* @param             Output Map for the key value 
*/
    
    public static Map<String, Object> updateOrCreateActWise(Map<String, Object> inputMap, Map<String, Object> outMap) {
        integer temp = 0;
        String planQLIID = (String) inputMap.get(CDHP_COMM2_Constants.PLANQLIID);
        String squoteId = (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID);
        QuoteLineItem actWiseQLI = new QuoteLineItem();
        HRA_Administration__c hraAdmin = new HRA_Administration__c();
        Object rTMedical = inputMap.get(CDHP_COMM2_Constants.RTMEDICAL);
        Map<String, Object> rtMedicalMap = (Map<String, Object>) rTMedical;
        List<QuoteLineItem> qliList = [select id, RecordType__c, Funding__c, Financing__c, Probability__c, Subscribers__c, Members__c, Reason__c,
                                       TermDate__c, Renewed_with_Changes__c, ReceivedDate__c, PBMIntegrationType__c, PharmacyIDCardDetails__c,
                                       PBM_Vendor__c, MedicalRXAccumulation__c, RXVendors__c, Network__c, AlternateNetwork__c, Prefix__c,
                                       DoesMultipleProviderTieringapply__c, Is_Applied_Behavioral_Analysis_Covered__c, OppType__c,
                                       Pre_Certification_Required_For_Analysis__c, Has_The_Client_Purchased_Autism_Disorder__c,
                                       Federal_Mental_Health_Parity_UW_Review__c, Federal_Mental_Health_Parity_FI_Min_Prem__c,
                                       Federal_Mental_Health_Parity_ASO__c, PLComplete__c, Product2Id, ProductStage__c, quoteId,
                                       PricebookEntryId, Quantity, UnitPrice, HSABankingPartner__c, IfHSAdidClientPurchaseHSAPlus__c,
                                       Administrative_Fees_Responsibility__c, Benefit_Period__c, Accum_Reset_Date__c, HRAHIAAdministration__c,
                                       HRABalanceTransfer__c, DidClientPurchaseBariatricBuyup__c, Client_Remaining_on_LITES__c, Anthem_Sends_Eligibility_to_PBM__c 
                                       from QuoteLineItem 
                                       where id =: squoteId];
        if(qliList.size()<1)
            return outMap;
        if (rtMedicalMap != null) {
            Object quoteLineDetails = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.QUOTELINEDETAILS);
            Map<String, Object> quoteLineDetailsMap = (Map<String, Object>) quoteLineDetails;
            if (quoteLineDetailsMap != null) {
                String recordType = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.RECORDTYPE);
                if (recordType != null) {
                    actWiseQLI.RecordType__c = recordType;
                    if (!actWiseQLI.RecordType__c.equals(qliList[0].RecordType__c)) {
                        temp = 1;
                    }
                }
                String oppType = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.OPPTYPE);
                if (oppType != null) {
                    actWiseQLI.OppType__c = oppType;
                    if (!actWiseQLI.OppType__c.equals(qliList[0].OppType__c)) {
                        temp = 1;
                    }
                }
                String funding = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.FUNDING);
                if (funding != null) {
                    actWiseQLI.Funding__c = funding;
                    if (!actWiseQLI.Funding__c.equals(qliList[0].Funding__c)) {
                        temp = 1;
                    }
                }
                String financing = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.FINANCING);
                if (financing != null) {
                    actWiseQLI.Financing__c = financing;
                    if (!actWiseQLI.Financing__c.equals(qliList[0].Financing__c)) {
                        temp = 1;
                    }
                }
                
                Object probBlock = (Map<String, Object> ) quoteLineDetailsMap.get(CDHP_COMM2_Constants.PROBBLOCK);
                Map<String, Object> probBlockMap = (Map<String, Object>) probBlock;
                if (probBlockMap != null) {
                    String probability = (String) probBlockMap.get(CDHP_COMM2_Constants.PROBABILITY);
                    if (probability != null) {
                        actWiseQLI.Probability__c = probability;
                        if (!actWiseQLI.Probability__c.equals(qliList[0].Probability__c)) {
                            temp = 1;
                        }
                    }
                }
                Decimal subscribers = (Decimal) quoteLineDetailsMap.get(CDHP_COMM2_Constants.SUBSCRIBERS);
                if (subscribers != null) {
                    actWiseQLI.Subscribers__c = subscribers;
                    if (actWiseQLI.Subscribers__c != qliList[0].Subscribers__c) {
                        temp = 1;
                    }
                }
                Decimal members = (Decimal) quoteLineDetailsMap.get(CDHP_COMM2_Constants.MEMBERS);
                if (members != null) {
                    actWiseQLI.Members__c = members;
                    if (actWiseQLI.Members__c != qliList[0].Members__c) {
                        temp = 1;
                    }
                }
                String reason = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.REASON);
                if (reason != null) {
                    actWiseQLI.Reason__c = reason;
                    if (!actWiseQLI.Reason__c.equals(qliList[0].Reason__c)) {
                        temp = 1;
                    }
                }
                
                Date termDate = (Date) quoteLineDetailsMap.get(CDHP_COMM2_Constants.TERMDATE);
                if (termDate != null) {
                    actWiseQLI.TermDate__c = termDate;
                    if (actWiseQLI.TermDate__c != qliList[0].TermDate__c) {
                        temp = 1;
                    }
                }
                
                String renewedWithChanges = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.RENEWEDWITHCHANGES);
                if (renewedWithChanges != null) {
                    actWiseQLI.Renewed_with_Changes__c = renewedWithChanges;
                    if (!actWiseQLI.Renewed_with_Changes__c.equals(qliList[0].Renewed_with_Changes__c)) {
                        temp = 1;
                    }
                }
                Date receivedDate = (Date) quoteLineDetailsMap.get(CDHP_COMM2_Constants.RECEIVEDDATE);
                if (receivedDate != null) {
                    actWiseQLI.ReceivedDate__c = receivedDate;
                    if (actWiseQLI.ReceivedDate__c != qliList[0].ReceivedDate__c) {
                        temp = 1;
                    }
                }
            }
            Object cDHPAWHSA = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.CDHPAWHSA);
            Map<String, Object> cDHPAWHSAMap = (Map<String, Object>) cDHPAWHSA;
            if (cDHPAWHSAMap != null) {
                
                String adminFeeResp = (String) cDHPAWHSAMap.get(CDHP_COMM2_Constants.ADMINFEERESP);
                if (adminFeeResp != null) {
                    actWiseQLI.Administrative_Fees_Responsibility__c = adminFeeResp;
                    if (!actWiseQLI.Administrative_Fees_Responsibility__c.equals(qliList[0].Administrative_Fees_Responsibility__c)) {
                        temp = 1;
                    }
                }
                String benefitPeriod = (String) cDHPAWHSAMap.get(CDHP_COMM2_Constants.BENEFITPERIOD);
                if (benefitPeriod != null) {
                    actWiseQLI.Benefit_Period__c = benefitPeriod;
                    if (!actWiseQLI.Benefit_Period__c.equals(qliList[0].Benefit_Period__c)) {
                        temp = 1;
                    }
                }
                if (cDHPAWHSAMap.get(CDHP_COMM2_Constants.ACCUMRESETDATE) != null) {
                    Date AccumResetDate = Date.valueOf((String) cDHPAWHSAMap.get(CDHP_COMM2_Constants.ACCUMRESETDATE));
                    if (AccumResetDate != null) {
                        actWiseQLI.Accum_Reset_Date__c = AccumResetDate;
                        if (actWiseQLI.Accum_Reset_Date__c != qliList[0].Accum_Reset_Date__c) {
                            temp = 1;
                        }
                    }
                }
            }
            Object cDHPHRA = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.CDHPHRA);
            Map<String, Object> cDHPHRAMap = (Map<String, Object>) cDHPHRA;
            if (cDHPHRAMap != null) {
                String hRAHIAAdministration = (String) cDHPHRAMap.get(CDHP_COMM2_Constants.HRAHIAADMINISTRATION);
                if (hRAHIAAdministration != null) {
                    actWiseQLI.HRAHIAAdministration__c = hRAHIAAdministration;
                    if (!actWiseQLI.HRAHIAAdministration__c.equals(qliList[0].HRAHIAAdministration__c)) {
                        temp = 1;
                    }
                }
                String hRABalanceTransfer = (String) cDHPHRAMap.get(CDHP_COMM2_Constants.HRABALANCETRANSFER);
                if (hRABalanceTransfer != null) {
                    actWiseQLI.HRABalanceTransfer__c = hRABalanceTransfer;
                    if (!actWiseQLI.HRABalanceTransfer__c.equals(qliList[0].HRABalanceTransfer__c)) {
                        temp = 1;
                    }
                }
                Boolean didClientPurchaseQUE = (Boolean) cDHPHRAMap.get(CDHP_COMM2_Constants.DIDCLIENTPURCHASEQUE);
                if (didClientPurchaseQUE != null) {
                    actWiseQLI.DidClientPurchaseBariatricBuyup__c = didClientPurchaseQUE;
                    if (actWiseQLI.DidClientPurchaseBariatricBuyup__c != qliList[0].DidClientPurchaseBariatricBuyup__c) {
                        temp = 1;
                    }
                }
            }
            Object cDHPHSA = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.CDHPHSA);
            Map<String, Object> cDHPHSAMap = (Map<String, Object>) cDHPHSA;
            if (cDHPHSAMap != null) {
                String clientRemLITES = (String) cDHPHSAMap.get(CDHP_COMM2_Constants.CLIENTREMLITES);
                if (clientRemLITES != null) {
                    actWiseQLI.Client_Remaining_on_LITES__c = clientRemLITES;
                    if (!actWiseQLI.Client_Remaining_on_LITES__c.equals(qliList[0].Client_Remaining_on_LITES__c)) {
                        temp = 1;
                    }
                }
                String anthemSendEligPBM = (String) cDHPHSAMap.get(CDHP_COMM2_Constants.ANTHEMSENDELIGPBM);
                if (anthemSendEligPBM != null) {
                    actWiseQLI.Anthem_Sends_Eligibility_to_PBM__c = anthemSendEligPBM;
                    if (!actWiseQLI.Anthem_Sends_Eligibility_to_PBM__c.equals(qliList[0].Anthem_Sends_Eligibility_to_PBM__c)) {
                        temp = 1;
                    }
                }
            }
            

            String hSABP = (String) rtMedicalMap.get(CDHP_COMM2_Constants.HSABP);
            if (hSABP != null) {
                actWiseQLI.HSABankingPartner__c = hSABP;
                if (!actWiseQLI.HSABankingPartner__c.equals(qliList[0].HSABankingPartner__c)) {
                    temp = 1;
                }
            }
            String hSACP = (String) rtMedicalMap.get(CDHP_COMM2_Constants.HSACP);
            if (hSACP != null) {
                actWiseQLI.IfHSAdidClientPurchaseHSAPlus__c = hSACP;
                if (!actWiseQLI.IfHSAdidClientPurchaseHSAPlus__c.equals(qliList[0].IfHSAdidClientPurchaseHSAPlus__c)) {
                    temp = 1;
                }
            }
            Object pharmacyObj = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.PHARMACY);
            Map<String, Object> pharmacyMap = (Map<String, Object>) pharmacyObj;
            if (pharmacyMap != null) {
                Object medicalCDHPandMedicalCDHPWCIC = (Map<String, Object>) pharmacyMap.get(CDHP_COMM2_Constants.MEDICALCDHPANDMEDICALCDHPWCIC);
                Map<String, Object> medicalCDHPandMedicalCDHPWCICMap = (Map<String, Object>) medicalCDHPandMedicalCDHPWCIC;
                if (medicalCDHPandMedicalCDHPWCICMap != null) {
                    String pBMIntegrationType = (String) medicalCDHPandMedicalCDHPWCICMap.get(CDHP_COMM2_Constants.PBMINTEGRATIONTYPE);
                    if (pBMIntegrationType != null) {
                        actWiseQLI.PBMIntegrationType__c = pBMIntegrationType;
                        if (!actWiseQLI.PBMIntegrationType__c.equals(qliList[0].PBMIntegrationType__c)) {
                            temp = 1;
                        }
                    }
                    String pharmacyIDCardDetails = (String) medicalCDHPandMedicalCDHPWCICMap.get(CDHP_COMM2_Constants.PHARMACYIDCARDDETAILS);
                    if (pharmacyIDCardDetails != null) {
                        actWiseQLI.PharmacyIDCardDetails__c = pharmacyIDCardDetails;
                        if (!actWiseQLI.PharmacyIDCardDetails__c.equals(qliList[0].PharmacyIDCardDetails__c)) {
                            temp = 1;
                        }
                    }
                }
                Object pBMVendor_Block = (Map<String, Object>) pharmacyMap.get(CDHP_COMM2_Constants.PBMVENDOR_BLOCK);
                Map<String, Object> pBMVendor_BlockMap = (Map<String, Object>) pBMVendor_Block;
                if (pBMVendor_BlockMap != null) {
                    String sPAccountId = (String) pBMVendor_BlockMap.get(CDHP_COMM2_Constants.SPACCOUNTID);
                    if (sPAccountId != null) {
                        actWiseQLI.PBM_Vendor__c = sPAccountId;
                        if (!actWiseQLI.PBM_Vendor__c.equals(qliList[0].PBM_Vendor__c)) {
                            temp = 1;
                        }
                    }
                }
                Object medicalandMedicalWCIC = (Map<String, Object>) pharmacyMap.get(CDHP_COMM2_Constants.MEDICALANDMEDICALWCIC_BLOCK);
                Map<String, Object> medicalandMedicalWCICMap = (Map<String, Object>) medicalandMedicalWCIC;
                if (medicalandMedicalWCICMap != null) {
                    String medicalRXAccumulation = (String) medicalandMedicalWCICMap.get(CDHP_COMM2_Constants.MEDICALRXACCUMULATION);
                    if (medicalRXAccumulation != null) {
                        actWiseQLI.MedicalRXAccumulation__c = medicalRXAccumulation;
                        if (!actWiseQLI.MedicalRXAccumulation__c.equals(qliList[0].MedicalRXAccumulation__c)) {
                            temp = 1;
                        }
                    }
                    String rXVendors = (String) medicalandMedicalWCICMap.get(CDHP_COMM2_Constants.RXVENDORS);
                    if (RXVendors != null) {
                        actWiseQLI.RXVendors__c = rXVendors;
                        if (!actWiseQLI.RXVendors__c.equals(qliList[0].RXVendors__c)) {
                            temp = 1;
                        }
                    }
                }
                
            }
            Object networkBlockObj = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.NETWORKBLOCK);
            Map<String, Object> networkBlockMap = (Map<String, Object>) networkBlockObj;
            if (networkBlockMap != null) {
                String network = (String) networkBlockMap.get(CDHP_COMM2_Constants.NETWORK);
                if (network != null) {
                    actWiseQLI.Network__c = network;
                    if (!actWiseQLI.Network__c.equals(qliList[0].Network__c)) {
                        temp = 1;
                    }
                }
                String alternateNetwork = (String) networkBlockMap.get(CDHP_COMM2_Constants.ALTERNATENETWORK);
                if (alternateNetwork != null) {
                    actWiseQLI.AlternateNetwork__c = alternateNetwork;
                    if (!actWiseQLI.AlternateNetwork__c.equals(qliList[0].AlternateNetwork__c)) {
                        temp = 1;
                    }
                }
                String prefix = (String) networkBlockMap.get(CDHP_COMM2_Constants.PREFIX);
                if (prefix != null) {
                    actWiseQLI.Prefix__c = prefix;
                    if (!actWiseQLI.Prefix__c.equals(qliList[0].Prefix__c)) {
                        temp = 1;
                    }
                }
            }
            Object multipleProviderTieringObj = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.MULTIPLEPROVIDERTIERING);
            Map<String, Object> multipleProviderTieringMap = (Map<String, Object>) multipleProviderTieringObj;
            if (multipleProviderTieringMap != null) {
                String doesMultipleProviderTieringApply = (String) multipleProviderTieringMap.get(CDHP_COMM2_Constants.DOESMULTIPLEPROVIDERTIERINGAPPLY);
                if (doesMultipleProviderTieringApply != null) {
                    actWiseQLI.DoesMultipleProviderTieringapply__c = doesMultipleProviderTieringApply;
                    if (!actWiseQLI.DoesMultipleProviderTieringapply__c.equals(qliList[0].DoesMultipleProviderTieringapply__c)) {
                        temp = 1;
                    }
                }
            }
            Object aBA = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.ABA);
            Map<String, Object> aBAMap = (Map<String, Object>) aBA;
            if (aBAMap != null) {
                String aBACovered = (String) aBAMap.get(CDHP_COMM2_Constants.ABACOVERED);
                if (aBACovered != null) {
                    actWiseQLI.Is_Applied_Behavioral_Analysis_Covered__c = aBACovered;
                    if (!actWiseQLI.Is_Applied_Behavioral_Analysis_Covered__c.equals(qliList[0].Is_Applied_Behavioral_Analysis_Covered__c)) {
                        temp = 1;
                    }
                }
                String preCertificationRequired = (String) aBAMap.get(CDHP_COMM2_Constants.PRECERTIFICATIONREQUIRED);
                if (preCertificationRequired != null) {
                    actWiseQLI.Pre_Certification_Required_For_Analysis__c = preCertificationRequired;
                    if (!actWiseQLI.Pre_Certification_Required_For_Analysis__c.equals(qliList[0].Pre_Certification_Required_For_Analysis__c)) {
                        temp = 1;
                    }
                }
                String purchasedASD = (String) aBAMap.get(CDHP_COMM2_Constants.PURCHASEDASD);
                if (purchasedASD != null) {
                    actWiseQLI.Has_The_Client_Purchased_Autism_Disorder__c = purchasedASD;
                    if (!actWiseQLI.Has_The_Client_Purchased_Autism_Disorder__c.equals(qliList[0].Has_The_Client_Purchased_Autism_Disorder__c)) {
                        temp = 1;
                    }
                }
            }
            Object fMHPBlockObj = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.FMHPBLOCK);
            Map<String, Object> fMHPBlockMap = (Map<String, Object>) fMHPBlockObj;
            
            String fMHPUWReview = (String) rtMedicalMap.get(CDHP_COMM2_Constants.FMHPUWREVIEW);
            if (fMHPUWReview != null) {
                actWiseQLI.Federal_Mental_Health_Parity_UW_Review__c = fMHPUWReview;
                if (!actWiseQLI.Federal_Mental_Health_Parity_UW_Review__c.equals(qliList[0].Federal_Mental_Health_Parity_UW_Review__c)) {
                    temp = 1;
                }
            }
            String fMHPFI = (String) rtMedicalMap.get(CDHP_COMM2_Constants.FMHPFI);
            if (fMHPFI != null) {
                actWiseQLI.Federal_Mental_Health_Parity_FI_Min_Prem__c = fMHPFI;
                if (!(actWiseQLI.Federal_Mental_Health_Parity_FI_Min_Prem__c == '' && qliList[0].Federal_Mental_Health_Parity_FI_Min_Prem__c == null)) {
                    if (!actWiseQLI.Federal_Mental_Health_Parity_FI_Min_Prem__c.equals(qliList[0].Federal_Mental_Health_Parity_FI_Min_Prem__c)) {
                        temp = 1;
                    }
                }
            }
            String fMHPASO = (String) rtMedicalMap.get(CDHP_COMM2_Constants.FMHPASO);
            if (fMHPASO != null) {
                actWiseQLI.Federal_Mental_Health_Parity_ASO__c = fMHPASO;
                if (!(actWiseQLI.Federal_Mental_Health_Parity_ASO__c == '' && qliList[0].Federal_Mental_Health_Parity_ASO__c == null)) {
                    if (!actWiseQLI.Federal_Mental_Health_Parity_ASO__c.equals(qliList[0].Federal_Mental_Health_Parity_ASO__c)) {
                        temp = 1;
                    }
                }
            }
            Object setPLComplete = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.SETPLCOMPLETE);
            Map<String, Object> setPLCompleteMap = (Map<String, Object>) setPLComplete;
            if (setPLCompleteMap != null) {
                Boolean pLComplete = (Boolean) setPLCompleteMap.get(CDHP_COMM2_Constants.PLCOMPLETE);
                if (pLComplete != null) {
                    actWiseQLI.PLComplete__c = pLComplete;
                    if (actWiseQLI.PLComplete__c != qliList[0].PLComplete__c) {
                        temp = 1;
                    }
                }
            }
        }
        //Product2id we are not checking as we are not allowing the user to modify. If later requirement comes then we can implement here.
        
        String productStage = (String) inputMap.get(CDHP_COMM2_Constants.PRODUCTSTAGE);
        actWiseQLI.ProductStage__c = productStage;
        
        if (!actWiseQLI.ProductStage__c.equals(qliList[0].ProductStage__c))
            temp = 1;
        if (actWiseQLI.RecordType__c == CDHP_COMM2_Constants.ACTWISE_HRA) {
            List<HRA_Administration__c> hraAdminList = [select id, HRA1_Group_Suffix__c, Plan_Start_Date__c, Plan_End_Date__c,
                                                        Terminated_can_submit_claims_for__c, If_Other_Please_Specify__c,
                                                        Benefit_Accumulations__c, Accum_Reset_Date__c, HRA_Funds_Pro_Rate_on_Entry_Date__c,
                                                        HRA_Funds_to_Employees_and_on_what_basis__c, Annual_Allocation_Tiers__c,
                                                        Health_Activities_Incentives__c, Health_Incentive_Type__c, AllocationEE__c,
                                                        AllocationEA__c, Allocation_EChild__c, AllocationEChildren__c, AllocationFamily__c,
                                                        Type_of_HRA__c, Debit_Card_Services__c, HRA_Upfront_Deductible__c, Covered_Services__c,
                                                        Up_Front_Deductible_Tiers__c, UpfrontDedEE__c, UpFrontDedEA__c, UpfrontDedEChild__c,
                                                        UpFrontDedEEChildren__c, UpFrontDedFamily__c, Has_Individual_Deductible__c,
                                                        Individual_Deductible_Amount__c, HRA_Split_Percentage__c,
                                                        Member_Responsibility_by_Claim__c, Custom_Member_Responbsibility__c,
                                                        Split_Percentage_Covered_Services__c, NonSplit_Covered_Services__c, Medical__c,
                                                        Pharmacy__c, Specialty__c, HRA_Rollover__c, Will_HRA_rollover_funds_ever_expire__c,
                                                        Claim_Run_Out_Date__c, During_claims_run_out__c, CapEE__c, HRA_Rollover_Time_Period__c,
                                                        Actual_Rollover_Date__c, CapEA__c, CapEChild__c, Minimum_Rollover_Amount__c,
                                                        CapEChildren__c, Employee_Funds_Rollover_Next_Plan_Year__c, CapEFamily__c,
                                                        Rollover_Percent_Value__c, Rollover_Cap_Tiers__c, Rollover_Different_Admin__c,
                                                        HRA_LITES_Rollover__c, Group_Accumulators_And_HRA_Allocation__c,
                                                        Desired_Rollover_Date_Fund__c, Prior_Trustee__c, QLI__c 
                                                        from HRA_Administration__c
                                                        where QLI__c =: squoteId
                                                       ];
            if (hraAdminList[0] != null) {
                
                Object hRAA = inputMap.get(CDHP_COMM2_Constants.HRAA);
                Map<String, Object> hRAAMap = (Map<String, Object>) hRAA;
                if (hRAAMap != null) {
                    Object hRAAR = (Map<String, Object>) hRAAMap.get(CDHP_COMM2_Constants.HRAAR);
                    Map<String, Object> hRAARMap = (Map<String, Object>) hRAAR;
                    if (hRAARMap != null) {
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRA1GROUPSUFFIX) != null) {
                            String hRA1GroupSuffix = (String) hRAARMap.get(CDHP_COMM2_Constants.HRA1GROUPSUFFIX);
                            if (hRA1GroupSuffix != null) {
                                hraAdmin.HRA1_Group_Suffix__c = hRA1GroupSuffix;
                                if (!hraAdmin.HRA1_Group_Suffix__c.equals(hraAdminList[0].HRA1_Group_Suffix__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if (Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.PLANSTARTDATE)) != null) {
                            Date planStartDate = Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.PLANSTARTDATE));
                            if (planStartDate != null) {
                                hraAdmin.Plan_Start_Date__c = planStartDate;
                                if (hraAdmin.Plan_Start_Date__c != hraAdminList[0].Plan_Start_Date__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if (Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.PLANENDDATE)) != null) {
                            Date planEndDate = Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.PLANENDDATE));
                            if (planEndDate != null) {
                                hraAdmin.Plan_End_Date__c = planEndDate;
                                if (hraAdmin.Plan_End_Date__c != hraAdminList[0].Plan_End_Date__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.TERMCANSUBMITCLAIMS) != null) {
                            String termCanSubmitClaims = (String) hRAARMap.get(CDHP_COMM2_Constants.TERMCANSUBMITCLAIMS);
                            if (termCanSubmitClaims != null) {
                                hraAdmin.Terminated_can_submit_claims_for__c = termCanSubmitClaims;
                                if (!hraAdmin.Terminated_can_submit_claims_for__c.equals(hraAdminList[0].Terminated_can_submit_claims_for__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.IFOTHERPLEASESPECIFY) != null) {
                            String ifOtherPleaseSpecify = (String) hRAARMap.get(CDHP_COMM2_Constants.IFOTHERPLEASESPECIFY);
                            if (ifOtherPleaseSpecify != null) {
                                hraAdmin.If_Other_Please_Specify__c = ifOtherPleaseSpecify;
                                if (!hraAdmin.If_Other_Please_Specify__c.equals(hraAdminList[0].If_Other_Please_Specify__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.BENACCUMULATION) != null) {
                            String benAccumulation = (String) hRAARMap.get(CDHP_COMM2_Constants.BENACCUMULATION);
                            if (benAccumulation != null) {
                                hraAdmin.Benefit_Accumulations__c = benAccumulation;
                                if (!hraAdmin.Benefit_Accumulations__c.equals(hraAdminList[0].Benefit_Accumulations__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        
                        Date accumResetDate = (Date) hRAARMap.get(CDHP_COMM2_Constants.ACCUMRESETDATE);
                        if (accumResetDate != null) {
                            hraAdmin.Accum_Reset_Date__c = accumResetDate;
                            if (hraAdmin.Accum_Reset_Date__c != hraAdminList[0].Accum_Reset_Date__c) {
                                temp = 1;
                            }
                        }
                        //}
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAFUNDSPRORATEENTRYDATE) != null) {
                            String hRAFundsProRateEntryDate = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAFUNDSPRORATEENTRYDATE);
                            if (hRAFundsProRateEntryDate != null) {
                                hraAdmin.HRA_Funds_Pro_Rate_on_Entry_Date__c = hRAFundsProRateEntryDate;
                                if (!hraAdmin.HRA_Funds_Pro_Rate_on_Entry_Date__c.equals(hraAdminList[0].HRA_Funds_Pro_Rate_on_Entry_Date__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAFUNDSTOEEANDBASIS) != null) {
                            String hRAFundstoEEandBasis = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAFUNDSTOEEANDBASIS);
                            if (hRAFundstoEEandBasis != null) {
                                hraAdmin.HRA_Funds_to_Employees_and_on_what_basis__c = hRAFundstoEEandBasis;
                                if (!hraAdmin.HRA_Funds_to_Employees_and_on_what_basis__c.equals(hraAdminList[0].HRA_Funds_to_Employees_and_on_what_basis__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.ANNUALALLOCTIERS) != null) {
                            String annualAllocTiers = (String) hRAARMap.get(CDHP_COMM2_Constants.ANNUALALLOCTIERS);
                            if (annualAllocTiers != null) {
                                hraAdmin.Annual_Allocation_Tiers__c = annualAllocTiers;
                                if (!hraAdmin.Annual_Allocation_Tiers__c.equals(hraAdminList[0].Annual_Allocation_Tiers__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HEALTHACTIVITIESINCENTIVESB) != null) {
                            String healthActivitiesIncentivesB = (String) hRAARMap.get(CDHP_COMM2_Constants.HEALTHACTIVITIESINCENTIVESB);
                            if (healthActivitiesIncentivesB != null) {
                                hraAdmin.Health_Activities_Incentives__c = healthActivitiesIncentivesB;
                                if (!hraAdmin.Health_Activities_Incentives__c.equals(hraAdminList[0].Health_Activities_Incentives__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HEALTHINCENTIVETYPEB) != null) {
                            String healthIncentiveTypeB = (String) hRAARMap.get(CDHP_COMM2_Constants.HEALTHINCENTIVETYPEB);
                            if (healthIncentiveTypeB != null) {
                                hraAdmin.Health_Incentive_Type__c = healthIncentiveTypeB;
                                if (!hraAdmin.Health_Incentive_Type__c.equals(hraAdminList[0].Health_Incentive_Type__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEE) != null) {
                            Decimal allocEE = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEE);
                            if (allocEE != null) {
                                hraAdmin.AllocationEE__c = allocEE;
                                if (hraAdmin.AllocationEE__c != hraAdminList[0].AllocationEE__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEA) != null) {
                            Decimal allocEA = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEA);
                            if (allocEA != null) {
                                hraAdmin.AllocationEA__c = allocEA;
                                if (hraAdmin.AllocationEA__c != hraAdminList[0].AllocationEA__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCECHILD) != null) {
                            Decimal allocEChild = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCECHILD);
                            if (allocEChild != null) {
                                hraAdmin.Allocation_EChild__c = allocEChild;
                                if (hraAdmin.Allocation_EChild__c != hraAdminList[0].Allocation_EChild__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCECHILDREN) != null) {
                            Decimal allocEChildren = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCECHILDREN);
                            if (allocEChildren != null) {
                                hraAdmin.AllocationEChildren__c = allocEChildren;
                                if (hraAdmin.AllocationEChildren__c != hraAdminList[0].AllocationEChildren__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEFAMILY) != null) {
                            Decimal allocEFamily = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEFAMILY);
                            if (allocEFamily != null) {
                                hraAdmin.AllocationFamily__c = allocEFamily;
                                if (hraAdmin.AllocationFamily__c != hraAdminList[0].AllocationFamily__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.TYPEOFHRA) != null) {
                            String typeofHRA = (String) hRAARMap.get(CDHP_COMM2_Constants.TYPEOFHRA);
                            if (typeofHRA != null) {
                                hraAdmin.Type_of_HRA__c = typeofHRA;
                                if (!hraAdmin.Type_of_HRA__c.equals(hraAdminList[0].Type_of_HRA__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.DEBITCARDSERVICES) != null) {
                            String debitCardServices = (String) hRAARMap.get(CDHP_COMM2_Constants.DEBITCARDSERVICES);
                            if (debitCardServices != null) {
                                hraAdmin.Debit_Card_Services__c = debitCardServices;
                                if (!hraAdmin.Debit_Card_Services__c.equals(hraAdminList[0].Debit_Card_Services__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAUPFRONTDED) != null) {
                            String hRAUpFrontDed = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAUPFRONTDED);
                            if (hRAUpFrontDed != null) {
                                hraAdmin.HRA_Upfront_Deductible__c = hRAUpFrontDed;
                                if (!hraAdmin.HRA_Upfront_Deductible__c.equals(hraAdminList[0].HRA_Upfront_Deductible__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.COVEREDSERVICES) != null) {
                            String coveredServices = (String) hRAARMap.get(CDHP_COMM2_Constants.COVEREDSERVICES);
                            if (coveredServices != null) {
                                hraAdmin.Covered_Services__c = coveredServices;
                                if (!hraAdmin.Covered_Services__c.equals(hraAdminList[0].Covered_Services__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.UPFRONTDEDTIERS) != null) {
                            String upFrontDedTiers = (String) hRAARMap.get(CDHP_COMM2_Constants.UPFRONTDEDTIERS);
                            if (upFrontDedTiers != null) {
                                hraAdmin.Up_Front_Deductible_Tiers__c = upFrontDedTiers;
                                if (!hraAdmin.Up_Front_Deductible_Tiers__c.equals(hraAdminList[0].Up_Front_Deductible_Tiers__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEE) != null) {
                            Decimal uFDEE = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEE);
                            if (uFDEE != null) {
                                hraAdmin.UpfrontDedEE__c = uFDEE;
                                if (hraAdmin.UpfrontDedEE__c != hraAdminList[0].UpfrontDedEE__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEA) != null) {
                            Decimal uFDEA = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEA);
                            if (uFDEA != null) {
                                hraAdmin.UpFrontDedEA__c = uFDEA;
                                if (hraAdmin.UpFrontDedEA__c != hraAdminList[0].UpFrontDedEA__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDECHILD) != null) {
                            Decimal uFDEChild = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDECHILD);
                            if (uFDEChild != null) {
                                hraAdmin.UpfrontDedEChild__c = uFDEChild;
                                if (hraAdmin.UpfrontDedEChild__c != hraAdminList[0].UpfrontDedEChild__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDECHILDREN) != null) {
                            Decimal uFDEChildren = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDECHILDREN);
                            if (uFDEChildren != null) {
                                hraAdmin.UpFrontDedEEChildren__c = uFDEChildren;
                                if (hraAdmin.UpFrontDedEEChildren__c != hraAdminList[0].UpFrontDedEEChildren__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEFAMILY) != null) {
                            Decimal uFDEFamily = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEFAMILY);
                            if (uFDEFamily != null) {
                                hraAdmin.UpFrontDedFamily__c = uFDEFamily;
                                if (hraAdmin.UpFrontDedFamily__c != hraAdminList[0].UpFrontDedFamily__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Boolean) hRAARMap.get(CDHP_COMM2_Constants.HASINDDED) != null) {
                            Boolean hasIndDed = (Boolean) hRAARMap.get(CDHP_COMM2_Constants.HASINDDED);
                            if (hasIndDed != null) {
                                hraAdmin.Has_Individual_Deductible__c = hasIndDed;
                                if (hraAdmin.Has_Individual_Deductible__c != hraAdminList[0].Has_Individual_Deductible__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.INDDEDAMOUNT) != null) {
                            Decimal indDedAmount = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.INDDEDAMOUNT);
                            if (indDedAmount != null) {
                                hraAdmin.Individual_Deductible_Amount__c = indDedAmount;
                                if (hraAdmin.Individual_Deductible_Amount__c != hraAdminList[0].Individual_Deductible_Amount__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRASPLITPERCENT) != null) {
                            String hRASplitPercent = (String) hRAARMap.get(CDHP_COMM2_Constants.HRASPLITPERCENT);
                            if (hRASplitPercent != null) {
                                hraAdmin.HRA_Split_Percentage__c = hRASplitPercent;
                                if (!hraAdmin.HRA_Split_Percentage__c.equals(hraAdminList[0].HRA_Split_Percentage__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.MEMBERRESPBYCLAIM) != null) {
                            String memberRespByClaim = (String) hRAARMap.get(CDHP_COMM2_Constants.MEMBERRESPBYCLAIM);
                            if (memberRespByClaim != null) {
                                hraAdmin.Member_Responsibility_by_Claim__c = memberRespByClaim;
                                if (!hraAdmin.Member_Responsibility_by_Claim__c.equals(hraAdminList[0].Member_Responsibility_by_Claim__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Double) hRAARMap.get(CDHP_COMM2_Constants.CUSTMEMCLAIMRESP) != null) {
                            Double custMemClaimResp = (Double) hRAARMap.get(CDHP_COMM2_Constants.CUSTMEMCLAIMRESP);
                            if (custMemClaimResp != null) {
                                hraAdmin.Custom_Member_Responbsibility__c = custMemClaimResp;
                                if (hraAdmin.Custom_Member_Responbsibility__c != hraAdminList[0].Custom_Member_Responbsibility__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.SPLITPERCENTCOVSVC) != null) {
                            String splitPercentCovSvc = (String) hRAARMap.get(CDHP_COMM2_Constants.SPLITPERCENTCOVSVC);
                            if (splitPercentCovSvc != null) {
                                hraAdmin.Split_Percentage_Covered_Services__c = splitPercentCovSvc;
                                if (!hraAdmin.Split_Percentage_Covered_Services__c.equals(hraAdminList[0].Split_Percentage_Covered_Services__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.NONSPLITCOVEREDSVC) != null) {
                            String nonSplitCoveredSvc = (String) hRAARMap.get(CDHP_COMM2_Constants.NONSPLITCOVEREDSVC);
                            if (nonSplitCoveredSvc != null) {
                                hraAdmin.NonSplit_Covered_Services__c = nonSplitCoveredSvc;
                                if (!hraAdmin.NonSplit_Covered_Services__c.equals(hraAdminList[0].NonSplit_Covered_Services__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.MEDICAL) != null) {
                            String medical = (String) hRAARMap.get(CDHP_COMM2_Constants.MEDICAL);
                            if (medical != null) {
                                hraAdmin.Medical__c = medical;
                                if (!hraAdmin.Medical__c.equals(hraAdminList[0].Medical__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.PHARMACYHRAADMIN) != null) {
                            String pharmacy = (String) hRAARMap.get(CDHP_COMM2_Constants.PHARMACYHRAADMIN);
                            if (pharmacy != null) {
                                hraAdmin.Pharmacy__c = pharmacy;
                                if (!hraAdmin.Pharmacy__c.equals(hraAdminList[0].Pharmacy__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.SPECIALTY) != null) {
                            String specialty = (String) hRAARMap.get(CDHP_COMM2_Constants.SPECIALTY);
                            if (specialty != null) {
                                hraAdmin.Specialty__c = specialty;
                                if (!hraAdmin.Specialty__c.equals(hraAdminList[0].Specialty__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVER) != null) {
                            String hRARollover = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVER);
                            if (hRARollover != null) {
                                hraAdmin.HRA_Rollover__c = hRARollover;
                                if (!hraAdmin.HRA_Rollover__c.equals(hraAdminList[0].HRA_Rollover__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVERFUNDSEXPIRE) != null) {
                            String hRARolloverFundsExpire = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVERFUNDSEXPIRE);
                            if (hRARolloverFundsExpire != null) {
                                hraAdmin.Will_HRA_rollover_funds_ever_expire__c = hRARolloverFundsExpire;
                                if (!hraAdmin.Will_HRA_rollover_funds_ever_expire__c.equals(hraAdminList[0].Will_HRA_rollover_funds_ever_expire__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.CLAIMRUNOUTDATE) != null) {
                            //Date PlanEndDate = Date.valueOf((String)HRAARMap.get('PlanEndDate'));
                            Date claimRunOutDate = Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.CLAIMRUNOUTDATE));
                            if (claimRunOutDate != null) {
                                hraAdmin.Claim_Run_Out_Date__c = claimRunOutDate;
                                if (hraAdmin.Claim_Run_Out_Date__c != hraAdminList[0].Claim_Run_Out_Date__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.DURINGCLAIMSRUNOUT) != null) {
                            String duringclaimsrunout = (String) hRAARMap.get(CDHP_COMM2_Constants.DURINGCLAIMSRUNOUT);
                            if (duringclaimsrunout != null) {
                                hraAdmin.During_claims_run_out__c = duringclaimsrunout;
                                if (!hraAdmin.During_claims_run_out__c.equals(hraAdminList[0].During_claims_run_out__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEE) != null) {
                            Decimal capEE = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEE);
                            if (capEE != null) {
                                hraAdmin.CapEE__c = capEE;
                                if (hraAdmin.CapEE__c != hraAdminList[0].CapEE__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVERTIMEPERIOD) != null) {
                            String hRARolloverTimePeriod = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVERTIMEPERIOD);
                            if (hRARolloverTimePeriod != null) {
                                hraAdmin.HRA_Rollover_Time_Period__c = hRARolloverTimePeriod;
                                if (!hraAdmin.HRA_Rollover_Time_Period__c.equals(hraAdminList[0].HRA_Rollover_Time_Period__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.ACTUALROLLOVERDATE) != null) {
                            
                            Date actualRolloverDate = Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.ACTUALROLLOVERDATE));
                            if (actualRolloverDate != null) {
                                hraAdmin.Actual_Rollover_Date__c = actualRolloverDate;
                                if (hraAdmin.Actual_Rollover_Date__c != hraAdminList[0].Actual_Rollover_Date__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEA) != null) {
                            Decimal capEA = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEA);
                            if (capEA != null) {
                                hraAdmin.CapEA__c = capEA;
                                if (hraAdmin.CapEA__c != hraAdminList[0].CapEA__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPECHILD) != null) {
                            Decimal capEChild = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPECHILD);
                            if (capEChild != null) {
                                hraAdmin.CapEChild__c = capEChild;
                                if (hraAdmin.CapEChild__c != hraAdminList[0].CapEChild__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.MINROLLOVERAMOUNT) != null) {
                            Decimal minRolloverAmount = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.MINROLLOVERAMOUNT);
                            if (minRolloverAmount != null) {
                                hraAdmin.Minimum_Rollover_Amount__c = minRolloverAmount;
                                if (hraAdmin.Minimum_Rollover_Amount__c != hraAdminList[0].Minimum_Rollover_Amount__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPECHILDREN) != null) {
                            Decimal capEChildren = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPECHILDREN);
                            if (capEChildren != null) {
                                hraAdmin.CapEChildren__c = capEChildren;
                                if (hraAdmin.CapEChildren__c != hraAdminList[0].CapEChildren__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.EEFUNDSROLLVERNEXTPLANYEAR) != null) {
                            String eEFundsRollverNextPlanYear = (String) hRAARMap.get(CDHP_COMM2_Constants.EEFUNDSROLLVERNEXTPLANYEAR);
                            if (eEFundsRollverNextPlanYear != null) {
                                hraAdmin.Employee_Funds_Rollover_Next_Plan_Year__c = eEFundsRollverNextPlanYear;
                                if (!hraAdmin.Employee_Funds_Rollover_Next_Plan_Year__c.equals(hraAdminList[0].Employee_Funds_Rollover_Next_Plan_Year__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEFAMILY) != null) {
                            Decimal capEFamily = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEFAMILY);
                            if (capEFamily != null) {
                                hraAdmin.CapEFamily__c = capEFamily;
                                if (hraAdmin.CapEFamily__c != hraAdminList[0].CapEFamily__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERPCTVALUE) != null) {
                            Decimal rolloverPctValue = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERPCTVALUE);
                            if (rolloverPctValue != null) {
                                hraAdmin.Rollover_Percent_Value__c = rolloverPctValue;
                                if (hraAdmin.Rollover_Percent_Value__c != hraAdminList[0].Rollover_Percent_Value__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERCAPTIERS) != null) {
                            String rolloverCapTiers = (String) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERCAPTIERS);
                            if (rolloverCapTiers != null) {
                                hraAdmin.Rollover_Cap_Tiers__c = rolloverCapTiers;
                                if (hraAdmin.Rollover_Cap_Tiers__c != hraAdminList[0].Rollover_Cap_Tiers__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERDIFFADMIN) != null) {
                            String rolloverDiffAdmin = (String) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERDIFFADMIN);
                            if (rolloverDiffAdmin != null) {
                                hraAdmin.Rollover_Different_Admin__c = rolloverDiffAdmin;
                                if (!hraAdmin.Rollover_Different_Admin__c.equals(hraAdminList[0].Rollover_Different_Admin__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRALITESROLLOVER) != null) {
                            String hRALITESRollover = (String) hRAARMap.get(CDHP_COMM2_Constants.HRALITESROLLOVER);
                            if (hRALITESRollover != null) {
                                hraAdmin.HRA_LITES_Rollover__c = hRALITESRollover;
                                if (!hraAdmin.HRA_LITES_Rollover__c.equals(hraAdminList[0].HRA_LITES_Rollover__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRALITESROLLOVERALLOCATION) != null) {
                            String hRALITESRolloverAllocation = (String) hRAARMap.get(CDHP_COMM2_Constants.HRALITESROLLOVERALLOCATION);
                            if (hRALITESRolloverAllocation != null) {
                                hraAdmin.Group_Accumulators_And_HRA_Allocation__c = hRALITESRolloverAllocation;
                                if (!hraAdmin.Group_Accumulators_And_HRA_Allocation__c.equals(hraAdminList[0].Group_Accumulators_And_HRA_Allocation__c)) {
                                    temp = 1;
                                }
                            }
                        }
                        
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.DESIREDROLLVERDATEFROMPREVHRA) != null) {
                            Date desiredRollverDateFromPrevHRA = Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.DESIREDROLLVERDATEFROMPREVHRA));
                            if (desiredRollverDateFromPrevHRA != null) {
                                hraAdmin.Desired_Rollover_Date_Fund__c = desiredRollverDateFromPrevHRA;
                                if (hraAdmin.Desired_Rollover_Date_Fund__c != hraAdminList[0].Desired_Rollover_Date_Fund__c) {
                                    temp = 1;
                                }
                            }
                        }
                        if ((String) hRAARMap.get(CDHP_COMM2_Constants.PRIORTRUSTEE) != null) {
                            String priorTrustee = (String) hRAARMap.get(CDHP_COMM2_Constants.PRIORTRUSTEE);
                            if (priorTrustee != null) {
                                hraAdmin.Prior_Trustee__c = priorTrustee;
                                if (!hraAdmin.Prior_Trustee__c.equals(hraAdminList[0].Prior_Trustee__c)) {
                                    temp = 1;
                                }
                            }
                        }
                    }
                }
            }
        }
        if (temp == 1) {
            QuoteLineItem qli = [select id, ActWiseChildQuote__c 
                                 from quoteLineItem 
                                 where id =: planQLIID];
            Plan_Relationship__c junctionRec = [SELECT Qli1__c, Qli2__c, Id 
                                                FROM Plan_Relationship__c 
                                                where Qli1__c =: qli.Id and Qli2__c =: squoteId];
            actWiseQLI.quoteId = qliList[0].quoteId;
            actWiseQLI.PricebookEntryId = qliList[0].PricebookEntryId;
            actWiseQLI.Quantity = qliList[0].quantity;
            actWiseQLI.UnitPrice = qliList[0].unitprice;
            actWiseQLI.From_Act_Wise_Config__c = true;
            
            Database.SaveResult sr = Database.insert(actWiseQLI, false);
            if (sr.isSuccess()) {
                if (actWiseQLI.RecordType__c == CDHP_COMM2_Constants.ACTWISE_HRA) {
                    hraAdmin.QLI__c = sr.getId();
                    qli.ActWiseChildQuote__c = sr.getId();
                    junctionRec.Qli2__c = sr.getId();
                    insert hraAdmin;
                    update qli;
                    update junctionRec;
                } else if (actWiseQLI.RecordType__c == CDHP_COMM2_Constants.ACTWISE_HSA) {
                    qli.ActWiseChildQuote__c = sr.getId();
                    junctionRec.Qli2__c = sr.getId();
                    update qli;
                    update junctionRec;
                }
            }
            
        }
        return outMap;
    }
    
    /**
* @description       checkJunctionObject  returns Junction Record Size   
* @param             Input Map of the key value 
* @param             Output Map for the key value 
*/
    
    public static Map<String, Object> checkJunctionObject(Map<String, Object> inputMap, Map<String, Object> outMap) {
        List<Plan_Relationship__c> juncRecordList = new List<Plan_Relationship__c>();
        String squoteId = (String) inputMap.get(CDHP_COMM2_Constants.CONTEXTID);
        if (!String.isEmpty(squoteId)) {
            juncRecordList = [SELECT Id, Qli2__c, QuoteId__c, Quote_Name__c, Type__c 
                              FROM Plan_Relationship__c 
                              where Qli2__c =: squoteId];
            Integer size = 0;
            size = juncRecordList.size();
            if (size > 1) {
                size = 2;
            } else {
                size = 1;
            }
            //outMap.put(CDHP_COMM2_Constants.JUNCTIONRECORDSIZE, size);
            outMap.put('junctionRecordSize', size);
        } else
            return outMap;
        return outMap;
    }
    
    /**
* @description       AddHRAHSAProduct1
* @param             Input Map of the key value 
* @param             Output Map for the key value 
*/
    
    public static Map<String, Object> addHRAHSAProduct1(Map<String, Object> inputMap, Map <String, Object> outMap) {
        QuoteLineItem actWiseQLI = new QuoteLineItem();
        Id quoteId12;
        String productType;
        List<QuoteLineItem> ParentPlanList = new List<QuoteLineItem>();
        Product2 pHRA = [Select Id, Name, QLIRecordType__c 
                         From Product2 
                         where IsActive = true and QLIRecordType__c =: CDHP_COMM2_Constants.ACTWISE_HRA
                         Limit 1
                        ];
        Product2 pHSA = [Select Id, Name, QLIRecordType__c From 
                         Product2 
                         where IsActive = true and QLIRecordType__c =: CDHP_COMM2_Constants.ACTWISE_HSA
                         Limit 1
                        ];
        Object rTMedical = inputMap.get(CDHP_COMM2_Constants.RTMEDICAL);
        Map<String, Object> rtMedicalMap = (Map<String, Object>) rTMedical;
        if (rtMedicalMap != null) {
            Object quoteLineDetails = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.QUOTELINEDETAILS);
            Map<String, Object> quoteLineDetailsMap = (Map<String, Object>) quoteLineDetails;
            if (quoteLineDetailsMap != null) {
                String recordType = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.RECORDTYPE);
                if (recordType != null)
                    actWiseQLI.RecordType__c = recordType;
                String oppType = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.OPPTYPE);
                if (oppType != null)
                    actWiseQLI.OppType__c = oppType;
                String funding = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.FUNDING);
                if (funding != null)
                    actWiseQLI.Funding__c = funding;
                String financing = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.FINANCING);
                if (financing != null)
                    actWiseQLI.Financing__c = financing;
                
                Object probBlock = (Map<String, Object>) quoteLineDetailsMap.get(CDHP_COMM2_Constants.PROBBLOCK);
                Map<String, Object> probBlockMap = (Map<String, Object>) probBlock;
                if (probBlockMap != null) {
                    String probability = (String) probBlockMap.get(CDHP_COMM2_Constants.PROBABILITY);
                    if (probability != null)
                        actWiseQLI.Probability__c = probability;
                }
                Decimal subscribers = (Decimal) quoteLineDetailsMap.get(CDHP_COMM2_Constants.SUBSCRIBERS);
                if (subscribers != null)
                    actWiseQLI.Subscribers__c = subscribers;
                Decimal members = (Decimal) quoteLineDetailsMap.get(CDHP_COMM2_Constants.MEMBERS);
                if (members != null)
                    actWiseQLI.Members__c = members;
                String reason = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.REASON);
                if (reason != null)
                    actWiseQLI.Reason__c = reason;
                
                Date termDate = (Date) quoteLineDetailsMap.get(CDHP_COMM2_Constants.TERMDATE);
                if (termDate != null)
                    actWiseQLI.TermDate__c = termDate;
                
                String renewedWithChanges = (String) quoteLineDetailsMap.get(CDHP_COMM2_Constants.RENEWEDWITHCHANGES);
                if (renewedWithChanges != null)
                    actWiseQLI.Renewed_with_Changes__c = renewedWithChanges;
                Date receivedDate = (Date) quoteLineDetailsMap.get(CDHP_COMM2_Constants.RECEIVEDDATE);
                if (receivedDate != null)
                    actWiseQLI.ReceivedDate__c = receivedDate;
            }
            Object cDHPAWHSA = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.CDHPAWHSA);
            Map<String, Object> cDHPAWHSAMap = (Map<String, Object>) cDHPAWHSA;
            if (cDHPAWHSAMap != null) {
                
                String adminFeeResp = (String) cDHPAWHSAMap.get(CDHP_COMM2_Constants.ADMINFEERESP);
                if (adminFeeResp != null)
                    actWiseQLI.Administrative_Fees_Responsibility__c = adminFeeResp;
                String benefitPeriod = (String) CDHPAWHSAMap.get(CDHP_COMM2_Constants.BENEFITPERIOD);
                if (benefitPeriod != null)
                    actWiseQLI.Benefit_Period__c = benefitPeriod;
                if (cDHPAWHSAMap.get(CDHP_COMM2_Constants.ACCUMRESETDATE) != null) {
                    Date accumResetDate = Date.valueOf((String) cDHPAWHSAMap.get(CDHP_COMM2_Constants.ACCUMRESETDATE));
                    if (accumResetDate != null)
                        actWiseQLI.Accum_Reset_Date__c = accumResetDate;
                }
            }
            Object cDHPHRA = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.CDHPHRA);
            Map<String, Object> cDHPHRAMap = (Map<String, Object>) cDHPHRA;
            if (cDHPHRAMap != null) {
                String hRAHIAAdministration = (String) cDHPHRAMap.get(CDHP_COMM2_Constants.HRAHIAADMINISTRATION);
                if (hRAHIAAdministration != null)
                    actWiseQLI.HRAHIAAdministration__c = hRAHIAAdministration;
                String hRABalanceTransfer = (String) cDHPHRAMap.get(CDHP_COMM2_Constants.HRABALANCETRANSFER);
                if (hRABalanceTransfer != null)
                    actWiseQLI.HRABalanceTransfer__c = hRABalanceTransfer;
                Boolean didClientPurchaseQUE = (Boolean) cDHPHRAMap.get(CDHP_COMM2_Constants.DIDCLIENTPURCHASEQUE);
                if (didClientPurchaseQUE != null)
                    actWiseQLI.DidClientPurchaseBariatricBuyup__c = didClientPurchaseQUE;
            }
            Object cDHPHSA = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.CDHPHSA);
            Map<String, Object> cDHPHSAMap = (Map<String, Object>) cDHPHSA;
            if (cDHPHSAMap != null) {
                
                String clientRemLITES = (String) cDHPHSAMap.get(CDHP_COMM2_Constants.CLIENTREMLITES);
                if (clientRemLITES != null)
                    actWiseQLI.Client_Remaining_on_LITES__c = clientRemLITES;
                String anthemSendEligPBM = (String) cDHPHSAMap.get(CDHP_COMM2_Constants.ANTHEMSENDELIGPBM);
                if (anthemSendEligPBM != null)
                    actWiseQLI.Anthem_Sends_Eligibility_to_PBM__c = anthemSendEligPBM;
            }
            
            String hSABP = (String) rtMedicalMap.get(CDHP_COMM2_Constants.HSABP);
            if (hSABP != null) {
                actWiseQLI.HSABankingPartner__c = hSABP;
                
            }
            String hSACP = (String) rtMedicalMap.get(CDHP_COMM2_Constants.HSACP);
            if (hSACP != null) {
                actWiseQLI.IfHSAdidClientPurchaseHSAPlus__c = hSACP;
                
            }
            
            Object pharmacyObj = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.PHARMACY);
            Map<String, Object> pharmacyMap = (Map<String, Object>) pharmacyObj;
            if (pharmacyMap != null) {
                Object medicalCDHPandMedicalCDHPWCIC = (Map<String, Object>) pharmacyMap.get(CDHP_COMM2_Constants.MEDICALCDHPANDMEDICALCDHPWCIC);
                Map<String, Object> medicalCDHPandMedicalCDHPWCICMap = (Map<String, Object>) medicalCDHPandMedicalCDHPWCIC;
                if (medicalCDHPandMedicalCDHPWCICMap != null) {
                    String pBMIntegrationType = (String) medicalCDHPandMedicalCDHPWCICMap.get(CDHP_COMM2_Constants.PBMINTEGRATIONTYPE);
                    if (pBMIntegrationType != null)
                        actWiseQLI.PBMIntegrationType__c = pBMIntegrationType;
                    String pharmacyIDCardDetails = (String) medicalCDHPandMedicalCDHPWCICMap.get(CDHP_COMM2_Constants.PHARMACYIDCARDDETAILS);
                    if (pharmacyIDCardDetails != null)
                        actWiseQLI.PharmacyIDCardDetails__c = pharmacyIDCardDetails;
                }
                Object pBMVendor_Block = (Map<String, Object> ) pharmacyMap.get(CDHP_COMM2_Constants.PBMVENDOR_BLOCK);
                Map<String, Object> pBMVendor_BlockMap = (Map<String, Object>) pBMVendor_Block;
                if (pBMVendor_BlockMap != null) {
                    String sPAccountId = (String) pBMVendor_BlockMap.get(CDHP_COMM2_Constants.SPACCOUNTID);
                    if (sPAccountId != null)
                        actWiseQLI.PBM_Vendor__c = sPAccountId;
                }
                Object medicalandMedicalWCIC = (Map<String, Object>) pharmacyMap.get(CDHP_COMM2_Constants.MEDICALANDMEDICALWCIC_BLOCK);
                Map<String, Object> medicalandMedicalWCICMap = (Map<String, Object>) medicalandMedicalWCIC;
                if (medicalandMedicalWCICMap != null) {
                    String medicalRXAccumulation = (String) medicalandMedicalWCICMap.get(CDHP_COMM2_Constants.MEDICALRXACCUMULATION);
                    if (medicalRXAccumulation != null)
                        actWiseQLI.MedicalRXAccumulation__c = medicalRXAccumulation;
                    String rXVendors = (String) medicalandMedicalWCICMap.get(CDHP_COMM2_Constants.RXVENDORS);
                    if (rXVendors != null)
                        actWiseQLI.RXVendors__c = rXVendors;
                }
                
            }
            Object networkBlockObj = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.NETWORKBLOCK);
            Map<String, Object> networkBlockMap = (Map<String, Object>) networkBlockObj;
            if (networkBlockMap != null) {
                String network = (String) networkBlockMap.get(CDHP_COMM2_Constants.NETWORK);
                if (network != null)
                    actWiseQLI.Network__c = network;
                String alternateNetwork = (String) networkBlockMap.get(CDHP_COMM2_Constants.ALTERNATENETWORK);
                if (alternateNetwork != null)
                    actWiseQLI.AlternateNetwork__c = alternateNetwork;
                String prefix = (String) networkBlockMap.get(CDHP_COMM2_Constants.PREFIX);
                if (prefix != null)
                    actWiseQLI.Prefix__c = prefix;
            }
            Object multipleProviderTieringObj = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.MULTIPLEPROVIDERTIERING);
            Map<String, Object> multipleProviderTieringMap = (Map<String, Object>) multipleProviderTieringObj;
            if (multipleProviderTieringMap != null) {
                String doesMultipleProviderTieringApply = (String) multipleProviderTieringMap.get(CDHP_COMM2_Constants.DOESMULTIPLEPROVIDERTIERINGAPPLY);
                if (doesMultipleProviderTieringApply != null)
                    actWiseQLI.DoesMultipleProviderTieringapply__c = doesMultipleProviderTieringApply;
            }
            Object aBA = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.ABA);
            Map<String, Object> aBAMap = (Map<String, Object> ) aBA;
            if (aBAMap != null) {
                String aBACovered = (String) aBAMap.get(CDHP_COMM2_Constants.ABACOVERED);
                if (aBACovered != null)
                    actWiseQLI.Is_Applied_Behavioral_Analysis_Covered__c = aBACovered;
                String preCertificationRequired = (String) aBAMap.get(CDHP_COMM2_Constants.PRECERTIFICATIONREQUIRED);
                if (preCertificationRequired != null)
                    actWiseQLI.Pre_Certification_Required_For_Analysis__c = preCertificationRequired;
                String purchasedASD = (String) aBAMap.get(CDHP_COMM2_Constants.PURCHASEDASD);
                if (purchasedASD != null)
                    actWiseQLI.Has_The_Client_Purchased_Autism_Disorder__c = purchasedASD;
            }
            Object fMHPBlockObj = (Map<String, Object> ) rtMedicalMap.get(CDHP_COMM2_Constants.FMHPBLOCK);
            Map<String, Object> fMHPBlockMap = (Map<String, Object>) fMHPBlockObj;            
            String fMHPUWReview = (String) rtMedicalMap.get(CDHP_COMM2_Constants.FMHPUWREVIEW);
            if (fMHPUWReview != null)
                actWiseQLI.Federal_Mental_Health_Parity_UW_Review__c = fMHPUWReview;
            String fMHPFI = (String) rtMedicalMap.get(CDHP_COMM2_Constants.FMHPFI);
            if (fMHPFI != null)
                actWiseQLI.Federal_Mental_Health_Parity_FI_Min_Prem__c = fMHPFI;
            String fMHPASO = (String) rtMedicalMap.get(CDHP_COMM2_Constants.FMHPASO);
            if (fMHPASO != null)
                actWiseQLI.Federal_Mental_Health_Parity_ASO__c = fMHPASO;
            Object setPLComplete = (Map<String, Object>) rtMedicalMap.get(CDHP_COMM2_Constants.SETPLCOMPLETE);
            Map<String, Object> setPLCompleteMap = (Map<String, Object>) setPLComplete;
            if (setPLCompleteMap != null) {
                Boolean pLComplete = (Boolean) setPLCompleteMap.get(CDHP_COMM2_Constants.PLCOMPLETE);
                if (pLComplete != null)
                    actWiseQLI.PLComplete__c = pLComplete;
            }
        }
        
        String planQLIID = (String) inputMap.get(CDHP_COMM2_Constants.PLANQLIID);
        Set<Id> parentQLIIdSet = new Set<Id>();
        Boolean isMedProduct = (Boolean) inputMap.get(CDHP_COMM2_Constants.ISMEDPRODUCT);
        if (isMedProduct == true) {
            List<Object> selectedPlansForAct = (List<Object>) inputMap.get(CDHP_COMM2_Constants.SELECTEDPLANSFORACT);
            if (selectedPlansForAct != null && !selectedPlansForAct.isEmpty()) {
                for (Object parentQLI: selectedPlansForAct) {
                    Map<String, Object> parentQLImap = (Map<String, Object>) parentQLI;
                    String parentQLIId = (String) parentQLImap.get(CDHP_COMM2_Constants.ID);
                    Boolean vlcSelected = (Boolean) parentQLImap.get(CDHP_COMM2_Constants.VLCSELECTED);
                    if (vlcSelected == true)
                        parentQLIIdSet.add(parentQLIId);
                }
                if (parentQLIIdSet != null) {
                    parentPlanList = [select id, QuoteId, OppType__c, quantity, unitprice, ActWiseChildQuote__c, Product2id 
                                      from QuoteLineItem
                                      where(id in: parentQLIIdSet) AND(ActWiseChildQuote__c =: null OR ActWiseChildQuote__c =: '')
                                     ];
                }
            }
        } else if (!String.isEmpty(planQLIID) && isMedProduct == false) {
            parentPlanList = [select id, QuoteId, OppType__c, quantity, unitprice, ActWiseChildQuote__c, Product2id 
                              from QuoteLineItem
                              where id =: planQLIID
                             ];
        }
        
        if (parentPlanList == null || parentPlanList.isEmpty())
            return outmap;
        Id pricebook;
        quoteId12 = parentPlanList[0].QuoteId;
        
        quote quote12 = new quote();
        quote12 = [select id, Pricebook2Id from quote where id =: quoteId12];
        if (parentPlanList != null) {
            
            if (parentPlanList[0].Product2id != null) {
                Product2 productDetail = [select id, name, QLIRecordType__c, Product_Type__c, Product_Family__c,
                                          vlocity_ins__AttributeDefaultValues__c 
                                          from product2 
                                          where id =: ParentPlanList[0].Product2id
                                         ];
                if (productDetail.vlocity_ins__AttributeDefaultValues__c != null && productDetail.vlocity_ins__AttributeDefaultValues__c != '') {
                    JSONParser parser = JSON.createParser((string) productDetail.vlocity_ins__AttributeDefaultValues__c);
                    while (parser.nextToken() != null) {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == CDHP_COMM2_Constants.OTHER_CDHPRODUCTTYPE)) {
                            // Get the value.
                            parser.nextToken();
                            String str = parser.getText();
                            if (str != null && str.containsIgnoreCase(CDHP_COMM2_Constants.HRA)) {
                                productType = CDHP_COMM2_Constants.HRA;
                                PricebookEntry pbeHRA = [SELECT Id, Name, Product2Id, Pricebook2Id, UseStandardPrice FROM PricebookEntry
                                                         where Product2Id =: pHRA.Id and Pricebook2Id =: quote12.Pricebook2Id
                                                        ];
                                pricebook = pbeHRA.Id;
                                actWiseQLI.Product2Id = pHRA.Id;
                            }
                            
                            if (str != null && str.containsIgnoreCase(CDHP_COMM2_Constants.HSA)) {
                                productType = CDHP_COMM2_Constants.HSA;
                                PricebookEntry pbeHSA = [SELECT Id, Name, Product2Id, Pricebook2Id, UseStandardPrice FROM PricebookEntry
                                                         where Product2Id =: pHSA.Id and Pricebook2Id =: quote12.Pricebook2Id
                                                        ];
                                pricebook = pbeHSA.Id;
                                actWiseQLI.Product2Id = pHSA.Id;
                            }
                            
                        }
                    }
                }
            }
        }
        String productStage = (String) inputMap.get(CDHP_COMM2_Constants.PRODUCTSTAGE);
        actWiseQLI.ProductStage__c = productStage;
        actWiseQLI.quoteId = quoteId12;
        actWiseQLI.PricebookEntryId = pricebook;
        actWiseQLI.Quantity = parentPlanList[0].quantity;
        actWiseQLI.UnitPrice = parentPlanList[0].unitprice;
        actWiseQLI.From_Act_Wise_Config__c = true;
        List<Plan_Relationship__c> junctionRecordList = new List<Plan_Relationship__c>();
        if (parentPlanList != null) {
            Database.SaveResult sr = Database.insert(actWiseQLI, false);
            if (sr.isSuccess()) {
                if (actWiseQLI.RecordType__c == CDHP_COMM2_Constants.ACTWISE_HRA)
                    createHRAAdminRec(sr.getId(), inputMap);
                for (QuoteLineItem qli: parentPlanList) {
                    Plan_Relationship__c junctionRecord = new Plan_Relationship__c();
                    qli.ActWiseChildQuote__c = sr.getId();
                    junctionRecord.Qli1__c = qli.Id;
                    junctionRecord.Qli2__c = sr.getId();
                    junctionRecord.Type__c = productType;
                    junctionRecordList.add(junctionRecord);
                    
                }
                update parentPlanList;
                insert junctionRecordList;
                
            } else {
                for (Database.Error err: sr.getErrors()) {
                    //System.debug('The following error has occurred.');                    
                    //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    //System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
        
        return outMap;
    }
    
    /**
* @description       createHRAAdminRec
* @param        Id  
* @param             Input Map of the key value
*/
    
    public static void createHRAAdminRec(Id actWiseId, Map < String, Object > inputMap) {
        try {
            
            HRA_Administration__c hraAdmin = new HRA_Administration__c();
            Object hRAA = inputMap.get(CDHP_COMM2_Constants.HRAA);
            Map<String, Object> hRAAMap = (Map<String, Object>) hRAA;
            if (hRAAMap != null) {
                Object hRAAR = (Map<String, Object>) hRAAMap.get(CDHP_COMM2_Constants.HRAAR);
                Map<String, Object> hRAARMap = (Map<String, Object>) hRAAR;
                if (hRAARMap != null) {
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRA1GROUPSUFFIX) != null) {
                        String hRA1GroupSuffix = (String) hRAARMap.get(CDHP_COMM2_Constants.HRA1GROUPSUFFIX);
                        if (hRA1GroupSuffix != null)
                            hraAdmin.HRA1_Group_Suffix__c = hRA1GroupSuffix;
                    }
                    if (Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.PLANSTARTDATE)) != null) {
                        Date planStartDate = Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.PLANSTARTDATE));
                        if (planStartDate != null)
                            hraAdmin.Plan_Start_Date__c = planStartDate;
                    }
                    if (Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.PLANENDDATE)) != null) {
                        Date planEndDate = Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.PLANENDDATE));
                        if (planEndDate != null)
                            hraAdmin.Plan_End_Date__c = planEndDate;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.TERMCANSUBMITCLAIMS) != null) {
                        String termCanSubmitClaims = (String) hRAARMap.get(CDHP_COMM2_Constants.TERMCANSUBMITCLAIMS);
                        if (termCanSubmitClaims != null)
                            hraAdmin.Terminated_can_submit_claims_for__c = termCanSubmitClaims;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.IFOTHERPLEASESPECIFY) != null) {
                        String ifOtherPleaseSpecify = (String) hRAARMap.get(CDHP_COMM2_Constants.IFOTHERPLEASESPECIFY);
                        if (ifOtherPleaseSpecify != null)
                            hraAdmin.If_Other_Please_Specify__c = ifOtherPleaseSpecify;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.BENACCUMULATION) != null) {
                        String benAccumulation = (String) hRAARMap.get(CDHP_COMM2_Constants.BENACCUMULATION);
                        if (benAccumulation != null)
                            hraAdmin.Benefit_Accumulations__c = benAccumulation;
                    }
                    Date accumResetDate = (Date) hRAARMap.get(CDHP_COMM2_Constants.ACCUMRESETDATE);
                    if (accumResetDate != null)
                        hraAdmin.Accum_Reset_Date__c = accumResetDate;
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAFUNDSPRORATEENTRYDATE) != null) {
                        String hRAFundsProRateEntryDate = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAFUNDSPRORATEENTRYDATE);
                        if (hRAFundsProRateEntryDate != null)
                            hraAdmin.HRA_Funds_Pro_Rate_on_Entry_Date__c = hRAFundsProRateEntryDate;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAFUNDSTOEEANDBASIS) != null) {
                        String hRAFundstoEEandBasis = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAFUNDSTOEEANDBASIS);
                        if (hRAFundstoEEandBasis != null)
                            hraAdmin.HRA_Funds_to_Employees_and_on_what_basis__c = hRAFundstoEEandBasis;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.ANNUALALLOCTIERS) != null) {
                        String annualAllocTiers = (String) hRAARMap.get(CDHP_COMM2_Constants.ANNUALALLOCTIERS);
                        if (annualAllocTiers != null)
                            hraAdmin.Annual_Allocation_Tiers__c = annualAllocTiers;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HEALTHACTIVITIESINCENTIVESB) != null) {
                        String healthActivitiesIncentivesB = (String) hRAARMap.get(CDHP_COMM2_Constants.HEALTHACTIVITIESINCENTIVESB);
                        if (healthActivitiesIncentivesB != null)
                            hraAdmin.Health_Activities_Incentives__c = healthActivitiesIncentivesB;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HEALTHINCENTIVETYPEB) != null) {
                        String healthIncentiveTypeB = (String) hRAARMap.get(CDHP_COMM2_Constants.HEALTHINCENTIVETYPEB);
                        if (healthIncentiveTypeB != null)
                            hraAdmin.Health_Incentive_Type__c = healthIncentiveTypeB;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEE) != null) {
                        Decimal allocEE = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEE);
                        if (allocEE != null)
                            hraAdmin.AllocationEE__c = allocEE;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEA) != null) {
                        Decimal allocEA = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEA);
                        if (allocEA != null)
                            hraAdmin.AllocationEA__c = allocEA;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCECHILD) != null) {
                        Decimal allocEChild = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCECHILD);
                        if (allocEChild != null)
                            hraAdmin.Allocation_EChild__c = allocEChild;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCECHILDREN) != null) {
                        Decimal allocEChildren = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCECHILDREN);
                        if (allocEChildren != null)
                            hraAdmin.AllocationEChildren__c = allocEChildren;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEFAMILY) != null) {
                        Decimal allocEFamily = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ALLOCEFAMILY);
                        if (allocEFamily != null)
                            hraAdmin.AllocationFamily__c = allocEFamily;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.TYPEOFHRA) != null) {
                        String typeofHRA = (String) hRAARMap.get(CDHP_COMM2_Constants.TYPEOFHRA);
                        if (typeofHRA != null)
                            hraAdmin.Type_of_HRA__c = typeofHRA;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.DEBITCARDSERVICES) != null) {
                        String debitCardServices = (String) hRAARMap.get(CDHP_COMM2_Constants.DEBITCARDSERVICES);
                        if (debitCardServices != null)
                            hraAdmin.Debit_Card_Services__c = debitCardServices;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAUPFRONTDED) != null) {
                        String hRAUpFrontDed = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAUPFRONTDED);
                        if (hRAUpFrontDed != null)
                            hraAdmin.HRA_Upfront_Deductible__c = hRAUpFrontDed;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.COVEREDSERVICES) != null) {
                        String coveredServices = (String) hRAARMap.get(CDHP_COMM2_Constants.COVEREDSERVICES);
                        if (coveredServices != null)
                            hraAdmin.Covered_Services__c = coveredServices;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.UPFRONTDEDTIERS) != null) {
                        String upFrontDedTiers = (String) hRAARMap.get(CDHP_COMM2_Constants.UPFRONTDEDTIERS);
                        if (upFrontDedTiers != null)
                            hraAdmin.Up_Front_Deductible_Tiers__c = upFrontDedTiers;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEE) != null) {
                        Decimal uFDEE = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEE);
                        if (uFDEE != null)
                            hraAdmin.UpfrontDedEE__c = uFDEE;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEA) != null) {
                        Decimal uFDEA = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEA);
                        if (uFDEA != null)
                            hraAdmin.UpFrontDedEA__c = uFDEA;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDECHILD) != null) {
                        Decimal uFDEChild = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDECHILD);
                        if (uFDEChild != null)
                            hraAdmin.UpfrontDedEChild__c = uFDEChild;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDECHILDREN) != null) {
                        Decimal uFDEChildren = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDECHILDREN);
                        if (uFDEChildren != null)
                            hraAdmin.UpFrontDedEEChildren__c = uFDEChildren;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEFAMILY) != null) {
                        Decimal uFDEFamily = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.UFDEFAMILY);
                        if (uFDEFamily != null)
                            hraAdmin.UpFrontDedFamily__c = uFDEFamily;
                    }
                    if ((Boolean) hRAARMap.get(CDHP_COMM2_Constants.HASINDDED) != null) {
                        Boolean hasIndDed = (Boolean) hRAARMap.get(CDHP_COMM2_Constants.HASINDDED);
                        if (hasIndDed != null)
                            hraAdmin.Has_Individual_Deductible__c = hasIndDed;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.INDDEDAMOUNT) != null) {
                        Decimal indDedAmount = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.INDDEDAMOUNT);
                        if (indDedAmount != null)
                            hraAdmin.Individual_Deductible_Amount__c = indDedAmount;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRASPLITPERCENT) != null) {
                        String hRASplitPercent = (String) hRAARMap.get(CDHP_COMM2_Constants.HRASPLITPERCENT);
                        if (hRASplitPercent != null)
                            hraAdmin.HRA_Split_Percentage__c = hRASplitPercent;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.MEMBERRESPBYCLAIM) != null) {
                        String memberRespByClaim = (String) hRAARMap.get(CDHP_COMM2_Constants.MEMBERRESPBYCLAIM);
                        if (memberRespByClaim != null)
                            hraAdmin.Member_Responsibility_by_Claim__c = memberRespByClaim;
                    }
                    if ((Double) hRAARMap.get(CDHP_COMM2_Constants.CUSTMEMCLAIMRESP) != null) {
                        Double custMemClaimResp = (Double) hRAARMap.get(CDHP_COMM2_Constants.CUSTMEMCLAIMRESP);
                        if (custMemClaimResp != null)
                            hraAdmin.Custom_Member_Responbsibility__c = custMemClaimResp;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.SPLITPERCENTCOVSVC) != null) {
                        String splitPercentCovSvc = (String) hRAARMap.get(CDHP_COMM2_Constants.SPLITPERCENTCOVSVC);
                        if (splitPercentCovSvc != null)
                            hraAdmin.Split_Percentage_Covered_Services__c = splitPercentCovSvc;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.NONSPLITCOVEREDSVC) != null) {
                        String nonSplitCoveredSvc = (String) hRAARMap.get(CDHP_COMM2_Constants.NONSPLITCOVEREDSVC);
                        if (nonSplitCoveredSvc != null)
                            hraAdmin.NonSplit_Covered_Services__c = nonSplitCoveredSvc;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.MEDICAL) != null) {
                        String medical = (String) hRAARMap.get(CDHP_COMM2_Constants.MEDICAL);
                        if (medical != null)
                            hraAdmin.Medical__c = medical;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.PHARMACYHRAADMIN) != null) {
                        String pharmacy = (String) hRAARMap.get(CDHP_COMM2_Constants.PHARMACYHRAADMIN);
                        if (pharmacy != null)
                            hraAdmin.Pharmacy__c = pharmacy;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.SPECIALTY) != null) {
                        String specialty = (String) hRAARMap.get(CDHP_COMM2_Constants.SPECIALTY);
                        if (specialty != null)
                            hraAdmin.Specialty__c = specialty;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVER) != null) {
                        String hRARollover = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVER);
                        if (hRARollover != null)
                            hraAdmin.HRA_Rollover__c = hRARollover;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVERFUNDSEXPIRE) != null) {
                        String hRARolloverFundsExpire = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVERFUNDSEXPIRE);
                        if (hRARolloverFundsExpire != null)
                            hraAdmin.Will_HRA_rollover_funds_ever_expire__c = hRARolloverFundsExpire;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.CLAIMRUNOUTDATE) != null) {
                        Date claimRunOutDate = Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.CLAIMRUNOUTDATE));
                        if (claimRunOutDate != null)
                            hraAdmin.Claim_Run_Out_Date__c = claimRunOutDate;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.DURINGCLAIMSRUNOUT) != null) {
                        String duringclaimsrunout = (String) hRAARMap.get(CDHP_COMM2_Constants.DURINGCLAIMSRUNOUT);
                        if (duringclaimsrunout != null)
                            hraAdmin.During_claims_run_out__c = duringclaimsrunout;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEE) != null) {
                        Decimal capEE = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEE);
                        if (capEE != null)
                            hraAdmin.CapEE__c = capEE;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVERTIMEPERIOD) != null) {
                        String hRARolloverTimePeriod = (String) hRAARMap.get(CDHP_COMM2_Constants.HRAROLLOVERTIMEPERIOD);
                        if (hRARolloverTimePeriod != null)
                            hraAdmin.HRA_Rollover_Time_Period__c = hRARolloverTimePeriod;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.ACTUALROLLOVERDATE) != null) {
                        Date actualRolloverDate = Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.ACTUALROLLOVERDATE));
                        if (actualRolloverDate != null)
                            hraAdmin.Actual_Rollover_Date__c = actualRolloverDate;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEA) != null) {
                        Decimal capEA = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEA);
                        if (capEA != null)
                            hraAdmin.CapEA__c = capEA;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPECHILD) != null) {
                        Decimal capEChild = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPECHILD);
                        if (capEChild != null)
                            hraAdmin.CapEChild__c = capEChild;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.MINROLLOVERAMOUNT) != null) {
                        Decimal minRolloverAmount = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.MINROLLOVERAMOUNT);
                        if (minRolloverAmount != null)
                            hraAdmin.Minimum_Rollover_Amount__c = minRolloverAmount;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPECHILDREN) != null) {
                        Decimal capEChildren = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPECHILDREN);
                        if (capEChildren != null)
                            hraAdmin.CapEChildren__c = capEChildren;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.EEFUNDSROLLVERNEXTPLANYEAR) != null) {
                        String eEFundsRollverNextPlanYear = (String) hRAARMap.get(CDHP_COMM2_Constants.EEFUNDSROLLVERNEXTPLANYEAR);
                        if (eEFundsRollverNextPlanYear != null)
                            hraAdmin.Employee_Funds_Rollover_Next_Plan_Year__c = eEFundsRollverNextPlanYear;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEFAMILY) != null) {
                        Decimal capEFamily = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.CAPEFAMILY);
                        if (capEFamily != null)
                            hraAdmin.CapEFamily__c = capEFamily;
                    }
                    if ((Decimal) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERPCTVALUE) != null) {
                        Decimal rolloverPctValue = (Decimal) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERPCTVALUE);
                        if (rolloverPctValue != null)
                            hraAdmin.Rollover_Percent_Value__c = rolloverPctValue;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERCAPTIERS) != null) {
                        String rolloverCapTiers = (String) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERCAPTIERS);
                        if (rolloverCapTiers != null)
                            hraAdmin.Rollover_Cap_Tiers__c = rolloverCapTiers;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERDIFFADMIN) != null) {
                        String rolloverDiffAdmin = (String) hRAARMap.get(CDHP_COMM2_Constants.ROLLOVERDIFFADMIN);
                        if (rolloverDiffAdmin != null)
                            hraAdmin.Rollover_Different_Admin__c = rolloverDiffAdmin;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRALITESROLLOVER) != null) {
                        String hRALITESRollover = (String) hRAARMap.get(CDHP_COMM2_Constants.HRALITESROLLOVER);
                        if (hRALITESRollover != null)
                            hraAdmin.HRA_LITES_Rollover__c = hRALITESRollover;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.HRALITESROLLOVERALLOCATION) != null) {
                        String hRALITESRolloverAllocation = (String) hRAARMap.get(CDHP_COMM2_Constants.HRALITESROLLOVERALLOCATION);
                        if (hRALITESRolloverAllocation != null)
                            hraAdmin.Group_Accumulators_And_HRA_Allocation__c = hRALITESRolloverAllocation;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.DESIREDROLLVERDATEFROMPREVHRA) != null) {
                        Date desiredRollverDateFromPrevHRA = Date.valueOf((String) hRAARMap.get(CDHP_COMM2_Constants.DESIREDROLLVERDATEFROMPREVHRA));
                        if (desiredRollverDateFromPrevHRA != null)
                            hraAdmin.Desired_Rollover_Date_Fund__c = desiredRollverDateFromPrevHRA;
                    }
                    if ((String) hRAARMap.get(CDHP_COMM2_Constants.PRIORTRUSTEE) != null) {
                        String priorTrustee = (String) hRAARMap.get(CDHP_COMM2_Constants.PRIORTRUSTEE);
                        if (priorTrustee != null)
                            hraAdmin.Prior_Trustee__c = priorTrustee;
                    }
                }
            }
            hraAdmin.QLI__c = actWiseId;
            insert hraAdmin;
        } catch (Exception ex) {
            system.debug('Error Occured: ' + ex);
        }
    }
    
    /**
* @description       isHRAorHSAPlanSelected
* @param             Input Map of the key value 
* @param             Output Map for the key value
*/
    
    public static Map<String, Object> isHRAorHSAPlanSelected(Map<String, Object> inputMap, Map<String, Object> outMap) {
        String scontextId = (String) inputMap.get('ContextId'); //0QL
        set<id> productIdSet = new set<id>();
        Map<id, QuoteLineItem> qliProductMap = new Map<id, QuoteLineItem>();
        String sIsHRAorHSAPlanSelected = CDHP_COMM2_Constants.NO;
        if(String.isEmpty(scontextId) || scontextId.equalsIgnoreCase('{0}'))
            return outMap;
        List<QuoteLineItem> qliObj = [Select Id, QuoteId, (select id, Product2Id, ActWiseChildQuote__c, Is_HSA_Selected_Plan__c 
                                                           from Quote_Line_Items__r) 
                                      From QuoteLineItem where Id =: scontextId];
        if(!qliObj.isEmpty()) {
            for(QuoteLineItem qli: qliObj[0].Quote_Line_Items__r) {
                if(qli.ActWiseChildQuote__c == null) {
                    productIdSet.add(qli.Product2id); // Adding related parent product id to the set
                    qliProductMap.put(qli.Product2id, qli);
                }
            }
        }
        if(productIdSet.size() <= 0 || productIdSet == null) {
            outMap.put('sIsHRAorHSAPlanSelected', sIsHRAorHSAPlanSelected);
            return outMap;
        }
        List<Product2> productDetailList = [select id, name, QLIRecordType__c, Product_Type__c, Product_Family__c,
                                            vlocity_ins__AttributeDefaultValues__c 
                                            from product2 
                                            where id in: productIdSet
                                           ];
        for(Product2 p: productDetailList){
            
            QuoteLineItem qli = new QuoteLineItem();
            qli = qliProductMap.get(p.id);
            if(!String.isEmpty(p.vlocity_ins__AttributeDefaultValues__c)) {
                JSONParser parser = JSON.createParser((string) p.vlocity_ins__AttributeDefaultValues__c);
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'OTHER_cdhProductType')) {
                        parser.nextToken();
                        String str = parser.getText();
                        if (str != null && str.containsIgnoreCase('HRA') && 'No'.equalsIgnoreCase(sIsHRAorHSAPlanSelected)) {
                            sIsHRAorHSAPlanSelected = CDHP_COMM2_Constants.YES;
                            break;
                        } else if (str != null && str.containsIgnoreCase('HSA') && 'No'.equalsIgnoreCase(sIsHRAorHSAPlanSelected) && qli.Is_HSA_Selected_Plan__c == true) {
                            sIsHRAorHSAPlanSelected = CDHP_COMM2_Constants.YES;
                            break;
                        }
                    }
                }
            }
            if(sIsHRAorHSAPlanSelected == CDHP_COMM2_Constants.YES)
                break;
            
        }
        outMap.put('sIsHRAorHSAPlanSelected', sIsHRAorHSAPlanSelected);
        
        return outMap;
    }
    
    /**
	* @description       isPermissionSetAssigned method checks if user has the PermissionSet 'HRAHSAPermissionSet'.
	* @param             Input Map of the key value 
	* @param             Output Map for the key value
	*/
    
    public static Map<String, Object> isPermissionSetAssigned(Map<String, Object> inputMap, Map<String, Object> outMap) {
        String sisPermissionSetAssigned = CDHP_COMM2_Constants.NO;
        User Usr = new User();
        Usr = [SELECT Phone, Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        for (PermissionSetAssignment p: [select PermissionSet.Name 
                                         from PermissionSetAssignment 
                                         where Assignee.Id =: Usr.Id order by PermissionSet.Name]) {
            if (p.PermissionSet.Name == CDHP_COMM2_Constants.HRAHSAPERMISSIONSET) {
                sisPermissionSetAssigned = CDHP_COMM2_Constants.YES;
            }
        }
        outMap.put('sisPermissionSetAssigned', sisPermissionSetAssigned);
        
        return outMap;
    }
    public class OtherException extends Exception {}
}