@isTest
public class LGBatchSyncJiraRefinedTest {
    
    @isTest static void createIssueNationalWGSTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'Customer', 'National Accounts','South East','NAH00000 GA','ANA');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('National Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('WGS 2.0', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','New Business');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('JAA (Jointly Administered Arrangement)','ASO', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'Custom');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'New Business', 'Local New Business', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c,Account_Group_Size__c,Account.Eligible_Employees__c, Account.Anthem_Entity__c, Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c, QuoteId, Plan_Type__c , Product2.Plan_Type__c From QuoteLineItem where ProductType__c = 'Medical' LIMIT 1];
        System.debug('QLI :'+qli);
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', 'National');
        requestMap.put('issueType', 'EBA Request New');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', 'WGS');
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', qli.Funding__c);
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryNewBusiness + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', 'WGS');
        requestMap.put('salesMarket', 'National - South East');
        requestMap.put('system', 'WGS JAA');
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        requestMap.put('gruopSize',String.valueOf(ordlst[0].Account_Group_Size__c));
        requestMap.put('eligibleEmployees',String.valueOf(ordlst[0].Account.Eligible_Employees__c));
        
        Test.startTest();
        
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('National');
        lgbs.execute(null,ordlst);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
        
    }
    
    @isTest static void createIssueLocalLGWGSTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'LG Customer', 'Local/Large Group','South East','NAH00000 GA','Indiana');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('Local Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('WGS 2.0', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','New Business');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','Standard');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('Administrative Services','ASO', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'Modified');
        QuoteLineItem qli2 = LGBatchSyncJiraHelperTest.createQLI('Administrative Services','ASO', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'Custom');
        QuoteLineItem qli3 = LGBatchSyncJiraHelperTest.createQLI('Administrative Services','ASO', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'Standard');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'New Business', 'Local New Business', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.Anthem_Entity__c, Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        List<QuoteLineItem> qliList = [Select Id, Funding__c, ProductName__c, ProductStage__c, QuoteId,Plan_Type__c , Product2.Plan_Type__c From QuoteLineItem where Product_Type__c = 'Medical'];
        System.debug('QLIList :'+qliList);
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember LIMIT 1];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', null);
        requestMap.put('issueType', 'EBA Request New');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', 'WGS-Spider');
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', qliList[0].Funding__c);
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryNewBusiness + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', 'WGS-Spider');
        requestMap.put('salesMarket', 'IN');
        requestMap.put('system', 'SPIDER – FACETS');
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('LG');
        lgbs.execute(null,ordlst);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
        
        
    }
    
    @isTest static void createIssueLabourWGSTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'LG Customer', 'Labor and Trust','South East','NAH00000 GA','Indiana');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('Local Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('WGS 2.0', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','Renewal');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('JAA (Jointly Administered Arrangement)','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'Renewal', 'Local Renewal Local', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c,Account_Group_Size__c,Account.Eligible_Employees__c, Account.Anthem_Entity__c, Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c, Plan_Type__c , Product2.Plan_Type__c,QuoteId From QuoteLineItem where Product_Type__c = 'Medical'];
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', null);
        requestMap.put('issueType', 'EBA Request Maintenance');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', 'WGS');
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', 'Non-Refunding');
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryRenewal + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', 'WGS');
        requestMap.put('salesMarket', 'National - South East');
        requestMap.put('system', 'WGS JAA');
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('LG');
        lgbs.execute(null,ordlst);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
    }
    
    @isTest static void createIssueNationalNascoTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'Customer', 'National Accounts','South East','NAH00000 GA','ANA');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('National Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('NASCO', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','New Business');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','Standard');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('JAA (Jointly Administered Arrangement)','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'New Business', 'Local New Business', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c,Account_Group_Size__c,Account.Eligible_Employees__c, Account.Anthem_Entity__c, Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c, Plan_Type__c , Product2.Plan_Type__c,QuoteId From QuoteLineItem];
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', 'National');
        requestMap.put('issueType', 'EBA Request New');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', ordlst[0].Claim_System__c);
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', 'Non-Refunding');
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryNewBusiness + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', ordlst[0].Claim_System__c);
        requestMap.put('salesMarket', 'National - South East');
        requestMap.put('system', 'NASCO JAA');
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('National');
        lgbs.execute(null,ordlst);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
    }
    
    @isTest static void createIssueLocalLGNascoTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'LG Customer', 'Local/Large Group','South East','NAH00000 GA','Indiana');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('Local Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('NASCO', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','New Business');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('Administrative Services','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'Standard');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'New Business', 'Local New Business', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.Anthem_Entity__c, Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c, Plan_Type__c , Product2.Plan_Type__c,QuoteId From QuoteLineItem];
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', null);
        requestMap.put('issueType', 'EBA Request New');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', ordlst[0].Claim_System__c);
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', 'Non-Refunding');
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryNewBusiness + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', ordlst[0].Claim_System__c);
        requestMap.put('salesMarket', 'Local - NASCO - JAA');
        requestMap.put('system', ordlst[0].Claim_System__c);
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('LG');
        lgbs.execute(null,ordlst);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
    }
    @isTest static void createIssueLocalLGWGSJAAIndTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'LG Customer', 'Local/Large Group','South East','NAH00000 GA','Indiana');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('Local Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('WGS 2.0', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','New Business');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','Standard');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('Administrative Services','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'New Business', 'Local New Business', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c,Plan_Type__c , Product2.Plan_Type__c, QuoteId From QuoteLineItem];
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', null);
        requestMap.put('issueType', 'EBA Request New');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', 'WGS-Spider');
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', 'Non-Refunding');
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryNewBusiness + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', 'WGS-Spider');
        requestMap.put('salesMarket', 'IN');
        requestMap.put('system', 'SPIDER – FACETS');
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('LG');
        lgbs.execute(null,ordlst);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
    }
    
    @isTest static void createIssueLabourNascoTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'LG Customer', 'Labor and Trust','South East','NAH00000 GA','Indiana');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('Local Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('NASCO', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','New Business');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('JAA (Jointly Administered Arrangement)','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'Standard');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'New Business', 'Local New Business', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c,Plan_Type__c , Product2.Plan_Type__c, QuoteId From QuoteLineItem];
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', null);
        requestMap.put('issueType', 'EBA Request New');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', ordlst[0].Claim_System__c);
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', 'Non-Refunding');
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryNewBusiness + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', ordlst[0].Claim_System__c);
        requestMap.put('salesMarket', 'National - South East');
        requestMap.put('system', 'NASCO JAA');
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('LG');
        lgbs.execute(null,ordlst);
        Database.executeBatch(lgbs);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
    }
    
    @isTest static void createIssueNationalNascoChangeRequestTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'Customer', 'National Accounts','South East','NAH00000 GA','ANA');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('National Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('NASCO', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','Renewal');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('JAA (Jointly Administered Arrangement)','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'Custom');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'Change Request Off Cycle', 'National In Group Change', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c,Plan_Type__c , Product2.Plan_Type__c, QuoteId From QuoteLineItem];
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', 'National');
        requestMap.put('issueType', 'EBA Request Maintenance');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', ordlst[0].Claim_System__c);
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', 'Non-Refunding');
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryChange + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', ordlst[0].Claim_System__c);
        requestMap.put('salesMarket', 'National - South East');
        requestMap.put('system','NASCO JAA');
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('National');
        lgbs.execute(null, ordlst);
        //Database.executeBatch(lgbs);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
        
    }
    
    /*  
@isTest static void createIssueNationalNascoTermTest()
{
//Accounts creation
Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'Customer', 'National Accounts','South East','NAH00000 GA','ANA');

//Retrive Admin Profile
Profile pf = LGBatchSyncJiraHelperTest.getProfile('National Implementations');

//Users creation
User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);

//AccountTeamMember Creation
AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);

//Group Creation
Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('NASCO', 'Test Group', acc1.Id,acc1.MBU_Codes__c);

//Opportunity Creations
Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','Renewal');

Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical');

Id priceBookId = Test.getStandardPricebookId();

PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);

Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);

PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);

Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);

QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99);

Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Pending SME Review', 'Change Request Off Cycle', 'National In Group Add Product', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);

SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');

Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);

List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c, QuoteId From QuoteLineItem];
AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
String newDateStr='';

if (ordlst[0].Quote.Opportunity.CloseDate != null) {
Datetime dT = ordlst[0].Quote.Opportunity.CloseDate;

dT = dT.addHours(dT.hour());
dT = dT.addMinutes(dT.minute());
dT = dT.addSeconds(dT.second());

newDateStr =  dT.format('MM/dd/yyyy') ;

}
Map<String,String> requestMap = new Map<String,String>();
requestMap.put('anthemEntity', 'National');
requestMap.put('issueType', 'EBA Request Maintenance');
requestMap.put('project', 'EBA Work Management (EWM)');
requestMap.put('referenceType', 'Sales Force');
requestMap.put('claimSystem', ordlst[0].Claim_System__c);
requestMap.put('state',ordlst[0].Account.Situs_State__c);
requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
requestMap.put('funding', 'Non-Refunding');
requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryChange + ordlst[0].OrderNumber);
requestMap.put('EBAPlatform', ordlst[0].Claim_System__c);
requestMap.put('salesMarket', 'National - South East');
requestMap.put('system', ordlst[0].Claim_System__c);
requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
requestMap.put('LHOL',ordlst[0].LHOL__c);
requestMap.put('accountTeamMember',accTeamMember.User.Name);

Test.startTest();
LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
Test.setMock(HttpCalloutMock.class, mockTest);


LGBatchSyncJira lgbs = new LGBatchSyncJira('National');
lgbs.execute(null, ordlst);
//Database.executeBatch(lgbs);


Test.stopTest();
Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
System.debug('ITList Returned :' +IT);
System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);


}
*/ 
    
    @isTest static void createIssueNationalNascoPreWorkTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'Customer', 'National Accounts','South East','NAH00000 GA','ANA');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('National Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('NASCO', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','Renewal');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('JAA (Jointly Administered Arrangement)','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'Standard');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Pending SME Review', 'Pre Work', 'National In Group Add Product', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c,Plan_Type__c , Product2.Plan_Type__c, QuoteId From QuoteLineItem];
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', 'National');
        requestMap.put('issueType', 'EBA Request Maintenance');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', ordlst[0].Claim_System__c);
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', 'Non-Refunding');
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryPreWork + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', ordlst[0].Claim_System__c);
        requestMap.put('salesMarket', 'National - South East');
        requestMap.put('system', 'NASCO JAA');
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('National');
        lgbs.execute(null, ordlst);
        //Database.executeBatch(lgbs);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        //System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
    }
    
    @isTest static void exceptionTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'Customer', 'National Accounts','South East','NAH00000 GA','ANA');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('National Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('NASCO', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','Renewal');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','Standard');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('Administrative Services','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Pending SME Review', 'Pre Work', 'National In Group Add Product', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,null,true);
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(400);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('National');
        lgbs.execute(null,ordlst);
        
        
        Test.stopTest();
    }
    @isTest static void responseTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'Customer', 'National Accounts','South East','NAH00000 GA','ANA');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('National Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('NASCO', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','Renewal');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('JAA (Jointly Administered Arrangement)','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Pending SME Review', 'Pre Work', 'National In Group Add Product', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,null,true);
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(401);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('National');
        lgbs.execute(null,ordlst);
        
        
        Test.stopTest();
    }
    
    
    @isTest static void noJiraIdTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'Customer', 'National Accounts','South East','NAH00000 GA','ANA');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('National Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('NASCO', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','Renewal');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('JAA (Jointly Administered Arrangement)','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Pending SME Review', 'Pre Work', 'National In Group Add Product', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,null,true);
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(405);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('National');
        lgbs.execute(null,ordlst);
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, lgbs);
        Test.stopTest();
    }
    @isTest static void LGSystemCS90Test()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'LG Customer', 'Local/Large Group','South East','NAH00000 GA','New York');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('Local Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('WGS 2.0', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','New Business');
        
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('Administrative Services','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'New Business', 'Local New Business', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c,Plan_Type__c , Product2.Plan_Type__c, QuoteId From QuoteLineItem];
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', null);
        requestMap.put('issueType', 'EBA Request New');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', 'WGS-Spider');
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', 'Non-Refunding');
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryNewBusiness + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', 'WGS-Spider');
        requestMap.put('salesMarket', 'Local - NY');
        requestMap.put('system', 'SPIDER – CS-90');
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('LG');
        lgbs.execute(null,ordlst);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
    }
    @isTest static void LGSystemSpideAcesTest()
    {
        //Accounts creation
        Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'LG Customer', 'Local/Large Group','South East','NAH00000 GA','Maine');
        
        //Retrive Admin Profile
        Profile pf = LGBatchSyncJiraHelperTest.getProfile('Local Implementations');
        
        //Users creation
        User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);
        
        //AccountTeamMember Creation
        AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);
        
        //Group Creation
        Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('WGS 2.0', 'Test Group', acc1.Id,acc1.MBU_Codes__c);
        
        //Opportunity Creations
        Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','New Business');
        
        //Product Creation
        Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical','');
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);
        
        Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);
        
        PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);
        
        Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);
        
        QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('Administrative Services','FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99,'');
        
        Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'New Business', 'Local New Business', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);
        
        SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');
        
        Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);
        
        List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
        QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c,Plan_Type__c , Product2.Plan_Type__c, QuoteId From QuoteLineItem];
        AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
        String newDateStr='';
        
        if (ordlst[0].Implementation_Effective_Date__c != null) {
            Datetime dT = ordlst[0].Implementation_Effective_Date__c;
            
            dT = dT.addHours(dT.hour());
            dT = dT.addMinutes(dT.minute());
            dT = dT.addSeconds(dT.second());
            
            newDateStr =  dT.format('MM/dd/yyyy') ;
            
        }
        Map<String,String> requestMap = new Map<String,String>();
        requestMap.put('anthemEntity', null);
        requestMap.put('issueType', 'EBA Request New');
        requestMap.put('project', 'EBA Work Management (EWM)');
        requestMap.put('referenceType', 'Sales Force');
        requestMap.put('claimSystem', 'WGS-Spider');
        requestMap.put('state',ordlst[0].Account.Situs_State__c);
        requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
        requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
        requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
        requestMap.put('funding', 'Non-Refunding');
        requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryNewBusiness + ordlst[0].OrderNumber);
        requestMap.put('EBAPlatform', 'WGS-Spider');
        requestMap.put('salesMarket', 'ME');
        requestMap.put('system', 'SPIDER – ACES');
        requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
        requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
        requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
        requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
        requestMap.put('LHOL',ordlst[0].LHOL__c);
        requestMap.put('accountTeamMember',accTeamMember.User.Name);
        
        Test.startTest();
        LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
        Test.setMock(HttpCalloutMock.class, mockTest);
        
        
        LGBatchSyncJira lgbs = new LGBatchSyncJira('LG');
        lgbs.execute(null,ordlst);
        
        
        Test.stopTest();
        Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
        System.debug('ITList Returned :' +IT);
        System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
        System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);
        
        
    }
    /*
@isTest static void LGSystemSpideChipsTest()
{
//Accounts creation
Account acc1 = LGBatchSyncJiraHelperTest.createFullAccount('LG Jira Test one', 'LG Customer', 'Local/Large Group','South East','NAH00000 GA','Virginia');

//Retrive Admin Profile
Profile pf = LGBatchSyncJiraHelperTest.getProfile('Local Implementations');

//Users creation
User uu = LGBatchSyncJiraHelperTest.createUser('ABC', 'XYZ', 'ABC@example.com','ABCLGJiraRefined@example.com', 'aba', pf.Id);

//AccountTeamMember Creation
AccountTeamMember atm1 = LGBatchSyncJiraHelperTest.createAccTeamMem(acc1.Id, 'Account Executive', uu.Id);

//Group Creation
Group__c  grp1 = LGBatchSyncJiraHelperTest.createGroup('WGS 2.0', 'Test Group', acc1.Id,acc1.MBU_Codes__c);

//Opportunity Creations
Opportunity opp1 = LGBatchSyncJiraHelperTest.createOpp(date.valueOf('2018-01-01'), 'test opp1', acc1.Id, 'Initiated','New Business');

Product2 prod = LGBatchSyncJiraHelperTest.createProduct('Health and Wellness - Live Health Online', true, 'Medical');

Id priceBookId = Test.getStandardPricebookId();

PricebookEntry standardPrice = LGBatchSyncJiraHelperTest.createPBE(priceBookId, prod.Id, 10000, true);

Pricebook2 customPB = LGBatchSyncJiraHelperTest.createPriceBook2('Custom Pricebook', true);

PricebookEntry pbe = LGBatchSyncJiraHelperTest.createPBE(customPB.Id, prod.Id, 12000, true);

Quote q1 = LGBatchSyncJiraHelperTest.createQuote(true, grp1.Id, 'test quote1', customPB.Id,opp1.Id);

QuoteLineItem qli1 = LGBatchSyncJiraHelperTest.createQLI('FI', q1.Id, prod.Id, 10, pbe.Id, 10, 10.00,100,99,99);

Order order1 = LGBatchSyncJiraHelperTest.createOrder(system.today(), 'Initiated', 'New Business', 'Local New Business', system.today(), system.today(),'Draft', acc1.Id, q1.Id, opp1.Id,grp1,uu.Id);

SME_Approvals__c smeApprovals1 = LGBatchSyncJiraHelperTest.createSMEApprovals(order1.Id, 'Medical Benefits', 'Approved', 'TBD');

Implementation_Tracking__c IT1 =  LGBatchSyncJiraHelperTest.createIT(order1.Id,'',true);

List<Order> ordlst = [Select Id, AccountId, Account.Name,Account.Situs_State__c ,Account.Region__c, Account.Anthem_Entity__c, Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c,Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order];
QuoteLineItem qli = [Select Id, Funding__c, ProductName__c, ProductStage__c, QuoteId From QuoteLineItem];
AccountTeamMember accTeamMember = [Select Id, AccountId, User.Name From AccountTeamMember];
String newDateStr='';

if (ordlst[0].Quote.Opportunity.CloseDate != null) {
Datetime dT = ordlst[0].Quote.Opportunity.CloseDate;

dT = dT.addHours(dT.hour());
dT = dT.addMinutes(dT.minute());
dT = dT.addSeconds(dT.second());

newDateStr =  dT.format('MM/dd/yyyy') ;

}
Map<String,String> requestMap = new Map<String,String>();
requestMap.put('anthemEntity', null);
requestMap.put('issueType', 'EBA Request New');
requestMap.put('project', 'EBA Work Management (EWM)');
requestMap.put('referenceType', 'Sales Force');
requestMap.put('claimSystem', 'WGS-Spider');
requestMap.put('state',ordlst[0].Account.Situs_State__c);
requestMap.put('productionDate',String.valueOf(ordlst[0].Production_Date__c));
requestMap.put('corporateReceiptDate',String.valueOf(ordlst[0].CreatedDate));
requestMap.put('assignedImplementer',ordlst[0].Assigned_Implementer__r.Name);
requestMap.put('funding', 'Non-Refunding');
requestMap.put('summary', ordlst[0].Account.Name + ' - ' + ordlst[0].Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryNewBusiness + ordlst[0].OrderNumber);
requestMap.put('EBAPlatform', 'WGS-Spider');
requestMap.put('salesMarket', 'VA');
requestMap.put('system', 'SPIDER – CS-90');
requestMap.put('totalMember',String.valueOf(ordlst[0].Quote.TotalMembers__c));
requestMap.put('oppEffDate',String.valueOf(ordlst[0].Quote.Opportunity.CloseDate.addYears(1)));
requestMap.put('recordLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + order1.Id);
requestMap.put('jaaIndicator',String.valueOf(ordlst[0].Quote.JAAIndicator__c));
requestMap.put('LHOL',ordlst[0].LHOL__c);
requestMap.put('accountTeamMember',accTeamMember.User.Name);

Test.startTest();
LGBatchSyncJiraMockTest mockTest = new LGBatchSyncJiraMockTest(requestMap);
Test.setMock(HttpCalloutMock.class, mockTest);


LGBatchSyncJira lgbs = new LGBatchSyncJira('LG');
lgbs.execute(null,ordlst);


Test.stopTest();
Implementation_Tracking__c IT = [select Implementation_Record_ID__c , JIRA_Request_ID__c from Implementation_Tracking__c LIMIT 1];
System.debug('ITList Returned :' +IT);
System.assertEquals('EWM-49704',IT.JIRA_Request_ID__c);
System.assertEquals(it1.Implementation_Record_ID__c, IT.Implementation_Record_ID__c);


}
*/
    
    
}