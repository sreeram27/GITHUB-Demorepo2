/****************************************************************
Class Name   : DNC_AttachmentHandler
Date Created : 18-APR-2018
Created By   : Deloitte USI
Modifications: Modified the class for PRDCRM- 31735 - OE changes - XMen 193.3 sprint.
Description  : DNC Handler class for Attachment Triggers
*****************************************************************/
public class DNC_AttachmentHandler {

  public static boolean onAfterInsertIsFirstRun = true;
  public static boolean onAfterDeleteIsFirstRun = true;

  public static void onAfterInsert(List<ContentDocumentLink> attList) {
    
	//Existing code - below	
    updateDNCAttachmentCount(attList);
  }

  public static void onAfterDelete(List<ContentDocument> attList) {
    updateDNCAttachmentCountDel(attList);
  } 
  /*
    Method Name : updateDNCAttachmentCount
    Parameter   : List<ContentDocumentLink>
    Return type : none
    Description : This method is used to update attachment count field when any attachment is added to DNC Preference  
    */
  public static void updateDNCAttachmentCount(List<ContentDocumentLink> attList) {
    try{        
        //Get all the ParentIds from the Attachment list
        Set<Id> attParentIds = new Set<Id>();
        Set<Id> oeMeetID = new Set<Id> ();
        for(ContentDocumentLink a : attList) {
          attParentIds.add(a.LinkedEntityId);
          //Below IF for Open Enrollment Meeting - PRDCRM- 31735          
          If(a.LinkedEntityId.getSobjectType() == Open_Enrollment_Meetings__c.SobjectType)  {
                oeMeetID.add(a.LinkedEntityId);
            }
        } 
        //List to get all OEMeeting record - XMen | Open Enrollment -- PRDCRM- 31735 - START
        List <Messaging.SingleEmailMessage> attachNotification = new List <Messaging.SingleEmailMessage> ();
        List <Open_Enrollment_Meetings__c> oeMeetingList = [Select Id, OE_Coordinator_Contact__c, OE_Coordinator_Contact__r.Email from Open_Enrollment_Meetings__c Where ID in: oeMeetID];
        EmailTemplate template = [SELECT Id,Body,Subject FROM EmailTemplate WHERE DeveloperName = 'OEMeeting_Attachment_Notification' AND IsActive = true Limit 1];
        for(Open_Enrollment_Meetings__c oeMRec : oeMeetingList){
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(template.id, oeMRec.OE_Coordinator_Contact__c, oeMRec.Id);                       
            String[] toAddresses = new String[] {oeMRec.OE_Coordinator_Contact__r.Email}; 
			String  subject = email.getSubject();
			String body = email.gethtmlBody();
			email.setTargetObjectId(oeMRec.OE_Coordinator_Contact__c);
            email.setToAddresses(toAddresses);
			email.setSubject(subject);
			email.sethtmlBody(body);
			email.saveAsActivity = false;
            email.setSenderDisplayName('Open Enrollment');
			attachNotification.add(email);                
        }
        if(!attachNotification.isEmpty()) {           
                Messaging.sendEmail(attachNotification);
        } 
        //List to get all OEMeeting record - XMen | Open Enrollment -- PRDCRM- 31735 --END
        // Get all DNC Preferences related to the attachment list
        List<DNC_Preferences__c> dncPrefList = [SELECT Id, (Select Id from ContentDocumentLinks ) from DNC_Preferences__c where ID in : attParentIds];
        List<DNC_Preferences__c> dncPreflst = new List<DNC_Preferences__c>();   
        for(DNC_Preferences__c dncPref : dncPrefList) {
          // Set Attachment_Count__c field with the number of retrieved Attachments
          dncPref.Attachment_Count__c = dncPref.ContentDocumentLinks.size();
          dncPreflst.add(dncPref);
        }
            
        if(dncPreflst.size() > 0) {
          //update DNC Pref records
          update dncPreflst;
        }
    }catch(Exception excn){
       System.debug('Exception'+excn.getMessage()); 
    }
  }
   /*
    Method Name : updateDNCAttachmentCountDel
    Parameter   : List<ContentDocument>
    Return type : none
    Description : This method is used to update attachment count field when any attachment is deleted from DNC Preference  
    */
    public static void updateDNCAttachmentCountDel(List<ContentDocument> attList) {
    try{
        Set<Id> setConDocId = new Set<Id>();
        map<Id,Id> mapDNCPrefIdConDocLink = new map<Id,Id>();
        map<Id,Id> mapConLinkConDoc = new map<Id,Id>();
    
        for(ContentDocument c:attList){
          setConDocId.add(c.id);
        } 
        
        List<ContentDocumentLink> lstConDocLink =[SELECT id, LinkedEntityId,ContentDocumentId  FROM ContentDocumentLink WHERE ContentDocumentId IN: setConDocId]; 
    
        //Get all the ParentIds from the Attachment list
        Set<Id> attParentIds = new Set<Id>();
        for(ContentDocumentLink a : lstConDocLink) {
          attParentIds.add(a.LinkedEntityId);  
        }
      
        // Get all DNC Preferences related to the attachment list
        List<DNC_Preferences__c> DncPrefList = [SELECT Id, (Select Id from ContentDocumentLinks ) from DNC_Preferences__c where ID in : attParentIds];
        List<DNC_Preferences__c> DncPrefListDel = [SELECT Id, (Select Id from ContentDocumentLinks WHERE ContentDocumentId  IN: setConDocId) from DNC_Preferences__c where ID in : attParentIds];
        
        System.debug('@@@@DncPrefList'+DncPrefList );
        System.debug('@@@@DncPrefListDel'+DncPrefListDel);
        
        map<id,Integer> mapDncPrefConDocDelSize= new  map<id,Integer>();
            
        for(DNC_Preferences__c dncPrefDel: DncPrefListDel){
        mapDncPrefConDocDelSize.put(dncPrefDel.id,dncPrefDel.ContentDocumentLinks.size());
        }
        
        System.debug('@@@@mapDncPrefConDocDelSize'+mapDncPrefConDocDelSize);
        List<DNC_Preferences__c> dncPreflst = new List<DNC_Preferences__c>();   
         
        for(DNC_Preferences__c dncPref : DncPrefList) {
          // Set Attachment_Count__c field with the number of retrieved Attachments
          dncPref.Attachment_Count__c = dncPref.ContentDocumentLinks.size() - mapDncPrefConDocDelSize.get(dncPref.id);
          dncPreflst.add(dncPref);
        }
         System.debug('@@@dncPreflst'+dncPreflst);
        if(dncPreflst.size() > 0) {
          //update DNC Pref records
          update dncPreflst;
        }
    }
        catch(Exception excn){
       System.debug('Exception'+excn.getMessage()); // changed as part of Code Coverage fix
    }
  }
    
   
}