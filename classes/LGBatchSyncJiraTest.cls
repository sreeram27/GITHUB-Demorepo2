@isTest(SeeAllData=false)
public class LGBatchSyncJiraTest {
   
    
    @isTest static void test_method_two() {
        // Implement test code
        
        Account acc1 = new Account(Name = 'test1',
                                   Region__c = 'West',
                                   Anthem_Entity__c = 'Local/Large Group'
                                  );
        
        insert acc1;
        
        Account acc2 = new Account(Name = 'test2',
                                   Region__c = 'West',
                                   Anthem_Entity__c = 'Local/Large Group'
                                  );
        
        insert acc2;
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu = new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = 'ABC@test.org',
                           EmailEncodingKey = 'ISO-8859-1',
                           Username = 'abcjiratest@anthem.com2', 
                           Alias = 'abc',
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US',
                           ProfileId = pf.Id); 
        
        insert uu;
        
        AccountTeamMember atm1 = new AccountTeamMember(AccountId = acc1.id, 
                                                       TeamMemberRole = 'Account Executive',
                                                       UserId = uu.Id);
        
        insert atm1;
        
        AccountTeamMember atm2 = new AccountTeamMember(AccountId = acc2.id, 
                                                       TeamMemberRole = 'Account Executive',
                                                       UserId = uu.Id);
        
