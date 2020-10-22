/*
 * This Class is a test class for the AP19_RevisionSMEApproval class
 * 
*/

@isTest(seealldata=true)
private class AP19_RevisionSMEApproval_Test {
    private static final string NATIONALIMPLEMENTATIONPROFILE='National Implementations'; 
    private static Profile profileNA = [select id from profile where name=:NATIONALIMPLEMENTATIONPROFILE limit 1];
    private static User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
    
    //This is testmethod for AP19_RevisionSMEApproval
    
    static testMethod void testOnsiteClinicDept() {//1
       test.starttest();
       system.runAs(user) { 
       String deptTested = departmentTesting('Onsite Clinic','Onsite Clinic','RFP',UtilConstants.SAVE_SME_DEPARTMENT);
       if (String.isNotBlank(deptTested)){
       System.assertEquals('Onsite Clinic',deptTested ); 
       }
      }
      test.stoptest();
      } 
      
 
    //The main logic of the data from above test methods is performed in this method.    
    static order testdata(String Implementation_Type, String productStage, String productName , String userGroup, String claimSystem) {
    
        //Creating Account Record
        Account acc = new Account(Name = 'Test Acc', Anthem_Entity__c = 'National Accounts',Region__c='Central',Branding__c = 'UniCare');
        insert Acc;
        System.debug('Account is created' );
        
        //Creating Pricebook Record
        Pricebook2 standardPB = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 prb= new  Pricebook2(Name='Test',Description ='Price Book Products',IsActive = true);
        insert prb;
        //System.debug('Price book is created' );
        
        //Adding Products
        Product2 prod = new Product2(Name = productName,isActive=true);
        insert prod;
        //System.debug('Product is created' );
        Product2 prodmed = new Product2(Name = 'Medical - POS',isActive=true);//'Onsite Clinics'
        insert prodmed;
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        //System.debug('Standard Price book is created' );
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = prb.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;
        
        //Creating Opportunity Records
        Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),Pricebook2Id = standardPB.id,AccountId = acc.Id);
        insert opty; 
        //System.debug('Opty is created' );
        Quote quoteRec = new Quote(Name = 'Test Quote',OpportunityId = opty.Id,Pricebook2Id = standardPB.id);
        insert quoteRec;
        //System.debug('Quote is created' );
        
        //Creating Group
        Group__c grpRec = new Group__c(Name='TestGroup',Account__c=acc.Id);
        grpRec.ClaimSystem__c=claimSystem;
        insert grpRec ;
        //System.debug('Group is created' );
        quoteRec.GroupNumber__c = grpRec.Id;
       // System.debug('--------------'+grpRec.ClaimSystem__c);                 
        
        //Creating Implementation Case Record            
        Order implementationCase = new Order(QuoteId = quoteRec.Id,AccountId = acc.Id );
        implementationCase.User_Group__c = userGroup ; //'National Renewal', 'Local New Business'
        implementationCase.Implementation_Type__c=Implementation_Type;
        implementationCase.Pre_Implementation_Type__c = 'RFP';
        implementationCase.Implementation_Effective_Date__c= System.today() ;
        implementationCase.EffectiveDate = System.today();
        implementationCase.Status = 'Draft';
        implementationCase.Is_A_Project_Plan_Needed__c = 'Yes';
        implementationCase.Is_a_Decisions_Deliverables_List_Needed__c = 'Yes';
        implementationCase.Are_there_changes_to_Eligibility__c ='Yes';
        implementationCase.Are_there_changes_to_Enrollment_Billing__c ='Yes';
        implementationCase.Intake_Type_Group_Term__c = true;
        implementationCase.Did_You_Attach_The_Selections_Report__c  ='Yes';
        implementationCase.ID_Card_Changes__c='Yes';
        implementationCase.Does_Anthem_Produce_SBC_s__c ='Yes';
        implementationCase.Want_the_SBC_created_by_the_SBC_team__c  ='Yes'; 
        implementationCase.Request_include_benefit_changes__c   ='Yes';
        implementationCase.Implementation_Status__c = 'Approved'; // 'Approved Implementation In Progress' ; // cmh 
        implementationCase.SME_Service_Operations__c = true;
        //implementationCase.Assigned_Implementer__c = UserInfo.getUserId();
        implementationCase.Assigned_Implementer__c = [SELECT id FROM User where Profile.Name in ('National Implementations') limit 1][0].Id; // cmh 
        insert implementationCase;
        //System.debug('implementationCase is created' );
                
        //Creating Revision record
        List<Impl_Revision__c> ListRevise = new List<Impl_Revision__c>(); 
        Impl_Revision__c revise = new Impl_Revision__c();
        revise.Implementation_Case_Id__c = implementationCase.id;
        revise.Status_Capture__c = 'Approved Implementation In Progress'; //pending SME 
        revise.Revision_Record_Status__c = 'Approved';
        ListRevise.add(revise);
        Insert ListRevise;
        
        //Creating SME department Record
        SMEDepartment__c smeDept = new SMEDepartment__c();
        smeDept.Department_Name__c = 'Test';
        smeDept.Active__c = True;
        smeDept.Omni_Script_Help_Text__c = 'Test Help';
        insert smeDept; 
        
        //Creating SME Approval Record 
        SME_Approvals__c smeAppr = new SME_Approvals__c();
        smeAppr.Implementation_Record_ID__c = implementationCase.id;
        smeAppr.SME_Department__c = 'Onsite Clinic';
        insert smeAppr; 

        return implementationCase;
                
    }
    
    //Different Implementation types are tested here.
    static String departmentTesting(string prod_Name , string sme_Dept, String preImplntType,String methodName) {
       // String methodName = UtilConstants.SAVE_SME_DEPARTMENT;
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> optns = new Map<String,Object>();
       // List<Id> OrderTestList = new List<Id>();
        String dept;
        
        SMEDepartment__c sme = new SMEDepartment__c(Department_Name__c = 'Test', Omni_Script_Help_Text__c = 'Test Help');
        Order implementationCase1 =  testdata('Renewal','Termed',prod_Name,'National Renewal','WGS 2.0');
       // System.debug('----Test---'+ implementationCase1.Id);
         // OrderTestList.add(implementationCase1.Id);
        String implId = implementationCase1.Id;
        inputMap.put('ImplCaseId',implementationCase1.Id);
        inputMap.put('ImplementationType',implementationCase1.Implementation_Type__c);
        inputMap.put(UtilConstants.PRODUCT_EFFECTIVE_DATE,implementationCase1.Implementation_Effective_Date__c);
        Map<String,List<Object>> STManualDepartment = new Map<String,List<Object>>();
        List<Object> SIManualDepartment = new List<Object>();
        Map<String,String> SIManualDepartmentMap = new Map<String,String>(); 
        SIManualDepartmentMap.put('Name','Anthem Flex Hour');
        SIManualDepartmentMap.put('SME_Department_Code','SDC-0003');
        SIManualDepartmentMap.put('Department_Name','Anthem_Flex_Hour__c');
        SIManualDepartmentMap.put('Omni_Script_Help_Text','help text test');
        SIManualDepartment.add(SIManualDepartmentMap);
        
        //data:2 
        Map<String,String> SIManualDepartmentMap2 = new Map<String,String>(); 
        SIManualDepartmentMap2.put('Name','Other');
        SIManualDepartmentMap2.put('SME_Department_Code','SDC-0035');
        SIManualDepartmentMap2.put('Department_Name','Other__c');
        SIManualDepartmentMap2.put('Omni_Script_Help_Text','help text test');
        SIManualDepartment.add(SIManualDepartmentMap2);
        
        //data:3
        Map<String,String> SIManualDepartmentMap3 = new Map<String,String>(); 
        SIManualDepartmentMap3.put('Name','IHM');
        SIManualDepartmentMap3.put('SME_Department_Code','SDC-0021');
        SIManualDepartmentMap3.put('Department_Name','IHM__c');
        SIManualDepartmentMap3.put('Omni_Script_Help_Text','help text test');
        SIManualDepartment.add(SIManualDepartmentMap3);
        
        //data:4
        Map<String,String> SIManualDepartmentMap4 = new Map<String,String>(); 
        SIManualDepartmentMap4.put('Name','Pricing Configuration Management (PCM)');
        SIManualDepartmentMap4.put('SME_Department_Code','SDC-0037');
        SIManualDepartmentMap4.put('Department_Name','Pricing_Config_Management_PCM__c');
        SIManualDepartmentMap4.put('Omni_Script_Help_Text','help text test');
        SIManualDepartment.add(SIManualDepartmentMap4); 
        STManualDepartment.put(UtilConstants.SI_MANUAL_DEPARTMENT,SIManualDepartment);
        inputMap.put(UtilConstants.ST_MANUAL_DEPARTMENT, STManualDepartment);
        //System.debug('---Manual-Test=====---' + STManualDepartment.get('SIManualDepartment'));
        AP19_RevisionSMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
        
        String queryString= 'Select Id,SME_Department__c from SME_Approvals__c where Implementation_Record_ID__c =\''+implId + '\' limit 1';
        SME_Approvals__c smeTempRec = Database.query(queryString);
        dept = smeTempRec.SME_Department__c;
        System.debug('======DEPT========'+ dept); 
          dept = smeTempRec.SME_Department__c;
          //System.assertEquals(sme_Dept,dept);
             
        return dept;
    }
    
    // This method is for testing Departments with one or zero products.
    
   static testMethod void  testSaveSMEDeptMethod() {
   
        String methodName = UtilConstants.CREATE_SME_DEPARTMENT;
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> optns = new Map<String,Object>();
        SMEDepartment__c sme = new SMEDepartment__c(Department_Name__c = 'Test', Omni_Script_Help_Text__c = 'Test Help');
        system.runAs(user) {
            Order implementationCase =  testdata('Renewal','Termed','SME Bold','National Renewal','WGS 2.0');
            inputMap.put('ContextId',implementationCase.Id);
            inputMap.put('ImplementationType',implementationCase.Implementation_Type__c);
            inputMap.put(UtilConstants.PRODUCT_EFFECTIVE_DATE,implementationCase.Implementation_Effective_Date__c);
            Set<String> autoengdepartment = new Set<String>{UtilConstants.IT, UtilConstants.INTER_PLAN, UtilConstants.ONSITE_CLINIC, UtilConstants.OTHER, UtilConstants.PRICING_CONFIGURATION_MANAGEMENT_PCM,UtilConstants.SERVICE_OPERATIONS};
            Map<String,List<Object>> STManualDepartment = new Map<String,List<Object>>();
            List<Object> SIManualDepartment = new List<Object>();
            Map<String,String> SIManualDepartmentMap = new Map<String,String>(); 
            SIManualDepartmentMap.put(UtilConstants.JSON_NAME_FIELD,UtilConstants.IT);
            SIManualDepartmentMap.put(UtilConstants.JSON_NAME_FIELD,UtilConstants.SERVICE_OPERATIONS);
            SIManualDepartment.add(SIManualDepartmentMap);
            STManualDepartment.put(UtilConstants.SI_MANUAL_DEPARTMENT,SIManualDepartment);
            inputMap.put(UtilConstants.ST_MANUAL_DEPARTMENT, STManualDepartment);
            test.starttest();
                AP19_RevisionSMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
            test.stoptest();                
      
        } 
     } 




