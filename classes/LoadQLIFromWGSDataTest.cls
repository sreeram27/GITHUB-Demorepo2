@isTest
public class LoadQLIFromWGSDataTest {
    
    static WGS_Sold_Contract_Codes__c createData()
    {
       Account acc=IntegrationTestDataUtilty.createAccount(true); 
       
        String renewalOppRecTypeId = Opportunity.sObjectType.getDescribe().getRecordTypeInfosbyName().get('Renewal Local').getRecordTypeId();
        Opportunity oppty=IntegrationTestDataUtilty.createOpportunity(acc.id, true);
        oppty.StageName = 'Submitted';
        oppty.RecordTypeId = renewalOppRecTypeId;
        update oppty;
        
        Group__c grp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        grp.IsActive__c = True;
        grp.Name = 'W61305';
        update grp;
        
        Quote qte=IntegrationTestDataUtilty.createQuote(oppty.Id, grp.id, true);
        
        Product2 prod=IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40RA';
        prod.Category__c = 'Product';
        Database.update(prod);
        
        Product2 plan=IntegrationTestDataUtilty.createProduct(true);
        plan.Contract_Code__c = '40QA';
        plan.vlocity_ins__ProductSpecId__c = prod.Id;
        plan.ProductActive__c = True;
        Database.update(plan);
        
        PricebookEntry pbe=IntegrationTestDataUtilty.createPricebookEntry(prod.id, true);
        PricebookEntry pbeplan=IntegrationTestDataUtilty.createPricebookEntry(plan.id, true);
        
        WGS_Sold_Contract_Codes__c wgsRec= new WGS_Sold_Contract_Codes__c(WGS_Group_Number__c = 'W61305', Contract_Code__c ='40QA', Benefit_Period__c = 'Calendar Year',
                                                                Effective_Date__c = Date.today(), Financing__c = 'Fully Insured', Funding_Type__c = 'FI', Status__c = 'Pending',
                                                                Member_Count__c = 150, Subscriber_Count__c = 100, Upsell_Flag__c = 'No');
		Database.insert(wgsRec);
        
        return wgsRec;
    }
	
    @isTest
    static void testQliInsertSuccess(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        System.assertEquals(2, [Select Count() from QuoteLineItem], 'Total No of QLis are not matching the expected count');
        QuoteLineItem childQLI = [Select Id, Members__c from QuoteLineItem where Contract_Codes__c = '40QA'];
        System.assertEquals(150, childQLI.Members__c, 'Member count is not correct');
    }
    
    @isTest
    static void testMandatoryfieldsnull(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
        
        wgsTestRec.Contract_Code__c = '';
        update wgsTestRec;
        
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        WGS_Sold_Contract_Codes__c wgsRecresult = [Select Id, Status__c, Status_Message__c from WGS_Sold_Contract_Codes__c LIMIT 1];
        System.assertEquals('Error', wgsRecresult.Status__c, 'Error occurred in the process');
        System.assertEquals('Missing WGS Group Number and/or Contract Code in WGS input data', wgsRecresult.Status_Message__c, 'Required fields error message is not correct');
    }
    
    @isTest
    static void testWGSGroupNotExist(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
        
        wgsTestRec.WGS_Group_Number__c = 'TestG';
        update wgsTestRec;
        
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        WGS_Sold_Contract_Codes__c wgsRecresult = [Select Id, Status__c, Status_Message__c from WGS_Sold_Contract_Codes__c LIMIT 1];
        System.assertEquals('Error', wgsRecresult.Status__c, 'Error occurred in the process');
        System.assertEquals('No active WGS Groups found with group number TestG', wgsRecresult.Status_Message__c, 'No active wgs group found error is not correct');    
        
    }
    
    @isTest
    static void testMultipleWGSgroupsExist(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
        
        Group__c grp = [Select Id, Account__c from Group__c where Name='W61305'];
        
       Group__c secondgrp = new Group__c(Name='W61305', IsActive__c = true, Account__c = grp.Account__c, ClaimSystem__c = 'WGS 2.0');
       insert secondgrp;
        
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        WGS_Sold_Contract_Codes__c wgsRecresult = [Select Id, Status__c, Status_Message__c from WGS_Sold_Contract_Codes__c LIMIT 1];
        System.assertEquals('Error', wgsRecresult.Status__c, 'Error occurred in the process');
        System.assertEquals('More than one active WGS Groups found with group number W61305', wgsRecresult.Status_Message__c, 'Multiple wgs groups exist error message is not correct');
    } 
    
    @isTest
    static void testNoOppExists(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
        
        Opportunity opp=[Select Id, StageName from Opportunity LIMIT 1];
        opp.StageName = 'Closed Won';
        update opp;
        
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        WGS_Sold_Contract_Codes__c wgsRecresult = [Select Id, Status__c, Status_Message__c from WGS_Sold_Contract_Codes__c LIMIT 1];
        Group__c grp = [Select Id, Account__c From Group__c where Name ='W61305'];
        System.assertEquals('Error', wgsRecresult.Status__c, 'Error occurred in the process');
        System.assertEquals('No Renewal Local Type Opportunity found for the related account '+grp.Account__c+' and group number W61305', wgsRecresult.Status_Message__c, 'No renewal Opp found error message is not correct');
    } 
    @isTest
    static void testMultipleOppsExists(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
        
        Opportunity opp=[Select Id, AccountId, StageName, RecordTypeId from Opportunity LIMIT 1];
        Opportunity opp2 = new Opportunity(Name = 'Test Opp2',AccountId = opp.AccountId, StageName='Initiated', CloseDate = Date.today(), RecordTypeId = opp.RecordTypeId);
        insert opp2;
        
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        WGS_Sold_Contract_Codes__c wgsRecresult = [Select Id, Status__c, Status_Message__c from WGS_Sold_Contract_Codes__c LIMIT 1];
        Group__c grp = [Select Id, Account__c From Group__c where Name ='W61305'];
        System.assertEquals('Error', wgsRecresult.Status__c, 'Error occurred in the process');
        System.assertEquals('More than one Renewal Local Type Opportunities found for the related account '+grp.Account__c+' and group number W61305', wgsRecresult.Status_Message__c, 'Multiple Opps found error message is not correct');
    }
    
