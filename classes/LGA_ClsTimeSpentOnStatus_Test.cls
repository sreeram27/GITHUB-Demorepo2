@isTest
public class LGA_ClsTimeSpentOnStatus_Test {

    @testSetup 
    static void setup() {
        List<String> lstReleaseNames = new List<String>{'testRel1', 'testRel2' , 'testRel3', 'testRel4', 'testRel5'};
        List<Release__c> releaseObjList = Anthem_TestDataFactory.generateRelease(lstReleaseNames);
		insert releaseObjList;    
        
        Map<String,String> requestObjValueMap = new Map<String,String>();
        requestObjValueMap.put('Release__c',releaseObjList.get(0).Id);
        requestObjValueMap.put('Request_Type__c','Configuration');
        requestObjValueMap.put('Request_Title__c','Test');
        requestObjValueMap.put('Status__c','Identify: New Requirement');
        requestObjValueMap.put('Related_Request__c',null);
        
        Request__c request = Anthem_TestDataFactory.generateRequest(requestObjValueMap);
        insert request;
        
        requestObjValueMap.put('Release__c',releaseObjList.get(1).Id);
        requestObjValueMap.put('Status__c','Identify: On-Hold Waiting on Client');
        Request__c rel2Request = Anthem_TestDataFactory.generateRequest(requestObjValueMap);
        insert rel2Request;
        
        requestObjValueMap.put('Release__c',releaseObjList.get(2).Id);
        requestObjValueMap.put('Status__c','Identify: On-Hold Waiting on Client');
        Request__c rel3Request = Anthem_TestDataFactory.generateRequest(requestObjValueMap);
        insert rel3Request;
        
        requestObjValueMap.put('Release__c',releaseObjList.get(3).Id);
        requestObjValueMap.put('Status__c','Close: Duplicate');
        requestObjValueMap.put('Related_Request__c',rel3Request.Id);
        Request__c closeDupRequest = Anthem_TestDataFactory.generateRequest(requestObjValueMap);
        insert closeDupRequest;
		
		requestObjValueMap.put('Release__c',releaseObjList.get(4).Id);
        requestObjValueMap.put('Status__c','Close: Duplicate');
        requestObjValueMap.put('Related_Request__c',rel3Request.Id);
        Request__c closeDupRequest1 = Anthem_TestDataFactory.generateRequest(requestObjValueMap);
        insert closeDupRequest1;
        
        
    }
    
