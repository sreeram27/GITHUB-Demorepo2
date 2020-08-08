@isTest
public class SendToFirstController_Test {
   
    public static List<Account> accs;

    public static List<Opportunity> opps;
    
    public static List<Quote> q;
    public static List<OpportunityTeamMember> otm;
    
    public static List<QuoteLineItem> qli;
    public static List<product2> prod;
       public static List<PricebookEntry> pbe;
        static testmethod void getQuotesTest(){
          
           Test.setMock(WebServiceMock.class, new wellpointComServiceUtilityMock());
          
           accs = TestDataFactory.createAccountSICList(1, 'Test Account', '1234 S. Address St.', 'Phoenix', 'AZ', '55555', 'United States', 'AZ');
      
        insert accs;
        //cons = TestDataFactory.createContactBrokerList(1, 'Test', 'Contact', 'test@test.com', '1234 s. Address St.', 'Phoenix', 'AZ', '55555', 'United States', accs[0]);
        //cons[0].Tax_ID__c = '00-00000';
        //insert cons;
      
        opps = TestDataFactory.createOpportunityList(1, 'Test Opportunity',accs[0]);
        insert opps;
        
           // p= TestDataFactory.Pricebook('Test Opportunity',1);
        //insert p;
        
        
            prod= TestDataFactory.createProduct('Test Opportunity',1);
        insert prod;
        
         q= TestDataFactory.Quote('Test Opportunity',1,opps[0]);
        insert q;
        
         pbe= TestDataFactory.PricebookEntry(1,prod[0]);
        insert pbe;
        
                qli= TestDataFactory.QuoteLineItem('Test QuoteLineItem',1,q[0],prod[0],pbe[0]);
        insert qli;
        
        otm= TestDataFactory.createOpportunityTeam(1,opps[0]);
        insert otm;
        
        SendToFirstController.getQuotes(opps[0].id);
        SendToFirstController.getRegion(opps[0].id);
        //test.starttest();
             SendToFirstController.sendInfoToFIRST(opps[0].id);
       //test.stoptest();
        //Test.setMock(HttpCalloutMock.class, new SendToFirstController());

       
    }
    

   
}