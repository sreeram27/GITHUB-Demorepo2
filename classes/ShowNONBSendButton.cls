/*
@Author : Olympians Dev Team 
@name : ShowNONBSendButton for PRDCRM-44997 and PRDCRM-45408
@CreateDate :11-06-2019
@Description : This class controls the display of the "Send (Resend) Act Wise Notice of New Businesss" button, 
and the emailing of the form as an attachment. 
*/

public with sharing class ShowNONBSendButton {      
	
    public static boolean wasEmailSent = false;    
    
    /*
	@method Name : initController
	@Parameters used: Quote Id
	@method Description : This method is called on initialization to control the view of "Send (and Resend) Act Wise Notice of New Business" links. 
	@Last Modified Date: 11/07/19
	*/
    
    @AuraEnabled
    public static InitializeResponse initController(String quoteId){
        //fetch the user profile
        Id profileId = UserInfo.getProfileId();
        String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
        
        //The  wrapper response to return to component
        InitializeResponse response = new InitializeResponse();        
        
        List<String> productStage = new List<String>{CDHP_COMM2_Constants.SOLD, CDHP_COMM2_Constants.IGAP_SOLD};            
            
            List<String> oppType = new List<String>{CDHP_COMM2_Constants.IN_GROUP_CHANGE, CDHP_COMM2_Constants.IN_GROUP_CHANGE_LOCAL, CDHP_COMM2_Constants.IN_GROUP_ADD_PRODUCT,
                CDHP_COMM2_Constants.IN_GROUP_ADD_PRODUCT_LOCAL, CDHP_COMM2_Constants.NEW_BUSINESS, CDHP_COMM2_Constants.NEW_BUSINESS_LOCAL, CDHP_COMM2_Constants.RENEWAL, CDHP_COMM2_Constants.RENEWAL_LOCAL};           
                            
            	List<String> profileNameList = new List<String>{CDHP_COMM2_Constants.LOCAL_IMPLEMENTATIONS, CDHP_COMM2_Constants.LOCAL_IMPLEMENTATIONS_DUAL,
                	CDHP_COMM2_Constants.NATIONAL_IMPLEMENTATIONS, CDHP_COMM2_Constants.NATIONAL_IMPLEMENTATIONS_DUAL};    
                                    
                	Quote qt = [SELECT Id, Opportunity.OpportunityRecordTypeName__c, Opportunity.Is_Renewed__c, Opportunity.AnthemEntity__c, NONB_Sent__c, NONB_Resent__c, 
                    	(SELECT Id, RecordType__c,IsArea1__c,IsArea4__c, IsArea3__c, Is_New_Business__c, ProductStage__c From QuoteLineItems) FROM Quote WHERE id = :quoteId]; 
               
        if(qt != null){
            if(qt.QuoteLineItems.size() > 0){                
                if((oppType.contains(qt.Opportunity.OpportunityRecordTypeName__c)) || (qt.Opportunity.Is_Renewed__c && qt.Opportunity.AnthemEntity__c == CDHP_COMM2_Constants.LOCAL_LARGE_GROUP) || (qt.Opportunity.OpportunityRecordTypeName__c == CDHP_COMM2_Constants.RENEWAL && qt.Opportunity.AnthemEntity__c == CDHP_COMM2_Constants.NATIONAL_ACCOUNTS)) {
                       
                       for(QuoteLineItem qli : qt.QuoteLineItems){                            
                           if(qt.NONB_Sent__c != 1 && (qli.Is_New_Business__c || qli.ProductStage__c == CDHP_COMM2_Constants.SOLD || qli.ProductStage__c == CDHP_COMM2_Constants.IGAP_SOLD ) && qli.RecordType__c.contains(CDHP_COMM2_Constants.ACTWISE) && !profileNameList.contains(profileName)){                                
                               if(qt.NONB_Sent__c != 1) {
                                   response.showSendEmailLink = true;  
                                   break;
                               }
                           }else if (qt.NONB_Sent__c == 1) {
                               response.showResendEmailLink = true;
                               wasEmailSent = true; 
                           }
                       }
                   }
            }          
        }
        return response;
    }    
    
    @AuraEnabled
    public static void sendProductEmail(Id quoteId, String fromBtn){
        
        PageReference pdfPage = Page.ActWiseNONB;
        pdfPage.getParameters().put('id',quoteId);
        
        Quote qt = [select Id, NONB_Sent__c,NONB_Sent_Date_Time__c,NONB_Resent_Date_Time__c, NONB_Resent__c from Quote where Id=:quoteId limit 1];
        
        Blob b = !Test.isRunningTest() ? pdfPage.getContentAsPdf() : Blob.valueOf(CDHP_COMM2_Constants.BLOB_FAKECONTENT);
        
        list<String> addresses = new list<String>();
        for(NONB_Email__c customSet : [select Name,Email__c from NONB_Email__c]){
            if(customSet.Email__c !=null){
                addresses.add(customSet.Email__c);
            }
        }
        
        if(addresses.size() > 0){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            efa1.setFileName(CDHP_COMM2_Constants.NONB_ATTACHMENT);
            efa1.setBody(b);
            
            String subj = '';
            
            if(fromBtn == CDHP_COMM2_Constants.SEND) {                
                subj = CDHP_COMM2_Constants.NONB_EMAILSUBJECT_NEW;
            } else {
                subj = CDHP_COMM2_Constants.NONB_EMAILSUBJECT_UPDATED;
            }
            
            email.setSubject(subj);
            email.setToAddresses(addresses);
            email.setPlainTextBody(CDHP_COMM2_Constants.NONB_EMAIL_TEXT);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});       
            
            /*PRDCRM-49399 (assigned to Naga on Admin team) is the required first step for this to work with the 'do not reply'
            email address. That story is to set up the Organization Wide Address in the sandboxes and the Com2 Orgs. */
			OrgWideEmailAddress owa= [select id, Address from OrgWideEmailAddress where Address =: CDHP_COMM2_Constants.SF_ACTWISE_OWA];
            if ( owa != null && owa.Address != null ) {
    			email.setOrgWideEmailAddressId(owa.id);
			} 
            
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            // move below SOQL ouside the for loop.
            //Quote qt = [select Id, NONB_Sent__c,NONB_Sent_Date_Time__c,NONB_Resent_Date_Time__c, NONB_Resent__c from Quote where Id=:quoteId limit 1];
            
            if(qt != null){
                if(qt.NONB_Sent__c == null){
                    qt.NONB_Sent__c = 0; 
                }if(qt.NONB_Resent__c == null){
                    qt.NONB_Resent__c = 0;
                }
                if(r[0].isSuccess()) {                    
                    try {
                        if(fromBtn == CDHP_COMM2_Constants.SEND && qt.NONB_Sent__c != 1) {
                            qt.NONB_Sent__c = 1;
                            qt.NONB_Sent_Date_Time__c = system.now();
                        } else if(fromBtn == CDHP_COMM2_Constants.RESEND && qt.NONB_Resent__c != null) {                            
                            qt.NONB_Resent__c += 1;
                            qt.NONB_Resent_Date_Time__c = system.now();
                        } 
                        update qt;    
                    } catch(DmlException e) {
                        System.debug('The following exception has occurred: ' +e.getMessage()+'at line '+e.getLineNumber());
                    }                                        
                } 
            }
        }
    }
    
    // Wrapper class to send the Response to the lightning component.
    public class InitializeResponse{
        
        @AuraEnabled
        public boolean showWarning_IC {get;set;}
        
        @AuraEnabled
        public boolean showSendEmailLink {get;set;}
        
        @AuraEnabled
        public boolean showResendEmailLink {get;set;} 
        
        @AuraEnabled
        public boolean showResendWarning {get;set;} 
        
        @AuraEnabled
        public boolean showBtn {get;set;} 
        
        public InitializeResponse()
        {
            showWarning_IC = false;
            showSendEmailLink=false;
            showResendEmailLink=false;
            showResendWarning = false;
            showBtn = false;
        }
    }
}