    @isTest
    public static void testNewTimeSpent1(){        
        Test.startTest();
        Release__c release = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request = [SELECT Id from Request__c where Release__c = :release.Id];
        request.Status__c = 'Identify: Deferred';
        request.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update request;        
        request.Status__c = 'Identify: On-Hold Waiting on Client';
        update request;        
        request.Status__c = 'Identify: Emergency Request';
        update request;        
        request.Status__c = 'Identify: On-Hold Waiting on Client';
        update request;        
        request.Status__c = 'Identify: Deferred';
        request.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update request;        
        request.Status__c = 'Identify: On-Hold Waiting on Client';
        update request;        
        request.Status__c = 'Consolidate: Approve to Estimate';
        update request;        
        request.Status__c = 'Identify: On-Hold Waiting on Client';
        update request;        
        request.Status__c = 'Consolidate: Level of Effort Complete';
        update request;        
        request.Status__c = 'Identify: On-Hold Waiting on Client';
        update request;        
        request.Status__c = 'Approve: Approved to Deploy';
        update request;        
        request.Status__c = 'Identify: On-Hold Waiting on Client';
        update request;        
        request.Status__c = 'Release: Design';
        update request;        
        request.Status__c = 'Identify: On-Hold Waiting on Client';
        update request;        
        request.Status__c = 'Release: Build';
        update request;        
        Release__c release2 = [SELECT Id from Release__c where Name = 'testRel2'];
        Request__c request2 = [SELECT Id from Request__c where Release__c = :release2.Id];  
        request2.Status__c = 'Identify: New Requirement';
        update request2;
       	Release__c release3 = [SELECT Id from Release__c where Name = 'testRel3'];
        Request__c request3 = [SELECT Id from Request__c where Release__c = :release3.Id];
        request3.Status__c = 'Identify: Submit for Business Review';
        update request3;
        
        request3.Status__c = 'Consolidate: Level of Effort Complete';
        update request3;
		request3.Status__c = 'Close: Rejected';
		request3.StopTime_Rejected__c = System.now();
		request3.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
		update request3;
                                
		request3.Status__c = 'Consolidate: Level of Effort Complete';
        update request3;
		request3.Status__c = 'Close: Duplicate';
		request3.StopTime_Duplicate__c = System.now();
        request3.Related_Request__c = request2.Id;
		update request3;
		
		request3.Status__c = 'Approve: Approved to Deploy';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = null;
		update request3;


		request3.Status__c = 'Approve: Approved to Deploy';
		update request3;
		request3.Status__c = 'Release: Test Production';
		request3.StopTime_Test_Production__c = System.now();
		update request3;

		request3.Status__c = 'Approve: Approved to Deploy';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = System.now();
		update request3;
						
		request3.Status__c = 'Approve: Approved to Deploy';
		update request3;
		request3.Status__c = 'Close: Rejected';
		request3.StopTime_Rejected__c = System.now();
		update request3;


		//************

		request3.Status__c = 'Approve: Approved to Deploy';
		update request3;
		request3.Status__c = 'Close: Duplicate';
		request3.StopTime_Duplicate__c = System.now();
		update request3;

		request3.Status__c = 'Release: Design';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = null;
		update request3;


		request3.Status__c = 'Release: Design';
		update request3;
		request3.Status__c = 'Release: Test Production';
		request3.StopTime_Test_Production__c = System.now();
		update request3;

		request3.Status__c = 'Release: Design';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = System.now();
		update request3;
        
		request3.Status__c = 'Identify: New Requirement';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = null;
		update request3;
		
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		update request3;
		request3.Status__c = 'Release: Test';
		request3.StopTime_Test__c = null;
		update request3;
		
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		update request3;
		request3.Status__c = 'Release: SIT';
		request3.StopTime_SIT__c = null;
		update request3;
		
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		update request3;
		request3.Status__c = 'Release: UAT';
		request3.StopTime_UAT__c = null;
		update request3;
		
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		update request3;
		request3.Status__c = 'Release: Build Production';
		request3.StopTime_Build_Production__c = null;
		update request3;
		
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		update request3;
		request3.Status__c = 'Release: Test Production';
		request3.StopTime_Test_Production__c = null;
		update request3;
		
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = null;
		update request3;
		
		request3.Status__c = 'Identify: Submit for Business Review';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = null;
		update request3;
		
		request3.Status__c = 'Identify: Submit for Business Review';
		update request3;
		request3.Status__c = 'Consolidate: Approve to Estimate';
		request3.StopTime_Approve_to_Estimate__c = System.now();
		update request3;
		
		request3.Status__c = 'Identify: Submit for Business Review';
		update request3;
		request3.Status__c = 'Release: Test Production';
		request3.StopTime_Test_Production__c = System.now();
		update request3;
		
		request3.Status__c = 'Identify: Submit for Business Review';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = System.now();
		update request3;
		
		request3.Status__c = 'Identify: Emergency Request';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = null;
		update request3;
		
		request3.Status__c = 'Identify: Emergency Request';
		update request3;
		request3.Status__c = 'Release: Test Production';
		request3.StopTime_Test_Production__c = System.now();
		update request3;
		
		request3.Status__c = 'Identify: Emergency Request';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = System.now();
		update request3;
		
		request3.Status__c = 'Identify: Deferred';
		update request3;
		request3.Status__c = 'Identify: New Requirement';
		request3.StopTime_Identify_New_Requirement__c = System.now();
		update request3;
		
		request3.Status__c = 'Identify: Deferred';
		update request3;
		request3.Status__c = 'Release: Test Production';
		request3.StopTime_Test_Production__c = System.now();
		update request3;
		
		request3.Status__c = 'Identify: Deferred';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = System.now();
		update request3;
		
        
		request3.Status__c = 'Consolidate: Approve to Estimate';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = null;
		update request3;
        
        System.assertEquals(request3.Status__c, 'Identify: On-Hold Waiting on Client', 'Success');        
        Test.stopTest();
    }
    
