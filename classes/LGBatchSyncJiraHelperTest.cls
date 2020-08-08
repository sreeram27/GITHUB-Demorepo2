/*
 * @Author - Legato Health Technologies
 * Helper Class for LGBatchSyncJiraRefinedTest class
 * 
 * Date : 30 - October - 2018
 */

@isTest
public class LGBatchSyncJiraHelperTest {
    
    public static RecordType fetchRecordType(String sObjectType , String recordTypeName)
    {
        RecordType rcType = [select id , name from recordtype where sobjecttype =:sObjectType and Name =:recordTypeName LIMIT 1];
        return rcType;
    }
    
    public static SIC__c createSIC() 
    {
        SIC__c sic = new SIC__c(name = 'test');
        insert sic;
        return sic;
    }
    
    public static Account createFullAccount(String name , String recordTypeName , String anthemEntity , String region , String MBUCodes , String situsState)
        {
            RecordType recordType = fetchRecordType('Account', recordTypeName);
            		Account acc = new Account(
                	Name = name,
                    Region__c = region,
                    Anthem_Entity__c = anthemEntity , 
                	Type = 'Prospect',
                    RecordTypeId = recordType.Id,
                    //ParentId = '',
                    Account_Name_DBA__c='',    
                    //MOD_Squad__c = false,
                        //Mercer_Study_Group__c = false,
                        //Demo__c = false,
                        //Past_Customer__c = false,
                        //Business_Continuity_Plan__c = '',
                        //Yearly_Refresh__c = false,
                        //MultipleOppty__c = false,
                        //Specialty_Note__c = '',
                        //TotalNumberofPartTimeWorkers__c = 100,
                        //TotalNumberofUnionWorkers__c = 20,
                        //Potential_of_Intermittent_Employees__c = 2,
                    BillingStreet = '24',
                    BillingCity = 'Callen',
                    BillingState = 'California',
                    BillingPostalCode = '10043',
                    BillingCountry = 'USA',
                    ShippingStreet = '26',
                    ShippingCity = 'Ballar',
                    ShippingState = 'Georgea',
                    ShippingPostalCode = '10065',
                    ShippingCountry = 'USA',
                    Physical_County__c = 'NEW YORK',
                    Mailing_Address_Same_as_Physical_Address__c = true,
                    Industry = '',
                    Description = 'Test Account' , 
                    Account_Status__c = 'Active' , 
                    HQ_State__c = 'GA' ,
                    //Original_Effective_Date__c = System.today() , 
                    //Client_Renewals_Occur__c = 'Annually',
                    //Month_Underwriter_starts_renewal_process__c = 'September',
                    //Active_Renewal_Date__c = Date.newInstance(2020, 1, 1),
                    Renewal_Month__c = 'January' , 
                    Branding__c = 'Anthem BCBS',
                    SIC__c = createSIC().Id,
                    MBU_Codes__c = MBUCodes,
                    //Does_NY_HCRA_Apply__c = 'Yes',
                    //    Is_this_Group_subject_to_ERISA__c = 'Yes',
                    //    Control_Plan_Code__c = 'WGS 102 (GA Subcontract)',
                        WGS_Contracting_Situs_State__c = situsState ,
                        NASCO_Contracting_Situs_State__c = situsState,
                    //    OffersEGRBenefits__c = 'Unsure',
                     //   Digital_Promotions_Opt_In__c = 'Yes',
                     //   Medicare_Member_Marketing_Opt_In__c = 'Yes',
                     //   FlexHour_Prospect__c = 'Yes',
                     //   FlexTypeMedical__c = '',
                      //  Other_Medical_Plan__c = '',
                     //   ProviderCallsBeingHandledOffshore__c = 'Yes',
                     //   MembershipBeingHandledOffshore__c = 'Yes',
                    //    ClaimsBeingHandledOffshore__c = 'Yes',
                    //    ApprovedByOutsourcing__c = false,
                    //    OutsourcingRestrictions__c = false,
                    Group_Size__c = '1 - 50',
                    Situs_State__c = situsState,
                    Total_Employees__c = 10571,
                    Eligible_Employees__c = 2200);
            insert acc;
        	return acc;  
        }

   
    
    public static Profile getProfile(String name)
    {
        Profile pf= [Select Id from profile where Name=: name];
        return pf;
    }
    
