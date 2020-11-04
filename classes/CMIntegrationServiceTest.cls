@isTest
private class CMIntegrationServiceTest {

    @testSetup
    static void setup() {
		CMIntegrationServiceTestDataFactory.prepareTestData();
	}    
    @isTest
    static void testPositive() {
        Order od = [select id, AccountId from Order limit 1];
        Group__c grp = [Select Id from Group__c LIMIT 1];
      //  grp.Customer_Requested_Group_Number__c ='122222';
        grp.ClaimSystem__c = 'WGS 2.0';
        update grp;
        od.Group_Name__c = grp.id;
        update od;
        Department_Code__c depCode= IntegrationTestDataUtilty.createDepartmntCode(od.AccountId, 'Test0', true);
        List<Account> acc=[Select Id, Global_Customer_ID__c from Account where Id=: od.AccountId LIMIT 1];
        if(acc.size()>0){
        String recTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();
        acc[0].RecordTypeId = recTypeId;   
        acc[0].Global_Customer_ID__c = '123456';
        acc[0].Claims_Savings_Vendor__c = 'ND8';
        acc[0].Account_Medical_Funding_Type__c = 'FI';
        update acc[0];
        }
        String dateString = CMIntegrationGroupLoad.convertDateToYYMMDDAddOneYear(Date.today());
        CMIntegrationRequest req = CMIntegrationGroupLoad.buildCMPayload(CMIntegrationService.prepareOrder(od.id), 
                                                                       CMIntegrationService.buildEventMetaData('AddUpdate'));

        System.assert(req != null);
    }
    @isTest
    static void testMaintenance() {
        Order od = [select id, Implementation_Type__c from Order limit 1];
        Group__c grp = [Select Id from Group__c LIMIT 1];
      //  grp.Customer_Requested_Group_Number__c ='122222';
        grp.ClaimSystem__c = 'WGS 2.0';
        update grp;
        od.Implementation_Type__c = 'Change Request Off Cycle';
        od.Maintenance_Reason_Customer_Master__c ='Rate adjustment due to internal error; Change Account Name';
        od.Group_Name__c = grp.id;
        update od;
        String res = CMIntegrationService.submitCaseToCM(CMIntegrationService.prepareOrder(od.id), 
                                                                       'AddUpdate');

        System.assert(res != null);
    }
    @isTest
    static void testOtOfScopeError() {
        Order od = [select id, Implementation_Type__c from Order limit 1];
        od.Implementation_Type__c = 'Pre Work';
        update od;
        String res = CMIntegrationService.submitCaseToCM(CMIntegrationService.prepareOrder(od.id), 
                                                                       'AddUpdate');

        System.assert(res != null);
    }
    @isTest
    static void testBulk() {
        // TODO
        Order od = [select id from Order limit 1];
        CMIntegrationServiceIDCardSoapCall.UICall('case', od.id, null);
        String res = CMIntegrationServiceIDCardSoapCall.UICall('case', 'abc', null);
        
        System.assert(res != null);
    }
    @isTest
    static void testNegative1() {
        // TODO
        Order od = [select id, AccountId from Order limit 1];
        List<Account> accnt=[Select Id, Global_Customer_ID__c from Account where Id=: od.AccountId LIMIT 1];
        if(accnt.size()>0){
        String recTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();
        accnt[0].RecordTypeId = recTypeId; 
        accnt[0].Global_Customer_ID__c = '123456';
        accnt[0].Claims_Savings_Vendor__c = 'ND8';
        update accnt[0];
        }
        CMIntegrationService.cmIntRestServicePostCall(od.id);
        CMIntegrationService.cmRestServicePostCallNoNull();
        
        // od.Implementation_Type__c = 'Renewal';
        // update od;
        CMIntegrationService.cmIntRestServicePostCall(od.id);
        Account acc = [select id from Account limit 1];
        CMIntegrationService.triggerIDCardAccountLevel(acc.id);
        CMIntegrationService.triggerIDCardCaseLevel(od.id);
        List<String> suffixList = new List<String>();
        suffixList.add('aa');
        String res = CMIntegrationService.triggerIDCardSuffixLevel(od.id, suffixList);
        
        System.assert(res != null);
        
    }
    @isTest
    static void testNegative2() {
        // TODO
        Order od = [select id from Order limit 1];
        String res = CMIntegrationService.submitCaseToCMforPreview(od.id);
        
   		RestRequest request = new RestRequest();
        request.requestUri =URL.getSalesforceBaseUrl().toExternalForm() +'/'+ od.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        CMIntegrationService.cmRestServicePostCallNoNull();
        CMIntegrationService.cmIntRestServicePostCall(null);
        System.assert(res != null);
        
    }
    @isTest
    static void testNegative3() {
        // TODO
        Order od = [select id from Order limit 1];
        String res = CMIntegrationService.submitCaseToCMforAddUpdate(od.id);
        System.assert(res != null);
        
    }
    
