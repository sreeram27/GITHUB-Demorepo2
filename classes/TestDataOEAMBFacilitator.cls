@isTest
public class TestDataOEAMBFacilitator {
 /***************************************************************
  * Purpose:  Test data for OE AMB Facilitators
  * Mod:     4/28/2015
  * Author:  Leslie Getman
  *            03/30/2017 - Comment and uncomment code to change a field type  LG 
  ***************************************************************/
    public static List<Contact> createNewFacilitators(Integer numAmbs) {
        RecordType rt=[Select SobjectType, Name, Id, DeveloperName From RecordType where Name='Facilitator Contact' and sObjectType='Contact'];
        system.assertNotEquals(null, rt.Id);
        List<account> OpEnroll = new LIST<Account>();
        OpEnroll = [Select Id from Account Where Name = 'Open Enrollment'];
        If (OpEnroll.size() == 0){
            account OpEnrol = new Account();
            OpEnrol.Name = 'Open Enrollment';
            insert OpEnrol;
            system.assertNotEquals(null, OpEnrol.Id);
        }
        else{
            system.assertEquals(1, OpEnroll.size(), 'there should be an Open Enrollment account');
        }
        Account OpEn = [Select Id from Account Where Name = 'Open Enrollment' LIMIT 1];
        system.assertNotEquals(null, OpEn.Id);
        
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
         
        return newAmbs;
    }
}