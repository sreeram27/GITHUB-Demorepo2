/****************************************************************************************************
* Class Name         : Util02_TestData
* LastModified By    : Prashanth
* LastModified Date  : 21 June 2019
* Description        : This is the class used to various test classes to create data
***************************************************************************************************/
public class Util02_TestData {
    public static Lead testLead;
    public static Opportunity testOpp;
    public static Account testAccount;
    public static List<Account> testAccList = new List<Account>();
    public static List<Task> testTaskList = new List<Task>();
    public static List<Lead> testLeadList = new List<Lead>();
    
    
    
    public static Boolean runContactsUpdate = false;
    
      
    public static User createUser(){
        Profile txtProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1]; 
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User tstUser = new User(Alias = 'standt1', Email='standarduser@testorg1.com', UserRoleId = portalRole.Id, 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = txtProfile.Id,
                                TimeZoneSidKey='America/Los_Angeles', UserName='standardUSER989999@testOrg.com'+DateTime.now().millisecond());
        insert tstUser;
        return tstUser;
    }
    
     public static vlocity_ins__Application__c createApplicationRec(Id accountId, Id OpportunityId) {
        System.debug(':::accountId::::'+accountId);
        vlocity_ins__Application__c testApplication = new vlocity_ins__Application__c(name='Test Application', vlocity_ins__AccountId__c = accountId, vlocity_ins__OpportunityId__c = OpportunityId);
        return testApplication;
    } 
     
     public static Account createGroupAccount(){
        Id grpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group').getRecordTypeId();
        Account testGrpAccount = new Account(recordtypeId=grpRecordTypeId,Name='Test Account',
                                             BillingCity='Houston',BillingStreet='2 Avenue Road',BillingState='NY',BillingPostalCode='56839');
        return testGrpAccount;
    }
    public static Account createLGProspectAccount(){
        Id grpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();
        Account testGrpAccount = new Account(recordtypeId=grpRecordTypeId,Name='Test Account',
                                             BillingCity='Houston',BillingStreet='2 Avenue Road',BillingState='CA',BillingPostalCode='56839');
        return testGrpAccount;
    }
    
     
     /*public static Order createOrder(Account acc) {
        Order testorder = new Order();
         Id orderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('LG_New_Business').getRecordTypeId();
     testorder.RecordTypeId = orderRecordTypeId;
     testorder.Implementation_Case_Name__c = 'Order tst';
         testorder.Implementation_Status__c = 'Initiated';
         testorder.AccountId = acc.Id;
         testorder.Account_Manager__c = acc.OwnerId;
         testorder.Implementation_Effective_Date__c = date.today();
         testorder.Discovery_Call_Desired__c = 'No';
         testorder.Are_Broker_Commissions_Impacted__c = 'No Broker Commission Offered';
         testorder.Does_Anthem_Produce_SBC_s__c = 'No';
         testorder.Want_the_SBC_created_by_the_SBC_team__c ='No';
         testorder.Does_Anthem_Produce_Benefit_Booklets__c ='No';
         testorder.Does_This_Require_A_New_Benefit_Booklet__c = 'No';
         testorder.Did_You_Attach_WGS_Rate_Sheet_if_WGS__c = 'No';
         testorder.Did_You_Attach_The_ASF__c = 'No';
         testorder.Did_You_attach_The_Benefit_Booklet_Form__c ='No';
         testorder.EffectiveDate = date.today();
         testorder.Status = 'Draft';


        return testorder;
    }*/
  
    
    
    
    }