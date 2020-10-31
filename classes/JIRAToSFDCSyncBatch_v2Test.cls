/*
 * @author Legato Health Technologies
 * Test Class for Jira to SFDC Integration
 * December 2018
 */
@isTest
public class JIRAToSFDCSyncBatch_v2Test {
 
    @isTest static void NASCOJiraWithNoILAndNoSTTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'NASCO',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49649';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        insert it1;
       
        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT Nasco: '+IT);
        System.assertEquals(Date.newInstance(2019, 01, 24), IT.EBA_Requested_ACD__c);
        System.assertEquals('Open', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018, 12, 11), IT.Receipt_Date__c);
        System.assertEquals('EWM-49649', IT.JIRA_Request_ID__c);
        System.assertEquals('Yerram, Praveen', IT.Benefit_Analyst_Assigned__c);
                
    }
    @isTest static void NASCOJiraWithSingleILANDSingleSTTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'NASCO',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49587';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        it1.Account_Legal_Name__c = acc1.Id;
        insert it1;

        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT Nasco: '+IT);
        System.assertEquals(Date.newInstance(2018, 11, 29), IT.EBA_Requested_ACD__c);
        System.assertEquals('Open', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018, 11, 29), IT.Receipt_Date__c);
        System.assertEquals('EWM-49587', IT.JIRA_Request_ID__c);
        System.assertEquals('Yerram, Praveen', IT.Benefit_Analyst_Assigned__c);
        
        
        
        //Medical Benefits  Validation
         Medical_Benefit__c MB = [Select EPID_s_Assigned__c,Id, JIRA_Request_ID__c, Benefit_Coding_Start_Date__c, EPID_Product_Config_Submission_Date__c, 
                    Benefit_Coding_ACD__c, Benefit_Coding_ECD__c, Auto_Adjudication_ACD__c, EPID_Product_Config_Approval_Date__c, 
                    Benefit_Testing_ACD__c, Auto_Adjudication_Required__c, Blue_Exchange_Production_Date__c, Benefit_Testing_Start_Date__c, 
                    Clean_Paperwork__c, Auto_Adjudication_ECD__c ,HPCC_Association_MBCC_Submission__c,BPD_Sent_For_Approval__c,
                                  BPD_ACD__c,HPCC_Association_MBCC_Completion__c,BPD_Start_Date__c,Sub_Tasks__c,BPD_Completion_ECD__c , Benefit_Analyst_Assigned__c From Medical_Benefit__c LIMIT 1];
       
        System.debug('Medical Benefit NASCO:'+MB);
        System.assertEquals('EWM-49596',MB.JIRA_Request_ID__c);
        System.assertEquals(Date.newInstance(2018, 11,30),MB.Benefit_Coding_Start_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,27),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,11),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('No',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018, 11,30),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018, 11,30),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018, 12,31),MB.BPD_Start_Date__c);
        System.assertEquals('Nov 28_NAT_Test 1 - 33557799 - 12/07/2018 - Pre Work- IMPL-0737',MB.Sub_Tasks__c);
        System.assertEquals(Date.newInstance(2018, 12,30),MB.BPD_Completion_ECD__c);
        System.assertEquals(Date.newInstance(2018, 11,30),MB.Benefit_Coding_ECD__c);
        //System.assertEquals(Date.newInstance(2018, 12,20),MB.Benefit_Coding_ACD__c);
        System.assertEquals('55755', MB.EPID_s_Assigned__c);
        System.assertEquals(Date.newInstance(2018, 11,30), MB.Blue_Exchange_Production_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,12),MB.Benefit_Testing_ACD__c);
        System.assertEquals(Date.newInstance(2018, 12,20),MB.Benefit_Testing_Start_Date__c);
        
    }

    @isTest static void NASCOJiraWithSingleILANDNoSTTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'NASCO',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49650';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        insert it1;

        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT Nasco: '+IT.JIRA_Request_ID__c+':'+IT);
        System.assertEquals(Date.newInstance(2019, 01,17), IT.EBA_Requested_ACD__c);
        System.assertEquals('In Progress', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018, 12, 27), IT.Receipt_Date__c);
        System.assertEquals('EWM-49650', IT.JIRA_Request_ID__c);
        System.assertEquals('Yerram, Praveen', IT.Benefit_Analyst_Assigned__c);
        
        
        
        //Medical Benefits  Validation
         Medical_Benefit__c MB = [Select EPID_s_Assigned__c,Id, JIRA_Request_ID__c, Benefit_Coding_Start_Date__c, EPID_Product_Config_Submission_Date__c, 
                    Benefit_Coding_ACD__c, Benefit_Coding_ECD__c, Auto_Adjudication_ACD__c, EPID_Product_Config_Approval_Date__c, 
                    Benefit_Testing_ACD__c, Auto_Adjudication_Required__c, Blue_Exchange_Production_Date__c, Benefit_Testing_Start_Date__c, 
                    Clean_Paperwork__c, Auto_Adjudication_ECD__c ,HPCC_Association_MBCC_Submission__c,BPD_Sent_For_Approval__c,
                                  BPD_ACD__c,HPCC_Association_MBCC_Completion__c,BPD_Start_Date__c,Sub_Tasks__c,BPD_Completion_ECD__c , Benefit_Analyst_Assigned__c From Medical_Benefit__c LIMIT 1];
       
        System.debug('Medical Benefit NASCO:'+MB.JIRA_Request_ID__c+':'+MB);
        System.assertEquals('EWM-49651',MB.JIRA_Request_ID__c);
        System.assertEquals(null,MB.Sub_Tasks__c);
        System.assertEquals('No',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018,12,19),MB.BPD_Start_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,26),MB.BPD_Completion_ECD__c);
        System.assertEquals(Date.newInstance(2018, 12,20),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018, 12,27),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018, 12,11),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,28),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('11220', MB.EPID_s_Assigned__c);
        
    }

    @isTest static void NASCOJiraWithMultipleILANDNoSTTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'NASCO',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49652';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        insert it1;

        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT Nasco: '+IT.JIRA_Request_ID__c+':'+IT);
        System.assertEquals(Date.newInstance(2018, 12,19), IT.EBA_Requested_ACD__c);
        System.assertEquals('Open', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018, 12, 18), IT.Receipt_Date__c);
        System.assertEquals('EWM-49652', IT.JIRA_Request_ID__c);
        System.assertEquals('Yerram, Praveen', IT.Benefit_Analyst_Assigned__c);
        
        
        
        //Medical Benefits  Validation
         List<Medical_Benefit__c> MBList = [Select EPID_s_Assigned__c,Id, JIRA_Request_ID__c, Benefit_Coding_Start_Date__c, EPID_Product_Config_Submission_Date__c, 
                    Benefit_Coding_ACD__c, Benefit_Coding_ECD__c, Auto_Adjudication_ACD__c, EPID_Product_Config_Approval_Date__c, 
                    Benefit_Testing_ACD__c, Auto_Adjudication_Required__c, Blue_Exchange_Production_Date__c, Benefit_Testing_Start_Date__c, 
                    Clean_Paperwork__c, Auto_Adjudication_ECD__c ,HPCC_Association_MBCC_Submission__c,BPD_Sent_For_Approval__c,
                                  BPD_ACD__c,HPCC_Association_MBCC_Completion__c,BPD_Start_Date__c,Sub_Tasks__c,BPD_Completion_ECD__c , Benefit_Analyst_Assigned__c From Medical_Benefit__c ];
       
        System.debug('Medical Benefit NASCO MBList:'+MBList);
        for(Medical_Benefit__c MB : MBList)
        {
            if(MB.JIRA_Request_ID__c == 'EWM-49653')
            {
                System.assertEquals('EWM-49653',MB.JIRA_Request_ID__c);
        		System.assertEquals('Yes',MB.Clean_Paperwork__c);
        		System.assertEquals(Date.newInstance(2018,12,11),MB.BPD_Start_Date__c);
        		System.assertEquals(Date.newInstance(2018, 12,04),MB.BPD_Completion_ECD__c);
        		System.assertEquals(Date.newInstance(2018, 12,12),MB.BPD_ACD__c);
        		System.assertEquals(Date.newInstance(2018, 12,19),MB.BPD_Sent_For_Approval__c);
        		System.assertEquals(Date.newInstance(2018, 12,03),MB.EPID_Product_Config_Submission_Date__c);
        		System.assertEquals(Date.newInstance(2018, 12,17),MB.EPID_Product_Config_Approval_Date__c);
        		System.assertEquals('1223', MB.EPID_s_Assigned__c);
            }
            else if(MB.JIRA_Request_ID__c == 'EWM-49654')
            {
             	System.assertEquals('EWM-49654',MB.JIRA_Request_ID__c);
        		System.assertEquals('Yes',MB.Clean_Paperwork__c);
        		System.assertEquals(Date.newInstance(2018,12,12),MB.BPD_Start_Date__c);
        		System.assertEquals(Date.newInstance(2018, 12,11),MB.BPD_Completion_ECD__c);
        		System.assertEquals(Date.newInstance(2018, 12,13),MB.BPD_ACD__c);
        		System.assertEquals(Date.newInstance(2018, 12,17),MB.BPD_Sent_For_Approval__c);
        		System.assertEquals(Date.newInstance(2018, 12,10),MB.EPID_Product_Config_Submission_Date__c);
        		System.assertEquals(Date.newInstance(2018, 12,20),MB.EPID_Product_Config_Approval_Date__c);
        		System.assertEquals('12345', MB.EPID_s_Assigned__c);   
            }
        }
        
        
    }