    @isTest
    public static void testNewTimeSpent2(){        
        Test.startTest();
        Release__c release3 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request3 = [SELECT Id from Request__c where Release__c = :release3.Id];
		
		
		//----------------------------------------------------------------
		request3.Status__c = 'Consolidate: Approve to Estimate';
		update request3;
		request3.Status__c = 'Release: Test Production';
		request3.StopTime_Test_Production__c = System.now();
		update request3;
		
		request3.Status__c = 'Consolidate: Approve to Estimate';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = System.now();
		update request3;
		
		request3.Status__c = 'Consolidate: Level of Effort Complete';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = null;
		update request3;
		
		request3.Status__c = 'Consolidate: Level of Effort Complete';
		update request3;
		request3.Status__c = 'Release: Test Production';
		request3.StopTime_Test_Production__c = System.now();
		update request3;
		
		request3.Status__c = 'Consolidate: Level of Effort Complete';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = System.now();
		update request3;
		
		request3.Status__c = 'Release: Build';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = null;
		update request3;
		
		request3.Status__c = 'Release: Build';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
		update request3;
		
		request3.Status__c = 'Release: Build';
		update request3;
		request3.Status__c = 'Release: Test Production';
		request3.StopTime_Test_Production__c = System.now();
		update request3;
		
		request3.Status__c = 'Release: Build';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = System.now();
		update request3;
		
		request3.Status__c = 'Release: Test';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = null;
		update request3;
		
		request3.Status__c = 'Release: Test';
		update request3;
		request3.Status__c = 'Identify: On-Hold Waiting on Client';
		request3.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
		update request3;
		
		request3.Status__c = 'Release: Test';
		update request3;
		request3.Status__c = 'Release: Test Production';
		request3.StopTime_Test_Production__c = System.now();
		update request3;
		
		request3.Status__c = 'Release: Test';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = System.now();
		update request3;
		
		request3.Status__c = 'Release: Test';
		update request3;
		request3.Status__c = 'Close: Deployed';
		request3.StopTime_Deployed__c = System.now();
		update request3;
		
		System.assertEquals(request3.Status__c,'Close: Deployed','Success');		
		Test.stopTest();
	}
    
    @isTest
    public static void testCloseDuplicateRequest(){        
        Test.startTest();        
        Release__c release1 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request1 = [SELECT Id from Request__c where Release__c = :release1.Id];        
        Release__c release = [SELECT Id from Release__c where Name = 'testRel3'];
        Request__c closeDuplicateRequest = [SELECT Id from Request__c where Release__c = :release.Id];
        closeDuplicateRequest.Status__c = 'Identify: New Requirement';
        update closeDuplicateRequest; 
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest; 
        closeDuplicateRequest.Status__c = 'Close: Rejected';
        closeDuplicateRequest.StopTime_Rejected__c = System.now();
        closeDuplicateRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeDuplicateRequest;  
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        closeDuplicateRequest.Status__c = 'Close: Rejected';
        closeDuplicateRequest.StopTime_Rejected__c = null;
        update closeDuplicateRequest;  
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        closeDuplicateRequest.Status__c = 'Close: Deployed';
        closeDuplicateRequest.StopTime_Deployed__c = null;
        update closeDuplicateRequest;  
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        closeDuplicateRequest.Status__c = 'Close: Deployed';
        closeDuplicateRequest.StopTime_Deployed__c = System.now();
        update closeDuplicateRequest;  
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        closeDuplicateRequest.Status__c = 'Release: Test Production';
        closeDuplicateRequest.StopTime_Test_Production__c = null;
        update closeDuplicateRequest;  
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        closeDuplicateRequest.Status__c = 'Release: Test Production';
        closeDuplicateRequest.StopTime_Test_Production__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: Build Production';
        closeDuplicateRequest.StopTime_Build_Production__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: Build Production';
        closeDuplicateRequest.StopTime_Build_Production__c = System.now();
        update closeDuplicateRequest; 
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: UAT';
        closeDuplicateRequest.StopTime_UAT__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: UAT';
        closeDuplicateRequest.StopTime_UAT__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
         closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: SIT';
        closeDuplicateRequest.StopTime_SIT__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: SIT';
        closeDuplicateRequest.StopTime_SIT__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: Test';
        closeDuplicateRequest.StopTime_Test__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: Test';
        closeDuplicateRequest.StopTime_Test__c = System.now();
        update closeDuplicateRequest; 
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
         closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: Build';
        closeDuplicateRequest.StopTime_Build__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: Build';
        closeDuplicateRequest.StopTime_Build__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
         closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: Design';
        closeDuplicateRequest.StopTime_Design__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Release: Design';
        closeDuplicateRequest.StopTime_Design__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Approve: Approved to Deploy';
        closeDuplicateRequest.StopTime_Approved_to_Deploy__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Approve: Approved to Deploy';
        closeDuplicateRequest.StopTime_Approved_to_Deploy__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Consolidate: Level of Effort Complete';
        closeDuplicateRequest.StopTime_Level_of_Effort_Complete__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Consolidate: Level of Effort Complete';
        closeDuplicateRequest.StopTime_Level_of_Effort_Complete__c = System.now();
        update closeDuplicateRequest; 
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Consolidate: Approve to Estimate';
        closeDuplicateRequest.StopTime_Approve_to_Estimate__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Consolidate: Approve to Estimate';
        closeDuplicateRequest.StopTime_Approve_to_Estimate__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: Deferred';
        closeDuplicateRequest.StopTime_Deferred__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: Deferred';
        closeDuplicateRequest.StopTime_Deferred__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: Emergency Request';
        closeDuplicateRequest.StopTime_Emergency_Request__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: Emergency Request';
        closeDuplicateRequest.StopTime_Emergency_Request__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: Submit for Business Review';
        closeDuplicateRequest.StopTime_Identify_Submit_for_Business__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: Submit for Business Review';
        closeDuplicateRequest.StopTime_Identify_Submit_for_Business__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        closeDuplicateRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        closeDuplicateRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        closeDuplicateRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        closeDuplicateRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update closeDuplicateRequest; 
        
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: New Requirement';
        closeDuplicateRequest.StopTime_Identify_New_Requirement__c = null;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Close: Duplicate';
        closeDuplicateRequest.Related_Request__c = request1.Id;
        update closeDuplicateRequest;  
        
        closeDuplicateRequest.Status__c = 'Identify: New Requirement';
        closeDuplicateRequest.StopTime_Identify_New_Requirement__c = System.now();
        update closeDuplicateRequest; 
        
        System.assertEquals(closeDuplicateRequest.Status__c, 'Identify: New Requirement','Success');        
        Test.stopTest();
    }
    
