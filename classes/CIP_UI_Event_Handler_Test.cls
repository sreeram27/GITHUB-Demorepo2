/*
@Author : Arun Siddappa
@name : CIP_UI_Event_Handler_Test
@CreateDate :07-22-2017
@Description : This class is a controller test class for VF Page to send data to Old Org 
*/
@isTest
public class CIP_UI_Event_Handler_Test
{
    testMethod static void testGetQuoteDetails()
    {
        Test.setMock(HttpCalloutMock.class, new CIP_RestAPI_HttpCallout_MockImpl());   
        CIPIntegration__c cipInt = CIP_Util_Test_Methods.createCIPIntegration();      
        insert cipInt;
        Account accnt = CIP_Util_Test_Methods.CreateAccount();
        insert accnt;
        Opportunity opty = CIP_Util_Test_Methods.CreateOpportunity(accnt);
        insert opty;
        Group__c grpNbr =  CIP_Util_Test_Methods.CreateGroup(accnt.Id, 'ABC123'); 
        insert grpNbr;        
        Quote quote = CIP_Util_Test_Methods.CreateQuote(accnt, opty,grpNbr.Id);
        insert quote;
        CIP_Util_Test_Methods.createDocument(quote);
        
        CIP_UI_Event_Handler controller;           
        Test.startTest(); 
        Test.setCurrentPageReference(new PageReference('Page.CIP_Create_New_Business'));                   
        ApexPages.StandardController sc = new ApexPages.standardController(quote);
        controller = new CIP_UI_Event_Handler(sc);           
        controller.NavigateToCIP();         
        //    System.assertEquals(httpRequest.getHeader('apikey')+'','ABC');
        Test.stopTest();   
    }
}