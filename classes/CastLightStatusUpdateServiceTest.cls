@isTest
public class CastLightStatusUpdateServiceTest{
    
    static testmethod void CSLTToAnthNegativeTest() {
        
        /*
        Engage_Scoping_And_Engage_Standard__c engageformstandard=new Engage_Scoping_And_Engage_Standard__c();
        
        engageformstandard.recordtypeid= [SELECT DeveloperName,name, Id, SobjectType, IsActive FROM RecordType where SobjectType='Engage_Scoping_And_Engage_Standard__c' and name='Engage Standard'].id;
        engageformstandard.Quote_Name__c=q1.id;
        engageformstandard.Member_Support_Phone_Number__c='1234556';
        engageformstandard.Member_Support_Hours_Of_Availability__c='test';
        engageformstandard.Est_Receipt_Date_Of_1st_Prod_Elig_File__c=system.today();
        engageformstandard.Est_Receipt_Date_of_1st_Prod_OE_File__c=system.today();
        engageformstandard.Start_Date_Of_Customer_Contract__c=system.today();
        engageformstandard.End_Date_Of_Customer_Contract__c=system.today();
        engageformstandard.Anthem_Health_Guide__c='Yes';
        engageformstandard.MyHealthAdvantage__c='Yes';
        engageformstandard.Live_Health_Online_Offering__c='Live Health Online Medical Only';
        engageformstandard.BioIQ__c='Yes';
        engageformstandard.WebMD_HRA_Program__c='Yes';
        engageformstandard.Activity_Nutrition_Sleep_Programs__c='Yes';
        engageformstandard.Anthem_Health_Rewards__c='Yes';
        engageformstandard.ASH_Gym_Reimbursement_Buyup__c='Yes';
        engageformstandard.ASH_Program_Name__c='Yes';
        engageformstandard.ASH_Eligible_Members__c='Employees Only';
        insert engageformstandard;
        system.assert(engageformstandard.id!=null);
        
        Engage_Scoping_And_Engage_Standard__c engageformscope=new Engage_Scoping_And_Engage_Standard__c();
        
        engageformscope.recordtypeid= [SELECT DeveloperName,name, Id, SobjectType, IsActive FROM RecordType where SobjectType='Engage_Scoping_And_Engage_Standard__c' and name='Engage Scoping'].id;
        engageformscope.Contract_Type__c='Castlight Contract With Client';
        engageformscope.If_No_Specify_Alternative_Arrangement__c='test';
        engageformscope.Quote_Name__c=q1.id;
        engageformscope.Number_Total_Membership_Elite__c =12;
        engageformscope.Number_Total_Membership_Elite_Plus__c =12;
        engageformscope.Number_Total_Membership_Essentials__c =12;
        engageformscope.Number_Total_Membership_Essentials_non__c=12;
        engageformscope.Number_Total_Membership_Essentials_Plus__c =12;
        engageformscope.Castlight_Contract_Sign_Date__c =system.today();
        engageformscope.When_Does_Plan_Year_Start__c =system.today();
        engageformscope.Anthem_Contract_Sign_Date__c =system.today();
        engageformscope.When_Is_Open_Enrollment__c =system.today();
        engageformscope.Existing_Client_Changes_Effective_Date__c =system.today();
        engageformscope.Registration_Availability_During_OE__c ='Yes';
        engageformscope.Client_Termination_Effective_Date__c =system.today();
        engageformscope.Client_Preferred_Launch_Date_For_Engage__c =system.today();
        engageformscope.Number_Subscribers_Elite_Plus__c =12;
        engageformscope.Number_Subscribers_Elite__c =12;
        engageformscope.Number_Subscribers_Essentials_Plus__c =12;
        engageformscope.Number_Subscribers_Essentials__c =12;
        engageformscope.Number_Subscribers_Essentials_non__c =12;
        engageformscope.Care_And_Cost_Finder_CCF__c =true;
        engageformscope.EYC_And_FAD__c =true;
        engageformscope.National_Networks_Alpha_Prefixes__c ='test';
        engageformscope.Advantage_Networks_Alpha_Prefixes__c ='test';
        engageformscope.If_Other_Specify_Network__c ='test';
        engageformscope.Number_Of_Plans__c =12;
        engageformscope.Anthem_To_Provide_Comm_Support__c ='Yes';
        engageformscope.Anthem_Only_Or_Multi_Carrier__c ='Multi-Carrier';
        engageformscope.If_Multi_Carrier_Select_All_That_Apply__c ='Arkansas Blue Cross Blue Shield';
        engageformscope.If_CARVE_OUT_Select_All_That_Apply__c='Aetna Pharmacy';
        engageformscope.Is_Pharmacy_Included__c ='Yes';
        engageformscope.ESI_Carve_In__c ='Yes';
        engageformscope.Past_2_Year_Pharmacy_Claim_History__c =true;
        engageformscope.Two_Year_Pharmacy_Group_Numbers__c ='test';
        engageformscope.Future_Pharmacy_Claims__c =true;
        engageformscope.Future_Pharmacy_Group_Numbers__c ='test';
        //engageformscope.If_Other_Specify_Rx_Carriers__c ='test';
        engageformscope.Is_There_Anthem_Dental__c ='Yes';
        engageformscope.Anthem_Dental_Carrier__c ='Anthem Dental Prime And Complete';
        engageformscope.Past_2_Year_Dental_Claim_History__c =true;
        engageformscope.Two_Year_Dental_Group_Numbers__c ='test';
        engageformscope.Future_Dental_Claims__c =true;
        engageformscope.Future_Dental_Group_Numbers__c ='test';
        engageformscope.Select_All_Anthem_Dental_That_Apply__c ='Delta Dental';
        engageformscope.If_Other_Anthem_Dental_Specify_Carriers__c ='test';
        engageformscope.Delta_Dental_State__c ='MI';
        engageformscope.Clinical_Shared_Data_And_Experiences__c ='LiveHealthOnline';
        engageformscope.If_Other_Clinical_Please_Specify__c ='test';
        engageformscope.Client_Have_Own_Wellness_Vendors__c ='Yes';
        engageformscope.If_Yes_Which_Vendor_Used_Today__c ='VirginPulse';
        engageformscope.Includes_Behavioral_Health_Elevate__c ='Yes';
        engageformscope.If_Behav_Health_Select_All_That_Apply__c ='Anthem';
        engageformscope.IF_EAP_Select_All_That_Apply__c ='Anthem';
        engageformscope.Anthem_Basic_of_Enhanced_EAP__c ='Basic';
        engageformscope.Incentives_Budget__c ='Yes';
        engageformscope.Is_Client_Interested_In_Incentives__c =true;
        engageformscope.Is_Client_Interested_In_Device_Credit__c =true;
        engageformscope.Device_Credit_Budget__c ='Yes';
        engageformscope.Is_Client_Interseted_In_Rewards_Center__c =true;
        engageformscope.Does_Client_Have_Anthem_Health_Rewards__c ='Yes';
        engageformscope.Client_Have_Benefit_Enrollment_Platform__c ='Yes';
        engageformscope.If_Other_Specify_BEP_Administrator__c ='test';
        engageformscope.Embed_Registration_Into_AE_And_NHE__c ='Yes';
        engageformscope.Does_The_Client_Have_Onsite_Clinics__c ='Yes';
        engageformscope.If_Yes_Specify_OC_Administrator__c ='CHS';
        engageformscope.HSA_Health_Account__c =true;
        engageformscope.If_Yes_Specify_HSA_Vendor__c='Act Wise';
        engageformscope.FSA_Health_Account__c=true;
        engageformscope.If_Yes_Specify_FSA_Vendor__c='Act Wise';
        engageformscope.HRA_Health_Account__c=true;
        engageformscope.If_Yes_Specify_HRA_Vendor__c='Act Wise';
        engageformscope.Specify_Account_Type_And_Vendor_Details__c='test';
        engageformscope.Is_Inbound_SSO_Required__c='Yes';
        engageformscope.Inbound_SSO_Partners_Desired__c='Accolade';
        engageformscope.Is_Outbound_SSO_Required__c='Yes';
        engageformscope.Outbound_SSO_Partners_Desired__c='Anthem';
        insert engageformscope;
        system.assert(engageformscope.id!=null);*/
        
        
        string msg='{"Accounts": [{"RenewalDate":"2018-01-01","ParentAccountName":"test2","Opportunities":[{"OppStage":"Initiated","OpportunityProducts":[{"ProductName":"Castlight - Buy Up Products","ProdSubscribers":"12","ProdStage":"In Progress","ProdReason":"Funding Type Change","ProdProbability":"15%","ProdMembers":"10","ProdLOB":"Medical","CompetitorName":"test"}],"OpportunityID":"0065B00000AKc8yQAD","OppEffectiveDate":"2018-07-17","OppDescription":"testing","CSLT_StageName":"test","CSLT_OpportunityID":"0065B00000AKc8yQAD","CSLT_CloseDate":"2018-01-01"}],"Member":"test","DUNSNUmber":"123456","DirectorofSalesAM_Phone":"123","DirectorofSalesAM_Email":"test@test.com","DirectorofSalesAM":"test","CSLT_Open_Enrollment_Type":"Active","CSLT_Open_Enrollment_Start_Date":"2018-01-01","CSLT_Open_Enrollment_End_Date":"2018-01-01","CSLT_AccountOwnerName":"test","CSLT_AccountOwnerEmail":"test@test.com","ConsultantFirm":"test","BillingStreet":"test","BillingState":"test","BillingPostalCode":"123","BillingCountry":"test","BillingCity":"test","AnthemORGID":"Com2","AcctExecPhone":"123","AcctExecEmail":"test","AcctExec":"test","AccountWebSite":"test","AccountType":"Local/Large Group","AccountRegion":"West","AccountName":"test1","AccountID":"0015B00000TM0tGQAT"}]}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CSLTStatusUpdate';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        //RestResponse res = RestContext.response;
        CastLightStatusUpdateService.doPost();
        System.assertEquals(500, res.statusCode);
        Test.stopTest();
        
    }
    
