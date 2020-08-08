/*************************************************************************************
Version     : 1.0 
@Author     : Mehaboob
@description :Test class for class OpenEnrollmentTriggerAction
@comment     : Created this class as part of Story PRDCRM-45610 and 43212
Created On : 10/30/2019
*************************************************************************************/
@isTest
private class OpenEnrollmentStageStatusTest{

@isTest
static void testInsertOrUpdateOE(){
       Test.setMock(HttpCalloutMock.class, TravelResponseServiceTest.getDefaultBingGeocodeMock());
          Id contactFacRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
         
         //Insert account
         List<Account> accountList = new List<Account>();
         accountList =TestDataFactory.createAccountSICList(1,'newaccount','CA street','CA','CA State','12345','US','CAA');
         insert accountList; 
         
        //Insert Account records
        List<Account> accRec = new List<Account>();
        Account accOeRec = new Account();
        accOeRec.Name = 'Open Enrollment';
        accOeRec.Anthem_Entity__c = 'National Accounts';
        accOeRec.Region__c = 'Central';
        accRec.add(accOeRec);
        insert accRec;
         
        List<Contact> contactList=new List<Contact>();
        contactList = TestDataFactory.createContact(1,'test','Test4',accRec[0],contactFacRecTypeId,'OE Coordinator','Central','test@test.com',true,0,0);
        insert contactList;
        
        List<Open_Enrollment_Meetings__c> oemeetingRec = new List<Open_Enrollment_Meetings__c>();
        oemeetingRec = TestDataFactory.createOpenEnrollmentMeeting(1,'Test123',accountList[0],'Georgia',contactList[0],UtilConstants.Plan_Type,'Commercial Medical','Yes','Test Performance comment','Renewal - Growth Opportunity','Sole Carrier','Test tally fields','3534353453',UtilConstants.Dress_Code_for_Event);
        insert oemeetingRec;
        
        List<SFDC_Volunteer_Event__c> oeRecList = new List<SFDC_Volunteer_Event__c>();
        oeRecList = TestDataFactory.createOpenEnrollment(1,'StageStatusOE',oemeetingRec[0],'No',FALSE,'321 N Clark','Chicago','IL','60654','12:00 AM','12:30 AM',System.Today(),'No',UtilConstants.MEETING_TYPE_OE,100,true,'DRAFT','Yes',41.8882434,-87.6328535,true,false,false,accRec[0],'New Request',contactList[0]);
        
        insert oeRecList;
        
       
       List<SFDC_Volunteer_Event__c> oeList=[select id,Name,Meeting_Stage__c,Meeting_Status__c,Submit__c,Meeting_Cancelled__c,Materials_Needed__c,Meeting_Contact__c,Contact_Phone_Number__c,Recruitment_of_Facilitator_Needed__c,RUSH__c from SFDC_Volunteer_Event__c where Name=:'StageStatusOE0' limit 1];
      
       oeList[0].Meeting_Cancelled__c=true;
       oeList[0].Submit__c=true;
       oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
       oeList[0].Meeting_Contact__c='Test contact user';
       oeList[0].Contact_Phone_Number__c='1234567890';
       oeList[0].Recruitment_of_Facilitator_Needed__c='No';
       
       update oeList;
       
       oeList[0].Reason_for_Update__c='Date Change';
       oeList[0].Date__c=System.Today()-15;
       
       update oeList;
       
       oeList[0].Reason_for_Update__c='Session times change';
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=true;
       oeList[0].Waiting_on_Feedback__c=false;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
       oeList[0].Facilitator_Feedback_Received__c=true;
       oeList[0].Unable_to_secure_facilitator__c=false;
       oeList[0].Submit__c=true;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=false;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Meeting_Cancelled__c=false;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=true;
       oeList[0].Waiting_on_Feedback__c=false;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=true;
       oeList[0].Facilitator_Feedback_Received__c=false;
       oeList[0].Unable_to_secure_facilitator__c=false;
       oeList[0].Submit__c=true;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=false;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Meeting_Cancelled__c=false;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=true;
       oeList[0].Waiting_on_Feedback__c=true;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
       oeList[0].Facilitator_Feedback_Received__c=false;
       oeList[0].Unable_to_secure_facilitator__c=false;
       oeList[0].Submit__c=true;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=false;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Meeting_Cancelled__c=false;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
       oeList[0].Facilitator_Being_Recruited__c=true;
       oeList[0].Submit__c=true;
       oeList[0].Facilitator_Secured__c=false;
       oeList[0].Unable_to_secure_facilitator__c=false;
       oeList[0].Waiting_on_Feedback__c=false;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
       oeList[0].Facilitator_Feedback_Received__c=false;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=false;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Meeting_Cancelled__c=false;
       
       update oeList;
      
     /* oeList[0].Date__c=System.TODAY() - 10;
       oeList[0].Meeting_Stage__c='SUBMITTED';
       
       update oeList;
       System.debug('stage is 10--->'+oeList[0].Meeting_Stage__c+'  Status is---->'+oeList[0].Meeting_Status__c);
     */
     
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed ';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Unable_to_secure_facilitator__c=true;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=true;
       oeList[0].Materials_Delivered__c=true;
       oeList[0].Submit__c=true;
     
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Unable_to_secure_facilitator__c=true;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=true;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Submit__c=true;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=true;
       oeList[0].Unable_to_secure_facilitator__c=false;
       oeList[0].Waiting_on_Feedback__c=false;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
       oeList[0].Facilitator_Feedback_Received__c=true;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=true;
       oeList[0].Materials_Delivered__c=true;
       oeList[0].Submit__c=true;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=true;
       oeList[0].Waiting_on_Feedback__c=false;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=true;
       oeList[0].Materials_Order_placed__c=true;
       oeList[0].Materials_Delivered__c=true;
       oeList[0].Submit__c=true;
       oeList[0].Facilitator_Feedback_Received__c=false;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=true;
       oeList[0].Unable_to_secure_facilitator__c=false;
       oeList[0].Waiting_on_Feedback__c=true;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
       oeList[0].Facilitator_Feedback_Received__c=false;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=true;
       oeList[0].Materials_Delivered__c=true;
       oeList[0].Meeting_Cancelled__c=false;
       oeList[0].Submit__c=true;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=false;
       oeList[0].Unable_to_secure_facilitator__c=true;
       oeList[0].Waiting_on_Feedback__c=false;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
       oeList[0].Facilitator_Feedback_Received__c=false;
       oeList[0].Materials_Order_On_Standby__c=true;
       oeList[0].Materials_Order_placed__c=false;
       oeList[0].Submit__c=true;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Meeting_Cancelled__c=false;
      
       update oeList;
       
      /* IN PROCESS - FACILITATOR SECURED & ORDER PLACED & WAITING ON FEEDBACK
      
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=true;
       oeList[0].Waiting_on_Feedback__c=true;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=true;
       oeList[0].Submit__c=true;
       oeList[0].Materials_Delivered__c=false;
       
       update oeList;
       System.debug('stage is 17--->'+oeList[0].Meeting_Stage__c+'  Status is---->'+oeList[0].Meeting_Status__c);
       */
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='No Promo or Collateral Needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=false;
       oeList[0].Unable_to_secure_facilitator__c=true;
       oeList[0].Waiting_on_Feedback__c=false;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
       oeList[0].Facilitator_Feedback_Received__c=false;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=false;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Meeting_Cancelled__c=true;
       oeList[0].Submit__c=true;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=true;
       oeList[0].Facilitator_Secured__c=false;
       oeList[0].Unable_to_secure_facilitator__c=false;
       oeList[0].Waiting_on_Feedback__c=false;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
       oeList[0].Facilitator_Feedback_Received__c=false;
       oeList[0].Materials_Order_On_Standby__c=true;
       oeList[0].Materials_Order_placed__c=false;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Meeting_Cancelled__c=false;
       oeList[0].Submit__c=true;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=true;
       oeList[0].Materials_Order_placed__c=true;
       oeList[0].Materials_Delivered__c=true;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Submit__c=true;    
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=true;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Materials_Order_placed__c=true;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Submit__c=true;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='Yes';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=true;
       oeList[0].Unable_to_secure_facilitator__c=false;
       oeList[0].Waiting_on_Feedback__c=true;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
       oeList[0].Facilitator_Feedback_Received__c=false;
       oeList[0].Materials_Order_On_Standby__c=true;
       oeList[0].Materials_Order_placed__c=false;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Meeting_Cancelled__c=false;
       oeList[0].Submit__c=true;
       
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='No';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Facilitator_Being_Recruited__c=false;
       oeList[0].Facilitator_Secured__c=false;
       oeList[0].Unable_to_secure_facilitator__c=false;
       oeList[0].Waiting_on_Feedback__c=false;
       oeList[0].Feedback_Not_Received_Within_14_Days__c=false;
       oeList[0].Facilitator_Feedback_Received__c=false;
       oeList[0].Materials_Order_On_Standby__c=true;
       oeList[0].Materials_Order_placed__c=false;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Meeting_Cancelled__c=false;
       oeList[0].Submit__c=true;
       
       update oeList;
       
       oeList[0].Recruitment_of_Facilitator_Needed__c='No';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Materials_Order_placed__c=true;
       oeList[0].Materials_Delivered__c=true;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Submit__c=true;
       
       update oeList;
      
       oeList[0].Recruitment_of_Facilitator_Needed__c='No';
       oeList[0].Materials_Needed__c='Promo only needed';
       oeList[0].Materials_Order_placed__c=true;
       oeList[0].Materials_Delivered__c=false;
       oeList[0].Materials_Order_On_Standby__c=false;
       oeList[0].Submit__c=true;
       
       update oeList;
       
       List<SFDC_Volunteer_Event__c> openEnrollmentList=[select id,Name,Meeting_Stage__c,Materials_Delivered__c,Meeting_Status__c,Submit__c,Meeting_Cancelled__c,Materials_Needed__c,Meeting_Contact__c,Contact_Phone_Number__c,Recruitment_of_Facilitator_Needed__c,RUSH__c from SFDC_Volunteer_Event__c limit 1];
      System.assertEquals(openEnrollmentList[0].Meeting_Stage__c,'In Process' ,'Stage of Open Enrollment ');
      System.assertEquals(openEnrollmentList[0].Meeting_Status__c,'IN PROCESS- ORDER PLACED' ,'Status of Open Enrollment ');
      System.assertEquals(openEnrollmentList[0].RUSH__c,false,'Rush of Open Enrollment ');
       
   }
}