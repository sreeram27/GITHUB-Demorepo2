/**************************************************************************************
@description          : Test Class for QuoteLineItemActions
@Author               : X-men Offshore(Smita)
US                    : PRDCRM-45634
*************************************************************************************/
@isTest
public class QuoteLineItemActionsTest {
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
        insert quotelist;
        
        //Insert Implementation case
        List<Order> orderlist = new List<Order>();
        orderlist = TestDataFactory.createOrder(recordCount,groupRecord.id,accounts[0].id,userlist[0].id,quotelist[0].id);
        orderlist[0].Opportunity=opportunities[0];
        insert orderlist;
        
        //Insert QuoteLineItem
        List<QuoteLineItem> quotelineitemlist= new List<QuoteLineItem>();
        
        String qliName='Test QLI';
        quotelineitemlist=TestDataFactory.QuoteLineItem(qliName,20,quotelist[0],prodlist[0],pricebookentrylist[0]);
        
        for(Integer i=0;i<20;i++){
            quotelineitemlist[i].HPCC_Code__c='HP5'+i;
            quotelineitemlist[i].Plan_Type__c='Custom';
            quotelineitemlist[i].ProductStage__c='In Progress';
            quotelineitemlist[i].vlocity_ins__ContractCode__c='Code'+i;
        }
         insert quotelineitemlist;
        
        //Insert SBCSOB
        List<SBC_SOB_Request__c> sbcRecord=new List<SBC_SOB_Request__c>();
        for(Integer i=0;i<10;i++){
            sbcRecord.add(new SBC_SOB_Request__c(Opportunity__c=opportunities[0].id,Custom_SBC_Requested__c='No'));
        }
        insert sbcRecord;
        
    }  

@isTest
    static void testinsertOrUpdateQLI(){
        
        Test.startTest();
        
        Set<ID> sbcId=new Set<ID>();
        String comment='test';
        String hpccCode='';
        String customCode='';
        
        List<Product2> prodList=[SELECT id,Contract_Code__c from Product2 Limit 1];
        prodList[0].Contract_Code__c='5AAAqq';
        update prodList;
        
        List<QuoteLineItem> quotelineitemlist=[SELECT Id,HPCC_Code__c,Contract_Codes__c,
                                               Plan_Type__c,OpportunityId__c,Funding__c,
                                               vlocity_ins__ContractCode__c
                                               from QuoteLineItem 
                                               where quote.Name='Test Quote' 
                                               Limit 200];
        
         for(Integer i=0;i<20;i++){
            quotelineitemlist[i].HPCC_Code__c='HP5'+(i+1);
            quotelineitemlist[i].Plan_Type__c='Modified';
            quotelineitemlist[i].ProductStage__c='In Progress';
            quotelineitemlist[i].vlocity_ins__ContractCode__c='Code'+(i+1);
          //  hpccCode=(hpccCode!='')?(hpccCode+';'+quotelineitemlist[i].HPCC_Code__c):(quotelineitemlist[i].HPCC_Code__c);
          //  customCode=(customCode!='')?(customCode+';'+quotelineitemlist[i].vlocity_ins__ContractCode__c):(quotelineitemlist[i].vlocity_ins__ContractCode__c);
        }
        update quotelineitemlist;
        
        List<SBC_SOB_Request__c> sbcRecord1=[select id,hpcc_code__c,Funding_Type__c,
                                             Contract_Code__c,Plan_Type__c,Opportunity__c,Custom_Contract_Code__c 
                                             from SBC_SOB_Request__c where Opportunity__r.Name='test Opty' 
                                             Limit 1];
        
        for(SBC_SOB_Request__c sbc:sbcRecord1){
            sbcId.add(sbc.id);
        }
        
        sbcRecord1=[select id,hpcc_code__c,Funding_Type__c,Contract_Code__c,Plan_Type__c,Opportunity__c,Custom_Contract_Code__c 
                    from SBC_SOB_Request__c Limit 200];
        
        
        System.assertEquals(sbcRecord1[0].Plan_Type__c,quotelineitemlist[0].Plan_Type__c, 'Plan Type is Equal');
      
        
        SBCSOBActions.sbcCheck=false;
                
        
        Test.stopTest();
    }    
}