    @isTest
    public static void testCloseRejectedRequest(){        
        Test.startTest();      
        Release__c release1 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request1 = [SELECT Id from Request__c where Release__c = :release1.Id];        
        Release__c release = [SELECT Id from Release__c where Name = 'testRel3'];
        Request__c closeRejectedRequest = [SELECT Id from Request__c where Release__c = :release.Id];
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Identify: New Requirement';
        closeRejectedRequest.StopTime_Identify_New_Requirement__c = null;
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        closeRejectedRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        closeRejectedRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update closeRejectedRequest; 
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Identify: Submit for Business Review';
        closeRejectedRequest.StopTime_Identify_Submit_for_Business__c = null;
        update closeRejectedRequest; 
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Identify: Emergency Request';
        closeRejectedRequest.StopTime_Emergency_Request__c = null;
        update closeRejectedRequest; 
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Identify: Deferred';
        closeRejectedRequest.StopTime_Deferred__c = null;
        update closeRejectedRequest; 
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Consolidate: Approve to Estimate';
        closeRejectedRequest.StopTime_Approve_to_Estimate__c = null;
        update closeRejectedRequest; 
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Release: Design';
        closeRejectedRequest.StopTime_Design__c = null;
        update closeRejectedRequest; 
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Release: Build';
        closeRejectedRequest.StopTime_Build__c = null;
        update closeRejectedRequest; 
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Release: Test';
        closeRejectedRequest.StopTime_Test__c = null;
        update closeRejectedRequest; 
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Release: SIT';
        closeRejectedRequest.StopTime_SIT__c = null;
        update closeRejectedRequest;
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Release: UAT';
        closeRejectedRequest.StopTime_UAT__c = null;
        update closeRejectedRequest;
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Release: Build Production';
        closeRejectedRequest.StopTime_Build_Production__c = null;
        update closeRejectedRequest;
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Release: Test Production';
        closeRejectedRequest.StopTime_Test_Production__c = null;
        update closeRejectedRequest;
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Release: Test Production';
        closeRejectedRequest.StopTime_Test_Production__c = System.now();
        update closeRejectedRequest;
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Close: Deployed';
        closeRejectedRequest.StopTime_Deployed__c = null;
        update closeRejectedRequest;
          
        closeRejectedRequest.Status__c = 'Close: Rejected';
        closeRejectedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update closeRejectedRequest; 
        closeRejectedRequest.Status__c = 'Close: Deployed';
        closeRejectedRequest.StopTime_Deployed__c = System.now();
        update closeRejectedRequest;
        
        System.assertEquals(closeRejectedRequest.Status__c, 'Close: Deployed', 'Success');
        Test.stopTest();
      
      }
    
    
    @isTest
    public static void testCloseDeployedRequest(){        
        Test.startTest();        
        Release__c release1 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request1 = [SELECT Id from Request__c where Release__c = :release1.Id];        
        Release__c release = [SELECT Id from Release__c where Name = 'testRel3'];
        Request__c closeDeployedRequest = [SELECT Id from Request__c where Release__c = :release.Id];
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Identify: New Requirement';
        closeDeployedRequest.StopTime_Identify_New_Requirement__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        closeDeployedRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        closeDeployedRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Identify: Submit for Business Review';
        closeDeployedRequest.StopTime_Identify_Submit_for_Business__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Identify: Emergency Request';
        closeDeployedRequest.StopTime_Emergency_Request__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Identify: Deferred';
        closeDeployedRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        closeDeployedRequest.StopTime_Deferred__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Consolidate: Approve to Estimate';
        closeDeployedRequest.StopTime_Approve_to_Estimate__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Consolidate: Level of Effort Complete';
        closeDeployedRequest.StopTime_Level_of_Effort_Complete__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Release: Design';
        closeDeployedRequest.StopTime_Design__c = null;
        update closeDeployedRequest;
        
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Release: Build';
        closeDeployedRequest.StopTime_Build__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Release: Test';
        closeDeployedRequest.StopTime_Test__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Release: SIT';
        closeDeployedRequest.StopTime_SIT__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Release: UAT';
        closeDeployedRequest.StopTime_UAT__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Release: Build Production';
        closeDeployedRequest.StopTime_Build_Production__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Release: Test Production';
        closeDeployedRequest.StopTime_Test_Production__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Release: Test Production';
        closeDeployedRequest.StopTime_Test_Production__c = System.now();
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Close: Rejected';
        closeDeployedRequest.StopTime_Rejected__c = null;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Close: Duplicate';
        closeDeployedRequest.StopTime_Duplicate__c = null;
        closeDeployedRequest.Related_Request__c = request1.Id;
        update closeDeployedRequest;
        
        closeDeployedRequest.Status__c = 'Close: Deployed';
        update closeDeployedRequest; 
        closeDeployedRequest.Status__c = 'Close: Duplicate';
        closeDeployedRequest.StopTime_Duplicate__c = System.now();
        update closeDeployedRequest;
        
        System.assertEquals(closeDeployedRequest.Status__c, 'Close: Duplicate', 'Success');        
        Test.stopTest();
        
    }
    
