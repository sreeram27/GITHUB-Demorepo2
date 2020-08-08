/*
 * Class Name: APIApplication
 * Current Version: 1.0
 * Created Date: October 2019
 * Author: Archima
 * Description: This class exposes a REST interface for retrieving an Application.
 * Below is the URL path pattern used to call the service.
 * 
 * GET /application/{applicationNumber}
 */
@RestResource(urlMapping='/application/*')
global with sharing class APIApplication {

    public static final STRING ROLE_ACCOUNT_MANAGER = 'Account Manager';
    public static final STRING ROLE_ACCOUNT_EXECUTIVE = 'Account Executive';


    @HttpGet
    global static Application getApplication() {
        String orderNumber = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/') + 1);
        return getApplication(orderNumber);
    }

    public static Application getApplication(String orderNumber) {
        Application application;

        if (String.isNotBlank(orderNumber)) {
            List<Order> orders = [
                SELECT
                    Account.Anthem_Entity__c, Account.BillingCity, Account.BillingPostalCode, Account.BillingState, Account.BillingStreet,
                    Account.Group_Size__c, Account.SIC__r.Industry_Name__c, Account.SIC__r.SIC_Code__c, Account.Situs_State_Abbrev__c,
                    AccountLegalName__c, LG_Broker_Portal_Case_Status__c, Implementation_Type__c, Opportunity.CloseDate,
                    Opportunity.Date_Signed_Paperwork_Rec_d__c, OrderNumber, QuoteId
                FROM
                    Order
                WHERE
                    OrderNumber = :orderNumber
            ];

            if (orders.size() > 0) {
                OpportunityTeamMember accountManager;
                OpportunityTeamMember accountExecutive;

                List<OpportunityTeamMember> opportunityTeamMembers = [
                    SELECT
                        TeamMemberRole, User.FirstName, User.LastName
                    FROM
                        OpportunityTeamMember
                    WHERE
                        OpportunityId = :orders[0].OpportunityId
                    AND
                        TeamMemberRole IN (:ROLE_ACCOUNT_MANAGER, :ROLE_ACCOUNT_EXECUTIVE)
                ];

                for (OpportunityTeamMember opportunityTeamMember : opportunityTeamMembers) {
                    if (opportunityTeamMember.TeamMemberRole == ROLE_ACCOUNT_MANAGER) {
                        accountManager = opportunityTeamMember;
                    } else if (opportunityTeamMember.TeamMemberRole == ROLE_ACCOUNT_EXECUTIVE) {
                        accountExecutive = opportunityTeamMember;
                    }
                }

                List<Brokerage_and_Consultant1__c> brokerageConsultants = [
                    SELECT
                        Broker_Role__c, Brokerage_Role__c, Consultant__r.Account__r.ENCRYPTID__c, Consultant__r.Account__r.Name,
                        Consultant__r.Contact__r.ENCRYPTID__c, Consultant__r.Contact__r.FirstName, Consultant__r.Contact__r.LastName
                    FROM
                        Brokerage_and_Consultant1__c
                    WHERE
                        Opportunity__c = :orders[0].OpportunityId
                    AND
                        (
                            Broker_Role__c = :ApplicationEventAction.WRITING_AGENT_BROKER_ROLE
                            OR
                            Brokerage_Role__c = :ApplicationEventAction.BROKERAGE_BROKERAGE_ROLE
                        )
                ];

                List<QuoteLineItem> quoteLineItems = [
                    SELECT
                        Contract_Code_ASF__c, ProductName__c, ProductLOB__c, Product_Family_Local__c
                    FROM
                        QuoteLineItem
                    WHERE
                        QuoteId = :orders[0].QuoteId
                    AND
                        ProductCategory__c = 'Product'
                    AND
                        IC_ProductStage__c = 'Sold'
                ];

                Contact primaryContact;

                List<Contact> contacts = [
                    SELECT
                        Email, Fax, Name, FirstName, LastName, Phone
                    FROM
                        Contact
                    WHERE
                        AccountId = :orders[0].AccountId
                    AND
                        IsActive1__c = true
                    AND
                        Primary_Contact__c = true
                    LIMIT 1
                ];

                if (contacts.size() > 0) {
                    primaryContact = contacts[0];
                }

                String taxId;

                // Get the last modified Tax ID record for the Account.
                List<Tax_ID__c> taxIds = [SELECT Tax_ID__c FROM Tax_ID__c WHERE Account__c = :orders[0].AccountId ORDER BY LastModifiedDate DESC LIMIT 1];

                if (taxIds.size() > 0) {
                    taxId = taxIds[0].Tax_ID__c;
                }

                application = new Application(orders[0], accountManager, accountExecutive, brokerageConsultants, quoteLineItems, primaryContact, taxId);
            } else {
                // No record found.
                RestContext.response.statusCode = 404;
            }
        } else {
            // Invalid request.
            RestContext.response.statusCode = 400;    
        }

        return application;
    }


    global class Application {

        global String accountManagerId {get; set;}
        global String accountManagerName {get; set;}
        global List<Agent> agents {get; set;}
        global String appCreationDate {get; set;}
        global String applicationId {get; set;}
        global String applicationType {get; set;}
        global String appSource {get; set;}
        global CompanyInformation companyInformation {get; set;}
        global String ein {get; set;}
        global String marketSegment {get; set;}
        global String name {get; set;}
        global List<Plan> plans {get; set;}
        global String requestEffectiveDate {get; set;}
        global String salesRepId {get; set;}
        global String salesRepName {get; set;}
        global String sicCode {get; set;}
        global String size {get; set;}
        global String state {get; set;}
        global String status {get; set;}


        global Application() {
        }

        global Application(Order order, OpportunityTeamMember accountManager, OpportunityTeamMember accountExecutive, List<Brokerage_and_Consultant1__c> brokerageConsultants, List<QuoteLineItem> quoteLineItems, Contact primaryContact, String taxId) {
            if (accountManager != null) {
                accountManagerId = accountManager.UserId;
                accountManagerName = formatName(accountManager.User.FirstName, accountManager.User.LastName);
            }

            agents = new List<Agent>();

            for (Brokerage_and_Consultant1__c brokerageConsultant : brokerageConsultants) {
                Agent agent = new Agent();

                if (brokerageConsultant.Brokerage_Role__c == ApplicationEventAction.BROKERAGE_BROKERAGE_ROLE) {
                    agent.paidAgentName = brokerageConsultant.Consultant__r.Account__r.Name;
                    agent.paidAgentTin = brokerageConsultant.Consultant__r.Account__r.ENCRYPTID__c;
                }

                if (brokerageConsultant.Broker_Role__c == ApplicationEventAction.WRITING_AGENT_BROKER_ROLE) {
                    agent.writingAgentName = formatName(brokerageConsultant.Consultant__r.Contact__r.FirstName, brokerageConsultant.Consultant__r.Contact__r.LastName);
                    agent.writingAgentTin = brokerageConsultant.Consultant__r.Contact__r.ENCRYPTID__c;
                }

                agents.add(agent);
            }

            appCreationDate = formatDate(order.Opportunity.Date_Signed_Paperwork_Rec_d__c, 'yyyy-MM-dd');
            applicationId = order.OrderNumber;
            applicationType = order.Implementation_Type__c;

            companyInformation = new CompanyInformation();
            companyInformation.addresses = new List<Address>();
            companyInformation.addresses.add(new Address());
            companyInformation.addresses[0].city = order.Account.BillingCity;
            companyInformation.addresses[0].state = order.Account.BillingState;
            companyInformation.addresses[0].streetAddress = order.Account.BillingStreet;
            companyInformation.addresses[0].type = 'Company';
            companyInformation.addresses[0].zip = order.Account.BillingPostalCode;

            if (primaryContact != null) {
                companyInformation.contactDetails = new ContactDetails ();
                companyInformation.contactDetails.contactEmailAddress = primaryContact.Email;
                companyInformation.contactDetails.contactName = formatName(primaryContact.FirstName, primaryContact.LastName);
                companyInformation.contactDetails.faxNumber = primaryContact.Fax;
                companyInformation.contactDetails.primaryPhone = primaryContact.Phone;
            }

            ein = taxId;
            marketSegment = order.Account.Anthem_Entity__c;
            name = order.AccountLegalName__c;

            plans = new List<Plan>();

            for (QuoteLineItem quoteLineItem : quoteLineItems) {
                Plan plan = new Plan();
                plan.planType = quoteLineItem.Product_Family_Local__c;
                plan.productType = quoteLineItem.ProductLOB__c;
                plans.add(plan);
            }
            
            requestEffectiveDate = formatDate(order.Opportunity.CloseDate, 'yyyy-MM-dd');

            if (accountExecutive != null) {
                salesRepId = accountExecutive.UserId;
                salesRepName = formatName(accountExecutive.User.FirstName, accountExecutive.User.LastName);
            }

            sicCode = order.Account.SIC__r.SIC_Code__c + ',' + order.Account.SIC__r.Industry_Name__c;
            size = order.Account.Group_Size__c;
            state = order.Account.Situs_State_Abbrev__c;
            status = order.LG_Broker_Portal_Case_Status__c;
        }

    }

    public static String formatName(String firstName, String lastName) {
        String name;

        if (String.isNotBlank(firstName) && String.isNotBlank(lastName)) {
            name = lastName + ', ' + firstName;
        } else if (String.isNotBlank(firstName)) {
            name = firstName;
        } else if (String.isNotBlank(lastName)) {
            name = lastName;
        }

        return name;
    }

	public static String formatDate(Date d, String format) {
        return (d == null ? null : DateTime.newInstance(d.year(), d.month(), d.day()).format(format));
    }


    global class Plan {

        global String contractCode {get; set;}
        global String planName {get; set;}
        global String planType {get; set;}
        global String productType {get; set;}

    }

    global class Agent {

        global String paidAgentName {get; set;}
        global String paidAgentTin {get; set;}
        global String parentAgentName {get; set;}
        global String parentAgentTin {get; set;}
        global String writingAgentName {get; set;}
        global String writingAgentTin {get; set;}

    }

	global class CompanyInformation {

        global List<Address> addresses {get; set;}
        global ContactDetails contactDetails {get; set;}

    }

	global class Address {

        global String city {get; set;}
        global String state {get; set;}
        global String streetAddress {get; set;}
        global String type {get; set;}
        global String zip {get; set;}

    }

	global class ContactDetails {

        global String contactEmailAddress {get; set;}
        global String contactName {get; set;}
        global String faxNumber {get; set;}
        global String primaryPhone {get; set;}

    }

}