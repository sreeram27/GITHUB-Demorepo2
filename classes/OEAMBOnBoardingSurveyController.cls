// SPRINT 192.4 - XMen - Shifted from COM1
// Modification - OE_AMB_Facilitator__c replaced with Contact

/*************************************************************************
    * Purpose:  Controller for Onboarding site 
    * Created:  3/20/2015
    * Author:   Leslie Getman
    **************************************************************************
    * Mod:      4/28/2015
    *            Modified for better code coverage - LG
    *           11/23/2016 - Modified to add new page block for not show 2016
    *            01/10/2017 - Modified to add Zip Code - LG
    * @description OEAMBOnBoardingSurveyController
    **************************************************************************/
public with sharing class OEAMBOnBoardingSurveyController {
  

     /** @description showReturnSurvey*/
    public Boolean showReturnSurvey {get;set;}
     /** @description showNotCleared*/
    public Boolean showNotCleared {get;set;}
     /** @description showThankYouNew*/
    public Boolean showThankYouNew {get;set;}
     /** @description showThankYouAmb*/
    public Boolean showThankYouAmb {get;set;}
     /** @description showAlreadyVolunteered*/
    public Boolean showAlreadyVolunteered {get;set;}
     /** @description showNewVol*/
    public Boolean showNewVol {get; set;}
     /** @description doNotShowNewVol*/
    public Boolean doNotShowNewVol {get; set;}
     /** @description facName*/
    public String facName {get; set;}
    //public OE_AMB_Facilitator__c ambassador{get;set;} ---Contact object to be used in 
    //place of OE_AMB_Facilitator__c object. - XMen - 22nd May
     /** @description ambassador*/
    public Contact ambassador{get;set;}
     /** @description dateUpdated*/
    public Date dateUpdated =system.Today();
     /** @description isConsultant*/
    public Boolean isConsultant { get; set;}
    
    
    @testvisible private String urlFacID=ApexPages.currentpage().getParameters().get('FacID');
    @testvisible private String urlEmail=ApexPages.currentpage().getParameters().get('Email');
    @testvisible private String meetingId = ApexPages.currentpage().getParameters().get('MeetingId');

    String urlNewVol=ApexPages.currentpage().getParameters().get('NewVol'); 
    
    
    {
        showReturnSurvey=false;
        showNotCleared=false;
        showThankYouNew=false;
        showThankYouAmb=false;
        showAlreadyVolunteered=false;
        showNewVol = false;
        ambassador=new Contact();
        ambassador.Id=urlFacID;
        newOrReturning(urlNewVol);
    }
    /**
        * @description backToMeeting method
        * @return PageReference
        *  
        */
    
    public PageReference backToMeeting() {
    
        PageReference pageRef = Page.OE_Amb_Signup;
        pageRef.getParameters().put('facid', urlFacID);
        pageRef.getParameters().put('email', urlEmail);
        pageRef.getParameters().put('meetingId', meetingId);
        
        return pageRef;
    } 
 /**
        * @description newOrReturning method
        * @param newVol
        *  
        */
    public void newOrReturning(String newVol) {
        if (newVol == 'TRUE') {
            showNewVol = true;
            showReturnSurvey = false;
       }
       else{
           whichAmbassador(urlFacID, urlEmail);
       }
   }
       
/**
        * @description whichAmbassador method
        * @param facId 
        * @param email 
        */     
    public void whichAmbassador(String facId, String email){
       
            LIST<Contact> facInfoList = new LIST<Contact>();
            facInfoList = [SELECT Id, 
							  Facilitator_Type__c,ARG_Names__c,
							  ARG__c,
							  Associate_Type__c,
							  Benefit_presentations_outside_the_OEAP__c,
							  Benefit_presentations_within_the_OEAP__c,
							  Bilingual__c,
							  Confidence_level_conducting_presentation__c,
							  Email,
							  FirstName,
							  LastName,
							  Department,
							  Explaining_and_answering_CDHP_questions__c,
							  Explaining_H_W_programs__c,Languages__c,
							  Name,OE_AMB_FacilitatorID__c,
							  Preferred_Meeting_Type__c,					   
							  Presentations_outside_the_company__c,
							  Title,Understanding_benefit_plans__c,
							  US_Domain_ID__c,
							  Walking_through_benefit_summaries__c,
							  Work_Location__c, Part_of_National_Government__c,
							  Billing_City__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,Phone, MobilePhone,
							  Commercial_Medical_Product_Benefits__c,
							  Years_as_an_Ambassador__c , Are_you_in_a_client_facing_role__c, 
							  Other_live_presentation_within_Company__c, Elaborate_On_Presentation_Experience__c, 
							  Knowledge_of_specialty_products__c,Facilitator_Comments__c,Explaining_specialty_benefits__c
							  FROM Contact WHERE Email = :email];
        if(facInfoList.size()> 0){
            ambassador = facInfoList[0];
            facName=ambassador.FirstName + ' ' + ambassador.LastName;
            showReturnSurvey = true;
            
            if (facInfoList[0].Facilitator_Type__c == 'Consultant') {
                isConsultant = true;
            } else {
                isConsultant = false;
            }
        }
        else{ 
            showNotCleared=true;
        }
        
       
    }
/**
        * @description submitAmbassador method
        * @return PageReference
        *  
        */    
 
    public PageReference submitAmbassador(){
        
            if (showNewVol) {
				try{
					showNewVol=false;
					String domainId;
					domainId = ambassador.US_Domain_ID__c;
					LIST<Contact> facExistList = new LIST<Contact>();
					facExistList= [SELECT Id FROM Contact WHERE US_Domain_ID__c = :domainId];
						if(facExistList.size()== 0){
						insert ambassador;
						showThankYouNew=true;
					}
						else{ 
					showAlreadyVolunteered=true;
					}
				}
				catch(DmlException ex){
					ApexPages.addMessages(ex);
					showNewVol=TRUE;
					showThankYouNew=FALSE;
					return null;
					}    
			}else{
				try{
					//Ambassador.Date_Updated_on_Web_survey__c = dateUpdated;
					showThankYouAmb=true;
					showReturnSurvey=false;
					update Ambassador;
				}
					catch(DmlException ex){
					ApexPages.addMessages(ex);
					showThankYouAmb=FALSE;
					showReturnSurvey=TRUE;
					return null;
			   }
			}  
      
       
        return null;
    }


}