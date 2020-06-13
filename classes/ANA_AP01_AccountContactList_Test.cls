/**
@Author : Accenture Offshore Dev team
@name : ANA_AP01_AccountContactList_Test
@CreateDate :05-05-2017
@Description : This class is test class for ANA_AP01_AccountContactList class. 
checks for positive and negative cases.
*/
@isTest
private class ANA_AP01_AccountContactList_Test
{
    private static final string RECTYPENAME='Customer';
    private static final string NATIONALAMPROFILE='National Sales';
    /*This method will create an account with contacts and invokes the populatepiclist*/  
    static testMethod void popPickListWithNationalAM() {
        // Setup test data
        // This code runs as the system user
        
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1 ]; 
        
        
        system.runAs(ANA_UTIL01_TestMethods.runAsUser(profileNA.id))
        {
            SIC__C sic=ANA_UTIL01_TestMethods.createSIC(false);
            Account acc=ANA_UTIL01_TestMethods.createAccount(false);
            Id recdTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account',RECTYPENAME);
            Map<String,Object> inputmap=new Map<String,Object>();
            Map<String,Object> outputmap=new Map<String,Object>();
            Map<String,Object> options=new Map<String,Object>();
            String methodName='populatePicklist';           
            outputmap.put('error','OK');
            options.put('useQueueableApexRemoting',true);   
            
            Test.starttest();
            database.insert(sic);            
            acc.SIC__c=sic.Id;
            acc.RecordTypeId=recdTypeId;
            database.insert(acc);
            inputmap.put('ContextId',acc.Id);
            ANA_UTIL01_TestMethods.createContacts(10,true,acc.Id);          
            Test.stopTest();    
            ANA_AP01_AccountContactList actct=new ANA_AP01_AccountContactList();
            Boolean actual= actct.invokeMethod(methodName,inputmap,outputmap,options);           
            system.assertEquals(true, actual);           
        }
    }
    /*This method will throgh an exception as we are passing empty account id*/    
    static testMethod void popPickListWithError() {
        // Setup test data
        // This code runs as the system user      
        Profile profileAM = [select id from profile where name='National Sales' limit 1];  
        system.runAs(ANA_UTIL01_TestMethods.runAsUser(profileAM.id))
        {
            Map<String,Object> inputmap=new Map<String,Object>();
            Map<String,Object> outputmap=new Map<String,Object>();
            Map<String,Object> options=new Map<String,Object>();
            String methodName='populatePicklist';
            inputmap.put('ContextId','');
            outputmap.put('error','OK');
            options.put('useQueueableApexRemoting',true);
            ANA_AP01_AccountContactList actct=new ANA_AP01_AccountContactList();
            Boolean actual= actct.invokeMethod(methodName,inputmap,outputmap,options);
            system.assertEquals(true, actual);
            
        }
    }
    
}