/* ****************************************************************************************************
Class Name   : DNCAttachmentCountOnDelete 
Date Created : 19-APR-2018
Created By   : Deloitte USI
Description  : Trigger that fires on before delete, before update and after update of DNC Preference 
****************************************************************************************************** */
trigger DNCPreferenceTrigger on DNC_Preferences__c (before delete, before update, after update) {
  
  if(Trigger.isBefore) {
    if(Trigger.isUpdate) {
      if(DNC_DNCPreferencesHandler.onBeforeUpdateIsFirstRun) {
        DNC_DNCPreferencesHandler.onBeforeUpdateIsFirstRun = false;
        DNC_DNCPreferencesHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
      }
    }
  } 
  if(Trigger.isAfter) {
    if(Trigger.isUpdate) {
      if(DNC_DNCPreferencesHandler.onAfterUpdateIsFirstRun) {
        DNC_DNCPreferencesHandler.onAfterUpdateIsFirstRun = false;
        DNC_DNCPreferencesHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
      }
    }
  }
  
   if(Trigger.isBefore) {
    if(Trigger.isDelete) {
      if(DNC_DNCPreferencesHandler.onBeforeDeleteIsFirstRun) {
        DNC_DNCPreferencesHandler.onBeforeDeleteIsFirstRun = false;
        DNC_DNCPreferencesHandler.onBeforeDelete(Trigger.old, Trigger.oldMap);
      }
    }
  }
}