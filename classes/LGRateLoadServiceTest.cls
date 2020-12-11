@isTest(SeeAllData=false)
public class LGRateLoadServiceTest {
    
    @testSetup static void setup() {
        Id LGCustrecTypeId=[SELECT DeveloperName, Id, SobjectType, IsActive FROM RecordType where SobjectType='Account' and DeveloperName='LG_Customer'].Id;
        Account testAccount =new Account();
        
        testAccount.recordtypeid=LGCustrecTypeId;
        testAccount.Name = 'Test Account';
        testAccount.Anthem_Entity__c = 'Local/Large Group';
        testAccount.Region__c = 'West';
        testAccount.BillingStreet = '24';
        testAccount.BillingCity = 'Callen';
        testAccount.BillingState = 'Colorado';
        testAccount.BillingPostalCode = '10043';
        testAccount.BillingCountry = 'USA';
        testAccount.ShippingStreet = '26';
        testAccount.ShippingCity = 'Ballar';
        testAccount.ShippingState = 'Colorado';
        testAccount.ShippingPostalCode = '10065';
        testAccount.ShippingCountry = 'USA';
        testAccount.Physical_County__c = 'NEW YORK';
        testAccount.Mailing_Address_Same_as_Physical_Address__c = true;
        testAccount.Industry = '';
        testAccount.Description = 'Test Account'; 
        testAccount.Account_Status__c = 'Active';
        testAccount.HQ_State__c = 'CO';
        testAccount.Renewal_Month__c = 'January';
        testAccount.Branding__c = 'Anthem BCBS';
        testAccount.MBU_Codes__c = 'CO-PBCOZZ-Public CO';
        testAccount.WGS_Contracting_Situs_State__c = 'CO';
        testAccount.NASCO_Contracting_Situs_State__c = 'CO';
        testAccount.Group_Size__c = '10001 - 20000';
        testAccount.Situs_State__c = 'Colorado';
        testAccount.Total_Employees__c = 10571;
        testAccount.Eligible_Employees__c = 2200;
        insert testAccount;
        
        
        Group__c testGroup=new Group__c();
        testGroup.name='test group';
        testGroup.Account__c=testAccount.id;
        insert testGroup;
        
        Opportunity opp1 = new Opportunity(Name = '2020 In Group Rate Test',
                                           AccountId = testAccount.id,
                                           StageName = 'Initiated',
                                           closedate = Date.newInstance(2020, 01, 01),
                                           WARP_Membership_Update_Date__c = System.today(),
                                           Stage_Reason__c = 'Brand',
                                           RFP_Status__c = 'Active Renewal',
                                           WasOpptyFinalized__c = true,
                                           Received_Date__c = System.today()
                                          );
        
        insert opp1;
        
        Product2 prod = new Product2(Name = 'Product- See Notes',
                                     vlocity_ins__SubType__c='Other',
                                     IsActive = true,LOB__c='Medical',
                                     productActive__c = true);
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Anthem Blue Access PPO HRAs Option E4-M',
                                      vlocity_ins__SubType__c='Other',
                                      IsActive = true,LOB__c='Medical',
                                      vlocity_ins__ProductSpecId__c=prod.Id,
                                      Contract_code__c='3MU2',
                                      vlocity_ins__EffectiveDate__c = Date.today(),
                                      productActive__c = true);
        insert prod1;
        
