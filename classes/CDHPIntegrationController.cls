/**
 * @author Santosh Gudge
 * @date 05/7/19
 *
 * @description Contains the logic for integrating CDHP Questionnaires between ISG and COM2
 */
public with sharing class CDHPIntegrationController {
    Public Static boolean allow = true;
    public String QlineItemId;
    private static final String NATIONAL_ACCOUNTS = 'National Accounts';
    private static final String LOCAL_LARGE_GROUP = 'Local/Large Group';
    List <CDHPISGRestAPIClient.HRAProductDetails> CDHPHRAProdDetails;
    CDHPISGRestAPIClient.quoteDetails quoteDtls = new CDHPISGRestAPIClient.quoteDetails(); //Added by Suresh
    Map <String, List <CDHPISGRestAPIClient.ProductDetails>> prodDt = new Map <String, List <CDHPISGRestAPIClient.ProductDetails>> (); //Added by Suresh
    Map <String, List <CDHPISGRestAPIClient.HRAProductDetails>> hraDetails = new Map <String, List <CDHPISGRestAPIClient.HRAProductDetails>> (); //Added by Suresh
    Map <String, List <CDHPISGRestAPIClient.ContactDetails>> cntDetails = new Map <String, List <CDHPISGRestAPIClient.ContactDetails>> (); //Added by Suresh
    Set <ID> quoteIDS = new Set <ID> ();

    /**
     * @description Stops trigger from running
     * @return void
     */
    public static void stopTrigger() {
        allow = false;
    }
    /**
     * @description Determines if trigger can run
     * @return boolean indicating whether or not the trigger can run
     */
    public static boolean canIRun() {
        return allow;
    }

    /**
     * @description Sends CDHP Details to ISG using a REST API call
     * @param quoteId ID of the Quote related to CDHP Details
     * @param optiId ID of the Opportunity related to CDHP Details
     * @return void
     */
    @future(callout = true)
    public static void SendCDHPDetailsToISG(String quoteId, String optiId) {
        try {
            stopTrigger();
            String access_token; //PRDCRM 34415
            String instance_url; //PRDCRM 34415
            CDHPIntegrationController CDHPIntegrationController = new CDHPIntegrationController();
            CDHPISGRestAPIClient.CDHPFields cdhpFlds = CDHPIntegrationController.PrepareCDHFieldForRESTAPI(quoteId, optiId);
            CDHPISGRestAPIClient.CDHPFields cdhpRetFields = CDHPISGRestAPIClient.createCDHPInISG(instance_url, access_token, cdhpFlds);
            TriggerHelperUtility.setStopTrigger();
            UpdateOpportunityRecord(optiId, cdhpRetFields.StatusDetails.cdhpQuoteIDS, cdhpRetFields.StatusDetails.Status, cdhpRetFields.StatusDetails.StatusMessage);
            TriggerHelperUtility.clearStopTrigger();
        } catch (exception ex) {
            system.debug('Error: ' + ex);
        }
    }

    /**
     * @description Updates an Opportunity associated with a CDHP Questionnaire
     * @param optiId ID of the Opportunity to be updated
     * @param cdhParentId A Map containing the IDs of CDHP Questionnaires
     * @param status The CDHP Questionnaire's status
     * @param statusMessage The message in the CDHP Questionnaire's status
     * @return void
     */
    public static void UpdateOpportunityRecord(String optiId, Map <String, String> cdhParentId, String status, String statusMessage) {
        //Get the details from CDHP Parent object
        Quote quoteRec;
        List <Quote> quoteLst = new List <Quote> ();

        try {
            for (Quote qt: [Select Id, CDHP_SF_Id_From_ISG__c from Quote where Id in: cdhParentId.keySet()]) {
                qt.CDHP_SF_Id_From_ISG__c = cdhParentId.get(qt.Id);
                quoteLst.add(qt);
            }
            update quoteLst;
        } catch (Exception e) {
            System.debug('Exception occured while fetching CDHP details - ' + e.getMessage());
        }
    }
    /**
     * @description Prepares CDHP Details for a REST API call
     * @param quoteId ID of the Quote related to CDHP Details
     * @param optiId ID of the Opportunity related to CDHP Details
     * @return The CDHP Details
     */
    public CDHPISGRestAPIClient.CDHPFields PrepareCDHFieldForRESTAPI(String quoteId, String optiId) {
        CDHPISGRestAPIClient.CDHPFields cdhpFldsObj = new CDHPISGRestAPIClient.CDHPFields();
        List <CDHPISGRestAPIClient.ContactDetails> CDHPConDetails = new List <CDHPISGRestAPIClient.ContactDetails> ();
        //Added by Suresh 
        CDHPISGRestAPIClient.OpportunityDetails oppDetails = GetOpportunityDetails(optiId);
        CDHPISGRestAPIClient.GroupDetails grpDetails = GetGroupDetails(optiId);
        List <CDHPISGRestAPIClient.ProductDetails> prodDetails = GetQuoteLineItems(quoteId); //Added - 38037, 38416
        CDHPConDetails = GetContactDetails(grpDetails.SFAccountId);
        CDHPConDetails = GetBrokerDetails(grpDetails.SFAccountId, CDHPConDetails);
        CDHPISGRestAPIClient.UserDetails userDetails = getUserDetails();



        for (ID ids: quoteIDS) {

            CDHPISGRestAPIClient.CDHPFields cdhpVar = new CDHPISGRestAPIClient.CDHPFields();
            cdhpVar.ORGName = 'COM2';
            cdhpVar.OpportunityDetails = oppDetails;
            cdhpVar.GroupDetails = grpDetails;


            if (prodDt.containsKey(ids) && prodDt.get(ids) != null) {
                cdhpVar.ProductDetails = prodDt.get(ids);
            }

            if (hraDetails.containsKey(ids) && hraDetails.get(ids) != null) {
                cdhpVar.HRAProductDetails = hraDetails.get(ids);
            }
            cdhpVar.ContactDetails = CDHPConDetails;
            cdhpVar.UserDetails = userDetails;

            cdhpFldsObj.quoteProdHRA.put(ids, cdhpVar);



        }
        //End - Added by Suresh 
        return cdhpFldsObj;
    }
    /**
     * @description Obtains the details of a broker
     * @param accntId ID of the Account related to broker
     * @param CDHPConDetails A List of contact details on CDHP Questionnaires
     * @return A List of contact details related to a broker
     */
    public List <CDHPISGRestAPIClient.ContactDetails> GetBrokerDetails(String accntId, List <CDHPISGRestAPIClient.ContactDetails> CDHPConDetails) {
        List <Brokerage_and_Consultant__c> contactsLst;
        try {
            contactsLst = [SELECT Consultant__r.FirstName__c, Consultant__r.LastName__c, Id, NameofBrokerage__c, BrokerageState__c,
                ConsultantEmail__c, ConsultantPhone__c, NameofConsultant__c, Consultant_Name__c FROM Brokerage_and_Consultant__c
                WHERE Account__c =: accntId
            ];
            for (Brokerage_and_Consultant__c cnt: contactsLst) {
                CDHPISGRestAPIClient.ContactDetails conDetails = new CDHPISGRestAPIClient.ContactDetails();
                conDetails.AgencyName = cnt.NameofBrokerage__c;
                conDetails.LastName = cnt.Consultant__r.LastName__c;
                conDetails.FirstName = cnt.Consultant__r.FirstName__c;
                conDetails.eMail = cnt.ConsultantEmail__c;
                conDetails.BrokerState = cnt.BrokerageState__c;
                conDetails.Phone = cnt.ConsultantPhone__c;
                conDetails.Type = 'Broker';
                conDetails.Name = cnt.Consultant_Name__c; // Added by Michael regarding story 27084
                CDHPConDetails.add(conDetails);
            }

        } catch (Exception e) {
            System.debug('Exception occured while fetching Brokerage_and_Consultant details - ' + e.getMessage());
            return null;
        }
        return CDHPConDetails;
    }

    /**
     * @description Obtains the details of a contact
     * @param accntId ID of the Account related to contact
     * @return A List of contact details related to a contact
     */
    public List <CDHPISGRestAPIClient.ContactDetails> GetContactDetails(String accntId) {
        //Get the details from CDHP Parent object
        List <Contact> contactsLst;
        List <CDHPISGRestAPIClient.ContactDetails> CDHPConDetails = new List <CDHPISGRestAPIClient.ContactDetails> ();
        try {
            contactsLst = [SELECT Id, FirstName, LastName, Phone, Email, Primary_Contact__c, IsActive1__c from Contact Where AccountId =: accntId];
            for (Contact cnt: contactsLst) {
                CDHPISGRestAPIClient.ContactDetails conDetails = new CDHPISGRestAPIClient.ContactDetails();
                conDetails.FirstName = cnt.FirstName;
                conDetails.LastName = cnt.LastName;
                conDetails.eMail = cnt.Email;
                conDetails.Phone = cnt.Phone;
                conDetails.Type = 'Customer';
                conDetails.IsPrimary = cnt.Primary_Contact__c;
                conDetails.IsActive = cnt.IsActive1__c;
                CDHPConDetails.add(conDetails);
            }

        } catch (Exception e) {
            System.debug('Exception occured while fetching CDHP details - ' + e.getMessage());
            return null;
        }
        return CDHPConDetails;
    }

    /**
     * @description Obtains the details of a group
     * @param optyId ID of the Opportunity related to group
     * @return Group details related to Opportunity
     */
    public CDHPISGRestAPIClient.GroupDetails GetGroupDetails(String optyId) {
        CDHPISGRestAPIClient.GroupDetails CDHPGroupDetails = new CDHPISGRestAPIClient.GroupDetails();
        Opportunity opty;
        List <Group__c> grp;
        try {
            opty = [SELECT Id, Account.Name, Account.Anthem_Entity__c, Account.Situs_State_Abbrev__c, OpportunityRecordTypeName__c, Account.Id, Account.Branding__c, Account.Eligible_Employees__c, Account.Tax_ID__c from Opportunity Where Id =: optyId];
            CDHPGroupDetails.EmployerName = opty.Account.Name;
            CDHPGroupDetails.SFAccountId = opty.Account.Id;
            CDHPGroupDetails.TaxId = opty.Account.Tax_ID__c;
            grp = [SELECT Id, Name from Group__c where Account__c =: opty.Account.Id];
            if (grp != null && grp.size() > 0) {
                CDHPGroupDetails.EmployerIdCaseNumber = grp[0].Name;
            }
            CDHPGroupDetails.NumberOfEligibleEmpl = opty.Account.Eligible_Employees__c;
            CDHPGroupDetails.Brand = opty.Account.Branding__c;
            //Added - PRDCRM-43498
            if (opty.Account.Anthem_Entity__c == NATIONAL_ACCOUNTS)
                CDHPGroupDetails.segmentInformation = 'ANA';
            else if (opty.Account.Anthem_Entity__c == LOCAL_LARGE_GROUP && opty.Account.Situs_State_Abbrev__c != null)
                CDHPGroupDetails.segmentInformation = opty.Account.Situs_State_Abbrev__c;
            // End - PRDCRM-43498

        } catch (Exception e) {
            System.debug('Exception occured while fetching  Group details*** - ' + e.getMessage());
            return null;
        }
        return CDHPGroupDetails;
    }

    /**
     * @description Obtains the details of a user
     * @return User details
     */
    public CDHPISGRestAPIClient.UserDetails getUserDetails() {
        CDHPISGRestAPIClient.UserDetails UserDetails = new CDHPISGRestAPIClient.UserDetails();
        User userInfoDetails;
        try {
            userInfoDetails = [SELECT Id, FirstName, LastName, Email, FederationIdentifier, Profile.Name from User Where Id =: UserInfo.getUserId()];
            UserDetails.FirstName = userInfoDetails.FirstName;
            UserDetails.LastName = userInfoDetails.LastName;
            UserDetails.eMail = userInfoDetails.Email;
            UserDetails.USDomainId = userInfoDetails.FederationIdentifier;
            UserDetails.UserRole = userInfoDetails.Profile.Name;

        } catch (Exception e) {
            System.debug('Exception occured while fetching CDHP details - ' + e.getMessage());
            return null;
        }
        return UserDetails;

    }

    /**
     * @description Obtains the details of an Opportunity
     * @param optyId ID of the Opportunity
     * @return Opportunity details
     */
    public CDHPISGRestAPIClient.OpportunityDetails GetOpportunityDetails(String optyId) {
        CDHPISGRestAPIClient.OpportunityDetails CDHPOptyDetails = new CDHPISGRestAPIClient.OpportunityDetails();
        Opportunity opty;
        try {
            opty = [SELECT Id, Name, CloseDate, OpportunityRecordTypeName__c, StageName, Owner.Name from Opportunity Where Id =: optyId];
            CDHPOptyDetails.SFORGOpportunityId = opty.Id;
            CDHPOptyDetails.OptyEffectiveDate = opty.CloseDate;
            CDHPOptyDetails.OptyName = opty.Name;
            CDHPOptyDetails.OptyRecordType = opty.OpportunityRecordTypeName__c;
            CDHPOptyDetails.StageName = opty.StageName;
            CDHPOptyDetails.OpportunityOwner = opty.Owner.Name;

        } catch (Exception e) {
            System.debug('Exception occured while fetching CDHP details - ' + e.getMessage());
            return null;
        }
        return CDHPOptyDetails;
    }
    /**
     * @description Obtains the Product details from the Quote Line Items on a Quote
     * @param quoteId ID of the Quote related to QLIs
     * @return A list of the Product details from the Quote Line Items
     */
    public List <CDHPISGRestAPIClient.ProductDetails> GetQuoteLineItems(String quoteId) {
        //Get the details from CDHP Parent object
        List <QuoteLineItem> qtLineItems;
        List <CDHPISGRestAPIClient.ProductDetails> CDHPProdDetails = new List <CDHPISGRestAPIClient.ProductDetails> ();
        CDHPHRAProdDetails = new List <CDHPISGRestAPIClient.HRAProductDetails> ();
        try {
            qtLineItems = [SELECT Id, HRA_Payment_Type__c, ClientName__c, ProductName__c, Product2.Product_Family__c,
                Parking_Plan_Option__c,
                Transit_Plan_Option__c, FSA_Plan_End_Date__c,
                OpportunityEffectiveDate__c,
                QuoteId, Funding__c, Financing__c, Subscribers__c, Quote.GroupNumber__c, FSA_Plan_Options__c,
                HSABankingPartner__c, PLComplete__c,
                RecordType__c
                from QuoteLineItem Where QuoteId =: quoteId and Product2.QLIRecordType__c like '%ActWise%'
                AND(ProductStage__c = 'Sold'
                    or ProductStage__c = 'Renewed'
                    or ProductStage__c = 'IGAP Sold')
                AND PLComplete__c = TRUE
            ];
            
            for (QuoteLineItem qtItem: qtLineItems) {
                CDHPISGRestAPIClient.ProductDetails prodDetails = new CDHPISGRestAPIClient.ProductDetails();
                prodDetails.EmployerId_CaseNumber = qtItem.Quote.GroupNumber__c;
                prodDetails.QuoteId = qtItem.QuoteId;
                quoteIDS.add(qtItem.QuoteId);
                if (qtItem.RecordType__c == 'ActWise HRA') {
                    prodDetails.HRA_Account_Type = true;
                    QlineItemId = qtItem.Id;

                    CDHPHRAProdDetails.add(GetHRADetails(qtItem.Id));
                } else if (qtItem.RecordType__c == 'ActWise HSA') {
                    prodDetails.HSA_Account_Type = true;
                } else if (qtItem.RecordType__c == 'ActWise FSA') {
                    prodDetails.FSA_Account_Type = true;
                    String[] tmpString = qtItem.FSA_Plan_Options__c.split(';');
                    if (tmpString != null) {
                        for (String pvalue: tmpString) {
                            if (pvalue == 'Limited Purpose FSA Plan')
                                prodDetails.Limited_Purpose_FSA_Plan = true;
                            if (pvalue == 'Dependent Care FSA Plan')
                                prodDetails.Dependent_Care_FSA_Plan = true;
                            if (pvalue == 'FSA Section 213d Plan')
                                prodDetails.FSA_Section_213_d_Plan = true;
                        }
                    }
                    prodDetails.FSA_Plan_Start_Date = qtItem.OpportunityEffectiveDate__c;
                    prodDetails.FSA_Plan_End_Date = qtItem.FSA_Plan_End_Date__c;
                } else if (qtItem.RecordType__c == 'ActWise Commuter') {
                    prodDetails.Commuter_Account_Type = true;
                }
                prodDetails.FSAPlan = '';
                prodDetails.SFORGQuoteLineId = qtItem.Id;
                prodDetails.ProdName = qtItem.ProductName__c;
                prodDetails.Funding = qtItem.Funding__c;
                prodDetails.Financing = qtItem.Financing__c;
                prodDetails.Transit_Plan_Option = qtItem.Transit_Plan_Option__c;
                prodDetails.Parking_Plan_Option = qtItem.Parking_Plan_Option__c;

                if (qtItem.HSABankingPartner__c != null)
                    prodDetails.HSA_Custodian = qtItem.HSABankingPartner__c; //'UMB';//qtItem.HSA_Custodian__c; //'PNC';
                prodDetails.HRA_Plan_Start_Date = qtItem.OpportunityEffectiveDate__c;
                prodDetails.Estimated_Number_of_Participants = String.valueOf(qtItem.Subscribers__c);
                CDHPProdDetails.add(prodDetails);

                //Added by Suresh
                if (prodDt.containsKey(qtItem.QuoteId) && prodDt.get(qtItem.QuoteId) != null) {
                    List <CDHPISGRestAPIClient.ProductDetails> prodDtls = prodDt.get(qtItem.QuoteId);
                    prodDtls.add(prodDetails);
                    prodDt.put(qtItem.QuoteId, prodDtls);
                } else {
                    List <CDHPISGRestAPIClient.ProductDetails> prodDtls = new List <CDHPISGRestAPIClient.ProductDetails> ();
                    prodDtls.add(prodDetails);
                    prodDt.put(qtItem.QuoteId, prodDtls);
                }

                // End - Added by Suresh
            }


        } catch (Exception e) {
            System.debug('Exception occured while fetching Qoute line item details*** - ' + e.getMessage());
            return null;
        }
        return CDHPProdDetails;
    }

    /**
     * @description Obtains the HRA Product details from a Quote Line Item
     * @param QlineItemId ID of the QLI
     * @return The HRA Product details from the Quote Line Item
     */
    public CDHPISGRestAPIClient.HRAProductDetails GetHRADetails(String QlineItemId) {
        HRA_Administration__c HRAAdmin;
        CDHPISGRestAPIClient.HRAProductDetails HRAProdDetails = new CDHPISGRestAPIClient.HRAProductDetails();
        try {
            HRAAdmin = [SELECT Account_Effective_Date_Plus_X__c, Desired_Rollover_Date_Fund__c, During_claims_run_out__c, Group_Accumulators_And_HRA_Allocation__c, Will_HRA_rollover_funds_ever_expire__c,
                Id, QLI__c, HRA1_Group_Suffix__c, CapEE__c, CapEA__c, CapEChild__c, CapEChildren__c, CapEFamily__c, AllocationEA__c, If_Other_Please_Specify__c,
                Allocation_EChild__c, AllocationEChildren__c, AllocationEE__c, AllocationFamily__c, Annual_Allocation_Tiers__c, Claim_Run_Out_Date__c,
                Debit_Card_Services__c, Has_Individual_Deductible__c, Rollover_Percent_Value__c, Employee_Funds_Rollover_Next_Plan_Year__c,
                HRA_Funds_to_Employees_and_on_what_basis__c, HRA_Funds_Pro_Rate_on_Entry_Date__c, Health_Activities_Incentives__c, Health_Incentive_Type__c,
                Individual_Deductible_Amount__c, Rollover_Cap_Tiers__c, Member_Responsibility_by_Claim__c, Minimum_Rollover_Amount__c,
                Specialty__c, Covered_Services__c, Medical__c, HRA_Rollover__c, HRA_Rollover_Time_Period__c, Terminated_can_submit_claims_for__c,
                Rollover_Different_Admin__c, UpfrontDedEE__c, UpFrontDedEA__c, UpfrontDedEChild__c, UpFrontDedEEChildren__c,
                UpFrontDedFamily__c, Up_Front_Deductible_Tiers__c, Plan_End_Date__c, Plan_Start_Date__c, Custom_Member_Responbsibility__c, Rx_Debit_card__c, HRA_Lites_Rollover__c, Type_of_HRA__c, HRA_Split_Percentage__c, QLI__r.QuoteId,
                HRA_Upfront_Deductible__c, Split_Percentage_Covered_Services__c, NonSplit_Covered_Services__c, Pharmacy__c, QLI__r.ProductName__c FROM HRA_Administration__c Where QLI__c =: QlineItemId
            ];
            if (HRAAdmin != null) {
                HRAProdDetails.HRA_Plan_End_Date = HRAAdmin.Plan_End_Date__c;
                HRAProdDetails.HRA_Plan_Start_Date = HRAAdmin.Plan_Start_Date__c;
                HRAProdDetails.HRA1_Group_Suffix = HRAAdmin.HRA1_Group_Suffix__c;
                HRAProdDetails.HRA_Ann_Roll_Cap_Amt_Emp = HRAAdmin.CapEE__c;
                HRAProdDetails.HRA_Ann_Roll_Cap_Amt_Emp_Adult = HRAAdmin.CapEA__c;
                HRAProdDetails.HRA_Ann_Roll_Cap_Amt_Emp_Child = HRAAdmin.CapEChild__c;
                HRAProdDetails.HRA_Ann_Roll_Cap_Amt_Emp_Children = HRAAdmin.CapEChildren__c;
                HRAProdDetails.HRA_Ann_Roll_Cap_Amt_Family = HRAAdmin.CapEFamily__c;
                HRAProdDetails.HRA_Annual_Alloc_Amt_Emp_Adult = HRAAdmin.AllocationEA__c;
                HRAProdDetails.HRA_Annual_Alloc_Amt_Emp_Child = HRAAdmin.Allocation_EChild__c;
                HRAProdDetails.HRA_Annual_Alloc_Amt_Emp_Children = HRAAdmin.AllocationEChildren__c;
                HRAProdDetails.HRA_Annual_Alloc_Amt_Employee = HRAAdmin.AllocationEE__c;
                HRAProdDetails.HRA_Annual_Alloc_Amt_Family = HRAAdmin.AllocationFamily__c;
                HRAProdDetails.HRA_Annual_Allocation_Tier_Selection = HRAAdmin.Annual_Allocation_Tiers__c;
                HRAProdDetails.HRA_Claim_Run_Out_Date = HRAAdmin.Claim_Run_Out_Date__c;
                HRAProdDetails.SF_Quote_Item_Id = QlineItemId;
                HRAProdDetails.Account_Effective_Date_Plus_X = HRAAdmin.Account_Effective_Date_Plus_X__c; //HRARolloverFields
                HRAProdDetails.Desired_Rollover_Date_Fund = HRAAdmin.Desired_Rollover_Date_Fund__c;
                HRAProdDetails.During_claims_run_out = HRAAdmin.During_claims_run_out__c;
                HRAProdDetails.Group_Accumulators_And_HRA_Allocation = HRAAdmin.Group_Accumulators_And_HRA_Allocation__c;
                HRAProdDetails.Will_HRA_rollover_funds_ever_expire = HRAAdmin.Will_HRA_rollover_funds_ever_expire__c;
                HRAProdDetails.HRA_LITES_Rollover = HRAAdmin.HRA_LITES_Rollover__c;



                if (HRAAdmin.Debit_Card_Services__c != null) {
                    String[] tmpString = HRAAdmin.Debit_Card_Services__c.split(';');

                    if (tmpString != null) {
                        for (String pvalue: tmpString) {
                            if (pvalue == 'Dental')
                                HRAProdDetails.HRA_Debit_Card_Dental_Services = true;
                            if (pvalue == 'Medical')
                                HRAProdDetails.HRA_Debit_Card_Medical_Services = true;
                            if (pvalue == 'OTC')
                                HRAProdDetails.HRA_Debit_Card_OTC_Services = true;
                            if (pvalue == 'Pharmacy') // Added - PRDCRM-27085
                                HRAProdDetails.HRA_Debit_Card_Rx_Services = true;
                            if (pvalue == 'Vision')
                                HRAProdDetails.HRA_Debit_Card_Vision_Services = true;
                        }
                    }
                }
                HRAProdDetails.HRA_Embedded_Ded = HRAAdmin.Has_Individual_Deductible__c;
                HRAProdDetails.HRA_Employee_Funds_Rollover_Amounts = HRAAdmin.Rollover_Percent_Value__c;
                HRAProdDetails.HRA_Employee_Funds_Rollover_Options = HRAAdmin.Employee_Funds_Rollover_Next_Plan_Year__c;
                HRAProdDetails.HRA_Fund_Allocation = HRAAdmin.HRA_Funds_to_Employees_and_on_what_basis__c;
                HRAProdDetails.HRA_Funding_Pro_Rate = HRAAdmin.HRA_Funds_Pro_Rate_on_Entry_Date__c;
                HRAProdDetails.HRA_Health_Activities = HRAAdmin.Health_Activities_Incentives__c;
                HRAProdDetails.HRA_Health_Activities_Options = HRAAdmin.Health_Incentive_Type__c;
                HRAProdDetails.HRA_Individual_Embedded_Ded_Amt = HRAAdmin.Individual_Deductible_Amount__c;
                HRAProdDetails.HRA_Max_Rollover_Amt_Cap_Tier = HRAAdmin.Rollover_Cap_Tiers__c;
                HRAProdDetails.HRA_Member_Responsibility_by_Claim = HRAAdmin.Member_Responsibility_by_Claim__c;
                HRAProdDetails.HRA_Min_Rollover_Amt = HRAAdmin.Minimum_Rollover_Amount__c;
                if (HRAAdmin.Type_of_HRA__c == 'Provider Pay Medical with Optional Rx/Dental/Vision Debit Card')
                    HRAProdDetails.HRA_Prov_Pay_Med_w_Opt_Rx_Den_Vis_Deb_Cd = true; //E2

                if (HRAAdmin.Type_of_HRA__c == 'Member Pay (debit card) Only')
                    HRAProdDetails.Member_Pay_HRA_with_Debit_Card = true; //E1
                if (HRAAdmin.HRA_Upfront_Deductible__c == 'Yes')
                    HRAProdDetails.Prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay = true;
                HRAProdDetails.Offer_Rx_debit_Card = HRAAdmin.Rx_Debit_card__c; //E3
                if (HRAAdmin.HRA_Split_Percentage__c == 'Yes')
                    HRAProdDetails.Provider_Pay_Split_HRA = true; //E4

                system.debug('HRAAdmin.Type_of_HRA__c:' + HRAAdmin.Type_of_HRA__c);
                if (HRAAdmin.Type_of_HRA__c == 'Auto-Pay Provider Only' && HRAAdmin.HRA_Upfront_Deductible__c == 'NO' &&
                    HRAAdmin.HRA_Split_Percentage__c == 'No') {
                    HRAProdDetails.HRA_Provider_Pay = true; //E5
                }


                if (HRAAdmin.Specialty__c != null)
                    HRAProdDetails.HRA_ProvPay_Opt_DebCd_Dental_Option = true;
                // fix US-32172/US-32174/US-32169 starts

                String[] coveredServices = new String[] {};
                if (HRAAdmin.Type_of_HRA__c == 'Auto-Pay Provider Only' || HRAAdmin.Type_of_HRA__c == 'Provider Pay Medical with Optional Rx/Dental/Vision Debit Card') {
                    if (HRAAdmin.Covered_Services__c != null)
                        coveredServices = HRAAdmin.Covered_Services__c.split(';');
                    if (HRAAdmin.HRA_Upfront_Deductible__c == 'Yes' && HRAAdmin.Covered_Services__c != null)
                        coveredServices = HRAAdmin.Covered_Services__c.split(';');

                    else if (HRAAdmin.HRA_Upfront_Deductible__c == 'No') {
                        if (HRAAdmin.HRA_Split_Percentage__c == 'Yes') {
                            if (HRAAdmin.Split_Percentage_Covered_Services__c != null)
                                coveredServices = HRAAdmin.Split_Percentage_Covered_Services__c.split(';');
                        } else {
                            if (HRAAdmin.NonSplit_Covered_Services__c != null)
                                coveredServices = HRAAdmin.NonSplit_Covered_Services__c.split(';');
                        }
                    }
                }

                //PRDCRM 33128 - Add ProdName
                HRAProdDetails.ProdName = HRAAdmin.QLI__r.ProductName__c;

                // fix US-32172/US-32174/US-32169 ends    
                if (coveredServices != null) {
                    for (String pval: coveredServices) {
                        if (pval == 'In Network Coinsurance')
                            HRAProdDetails.HRA_ProvPay_Opt_DebCd_INN_Med_Coins = true;
                        if (pval == 'In Network Copays')
                            HRAProdDetails.HRA_ProvPay_Opt_DebCd_INN_Med_Copay = true;
                        if (pval == 'In Network Medical Deductible')
                            HRAProdDetails.HRA_ProvPay_Opt_DebCd_INN_Med_Ded = true;
                        if (pval == 'Out of Network Coinsurance')
                            HRAProdDetails.HRA_ProvPay_Opt_DebCd_ONN_Med_Coins = true;
                        if (pval == 'Out of Network Copays')
                            HRAProdDetails.HRA_ProvPay_Opt_DebCd_ONN_Med_Copay = true;
                        if (pval == 'Out of Network Medical Deductible')
                            HRAProdDetails.HRA_ProvPay_Opt_DebCd_ONN_Med_Ded = true;
                        if (pval == 'Rx')
                            HRAProdDetails.HRA_ProvPay_Opt_DebCd_Rx_Option = true;
                    }
                }
                if (HRAAdmin.Medical__c != null) {
                    String[] medical = HRAAdmin.Medical__c.split(';');

                    if (medical != null) {
                        for (String pval1: medical) {
                            if (pval1 == 'Provider Pay')
                                HRAProdDetails.HRA_ProvPay_Opt_DebCd_Medical = true;
                        }
                    }
                }
                if (HRAAdmin.Specialty__c != null)
                    HRAProdDetails.HRA_ProvPay_Opt_DebCd_Vision_Option = true;
                if (HRAAdmin.HRA_Rollover__c != null && HRAAdmin.HRA_Rollover__c == 'Yes')
                    HRAProdDetails.HRA_Rollover = true;
                HRAProdDetails.HRA_Rollover_Offer = HRAAdmin.HRA_Rollover__c;
                HRAProdDetails.HRA_Rollover_Date_recommend_3_months = HRAAdmin.Plan_End_Date__c.addDays(90);
                HRAProdDetails.HRA_Termed_Emp_Claims_Run_out_Deadline = HRAAdmin.Terminated_can_submit_claims_for__c;
                if (HRAAdmin.If_Other_Please_Specify__c != null) {
                    HRAProdDetails.HRA_Terminated_Employees_Other_Value = HRAAdmin.If_Other_Please_Specify__c; // Added - PRDCRM-27088
                }
                HRAProdDetails.HRA_Unused_rollovrfund_diff_Adm_last_yr = HRAAdmin.Rollover_Different_Admin__c;
                HRAProdDetails.HRA_Upfront_Ded_Amt_Emp = HRAAdmin.UpfrontDedEE__c;
                HRAProdDetails.HRA_Upfront_Ded_Amt_Emp_Adult = HRAAdmin.UpFrontDedEA__c;
                HRAProdDetails.HRA_Upfront_Ded_Amt_Emp_Child = HRAAdmin.UpfrontDedEChild__c;
                HRAProdDetails.HRA_Upfront_Ded_Amt_Emp_Children = HRAAdmin.UpFrontDedEEChildren__c;
                HRAProdDetails.HRA_Upfront_Ded_Amt_Family = HRAAdmin.UpFrontDedFamily__c;
                HRAProdDetails.HRA_Upfront_Deductible_Tier_Selection = HRAAdmin.Up_Front_Deductible_Tiers__c;
                HRAProdDetails.Legacy_Lumenos_HRA = HRAAdmin.HRA_Lites_Rollover__c;

            }
            //Added by Suresh 
            if (hraDetails.containsKey(HRAAdmin.QLI__r.QuoteId) && hraDetails.get(HRAAdmin.QLI__r.QuoteId) != null) {
                List <CDHPISGRestAPIClient.HRAProductDetails> hraDt = hraDetails.get(HRAAdmin.QLI__r.QuoteId);
                hraDt.add(HRAProdDetails);
                hraDetails.put(HRAAdmin.QLI__r.QuoteId, hraDt);
            } else {
                List <CDHPISGRestAPIClient.HRAProductDetails> hraDt = new List <CDHPISGRestAPIClient.HRAProductDetails> ();
                hraDt.add(HRAProdDetails);
                hraDetails.put(HRAAdmin.QLI__r.QuoteId, hraDt);
            }
            // End - Added by Suresh 

        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            System.debug('Exception occured while fetching HRA product details - ' + e.getMessage() + ' \n' + e.getStackTraceString());
            return null;
        }
        return HRAProdDetails;
    }

    /**
     * @description Obtains the address from an Account
     * @param accountId ID of Account
     * @return The address of the Account
     */
    public CDHPISGRestAPIClient.AccountAddress GetAccountAddress(String accountId) {
        CDHPISGRestAPIClient.AccountAddress CDHPAcctAddress = new CDHPISGRestAPIClient.AccountAddress();
        Account acct;
        try {
            acct = [SELECT Name, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                BillingCountry FROM Account Where Id =: accountId
            ];

            CDHPAcctAddress.BillingStreet = acct.BillingStreet;
            CDHPAcctAddress.BillingCity = acct.BillingCity;
            CDHPAcctAddress.BillingState = acct.BillingState;
            CDHPAcctAddress.BillingPostalCode = acct.BillingPostalCode;
            CDHPAcctAddress.BillingCountry = acct.BillingCountry;

        } catch (Exception e) {
            System.debug('Exception occured while fetching CDHP details - ' + e.getMessage());
            return null;
        }
        return CDHPAcctAddress;
    }

}