    @isTest
    public static void testReleaseTestProdRequest(){        
        Test.startTest();        
        Release__c release1 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request1 = [SELECT Id from Request__c where Release__c = :release1.Id];        
        Release__c release = [SELECT Id from Release__c where Name = 'testRel3'];
        Request__c releaseTestProdRequest = [SELECT Id from Request__c where Release__c = :release.Id];
        releaseTestProdRequest.Status__c = 'Release: Test Production';
        update releaseTestProdRequest; 
        releaseTestProdRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseTestProdRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update releaseTestProdRequest;
        
        releaseTestProdRequest.Status__c = 'Release: Build Production';
        update releaseTestProdRequest; 
        releaseTestProdRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseTestProdRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseTestProdRequest;
        
        
        releaseTestProdRequest.Status__c = 'Release: Build Production';
        update releaseTestProdRequest; 
        releaseTestProdRequest.Status__c = 'Release: Test Production';
        releaseTestProdRequest.StopTime_Test_Production__c = System.now();
        update releaseTestProdRequest;
        
        releaseTestProdRequest.Status__c = 'Release: Build Production';
        update releaseTestProdRequest; 
        releaseTestProdRequest.Status__c = 'Close: Deployed';
        releaseTestProdRequest.StopTime_Deployed__c = System.now();
        update releaseTestProdRequest;
        
        System.assertEquals(releaseTestProdRequest.Status__c,'Close: Deployed', 'Success');
        Test.stopTest();
        
    }
     
    
    @isTest
    public static void testReleaseBuildProdRequest(){        
        Test.startTest();        
        Release__c release1 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request1 = [SELECT Id from Request__c where Release__c = :release1.Id];        
        Release__c release = [SELECT Id from Release__c where Name = 'testRel3'];
        Request__c releaseBuildProdRequest = [SELECT Id from Request__c where Release__c = :release.Id];
        releaseBuildProdRequest.Status__c = 'Release: Build Production';
        update releaseBuildProdRequest; 
        releaseBuildProdRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildProdRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update releaseBuildProdRequest;
        
        releaseBuildProdRequest.Status__c = 'Release: Build Production';
        update releaseBuildProdRequest; 
        releaseBuildProdRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildProdRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildProdRequest;
        
        
        releaseBuildProdRequest.Status__c = 'Release: Build Production';
        update releaseBuildProdRequest; 
        releaseBuildProdRequest.Status__c = 'Release: Test Production';
        releaseBuildProdRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildProdRequest;
        
        releaseBuildProdRequest.Status__c = 'Release: Build Production';
        update releaseBuildProdRequest; 
        releaseBuildProdRequest.Status__c = 'Close: Deployed';
        releaseBuildProdRequest.StopTime_Deployed__c = System.now();
        update releaseBuildProdRequest;
        
        System.assertEquals(releaseBuildProdRequest.Status__c, 'Close: Deployed', 'Success');        
        Test.stopTest();
        
    }
    
