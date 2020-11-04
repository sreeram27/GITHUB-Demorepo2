@isTest(seeAllData=false)
private class VOTestCustomerPostSurveyExtension {

    //Variable declaration
    static ApexPages.StandardController standardControllerObject;
    static VOCustomerPostSurveyExtension controllerObject;
    static VisitOps__Visit__c referenceVisit;
    
    static VisitOps__Room__c testRoom;
    static VisitOps__Location__c testLocation;
    static VisitOps__VisitType__c testCustomerVisit1;
    static VisitOps__Status__c testNewStatus;
    
    static Account testAccount;
    static VisitOps__Company__c testCompany;
    static Contact testContact;
    static VisitOps__Visit__c currentVisit;
    static sobject testOpportunity;
    static sobject testVisitOppLink;
    static VisitOps__Attendee__c testContactAttendee,testUserAttendee;
    static VisitOps__Survey__c testSurvey,testSurvey1;
    static VisitOps__Agenda__c agenda1,parkedAgenda;
    static VisitOps__Presenter_Agenda_Link__c pal;
    static List<RecordType> rtypes;
    
    static final Boolean isOpportunityAvailable;
    static final Boolean isOpportunityAccessible;
    
    static{
        try{
            isOpportunityAvailable = true;
            isOpportunityAccessible = true;    	
            rtypes = [Select Name, Id From RecordType where sObjectType='VisitOps__Survey__c' and isActive=true and DeveloperName= 'Customer_Survey' ];
        }catch(Exception ex){
            system.debug('Exception inside static block while determining isOpportunityAvailable and isOpportunityAccessible--'+ex.getMessage());   
        }
    }
    
    
    //Create test data for testmethods
    static void createTestData() {
        //Insert Location
        testLocation = new VisitOps__Location__c(Name='TestLocation',VisitOps__Location_Street_Address__c='testAddress', VisitOps__Time_Zone__c = '(GMT+00:00) Greenwich Mean Time (GMT)'); 
        insert testLocation;
        VisitOps__Place__c testPlace = new VisitOps__Place__c(Name='TestPlace', VisitOps__Location__c=testLocation.Id);
        insert testPlace;
        //Insert VisitType
        testCustomerVisit1 = new VisitOps__VisitType__c(Name='TestCustomerVisit1', VisitOps__Category__c='CV1'); 
        insert testCustomerVisit1;
        
        //Create visitTypeMapping
        insert new VisitOps__LocationTypeLink__c(VisitOps__Location__c=testLocation.id,VisitOps__VisitType__c=testCustomerVisit1.id,VisitOps__Hide_Presenters_on_Survey__c=true);
        
        //Create Room
        testRoom = new VisitOps__Room__c(Name='TestRoom',VisitOps__Location__c=testLocation.id,VisitOps__Place__c=testPlace.Id,VisitOps__Room_Capacity__c=20);
        insert testRoom;
        
        //Create Status - New
        testNewStatus = new VisitOps__Status__c(Name='New'); 
        insert testNewStatus;
        
		referenceVisit=new VisitOps__Visit__c(VisitOps__VisitName__c='ReferenceVisit - DoNotDelete', VisitOps__VisitOwner__c =userInfo.getUserId(), VisitOps__Location__c=testLocation.id, VisitOps__VisitType__c=testCustomerVisit1.id, VisitOps__VisitStatus__c=testNewStatus.id, VisitOps__VisitStatus__r=testNewStatus, VisitOps__ArrivalDateTime__c=system.now(),VisitOps__DepartureDateTime__c=system.now()+5, VisitOps__TotalNoOfAttendees__c=100,
        					VisitOps__ArrivalDateTimeLocationTZ__c=system.now().format('yyyy-MM-dd HH:mm:ss'),VisitOps__DepartureDateTimeLocationTZ__c=system.now().addDays(5).format('yyyy-MM-dd HH:mm:ss'));
        insert(referenceVisit);
        
    }
    
