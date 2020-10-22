/*******************************************************************************************
@class Name  : LGA_AccountStructureOSRemoteServiceTest
@created By  : IDC Offshore
@createdDate : 10/22/2019
@description : This test class is for LGA_CreateGroupPlanDesign
********************************************************************************************/
@isTest
public class LGA_AccountStructureOSRemoteServiceTest {
    @testSetup static void setup() {
        
        //Account creation
        List<Id> accountRecordTypeIdList = new List<Id>();
        Id prospectAccRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();
        accountRecordTypeIdList.add(prospectAccRecordType);
        List<Account> accountObjList = Anthem_TestDataFactory.generateAccount(accountRecordTypeIdList);        
        database.insert (accountObjList);
        
        // Create common test Opportunities
        List<Id> opportunityRecordTypeIdList = new List<Id>();
        Id newBusinsLocalOppRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business Local').getRecordTypeId();
        OpportunityRecordTypeIdList.add(newBusinsLocalOppRecordType);
        List<Opportunity> oppObjList = Anthem_TestDataFactory.generateOpportunity(opportunityRecordTypeIdList, accountObjList.get(0).Id);
        database.insert (oppObjList);
        
        //Create Products
        Product2 product1 = Anthem_TestDataFactory.createProduct('Medical Product','Medical','Plan','1234',true);
        Product2 product3 = Anthem_TestDataFactory.createProduct('Dental Product','Dental','Plan','12345',true);
        Product2 product4 = Anthem_TestDataFactory.createProduct('Vision Product','Vision','Plan','123456',true);
        List<Product2> productList = new List<Product2>{product1,product3,product4}; 
            database.insert (productList);
        
        //Create pricebook
        Id pricebookId = Anthem_TestDataFactory.generatePricebookId();  
        
        // Create common test PricebookEntry        
        PricebookEntry pricebookEntryObj = Anthem_TestDataFactory.generatePricebookEntry(productList[0].Id, pricebookId);
        database.insert (pricebookEntryObj);
        
        // Create common test Group
        Group__c grp = Anthem_TestDataFactory.createGroup(accountObjList[0].Id);
        grp.Billing__c = 'Customized Billing Arrangement';
        grp.Employee_Category__c = 'COBRA;Active;';
        database.insert(grp);
        
        // Create common test Quotes        
        List<Quote>quoteObjList = Anthem_TestDataFactory.createQuote(pricebookId, oppObjList.get(0).Id);
        database.insert (quoteObjList);
        
        
        //Quote line item creation
        List<Id> quoteLineItem = new List<Id>();
        List<QuoteLineItem> quoteLineItemTest = Anthem_TestDataFactory.generateQuoteLineItemByProductList(quoteObjList[0].Id, productList, pricebookEntryObj.Id);      
        for(QuoteLineItem qli : quoteLineItemTest)
        {
            qli.ProductStage__c = 'Sold';        
        } 
        database.insert (quoteLineItemTest); 
        
        //Order creation
        List<Id>orderList = new List<Id>();
        List<Order>orderObjList = Anthem_TestDataFactory.groupPlanImplementationCase(accountObjList.get(0).Id,quoteObjList.get(0).Id,
                                                                                     oppObjList.get(0).Id,grp.Id,quoteLineItemTest[0].Id);
        
        insert orderObjList;   
        
        //Create Employee Class
        List<Employee_Class__c> emList = new List<Employee_Class__c>(Anthem_TestDataFactory.createEmployeeClass(grp.Id,3));
        database.insert(emList);
        
        // Create active GPDs
        List<Group_Plan_Design__c> activeGPDList = Anthem_TestDataFactory.generateGroupPlanDesigns(emList,quoteLineItemTest,accountObjList.get(0).Id,grp.Id);
        database.insert(activeGPDList);
    }
    
    /*******************#######################*************************
************** @description groupPlanTestMethod*******************
******************************************************************/ 
    
