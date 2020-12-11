/**************************************************************************************
Class Name: AlphaPrefixRequestTriggerHandler  
Current Version     : 2.0 
Created Date    : 7 May 2019
@Author: Neha Prasad ,Legato 
@UStory: PRDCRM-32826    
Function    : Class to send the email notiification to Team members of role 'Account Executive','Account Manager','Underwriter'.


Change Logs :
Date              Modified By           User Story           Remarks
9 July 2019       Partha Baruah         PRDCRM-37163         Added Team Member roles :: AE Support Rep;AM Support Rep

****************************************************************************************************************************/ 

public class AlphaPrefixRequestTriggerHandler {
    
    
    static LG_Op_Helper__mdt mdtRoles=[select LG_Field_Value__c from LG_Op_Helper__mdt where DeveloperName='APR_Account_Roles']; // Contains list of relevant Account Team Roles: Account Executive;Account Manager;Underwriter;AE Support Rep;AM Support Rep
    
    static List <String>  accountTeamMemberRoles = mdtRoles.LG_Field_Value__c.split(';'); 
    
    static LG_Op_Helper__mdt mStatus=[select LG_Field_Value__c from LG_Op_Helper__mdt where DeveloperName='APR_Status']; // relevant Status for APR on which emails are triggered i.e. Request Complete;Prefix Assigned
    
    static List <String> APRStatusSet = mStatus.LG_Field_Value__c.split(';'); 
    
    
    
    public static void afterInsertCall() {
        sendEmailNotifications((Map<Id,Alpha_Prefix_Request__c>)Trigger.newMap);
    }
    
    
    public static void afterUpdateCall() {
        sendEmailNotifications((Map<Id,Alpha_Prefix_Request__c>)Trigger.oldMap, (Map<Id,Alpha_Prefix_Request__c>)Trigger.newMap);
    }
    
    /**
* @description Send Email Notifications to Account team members of Account assoicated with Alpha Requests 
*              with status as 'Request Complete' or 'Prefix Assigned'
* @param       Trigger.NewMap
* @return      void
*/                 
    public static void sendEmailNotifications(Map<Id,Alpha_Prefix_Request__c> updateRequestMap) {
        Map<Id,Id> alphaPrefixRequestToAccountId = new Map<Id,Id>();
        List<Alpha_Prefix_Request__c> requestsNeedEmailAlert = new List<Alpha_Prefix_Request__c>();
        for(Id alphaPrefixRequestId: updateRequestMap.keySet()) {
            Alpha_Prefix_Request__c alphaPrefixRequest = updateRequestMap.get(alphaPrefixRequestId);
            
            if(APRStatusSet.contains(alphaPrefixRequest.Status__c)) {    // checks if alphaPrefixRequest.Status__c = 'Request Complete' OR 'Prefix Assigned'
                alphaPrefixRequestToAccountId.put(alphaPrefixRequest.Id,alphaPrefixRequest.Account__c);
                requestsNeedEmailAlert.add(alphaPrefixRequest);
            }
        }
        sendEmailMessages(requestsNeedEmailAlert, alphaPrefixRequestToAccountId);
    }
    
    /**
* @description Send Email Notifications to Account team members of Account assoicated with Alpha Requests
*              with Status Update as 'Request Complete' or 'Prefix Assigned' 
* @param       Trigger.oldMap
* @param       Trigger.newMap
* @return      void
*/
    public static void sendEmailNotifications(Map<Id,Alpha_Prefix_Request__c> oldRequestMap, Map<Id,Alpha_Prefix_Request__c> updateRequestMap) {
        Map<Id,Id> alphaPrefixRequestToAccountId = new Map<Id,Id>();
        List<Alpha_Prefix_Request__c> requestsNeedEmailAlert = new List<Alpha_Prefix_Request__c>();
        for(Id alphaPrefixRequestId: updateRequestMap.keySet()) {
            Alpha_Prefix_Request__c alphaPrefixRequest = updateRequestMap.get(alphaPrefixRequestId);
            Alpha_Prefix_Request__c alphaPrefixRequestBeforeChange = oldRequestMap.get(alphaPrefixRequestId);
            if(alphaPrefixRequest.Status__c != alphaPrefixRequestBeforeChange.Status__c && APRStatusSet.contains(alphaPrefixRequest.Status__c))                 //if status is changed to either 'Request Complete' OR 'Prefix Assigned'
            {
                alphaPrefixRequestToAccountId.put(alphaPrefixRequest.Id,alphaPrefixRequest.Account__c);
                requestsNeedEmailAlert.add(alphaPrefixRequest);
            }
        }
        sendEmailMessages(requestsNeedEmailAlert, alphaPrefixRequestToAccountId);
    }
    