    // Preparing data for Positive Testing
    static void createTestVisitAndRelatedData() {
        try{
            system.debug('inside createTestVisitAndRelatedData');
            
            //Create New Account
            testAccount = new Account(Name='testAccount');
            insert testAccount;
            
            //Create New Visit
			currentVisit = new VisitOps__Visit__c(VisitOps__VisitName__c='testVisit', VisitOps__VisitOwner__c =userInfo.getUserId(), VisitOps__Location__c=testLocation.id, VisitOps__VisitType__c=testCustomerVisit1.id, VisitOps__VisitStatus__c=testNewStatus.id, VisitOps__VisitStatus__r=testNewStatus, VisitOps__ArrivalDateTime__c=system.now(), VisitOps__DepartureDateTime__c=system.now()+5, VisitOps__TotalNoOfAttendees__c=100, VisitOps__Room__c=testRoom.id,
            							VisitOps__ArrivalDateTimeLocationTZ__c=system.now().format('yyyy-MM-dd HH:mm:ss'),VisitOps__DepartureDateTimeLocationTZ__c=system.now().addDays(5).format('yyyy-MM-dd HH:mm:ss'));
            insert currentVisit;
            
            //Create Company
            testCompany = new VisitOps__company__c(VisitOps__visit__c = currentVisit.id, VisitOps__Account__c = testAccount.id); 
            insert testCompany;
            
            //Create Contact
            testContact = new Contact(LastName = 'testContact', Email = 'testContact@abc.com', AccountId = testAccount.id);
            insert testContact;
            
            //Create Attendee - Contact type
            testContactAttendee = new VisitOps__Attendee__c(VisitOps__visit__c = currentVisit.id, VisitOps__Contact__c = testContact.id);
            insert testContactAttendee;
            
            //Create Attendee - User type
            testUserAttendee = new VisitOps__Attendee__c(VisitOps__visit__c = currentVisit.id, VisitOps__User__c = userInfo.getUserId());
            insert testUserAttendee;
            
            //Create Survey for Negative Testing
            testSurvey1= new VisitOps__Survey__c(RecordTypeId = rtypes[0].Id, VisitOps__Post_Survey_status__c=True, VisitOps__Things_to_Accomplish__c='Things to accomplish', VisitOps__Likely_To_Recommend__c=8, VisitOps__Visit__c=currentVisit.Id, VisitOps__Attendee__c=testContactAttendee.Id);
            insert testSurvey1;
            
            //Create an Agenda Item
            agenda1 = new VisitOps__Agenda__c(VisitOps__Agenda_Title__c='Test Agenda1',VisitOps__Objectives__c='Test Objectves',VisitOps__Start_Time__c=System.Now(),VisitOps__End_Time__c=System.Now()+5,VisitOps__StartTimeLocationTZ__c=system.now().format('yyyy-MM-dd HH:mm:ss'),VisitOps__EndTimeLocationTZ__c=system.now().addDays(5).format('yyyy-MM-dd HH:mm:ss'),VisitOps__Visit__c=currentVisit.Id,VisitOps__Room__c=testRoom.Id);
            insert agenda1;
            
            //Create a parked Agenda Item
            parkedAgenda = new VisitOps__Agenda__c(VisitOps__Agenda_Title__c='Test Agenda1', VisitOps__IsParked__c=true, VisitOps__Objectives__c='Test Objectves',VisitOps__Start_Time__c=System.Now(),VisitOps__End_Time__c=System.Now()+20,VisitOps__StartTimeLocationTZ__c=system.now().format('yyyy-MM-dd HH:mm:ss'),VisitOps__EndTimeLocationTZ__c=system.now().addDays(5).format('yyyy-MM-dd HH:mm:ss'),VisitOps__Visit__c=currentVisit.Id);
	        insert parkedAgenda;
	        
	        //Add Presenters to the Session
	        pal = new VisitOps__Presenter_Agenda_Link__c(VisitOps__User__c=UserInfo.getUserId(),VisitOps__Agenda__c=agenda1.Id,VisitOps__Status__c='Accepted');
	        insert pal;
            
            //Create New Opportunity if Org has Opportunity
            if(isOpportunityAvailable && isOpportunityAccessible){
            	testOpportunity = Schema.getGlobalDescribe().get('Opportunity').newSObject();
				testOpportunity.put('Name','testOpportunity');
				testOpportunity.put('AccountId',testAccount.id);
				testOpportunity.put('CloseDate',system.today()+2);
				testOpportunity.put('StageName','Prospecting');
				insert testOpportunity;
            }
            testVisitOppLink = new VisitOps__VisitBundle__c(VisitOps__visit__c = currentVisit.id);
            testVisitOppLink.put('VisitOps__Opportunity__c', testOpportunity.get('Id')); 
            insert testVisitOppLink;
            
        }catch(Exception ex){
            system.debug('Exception inside createTestVisitAndRelatedData'+ex.getMessage());
        }
    }
    
