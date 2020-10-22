public without Sharing class OEAmbSignupController{
    /*************************************************************************
* Purpose:  Controller for meeting volunteer form
* Mod:      6/15/2014
* @Author:   Tony Angle
**************************************************************************
* Mod:      7/7/2014 -  Changed location of css and external resources for
*                       public consumption TA
*           7/16/2014 - Changed sort items per Colleen and team TA
*           7/17/2014 - Corrected email going out Volunteer Name TA
*           9/4/2015 -  Adding filters to meeting query based upon user profile - LG
*           6/1/2016 -  Sort order by Local Ambassador only - LG
*           6/14/2016 - If person is consultant(external), render different meetings, 
*            table columns, get travel distance, etc.
*           SPRINT 192.4-XMen - Shifted from COM1
*           Modification - OE_AMB_Facilitator__c replaced with Contact
**************************************************************************
* Mod                 : 9/12/2019
* @Author           : Mehaboob
* @description        : added @TestVisible for isInMap 
*                       Removed below methods as these are not used anywhere.
*                       Class was lifted and shifted from COM1,these methods were part of that .
*                       getMainCSSFile
*                       getOEMapFile
**************************************************************************
* Mod                 : 1/28/2020
* @Author           : Poonam
* @description        : Added two conditions for fields Selected_For_Facilitator__c and 
*                       Thanks_but_No_Thanks__c to method volunteer()
**************************************************************************/
    
    public Boolean isConsultant {get;set;}
    public List<RelatedMeetingWrapper> meetingWrappers{get; set;}
    public Boolean isRelatedMeetings {get; set;}
    public Boolean relatedMeetingsAreSet = false;
    public decimal flightCost {get;set;}
    public decimal hotelCost {get;set;}
    public decimal carRentalPerDay {get;set;}
    
    @TestVisible private Contact personContact { get; set;}
    public Boolean disabledTravel = false;
    public Boolean validResponse = true;  
    public final String URGENT_LABEL = 'Urgent';
    public final Set<String> regionsToAdd = new Set<String>{'Central', 'West', 'North West', 'South East', 'West', 'North East'};
    public final Set<String> specialRegionsToAdd = new Set<String>{'Buddy Eligible','GRS', 'Specialty/Voluntary', 'Virtual (Webinar)'};
    public static final String FACNEEDED = 'Yes';
    private static final Integer MAX_RELATED_MEETING_DISTANCE = 200;
    private Set<Date> datesAlreadySignedUp;
    
    public Boolean getDisabledTravel() {
        return disabledTravel;
    }
    
    public Boolean getValidResponse() {
        return validResponse;
    }
    public String stateorRegion {get;set;}
    public String buddyProgramResponse {get;set;}
    public String sortBy {get;set;}
    public Boolean sortAsc {get;set;}
    public String searchmeetingName {get;set;}
    public Boolean showSearch {get;set;}
    public Boolean showMeeting {get;set;}
    public Boolean showThankYou {get;set;}
    public Boolean showMgrApproval {get;set;}
    public SFDC_Volunteer_Event__c selectedMeeting {get;set;}
    public Boolean personCleared {get;set;}
    public String volComments {get;set;}
    
    @TestVisible private String selectedContact;
    @TestVisible private String urlfacId = ApexPages.currentpage().getParameters().get('facId');
    @TestVisible private String urlEmail = ApexPages.currentpage().getParameters().get('email');
    @TestVisible private String meetingId = ApexPages.currentpage().getParameters().get('MeetingId');
    @TestVisible private String userRegions;
    private String instanceURL = URL.getSalesforceBaseUrl().toExternalForm();   
        
    public OEAmbSignupController() {
        showMgrApproval = false;
        showSearch=true;         
        // if url contains meeting id, go to that event        
        if (meetingId != null) {
            selectMeeting();
        }
    }
    
    public Map<Id, DisDurMeetingWrap> disDurEvent {
        get {
            if (disDurEvent == NULL) { 
                disDurEvent = new Map<Id, DisDurMeetingWrap>();                
            }                             
            return disDurEvent;
        }
        set;
    }
    
    @TestVisible
    public Boolean isInMap {
        get {       
            if(disDurEvent==Null || disDurEvent.isEmpty() ) {
                return false;
            } else {
                return disDurEvent.containskey(selectedMeeting.Id);
            }           
        }
    }
    
    //*** class to preserve temporary computed duraton/distance for meeting, since user has to always make callout to google api for selected meeting
    public class DisDurMeetingWrap {
        public String meetingDistance { get; set;}
        public String meetingDuration { get; set;}
        
        public DisDurMeetingWrap(String distance, String duration) {
            this.meetingDistance = distance;
            this.meetingDuration = duration;                    
        }  
    }        
    
    {
        sortAsc=true;   showMgrApproval=false; 
        personCleared=isPersonCleared(urlfacId, urlEmail);        
    }
    
    public pageReference openSearch(){
        showThankYou=false;  showSearch=true;
        showMgrApproval=false;
        return null;
    }
    
    public PageReference editProfile() {        
        PageReference pageRef = Page.OEAmbassadorOnBoardingSurvey;
        pageRef.getParameters().put('facId', urlfacId);
        pageRef.getParameters().put('email', urlEmail);        
        if (selectedMeeting != NULL && selectedMeeting.Id != NULL) {
            pageRef.getParameters().put('meetingId', selectedMeeting.Id);
        }         
        return pageRef;
    }     
    
    public List<SFDC_Volunteer_Event__c> queryRelatedMeetings() {
        Id groupingId = selectedMeeting.OE_Grouping__c;
        List<SFDC_Volunteer_Event__c> relatedMeetings = new List<SFDC_Volunteer_Event__c>();
        Date fiveDaysBefore = selectedMeeting.Date__c.addDays(-5);
        Date fiveDaysAfter = selectedMeeting.Date__c.addDays(5);        
        datesAlreadySignedUp = getUpdatedDatesSignedUp();        
        Id selectedMeetingId = selectedMeeting.Id;  
        
        String baseQueryString = 'SELECT Bilingual__c, Account_Name__c, Meeting_Type__c, Meeting_Street__c, Meeting_City__c, Meeting_State__c,'+ 
            'Meeting_Zip_Code__c, Expected_of_Employees__c, Buddy_Program_Eligible__c, Dates_Flexible__c, Meeting_Stage__c,'+
            'Local_Ambassador_Only__c, Location__c, Location__Latitude__s, Location__Longitude__s, Recruitment_of_Facilitator_Needed__c,'+
            'Facilitator_Being_Recruited__c, Recruit_Consultant__c, Facilitator_Secured__c, Date__c FROM sfdc_volunteer_event__c ';
        // if person is external consultant
        if (isConsultant) {
            
            baseQueryString += ' WHERE Recruitment_of_Facilitator_Needed__c=:FACNEEDED AND Facilitator_Secured__c=false'+                
                ' AND Date__c >= :fiveDaysBefore AND Date__c <= :fiveDaysAfter AND Date__c NOT IN :datesAlreadySignedUp'+
                ' AND( Meeting_Stage__c =\'SUBMITTED\' OR Meeting_Stage__c =\'Submitted - Rush\' OR Meeting_Stage__c =\'In Process\')'+
                ' AND Facilitator_Being_Recruited__c = true AND Recruit_Consultant__c = true'+                              
                ' AND Id NOT IN (select Volunteer_Event__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__c = :selectedContact)';            
            
        } else {
            
            baseQueryString += ' WHERE Recruitment_of_Facilitator_Needed__c=:FACNEEDED AND Facilitator_Secured__c=false' +                
                ' AND Date__c >= :fiveDaysBefore AND Date__c <= :fiveDaysAfter AND Date__c NOT IN :datesAlreadySignedUp' +
                ' AND( Meeting_Stage__c =\'SUBMITTED\' OR Meeting_Stage__c =\'Submitted - Rush\' OR Meeting_Stage__c =\'In Process\')' +               
                ' AND Id NOT IN (select Volunteer_Event__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__c = :selectedContact)' +
                ' AND Buddy_Program_Eligible__c = false'; 
        }
        baseQueryString += ' AND OE_Grouping__c = :groupingId AND Id != :selectedMeetingId ORDER BY Date__c ASC LIMIT 50';  
        relatedMeetings = Database.query(baseQueryString);              
        return relatedMeetings;
    } 
    
    public List<RelatedMeetingWrapper> getUpdatedRelatedMeetings() {
        relatedMeetingsAreSet = true;        
        List<SFDC_Volunteer_Event__c> updatedRelatedMeetings = queryRelatedMeetings(); 
        List<RelatedMeetingWrapper> updatedWrappers = new List<RelatedMeetingWrapper>();
        Map<Id, String> existingRelatedMeetingsMap = new Map<Id, String>();
        
        for(RelatedMeetingWrapper meetingWrapper : meetingWrappers) {
            existingRelatedMeetingsMap.put(meetingWrapper.meeting.Id, meetingWrapper.distance);
        }
        
        for(SFDC_Volunteer_Event__c meeting : updatedRelatedMeetings) {
            if(existingRelatedMeetingsMap.get(meeting.Id) != null && meeting.Id != selectedMeeting.Id && meeting.Date__c != selectedMeeting.Date__c) {
                updatedWrappers.add(new RelatedMeetingWrapper(meeting, existingRelatedMeetingsMap.get(meeting.Id)));
            }
        }               
        return updatedWrappers;
    }    
    
    public List<RelatedMeetingWrapper> getRelatedMeetingsForDistance(){
        
        if(relatedMeetingsAreSet == false) {            
            List<SFDC_Volunteer_Event__c> relatedMeetings = queryRelatedMeetings(); 
            if(relatedMeetings.size() > 0){
                List<SFDC_Volunteer_Event__c> relatedMeetingsWithinDistance = new List<SFDC_Volunteer_Event__c>();                
                List<TravelResponseService.Point> origins = new List<TravelResponseService.Point>();
                List<TravelResponseService.Point> destinations = new List<TravelResponseService.Point>();
                
                origins.add(new TravelResponseService.Point(selectedMeeting.Location__latitude__s, selectedMeeting.Location__Longitude__s));                
                for(SFDC_Volunteer_Event__c event : relatedMeetings){
                    if(event.Location__c != NULL && Location.newInstance(event.Location__Latitude__s, event.Location__Longitude__s).getDistance(Location.newInstance(selectedMeeting.Location__Latitude__s, selectedMeeting.Location__Longitude__s), 'mi') <= MAX_RELATED_MEETING_DISTANCE){
                        destinations.add(new TravelResponseService.Point(event.Location__latitude__s, event.Location__Longitude__s));
                        relatedMeetingsWithinDistance.add(event);                        
                    }                    
                }               
                
                if(origins.size() > 0 && destinations.size() > 0){
                    try{                        
                        Map<SFDC_Volunteer_Event__c, String> relatedMeetingsToDistancesMap = new Map<SFDC_Volunteer_Event__c, String>();
                        
                        TravelResponseService.TravelResponse response = TravelResponseService.sendRequest(origins, destinations);
                        
                        if(relatedMeetingsWithinDistance.size() > 0){
                            for(Integer i = 0; i < relatedMeetingsWithinDistance.size(); i++){
                                
                                String distance = response.getDistanceMatrix(0, i).distance;
                                
                                List<String> distanceString = distance.split(' ');
                                if(distanceString.size() > 0){
                                    if(Decimal.valueOf(distanceString.get(0)) <= MAX_RELATED_MEETING_DISTANCE){
                                        relatedMeetingsToDistancesMap.put(relatedMeetingsWithinDistance.get(i), String.join(distanceString, ' '));
                                    }                                    
                                }                                
                            }
                            setRelatedMeetingWrappers(relatedMeetingsToDistancesMap);
                        }                        
                    } catch(TravelResponseService.TravelResponseException ex){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'An error has occurred when calculating related meeting distance'));
                        return null;
                    }
                    catch(Exception ex){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'An error has occurred when calculating related meeting distance'));
                        return null;
                    }
                }
            }
            else{
                return new List<RelatedMeetingWrapper>();
            }
            
            this.meetingWrappers = meetingWrappers;         
            return meetingWrappers;
            
        } else {
            return getUpdatedRelatedMeetings();
        }     
    }   
    public void getTravelDistance() {        
        String origin = (personContact.MailingStreet != null ? personContact.MailingStreet : '') + ' '
            + (personContact.MailingCity != null ? personContact.MailingCity : '') + ' '
            + (personContact.MailingState != null ? personContact.MailingState : '') + ' ' 
            + (personContact.MailingPostalCode != null ? personContact.MailingPostalCode : '') + ' '
            + (personContact.MailingCountry != null ? personContact.MailingCountry : '');
        
        String destination = (selectedMeeting.Meeting_Street__c != null ? selectedMeeting.Meeting_Street__c : '') + ' '
            + (selectedMeeting.Meeting_City__c != null ? selectedMeeting.Meeting_City__c : '') + ' '
            + (selectedMeeting.Meeting_State__c != null ? selectedMeeting.Meeting_State__c : '') + ' ' 
            + (selectedMeeting.Meeting_Zip_Code__c != null ? selectedMeeting.Meeting_Zip_Code__c : '');
        
        //*** get response from google distance api
        try {
            TravelResponseService.TravelResponse travelResp = TravelResponseService.getResponse(origin, destination);
            disDurEvent.put(selectedMeeting.Id,
                            new DisDurMeetingWrap(travelResp.getDistanceMatrix().distance, travelResp.getDistanceMatrix().duration)
                           );
            validResponse = true;
            disabledTravel = true;            
        } catch(Exception e) {
            validResponse = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'An error has occurred when calculating distance ' + e.getMessage()));
        }        
    }
    
    public Boolean isPersonCleared(string facId, string email){
        List<Contact> facuser=[select name,id,FirstName,LastName,Region_Location__c,email, Bilingual__c, Facilitator_type__c from Contact
                               where ID=:facId and email=:email];        
        if (facuser.size()>0){
            selectedContact=facuser[0].Id;
            userRegions=facuser[0].Region_Location__c;
            showMgrApproval=true;                     
            //*** based on isConsultant we will render and query different meetings, fields, etc.
            if (facuser[0].Facilitator_type__c == 'Consultant') {
                isConsultant = true;                
                showMgrApproval=false;
                showSearch=true;
                showMeeting=false;
            } else {
                isConsultant = false;                
            }            
            //*** get persons address
            personContact = [select MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
                             from contact where id = :selectedContact limit 1];            
            return true;
        }
        else{
            showSearch=false;
            showMgrApproval=false;
            return false;
        }
    }
    
    public List<SelectOption> getRegions() {        
        List<SelectOption> options = new List<SelectOption>();            
        if (personCleared==true){
            //*** Break Region into acceptable values
            List<String> regions;
            regions=UserRegions.split(';');            
            if(!isConsultant) {
                options.add(new SelectOption(URGENT_LABEL, URGENT_LABEL));
            }            
            List<SelectOption> geoOptions = new List<SelectOption>();
            List<SelectOption> specialOptions = new List<SelectOption>();
            for(String region:regions){
                if(isConsultant && regionsToAdd.contains(region)) {
                    options.add(new SelectOption(URGENT_LABEL + ' ' + region, URGENT_LABEL + ' ' +region));
                    geoOptions.add(new SelectOption(region,region));                    
                }
                else if(specialRegionsToAdd.contains(region)) {
                    specialOptions.add(new SelectOption(region,region));
                } 
                else {
                    geoOptions.add(new SelectOption(region,region));
                    
                }                
            }
            options.sort();
            geoOptions.sort();
            specialOptions.sort();
            options.addAll(geoOptions);
            options.addAll(specialOptions);            
            options.add(0, new SelectOption('None','None'));
        }
        
        return options;
    }
    public List<SelectOption> getBuddyOptions() {                
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('No', 'No'));    
        options.add(new SelectOption('Yes','Yes'));            
        
        return options;
    }
    
    public OEAmbSignupController.RelatedMeetingWrapper[] getRelatedMeetingWrappers(){
        return meetingWrappers;
    }
    
    public void setRelatedMeetingWrappers(Map<SFDC_Volunteer_Event__c, String> relatedMeetingsToDistances){
        Id groupingId = selectedMeeting.OE_Grouping__c;
        meetingWrappers = new List<RelatedMeetingWrapper>();
        
        for(SFDC_Volunteer_Event__c meeting : relatedMeetingsToDistances.keySet()){
            meetingWrappers.add(new RelatedMeetingWrapper(meeting, relatedMeetingsToDistances.get(meeting)));//replace with distance from matrix api
        }       
    }
    
    public sfdc_volunteer_event__c[] getRelatedMeetings(){
        return [SELECT Id, Local_Ambassador_Only__c, Bilingual__c, Account_Name__c, Meeting_Type__c, Date__c, Meeting_City__c, Meeting_State__c, Expected_of_Employees__c, Buddy_Program_Eligible__c, Dates_Flexible__c FROM SFDC_Volunteer_Event__c WHERE  Id != :selectedMeeting.Id ORDER By Date__c ASC];
    }
    
    public sfdc_volunteer_event__c[] getMeetings(){        
        String strGRS = UtilConstants.GRS;
        String strVolutarySpeciality = UtilConstants.VOLUNTARYSPECIALTY;
        String strVirtual = UtilConstants.VIRTUALWEBINAR;
        String statusSubmitted = UtilConstants.STATUS_SUBMITTED;
        String statusSubRush = UtilConstants.STATUS_SUB_RUSH;
        String stageInReview = UtilConstants.STAGE_INREVIEW;
        String stageInProcess = UtilConstants.STAGE_INPROCESS;
        
        List<Sfdc_volunteer_event__c> recs;
        String sortString;
        
        if (stateorRegion==null){
            stateorRegion='Alaska';
        }
        
        // get today's date into a variable
        Date datetoday=date.today();
        Date dateUrgent;
        
        datesAlreadySignedUp = getUpdatedDatesSignedUp();
        
        String baseQueryString = 'SELECT Id, Local_Ambassador_Only__c, Bilingual__c, Account_Name_Text__c,'+
            'Account_Name__c, Meeting_Type__c, Date__c, Meeting_City__c, Meeting_State__c, Expected_of_Employees__c,'+
            'Buddy_Program_Eligible__c, Dates_Flexible__c FROM sfdc_volunteer_event__c ';
        //*** if person is external consultant
        if (isConsultant) {             
            baseQueryString += ' WHERE Recruitment_of_Facilitator_Needed__c=:FACNEEDED AND Recruit_Consultant__c = true'+                              
                ' AND Facilitator_Secured__c=false AND date__c>:datetoday AND date__c not in :datesAlreadySignedUp'+                               
                ' AND (Meeting_Stage__c =:statusSubmitted OR Meeting_Stage__c =:statusSubRush OR Meeting_Stage__c =:stageInProcess)'+                           
                ' AND Meeting_Status__c != :stageInReview AND Facilitator_Being_Recruited__c = true'+                                
                ' AND Id NOT in (select Volunteer_Event__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__c = :selectedContact)';
            
            if (stateorRegion.contains(URGENT_LABEL))  {
                dateUrgent = datetoday.addDays(5);
                baseQueryString += ' AND date__c <= :dateUrgent ';
                if(stateorRegion != URGENT_LABEL) {
                    String region = stateorRegion.remove(URGENT_LABEL).trim();
                    baseQueryString += ' AND Geographical_Region__c = :region ';
                }
            } else {
                baseQueryString += ' AND Geographical_Region__c = :stateorRegion ';
            }             
            
        } else {
            //*** For urgent limit date to only 14 days out
            if (stateorRegion == URGENT_LABEL)  {
                dateUrgent = datetoday.addDays(14);
                baseQueryString += ' WHERE Recruitment_of_Facilitator_Needed__c=:FACNEEDED and Facilitator_Secured__c=false AND Facilitator_Being_Recruited__c=True'+                               
                    ' AND date__c>:datetoday AND date__c <:dateUrgent AND Meeting_Status__c != :stageInReview AND date__c not IN :datesAlreadySignedUp'+                                  
                    ' AND (Meeting_Stage__c =:statusSubmitted OR Meeting_Stage__c =:statusSubRush OR Meeting_Stage__c =:stageInProcess)'+
                    ' AND Id NOT in (select Volunteer_Event__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__c =:selectedContact)';
            } 
            else if(stateorRegion == 'Buddy Eligible') {
                baseQueryString += ' WHERE Recruitment_of_Facilitator_Needed__c=:FACNEEDED AND Facilitator_Being_Recruited__c=false'+
                    ' AND date__c>:datetoday AND Facilitator_Secured__c=true AND Buddy_Secured__c = false'+                               
                    ' AND (Meeting_Stage__c =:statusSubmitted OR Meeting_Stage__c =:statusSubRush OR Meeting_Stage__c =:stageInProcess)'+
                    ' AND Id NOT IN (select Volunteer_Event__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__c =:selectedContact)'+
                    ' AND Buddy_Program_Eligible__c = true AND date__c not in :datesAlreadySignedUp AND Meeting_Status__c !=:stageInReview';                
            }
            else if(stateorRegion == 'GRS') {
                baseQueryString += ' WHERE Recruitment_of_Facilitator_Needed__c=:FACNEEDED AND Facilitator_Being_Recruited__c=True'+ 
                    ' AND Facilitator_Secured__c=false AND Buddy_Program_Eligible__c = false AND Request_is_From__c like:strGRS'+                   
                    ' AND date__c>:datetoday and date__c not in :datesAlreadySignedUp AND Meeting_Status__c !=:stageInReview'+                                
                    ' AND (Meeting_Stage__c =:statusSubmitted OR Meeting_Stage__c =:statusSubRush OR Meeting_Stage__c =:stageInProcess)'+ 
                    ' AND Id NOT IN (select Volunteer_Event__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__c =:selectedContact)';                   
                
            } else if(stateorRegion == 'Specialty/Voluntary') {
                baseQueryString += ' WHERE Recruitment_of_Facilitator_Needed__c=:FACNEEDED AND Facilitator_Being_Recruited__c=True'+ 
                    ' AND Facilitator_Secured__c=false AND Buddy_Program_Eligible__c = false AND Meeting_Status__c != :stageInReview'+                   
                    ' AND Request_is_From__c like:strVolutarySpeciality and date__c>:datetoday and date__c not in :datesAlreadySignedUp'+                                
                    ' AND (Meeting_Stage__c =:statusSubmitted OR Meeting_Stage__c =:statusSubRush OR Meeting_Stage__c =:stageInProcess)'+ 
                    ' AND Id NOT IN (select Volunteer_Event__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__c =:selectedContact)';
                
            } else if(stateorRegion == 'Virtual (Webinar)') {
                baseQueryString += ' WHERE Recruitment_of_Facilitator_Needed__c=:FACNEEDED AND Facilitator_Being_Recruited__c=True' + 
                    ' AND Facilitator_Secured__c=false AND Buddy_Program_Eligible__c = false AND Meeting_Status__c != :stageInReview'+                    
                    ' AND Meeting_Type__c like:strVirtual and date__c>:datetoday and date__c not in :datesAlreadySignedUp' +                                
                    ' AND (Meeting_Stage__c =:statusSubmitted OR Meeting_Stage__c =:statusSubRush OR Meeting_Stage__c =:stageInProcess)' + 
                    ' AND Id NOT IN (select Volunteer_Event__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__c =:selectedContact)';                    
            } else {
                baseQueryString += ' WHERE Recruitment_of_Facilitator_Needed__c=:FACNEEDED AND Facilitator_Being_Recruited__c=True'+ 
                    ' AND Facilitator_Secured__c=false AND Buddy_Program_Eligible__c = false AND Meeting_Status__c !=:stageInReview'+
                    ' AND (Not Request_is_From__c like:strVolutarySpeciality) AND (Not Request_is_From__c like:strGRS)'+                                 
                    ' AND Geographical_Region__c=:stateorRegion and date__c>:datetoday and date__c not in :datesAlreadySignedUp'+                                
                    ' AND (Meeting_Stage__c =:statusSubmitted OR Meeting_Stage__c =:statusSubRush OR Meeting_Stage__c =:stageInProcess)'+                     
                    ' AND Id NOT IN (select Volunteer_Event__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__c =:selectedContact)';            
            }
            
        }     
        
        if (sortBy=='Date__c'){
            if (sortAsc==true){
                sortString=' order by Date__c Asc';     
            }
            else{
                sortString=' order by Date__c Desc';
            }
        }
        else if (sortBy=='Meeting_State__c'){
            if (sortAsc==true){
                sortString=' order by Meeting_State__c Asc';
            }
            else{
                sortString=' order by Meeting_State__c Desc';
            }
        }
        else if (sortBy=='Local_Ambassador_Only__c'){
            if (sortAsc==true){
                sortString=' order by Local_Ambassador_Only__c Asc';
            }
            else{
                sortString=' order by Local_Ambassador_Only__c Desc';
            }
        }
        else if (sortBy=='Meeting_City__c'){
            if (sortAsc==true){
                sortString=' order by Meeting_City__c Asc';
            }
            else{
                sortString=' order by Meeting_City__c Desc';
            }
        }
        
        else if (sortBy=='Meeting_Type__c'){
            if (sortAsc==true){
                sortString=' order by Meeting_Type__c Asc';
            }
            else{
                sortString=' order by Meeting_Type__c Desc';
            }
        }
        else{
            if (sortAsc==true){
                sortString=' order by Account_Name_Text__c Asc';
            }
            else{
                sortString=' order by Account_Name_Text__c Desc';
            }
        }
        
        baseQueryString=baseQueryString+sortString;    
        System.debug('          *** ' + baseQueryString);        
        recs=database.query(baseQueryString);                     
        return recs;        
    }
    
    public List<SelectOption> getSortOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Date__c','Date'));
        options.add(new SelectOption('Account_Name_Text__c','Account Name'));
        options.add(new SelectOption('Meeting_City__c','City'));
        options.add(new SelectOption('Meeting_State__c','State'));
        options.add(new SelectOption('Meeting_Type__c','Meeting Type'));
        
        if (!isConsultant) {
            options.add(new SelectOption('Local_Ambassador_Only__c','Local Ambassador Only'));
        }
        
        return options;
    }
    private Set<Date> getUpdatedDatesSignedUp(){
        return Pluck.dates('Meeting_Date__c', [SELECT Meeting_Date__c FROM SFDC_Volunteer_Participant__c
                                               WHERE OE_Ambassador_Volunteer__c = :selectedContact
                                               AND Thanks_but_No_Thanks__c = false
                                               AND Meeting_Date__c >= TODAY]);
    }
    public pageReference selectMeeting(){
        showThankYou = false;
        relatedMeetingsAreSet = false;
        String meetingID=ApexPages.currentpage().getParameters().get('meetingID'); 
        selectedMeeting=[Select ID,
                   name,Account_Name_Text__c, Expected_of_Employees__c,meeting_type__c, 
                   Account_Name__c,Dates_Flexible__c, Location__c, Location__Latitude__s, 
                   Location__Longitude__s,Date__c,Bilingual__c,Buddy_Program_Eligible__c,
                   OE_Coordinator_Name_Text__c,Meeting_Street__c,Meeting_City__c,
                   Local_Ambassador_Only__c,Meeting_State__c,Meeting_Zip_Code__c,
                   Meeting_Contact__c,OE_Grouping__r.Plan_Type__c,Contact_Phone_Number__c,
                   Session_1_Start_Time__c,Session_1_End_Time__c,Session_2_Start_Time__c,
                   Session_2_End_Time__c,Session_3_Start_Time__c,Session_3_End_Time__c,
                   Session_4_Start_Time__c,Session_4_End_Time__c,Session_5_Start_Time__c,
                   Session_5_End_Time__c,Session_6_Start_Time__c,Session_6_End_Time__c,
                   Session_7_Start_Time__c,Session_7_End_Time__c,Special_Comments__c, OE_Grouping__c
                   From SFDC_Volunteer_Event__c
                   where ID=:meetingID]; 
      
        volComments='';
        if (selectedMeeting.Session_2_Start_Time__c=='N/A' || selectedMeeting.Session_2_Start_Time__c=='NA'){
            selectedMeeting.Session_2_Start_Time__c='';
            selectedMeeting.Session_2_End_Time__c='';
        }
        showMgrApproval=false;
        disabledTravel = false;
        showSearch=false;
        showMeeting=true;
        validResponse = true;
        
        if (disDurEvent.get(selectedMeeting.Id) != NULL) {
            disabledTravel = true;
        }
        meetingWrappers = getRelatedMeetingsForDistance();              
        return null;
    }
    
    public pageReference backToSearch(){
        relatedMeetingsAreSet = false;
        showSearch=true;
        showMeeting=false;
        showMgrApproval=false;
        disabledTravel = false;         
        meetingId = null;
        selectedMeeting = null;    
        return null;
    }
    
    public pageReference mapit(){
        pageReference pge=new PageReference('http://maps.google.com/maps/place/'+selectedMeeting.Meeting_Street__c+' '+selectedMeeting.Meeting_State__c+' '+selectedMeeting.Meeting_Zip_Code__c);
        
        return pge;
    }
    
    public pageReference volunteer(){
        SFDC_Volunteer_Participant__c volrec=new SFDC_Volunteer_Participant__c();         
        if (buddyProgramResponse==null){
            buddyProgramResponse='No';
        }
        
        volrec.Comment__c=volComments;
        volrec.OE_Ambassador_Volunteer__c=selectedContact;
        volrec.Volunteer_Event__c=selectedMeeting.Id;
        volrec.Requested_Buddy_Program__c=buddyProgramResponse;
        volrec.Flight_Cost__c= flightCost;
        volrec.Car_Rental_per_day__c= carRentalPerDay;
        volrec.Hotel_Cost__c=hotelCost;
        volrec.Selected_For_Facilitator__c = false;
        volrec.Thanks_but_No_Thanks__c = false;

        
        DisDurMeetingWrap disDur = disDurEvent.get(selectedMeeting.Id);        
        // set data from google distance api
        if (disDur != NULL) {
            volrec.Travel_Distance__c = disDur.meetingDistance;
            volrec.Travel_Duration__c = disDur.meetingDuration;        
        }        
        
        try{
            insert volrec;
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);   
        }
        
        showMeeting=false;
        showMgrApproval=false;
        showThankYou=true;
        return null;
    }
    
    public pageReference returntoList(){
        showThankYou=false;
        showMgrApproval=false;
        showSearch=true;        
        return null;
    }
    
    public class RelatedMeetingWrapper{
        public SFDC_Volunteer_Event__c meeting{get;set;}
        public String distance{get;set;}
        
        public RelatedMeetingWrapper(SFDC_Volunteer_Event__c meeting, String distance){
            this.meeting = meeting;
            this.distance = distance;
        }
    }
}