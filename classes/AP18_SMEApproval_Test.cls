/*
 * This Class is a test class for the AP18_SMEApproval class
 * 
 */
@isTest(seealldata=true)
private class AP18_SMEApproval_Test{
     private static final string NATIONALIMPLEMENTATIONPROFILE='National Implementations'; 
     private static Profile profileNA = [select id from profile where name=:NATIONALIMPLEMENTATIONPROFILE limit 1];
     private static User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
   /*This is testmethod for 'Onsite Clinic' department. */
   static testMethod void testOnsiteClinicDept() {//1
       String deptTested = departmentTesting('Onsite Clinics','Onsite Clinic','RFP');
       test.starttest();
       system.runAs(user) { 
       test.stoptest();
       if (String.isNotBlank(deptTested)){
        System.assertEquals('Onsite Clinics',deptTested ); 
       }
      }
      
      } 
   /*This is testmethod for 'Bold' department. */
   static testMethod void testBoldDept() {//2
        test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('BOLD','Bold','RFP');
        test.stoptest();
        if (String.isNotBlank(deptTested)){
        System.assertEquals('Onsite Clinics',deptTested ); 
       }
       }
      
      }
   /*This is testmethod for 'Underwriting' department. */
   static testMethod void testUnderWritingDept() {//2
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('BOLD','Underwriting','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
        System.assertEquals('Underwriting',deptTested ); 
       }
       }
     
      }   
   /* This is testmethod for 'Life' department. */
   static testMethod void testLitesDept() {//3
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Medical-CDHP - HRA','LITES CDH','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
        System.assertEquals('LITES CDH',deptTested ); 
       }
      }
      
      }
   /*This is testmethod for 'MHA' department. */
   static testMethod void testMHADept() {//4
       test.starttest();
       system.runAs(user) { 
        String deptTested =  departmentTesting('Mercer Health Advantage','Mercer Health Advantage','RFP');
        test.stoptest();
        if (String.isNotBlank(deptTested)){
        System.assertEquals('Mercer Health Advantage',deptTested ); 
       }
      } 
      
      }
    /*This is testmethod for 'Health Equity' department. */
    static testMethod void testHealthEquityDept() {//5
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Benefits Admin: COBRA','HealthEquity/WageWorks/FSA/COBRA','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Mercer Health Advantage',deptTested ); 
       }
      }
      
      }
    /* This is testmethod for 'Dental' department. */
     static testMethod void testDentalDept() {//6
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Dental - Anthem Dental National PPO (all)','Dental','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Dental',deptTested ); 
       }
      }
      
      }
    /* This is testmethod for 'Life' department. */
       static testMethod void testLifeDept() {//7
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Life - Accidental Death & Dismemberment','Life','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Life',deptTested ); 
       }
      }
      
      }
    /* This is testmethod for 'IHM' department. */
       static testMethod void testIHMDept() {//8
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Integrated Health Model','IHM','RFP');
        if (String.isNotBlank(deptTested)){
        System.assertEquals('IHM',deptTested ); 
       }
      }
     
      }
     /* This is testmethod for 'EAP' department. */
         static testMethod void testEAPDept() {//9
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('EAP - Basic EAP','EAP','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('EAP',deptTested ); 
       }
      }
      
      }
     /*This is testmethod for 'Pharmacy' department. */
       static testMethod void testPharmacyDept() {//10
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Pharmacy - Anthem Pharmacy Services','Pharmacy','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Pharmacy',deptTested ); 
       }
      }
      
      }
     /* This is testmethod for 'NCN' department. */
       static testMethod void testNCNDept() {//11
       test.starttest();
       system.runAs(user) { 
        String deptTested =  departmentTesting('Network Based - Non-Par Provider Reimbursement (NCN)','NCN','RFP');
        test.stoptest();
        if (String.isNotBlank(deptTested)){
        System.assertEquals('NCN',deptTested ); 
       }
      }
      
      }
     /*This is testmethod for 'Live Health Online' department. */
       static testMethod void testLVHDept() {//12
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Health and Wellness - Live Health Online','Live Health Online','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Live Health Online',deptTested ); 
       }
      }
      
      }
     /* This is testmethod for 'Tele Health' department. */
       static testMethod void testTHGDept() {//13
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Health and Wellness - Telehealth - Other Vendor','TeleHealth','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('TeleHealth',deptTested ); 
       }
      }
      
      } 
     /* This is testmethod for 'Anthem Health Guide' department. */
       static testMethod void testHGDept() {//14
       Profile profileNA = [select id from profile where name=:NATIONALIMPLEMENTATIONPROFILE limit 1];
       User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Other-Anthem Health Guide','Anthem Health Guide','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Anthem Health Guide',deptTested ); 
       }
      }
      
      }
    /* This is testmethod for 'Live Health Online' department. */
      static testMethod void testLiveHealthOnlineDept() {//15
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Health and Wellness - Live Health Online','Live Health Online','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Live Health Online',deptTested ); 
       }
      }
      
      }
    /* This is testmethod for 'Act Wise FSA' department. */
       static testMethod void testActWiseFSADept() {//16
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Benefits Admin - Act Wise FSA','Act Wise FSA','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Act Wise FSA',deptTested ); 
       }
      }
      
      }
    /* This is testmethod for 'Act wise CDH' department. */
       static testMethod void testActWiseCDHDept() {//17
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('Medical - Act Wise CDHP HRA','Act Wise CDH','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Act Wise CDH',deptTested ); 
       }
       
      }
      
      }
      /* This is testmethod for 'CCM' department. */
       static testMethod void testActWiseCCMDept() {//18
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting('BOLD','Coordinated Care Model','New Eligibility Vendor Setup');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Coordinated Care Model',deptTested ); 
       }
      }
      
      }
     /* This is testmethod for 'Spider' department. */
       static testMethod void testSpiderDept() {//19
       test.starttest();
       system.runAs(user) { 
       String deptTested =   departmentTesting( 'Medical - Act Wise CDHP HRA','Spider','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Spider',deptTested ); 
       }
      }
      
      }
     /* This is testmethod for 'Implementations' department. */
       static testMethod void testImplementationsDept() {//20
       test.starttest();
       system.runAs(user) { 
       String deptTested =   departmentTesting( 'BOLD','Implementations','New Eligibility Vendor Setup');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Implementations',deptTested ); 
       }
      }
      
      }
      /*This is testmethod for 'Medical Benefits' department. */
       static testMethod void testMedicalBenifitsDept() {//21
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting( 'Stop Loss - Stop Loss - Aggregate & Specific','Medical Benefits','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Medical Benefits',deptTested ); 
       }
      }
     
      }
      /*This is testmethod for 'SBC' department. */
      static testMethod void testSBCDept() {//22
      test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting( 'BOLD','SBC','SBC');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('SBC',deptTested ); 
       }
      }
      
      }
      /*This is testmethod for 'ID Cards' department. */
       static testMethod void testIDCardDept() {//23
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting( 'BOLD','ID Cards','New Eligibility Vendor Setup');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('ID Cards',deptTested ); 
       }
      }
      
      }
      /*This is testmethod for 'Group Services' department. */
       static testMethod void testGroupServicesDept() {//24
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting( 'BOLD','Group Services','New Eligibility Vendor Setup');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Group Services',deptTested ); 
       }
      }
      
      }
      /*This is testmethod for 'Enrollment and Billing' department. */
       static testMethod void testEnrollNBillingDept() {//25
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting( 'BOLD','Enrollment and Billing (E/B)','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Enrollment and Billing (E/B)',deptTested ); 
       }
      }
      
      }
     /* This is testmethod for 'DIT' department. */
       static testMethod void testDITDept() {//26
       test.starttest();
       system.runAs(user) { 
       String deptTested =  departmentTesting( 'BOLD','Data Interface Team (DIT)','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Data Interface Team (DIT)',deptTested ); 
       }
      }
     
      }
    /* This is testmethod for 'Claims' department. */
       static testMethod void testClaimsDept() {//27
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting( 'Medical - Act Wise CDHP HRA','SME Claims','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('SME Claims',deptTested ); 
       }
      }
      
      }
    
      /*This is testmethod for 'De Care' department. */
       static testMethod void testDeCareDept() {//28
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Dental: Dental Complete (DeCare)','DeCare','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('DeCare',deptTested ); 
       }
      }
      
      }
      /*This is testmethod for 'Benefits Booklets/Contracts' department. */
       static testMethod void testBookletsContractsDept() {//29
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting( 'Anthem FlexHour Medical','Benefit Booklets/Contracts','Benefit Booklets/Contracts');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Benefit Booklets/Contracts',deptTested ); 
       }
      }
       
      }
      /* This is testmethod for 'Virtual Second Openion' department. */
       static testMethod void testVirtualSecondOpnion() {//30
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Virtual Second Opinion','Virtual Second Opinion','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Virtual Second Opinion',deptTested ); 
       }
       
      }
      
      }  
     /* This is testmethod for 'Anthem Flex Hour' department. */
       static testMethod void testAnthemFlexHour() {//31
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Anthem FlexHour Vision Plan','Anthem Flex Hour','RFP');
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Anthem FlexHour Vision Plan',deptTested ); 
       }
      }
      
      } 
      /* This is testmethod for 'Vision' department. */
       static testMethod void testVision() {//31
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Vision - Blue View Vision','Vision','RFP');     
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Vision - Blue View Vision',deptTested ); 
       }
      }
      
      } 
        /* This is testmethod for 'Medical Benefits NASCO Retro ' department. */
       static testMethod void testMedicalRetro() {//32
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Medical - Act Wise CDHP HRA','Medical Benefits - NASCO Retro','RFP');     
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Vision - Blue View Vision',deptTested ); 
       }
      }
      
      }  
      /* This is testmethod for 'UM Intake ' department. */
       static testMethod void testUMIntake() {//33
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Medical - Act Wise CDHP HRA','UM Intake','RFP');     
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('UM Intake',deptTested ); 
       }
      }      
      }
      /* This is testmethod for 'JAA/NTS' department. */
       static testMethod void testJaaNtsDept() {//34
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('BOLD','JAA/NTS','New Business');     
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('JAA/NTS',deptTested ); 
       }
      }
      
      } 
       /* This is testmethod for 'Claims Retro' department. */
       static testMethod void testClaimsRetro() {//35
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Medical - Act Wise CDHP HRA','Claims Retro','RFP');     
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Claims Retro',deptTested ); 
       }
      }
      
      }  
      /* This is testmethod for 'Blue Exchange (BX) ' department. */
       static testMethod void testBlueExchange() {//36
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Medical - Act Wise CDHP HRA','Blue Exchange (BX)','RFP');     
       test.stoptest();
       if(String.isNotBlank(deptTested)){
       System.assertEquals('Blue Exchange (BX)',deptTested ); 
       }
      }
      
      } 
       /* This is testmethod for 'Service Operations Retro' department. */
       static testMethod void testServiceOperationsRetro() {//37
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Medical - Act Wise CDHP HRA','Service Operations Retro','RFP');     
       test.stoptest();
       if(String.isNotBlank(deptTested)){
       System.assertEquals('Service Operations Retro',deptTested ); 
       }
      }
      
      }
      /* This is testmethod for 'Claims Retro' department. */
       static testMethod void testNetworkManagement() {//38
      AlternateNetwork__c altnwrk = new AlternateNetwork__c(
                                       AltNetStateOptions__c = '1G7 – CT Century Preferred Tiered'
                                       );
       insert altnwrk;
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Medical - Act Wise CDHP HRA','Network Management','RFP');     
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Network Management',deptTested ); 
       }
      }
      }
    /* This is testmethod for 'THTY' department. */
      static testMethod void testTHTY() {//39
      AlternateNetwork__c altnwrk = new AlternateNetwork__c(
                                       AltNetStateOptions__c = '1G7 – CT Century Preferred Tiered'
                                       );
       insert altnwrk;
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Medical - Act Wise CDHP HRA','Network Management','RFP');     
       test.stoptest();
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Network Management',deptTested ); 
       }
      }    
      }   
