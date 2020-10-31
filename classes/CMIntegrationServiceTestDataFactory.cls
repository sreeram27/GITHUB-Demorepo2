public class CMIntegrationServiceTestDataFactory {
    public static void prepareTestData() {

        // Create common test accounts
		Account acc=IntegrationTestDataUtilty.createAccount(true); 
        Opportunity oppty=IntegrationTestDataUtilty.createOpportunity(acc.id, true);
        Group__c grp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        
        Quote Qte = new Quote();
		Qte.Name = 'Test Quote';
        Qte.OpportunityId = oppty.Id;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Qte.Pricebook2Id = customPB.id;
        Qte.GroupNumber__c = grp.id;
        
        insert Qte;
        Order ImplCase = new Order(Implementation_Effective_Date__c = system.today(),
                             Implementation_Status__c = 'Initiated',
                             Implementation_Type__c = 'New Business',
                             User_Group__c = 'Local New Business',
                             Production_Date__c = system.today(),
                             EffectiveDate = system.today(),
                             Status = 'Draft',
                             //LHOL_Q__c = 'true',
                             AccountId = Acc.Id,
                             QuoteId = Qte.Id,
                             OpportunityId = oppty.Id);
        
        insert ImplCase;

        Contact con1 = new contact();
        con1.AccountId = acc.Id;
        con1.LastName = 'testCon';
        insert con1;
        
        ContactRelationship__c cr1 = new ContactRelationship__c();
        cr1.Account__c = acc.Id;
        cr1.Contact__c = con1.id;
        cr1.EndDate__c = system.today().addDays(2);
        cr1.NEW_BSNS_TERM_DT__c = system.today().addDays(2);
        cr1.Contact_Type__c = 'Group Administrator';
        insert cr1;
        
	}
}