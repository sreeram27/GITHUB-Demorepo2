/*
@author         Accenture offshore
@date           5/31/2018
@name           AP26_NotifysersOnICStatusChange
@description    Called from trigger on SME Approval object to send Notfications to users.  
*/
Global with sharing class AP26_NotifyUsers_On_ICStatusChange {
    public static boolean firstRun = true;
    public static final String selectStatement='select Claim_System__c,Department__c,Required__c,Region__c,SME_Email__c,SME_User_Name__c from SME_User_Data__c '; 
    public static final String whereString ='Where ';
    public static final String OrString ='OR';
    public static final String whereClause1=' Claim_System__c includes ';
    public static final String whereClause2 =' And Region__c includes ';
    public static final String whereClause3=' And Department__c includes ';
    public static final String whereClause4=' And Required__c = True';
    public static final String openBrace ='(';
    public static final String closeBrace =')';
    public static final String CLASS_AP26='AP26_NotifyUsers_On_ICStatusChange';
    public static final String mailBuildermethod='mailBuildermethod';
    public static boolean doNotMail=false; 
    public static List<string> subList = new List<string>();
    public static List<string>ccAddresses=new list<string>();
    public static final String accountTeamError='Please add an Account Manager to the Account Team before completing this field';
    public static final String BenefitInquiry='Benefit Inquiry';
    
    /*This method is used to store the filtered implimentation record id and SMEApproval Records */
    public static void mailBuildermethod(List<Order>newList,Map<id,Order>OldMap){
        List<SME_Approvals__c> relatedApprovals = new List<SME_Approvals__c>();
        set<id>implId = new set<id>();
        list<id>accIdSet= new list<id>();
        list<string> smeEmails= new list<string>();
        // #PRDCRM-35315 #PRDCRM-36436 Added User Roles HWS Implementor and Underwriter
        set<string> userRoles = new set<string>{UtilConstants.accountExecutive,UtilConstants.accountManager,UtilConstants.eba,UtilConstants.groupServiceAnalyst,UtilConstants.dataExchangeAnalyst,UtilConstants.hwsImplementor,UtilConstants.underwriter};
        list <ID> userId = new list <ID>();                                                     //this set stores the users which are recipients of email
        List<AccountTeamMember> teamList = new List<AccountTeamMember>();
        List<string> userEmails = new list<string>();
        Id targetID; 
        Id impLAssgnId;                   //this variable stores the assign Implementer user ID  
        id quoteID;
        id qliWhatID;
        //List<string> subList = new List<string>();
        //List<string> subList2 = new List<string>();
        //List<string>ccAddresses=new list<string>();
       
        List<string> allEmailsList = new List<String>();
        List<String> claimSystemsApprovalList = new List<String>();
        List<String> departmentApprovalSmeList = new List<String>();
        List<String> regionApprovalList = new List<String>();       
        boolean isPendingReview= false;
        boolean isApproved= false;
        boolean productNameCheck= false; 
        Order orderRecord ;
        date effectiveDate;
        QuoteLineItem updateQli;
        
     try{ 
            //code to get implementation contextID    
            for(Order  ord : newList){
                implId.add(ord.id);
                targetID=ord.id;   //This Id is used in email template
                orderRecord=ord;    
            } 
            //code to query all the related sme approval and all the region, claim system and department related details 
            for(Order  ord : [select No_Rev_Email__c,Number_Of_Revisions__c,Revision_Sequence_UpdatingTrigger__c,id,Group_Name__r.Employer_Service_Representative__c,Implementation_Status__c,region__c,Claim_system__c,Account.name,Account.Id,Assigned_Implementer__c,Assigned_Implementer__r.email,Account_Group_Size__c,QuoteID,Implementation_Effective_Date__c,Pre_Implementation_Type__c,(select id,name,SME_Approver__r.email,SME_Department__c,If_Other_List_Department__c from SME_Approvals__r ) from Order where Id IN : implId]){
                Order oldOrdRec = OldMap.get(ord.id);               
                quoteID=ord.QuoteID;
                if(ord.Implementation_Effective_Date__c!=null){  
                    effectiveDate=ord.Implementation_Effective_Date__c;
                }   
                //system.debug('oldOrdRec.Implementation_Status__c'+oldOrdRec.Implementation_Status__c);
                //system.debug('ord.Implementation_Status__c'+ord.Implementation_Status__c);
                //system.debug('ord.Implementation_Status__c'+ord.Implementation_Status__c);
                
    
                if((oldOrdRec.Implementation_Status__c!= ord.Implementation_Status__c || oldOrdRec.Revision_Sequence_UpdatingTrigger__c!= ord.Revision_Sequence_UpdatingTrigger__c) && (ord.Implementation_Status__c== UtilConstants.IC_STATUS_PENDINGSMEREVIEW || ord.Implementation_Status__c == UtilConstants.APPROVED) && oldOrdRec.Implementation_Status__c !=UtilConstants.RevisionPendingImplementationsReview && ord.No_Rev_Email__c==false ){      
                    if(!string.isBlank(ord.Assigned_Implementer__c)){
                        //userId.add(ord.Assigned_Implementer__c);
                        impLAssgnId=ord.Assigned_Implementer__c; 
                        ccAddresses.add(ord.Assigned_Implementer__c);                       
                    }else if(ord.Account_Group_Size__c!= UtilConstants.keyNumber && string.isBlank(ord.Assigned_Implementer__c)){
                        orderRecord.addError(UtilConstants.assigIMpError);
                        Break;                   
                    }else if(ord.Account_Group_Size__c == UtilConstants.keyNumber && string.isBlank(ord.Assigned_Implementer__c)){
                        doNotMail= true;
                        Break;                  
                    }      
                    
                       
                    // As per US#23379 5.2
                    
                    if(ord.Pre_Implementation_Type__c==BenefitInquiry){ 
                        doNotMail= true;
                    }   
                    //query for Group user details
                    if(!string.isBlank(ord.Group_Name__r.Employer_Service_Representative__c)){     
                          userId.add(ord.Group_Name__r.Employer_Service_Representative__c);                
                    } 
                    
                    //system.debug('@@@@@@@@@@Imhere');
                    relatedApprovals.addAll(ord.SME_Approvals__r);
                    claimSystemsApprovalList.add(ord.Claim_system__c);
                    regionApprovalList.add(ord.Region__c);

                    
                    if(ord.Implementation_Status__c == UtilConstants.IC_STATUS_PENDINGSMEREVIEW){
                        isPendingReview= true;
                    }else if(ord.Implementation_Status__c == UtilConstants.APPROVED){
                        //system.debug('@@@@@@@@@@Approved'); 
                        isApproved= true;   
                    }
                   //checking if the status is updtadeted and approval records are created 
                    accIdSet.add(ord.Account.Id);                             
                }
            }
         
         
            if(isPendingReview){
               for(QuoteLineItem qli : [select id,Financing__c,Product2.name,Effective_Date_IC__c from QuoteLineItem where quoteID=:quoteID]){
                    if(qli.Product2.name== UtilConstants.othersubrogation ){
                        qliWhatID=qli.id;
                        productNameCheck=true;
                        qli.Effective_Date_IC__c=effectiveDate;
                        updateQli=qli;
                        //system.debug('@@@updateQli is '+updateQli.Effective_Date_IC__c);
                        break;            
                        
                    }        
                }   
            }         
            //system.debug('@@@Date is '+effectiveDate);  
            if(updateQli!=null && effectiveDate!=null){ 
                update updateQli;   
            }

            
            //query for collecting departments
            for(SME_Approvals__c sme :relatedApprovals){    
                departmentApprovalSmeList.add(sme.SME_Department__c);
                if(!string.isBlank(sme.If_Other_List_Department__c)){                                 // code added for US# 13490 
                    departmentApprovalSmeList.add(sme.If_Other_List_Department__c); 
                }               
            }          

            //system.debug('@@@@@@@@@@regionApprovalList'+ regionApprovalList );     
            //system.debug('@@@@@@@@@@departmentApprovalSmeList'+ departmentApprovalSmeList );
            //system.debug('@@@@@@@@@@claimSystemsApprovalList'+ claimSystemsApprovalList);
          
            /**************************************************************************************************
                                                     Code for Dynamic Query Build 
            
            ******************************************************************************************************/
            
            string claimsystemString= string.join(claimSystemsApprovalList, UtilConstants.SLASH_QUOTE + UtilConstants.COMMA + UtilConstants.SLASH_QUOTE);
            claimsystemString = UtilConstants.SLASH_QUOTE + claimsystemString + UtilConstants.SLASH_QUOTE;
            string regionString= string.join(regionApprovalList, UtilConstants.SLASH_QUOTE + UtilConstants.COMMA + UtilConstants.SLASH_QUOTE);
            regionString = UtilConstants.SLASH_QUOTE + regionString + UtilConstants.SLASH_QUOTE;
            string deptString= string.join(departmentApprovalSmeList, UtilConstants.SLASH_QUOTE + UtilConstants.COMMA + UtilConstants.SLASH_QUOTE);
            deptString = UtilConstants.SLASH_QUOTE + deptString + UtilConstants.SLASH_QUOTE;

            
            String selectStmnt = selectStatement;
            selectStmnt +=  whereString+ openBrace + whereClause1 + openBrace + claimsystemString + closeBrace;
            selectStmnt +=  whereClause2 + openBrace + regionString + closeBrace;
            selectStmnt +=  whereClause3 + openBrace + deptString + closeBrace + closeBrace;
            selectStmnt +=  OrString + openBrace + whereClause1 + openBrace + claimsystemString + closeBrace;
            selectStmnt +=  whereClause2 + openBrace + regionString + closeBrace ;
            selectStmnt +=  whereClause4 + closeBrace;
            
            //system.debug('@@@@@@@@@@selectStmnt'+selectStmnt);
            

            //query for collecting sme emails
            for( SME_User_Data__c sme : Database.query(selectStmnt)){
                   smeEmails.add(sme.SME_Email__c);
                   //system.debug('@@@@@@@@@@smeUserData'+smeEmails); 
            }
           

            //code ends

            //query for collecting account team member
            for(Account acc :[select id,name,(Select id,UserId from AccountTeamMembers where TeamMemberRole IN : userRoles) from Account where id IN:accIdSet]){    
                teamList.addAll(acc.AccountTeamMembers); 
            }   
           
           //query for collecting account details
            for(AccountTeamMember team:teamList){
                userId.add(team.UserId);
            }
             
            //query for collecting user details 
            for(User usr:[select email from user where id IN:userId]){
                userEmails.add(usr.email);
            } 
            
            allEmailsList.addAll(smeEmails);
            allEmailsList.addAll(userEmails);
            allEmailsList.sort();
            Set<string> myset = new Set<string>();
            myset.addAll(allEmailsList);
            allEmailsList.clear();
            allEmailsList.addAll(myset); 

         
            // for user story  3556 query to get email template ID 
            if(orderRecord.Implementation_Type__c == UtilConstants.PRE_WORK && orderRecord.Pre_Implementation_Type__c == UtilConstants.RFP){
                doNotMail=true;
            }
            if(isPendingReview && !doNotMail){   
               emailTemplate template = [Select Id, Name From EmailTemplate where Name= :UtilConstants.nofiticationEmailApprovedImplementationCaseRecord];
               mailLimitSetup(allEmailsList,targetID,impLAssgnId,template.id);
            }else if(isApproved && !doNotMail){
               emailTemplate template = [Select Id, Name From EmailTemplate where Name= :UtilConstants.emailNotificationToSpecificSME];
               mailLimitSetup(allEmailsList,targetID,impLAssgnId,template.id);
            }           
          // for user story 6052
          //Commenting as per UA 21944
          /* if(productNameCheck){
               emailTemplate template = [Select Id, Name From EmailTemplate where Name= :UtilConstants.emailnotificationforsubrogation];
               //string email1=system.Label.Anthemsubrogationemails;
               list<string> sendTo= new list<string>();
               sendTo.add(system.Label.AnthemSubrogationEmail1);
               sendTo.add(system.Label.AnthemSubrogationEmail2);
               emailTempteSetup(sendTo,qliWhatID,impLAssgnId,template.id); 
               
            } */
        }catch (Exception excp){   
               //System.debug('---'+excp);
               UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,CLASS_AP26,mailBuildermethod,UtilConstants.triggerName1,LoggingLevel.ERROR);
        }      
    
    }

         
    public static void mailLimitSetup(list<string> sendToList,ID targetID,ID assignId,Id templateId){
    integer counter = 0;
        for(string eachEmail : sendToList) {
            subList.add(eachEmail);
            if(!subList.isEmpty() && math.mod(subList.size(),Integer.Valueof(system.Label.MaxMailLimit)) == 0) {
                emailTempteSetup(subList,targetID,assignId,templateId);                     
                subList.clear();
                counter++;
            }
            if((subList.size() + Integer.Valueof(system.Label.MaxMailLimit) * counter) == sendToList.size()) {
                if(!subList.isEmpty()) {
                   emailTempteSetup(subList,targetID,assignId,templateId);
                }
            }
        }

    }
    

    
   /* Method to build email template*/
    public static void emailTempteSetup(list<string> sendTo,ID targetID,ID assignId,Id templateId){ 
        try{ 
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(assignId);
            mail.setCcAddresses(ccAddresses);
            mail.setWhatID(targetID);
            mail.setSaveAsActivity(false);
            mail.setToAddresses(sendTo);  
            mail.setReplyTo(UtilConstants.donotreplycom);
            mail.setTemplateId(templateId);
            mails.add(mail);
            system.debug('@@@@@@@@@@mails'+mails);
            
            if(mails!=null){
               Messaging.sendEmail(mails);  
            }
             
        }catch (Exception excp){   
                 UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,CLASS_AP26,mailBuildermethod,UtilConstants.triggerName1,LoggingLevel.ERROR);
        }   
    } 
    
    // changes done for US20866 sprint 4.4 
    public static void beforeUpdateValidate(list<Order>newOrderList,Map<Id,Order>oldMap){
        try{ 
            //List<Id>accountManagerOrderList= new List<Id>();
            List<AccountTeamMember> teamList = new List<AccountTeamMember>();
            list <String> accountManagerAccountList = new list <String>();
            list <string> accIdSet = new list <string>();   
            
           for(Order ord :newOrderList){
               accIdSet.add(ord.AccountID);
            }
            system.debug('***accountIDs'+accIdSet);
            
         //query for collecting account team member
            for(AccountTeamMember teamMember :[Select id,UserId from AccountTeamMember where TeamMemberRole=:UtilConstants.accountManager AND AccountID IN:accIdSet]){    
                accountManagerAccountList.add(teamMember.UserId);
            }   
           
           system.debug('***accountManagerAccountList'+accountManagerAccountList); 
           
           //logic to check if account manager is not from the account team 
            for(Order ord : newOrderList){
               Order oldOrdRec = OldMap.get(ord.id);  
               system.debug('***ord.Account_Manager__c '+ord.Account_Manager__c);
               system.debug('***contains '+accountManagerAccountList.contains(ord.Account_Manager__c));
               
               if(oldOrdRec.Account_Manager__c != ord.Account_Manager__c && ord.Account_Manager__c!=null){
                    if(!accountManagerAccountList.contains(ord.Account_Manager__c) && !accountManagerAccountList.isEmpty() ){
                        system.debug('**Inside error loop');
                        ord.AddError(accountTeamError);    
                        Break;              
                    }else if(accountManagerAccountList.isEmpty()){
                         ord.AddError(accountTeamError);
                    }          
                } 
            }       
        }catch (Exception excp){   
            UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,CLASS_AP26,mailBuildermethod,UtilConstants.triggerName1,LoggingLevel.ERROR);
        }         
    }
}