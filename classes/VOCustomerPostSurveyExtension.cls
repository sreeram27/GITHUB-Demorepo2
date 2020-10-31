/******************************************************************************************
* Name         :    VOCustomerPostSurveyExtension
* Description  :    Class for  Web Version Visit Owner Post Survey
* Author       :    Tanuj, VisitOps
*
* Modification Log
* ---------------- 
* Date        Developer     Chg/Ticket #         Comments
* ----------- ------------- ------------- ------------------------------------------------
* 06/11/19       Tanuj        I-0399              Create Web Version Survey Page for Owners  

*******************************************************************************************/
public without sharing class VOCustomerPostSurveyExtension {
    //  Class has made without sharing because it is being developed for Sites
    public string visitId {get;set;} 
    public String attendeeId {get;set;}
    public String existingSurveyId {get;set;}
    private List<VisitOps__Visit__c> visitList {get;set;}
    public Boolean showSubmitButton {get;set;}
    public VisitOps__Visit__c visitRecord {get;set;}
    public VisitOps__Attendee__c attendeeRecord {get;set;}
    public VisitOps__Survey__c surveyRecord {get;set;}
    public String thingsToAccomplishPre {get;set;}
    public String coordinatorName {get;set;}
    public VisitOps__Survey__c preSurveyRecord{get;set;}
    public boolean flag{get;set;}
    public boolean flag1{get;set;}
    public string newString{get;set;}
    public String arrivalDate{get;set;}
    public List<AgendaPresenterWrapper> agendaPresenterWrapperList {get;set;}
    public boolean showPresentersGrid{get;set;}
    public Boolean IsAgendaSurveyExist; 
    public Boolean isPresenterSurveyExist;
    public String selectedLang{get;set;}
    public boolean isPrintForm{get;set;}
    public List<selectoption> listOfLang {get;set;}
    
    public VOCustomerPostSurveyExtension(ApexPages.StandardController controller) {
        
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
            IsAgendaSurveyExist = false;
            isPresenterSurveyExist = false;
            
            visitId = ApexPages.currentPage().getParameters().get('visitId');
            
            system.debug('selectedLang=======>'+selectedLang);
            if(visitId!=null && visitId!='') visitId = String.escapeSingleQuotes(visitId);
            else throw new ErrorOccuredException();
            
            attendeeId =ApexPages.currentPage().getParameters().get('attendeeId');
            if(attendeeId!=null && attendeeId!=''){
                 attendeeId = String.escapeSingleQuotes(attendeeId);
            }else{
                isPrintForm = true;
            }
               
            
           // else throw new ErrorOccuredException();
            showPresentersGrid = true;
            visitList = [select Id,Name,VisitOps__VisitName__c,VisitOps__ArrivalDateTime__c,VisitOps__DepartureDateTime__c,VisitOps__ArrivalDateTimeLocationTZ__c,VisitOps__DepartureDateTimeLocationTZ__c,VisitOps__Location__c,VisitOps__VisitType__c,VisitOps__Location__r.Name,VisitOps__VisitManager__c,VisitOps__VisitCoordinator__c,VisitOps__VisitCoordinator__r.Name,Owner.Name,VisitOps__VisitOwner__c,VisitOps__VisitOwner__r.Name from VisitOps__Visit__c where Id=:visitid];
            if(visitList!=null && visitList.size()>0) {
                Map<String,String> monthNamesMap = new Map<String,String>{'01'=>'January','02'=>'February','03'=>'March','04'=>'April',
                    '05'=>'May','06'=>'June','07'=>'July','08'=>'August',
                    '09'=>'September','10'=>'October','11'=>'November','12'=>'December'};
                        visitRecord = visitList[0];
                coordinatorName = visitList[0].VisitOps__VisitCoordinator__r.Name;
                List<String> arrivalDateList = visitRecord.VisitOps__ArrivalDateTimeLocationTZ__c.split('-'); //yyyy-mm-dd hh:mm:ss
                if(!arrivalDateList.isEmpty()){
                    arrivalDate = monthNamesMap.get(arrivalDateList[1])+ ' '+ arrivalDateList[2].split(' ')[0] + ', '+ arrivalDateList[0]; //Month_Name Date, Year
                }
                List<VisitOps__LocationTypeLink__c> loctyp = [select id,VisitOps__Hide_Presenters_on_Survey__c from VisitOps__LocationTypeLink__c where VisitOps__Location__c=:visitRecord.VisitOps__Location__c AND VisitOps__VisitType__c=:visitRecord.VisitOps__VisitType__c];
                if(!loctyp.isEmpty() && loctyp[0].VisitOps__Hide_Presenters_on_Survey__c){
                    showPresentersGrid = false;
                }
                

            }
            else throw new ErrorOccuredException();
            
            List<VisitOps__Attendee__c> attendeeList = [SELECT Id, Name,VisitOps__FirstName__c,VisitOps__LastName__c FROM VisitOps__Attendee__c WHERE Id = :attendeeId];
            List<VisitOps__Survey__c> surveyList;
            if(attendeeList!=null && attendeeList.size()>0){
                attendeeRecord = attendeeList[0];
                 surveyList = [select Id,VisitOps__Things_to_Accomplish__c,VisitOps__isPrint__c,VisitOps__Post_Survey_status__c from VisitOps__Survey__c where VisitOps__Visit__c=:visitId AND VisitOps__Attendee__c=:attendeeId limit 1] ;
                system.debug('surveyList : '+surveyList);
                
            }
            //else throw new ErrorOccuredException();
           
            

            if(surveyList!=null && surveyList.size()>0) {
                if(surveyList[0].VisitOps__Post_Survey_status__c) {
                    throw new SurveyAlreadySubmittedException();
                }
                else {
                    existingSurveyId = surveyList[0].Id;
                    preSurveyRecord=surveyList[0];
                    thingsToAccomplishPre = surveyList[0].VisitOps__Things_to_Accomplish__c;
                }
            }
            if(existingSurveyId==null){
                surveyRecord = new VisitOps__Survey__c();
            }else{
                surveyRecord = new VisitOps__Survey__c(id=existingSurveyId);
            }

            showSubmitButton = attendeeRecord != null ? true : false;


            //List<Agenda__c> agendaList = [select Id,Agenda_Title__c,Name,(select Id,Presenter_Name__c from Presenter_Agenda_Links__r where Status__c='Accepted') from Agenda__c where Visit__c= :visitId];
            
            /** fetching all the Agenda Survey related to Survey **/
            List<VisitOps__Agenda_Survey__c> FetchAgendaList = new List<VisitOps__Agenda_Survey__c>();
            Map<Id, VisitOps__Agenda_Survey__c> AgendaSurveyWithAgendaMap = new Map<Id, VisitOps__Agenda_Survey__c>();
            
            /** fetching all the Presenter Survey related to Agenda Survey **/
            Map<Id, VisitOps__Presenter_Survey__c> presenterSurveyWithAgendaSurveyMap = new Map<Id, VisitOps__Presenter_Survey__c>();
            Set<Id> agendaSurveyIds = new Set<Id>();
            
            if(existingSurveyId != Null){
                FetchAgendaList = [select Id, Name, VisitOps__Agenda__c, VisitOps__Agenda__r.VisitOps__Agenda_Title__c,  VisitOps__Agenda__r.Id, VisitOps__Session_Rating__c , VisitOps__Comments__c from VisitOps__Agenda_Survey__c where VisitOps__Survey__c=:surveyRecord.Id];             
                
                if(!FetchAgendaList.isEmpty()){
                    
                    for(VisitOps__Agenda_Survey__c obj : FetchAgendaList){
                        
                        AgendaSurveyWithAgendaMap.put(obj.VisitOps__Agenda__c, obj);  
                        agendaSurveyIds.add(obj.Id);  
                    }
                    
                }
                
                if(!agendaSurveyIds.isEmpty()){
                    
                    List<VisitOps__Presenter_Survey__c> fetchPresenterSurvey = new List<VisitOps__Presenter_Survey__c>();
                    fetchPresenterSurvey = [select Id, VisitOps__Agenda_Survey__c, VisitOps__Comments__c, VisitOps__Presenter__c, VisitOps__Presenter_Agenda_Link__c, 
                                            VisitOps__Presenter_Agenda_Link__r.Id, VisitOps__Presenter_Agenda_Link__r.VisitOps__Presenter_Name__c, VisitOps__Presenter_Rating__c
                                            from VisitOps__Presenter_Survey__c where VisitOps__Agenda_Survey__c IN:agendaSurveyIds]; 
                    
                    for(VisitOps__Presenter_Survey__c obj : fetchPresenterSurvey){
                        presenterSurveyWithAgendaSurveyMap.put(obj.VisitOps__Presenter_Agenda_Link__c, obj);
                    }
                    
                }
            }
            
            List<VisitOps__Agenda__c> agendaList = [select Id,VisitOps__Agenda_Title__c,Name,(select Id,VisitOps__Presenter_Name__c from VisitOps__Presenter_Agenda_Links__r where VisitOps__Status__c='Accepted') from VisitOps__Agenda__c where VisitOps__Visit__c= :visitId AND VisitOps__Show_on_Customer_Survey__c = true order by VisitOps__Start_Time__c,VisitOps__Agenda_Title__c];
            
            AgendaPresenterWrapper agendaPresenterWrapperRecord;
            VisitOps__Agenda_Survey__c agendaSurveyRecord;
            VisitOps__Presenter_Survey__c tempPresenterSurveyRecord;
            List<VisitOps__Presenter_Survey__c> tempAgendaPresenterList;
            agendaPresenterWrapperList = new List<AgendaPresenterWrapper>();
            
            for(VisitOps__Agenda__c each : agendaList){
                
                if(!AgendaSurveyWithAgendaMap.isEmpty() && AgendaSurveyWithAgendaMap.containsKey(each.Id)){
                    agendaSurveyRecord = AgendaSurveyWithAgendaMap.get(each.Id);
                    IsAgendaSurveyExist = true;
                }else{                    
                    agendaSurveyRecord = new VisitOps__Agenda_Survey__c(VisitOps__Agenda__r=each,VisitOps__Agenda__c=each.Id);
                }
                
                tempAgendaPresenterList = null;
                if(each.VisitOps__Presenter_Agenda_Links__r!=null && each.VisitOps__Presenter_Agenda_Links__r.size()>0) {
                    tempagendaPresenterList = new List<VisitOps__Presenter_Survey__c>();
                    for(VisitOps__Presenter_Agenda_Link__c eachPresenterLink : each.VisitOps__Presenter_Agenda_Links__r) {
                        system.debug('eachPresenterLink :: '+eachPresenterLink);
                        if(!presenterSurveyWithAgendaSurveyMap.isEmpty() && presenterSurveyWithAgendaSurveyMap.containsKey(eachPresenterLink.Id)){
                            tempPresenterSurveyRecord = presenterSurveyWithAgendaSurveyMap.get(eachPresenterLink.Id);
                            isPresenterSurveyExist = true;
                        }else{
                            tempPresenterSurveyRecord = new VisitOps__Presenter_Survey__c(VisitOps__Presenter_Agenda_Link__r=eachPresenterLink,VisitOps__Presenter_Agenda_Link__c=eachPresenterLink.Id);                        
                        }
                        
                        tempagendaPresenterList.add(tempPresenterSurveyRecord);
                    }
                }
                agendaPresenterWrapperRecord = new AgendaPresenterWrapper(agendaSurveyRecord,tempAgendaPresenterList);
                agendaPresenterWrapperList.add(agendaPresenterWrapperRecord);
                
                
            }
            
        }
        catch (SurveyAlreadySubmittedException ex) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, System.Label.VisitOps.Survey_Already_Submitted));}
        catch(Exception ex) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, System.Label.VisitOps.Survey_Loading_Error));System.debug('Exception occured:'+ex.getMessage());System.debug('=:Line Number:='+ex.getLineNumber());}
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
        //newString =fullFileURL+'/servlet/servlet.FileDownload?file='+d[0].id+'&oid='+UserInfo.getOrganizationId()+'" alt="User-added image">';
        newString = System.Label.VisitOps.VisitOps_Site_Url +'/servlet/servlet.FileDownload?file='+d[0].id+'&oid='+UserInfo.getOrganizationId()+'" alt="User-added image">';
        return newString;
    }
    public string getDocumentFooterUrl()
    {
        
        list<Document> d = [Select Id,LastModifiedById,DeveloperName from Document where DeveloperName = 'Survey_Footer'];
        String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
        //newString =fullFileURL+'/servlet/servlet.FileDownload?file='+d[0].id+'&oid='+UserInfo.getOrganizationId()+'" alt="User-added image">';
        newString = System.Label.VisitOps.VisitOps_Site_Url +'/servlet/servlet.FileDownload?file='+d[0].id+'&oid='+UserInfo.getOrganizationId()+'" alt="User-added image">';
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
    
    
    
    public List<SelectOption> getRadioOptsforAgenda(){
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
    
    
    public List<SelectOption> getPicklistOpts(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Strongly Disagree','Strongly Disagree'));
        options.add(new SelectOption('Disagree','Disagree'));
        options.add(new SelectOption('Neutral','Neutral')); 
        options.add(new SelectOption('Agree','Agree')); 
        options.add(new SelectOption('Strongly Agree','Strongly Agree')); 
        return options; 
    }
    
    
    public List<SelectOption> getPicklistOptsforPerception(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Improved','Improved'));
        options.add(new SelectOption('Stayed the Same','Stayed the Same'));
        options.add(new SelectOption('Declined','Declined')); 
        return options; 
    }
    
    public List<SelectOption> getPercentRadioOpts(){
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('10','10%')); 
        options.add(new SelectOption('20','20%')); 
        options.add(new SelectOption('30','30%')); 
        options.add(new SelectOption('40','40%')); 
        options.add(new SelectOption('50','50%')); 
        options.add(new SelectOption('60','60%')); 
        options.add(new SelectOption('70','70%')); 
        
        return options; 
    }
    public List<SelectOption> getRadio(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes',''));
        options.add(new SelectOption('SomeWhat','')); 
        options.add(new SelectOption('NotReally','')); 
        options.add(new SelectOption('N/A','')); 
        return options; 
    }
    public PageReference submitSurvey() {
        System.debug('SubmitSurvey');
        Savepoint sp = Database.setSavepoint();
        if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__User_Type__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__User_Type__c.isUpdateable()){
            surveyRecord.VisitOps__User_Type__c='Customer';
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
        if(Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__isPrint__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__isPrint__c.isUpdateable()){
            surveyRecord.VisitOps__isPrint__c = false;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
            return null;
        }
      /*
       *   String output =  String.valueOf(surveyRecord.VisitOps__Likely_To_Recommend_Post__c);
        if(output == 'N/A'){
            surveyRecord.VisitOps__Likely_To_Recommend_Post__c = null;
        }
		*/
        
        
        flag=true;  
        flag1=true; 
        try{
            List<RecordType> rtList = [select Id,DeveloperName,Name from RecordType where DeveloperName='Customer_Survey' limit 1];
            if(rtList!=null && rtList.size()>0){ 
                if((Schema.SObjectType.VisitOps__Survey__c.Fields.RecordTypeId.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.RecordTypeId.isUpdateable())){
                    surveyRecord.RecordTypeId = rtList[0].Id;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
                    return null;
                }
            }
            if(visitId!= null && String.isNotEmpty(visitId) && (existingSurveyId==null)){
                
                if((Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit__c.isUpdateable())){
                    surveyRecord.VisitOps__Visit__c = visitId;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
                    return null;
                }
            }
            if(attendeeId!= Null && String.isNotEmpty(attendeeId)){
                if((Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Attendee__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Attendee__c.isUpdateable())){
                    surveyRecord.VisitOps__Attendee__c = attendeeId;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Permissions_Error_Message));
                    return null;
                }
            }
            
            if(visitList!=null && visitList.size()>0){
                if((Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit_Owner__c.isCreateable() || Schema.SObjectType.VisitOps__Survey__c.Fields.VisitOps__Visit_Owner__c.isUpdateable())) {
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
            }
            else {
                if(!Schema.SObjectType.VisitOps__Survey__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.VisitOps.Survey_Update_Error_Message));
                    return null;
                }
                update surveyRecord;
            }       
          System.debug('surveyRecord DML');  
            
            List<VisitOps__Agenda_Survey__c> agendaSurveyList = new List<VisitOps__Agenda_Survey__c>();
            List<VisitOps__Presenter_Survey__c> presenterSurveyList = new List<VisitOps__Presenter_Survey__c>();
            List<VisitOps__Presenter_Survey__c> tempPresenterSurveyList;
            Map<Id,List<VisitOps__Presenter_Survey__c>> agendaPresenterSurveyMap = new Map<Id,List<VisitOps__Presenter_Survey__c>>();
            for(AgendaPresenterWrapper each : agendaPresenterWrapperList) {
                if(Schema.SObjectType.VisitOps__Agenda_Survey__c.Fields.VisitOps__Survey__c.isCreateable() || Schema.SObjectType.VisitOps__Agenda_Survey__c.Fields.VisitOps__Survey__c.isUpdateable()){
                    
                    if(!IsAgendaSurveyExist){
                        each.agendaSurvey.VisitOps__Survey__c = surveyRecord.Id;
                    }
                    
                    system.debug('=:each.agendaSurvey.VisitOps__Session_Rating__c:='+each.agendaSurvey.VisitOps__Session_Rating__c);
                    system.debug('=:each.agendaSurvey.Id:='+each.agendaSurvey.Id);
                    
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
                upsert agendaSurveyList;
                
                for(VisitOps__Agenda_Survey__c each : agendaSurveyList) {
                    tempPresenterSurveyList = agendaPresenterSurveyMap.get(each.VisitOps__Agenda__r.Id);
                    
                    if(tempPresenterSurveyList!=null && tempPresenterSurveyList.size()>0) {
                        for(VisitOps__Presenter_Survey__c pSurvey : tempPresenterSurveyList) {
                            if(Schema.SObjectType.VisitOps__Presenter_Survey__c.Fields.VisitOps__Agenda_Survey__c.isCreateable() || Schema.SObjectType.VisitOps__Presenter_Survey__c.Fields.VisitOps__Agenda_Survey__c.isUpdateable()){
                                
                                if(!isPresenterSurveyExist){
                                    pSurvey.VisitOps__Agenda_Survey__c = each.Id;
                                }
                                
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
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Access Denied for Presenter Survey'));
                        return null;
                    }
                    upsert presenterSurveyList;
                }
            }
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.CONFIRM, System.Label.VisitOps.Survey_Success_Message));      
            showSubmitButton = false;
            return null;        
        }
        
        catch(DMLException ex){Database.rollback(sp);ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));return null;}
        catch(Exception ex) {Database.rollback(sp);ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.VisitOps.Survey_Committing_Error));return null;}
        
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