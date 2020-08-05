@isTest
private class opportnityRedirect_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Opportunity opportunity_Obj = new Opportunity(IsPrivate = false, Name = 'Name324', StageName = 'Scoping', CloseDate = Date.today(), CreatedDate = DateTime.now(), LastModifiedDate = DateTime.now(), Budget_Confirmed__c = false, Discovery_Completed__c = false, ROI_Analysis_Completed__c = false, Implementation_Complete__c = false, New__c = false, Procurement_Complete__c = false, Renewal__c = false, Security_Complete__c = false, Upsell__c = false, isFromOpportunity__c = false, isNew__c = false, isStageChanged__c = false, isRenewal__c = false, isUpsell__c = false);
    Insert opportunity_Obj; 
    test.stopTest();
  }
  static testMethod void test_redirect_UseCase1(){
    List<Opportunity> opportunity_Obj  =  [SELECT IsPrivate,Name,StageName,CloseDate,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,Budget_Confirmed__c,Discovery_Completed__c,ROI_Analysis_Completed__c,Implementation_Complete__c,New__c,Procurement_Complete__c,Renewal__c,Security_Complete__c,Upsell__c,isFromOpportunity__c,isNew__c,isStageChanged__c,isRenewal__c,isUpsell__c from Opportunity];
    System.assertEquals(true,opportunity_Obj.size()>0);
    PageReference pageRef = Page.Opportunityrenewalpage;
    pageRef.getParameters().put('retURL','test');
    pageRef.getParameters().put('RecordType','test');
    pageRef.getParameters().put('cancelURL','test');
    pageRef.getParameters().put('ent','test');
    pageRef.getParameters().put('_CONFIRMATIONTOKEN','test');
    pageRef.getParameters().put('save_new_url','test');
    pageRef.getParameters().put('def_account_id','test');
    pageRef.getParameters().put('def_contact_id','test');
    Test.setCurrentPage(pageRef);
    opportnityRedirect obj01 = new opportnityRedirect(new ApexPages.StandardController(opportunity_Obj[0]));
    obj01.retURL = 'test data';
    obj01.saveNewURL = 'test data';
    obj01.rType = 'test data';
    obj01.cancelURL = 'test data';
    obj01.ent = 'test data';
    obj01.confirmationToken = 'test data';
    obj01.accountID = 'test data';
    obj01.contactID = 'test data';
    obj01.redirect();
  }
}