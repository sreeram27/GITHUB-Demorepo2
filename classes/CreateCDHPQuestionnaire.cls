/*
@Author : CDHP Dev Team 
@name : CreateCDHPQuestionnaire
@CreateDate :07-15-2018
@Description : This class sends the opportunity data to ISG when CDHP Plans are selected and based on business rules. It is called on click of
"Create Act Wise Questionnaire" button on Quote Page.
@Last Modified Date: 20th January 2019
*/
public with sharing class CreateCDHPQuestionnaire {
    /*PRDCRM-48570 to split the string in case email is send to multiple users*/
    public static final String DELIMITERTEXT = ';';
    /*PRDCRM-48570 Email configuration*/
    public static final String EMAIL_FROM = 'do_not_reply@anthem.com';
    public static final String EMAIL_SUBJECT = ' Multiple HRA Plans Sold';
    public static final String SENDER_DISPLAY_NAME = 'Questionnaire';
    /*
@method Name : sendOpportunityData
@Parameters used: Quote Id
@method Description : This methods leads to REST API Callout from sendOpportunityData. 
@Last Modified Date:20th January 2019
*/
    @AuraEnabled
    public static void sendOpportunityData(String quoteId){
        /*PRDCRM-48570*/
        if(quoteId !=null){
            checkMultipleHRARecords(quoteId);
            CDHP_ISG_Send_Opportunity cdhp = new CDHP_ISG_Send_Opportunity();
            cdhp.sendOpportunityData(quoteId);
        }
    }
    /*
@method Name : initController
@Parameters used: Quote Id
@method Description : This method is called on initialization to control the view of "Create/Update" & "View" Questionnaire links. 
@Last Modified Date: 20th January 2019
*/
    @AuraEnabled
    public static InitializeResponse initController(String quoteId){
        //fetch the user profile
        Id profileId = UserInfo.getProfileId();
        String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
        system.debug('Profile Name'+profileName);
        
        //The  wrapper response to return to component
        InitializeResponse response = new InitializeResponse();
        
        List<String> productStages = new List<String>{CDHP_COMM2_Constants.SOLD,CDHP_COMM2_Constants.RENEWED,CDHP_COMM2_Constants.IGAP_SOLD};
            List<String> oppClosedOrRenewed = new List<String>{CDHP_COMM2_Constants.CLOSED_WON,CDHP_COMM2_Constants.RENEWAL_FINALIZED};
                List<String> profileNameList = new List<String>{CDHP_COMM2_Constants.LOCAL_IMPLEMENTATIONS,CDHP_COMM2_Constants.LOCAL_IMPLEMENTATIONS_DUAL};
                    
                    Quote qt = [SELECT Id,Opportunity.StageName,CDHP_SF_Id_From_ISG__c,
                                (SELECT Id,ProductStage__c,PLComplete__c,Product2.QLIRecordType__c FROM QuoteLineItems where Product2.QLIRecordType__c != NULL),
                                (select Id from Orders)
                                FROM Quote
                                WHERE id = :quoteId];   
        if(qt != null){
            if(qt.Orders.size() > 0){
                response.showWarning_IC = true;
            }            
          
            if(!String.isBlank(qt.CDHP_SF_Id_From_ISG__c)){
                response.showViewLink = True;
                response.CDHP_SF_Id_ISG = qt.CDHP_SF_Id_From_ISG__c;
            }
            if(oppClosedOrRenewed.contains(qt.Opportunity.StageName) ){
                for(QuoteLineItem qli : qt.QuoteLineItems){
                    if(productStages.contains(qli.ProductStage__c) && qli.PLComplete__c && qli.Product2.QLIRecordType__c.contains(CDHP_COMM2_Constants.ACTWISE) && !profileNameList.contains(profileName) ){
                        response.showCreatUpdate = True;
                        return response;
                    }
                }
            }
        }
        return response;
    }
    
    //The following method was implemented in a separate NONB-specific class and can be removed from this class
    /*@AuraEnabled
    public static void sendProductEmail(Id quoteId){
        
        PageReference pdfPage = Page.ActWiseNoticeOfNewBusiness;
        pdfPage.getParameters().put('id',quoteId);
        Blob b = pdfPage.getContentAsPDF();
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1.setFileName('attachment_WORK.pdf');
        efa1.setBody(b);
        String str='karthik.keshavan@anthem.com';
        list<String> addresses = new list<String>();
        addresses.add(str);
        email.setSubject( 'Subject' +String.valueOf(DateTime.now()));
        email.setToAddresses(addresses);
        email.setPlainTextBody('Test Body');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

    } */ //<--------- This is the end of the NONB-related method that is NOT part of this class. It can be removed
    
    

    /*PRDCRM-48570 
    Email for excess repeating objects that will not fit Questionnaire*/
    /*
@method Name : checkMultipleHRARecords
@Parameters used: Quote Id
@method Description : This methods checks if the given Quote has multiple HRA Administration records for same type of HRA combination. 
@Last Modified Date:05 Dec 2019
*/
    
    public static void checkMultipleHRARecords(Id quoteId){
        List<QuoteLineItem> qtLineItemList = new  List<QuoteLineItem>();
        List<HRA_Administration__c> HRAAdminList = new List<HRA_Administration__c>();
        qtLineItemList = [SELECT Id,HRA_Payment_Type__c,ClientName__c,ProductName__c,Product2.Product_Family__c, 
                                 FSA_Plan_End_Date__c, OpportunityEffectiveDate__c,QuoteId
                          FROM QuoteLineItem 
                          WHERE QuoteId = :quoteId];
        if(!qtLineItemList.isEmpty()){
        	Map<Id, QuoteLineItem> mapQLI = new Map<Id, QuoteLineItem>(qtLineItemList);                                              
         	HRAAdminList = [SELECT Id,Type_of_HRA__c,HRA_Upfront_Deductible__c,HRA_Split_Percentage__c
                            FROM HRA_Administration__c
                            WHERE QLI__c In : mapQLI.keySet()];
        }
        Integer member_Pay_count = 0;
        Integer provider_Pay_Medical_count = 0;
        Integer hra_Upfront_Deductible_count = 0;
        Integer auto_Pay_Provider_count = 0;  
        Integer hra_Split_Percentage_count = 0; 
        for(HRA_Administration__c HRAAdmin : HRAAdminList){
            //Sequence E1 for ISG
            if(HRAAdmin.Type_of_HRA__c== 'Member Pay (debit card) Only'){
                member_Pay_count++;
            }
            //Sequence E2 for ISG
            if(HRAAdmin.Type_of_HRA__c == 'Provider Pay Medical with Optional Rx/Dental/Vision Debit Card'){
                provider_Pay_Medical_count++;
            }
            //Sequence E3 for ISG
            if(HRAAdmin.HRA_Upfront_Deductible__c== 'Yes'){
                hra_Upfront_Deductible_count++;
            }
            //Sequence E4 for ISG
            if(HRAAdmin.HRA_Split_Percentage__c == 'Yes'){
                hra_Split_Percentage_count++;
            }
            //Sequence E5 for ISG
            if(HRAAdmin.Type_of_HRA__c=='Auto-Pay Provider Only' &&  HRAAdmin.HRA_Upfront_Deductible__c == 'NO' 
                                         && HRAAdmin.HRA_Split_Percentage__c == 'No'){
                auto_Pay_Provider_count++;
            }
            

            if(member_Pay_count > 1 || provider_Pay_Medical_count > 1 || hra_Upfront_Deductible_count > 1 || auto_Pay_Provider_count > 4 || hra_Split_Percentage_count > 1){
                sendEmailToActWiseSupport(quoteId);
                break;
            }

        }                                                    
    } 
	/*
@method Name : sendEmailToActWiseSupport
@Parameters used: Quote Id
@method Description : This methods sends Email to the ActWiseSupport team.
@Last Modified Date:05 Dec 2019
*/
    public static void sendEmailToActWiseSupport(Id quoteId){
        System.debug('sendEmailToActWiseSupport method is called');
        String account_Name;
        String startDate;
        Quote quoteDetails = new Quote();
        OrgWideEmailAddress owa;
        if(quoteId != null){
        	quoteDetails = [SELECT Id,Account.Name, Opportunity.CloseDate
                            FROM Quote
                            WHERE id = :quoteId];
        }
        if(quoteDetails != null){
            account_Name = quoteDetails.Account.Name;
            startDate = String.valueOf(quoteDetails.Opportunity.CloseDate);
        }
        if(!Test.isRunningTest()){
        	owa = [select id, Address,DisplayName from OrgWideEmailAddress where Address = :EMAIL_FROM Limit 1 ]; 
        } else {
            new OrgWideEmailAddress (Address  ='dl-deltaforce@anthem.com', DisplayName  ='Anthem Dev Ops');
        }
        //Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //list of people who should get the email
        if(owa != null){
        	mail.setOrgWideEmailAddressId(owa.id);
        } 
        List<String> sendTo = new List<String>();
        //List of Users the email will be send to
        String sendToList = System.Label.ActWiseSupportTeam;
        if(sendToList.contains(DELIMITERTEXT)){
            for(String recipient : sendToList.split(DELIMITERTEXT)){
                sendTo.add(recipient);
                mail.setToAddresses(sendTo);
            }
        }
        //Set Email Details
        mail.setReplyTo(EMAIL_FROM);
        mail.setSubject(account_Name + EMAIL_SUBJECT);
        //mail.setSenderDisplayName(SENDER_DISPLAY_NAME);
        String body = 'Multiple HRA Plans (member pay, split % or deductible first) have been marked as sold for '+ account_Name + ' effective '+startDate+'  .';
        body += '<br/>The salesforce questionnaire cannot currently capture the multiple plans electronically. <br/>';
        body += '<br/>This notice is a reminder to submit the additional plans to Alegeus via email.<br/>';
        body += '<br/> *Note that the questionnaire can currently capture multiple provider pay HRA plans';
        mail.setHtmlBody(body);
		
        // send email messages
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});

    }
    // Wrapper class to send the Response to the lightning component.
    public class InitializeResponse{
        @AuraEnabled
        public Boolean showCreatUpdate {get;set;}
        
        @AuraEnabled
        public Boolean showViewLink {get;set;}
        
        @AuraEnabled
        public String CDHP_SF_Id_ISG {get;set;}
        
        @AuraEnabled
        public boolean showWarning_IC {get;set;}
        
        @AuraEnabled
        public boolean showSendEmailLink {get;set;}
        
        public InitializeResponse()
        {
            showCreatUpdate = False;
            showViewLink = False;
            showWarning_IC = false;
            showSendEmailLink=false;
            CDHP_SF_Id_ISG = '';
        }
    }
}