    @isTest
    public static void testReleaseSITRequest(){        
        Test.startTest();        
        Release__c release1 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request1 = [SELECT Id from Request__c where Release__c = :release1.Id];        
        Release__c release = [SELECT Id from Release__c where Name = 'testRel3'];
        Request__c releaseSitRequest = [SELECT Id from Request__c where Release__c = :release.Id];
        releaseSitRequest.Status__c = 'Release: SIT';
        update releaseSitRequest; 
        releaseSitRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseSitRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update releaseSitRequest;
        
        releaseSitRequest.Status__c = 'Release: SIT';
        update releaseSitRequest; 
        releaseSitRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseSitRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseSitRequest;
        
        
        releaseSitRequest.Status__c = 'Release: SIT';
        update releaseSitRequest; 
        releaseSitRequest.Status__c = 'Release: Test Production';
        releaseSitRequest.StopTime_Test_Production__c = System.now();
        update releaseSitRequest;
        
        releaseSitRequest.Status__c = 'Release: SIT';
        update releaseSitRequest; 
        releaseSitRequest.Status__c = 'Close: Deployed';
        releaseSitRequest.StopTime_Deployed__c = System.now();
        update releaseSitRequest;
        
        System.assertEquals(releaseSitRequest.Status__c, 'Close: Deployed', 'Success');
        Test.stopTest();
        
    }
    
      
    @isTest
    public static void testReleaseUATRequest(){        
        Test.startTest();        
        Release__c release1 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request1 = [SELECT Id from Request__c where Release__c = :release1.Id];        
        Release__c release = [SELECT Id from Release__c where Name = 'testRel3'];
        Request__c releaseUatRequest = [SELECT Id from Request__c where Release__c = :release.Id];
        releaseUatRequest.Status__c = 'Release: UAT';
        update releaseUatRequest; 
        releaseUatRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseUatRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update releaseUatRequest;
        
        releaseUatRequest.Status__c = 'Release: UAT';
        update releaseUatRequest; 
        releaseUatRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseUatRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseUatRequest;
        
        
        releaseUatRequest.Status__c = 'Release: UAT';
        update releaseUatRequest; 
        releaseUatRequest.Status__c = 'Release: Test Production';
        releaseUatRequest.StopTime_Test_Production__c = System.now();
        update releaseUatRequest;
        
        releaseUatRequest.Status__c = 'Release: UAT';
        update releaseUatRequest; 
        releaseUatRequest.Status__c = 'Close: Deployed';
        releaseUatRequest.StopTime_Deployed__c = System.now();
        update releaseUatRequest;
        
        System.assertEquals(releaseUatRequest.Status__c, 'Close: Deployed', 'Success');
        Test.stopTest();
        
    }
    
    
     @isTest
    public static void testReleaseTestRequest(){        
        Test.startTest();        
        Release__c release1 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request1 = [SELECT Id from Request__c where Release__c = :release1.Id];        
        Release__c release = [SELECT Id from Release__c where Name = 'testRel3'];
        Request__c releaseTestRequest = [SELECT Id from Request__c where Release__c = :release.Id];
        releaseTestRequest.Status__c = 'Release: Test';
        update releaseTestRequest; 
        releaseTestRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseTestRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update releaseTestRequest;
        
        releaseTestRequest.Status__c = 'Release: Test';
        update releaseTestRequest; 
        releaseTestRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseTestRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseTestRequest;
        
        
        releaseTestRequest.Status__c = 'Release: Test';
        update releaseTestRequest; 
        releaseTestRequest.Status__c = 'Release: Test Production';
        releaseTestRequest.StopTime_Test_Production__c = System.now();
        update releaseTestRequest;
        
        releaseTestRequest.Status__c = 'Release: Test';
        update releaseTestRequest; 
        releaseTestRequest.Status__c = 'Close: Deployed';
        releaseTestRequest.StopTime_Deployed__c = System.now();
        update releaseTestRequest;
        
        System.assertEquals(releaseTestRequest.Status__c, 'Close: Deployed', 'Success');
        Test.stopTest();
        
    }
    