    public static User createUser(String fname , String lname , String email , String userName , String alias , String profileId)
    {
        User user = new User(firstname = fname, 
                        lastName = lname, 
                        email = email,
                        EmailEncodingKey = 'ISO-8859-1',
                        Username = userName, 
                        Alias = alias,
                        TimeZoneSidKey = 'America/Los_Angeles', 
                        LocaleSidKey = 'en_US', 
                        LanguageLocaleKey = 'en_US',
                        ProfileId = profileId); 
        insert user;
        return user;
    }
    
    public static AccountTeamMember createAccTeamMem(String accId , String teamMemberRole , String userId)
    {
        AccountTeamMember atm = new AccountTeamMember(AccountId = accId, 
                                                    TeamMemberRole = teamMemberRole,
                                                    UserId = userId);

        insert atm;
        return atm;
    }
    
    public static Group__c createGroup(String claimSystem , String name , String accId,String MBUCodes)
    {
        Group__c g = new Group__c(ClaimSystem__c = claimSystem,
                                  Name = name,
                                  Account__c = accId,
                                  ClaimServiceCenter__c = 'Richmond VA',
                                  CallServiceCenter__c = 'Richmond VA',
                                  /*ABH_Service_Location__c = '',
                                  Actuarial_Funding_Code_WGS_Only__c = '',
                                  ARMS_Subsequent_Enrollment__c = '',
                                  Claims_Route_Code__c = '',
                                  Comments__c = '',
                                  */
                                  DeliveryChannel__c = 'Towers Watson',
                                  Effective_Date__c = System.today(),
                                  Subscribers__c = 2200,
                                  Members__c = 4000,
                                  /*Eligibility_File_PG_Ongoing__c = '',
                                  Employer_Service_Representative_ESR__c = '',
                                  ESR_Contact__c = '',
                                  Exchange__c = '',
                                  FinancingRollup__c = '',
                                  First_Impression_Check__c = '',
                                  GroupFundingType__c = '',
                                  GroupNumberRequestStatus__c = '',
                                  GroupServicesGroupNumberNotes__c = '',
                                  ID_Card_On_Going_Performance_Guarantee__c	 = '',
                                  ID_Card_Performance_Guarantee__c = '',
                                  Implementation_PGs__c = '',
                                  Initial_ARMS_Enrollment__c = '',
                                  Initial_Implementation_Satisfaction_PG__c = '',
                                  */
								  IsActive__c = true,
                                  //IsPartOfAMigration__c = '',
                                  //LineofBusiness__c = '',
                                  MBU_Codes__c = MBUCodes,
                                  /*
                                  Medical_Management__c = '',
                                  Medical_Management_Platform__c = '',
                                  Medical_Management_Service_Location__c = '',
                                  Med_Mgmt_Service_Location__c = '',
                                  NumberofOpenProductsProgramsGROUP__c = 2,
                                  Operational_OE_Adjustments__c = '',
                                  Operational_Owner_Adjustments__c = '',
                                  Operational_Owner_Claims__c = '',
                                  Operational_Owner_Service_Managers__c = '',
                                  Operational_Owner_Serv_Mgrs__c	= '',
                                  Operations_Expert_OE_Adjustments__c = '',
                                  Operations_Expert_OE_Claims__c = '',
                                  Operations_Expert_OE_Service__c = '',
                                  Operations_Owner_Adjustments__c = '',
                                  Op_Owner_Adjustments__c='',
                                  */
                                  Opportunity_Effective_Date__c = System.today()
                                  /*Ops_Expert_OE_Claims__c = '',
                                  Ops_Expert_OE_Service__c = '',
                                  Prior_Medical_Carrier__c = '',
                                  ProductLineFundingType__c = '',
                                  SFDCLegacyID__c = '',
                                  SFDCLegacyID2__c = '',
                                  SFDCLegacyID3__c = '',
                                  TECH_OpportunityId__c = '',
                                  TECH_OppOwnerEmail__c = '',
                                  TotalEligibles__c = 200,
                                  Unit_Code__c = '',
                                  Unit_Name__c = ''
                                  */
                                 );

        insert g;
        return g;
    }
    
