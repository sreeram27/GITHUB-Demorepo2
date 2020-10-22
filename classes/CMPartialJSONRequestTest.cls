@isTest
private class CMPartialJSONRequestTest {
    
    @testSetup
    static void createData()
    {
        Account acc=IntegrationTestDataUtilty.createAccount(true);  
        Opportunity oppty=IntegrationTestDataUtilty.createOpportunity(acc.id, true);
        Group__c grp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        Quote Qte = IntegrationTestDataUtilty.createQuote(oppty.Id, grp.id, true);
        Order ImplCase = IntegrationTestDataUtilty.createImplCase(qte.Id, acc.Id, false);
        ImplCase.Implementation_Effective_Date__c = system.today();
        ImplCase.Implementation_Status__c = 'Initiated';
        ImplCase.Implementation_Type__c = 'New Business';
        ImplCase.User_Group__c = 'Local New Business';
        ImplCase.Production_Date__c = system.today();
        ImplCase.OpportunityId = oppty.Id ;                   
        //ImplCase.LHOL_Q__c = 'true',
        insert ImplCase;   
        System.debug('Impl Case Opp Id:'+ ImplCase.OpportunityId);
        
        Product2 prod = IntegrationTestDataUtilty.createProduct('40QA', true);
        prod.Name = 'Health and Wellness - Live Health Online';
        prod.vlocity_ins__Type__c = 'Medical';
        prod.Product_Type__c = 'Medical';
        Database.update(prod);
        
        vlocity_ins__AttributeAssignment__c  spiderAttrb = IntegrationTestDataUtilty.createAttributeAssgnmnt(prod.Id,'Spider Network Id', 'Spider Test', true);
		vlocity_ins__AttributeAssignment__c  metalLevelAttrb = IntegrationTestDataUtilty.createAttributeAssgnmnt(prod.Id,'Metal Level Code', 'Metal Level Test', true);
        vlocity_ins__AttributeAssignment__c  exchangeIndAttrb = IntegrationTestDataUtilty.createAttributeAssgnmnt(prod.Id,'Exchange Indicator', 'Exchange Ind Test', true);
        vlocity_ins__AttributeAssignment__c  legalEntityAttrb = IntegrationTestDataUtilty.createAttributeAssgnmnt(prod.Id,'Legal Entity', 'Legal value Test', true);
        vlocity_ins__AttributeAssignment__c  cdhpAttrb = IntegrationTestDataUtilty.createAttributeAssgnmnt(prod.Id,'CDHP Product Type', 'CDHP Test', true);

           
        PricebookEntry pbe= IntegrationTestDataUtilty.createpricebookEntry(prod.Id, true);
        QuoteLineItem qlitest = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, true);
       
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.QuoteId = qte.id;
        Database.insert(qli);
        
        QuoteLineItemRates__c rate1= IntegrationTestDataUtilty.createQLIRates(qli.Id, '123567', true);
        QuoteLineItemRates__c rate2= IntegrationTestDataUtilty.createQLIRates(qli.Id, '462829', true);
        
        Group_Plan_Design__c grpPlanDesign1 = IntegrationTestDataUtilty.createGrpPlanDesign(grp.Id, qli.Id, 'Active', true);
        Group_Plan_Design__c grpPlanDesign2 = IntegrationTestDataUtilty.createGrpPlanDesign(grp.Id, qli.Id, 'Active', true);   
        
        Account brokerAccount = IntegrationTestDataUtilty.createAccount('Test BrokerAccount', 'Virginia', 'LG Brokerage', 'Local/Large Group', false);
        brokerAccount.Tax_ID__c ='123456789';
        Database.insert(brokerAccount);
        
        Contact con = IntegrationTestDataUtilty.createContact(brokerAccount.Id, 'General Contact', 'Consultant', true);
        System.debug('Broker Account Id: '+brokerAccount.Id);
        System.debug('Broker Contact Id: '+con.Id);
        ContactRelationShip__c conRel = IntegrationTestDataUtilty.createConRelationship(brokerAccount.Id, con.Id, 'LG Brokerage Consultant Relationship', 'Billing Contact',true);
        System.debug('Broker Contact RelationId: '+conRel.Id);
        System.debug('Account Id: '+acc.Id);
        Brokerage_and_Consultant1__c brokerConsultant1 = IntegrationTestDataUtilty.createBrokerConsultant1(acc.Id, oppty.Id, brokerAccount.Id, conRel.Id, 'Medical', false);
        brokerConsultant1.Brokerage_of_Record__c = true;
        Database.insert(brokerConsultant1);
        
        Broker_Consultant_Commissions1__c brokerConsCommission = IntegrationTestDataUtilty.createBrokerConsCommission1(brokerConsultant1.Id, conRel.Id, acc.Id, 'Medical', true);
    
