@isTest
public class EUSR_Recordtype_Test {
static testMethod void EUSR_Recordtype_Test()
    {
        Id RecordTypeId = Schema.SObjectType.Support_Request__c.getRecordTypeInfosByName().get('User Access Request').getRecordTypeId();
        EUSR_Recordtype.EUSR_Recordtypes(RecordTypeId);
        
    }
}