    public static Opportunity createOpp(Date closeDate , String name , String accId , String stageName , String oppRecordType)
    {
        Opportunity opp = new Opportunity(
            CloseDate = closeDate,
            Name = name,
            AccountId = accId,
            StageName = stageName ,
            Received_Date__c = System.today(),
            RecordType = fetchRecordType('Opportunity', oppRecordType),
            Probability = 10,
            WARP_Membership_Update_Date__c = System.today(),
            Stage_Reason__c = 'Brand',
            RFP_Status__c = 'Active Renewal',
            WasOpptyFinalized__c = true
            /*Custom_first_level_grievance_and_appeal__c = 'No',
            Notes_Comments__c = '',
            Specialty_Comments__c = '',
            Executive_Comments__c = '',
            AnthemFlexHourComments__c = '',
            Non_Chargeable__c = false,
            Upsell_Toolkit_Target__c = false,
            Upsell_Toolkit_Tracking__c = 'Initiated'
            */
            
        );
        insert opp;
        return opp;
    }
    
    public static Product2 createProduct(String name , boolean isActive , String type,String planType)
    {
        Product2 prod = new Product2(Name = name,
                                     IsActive = isActive,
                                     vlocity_ins__Type__c = type,
                                     ProductCode = 'RPE-3K0-089',
                                     Description = 'Test Product',
                                     Family = 'AIM',
                                     Product_Type__c = type,
                                     Plan_Type__c = planType
                                     
                                    );
        insert prod;
        return prod;
    }
    
