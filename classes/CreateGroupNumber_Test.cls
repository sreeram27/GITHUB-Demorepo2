/*
@author         Deloitte offshore
@date           29/03/2018
@name           CreateGroupNumber_Test
@description    Used in vlocity omniscript to Generate Group Number for Group record.
@LastModifiedDate 28Sept2018
*/
@isTest
private class CreateGroupNumber_Test
{
    
    private static final String GETGROUPNUMBER = staticVariableClass.CreateGrpGETGROUPNUMBER;
    private static final String UPDATENEXTNUMBERUTILITY =  staticVariableClass.CreateGrpUPDATENEXTNUMBERUTILITY;
    private static final string REQUESTGROUPNUMBERSTEP = staticVariableClass.CreateGrpREQUESTGROUPNUMBERSTEP;
    private static final string ACCTID = staticVariableClass.CreateGrpACCTID;
    
    /*Below method inserts sample data*/
    @testsetup
    static void createData()
    {
        Account A =new Account
        (
            RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
            Name= staticVariableClass.AccountName,
            Account_s_Suppress_Auto_Renewal__c = false,
            Anthem_Entity__c = staticVariableClass.Entity,
            Region__c= staticVariableClass.Region,
            Branding__c =staticVariableClass.UniCare,
            Group_Size__c =staticVariableClass.size,
            Total_Employees__c =staticVariableClass.emp,
            HQ_State__c =staticVariableClass.AK,
            Situs_State__c = staticVariableClass.California,
            Mailing_Address_Same_as_Physical_Address__c = true,
            BillingStreet = staticVariableClass.testAccBillingStreet,
            BillingPostalCode= staticVariableClass.testAccBillingPostalCode ,
            BillingCity = staticVariableClass.testAccBillingCity ,
            BillingCountry =  staticVariableClass.testAccBillingCountry ,
            BillingState = staticVariableClass.testAccBillingState ,
            Physical_County__c = staticVariableClass.testAccBillingCity
        );
        insert A;
        
        insert new list<Group__c>{  new Group__c(Name = staticVariableClass.TBD, Account__c = A.ID), 
                                    new Group__c(Name = staticVariableClass.GroupNum, Account__c = A.ID)};
        
        insert new Next_Number_Utility__c(Name = staticVariableClass.California, Last_Number_Used__c = 100, Max_Value__c = 500);
        insert new Next_Number_Utility__c(Name = staticVariableClass.Georgia, Last_Number_Used__c = 999, Max_Value__c = 999,Current_State_Prefix__c = 'GB');
    }
    
    /*Below method is to invoke the CreateGroupNumber with the data inserted*/
    public static testMethod void CreateGroupNumber_Test_1()
    {
        Account A = [select ID,Situs_State__c,RecordTypeId from Account where Name =:staticVariableClass.AccountName limit 1];
        list<Group__c> GroupList = [select ID,Name from Group__c where Name IN ('TBD', '123')];
        
        map<String,Object> inputMap = new map<String,Object>();
        inputMap.put(ACCTID, A.ID);
        inputMap.put(REQUESTGROUPNUMBERSTEP, new map<String, Object>());
        
        CreateGroupNumber C = new CreateGroupNumber();
        C.invokeMethod(GETGROUPNUMBER, inputMap, new map<String,Object>(), null);
        C.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new map<String,Object>(), null);
        
        A.Situs_State__c = staticVariableClass.Indiana;
        update A;
        
        C.invokeMethod(GETGROUPNUMBER, inputMap, new map<String,Object>(), null);
        C.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new map<String,Object>(), null);
        
         A.Situs_State__c = staticVariableClass.Georgia;
         update A;
        
        C.invokeMethod(GETGROUPNUMBER, inputMap, new map<String,Object>(), null);
        C.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new map<String,Object>(), null);
    }
}