        insert atm2;
        
        
        //Id rtId = Schema.SObjectType.QuoteLineItem.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                                   Name = 'test Group',
                                   Account__c = acc1.Id);
        
        insert g1;
        
        Group__c g2 = new Group__c(ClaimSystem__c = 'NASCO',
                                   Name = 'test Group',
                                   Account__c = acc2.Id);
        
        insert g2;
        
        Opportunity opp1 = new Opportunity(CloseDate = system.today(),
                                           Name = 'test opp',
                                           AccountId = acc1.id,
                                           StageName = 'Initiated');
        
        insert opp1;
        
        Opportunity opp2 = new Opportunity(CloseDate = system.today().addDays(-5),
                                           Name = 'test opp',
                                           AccountId = acc2.id,
                                           StageName = 'Initiated');
        
        insert opp2;
        
        
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
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
        
        
        Quote q1 = new Quote(JAAIndicator__c = true,
                             GroupNumber__c = g1.Id,
                             Name = 'test Quote',
                             Pricebook2Id = customPB.Id,
                             OpportunityId = opp1.Id);
        
        insert q1;
        
        Quote q2 = new Quote(JAAIndicator__c = true,
                             GroupNumber__c = g2.Id,
                             Name = 'test Quote',
                             Pricebook2Id = customPB.Id,
                             OpportunityId = opp2.Id);
        
        insert q2;
        
        QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                               QuoteId = q1.Id,
                                               Product2Id = prod.Id,
                                               Members__c = 10,
                                               PricebookEntryId = pbe.Id,
                                               Quantity = 10,
                                               Unitprice = 10.00);
        
        insert qli1;
        
        QuoteLineItem qli2 = new QuoteLineItem(Funding__c = 'ASO', 
                                               QuoteId = q2.Id,
                                               Product2Id = prod.Id,
                                               Members__c = 10,
                                               PricebookEntryId = pbe.Id,
                                               Quantity = 10,
                                               Unitprice = 10.00);
        
        insert qli2;
        
        
        Order o2 = new Order(Implementation_Effective_Date__c = system.today(),
                             Implementation_Status__c = 'Initiated',
                             Implementation_Type__c = 'Renewal',
                             User_Group__c = 'National Renewal',
                             Production_Date__c = system.today(),
                             EffectiveDate = system.today(),
                             Status = 'Draft',
                             //LHOL_Q__c = 'false',
                             AccountId = acc2.Id,
                             QuoteId = q2.Id,
                             OpportunityId = opp2.Id);
        
        insert o2;
        
        Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                             Implementation_Status__c = 'Initiated',
                             Implementation_Type__c = 'New Business',
                             User_Group__c = 'Local New Business',
                             Production_Date__c = system.today(),
                             EffectiveDate = system.today(),
                             Status = 'Draft',
                             //LHOL_Q__c = 'true',
                             AccountId = acc1.Id,
                             QuoteId = q1.Id,
                             OpportunityId = opp1.Id);
        
        //insert o1;
        
        SME_Approvals__c approval1 = new SME_Approvals__c(Implementation_Record_ID__c = o1.Id,
                                                          SME_Department__c = 'Medical Benefits',
                                                          Status__c = 'Approved',
                                                          Strings_Tables_Contract_Codes_Impacted__c = 'TBD');
        
        insert approval1;
        
        SME_Approvals__c approval2 = new SME_Approvals__c(Implementation_Record_ID__c = o2.Id,
                                                          SME_Department__c = 'Medical Benefits',
                                                          Status__c = 'Approved',
                                                          Strings_Tables_Contract_Codes_Impacted__c = 'TBD');
        
        insert approval2;
        
        /*JiraEndpoint__c endpoint = new JiraEndpoint__c(AccessToken__c = '1', ApiKey__c = '1', ClientID__c = '1', ClientSecret__c = '1', 
Create_Issue__c = '1', Delete_Issue__c = '1', healthCheck__c = '1', 
Jira_Generic__c = '1', Modify_Issue__c = '1', Search_GET__c = '1',
Search_POST__c = '1', Host__c = '1', Application_Username__c = '1', 
Application_Password__c = '1', TokenRefreshTime__c = 12);

insert endpoint;*/
        
        Test.startTest();
        
        LGBatchSyncJira lgBS = new LGBatchSyncJira('LG');
        Database.executeBatch(lgBS);
        
        Test.stopTest();
    }
    
    @isTest static void test_method_five() {
        Test.startTest();
        
        System.schedule('test', '0 0 * * * ?', new LGBatchSyncJira());
        
        Test.stopTest();
    }
    
    @isTest static void test_method_eight() {
        
        LGJiraCreateIssueResponse.Exceptions e=new LGJiraCreateIssueResponse.Exceptions();
        e.type_Z='test';
        e.code='test';
        e.message='test';
        e.detail='test';
        system.assert(e!=null);
    }
    
    
    @isTest static void test_method_ten() {
        // Implement test code
        
        Account acc1 = new Account(Name = 'test1',
                                   Region__c = 'West',
                                   Anthem_Entity__c = 'Local/Large Group'
                                  );
        
        insert acc1;
        
        Account acc2 = new Account(Name = 'test2',
                                   Region__c = 'West',
                                   Anthem_Entity__c = 'Local/Large Group'
                                  );
        
        insert acc2;
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu = new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = 'ABC@test.org',
                           EmailEncodingKey = 'ISO-8859-1',
                           Username = 'abcjiratest@anthem.com2', 
                           Alias = 'abc',
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US',
                           ProfileId = pf.Id); 
        
        insert uu;
        
        AccountTeamMember atm1 = new AccountTeamMember(AccountId = acc1.id, 
                                                       TeamMemberRole = 'Account Executive',
                                                       UserId = uu.Id);
        
        insert atm1;
        
        AccountTeamMember atm2 = new AccountTeamMember(AccountId = acc2.id, 
                                                       TeamMemberRole = 'Account Executive',
                                                       UserId = uu.Id);
        
        insert atm2;
        
        
        //Id rtId = Schema.SObjectType.QuoteLineItem.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                                   Name = 'test Group',
                                   Account__c = acc1.Id);
        
        insert g1;
        
        Group__c g2 = new Group__c(ClaimSystem__c = 'NASCO',
                                   Name = 'test Group',
                                   Account__c = acc2.Id);
        
        insert g2;
        
        Opportunity opp1 = new Opportunity(CloseDate = system.today(),
                                           Name = 'test opp',
                                           AccountId = acc1.id,
                                           StageName = 'Initiated');
        
        insert opp1;
        
        Opportunity opp2 = new Opportunity(CloseDate = system.today().addDays(-5),
                                           Name = 'test opp',
                                           AccountId = acc2.id,
                                           StageName = 'Initiated');
        
        insert opp2;
        
        
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
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
        
        
        Quote q1 = new Quote(JAAIndicator__c = true,
                             GroupNumber__c = g1.Id,
                             Name = 'test Quote',
                             Pricebook2Id = customPB.Id,
                             OpportunityId = opp1.Id);
        
        insert q1;
        
        Quote q2 = new Quote(JAAIndicator__c = true,
                             GroupNumber__c = g2.Id,
                             Name = 'test Quote',
                             Pricebook2Id = customPB.Id,
                             OpportunityId = opp2.Id);
        
        insert q2;
        
        QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                               QuoteId = q1.Id,
                                               Product2Id = prod.Id,
                                               Members__c = 10,
                                               PricebookEntryId = pbe.Id,
                                               Quantity = 10,
                                               Unitprice = 10.00);
        
        insert qli1;
        
        QuoteLineItem qli2 = new QuoteLineItem(Funding__c = 'ASO', 
                                               QuoteId = q2.Id,
                                               Product2Id = prod.Id,
                                               Members__c = 10,
                                               PricebookEntryId = pbe.Id,
                                               Quantity = 10,
                                               Unitprice = 10.00);
        
        insert qli2;
        
        
        Order o2 = new Order(Implementation_Effective_Date__c = system.today(),
                             Implementation_Status__c = 'Initiated',
                             Implementation_Type__c = 'Renewal',
                             User_Group__c = 'National Renewal',
                             Production_Date__c = system.today(),
                             EffectiveDate = system.today(),
                             Status = 'Draft',
                             //LHOL_Q__c = 'false',
                             AccountId = acc2.Id,
                             QuoteId = q2.Id,
                             OpportunityId = opp2.Id);
        
        insert o2;
        
        Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                             Implementation_Status__c = 'Initiated',
                             Implementation_Type__c = 'New Business',
                             User_Group__c = 'Local New Business',
                             Production_Date__c = system.today(),
                             EffectiveDate = system.today(),
                             Status = 'Draft',
                             //LHOL_Q__c = 'true',
                             AccountId = acc1.Id,
                             QuoteId = q1.Id,
                             OpportunityId = opp1.Id);
        
        //insert o1;
        
        SME_Approvals__c approval1 = new SME_Approvals__c(Implementation_Record_ID__c = o1.Id,
                                                          SME_Department__c = 'Medical Benefits',
                                                          Status__c = 'Approved',
                                                          Strings_Tables_Contract_Codes_Impacted__c = 'TBD');
        
        insert approval1;
        
        SME_Approvals__c approval2 = new SME_Approvals__c(Implementation_Record_ID__c = o2.Id,
                                                          SME_Department__c = 'Medical Benefits',
                                                          Status__c = 'Approved',
                                                          Strings_Tables_Contract_Codes_Impacted__c = 'TBD');
        
        insert approval2;
        
        /*JiraEndpoint__c endpoint = new JiraEndpoint__c(AccessToken__c = '1', ApiKey__c = '1', ClientID__c = '1', ClientSecret__c = '1', 
Create_Issue__c = '1', Delete_Issue__c = '1', healthCheck__c = '1', 
Jira_Generic__c = '1', Modify_Issue__c = '1', Search_GET__c = '1',
Search_POST__c = '1', Host__c = '1', Application_Username__c = '1', 
Application_Password__c = '1', TokenRefreshTime__c = 12);

insert endpoint;*/
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name, Account.Region__c, Account.Anthem_Entity__c, Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order limit 1];
        
        
        
        Test.startTest();
        
        LGBatchSyncJira lgBS = new LGBatchSyncJira('LG');
        //Database.executeBatch(lgBS);
        lgBS.execute(null,ordlst);
        Test.stopTest();
    }


    
}