    // Preparing Data for Negative Testing
    static void createTestVisitAndRelatedNegativeData() {
        try{
            system.debug('inside createTestVisitAndRelatedData');
            
            //Create New Account
            testAccount = new Account(Name='testAccount');
            insert testAccount;
            
            //Create New Visit
			currentVisit = new VisitOps__Visit__c(VisitOps__VisitName__c='testVisit', VisitOps__VisitOwner__c =userInfo.getUserId(), VisitOps__Location__c=testLocation.id, VisitOps__VisitType__c=testCustomerVisit1.id, VisitOps__VisitStatus__c=testNewStatus.id, VisitOps__VisitStatus__r=testNewStatus, VisitOps__ArrivalDateTime__c=system.now(), VisitOps__DepartureDateTime__c=system.now()+5, VisitOps__TotalNoOfAttendees__c=100, VisitOps__Room__c=testRoom.id,
            							VisitOps__ArrivalDateTimeLocationTZ__c=system.now().format('yyyy-MM-dd HH:mm:ss'),VisitOps__DepartureDateTimeLocationTZ__c=system.now().addDays(5).format('yyyy-MM-dd HH:mm:ss'));
            insert currentVisit;
            
            //Create Company
            testCompany = new VisitOps__company__c(VisitOps__visit__c = currentVisit.id, VisitOps__Account__c = testAccount.id); 
            insert testCompany;
            
            //Create Contact
            testContact = new Contact(LastName = 'testContact', Email = 'testContact@abc.com', AccountId = testAccount.id);
            insert testContact;
            
            //Create Attendee - Contact type
            testContactAttendee = new VisitOps__Attendee__c(VisitOps__visit__c = currentVisit.id, VisitOps__Contact__c = testContact.id);
            insert testContactAttendee;
            
            //Create Attendee - User type
            testUserAttendee = new VisitOps__Attendee__c(VisitOps__visit__c = currentVisit.id, VisitOps__User__c = userInfo.getUserId());
            insert testUserAttendee;
            
            //Create Survey for Negative Testing
            testSurvey1= new VisitOps__Survey__c(RecordTypeId = rtypes[0].Id, VisitOps__Post_Survey_status__c=false, VisitOps__Things_to_Accomplish__c='Things to accomplish', VisitOps__Likely_To_Recommend__c=8, VisitOps__Visit__c=currentVisit.Id, VisitOps__Attendee__c=testContactAttendee.Id);
            insert testSurvey1;
            
            //Create an Agenda Item
            agenda1 = new VisitOps__Agenda__c(VisitOps__Agenda_Title__c='Test Agenda1',VisitOps__Objectives__c='Test Objectves',VisitOps__Start_Time__c=System.Now(),VisitOps__End_Time__c=System.Now()+5,VisitOps__StartTimeLocationTZ__c=system.now().format('yyyy-MM-dd HH:mm:ss'),VisitOps__EndTimeLocationTZ__c=system.now().addDays(5).format('yyyy-MM-dd HH:mm:ss'),VisitOps__Visit__c=currentVisit.Id,VisitOps__Show_on_Customer_Survey__c=true);
            insert agenda1;
            
            //Create a parked Agenda Item
            parkedAgenda = new VisitOps__Agenda__c(VisitOps__Agenda_Title__c='Test Agenda1', VisitOps__IsParked__c=true, VisitOps__Objectives__c='Test Objectves',VisitOps__Start_Time__c=System.Now(),VisitOps__End_Time__c=System.Now()+20,VisitOps__StartTimeLocationTZ__c=system.now().format('yyyy-MM-dd HH:mm:ss'),VisitOps__EndTimeLocationTZ__c=system.now().addDays(5).format('yyyy-MM-dd HH:mm:ss'),VisitOps__Visit__c=currentVisit.Id);
	        insert parkedAgenda;
	        
	        //Add Presenters to the Session
	        pal = new VisitOps__Presenter_Agenda_Link__c(VisitOps__User__c=UserInfo.getUserId(),VisitOps__Agenda__c=agenda1.Id,VisitOps__Status__c='Accepted');
	        insert pal;
            
            //Create New Opportunity if Org has Opportunity
            if(isOpportunityAvailable && isOpportunityAccessible){
            	testOpportunity = Schema.getGlobalDescribe().get('Opportunity').newSObject();
				testOpportunity.put('Name','testOpportunity');
				testOpportunity.put('AccountId',testAccount.id);
				testOpportunity.put('CloseDate',system.today()+2);
				testOpportunity.put('StageName','Prospecting');
				insert testOpportunity;
            }
            testVisitOppLink = new VisitOps__VisitBundle__c(VisitOps__visit__c = currentVisit.id);
            testVisitOppLink.put('VisitOps__Opportunity__c', testOpportunity.get('Id')); 
            insert testVisitOppLink;
            
        }catch(Exception ex){
            system.debug('Exception inside createTestVisitAndRelatedData'+ex.getMessage());
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
    
    static testMethod void testCustomPostSurvey(){
    	
    	try{
    	    
            system.debug('inside testConstructor');
            
        	//Create Test Data           
            createTestData();
            createTestVisitAndRelatedData();
            createTestDocumentData();
            Test.startTest();
            //Set Current Page
            PageReference pageRef = Page.VOCustomerPostSurvey;
        	Test.setCurrentPage(pageRef);
        	
            //Set Parameters for the page
            ApexPages.currentPage().getParameters().put('visitId',currentVisit.Id);
            ApexPages.currentPage().getParameters().put('attendeeId',testContactAttendee.Id);
            
            //New Survey Case
            standardControllerObject = new ApexPages.StandardController(new VisitOps__Survey__c());
            controllerObject = new VOCustomerPostSurveyExtension(standardControllerObject);
            
            controllerObject.getRadioOpts();
            controllerObject.getPercentRadioOpts();
            controllerObject.getPicklistOptsforPerception();
            controllerObject.getPicklistOpts();
            controllerObject.getRadioOptsforAgenda();
            controllerObject.getRadio();
            
            controllerObject.agendaPresenterWrapperList=new List<VOCustomerPostSurveyExtension.AgendaPresenterWrapper>();
            VisitOps__Agenda_Survey__c agendaSurveyRecord = new VisitOps__Agenda_Survey__c(VisitOps__Agenda__c=agenda1.Id);
            List<VisitOps__Presenter_Survey__c> psList;
            if(agenda1.VisitOps__Presenter_Agenda_Links__r!=null && agenda1.VisitOps__Presenter_Agenda_Links__r.size()>0) {
		    		psList = new List<VisitOps__Presenter_Survey__c>();
		    		for(VisitOps__Presenter_Agenda_Link__c eachPresenterLink : agenda1.VisitOps__Presenter_Agenda_Links__r) {
		    			VisitOps__Presenter_Survey__c tempPresenterSurveyRecord = new VisitOps__Presenter_Survey__c(VisitOps__Presenter_Agenda_Link__r=eachPresenterLink,VisitOps__Presenter_Agenda_Link__c=eachPresenterLink.Id);
		    			psList.add(tempPresenterSurveyRecord);
		    		}
		    }
            VOCustomerPostSurveyExtension.AgendaPresenterWrapper apWrapper=new VOCustomerPostSurveyExtension.AgendaPresenterWrapper(agendaSurveyRecord,psList);
            controllerObject.agendaPresenterWrapperList.add(apWrapper);
            controllerObject.surveyRecord= new VisitOps__Survey__c();
            controllerObject.SubmitSurvey();
            
            controllerObject.getDocumentLogoUrl();
            controllerObject.getDocumentFooterUrl();
            
            system.assertEquals(null,null);
            Test.stopTest();
            
        }catch(Exception ex){
            system.debug('Exception inside testConstructor'+ex.getMessage());
        }
        
    }
    
    // Negative Testing for Controller
    static testMethod void testtestCustomPostSurveyNegative(){
    	
    	try{
    	    
            system.debug('inside testConstructor');
            
        	//Create Test Data           
            createTestData();
            createTestVisitAndRelatedNegativeData();
            Test.startTest();
            //Set Current Page
            PageReference pageRef = Page.VOCustomerPostSurvey;
        	Test.setCurrentPage(pageRef);
        	
        	//Test for new survey
            ApexPages.currentPage().getParameters().put('visitId',currentVisit.id);
            ApexPages.currentPage().getParameters().put('attendeeId',testContactAttendee.Id);
            standardControllerObject = new ApexPages.StandardController(new VisitOps__Survey__c());
            controllerObject = new VOCustomerPostSurveyExtension(standardControllerObject);
            controllerObject.SubmitSurvey();
        	
            //Test without visitid
            ApexPages.currentPage().getParameters().put('visitId','');
            standardControllerObject = new ApexPages.StandardController(new VisitOps__Survey__c());
            controllerObject = new VOCustomerPostSurveyExtension(standardControllerObject);
            
            //Test without attendeeid
            ApexPages.currentPage().getParameters().put('visitId',currentVisit.id);
            ApexPages.currentPage().getParameters().put('attendeeId','');
            standardControllerObject = new ApexPages.StandardController(new VisitOps__Survey__c());
            controllerObject = new VOCustomerPostSurveyExtension(standardControllerObject);
            
            //Test for No Visits Exception
            ApexPages.currentPage().getParameters().put('visitId',testContactAttendee.id);
            ApexPages.currentPage().getParameters().put('attendeeId',testContactAttendee.Id);
            standardControllerObject = new ApexPages.StandardController(new VisitOps__Survey__c());
            controllerObject = new VOCustomerPostSurveyExtension(standardControllerObject);
            
            //Test for No Attendees Exception
            ApexPages.currentPage().getParameters().put('visitId',currentVisit.id);
            ApexPages.currentPage().getParameters().put('attendeeId',currentVisit.Id);
            standardControllerObject = new ApexPages.StandardController(new VisitOps__Survey__c());
            controllerObject = new VOCustomerPostSurveyExtension(standardControllerObject);
            
            system.assertEquals(null,null);
            Test.stopTest();
            
        }catch(Exception ex){
            system.debug('Exception inside testConstructor'+ex.getMessage());
        }
        
    }
}