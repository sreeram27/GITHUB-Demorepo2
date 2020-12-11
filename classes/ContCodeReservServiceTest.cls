@isTest(SeeAllData=false)
public class ContCodeReservServiceTest {
    
    
    @isTest static void testContCodeReserve() {
        Test.startTest();
        ContCodeReservRequest rr = new ContCodeReservRequest();
        ContCodeReserveResponse res = new ContCodeReserveResponse();
        
        Test.setMock(HttpCalloutMock.class, new ContCodeReserveResponseMockTest());
        
        res = ContCodeReservService.reserveContractCode(rr);
       
        system.debug('status********:' + res.Status.code);
        system.assertEquals('Contract codes(s) reserved successfully for the domain', res.Status.message);
        system.assertEquals('200', res.Status.code);
        system.assertEquals('4BMQ', res.contractCode);
        
        
        Test.stopTest();
    }
    
    @isTest 
    static void testContCodeReserveFailure() {
        Test.startTest();
        ContCodeReservRequest rr = new ContCodeReservRequest();
        ContCodeReserveResponse res = new ContCodeReserveResponse();
        
        ContCodeReservServiceUtility servUtility = new ContCodeReservServiceUtility();
        rr.baseContract = '';
      
        Test.setMock(HttpCalloutMock.class, new ContCodeReserveResponsefailureMockTest());
        
        res = servUtility.reserveContractCode(rr);
        
        ContCodeReservServiceUtility.ContCodeAPITokenDetails tokendetails = new ContCodeReservServiceUtility.ContCodeAPITokenDetails();
        tokendetails = servUtility.getAuthToken();
       
        system.debug('status********:' + res.Status.code);
        //system.assertEquals('Invalid Input Parameter -  baseContract cannot be empty for processing the request', res.Status.message);
        system.assertEquals('400', res.Status.code);
        system.assertEquals('salesforce-large-gro', tokendetails.application_name);
        system.assertEquals('1557336486513', tokendetails.issued_at);
        system.assertEquals('899', tokendetails.expires_in);
        system.assertEquals('dv2JGaEOEl6p40WTKd17', tokendetails.client_id);
        system.assertEquals('approved', tokendetails.status);
        system.assertEquals(true, tokendetails.isNewToken); 
        system.assertEquals(null, tokendetails.currentTime); 
        Test.stopTest();
    } 
    
 /*   @isTest static void testContCodeRelease() {
        Test.startTest();
        ContCodeReleaseRequest rres = new ContCodeReleaseRequest();
        rres.callingSystem ='PMT';
        String[] conCodes = new String[]{'00GF'};
            rres.contractCodes = conCodes;
        rres.txnId='12345678';
          Test.setMock(HttpCalloutMock.class, new ContCodeReleaseResponseMockTest());
        ContCodeReservService.releaseContractCode(rres);
        
        Test.stopTest();
    } */
    
    static testMethod void testConCodeReservParse() {
        /*String json = '{"domain": {"lineOfBusiness": ["MED","PHARM" ],"businessEntity": "ABCBS","marketSegment": "LG","businessUnit": "LOCAL" }, "effectiveDate": "2019-04-22","expiryDate": "2019-12-31","comment": "RELEASE TESTING","contractCodeCount": 1,"callingSystem": "PMT","txnId": "1234567","txnTimestamp": ""}';*/
        String json = '{"callingSystem":"SFDCCOM2", "baseContract": "47KB", "planModifiedInd": "Y", "actwiseIndicator": "Member", "engageIndicators":"K2,9", "hpcc": "HM26", "fundingTypeCode": "ASO", "stateCode": "OH", "quoteLineItem": "NA", "effectiveDate": "2019-04-01", "groupSize": "100 - 249", "baseContractType": "Custom", "CEPIndicator": "N","performanceGuarantee": "Y", "caseID":"4701", "wgsgroupID": "15", "transactionId": "7aa6821b-aadd-41e8-8b34-83a3d8b5961e201906200513", "transactionTimestamp": "2018-05-16T08:05:15.222Z", "poolingStatus": "Y"}';
        ContCodeReservRequest.parse(json);
    }
    