@isTest static void NASCOJiraWithMultipleILANDMultipleSTTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'NASCO',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49655';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        insert it1;

        Medical_Benefit__c MedBen = new Medical_Benefit__c();
        MedBen.Implementation_Tracking_ID__c = it1.Id;
        MedBen.JIRA_Request_ID__c = 'EWM-49656';
        insert MedBen;
        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT Nasco: '+IT.JIRA_Request_ID__c+':'+IT);
       	System.assertEquals(Date.newInstance(2018, 12, 13), IT.EBA_Requested_ACD__c);
        System.assertEquals('Open', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018, 12, 10), IT.Receipt_Date__c);
        System.assertEquals('EWM-49655', IT.JIRA_Request_ID__c);
        System.assertEquals('Yerram, Praveen', IT.Benefit_Analyst_Assigned__c);
        System.assertEquals(null,IT.Claims_Stop_Detail__c);
        
        
        
        //Medical Benefits  Validation
         List<Medical_Benefit__c> MBList = [Select EPID_s_Assigned__c,Id, JIRA_Request_ID__c, Benefit_Coding_Start_Date__c, EPID_Product_Config_Submission_Date__c, 
                    Benefit_Coding_ACD__c, Benefit_Coding_ECD__c, Auto_Adjudication_ACD__c, EPID_Product_Config_Approval_Date__c, 
                    Benefit_Testing_ACD__c, Auto_Adjudication_Required__c, Blue_Exchange_Production_Date__c, Benefit_Testing_Start_Date__c, 
                    Clean_Paperwork__c, Auto_Adjudication_ECD__c ,HPCC_Association_MBCC_Submission__c,BPD_Sent_For_Approval__c,
                                  BPD_ACD__c,HPCC_Association_MBCC_Completion__c,BPD_Start_Date__c,Sub_Tasks__c,BPD_Completion_ECD__c , Benefit_Analyst_Assigned__c From Medical_Benefit__c];
       for(Medical_Benefit__c MB : MBList)
       {
           if(MB.JIRA_Request_ID__c == 'EWM-49656')
           {
        System.debug('Medical Benefit NASCO:'+MB.JIRA_Request_ID__c+':'+MB);
        System.assertEquals('EWM-49656',MB.JIRA_Request_ID__c);
        System.assertEquals(Date.newInstance(2018, 12,10),MB.Benefit_Coding_Start_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,18),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,18),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('Yes',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018, 12,10),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018,12,05),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018, 12,11),MB.BPD_Start_Date__c);
        System.assertEquals('002 Issue Links and Multiple Sub Tasks',MB.Sub_Tasks__c);
        System.assertEquals(Date.newInstance(2018, 12,10),MB.BPD_Completion_ECD__c);
        System.assertEquals(Date.newInstance(2018, 12,11),MB.Benefit_Coding_ECD__c);
        //System.assertEquals(Date.newInstance(2018, 12,19),MB.Benefit_Coding_ACD__c);
        System.assertEquals('123456', MB.EPID_s_Assigned__c);
        System.assertEquals(Date.newInstance(2018,12,11), MB.Blue_Exchange_Production_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,12),MB.Benefit_Testing_ACD__c);
        System.assertEquals(Date.newInstance(2018, 12,05),MB.Benefit_Testing_Start_Date__c); 
           }
           else if(MB.JIRA_Request_ID__c == 'EWM-49657')
           {
        System.debug('Medical Benefit NASCO:'+MB.JIRA_Request_ID__c+':'+MB);
        System.assertEquals('EWM-49657',MB.JIRA_Request_ID__c);
        System.assertEquals(Date.newInstance(2018,12,10),MB.Benefit_Coding_Start_Date__c);
        System.assertEquals(Date.newInstance(2019,01,03),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,12),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('Yes',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018, 12,28),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018, 12,26),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018, 12,25),MB.BPD_Start_Date__c);
        System.assertEquals(null,MB.Sub_Tasks__c);
        System.assertEquals(Date.newInstance(2018, 12,24),MB.BPD_Completion_ECD__c);
        System.assertEquals(Date.newInstance(2018, 12,11),MB.Benefit_Coding_ECD__c);
        System.assertEquals(null,MB.Benefit_Coding_ACD__c);
        System.assertEquals(null, MB.EPID_s_Assigned__c);
        System.assertEquals(Date.newInstance(2018, 12,11), MB.Blue_Exchange_Production_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,12),MB.Benefit_Testing_ACD__c);
        System.assertEquals(Date.newInstance(2018, 12,05),MB.Benefit_Testing_Start_Date__c);
           }
       }
        
    }
    
    @isTest static void WGSJiraWithNoILAndNoSTTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49675';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        insert it1;

        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT : '+IT.JIRA_Request_ID__c+':'+IT);
        System.assertEquals(Date.newInstance(2018,12,06), IT.EBA_Requested_ACD__c);
        System.assertEquals('Open', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018,12,05), IT.EBA_Request_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,11), IT.Receipt_Date__c);
        System.assertEquals(70.00,IT.Benefit_Coding_Precert_Completed__c);
        System.assertEquals('EWM-49675', IT.JIRA_Request_ID__c);
        System.assertEquals('Yerram, Praveen', IT.Benefit_Analyst_Assigned__c);
        
       
    }
    
     @isTest static void WGSJiraWithSingleILAndSingleSTTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49588';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        insert it1;

        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT : '+IT);
        //System.assertEquals(null,IT.Claims_Stop_Detail__c); Removed from mapping
        System.assertEquals(Date.newInstance(2018, 11, 30), IT.EBA_Requested_ACD__c);
        System.assertEquals('Open', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018, 11,30), IT.EBA_Request_ECD__c);
        System.assertEquals(Date.newInstance(2018, 11, 29), IT.Receipt_Date__c);
        System.assertEquals(60.00,IT.Benefit_Coding_Precert_Completed__c);
        System.assertEquals('EWM-49588', IT.JIRA_Request_ID__c);
        System.assertEquals('Yerram, Praveen', IT.Benefit_Analyst_Assigned__c);
        
        
        
        //Medical Benefits  Validation
         Medical_Benefit__c MB = [Select EPID_s_Assigned__c,Id, JIRA_Request_ID__c, Benefit_Coding_Start_Date__c, EPID_Product_Config_Submission_Date__c, 
                    Benefit_Coding_ACD__c, Benefit_Coding_ECD__c, Auto_Adjudication_ACD__c, EPID_Product_Config_Approval_Date__c, 
                    Benefit_Testing_ACD__c, Auto_Adjudication_Required__c, Blue_Exchange_Production_Date__c, Benefit_Testing_Start_Date__c, 
                    Clean_Paperwork__c, Auto_Adjudication_ECD__c ,HPCC_Association_MBCC_Submission__c,BPD_Sent_For_Approval__c,
                                  BPD_ACD__c,HPCC_Association_MBCC_Completion__c,BPD_Start_Date__c,Sub_Tasks__c,BPD_Completion_ECD__c , Benefit_Analyst_Assigned__c From Medical_Benefit__c LIMIT 1];
       
        System.debug('Medical Benefit :'+MB);
        System.assertEquals('EWM-49590',MB.JIRA_Request_ID__c);
        System.assertEquals(Date.newInstance(2018, 11,01),MB.Benefit_Coding_Start_Date__c);
        System.assertEquals(Date.newInstance(2018, 12,17),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018, 11,28),MB.Auto_Adjudication_ACD__c);
        System.assertEquals(Date.newInstance(2018, 11,28),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('Yes',MB.Auto_Adjudication_Required__c);
        System.assertEquals('Yes',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018, 11,30),MB.Auto_Adjudication_ECD__c);
        System.assertEquals(Date.newInstance(2018, 11,01), MB.HPCC_Association_MBCC_Submission__c);
        System.assertEquals(Date.newInstance(2018, 12,02),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018, 12,01),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018, 11,02),MB.HPCC_Association_MBCC_Completion__c);
        System.assertEquals(Date.newInstance(2018, 12,01),MB.BPD_Start_Date__c);
        System.assertEquals('pkg001',MB.Sub_Tasks__c);
        System.assertEquals(Date.newInstance(2018, 11,30),MB.BPD_Completion_ECD__c);
        System.assertEquals(Date.newInstance(2018, 11,16),MB.Benefit_Coding_ECD__c);
        //System.assertEquals(Date.newInstance(2018, 11,25),MB.Benefit_Coding_ACD__c);
        System.assertEquals('23456', MB.EPID_s_Assigned__c);
        
    }
    
    @isTest static void WGSJiraWithSingleILAndNoSTTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49677';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        insert it1;

        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT : '+IT.JIRA_Request_ID__c+':'+IT);
        System.assertEquals(Date.newInstance(2018,12,06), IT.EBA_Requested_ACD__c);
        System.assertEquals('Open', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018,12,06), IT.EBA_Request_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,06), IT.Receipt_Date__c);
        System.assertEquals(40.00,IT.Benefit_Coding_Precert_Completed__c);
        System.assertEquals('EWM-49677', IT.JIRA_Request_ID__c);
        System.assertEquals(null, IT.Benefit_Analyst_Assigned__c);
        
    }
    
 
   @isTest static void WGSJiraWithMultipleILAndSingleSTTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49679';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        insert it1;
        

        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT : '+IT.JIRA_Request_ID__c+':'+IT);
        System.assertEquals(null,IT.Claims_Stop_Detail__c);
        System.assertEquals(Date.newInstance(2018,12,13), IT.EBA_Requested_ACD__c);
        System.assertEquals('Open', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018,12,12), IT.EBA_Request_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,20), IT.Receipt_Date__c);
        System.assertEquals(90.00,IT.Benefit_Coding_Precert_Completed__c);
        System.assertEquals('EWM-49679', IT.JIRA_Request_ID__c);        
        
        
        //Medical Benefits  Validation
         List<Medical_Benefit__c> MBList = [Select EPID_s_Assigned__c,Id, JIRA_Request_ID__c, Benefit_Coding_Start_Date__c, EPID_Product_Config_Submission_Date__c, 
                    Benefit_Coding_ACD__c, Benefit_Coding_ECD__c, Auto_Adjudication_ACD__c, EPID_Product_Config_Approval_Date__c, 
                    Benefit_Testing_ACD__c, Auto_Adjudication_Required__c, Blue_Exchange_Production_Date__c, Benefit_Testing_Start_Date__c, 
                    Clean_Paperwork__c, Auto_Adjudication_ECD__c ,HPCC_Association_MBCC_Submission__c,BPD_Sent_For_Approval__c,
                                  BPD_ACD__c,HPCC_Association_MBCC_Completion__c,BPD_Start_Date__c,Sub_Tasks__c,BPD_Completion_ECD__c , Benefit_Analyst_Assigned__c From Medical_Benefit__c];
       for(Medical_Benefit__c MB : MBList)
       {
           if(MB.JIRA_Request_ID__c == 'EWM-49680')
           {
        		System.debug('Medical Benefit :'+MB);
        System.assertEquals('EWM-49680',MB.JIRA_Request_ID__c);
        System.assertEquals(Date.newInstance(2018,11,01),MB.Benefit_Coding_Start_Date__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018,12,21),MB.Auto_Adjudication_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,14),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('Yes',MB.Auto_Adjudication_Required__c);
        System.assertEquals('Yes',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018,12,20),MB.Auto_Adjudication_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,19), MB.HPCC_Association_MBCC_Submission__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.HPCC_Association_MBCC_Completion__c);
        System.assertEquals(Date.newInstance(2018,12,11),MB.BPD_Start_Date__c);
        System.assertEquals('23322',MB.Sub_Tasks__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.BPD_Completion_ECD__c);
        System.assertEquals(Date.newInstance(2018,11,16),MB.Benefit_Coding_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.Benefit_Coding_ACD__c);
        System.assertEquals('22232', MB.EPID_s_Assigned__c);       
          }
           else if(MB.JIRA_Request_ID__c == 'EWM-49683')
           {
               System.debug('Medical Benefit :'+MB);
        System.assertEquals('EWM-49683',MB.JIRA_Request_ID__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018,12,11),MB.Auto_Adjudication_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,14),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('Yes',MB.Auto_Adjudication_Required__c);
        System.assertEquals('Yes',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.Auto_Adjudication_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,12), MB.HPCC_Association_MBCC_Submission__c);
        System.assertEquals(Date.newInstance(2018,12,11),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018,12,07),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.HPCC_Association_MBCC_Completion__c);
        System.assertEquals(Date.newInstance(2018,12,11),MB.BPD_Start_Date__c);
        System.assertEquals('23322',MB.Sub_Tasks__c);
        System.assertEquals(Date.newInstance(2018,12,14),MB.BPD_Completion_ECD__c);
        System.assertEquals('222', MB.EPID_s_Assigned__c);
           }
        
       }
    }
   
   @isTest static void WGSJiraWithMultipleILAndMultipleSTTest()
    {
        RecordType rcType = [select id , name from recordtype where sobjecttype ='Account' and Name ='LG Customer' LIMIT 1];
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'South East',
                                Anthem_Entity__c = 'Local/Large Group',
                                MBU_Codes__c = 'NAH00000 GA',
                                RecordTypeId = rcType.Id,
                                BillingStreet = '24',
                                BillingCity = 'Callen',
                                BillingState = 'California',
                                BillingPostalCode = '10043',
                    			BillingCountry = 'USA',
                    			ShippingStreet = '26',
                    			ShippingCity = 'Ballar',
                    			ShippingState = 'Georgea',
                    			ShippingPostalCode = '10065',
                    			ShippingCountry = 'USA',
                    			Physical_County__c = 'NEW YORK',
                    			Mailing_Address_Same_as_Physical_Address__c = true,
                                Situs_State__c = 'Indiana');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49684';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        it1.Account_Legal_Name__c = acc1.Id;
        insert it1;

        Medical_Benefit__c MedBen = new Medical_Benefit__c();
        MedBen.Implementation_Tracking_ID__c = it1.Id;
        MedBen.JIRA_Request_ID__c = 'EWM-49685';
        insert MedBen;
        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c,Account_Legal_Name__r.Anthem_Entity__c, Account_Legal_Name__r.Situs_State__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT : '+IT);
        System.assertEquals(null,IT.Claims_Stop_Detail__c);
        System.assertEquals(Date.newInstance(2018,12,19), IT.EBA_Requested_ACD__c);
        System.assertEquals('Open', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018,12,19), IT.EBA_Request_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,11), IT.Receipt_Date__c);
        System.assertEquals(70.00,IT.Benefit_Coding_Precert_Completed__c);
        System.assertEquals('EWM-49684', IT.JIRA_Request_ID__c);
        System.assertEquals('Yerram, Praveen', IT.Benefit_Analyst_Assigned__c);
        
        
        //Medical Benefits  Validation
         List<Medical_Benefit__c> MBList = [Select EPID_s_Assigned__c,Id, JIRA_Request_ID__c, Benefit_Coding_Start_Date__c, EPID_Product_Config_Submission_Date__c, 
                    Benefit_Coding_ACD__c, Benefit_Coding_ECD__c, Auto_Adjudication_ACD__c, EPID_Product_Config_Approval_Date__c, 
                    Benefit_Testing_ACD__c, Auto_Adjudication_Required__c, Blue_Exchange_Production_Date__c, Benefit_Testing_Start_Date__c, 
                    Clean_Paperwork__c, Auto_Adjudication_ECD__c ,HPCC_Association_MBCC_Submission__c,BPD_Sent_For_Approval__c,
                                  BPD_ACD__c,HPCC_Association_MBCC_Completion__c,BPD_Start_Date__c,Sub_Tasks__c,BPD_Completion_ECD__c , Benefit_Analyst_Assigned__c From Medical_Benefit__c];
       for(Medical_Benefit__c MB : MBList)
       {
           if(MB.JIRA_Request_ID__c == 'EWM-49685')
           {
        System.debug('Medical Benefit :'+MB);
        System.assertEquals('EWM-49685',MB.JIRA_Request_ID__c);
        System.assertEquals(Date.newInstance(2018,12,14),MB.Benefit_Coding_Start_Date__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018,12,20),MB.Auto_Adjudication_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('Yes',MB.Auto_Adjudication_Required__c);
        System.assertEquals('Yes',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.Auto_Adjudication_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,14), MB.HPCC_Association_MBCC_Submission__c);
        System.assertEquals(Date.newInstance(2018,12,14),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,12),MB.HPCC_Association_MBCC_Completion__c);
        System.assertEquals(Date.newInstance(2018,12,20),MB.BPD_Start_Date__c);
        System.assertEquals('23322',MB.Sub_Tasks__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.BPD_Completion_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,11),MB.Benefit_Coding_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,19),MB.Benefit_Coding_ACD__c);
        System.assertEquals('4333', MB.EPID_s_Assigned__c);
           } 
           else if(MB.JIRA_Request_ID__c == 'EWM-49686')
           {
               System.debug('Medical Benefit :'+MB);
        System.assertEquals('EWM-49686',MB.JIRA_Request_ID__c);
        System.assertEquals(Date.newInstance(2018,12,14),MB.Benefit_Coding_Start_Date__c);
        System.assertEquals(Date.newInstance(2018,12,06),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018,12,14),MB.Auto_Adjudication_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('Yes',MB.Auto_Adjudication_Required__c);
        System.assertEquals('Yes',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018,12,14),MB.Auto_Adjudication_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,13), MB.HPCC_Association_MBCC_Submission__c);
        System.assertEquals(Date.newInstance(2018,12,11),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018,12,11),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.HPCC_Association_MBCC_Completion__c);
        System.assertEquals(Date.newInstance(2018,12,12),MB.BPD_Start_Date__c);
        System.assertEquals('23322',MB.Sub_Tasks__c);
        System.assertEquals(Date.newInstance(2018,12,11),MB.BPD_Completion_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,13),MB.Benefit_Coding_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,14),MB.Benefit_Coding_ACD__c);
        System.assertEquals('2233', MB.EPID_s_Assigned__c);
           }
       }
        
        
    }

    @isTest static void NationalWGSCalloutLimitTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-49668';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        insert it1;

       
        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2();       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
        //Implementation Tracking Validation
        Implementation_Tracking__c IT = [SELECT Id , EBA_Requested_ACD__c ,Claims_Stop_Detail__c, Status_At_EBA_Request_Level__c ,EBA_Request_ECD__c, Receipt_Date__c, JIRA_Request_ID__c , Benefit_Analyst_Assigned__c ,Benefit_Coding_Precert_Completed__c from Implementation_Tracking__c LIMIT 1];
        
        System.debug('IT : '+IT);
        System.assertEquals(null,IT.Claims_Stop_Detail__c);
        System.assertEquals(Date.newInstance(2018,12,28), IT.EBA_Requested_ACD__c);
        System.assertEquals('Open', IT.Status_At_EBA_Request_Level__c);
        System.assertEquals(Date.newInstance(2018,12,19), IT.EBA_Request_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,04), IT.Receipt_Date__c);
        System.assertEquals(75.00,IT.Benefit_Coding_Precert_Completed__c);
        System.assertEquals('EWM-49668', IT.JIRA_Request_ID__c);
        System.assertEquals('Yerram, Praveen', IT.Benefit_Analyst_Assigned__c);
        
        
        //Medical Benefits  Validation
         List<Medical_Benefit__c> MBList = [Select EPID_s_Assigned__c,Id, JIRA_Request_ID__c, Benefit_Coding_Start_Date__c, EPID_Product_Config_Submission_Date__c, 
                    Benefit_Coding_ACD__c, Benefit_Coding_ECD__c, Auto_Adjudication_ACD__c, EPID_Product_Config_Approval_Date__c, 
                    Benefit_Testing_ACD__c, Auto_Adjudication_Required__c, Blue_Exchange_Production_Date__c, Benefit_Testing_Start_Date__c, 
                    Clean_Paperwork__c, Auto_Adjudication_ECD__c ,HPCC_Association_MBCC_Submission__c,BPD_Sent_For_Approval__c,
                                  BPD_ACD__c,HPCC_Association_MBCC_Completion__c,BPD_Start_Date__c,Sub_Tasks__c,BPD_Completion_ECD__c , Benefit_Analyst_Assigned__c From Medical_Benefit__c];
       for(Medical_Benefit__c MB : MBList)
       {
           if(MB.JIRA_Request_ID__c == 'EWM-49715')
           {
        System.debug('Medical Benefit :'+MB);
        System.assertEquals('EWM-49715',MB.JIRA_Request_ID__c);
        System.assertEquals(null,MB.Benefit_Coding_Start_Date__c);
        System.assertEquals(Date.newInstance(2018,12,19),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018,12,19),MB.Auto_Adjudication_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,20),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('No',MB.Auto_Adjudication_Required__c);
        System.assertEquals('Yes',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018,12,12),MB.Auto_Adjudication_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,20), MB.HPCC_Association_MBCC_Submission__c);
        System.assertEquals(Date.newInstance(2018,12,25),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018,12,20),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,26),MB.HPCC_Association_MBCC_Completion__c);
        System.assertEquals(Date.newInstance(2018,12,19),MB.BPD_Start_Date__c);
        System.assertEquals('1234',MB.Sub_Tasks__c);
        System.assertEquals(Date.newInstance(2018,12,19),MB.BPD_Completion_ECD__c);
        System.assertEquals(null,MB.Benefit_Coding_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,24),MB.Benefit_Coding_ACD__c);
        System.assertEquals('000012', MB.EPID_s_Assigned__c);
           } 
           else if(MB.JIRA_Request_ID__c == 'EWM-49716')
           {
               System.debug('Medical Benefit :'+MB);
       	System.assertEquals('EWM-49716',MB.JIRA_Request_ID__c);
        System.assertEquals(Date.newInstance(2018,12,18),MB.Benefit_Coding_Start_Date__c);
        System.assertEquals(Date.newInstance(2018,12,18),MB.EPID_Product_Config_Submission_Date__c);
        System.assertEquals(Date.newInstance(2018,12,20),MB.Auto_Adjudication_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,19),MB.EPID_Product_Config_Approval_Date__c);
        System.assertEquals('Yes',MB.Auto_Adjudication_Required__c);
        System.assertEquals('Yes',MB.Clean_Paperwork__c);
        System.assertEquals(Date.newInstance(2018,12,19),MB.Auto_Adjudication_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,25), MB.HPCC_Association_MBCC_Submission__c);
        System.assertEquals(Date.newInstance(2018,12,21),MB.BPD_Sent_For_Approval__c);
        System.assertEquals(Date.newInstance(2018,12,20),MB.BPD_ACD__c);
        System.assertEquals(Date.newInstance(2018,12,17),MB.HPCC_Association_MBCC_Completion__c);
        System.assertEquals(Date.newInstance(2018,12,19),MB.BPD_Start_Date__c);
        System.assertEquals('000234',MB.Sub_Tasks__c);
        System.assertEquals(Date.newInstance(2018,12,20),MB.BPD_Completion_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,20),MB.Benefit_Coding_ECD__c);
        System.assertEquals(Date.newInstance(2018,12,21),MB.Benefit_Coding_ACD__c);
        System.assertEquals(null, MB.EPID_s_Assigned__c);
           }
       }
        
        
    }

@isTest static void ExceptionTest()
    {
         Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = Date.newInstance(system.today().year(),1,1),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it1 = new Implementation_Tracking__c();
        it1.JIRA_Request_ID__c = 'EWM-60000';
        it1.Overall_Status__c = 'On Hold';
        it1.Implementation_Record_ID__c=o1.id;
        insert it1;

        Medical_Benefit__c MedBen = new Medical_Benefit__c();
        MedBen.Implementation_Tracking_ID__c = it1.Id;
        MedBen.JIRA_Request_ID__c = 'EWM-60001';
        insert MedBen;
        
        Test.setMock(HttpCalloutMock.class, new JIRAToSFDCSyncBatchMockTest());
        
         
        Test.startTest();
         
        JIRAToSFDCSyncBatch_v2 batch = new JIRAToSFDCSyncBatch_v2(it1.Id);       
        Database.executeBatch(batch,1);
        Test.stopTest();
        
    }
    
}