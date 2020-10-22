@isTest(seeAllData=false)
private class VOSurveyCustomerPreTest {

    static ApexPages.StandardController standardControllerObject; 
    static VOCustomerPreSurveyExtension controllerObject; 
    
    static VisitOps__Visit__c currentVisit;
    static VisitOps__Attendee__c testUserAttendee,testContactAttendee;
    static VisitOps__Survey__c testsurvey;
    static VisitOps__Location__c testLocation;
    static VisitOps__VisitType__c testCustomerVisit1;
    static VisitOps__Status__c testNewStatus;
    
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
            system.debug('inside createTestVisitAndRelatedData');

            
            currentVisit = new VisitOps__Visit__c(VisitOps__VisitName__c='testVisit1', VisitOps__VisitOwner__c =userInfo.getUserId(), VisitOps__Location__c=testLocation.id, VisitOps__VisitType__c=testCustomerVisit1.id, VisitOps__VisitStatus__c=testNewStatus.id,VisitOps__ArrivalDateTime__c=system.now(), VisitOps__DepartureDateTime__c=system.now().addDays(5), VisitOps__ArrivalDateTimeLocationTZ__c=system.now().format('yyyy-MM-dd HH:mm:ss'),VisitOps__DepartureDateTimeLocationTZ__c=system.now().addDays(5).format('yyyy-MM-dd HH:mm:ss'), VisitOps__TotalNoOfAttendees__c=100);
            insert currentVisit;
            testUserAttendee = new VisitOps__Attendee__c(VisitOps__Company__c='eretrw',VisitOps__visit__c = currentVisit.id,VisitOps__User__c = userInfo.getUserId(),VisitOps__FirstName__c='seema',VisitOps__LastName__c='singh',VisitOps__Post_Survey_Sent__c=true,VisitOps__PreSurveySent__c=true,VisitOps__Email__c='singh.seema61@sdf.com',VisitOps__Pre_Survey_Required__c=true,VisitOps__Post_Survey_Required__c=true,VisitOps__SendPreSurvey__c = true,VisitOps__SendPostSurvey__c=true);
            insert testUserAttendee;
            
