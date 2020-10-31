global class SendToCastLightBatch implements Database.Batchable < sobject > , Database.AllowsCallouts, Schedulable, Database.Stateful {
    
    public List < string > prodstage {
        get;
        set;
    }
    public List < string > products {
        get;
        set;
    }
    public set < id > oppid {
        get;
        set;
    }
    
    public List < CastLightProcessBatchStatus.CastLightProcessStatusWrapper > processstatuswrapper {
        get;
        set;
    }
    
    public Map < Id, List < CastLightRequestResponse.OpportunityProduct >> oppidtooppprodlist;
    
    public Map < Id, List < CastLightRequestResponse.StandardForm>> oppidtostandardformlist; 
    public Map < Id, List < CastLightRequestResponse.ScopingForm >> oppidtoscopeformlist; 
    
    public Map < Id, List < CastLightRequestResponse.EmployerProgram>> standformidtoempproglist; 
    
    public SendToCastLightBatch() {
        
        
        products = new List < string > ();
        /*products.add('Castlight - Buy Up Products');
products.add('Castlight - Core Early Adopter');
products.add('Engage Elite');
products.add('Engage Essential');
*/
        prodstage = new List < string > ();
        /*
prodstage.add('In Progress');
prodstage.add('IGAP In Progress');
prodstage.add('IGAP Sold');
prodstage.add('Renewed');
prodstage.add('Sold');
*/
        oppidtooppprodlist = new Map < Id, List < CastLightRequestResponse.OpportunityProduct >> ();
        oppidtostandardformlist = new Map < Id, List < CastLightRequestResponse.StandardForm>> ();
        oppidtoscopeformlist = new Map < Id, List < CastLightRequestResponse.ScopingForm>> ();
        standformidtoempproglist = new Map < Id, List < CastLightRequestResponse.EmployerProgram>> ();
        oppid=new set<Id>();
        processstatuswrapper=new  List<CastLightProcessBatchStatus.CastLightProcessStatusWrapper>();
        
    }
    global database.QueryLocator start(Database.BatchableContext BC) {
        
        /*List < CSLT_Integration_Process_Log__c > processlog = [select id, OpportunityId__c, Status__c, Send_update__c from CSLT_Integration_Process_Log__c 
where Status__c = 'SUCCESS' and Send_update__c = false];
set < Id > processlogoppids = new set < Id > ();
for (CSLT_Integration_Process_Log__c p: processlog) {
processlogoppids.add(p.OpportunityId__c);
} */
        ServiceInterface__mdt mc = [Select effective_date__c, parameter1__c, parameter2__c  From ServiceInterface__mdt Where DeveloperName = 'CastLightIntegration']; 
        products = mc.parameter1__c.split(',');
        prodstage =mc.parameter2__c.split(',');
        
        AggregateResult[] query;
        
        /*query = [select quote.opportunityid oppids from quotelineitem
where product2.name in :products
and productstage__c in : prodstage and quote.opportunityid not in : processlogoppids 
group by quote.opportunityid
];*/
        
        query = [select quote.opportunityid oppids  from quote 
                 where Opportunity.closeDate >= :mc.effective_date__c and 
                 id in 
                 (select QuoteId  from quotelineitem 
                  where product2.vlocity_ins__SubType__c = 'Castlight'
                  and productstage__c in :prodstage 
                 )
                 and OpportunityId not in 
                 (select  OpportunityId__c from CSLT_Integration_Process_Log__c
                  where Status__c = 'SUCCESS' and Send_update__c = false
                 ) group by OpportunityId
                ];
        
        
        set < id > oppidfetch = new set < Id > ();
        
        for (AggregateResult ar: query) {
            
            if (ar.get('oppids') != NULL) {
                oppidfetch.add((ID)(ar.get('oppids')));
            }
        }
        
        string q = 'select name,Account.parent.name,Account.parentid,Account.DirectorSalesAccountManagement__r.Phone,'+
            'Account.Account_Executive__r.Phone,Account.DirectorSalesAccountManagement__r.Email,Account.Account_Executive__r.Email,'+
            'Account.BillingCountry,Account.BillingPostalCode,Account.BillingState,Account.billingstreet,Account.BillingCity,Account.website,'+
            'Account.Active_Renewal_Date__c,Accountid,Account.Duns_Number__c,Account.DirectorSalesAccountManagement__r.Name,'+
            'Account.Account_Executive__r.Name,Account.Region__c,Account.Name,account.Anthem_Entity__c,Id, StageName,description,OpportunityRecordTypeName__c,'+
            'closedate,account.recordtype.name from opportunity where Id in :oppidfetch';
        
        return database.getQueryLocator(q);
        
    }
    
    global void execute(Database.BatchableContext BC, List < Opportunity > opplist) {
        
        system.debug('opplist:' + opplist);
        
        Set < Id > actid = new set < Id > ();
        Map < Id, List < QuoteLineItem >> opptoQLI = new Map < Id, List < QuoteLineItem >> ();
        Map < Id, string > parentactidtoparentname = new Map < Id, string > ();
        
        CastLightRequestResponse.Account reqqrapper;
        
        List < CastLightRequestResponse.Opportunity > opportunitylist;
        List < CastLightRequestResponse.OpportunityProduct > oppprodlist;
        List < CastLightRequestResponse.StandardForm> oppstandformlist;
        List < CastLightRequestResponse.ScopingForm> oppscopeformlist;
        List < CastLightRequestResponse.EmployerProgram > empproglist;
        string parentact;
        Map < Id, Brokerage_and_Consultant__c > acttobrokerageconsultant = new Map < Id, Brokerage_and_Consultant__c > ();
        Map < Id, Brokerage_and_Consultant1__c > opptobrokerageconsultant = new Map < Id, Brokerage_and_Consultant1__c > ();
        Map<Id,CSLT_Integration_Process_Log__c> oppidtoprocesslogmap = new Map<Id,CSLT_Integration_Process_Log__c>();
        List < CSLT_Integration_Process_Log__c > processloglist = new List < CSLT_Integration_Process_Log__c > ();
        
        try {
            
            for (opportunity oppeach: opplist) {
                oppid.add(oppeach.id);
                actid.add(oppeach.accountid);
                if (oppeach.account.parentid != null) {
                    parentactidtoparentname.put(oppeach.account.parentid, oppeach.account.parent.name);
                }
            }
            
            List < CSLT_Integration_Process_Log__c > processloglst = [select id, OpportunityId__c, Status__c, Send_update__c from CSLT_Integration_Process_Log__c WHERE OpportunityId__c in :oppid];
            
            
            if (!processloglst.isempty() || processloglst.size() > 0) 
            {
                for(CSLT_Integration_Process_Log__c p:processloglst )
                {
                    oppidtoprocesslogmap.put(p.OpportunityId__c,p);
                }
                
            }                   
            List < Brokerage_and_Consultant__c > nationalConsultantFirmlist = [Select Account__c, id, Brokerage__r.Name, Brokerage_LG__r.Name 
                                                                               from Brokerage_and_Consultant__c where Account__c in : actid];
            if (!nationalConsultantFirmlist.isempty() || nationalConsultantFirmlist.size() > 0) {
                for (Brokerage_and_Consultant__c eachbrok: nationalConsultantFirmlist) {
                    if (!acttobrokerageconsultant.containskey(eachbrok.Account__c)) {
                        acttobrokerageconsultant.put(eachbrok.Account__c, eachbrok);
                    }
                }
            }
            
            
            List < Brokerage_and_Consultant1__c > localConsultantFirmlist = [Select id, Opportunity__c, Brokerage__r.Name from 
                                                                             Brokerage_and_Consultant1__c where Opportunity__c in : oppid];
            if (!localConsultantFirmlist.isempty() || localConsultantFirmlist.size() > 0) {
                for (Brokerage_and_Consultant1__c eachbrok: localConsultantFirmlist) {
                    if (!opptobrokerageconsultant.containskey(eachbrok.Opportunity__c)) {
                        opptobrokerageconsultant.put(eachbrok.Opportunity__c, eachbrok);
                    }
                }
            }
            
            List < quotelineitem > quotelineitemlist = [select id,quote.account.Anthem_Entity__c, Subscribers__c, Competitor__c, 
                                                        Competitor__r.Name, Reason__c, Probability__c, ProductStage__c, ProductLOB__c, Members__c,
                                                        Product2.Name, Product2.vlocity_ins__SubType__c , quote.opportunityid from quotelineitem
                                                        where quote.opportunityid in : oppid and product2.vlocity_ins__SubType__c = 'Castlight' and productstage__c in : prodstage
                                                       ];
            
            List<Engage_Scoping_And_Engage_Standard__c> scopingformstatuslist= new List<Engage_Scoping_And_Engage_Standard__c>();
            
            List<Engage_Scoping_And_Engage_Standard__c> scopingstandardform=[select 
                                                                             If_Yes_Specify_BEP_Administrator__c,If_Other_Please_Specify_BH_EAP__c,If_Other_Specify_Behavior_Health__c,If_Multi_Carrier_Select_All_That_Apply__c,If_Other_Specify_Medical_Carriers__c,Anthem_Control_State__c,If_Other_Clinical_Please_Specify__c,If_CARVE_OUT_Select_All_That_Apply__c,Specify_Account_Type_And_Vendor_Details__c,If_No_Specify_Alternative_Arrangement__c,If_Yes_Which_Vendor_Used_Today__c,Future_Pharmacy_Group_Numbers__c,Future_Pharmacy_Claims__c,IF_EAP_Select_All_That_Apply__c,If_Behav_Health_Select_All_That_Apply__c,Select_All_Anthem_Dental_That_Apply__c,If_Other_Anthem_Dental_Specify_Carriers__c,If_Yes_Specify_OC_Administrator__c,If_Other_Specify_BEP_Administrator__c,Is_There_Anthem_Dental__c,If_Other_Specify_Rx_Carriers__c,Ready_to_Submit_Engage_Scoping_Form__c,Ready_to_Submit_Engage_Standard_Form__c,Outbound_SSO_Partners_Desired__c,Is_Outbound_SSO_Required__c,Inbound_SSO_Partners_Desired__c,Is_Inbound_SSO_Required__c,
                                                                             If_Yes_Specify_HRA_Vendor__c,HRA_Health_Account__c,If_Yes_Specify_FSA_Vendor__c,FSA_Health_Account__c,
                                                                             If_Yes_Specify_HSA_Vendor__c,HSA_Health_Account__c,Does_The_Client_Have_Onsite_Clinics__c,
                                                                             Embed_Registration_Into_AE_And_NHE__c,Client_Have_Benefit_Enrollment_Platform__c,
                                                                             Does_Client_Have_Anthem_Health_Rewards__c,Is_Client_Interseted_In_Rewards_Center__c,
                                                                             Device_Credit_Budget__c,Is_Client_Interested_In_Device_Credit__c,Incentives_Budget__c,
                                                                             Is_Client_Interested_In_Incentives__c,Anthem_Basic_of_Enhanced_EAP__c,
                                                                             Includes_Behavioral_Health_Elevate__c,Client_Have_Own_Wellness_Vendors__c,
                                                                             Delta_Dental_State__c,Future_Dental_Group_Numbers__c,Future_Dental_Claims__c,
                                                                             Two_Year_Dental_Group_Numbers__c,Past_2_Year_Dental_Claim_History__c,
                                                                             Anthem_Dental_Carrier__c,Two_Year_Pharmacy_Group_Numbers__c,
                                                                             Past_2_Year_Pharmacy_Claim_History__c,ESI_Carve_In__c,
                                                                             Anthem_Only_Or_Multi_Carrier__c,Anthem_To_Provide_Comm_Support__c,Number_Of_Plans__c,
                                                                             If_Other_Specify_Network__c,Advantage_Networks_Alpha_Prefixes__c,
                                                                             National_Networks_Alpha_Prefixes__c,EYC_And_FAD__c,Care_And_Cost_Finder_CCF__c,
                                                                             Number_Total_Membership_Essentials_non__c,Number_Subscribers_Essentials_non__c,
                                                                             Number_Total_Membership_Essentials__c,Number_Subscribers_Essentials__c,
                                                                             Number_Total_Membership_Essentials_Plus__c,Number_Subscribers_Essentials_Plus__c,
                                                                             Number_Subscribers_Elite_Plus__c,Number_Total_Membership_Elite_Plus__c,
                                                                             Number_Total_Membership_Elite__c,Number_Subscribers_Elite__c,
                                                                             Client_Preferred_Launch_Date_For_Engage__c,Client_Termination_Effective_Date__c,
                                                                             Registration_Availability_During_OE__c,Existing_Client_Changes_Effective_Date__c,
                                                                             When_Is_Open_Enrollment__c,Anthem_Contract_Sign_Date__c,When_Does_Plan_Year_Start__c,
                                                                             Castlight_Contract_Sign_Date__c,Anthem_Renewal_or_New_Sale__c,Anthem_Executive_Manager__c,
                                                                             Estimated_Total_Membership__c,Contract_Type__c,ASH_Eligible_Members__c,ASH_Program_Name__c,
                                                                             ASH_Gym_Reimbursement_Buyup__c,Anthem_Health_Rewards__c,Activity_Nutrition_Sleep_Programs__c,
                                                                             WebMD_HRA_Program__c,BioIQ__c,Live_Health_Online_Offering__c,MyHealthAdvantage__c,
                                                                             Anthem_Health_Guide__c,End_Date_Of_Customer_Contract__c,Start_Date_Of_Customer_Contract__c,
                                                                             Est_Receipt_Date_of_1st_Prod_OE_File__c,Est_Receipt_Date_Of_1st_Prod_Elig_File__c,
                                                                             Member_Support_Hours_Of_Availability__c,Member_Support_Phone_Number__c,Group_Number__c,
                                                                             Clinical_Shared_Data_And_Experiences__c,Is_Pharmacy_Included__c,Select_All_Carriers_That_Apply__c,
                                                                             id,Quote_Name__c,Quote_Name__r.opportunityid,recordtype.name,Claim_System__c,Client_Integrating_Wellness_Bundle__c,
                                                                             If_Yes_Select_All_Applicable_Wellness__c,Select_All_Ecosystem_Integrations__c,If_Other_Specify_Ecosystem_Integration__c,If_Yes_Please_Indicate_Rx_Vendor__c,
                                                                             (select id,name,Employer_Program_Availability_Date__c,Employer_Program_Eligible_Members__c,Employer_Program_Email__c,
                                                                              Employer_Program_Name__c,Employer_Program_Phone_Number__c,Employer_Program_Website__c,Engage_Scoping_And_Engage_Standard__c,
                                                                              Group_Suffix_Number__c,If_Other_Employer_Program_Name__c from Engage_Standard_Employer_Programs__r) from Engage_Scoping_And_Engage_Standard__c 
                                                                             //where Quote_Name__r.opportunityid in: oppid and (Ready_to_Submit_Engage_Standard_Form__c=true or Ready_to_Submit_Engage_Scoping_Form__c=true)];
                                                                             where Quote_Name__r.opportunityid in: oppid and (Castlight_Submission_Status__c='Ready for Submission' or Castlight_Submission_Status__c='Ready for Re-Submission')];
            
            oppidtostandardformlist.clear();
            oppidtoscopeformlist.clear();
            standformidtoempproglist.clear();
            //start of new code
            if(!scopingstandardform.isempty()|| scopingstandardform.size() > 0 )
            {
                for(Engage_Scoping_And_Engage_Standard__c scopeformeach:scopingstandardform)
                {
                    
                    if( scopeformeach.recordtype.name=='Engage Standard')
                    {
                        Engage_Scoping_And_Engage_Standard__c scopingformstatus = new Engage_Scoping_And_Engage_Standard__c();
                        scopingformstatus.id = scopeformeach.id;
                        scopingformstatus.Castlight_Submission_Status__c = 'Submitted';
                        scopingformstatuslist.add(scopingformstatus);
                        
                        oppstandformlist = new List < CastLightRequestResponse.StandardForm > ();
                        
                        CastLightRequestResponse.StandardForm  oppstandform = new CastLightRequestResponse.StandardForm();
                        //oppstandform.FormType=scopeformeach.recordtype.name;
                        oppstandform.GroupNumber=scopeformeach.Group_Number__c;
                        oppstandform.MemberSupportPhoneNumber=scopeformeach.Member_Support_Phone_Number__c;
                        oppstandform.MemberSupportHours= scopeformeach.Member_Support_Hours_Of_Availability__c;
                        //oppstandform.EstReceiptDateOf1stProdEligFile= string.valueof(scopeformeach.Est_Receipt_Date_Of_1st_Prod_Elig_File__c);
                        oppstandform.EstReceiptDateOf1stProdEligFile= scopeformeach.Est_Receipt_Date_Of_1st_Prod_Elig_File__c;
                        oppstandform.ClaimSystem=scopeformeach.Claim_System__c;
                        oppstandform.EstReceiptDateOf1stProdOEFile= scopeformeach.Est_Receipt_Date_of_1st_Prod_OE_File__c;
                        oppstandform.StartDateOfCustContract= scopeformeach.Start_Date_Of_Customer_Contract__c;
                        oppstandform.EndDateOfCustContract= scopeformeach.End_Date_Of_Customer_Contract__c;
                        oppstandform.AnthemHealthGuide= scopeformeach.Anthem_Health_Guide__c;
                        oppstandform.MyHealthAdvantage= scopeformeach.MyHealthAdvantage__c;
                        oppstandform.LiveHealthOnlineOffering= scopeformeach.Live_Health_Online_Offering__c;
                        oppstandform.BioIQ= scopeformeach.BioIQ__c;
                        oppstandform.WebMDHRAProgram= scopeformeach.WebMD_HRA_Program__c;
                        oppstandform.ActivityNutritionSleepProg= scopeformeach.Activity_Nutrition_Sleep_Programs__c;
                        oppstandform.AnthemHealthReward= scopeformeach.Anthem_Health_Rewards__c;
                        oppstandform.ASHGymReimbursement= scopeformeach.ASH_Gym_Reimbursement_Buyup__c;
                        oppstandform.ASHProgramName= scopeformeach.ASH_Program_Name__c;
                        oppstandform.ASHEligibleMem= scopeformeach.ASH_Eligible_Members__c;
                        oppstandform.AnthemRecordID= scopeformeach.id;
                        //oppstandformlist.add(oppstandform);
                        
                        if (!oppidtostandardformlist.containskey(scopeformeach.Quote_Name__r.opportunityid)) {
                            system.debug('oppidtostandardformlist map:' + oppstandformlist);
                            
                            oppidtostandardformlist.put(scopeformeach.Quote_Name__r.opportunityid, oppstandformlist);
                            system.debug('oppidtostandardformlist map after:' + oppidtostandardformlist);
                            
                        } else {
                            List < CastLightRequestResponse.StandardForm > oppstandforms = oppidtostandardformlist.get(scopeformeach.Quote_Name__r.opportunityid);
                            
                            oppstandforms.add(oppstandform);
                            oppidtostandardformlist.put(scopeformeach.Quote_Name__r.opportunityid, oppstandforms);
                            system.debug('oppidtostandardformlist map multiple value:' + oppidtostandardformlist);
                        }
                        
                        for(Engage_Standard_Employer_Programs__c standemp:scopeformeach.Engage_Standard_Employer_Programs__r)
                        {
                            CastLightRequestResponse.EmployerProgram  empprograms = new CastLightRequestResponse.EmployerProgram ();
                            empproglist=new List < CastLightRequestResponse.EmployerProgram> ();
                            empprograms.EmpProgName=standemp.Employer_Program_Name__c;
                            empprograms.EmpProgNameOther=standemp.If_Other_Employer_Program_Name__c;
                            empprograms.EligMembers=standemp.Employer_Program_Eligible_Members__c;
                            empprograms.GroupSuffixNum=standemp.Group_Suffix_Number__c;
                            empprograms.EmpProgPhoneNum=standemp.Employer_Program_Phone_Number__c;
                            empprograms.EmpProgWebsite=standemp.Employer_Program_Website__c;
                            empprograms.EmpProgEmail=standemp.Employer_Program_Email__c;
                            empprograms.EmpProgAvailDate=standemp.Employer_Program_Availability_Date__c;
                            empprograms.AnthemRecordID=standemp.id;
                            empproglist.add(empprograms);  
                            
                            if (!standformidtoempproglist.containskey(scopeformeach.id)) {
                                system.debug('standformidtoempproglist map:' + standformidtoempproglist);
                                
                                standformidtoempproglist.put(scopeformeach.id, empproglist);
                                system.debug('standformidtoempproglist map after:' + standformidtoempproglist);
                                
                            } else {
                                List < CastLightRequestResponse.EmployerProgram> empprogforms = standformidtoempproglist.get(scopeformeach.id);
                                
                                empprogforms.add(empprograms);
                                standformidtoempproglist.put(scopeformeach.id, empprogforms);
                                system.debug('standformidtoempproglist map multiple value:' + standformidtoempproglist);
                            }
                        }
                        if(standformidtoempproglist.size() >0)
                        {
                            oppstandform.EmployerPrograms=standformidtoempproglist.get(scopeformeach.id);
                        }
                        oppstandformlist.add(oppstandform);
                    }
                    
                    
                    if( scopeformeach.recordtype.name=='Engage Scoping')
                    {
                        
                        Engage_Scoping_And_Engage_Standard__c scopingformstatus = new Engage_Scoping_And_Engage_Standard__c();
                        scopingformstatus.id = scopeformeach.id;
                        scopingformstatus.Castlight_Submission_Status__c = 'Submitted';
                        scopingformstatuslist.add(scopingformstatus);
                        
                        CastLightRequestResponse.ScopingForm oppscopeform = new CastLightRequestResponse.ScopingForm();
                        oppscopeformlist = new List < CastLightRequestResponse.ScopingForm > ();
                        //oppscopeform.FormType=scopeformeach.recordtype.name;
                        oppscopeform.AnthemRecordID=scopeformeach.id;
                        oppscopeform.AnthemControlState=scopeformeach.Anthem_Control_State__c;
                        oppscopeform.AlternateCommArrangement=scopeformeach.If_No_Specify_Alternative_Arrangement__c;
                        oppscopeform.GroupNumber=scopeformeach.Group_Number__c;
                        oppscopeform.ContractType=scopeformeach.Contract_Type__c;
                        oppscopeform.EstTotalMemCount=scopeformeach.Estimated_Total_Membership__c;
                        oppscopeform.ANTMRenewalorNewSale=scopeformeach.Anthem_Renewal_or_New_Sale__c;
                        oppscopeform.ANTMExecutiveMangaer=scopeformeach.Anthem_Executive_Manager__c;
                        oppscopeform.CSLTContSignDate=scopeformeach.Castlight_Contract_Sign_Date__c;
                        oppscopeform.PlanYearStartDate=scopeformeach.When_Does_Plan_Year_Start__c;
                        oppscopeform.ANTMContSignDate=scopeformeach.Anthem_Contract_Sign_Date__c;
                        oppscopeform.OEDate=scopeformeach.When_Is_Open_Enrollment__c;
                        oppscopeform.ExistingClientChangeEffDate=scopeformeach.Existing_Client_Changes_Effective_Date__c;
                        oppscopeform.RegistAvailDuringOE=scopeformeach.Registration_Availability_During_OE__c;
                        oppscopeform.ClntTermEffDate=scopeformeach.Client_Termination_Effective_Date__c;
                        oppscopeform.ClntPreferredLaunchDate=scopeformeach.Client_Preferred_Launch_Date_For_Engage__c;
                        //oppscopeform.ElitePlusSubCount=string.valueof(scopeformeach.Number_Subscribers_Elite_Plus__c);
                        oppscopeform.ElitePlusSubCount=scopeformeach.Number_Subscribers_Elite_Plus__c;
                        oppscopeform.ElitePlusMemCount=scopeformeach.Number_Total_Membership_Elite_Plus__c;
                        oppscopeform.EliteSubCount=scopeformeach.Number_Subscribers_Elite__c;
                        oppscopeform.EliteMemCount=scopeformeach.Number_Total_Membership_Elite__c;
                        oppscopeform.EssentialsPlusSubCount=scopeformeach.Number_Subscribers_Essentials_Plus__c;
                        oppscopeform.EssentialsPlusMemCount=scopeformeach.Number_Total_Membership_Essentials_Plus__c;
                        oppscopeform.EssentialsSubCount=scopeformeach.Number_Subscribers_Essentials__c;
                        oppscopeform.EssentialsMemCount=scopeformeach.Number_Total_Membership_Essentials__c;
                        oppscopeform.EssentialsNonANTMSubCount=scopeformeach.Number_Subscribers_Essentials_non__c;
                        oppscopeform.EssentialsNonANTMMemCount=scopeformeach.Number_Total_Membership_Essentials_non__c;
                        //oppscopeform.CCF=string.valueof(scopeformeach.Care_And_Cost_Finder_CCF__c);
                        oppscopeform.CCF=scopeformeach.Care_And_Cost_Finder_CCF__c;
                        oppscopeform.EYCAndFAD=scopeformeach.EYC_And_FAD__c;
                        oppscopeform.NationalNetworkAlphaPrefix=scopeformeach.National_Networks_Alpha_Prefixes__c;
                        oppscopeform.AdvantageNetworkAlphaPrefix=scopeformeach.Advantage_Networks_Alpha_Prefixes__c;
                        oppscopeform.OtherNetwork=scopeformeach.If_Other_Specify_Network__c;
                        oppscopeform.NumberOfPlans=scopeformeach.Number_Of_Plans__c;
                        oppscopeform.ANTMProvideCommSupport=scopeformeach.Anthem_To_Provide_Comm_Support__c;
                        oppscopeform.ANTMOnly_MultiCarrier=scopeformeach.Anthem_Only_Or_Multi_Carrier__c;
                        //oppscopeform.CarrierNames= scopeformeach.Select_All_Carriers_That_Apply__c;
                        if(scopeformeach.If_Multi_Carrier_Select_All_That_Apply__c!=null)
                        {
                            oppscopeform.MedicalCarrierNames= scopeformeach.If_Multi_Carrier_Select_All_That_Apply__c;
                            if(scopeformeach.If_Multi_Carrier_Select_All_That_Apply__c.contains('Other') && scopeformeach.If_Other_Specify_Medical_Carriers__c!=null)
                            {
                                	oppscopeform.MedicalCarrierNames= scopeformeach.If_Multi_Carrier_Select_All_That_Apply__c.replace('Other',scopeformeach.If_Other_Specify_Medical_Carriers__c);
                            }
                                
                        }

                            
                        oppscopeform.Pharmacy=scopeformeach.Is_Pharmacy_Included__c;
                        oppscopeform.ANTMRx=scopeformeach.ESI_Carve_In__c;
                        oppscopeform.RxVendorName = scopeformeach.If_Yes_Please_Indicate_Rx_Vendor__c;
                        oppscopeform.TwoYrPharmancyClmHistory=scopeformeach.Past_2_Year_Pharmacy_Claim_History__c;
                        oppscopeform.TwoYrPharmancyGrpNum=scopeformeach.Two_Year_Pharmacy_Group_Numbers__c;
                        
                        oppscopeform.FuturePharmacyClaims=scopeformeach.Future_Pharmacy_Claims__c;
                        oppscopeform.FuturePharmacyGrpNum=scopeformeach.Future_Pharmacy_Group_Numbers__c;
						if(scopeformeach.If_CARVE_OUT_Select_All_That_Apply__c!=null)
						{
							oppscopeform.PharmacyCarrierNames=scopeformeach.If_CARVE_OUT_Select_All_That_Apply__c;
							if(scopeformeach.If_CARVE_OUT_Select_All_That_Apply__c.contains('Other') && scopeformeach.If_Other_Specify_Rx_Carriers__c!=null)
							{
								oppscopeform.PharmacyCarrierNames=scopeformeach.If_CARVE_OUT_Select_All_That_Apply__c.replace('Other',scopeformeach.If_Other_Specify_Rx_Carriers__c);
							}
						}
                        
                        //oppscopeform.OtherPharmacyName= scopeformeach.If_Other_Specify_Rx_Carriers__c;
                        oppscopeform.ANTMDental=scopeformeach.Is_There_Anthem_Dental__c;
                        oppscopeform.ANTMDentalProdNames= scopeformeach.Anthem_Dental_Carrier__c;
                        oppscopeform.TwoYrDentalClmHistory=scopeformeach.Past_2_Year_Dental_Claim_History__c;
                        oppscopeform.TwoYrDentalGrpNum=scopeformeach.Two_Year_Dental_Group_Numbers__c;
                        oppscopeform.FutureDentalClaims=scopeformeach.Future_Dental_Claims__c;
                        oppscopeform.FutureDentalGrpNum=scopeformeach.Future_Dental_Group_Numbers__c;
						if(scopeformeach.Select_All_Anthem_Dental_That_Apply__c!=null)
						{
							oppscopeform.DentalCarrierNames=scopeformeach.Select_All_Anthem_Dental_That_Apply__c;
							if(scopeformeach.Select_All_Anthem_Dental_That_Apply__c.contains('Other') && scopeformeach.If_Other_Anthem_Dental_Specify_Carriers__c!=null)
							{
								oppscopeform.DentalCarrierNames=scopeformeach.Select_All_Anthem_Dental_That_Apply__c.replace('Other',scopeformeach.If_Other_Anthem_Dental_Specify_Carriers__c);
							}
						}
						
                        // oppscopeform.OtherDentalCarriers=scopeformeach.If_Other_Anthem_Dental_Specify_Carriers__c;
                        oppscopeform.DeltaDentalState=scopeformeach.Delta_Dental_State__c;
						if(scopeformeach.Clinical_Shared_Data_And_Experiences__c!=null)
						{
							oppscopeform.ClinicalProgNames= scopeformeach.Clinical_Shared_Data_And_Experiences__c;
							if(scopeformeach.Clinical_Shared_Data_And_Experiences__c.contains('Other') && scopeformeach.If_Other_Clinical_Please_Specify__c!=null)
							{
								oppscopeform.ClinicalProgNames= scopeformeach.Clinical_Shared_Data_And_Experiences__c.replace('Other',scopeformeach.If_Other_Clinical_Please_Specify__c);
							}
						}
						
                        //oppscopeform.OtherClinicalProgNames= scopeformeach.If_Other_Clinical_Please_Specify__c;
                        oppscopeform.ClientHasOwnWellnessVendor=scopeformeach.Client_Have_Own_Wellness_Vendors__c;
                        oppscopeform.WellnessVendorNames=scopeformeach.If_Yes_Which_Vendor_Used_Today__c;
                        oppscopeform.BHElevate=scopeformeach.Includes_Behavioral_Health_Elevate__c;
						if(scopeformeach.If_Behav_Health_Select_All_That_Apply__c!=null)
						{
							oppscopeform.BHVendorNames= scopeformeach.If_Behav_Health_Select_All_That_Apply__c;
							if(scopeformeach.If_Behav_Health_Select_All_That_Apply__c.contains('Other') && scopeformeach.If_Other_Specify_Behavior_Health__c!=null)
							{
								oppscopeform.BHVendorNames= scopeformeach.If_Behav_Health_Select_All_That_Apply__c.replace('Other',scopeformeach.If_Other_Specify_Behavior_Health__c);
							}
						}
						
                        if(scopeformeach.IF_EAP_Select_All_That_Apply__c!=null)
						{
							oppscopeform.EAPHealthVendorNames= scopeformeach.IF_EAP_Select_All_That_Apply__c;
							if(scopeformeach.IF_EAP_Select_All_That_Apply__c.contains('Other') && scopeformeach.If_Other_Please_Specify_BH_EAP__c!=null)
							{
								oppscopeform.EAPHealthVendorNames= scopeformeach.IF_EAP_Select_All_That_Apply__c.replace('Other',scopeformeach.If_Other_Please_Specify_BH_EAP__c);
							}
						}
						
                        oppscopeform.ANTMEAPProgName=scopeformeach.Anthem_Basic_of_Enhanced_EAP__c;
                        oppscopeform.IncentivesBudget=scopeformeach.Incentives_Budget__c;
                        oppscopeform.InterestedInIncentives=scopeformeach.Is_Client_Interested_In_Incentives__c;
                        oppscopeform.InterestedInDeviceCredit=scopeformeach.Is_Client_Interested_In_Device_Credit__c;
                        oppscopeform.DeviceCreditBudget=scopeformeach.Device_Credit_Budget__c;
                        oppscopeform.InterestedInRewardCenter=scopeformeach.Is_Client_Interseted_In_Rewards_Center__c;
                        oppscopeform.ClientHasANTMHealthReward=scopeformeach.Does_Client_Have_Anthem_Health_Rewards__c;
                        oppscopeform.BenefitEnrollmentPlatform=scopeformeach.Client_Have_Benefit_Enrollment_Platform__c;
						if(scopeformeach.If_Yes_Specify_BEP_Administrator__c!=null)
						{
                            oppscopeform.BEPAdministrator= scopeformeach.If_Yes_Specify_BEP_Administrator__c;
							if(scopeformeach.If_Yes_Specify_BEP_Administrator__c.contains('Other') && scopeformeach.If_Other_Specify_BEP_Administrator__c!=null)
							{
								oppscopeform.BEPAdministrator= scopeformeach.If_Yes_Specify_BEP_Administrator__c.replace('Other',scopeformeach.If_Other_Specify_BEP_Administrator__c);
							}
						}
						
                        oppscopeform.EmbedRegisIntoAEandNHE=scopeformeach.Embed_Registration_Into_AE_And_NHE__c;
                        oppscopeform.OnsiteClinic=scopeformeach.Does_The_Client_Have_Onsite_Clinics__c;
                        oppscopeform.OnsiteClinicAdmin= scopeformeach.If_Yes_Specify_OC_Administrator__c;
                        oppscopeform.HSAHealthAccount=scopeformeach.HSA_Health_Account__c;
                        oppscopeform.HSAVendorName=scopeformeach.If_Yes_Specify_HSA_Vendor__c;
                        oppscopeform.FSAHealthAccount=scopeformeach.FSA_Health_Account__c;
                        oppscopeform.FSAVendorName=scopeformeach.If_Yes_Specify_FSA_Vendor__c;
                        oppscopeform.HRAHealthAccount=scopeformeach.HRA_Health_Account__c;
                        oppscopeform.HRAVendorName=scopeformeach.If_Yes_Specify_HRA_Vendor__c;
                        oppscopeform.OtherHealthVendorDetail=scopeformeach.Specify_Account_Type_And_Vendor_Details__c;
                        oppscopeform.InboundSSORequired=scopeformeach.Is_Inbound_SSO_Required__c;
                        oppscopeform.InboundSSOPartnersNames=scopeformeach.Inbound_SSO_Partners_Desired__c;
                        oppscopeform.OutboundSSORequired=scopeformeach.Is_Outbound_SSO_Required__c;
                        oppscopeform.OutboundSSOPartnersNames=scopeformeach.Outbound_SSO_Partners_Desired__c;
                        oppscopeform.ClaimSystem=scopeformeach.Claim_System__c;
                        oppscopeform.ClientIntegratingWellnessBundle=scopeformeach.Client_Integrating_Wellness_Bundle__c;
                        oppscopeform.WellnessBundleNames=scopeformeach.If_Yes_Select_All_Applicable_Wellness__c;
						if(scopeformeach.Select_All_Ecosystem_Integrations__c!=null)
						{
							oppscopeform.EcoSystemIntegrations=scopeformeach.Select_All_Ecosystem_Integrations__c;
							if(scopeformeach.Select_All_Ecosystem_Integrations__c.contains('Other') && scopeformeach.If_Other_Specify_Ecosystem_Integration__c!=null)
							{
								oppscopeform.EcoSystemIntegrations=scopeformeach.Select_All_Ecosystem_Integrations__c.replace('Other',scopeformeach.If_Other_Specify_Ecosystem_Integration__c);   
							}
						}
						
                        oppscopeformlist.add(oppscopeform);
                        
                        if (!oppidtoscopeformlist.containskey(scopeformeach.Quote_Name__r.opportunityid)) {
                            system.debug('oppidtoscopeformlist map:' + oppidtoscopeformlist);
                            
                            oppidtoscopeformlist.put(scopeformeach.Quote_Name__r.opportunityid, oppscopeformlist);
                            system.debug('oppidtoscopeformlist map after:' + oppidtoscopeformlist);
                            
                        } else {
                            List < CastLightRequestResponse.ScopingForm > oppscopingforms = oppidtoscopeformlist.get(scopeformeach.Quote_Name__r.opportunityid);
                            
                            oppscopingforms.add(oppscopeform);
                            oppidtoscopeformlist.put(scopeformeach.Quote_Name__r.opportunityid, oppscopingforms);
                            system.debug('oppidtoscopeformlist map multiple value:' + oppidtoscopeformlist);
                        }
                    }
                    
                    
                }
                system.debug('oppidtostandardformlist Map:' + oppidtostandardformlist);
                system.debug('oppidtostandardformlist Map:' + oppidtostandardformlist.size());
                
                system.debug('oppidtoscopeformlist Map:' + oppidtoscopeformlist);
                system.debug('oppidtoscopeformlist Map:' + oppidtoscopeformlist.size());
                
                system.debug('standformidtoempproglist Map:' + standformidtoempproglist);
                system.debug('standformidtoempproglist Map:' + standformidtoempproglist.size());
            }               
            //end of new code
            
            for (quotelineitem qeach: quotelineitemlist) {
                if (opptoQLI.containskey(qeach.Quote.OpportunityId)) {
                    List < QuoteLineItem > retqli = opptoQLI.get(qeach.Quote.OpportunityId);
                    
                    retqli.add(qeach);
                    
                    opptoQLI.put(qeach.Quote.OpportunityId, retqli);
                    
                } else {
                    
                    opptoQLI.put(qeach.Quote.OpportunityId, new List < QuoteLineItem > {
                        qeach
                            });
                    
                }
            }
            system.debug('opptoQLI:' + opptoQLI);
            oppidtooppprodlist.clear();
            for (Id key: opptoQLI.keyset()) {
                
                for (QuoteLineItem q: opptoQLI.get(key)) {
                    
                    oppprodlist = new List < CastLightRequestResponse.OpportunityProduct > ();
                    system.debug('qli list:' + q);
                    CastLightRequestResponse.OpportunityProduct oppprod = new CastLightRequestResponse.OpportunityProduct();
                    oppprod.AnthemRecordID=q.id;
                    oppprod.ProductName = q.Product2.Name;
                    oppprod.ProdLOB = q.ProductLOB__c;
                    oppprod.ProdMembers = string.valueof(q.Members__c);
                    oppprod.ProdStage = q.ProductStage__c;
                    oppprod.ProdProbability = q.Probability__c; 
                    oppprod.ProdReason = q.Reason__c;
                    oppprod.ProdSubscribers = string.valueof(q.Subscribers__c);
                    if (q.quote.account.Anthem_Entity__c == 'Local/Large Group') {
                        oppprod.CompetitorName = q.Competitor__r.Name;
                    } else if (q.quote.account.Anthem_Entity__c == 'National Accounts') {
                        system.debug('National Accounts');
                        oppprod.CompetitorName = '';
                    }
                    
                    oppprodlist.add(oppprod);
                    
                    if (!oppidtooppprodlist.containskey(key)) {
                        
                        oppidtooppprodlist.put(key, oppprodlist);
                        
                    } else {
                        List < CastLightRequestResponse.OpportunityProduct > oppproducts = oppidtooppprodlist.get(key);
                        
                        oppproducts.add(oppprod);
                        oppidtooppprodlist.put(key, oppproducts);
                        system.debug('oppidtooppprodlist map multiple value:' + oppidtooppprodlist);
                    }
                    system.debug('Map formed:' + oppidtooppprodlist);
                }
                
            }
            
            system.debug('oppidtooppprodlist Map:' + oppidtooppprodlist);
            system.debug('oppidtooppprodlist Map Size:' + oppidtooppprodlist.size());
            CSLT_Integration_Process_Log__c processlog;
            for (Opportunity oeach: opplist) {
                try {
                    reqqrapper = new CastLightRequestResponse.Account();
                    opportunitylist = new List < CastLightRequestResponse.Opportunity > ();
                    reqqrapper.AccountRegion = oeach.Account.Region__c;
                    reqqrapper.AccountName = oeach.Account.Name;
                    reqqrapper.AcctExec = oeach.Account.Account_Executive__r.Name;
                    reqqrapper.DirectorofSalesAM = oeach.Account.DirectorSalesAccountManagement__r.Name;
                    if (oeach.Account.Anthem_Entity__c == 'Local/Large Group') {
                        
                        if (opptobrokerageconsultant.get(oeach.id) != null) {
                            reqqrapper.ConsultantFirm = opptobrokerageconsultant.get(oeach.id).Brokerage__r.Name;
                        }
                    } else if (oeach.Account.Anthem_Entity__c == 'National Accounts') {
                        
                        if (acttobrokerageconsultant.get(oeach.accountid) != null) {
                            reqqrapper.ConsultantFirm = acttobrokerageconsultant.get(oeach.accountid).Brokerage__r.Name;
                        }
                    }
                    reqqrapper.DUNSNUmber = oeach.Account.Duns_Number__c;
                    reqqrapper.Member = ''; //needs to be mapped later after confirming
                    
                    reqqrapper.AccountID = oeach.Accountid;
                    reqqrapper.AnthemORGID = 'Com2';
                    reqqrapper.AccountType = oeach.account.Anthem_Entity__c;
                    reqqrapper.RenewalDate = string.valueof(oeach.Account.Active_Renewal_Date__c);
                    reqqrapper.AccountWebSite = oeach.Account.website;
                    
                    reqqrapper.BillingStreet = string.valueof(oeach.Account.billingstreet);
                    
                    reqqrapper.BillingCity = string.valueof(oeach.Account.BillingCity);
                    reqqrapper.BillingPostalCode = string.valueof(oeach.Account.BillingPostalCode);
                    reqqrapper.BillingState = string.valueof(oeach.Account.BillingState);
                    reqqrapper.BillingCountry = string.valueof(oeach.Account.BillingCountry);
                    reqqrapper.AcctExecEmail = oeach.Account.Account_Executive__r.Email;
                    reqqrapper.DirectorofSalesAM_Email = oeach.Account.DirectorSalesAccountManagement__r.Email;
                    reqqrapper.AcctExecPhone = oeach.Account.Account_Executive__r.Phone;
                    reqqrapper.DirectorofSalesAM_Phone = oeach.Account.DirectorSalesAccountManagement__r.Phone;
                    parentact = parentactidtoparentname.get(oeach.account.parentid);
                    if (parentact != null) {
                        reqqrapper.ParentAccountName = parentact;
                    }
                    
                    CastLightRequestResponse.Opportunity o = new CastLightRequestResponse.Opportunity();
                    o.OppStage = oeach.StageName;
                    o.OpportunityID = oeach.id;
                    o.OppDescription = oeach.description;
                    o.OpportunityRecordType = oeach.OpportunityRecordTypeName__c;
                    o.OppEffectiveDate = string.valueof(oeach.closedate);
                    o.OpportunityProducts = oppidtooppprodlist.get(oeach.id);
                    o.StandardForms=oppidtostandardformlist.get(oeach.id);
                    o.ScopingForms=oppidtoscopeformlist.get(oeach.id);
                    opportunitylist.add(o);
                    
                    if (!opportunitylist.isempty() || opportunitylist.size() > 0) {
                        reqqrapper.Opportunities = opportunitylist;
                    }
                    system.debug('reqqrapper final---->' + reqqrapper);
                    System.debug('json:'+JSON.serializePretty(reqqrapper));
                    //System.debug(LoggingLevel.FINE,'json:'+JSON.serialize(reqqrapper));
                    CastLightIntegrationUtility.Response resp=CastLightIntegrationUtility.SendDataToCastlight(reqqrapper);
                    system.debug('** Response : ' + resp);
                    
                    if (resp.statuscode !=200) {
                        system.debug('Error found');
                        //responseString = responseString.remove('\"');
                        
                        throw new CustomException(resp.statusmessage);
                    } else {
                        
                        /* TO DO  - update the scoping/standard form status*/
                        if(scopingformstatuslist.size()>0) {
                            update scopingformstatuslist;
                        }
                        
                        if(!oppidtoprocesslogmap.containskey(oeach.id))
                        {
                            processlog = new CSLT_Integration_Process_Log__c();
                            processlog.OpportunityId__c = oeach.id;
                            
                        }
                        
                        else
                        {
                            processlog=oppidtoprocesslogmap.get(oeach.id);
                        }
                        
                        processlog.Status__c = 'SUCCESS';
                        processlog.Send_update__c = false;
                        processlog.Sent_Date_Time__c = Datetime.now();
                        processlog.Status_Message__c = resp.statusmessage;
                        processloglist.add(processlog);
                        CastLightProcessBatchStatus.CastLightProcessStatusWrapper processstatus=new CastLightProcessBatchStatus.CastLightProcessStatusWrapper();
                        processstatus.statusmessage=resp.statusmessage;
                        processstatus.status ='SUCCESS';
                        processstatuswrapper.add(processstatus);
                        
                        
                    }
                }
                Catch(Exception ex) {
                    
                    
                    if(oppidtoprocesslogmap.containskey(oeach.id))
                    {
                        processlog=oppidtoprocesslogmap.get(oeach.id);
                    }
                    
                    else
                    {
                        processlog = new CSLT_Integration_Process_Log__c();
                        processlog.OpportunityId__c = oeach.id;
                    }
                    
                    processlog.Status__c = 'ERROR';
                    processlog.Send_update__c=false;
                    processlog.Sent_Date_Time__c = Datetime.now();
                    processlog.Status_Message__c = ex.getmessage();
                    processloglist.add(processlog);
                    CastLightProcessBatchStatus.CastLightProcessStatusWrapper processstatus=new CastLightProcessBatchStatus.CastLightProcessStatusWrapper();
                    
                    processstatus.statusmessage=ex.getmessage();
                    processstatus.status ='ERROR';
                    processstatus.opp =oeach;
                    processstatuswrapper.add(processstatus);
                    
                    system.debug('Line no-->' + ex.getStackTraceString().replace('\n', ' | ') + ' | ' + ex.getMessage().replace('\n', ' '));
                    
                }
                
                
            }
            
            system.debug('processloglist final--->' + processloglist);
            
            if (!processloglist.isempty() || processloglist.size() > 0) {
                
                upsert processloglist;
                
                if(test.isrunningtest())
                {
                    throw new CustomException();
                }
            }
        }
        Catch(Exception ex) {
            
            system.debug('Line no-->' + ex.getStackTraceString().replace('\n', ' | ') + ' | ' + ex.getMessage().replace('\n', ' '));
            
            
            for(Opportunity o:opplist)
            {
                CastLightProcessBatchStatus.CastLightProcessStatusWrapper c=new CastLightProcessBatchStatus.CastLightProcessStatusWrapper();
                
                c.status ='ERROR';
                c.statusmessage =ex.getStackTraceString().replace('\n', ' | ') + ' | ' + ex.getMessage().replace('\n', ' ');
                c.opp=o;
                
                processstatuswrapper.add(c);  
            }
            
            
        }
        
        
        
    }
    
    global void execute(SchedulableContext ctx) {
        
        SendToCastLightBatch castlightbatch = new SendToCastLightBatch();
        Database.executeBatch(castlightbatch,1);
        
    }
    global void finish(Database.BatchableContext BC) {
        
        system.debug('processstatuswrapper--->'+processstatuswrapper);
        
        CastLightProcessBatchStatus.AnthToCSLTProcessStatusEmail(processstatuswrapper);
        
        
    }
}