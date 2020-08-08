/****************************************************************
Class Name   : DNC_AttachmentHandler_Test
Date Created : 18-Apr-2018
Created By   : Deloitte USI
Description  : Test class for DNC_AttachmentHandler 
Modifications: Modified the test class for PRDCRM- 31735 - OE changes - XMen 193.3 sprint.
*****************************************************************/
@isTest
private class DNC_AttachmentHandler_Test {
    
    @testSetup
	static void testDataMethod() {	
        Test.setMock(HttpCalloutMock.class, New MockBingTravelResponse());
		// Insert Account
        Account acctRec = new Account();
        acctRec.Name = 'Test Company Name';
        acctRec.Anthem_Entity__c = 'National Accounts';
        acctRec.Region__c = 'Central';
        insert acctRec;
        
        //Create contact
        Contact cnt=new Contact();
        cnt.lastname='Test First';
        cnt.firstname='Tony';
        cnt.AccountId=acctRec.Id;
        cnt.RecordTypeID=Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        cnt.Facilitator_Type__c='OE Coordinator';
        cnt.Region_Location__c='Central';
        cnt.Email='tony_angle@msn.com';
        cnt.Active__c=true;
        insert cnt;		
		
        // Insert new meeting
        Open_Enrollment_Meetings__c meetRec = new Open_Enrollment_Meetings__c();
        meetRec.Account__c = acctRec.id;        
        meetRec.Plan_Type__c = 'ANC Dental';        
        meetRec.Name='test Meeting';
        meetRec.Source__c='Georgia';
        meetRec.OE_Coordinator_Contact__c=cnt.id;
		meetRec.Plan_Type__c= 'ANC Vision'; 
        meetRec.Request_is_from__c='Commercial Medical';  
        meetRec.Performance_Guarantees__c = 'Yes';
        meetRec.Performance_Guarantees_Comments__c='Test Performance comment';
        meetRec.Client_Arrangement__c='Renewal - Growth Opportunity';
        meetRec.Sole_Carrier_or_Multi_Carriers__c='Sole Carrier';
        meetRec.Client_Drivers_Issues_Risks__c='Test';
        meetRec.Member_Customer_Service_Telephone__c='3534353453';        
        insert meetRec;        
    }
  
  @isTest		
  static void testOEAttachment() {
      ID profileId = [select id from profile where Name ='System Administrator'].id; 
      User u= [Select id from user where profile.id =: profileId AND IsActive =True limit 1];
      Account ac = [Select ID from Account where Name='Test Company Name' limit 1];
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,OE_Coordinator_Contact__c, OE_Coordinator_Contact__r.Email
                                              from Open_Enrollment_Meetings__c
                                              Where Account__c=:ac.Id];
      System.runAs(u){
       string before = staticVariableClass.DNCStrBefore;            
         Blob beforeblob = Blob.valueOf(before);
        ContentVersion contentVersion = new ContentVersion(
          Title = staticVariableClass.DNCStrTitle,
          PathOnClient = staticVariableClass.DNCStrPath,
          VersionData = beforeblob,
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        //create ContentDocumentLink  record for that account
        ContentDocumentLink cdl = New ContentDocumentLink(
                    LinkedEntityId = meetRec.id, ContentDocumentId = documents[0].Id, shareType = staticVariableClass.DNCStrShareType);
        insert cdl;
      }
        
       Test.startTest();
        List<ContentDocumentLink> oeAttachment = [Select id,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: meetRec.id];
       Test.stoptest();
      System.assertEquals(1, oeAttachment.size());
  } 

  @isTest		
  static void testOEAttachment2() {
      ID profileId = [select id from profile where Name ='System Administrator'].id; 
      User u= [Select id from user where profile.id =: profileId AND IsActive =True limit 1];
      Account ac = [Select ID from Account where Name='Test Company Name' limit 1];
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,OE_Coordinator_Contact__c, OE_Coordinator_Contact__r.Email
                                              from Open_Enrollment_Meetings__c
                                              Where Account__c=:ac.Id];
      System.runAs(u){
       string before = staticVariableClass.DNCStrBefore;            
         Blob beforeblob = Blob.valueOf(before);
         //Insert contentdocument data
         ContentVersion cv = new ContentVersion();
         cv.title = staticVariableClass.DNCStrTitle;      
         cv.PathOnClient = staticVariableClass.DNCStrPath;           
         cv.VersionData =beforeblob;          
         insert cv;         
                                                
         ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.LinkedEntityId = meetRec.Id;
        newFileShare.ShareType= staticVariableClass.DNCStrShareType;
        insert newFileShare;
        List<ContentDocumentLink> lstConDocLst = new List<ContentDocumentLink>();
        lstConDocLst.add(newFileShare);
        DNC_AttachmentHandler.onAfterInsert(lstConDocLst);
      }
        
       Test.startTest();
        List<ContentDocumentLink> oeAttachment = [Select id,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: meetRec.id];
       Test.stoptest();
      Integer invocations = Limits.getEmailInvocations();       
      System.assertEquals(1, invocations);
      System.assertEquals(1, oeAttachment.size());
  }  

  @isTest  
  static void testInsertAttachment() {
    Account acct = new Account(Name = staticVariableClass.DNCTstAcc);
    insert acct;
    DNC_Preferences__c dncPref = new DNC_Preferences__c(AccountDNC__c = acct.Id);
    insert dncPref;
       
    Test.startTest();
      string before = staticVariableClass.DNCStrBefore;            
         Blob beforeblob = Blob.valueOf(before);
         //Insert contentdocument data
         ContentVersion cv = new ContentVersion();
         cv.title = staticVariableClass.DNCStrTitle;      
         cv.PathOnClient = staticVariableClass.DNCStrPath;           
         cv.VersionData =beforeblob;          
         insert cv;       
                                                
         ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.LinkedEntityId = dncPref.Id;
        newFileShare.ShareType= staticVariableClass.DNCStrShareType;
        insert newFileShare;
        List<ContentDocumentLink> lstConDocLst = new List<ContentDocumentLink>();
        lstConDocLst.add(newFileShare);
        DNC_AttachmentHandler.onAfterInsert(lstConDocLst);
    Test.stopTest();    
    DNC_Preferences__c uAccount = [SELECT Id, Attachment_Count__C from DNC_Preferences__c where Id = :dncPref.Id];
    System.assertEquals(1, uAccount.Attachment_Count__C);
  }
  @isTest		
  static void testDeleteAttachment() {
      Account acct = new Account(Name=staticVariableClass.DNCTstAcc);
        insert acct;
       string before = staticVariableClass.DNCStrBefore;            
         Blob beforeblob = Blob.valueOf(before);
        ContentVersion contentVersion = new ContentVersion(
          Title = staticVariableClass.DNCStrTitle,
          PathOnClient = staticVariableClass.DNCStrPath,
          VersionData = beforeblob,
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        //create ContentDocumentLink  record for that account
        ContentDocumentLink cdl = New ContentDocumentLink(
                    LinkedEntityId = acct.id, ContentDocumentId = documents[0].Id, shareType = staticVariableClass.DNCStrShareType);
        insert cdl;        
        Test.startTest();
        delete documents; 
       test.stoptest();
  } 
  
}