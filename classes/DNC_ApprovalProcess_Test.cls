/****************************************************************
Class Name   : DNC_ApprovalProcess_Test
Date Created : 20-Apr-2018
Created By   : Deloitte USI
Description  : Test class for DNC_ApprovalProcess 
*****************************************************************/
@isTest
private class DNC_ApprovalProcess_Test{
  
  static testMethod void testApproval() {
    Account acct = new Account(Name = staticVariableClass.DNCTstAcc);
    acct.Situs_State__c = staticVariableClass.DNCTstAccState;
    acct.Anthem_Entity__c= staticVariableClass.DNCTstEntity;
    acct.BillingStreet = staticVariableClass.testAccBillingStreet;
    acct.BillingPostalCode= staticVariableClass.testAccBillingPostalCode;
    acct.BillingCity = staticVariableClass.testAccBillingCity;
    acct.BillingCountry =  staticVariableClass.testAccBillingCountry;
    acct.BillingState = staticVariableClass.testAccBillingState;
    acct.Physical_County__c = staticVariableClass.testAccBillingCity;    
    acct.Mailing_Address_Same_as_Physical_Address__c = true;
    acct.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();
    insert acct;
    
    DNC_Preferences__c dncPref = new DNC_Preferences__c(AccountDNC__c = acct.Id);
    insert dncPref;
    
    Account acct2 = new Account(Name = staticVariableClass.DNCTstAcc2);
    insert acct2;
    
    DNC_Preferences__c dncPref2 = new DNC_Preferences__c(AccountDNC__c = acct2.Id);
    insert dncPref2;
    map<String,object> inputMap = new map<String,object>();
    map<String,object> outputMap = new map<String,object>();
    map<String,object> optns= new map<String,object>();
    inputMap.put('DRId_DNC_Preferences__c',dncPref.id);
    Test.startTest();
   /* DNC_ApprovalProcess.DNC_CallApprovalProcess(dncPref.id);
    DNC_ApprovalProcess.DNC_CallApprovalProcess(dncPref2.id);*/
    DNC_ApprovalProcess Dnc = new DNC_ApprovalProcess();
    Boolean v = Dnc.invokeMethod('DNC_CallApprovalProcess',inputMap ,outputMap ,optns);
    inputMap.put('DRId_DNC_Preferences__c',dncPref2.id);
    Boolean v2 = Dnc.invokeMethod('DNC_CallApprovalProcess',inputMap ,outputMap ,optns);
    Test.stopTest();
    }
  }