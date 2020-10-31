@isTest
public class UPS_TestDataFactory {
    
    public static Account createAccount(boolean isInsert) {
        Account acc= new Account(
        Name = 'TestAccount',
        TAX_ID__c = '12345',
        Phone = '(123) 456-7890' );
        
        if(isInsert) insert acc;
        return acc;
    }
    
    public static List<Open_Enrollment_Meetings__c> createOEMeetings (Integer num, Account acct, boolean isInsert) {
        List<Open_Enrollment_Meetings__c> meetingList = new List<Open_Enrollment_Meetings__c>();
        for(Integer i = 0; i < num; i++) {
            Open_Enrollment_Meetings__c oem = new Open_Enrollment_Meetings__c(
                Name = 'Test Open Enrollment Meeting ' + i,
                Plan_Type__c = 'ANC - AD&D',
                Account__c = acct.Id
            );
            meetingList.add(oem);
        }
        
        if(isInsert) {
            insert meetingList;
        }
        return meetingList;
    }    
    
    public static List<SFDC_Volunteer_Event__c> createOpenEnrollments(Integer num, Open_Enrollment_Meetings__c oe_meeting, boolean isInsert) {
        List<SFDC_Volunteer_Event__c> oeList = new List<SFDC_Volunteer_Event__c>();
        for(Integer i = 0; i < num; i++) {
            SFDC_Volunteer_Event__c oe = new SFDC_Volunteer_Event__c(
                Name = 'Test Open Enrollment ' + i,
                OE_Grouping__c = oe_meeting.Id,Date__c=System.Today(),Meeting_Type__c='Benefit Fair',Recruitment_of_Facilitator_Needed__c='Yes'
            );
            oeList.add(oe);
        }
        
        if(isInsert) {
            insert oeList;
        }
        return oeList;
    }
    
    public static List<OE_Order__c> createOrders(Integer num, SFDC_Volunteer_Event__c oe, boolean isInsert) {
        List<OE_Order__c> orderList = new List<OE_Order__c>();
        for(Integer i = 0; i < num; i++) {
            OE_Order__c oeOrder = new OE_Order__c(
                Open_Enrollment__c = oe.Id
            );
            orderList.add(oeOrder);
        }
        
        if(isInsert) {
            insert orderList;
        }
        return orderList;
    }
    
    public static List<Order_Fulfillment__c> createOrderFulfillments(Integer num, OE_Order__c ord, boolean isInsert) {
        List<Order_Fulfillment__c> ofList = new List<Order_Fulfillment__c>();
        for(Integer i = 0; i < num; i++) {
            Order_Fulfillment__c ordFul = new Order_Fulfillment__c(
                Carrier__c = 'UPS',
                Order__c = ord.Id
            );
            ofList.add(ordFul);
        }
        
        if(isInsert) {
            insert ofList;
        }
        return ofList;
    }
}