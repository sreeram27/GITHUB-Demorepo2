/*
 * Class Name: ApplicationEventAction
 * Current Version: 1.0
 * Created Date: October 2019
 * Author: Archima
 * Description: This class has an invocable method that is used by a process
 * to publish LG Application platform events.
 */
public with sharing class ApplicationEventAction {

    public static final String WRITING_AGENT_BROKER_ROLE = 'Writing Agent';
    public static final String BROKERAGE_BROKERAGE_ROLE = 'Brokerage';

    @InvocableMethod(label='Create Application Events')
    public static void createApplicationEvents(List<Id> orderIds) {
        List<Order> orders = [
            SELECT
            	OpportunityId,
            	OrderNumber,
            	LG_Broker_Portal_Case_Status__c,
            	LG_Broker_Portal_Status_Date__c,
            	LG_Broker_Portal_Status_Event_Type__c,
            	Account.Situs_State_Abbrev__c
           	FROM
            	Order
            WHERE
            	Id IN :orderIds
        ];

        Set<Id> opportunityIds = new Set<Id>();

        for (Order order : orders) {
            opportunityIds.add(order.OpportunityId);
        }

        List<Brokerage_and_Consultant1__c> brokerageConsultants = [
        	SELECT
            	Opportunity__c,
            	Brokerage_Role__c,
            	Broker_Role__c,
            	Consultant__r.Account__r.ENCRYPTID__c,
            	Consultant__r.Contact__r.ENCRYPTID__c
            FROM
            	Brokerage_and_Consultant1__c
            WHERE
                Opportunity__c IN :opportunityIds
            AND
            	(
                	Broker_Role__c = :WRITING_AGENT_BROKER_ROLE
                    OR
            		Brokerage_Role__c = :BROKERAGE_BROKERAGE_ROLE
                )
        ];

        Map<Id, Brokerage_and_Consultant1__c> opportunityBrokerageConsultants = new Map<Id, Brokerage_and_Consultant1__c>();
        Map<Id, Brokerage_and_Consultant1__c> opportunityWritingConsultants = new Map<Id, Brokerage_and_Consultant1__c>();

        for (Brokerage_and_Consultant1__c brokerageConsultant : brokerageConsultants) {
            if (brokerageConsultant.Brokerage_Role__c == BROKERAGE_BROKERAGE_ROLE) {
            	opportunityBrokerageConsultants.put(brokerageConsultant.Opportunity__c, brokerageConsultant);
            }

            if (brokerageConsultant.Broker_Role__c == WRITING_AGENT_BROKER_ROLE) {
				opportunityWritingConsultants.put(brokerageConsultant.Opportunity__c, brokerageConsultant);
            }
        }

        List<LG_Application__e> applicationEvents = new List<LG_Application__e>();

        for (Order order : orders) {
            Brokerage_and_Consultant1__c brokerageConsultant = opportunityBrokerageConsultants.get(order.OpportunityId);
            Brokerage_and_Consultant1__c writingConsultant = opportunityWritingConsultants.get(order.OpportunityId);

            LG_Application__e applicationEvent = new LG_Application__e();
            applicationEvent.Application_ID__c = order.OrderNumber;
            applicationEvent.Application_Status__c = order.LG_Broker_Portal_Case_Status__c;
            applicationEvent.Application_Status_Description__c = order.LG_Broker_Portal_Case_Status__c;
            applicationEvent.Application_Status_Modified__c = order.LG_Broker_Portal_Status_Date__c;
            applicationEvent.Event_Name__c = order.LG_Broker_Portal_Status_Event_Type__c;
            applicationEvent.Line_of_Business__c = 'LG';
            applicationEvent.Payee_TIN__c = (brokerageConsultant == null ? null : brokerageConsultant.Consultant__r.Account__r.ENCRYPTID__c);
            applicationEvent.State__c = order.Account.Situs_State_Abbrev__c;
            applicationEvent.Writing_TIN__c = (writingConsultant == null ? null : writingConsultant.Consultant__r.Contact__r.ENCRYPTID__c);
            applicationEvents.add(applicationEvent);
        }
        
        EventBus.publish(applicationEvents);
    }

}