    @isTest
    public static void testReleaseBuildRequest(){        
        Test.startTest();        
        Release__c release1 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request1 = [SELECT Id from Request__c where Release__c = :release1.Id];        
        Release__c release = [SELECT Id from Release__c where Name = 'testRel3'];
        Request__c releaseBuildRequest = [SELECT Id from Request__c where Release__c = :release.Id];
        releaseBuildRequest.Status__c = 'Release: Build';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update releaseBuildRequest;
        
        releaseBuildRequest.Status__c = 'Release: Build';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
        
        
        releaseBuildRequest.Status__c = 'Release: Build';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Release: Test Production';
        releaseBuildRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildRequest;
        
        releaseBuildRequest.Status__c = 'Release: Build';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Close: Deployed';
        releaseBuildRequest.StopTime_Deployed__c = System.now();
        update releaseBuildRequest;
        System.assertEquals(releaseBuildRequest.Status__c, 'Close: Deployed', 'Success');  
        
        //-------------------------------------------------------------------------------
        releaseBuildRequest.Status__c = 'Identify: Submit for Business Review';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
        System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client');  
       
        releaseBuildRequest.Status__c = 'Identify: Submit for Business Review';
		releaseBuildRequest.StartTime_Approve_to_Estimate__c = (System.now()).addMinutes(-30);
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Consolidate: Approve to Estimate';
        releaseBuildRequest.StopTime_Approve_to_Estimate__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Consolidate: Approve to Estimate'); 
		
		releaseBuildRequest.Status__c = 'Identify: Emergency Request';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client'); 
		
		releaseBuildRequest.Status__c = 'Identify: Deferred';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client'); 
		
		releaseBuildRequest.Status__c = 'Identify: Submit for Business Review';
		releaseBuildRequest.StartTime_Approve_to_Estimate__c = (System.now()).addMinutes(-30);		
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Consolidate: Approve to Estimate';
        releaseBuildRequest.StopTime_Approve_to_Estimate__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Consolidate: Approve to Estimate'); 
		
		releaseBuildRequest.Status__c = 'Consolidate: Approve to Estimate';//**************************NOT COVERED YET***************************//
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client'); 
		
		releaseBuildRequest.Status__c = 'Consolidate: Approve to Estimate';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;		
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client'); 
		
		releaseBuildRequest.Status__c = 'Consolidate: Approve to Estimate';
		releaseBuildRequest.StartTime_Test_Production__c = (System.now()).addMinutes(-30);
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Release: Test Production';
        releaseBuildRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Release: Test Production'); 
		
		releaseBuildRequest.Status__c = 'Consolidate: Level of Effort Complete';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;	
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client'); 
		
		releaseBuildRequest.Status__c = 'Consolidate: Level of Effort Complete';
		releaseBuildRequest.StartTime_Test_Production__c = (System.now()).addMinutes(-30);
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Release: Test Production';
        releaseBuildRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Release: Test Production'); 
		
		releaseBuildRequest.Status__c = 'Consolidate: Level of Effort Complete';
		releaseBuildRequest.StartTime_Rejected__c = (System.now()).addMinutes(-30);
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Close: Rejected';
        releaseBuildRequest.StopTime_Rejected__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Close: Rejected'); 
		
		releaseBuildRequest.Status__c = 'Approve: Approved to Deploy';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client'); 
		
		releaseBuildRequest.Status__c = 'Approve: Approved to Deploy';
		releaseBuildRequest.StartTime_Test_Production__c = (System.now()).addMinutes(-30);
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Release: Test Production';
        releaseBuildRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Release: Test Production'); 
		
		releaseBuildRequest.Status__c = 'Approve: Approved to Deploy';
		releaseBuildRequest.StartTime_Deployed__c = (System.now()).addMinutes(-30);
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Close: Deployed';
        releaseBuildRequest.StopTime_Deployed__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Close: Deployed'); 
		
		releaseBuildRequest.Status__c = 'Approve: Approved to Deploy';
		releaseBuildRequest.StartTime_Rejected__c = (System.now()).addMinutes(-30);
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Close: Rejected';
        releaseBuildRequest.StopTime_Rejected__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Close: Rejected'); 
		
		releaseBuildRequest.Status__c = 'Release: Design';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client'); 
		
		releaseBuildRequest.Status__c = 'Release: Design';
		releaseBuildRequest.StartTime_Test_Production__c = (System.now()).addMinutes(-30);
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Release: Test Production';
        releaseBuildRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Release: Test Production'); 
		
		releaseBuildRequest.Status__c = 'Release: Build';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client'); 
		
		releaseBuildRequest.Status__c = 'Release: Build';
		releaseBuildRequest.StartTime_Test_Production__c = (System.now()).addMinutes(-30);
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Release: Test Production';
        releaseBuildRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Release: Test Production');
		
		releaseBuildRequest.Status__c = 'Release: Test';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client');
		
		releaseBuildRequest.Status__c = 'Release: Test';
		releaseBuildRequest.StartTime_Test_Production__c = (System.now()).addMinutes(-30);
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Release: Test Production';
        releaseBuildRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Release: Test Production');
		
		releaseBuildRequest.Status__c = 'Release: SIT';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client');
		
		releaseBuildRequest.Status__c = 'Release: SIT';
		releaseBuildRequest.StartTime_Test_Production__c = (System.now()).addMinutes(-30);
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Release: Test Production';
        releaseBuildRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Release: Test Production');
		
		releaseBuildRequest.Status__c = 'Release: UAT';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client');
		
		releaseBuildRequest.Status__c = 'Release: UAT';
		releaseBuildRequest.StartTime_Test_Production__c = (System.now()).addMinutes(-30);
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Release: Test Production';
        releaseBuildRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Release: Test Production');
		
		releaseBuildRequest.Status__c = 'Release: UAT';
		releaseBuildRequest.StartTime_Test_Production__c = (System.now()).addMinutes(-30);
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Release: Test Production';
        releaseBuildRequest.StopTime_Test_Production__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Release: Test Production');
		
		releaseBuildRequest.Status__c = 'Release: Build Production';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client');
		
			
		
        //------------------------------------------------------------------------------------
		
		
        Test.stopTest();
        
    }
	
