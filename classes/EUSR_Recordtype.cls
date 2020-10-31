public class EUSR_Recordtype {
 @AuraEnabled
    public static string EUSR_Recordtypes(Id recTypeId)
    {
        
       return Schema.SObjectType.Support_Request__c.getRecordTypeInfosById().get(recTypeId).getname();
        
    }
}