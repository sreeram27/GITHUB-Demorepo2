/*
@author         Accenture offshore
@date           4/20/2018
@name           AP22_SendNotifToNationalAIMTeam
@description    Called from trigger on Order object to send Notfications to users.  
*/

public without sharing class AP22_SendNotifToNationalAIMTeam {
    
    public static  boolean firstRun = true;
    public static List<string>ccAddresses=new list<string>();
    
    /* Method to pull the Implementation Case record values */
    public static void mailBuildermethod(List<Order>newList,Map<id,Order>OldMap){
        String quoteID ='' ;
        String implID ='';  
        String implCaseStatus ='' ;
        String aimStatus ='';
        String accLegalName ='';
        String claimSystem ='';
        Date implEffDate ;
        String quoteLink='';
        String quoteName ='';
        String quoteNumber ='';
        String implName ='';
        String owner ='';
        String implDate ='';
        Boolean orderStatusPendingReview;
        Id impLAssgnId;
        
        try{
        String  subjectLine='';
        List<String> toAddress=new List<String>();
        
        for(Order  ord : newList){
            implCaseStatus = ord.Implementation_Status__c;
            aimStatus = ord.AIM_Product_Sold_Or_Termed_Notification__c;
            orderStatusPendingReview = ord.Is_Order_Status_Pending_SME_Review__c;
            accLegalName = ord.AccountLegalName__c;
            claimSystem = ord.Claim_system__c;
            implEffDate = ord.Implementation_Effective_Date__c;
            implDate = implEffDate.format();
            quoteLink = ord.Quote_Name__c;
            implName = ord.OrderNumber;
            owner = ord.Owner_Full_Name__c;
            Order oldorderRec = OldMap.get(ord.id); 
            impLAssgnId=ord.Assigned_Implementer__c;
            
            
            
            if(oldorderRec.Implementation_Status__c != ord.Implementation_Status__c){                        
                implID=ord.id;
                quoteID=ord.QuoteId;      
               //system.debug('Im here in Impl'+implID);    
            }   
        }
        
        /* Query to get respective Quote details for the hyperlink */
        for(Quote q :[Select Name,QuoteNumber from Quote where Id=: quoteID]){
            quoteName = q.Name;
            quoteNumber = q.QuoteNumber;       
        }
        
        /*Query to get all the related Quote Line Item records under Quote */  
        for(QuoteLineItem qli :[select id,ProductStage__c from QuoteLineItem where QuoteId=: quoteID]){  
            //system.debug('Im here in QLI'+quoteID);
            /* Checking the Product Stage, AIM_Product_Sold_Or_Termed_Notification__c & Implementation Status */ 
     

            if(implCaseStatus==UtilConstants.IC_STATUS_PENDINGSMEREVIEW && aimStatus==UtilConstants.YES_VAL && !orderStatusPendingReview && (qli.ProductStage__c==UtilConstants.SOLD  || qli.ProductStage__c==UtilConstants.IGAP_SOLD || qli.ProductStage__c==UtilConstants.TERMED)){
                //system.debug('I have enterd if logic');
                toAddress.addAll(Label.Email_Addresses.split(','));             
                //toAddress.add('santosh.meesala@anthem.com');
                //toAddress.add('srividya.amaravadi@anthem.com');
                subjectLine= accLegalName + UtilConstants.COMMA + claimSystem + UtilConstants.COMMA + implDate + UtilConstants.AIM_Notification;
                sendMailMethod(toAddress,subjectLine,accLegalName,claimSystem,implDate,quoteName,quoteID,implID,implName,owner,impLAssgnId);   
                break;
            } 
            
        }  
      }catch (Exception excp){
            UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.class_AP22_SendNotifToNationalAIMTeam,UtilConstants.mailBuildermethod,UtilConstants.aimTrigger,LoggingLevel.ERROR);
        } 
        
    }
        
    /*Method to send mail*/ 
    public static void sendMailMethod(List<String> sendTo,String subjectLine, String accLegalName, String claimSystem, String implDate, String quoteName, String quoteID, String implID, String implName, String owner, String impLAssgnId){
        
        try{
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();               
        if(!sendTo.isEmpty() && String.isNotEmpty(subjectLine)){ 
            if(String.isBlank(claimSystem))
                claimSystem=UtilConstants.none;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
            //Step 2: Set list of people who should get the email
            mail.setToAddresses(sendTo);    
            // Step 3: Set who the email is sent from
            mail.setReplyTo(UtilConstants.donotreplycom);
            // (Optional) Set list of people who should be CC'ed
            List<String> ccTo = new List<String>();
            ccTo.add(impLAssgnId);
            mail.setCcAddresses(ccTo);
            mail.setSenderDisplayName(owner);
            String body = '';
            body += UtilConstants.mailBody+UtilConstants.br+UtilConstants.br;
            body += UtilConstants.Account_Name +accLegalName+UtilConstants.br;
            body += UtilConstants.Claims_System+claimSystem+UtilConstants.br;
            body += UtilConstants.Effective_Date+implDate+UtilConstants.br+UtilConstants.br;
            body += UtilConstants.mailBody2+UtilConstants.br;
            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+quoteID+'">'+quoteName+'</a>'+UtilConstants.br+UtilConstants.br;
            body += UtilConstants.mailBody3+UtilConstants.br;
            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+implID+'">'+implName+'</a>'+UtilConstants.br;
            mail.setHtmlBody(body);
            // Step 4. Set email contents - you can use variables!
            mail.setSubject(subjectLine);
            // Step 5. Add your email to the master list
            mails.add(mail);               
            if(!mails.isEmpty()){
                //system.debug('@@@@@@@mails'+mails);
                Messaging.sendEmail(mails);  
            }
            
        }
       }catch (Exception excp){
            UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.class_AP22_SendNotifToNationalAIMTeam,UtilConstants.sendMailMethod,UtilConstants.aimTrigger,LoggingLevel.ERROR);
        } 
        
    }
    
    
}