    static testmethod void CSLTToAnthPositiveTest() {
        
        
        
        
        
        Account acc2 = new Account(Name = 'testcompetitor',
                                   Region__c = 'West',
                                   Anthem_Entity__c = 'Local/Large Group',Competitor__c=true);
        
        insert acc2;
        
        Opportunity opp1 = new Opportunity(CloseDate = system.today(),
                                           Name = 'test opp',
                                           AccountId = acc2.id,
                                           StageName = 'Initiated');
        
        insert opp1;
        
        
        Group__c g=new Group__c();
        g.name='test group';
        g.Account__c=acc2.id;
        insert g;
        system.assert(g.id!=null);
     
        
       
        
        Product2 prod = new Product2(Name = 'Castlight - Buy Up Products',
                                     IsActive = true,LOB__c='Medical');
        
        insert prod;
        
        system.assert(prod.id!=null);
        Id pricebookId = Test.getStandardPricebookId();
        
        
        PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                          Product2Id = prod.Id,
                                                          UnitPrice = 10000, IsActive = true);
        
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        
        insert customPB;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
        
        
        Quote q1 = new Quote(Name = 'test Quote',
                             Pricebook2Id = customPB.Id,
                             OpportunityId = opp1.Id,GroupNumber__c=g.id);
        
        insert q1;
        
