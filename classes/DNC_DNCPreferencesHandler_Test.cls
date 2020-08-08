/****************************************************************
Class Name   : DNC_DNCPreferencesHandler_Test
Date Created : 24-Apr-2018
Created By   : Deloitte USI
Description  : Test class for DNC_DNCPreferencesHandler 
*****************************************************************/
@isTest
private class DNC_DNCPreferencesHandler_Test {
  
     // test before and after update
    @isTest
    static void test_update() {
        List<Account> accList = new List<Account>();
        Account acct = new Account(Name = staticVariableClass.DNCTstAcc);
         accList.add(acct);
        insert accList;
        
        List<DNC_Preferences__c> dncList = new List<DNC_Preferences__c>();
         DNC_Preferences__c dncPref = new DNC_Preferences__c(AccountDNC__c = acct.Id);
         dncPref.Status__c = staticVariableClass.DNCStatusNew;
         dncPref.Group_Preference_Comment__c = staticVariableClass.DNCStrGrpPref;
         dncPref.DNC_Effective_Date__c = Date.Today() + 1;
         dncPref.DNC__c = staticVariableClass.DNCStrGrp;
         dncPref.Requested_By__c = staticVariableClass.DNCStrAccManager;
         dncPref.DNC_Reason__c = staticVariableClass.DNCStrEmpPref;
         dncPref.Attachment_Count__c = 2;
         dncList.add(dncPref);
         insert dncList;
        
        accList[0].DNC_Preference_ID__c = dncList[0].Id;
        update accList[0];
        
        test.StartTest();
        
        DNC_DNCPreferencesHandler.onBeforeUpdateIsFirstRun = true;
        DNC_DNCPreferencesHandler.onAfterUpdateIsFirstRun = true;
        dncList[0].Status__c = staticVariableClass.DNCStatusApproved;
        update dncList;
        test.StopTest();
}
//test before delete
@isTest
    static void test_delete() {
        List<Account> accList = new List<Account>();
        Account acct = new Account(Name = staticVariableClass.DNCTstAcc);
         accList.add(acct);
        insert accList;
        
        List<DNC_Preferences__c> dncList = new List<DNC_Preferences__c>();
         DNC_Preferences__c dncPref = new DNC_Preferences__c(AccountDNC__c = acct.Id);
         dncPref.Status__c = staticVariableClass.DNCStatusPen;
         dncPref.Group_Preference_Comment__c = staticVariableClass.DNCStrGrpPref;
         dncPref.DNC_Effective_Date__c = Date.Today() + 1;
         dncPref.DNC__c = staticVariableClass.DNCStrGrp;
         dncPref.Requested_By__c = staticVariableClass.DNCStrAccManager;
         dncPref.DNC_Reason__c = staticVariableClass.DNCStrEmpPref;
         dncPref.Attachment_Count__c = 2;
         dncList.add(dncPref);
         insert dncList;
        
        test.StartTest();
        DNC_DNCPreferencesHandler.onBeforeDeleteIsFirstRun= true;
        delete dncList;
        test.StopTest();
}
}