    public static PricebookEntry createPBE(Id priceBookId , Id product2Id , Integer unitPrice , boolean isActive)
    {
        PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = priceBookId, 
                                                        Product2Id = product2Id,
                                                        UnitPrice = unitPrice,
                                                        IsActive = isActive,
                                                          vlocity_ins__DRBundleName__c = '',
                                                          vlocity_ins__DRError__c = '',
                                                          vlocity_ins__DRProgressData__c = '',
                                                          vlocity_ins__DRStatus__c = '',
                                                          vlocity_ins__FloorPrice__c = 20,
                                                          vlocity_ins__OverageCharge__c = 20,
                                                          vlocity_ins__OverageUOM__c = '',
                                                          vlocity_ins__RecurringPrice__c = 20,
                                                          vlocity_ins__RecurringUOM__c = ''
                                                       );
        insert standardPrice;
        return standardPrice;
    }
    
    public static Pricebook2 createPriceBook2(String name , boolean isActive)
    {
        Pricebook2 customPB = new Pricebook2(Name=name, isActive=isActive);
        insert customPB;
        return customPB;
    }
    
    public static Quote createQuote(boolean jaaIndicator , Id groupId , String name , Id priceBookId , Id oppId)
    {
        Quote q = new Quote(JAAIndicator__c = jaaIndicator,
                        GroupNumber__c = groupId,
                        Name = name,
                        Pricebook2Id = priceBookId,
                        OpportunityId = oppId,
                            GroupOriginalEffectiveDate__c = System.today(),
                            PaymentInnovationInitiativesException__c = false,
                            DivisionName__c = 'Medical',
                            BenefitRenewalAnniversaryDate__c = Date.newInstance(2020, 1, 1),
                            UseDivisionNameasGroupName__c = false,
                            WGSCompanySizeCode__c = 'I -- 5,000 + contracts',
                            BenefitRenewalAnniversary__c = 'Calendar Year',
                            FiduciaryServicesSoldASOOnly__c = 'Yes (Anthem has final responsibility on Appeals)',
                            //vlocity_ins__PriceListId__c = '',
                            NASCOMarketSegmentCode__c = '04 National Large Group',
                            CIPExcluded__c = false,
                            LHOL_Q__c = ''
                            
                        );

        insert q;
        return q;
    }
    
    public static QuoteLineItem createQLI(String financing,String funding , Id quoteId , Id prodId , integer members , Id pbeId , integer quant , decimal unitprice , double subscribers , double currSubscribers , double currMembers,String planType)
    {
        QuoteLineItem qli = new QuoteLineItem(Funding__c = funding, 
                                            QuoteId = quoteId,
                                            Product2Id = prodId,
                                            Members__c = members,
                                            PricebookEntryId = pbeId,
                                            Quantity = quant,
                                            Unitprice = unitprice,
                                            Subscribers__c = subscribers,
                                            CurrentSubscribers__c = currSubscribers , 
                                            CurrentMembers__c = currMembers,
                                            Reason__c = 'DNA' , 
                                            Financing__c = financing,
                                              InitialSubscribers__c = 200,
                                              InitialMembers__c = 100,
                                              //Competitor__c = '',
                                              CompetitorStatus__c = '',
                                              Plan_Type__c=planType
                                              //TermDate__c = Date.newInstance(2020, 1, 1)
                                             );

        insert qli;
        return qli;
    }
    
    public static Order createOrder(Date ImplEffDate , String impStatus , String impType , String userGroup , Date prodDate , Date effDate ,  String status , Id accId , Id qId , Id oppId , Group__c grp, Id userID)
    {
        Order o = new Order(Implementation_Effective_Date__c = ImplEffDate,
                        Implementation_Status__c = impStatus,
                        Implementation_Type__c = impType,
                        User_Group__c = userGroup,
                        Production_Date__c = prodDate,
                        EffectiveDate = effDate,
                        Status = status,
                        AccountId = accId,
                        QuoteId = qId,
                        OpportunityId = oppId,
                            //vlocity_ins__FrameContractId__c = '',
                            Implementation_Case_Topic__c = 'MedBen JIRA',
                            Group_Name__c = grp.Id,
                            /*Discovery_Call_Desired__c = 'No',
                            Discovery_Call_Held__c = Date.newInstance(2019,1, 1),
                            Pre_Implementation_Audit__c = '',
                            Intake_Type_Acquisition__c = false,
                            Intake_Type_Group_Term__c = false,
                            Intake_Type_Spin_Off__c = false,
                            Intake_Type_Retro__c = false,
                            Impacted_Packages_Suffixes_Sections__c = '',
                            AIM_Product_Sold_Or_Termed_Notification__c = '',
                            Was_A_Previous_Prework_Case_Submitted__c = 'No',
                            Are_there_changes_to_Group_Structure__c = 'No',
                            Does_this_change_req_impact_Pre_Cert_De__c = 'No',
                            Are_there_changes_to_Broker_Commissions__c = 'No',
                            Are_there_changes_to_Rates__c = 'No',
                            Custom_IVR_Telephony_changes_Renewal__c = 'No',
                            Are_there_any_third_party_vendor_requir__c = 'No',
                            Does_a_partial_term_apply__c = 'No',
                            Are_there_changes_to_Eligibility__c = 'No',
                            Provide_Partial_Term_Reason__c = '',
                            Are_there_changes_to_COB__c = 'No',
                            //Indicate_Latest_Eligibility_Record__c = '',
                            Are_there_changes_to_Enrollment_Billing__c = 'No',
                            //Indicate_Latest_COB_Record__c = '',
                            Changes_to_Elig_Vendor_or_File_Feed__c = 'No',
                            //Indicate_Latest_Funding_Record__c = '',
                            Request_include_benefit_changes__c = 'No',
                            //Accumulator_History_Load__c = '',
                            Are_there_Changes_to_Behav_Health__c = '',
                            Open_Enrollment_Submission_Type__c = '',
                            Impact_To_HPCC__c = '',
                            Do_Medical_Plans_Have_Custom_Benefit__c = '',
                            Custom_ID_Cards__c = false,
                            ID_Cards_Sent_To__c = '',
                            ID_Cards_Required__c = '',
                            Custom_ID_Card_Code__c = '',
                            Maintenance_Cards_Sent_To__c = '',
                            Standalone_ID_card__c = '',
                            ID_Card_Design__c = '',
                            ID_Card_Changes__c = 'No',
                            Added_plans_or_plans_changed_HCR_Status__c = 'No',
                            //Indicate_HCR_Record_del__c = '',
                            Does_this_change_req_impact_SBCs__c = 'No',
                            Want_the_SBC_created_by_the_SBC_team__c = '',
                            Does_Anthem_Produce_SBC_s__c = '',
                            Contract_Codes_Packages_Customization__c = '',
                            Does_change_req_impact_Benefit_Booklets__c = 'No',
                            Does_This_Require_A_New_Benefit_Booklet__c = '',
                            Does_Anthem_Produce_Benefit_Booklets__c = '',
                            Modification_to_existing_booklet__c = 'No',
                            Who_Is_Prior_Vendor__c = '',
                            Is_The_Sale_Date_Final__c = '',
                            Group_Structure_Impacts__c = '',
                            IsThe_Acquisition_Confidential__c = '',
                            Carry_Over_Accumulators_Or_Data_Files__c = '',
                            Did_You_Attach_Client_Chg_Approval_Email__c = 'No',
                            Did_You_Attach_The_Selections_Report__c = 'No',
                            Did_You_Attach_WGS_Rate_Sheet_if_WGS__c = 'No',
                            Did_You_attach_The_Benefit_Booklet_Form__c = 'No',
                            Did_You_Attach_The_ASF__c = 'No',
                            Attach_Group_Benefit_Agreement__c = 'No',
                            Attach_Implementation_Questionnaire__c = 'No',
                            Attach_The_Quote__c = 'No',
                            Attach_The_Rates__c = 'No',
                            Attach_The_Approvals__c = 'No',
                            Attach_The_Benefit_Summaries__c = 'No',
                            Attach_CEP_Approval_CustomBenefit__c = 'No',
                            In_Progress_Status__c = DateTime.now(),
                            In_Progress__c = 1,
                            Ready_for_Implementations_Status__c = DateTime.now(),
                            Ready_For_Implementations__c = 1,
                            Pending_Sales_Account_Management_Status__c = DateTime.now(),
                            Pending_Sales_Account_Management__c = 1,
                            Pending_SME_Review_St__c = DateTime.now(),
                            Pending_SME_Review__c = 1,
                            Approved_Implementation_in_Progress_St__c = DateTime.now(),
                            Approved_Implementation_in_Progress__c = 1,
                            */
                            Assigned_Implementer__c = userID
                            
                            
                            
                           );

        insert o;
        return o;
    }
    
    public static SME_Approvals__c createSMEApprovals(Id orderId , String SMEDepartment , String status , String codesImpacted)
    {
        SME_Approvals__c approval = new SME_Approvals__c(Implementation_Record_ID__c = orderId,
                                                        SME_Department__c = SMEDepartment,
                                                        Status__c = status,
                                                        Strings_Tables_Contract_Codes_Impacted__c = codesImpacted
                                                        );
        

        insert approval;
        return approval;
    }
    
    public static Implementation_Tracking__c createIT(Id impRecordId ,String jiraID , boolean engageMedicalBenifits)
    {
        Implementation_Tracking__c IT = new Implementation_Tracking__c(Implementation_Record_ID__c = impRecordId,
                                                                       JIRA_Request_ID__c = jiraID,
                                                                       Overall_Status__c = '',
                                                                       EBA_Requested_ACD__c = null,
                                                                       EBA_Request_ECD__c = null,
                                                                       Status_At_EBA_Request_Level__c='',
                                                                       Receipt_Date__c = null,
                                                                       Benefit_Analyst_Assigned__c = '',
                                                                       Engage_Medical_Benefits__c = engageMedicalBenifits);
        insert IT;
        return IT;
    }
    /*
    public Jira_EndPoint_Setting__mdt createEndPointInfo(String accessToken , 
                                                        String apiKey , 
                                                        String clientId , 
                                                        String clientSecret , 
                                                        String createIssue , 
                                                        String deleteIssue,
                                                        String healthCheck , 
                                                        String jiraGeneric,
                                                        String modifyIssue,
                                                        String searchGet,
                                                        String searchPost,
                                                        String host,
                                                        String userName,
                                                        String password,
                                                        Integer tokenRefreshTime)
        
    {
        
        Jira_EndPoint_Setting__mdt endPointInfo = new Jira_EndPoint_Setting__mdt(AccessToken__c = accessToken , 
                                                                                ApiKey__c = apikey,
                                                                                 ClientID__c = clientId,
                                                                                 ClientSecret__c = clientSecret,
                                                                                 Create_Issue__c = createIssue , 
                                                                                 Delete_Issue__c = deleteIssue, 
                            healthCheck__c = healthCheck, Jira_Generic__c = jiraGeneric, Modify_Issue__c = modifyIssue, Search_GET__c=searchGet, Search_POST__c=searchPost, Host__c=host, Application_Username__c = userName, 
                            Application_Password__c = password, TokenRefreshTime__c = tokenRefreshTime);
        insert endPointInfo;
        return endPointInfo;
    } 
*/
    
}