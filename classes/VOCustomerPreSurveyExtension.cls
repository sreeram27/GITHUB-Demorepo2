/**********************************************************************
Name:  VOCustomerPreSurveyExtension
Copyright © 2020  VisitOps  
======================================================
Purpose: Survey Class to be send out to the Customers before Visit                                                                                                                      
======================================================
====================================================== 
History                                                            
-------                                                            
VERSION  	AUTHOR        DATE           DETAIL                      				
1.0 - 	Tanuj Tyagi       01/23/2020     OTOP Survey Class for SLDS Design 
***********************************************************************/

public without sharing class VOCustomerPreSurveyExtension {
    public string visitId {get;set;}
    public String attendeeId {get;set;}
    private String existingSurveyId {get;set;}
    private List<VisitOps__Visit__c> visitList {get;set;}
    public Boolean showSubmitButton {get;set;}
    public VisitOps__Visit__c visitRecord {get;set;}
    public VisitOps__Attendee__c attendeeRecord {get;set;}
    public VisitOps__Survey__c surveyRecord {get;set;}
    public String coordinatorName {get;set;}
    public String visitOwnerName {get;set;}
    public String companyNameDynamically{get;set;}
    public boolean flag{get;set;}
    public boolean flag1{get;set;}
    public string newString{get;set;}
    public String arrivalDate{get;set;}
    public boolean isPrintForm{get;set;}
    
    public VOCustomerPreSurveyExtension(ApexPages.StandardController controller) {
        try {
            flag=false;
            flag1=false;
            visitId = ApexPages.currentPage().getParameters().get('visitId');
            
            if(visitId!=null && visitId!='') visitId = String.escapeSingleQuotes(visitId);
            else throw new ErrorOccuredException();
            
            attendeeId =ApexPages.currentPage().getParameters().get('attendeeId');
            if(attendeeId!=null && attendeeId!=''){
                attendeeId = String.escapeSingleQuotes(attendeeId);
            }else{
                isPrintForm = true;
            }
            
            //  else throw new ErrorOccuredException();
            
            visitList = [select Id,Name,VisitOps__VisitName__c,VisitOps__ArrivalDateTime__c,VisitOps__DepartureDateTime__c,VisitOps__ArrivalDateTimeLocationTZ__c,VisitOps__DepartureDateTimeLocationTZ__c,VisitOps__Location__c,VisitOps__Location__r.Name,VisitOps__VisitManager__c,VisitOps__VisitCoordinator__c,VisitOps__VisitCoordinator__r.Name,Owner.Name,VisitOps__VisitOwner__c,VisitOps__VisitOwner__r.Name from VisitOps__Visit__c where Id=:visitid];
            
            
            if(visitList!=null && visitList.size()>0) {
                Map<String,String> monthNamesMap = new Map<String,String>{'01'=>'January','02'=>'February','03'=>'March','04'=>'April',
                    '05'=>'May','06'=>'June','07'=>'July','08'=>'August',
                    '09'=>'September','10'=>'October','11'=>'November','12'=>'December'};
                        visitRecord = visitList[0];
                coordinatorName = visitList[0].VisitOps__VisitCoordinator__r.Name;
                visitOwnerName = visitList[0].VisitOps__VisitOwner__r.Name;
                List<String> arrivalDateList = visitRecord.VisitOps__ArrivalDateTimeLocationTZ__c.split('-'); //yyyy-mm-dd hh:mm:ss
                if(!arrivalDateList.isEmpty()){
                    arrivalDate = monthNamesMap.get(arrivalDateList[1])+ ' '+ arrivalDateList[2].split(' ')[0] + ', '+ arrivalDateList[0]; //Month_Name Date, Year
                }
            }
            else throw new ErrorOccuredException();
            
            List<VisitOps__Attendee__c> attendeeList = [SELECT Id, Name,VisitOps__Company__c,VisitOps__FirstName__c,VisitOps__LastName__c FROM VisitOps__Attendee__c WHERE Id = :attendeeId];
             List<VisitOps__Survey__c> surveyList;
            if(attendeeList!=null && attendeeList.size()>0){ 
                attendeeRecord = attendeeList[0];
                companyNameDynamically =attendeeList[0].VisitOps__Company__c;
                system.debug('companyNameDynamically-'+companyNameDynamically);
                 surveyList = [select Id,VisitOps__isPrint__c,VisitOps__Pre_Survey_Status__c,VisitOps__Attendee__r.VisitOps__Company__c from VisitOps__Survey__c where VisitOps__Visit__c=:visitId AND VisitOps__Attendee__c=:attendeeId limit 1] ;
            } 
            // else throw new ErrorOccuredException();
            
            if(surveyList!=null && surveyList.size()>0) {
                if(surveyList[0].VisitOps__Pre_Survey_status__c && !surveyList[0].VisitOps__isPrint__c) {
                    throw new SurveyAlreadySubmittedException();
                } 
                else {
                    existingSurveyId = surveyList[0].Id;
                }
                
            }
            
            if(existingSurveyId==null) {
                surveyRecord = new VisitOps__Survey__c();
            }else{
                surveyRecord = new VisitOps__Survey__c(Id=existingSurveyId);
            }
            showSubmitButton = attendeeRecord != null ? true : false;
        }
        catch (SurveyAlreadySubmittedException ex) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'The Survey has already been submitted. Thank you.'));}
        catch(Exception ex) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error occured while loading the Survey'));System.debug('Exception occured:'+ex.getMessage());}
    }
    public string getDocumentLogoUrl()
    {
        list<Document> d = [Select Id,LastModifiedById,DeveloperName from Document where DeveloperName = 'Survey_Logo' limit 1];
        String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
        //newString =fullFileURL+'/servlet/servlet.FileDownload?file='+d[0].id+'&oid='+UserInfo.getOrganizationId();
        newString = System.Label.VisitOps.VisitOps_Site_Url +'/servlet/servlet.FileDownload?file='+d[0].id+'&oid='+UserInfo.getOrganizationId();
        return newString;
    }
    public string getDocumentFooterUrl()
    {
        
        list<Document> d = [Select Id,LastModifiedById,DeveloperName from Document where DeveloperName = 'Survey_Footer'];
        String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
        //newString =fullFileURL+'/servlet/servlet.FileDownload?file='+d[0].id+'&oid='+UserInfo.getOrganizationId();
        newString = System.Label.VisitOps.VisitOps_Site_Url +'/servlet/servlet.FileDownload?file='+d[0].id+'&oid='+UserInfo.getOrganizationId();
        system.debug('***********************************'+newString);
        return newString;
    } 
    public List<SelectOption> getRadioOpts(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('','N/A'));
        options.add(new SelectOption('0','0'));
        options.add(new SelectOption('1','1')); 
        options.add(new SelectOption('2','2')); 
        options.add(new SelectOption('3','3')); 
        options.add(new SelectOption('4','4')); 
        options.add(new SelectOption('5','5')); 
        options.add(new SelectOption('6','6')); 
        options.add(new SelectOption('7','7')); 
        options.add(new SelectOption('8','8')); 
        options.add(new SelectOption('9','9')); 
        options.add(new SelectOption('10','10'));
        return options; 
    }
    
    
    public List<SelectOption> getPicklistOpts(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Strongly Disagree','Strongly Disagree'));
        options.add(new SelectOption('Disagree','Disagree'));
        options.add(new SelectOption('Neutral','Neutral')); 
        options.add(new SelectOption('Agree','Agree')); 
        options.add(new SelectOption('Strongly Agree','Strongly Agree')); 
        return options; 
    }
    
    public List<SelectOption> getPercentRadioOpts(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('0','0%'));
        options.add(new SelectOption('10','10%')); 
        options.add(new SelectOption('20','20%')); 
        options.add(new SelectOption('30','30%')); 
        options.add(new SelectOption('40','40%')); 
        options.add(new SelectOption('50','50%')); 
        options.add(new SelectOption('60','60%')); 
        options.add(new SelectOption('70','70%')); 
        options.add(new SelectOption('80','80%')); 
        options.add(new SelectOption('90','90%')); 
        options.add(new SelectOption('100','100%'));
        return options; 
    }
    
    
    public PageReference SubmitSurvey() {
        if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__User_Type__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__User_Type__c.isUpdateable()){
            surveyRecord.VisitOps__User_Type__c ='Customer';
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to update Surveys.'));
            return null;
        }
        if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Pre_Survey_status__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Pre_Survey_status__c.isUpdateable()){
            surveyRecord.VisitOps__Pre_Survey_status__c = true;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to update Surveys.'));
            return null;
        } 
        if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__isPrint__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__isPrint__c.isUpdateable()){
            surveyRecord.VisitOps__isPrint__c = false;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to update Surveys.'));
            return null;
        }
        
        flag=true;
        flag1=true; 
        
        List<RecordType> rtList = [select Id,DeveloperName,Name from RecordType where DeveloperName='Customer_Survey' limit 1];
        if(rtList!=null && rtList.size()>0){ 
            if((Schema.SObjectType.VisitOps__Survey__c.Fields.RecordTypeId.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.RecordTypeId.isUpdateable())){
                surveyRecord.RecordTypeId = rtList[0].Id;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions.'));
                return null;
            }
        }
        
        try{      
            if(visitId!= null && String.isNotEmpty(visitId) && (existingSurveyId==null)){
                surveyRecord.VisitOps__Visit__c = visitId;
            }
            if(attendeeId!=null && String.isNotEmpty(attendeeId)){
                if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Attendee__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Attendee__c.isUpdateable()){
                    surveyRecord.VisitOps__Attendee__c = attendeeId;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions.'));
                    return null;
                }
            }
            if(visitList!=null && visitList.size()>0){ 
                if((Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit_Owner__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit_Owner__c.isUpdateable())) {
                    system.debug('ID Owner :'+visitList[0].VisitOps__VisitOwner__c);
                    //  surveyRecord.VisitOps__Visit_Owner__c = visitList[0].VisitOps__VisitOwner__c;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions.'));
                    return null;
                }
            }
            
            if(existingSurveyId==null) {
                if(!Schema.SObjectType.VisitOps__Survey__c.isCreateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to create survey.'));
                    return null;
                }
                insert surveyRecord;
            }
            else {
                if(!Schema.SObjectType.VisitOps__Survey__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to update survey.'));
                    return null;
                }
                update surveyRecord;
            }       
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'Survey Submitted successfully!'));      
            showSubmitButton = false;
            return null;        
        }
        
        catch(DMLException ex){ ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)+ex.getlineNumber()));return null;  }
        catch(Exception ex) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error occured while committing the Survey'));return null;} 
    }
    // Define Exception classes
    public class ErrorOccuredException extends Exception {
    }
    public class SurveyAlreadySubmittedException extends Exception {
        
    }
}