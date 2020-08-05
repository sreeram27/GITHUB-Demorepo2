@isTest
public class Test_Renewal_Page {
    @testSetup
    static void setupTestData(){
        Opportunity oppty = new Opportunity(Name = 'Test1', StageName = 'Proposal',CreatedDate = DateTime.now(),CloseDate = Date.today());
        insert oppty;
        
        Opportunity opportunity_Obj = new Opportunity(IsPrivate = false, Name = 'Name322', StageName = 'Scoping', CloseDate = Date.today(), CreatedDate = DateTime.now(),
                                                      LastModifiedDate = DateTime.now(),Opportunity__c=oppty.id, Budget_Confirmed__c = false, Discovery_Completed__c = false, 
                                                      ROI_Analysis_Completed__c = false, Implementation_Complete__c = false, New__c = false, Procurement_Complete__c = false,
                                                      Renewal__c = false, Security_Complete__c = false, Upsell__c = false, isFromOpportunity__c = false, isNew__c = false, 
                                                      isStageChanged__c = false, isRenewal__c = false, isUpsell__c = false);
        Insert opportunity_Obj; 
        
        //pricebook creation
        Pricebook2 pbk1 = new Pricebook2();
        pbk1.Name='Test Pricebook Entry 1';
        pbk1.Description='Test Pricebook Entry 1';
        pbk1.isActive=true;
        insert pbk1;
        
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 limit 1];
        
        //creation of product
        Product2 prd1 = new Product2();
        prd1.Name='Test Product Entry 1';
        prd1.Description='Test Product Entry 1';
        prd1.productCode = 'ABC';
        prd1.isActive = true;
        insert prd1;
        
        //creating pricebookentry for product
        PricebookEntry pbe1 = new PricebookEntry();
        pbe1.Product2ID=prd1.id;
        pbe1.Pricebook2ID=standardPb.id;
        pbe1.UnitPrice=50;
        pbe1.isActive=true;
       // insert pbe1;
        
       
        /*
         //creation of opportunity line item 
        OpportunityLineItem lineItem1 = new OpportunityLineItem ();
        lineItem1.OpportunityID = opportunity_Obj.id;
        lineItem1.PriceBookEntryID = pbe1.id; 
        lineItem1.quantity = 4;
        lineItem1.totalprice = 200;
        insert lineItem1;*/
    }
    static testMethod void test_getDeatils_UseCase1(){
        List<Opportunity> opportunity_Obj  =  [SELECT IsPrivate,Name,StageName,CloseDate,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,Budget_Confirmed__c,Discovery_Completed__c,
                                               ROI_Analysis_Completed__c,Implementation_Complete__c,New__c,Procurement_Complete__c,Renewal__c,Security_Complete__c,Upsell__c,
                                               isFromOpportunity__c,Opportunity__c,isNew__c,isStageChanged__c,isRenewal__c,isUpsell__c from Opportunity where Name='Name322'];
        System.assertEquals(true,opportunity_Obj.size()>0);
        Renewal_Page obj01 = new Renewal_Page(new ApexPages.StandardController(opportunity_Obj[0]));
        obj01.opp = opportunity_Obj[0];
        system.debug('opp::'+obj01.opp.Opportunity__c);
        obj01.getDetails();
        obj01.currentRecordId = 'test data';
        obj01.opps = opportunity_Obj;
        
    }
}