@isTest
public with sharing class FacilitatorFeedback_AfterInsTest {
  /**************************************************************
  * Purpose:  Test FacFeedbackAfterIns tests
  * Mod:     7/23/2014
  * Author:  Tony Angle
  * Mod:    5/7/2015
  *         Including new required fields for the onboarding survey-LG
  *         3/30/2017 comment and uncomment code to change field type LG
  ***************************************************************/
  
  
  public static testMethod void Test(){
    Account acctRec=new Account();
    acctRec.Name='Open Enrollment';
   // acctRec.WellPoint_Entity__c='National Accounts';
    insert acctRec;
    
    Contact cnt=new Contact();
    cnt.lastname='Test First';
    cnt.firstname='Test First';
    cnt.AccountId=acctRec.Id;
    cnt.Facilitator_Type__c='OE Coordinator';
    cnt.Region_Location__c='West'; 
    cnt.email='tony_angle@msn.com';
    cnt.Active__c=true;
    insert cnt;
    
    Open_Enrollment_Meetings__c meetRec=new Open_Enrollment_Meetings__c();
    meetRec.Account__c=acctRec.Id;
    meetRec.OE_Coordinator_Contact__c=cnt.Id;
    meetRec.Name='test me';
    meetRec.Source__c='West';
    meetRec.Plan_Type__c='MED POS';
    insert meetRec;
    Test.setMock(HttpCalloutMock.class, TravelResponseServiceTest.getDefaultBingGeocodeMock());
    SFDC_Volunteer_Event__c evtRec=new SFDC_Volunteer_Event__c();
    evtRec.OE_Grouping__c=meetRec.Id;
    evtRec.Account__c=acctRec.Id;
    evtRec.OE_Coordinator_Contact__c=cnt.Id;
    evtRec.Name='test meeting';
    evtRec.Date__c=date.today();
    evtRec.Session_1_Start_Time__c = '9:00 PM';
    evtRec.Session_1_End_Time__c = '10:00 PM';
    evtRec.Expected_of_Employees__c = 100;
    evtRec.Meeting_Street__c = '321 N Clark';
    evtRec.Meeting_City__c = 'Chicago';
    evtRec.Meeting_State__c = 'IL';
    evtRec.Meeting_Zip_Code__c = '60654';
    evtRec.Location__Latitude__s = 41.8882434;
    evtRec.Location__Longitude__s = -87.6328535;
    evtRec.Facilitator1__c = cnt.Id;
    evtRec.Contact_Phone_Number__c = '000-000-0000';
    evtRec.Meeting_Contact__c = 'Test Contact';
    evtRec.Meeting_Type__c = 'Conference Call';
    evtRec.Recruitment_of_Facilitator_Needed__c = 'No';
    insert evtRec;
    
    
    
    Account facacctRec=new Account();
    facacctRec.Name='Facilitators';
    //facacctRec.WellPoint_Entity__c='';
    insert facacctRec;
    
    Contact faccnt=new Contact();
    faccnt.lastname='Test First';
    faccnt.firstname='Test First';
    faccnt.AccountId=facacctRec.Id;
    faccnt.Facilitator_Type__c='Facilitator';
    faccnt.Region_Location__c='West'; 
    faccnt.email='mehaboobpasha.kallur@legatohealth.com';
    faccnt.Active__c=true;
    insert faccnt;
    
    Contact faccnt2=new Contact();
    faccnt2.lastname='Test First 2';
    faccnt2.firstname='Test First 2';
    faccnt2.AccountId=facacctRec.Id;
    faccnt2.Facilitator_Type__c='Facilitator';
    faccnt2.Region_Location__c='West'; 
    faccnt2.Active__c=true;
    insert faccnt2;
    
    SFDC_Volunteer_Event__c evtRec2=new SFDC_Volunteer_Event__c();
    evtRec2.OE_Grouping__c=meetRec.Id;
    evtRec2.Account__c=acctRec.Id;
    evtRec2.Name='test meeting';
    evtRec2.Date__c=date.today();
    evtRec2.Session_1_Start_Time__c = '9:00 PM';
    evtRec2.Session_1_End_Time__c = '10:00 PM';
    evtRec2.Expected_of_Employees__c = 100;
    evtRec2.Meeting_Street__c = '321 N Clark';
    evtRec2.Meeting_City__c = 'Chicago';
    evtRec2.Meeting_State__c = 'IL';
    evtRec2.Meeting_Zip_Code__c = '60654';
    evtRec2.Location__Latitude__s = 41.8882434;
    evtRec2.Location__Longitude__s = -87.6328535;
    evtRec2.Facilitator1__c = cnt.Id;
    evtRec2.Contact_Phone_Number__c = '000-000-0000';
    evtRec2.Meeting_Contact__c = 'Test Contact';
    evtRec2.Meeting_Type__c = 'Conference Call';
    evtRec2.Recruitment_of_Facilitator_Needed__c = 'No';
    insert evtRec2;
    
    
    Integer numAmbs=10;
    List<Contact> newAmbs = new List<Contact>();  
        for(Integer i=0;i<numAmbs;i++) {
            Contact a = new Contact();
           // a.Additional_Training_Requested__c = 'blah, blah';
            a.Associate_Type__c = 'Exempt';
            a.Benefit_presentations_outside_the_OEAP__c = '3';
            a.Benefit_presentations_within_the_OEAP__c = '3';
            a.Billing_City__c = 'D.C.';
            a.Confidence_level_conducting_presentation__c ='3';
            a.Department = 'SFA';
            a.Email = 'leslie.getman@wellpoint.com';
            a.Bilingual__c = TRUE;
            a.Languages__c = 'Spanish';
            a.Explaining_and_answering_CDHP_questions__c = '3';
            a.Explaining_H_W_programs__c = '3';
            a.FirstName = 'Leslie' +i;
            a.LastName = 'Getman' +i;
            a.MobilePhone = '(858)248-5268';
            a.Presentations_outside_the_company__c = '3';
            a.Billing_State_Province__c = 'CA';
            a.Title = 'SFA';
            a.Understanding_benefit_plans__c= '3';
            a.US_Domain_ID__c = 'AC9iii';
            a.Walking_through_benefit_summaries__c = '3';
            a.Work_Location__c = 'Work@home';
            a.Preferred_Meeting_Type__c = 'health fair';
           // a.Year_certified__c = '1990';
            a.Years_as_an_Ambassador__c = 'New';
            //a.Confirm_Manager_s_Approval__c = TRUE;
            a.Are_you_in_a_client_facing_role__c = 'No';
            a.Commercial_Medical_Product_Benefits__c = 'No';
            a.Part_of_National_Government__c = 'No';
            a.Other_live_presentation_within_Company__c = 'No';
            a.Elaborate_On_Presentation_Experience__c= 'None';
            a.Knowledge_of_specialty_products__c = '0';
            a.Explaining_specialty_benefits__c = '0';

            newAmbs.add(a);
        }
            
        insert newAmbs;
    
    evtRec=[select id, Facilitator1__c, Session_1_Start_Time__c, Session_1_End_Time__c, Expected_of_Employees__c,
    Meeting_Street__c, Meeting_City__c, Meeting_State__c, Meeting_Zip_Code__c, Contact_Phone_Number__c 
    from SFDC_Volunteer_Event__c where id=:evtRec.ID];

    evtRec.Facilitator1__c=faccnt.Id;
    update evtRec;
    
    // Insert Fac Feedback Record
    Facilitator_Feedback__c testRec=new Facilitator_Feedback__c();
    testRec.Name='test';
    testRec.Open_Enrollment__c=evtRec.id;
    testRec.Person_Completing__c='tony_angle@msn.com';
    insert testRec;
  }
}