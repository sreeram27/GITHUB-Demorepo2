/**************************************************************************************************************
@class Name  : TestSaaSCreateSessionOutcomeCtrl
@created By  : IDC Offshore_panthors
@createdDate : 11/11/2019
@description : This test class is to cover  SaaSCreateSessionOutcomeCtrl class as apart of PRDCRM-44932
*****************************************************************************************************************/
@isTest
public class TestSaaSCreateSessionOutcomeCtrl {
    @testSetup static void setup() {
        
        Release__c relList = Anthem_TestDataFactory.releaseSaasCreate();
        database.insert(relList);
        
        // Creating Value_Delivery_Session__c test record
        
        List<Value_Delivery_Session__c>vdsList = Anthem_TestDataFactory.valueDeliverySaasCreate(relList.Id);
        database.insert(vdsList);
        
        //Creating Value_Delivery_Session_Outcomes__c test record
        
        List<Value_Delivery_Session_Outcomes__c>vdsoList = Anthem_TestDataFactory.valueDeliverySessionCreate(vdsList[0].Id);
        database.insert(vdsoList);
        
        //Creating Value_Delivery_Key_Participants__c test records
        
        List<Value_Delivery_Key_Participants__c>vdkpList = Anthem_TestDataFactory.valueDeliveryKeyCreate(vdsoList[0].Id);
        database.insert(vdkpList);
        
        // Creating Value_Delivery_User_Config__c test record
        
        List<Value_Delivery_User_Config__c>vducList = Anthem_TestDataFactory.valueDeliveryUserCreate(vdkpList[0].Id);
        database.insert(vducList);
        
        
    }
    
    static testMethod void getAllKeyParticipantTestMethod() 
    {
        Value_Delivery_Session_Outcomes__c objVDSO  = [SELECT Id,Name, Phase__c, Start_Date__c,
                                                       End_Date__c, Session_Outcome__c, Value_Delivery_Session__c
                                                       FROM Value_Delivery_Session_Outcomes__c WHERE Name='Test outcome Data' LIMIT 1];
        
        Value_Delivery_Session_Outcomes__c objVDSO1 = new Value_Delivery_Session_Outcomes__c(Value_Delivery_Session__c = objVDSO.Value_Delivery_Session__c);
        insert objVDSO1;
        
        
        // Calling SaaSCreateSessionOutcomeCtrl methods
        Test.startTest();
        SaaSCreateSessionOutcomeCtrl ctrl = new SaaSCreateSessionOutcomeCtrl(new ApexPages.StandardController(objVDSO1));
        ctrl.saveSessionOutcome();
        System.assertEquals(objVDSO1.Value_Delivery_Session__c, objVDSO.Value_Delivery_Session__c);
        System.assertEquals(null, objVDSO1.Start_Date__c);
        System.assertEquals(null, objVDSO1.End_Date__c);
        Test.stopTest();
    }
    
    static testMethod void getParticipantsTosaveTestMethod() 
    {
        List<Value_Delivery_Key_Participants__c> lstVDP = [SELECT Id, Name, Role__c, Participant_Type__c,Comments__c 
                                                           FROM Value_Delivery_Key_Participants__c LIMIT 2];
        lstVDP[0].Name = '';
        lstVDP[1].Role__c = null;
        update lstVDP;
        
        Value_Delivery_Session_Outcomes__c objVDSO  = [SELECT Id,Name, Phase__c, Start_Date__c,
                                                       End_Date__c, Session_Outcome__c, Value_Delivery_Session__c
                                                       FROM Value_Delivery_Session_Outcomes__c WHERE Name='Test outcome Data' LIMIT 1];
        //Calling SaaSCreateSessionOutcomeCtrl methods
        Test.startTest();
        SaaSCreateSessionOutcomeCtrl ctrl = new SaaSCreateSessionOutcomeCtrl(new ApexPages.StandardController(objVDSO));
        
        ctrl.newParticipantsLst.add(new SaaSCreateSessionOutcomeCtrl.ParticipantsWrapper(lstVDP[0]));
        ctrl.newParticipantsLst.add(new SaaSCreateSessionOutcomeCtrl.ParticipantsWrapper(lstVDP[1]));
        ctrl.saveSessionOutcome();
        System.assertEquals('', ctrl.newParticipantsLst.get(0).obj.Name);
        
        SaaSCreateSessionOutcomeCtrl ctrl1 = new SaaSCreateSessionOutcomeCtrl(new ApexPages.StandardController( new Value_Delivery_Session_Outcomes__c(Name = 'Test', Phase__c = 'Test', Start_Date__c = System.Today(), End_Date__c = System.Today()+10, Session_Outcome__c = null)));
        SaaSCreateSessionOutcomeCtrl.ParticipantsWrapper pw3 = new SaaSCreateSessionOutcomeCtrl.ParticipantsWrapper(new Value_Delivery_Key_Participants__c(Name= 'Test', Role__c = 'TestRole', Participant_Type__c = 'Accenture Team', Comments__c = 'Test Comments'));        
        ctrl1.saveSessionOutcome();
        Test.stopTest();
        
        
    }
    
    static testMethod void validateKeyParticipantTestMethod() 
    {
        List<Value_Delivery_Key_Participants__c> lstVDP = [SELECT Id, Name, Role__c, Participant_Type__c,Comments__c 
                                                           FROM Value_Delivery_Key_Participants__c LIMIT 2];
        lstVDP[0].Role__c = '';
        update lstVDP[0];
        
        Value_Delivery_Session_Outcomes__c objVDSO  = [SELECT Id,Name, Phase__c, Start_Date__c,
                                                       End_Date__c, Session_Outcome__c, Value_Delivery_Session__c
                                                       FROM Value_Delivery_Session_Outcomes__c WHERE Name='Test outcome Data' LIMIT 1];
        //Calling SaaSCreateSessionOutcomeCtrl methods
        Test.startTest();
        SaaSCreateSessionOutcomeCtrl ctrl = new SaaSCreateSessionOutcomeCtrl(new ApexPages.StandardController(objVDSO));
        ctrl.newParticipantsLst.add(new SaaSCreateSessionOutcomeCtrl.ParticipantsWrapper(lstVDP[0]));
        ctrl.saveSessionOutcome();
        System.assertEquals('', ctrl.newParticipantsLst.get(0).obj.Role__c);
        Test.stopTest();        
    }
}