/*
@Author : Arun Siddappa
@name : CIP_RestAPI_Session_Handler_Test 
@CreateDate :07-20-2017
@Description : This class is to test CIP_RestAPI_Session_Handler 
*/

@isTest
public class CIP_RestAPI_Session_Handler_Test {
    public static testMethod void testOauthLogin()
    {    
        Test.setMock(HttpCalloutMock.class, new CIP_RestAPI_HttpCallout_MockImpl());   
        CIPIntegration__c cipInt = CIP_Util_Test_Methods.createCIPIntegration();
        insert cipInt;
        Test.startTest(); 
        CIP_RestAPI_Session_Handler sessionHandler = new CIP_RestAPI_Session_Handler();
        CIP_RestAPI_Session_Handler.SessionObject sessObj = CIP_RestAPI_Session_Handler.restTest(); 
        System.assertEquals(sessObj.id ,'SESSION_ID');
        Test.stopTest();   
    }
        
}