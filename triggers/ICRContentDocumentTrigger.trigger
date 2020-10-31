/**
 * @File Name          : ICRContentDocumentTrigger.trigger
 * @Description        :  Associating ICR RateSheets with the Account
 * @Author             : Raptors Onshore
 * @Group              : Raptor
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2/18/2020, 10:16:54 AM
 * @Modification Log   : 
 * Ver       Date            Author      Modification
 * 1.0    2/12/2020   Raptors Onshore    Initial Version
**/
trigger ICRContentDocumentTrigger on ContentDocumentLink (after insert) {

  boolean isDisabled = false;
//Get the custom setting value and assign the flag value
  Trigger_Settings__c ts  = Trigger_Settings__c.getInstance('ICRContentDocumentTriggerDisable');
  if(ts != null){
    isDisabled = ts.Disable_Trigger__c;
  }

//Execute accountDocumentLink if the trigger is not disable
  if(!isDisabled){
    if(Trigger.isAfter && Trigger.isInsert){
        ICRContentDocumentTriggerHandler.accountContentDocumentLink(ICRContentDocumentTriggerHandler.getOrderId(trigger.new));
  
    }
  }
}