//------------------------------    CREATE_SME_DEPARTMENT
       static testMethod void  testSaveCreateMethod() {
   
        String methodName = UtilConstants.CREATE_SME_DEPARTMENT; //GENERATE_SME_DEPARTMENT;
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> optns = new Map<String,Object>();
        //SMEDepartment__c sme = new SMEDepartment__c(Department_Name__c = 'Test', Omni_Script_Help_Text__c = 'Test Help');
        system.runAs(user) {
            Order implementationCase1 =  testdata('Renewal','Termed','SME Bold','National Renewal','WGS 2.0');
            implementationCase1.Are_there_changes_to_Rates__c = UtilConstants.YES;
            update implementationCase1;
            inputMap.put('ContextId',implementationCase1.Id);
            inputMap.put('ImplementationType',implementationCase1.Implementation_Type__c);
            inputMap.put(UtilConstants.PRODUCT_EFFECTIVE_DATE,implementationCase1.Implementation_Effective_Date__c);                   
            test.starttest();
                AP19_RevisionSMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
            test.stoptest();                
      
        }         
    }   
     static testMethod void  testSaveCreateMethodWithImplid() {
   
        String methodName = UtilConstants.CREATE_SME_DEPARTMENT  ; //GENERATE_SME_DEPARTMENT;
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> optns = new Map<String,Object>();       
        system.runAs(user) {
            Order implementationCase1 =  testdata('Renewal','Termed','SME Bold','National Renewal','WGS 2.0');
            implementationCase1.Are_there_changes_to_Rates__c = UtilConstants.YES;
            update implementationCase1;
            inputMap.put('ImplCaseId',implementationCase1.Id);
            inputMap.put('ImplementationType',implementationCase1.Implementation_Type__c);
            inputMap.put(UtilConstants.PRODUCT_EFFECTIVE_DATE,implementationCase1.Implementation_Effective_Date__c);                 
            test.starttest();
                AP19_RevisionSMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
            test.stoptest();                
      
        }         
    }


     
