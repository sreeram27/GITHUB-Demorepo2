/*
 * Class Name: APIApplicationTest
 * Current Version: 1.0
 * Created Date: October 2019
 * Author: Archima
 * Description: This class has the unit tests for the APIApplication class.
 */
@isTest
private class APIApplicationTest {

    @isTest
    static void testGetApplication() {
        Account account = new Account();
        account.Name = 'Test';
        insert account;
        
        Contact contact = new Contact();
        contact.AccountId = account.Id;
        contact.LastName = 'Primary';
        contact.Primary_Contact__c = true;
        contact.IsActive1__c = true;
        insert contact;
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Name = 'Test';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = Date.today();
        insert opportunity;
        
        OpportunityTeamMember opportunityTeamMemberManager = new OpportunityTeamMember();
        opportunityTeamMemberManager.OpportunityId = opportunity.Id;
        opportunityTeamMemberManager.UserId = UserInfo.getUserId();
        opportunityTeamMemberManager.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMemberManager;

        OpportunityTeamMember opportunityTeamMemberExecutive = new OpportunityTeamMember();
        opportunityTeamMemberExecutive.OpportunityId = opportunity.Id;
        opportunityTeamMemberExecutive.UserId = UserInfo.getUserId();
        opportunityTeamMemberExecutive.TeamMemberRole = 'Account Executive';

        Brokerage_and_Consultant1__c brokerageConsultant = new Brokerage_and_Consultant1__c();
        brokerageConsultant.Opportunity__c = opportunity.Id;
        brokerageConsultant.Broker_Role__c = ApplicationEventAction.WRITING_AGENT_BROKER_ROLE;
        brokerageConsultant.Brokerage_Role__c = ApplicationEventAction.BROKERAGE_BROKERAGE_ROLE;
        insert brokerageConsultant;

        Tax_ID__c taxId = new Tax_ID__c();
        taxId.Account__c = account.Id;
        insert taxId;

        Quote quote = new Quote();
        quote.OpportunityId = opportunity.Id;
        quote.Pricebook2Id = Test.getStandardPricebookId();
        quote.Name = 'Test';
        insert quote;
        
		Product2 product = new Product2();
		product.Name = 'Test';
        product.Category__c = 'Product';
		insert product;

		PricebookEntry pricebookEntry = new PricebookEntry();
		pricebookEntry.Pricebook2Id = Test.getStandardPricebookId();
		pricebookEntry.Product2Id = product.Id;
		pricebookEntry.UnitPrice = 1;
		pricebookEntry.IsActive = true;
		insert pricebookEntry;
        
        QuoteLineItem quoteLineItem = new QuoteLineItem();
        quoteLineItem.QuoteId = quote.Id;
        quoteLineItem.PricebookEntryId = pricebookEntry.Id;
        quoteLineItem.Quantity = 1;
        quoteLineItem.UnitPrice = 1;
        quoteLineItem.ProductStage__c = 'Sold';
        insert quoteLineItem;
        
        Order order = new Order();
        order.AccountId = account.Id;
        order.OpportunityId = opportunity.Id;
        order.QuoteId = quote.Id;
        order.EffectiveDate = Date.today();
        order.Status = 'Draft';
        insert order;

        String orderNumber = [SELECT OrderNumber FROM Order WHERE Id = :order.Id].OrderNumber;

        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/application/' + orderNumber;
        
        APIApplication.Application application = APIApplication.getApplication();

        System.assertEquals(orderNumber, application.applicationId);
    }

    @isTest
    static void testGetApplicationMissingOrderNumber() {
        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/application/';

        RestContext.response = new RestResponse();

        APIApplication.Application application = APIApplication.getApplication();

        System.assertEquals(null, application);
        System.assertEquals(400, RestContext.response.statusCode);
    }

    @isTest
    static void testGetApplicationInvalidOrderNumber() {
        String orderNumber = 'invalid';

        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/application/' + orderNumber;

        RestContext.response = new RestResponse();

        APIApplication.Application application = APIApplication.getApplication();

        System.assertEquals(null, application);
        System.assertEquals(404, RestContext.response.statusCode);
    }

}