    @isTest
    static void testGroupNumberGenerationPartialSuccess(){
        Quote qte = [Select Id, AccountId, GroupNumber__c from Quote where Name ='Test Quote'];
        qte.Pricebook2Id = Test.getStandardPricebookId();
        update qte; 
        
        List<group__c> grp = [Select Id, Name from Group__c where Id =: qte.GroupNumber__c];
        if(grp.size() >0){
            grp[0].Name ='TBD';
            Database.update(grp[0]);
        }
        
        Product2 prod = IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Prod.Product_Type__c ='Medical';
        Database.update(prod);
        
        PricebookEntry pbe= IntegrationTestDataUtilty.createpricebookEntry(prod.Id, true);
         
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.vlocity_ins__ContractCode__c = '40QA';
        qli.ProductStage__c ='Sold';
        Database.insert(qli);
        
        Product2 prod1=IntegrationTestDataUtilty.createProduct(false);
        Prod1.Product_Type__c ='LTD';
        Database.insert(prod1);      
        PricebookEntry pbe1= IntegrationTestDataUtilty.createpricebookEntry(prod1.Id, true);
         
        QuoteLineItem qli1= IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe1.Id, false);
        qli1.Product2Id = prod1.Id;
        qli1.ProductStage__c ='Sold';
        Database.insert(qli1);
              
