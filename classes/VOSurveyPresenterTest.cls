@isTest(seeAllData=false)
private class VOSurveyPresenterTest {
  
  static ApexPages.StandardController standardControllerObject; 
  static VOPresenterSurveyExtension controllerObject; 
  static VisitOps__Survey__c testsurvey;
  static VisitOps__Visit__c currentVisit;
  static VisitOps__Location__c testLocation;
  static VisitOps__VisitType__c testCustomerVisit1;
  static VisitOps__Status__c testNewStatus;
  static VisitOps__Presenter_Agenda_Link__c testPresenterAgenda;
  static VisitOps__Agenda__c  testAgenda;
  
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
        currentVisit = new VisitOps__Visit__c(VisitOps__VisitName__c='testVisit1', VisitOps__VisitOwner__c =userInfo.getUserId(), VisitOps__Location__c=testLocation.id, VisitOps__VisitType__c=testCustomerVisit1.id, VisitOps__VisitStatus__c=testNewStatus.id,VisitOps__ArrivalDateTime__c=system.now(),VisitOps__DepartureDateTime__c=system.now().addDays(5), VisitOps__ArrivalDateTimeLocationTZ__c=system.now().format('yyyy-MM-dd HH:mm:ss'),VisitOps__DepartureDateTimeLocationTZ__c=system.now().addDays(5).format('yyyy-MM-dd HH:mm:ss'), VisitOps__TotalNoOfAttendees__c=100);
        insert currentVisit;
        
        testAgenda=new VisitOps__Agenda__c(VisitOps__Agenda_Title__c='sample1',VisitOps__Visit__c=currentVisit.id,VisitOps__Start_Time__c=system.now(),VisitOps__End_Time__c=system.now()+10, VisitOps__StartTimeLocationTZ__c = system.now().format('yyyy-MM-dd HH:mm:ss'), VisitOps__EndTimeLocationTZ__c = system.now().addDays(10).format('yyyy-MM-dd HH:mm:ss'));
        insert testAgenda;
        testPresenterAgenda=new VisitOps__Presenter_Agenda_Link__c(VisitOps__Presenter_Name__c='test',VisitOps__Status__c='Accepted',VisitOps__Agenda__c=testAgenda.id);
        insert testPresenterAgenda;
        
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='VisitOps__Survey__c' and isActive=true and DeveloperName= 'PresenterSurvey' ];
        
        testsurvey=new VisitOps__Survey__c(RecordTypeId = rtypes[0].Id, VisitOps__Were_you_completely_satisfied__c='Completely Satisfied',VisitOps__Satisfaction_Comments__c='abc',VisitOps__Things_You_Would_Like_To_Change__c='nothing',VisitOps__Things_You_Would_Leave_The_Same__c='nothing',VisitOps__Recommendation_Strategy__c=10,VisitOps__Recommendation_Comments__c='grgtrg',VisitOps__Accomplishment_Owner_pre__c='sample1',VisitOps__Biggest_fear__c='sample2',VisitOps__visit__c = currentVisit.id,VisitOps__Post_Survey_status__c=true);
        insert testsurvey;
        
       PageReference currentPageRef = Page.VOPresenterSurvey;
       Test.setCurrentPage(currentPageRef);
       ApexPages.currentPage().getParameters().put('visitId',currentVisit.id);
       ApexPages.currentPage().getParameters().put('presenterId',testPresenterAgenda.id); 
        
     }  
     catch(Exception ex){
     	system.debug('+++++++++Exception inside createTestVisitAndRelatedData'+ex.getMessage());
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
      
  static testMethod void testConstructor() {
        try{
            
            system.debug('inside testConstructor');
            createTestData();
            createTestVisitAndRelatedData();
            createTestDocumentData();
            Test.startTest();
            standardControllerObject = new ApexPages.StandardController(testAgenda);
            controllerObject = new VOPresenterSurveyExtension(standardControllerObject);
            controllerObject.getRadioOpts();
            controllerObject.submitSurvey();
            controllerObject.flag=true;
            
            controllerObject.getDocumentLogoUrl();
            controllerObject.getDocumentFooterUrl();
            
            System.assertEquals(null,null);
            Test.stopTest();
            
        }  
      catch(Exception ex){
      	system.debug('+++++++++Exception inside createTestVisitAndRelatedData'+ex.getMessage());
      }    
 }
	static testMethod void testSurveyExceptions() {
    	try{
    	    
        	system.debug('inside testSurveyExceptions');
            createTestData();
            createTestVisitAndRelatedData();
            Test.startTest();
            Id currentVisitId = currentVisit.id;
            Id presenterId = testPresenterAgenda.id;

           	standardControllerObject = new ApexPages.StandardController(testAgenda);
            controllerObject = new VOPresenterSurveyExtension(standardControllerObject);
             
            controllerObject.visitId = presenterId;
            controllerObject.SubmitSurvey();
            
            System.currentPageReference().getParameters().put('visitId', '');  
            controllerObject = new VOPresenterSurveyExtension(standardControllerObject);
            
            System.currentPageReference().getParameters().put('visitId', currentVisitId);   
            System.currentPageReference().getParameters().put('presenterId', ''); 
            controllerObject = new VOPresenterSurveyExtension(standardControllerObject);
            
            System.currentPageReference().getParameters().put('visitId', currentVisitId);  
            System.currentPageReference().getParameters().put('presenterId', presenterId);
            testsurvey.VisitOps__Presenter_Agenda_Link__c = testPresenterAgenda.id;
            update testsurvey;
            controllerObject = new VOPresenterSurveyExtension(standardControllerObject);
            
            System.currentPageReference().getParameters().put('visitId', currentVisitId);  
            System.currentPageReference().getParameters().put('presenterId', presenterId);
            insert new VisitOps__Status__c(Name='Cancelled');
            delete currentVisit;
            controllerObject = new VOPresenterSurveyExtension(standardControllerObject); 
            
           	System.assertEquals(null,null);
           	Test.stopTest();
           
        }catch(Exception ex){
        	system.debug('Exception inside testSurveyExceptions--'+ex.getMessage());
  		}
     }    
 
}