/* ***************************************************************************
@description : Test Class for OEAmbVolCountTallyFields. This gets called from the Visualforce component 'QLISoleraComponent' to get the Quote Line item field values for the provided QLI record id. 
@Author               : X-men Offshore
US                        : Modified Test class as part of PRDCRM-41975
Class Name   : QLISoleraTemplateController
Date Created : 27-NOV-2018
Created By   : XMEN-Poonam/Swetha
User Story:PRDCM-25413 
@comment      : Modified Test class as part of PRDCRM-41975
******************************************************************************* */
public with sharing class QLISoleraTemplateController {
  
  // @comment     : getters and setters for accTeamRole which we are using for Implementer details .
  Public List<Accountteammember> accTeamRole{ get; set;}
  
  //@comment      : getters and setters for QuoteLineItem values which we are providong to template .
  Public List<QuoteLineItem> qliRec;
  
  // @comment      : getters and setters for qliId , Id which we are getting from template and returing QLI values back based on this id
  Public Id qliId{ get;set;}  
  
  // @comment      : Method which is returning Quote Line Item values and Implementer user details to template based on the Id provided 
  Public List<QuoteLineItem> getqliRec()
    {
        Id accId;
        //List<QuoteLineItem> qliRec;
        qliRec=new List<QuoteLineItem>();
        qliRec= [SELECT Id,Description,Quote.AccountId,Quote.Account.Name,Prefix_for_Client_Account__c,Quote.Account.NASCO_Contracting_Situs_State__c,Quote.Account.WGS_Contracting_Situs_State__c,Financing__c,Primary_Point_of_Contact__r.Name,Primary_Point_of_Contact__r.Email,Primary_Point_of_Contact__r.Phone,Primary_Point_of_Contact__r.Title,Marketing_outreach__c,Anthem_Account_Manager__r.Name,Anthem_Account_Manager__r.Email,Anthem_Account_Manager__r.Phone,Anthem_Account_Manager__r.Title,Anthem_Account_Manager__r.UserRole.name,Quote.Opportunity.Closedate,Other_Notes__c,Geography_of_the_Population__c,Early_Retiree_Population_Covered__c,Members_Covered__c FROM QuoteLineItem WHERE id =: qliId Limit 1];
        for(QuoteLineItem q:qliRec)
        {
            accId=q.Quote.AccountId;
        }
        accTeamRole = [SELECT id,User.Name,User.Email,User.Phone,User.Title,User.UserRole.name,TeamMemberRole from AccountTeamMember where AccountID =:accId and TeamMemberRole='Implementer' limit 1];
        return qliRec;
    }
}