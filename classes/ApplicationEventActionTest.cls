/*
 * Class Name: ApplicationEventActionTest
 * Current Version: 1.0
 * Created Date: October 2019
 * Author: Archima
 * Description: This class has the unit tests for the ApplicationEventAction class.
 */
@isTest
private class ApplicationEventActionTest {

    @isTest
    static void testCreateApplicationEvents() {
        Account account = new Account();
        account.Name = 'Test';
        insert account;

        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Name = 'Test';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = Date.today();
        insert opportunity;

        Brokerage_and_Consultant1__c brokerageConsultant = new Brokerage_and_Consultant1__c();
        brokerageConsultant.Opportunity__c = opportunity.Id;
        brokerageConsultant.Broker_Role__c = ApplicationEventAction.WRITING_AGENT_BROKER_ROLE;
        brokerageConsultant.Brokerage_Role__c = ApplicationEventAction.BROKERAGE_BROKERAGE_ROLE;
        insert brokerageConsultant;

        Order order = new Order();
        order.AccountId = account.Id;
        order.OpportunityId = opportunity.Id;
        order.EffectiveDate = Date.today();
        order.Status = 'Draft';
        insert order;

        Test.startTest();

        // NOTE: ApplicationEventAction.createApplicationEvents() sole purpose is to publish a platform event which can't be asserted.
        try {
            ApplicationEventAction.createApplicationEvents(new List<Id>{order.Id});
        } catch (Exception e) {
            System.assert(false, 'Exception should not have been thrown.');
        }

        Test.stopTest();
    }

}