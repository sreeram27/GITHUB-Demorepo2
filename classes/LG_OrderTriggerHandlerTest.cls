/**
@author Sharath KN (Vikings)
@createDate 04/09/2019
@description This is test class for handler(LG_OrderTriggerHandler) of OrderAfterUpdate.
@modified - 04/02/2020 - Ravideep(Vikings) - PRDCRM - 49125 - Test class changes for new functionality in LG_OrderActions
*/
@isTest
public class LG_OrderTriggerHandlerTest{
    
/*******************************************************************************************************
* @description Sets up test data
* @param null 
* @return Doesn't return anything
*/  
    @testSetup
    public static void testSetUpMethod(){
        
        Recordtype LocalImplTracking = [SELECT id from RecordType where DeveloperName = 'Local_NASCO_and_WGS' LIMIT 1];
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Local Implementations' limit 1];
        Account testAcc = new Account();
        testAcc = TestDataFactory.createLGAccount(staticVariableClass.AccountName,staticVariableClass.AccountName,true,staticVariableClass.AccountName,staticVariableClass.AccountName,staticVariableClass.AccountName,staticVariableClass.AccountName,staticVariableClass.AccountName);
        insert testAcc;
        
        Group__c testGroup = new Group__c();
        testGroup = ANA_UTIL01_TestMethods.createGroup(testAcc.id, false);
        insert testGroup;
        
        User testUser = new User();
        testUser = ANA_UTIL01_TestMethods.runAsUser(testProfile.id);
        insert testUser;
        
        Opportunity testOpportunity = new Opportunity();
        testOpportunity = ANA_UTIL01_TestMethods.createOpportunity(false, testAcc.id);
        insert testOpportunity;
        
        Quote testQuote= new Quote();
        testQuote = ANA_UTIL01_TestMethods.createQuote(false, testOpportunity.id);
        testQuote.GroupNumber__c=testGroup.id;
        insert testQuote;
        
        Order thisOrder = new Order();
        thisOrder = ANA_UTIL01_TestMethods.CreateOrder(testGroup.id, testAcc.id, testUser.id, testQuote.id);
        thisOrder.Impacted_Products__c = 'testIP';
        thisOrder.Implementation_Case_Name__c = 'testIMPL';
        insert thisOrder;
        
        Implementation_Tracking__c IT1 = new Implementation_Tracking__c();
        IT1 = ANA_UTIL01_TestMethods.CreateImplTracking(thisOrder.id, LocalImplTracking.id, testUser.id);
        insert IT1;
        
        Issue_Control__c ic1 = new Issue_Control__c();
        ic1 = ANA_UTIL01_TestMethods.CreateCaseInstall('No',IT1.Id,'testIP');
        insert ic1;
        
        Underwriting__c uw = new Underwriting__c();
        uw = TestDataFactory.createUnderwriting(IT1.id);
        uw.Stage__c = staticVariableClass.APPROVED;
        insert uw;
    }
    
/*******************************************************************************************************
* @description test method for LG_OrderTriggerHandler unit tests
* @param null 
* @return Doesn't return anything
*/
    @isTest
    public static void testImpactedProducts()
    {
        List<Order> implCaseList = new List<Order>([select id,QuoteId from Order where Implementation_Case_Name__c='testIMPL']);
        test.startTest();
        if(implCaseList.size()>0){
            implCaseList[0].Impacted_Products__c = 'updatedIP';
            update implCaseList[0];
        }
        List<Issue_Control__c> icList = new List<Issue_Control__c>([SELECT id,Impacted_Products__c FROM Issue_Control__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__r.id =: implCaseList[0].id]);
        system.assertEquals('updatedIP', icList[0].Impacted_Products__c);
        test.stopTest();
    }
    
    /*******************************************************************************************************
* @description test method for LG_OrderTriggerHandler and LG_OrderActions 
* @param null 
* @return Doesn't return anything
*/
@isTest
    public static void testShowErrorICRUpdate(){
        List<Order> implCaseList = new List<Order>([select id from Order where Implementation_Case_Name__c='testIMPL']);
        test.startTest();
        
        if(implCaseList.size()>0){
            implCaseList[0].Implementation_Status__c = staticVariableClass.WITHDRAWN;
            try{
                update implCaseList[0];
            }
            catch(Exception ex){
                System.Assert(ex.getMessage().contains(staticVariableClass.UNDERWRITING_ERROR));
            }
        }
        
        test.stopTest();
    }
    
}