/* The main logic of the data from above test methods is performed in this method. */
static Order testdata(String Implementation_Type, String productStage, 
                      String productName ,String userGroup, String claimSystem)
 {
    Account acc = new Account(Name = 'Test Acc',Anthem_Entity__c = 'National Accounts',Region__c='Central',
                              Branding__c = 'UniCare',ApprovedByOutsourcing__c= true);
    insert Acc;
    
    Pricebook2 standardPB = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
    Pricebook2 prb= new  Pricebook2(Name='Test',Description ='Price Book Products',IsActive = true);
    insert prb;
    
    Product2 prod = new Product2(Name = productName,isActive=true,Family='THTY');
    insert prod;
   
    Product2 prodmed = new Product2(Name = 'Medical - POS',isActive=true,Family='THTY');//'Onsite Clinics'
    insert prodmed;
    PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, 
      Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
    insert standardPrice;
    
    PricebookEntry pbe = new PricebookEntry(Pricebook2Id = prb.Id,
       Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
    insert pbe;
    Opportunity opty = new opportunity(Name = 'test Opty',
                                       StageName = 'Engage',
                                       Closedate = Date.newInstance(2008,11,20),
                                       Pricebook2Id = standardPB.Id,AccountId = acc.Id);
    insert opty; 
    
    Quote quoteRec = new Quote(Name = 'Test Quote',OpportunityId = opty.Id,Pricebook2Id = standardPB.Id);
    insert quoteRec;
   
    Group__c grpRec = new Group__c(Name='TestGroup',Account__c=acc.Id);
    grpRec.ClaimSystem__c=claimSystem;
    insert grpRec ;
   
    quoteRec.GroupNumber__c = grpRec.Id;
    
    List<QuoteLineItem> qliRecords = new List<QuoteLineItem>();
    QuoteLineItem qli = new QuoteLineItem(QuoteId = quoteRec.Id,Product2Id = prod.Id);    
    qli.ProductStage__c=productStage;//'Termed';
    qli.Renewed_with_Changes__c='Yes'; 
    qli.PricebookEntryId = standardPrice.Id;
    qli.Quantity = 1;
    qli.UnitPrice = 1000;
    qli.RecordType__c = 'AIM';
    qli.MembershipsplitbetweenIHMandnonIHM__c = 'Yes';
    //qli.Membership_Split_Between_MHA_and_Non_MHA__c = 'Yes';
    qli.IsMembershipSplitBetweenCCMUnonCCMU__c = 'Yes (please explain)';
    qli.Funding__c = 'ASO';
    qli.Financing__c = 'JAA (Jointly Administered Arrangement)';
    qliRecords.add(qli);
    
    QuoteLineItem qlimed = new QuoteLineItem(QuoteId = quoteRec.Id,Product2Id = prodmed.Id);    
    qlimed.ProductStage__c=productStage;
    qlimed.Renewed_with_Changes__c='Yes'; 
    qlimed.PricebookEntryId = standardPrice.Id;
    qlimed.Quantity = 1;
    qlimed.UnitPrice = 1000;
    qlimed.RecordType__c = 'AIM';
    qlimed.MembershipsplitbetweenIHMandnonIHM__c = 'Yes';
    //qlimed.Membership_Split_Between_MHA_and_Non_MHA__c = 'Yes';
    qlimed.IsMembershipSplitBetweenCCMUnonCCMU__c = 'Yes (please explain)';
    qlimed.Funding__c = 'FI';
    qlimed.Financing__c = 'JAA (Jointly Administered Arrangement)';
    qliRecords.add(qlimed);
    insert qliRecords;
    AlternateNetwork__c altnwrk = new AlternateNetwork__c(
                                       AltNetStateOptions__c = '1G7 – CT Century Preferred Tiered',
                                       QuoteLineItem__c =  qli.Id);
    insert altnwrk;
        
    Order implementationCase = new Order(QuoteId = quoteRec.Id,AccountId = acc.Id );
    implementationCase.User_Group__c = userGroup ; //'National Renewal', 'Local New Business'
    implementationCase.Implementation_Type__c=Implementation_Type;
    implementationCase.Pre_Implementation_Type__c = 'RFP';
    implementationCase.Does_a_partial_term_apply__c ='Yes';
    implementationCase.Are_there_changes_to_Rates__c ='yes';
    implementationCase.Assigned_Implementer__c = user.Id;
    implementationCase.Implementation_Effective_Date__c= System.today() ;
    implementationCase.EffectiveDate = System.today();
    implementationCase.Status = 'Draft';
    
    implementationCase.Is_A_Project_Plan_Needed__c = 'Yes';
    implementationCase.Is_a_Decisions_Deliverables_List_Needed__c = 'Yes';
    implementationCase.Are_there_changes_to_Eligibility__c ='Yes';
    implementationCase.Are_there_changes_to_Enrollment_Billing__c ='Yes';
    implementationCase.Intake_Type_Group_Term__c = true;
    implementationCase.Intake_Type_Retro__c = true;
    implementationCase.If_Effective_Date_Is_Retro__c = 'No Claim Impacts';
    implementationCase.Reason_For_Retro__c = 'Benefits Not Coded Per BPD';
    implementationCase.Apply_Claims_Stop__c = 'No';
    implementationCase.Additional_Reason_Details__c ='Testing Retro from test class';
    implementationCase.Request_include_benefit_changes__c = 'Yes';
    implementationCase.Did_You_Attach_The_Selections_Report__c  ='Yes';
    implementationCase.ID_Card_Changes__c='Yes';
    implementationCase.Does_Anthem_Produce_SBC_s__c ='Yes';
    implementationCase.Want_the_SBC_created_by_the_SBC_team__c  ='Yes'; 
    implementationCase.Request_include_benefit_changes__c   ='Yes';
    implementationCase.Does_Anthem_Produce_Benefit_Booklets__c ='yes';
    implementationCase.Does_This_Require_A_New_Benefit_Booklet__c  ='yes'; 
    implementationCase.Intake_Type_Existing_Shift_to_JAA__c = true;
    
    // 27413 Commented to avoid single insert of Implementation Case
    //insert implementationCase;
    
    return implementationCase;
   } 
/*Different Implementation types are tested here. */
 static String departmentTesting(string prod_Name , string sme_Dept, String preImplntType)
   {
    String methodName = UtilConstants.RETRIEVE_DEPARTMENT;
    String dept;
    Map<String,Object> inputMap = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> optns = new Map<String,Object>();
    List<Id> OrderTestList = new List<Id>();
    
    List<Order> orderLst = new List<Order>();
    //1:Renewal,Termed       
    Order implementationCase1 =  testdata('Renewal','Termed',prod_Name,'National Renewal','WGS 2.0');
    orderLst .add(implementationCase1);
    // 2:Renewal ,IGAP sold
    Order implementationCase2 =  testdata('Renewal','IGAP Sold',prod_Name,'National Renewal','WGS 2.0');
    orderLst .add(implementationCase2);
    // 3:Renewal ,Renewed
    Order implementationCase3 =  testdata('Renewal','Renewed',prod_Name,'National Renewal','WGS 2.0');
    orderLst .add(implementationCase3);
    // 4:New Business ,sold
    Order implementationCase4 =  testdata('New Business','Sold',prod_Name,'Local New Business','NASCO');
    orderLst .add(implementationCase4);
    // 5:Change Request Off Cycle ,Sold
    Order implementationCase5 =  testdata('Change Request Off Cycle','IGAP Sold',prod_Name,'National Renewal','WGS 2.0');
    orderLst .add(implementationCase5);
    //6 :Pre Work ,Termed
    Order implementationCase6 =  testdata('Pre Work','Termed',prod_Name,'National Renewal','WGS 2.0');
    orderLst .add(implementationCase6);
    Order implementationCase7 =  testdata('Change Request Off Cycle','IGAP Sold',prod_Name,'National Renewal','NASCO');
    orderLst .add(implementationCase7);
    Order implementationCase8 =  testdata('Pre Work','Termed',prod_Name,'National Renewal','WGS 2.0');
    orderLst.add(implementationCase8);
    // 9:New Business with ClaimSystem = WGS 2.0
    Order implementationCase9 =  testdata('New Business','Sold',prod_Name,'Local New Business','WGS 2.0');
    orderLst.add(implementationCase9);
    
    // 27413 Added flag to not run Implementation Case Trigger to avoid CPU Limit Error
    /*checkRecursive_trgrecursive.runOnce();
    AP22_SendNotifToNationalAIMTeam.firstRun = false; 
    AP26_NotifyUsers_On_ICStatusChange.firstRun=false; */
    
    insert orderLst; 
    
    implementationCase1.Pre_Implementation_Type__c = preImplntType;
    
    implementationCase1.Intake_Type_Group_Term__c = true; //IntakeGroupTerm
    implementationCase1.Intake_Type_Existing_Shift_to_JAA__c = true; //IntakeExistingShiftJaa
    
    OrderTestList.add(implementationCase1.Id);
    
    String sme_dept_Name = '\''+ 'SME '+ prod_Name + '\'' ;    
    String text ='Pre Work';
    String queryString= 'SELECT Id,Department__c,Active__c, Criteria__c FROM SME_Approval_Routing_Logic__c Where Department__c ='+sme_dept_Name +' and  Active__c = true AND Criteria__c  Like \'% ' + text + ' %\''; 
   
    List<SME_Approval_Routing_Logic__c> routingRecords = new List<SME_Approval_Routing_Logic__c>();
    routingRecords=Database.query(queryString);
    
    inputMap.put('ContextId',implementationCase1.Id);  
    inputMap.put('ImplementationType',implementationCase1.Implementation_Type__c);
    inputMap.put('preImplementationType',implementationCase1.Pre_Implementation_Type__c);
    //inputMap.put('claimSystem',implementationCase1.Claim_system__c);
    inputMap.put('claimSystem','NASCO');
    inputMap.put('ProjectPlanNeeded',implementationCase1.Is_A_Project_Plan_Needed__c);
    inputMap.put('DecisionsAndDeliverablesList',implementationCase1.Is_a_Decisions_Deliverables_List_Needed__c);
    inputMap.put('ChangesToEligibility',implementationCase1.Are_there_changes_to_Eligibility__c);
    inputMap.put('ChangesToBillingOrFunding',implementationCase1.Are_there_changes_to_Enrollment_Billing__c);
    inputMap.put('IntakeGroupTerm',implementationCase1.Intake_Type_Group_Term__c);
    inputMap.put('SelectionReport',implementationCase1.Did_You_Attach_The_Selections_Report__c);
    inputMap.put('IdCardChanges',implementationCase1.ID_Card_Changes__c);
    inputMap.put('DoesAnthemProdSME',implementationCase1.Does_Anthem_Produce_SBC_s__c);
    inputMap.put('WantTheSBCCreatedBySME',implementationCase1.Want_the_SBC_created_by_the_SBC_team__c);
    inputMap.put('RequestChanges',implementationCase1.Request_include_benefit_changes__c);
    inputMap.put('DoesAnthemProdBenefitSME',implementationCase1.Does_Anthem_Produce_Benefit_Booklets__c);   
    inputMap.put('DoesThisRequireANewBenefitSME',implementationCase1.Does_This_Require_A_New_Benefit_Booklet__c);
    inputMap.put('existingShiftJaaField',implementationCase1.Intake_Type_Existing_Shift_to_JAA__c);
    inputMap.put('PartialTermApply',implementationCase1.Does_a_partial_term_apply__c);
       
     List<Object> quoteLineItemFields3 =  new List<Object>(); 
     
     Map<String,Object> quoteLineItemFieldsMap3 = new Map<String,Object>(); 
     quoteLineItemFieldsMap3.put('Funding','ASO');
     quoteLineItemFieldsMap3.put('Financing','JAA (Jointly Administered Arrangement)');
     quoteLineItemFieldsMap3.put('QuoteLineItemProductName','XYZ'); 
     quoteLineItemFieldsMap3.put('QuoteLineItemId','QLITID');    
     quoteLineItemFields3.add(quoteLineItemFieldsMap3);
     quoteLineItemFieldsMap3.put('Funding','FI');
     quoteLineItemFieldsMap3.put('Financing','JAA (Jointly Administered Arrangement)');
     quoteLineItemFieldsMap3.put('QuoteLineItemProductName','BOLD');
     quoteLineItemFieldsMap3.put('QuoteLineItemId','QLITID');
     quoteLineItemFields3.add(quoteLineItemFieldsMap3);
     quoteLineItemFieldsMap3.put('Funding','ASO');
     quoteLineItemFieldsMap3.put('Financing','JAA (Jointly Administered Arrangement)');
     quoteLineItemFieldsMap3.put('QuoteLineItemProductName','Medical - POS'); 
     quoteLineItemFieldsMap3.put('QuoteLineItemId','QLITID');    
     quoteLineItemFields3.add(quoteLineItemFieldsMap3);
      inputMap.put(UtilConstants.QLI,quoteLineItemFields3);  
    
    AP18_SMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
    OrderTestList.add(implementationCase2.Id);
    
    inputMap.clear();outMap.clear();
    inputMap.put('ContextId',implementationCase2.Id);
    inputMap.put('ImplementationType',implementationCase2.Implementation_Type__c);
    inputMap.put('preImplementationType',implementationCase2.Pre_Implementation_Type__c);
    inputMap.put('claimSystem',implementationCase2.Claim_system__c);
    inputMap.put('ProjectPlanNeeded',implementationCase2.Is_A_Project_Plan_Needed__c);
    inputMap.put('DecisionsAndDeliverablesList',implementationCase2.Is_a_Decisions_Deliverables_List_Needed__c);
    inputMap.put('ChangesToEligibility',implementationCase2.Are_there_changes_to_Eligibility__c);
    inputMap.put('ChangesToBillingOrFunding',implementationCase2.Are_there_changes_to_Enrollment_Billing__c);
    inputMap.put('IntakeGroupTerm',implementationCase2.Intake_Type_Group_Term__c);
    inputMap.put('SelectionReport',implementationCase2.Did_You_Attach_The_Selections_Report__c);
    inputMap.put('IdCardChanges',implementationCase1.ID_Card_Changes__c);
    inputMap.put('DoesAnthemProdSME',implementationCase2.Does_Anthem_Produce_SBC_s__c);
    inputMap.put('WantTheSBCCreatedBySME',implementationCase2.Want_the_SBC_created_by_the_SBC_team__c);
    inputMap.put('RequestChanges',implementationCase2.Request_include_benefit_changes__c);
    inputMap.put('DoesAnthemProdBenefitSME',implementationCase1.Does_Anthem_Produce_Benefit_Booklets__c);
    inputMap.put('DoesThisRequireANewBenefitSME',implementationCase1.Does_This_Require_A_New_Benefit_Booklet__c);
    inputMap.put('existingShiftJaaField',implementationCase1.Intake_Type_Existing_Shift_to_JAA__c);
    AP18_SMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
    
    OrderTestList.add(implementationCase3.Id);
   // System.debug('Test Record3: '+implementationCase3.Id);
    inputMap.clear();outMap.clear();
    inputMap.put('ContextId',implementationCase3.Id);
    inputMap.put('ImplementationType',implementationCase3.Implementation_Type__c);
    inputMap.put('preImplementationType',implementationCase3.Pre_Implementation_Type__c);
    inputMap.put('claimSystem',implementationCase3.Claim_system__c);
    inputMap.put('ProjectPlanNeeded',implementationCase3.Is_A_Project_Plan_Needed__c);
    inputMap.put('DecisionsAndDeliverablesList',implementationCase3.Is_a_Decisions_Deliverables_List_Needed__c);
    inputMap.put('ChangesToEligibility',implementationCase3.Are_there_changes_to_Eligibility__c);
    inputMap.put('ChangesToBillingOrFunding',implementationCase3.Are_there_changes_to_Enrollment_Billing__c);
    inputMap.put('IntakeGroupTerm',implementationCase3.Intake_Type_Group_Term__c);
    inputMap.put('SelectionReport',implementationCase3.Did_You_Attach_The_Selections_Report__c);
    inputMap.put('IdCardChanges',implementationCase3.ID_Card_Changes__c);
    inputMap.put('DoesAnthemProdSME',implementationCase3.Does_Anthem_Produce_SBC_s__c);
    inputMap.put('WantTheSBCCreatedBySME',implementationCase3.Want_the_SBC_created_by_the_SBC_team__c);
    inputMap.put('RequestChanges',implementationCase3.Request_include_benefit_changes__c);
    inputMap.put('DoesAnthemProdBenefitSME',implementationCase1.Does_Anthem_Produce_Benefit_Booklets__c);
    inputMap.put('DoesThisRequireANewBenefitSME',implementationCase1.Does_This_Require_A_New_Benefit_Booklet__c);
    inputMap.put('existingShiftJaaField',implementationCase1.Intake_Type_Existing_Shift_to_JAA__c);
    AP18_SMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
    
    OrderTestList.add(implementationCase4.Id);
    inputMap.clear();outMap.clear();
    inputMap.put('ContextId',implementationCase4.Id);
    inputMap.put('ImplementationType',implementationCase4.Implementation_Type__c);
    inputMap.put('preImplementationType',implementationCase4.Pre_Implementation_Type__c);
    inputMap.put('claimSystem',implementationCase4.Claim_system__c);
    inputMap.put('ProjectPlanNeeded',implementationCase4.Is_A_Project_Plan_Needed__c);
    inputMap.put('DecisionsAndDeliverablesList',implementationCase4.Is_a_Decisions_Deliverables_List_Needed__c);
    inputMap.put('ChangesToEligibility',implementationCase4.Are_there_changes_to_Eligibility__c);
    inputMap.put('ChangesToBillingOrFunding',implementationCase4.Are_there_changes_to_Enrollment_Billing__c);
    inputMap.put('IntakeGroupTerm',implementationCase4.Intake_Type_Group_Term__c);
    inputMap.put('SelectionReport',implementationCase4.Did_You_Attach_The_Selections_Report__c);
    inputMap.put('IdCardChanges',implementationCase4.ID_Card_Changes__c);
    inputMap.put('DoesAnthemProdSME',implementationCase4.Does_Anthem_Produce_SBC_s__c);
    inputMap.put('WantTheSBCCreatedBySME',implementationCase4.Want_the_SBC_created_by_the_SBC_team__c);
    inputMap.put('RequestChanges',implementationCase4.Request_include_benefit_changes__c);
    inputMap.put('DoesAnthemProdBenefitSME',implementationCase4.Does_Anthem_Produce_Benefit_Booklets__c);
    inputMap.put('DoesThisRequireANewBenefitSME',implementationCase4.Does_This_Require_A_New_Benefit_Booklet__c);
    inputMap.put('existingShiftJaaField',implementationCase4.Intake_Type_Existing_Shift_to_JAA__c); 
    AP18_SMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
       
    
    OrderTestList.add(implementationCase9.Id);
    inputMap.clear();outMap.clear();
    inputMap.put('ContextId',implementationCase9.Id);
    inputMap.put('ImplementationType',implementationCase9.Implementation_Type__c);
    inputMap.put('preImplementationType',implementationCase9.Pre_Implementation_Type__c);
    inputMap.put('claimSystem',implementationCase9.Claim_system__c);
   /* inputMap.put('ProjectPlanNeeded',implementationCase4.Is_A_Project_Plan_Needed__c);
    inputMap.put('DecisionsAndDeliverablesList',implementationCase4.Is_a_Decisions_Deliverables_List_Needed__c);
    inputMap.put('ChangesToEligibility',implementationCase4.Are_there_changes_to_Eligibility__c);
    inputMap.put('ChangesToBillingOrFunding',implementationCase4.Are_there_changes_to_Enrollment_Billing__c);
    inputMap.put('IntakeGroupTerm',implementationCase4.Intake_Type_Group_Term__c);
    inputMap.put('SelectionReport',implementationCase4.Did_You_Attach_The_Selections_Report__c);
    inputMap.put('IdCardChanges',implementationCase4.ID_Card_Changes__c);
    inputMap.put('DoesAnthemProdSME',implementationCase4.Does_Anthem_Produce_SBC_s__c);
    inputMap.put('WantTheSBCCreatedBySME',implementationCase4.Want_the_SBC_created_by_the_SBC_team__c);
    inputMap.put('RequestChanges',implementationCase4.Request_include_benefit_changes__c);
    inputMap.put('doesAnthemProdBenefitSME',implementationCase4.Does_Anthem_Produce_Benefit_Booklets__c);
    inputMap.put('doesthisrequireanewBenefitSME',implementationCase4.Does_This_Require_A_New_Benefit_Booklet__c);
    inputMap.put('existingShiftJaaField',implementationCase4.Intake_Type_Existing_Shift_to_JAA__c); */
    AP18_SMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
    
   
    OrderTestList.add(implementationCase5.Id);
    
    inputMap.clear();outMap.clear();
    inputMap.put('ContextId',implementationCase5.Id);
    inputMap.put('ImplementationType',implementationCase5.Implementation_Type__c);
    inputMap.put('preImplementationType',implementationCase5.Pre_Implementation_Type__c);
    inputMap.put('claimSystem','WGS 2.0');
    inputMap.put('IntakeRetro','True');
    inputMap.put('ProjectPlanNeeded',implementationCase5.Is_A_Project_Plan_Needed__c);
    inputMap.put('DecisionsAndDeliverablesList',implementationCase5.Is_a_Decisions_Deliverables_List_Needed__c);
    inputMap.put('ChangesToEligibility',implementationCase5.Are_there_changes_to_Eligibility__c);
    inputMap.put('ChangesToBillingOrFunding',implementationCase5.Are_there_changes_to_Enrollment_Billing__c);
    inputMap.put('IntakeGroupTerm',implementationCase5.Intake_Type_Group_Term__c);
    inputMap.put('SelectionReport',implementationCase5.Did_You_Attach_The_Selections_Report__c);
    inputMap.put('IdCardChanges',implementationCase5.ID_Card_Changes__c);
    inputMap.put('DoesAnthemProdSME',implementationCase5.Does_Anthem_Produce_SBC_s__c);
    inputMap.put('WantTheSBCCreatedBySME',implementationCase5.Want_the_SBC_created_by_the_SBC_team__c);
    inputMap.put('RequestChanges',implementationCase5.Request_include_benefit_changes__c);
    inputMap.put('DoesAnthemProdBenefitSME',implementationCase1.Does_Anthem_Produce_Benefit_Booklets__c);
    inputMap.put('DoesThisRequireANewBenefitSME',implementationCase1.Does_This_Require_A_New_Benefit_Booklet__c);
    inputMap.put('existingShiftJaaField',implementationCase1.Intake_Type_Existing_Shift_to_JAA__c);
       
    List<Object> quoteLineItemFields2 =  new List<Object>(); 
     
     Map<String,Object> quoteLineItemFieldsMap2 = new Map<String,Object>(); 
     quoteLineItemFieldsMap2.put('Funding','ASO');
     quoteLineItemFieldsMap2.put('Financing','JAA (Jointly Administered Arrangement)');
     quoteLineItemFieldsMap2.put('QuoteLineItemProductName','XYZ'); 
     quoteLineItemFieldsMap2.put('QuoteLineItemId','QLITID');    
     quoteLineItemFields2.add(quoteLineItemFieldsMap2);
     quoteLineItemFieldsMap2.put('Funding','FI');
     quoteLineItemFieldsMap2.put('Financing','JAA (Jointly Administered Arrangement)');
     quoteLineItemFieldsMap2.put('QuoteLineItemProductName','BOLD');
     quoteLineItemFieldsMap2.put('QuoteLineItemId','QLITID');
     quoteLineItemFields2.add(quoteLineItemFieldsMap2);
     quoteLineItemFieldsMap2.put('Funding','ASO');
     quoteLineItemFieldsMap2.put('Financing','JAA (Jointly Administered Arrangement)');
     quoteLineItemFieldsMap2.put('QuoteLineItemProductName','Medical - POS'); 
     quoteLineItemFieldsMap2.put('QuoteLineItemId','QLITID');    
     quoteLineItemFields2.add(quoteLineItemFieldsMap2);
      inputMap.put(UtilConstants.QLI,quoteLineItemFields2);   
       
    AP18_SMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
    
    OrderTestList.add(implementationCase7.Id);
    //System.debug('Test Record5 : '+implementationCase7.Id);
    inputMap.clear();outMap.clear();
    inputMap.put('ContextId',implementationCase7.Id);
    inputMap.put('ImplementationType',implementationCase7.Implementation_Type__c);
    inputMap.put('IntakeRetro','True');
    inputMap.put('claimSystem','Nasco');
    inputMap.put('IntakeGroupTerm',implementationCase7.Intake_Type_Group_Term__c);
    inputMap.put('SelectionReport',implementationCase7.Did_You_Attach_The_Selections_Report__c);
    inputMap.put('IdCardChanges',implementationCase7.ID_Card_Changes__c);
    inputMap.put('DoesAnthemProdSME',implementationCase7.Does_Anthem_Produce_SBC_s__c);
    inputMap.put('WantTheSBCCreatedBySME',implementationCase7.Want_the_SBC_created_by_the_SBC_team__c);
    inputMap.put('RequestChanges',implementationCase7.Request_include_benefit_changes__c);
    inputMap.put('DoesAnthemProdBenefitSME',implementationCase7.Does_Anthem_Produce_Benefit_Booklets__c);
    inputMap.put('DoesThisRequireANewBenefitSME',implementationCase7.Does_This_Require_A_New_Benefit_Booklet__c);
    AP18_SMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
    
    
    implementationCase6.Pre_Implementation_Type__c=preImplntType;
    
    OrderTestList.add(implementationCase6.Id);
    inputMap.clear();outMap.clear();
    inputMap.put('ContextId',implementationCase6.Id);
    inputMap.put('ImplementationType',implementationCase6.Implementation_Type__c);
    inputMap.put('preImplementationType',implementationCase6.Pre_Implementation_Type__c);
    inputMap.put('claimSystem',implementationCase6.Claim_system__c);
    inputMap.put('ProjectPlanNeeded',implementationCase6.Is_A_Project_Plan_Needed__c);
    inputMap.put('DecisionsAndDeliverablesList',implementationCase6.Is_a_Decisions_Deliverables_List_Needed__c);
    inputMap.put('ChangesToEligibility',implementationCase6.Are_there_changes_to_Eligibility__c);
    inputMap.put('ChangesToBillingOrFunding',implementationCase6.Are_there_changes_to_Enrollment_Billing__c);
    inputMap.put('IntakeGroupTerm',implementationCase6.Intake_Type_Group_Term__c);
    inputMap.put('SelectionReport',implementationCase6.Did_You_Attach_The_Selections_Report__c);
    inputMap.put('IdCardChanges',implementationCase6.ID_Card_Changes__c);
    inputMap.put('DoesAnthemProdSME',implementationCase6.Does_Anthem_Produce_SBC_s__c);
    inputMap.put('WantTheSBCCreatedBySME',implementationCase6.Want_the_SBC_created_by_the_SBC_team__c);
    inputMap.put('RequestChanges',implementationCase6.Request_include_benefit_changes__c);
    inputMap.put('DoesAnthemProdBenefitSMEDoesAnthemProdBenefitSME',implementationCase1.Does_Anthem_Produce_Benefit_Booklets__c);
    inputMap.put('DoesThisRequireANewBenefitSME',implementationCase1.Does_This_Require_A_New_Benefit_Booklet__c);
    inputMap.put('existingShiftJaaField',implementationCase1.Intake_Type_Existing_Shift_to_JAA__c);
    AP18_SMEApproval.invokeMethod(methodName, inputMap,outMap,optns); 
    
    //676
    
     OrderTestList.add(implementationCase8.Id);
     inputMap.clear();outMap.clear();
     inputMap.put('ContextId',implementationCase8.Id);
    inputMap.put('ImplementationType',implementationCase8.Implementation_Type__c);
    inputMap.put('preImplementationType',implementationCase8.Pre_Implementation_Type__c);
    inputMap.put('claimSystem',implementationCase8.Claim_system__c);
    inputMap.put('ProjectPlanNeeded',implementationCase8.Is_A_Project_Plan_Needed__c);
    inputMap.put('DecisionsAndDeliverablesList',implementationCase8.Is_a_Decisions_Deliverables_List_Needed__c);
    inputMap.put('ChangesToEligibility',implementationCase8.Are_there_changes_to_Eligibility__c);
    inputMap.put('ChangesToBillingOrFunding',implementationCase8.Are_there_changes_to_Enrollment_Billing__c);
    inputMap.put('IntakeGroupTerm',implementationCase8.Intake_Type_Group_Term__c);
    inputMap.put('SelectionReport',implementationCase8.Did_You_Attach_The_Selections_Report__c);
    inputMap.put('IdCardChanges',implementationCase8.ID_Card_Changes__c);
    inputMap.put('DoesAnthemProdSME',implementationCase8.Does_Anthem_Produce_SBC_s__c);
    inputMap.put('WantTheSBCCreatedBySME',implementationCase8.Want_the_SBC_created_by_the_SBC_team__c);
    inputMap.put('RequestChanges',implementationCase8.Request_include_benefit_changes__c);
    inputMap.put('DoesAnthemProdBenefitSME',implementationCase8.Does_Anthem_Produce_Benefit_Booklets__c);
    inputMap.put('DoesThisRequireANewBenefitSME',implementationCase8.Does_This_Require_A_New_Benefit_Booklet__c);
    inputMap.put('existingShiftJaaField',implementationCase8.Intake_Type_Existing_Shift_to_JAA__c);
    
     List<Object> quoteLineItemFields1      =  new List<Object>(); 
     
     Map<String,Object> quoteLineItemFieldsMap1 = new Map<String,Object>(); 
     quoteLineItemFieldsMap1.put('Funding','ASO');
     quoteLineItemFieldsMap1.put('Financing','JAA (Jointly Administered Arrangement)');
     quoteLineItemFieldsMap1.put('QuoteLineItemProductName','XYZ'); 
     quoteLineItemFieldsMap1.put('QuoteLineItemId','QLITID');    
     quoteLineItemFields1.add(quoteLineItemFieldsMap1);
     quoteLineItemFieldsMap1.put('Funding','FI');
     quoteLineItemFieldsMap1.put('Financing','JAA (Jointly Administered Arrangement)');
     quoteLineItemFieldsMap1.put('QuoteLineItemProductName','BOLD');
     quoteLineItemFieldsMap1.put('QuoteLineItemId','QLITID');
     quoteLineItemFields1.add(quoteLineItemFieldsMap1);
     quoteLineItemFieldsMap1.put('Funding','ASO');
     quoteLineItemFieldsMap1.put('Financing','JAA (Jointly Administered Arrangement)');
     quoteLineItemFieldsMap1.put('QuoteLineItemProductName','Medical - POS'); 
     quoteLineItemFieldsMap1.put('QuoteLineItemId','QLITID');    
     quoteLineItemFields1.add(quoteLineItemFieldsMap1);
      inputMap.put(UtilConstants.QLI,quoteLineItemFields1);

     implementationCase8.Pre_Implementation_Type__c=preImplntType;
     
     
     AP18_SMEApproval.invokeMethod(methodName, inputMap,outMap,optns);    
    
        for ( SME_Approvals__c smeTempRec :[Select Id,SME_Department__c from SME_Approvals__c where Implementation_Record_ID__c IN :OrderTestList]){
          dept = smeTempRec.SME_Department__c;
          
          System.assertEquals(sme_Dept,smeTempRec.SME_Department__c);//'Onsite Clinic'
          dept = smeTempRec.SME_Department__c;
       }
        return dept;
   }
   
   /* for testing Departments with one or zero products. */    
    static testMethod void  testSaveSMEDeptMethod()
   {
    String methodName = UtilConstants.SAVE_SME_DEPARTMENT;
    Map<String,Object> inputMap = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> optns = new Map<String,Object>();
    test.starttest();
    system.runAs(user){
    Order implementationCase =  testdata('Renewal','Termed','SME Bold','National Renewal','WGS 2.0');
    insert implementationCase ;
    inputMap.put('ContextId',implementationCase.Id);
    inputMap.put('ImplementationType',implementationCase.Implementation_Type__c);
    inputMap.put(UtilConstants.PRODUCT_EFFECTIVE_DATE,implementationCase.Implementation_Effective_Date__c);
    
    Map<String,List<Object>> STManualDepartment = new Map<String,List<Object>>();
    List<Object> SIManualDepartment = new List<Object>();
    Map<String,String> SIManualDepartmentMap = new Map<String,String>(); 
    SIManualDepartmentMap.put(UtilConstants.JSON_NAME_FIELD,UtilConstants.IT);
    SIManualDepartmentMap.put(UtilConstants.JSON_NAME_FIELD,UtilConstants.SERVICE_OPERATIONS);
    SIManualDepartment.add(SIManualDepartmentMap);
    STManualDepartment.put(UtilConstants.SI_MANUAL_DEPARTMENT,SIManualDepartment);
    inputMap.put(UtilConstants.ST_MANUAL_DEPARTMENT, STManualDepartment);
    AP18_SMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
    }
   test.stoptest();
   }
}