        String respBody = '{"responseMsg": {"statusCode": "PARTIAL SUCCESS","externalNumber":[{"productType":"Medical","id": "W12367","claimSystem":"WGS"},'
        				 +'{"productType":"LTD","id": "321456","claimSystem":"COMPASS"}],'
                         +'"globalCustomerNumber":"12345","customerNumber":"2345",'
					     +'"responseDetails": {'
		 				 +'"listOfErrorCodes": [{"category": "Functional","errorCode": "EXB1001","bindingFiled":"","entityName": "","errorMessage": "CaseId is already present"}] }}}';
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CMGroupNumberReqCalloutMock(respBody));        
        CMIntegrationService.generateGroupNumber(qte.Id, '555555');     
        Order od = [select id, AccountId from Order limit 1];
        String res = CMIntegrationService.submitCaseToCMforAddUpdate(od.id);
        Test.stopTest();
        List<Integration_Event_log__c> eventLogs = [Select Id from Integration_Event_log__c where Quote__c =: qte.Id];
        System.assertEquals(1, eventLogs.size(), 'Event Log not created');  
        List<Group__c> grpsList = [Select Id, Name from Group__c where Name = 'W12367'];
        System.assertEquals(1, grpsList.size(), 'Group upsert error');
        Account acc = [Select Id, Global_Customer_ID__c from Account where Id =: qte.AccountId];
        System.assertEquals('12345', acc.Global_Customer_ID__c, 'Account not updated');
        Quote qt = [Select Id, GroupNumber__c from Quote where Id =: qte.Id];
        System.assertEquals(grpsList[0].Id, qt.GroupNumber__c, 'Group Number on Quote is not updated');
        QuoteLineItem qliUpdated = [Select Id, Group__c from QuoteLineItem where Id =: qli.Id];
        System.assertEquals(grpsList[0].Id, qliUpdated.Group__c, 'Group Number on QuoteLineItem is not updated');
    }
    
    @isTest
    static void testGroupNumberGenerationSuccess(){
        Quote qte = [Select Id, AccountId, GroupNumber__c from Quote where Name ='Test Quote'];
        qte.Pricebook2Id = Test.getStandardPricebookId();
        update qte; 

        Product2 prod = IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Prod.Product_Type__c ='Medical';
        Database.update(prod);
        
        PricebookEntry pbe= IntegrationTestDataUtilty.createpricebookEntry(prod.Id, true);
         
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.vlocity_ins__ContractCode__c = '40QA';
        qli.ProductStage__c ='Sold';
        Database.insert(qli);
        
        String respBody = '{"responseMsg": {"statusCode": "SUCCESS","externalNumber":[{"productType":"Medical","id": "Test Group","claimSystem":"WGS"},'
        					+'{"productType":"LTD","id": "321456","claimSystem":"COMPASS"}],'
                            +'"globalCustomerNumber":"12345","customerNumber":"2345"}}';
        
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CMGroupNumberReqCalloutMock(respBody));        
        CMIntegrationService.generateGroupNumber(qte.Id, '555555');
        Test.stopTest();
        List<Integration_Event_log__c> eventLogs = [Select Id from Integration_Event_log__c where Quote__c =: qte.Id];
        System.assertEquals(1, eventLogs.size(), 'Event Log not created'); 
        List<Group__c> grpsList = [Select Id, Name from Group__c where Name = '321456'];
        System.assertEquals(1, grpsList.size(), 'Group upsert error');
        Account acc = [Select Id, Global_Customer_ID__c from Account where Id =: qte.AccountId];
        System.assertEquals('12345', acc.Global_Customer_ID__c, 'Account not updated');
    }
    
    @isTest
    static void testGroupClaimSystemVal(){
        Quote qte = [Select Id, AccountId from Quote where Name ='Test Quote'];
   
        Group__c wgsGrp = IntegrationTestDataUtilty.createGroup(qte.AccountId, true);
        wgsGrp.Name = 'Test Group 2';
        Database.update(wgsGrp); 
        
         CMIntegrationService.generateGroupNumber(qte.Id, '555555'); 
         List<Integration_Event_log__c> eventLogs = [Select Id from Integration_Event_log__c where Quote__c =: qte.Id];
        System.assertEquals(1, eventLogs.size(), 'Event Log not created');  
    }
    
    @isTest
    static void testProducTypesValid(){
        Quote qte = [Select Id, AccountId from Quote where Name ='Test Quote'];
        qte.Pricebook2Id = Test.getStandardPricebookId();
        update qte; 
        
        Product2 prod = IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Prod.Product_Type__c = 'Other';
        Database.update(prod);
        
        PricebookEntry pbe= IntegrationTestDataUtilty.createpricebookEntry(prod.Id, true);
         
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.vlocity_ins__ContractCode__c = '40QA';
        qli.ProductStage__c ='Sold';
        Database.insert(qli); 
        
         CMIntegrationService.generateGroupNumber(qte.Id, '555555'); 
         List<Integration_Event_log__c> eventLogs = [Select Id from Integration_Event_log__c where Quote__c =: qte.Id];
        System.assertEquals(1, eventLogs.size(), 'Event Log not created');  
    }
    
        @isTest
       static void testGenerateGroupNoStatusError(){
        
        Quote qte = [Select Id from Quote where Name ='Test Quote'];
        qte.Pricebook2Id = Test.getStandardPricebookId();
        update qte; 
        
        Product2 prod=IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Prod.Product_Type__c ='Medical';
        Database.update(prod);
        
        PricebookEntry pbe= IntegrationTestDataUtilty.createpricebookEntry(prod.Id, true);
         
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.vlocity_ins__ContractCode__c = '40QA';
        qli.ProductStage__c ='Sold';
        Database.insert(qli);
        
        Product2 prod1=IntegrationTestDataUtilty.createProduct(false);
        Prod1.Product_Type__c ='LTD';
        Database.insert(prod1);
        
        PricebookEntry pbe1= IntegrationTestDataUtilty.createpricebookEntry(prod1.Id, true);
         
        QuoteLineItem qli1= IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe1.Id, false);
        qli1.Product2Id = prod1.Id;
        qli1.ProductStage__c ='Sold';
        Database.insert(qli1);
              
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CMGroupNumberReqCalloutMock('{"responseMsg":{"statusCode":"ERROR","globalCustomerNumber":"1234","customerNumber":"2345","responseDetails":{"listOfErrorCodes":[{"category":"Functional","errorCode":"EXB1001","errorMessage":"CaseId is already present"}]}}}'));        
        CMIntegrationService.generateGroupNumber(qte.Id, '555555');      
        Test.stopTest();
        List<Integration_Event_log__c> eventLogs = [Select Id from Integration_Event_log__c where Quote__c =: qte.Id];
        System.assertEquals(1, eventLogs.size(), 'Event Log not created');       
    }
    
    @isTest
    static void testGroupNoResValiError2(){
         Quote qte = [Select Id from Quote where Name ='Test Quote'];
        qte.Pricebook2Id = Test.getStandardPricebookId();
        update qte; 
        
        Product2 prod=IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Prod.Product_Type__c ='Medical';
        Database.update(prod);
        
        PricebookEntry pbe= IntegrationTestDataUtilty.createpricebookEntry(prod.Id, true);
         
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.vlocity_ins__ContractCode__c = '40QA';
        qli.ProductStage__c ='Sold';
        Database.insert(qli);
        
        String respBody = '{"responseMsg":{"statusCode":"SUCCESS","globalCustomerNumber":"1234","customerNumber":"2345",'
            				+'"responseDetails":{"listOfErrorCodes":[{"category":"Functional","errorCode":"EXB1001","errorMessage":"CaseId is already present"}]}}}';
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CMGroupNumberReqCalloutMock(respBody));        
        CMIntegrationService.generateGroupNumber(qte.Id, '555555');      
        Test.stopTest();
        List<Integration_Event_log__c> eventLogs = [Select Id, status_Message__c from Integration_Event_log__c where Quote__c =: qte.Id];
        System.assertEquals(1, eventLogs.size(), 'Event Log not created'); 
        System.assertEquals('Error - Missing external numbers for Success scenario', eventLogs[0].Status_Message__c, 'Status Message not updated');
    }
    
     @isTest
    static void testGroupNoResValiError3(){
         Quote qte = [Select Id from Quote where Name ='Test Quote'];
        qte.Pricebook2Id = Test.getStandardPricebookId();
        update qte; 
        
        Product2 prod=IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Prod.Product_Type__c ='Medical';
        Database.update(prod);
        
        PricebookEntry pbe= IntegrationTestDataUtilty.createpricebookEntry(prod.Id, true);
         
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.vlocity_ins__ContractCode__c = '40QA';
        qli.ProductStage__c ='Sold';
        Database.insert(qli);
        
        String respBody = '{"responseMsg": {"statusCode": "PARTIAL SUCCESS","externalNumber":[{"productType":"Medical","id": "","claimSystem":"WGS"},'
        					+'{"productType":"LTD","id": "321456","claimSystem":"COMPASS"}],'
                            +'"globalCustomerNumber":"12345","customerNumber":"2345"}}';
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CMGroupNumberReqCalloutMock(respBody));        
        CMIntegrationService.generateGroupNumber(qte.Id, '555555');      
        Test.stopTest();
        List<Integration_Event_log__c> eventLogs = [Select Id, Status_Message__c from Integration_Event_log__c where Quote__c =: qte.Id];
        System.assertEquals(1, eventLogs.size(), 'Event Log not created');
		System.assertEquals('Error - Missing Product Type or Claim System or Id for external numbers in the response', eventLogs[0].Status_Message__c, 'Status Message not updated');        
    }
    
     @isTest
    static void testProdTypeClmSysError(){
        Quote qte = [Select Id, AccountId from Quote where Name ='Test Quote'];
        qte.Pricebook2Id = Test.getStandardPricebookId();
        update qte; 
        
        Product2 prod = IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Prod.Product_Type__c ='Medical';
        Database.update(prod);
        
        PricebookEntry pbe= IntegrationTestDataUtilty.createpricebookEntry(prod.Id, true);
         
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.vlocity_ins__ContractCode__c = '40QA';
        qli.ProductStage__c ='Sold';
        Database.insert(qli);
        
        String respBody = '{"responseMsg": {"statusCode": "PARTIAL SUCCESS","externalNumber":[{"productType":"Medical","id": "Test Group","claimSystem":"WGS"},{"productType":"Medical","id": "321456","claimSystem":"COMPASS"}],'
                           +'"globalCustomerNumber":"12345","customerNumber":"2345",'
						   +'"responseDetails": {'
						   +'"listOfErrorCodes": [{"category": "Functional","errorCode": "EXB1001","bindingFiled":"","entityName": "","errorMessage": "CaseId is already present"}] }}}';
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CMGroupNumberReqCalloutMock(respBody));        
        CMIntegrationService.generateGroupNumber(qte.Id, '555555');      
        Test.stopTest();
        List<Integration_Event_log__c> eventLogs = [Select Id from Integration_Event_log__c where Quote__c =: qte.Id];
        System.assertEquals(1, eventLogs.size(), 'Event Log not created');   
    }
    
     @isTest
    static void testGrpNumberExistsError(){
        Quote qte = [Select Id, AccountId from Quote where Name ='Test Quote'];
        qte.Pricebook2Id = Test.getStandardPricebookId();
        update qte; 
        
        Product2 prod = IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Prod.Product_Type__c ='Medical';
        Database.update(prod);
        
        PricebookEntry pbe= IntegrationTestDataUtilty.createpricebookEntry(prod.Id, true);
         
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.vlocity_ins__ContractCode__c = '40QA';
        qli.ProductStage__c ='Sold';
        Database.insert(qli);
        
        String respBody = '{"responseMsg": {"statusCode": "PARTIAL SUCCESS","externalNumber":[{"productType":"Medical","id": "W12345","claimSystem":"WGS"}],'
                         +'"globalCustomerNumber":"12345","customerNumber":"2345",'
						 +'"responseDetails": {'
						 +'"listOfErrorCodes": [{"category": "Functional","errorCode": "EXB1001","bindingFiled":"","entityName": "","errorMessage": "CaseId is already present"}]}}}';
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CMGroupNumberReqCalloutMock(respBody));        
        CMIntegrationService.generateGroupNumber(qte.Id, '555555');      
        Test.stopTest();
        List<Integration_Event_log__c> eventLogs = [Select Id from Integration_Event_log__c where Quote__c =: qte.Id];
        System.assertEquals(1, eventLogs.size(), 'Event Log not created');   
    }
    
     @isTest
    static void testGrpNumberResponseError(){
        Quote qte = [Select Id, AccountId from Quote where Name ='Test Quote'];
        qte.Pricebook2Id = Test.getStandardPricebookId();
        update qte; 
        
        Product2 prod = IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Prod.Product_Type__c ='Medical';
        Database.update(prod);
        
        PricebookEntry pbe= IntegrationTestDataUtilty.createpricebookEntry(prod.Id, true);
         
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.vlocity_ins__ContractCode__c = '40QA';
        qli.ProductStage__c ='Sold';
        Database.insert(qli);
        
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CMGroupNumberReqCalloutMock('{"responseMsg": null'));        
        CMIntegrationService.generateGroupNumber(qte.Id, '555555');      
        Test.stopTest();
        List<Integration_Event_log__c> eventLogs = [Select Id from Integration_Event_log__c where Quote__c =: qte.Id];
        System.assertEquals(1, eventLogs.size(), 'Event Log not created');   
    }

}