@isTest
public class SendToCastLightBatchTest {
    
    
    @testSetup static void setup() {
        // Create common test accounts
        Id i=[SELECT DeveloperName, Id, SobjectType, IsActive FROM RecordType where SobjectType='Account' and DeveloperName='Brokerage'].Id;
        
        
        Account parentacc =new Account();
        
        parentacc.recordtypeid=i;
        parentacc.Name = 'test2';
        parentacc.Anthem_Entity__c = 'Local/Large Group';
        insert parentacc;
        
        Account acc1 = new Account(Name = 'test1',
                                   Region__c = 'West',
                                   Anthem_Entity__c = 'Local/Large Group',
                                   parentid=parentacc.id,NASCO_Contracting_Situs_State__c='60 CO',WGS_Contracting_Situs_State__c='CA California');
        
        insert acc1;
        
        system.assert(acc1.id!=null);
        
        Group__c g=new Group__c();
        g.name='test group';
        g.Account__c=acc1.id;
        insert g;
        system.assert(g.id!=null);
        Id recid=[SELECT DeveloperName, Id, SobjectType, IsActive FROM RecordType where SobjectType='Account' and DeveloperName='ServiceProvider'].Id;
        
        Account acc2 = new Account(Name = 'testcompetitor',
                                   Region__c = 'West',
                                   Anthem_Entity__c = 'Local/Large Group',
                                   recordtypeid=recid,Competitor__c=true,NASCO_Contracting_Situs_State__c='60 CO',WGS_Contracting_Situs_State__c='CA California');
        
        insert acc2;
        
        
        Brokerage_and_Consultant__c brokcons=new Brokerage_and_Consultant__c(Account__c=acc1.id,Brokerage__c=parentacc.id);
        insert brokcons;
        
        Opportunity opp1 = new Opportunity(Name = 'test opp',
                                           AccountId = acc1.id,
                                           StageName = 'Initiated',closedate=date.newInstance(2020, 01, 01));
        
        insert opp1;
        CSLT_Integration_Process_Log__c csltlog = new CSLT_Integration_Process_Log__c();
        csltlog.OpportunityId__c = opp1.Id;
        csltlog.Send_update__c = true;
        insert csltlog;
        system.assert(opp1.id!=null);
        
        Product2 prod = new Product2(Name = 'Castlight - Buy Up Products',vlocity_ins__SubType__c='Castlight',
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
		engageformstandard.Castlight_Submission_Status__c ='Ready for Submission';
        
        insert engageformstandard;
        system.assert(engageformstandard.id!=null);
        
        
        
        Engage_Standard_Employer_Programs__c prog=new Engage_Standard_Employer_Programs__c();
        prog.Employer_Program_Availability_Date__c=system.today();
        prog.Employer_Program_Eligible_Members__c='Employees Only';
        prog.Employer_Program_Email__c='test@test.com';
        prog.Employer_Program_Name__c='Onsite Clinic';
        prog.Employer_Program_Phone_Number__c='1234';
        prog.Employer_Program_Website__c='www.google.com';
        prog.Group_Suffix_Number__c='123';
        prog.If_Other_Employer_Program_Name__c='test';
        prog.Engage_Scoping_And_Engage_Standard__c=engageformstandard.id;
        
        insert prog;
        
        system.assert(prog.id!=null);
        Engage_Scoping_And_Engage_Standard__c engageformscope=new Engage_Scoping_And_Engage_Standard__c();
        
        engageformscope.recordtypeid= [SELECT DeveloperName,name, Id, SobjectType, IsActive FROM RecordType where SobjectType='Engage_Scoping_And_Engage_Standard__c' and name='Engage Scoping'].id;
        engageformscope.Contract_Type__c='Castlight Contract With Client';
        engageformscope.Client_Integrating_Wellness_Bundle__c='Yes';
        engageformscope.If_Yes_Select_All_Applicable_Wellness__c='Biometrics And Coaching;Biometrics And Coaching/Financial Health';
        engageformscope.Select_All_Ecosystem_Integrations__c='Quest Diagnostics;2Morrow;Other';
        engageformscope.If_Other_Specify_Ecosystem_Integration__c='Anthem';
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
        engageformscope.Advantage_Networks_Alpha_Prefixes__c ='test;Other';
        engageformscope.If_Other_Specify_Network__c ='test';
        engageformscope.Number_Of_Plans__c =12;
        engageformscope.Anthem_To_Provide_Comm_Support__c ='Yes';
        engageformscope.Anthem_Only_Or_Multi_Carrier__c ='Multi-Carrier';
        engageformscope.If_Multi_Carrier_Select_All_That_Apply__c ='Arkansas Blue Cross Blue Shield;Other';
        engageformscope.If_Multi_Carrier_Select_All_That_Apply__c='Aetna';
        engageformscope.If_CARVE_OUT_Select_All_That_Apply__c='Aetna Pharmacy;Other';
        engageformscope.If_Other_Specify_Rx_Carriers__c='Anthem';
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
        engageformscope.Select_All_Anthem_Dental_That_Apply__c ='Delta Dental;Other';
        engageformscope.If_Other_Anthem_Dental_Specify_Carriers__c ='test';
        engageformscope.Delta_Dental_State__c ='MI';
        engageformscope.Clinical_Shared_Data_And_Experiences__c ='LiveHealthOnline';
        engageformscope.If_Other_Clinical_Please_Specify__c ='test';
        engageformscope.Client_Have_Own_Wellness_Vendors__c ='Yes';
        engageformscope.If_Yes_Which_Vendor_Used_Today__c ='VirginPulse';
        engageformscope.Includes_Behavioral_Health_Elevate__c ='Yes';
        engageformscope.If_Behav_Health_Select_All_That_Apply__c ='Anthem;Other';
        engageformscope.If_Other_Specify_Behavior_Health__c='Anthem';
        engageformscope.IF_EAP_Select_All_That_Apply__c ='Anthem;Other';
        engageformscope.If_Other_Please_Specify_BH_EAP__c='Anthem';
        engageformscope.Anthem_Basic_of_Enhanced_EAP__c ='Basic';
        engageformscope.Incentives_Budget__c ='Yes';
        engageformscope.Is_Client_Interested_In_Incentives__c =true;
        engageformscope.Is_Client_Interested_In_Device_Credit__c =true;
        engageformscope.Device_Credit_Budget__c ='Yes';
        engageformscope.Is_Client_Interseted_In_Rewards_Center__c =true;
        engageformscope.Does_Client_Have_Anthem_Health_Rewards__c ='Yes';
        engageformscope.Client_Have_Benefit_Enrollment_Platform__c ='Yes';
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
        engageformscope.Castlight_Submission_Status__c='Ready for Re-Submission';
        engageformscope.If_Yes_Specify_BEP_Administrator__c='Other';
        engageformscope.If_Other_Specify_BEP_Administrator__c = 'Cigna';
        engageformscope.If_Yes_Please_Indicate_Rx_Vendor__c = 'Health PPO Vendor';
        
        insert engageformscope;
        system.assert(engageformscope.id!=null);
        QuoteLineItem qli1 = new QuoteLineItem(Subscribers__c = 12, 
                                               Reason__c='Funding Type Change',
                                               Probability__c='15%',
                                               ProductStage__c='In Progress',
                                               Members__c = 10,
                                               QuoteId = q1.Id,
                                               Product2Id = prod.Id,
                                               PricebookEntryId = pbe.Id,
                                               Quantity = 10,
                                               Unitprice = 10.00,Competitor__c=acc2.id);
        
        insert qli1;
        
        system.assert(qli1.id!=null);  
    }
    
    
    static testmethod void LocalGroupPositiveTesting() {
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CastLightHttpResponseSuccessMockTest());
        SendToCastLightBatch s = new SendToCastLightBatch();
        Database.executeBatch(s,1);
        Test.stopTest();
        CSLT_Integration_Process_Log__c c=[select id,Status__c,OpportunityId__c,OpportunityId__r.name from CSLT_Integration_Process_Log__c where OpportunityId__r.name ='test opp'];
        System.assert(c.id!=null);
        System.assertequals('test opp',c.OpportunityId__r.name);
        System.assertequals('SUCCESS',c.Status__c);
        
    }
    static testmethod void LocalGroupNegativeTesting() {
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CastLightHttpResponseErrorMockTest());
        SendToCastLightBatch s = new SendToCastLightBatch();
        Database.executeBatch(s,1);
        Test.stopTest();
        CSLT_Integration_Process_Log__c c=[select id,OpportunityId__c,OpportunityId__r.name,Status__c from CSLT_Integration_Process_Log__c where OpportunityId__r.name ='test opp'];
        System.assert(c.id!=null);
        System.assertequals('ERROR',c.Status__c);
        
    }
    
    static testmethod void NationalPositiveTesting() {
        
        
        Id i=[SELECT DeveloperName, Id, SobjectType, IsActive FROM RecordType where SobjectType='Account' and DeveloperName='LG_Brokerage'].Id;
        
        Account acc=[select id,Tax_ID__c,recordtypeid,Anthem_Entity__c from Account where name='test2'];
        acc.recordtypeid=i;
        acc.Anthem_Entity__c = 'National Accounts';
        acc.Tax_ID__c='123456789';
        update acc;
        
        
        Account act=[select id,parentid,Anthem_Entity__c from Account where name='test1'];
        act.parentid=acc.id;
        act.Anthem_Entity__c = 'National Accounts';
        update act;
        
        
        system.assert(act.id!=null);
        
        
        Opportunity o=[select id,name,accountid from opportunity where name='test opp'];
        
        system.assert(o.id!=null);
        
        
        Brokerage_and_Consultant1__c brokcons=new Brokerage_and_Consultant1__c(Opportunity__c=o.id,Brokerage__c=acc.id);
        insert brokcons;
        system.assert(brokcons.id!=null);
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CastLightHttpResponseSuccessMockTest());
        SendToCastLightBatch s = new SendToCastLightBatch();
        Database.executeBatch(s,1);
        Test.stopTest();
        CSLT_Integration_Process_Log__c c=[select id,Status__c,OpportunityId__c,OpportunityId__r.name from CSLT_Integration_Process_Log__c where OpportunityId__r.name ='test opp'];
        System.assert(c.id!=null);
        System.assertequals('test opp',c.OpportunityId__r.name);
        System.assertequals('SUCCESS',c.Status__c);
        
    }
    static testmethod void NationalNegativeTesting() {
        
        
        Id i=[SELECT DeveloperName, Id, SobjectType, IsActive FROM RecordType where SobjectType='Account' and DeveloperName='LG_Brokerage'].Id;
        
        Account acc=[select id,Tax_ID__c,recordtypeid,Anthem_Entity__c from Account where name='test2'];
        acc.recordtypeid=i;
        acc.Anthem_Entity__c = 'National Accounts';
        acc.Tax_ID__c='123456789';
        update acc;
        
        
        Account act=[select id,parentid,Anthem_Entity__c from Account where name='test1'];
        act.parentid=acc.id;
        act.Anthem_Entity__c = 'National Accounts';
        update act;
        
        
        system.assert(act.id!=null);
        
        Opportunity o=[select id,name,accountid from opportunity where name='test opp'];
        
        system.assert(o.id!=null);
        
        
        Brokerage_and_Consultant1__c brokcons=new Brokerage_and_Consultant1__c(Opportunity__c=o.id,Brokerage__c=acc.id);
        insert brokcons;
        system.assert(brokcons.id!=null);
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CastLightHttpResponseErrorMockTest());
        SendToCastLightBatch s = new SendToCastLightBatch();
        Database.executeBatch(s,1);
        Test.stopTest();
        CSLT_Integration_Process_Log__c c=[select id,Status__c,OpportunityId__c,OpportunityId__r.name from CSLT_Integration_Process_Log__c where OpportunityId__r.name ='test opp'];
        System.assert(c.id!=null);
        System.assertequals('test opp',c.OpportunityId__r.name);
        System.assertequals('ERROR',c.Status__c);
    }
    static testmethod void TokenTableTest()
    {
        
        CastLightAccessToken__c accesstoken=new CastLightAccessToken__c(Name = 'TokenforCastLight',CreatedTime__c=Datetime.now(),Access_Token__c='00D5B000000DfYA!AQQAQMWa.1nYVpTjBgNgtB9G3P53oBK43YqCWzqfqroXbywU6J1edt3QoEvJIrHuVsA7bMkAh77_IUfJtJ6Bu9f.nKnij3Dn');
        insert accesstoken;
        system.assert(accesstoken.id!=null);
        Test.startTest();
        
        CastLightIntegrationUtility.QueryTokenTable();
        CastLightIntegrationUtility.UpdateTokenTable();
        
        Test.stopTest();
        
        
    }
    static testmethod void SchedularTest() {
        Test.startTest();
        
        System.schedule('test', '0 0 * * * ?', new SendToCastLightBatch());
        
        Test.stopTest();
    }
    
    
    
}