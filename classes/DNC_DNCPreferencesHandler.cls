/****************************************************************
Class Name   : DNC_DNCPreferencesHandler
Date Created : 19-APR-2018
Created By   : Deloitte USI
Description  : DNC Handler class for DNCPreferenceTrigger
*****************************************************************/
public with sharing class DNC_DNCPreferencesHandler {

    public static boolean onAfterUpdateIsFirstRun = true;
    public static boolean onBeforeUpdateIsFirstRun = true;
    public static boolean onBeforeDeleteIsFirstRun = true;

    public static void onBeforeUpdate(List<DNC_Preferences__c> dncList, Map<Id, DNC_Preferences__c> oldMap) {
        requireAttachmentIfApproved(dncList, oldMap);
    }

    public static void onAfterUpdate(List<DNC_Preferences__c> dncList, Map<Id, DNC_Preferences__c> oldMap) {
        updateParentAccount(dncList, oldMap);
    }
    
    public static void onBeforeDelete(List<DNC_Preferences__c> dncList, Map<Id, DNC_Preferences__c> oldMap) {
        updateParentAccountPref(dncList, oldMap);
    }

    /*
    Method Name : requireAttachmentIfApproved
    Parameter   : List<DNC_Preferences__c>, Map<Id, DNC_Preferences__c>
    Return type : none
    Description : This method is used validate that a DNC Approval record has attached documentation before every approval
   */
    public static void requireAttachmentIfApproved(List<DNC_Preferences__c> dncList, Map<Id, DNC_Preferences__c> oldMap) {
        for(DNC_Preferences__c dnc : dncList) {
            //Check if status is updated
            if(dnc.Status__c != oldmap.get(dnc.Id).Status__c) {
                //Check if new status is 'Approved'
                if(('Approved').equalsIgnoreCase(dnc.Status__c)) {
                    if(dnc.Attachment_Count__c == null || dnc.Attachment_Count__c < 1) {
                        dnc.addError(staticVariableClass.DNCError);
                    }
                }
            }
        }
    }

   /*
    Method Name : updateParentAccount
    Parameter   : List<DNC_Preferences__c>, Map<Id, DNC_Preferences__c>
    Return type : none
    Description : This method is used to update DNC Preferences fields on the DNC Preferences records' parent Account records
    */
     public static void updateParentAccountPref(List<DNC_Preferences__c> dncList, Map<Id, DNC_Preferences__c> oldMap) {
       try{
            //Set to hold all the accounts record IDs to be retrieved and updated
            Set<Id> acctIds = new Set<Id>();
            //Map of account IDs and their related DNC Preferences record
            Map<Id, DNC_Preferences__c> acctDNCMap = new Map<Id, DNC_Preferences__c>(); 
    
            for(DNC_Preferences__c dnc : dncList) {
                if(('Pending Approval').equalsIgnoreCase(dnc.Status__c) || ('Pending Submission - Need Attachment').equalsIgnoreCase(dnc.Status__c)) {
                    acctIds.add(dnc.AccountDNC__c);
                }
            }
            
            List<Account> accts = [SELECT Id, DNC_Preference_ID__c 
                                        FROM Account 
                                        WHERE Id in :acctIds];     
            
            for(Account a : accts) {
                //set DNC Preferences ID field to blank, to indicate that the record has already been processed
                a.put('DNC_Preference_ID__c','');// changed as part of Code Coverage fix
               // a.DNC_Preference_ID__c = ''; 
            }
    
            //update Account records
            if(!accts.isEmpty()) {
                update accts;
            }
        }
        catch(Exception e){
          System.debug('Exception'+e.getMessage());
        }
        
    }
  
    /*
    Method Name : updateParentAccount
    Parameter   : List<DNC_Preferences__c>, Map<Id, DNC_Preferences__c>
    Return type : none
    Description : This method is used to update DNC Preferences fields on the DNC Preferences records' parent Account records
    */
     public static void updateParentAccount(List<DNC_Preferences__c> dncList, Map<Id, DNC_Preferences__c> oldMap) {
       try{
            //Set to hold all the accounts record IDs to be retrieved and updated
            Set<Id> acctIds = new Set<Id>();
            //Map of account IDs and their related DNC Preferences record
            Map<Id, DNC_Preferences__c> acctDNCMap = new Map<Id, DNC_Preferences__c>(); 
            for(DNC_Preferences__c dnc : dncList) {
                //Check if status is updated
                if(dnc.Status__c != oldmap.get(dnc.Id).Status__c) {                    
                    //Check if new status is 'Approved' or 'Rejected' - indicates that the record is being approved/rejected
                    if(('Approved').equalsIgnoreCase(dnc.Status__c) || ('Rejected').equalsIgnoreCase(dnc.Status__c) || ('Recalled').equalsIgnoreCase(dnc.Status__c)) {
                      //add to account ID list
                        acctIds.add(dnc.AccountDNC__c);
                        //add to Account-DNC map
                        acctDNCMap.put(dnc.AccountDNC__c, dnc);
                    }
                }
            }
           
            List<Account> accts = [SELECT Id, DNC_Preference_ID__c 
                                        FROM Account 
                                        WHERE Id in :acctIds];                        
            DNC_Preferences__c dnc = null;
            
            for(Account a : accts) {
                //set DNC Preferences ID field to blank, to indicate that the record has already been processed
                //a.DNC_Preference_ID__c = ''; 
                a.put('DNC_Preference_ID__c',''); 
    
                //retrieve the related DNC record for the account
                dnc = acctDNCMap.get(a.Id);
                //if DNC Preferences status is 'Approved', copy all DNC fields to the Account
                if(('Approved').equalsIgnoreCase(dnc.Status__c)) {
                    a.DNC__c                        = dnc.DNC__c;
                    a.DNC_Effective_Date__c         = dnc.DNC_Effective_Date__c;
                    a.DNC_Reason__c                 = dnc.DNC_Reason__c;
                    a.Group_Preference_Comment__c   = dnc.Group_Preference_Comment__c;
                    a.Requested_By__c               = dnc.Requested_By__c;
                }
            }
    
            //update Account records
            if(!accts.isEmpty()) {
                update accts;
            }
        }
        catch(Exception e){
          System.debug('Exception'+e.getMessage());
        }
        
    }
}