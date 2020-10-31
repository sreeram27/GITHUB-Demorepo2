/******************************************************************************************
* Name         :    VOOwnerPostSurveyExtension
* Description  :    Class for  Web Version Visit Owner Post Survey
* Author       :    Tanuj, VisitOps 
* 
* Modification Log
* ---------------- 
* Date        Developer     Chg/Ticket #         Comments
* ----------- ------------- ------------- ------------------------------------------------
* 06/11/19       Tanuj        I-0399              Create Web Version Survey Page for Owners
* 08/26/19       Neha         I-0610              Updated Line 87, added ORDER BY
* 01/16/20       Kalpana      I-0899              Updated the recordType query  

*******************************************************************************************/
public without sharing class VOOwnerPostSurveyExtension {

    public string visitId {get;set;}
    public String attendeeId {get;set;}
    public String userId {get;set;}
    private String existingSurveyId {get;set;}
    public Boolean showSubmitButton {get;set;}
    private List<VisitOps__Visit__c> visitList{get;set;}
    public VisitOps__Visit__c visitRecord {get;set;}
    public VisitOps__Attendee__c attendeeRecord {get;set;}
    public User userRecord {get;set;}
    public VisitOps__Survey__c surveyRecord {get;set;}
    public VisitOps__Survey__c preSurveyRecord {get;set;}
    public String coordinatorName {get;set;}
    public String visitOwnerName {get;set;}
    public String location {get;set;}
    public boolean flag{get;set;}
    public string newString{get;set;}
    public boolean flag1{get;set;}
    public List<AgendaPresenterWrapper> agendaPresenterWrapperList {get;set;}
    public String selectedLang{get;set;}
    public boolean isPrintForm{get;set;}
    public List<selectoption> listOfLang {get;set;}
    
    public VOOwnerPostSurveyExtension (ApexPages.StandardController controller) {
        listOfLang = new List<selectOption>();

        Schema.DescribeFieldResult fieldResult = VisitOps__Attendee__c.VisitOps__Survey_Language__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
        for( Schema.PicklistEntry f : ple){
            listOfLang.add(new SelectOption(f.getValue(), f.getLabel()));
        }

        selectedLang = ApexPages.currentPage().getParameters().get('lang');

        constructorCode();
        
    }

    public PageReference constructorCode(){

        try {
            flag=false;
            flag1=false;
            agendaPresenterWrapperList = new List<AgendaPresenterWrapper>();
            visitId = ApexPages.currentPage().getParameters().get('visitId');
            if(visitId!=null && visitId!='') visitId = String.escapeSingleQuotes(visitId);
            else throw new ErrorOccuredException();
            
            attendeeId = ApexPages.currentPage().getParameters().get('attendeeId');
            if(attendeeId!=null && attendeeId!='') attendeeId = String.escapeSingleQuotes(attendeeId);
            
            userId = ApexPages.currentPage().getParameters().get('userId');
            if(userId!=null && userId!='') userId = String.escapeSingleQuotes(userId);
            
            if((userId==null||userId=='') && (attendeeId==null||attendeeId=='')){
              isPrintForm = true;
            }
                
            
            visitList = [select Id,Name,VisitOps__VisitName__c,VisitOps__ArrivalDateTime__c,VisitOps__DepartureDateTime__c,VisitOps__ArrivalDateTimeLocationTZ__c,VisitOps__DepartureDateTimeLocationTZ__c, VisitOps__Arrival_Date_and_Time_LocationFormula__c, VisitOps__Departure_Date_and_Time_LocationFormula__c, VisitOps__Location__c,VisitOps__Location__r.Name,VisitOps__VisitManager__c,VisitOps__VisitCoordinator__c,VisitOps__VisitCoordinator__r.Name,Owner.Name,VisitOps__VisitOwner__r.Name,VisitOps__VisitOwner__c from VisitOps__Visit__c where Id=:visitid];
            if(visitList!=null && visitList.size()>0) {
                visitRecord = visitList[0];
                system.debug('visitRecord.LocationName : '+visitRecord.VisitOps__Location__r.Name);
                location = visitList[0].VisitOps__Location__r.Name;
                coordinatorName = visitList[0].VisitOps__VisitCoordinator__r.Name;
                visitOwnerName = visitList[0].VisitOps__VisitOwner__r.Name;               
            }
            else throw new ErrorOccuredException();
        
            List<VisitOps__Attendee__c> attendeeList = [SELECT Id, Name,VisitOps__FirstName__c,VisitOps__LastName__c FROM VisitOps__Attendee__c WHERE Id = :attendeeId];
            if(attendeeList!=null && attendeeList.size()>0) attendeeRecord = attendeeList[0];
            
system.debug('userId===='+userId);

            List<User> userList = [select Id,Name from User where Id=:userId];
            system.debug('userList===='+userList);
            if(userList!=null && userList.size()>0) userRecord = userList[0];

            system.debug('userRecord===='+userRecord);
            
            if(attendeeRecord==null && userRecord==null){
               showSubmitButton = false; 
            }else{
                showSubmitButton = true; 
            }
            //  throw new ErrorOccuredException();
            
            List<VisitOps__Survey__c> surveyList = [select Id,VisitOps__Post_Survey_status__c from VisitOps__Survey__c where VisitOps__Visit__c=:visitId AND VisitOps__Attendee__c=:attendeeId AND VisitOps__User__c=:userId limit 1] ;
            if(surveyList!=null && surveyList.size()>0) {
                if(surveyList[0].VisitOps__Post_Survey_status__c) {
                    throw new SurveyAlreadySubmittedException();
                }
                else {
                    existingSurveyId = surveyList[0].Id;
                    preSurveyRecord = surveyList[0];
                }
            }
            if(existingSurveyId==null){
                surveyRecord = new VisitOps__Survey__c();
            }else{
                surveyRecord = new VisitOps__Survey__c(id=existingSurveyId);
            }
            
            
            //List<Agenda__c> agendaList = [select Id,Agenda_Title__c,Topic__r.TopicCategory__c,Name,(select Id,Presenter_Name__c from Presenter_Agenda_Links__r where Status__c='Accepted') from Agenda__c where Visit__c= :visitId AND Topic__r.TopicCategory__c!='Instructions and Meals'];
            //Exclude Agendas of Type 'Instructions' from post surveys
            List<VisitOps__Agenda__c> agendaList = [SELECT Id,VisitOps__Agenda_Title__c,VisitOps__Topic__r.VisitOps__TopicCategory__c,Name,(select Id,VisitOps__Presenter_Name__c FROM VisitOps__Presenter_Agenda_Links__r WHERE VisitOps__Status__c='Accepted') FROM VisitOps__Agenda__c where VisitOps__Visit__c= :visitId AND VisitOps__Topic__r.VisitOps__TopicCategory__c!='Instructions' ORDER BY VisitOps__Start_Time__c,VisitOps__Agenda_Title__c];
                
            AgendaPresenterWrapper agendaPresenterWrapperRecord;
            VisitOps__Agenda_Survey__c agendaSurveyRecord;
            VisitOps__Presenter_Survey__c tempPresenterSurveyRecord;
            List<VisitOps__Presenter_Survey__c> tempAgendaPresenterList;
            
            for(VisitOps__Agenda__c each : agendaList){
                agendaSurveyRecord = new VisitOps__Agenda_Survey__c(VisitOps__Agenda__r=each,VisitOps__Agenda__c=each.Id);
                tempAgendaPresenterList = null;
                if(each.VisitOps__Presenter_Agenda_Links__r!=null && each.VisitOps__Presenter_Agenda_Links__r.size()>0) {
                    tempagendaPresenterList = new List<VisitOps__Presenter_Survey__c>();
                    for(VisitOps__Presenter_Agenda_Link__c eachPresenterLink : each.VisitOps__Presenter_Agenda_Links__r) {
                        tempPresenterSurveyRecord = new VisitOps__Presenter_Survey__c(VisitOps__Presenter_Agenda_Link__r=eachPresenterLink,VisitOps__Presenter_Agenda_Link__c=eachPresenterLink.Id);
                        tempagendaPresenterList.add(tempPresenterSurveyRecord);
                    }
                }
                agendaPresenterWrapperRecord = new AgendaPresenterWrapper(agendaSurveyRecord,tempAgendaPresenterList);
                agendaPresenterWrapperList.add(agendaPresenterWrapperRecord);
            }           
        }catch (SurveyAlreadySubmittedException ex) {
            flag=true;            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, System.Label.VisitOps.Survey_Already_Submitted));
            return null;
        }catch(Exception ex) {
            
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, System.Label.VisitOps.Survey_Loading_Error));
           System.debug('Exception occured:'+ex.getMessage());
           System.debug('Exception occured:'+ex.getLineNumber());
            return null;
        }

        return null;
    }

    public PageReference refreshPage() {
        constructorCode();
        return null;
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


    public List<SelectOption> getRadioOptsNoLabel(){
            List<SelectOption> options = new List<SelectOption>(); 

            options.add(new SelectOption('1',''));
            options.add(new SelectOption('2','')); 
            options.add(new SelectOption('3','')); 
            options.add(new SelectOption('4','')); 
            options.add(new SelectOption('5','')); 
            options.add(new SelectOption('6','')); 
            options.add(new SelectOption('7','')); 
            
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
    
    public PageReference submitSurvey() {
        
        Savepoint sp = Database.setSavepoint();
        if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__User_Type__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__User_Type__c.isUpdateable()){
            surveyRecord.VisitOps__User_Type__c='Owner';
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
            return null;
        }
        if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Post_Survey_status__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Post_Survey_status__c.isUpdateable()){
            surveyRecord.VisitOps__Post_Survey_status__c=true;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
            return null;
        }
        
        flag=true;
        flag1=true;     
        try{
           // List<RecordType> rtList = [select Id,DeveloperName,Name from RecordType where DeveloperName='VisitOps__Visit_Owner_Survey' limit 1];
            List<RecordType> rtList = [select Id,DeveloperName,Name from RecordType where DeveloperName='Visit_Owner_Survey' limit 1]; 
            if(rtList!=null && rtList.size()>0){ 
                if((Schema.SObjectType.VisitOps__Survey__c.Fields.RecordTypeId.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.RecordTypeId.isUpdateable())){
                surveyRecord.RecordTypeId = rtList[0].Id;
                system.debug(' rtList[0].Id:'+ rtList[0].Id);
                system.debug('surveyRecord.RecordTypeId'+surveyRecord.RecordTypeId);    
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
                return null;
            }
            }
        
            if(visitId!= null && String.isNotEmpty(visitId) && (existingSurveyId==null)){
                surveyRecord.VisitOps__Visit__c = visitId;
            }
            if(attendeeId!= Null && String.isNotEmpty(attendeeId)){
                if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Attendee__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Attendee__c.isUpdateable()){
                    surveyRecord.VisitOps__Attendee__c = attendeeId;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
                    return null;
                }
            }
            if(userId!=null && String.isNotEmpty(userId)){
                if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__User__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__User__c.isUpdateable()){
                    surveyRecord.VisitOps__User__c = userId;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
                    return null;
                }
            }
            if(visitList!=null && visitList.size()>0){
                if((Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit_Owner__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit_Owner__c.isUpdateable())){
                surveyRecord.VisitOps__Visit_Owner__c = visitList[0].VisitOps__VisitOwner__c;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
                return null;
            }
            }
        
            
            if(existingSurveyId==null){
                if(!Schema.SObjectType.VisitOps__Survey__c.isCreateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Survey_Create_Error_Message));
                    return null;
                }
                insert surveyRecord;
            }else {
                if(!Schema.SObjectType.VisitOps__Survey__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Survey_Update_Error_Message));
                    return null;
                }
                update surveyRecord;
            }       
            
            
            List<VisitOps__Agenda_Survey__c> agendaSurveyList = new List<VisitOps__Agenda_Survey__c>();
            List<VisitOps__Presenter_Survey__c> presenterSurveyList = new List<VisitOps__Presenter_Survey__c>();
            List<VisitOps__Presenter_Survey__c> tempPresenterSurveyList;
            Map<Id,List<VisitOps__Presenter_Survey__c>> agendaPresenterSurveyMap = new Map<Id,List<VisitOps__Presenter_Survey__c>>();
            for(AgendaPresenterWrapper each : agendaPresenterWrapperList) {
                if(Schema.SObjectType.VisitOps__Agenda_Survey__c.Fields.VisitOps__Survey__c.isCreateable() || Schema.SObjectType.VisitOps__Agenda_Survey__c.Fields.VisitOps__Survey__c.isUpdateable()){
                    each.agendaSurvey.VisitOps__Survey__c = surveyRecord.Id;
                    agendaSurveyList.add(each.agendaSurvey);
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
                    return null;
                }
                agendaPresenterSurveyMap.put(each.agendaSurvey.VisitOps__Agenda__r.Id,each.presenterSurveyList);
            }
            System.debug('agendaPresenterSurveyMap-->:'+agendaPresenterSurveyMap);
            if(agendaSurveyList!=null && agendaSurveyList.size()>0) {
                if(!Schema.SObjectType.VisitOps__Agenda_Survey__c.isCreateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Agenda_Survey_Error_Message));
                    return null;
                }
                insert agendaSurveyList;
            
                for(VisitOps__Agenda_Survey__c each : agendaSurveyList) {
                    tempPresenterSurveyList = agendaPresenterSurveyMap.get(each.VisitOps__Agenda__r.Id);

                    if(tempPresenterSurveyList!=null && tempPresenterSurveyList.size()>0) {
                        for(VisitOps__Presenter_Survey__c pSurvey : tempPresenterSurveyList) {
                            if(Schema.SObjectType.VisitOps__Presenter_Survey__c.Fields.VisitOps__Agenda_Survey__c.isCreateable() || Schema.SObjectType.VisitOps__Presenter_Survey__c.Fields.VisitOps__Agenda_Survey__c.isUpdateable()){
                                pSurvey.VisitOps__Agenda_Survey__c = each.Id;
                                presenterSurveyList.add(pSurvey);
                            }else{
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
                                return null;
                            }
                        }   
                    }
                }
                
                if(presenterSurveyList!=null && presenterSurveyList.size()>0) {
                    if(!Schema.SObjectType.VisitOps__Presenter_Survey__c.isCreateable()){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Presenter_Survey_Error_Message));
                        return null;
                    }
                    insert presenterSurveyList;
                }
            }
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.CONFIRM, System.Label.VisitOps.Survey_Success_Message));      
            showSubmitButton = false;
            return null;        
        }
        
        catch(DMLException ex){
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
            return null;        
        }
        catch(Exception ex) {
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.VisitOps.Survey_Committing_Error));          
            return null;
        }
        
    }
    
    
    //wrapper class for agendas
    
    public class AgendaPresenterWrapper{
        public VisitOps__Agenda_Survey__c agendaSurvey {get;set;}
        public List<VisitOps__Presenter_Survey__c> presenterSurveyList {get;set;}
         
        public AgendaPresenterWrapper(VisitOps__Agenda_Survey__c agendaSurvey, List<VisitOps__Presenter_Survey__c> presenterSurveyList){
            this.agendaSurvey = agendaSurvey;
            this.presenterSurveyList = presenterSurveyList;
        }
    }
    
    // Define Exception classes
    public class ErrorOccuredException extends Exception {
    
    }
    public class SurveyAlreadySubmittedException extends Exception {
    
    }
}