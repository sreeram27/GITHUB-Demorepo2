/*
@author         Accenture offshore
@date           4/20/2018
@name           AP21_SMENotifyApproverEMail
@description    Called from trigger on SME Approval object to send Notfications to users.  
*/
global without sharing class  AP21_SMENotifyApproverEMail{

    public static boolean firstRun = true;

    /*This method is used to store the filtered implimentation record id and SMEApproval Records */
    public static void mailBuildermethod(List<SME_Approvals__c>newList,Map<id,SME_Approvals__c>OldMap){
        set<ID> apporvalID = new set<ID>();
        set<ID> implID = new set<ID>();
        String  prirorValue; 
        String  newValue; 
        String  impactPriorValue;
        String  impactNewValue;
        String  subjectLine='';
        String  ToName='';
        String  implLink=''; 
        boolean impact=false;
        boolean medicalBenefits =false;
        boolean selectionAndimpact =false;
        
     try{
            List<String>toAddresss=new List<String>(); 
            List<SME_Approvals__c> relatedApprovals = new List<SME_Approvals__c>();
            for(SME_Approvals__c  appRec : newList){
                SME_Approvals__c oldSmeRec = OldMap.get(appRec.id); 
       
              /*Code to compare the old and new values of particular fields which are updated */   
        
                if((oldSmeRec.Selections_Report_Required__c !=appRec.Selections_Report_Required__c ) && appRec.SME_Department__c== UtilConstants.healthString){                        
                    apporvalID.add(appRec.id);
                    implID.add(appRec.Implementation_Record_ID__c);   
                    prirorValue=oldSmeRec.Selections_Report_Required__c;
                    newValue=appRec.Selections_Report_Required__c;
                    impactPriorValue=oldSmeRec.Impact_to_HPCC__c;
                    impactNewValue=appRec.Impact_to_HPCC__c;     
                }   
                if((oldSmeRec.Impact_to_HPCC__c !=appRec.Impact_to_HPCC__c) && appRec.SME_Department__c == UtilConstants.healthString){
                    impact=true;
                    apporvalID.add(appRec.id);
                    implID.add(appRec.Implementation_Record_ID__c);   
                    impactPriorValue=oldSmeRec.Impact_to_HPCC__c;
                    impactNewValue=appRec.Impact_to_HPCC__c; 
                    
                }else if(oldSmeRec.Strings_Tables_Contract_Codes_Impacted__c !=appRec.Strings_Tables_Contract_Codes_Impacted__c && appRec.SME_Department__c== UtilConstants.medicalString){
                    apporvalID.add(appRec.id);
                    implID.add(appRec.Implementation_Record_ID__c);   
                    prirorValue=oldSmeRec.Strings_Tables_Contract_Codes_Impacted__c;
                    newValue=appRec.Strings_Tables_Contract_Codes_Impacted__c;
                    medicalBenefits=true;                   
                } 
                if(oldSmeRec.Selections_Report_Required__c !=appRec.Selections_Report_Required__c  && oldSmeRec.Impact_to_HPCC__c !=appRec.Impact_to_HPCC__c){
                    selectionAndimpact=true;
                }
            }
          /*Query to get all the related approval records under parent implementation case */ 
            
            for(SME_Approvals__c approvalMailRec :[select id,Implementation_Record_ID__r.OrderNumber,SME_Approver__r.name,SME_Approver__r.Email,SME_Department__c,Claims_System__c,Implementation_Record_ID__c,Account_Legal_Name__c,ICHyperLink__c,Selections_Report_Required__c from SME_Approvals__c where Implementation_Record_ID__c IN:implID]){
                relatedApprovals.add(approvalMailRec);                  
                /*for user story 1632*/ 

               if(approvalMailRec.Claims_System__c==UtilConstants.nasco && approvalMailRec.SME_Department__c== UtilConstants.groupString && String.isNotBlank(approvalMailRec.SME_Approver__r.Email) && medicalBenefits==false && (impact==false|| selectionAndimpact==true)) {
                    subjectLine= UtilConstants.groupServicesForSelectionsReportReuired+approvalMailRec.Account_Legal_Name__c; 
                    toAddresss.add(approvalMailRec.SME_Approver__r.Email);
                    ToName=approvalMailRec.SME_Approver__r.name;
                    implLink=approvalMailRec.ICHyperLink__c;
                    sendMailMethod(toAddresss,subjectLine,ToName,prirorValue,newValue,implLink,UtilConstants.reportMailBody);                                                  
               }else if(approvalMailRec.Claims_System__c== UtilConstants.wgs && approvalMailRec.SME_Department__c== UtilConstants.medicalString && String.isNotBlank(approvalMailRec.SME_Approver__r.Email) && medicalBenefits==false && (impact==false || selectionAndimpact==true)){   
                    subjectLine= UtilConstants.medicalBenifitsForSelectionsReportRequired+approvalMailRec.Account_Legal_Name__c;
                    toAddresss.add(approvalMailRec.SME_Approver__r.Email);
                    ToName=approvalMailRec.SME_Approver__r.name;
                    implLink=approvalMailRec.ICHyperLink__c;
                    sendMailMethod(toAddresss,subjectLine,ToName,prirorValue,newValue,implLink,UtilConstants.reportMailBody);
                }               
                if(impact==true || selectionAndimpact==true){ /*for user story 5989*/
                    if(approvalMailRec.Claims_System__c== UtilConstants.nasco && approvalMailRec.SME_Department__c == UtilConstants.groupString && String.isNotBlank(approvalMailRec.SME_Approver__r.Email) && medicalBenefits==false){
                        subjectLine= UtilConstants.groupServicesForImpactHpcc+approvalMailRec.Account_Legal_Name__c; 
                        toAddresss.add(approvalMailRec.SME_Approver__r.Email);
                        ToName=approvalMailRec.SME_Approver__r.name;
                        implLink=approvalMailRec.ICHyperLink__c;
                        sendMailMethod(toAddresss,subjectLine,ToName,impactPriorValue,impactNewValue,implLink,UtilConstants.impactHccMailBody);                        
                   }else if(approvalMailRec.Claims_System__c== UtilConstants.wgs && approvalMailRec.SME_Department__c == UtilConstants.medicalString && String.isNotBlank(approvalMailRec.SME_Approver__r.Email) && medicalBenefits==false){   
                        subjectLine= UtilConstants.medicalBenifitsForImpactHpcc+approvalMailRec.Account_Legal_Name__c;
                        toAddresss.add(approvalMailRec.SME_Approver__r.Email);
                        ToName=approvalMailRec.SME_Approver__r.name;
                        implLink=approvalMailRec.ICHyperLink__c;
                        sendMailMethod(toAddresss,subjectLine,ToName,impactPriorValue,impactNewValue,implLink,UtilConstants.impactHccMailBody); 
                    }
                } 
               
               if(medicalBenefits==true){       /*for user story 1631*/
                    if(approvalMailRec.SME_Department__c== UtilConstants.groupString && String.isNotBlank(approvalMailRec.SME_Approver__r.Email)){            
                        subjectLine= UtilConstants.groupServicesForStringsTablesContract+approvalMailRec.Account_Legal_Name__c;
                        toAddresss.add(approvalMailRec.SME_Approver__r.Email);
                        ToName=approvalMailRec.SME_Approver__r.name;
                        implLink=approvalMailRec.ICHyperLink__c;
                        sendMailMethod(toAddresss,subjectLine,ToName,prirorValue,newValue,implLink,UtilConstants.stringsTableMailBody);  
                    }   
                }
            }   
        }catch (Exception excp){
             UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.CLASS_NAMESME,UtilConstants.mailBuildermethod,UtilConstants.triggerName,LoggingLevel.ERROR);                               
        
        } 
    
    }   
        
   /*Method to send mail to the users which reused in above code */ 
    public static void sendMailMethod(List<String> sendTo,String subjectLine, String Salutation,String prirorValue,String newValue,String hyperLink,String mailBody){
    
      try{    
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            if(!sendTo.isEmpty() && String.isNotBlank(subjectLine) && !String.isBlank(Salutation) && String.isNotBlank(hyperLink)){
                if(prirorValue == null) 
                    prirorValue=UtilConstants.none;
                if(newValue == null)    
                    newValue=UtilConstants.none;
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
                //Step 2: Setting list of people who should get the email
                mail.setToAddresses(sendTo);    
                // Step 3: Setting who the email is sent from
                mail.setReplyTo(UtilConstants.donotreplycom);
                // (Optional) Setting list of people who should be CC'ed
                List<String> ccTo = new List<String>();
                //ccTo.add('shashidhar.pataballa@anthem.com');
               // ccTo.add('mantena.vaishnavi@anthem.com');
                mail.setCcAddresses(ccTo);
                // Step 4. Setting email contents - you can use variables!
                mail.setSubject(subjectLine);
                String body = UtilConstants.to+Salutation+UtilConstants.br+UtilConstants.br;
                body += mailBody+UtilConstants.br;
                body += UtilConstants.perviousValue+prirorValue +UtilConstants.br;
                body += UtilConstants.newValue+newValue+UtilConstants.br+UtilConstants.br;
                body += UtilConstants.implementationCaseRecordBody+UtilConstants.br;
                body += hyperLink+UtilConstants.br;
                mail.setHtmlBody(body);
                mails.add(mail);               
               if(mails!=null){
                  Messaging.sendEmail(mails);  
               }
            }   
    
        }catch (Exception excp){
            UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.CLASS_NAMESME,UtilConstants.sendMailMethod,UtilConstants.triggerName,LoggingLevel.ERROR);
        } 
    }                                                                                                             

    /*Method to send mail for user story #1634 */
    public static void sendStatusChangemail(List<SME_Approvals__c>newList,Map<id,SME_Approvals__c>OldMap){
        set<ID> implID = new set<ID>();
        //string TempID;
        String impCaseName='';
        String implEmail;
        List<String> sendTo = new List<String>();
       // id approvalrecID;    
        string hyperLink='';        
        boolean sendMail=false;
        boolean statusChange=false; 
        String orderName='';    
        SME_Approvals__c currentSmeRecord;
        
     try{
        
            for(SME_Approvals__c  appRec : newList){         
                implID.add(appRec.Implementation_Record_ID__c);             
                SME_Approvals__c oldApproval = OldMap.get(appRec.id);
                currentSmeRecord = appRec;         // approval record instance for trigger context              
                if(OldMap.get(appRec.id).Status__c != appRec.Status__c){    
                    statusChange=true;
                }else{
                    statusChange=false;
                }   
            
            }
            if(statusChange){
                for(SME_Approvals__c apprvalRec :[select id,Implementation_Record_ID__r.OrderNumber,ICHyperLink__c,Status__c,Implementation_Record_ID__r.Implementation_Case_Name__c,Implementation_Record_ID__r.Assigned_Implementer__r.email,Implementation_Record_ID__r.Account_Group_Size__c from SME_Approvals__c
                 where Implementation_Record_ID__c IN : implID]){                 
                    sendTo.add(apprvalRec.Implementation_Record_ID__r.Assigned_Implementer__r.email);
                    implEmail=apprvalRec.Implementation_Record_ID__r.Assigned_Implementer__r.email;
                    impCaseName=apprvalRec.Implementation_Record_ID__r.Implementation_Case_Name__c;
                    hyperLink=apprvalRec.ICHyperLink__c;
                    orderName=apprvalRec.Implementation_Record_ID__r.OrderNumber;                    
                    if((apprvalRec.Status__c== UtilConstants.approved || apprvalRec.Status__c== UtilConstants.approvedcastlight || apprvalRec.Status__c== UtilConstants.approveddeviation || apprvalRec.Status__c== UtilConstants.denied|| apprvalRec.Status__c== UtilConstants.na) &&(apprvalRec.Implementation_Record_ID__r.Account_Group_Size__c!=UtilConstants.keyNumber)){
                         sendMail=true;
                    }else{  
                        sendMail=false; 
                       break;
                    }
                }
            }
      
            /*This logic below will add error on the status field when email field on IMPL case is null */
            if(sendMail== true){    
                if(implEmail==null){
                        sendMail=false;
                        currentSmeRecord.Status__c.addError(UtilConstants.pleaseAddAssignedImplementerIC);
                    } 
            }

         /*This logic below will build the email body when all the conditions are met */
            if(sendMail== true){
                String subjectLine= UtilConstants.allSmereviews+impCaseName;
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> ccTo = new List<String>();
                // ccTo.add('shashidhar.pataballa@anthem.com');
                String body = orderName+UtilConstants.br;
                body += UtilConstants.implementationCaseRecordBody+UtilConstants.br;
                body += hyperLink+UtilConstants.br;
                mail.setHtmlBody(body);
                mail.setSubject(subjectLine);
                mail.setToAddresses(sendTo);
                mail.setCcAddresses(ccTo);
                mail.setReplyTo(UtilConstants.donotreplycom);
                mails.add(mail);               
                if(mails!=null)
                  Messaging.sendEmail(mails);           
            }
    
        }catch (Exception excp){
            UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.CLASS_NAMESME,UtilConstants.sendStatusChangemail,UtilConstants.triggerName,LoggingLevel.ERROR);
        } 

    }           
            
     /*This method is used to create groupservice and id cards records  for US#4586 for Update */       
    public static void createApprovalRecordsOnUpdate(List<SME_Approvals__c>newList,Map<id,SME_Approvals__c>OldMap){
        set<ID> implID = new set<ID>();
        Id trackingId;
        Id grpqId;
        Id idqId;
        String antEntity = '';
        list<Group_Services__c> groupList = new list<Group_Services__c>();
        list<ID_Cards__c> idList = new list<ID_Cards__c>();
        list<Data_Interface_Team__c> ditList = new list<Data_Interface_Team__c>();
        string claimSystem = '';
        string assignImpl='';
        string accountImpl='';
        string accountID='';
        Id groupRecordTypeId;
        Id idCardRecordTypeId; 
        id ditRecordTypeId;
        set<String> quoteName = new set<String>();
        list<QuoteLineItem> lineItemList = new list<QuoteLineItem>();
        Boolean isJAA=false;
        List<AccountTeamMember> teamList = new List<AccountTeamMember>();
        list <ID> userId = new list <ID>();     
          
        try{ 
            
            for(SME_Approvals__c  appRec : newList){  
                implID.add(appRec.Implementation_Record_ID__c);
                quoteName.add(appRec.QuoteName__c);
            }
        
            /*query to get the implimentation tracking record for the impl case */     
            for(Implementation_Tracking__c impt: [Select id,name,(Select id,name from ID_Cards__r),(Select name from Group_Services_and_ID_Cards__r),(Select name from Data_Interface_Teams__r) from Implementation_Tracking__c  where Implementation_Record_ID__c IN: implID]){
                trackingId=impt.id;
                groupList.addAll(impt.Group_Services_and_ID_Cards__r);
                idList.addAll(impt.ID_Cards__r);  
                ditList.addAll(impt.Data_Interface_Teams__r);
            }
  
            /* query to get the Anthem Entity from the Account related to the Implementation Case */
            for(Order ord : [Select AccountID,Anthem_Entity__c,Claim_system__c,Assigned_Implementer__c,Account.Account_Manager__c from Order where Id IN: implID]){
                antEntity = ord.Anthem_Entity__c;
                claimSystem=ord.Claim_system__c;
                assignImpl=ord.Assigned_Implementer__c;
                //accountImpl=ord.Account.Account_Manager__c;
                accountID=ord.AccountID;
            }
            
            //query for collecting account team member
            for(Account acc :[select id,name,(Select id,UserId from AccountTeamMembers where TeamMemberRole =:UtilConstants.accountManager LIMIt 1) from Account where id =:accountID]){    
                teamList.addAll(acc.AccountTeamMembers); 
            }   
           
           //query for collecting account details
            for(AccountTeamMember team:teamList){
                accountImpl=team.UserId;
            }        
           
           system.debug('@@@@accountImpl'+accountImpl);
        
            if(String.isBlank(accountImpl)){ 
                accountImpl=null;
            }
           
            if(String.isBlank(assignImpl)){
                assignImpl=NULL;
            }
             
        
        
            /* query to get Queue ID for Group National Accounts */
            for (Group grp : [select Id from Group where Name =: UtilConstants.groupServicesNational and Type =: UtilConstants.queue]){
                grpqId = grp.Id;
            }
            
            /* query to get Queue ID for Group National Accounts */
            for (Group grp : [select Id from Group where (Name =:UtilConstants.idCardsNational OR Name =:UtilConstants.idCardsLocal) and Type =: UtilConstants.queue]){
                idqId = grp.Id;
            }
        
            /* query to get Quoteline item records from the quote for us#10036*/
            for(Quote quoteRec :[select id,name,(select id,Financing__c from QuoteLineItems) from Quote where name IN:quoteName]){
                lineItemList.addAll(quoteRec.QuoteLineItems);
            }
        
            /* query to check the JAA condition for us#10036 */
            for(QuoteLineItem lineItems :  lineItemList){   
                if(lineItems.Financing__c==UtilConstants.JAA){
                    isJAA=true; 
                    break;
                }   
            }

            if (!String.isBlank(claimSystem)){         
                if(isJAA==true && claimSystem==UtilConstants.nasco){
                    groupRecordTypeId = Schema.SObjectType.Group_Services__c.getRecordTypeInfosByName().get(UtilConstants.JAANASCO).getRecordTypeId();  
                    idCardRecordTypeId = Schema.SObjectType.ID_Cards__c.getRecordTypeInfosByName().get(UtilConstants.JAANASCOandWGS).getRecordTypeId();
                    ditRecordTypeId=Schema.SObjectType.Data_Interface_Team__c.getRecordTypeInfosByName().get(UtilConstants.JAANASCO).getRecordTypeId();
                }else if(isJAA==true && claimSystem==UtilConstants.wgs){
                    groupRecordTypeId = Schema.SObjectType.Group_Services__c.getRecordTypeInfosByName().get(UtilConstants.JAAWGS).getRecordTypeId(); 
                    idCardRecordTypeId = Schema.SObjectType.ID_Cards__c.getRecordTypeInfosByName().get(UtilConstants.JAANASCOandWGS).getRecordTypeId();
                    //ditRecordTypeId=Schema.SObjectType.Data_Interface_Team__c.getRecordTypeInfosByName().get(UtilConstants.JAANASCO).getRecordTypeId(); 
                }else if(isJAA==false && claimSystem==UtilConstants.nasco){   
                    groupRecordTypeId = Schema.SObjectType.Group_Services__c.getRecordTypeInfosByName().get(UtilConstants.NationalNASCO).getRecordTypeId();  
                    idCardRecordTypeId = Schema.SObjectType.ID_Cards__c.getRecordTypeInfosByName().get(UtilConstants.NationalNASCOandWGS).getRecordTypeId(); 
                }else if(isJAA==false &&  claimSystem==UtilConstants.wgs){                   
                    groupRecordTypeId = Schema.SObjectType.Group_Services__c.getRecordTypeInfosByName().get(UtilConstants.NationalWGS).getRecordTypeId();                    
                    idCardRecordTypeId = Schema.SObjectType.ID_Cards__c.getRecordTypeInfosByName().get(UtilConstants.NationalNASCOandWGS).getRecordTypeId();
                }
            }  
            List<Group_Services__c> listGS = new List< Group_Services__c>();
            List<ID_Cards__c> listID = new List< ID_Cards__c>();
            List<Data_Interface_Team__c> listDit = new List< Data_Interface_Team__c>();
            for( SME_Approvals__c sme: newList ){       
                SME_Approvals__c oldAppRec =OldMap.get(sme.id);
                if((oldAppRec.Status__c!=sme.Status__c && sme.SME_Department__c== UtilConstants.groupString && trackingId!=null ) && (sme.Status__c == UtilConstants.Approved || sme.Status__c == UtilConstants.approveddeviation)){                 
                     if(antEntity==UtilConstants.NationalAccounts){
                     listGS.add(new Group_Services__c(Implementation_Tracking_ID__c=trackingId, OwnerId=grpqId,RecordTypeID=groupRecordTypeId,Assigned_Implementer__c= assignImpl));
                    }else {
                     listGS.add(new Group_Services__c(Implementation_Tracking_ID__c=trackingId,RecordTypeID=groupRecordTypeId,Assigned_Implementer__c= assignImpl));
                    }
                }else if((oldAppRec.Status__c!=sme.Status__c && sme.SME_Department__c== UtilConstants.idcards) && (sme.Status__c == UtilConstants.Approved || sme.Status__c == UtilConstants.approveddeviation)){
                    if(antEntity==UtilConstants.NationalAccounts){
                        ID_Cards__c idRecs = new ID_Cards__c(Implementation_Tracking_ID__c=trackingId,OwnerId=idqId,RecordTypeID=idCardRecordTypeId,Account_Manager__c=accountImpl,Assigned_Implementer__c=assignImpl);
                        listID.add(idRecs);
                    }else if(antEntity==UtilConstants.LocalAccounts){
                        ID_Cards__c idRecs = new ID_Cards__c(Implementation_Tracking_ID__c=trackingId,OwnerId=idqId,RecordTypeID=idCardRecordTypeId,Account_Manager__c=accountImpl,Assigned_Implementer__c=assignImpl);
                        listID.add(idRecs);
                        
                    }else{
                        ID_Cards__c idRecs = new ID_Cards__c(Implementation_Tracking_ID__c=trackingId,RecordTypeID=idCardRecordTypeId,Account_Manager__c=accountImpl,Assigned_Implementer__c=assignImpl);
                        listID.add(idRecs);
                    }
                }else if((oldAppRec.Status__c!=sme.Status__c && sme.SME_Department__c==UtilConstants.Dit  && trackingId!=null && claimSystem==UtilConstants.nasco && ditRecordTypeId!=null ) && (sme.Status__c == UtilConstants.Approved || sme.Status__c == UtilConstants.approveddeviation)){
                        Data_Interface_Team__c dit = new Data_Interface_Team__c(Implementation_Tracking_ID__c=trackingId,RecordTypeID=ditRecordTypeId);
                        listDit.add(dit);
                }
            }   
            
            if(listGS.size() > 0 && groupList.size()==0){
                insert(listGS);
            }else if(listID.size() > 0 && idList.size()==0){
                insert listID;
            }else if(listDit.size() > 0 && ditList.size()==0){
                insert listDit;
            }
            
           }catch (Exception excp){   
               UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.CLASS_NAMESME,UtilConstants.createApprovalRecordsOnUpdate,UtilConstants.triggerName,LoggingLevel.ERROR);
          }   
    }             

}