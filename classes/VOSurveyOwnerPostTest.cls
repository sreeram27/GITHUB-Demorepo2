@isTest(seeAllData=false)
private class VOSurveyOwnerPostTest {
    
    static ApexPages.StandardController standardControllerObject; 
    static VOOwnerPostSurveyExtension controllerObject; 
    
    static VisitOps__Visit__c currentVisit;
    static VisitOps__Attendee__c testUserAttendee,testContactAttendee;
    static VisitOps__Survey__c testsurvey;
    static VisitOps__Location__c testLocation;
    static VisitOps__VisitType__c testCustomerVisit1;
    static VisitOps__Status__c testNewStatus;
    static VisitOps__Agenda__c testAgenda;
    static VisitOps__Presenter_Agenda_Link__c testPresenterAgenda;
    static User u;
    static boolean flag;
    static boolean flag1; 
    static void createTestData(){ 
        
        testLocation = new VisitOps__Location__c(Name='TestLocation',VisitOps__Location_Street_Address__c='testAddress', VisitOps__Time_Zone__c = '(GMT+00:00) Greenwich Mean Time (GMT)'); 
        insert testLocation;
        
        testCustomerVisit1 = new VisitOps__VisitType__c(Name='TestCustomerVisit1', VisitOps__Category__c='CV1'); 
        insert testCustomerVisit1;  
        
        testNewStatus = new VisitOps__Status__c(Name='New'); 
        insert testNewStatus;
        
    }
    static void createTestVisitAndRelatedData() {
        try{
            List<VisitOps__Attendee__c> attlist = new List<VisitOps__Attendee__c>();
            system.debug('inside createTestVisitAndRelatedData');
            
            
            currentVisit = new VisitOps__Visit__c(VisitOps__VisitName__c='testVisit1', VisitOps__VisitOwner__c =userInfo.getUserId(), VisitOps__Location__c=testLocation.id, VisitOps__VisitType__c=testCustomerVisit1.id, VisitOps__VisitStatus__c=testNewStatus.id,VisitOps__ArrivalDateTime__c=system.now(), VisitOps__DepartureDateTime__c=system.now().addDays(5), VisitOps__ArrivalDateTimeLocationTZ__c=system.now().format('yyyy-MM-dd HH:mm:ss'),VisitOps__DepartureDateTimeLocationTZ__c=system.now().addDays(5).format('yyyy-MM-dd HH:mm:ss'),VisitOps__TotalNoOfAttendees__c=100);
            insert currentVisit;
            
            testUserAttendee = new VisitOps__Attendee__c(VisitOps__visit__c = currentVisit.id,VisitOps__User__c = userInfo.getUserId(),VisitOps__FirstName__c='seema',VisitOps__LastName__c='singh',VisitOps__Post_Survey_Sent__c=false,VisitOps__PreSurveySent__c=true,VisitOps__Email__c='singh.seema61@sdf.com',VisitOps__Pre_Survey_Required__c=true,VisitOps__Post_Survey_Required__c=true,VisitOps__SendPreSurvey__c = true,VisitOps__SendPostSurvey__c=false);
            insert testUserAttendee; 
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            u = new User(Alias = 'testVis', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='testVisitopsUser@test.com');
            insert u;
            
            /*testsurv1ey.Post_Survey_status__c=null;*/
            
            testAgenda=new VisitOps__Agenda__c(VisitOps__Agenda_Title__c='sample1',VisitOps__Visit__c=currentVisit.id,VisitOps__Start_Time__c=system.now(),VisitOps__End_Time__c=system.now()+10, VisitOps__StartTimeLocationTZ__c = system.now().format('yyyy-MM-dd HH:mm:ss'), VisitOps__EndTimeLocationTZ__c = system.now().addDays(10).format('yyyy-MM-dd HH:mm:ss'));
            insert testAgenda;
            testPresenterAgenda=new VisitOps__Presenter_Agenda_Link__c(VisitOps__Presenter_Name__c='test',VisitOps__Status__c='Accepted',VisitOps__Agenda__c=testAgenda.id);
            insert testPresenterAgenda;
            
            String  visitId= currentVisit.id;
            
            PageReference currentPageRef = Page.VOOwnerPostSurvey;
            Test.setCurrentPage(currentPageRef);
            ApexPages.currentPage().getParameters().put('visitId',currentVisit.id);
            ApexPages.currentPage().getParameters().put('attendeeId',testUserAttendee.id);
            ApexPages.currentPage().getParameters().put('userId',u.id);
            
            
        } 
        catch(Exception ex){system.debug('+++++++++Exception inside createTestVisitAndRelatedData'+ex.getMessage());}
    } 
    