    @isTest
    static void testNoQuoteExists(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
       /* Group__c grp = [Select Id, Account__c from Group__c where Name='W61305'];
        Group__c secondgrp = new Group__c(Name='W61307', IsActive__c = true, Account__c = grp.Account__c, ClaimSystem__c = 'WGS 2.0');
        insert secondgrp; */
        
        Quote quoteRec = [Select Id, GrpName__c from Quote where GrpName__c = 'W61305'];
       // quoteRec.GroupNumber__c = secondgrp.Id;
        delete quoteRec;
            
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        WGS_Sold_Contract_Codes__c wgsRecresult = [Select Id, Status__c, Status_Message__c from WGS_Sold_Contract_Codes__c LIMIT 1];
        Group__c grp1 = [Select Id, Account__c From Group__c where Name ='W61305'];
        System.assertEquals('Error', wgsRecresult.Status__c, 'Error occurred in the process');
        System.assertEquals('No quote found under Renewal Local Type Opportunity for the related account '+grp1.Account__c+' and group number W61305', wgsRecresult.Status_Message__c, 'No quote found error message is not correct');
    } 
    
    @isTest
    static void testMultipleQuotesExist(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
        Group__c grp = [Select Id, Account__c from Group__c where Name='W61305'];
        Opportunity opp=[Select Id, AccountId, StageName, RecordTypeId from Opportunity LIMIT 1];
        
        Quote secondqte=IntegrationTestDataUtilty.createQuote(opp.Id, grp.id, true);     
            
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        WGS_Sold_Contract_Codes__c wgsRecresult = [Select Id, Status__c, Status_Message__c from WGS_Sold_Contract_Codes__c LIMIT 1];
        Group__c grp1 = [Select Id, Account__c From Group__c where Name ='W61305'];
        System.assertEquals('Error', wgsRecresult.Status__c, 'Error occurred in the process');
        System.assertEquals('More than one quotes found under Renewal Local Type Opportunity for the related account '+grp1.Account__c+' and group number W61305', wgsRecresult.Status_Message__c, 'Error message for multiple quotes scenario is wrong');
    } 
    
    @isTest
    static void testQLIExist(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
        
        Quote qte = [Select Id, GrpName__c from Quote where GrpName__c = 'W61305'];
        Product2 prod = [Select Id From Product2 where Contract_Code__c='40QA'];
        PriceBookEntry pbe = [Select Id from PriceBookEntry where Product2Id=: prod.Id];
        
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        Database.insert(qli); 
            
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        WGS_Sold_Contract_Codes__c wgsRecresult = [Select Id, Status__c, Status_Message__c from WGS_Sold_Contract_Codes__c LIMIT 1];
        System.assertEquals('Error', wgsRecresult.Status__c, 'Error occurred in the process');
        System.assertEquals('QLI already exists for the contract code 40QA and WGS group number W61305', wgsRecresult.Status_Message__c, 'Error message for QLI already exist scenario is not correct');
    } 
    
    @isTest
    static void testProductNotExist(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
        
        Product2 prod = [Select Id From Product2 where Contract_Code__c='40QA'];
        prod.Contract_Code__c = 'ABCD';
        update prod;
            
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        WGS_Sold_Contract_Codes__c wgsRecresult = [Select Id, Status__c, Status_Message__c from WGS_Sold_Contract_Codes__c LIMIT 1];
        System.assertEquals('Error', wgsRecresult.Status__c, 'Error occurred in the process');
        System.assertEquals('No matching Product found with the contract code 40QA', wgsRecresult.Status_Message__c, 'Product not found error message');
    }
     @isTest
    static void testParentQLIExist(){
        
        WGS_Sold_Contract_Codes__c wgsTestRec = createData();
        
        Quote qte = [Select Id, GrpName__c from Quote where GrpName__c = 'W61305'];
        Product2 prod = [Select Id From Product2 where Contract_Code__c='40RA'];
        PriceBookEntry pbe = [Select Id from PriceBookEntry where Product2Id=: prod.Id];
        
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        Database.insert(qli); 
            
        Test.startTest();
        Database.executeBatch(new LoadQLIFromWGSData(), 1);
        Test.stopTest();
        
        System.assertEquals(2, [Select Count() from QuoteLineItem], 'No of qlis not matching the expected count');
        QuoteLineItem childQLI = [Select Id, Members__c from QuoteLineItem where Contract_Codes__c = '40QA'];
        QuoteLineItem parentQLI = [Select Id, Members__c from QuoteLineItem where Contract_Codes__c = '40RA'];
        System.assertEquals(150, childQLI.Members__c, 'Member count not updated on child QLI');
        System.assertEquals(150, parentQLI.Members__c, 'Member count not updated on Parent QLI');
    } 
}