    /**
* @description Prepares Email Content based on Alpha Request Information and it's associcated account team members
* @param       List of Alpha Prefix Request requires email alerts
* @param       Map of Alpha Prefix Request Id to related Account Id
* @return      void
*/
    @TestVisible
    private static void sendEmailMessages(List<Alpha_Prefix_Request__c> requestsNeedEmailAlert,Map<Id,Id> alphaPrefixRequestToAccountId) 
    {
        List <Messaging.SingleEmailMessage> emailMessages = new List <Messaging.SingleEmailMessage> ();
        if(!requestsNeedEmailAlert.isEmpty() && !alphaPrefixRequestToAccountId.isEmpty()) {
            EmailTemplate template = [SELECT Id,
                                      Body,
                                      Subject 
                                      FROM EmailTemplate 
                                      WHERE DeveloperName = 'APR_PrefixConfirmedFromIP' 
                                      AND IsActive = true
                                     ];
            if(template != NULL) {
                Map <Id,String> emailBodyStringList = getHTMLBodyStrings(requestsNeedEmailAlert,template.Body);
                Map <Id,Set <Id>> teamMembersMap = getAccountTeamMembersMap(alphaPrefixRequestToAccountId.values());
                
                for (Alpha_Prefix_Request__c alphaPrefixRequest: requestsNeedEmailAlert) {
                    String emailBody = emailBodyStringList.get(alphaPrefixRequest.Id);
                    messaging.SingleEmailMessage email = prepareEmailMessage(alphaPrefixRequest.OwnerId,emailBody,template.Subject);
                    emailMessages.add(email);
                    for (Id userId: teamMembersMap.get(alphaPrefixRequest.Account__c)) {
                        Messaging.SingleEmailMessage emailMessage = prepareEmailMessage(userId,emailBody,template.Subject);
                        emailMessages.add(emailMessage);
                    }
                }
            }            
        }
        if(!emailMessages.isEmpty()) {
            try{
                Messaging.sendEmail(emailMessages);
            } catch(Exception ex) {
                System.debug('Exception while sending email messages to Account Team Members '+ex.getMessage());
            }
        }
    }
    
    /**
* @description Instantiate SingleEmailMessage Object and set different properities based on inputs
* @param       Account Team Member User Id
* @param       Email Content
* @param       Email Subject
* @return      SingleEmailMessage Instance
*/
    @TestVisible
    private static Messaging.SingleEmailMessage prepareEmailMessage(Id userId, String emailBody, String emailSubject) {
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setSaveAsActivity(false);
        emailMessage.setTargetObjectId(userId);
        emailMessage.setTreatTargetObjectAsRecipient(true);
        emailMessage.setSubject(emailSubject);
        emailMessage.setplaintextBody(emailBody);
        return emailMessage;
    }
    
    /**
* @description Prepares Map of Alpha Prefix Request associcated Account Id and Set of Account Team Member's 
User Ids with specified roles 
* @param       Account Ids
* @return      Map of AccountId and Set of valid Account Team Members Id
*/
    @TestVisible
    private static Map <Id,Set <Id>> getAccountTeamMembersMap(List <Id> accountIds) {
        Map <Id,Set <Id>> teamMap = new Map <Id,Set <Id>> ();
        for (AccountTeamMember teamMember: [Select UserId,AccountId from AccountTeamMember where AccountId in: accountIds and TeamMemberRole in: accountTeamMemberRoles and User.IsActive = true]) {
            if (teamMap.containsKey(teamMember.AccountId)) {
                teamMap.get(teamMember.AccountId).add(teamMember.UserId);
            } else {
                teamMap.put(teamMember.AccountId,new Set <Id> {teamMember.UserId});
            }
        }
        return teamMap;
    }
    
    /**
* @description Replaces the Link and RequestNo of email content with AlphaRequest Information
* @param       Context Alpha Prefix Requests
* @param       Email Content
* @return      Map of Alpha Prefix Request Id and Updated Email Content
*/
    @TestVisible
    private static Map <Id,String> getHTMLBodyStrings(List <Alpha_Prefix_Request__c> alphaPrefixRequests, String content) {
        System.debug(content);
        Map <Id,String> emailHtmlBodyMap = new Map <Id,String> ();
        for (Alpha_Prefix_Request__c alphaPrefixRequest: alphaPrefixRequests) {
            String linkURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + alphaPrefixRequest.Id;
            String requestNo = alphaPrefixRequest.Name;
            String emailHtmlBody = content.replace('{!Alpha_Prefix_Request__c.Name}',requestNo);
            emailHtmlBody =  emailHtmlBody.replace('{!Alpha_Prefix_Request__c.Link}',linkURL);          
            emailHtmlBodyMap.put(alphaPrefixRequest.Id,emailHtmlBody);
        }
        return emailHtmlBodyMap;
    }
}