        system.assert(q1.id!=null);
        
        CastLightRequestResponse csltReqResScoping = new CastLightRequestResponse();
        CastLightRequestResponse.ScopingForm scopeForm = new CastLightRequestResponse.ScopingForm();
        scopeForm.CSLTFormStatus = 'Test';
        scopeForm.AnthemRecordId = 'a7r5B0000008T8MQAU';
        
        
         CastLightRequestResponse csltReqResStandard = new CastLightRequestResponse();
        CastLightRequestResponse.StandardForm standardForm = new CastLightRequestResponse.StandardForm();
        standardForm.CSLTFormStatus = 'Test';
        
        Engage_Scoping_And_Engage_Standard__c engageformstandard=new Engage_Scoping_And_Engage_Standard__c();
        
        engageformstandard.recordtypeid= [SELECT DeveloperName,name, Id, SobjectType, IsActive FROM RecordType where SobjectType='Engage_Scoping_And_Engage_Standard__c' and name='Engage Standard'].id;
        engageformstandard.Quote_Name__c=q1.id;
        engageformstandard.Member_Support_Phone_Number__c='1234556';
        engageformstandard.Member_Support_Hours_Of_Availability__c='test';
        engageformstandard.Est_Receipt_Date_Of_1st_Prod_Elig_File__c=system.today();
        engageformstandard.Est_Receipt_Date_of_1st_Prod_OE_File__c=system.today();
        engageformstandard.Start_Date_Of_Customer_Contract__c=system.today();
        engageformstandard.End_Date_Of_Customer_Contract__c=system.today();
        engageformstandard.Anthem_Health_Guide__c='Yes';
        engageformstandard.MyHealthAdvantage__c='Yes';
        engageformstandard.Live_Health_Online_Offering__c='Live Health Online Medical Only';
        engageformstandard.BioIQ__c='Yes';
        engageformstandard.WebMD_HRA_Program__c='Yes';
        engageformstandard.Activity_Nutrition_Sleep_Programs__c='Yes';
        engageformstandard.Anthem_Health_Rewards__c='Yes';
        engageformstandard.ASH_Gym_Reimbursement_Buyup__c='Yes';
        engageformstandard.ASH_Program_Name__c='Yes';
        engageformstandard.ASH_Eligible_Members__c='Employees Only';
        insert engageformstandard;
        system.assert(engageformstandard.id!=null);
        