        Product2 prod2 = new Product2(Name = 'PPO Product',
                                      vlocity_ins__SubType__c='Other',
                                      IsActive = true,
                                      LOB__c='Medical',
                                      vlocity_ins__ProductSpecId__c=prod.Id,
                                      Contract_code__c='3MU3',
                                      vlocity_ins__EffectiveDate__c = Date.today(),
                                      productActive__c = true);
        insert prod2;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                          Product2Id = prod.Id,
                                                          UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                           Product2Id = prod1.Id,
                                                           UnitPrice = 20000, IsActive = true);
        insert  standardPrice1;
        PricebookEntry standardPrice2 = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                           Product2Id = prod2.Id,
                                                           UnitPrice = 20000, IsActive = true);
        insert  standardPrice2;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        Quote testQuote = new Quote(Name = '2019 Opportunity for Rate update',
                                    Pricebook2Id = pricebookId,
                                    OpportunityId = opp1.Id,GroupNumber__c=testGroup.id);
        insert testQuote;
    }
    
    //Creates rate record sucessfully for given oppty and contract code
    @isTest static void testUpdateQLIRate() {
        
        Quote quote = [select Id from Quote LIMIT 1];
        Product2 prod = [select Id from Product2 where Name = 'Anthem Blue Access PPO HRAs Option E4-M'];
        PriceBookEntry pbe = [select id from PriceBookEntry where Product2.Id =:prod.Id];
        
        Product2 prod1 = [select Id from Product2 where Name = 'PPO Product'];
        PriceBookEntry pbe1 = [select id from PriceBookEntry where Product2.Id =:prod1.Id];
        QuoteLineItem parentQLI = new QuoteLineItem(Subscribers__c = 9, 
                                                    Reason__c='Funding Type Change',
                                                    Probability__c='15%',
                                                    ProductStage__c='In Progress',
                                                    Members__c = 10,
                                                    QuoteId = quote.Id,
                                                    Product2Id = prod.Id,
                                                    PricebookEntryId = pbe.Id,
                                                    Quantity = 10,
                                                    Unitprice = 10.00);
        
        insert parentQLI;
        QuoteLineItem childQLI = new QuoteLineItem(Subscribers__c = 9, 
                                                   Reason__c='Funding Type Change',
                                                   Probability__c='15%',
                                                   ProductStage__c='In Progress',
                                                   Members__c = 10,
                                                   QuoteId = quote.Id,
                                                   Product2Id = prod1.Id,
                                                   PricebookEntryId = pbe1.Id,
                                                   Quantity = 10,
                                                   ParentQuoteLineItem__c = parentQLI.id,
                                                   Unitprice = 10.00,vlocity_ins__ContractCode__c='3MU3');
        
        insert childQLI;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Id opptyId = [select id from Opportunity Limit 1].Id;
        
        
        String reqBody=			'{'+
            '  "groupName": "Rosetta CO",'+
            '  "requestedBy": "SFDC_User_Name",'+
            '  "effectiveDate": "2019-01-01",'+
            '  "environment": "DEV",'+
            '  "sfOpportunityId": \"'+opptyId+'\",'+
            '  "sourceSystem": "ABACUS",'+
            '  "customerMasterKey": "E&B Customer Master Id",'+
            '  "caseNumber": "123456",'+
            '  "sourceRecordId": "SourceRecordIdentifier",'+
            '  "sfOpportunityType": "New Business",'+
            '  "rateInfo": ['+
            '    {'+
            '      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
            '      "rateIdentifier": "RATE_ID_1",'+
            '      "contractCode": "3MU3",'+
            '      "classCode": "Hourly",'+
            '      "employmentCategoryCode": "ACTSB",'+
            '      "productCategory": "MEDICAL",'+
            '      "productName": "Blue Advantage HMO",'+
            '      "commissionLevel": "10",'+
            '      "commissionType": "PSPM",'+
            '      "single": 703.2,'+
            '      "twoParty": 1547.04,'+
            '      "eeChild": 1265.76,'+
            '      "family": 2179.92,'+
            '      "eeChildren": 1265.76,'+
            '      "medicareElgSpouseL65": 703.2,'+
            '      "medicareElgSpouseChildL65": 1476.72,'+
            '      "embeddedVision": 1.6'+
            '    }'+
            '  ]'+
            '}';	
        
        
        req.requestURI = '/services/apexrest/LGRateLoadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        //System.debug('request body-------:' +req.requestBody);
        
        LGRateLoadService.doPost();
        LGRateLoadService.StatusDetails resBody = (LGRateLoadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGRateLoadService.StatusDetails.class);
        
        System.assertEquals(resBody.statusCode, 200);
        System.assertEquals(resBody.statusMessage,'Request processed successfully');
        //update Rate for existing QLI
        LGRateLoadService.doPost();
        LGRateLoadService.StatusDetails updateResBody = (LGRateLoadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGRateLoadService.StatusDetails.class);
        
        System.assertEquals(updateResBody.statusCode, 200);
        System.assertEquals(updateResBody.statusMessage,'Request processed successfully');
        Test.stopTest();
        
    }
    
    //Creates rate record sucessfully for given oppty and contract code
    @isTest static void testFoundTwoQLIsWithContractCode() {
        
        Quote quote = [select Id from Quote LIMIT 1];
        Product2 prod = [select Id from Product2 where Name = 'Anthem Blue Access PPO HRAs Option E4-M'];
        PriceBookEntry pbe = [select id from PriceBookEntry where Product2.Id =:prod.Id];
        
        Product2 prod1 = [select Id from Product2 where Name = 'PPO Product'];
        PriceBookEntry pbe1 = [select id from PriceBookEntry where Product2.Id =:prod1.Id];
        QuoteLineItem parentQLI = new QuoteLineItem(Subscribers__c = 9, 
                                                    Reason__c='Funding Type Change',
                                                    Probability__c='15%',
                                                    ProductStage__c='In Progress',
                                                    Members__c = 10,
                                                    QuoteId = quote.Id,
                                                    Product2Id = prod.Id,
                                                    PricebookEntryId = pbe.Id,
                                                    Quantity = 10,
                                                    Unitprice = 10.00);
        
        insert parentQLI;
        QuoteLineItem childQLI = new QuoteLineItem(Subscribers__c = 9, 
                                                   Reason__c='Funding Type Change',
                                                   Probability__c='15%',
                                                   ProductStage__c='In Progress',
                                                   Members__c = 10,
                                                   QuoteId = quote.Id,
                                                   Product2Id = prod1.Id,
                                                   PricebookEntryId = pbe1.Id,
                                                   Quantity = 10,
                                                   ParentQuoteLineItem__c = parentQLI.id,
                                                   Unitprice = 10.00,vlocity_ins__ContractCode__c='3MU3');
        
        insert childQLI;
        
        QuoteLineItem childQLI1 = new QuoteLineItem(Subscribers__c = 9, 
                                                    Reason__c='Funding Type Change',
                                                    Probability__c='15%',
                                                    ProductStage__c='In Progress',
                                                    Members__c = 10,
                                                    QuoteId = quote.Id,
                                                    Product2Id = prod1.Id,
                                                    PricebookEntryId = pbe1.Id,
                                                    Quantity = 10,
                                                    ParentQuoteLineItem__c = parentQLI.id,
                                                    Unitprice = 10.00,vlocity_ins__ContractCode__c='3MU3');
        
        insert childQLI1;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Id opptyId = [select id from Opportunity Limit 1].Id;
        
        
        String reqBody=			'{'+
            '  "groupName": "Rosetta CO",'+
            '  "requestedBy": "SFDC_User_Name",'+
            '  "effectiveDate": "2019-01-01",'+
            '  "environment": "DEV",'+
            '  "sfOpportunityId": \"'+opptyId+'\",'+
            '  "sourceSystem": "ABACUS",'+
            '  "customerMasterKey": "E&B Customer Master Id",'+
            '  "caseNumber": "123456",'+
            '  "sourceRecordId": "SourceRecordIdentifier",'+
            '  "sfOpportunityType": "New Business",'+
            '  "rateInfo": ['+
            '    {'+
            '      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
            '      "rateIdentifier": "RATE_ID_1",'+
            '      "contractCode": "3MU3",'+
            '      "classCode": "Hourly",'+
            '      "employmentCategoryCode": "ACTSB",'+
            '      "productCategory": "MEDICAL",'+
            '      "productName": "Blue Advantage HMO",'+
            '      "commissionLevel": "10",'+
            '      "commissionType": "PSPM",'+
            '      "single": 703.2,'+
            '      "twoParty": 1547.04,'+
            '      "eeChild": 1265.76,'+
            '      "family": 2179.92,'+
            '      "eeChildren": 1265.76,'+
            '      "medicareElgSpouseL65": 703.2,'+
            '      "medicareElgSpouseChildL65": 1476.72,'+
            '      "embeddedVision": 1.6'+
            '    }'+
            '  ]'+
            '}';	
        
        
        req.requestURI = '/services/apexrest/LGRateLoadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        //System.debug('request body-------:' +req.requestBody);
        
        LGRateLoadService.doPost();
        LGRateLoadService.StatusDetails resBody = (LGRateLoadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGRateLoadService.StatusDetails.class);
        
        System.assertEquals(resBody.statusCode, 400);
        System.assertEquals(resBody.statusMessage,'Found more than one Qli for contract code:3MU3');
        
        Test.stopTest();
        
    }
    
    //No Opportunity id found in the request
    @isTest static void testCreateRateRecordWithoutOppty() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        String reqBody=		'{'+
            '  "groupName": "Rosetta CO",'+
            '  "requestedBy": "SFDC_User_Name",'+
            '  "effectiveDate": "2019-01-01",'+
            '  "sourceSystem": "ABACUS",'+
            '  "environment": "DEV",'+
            '  "sourceRecordId": "SourceRecordIdentifier",'+
            '  "customerMasterKey": "E&B Customer Master Id",'+
            '  "caseNumber": "123456",'+
            '  "mbu": "TestMBU01",'+
            '  "customerType": "Prospect/Customer",'+
            '  "rateInfo": ['+
            '    {'+
            '      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
            '      "rateIdentifier": "RATE_ID",'+
            '      "contractCode": "3MU3",'+
            '      "employmentCategoryCode": "ACTSB",'+
            '      "productCategory": "HMO",'+
            '      "productName": "Blue Advantage HMO",'+
            '      "commission": "10",'+
            '      "networkName": "Full",'+
            '      "networkId": "CO_FULL",'+
            '      "subgroupName": "",'+
            '      "subgroupNumber": "",'+
            '      "productType": "Blue Advantage HMO",'+
            '      "planName": "BA-BC14",'+
            '      "riderDescription": "",'+
            '      "single": "200",'+
            '      "twoParty": "200",'+
            '      "eeChild": "200",'+
            '      "family": "200",'+
            '      "eeChildren": "200",'+
            '      "medicareElgSpouseL65": "200",'+
            '      "medicareElgSpouseChildL65": "200",'+
            '      "inn": {'+
            '        "deductibleSingleRFamily": "200.1",'+
            '        "coinsurance": "200.1",'+
            '        "outOfPocketLimitSingleRFamily": "200.1",'+
            '        "officeVisitsPCPRSpecialistCopay": "200.1",'+
            '        "inpatientHospitalCopay": "200.1",'+
            '        "erUrgentCareCopay": "200.1",'+
            '        "prescriptionDrugRetail": "200.1",'+
            '        "prescriptionDrugMailOrder": "200.1"'+
            '      }'+
            '    }'+
            '  ]'+
            '}';
        req.requestURI = '/services/apexrest/LGRateLoadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        LGRateLoadService.doPost();
        LGRateLoadService.StatusDetails updateResBody = (LGRateLoadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGRateLoadService.StatusDetails.class);
        
        System.assertEquals(updateResBody.statusCode, 400);
        System.assertEquals(updateResBody.statusMessage,'No Opportunity id found in the request');
        Test.stopTest();
        
    }
    //Without Rate info in the req
    @isTest static void testWithOutRateNodeInRequestBody() {
        Quote quote = [select Id from Quote LIMIT 1];
        Product2 prod = [select Id from Product2 where Name = 'Anthem Blue Access PPO HRAs Option E4-M'];
        PriceBookEntry pbe = [select id from PriceBookEntry where Product2.Id =:prod.Id];
        
        Product2 prod1 = [select Id from Product2 where Name = 'PPO Product'];
        PriceBookEntry pbe1 = [select id from PriceBookEntry where Product2.Id =:prod1.Id];
        QuoteLineItem parentQLI = new QuoteLineItem(Subscribers__c = 9, 
                                                    Reason__c='Funding Type Change',
                                                    Probability__c='15%',
                                                    ProductStage__c='In Progress',
                                                    Members__c = 10,
                                                    QuoteId = quote.Id,
                                                    Product2Id = prod.Id,
                                                    PricebookEntryId = pbe.Id,
                                                    Quantity = 10,
                                                    Unitprice = 10.00);
        
        insert parentQLI;
        QuoteLineItem childQLI = new QuoteLineItem(Subscribers__c = 9, 
                                                   Reason__c='Funding Type Change',
                                                   Probability__c='15%',
                                                   ProductStage__c='In Progress',
                                                   Members__c = 10,
                                                   QuoteId = quote.Id,
                                                   Product2Id = prod1.Id,
                                                   PricebookEntryId = pbe1.Id,
                                                   Quantity = 10,
                                                   ParentQuoteLineItem__c = parentQLI.id,
                                                   Unitprice = 10.00,vlocity_ins__ContractCode__c='3MU3');
        
        insert childQLI;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Id opptyId = [select id from Opportunity Limit 1].Id;
        
        String reqBody=		'{'+
            '  "groupName": "Rosetta CO",'+
            '  "requestedBy": "SFDC_User_Name",'+
            '  "effectiveDate": "2019-01-01",'+
            '  "sourceSystem": "ABACUS",'+
            '  "environment": "DEV",'+
            '  "sfOpportunityId": \"'+opptyId+'\",'+
            '  "sourceRecordId": "SourceRecordIdentifier",'+
            '  "customerMasterKey": "E&B Customer Master Id",'+
            '  "caseNumber": "123456",'+
            '  "mbu": "TestMBU01",'+
            '  "customerType": "Prospect/Customer",'+
            '  "rateInfo": ['+
            '  ]'+
            '}';
        
        
        req.requestURI = '/services/apexrest/LGRateLoadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        //System.debug('request body-------:' +req.requestBody);
        
        LGRateLoadService.doPost();
        LGRateLoadService.StatusDetails resBody = (LGRateLoadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGRateLoadService.StatusDetails.class);
        System.assertEquals(resBody.statusMessage,'No RateInfo found in the request');
        Test.stopTest();
        
        
    }
    
    
    @isTest static void testCreateRateRecordWithNullOpptyId() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        String reqBody=		'{'+
            '  "groupName": "Rosetta CO",'+
            '  "requestedBy": "SFDC_User_Name",'+
            '  "effectiveDate": "2019-01-01",'+
            '  "sourceSystem": "ABACUS",'+
            '  "environment": "DEV",'+
            '  "sfOpportunityId":"null",'+
            '  "sourceRecordId": "SourceRecordIdentifier",'+
            '  "customerMasterKey": "E&B Customer Master Id",'+
            '  "caseNumber": "123456",'+
            '  "mbu": "TestMBU01",'+
            '  "customerType": "Prospect/Customer",'+
            '  "rateInfo": ['+
            '    {'+
            '      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
            '      "rateIdentifier": "RATE_ID",'+
            '      "contractCode": "3MU3",'+
            '      "employmentCategoryCode": "ACTSB",'+
            '      "productCategory": "HMO",'+
            '      "productName": "Blue Advantage HMO",'+
            '      "commission": "10",'+
            '      "networkName": "Full",'+
            '      "networkId": "CO_FULL",'+
            '      "subgroupName": "",'+
            '      "subgroupNumber": "",'+
            '      "productType": "Blue Advantage HMO",'+
            '      "planName": "BA-BC14",'+
            '      "riderDescription": "",'+
            '      "single": "200",'+
            '      "twoParty": "200",'+
            '      "eeChild": "200",'+
            '      "family": "200",'+
            '      "eeChildren": "200",'+
            '      "medicareElgSpouseL65": "200",'+
            '      "medicareElgSpouseChildL65": "200",'+
            '      "inn": {'+
            '        "deductibleSingleRFamily": "200.1",'+
            '        "coinsurance": "200.1",'+
            '        "outOfPocketLimitSingleRFamily": "200.1",'+
            '        "officeVisitsPCPRSpecialistCopay": "200.1",'+
            '        "inpatientHospitalCopay": "200.1",'+
            '        "erUrgentCareCopay": "200.1",'+
            '        "prescriptionDrugRetail": "200.1",'+
            '        "prescriptionDrugMailOrder": "200.1"'+
            '      }'+
            '    }'+
            '  ]'+
            '}';
        
        req.requestURI = '/services/apexrest/LGRateLoadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        LGRateLoadService.doPost();
        LGRateLoadService.StatusDetails updateResBody = (LGRateLoadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGRateLoadService.StatusDetails.class);
        
        System.assertEquals(updateResBody.statusCode, 400);
        System.assertEquals(updateResBody.statusMessage,'No Opportunity record found with oppty id:null');
        Test.stopTest();
        
    }
    @isTest static void testCreateRateRecordWithoutContCode() {
        Quote quote = [select Id from Quote LIMIT 1];
        Product2 prod = [select Id from Product2 where Name = 'Anthem Blue Access PPO HRAs Option E4-M'];
        PriceBookEntry pbe = [select id from PriceBookEntry where Product2.Id =:prod.Id];
        
        Product2 prod1 = [select Id from Product2 where Name = 'PPO Product'];
        PriceBookEntry pbe1 = [select id from PriceBookEntry where Product2.Id =:prod1.Id];
        QuoteLineItem parentQLI = new QuoteLineItem(Subscribers__c = 9, 
                                                    Reason__c='Funding Type Change',
                                                    Probability__c='15%',
                                                    ProductStage__c='In Progress',
                                                    Members__c = 10,
                                                    QuoteId = quote.Id,
                                                    Product2Id = prod.Id,
                                                    PricebookEntryId = pbe.Id,
                                                    Quantity = 10,
                                                    Unitprice = 10.00);
        
        insert parentQLI;
        QuoteLineItem childQLI = new QuoteLineItem(Subscribers__c = 9, 
                                                   Reason__c='Funding Type Change',
                                                   Probability__c='15%',
                                                   ProductStage__c='In Progress',
                                                   Members__c = 10,
                                                   QuoteId = quote.Id,
                                                   Product2Id = prod1.Id,
                                                   PricebookEntryId = pbe1.Id,
                                                   Quantity = 10,
                                                   ParentQuoteLineItem__c = parentQLI.id,
                                                   Unitprice = 10.00,vlocity_ins__ContractCode__c='3MU3');
        
        insert childQLI;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Id opptyId = [select id from Opportunity Limit 1].Id;
        
        String reqBody=		'{'+
            '  "groupName": "Rosetta CO",'+
            '  "requestedBy": "SFDC_User_Name",'+
            '  "effectiveDate": "2019-01-01",'+
            '  "sourceSystem": "ABACUS",'+
            '  "environment": "DEV",'+
            '  "sfOpportunityId": \"'+opptyId+'\",'+
            '  "sourceRecordId": "SourceRecordIdentifier",'+
            '  "customerMasterKey": "E&B Customer Master Id",'+
            '  "caseNumber": "123456",'+
            '  "mbu": "TestMBU01",'+
            '  "customerType": "Prospect/Customer",'+
            '  "rateInfo": ['+
            '    {'+
            '      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
            '      "rateIdentifier": "RATE_ID",'+
            '      "employmentCategoryCode": "ACTSB",'+
            '      "productCategory": "HMO",'+
            '      "productName": "Blue Advantage HMO",'+
            '      "commission": "10",'+
            '      "networkName": "Full",'+
            '      "networkId": "CO_FULL",'+
            '      "subgroupName": "",'+
            '      "subgroupNumber": "",'+
            '      "productType": "Blue Advantage HMO",'+
            '      "planName": "BA-BC14",'+
            '      "riderDescription": "",'+
            '      "single": "200",'+
            '      "twoParty": "200",'+
            '      "eeChild": "200",'+
            '      "family": "200",'+
            '      "eeChildren": "200",'+
            '      "medicareElgSpouseL65": "200",'+
            '      "medicareElgSpouseChildL65": "200",'+
            '      "inn": {'+
            '        "deductibleSingleRFamily": "200.1",'+
            '        "coinsurance": "200.1",'+
            '        "outOfPocketLimitSingleRFamily": "200.1",'+
            '        "officeVisitsPCPRSpecialistCopay": "200.1",'+
            '        "inpatientHospitalCopay": "200.1",'+
            '        "erUrgentCareCopay": "200.1",'+
            '        "prescriptionDrugRetail": "200.1",'+
            '        "prescriptionDrugMailOrder": "200.1"'+
            '      }'+
            '    }'+
            '  ]'+
            '}';
        
        req.requestURI = '/services/apexrest/LGRateLoadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        LGRateLoadService.doPost();
        LGRateLoadService.StatusDetails updateResBody = (LGRateLoadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGRateLoadService.StatusDetails.class);
        
        System.assertEquals(updateResBody.statusCode, 400);
        System.assertEquals(updateResBody.statusMessage,'No Contract code in the request');
        Test.stopTest();
        
    } 
    
    
    @isTest static void testNoQLIFoundForContCode() {
        Quote quote = [select Id from Quote LIMIT 1];
        Product2 prod = [select Id from Product2 where Name = 'Anthem Blue Access PPO HRAs Option E4-M'];
        PriceBookEntry pbe = [select id from PriceBookEntry where Product2.Id =:prod.Id];
        
        Product2 prod1 = [select Id from Product2 where Name = 'PPO Product'];
        PriceBookEntry pbe1 = [select id from PriceBookEntry where Product2.Id =:prod1.Id];
        QuoteLineItem parentQLI = new QuoteLineItem(Subscribers__c = 9, 
                                                    Reason__c='Funding Type Change',
                                                    Probability__c='15%',
                                                    ProductStage__c='In Progress',
                                                    Members__c = 10,
                                                    QuoteId = quote.Id,
                                                    Product2Id = prod.Id,
                                                    PricebookEntryId = pbe.Id,
                                                    Quantity = 10,
                                                    Unitprice = 10.00);
        
        insert parentQLI;
        QuoteLineItem childQLI = new QuoteLineItem(Subscribers__c = 9, 
                                                   Reason__c='Funding Type Change',
                                                   Probability__c='15%',
                                                   ProductStage__c='In Progress',
                                                   Members__c = 10,
                                                   QuoteId = quote.Id,
                                                   Product2Id = prod1.Id,
                                                   PricebookEntryId = pbe1.Id,
                                                   Quantity = 10,
                                                   ParentQuoteLineItem__c = parentQLI.id,
                                                   Unitprice = 10.00,vlocity_ins__ContractCode__c='3MU3');
        
        insert childQLI;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Id opptyId = [select id from Opportunity Limit 1].Id;
        
        String reqBody=		'{'+
            '  "groupName": "Rosetta CO",'+
            '  "requestedBy": "SFDC_User_Name",'+
            '  "effectiveDate": "2019-01-01",'+
            '  "sourceSystem": "ABACUS",'+
            '  "environment": "DEV",'+
            '  "sfOpportunityId": \"'+opptyId+'\",'+
            '  "sourceRecordId": "SourceRecordIdentifier",'+
            '  "customerMasterKey": "E&B Customer Master Id",'+
            '  "caseNumber": "123456",'+
            '  "mbu": "TestMBU01",'+
            '  "customerType": "Prospect/Customer",'+
            '  "rateInfo": ['+
            '    {'+
            '      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
            '      "contractCode": "3MU0",'+
            '      "employmentCategoryCode": "ACTSB",'+
            '      "productCategory": "HMO",'+
            '      "productName": "Blue Advantage HMO",'+
            '      "commission": "10",'+
            '      "networkName": "Full",'+
            '      "networkId": "CO_FULL",'+
            '      "subgroupName": "",'+
            '      "subgroupNumber": "",'+
            '      "productType": "Blue Advantage HMO",'+
            '      "planName": "BA-BC14",'+
            '      "riderDescription": "",'+
            '      "single": "200",'+
            '      "twoParty": "200",'+
            '      "eeChild": "200",'+
            '      "family": "200",'+
            '      "eeChildren": "200",'+
            '      "medicareElgSpouseL65": "200",'+
            '      "medicareElgSpouseChildL65": "200",'+
            '      "inn": {'+
            '        "deductibleSingleRFamily": "200.1",'+
            '        "coinsurance": "200.1",'+
            '        "outOfPocketLimitSingleRFamily": "200.1",'+
            '        "officeVisitsPCPRSpecialistCopay": "200.1",'+
            '        "inpatientHospitalCopay": "200.1",'+
            '        "erUrgentCareCopay": "200.1",'+
            '        "prescriptionDrugRetail": "200.1",'+
            '        "prescriptionDrugMailOrder": "200.1"'+
            '      }'+
            '    }'+
            '  ]'+
            '}';
        
        req.requestURI = '/services/apexrest/LGRateLoadService';  
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        LGRateLoadService.doPost();
        LGRateLoadService.StatusDetails updateResBody = (LGRateLoadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGRateLoadService.StatusDetails.class);
        
        System.assertEquals(updateResBody.statusCode, 400);
        System.assertEquals(updateResBody.statusMessage,'No Qli record found for contract code:3MU0');
        Test.stopTest();
        
    } 
      static testMethod void testLGRateRequestParse() {
           
     	String json=		'{'+
		'  "groupName": "Rosetta CO",'+
		'  "requestedBy": "SFDC_User_Name",'+
		'  "effectiveDate": "2019-01-01",'+
		'  "environment": "DEV",'+
		'  "sfOpportunityId": "0061K00000d20WsQAI",'+
		'  "sourceSystem": "ABACUS",'+
		'  "customerMasterKey": "E&B Customer Master Id",'+
		'  "caseNumber": "123456",'+
		'  "sourceRecordId": "SourceRecordIdentifier",'+
		'  "sfOpportunityType": "New Business",'+
		'  "fileName": "MEDICAL_FINALRATES.XLSX",'+
		'  "fileVersion": "1", '+
		' "rateInfo": ['+
		'    {'+
		'      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
		'      "rateIdentifier": "RATE_ID_1",'+
		'      "contractCode": "3XYY",'+
		'      "classCode": "Hourly",'+
		'      "employmentCategoryCode": "ACTSB",'+
		'      "productCategory": "MEDICAL",'+
		'      "productName": "Blue Advantage HMO",'+
		'      "commissionLevel": "10",'+
		'      "commissionType": "PSPM",'+
		'      "single": 703.2,'+
		'      "twoParty": 1547.04,'+
		'      "eeChild": 1265.76,'+
		'      "family": 2179.92,'+
		'      "eeChildren": 1265.76,'+
		'      "medicareElgSpouseL65": 703.2,'+
		'      "medicareElgSpouseChildL65": 1476.72,'+
		'      "embeddedVision": 1.6'+
		'    },'+
		'    {'+
		'      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
		'      "rateIdentifier": "RATE_ID_2",'+
		'      "contractCode": "3XYZ",'+
		'      "classCode": "Hourly",'+
		'      "employmentCategoryCode": "ACTSB",'+
		'      "productCategory": "MEDICAL",'+
		'      "productName": "Blue Advantage HMO",'+
		'      "commissionLevel": "10",'+
		'      "commissionType": "PSPM",'+
		'      "single": 703.2,'+
		'      "twoParty": 1547.04,'+
		'      "eeChild": 1265.76,'+
		'      "family": 2179.92,'+
		'      "eeChildren": 1265.76,'+
		'      "medicareElgSpouseL65": 703.2,'+
		'      "medicareElgSpouseChildL65": 1476.72,'+
		'      "embeddedVision": 1.6'+
		'    }'+
		'  ]'+
		'}';
		LGRateRequest rates = LGRateRequest.parse(json);
          String casenumber= rates.caseNumber;
          String requestedBy= rates.requestedBy;
          String groupName= rates.groupName;
          String environment= rates.environment;
          String sourceSystem= rates.sourceSystem;
          String customerMasterKey= rates.customerMasterKey;
          String sourceRecordId= rates.sourceRecordId;
          String sfOpportunityType= rates.sfOpportunityType;
          String effectiveDate= rates.effectiveDate;
          String sfOpportunityId= rates.sfOpportunityId;
          List<LGRateRequest.rateInfo> rateInfo = new List<LGRateRequest.rateInfo>();
          rateInfo = rates.rateInfo;
          
     }
    
    /* @isTest static void testUpdateQLIWithWrongContCode() {
RestRequest req = new RestRequest();
RestResponse res = new RestResponse();
Id opptyId = [select id from Opportunity Limit 1].Id;

String reqBody=		'{'+
'  "groupName": "Rosetta CO",'+
'  "requestedBy": "SFDC_User_Name",'+
'  "effectiveDate": "2019-01-01",'+
'  "sourceSystem": "ABACUS",'+
'  "environment": "DEV",'+
'  "sfOpportunityId": \"'+opptyId+'\",'+
'  "sourceRecordId": "SourceRecordIdentifier",'+
'  "customerMasterKey": "E&B Customer Master Id",'+
'  "caseNumber": "123456",'+
'  "mbu": "TestMBU01",'+
'  "customerType": "Prospect/Customer",'+
'  "rateInfo": ['+
'    {'+
'      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
'      "rateIdentifier": "RATE_ID",'+
'      "contractCode": "1111",'+
'      "employmentCategoryCode": "ACTSB",'+
'      "productCategory": "HMO",'+
'      "productName": "Blue Advantage HMO",'+
'      "commission": "10",'+
'      "networkName": "Full",'+
'      "networkId": "CO_FULL",'+
'      "subgroupName": "",'+
'      "subgroupNumber": "",'+
'      "productType": "Blue Advantage HMO",'+
'      "planName": "BA-BC14",'+
'      "riderDescription": "",'+
'      "single": "200",'+
'      "twoParty": "200",'+
'      "eeChild": "200",'+
'      "family": "200",'+
'      "eeChildren": "200",'+
'      "medicareElgSpouseL65": "200",'+
'      "medicareElgSpouseChildL65": "200",'+
'      "inn": {'+
'        "deductibleSingleRFamily": "200.1",'+
'        "coinsurance": "200.1",'+
'        "outOfPocketLimitSingleRFamily": "200.1",'+
'        "officeVisitsPCPRSpecialistCopay": "200.1",'+
'        "inpatientHospitalCopay": "200.1",'+
'        "erUrgentCareCopay": "200.1",'+
'        "prescriptionDrugRetail": "200.1",'+
'        "prescriptionDrugMailOrder": "200.1"'+
'      }'+
'    }'+
'  ]'+
'}';


req.requestURI = '/services/apexrest/LGRateLoadService';  
req.httpMethod = 'POST';//HTTP Request Type
req.requestBody = Blob.valueof(reqBody);
RestContext.request = req;
RestContext.response= res;
Test.startTest();
LGRateLoadService.doPost();
LGRateLoadService.StatusDetails updateResBody = (LGRateLoadService.StatusDetails)JSON.deserialize(res.responseBody.toString(),LGRateLoadService.StatusDetails.class);

System.assertEquals(updateResBody.statusCode, 400);
System.assertEquals(updateResBody.statusMessage,'No product found with contract code :1111');
Test.stopTest();

} */
    
}