/*****
 * ------------------------------------------------------------------------------------------------------------------------------
 * Name   CurrentUserInfoCtrl
 * Author  Sreeman Jannu
 * CreatedDate  05/18/2019
 * Used by       VolunteerCmp
 * -----------------------------------------------------------------------------------------------------------------------------
 * Description     
 * This control will retrive logged in user Contact details and determine the environment to pass back to Component
 * 
 * ---------------------------------------------------------------------------------------------------------------------------
 **/
public with sharing class CurrentUserInfoCtrl {
   @AuraEnabled 
     public static contact fetchContact(){
         List<Contact> ContactList = new List<Contact>();
          List<Contact> lstcontact = [select id, Email,OE_AMB_FacilitatorID__c from contact where Email = : userInfo.getUserEmail() and OE_AMB_FacilitatorID__c != null LIMIT 1];
          if(!lstcontact.isEmpty()){
           ContactList.add(lstcontact[0]);
           
          }
         return ContactList[0];
    }
    @AuraEnabled 
     public static string fetchOrg(){
        Organization lstorg = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        String Env;
         
        Env = (lstorg.IsSandbox == true) ? 'sandbox' : 'production';
         
         return Env;
    }
}