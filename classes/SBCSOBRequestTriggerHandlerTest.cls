/**************************************************************************************
@description          : Test Class for SBCSOBActions
@Author               : X-men Offshore(Smita)
US                    : PRDCRM-42116,PRDCRM-45153,PRDCRM-43922,PRDCRM-46329
*************************************************************************************/
@isTest
public class SBCSOBRequestTriggerHandlerTest {
    
    @testSetup 
    static void testData() {
        
        Id qliId;
        User testUser;
        Integer recordCount=1;
        
        //Insert User
        List<User> userList = new List<User>();
        String userprofile = 'Local Implementations';
        String federationid = '';
        userList = TestDataFactory.createUserData(recordCount,userprofile,federationid);
        insert userList;
        
        //Insert account
        List<Account> accounts = new List<Account>();
        String accName='newaccount';
        String street='CA street';
        String city='CA';
        String state='CA State';
        String zip='12345';
        String country='US';
        String stateCode='CAA';
        accounts =TestDataFactory.createAccountSICList(recordCount,accName,street,city,state,zip,country,stateCode);
        insert accounts; 
        
        //Insert Opportunity 
        List<Opportunity> opportunities = new List<Opportunity>();
        String optyName = 'test Opty';
        String stageName='Prospecting';
        Date closeDate=System.Today();
        opportunities=TestDataFactory.createOpportunityList(recordCount,optyName,accounts[0]);
        insert opportunities;
        
        //Insert Product
        String prodName='Laptop X200';
        List<Product2> prodlist= new List<Product2>();
        prodlist=TestDataFactory.createProduct(prodName,recordCount);
        insert prodlist;
        prodlist[0].LOB__c='Medical';
        prodlist[0].Contract_Code__c='5ABB';
        update prodlist;
        
        //Insert PricebookEntry
        List<PricebookEntry> pricebookentrylist= new List<PricebookEntry>();
        pricebookentrylist=TestDataFactory.PricebookEntry(recordCount,prodlist[0]);
        insert pricebookentrylist;
        
        //Insert Group
        Group__c groupRecord = new Group__c();
        boolean doinsert = false;
        groupRecord = TestDataFactory.createGroup(accounts[0].id,doinsert);
        groupRecord.ClaimSystem__c ='';
        groupRecord.IsActive__c = true;
        insert groupRecord;
        
        //Insert Quote
        List<Quote> quotelist= new List<Quote>();
        String quoteName='Test Quote';
        quotelist=TestDataFactory.Quote(quoteName,recordCount,opportunities[0]);
        quotelist[0].GroupNumber__c = groupRecord.id;
        insert quotelist;        
        
        //Insert Implementation case
        List<Order> orderlist = new List<Order>();
        orderlist = TestDataFactory.createOrder(recordCount,groupRecord.id,accounts[0].id,userlist[0].id,quotelist[0].id);
        orderlist[0].Opportunity=opportunities[0];
        insert orderlist;
        
        
        //Insert QuoteLineItem
        List<QuoteLineItem> quotelineitemlist= new List<QuoteLineItem>();
        String qliName='Test QLI';
        quotelineitemlist=TestDataFactory.QuoteLineItem(qliName,recordCount,quotelist[0],prodlist[0],pricebookentrylist[0]);
        quotelineitemlist[0].HPCC_Code__c='HP54';
        quotelineitemlist[0].Plan_Type__c='Custom';
        quotelineitemlist[0].ProductStage__c='In Progress';
        insert quotelineitemlist;
        
        //Insert SBCSOB
        List<SBC_SOB_Request__c> sbcRecord=new List<SBC_SOB_Request__c>();
        for(Integer i=0;i<200;i++){
            sbcRecord.add(new SBC_SOB_Request__c(Opportunity__c=opportunities[0].id,Custom_SBC_Requested__c='No'));
        }
        insert sbcRecord;
    }
    
    @isTest
    static void testinsertOrUpdateQLI(){
        
        Test.startTest();
        
        Set<ID> sbcId=new Set<ID>();
        String comment='test';
        List<QuoteLineItem> quotelineitemlist=[SELECT Id,HPCC_Code__c,Contract_Codes__c,
                                               Plan_Type__c,Implementation_Status__c,OpportunityId__c,Funding__c 
                                               from QuoteLineItem 
                                               where quote.Name='Test Quote' 
                                               Limit 1];
        
        
        List<SBC_SOB_Request__c> sbcRecord1=[select id,hpcc_code__c,Funding_Type__c,
                                             Contract_Code__c,Custom_Contract_Code__c,Plan_Type__c,Opportunity__c ,Opportunity_ICR_ID_s__c
                                             from SBC_SOB_Request__c where Opportunity__r.Name='test Opty' 
                                             Limit 200];
        
        List<order> orderList1=[select id,ordernumber from order Limit 1];
        
        for(SBC_SOB_Request__c sbc:sbcRecord1){
            sbcId.add(sbc.id);
        }
        
        sbcRecord1=[select id,hpcc_code__c,Funding_Type__c,Opportunity_ICR_ID_s__c,Custom_Contract_Code__c,Contract_Code__c,Plan_Type__c,Opportunity__c 
                    from SBC_SOB_Request__c Limit 500];
        System.debug('Helloo'+orderList1[0].ordernumber);
        System.debug('Helloooooo'+sbcRecord1[0].Opportunity_ICR_ID_s__c);
        System.assertEquals(sbcRecord1[0].hpcc_code__c,quotelineitemlist[0].hpcc_code__c, 'HPCC Code is Equal');
        System.assertEquals(sbcRecord1[0].Plan_Type__c,quotelineitemlist[0].Plan_Type__c, 'Plan Type is Equal');
        System.assertEquals(sbcRecord1[0].Custom_Contract_Code__c,quotelineitemlist[0].Contract_Codes__c, 'Custom Contract Code is Equal');
        System.assertEquals(sbcRecord1[0].Opportunity_ICR_ID_s__c,orderList1[0].ordernumber, 'Implementation ID is Equal');
        
        System.assertEquals(sbcRecord1[1].hpcc_code__c,quotelineitemlist[0].hpcc_code__c, 'HPCC Code is Equal');
        System.assertEquals(sbcRecord1[1].Plan_Type__c,quotelineitemlist[0].Plan_Type__c, 'Plan Type is Equal');
        
        SBCSOBActions.sbcCheck=false;
        for(Integer i=0;i<200;i++){
            sbcRecord1[i].comments__c=comment;
        }
        
        update sbcRecord1;
        System.assertEquals(sbcRecord1[0].comments__c,comment, 'Comment is updated to test');
        Test.stopTest();
    }
}