        Engage_Scoping_And_Engage_Standard__c engageformscope=new Engage_Scoping_And_Engage_Standard__c();
        
        engageformscope.recordtypeid= [SELECT DeveloperName,name, Id, SobjectType, IsActive FROM RecordType where SobjectType='Engage_Scoping_And_Engage_Standard__c' and name='Engage Scoping'].id;
        engageformscope.Contract_Type__c='Castlight Contract With Client';
        engageformscope.If_No_Specify_Alternative_Arrangement__c='test';
        engageformscope.Quote_Name__c=q1.id;
        engageformscope.Number_Total_Membership_Elite__c =12;
        engageformscope.Number_Total_Membership_Elite_Plus__c =12;
        engageformscope.Number_Total_Membership_Essentials__c =12;
        engageformscope.Number_Total_Membership_Essentials_non__c=12;
        engageformscope.Number_Total_Membership_Essentials_Plus__c =12;
        engageformscope.Castlight_Contract_Sign_Date__c =system.today();
        engageformscope.When_Does_Plan_Year_Start__c =system.today();
        engageformscope.Anthem_Contract_Sign_Date__c =system.today();
        engageformscope.When_Is_Open_Enrollment__c =system.today();
        engageformscope.Existing_Client_Changes_Effective_Date__c =system.today();
        engageformscope.Registration_Availability_During_OE__c ='Yes';
        engageformscope.Client_Termination_Effective_Date__c =system.today();
        engageformscope.Client_Preferred_Launch_Date_For_Engage__c =system.today();
        engageformscope.Number_Subscribers_Elite_Plus__c =12;
        engageformscope.Number_Subscribers_Elite__c =12;
        engageformscope.Number_Subscribers_Essentials_Plus__c =12;
        engageformscope.Number_Subscribers_Essentials__c =12;
        engageformscope.Number_Subscribers_Essentials_non__c =12;
        engageformscope.Care_And_Cost_Finder_CCF__c =true;
        engageformscope.EYC_And_FAD__c =true;
        engageformscope.National_Networks_Alpha_Prefixes__c ='test';
        engageformscope.Advantage_Networks_Alpha_Prefixes__c ='test';
        engageformscope.If_Other_Specify_Network__c ='test';
        engageformscope.Number_Of_Plans__c =12;
        engageformscope.Anthem_To_Provide_Comm_Support__c ='Yes';
        engageformscope.Anthem_Only_Or_Multi_Carrier__c ='Multi-Carrier';
        engageformscope.If_Multi_Carrier_Select_All_That_Apply__c ='Arkansas Blue Cross Blue Shield';
        engageformscope.If_CARVE_OUT_Select_All_That_Apply__c='Aetna Pharmacy';
        engageformscope.Is_Pharmacy_Included__c ='Yes';
        engageformscope.ESI_Carve_In__c ='Yes';
        engageformscope.Past_2_Year_Pharmacy_Claim_History__c =true;
        engageformscope.Two_Year_Pharmacy_Group_Numbers__c ='test';
        engageformscope.Future_Pharmacy_Claims__c =true;
        engageformscope.Future_Pharmacy_Group_Numbers__c ='test';
        //engageformscope.If_Other_Specify_Rx_Carriers__c ='test';
        engageformscope.Is_There_Anthem_Dental__c ='Yes';
        engageformscope.Anthem_Dental_Carrier__c ='Anthem Dental Prime And Complete';
        engageformscope.Past_2_Year_Dental_Claim_History__c =true;
        engageformscope.Two_Year_Dental_Group_Numbers__c ='test';
        engageformscope.Future_Dental_Claims__c =true;
        engageformscope.Future_Dental_Group_Numbers__c ='test';
        engageformscope.Select_All_Anthem_Dental_That_Apply__c ='Delta Dental';
        engageformscope.If_Other_Anthem_Dental_Specify_Carriers__c ='test';
        engageformscope.Delta_Dental_State__c ='MI';
        engageformscope.Clinical_Shared_Data_And_Experiences__c ='LiveHealthOnline';
        engageformscope.If_Other_Clinical_Please_Specify__c ='test';
        engageformscope.Client_Have_Own_Wellness_Vendors__c ='Yes';
        engageformscope.If_Yes_Which_Vendor_Used_Today__c ='VirginPulse';
        engageformscope.Includes_Behavioral_Health_Elevate__c ='Yes';
        engageformscope.If_Behav_Health_Select_All_That_Apply__c ='Anthem';
        engageformscope.IF_EAP_Select_All_That_Apply__c ='Anthem';
        engageformscope.Anthem_Basic_of_Enhanced_EAP__c ='Basic';
        engageformscope.Incentives_Budget__c ='Yes';
        engageformscope.Is_Client_Interested_In_Incentives__c =true;
        engageformscope.Is_Client_Interested_In_Device_Credit__c =true;
        engageformscope.Device_Credit_Budget__c ='Yes';
        engageformscope.Is_Client_Interseted_In_Rewards_Center__c =true;
        engageformscope.Does_Client_Have_Anthem_Health_Rewards__c ='Yes';
        engageformscope.Client_Have_Benefit_Enrollment_Platform__c ='Yes';
        engageformscope.If_Other_Specify_BEP_Administrator__c ='test';
        engageformscope.Embed_Registration_Into_AE_And_NHE__c ='Yes';
        engageformscope.Does_The_Client_Have_Onsite_Clinics__c ='Yes';
        engageformscope.If_Yes_Specify_OC_Administrator__c ='CHS';
        engageformscope.HSA_Health_Account__c =true;
        engageformscope.If_Yes_Specify_HSA_Vendor__c='Act Wise';
        engageformscope.FSA_Health_Account__c=true;
        engageformscope.If_Yes_Specify_FSA_Vendor__c='Act Wise';
        engageformscope.HRA_Health_Account__c=true;
        engageformscope.If_Yes_Specify_HRA_Vendor__c='Act Wise';
        engageformscope.Specify_Account_Type_And_Vendor_Details__c='test';
        engageformscope.Is_Inbound_SSO_Required__c='Yes';
        engageformscope.Inbound_SSO_Partners_Desired__c='Accolade';
        engageformscope.Is_Outbound_SSO_Required__c='Yes';
        engageformscope.Outbound_SSO_Partners_Desired__c='Anthem';
        insert engageformscope;
        system.assert(engageformscope.id!=null);
        
        
        
