/*******************************************************************************************
@class Name  : LGA_IntErrorLog_Trg_Handler_Test
@created By  : IDC Offshore
@createdDate : 11/19/2019
@description : This test class is for LGA_IntErrorLog_Trg_Handler
********************************************************************************************/
@isTest(SeeAllData=false)
public with sharing class LGA_IntErrorLog_Trg_Handler_Test {
    
/*******************************************************************************************
@ method Name  : method1
@ description : This is a test method used for LGA_IntErrorLog_Trg_Handler
********************************************************************************************/
    @isTest(SeeAllData=false)
    public static void method1(){
        try {
            LGA_IntErrorLog_Trg_Handler intErrorLog = new LGA_IntErrorLog_Trg_Handler();
            List<Integration_Error_Log__c> intErrorList = New List<Integration_Error_Log__c>();
            List<Integration_Error_Log__c> intError = New List<Integration_Error_Log__c>();
            //User Creation
            User testUser = Util02_TestData.createUser();
            System.runAs(testUser){
                Test.startTest();
                Integration_Event_Log__c inEvent = new Integration_Event_Log__c();
                inEvent.Status__c = 'Open';
                inEvent.System_Name__c = 'Test';
                database.insert(inEvent);
                
                Integration_Error_Log__c inError1 = new Integration_Error_Log__c();
                inError1.Status__c = 'Open';
                inError1.Category__c = 'Technical';
                inError1.Assigned_to__c = testUser.Id;
                inError1.Integration_Event_Log__c = inEvent.Id;
                database.insert(inError1);
                intErrorList.add(inError1);
                
                Integration_Error_Log__c inError2 = new Integration_Error_Log__c();
                inError2.Status__c = 'Open';
                inError2.Category__c = 'Functional';
                inError2.Assigned_to__c = testUser.Id;
                inError2.Integration_Event_Log__c = inEvent.Id;
                database.insert(inError2);
                intError.add(inError2);
                
                inError1.Status__c = 'Closed';
                database.update(inError1);
                inError2.Status__c = 'Closed';
                database.update(inError2);
                Test.stopTest();
                system.assertNotEquals(NULL,intError,'Success');
                intErrorLog.calculateAvgResTime(intErrorList);
                intErrorLog.calculateAvgResTime(intError);
                
            }
        } catch (Exception ex) {
            system.debug('****The following exception has occurred: ' + ex.getMessage());
        }        
    }
    
/*******************************************************************************************
@ method Name  : method2
@ description : This is a test method used for LGA_IntErrorLog_Trg_Handler
********************************************************************************************/
    @isTest(SeeAllData=false)
    public static void method2(){
        try {
            LGA_IntErrorLog_Trg_Handler intErrorLog = new LGA_IntErrorLog_Trg_Handler();
            List<Integration_Error_Log__c> intErrorList = New List<Integration_Error_Log__c>();
            List<Integration_Error_Log__c> intError = New List<Integration_Error_Log__c>();
            //User Creation
            User testUser = Util02_TestData.createUser();
            System.runAs(testUser){
                Test.startTest();
                Integration_Event_Log__c inEvent = new Integration_Event_Log__c();
                inEvent.Status__c = 'Open';
                inEvent.System_Name__c = 'Test';
                database.insert(inEvent);
                
                Integration_Error_Log__c inError1 = new Integration_Error_Log__c();
                inError1.Status__c = 'Open';
                inError1.Category__c = 'Technical';
                inError1.Assigned_to__c = testUser.Id;
                inError1.Integration_Event_Log__c = inEvent.Id;
                database.insert(inError1);
                intErrorList.add(inError1);
                
                Integration_Error_Log__c inError2 = new Integration_Error_Log__c();
                inError2.Status__c = 'Open';
                inError2.Category__c = 'Functional';
                inError2.Assigned_to__c = testUser.Id;
                inError2.Integration_Event_Log__c = inEvent.Id;
                database.insert(inError2);
                intError.add(inError2);
                Test.stopTest();
                system.assertNotEquals(NULL,intError,'Success');
                intErrorLog.calculateAvgResTime(intErrorList);
                intErrorLog.calculateAvgResTime(intError);
                
            }
        } catch (Exception ex) {
            system.debug('****The following exception has occurred: ' + ex.getMessage());
        }        
    }

}