//------------------------------    GENERATE_SME_DEPARTMENT

       static testMethod void  testSaveGenerateMethod() {
   
        String methodName = UtilConstants.GENERATE_SME_DEPARTMENT;
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> optns = new Map<String,Object>();
        //SMEDepartment__c sme = new SMEDepartment__c(Department_Name__c = 'Test', Omni_Script_Help_Text__c = 'Test Help');
        system.runAs(user) {
            Order implementationCase1 =  testdata('Renewal','Termed','SME Bold','National Renewal','WGS 2.0');
            implementationCase1.Are_there_changes_to_Rates__c = UtilConstants.YES;
            update implementationCase1;
            inputMap.put('ContextId',implementationCase1.Id);
            inputMap.put('ImplementationType',implementationCase1.Implementation_Type__c);
            inputMap.put(UtilConstants.PRODUCT_EFFECTIVE_DATE,implementationCase1.Implementation_Effective_Date__c);                   
            test.starttest();
                AP19_RevisionSMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
            test.stoptest();                
      
        }         
    }   
     static testMethod void  testSaveGenerateMethodWithImplid() {
   
        String methodName = UtilConstants.GENERATE_SME_DEPARTMENT;
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> optns = new Map<String,Object>();       
        system.runAs(user) {
            Order implementationCase1 =  testdata('Renewal','Termed','SME Bold','National Renewal','WGS 2.0');
            implementationCase1.Are_there_changes_to_Rates__c = UtilConstants.YES;
            update implementationCase1;
            inputMap.put('ImplCaseId',implementationCase1.Id);
            inputMap.put('ImplementationType',implementationCase1.Implementation_Type__c);
            inputMap.put(UtilConstants.PRODUCT_EFFECTIVE_DATE,implementationCase1.Implementation_Effective_Date__c);                 
            test.starttest();
                AP19_RevisionSMEApproval.invokeMethod(methodName, inputMap,outMap,optns);
            test.stoptest();                
      
        }         
    }   
}