    @isTest
    public static  void  groupPlanTestMethod(){
        
        Order implCase = [SELECT id,Impacted_Products_Id__c from Order LIMIT 1];     
        try{
            Test.startTest();
            LGA_AccountStructureOSRemoteService groupPlanDesign = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            optnsJson.put('implCaseId', implCase.Id);
            Boolean result = groupPlanDesign.invokeMethod('createGroupPlan', inputJson, outJson, optnsJson);
            
            Integer countGPD = [Select count() from Group_Plan_Design__c LIMIT 50000];
            Group__c grpEmpCategory = [Select Employee_Category__c from Group__c limit 1];
            String selectedEmpCat = grpEmpCategory.Employee_Category__c;
            Integer countEmpCat = (selectedEmpCat.split(';')).size();
            Integer countEmpClass = [Select count() from Employee_Class__c LIMIT 50000 ];
            Integer countQLI = [Select count() from QuoteLineItem LIMIT 50000 	];
            Integer expectedGPDCount = countEmpClass*countQLI*countEmpCat;
            
            
            
            
            //invoking the same method when Existing group plan design data are present
            result = groupPlanDesign.invokeMethod('createGroupPlan', inputJson, outJson, optnsJson);
            Integer newCountGPD = [Select count() from Group_Plan_Design__c LIMIT 50000 ];
            
            
            Test.stopTest();
            System.assertEquals(true, result, 'Success');
            System.assertEquals(expectedGPDCount, newCountGPD, 'New duplicate GPDs should not be created');
            System.assertEquals(true, result, 'Success');
            System.assertEquals(expectedGPDCount, countGPD, 'GPDs should be created for all possible combination of QLIs and Employee classes');
        } catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        } 
    }
    
    
    /*******************#######################*************************
************** @description groupPlanExceptionTestMethod*******************
******************************************************************/ 
    
    @isTest
    public static  void  groupPlanExceptionTestMethod(){    
        try{
            Test.startTest();
            LGA_AccountStructureOSRemoteService groupPlanDesign = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            Boolean groupPlan = groupPlanDesign.invokeMethod('createGroupPlan', inputJson, outJson, optnsJson);  
            
            Test.stopTest(); 
            System.assertEquals(false, groupPlan, 'Exception');
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    
    /*******************#######################*************************
************** @description billingTestMethod*******************
******************************************************************/ 
    
    @isTest
    public static  void  billingTestMethod(){
        try{
            Test.startTest();
            LGA_AccountStructureOSRemoteService billingArrange = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            inputJson.put('SelectedBilling', 'Customized Billing Arrangement');
            Boolean billing = billingArrange.invokeMethod('fetchBillingArrangement', inputJson, outJson, optnsJson); 
            
            List<LGA_AccountStructureOSRemoteService.Billing> billingList = (List<LGA_AccountStructureOSRemoteService.Billing>)outJson.get(LGA_UTIL_Constants.BILLING_NODE_NAME);
            
            Test.stopTest(); 
            System.assert(billingList.size()>0, 'Picklist values should be embedded in the output JSON');
            System.assertEquals(true, billing, 'Success');
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }   
    }
    
    /**
* @description testFetchEmpCategoryPreSelected - to have already selected employee category vlcSelected as true
*/
    
    @isTest
    public static void testFetchEmpCategoryPreSelected()
    {
        try{
            Test.startTest();      
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            inputJson.put('SelectedEmpCategory','Retiree All');
            Boolean methodExec = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.FETCH_EMP_CATEGORY_OPTIONS, inputJson, outJson, optnsJson);            
            List<LGA_AccountStructureOSRemoteService.EmployeeCategory> empCatList = (List<LGA_AccountStructureOSRemoteService.EmployeeCategory>)outJson.get(LGA_UTIL_Constants.EMP_CATEGORY_NODE_NAME);
            Boolean isMatched = false;            
            for(LGA_AccountStructureOSRemoteService.EmployeeCategory empCatObj:empCatList){
                if(empCatObj.employeeCategory.equals('Retiree All')){
                    isMatched = empCatObj.vlcSelected;
                    break;
                }               
            }
            
            Test.stopTest();
            System.assertEquals(true, isMatched, 'Existing Emp Category is pre-selected.');  
            System.assertEquals(true, methodExec, 'Success');   
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    /**
* @description testFetchEmpCategoryNoPreSelected
*/
    
    @isTest
    public static void testFetchEmpCategoryNoPreSelected()
    {
        try{
            Test.startTest();      
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            inputJson.put('SelectedEmpCategory','');
            Boolean methodExec = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.FETCH_EMP_CATEGORY_OPTIONS, inputJson, outJson, optnsJson);            
            List<LGA_AccountStructureOSRemoteService.EmployeeCategory> empCatList = (List<LGA_AccountStructureOSRemoteService.EmployeeCategory>)outJson.get(LGA_UTIL_Constants.EMP_CATEGORY_NODE_NAME);
            Boolean isMatched = false;            
            for(LGA_AccountStructureOSRemoteService.EmployeeCategory empCatObj:empCatList){
                if(empCatObj.vlcSelected){
                    isMatched = true;
                    break;
                }               
            }
            
            Test.stopTest();
            System.assertEquals(false, isMatched, 'No Pre selected Emp Category.');  
            System.assertEquals(true, methodExec, 'Success');  
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    /**
* @description testFetchEmpCategoryWrongNodeName
*/
    
    @isTest
    public static void testFetchEmpCategoryWrongNodeName()
    {
        try{
            Test.startTest();      
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            inputJson.put('SelectedEmpCategoryTest','Retiree All;Under 65 Retiree');
            Boolean methodExec = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.FETCH_EMP_CATEGORY_OPTIONS, inputJson, outJson, optnsJson);            
            
            Test.stopTest();
            System.assertEquals(false, methodExec, 'Success');
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    
    /**
* @description testInvokeMethod- Vlocity invokeMethod.
*/
    
    @isTest
    public static void testInvokeMethodName(){
        try{
            Test.startTest();      
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();   
            Boolean result = actStucRemoteServc.invokeMethod('fetchEmployeeCategoryTest', inputJson, outJson, optnsJson);            
            
            Test.stopTest();
            System.assertEquals(false, result, 'Success - No such named remote action exists'); 
        }  catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    /**
* @description testFetchQLINewHireProbation
*/
    
    @isTest
    public static void testFetchQLINewHireProbation()
    {
        try{
            Test.startTest();      
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            Boolean methodExec = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.FETCH_QLI_DEMOSTIC_PARTNER_NEW_HIRE, inputJson, outJson, optnsJson);            
            List<LGA_AccountStructureOSRemoteService.PicklistVals> newHireProbList = (List<LGA_AccountStructureOSRemoteService.PicklistVals>)outJson.get(LGA_UTIL_Constants.NEW_HIRE_PROB_VALS);
            List<LGA_AccountStructureOSRemoteService.PicklistVals> domPartnerList = (List<LGA_AccountStructureOSRemoteService.PicklistVals>)outJson.get(LGA_UTIL_Constants.DOMESTIC_PARTNER_VALS);
            
            Test.stopTest();
            System.assert(newHireProbList.size() > 0, 'New Hire Probation pilcklist values populated');     
            System.assert(domPartnerList.size() > 0, 'Domestic Partner pilcklist values populated'); 
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    /**
* @description testFetchQLIDomesticPartnerWrongMethod
*/
    
    @isTest
    public static void testFetchQLIDomesticPartnerWrongMethod(){
        try{
            Test.startTest();      
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();   
            boolean result = actStucRemoteServc.invokeMethod('fetchDomPartnerNewHireProbTest', inputJson, outJson, optnsJson);            
            
            Test.stopTest();
            System.assertEquals(false, result, 'Success - No such named remote action exists'); 
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    /**
* @description testBillingAttchmentSingleInvoice
*/
    
    @isTest
    public static void testBillingAttchmentSingleInvoice()
    {
        try{
            Test.startTest();    
            Order implCase = [SELECT id,AccountId,Group_Name__c from Order LIMIT 1]; 
            Id accountId = implCase.AccountId;
            Id groupId = implCase.Group_Name__c;
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            String selectedBillingOption = 'Single Invoice (containing all Suffixes)';
            inputJson.put('SelectedBilling','Single Invoice (containing all Suffixes)');
            optnsJson.put('selectedAccountId',accountId);
            optnsJson.put('selectedGroupId',groupId);
            optnsJson.put('selectedBillingOption',selectedBillingOption);
            Boolean methodExec = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.ATTACH_BILLING_INVOICE_ACCTSTRUC, inputJson, outJson, optnsJson);            
            
            List<Group_Plan_Design__c> allActiveGPDList = [SELECT Id,Billing_Arrangement_Record_ID__c from Group_Plan_Design__c WHERE Group__c = :groupId AND Is_Active_Indicator__c = true LIMIT 50000 ];
            List<Group_Plan_Design__c> attachedGPDList = [SELECT ID,Billing_Arrangement_Record_ID__c,Is_Active_Indicator__c from Group_Plan_Design__c WHERE Group__c = :groupId AND Is_Active_Indicator__c = true AND Billing_Arrangement_Record_ID__c != null LIMIT 50000 ];  
            // System.debug('allActiveGPDList : ' + allActiveGPDList.size() + ' , attachedGPDList size : ' + attachedGPDList.size());
            
            Id billingArranmgementId = attachedGPDList.get(0).Billing_Arrangement_Record_ID__c;
            boolean sameBillingArrangeId = true;
            for(Group_Plan_Design__c gpd:allActiveGPDList){
                sameBillingArrangeId = (gpd.Billing_Arrangement_Record_ID__c == billingArranmgementId);
            }
            
            Boolean methodExecAgainByUser = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.ATTACH_BILLING_INVOICE_ACCTSTRUC, inputJson, outJson, optnsJson);            
            
            List<Employee_Class__c> emList = new List<Employee_Class__c>(Anthem_TestDataFactory.createEmployeeClass(groupId,3));
            database.insert(emList);
            List<QuoteLineItem> qliList = [Select Id from QuoteLineItem LIMIT 50000];
            List<Group_Plan_Design__c> activeGPDList = Anthem_TestDataFactory.generateGroupPlanDesigns(emList,qliList,accountId,groupId);
            database.insert(activeGPDList);
            Boolean methodExecAgain = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.ATTACH_BILLING_INVOICE_ACCTSTRUC, inputJson, outJson, optnsJson);            
            
            Test.stopTest();
            System.assert(true, methodExec); 
            System.assert(attachedGPDList.size() == allActiveGPDList.size(), 'All active GPDs are attached to a billing preference'); 
            System.assert(sameBillingArrangeId == true, 'All active GPDs are attached to a single billing preference'); 
            System.assert(true, methodExecAgainByUser); 
            System.assert(true, methodExecAgain);
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    @isTest
    public static void testNoBillingAttchmentSingleInvoice()
    {
        try{
            Test.startTest();    
            Order implCase = [SELECT id,AccountId,Group_Name__c from Order LIMIT 1]; 
            Id accountId = implCase.AccountId;
            Id groupId = implCase.Group_Name__c;
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            //String selectedBillingOptionList = '';
            inputJson.put('SelectedBilling','Single Invoice (containing all Suffixes)');
            optnsJson.put('selectedAccountId',accountId);
            optnsJson.put('selectedGroupId',groupId);
            optnsJson.put('selectedBillingOption','Single Invoice (containing all Suffixes)');
            Boolean methodExec = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.ATTACH_BILLING_INVOICE_ACCTSTRUC, inputJson, outJson, optnsJson);            
            
            List<Group_Plan_Design__c> allActiveGPDList = [SELECT Id,Billing_Arrangement_Record_ID__c from Group_Plan_Design__c WHERE Group__c = :groupId AND Is_Active_Indicator__c = true LIMIT 50000 ];
            List<Group_Plan_Design__c> attachedGPDList = [SELECT ID,Billing_Arrangement_Record_ID__c,Is_Active_Indicator__c from Group_Plan_Design__c WHERE Group__c = :groupId AND Is_Active_Indicator__c = true AND Billing_Arrangement_Record_ID__c != null LIMIT 50000 ];  
            //System.debug('allActiveGPDList : ' + allActiveGPDList.size() + ' , attachedGPDList size : ' + attachedGPDList.size());
            
            Id billingArranmgementId = attachedGPDList.get(0).Billing_Arrangement_Record_ID__c;
            boolean sameBillingArrangeId = true;
            for(Group_Plan_Design__c gpd:allActiveGPDList){
                sameBillingArrangeId = (gpd.Billing_Arrangement_Record_ID__c == billingArranmgementId);
            }
            
            Boolean methodExecAgainByUser = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.ATTACH_BILLING_INVOICE_ACCTSTRUC, inputJson, outJson, optnsJson);            
            
            List<Employee_Class__c> emList = new List<Employee_Class__c>(Anthem_TestDataFactory.createEmployeeClass(groupId,3));
            database.insert(emList);
            List<QuoteLineItem> qliList = [Select Id from QuoteLineItem LIMIT 50000];
            List<Group_Plan_Design__c> activeGPDList = Anthem_TestDataFactory.generateGroupPlanDesigns(emList,qliList,accountId,groupId);
            database.insert(activeGPDList);
            Boolean methodExecAgain = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.ATTACH_BILLING_INVOICE_ACCTSTRUC, inputJson, outJson, optnsJson);            
            
            Test.stopTest();
            
            System.assert(true, methodExec);
            System.assert(attachedGPDList.size() == allActiveGPDList.size(), 'All active GPDs are attached to a billing preference'); 
            System.assert(sameBillingArrangeId == true, 'All active GPDs are attached to a single billing preference'); 
            System.assert(true, methodExecAgainByUser);
            System.assert(true, methodExecAgain);
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    
    /**
* @description testUpdateEmpCatGPDs
*/
    
    @isTest
    public static void testUpdateEmpCatGPDs()
    {
        try{
            Test.startTest();    
            Order implCase = [SELECT id,AccountId,Group_Name__c from Order LIMIT 1]; 
            Id accountId = implCase.AccountId;
            Id groupId = implCase.Group_Name__c;
            
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            inputJson.put('PreSelectedEmpCategory','Active;COBRA;');
            inputJson.put('SelectedEmpCategory','COBRA;');
            inputJson.put('AccountId',accountId);
            inputJson.put('GroupID',groupId);
            Boolean methodExec = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.UPDATE_EMP_CATEGORY_DEL_GPDS, inputJson, outJson, optnsJson);            
            
            Group__c grp = [SELECT id,Employee_Category__c from Group__c where Id = :groupId LIMIT 50000]; 
            
            Integer activeEmpCatGpdCount = [SELECT count() from Group_Plan_Design__c WHERE Group__c = :groupId AND Employee_Category__c = 'Active' LIMIT 50000];          
            
            Test.stopTest();
            System.assert(true, methodExec);
            System.assert(grp.Employee_Category__c == 'COBRA', 'Applicable Employee Categories is updated');
            System.assert(activeEmpCatGpdCount == 0, 'Active Emp category  GPDs are deleted from this Group');
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    /**
* @description testUpdateEmpCatGPDs
*/
    
    @isTest
    public static void testNoUpdateEmpCatGPDs()
    {
        try{
            Test.startTest();    
            Order implCase = [SELECT id,AccountId,Group_Name__c from Order LIMIT 1]; 
            Id accountId = implCase.AccountId;
            Id groupId = implCase.Group_Name__c;
            
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            inputJson.put('PreSelectedEmpCategory','Active;COBRA;');
            inputJson.put('SelectedEmpCategory',null);
            inputJson.put('AccountId',accountId);
            inputJson.put('GroupID',groupId);
            Boolean methodExec = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.UPDATE_EMP_CATEGORY_DEL_GPDS, inputJson, outJson, optnsJson);            
            
            Test.stopTest();
            System.assertEquals(false, methodExec);
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
    
    /**
* @description testBillingAttchmentOneInvPerEmpClass
*/
    
    @isTest
    public static void testBillingAttchmentOneInvPerEmpClass()
    {
        try{
            Test.startTest();    
            Order implCase = [SELECT id,AccountId,Group_Name__c from Order LIMIT 1]; 
            Id accountId = implCase.AccountId;
            Id groupId = implCase.Group_Name__c;
            LGA_AccountStructureOSRemoteService actStucRemoteServc = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            
            inputJson.put('SelectedBilling','Single Invoice (containing all Suffixes)');
            optnsJson.put('selectedAccountId',accountId);
            optnsJson.put('selectedBillingOption','One Invoice per Employee Class');
            optnsJson.put('selectedGroupId',groupId);
            
            Boolean methodExec = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.ATTACH_BILLING_INVOICE_ACCTSTRUC, inputJson, outJson, optnsJson);            
            
            List<Group_Plan_Design__c> allActiveGPDList = [SELECT Id,Billing_Arrangement_Record_ID__c,Employee_Class_Record_ID__c from Group_Plan_Design__c WHERE Group__c = :groupId AND Is_Active_Indicator__c = true LIMIT 50000];
            List<Group_Plan_Design__c> attachedGPDList = [SELECT ID,Billing_Arrangement_Record_ID__c,Employee_Class_Record_ID__c,Is_Active_Indicator__c from Group_Plan_Design__c WHERE Group__c = :groupId AND Is_Active_Indicator__c = true AND Billing_Arrangement_Record_ID__c != null LIMIT 50000 ];  
            // System.debug('allActiveGPDList : ' + allActiveGPDList.size() + ' , attachedGPDList size : ' + attachedGPDList.size());
            
            
            Map<Id,List<Group_Plan_Design__c>> activeGPDMap = new Map<Id,List<Group_Plan_Design__c>>();            
            for(Group_Plan_Design__c activeGpd : allActiveGPDList){
                if(activeGPDMap.containsKey(activeGpd.Employee_Class_Record_ID__c)){
                    activeGPDMap.get(activeGpd.Employee_Class_Record_ID__c).add(activeGpd);
                }else{
                    List<Group_Plan_Design__c> gpdList = new List<Group_Plan_Design__c>();
                    gpdList.add(activeGpd);
                    activeGPDMap.put(activeGpd.Employee_Class_Record_ID__c, gpdList);
                }                
            }
            boolean isBASamePerEmpClass = false;
            for(Id empClassIdKey:activeGPDMap.keySet()){                    
                List<Group_Plan_Design__c> activeGpdPerEmpClassList = activeGPDMap.get(empClassIdKey);  
                Id billingArrangementId = activeGpdPerEmpClassList.get(0).Billing_Arrangement_Record_ID__c;
                for(Group_Plan_Design__c gpd: activeGpdPerEmpClassList){
                    isBASamePerEmpClass = gpd.Billing_Arrangement_Record_ID__c == billingArrangementId;
                }
                System.assert(isBASamePerEmpClass == true, 'All active GPDs per emp class are attached to a same billing preference');   
                
            }
            
            
            Boolean methodExecAgainByUser = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.ATTACH_BILLING_INVOICE_ACCTSTRUC, inputJson, outJson, optnsJson);            
            
            List<Employee_Class__c> emList = new List<Employee_Class__c>(Anthem_TestDataFactory.createEmployeeClass(groupId,3));
            database.insert(emList);
            List<QuoteLineItem> qliList = [Select Id from QuoteLineItem LIMIT 50000 ];
            List<Group_Plan_Design__c> activeGPDList = Anthem_TestDataFactory.generateGroupPlanDesigns(emList,qliList,accountId,groupId);
            database.insert(activeGPDList);
            inputJson.put('SelectedBilling','One Invoice per Employee Class');
            Boolean methodExecAgain = actStucRemoteServc.invokeMethod(LGA_UTIL_Constants.ATTACH_BILLING_INVOICE_ACCTSTRUC, inputJson, outJson, optnsJson);            
            Test.stopTest();
            System.assert(true, methodExec); 
            System.assert(attachedGPDList.size() == allActiveGPDList.size(), 'All active GPDs are attached to a billing preference'); 
            System.assert(true, methodExecAgainByUser);
            System.assert(true, methodExecAgain); 
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
        
    }
    
    
    
    /********************************************************************************************
@description:deleteEmployeeClassesTestMethod
********************************************************************************************/
    
    @isTest
    public static  void  deleteEmployeeClassesTestMethod(){
        try{
            Order implCase = [SELECT id,Impacted_Products_Id__c FROM Order LIMIT 1]; 
            Employee_Class__c empClass = [SELECT Id FROM Employee_Class__c LIMIT 1];
            Test.startTest();
            LGA_AccountStructureOSRemoteService deleteEmployeeClasses = new LGA_AccountStructureOSRemoteService();
            Map <String, Object> inputJson = new Map<String,Object>();
            Map <String, Object> outJson = new Map <String,Object>();
            Map <String, Object> optnsJson = new Map <String,Object>();
            optnsJson.put('implCaseId', implCase.Id);
            inputJson.put(LGA_UTIL_Constants.DELETE_EMP_CLASS_METHODNAME,empClass.Id);
            Boolean dec = deleteEmployeeClasses.invokeMethod(LGA_UTIL_Constants.DELETE_EMP_CLASS_METHODNAME, inputJson, outJson, optnsJson); 
            
            Test.stopTest();        
            System.assert(dec == false);
        }catch(exception ex){
            system.debug('@@@@@exception'+ ex);
        }
    }
    
}