  /*  static testMethod void testConCodeReleaseParse() {
        String json = '{"contractCodes": ["00EU"],"callingSystem": "PMT","txnId": "2345678","txnTimestamp": ""}';
        ContCodeReleaseRequest.parse(json);
    } */
    
     /*This method will create test data*/
    static QuoteLineItem createData()
    {
       Account acc=IntegrationTestDataUtilty.createAccount(true); 
       System.debug('Test Account ID :'+acc.id);
       
        Opportunity oppty=IntegrationTestDataUtilty.createOpportunity(acc.id, true);
        
        Group__c grp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        
        Quote qte=IntegrationTestDataUtilty.createQuote(oppty.Id, grp.id, true);
        
        Product2 prod=IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Database.update(prod);
        
        PricebookEntry pbe=IntegrationTestDataUtilty.createPricebookEntry(prod.id, true);
        QuoteLineItem qlitest = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, true);
       
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.vlocity_ins__ContractCode__c = '40QA';
        System.debug(qli);         
        return qli;
        
    }
    
    @isTest
    static void testbuildRequest(){
        
        Order od = createImplCaseTestData();
        insert od;
        QuoteLineItem qli = [Select Id, Contract_Codes__c, vlocity_ins__ContractCode__c, Actwise_Member_Provider_Pay_Indicator__c, Anthem_Engage_Indicators__c, HPCC_Code__c, Product2.HPCC_code__c, Product_Type__c,
                                             Funding__c, Situs_State_Abbrev__c, Quote.Account.Situs_State__c, EffectiveDate__c, Quote.GroupNumber__r.Effective_Date__c, Quote.GroupSize__c, Plan_Type__c, Product2.Plan_Type__c,  
                                             CEP_Indicator__c, Group_Number__c, Quote.Non_Pooled__c, OpportunityEffectiveDate__c, Quote.GroupNumber__r.Performance_Indicator__c, P2AModified__c,  Quote.Account_Name__c,
                                             Quote.GroupNumber__r.Date_Migrated_to_WGS__c, HCR_Status__c
                                             FROM QuoteLineItem 
                                             WHERE quoteId =: od.QuoteId];
        
        ContCodeReservServiceUtility serviceUtility = new ContCodeReservServiceUtility();
        ContCodeReservRequest req = serviceUtility.buildRequest(qli.Id, od);
    }
    
    static Order createImplCaseTestData()
    {
       Account acc=IntegrationTestDataUtilty.createAccount(true); 
      
        Opportunity oppty=IntegrationTestDataUtilty.createOpportunity(acc.id, true);
        
        Group__c grp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        
        Quote qte=IntegrationTestDataUtilty.createQuote(oppty.Id, grp.id, true);
        
        Order ImplCaseTestCoverage =   IntegrationTestDataUtilty.createImplCase(Qte.Id, Acc.Id, true); 
        
        Product2 prod=IntegrationTestDataUtilty.createProduct(false);
        prod.Category__c = 'Plan';
        prod.Product_Type__c = 'Medical';
        prod.Contract_Code__c = '40QA';
        Database.insert(prod);
        
        PricebookEntry pbe=IntegrationTestDataUtilty.createPricebookEntry(prod.id, true);
        
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.ProductStage__c = 'Sold';
        qli.vlocity_ins__ContractCode__c = '40QA';
        Database.insert(qli);
        
        Order ImplCase =   IntegrationTestDataUtilty.createImplCase(Qte.Id, Acc.Id, false); 
         
        return ImplCase;
    }
    @isTest
    static void testReservContCodeforImplCase(){
        
        Order Implcase = createImplCaseTestData();
        Database.insert(Implcase);
        
        Product2 prod=IntegrationTestDataUtilty.createProduct(false);
        prod.Category__c = 'Plan';
        prod.Product_Type__c = 'Medical';
        prod.Contract_Code__c = '40QA';
        Database.insert(prod);
        
        PricebookEntry pbe=IntegrationTestDataUtilty.createPricebookEntry(prod.id, true);
        
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(ImplCase.QuoteId, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.ProductStage__c = 'Sold';
        Database.insert(qli);
        
        LG_Riders__c rider = new LG_Riders__c(Name = 'Test Rider 001');
        Database.insert(rider);
        System.debug('Rider : '+ rider);
        
        String recTypeId = Schema.getGlobalDescribe().get('ProductSelectionDetail__c').getDescribe().getRecordTypeInfosByName().get('LG_Rider_Plan_Assoc').getRecordTypeId(); 
        ProductSelectionDetail__c prodSelectDetail = new ProductSelectionDetail__c(QuoteLineItem__c = qli.Id, Rider__c = rider.Id, RecordTypeId = recTypeId);
        Database.insert(prodSelectDetail);
        System.debug('Prod Select : '+ prodSelectDetail); 
       Contract_Reservation_Service_Call_Log__c servclog = new Contract_Reservation_Service_Call_Log__c();
       servclog.Implementation_Case_Id__c = Implcase.Id;
       servclog.Quote_Line_Item_Id__c = qli.Id;
       servclog.Status_Code__c = 'SUCCESS';
       Database.insert(servclog);
        
        Test.setMock(HttpCalloutMock.class, new ContCodeReserveResponseMockTest());
        
        Test.startTest();  
        ContCodeReservService.contractCodeReserveServiceCallout(Implcase.Id);  
        Test.stopTest();
        
        List<Contract_Reservation_Service_Call_Log__c> servicelogs = [Select Id, Status_Code__c, Quote_Line_Item_ID__c, Implementation_Case_Id__c from Contract_Reservation_Service_Call_Log__c];
        System.assertEquals(2, servicelogs.size());
        
    }
    @isTest
    static void testFailureReservContCodeforImplCase(){
        
        Order Implcase = createImplCaseTestData();
        Database.insert(Implcase);
       
        Test.setMock(HttpCalloutMock.class, new ContCodeReserveResponsefailureMockTest());
        
        Test.startTest();  
        ContCodeReservService.contractCodeReserveServiceCallout(Implcase.Id);  
        Test.stopTest();
        
        List<Contract_Reservation_Service_Call_Log__c> servicelogs = [Select Id, Status_Code__c, Quote_Line_Item_ID__c, Implementation_Case_Id__c from Contract_Reservation_Service_Call_Log__c];
        System.assertEquals(1, servicelogs.size());
        
    }
    
    
    @isTest
    static void testcontractCodeReserveServiceCalloutImpl(){
        
        Order Implcase = createImplCaseTestData();
        Database.insert(Implcase);
        
        List<QuoteLineItem> qlis = [Select Id, Contract_Codes__c, vlocity_ins__ContractCode__c, Actwise_Member_Provider_Pay_Indicator__c, Anthem_Engage_Indicators__c, HPCC_Code__c, Product2.HPCC_code__c, Product_Type__c,
                                             Funding__c, Situs_State_Abbrev__c, Quote.Account.Situs_State__c, EffectiveDate__c, Quote.GroupNumber__r.Effective_Date__c, Quote.GroupSize__c, Plan_Type__c, Product2.Plan_Type__c,  
                                             CEP_Indicator__c, Group_Number__c, Quote.Non_Pooled__c, OpportunityEffectiveDate__c, Quote.GroupNumber__r.Performance_Indicator__c, P2AModified__c,  Quote.Account_Name__c,
                                             Quote.GroupNumber__r.Date_Migrated_to_WGS__c, HCR_Status__c
                                             FROM QuoteLineItem 
                                             WHERE quoteId =: Implcase.QuoteId];
        
        LG_Riders__c rider = new LG_Riders__c(Name = 'Test Rider 001');
        Database.insert(rider);
        System.debug('Rider : '+ rider);
        
        String recTypeId = Schema.getGlobalDescribe().get('ProductSelectionDetail__c').getDescribe().getRecordTypeInfosByName().get('LG_Rider_Plan_Assoc').getRecordTypeId(); 
        ProductSelectionDetail__c prodSelectDetail = new ProductSelectionDetail__c(QuoteLineItem__c = qlis[0].Id, Rider__c = rider.Id, RecordTypeId = recTypeId);
        Database.insert(prodSelectDetail);
        System.debug('Prod Select : '+ prodSelectDetail); 
  
        Test.setMock(HttpCalloutMock.class, new ContCodeReserveResponseMockTest());
        
        Test.startTest();  
        ContCodeReservService.contractCodeReserveServiceCalloutImpl(Implcase.Id);  
        Test.stopTest();
        
        List<Contract_Reservation_Service_Call_Log__c> servicelogs = [Select Id from Contract_Reservation_Service_Call_Log__c];
        System.assertEquals(1, servicelogs.size());
        
        Order ImplCaseUpdated = [Select Id, CC_Service_Invoked__c from Order where Id=: ImplCase.Id];
        System.assertEquals(true, ImplCaseUpdated.CC_Service_Invoked__c);
        
    }
    @isTest
    static void testFailurecontractCodeReserveServiceCalloutImpl(){
        
        Order Implcase = createImplCaseTestData();
        Database.insert(Implcase);
        
        Product2 prod=IntegrationTestDataUtilty.createProduct(false);
        prod.Category__c = 'Plan';
        prod.Product_Type__c = 'Medical';
        prod.Contract_Code__c = '40QA';
        Database.insert(prod);
        
        PricebookEntry pbe=IntegrationTestDataUtilty.createPricebookEntry(prod.id, true);
        
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(ImplCase.QuoteId, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.ProductStage__c = 'Sold';
        Database.insert(qli);
        
       Contract_Reservation_Service_Call_Log__c servclog = new Contract_Reservation_Service_Call_Log__c();
       servclog.Implementation_Case_Id__c = Implcase.Id;
       servclog.Quote_Line_Item_Id__c = qli.Id;
       servclog.Status_Code__c = 'SUCCESS';
       Database.insert(servclog);
  
        Test.setMock(HttpCalloutMock.class, new ContCodeReserveResponsefailureMockTest());
        
        Test.startTest();  
        ContCodeReservService.contractCodeReserveServiceCalloutImpl(Implcase.Id);  
        Test.stopTest();
        
        List<Contract_Reservation_Service_Call_Log__c> servicelogs = [Select Id from Contract_Reservation_Service_Call_Log__c];
        System.assertEquals(2, servicelogs.size());
        
    }
    
     @isTest
    static void testSendEmail(){
        
        Test.startTest();  
        ContCodeReservService.sendEmail('Test Attachment Body', 1, 0);  
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
       
        System.assertEquals(1, invocations);
        
    }
    
    @isTest
    static void IntegrationUtilCatchTest(){
    
        Opportunity oppty=IntegrationTestDataUtilty.createOpportunity(null, true);
        
        Group__c grp=IntegrationTestDataUtilty.createGroup(null, true);
        
        Quote qte=IntegrationTestDataUtilty.createQuote(null, null, true);
        
        Order ImplCaseTestCoverage =   IntegrationTestDataUtilty.createImplCase(null, null, true); 
        PricebookEntry pbe=IntegrationTestDataUtilty.createPricebookEntry(null, true);
        
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(null, null, true);
        
        Account acc=IntegrationTestDataUtilty.createAccount('Test Account','CO', null, 'Local/Large Group',true);
        Account accFailTest = IntegrationTestDataUtilty.createAccount('Test Account','CO', 'LG Customer', 'Local/Large Group',true);
        
        Product2 prod=IntegrationTestDataUtilty.createProduct('32DQ',true);
        Product2 prodFail=IntegrationTestDataUtilty.createProduct(null,true);
    }
}