        Id actid=[select id from account where id=:acc2.id].id;
        Id oppid=[select id from opportunity where id=:opp1.id].id;
        string actidstring='"'+actid+'"';
        string oppidstring= '"'+oppid;
        
        Id engageformscopeid=[select id from Engage_Scoping_And_Engage_Standard__c where id=:engageformscope.id].id;
        string engageformscopeidstring='"'+engageformscopeid+'"';
        
        Id engageformstandardid=[select id from Engage_Scoping_And_Engage_Standard__c where id=:engageformstandard.id].id;
        string engageformstandardidstring='"'+engageformstandardid+'"';
        //string msg='{"Accounts": [{"RenewalDate":"2018-01-01","ParentAccountName":"test2","Opportunities":[{"OppStage":"Initiated","OpportunityProducts":[{"ProductName":"Castlight - Buy Up Products","ProdSubscribers":"12","ProdStage":"In Progress","ProdReason":"Funding Type Change","ProdProbability":"15%","ProdMembers":"10","ProdLOB":"Medical","CompetitorName":"test"}],"OpportunityID":oppid,"OppEffectiveDate":"2018-07-17","OppDescription":"testing","CSLT_StageName":"test","CSLT_OpportunityID":oppid,"CSLT_CloseDate":"2018-01-01"}],"Member":"test","DUNSNUmber":"123456","DirectorofSalesAM_Phone":"123","DirectorofSalesAM_Email":"test@test.com","DirectorofSalesAM":"test","CSLT_Open_Enrollment_Type":"Active","CSLT_Open_Enrollment_Start_Date":"2018-01-01","CSLT_Open_Enrollment_End_Date":"2018-01-01","CSLT_AccountOwnerName":"test","CSLT_AccountOwnerEmail":"test@test.com","ConsultantFirm":"test","BillingStreet":"test","BillingState":"test","BillingPostalCode":"123","BillingCountry":"test","BillingCity":"test","AnthemORGID":"Com2","AcctExecPhone":"123","AcctExecEmail":"test","AcctExec":"test","AccountWebSite":"test","AccountType":"Local/Large Group","AccountRegion":"West","AccountName":"test1","AccountID":actid}]}';
        string msg='{"Accounts": [{"RenewalDate":"2018-01-01","Opportunities":[{"OppStage":"Initiated","OpportunityID":'+oppidstring+'","OppEffectiveDate":"2018-07-17","OppDescription":"testing","CSLT_StageName":"test","CSLT_OpportunityID":'+oppidstring+'","CSLT_CloseDate":"2018-01-01", "ScopingForms":[{"AnthemRecordID" :'+engageformscopeidstring+',"CSLTFormStatus":"In Progress"}  ],"StandardForms":[{"AnthemRecordID" :'+engageformstandardidstring+',"CSLTFormStatus":"In Progress"}  ]}],"Member":"test","DUNSNUmber":"123456","DirectorofSalesAM_Phone":"123","DirectorofSalesAM_Email":"test@test.com","DirectorofSalesAM":"test","CSLT_Open_Enrollment_Type":"Active","CSLT_Open_Enrollment_Start_Date":"2018-01-01","CSLT_Open_Enrollment_End_Date":"2018-01-01","CSLT_AccountOwnerName":"test","CSLT_AccountOwnerEmail":"test@test.com","ConsultantFirm":"test","BillingStreet":"test","BillingState":"test","BillingPostalCode":"123","BillingCountry":"test","BillingCity":"test","AnthemORGID":"Com2","AcctExecPhone":"123","AcctExecEmail":"test","AcctExec":"test","AccountWebSite":"test","AccountType":"Local/Large Group","AccountRegion":"West","AccountName":"test1","AccountID":'+actidstring+'}]}';
        system.debug('json'+msg);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CSLTStatusUpdate';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        
        CastLightStatusUpdateService.doPost();
        System.assertEquals(200, res.statusCode);
        System.assertEquals(Blob.valueof('Opportunity status processed successfully'), res.responseBody);
        Castlight_Opportunity__c c=[select id,CSLT_Account_Owner__c,OpportunityId__c from Castlight_Opportunity__c where OpportunityId__c=:oppid];
        system.assertEquals('test', c.CSLT_Account_Owner__c);
        
        Test.stopTest();
        
    }
    
    
}