    // Preparing data for Positive Testing
    static void createTestDocumentData() {
        
        Document document = new Document();
        document.Name='testDoc';
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId();
        document.DeveloperName = 'Survey_Logo';
        insert document;
        
        Document document1 = new Document();
        document1.Name='testDoc1';
        document1.AuthorId = UserInfo.getUserId();
        document1.FolderId = UserInfo.getUserId();
        document1.DeveloperName = 'Survey_Footer';
        insert document1;
        
        
    }
    
    static testMethod void testConstructor() {
        try{
            
            system.debug('inside testConstructor');
            createTestData();
            createTestVisitAndRelatedData();
            createTestDocumentData();
            Test.startTest();
            
            List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='VisitOps__Survey__c' and isActive=true and DeveloperName= 'Visit_Owner_Survey' ];
            
            testsurvey=new VisitOps__Survey__c(RecordTypeId = rtypes[0].Id, VisitOps__Were_you_completely_satisfied__c='Completely Satisfied',VisitOps__Satisfaction_Comments__c='abc',VisitOps__Things_You_Would_Like_To_Change__c='nothing',VisitOps__Things_You_Would_Leave_The_Same__c='nothing',VisitOps__Recommendation_Strategy__c=10,VisitOps__Recommendation_Comments__c='grgtrg',VisitOps__Accomplishment_Owner_pre__c='sample1',VisitOps__Biggest_fear__c='sample2',VisitOps__visit__c = currentVisit.id,VisitOps__Post_Survey_status__c=true);
            insert testsurvey;
            
            testsurvey=new VisitOps__Survey__c(RecordTypeId = rtypes[0].Id, VisitOps__Accomplishment_Owner_pre__c='sample1',VisitOps__Biggest_fear__c='sample2',VisitOps__visit__c = currentVisit.id,VisitOps__Pre_Survey_status__c=false);
            insert testsurvey;
            
            system.debug('--visitId---'+ApexPages.currentPage().getParameters().get('visitId'));
            standardControllerObject = new ApexPages.StandardController(testUserAttendee);
            controllerObject = new VOOwnerPostSurveyExtension(standardControllerObject); 
            
            System.currentPageReference().getParameters().put('visitId', currentVisit.id);  
            System.currentPageReference().getParameters().put('attendeeId', testUserAttendee.id); 
            System.currentPageReference().getParameters().put('userId', u.id);   
            
            ApexPages.currentPage().getParameters().put('visitId','');
            ApexPages.currentPage().getParameters().put('attendeeId','');
            ApexPages.currentPage().getParameters().put('userId','');
            
            ApexPages.currentPage().getParameters().put('visitId',null);
            ApexPages.currentPage().getParameters().put('attendeeId',null);
            ApexPages.currentPage().getParameters().put('userId',null);
            controllerObject.flag=true;
            controllerObject.submitSurvey();
            controllerObject.getRadioOpts();
            controllerObject.getRadioOptsNoLabel();
            controllerObject.getDocumentLogoUrl();
            controllerObject.getDocumentFooterUrl();
            controllerObject.flag1=true;
            
            //Already Submitted Exception
            testsurvey.VisitOps__Attendee__c=testUserAttendee.id;
            testsurvey.VisitOps__User__c=u.id;
            testsurvey.VisitOps__Post_Survey_status__c=true;
            update testsurvey;
            ApexPages.currentPage().getParameters().put('visitId',currentVisit.id);
            ApexPages.currentPage().getParameters().put('attendeeId',testUserAttendee.id);
            ApexPages.currentPage().getParameters().put('userId',u.id);
            controllerObject = new VOOwnerPostSurveyExtension(standardControllerObject); 
            
            ApexPages.currentPage().getParameters().put('userId','');
            controllerObject = new VOOwnerPostSurveyExtension(standardControllerObject); 
            
            //Exceptions 
            controllerObject.visitId = testUserAttendee.id;
            controllerObject.SubmitSurvey();
            
            controllerObject.visitId = currentVisit.id;
            controllerObject.agendaPresenterWrapperList = null;
            controllerObject.SubmitSurvey();
            
            System.assertEquals(null,null);
            Test.stopTest();
        }
        catch(Exception ex){system.debug('+++++++++Exception inside createTestVisitAndRelatedData'+ex.getMessage());}
    }
    
    static testMethod void testConstructor2() {
        try{
            
            system.debug('inside testConstructor2');
            createTestData();
            createTestVisitAndRelatedData();
            createTestDocumentData();
            Test.startTest();
            List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='VisitOps__Survey__c' and isActive=true and DeveloperName= 'PresenterSurvey' ];
            
            testsurvey=new VisitOps__Survey__c(RecordTypeId = rtypes[0].Id, VisitOps__Attendee__c=testUserAttendee.id,VisitOps__User__c=u.id,VisitOps__Were_you_completely_satisfied__c='Completely Satisfied',VisitOps__Satisfaction_Comments__c='abc',VisitOps__Things_You_Would_Like_To_Change__c='nothing',VisitOps__Things_You_Would_Leave_The_Same__c='nothing',VisitOps__Recommendation_Strategy__c=10,VisitOps__Recommendation_Comments__c='grgtrg',VisitOps__Accomplishment_Owner_pre__c='sample1',VisitOps__Biggest_fear__c='sample2',VisitOps__visit__c = currentVisit.id,VisitOps__Post_Survey_status__c=false);
            insert testsurvey;
            
            System.currentPageReference().getParameters().put('visitId', '');  
            standardControllerObject = new ApexPages.StandardController(testUserAttendee);
            controllerObject = new VOOwnerPostSurveyExtension(standardControllerObject); 
            
            System.currentPageReference().getParameters().put('visitId', testUserAttendee.id);
            System.currentPageReference().getParameters().put('attendeeId', '');
            System.currentPageReference().getParameters().put('userId', '');
            controllerObject = new VOOwnerPostSurveyExtension(standardControllerObject);
            
            System.currentPageReference().getParameters().put('visitId', testUserAttendee.id);
            System.currentPageReference().getParameters().put('attendeeId', testUserAttendee.id);
            controllerObject = new VOOwnerPostSurveyExtension(standardControllerObject); 
            
            System.currentPageReference().getParameters().put('visitId', currentVisit.id);
            System.currentPageReference().getParameters().put('attendeeId', currentVisit.id);
            controllerObject = new VOOwnerPostSurveyExtension(standardControllerObject);
            
            System.currentPageReference().getParameters().put('visitId', currentVisit.id);  
            System.currentPageReference().getParameters().put('attendeeId', testUserAttendee.id); 
            System.currentPageReference().getParameters().put('userId', u.id);
            controllerObject = new VOOwnerPostSurveyExtension(standardControllerObject);
            controllerObject.SubmitSurvey();
            
            System.assertEquals(null,null);
            Test.stopTest();
        }
        catch(Exception ex){system.debug('+++++++++Exception inside createTestVisitAndRelatedData'+ex.getMessage());}
    }
}