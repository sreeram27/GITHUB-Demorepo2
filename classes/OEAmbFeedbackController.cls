/**************************************************************************************
@description : Modified this class to follow best practices 
@Author               : Mehaboob
US                        :  PRDCRM-43215 
*************************************************************************************/
public without sharing class OEAmbFeedbackController {
    /***************************************************************
    * Purpose:  Controller for feedback form
    * Mod:      6/15/2014
    * Author:   Tony Angle
    * 4/1/2016: New/Modified questions for 2016 Red Carper LG
    @description : Lifted and Shifted from COM1
    ***************************************************************/
    
    /**
     * @description :adding below getters and setters related to Facilitator and Meeting records .
     */
    public Boolean showSurvey {get;set;}
    public Boolean showNotCleared {get;set;}
    public Boolean showThankYou {get;set;}
    public String facName {get;set;}
    public String meetingName {get;set;}
    public Boolean redCarpet {get;set;}
    public Boolean isCalpher {get;set;}
    public Facilitator_Feedback__c feedback {get;set;} 
    public final String Accountname_dba= 'CalPERS';
    public Boolean showAMStrategyCall {get;set;}
    public Boolean showPreparedTrained {get;set;}
    
    private String urlFacID=ApexPages.currentpage().getParameters().get('FacID');
    private String urlEmail=ApexPages.currentpage().getParameters().get('Email');
    private String urlMeetingID=ApexPages.currentpage().getParameters().get('MeetingID');
    private Boolean urlUserIdCheck=ApexPages.currentpage().getUrl().contains('UserId');
    private String urlUserId;
    
    {
        showSurvey=true;
        showNotCleared=false;
        showThankYou=false;
        showAMStrategyCall = true;
        showPreparedTrained = true;
        if(urlUserIdCheck){
            showAMStrategyCall = false;
            showPreparedTrained = false;
            urlUserId=ApexPages.currentpage().getParameters().get('UserId');
        }
        facName=whoIsCalling();
        meetingName=whatMeeting();
        feedback=new Facilitator_Feedback__c();
        feedback.Open_Enrollment__c=urlMeetingID;
    }
    
   /* public String getMainCSSFile(){
        Document docs=[select id from Document where name='main'];
        return URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+docs.Id;
    }
    
    public String getAnthemLogoFile(){
        Document docs=[select id from Document where name='AnthemLogo'];
        return URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+docs.Id;
    }*/
    
    /**
     * @description : returning open Enrollment Name to Page 
     * @return Meeting Name
     */    
    @TestVisible private String whatMeeting(){
        List<SFDC_Volunteer_Event__c> meetRecs=[SELECT Id, Name, OE_Grouping__r.Account__r.Account_name_dba__C,Expected_of_Employees__c, Red_Carpet__c 
                                                FROM SFDC_Volunteer_Event__c 
                                                WHERE Id=:urlMeetingID]; 
       isCalpher = meetRecs[0].OE_Grouping__r.Account__r.Account_name_dba__C == Accountname_dba;

        if (meetRecs.size()>0){
            return meetRecs[0].Name;
        }
        else{
            showNotCleared=true;
            showSurvey=false;
            return 'Not Available'; 
        }
    }
     
     /**
     * @description : returning Faciliatator Contact details to Page 
     * @return Facilitator
     */
    @TestVisible private String whoIsCalling(){
       List<Contact> facRecs=[select Name,id, FirstName,LastName,vlocity_ins__Location__c,Email
                                                from Contact
                                               where ID=:urlFacID and Email=:urlEmail];
        List<User> usrRecs = [Select FirstName, LastName From User Where ID=:urlUserId];
        
        if (facRecs.size()>0){
            return facRecs[0].FirstName+' '+facRecs[0].LastName;
        }
        else 
        if (usrRecs.size()>0) {
            return usrRecs[0].FirstName+' '+usrRecs[0].LastName;
        }
        else{
            showNotCleared=true;
            showSurvey=false;
            return 'Not Available'; 
        }
    }
    /**
     * @description : Creating facilitator feedback record
     * @return PageReference object reference with setRedirect false
     */
    public PageReference submitFeedback(){
        showSurvey=false;
        showThankYou=true;
        feedback.person_completing__c=urlEmail;
        try{
            insert feedback;
           }
        catch(DmlException ex){
         ApexPages.addMessages(ex);   
        }
        
        return null;
    }
     
}