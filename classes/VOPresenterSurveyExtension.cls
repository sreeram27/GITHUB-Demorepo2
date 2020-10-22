/**********************************************************************
Name:  VOPresenterSurveyExtension
Copyright © 2020  VisitOps  
======================================================
Purpose: Survey Class to be send out to the Presenters                                                                                                                      
======================================================
====================================================== 
History                                                            
-------                                                            
VERSION  	AUTHOR        DATE           DETAIL                      				
1.0 - 	Tanuj Tyagi       01/21/2020     OTOP Survey Class for SLDS Design 
***********************************************************************/

 
public without sharing class VOPresenterSurveyExtension {
    
    public string visitId {get;set;}
    public String presenterLinkId {get;set;}
    public List<VisitOps__Visit__c> visitList{get;set;}
    public Boolean showSubmitButton {get;set;}
    public VisitOps__Visit__c visitRecord {get;set;}
    public VisitOps__Presenter_Agenda_Link__c presenterLinkRecord {get;set;}
    public VisitOps__Survey__c surveyRecord {get;set;}
    public String coordinatorName {get;set;}
    public String visitOwnerName {get;set;}
    public String agendaSessionName {get;set;}
    public boolean flag{get;set;}
    public string newString{get;set;}
    
    public VOPresenterSurveyExtension(ApexPages.StandardController controller) {
        try {
            flag=false;
            visitId = ApexPages.currentPage().getParameters().get('visitId');
            if(visitId!=null && visitId!='') visitId = String.escapeSingleQuotes(visitId);
            else throw new ErrorOccuredException();
            
            presenterLinkId = ApexPages.currentPage().getParameters().get('presenterId');
            if(presenterLinkId!=null && presenterLinkId!='') presenterLinkId = String.escapeSingleQuotes(presenterLinkId);
            else throw new ErrorOccuredException();
            
            visitList = [select Id,Name,VisitOps__VisitName__c,VisitOps__ArrivalDateTime__c,VisitOps__DepartureDateTime__c,VisitOps__ArrivalDateTimeLocationTZ__c,VisitOps__DepartureDateTimeLocationTZ__c,VisitOps__Location__c,VisitOps__Location__r.Name,VisitOps__VisitManager__c,VisitOps__VisitCoordinator__c,VisitOps__VisitCoordinator__r.Name,Owner.Name,VisitOps__VisitOwner__r.Name,VisitOps__VisitOwner__c, VisitOps__Arrival_Date_and_Time_LocationFormula__c,VisitOps__Departure_Date_and_Time_LocationFormula__c from VisitOps__Visit__c where Id=:visitid];
            if(visitList!=null && visitList.size()>0) { 
                visitRecord = visitList[0];
                system.debug('visitRecord.Name : '+visitRecord.Name);
                system.debug('visitRecord.VisitOps__VisitName__c : '+visitRecord.VisitOps__VisitName__c);
                             
                visitList[0].VisitOps__ArrivalDateTimeLocationTZ__c = Datetime.valueOf(visitList[0].VisitOps__ArrivalDateTimeLocationTZ__c).format('MM/dd/yyyy HH:mm:ss');
                visitList[0].VisitOps__DepartureDateTimeLocationTZ__c = Datetime.valueOf(visitList[0].VisitOps__DepartureDateTimeLocationTZ__c).format('MM/dd/yyyy HH:mm:ss');
                                    
                coordinatorName = visitList[0].VisitOps__VisitCoordinator__r.Name;
                visitOwnerName = visitList[0].VisitOps__VisitOwner__r.Name;				
            }
            List<VisitOps__Presenter_Agenda_Link__c> presenterAgendaList = [select Id,Name,VisitOps__Attendee__r.VisitOps__FirstName__c,VisitOps__Attendee__r.VisitOps__LastName__c,VisitOps__Agenda__r.VisitOps__Agenda_Title__c from VisitOps__Presenter_Agenda_Link__c where Id=:presenterLinkId];
            if(presenterAgendaList!=null && presenterAgendaList.size()>0) {
                presenterLinkRecord = presenterAgendaList[0];
                agendaSessionName = presenterAgendaList[0].VisitOps__Agenda__r.VisitOps__Agenda_Title__c;
            }
            else throw new ErrorOccuredException();
            
            List<VisitOps__Survey__c> surveyList = [select Id from VisitOps__Survey__c where VisitOps__Visit__c=:visitId AND VisitOps__Presenter_Agenda_Link__c=:presenterLinkId limit 1] ;
            if(surveyList!=null && surveyList.size()>0) {
                throw new SurveyAlreadySubmittedException();
            }
            
            surveyRecord = new VisitOps__Survey__c();
            showSubmitButton = true;	
        }
        catch (SurveyAlreadySubmittedException ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'The Survey has already been submitted. Thank you.'));
        }
        catch(Exception ex) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error occured while loading the Survey'));System.debug('Exception occured:'+ex.getMessage());}
        
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
        
        return options; 
    }
 public string getDocumentLogoUrl()
	{
		list<Document> d = [Select Id,LastModifiedById,DeveloperName from Document where DeveloperName = 'Survey_Logo'];
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
		return newString;
  }	
	
	public PageReference submitSurvey() {
	 
        if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__User_Type__c.isCreateable()){
		surveyRecord.VisitOps__User_Type__c ='Presenter';
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to update Surveys.'));
            return null;
        }
        if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Topic_Name__c.isCreateable()){
            surveyRecord.VisitOps__Topic_Name__c = agendaSessionName;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to update Surveys.'));
            return null;
        }
        if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Post_Survey_status__c.isCreateable()){
		surveyRecord.VisitOps__Post_Survey_status__c = true;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to update Surveys.'));
            return null;
        }
		flag=true;
		List<RecordType> rtList = [select Id,DeveloperName,Name from RecordType where DeveloperName='PresenterSurvey' limit 1];
        if(rtList!=null && rtList.size()>0){ 
            if((Schema.SObjectType.VisitOps__Survey__c.Fields.RecordTypeId.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.RecordTypeId.isUpdateable())){
			surveyRecord.RecordTypeId = rtList[0].Id;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions.'));
                return null;
            }
        }
		try{      
		    if(visitId!= null && String.isNotEmpty(visitId)){
                if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit__c.isCreateable()){
		       	surveyRecord.VisitOps__Visit__c = visitId;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to update Surveys.'));
                    return null;
                }
		    }
		   	if(presenterLinkId!=null && String.isNotEmpty(presenterLinkId)){
                if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Presenter_Agenda_Link__c.isCreateable()){
		    	surveyRecord.VisitOps__Presenter_Agenda_Link__c = presenterLinkId;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to update Surveys.'));
                    return null;
                }
		    }
		     if(visitList!=null && visitList.size()>0) {
                if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit_Owner__c.isCreateable() && Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit_Owner__c.isUpdateable()) {
		    	surveyRecord.VisitOps__Visit_Owner__c = visitList[0].VisitOps__VisitOwner__c;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to update Surveys.'));
                    return null;
                }
            }
            if(!Schema.SObjectType.VisitOps__Survey__c.isCreateable()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You do not have sufficient permissions to create survey.'));
                return null;
		    }
	    	insert surveyRecord;
	    	
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'Survey Submitted successfully!'));		
			showSubmitButton = false;
			
			return null;		
		}
	    
	   	catch(DMLException ex){ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)+ex.getlineNumber()));return null; }
	    catch(Exception ex) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error occured while committing the Survey'));return null;} 
	  
	}
	

	// Define Exception classes
	public class ErrorOccuredException extends Exception {
	
	}
	public class SurveyAlreadySubmittedException extends Exception {
	
	}    
    
}