	@isTest
    public static void testReleaseTestRequest1(){        
        Test.startTest();        
        Release__c release1 = [SELECT Id from Release__c where Name = 'testRel1'];
        Request__c request1 = [SELECT Id from Request__c where Release__c = :release1.Id];        
        Release__c release = [SELECT Id from Release__c where Name = 'testRel3'];
		Release__c parentOfRelatedRequest = [SELECT Id from Release__c where Name = 'testRel5'];
		
        Request__c releaseBuildRequest = [SELECT Id from Request__c where Release__c = :release.Id];
		Request__c relatedRequest = [SELECT Id from Request__c where Release__c = :parentOfRelatedRequest.Id];
        releaseBuildRequest.Status__c = 'Release: Test';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = null;
        update releaseBuildRequest;
		
		//------------------------------------------------------------------------------------
		
		releaseBuildRequest.Status__c = 'Release: Test Production';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: New Requirement';
        releaseBuildRequest.StopTime_Identify_New_Requirement__c = null;
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: New Requirement');
		
		releaseBuildRequest.Status__c = 'Release: Test Production';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client');
		
		releaseBuildRequest.Status__c = 'Release: Test Production';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: Submit for Business Review';
        releaseBuildRequest.StopTime_Identify_Submit_for_Business__c = null;
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: Submit for Business Review');
		
		releaseBuildRequest.Status__c = 'Release: Test Production';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: Emergency Request';
        releaseBuildRequest.StopTime_Emergency_Request__c = null;
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: Emergency Request');
		
		releaseBuildRequest.Status__c = 'Release: Test Production';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Close: Deployed';
        releaseBuildRequest.StopTime_Deployed__c = null;
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Close: Deployed');
		
		releaseBuildRequest.Status__c = 'Release: Test Production';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Close: Rejected';
        releaseBuildRequest.StopTime_Rejected__c = null;
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Close: Rejected');
		
		releaseBuildRequest.Status__c = 'Release: Test Production';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Close: Duplicate';
        releaseBuildRequest.StopTime_Duplicate__c = null;
		releaseBuildRequest.Related_Request__c = relatedRequest.Id;
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Close: Duplicate');
		
		releaseBuildRequest.Status__c = 'Close: Deployed';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client');
		
		releaseBuildRequest.Status__c = 'Close: Rejected';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client');
		
		releaseBuildRequest.Status__c = 'Close: Duplicate';
		releaseBuildRequest.TimeSpentOn_Identify_OnHoldWaitingonClie__c = 30;
		releaseBuildRequest.Related_Request__c = relatedRequest.Id;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Identify: On-Hold Waiting on Client';
        releaseBuildRequest.StopTime_Identify_OnHoldWaitingonClient__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Identify: On-Hold Waiting on Client');
		
		releaseBuildRequest.Status__c = 'Close: Duplicate';
		releaseBuildRequest.StartTime_Rejected__c = (System.now()).addMinutes(-30);
		releaseBuildRequest.Related_Request__c = relatedRequest.Id;
		releaseBuildRequest.Closed_Deferred__c = 'Deferred: Waiting Architecture Availabiity';
        update releaseBuildRequest; 
        releaseBuildRequest.Status__c = 'Close: Rejected';
        releaseBuildRequest.StopTime_Rejected__c = System.now();
        update releaseBuildRequest;
		System.assertEquals(releaseBuildRequest.Status__c, 'Close: Rejected');
		
		
		//------------------------------------------------------------------------------------
		
		Test.stopTest();
	}
}