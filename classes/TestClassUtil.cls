@isTest
public class TestClassUtil {
    public static void loadEnvironmentVariables(){
        List<SObject> SObjectList=new List<SObject>();
        // create custom settings data required for running test classes
        SObjectList.add(new Custom_Clone_Setting__c (Name='1',Default_Child_Elements__c ='CaseComment,ContentDocumentLink,EmailMessage', Show_UI_Child_Element_Selector__c =false, Pre_Clone_Parent_Object_Processor__c='PreCloneHandlerParentCaseImpl', Pre_Clone_Children_Processor__c ='PreCloneHandlerCaseChildrenImpl'));
        insert SObjectList;
    }
    public static sObject getsObjectInstance(Schema.SObjectType sobjType,Map<Schema.sObjectField,Object> FieldValueMap,String RecordTypeName){
        sObject sObj=Schema.getGlobalDescribe().get(sobjType.getDescribe().getName()).newSObject();
        for(Schema.sObjectField fieldApiName : FieldValueMap.keyset())
            sObj.put(fieldApiName,FieldValueMap.get(fieldApiName));
        if(RecordTypeName!=NULL)
            sObj.put('RecordTypeId',Schema.getGlobalDescribe().get(sobjType.getDescribe().getName()).getDescribe().getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeID());
        return sObj;
    }
}