        Sales_Compensation__c salesComp = IntegrationTestDataUtilty.createSalesCompensation(oppty.Id, 'Medical', true);
        System.debug('Sales Comp Id: '+salesComp.Id);
        Internal_Broker__c agent = IntegrationTestDataUtilty.createAgent(salesComp.Id, 'SR - Account Coordinator (SAR)', 'Medical','12345', true);
        System.debug('Agent Id: '+ agent.Id); 
        
        Contact contct = IntegrationTestDataUtilty.createContact(acc.Id, 'General Contact', 'Test Billing', true);
        System.debug('Contact Id: '+contct.Id);
        
       	ServiceProviderRelationship__c srvProv = IntegrationTestDataUtilty.createSrvcPrvdrRltnshp(acc.Id, contct.id, 'TPA', true);
        
        Account_Preferences__c grpPref = IntegrationTestDataUtilty.createGrpPreferences(acc.Id, true);
        
        Eligibility__c eligibility = IntegrationTestDataUtilty.createEligibility(ImplCase.Id, grp.Id, true);
      
        AccountTeamMember teamMem = new AccountTeamMember(AccountId = acc.Id, TeamMemberRole ='Account Manager', UserId= UserInfo.getUserId());
        insert teamMem;
        Invoices_Local__c invoice = IntegrationTestDataUtilty.createInvoice(acc.Id, contct.Id, grp.Id, true);
        invoice.CBP_Bill_Group_ID__c ='12345';
        update invoice;
        Billing_Arrangement_Local__c billArrgmnt1 = IntegrationTestDataUtilty.createBillingArrangement(invoice.Id, 'Medical', true);
        Billing_Arrangement_Local__c billArrgmnt2 = IntegrationTestDataUtilty.createBillingArrangement(invoice.Id, 'Medical', true);
    }
    
    @isTest
    static void buildProductsCustInfo(){  
        List<Account> acc = [Select Id from Account LIMIT 1];
        List<Order> implCase = [Select Id from Order 
                                WHERE AccountId =: acc[0].Id
                                LIMIT 1];
       
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CMIntegrationCalloutMockTest());
        
        CMIntegrationUtility utility = new CMIntegrationUtility();  
        String  output = CMIntegrationService.submitCaseToCM(CMIntegrationService.prepareOrder(implCase[0].id), 'AddUpdate');
         
        //CMIntegrationRequest req = CMIntegrationService.buildCMPayload(CMIntegrationService.prepareOrder(implCase[0].id), CMIntegrationService.buildEventMetaData('Preview'));
        //CMIntegrationRequest req = CMIntegrationGroupLoad.buildCMPayload(CMIntegrationService.prepareOrder(implCase[0].id), CMIntegrationService.buildEventMetaData('Preview'));
       // CMIntegrationUtility.StatusDetails returnStatus = utility.sendCMReqInfo(req);
      //  CMIntegrationUtility.CMIntgrtnAPITokenDetails tokenDetails = utility.getAuthToken();
  
        Test.stopTest(); 
        System.assertEquals('SUCCESS', output, 'Response status codes not matched');
   
      /* System.assertEquals(1, prodList.size() , 'Return Product List Size is not matched');
         System.assertEquals(1, reps.size() , 'Return Reps List Size is not matched'); */
    }
    
    @isTest
    static void testUtilityMethod(){
        List<Account> acc = [Select Id from Account LIMIT 1];
        List<Order> implCase = [Select Id from Order 
                                WHERE AccountId =: acc[0].Id
                                LIMIT 1];
       
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CMIntegrationCalloutMockTest());
        
        CMIntegrationUtility utility = new CMIntegrationUtility();
        CMIntegrationRequest req = CMIntegrationGroupLoad.buildCMPayload(CMIntegrationService.prepareOrder(implCase[0].id), CMIntegrationService.buildEventMetaData('Preview'));
        CMIntegrationUtility.StatusDetails returnStatus = utility.sendCMReqInfo(req);
        CMIntegrationUtility.CMIntgrtnAPITokenDetails tokenDetails = utility.getAuthToken();
  
        Test.stopTest(); 
        System.assertEquals(200, returnStatus.statusCode, 'Response status codes not matched');
        System.assertEquals('salesforce-large-gro', tokendetails.application_name);
        System.assertEquals('1557336486513', tokendetails.issued_at);
        System.assertEquals('899', tokendetails.expires_in);
        system.assertEquals('dv2JGaEOEl6p40WTKd17', tokendetails.client_id);
        system.assertEquals('approved', tokendetails.status);
        system.assertEquals(true, tokendetails.isNewToken); 
        system.assertEquals(null, tokendetails.currentTime); 
    }
    
}