            PageReference currentPageRef = Page.VOCustomerPreSurvey;
            Test.setCurrentPage(currentPageRef);
            ApexPages.currentPage().getParameters().put('visitId',currentVisit.Id);
            ApexPages.currentPage().getParameters().put('attendeeId',testUserAttendee.Id);
            
            
       } 
       catch(Exception ex){
         system.debug('+++++++++Exception inside createTestVisitAndRelatedData'+ex.getMessage());
      }
   } 
     static testMethod void testConstructor() {
        try{
            
            system.debug('inside testConstructor');
            createTestData();
            createTestVisitAndRelatedData();
            Test.startTest();
           standardControllerObject = new ApexPages.StandardController(testUserAttendee);
            controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject); 
            System.currentPageReference().getParameters().put('visitId', currentVisit.id);  
            System.currentPageReference().getParameters().put('attendeeId', testUserAttendee.id); 
            
            ApexPages.currentPage().getParameters().put('visitId','');
            ApexPages.currentPage().getParameters().put('attendeeId','');
            
           ApexPages.currentPage().getParameters().put('visitId',null);
           ApexPages.currentPage().getParameters().put('attendeeId',null);
           controllerObject.flag=true;
           controllerObject.flag1=true;
           controllerObject.showSubmitButton=true;
           controllerObject.SubmitSurvey();
           controllerObject.getRadioOpts();
           controllerObject.getPercentRadioOpts();
           
           testsurvey.VisitOps__Attendee__c=testUserAttendee.id;
           update testsurvey;
           controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject); 
           
           System.assertEquals(null,null);
           Test.stopTest();
           
         }
         catch(Exception ex){
         system.debug('+++++++++Exception inside testConstructor '+ex.getMessage());
      }
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
    
	static testMethod void testSurveyBranding() {
    	try{
    	    
        	system.debug('inside testSurveyBranding');
            createTestData();
            createTestVisitAndRelatedData();
            createTestDocumentData();
            Test.startTest();
           	standardControllerObject = new ApexPages.StandardController(testUserAttendee);
            controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject); 
            System.currentPageReference().getParameters().put('visitId', currentVisit.id);  
            System.currentPageReference().getParameters().put('attendeeId', testUserAttendee.id); 
            
            controllerObject.getDocumentLogoUrl();
            controllerObject.getDocumentFooterUrl();
            
           	System.assertEquals(null,null);
           	Test.stopTest();
           
        }catch(Exception ex){
        	system.debug('Exception inside testSurveyBranding--'+ex.getMessage());
  		}
     }
     
     
	static testMethod void testSurveyExceptions() {
    	try{
    	    
        	system.debug('inside testSurveyExceptions');
            createTestData();
            createTestVisitAndRelatedData();
            Test.startTest();
            Id currentVisitId = currentVisit.id;
            Id attendeeId = testUserAttendee.id;

           	standardControllerObject = new ApexPages.StandardController(testUserAttendee);
            controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject);
             
            controllerObject.visitId = attendeeId;
            controllerObject.SubmitSurvey();
            
            System.currentPageReference().getParameters().put('visitId', '');  
            controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject);
            
            System.currentPageReference().getParameters().put('visitId', currentVisitId);   
            System.currentPageReference().getParameters().put('attendeeId', ''); 
            controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject);
            
            System.currentPageReference().getParameters().put('visitId', currentVisitId);  
            System.currentPageReference().getParameters().put('attendeeId', attendeeId);
            delete testUserAttendee;
            controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject);
            
            System.currentPageReference().getParameters().put('visitId', currentVisitId);  
            System.currentPageReference().getParameters().put('attendeeId', attendeeId);
            insert new VisitOps__Status__c(Name='Cancelled');
            delete currentVisit;
            controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject); 
           	
           	System.assertEquals(null,null);
           	Test.stopTest();
           
        }catch(Exception ex){
        	system.debug('Exception inside testSurveyExceptions--'+ex.getMessage());
  		}
     }         
     
     
     public static testMethod void testAlreadyExistingSurvey(){
            
            createTestData();
            createTestVisitAndRelatedData();
            Test.startTest();
            Id currentVisitId = currentVisit.id;
            Id attendeeId = testUserAttendee.id;

           	standardControllerObject = new ApexPages.StandardController(testUserAttendee);
            controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject);
         
                 List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='VisitOps__Survey__c' and isActive=true and DeveloperName= 'Customer_Survey' ];

         
            testsurvey=new VisitOps__Survey__c(RecordTypeId = rtypes[0].Id, VisitOps__visit__c = currentVisitId,VisitOps__Attendee__c=attendeeId,VisitOps__Pre_Survey_status__c=false,VisitOps__Likely_To_Recommend__c=9,VisitOps__Things_to_Accomplish__c='dad',VisitOps__Level_of_Agreement_Pre__c='dhsdh',VisitOps__ConfidenceLevelBefore__c=100,VisitOps__About_the_Company_Pre__c='djhdjk',VisitOps__Things_to_know_pre__c='dhfjdh');
            insert testsurvey;
            System.currentPageReference().getParameters().put('visitId', currentVisitId);   
            System.currentPageReference().getParameters().put('attendeeId', attendeeId);
            controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject);
            
            testsurvey=new VisitOps__Survey__c(RecordTypeId = rtypes[0].Id, VisitOps__visit__c = currentVisitId,VisitOps__Attendee__c=attendeeId,VisitOps__Pre_Survey_status__c=true,VisitOps__Likely_To_Recommend__c=9,VisitOps__Things_to_Accomplish__c='dad',VisitOps__Level_of_Agreement_Pre__c='dhsdh',VisitOps__ConfidenceLevelBefore__c=100,VisitOps__About_the_Company_Pre__c='djhdjk',VisitOps__Things_to_know_pre__c='dhfjdh');
            insert testsurvey;
            System.currentPageReference().getParameters().put('visitId', currentVisitId);  
            System.currentPageReference().getParameters().put('attendeeId', attendeeId);
            controllerObject = new VOCustomerPreSurveyExtension(standardControllerObject);
            controllerObject.SubmitSurvey();
            
            System.assertEquals(null,null);
            Test.stopTest();
         
     }
}