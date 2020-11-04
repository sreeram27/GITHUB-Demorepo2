@isTest
public class BrokerageToOppRollUpBatchTest {
    @testSetup
    static  void setupTestData(){
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LG Brokerage').getRecordTypeId();
        Id RecordTypeIdCR = Schema.SObjectType.ContactRelationship__c.getRecordTypeInfosByName().get('LG Brokerage Consultant Relationship').getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'testAcc1';
        acc1.RecordTypeId = RecordTypeIdAccount;
        acc1.Tax_ID__c = '123456789';
        insert acc1;
        Account acc2 = new Account();
        acc2.Name = 'testAcc2';
        insert acc2;
        Contact con1 = new contact();
        con1.AccountId = acc1.Id;
        con1.LastName = 'testCon';
        insert con1;
        ContactRelationship__c cr1 = new ContactRelationship__c();
        cr1.Account__c = acc1.Id;
        cr1.EndDate__c = system.today().addDays(2);
        cr1.NEW_BSNS_TERM_DT__c = system.today().addDays(2);
        cr1.RecordTypeId = RecordTypeIdCR;
        insert cr1;
        
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'testOpp1';
        opp1.StageName = 'Initiated';
        opp1.CloseDate = system.today();
        opp1.AccountId = acc1.Id;
        oppList.add(opp1);
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'testOpp2';
        opp2.StageName = 'Closed Won';
        opp2.CloseDate = system.today();
        opp2.AccountId = acc1.Id;
        oppList.add(opp2);
        insert oppList;
        
        Brokerage_and_Consultant1__c BC = new Brokerage_and_Consultant1__c();
        BC.Opportunity__c = opp1.Id;
        BC.Brokerage__c = acc1.Id;
        BC.Consultant__c = cr1.Id;
        insert BC;
        
        Brokerage_and_Consultant1__c BC1 = new Brokerage_and_Consultant1__c();
        BC1.Opportunity__c = opp1.Id;
        BC1.Brokerage__c = acc1.Id;
        BC1.Consultant__c = cr1.Id;
        insert BC1;
        Brokerage_and_Consultant1__c BC2 = new Brokerage_and_Consultant1__c();
        BC2.Opportunity__c = opp2.Id;
        BC2.Brokerage__c = acc1.Id;
        //BC2.Consultant__c = null;
        insert BC2;
        Delete BC2;
        AccountRoles__c roles = new AccountRoles__c();
        roles.Name = 'BrokerageOppReport';
        roles.LastRun__c = Datetime.now().addDays(-5);
        insert roles;
    }
    static testMethod void testMethodOppExec()
    {
        Test.startTest();
        BrokerageToOppRollUpBatch obj = new BrokerageToOppRollUpBatch();
        database.executeBatch(obj); 
        Test.StopTest();
    }
     static testMethod void testMethodOppExec1()
    {
        Test.startTest();
        BrokerageToOppRollUpBatch obj1 = new BrokerageToOppRollUpBatch();
        obj1.isError = true;
        database.executeBatch(obj1); 
        Test.StopTest();
    }
}