@isTest
global class wellpointComServiceUtilityInterface_Test implements WebServiceMock{
 public static List<Account> accs;

    public static List<Opportunity> opps;
    
    public static List<Quote> q;
    public static List<OpportunityTeamMember> otm;
    
    public static List<QuoteLineItem> qli;
    public static List<product2> prod;
       public static List<PricebookEntry> pbe;
  
  static testmethod void UtilityService_HTTP_Port_Test(){
    /*init();
    ApexPages.CurrentPage().getparameters().put('id', opps[0].id);
    ApexPages.StandardController sc = new ApexPages.standardController(opps[0]);
    SendToFirstExtension sfe = new SendToFirstExtension(sc);*/
    wellpointComServiceUtilityInterface.UtilityService_HTTP_Port ush = new wellpointComServiceUtilityInterface.UtilityService_HTTP_Port();
    
    Test.setMock(WebServiceMock.class, new wellpointComServiceUtilityInterface_Test());
    
    wellpointComServiceUtility.SubmitFIRSTQuoteResponse_element output = ush.SubmitFIRSTQuote(null);
    
    system.assertEquals('Test Status Code', output.Status.StatusCode);
    system.assertEquals('Test Status Description', output.Status.StatusDesc);
  }
  
  global void doInvoke(
    Object stub,
    Object request,
    Map<String, Object> response,
    String endpoint,
    String soapAction,
    String requestName,
    String responseNS,
    String responseName,
    String responseType
  ){
    wellpointComServiceUtility.UtilityService_SubmitFIRSTQuote_ResponseType resTyp = new wellpointComServiceUtility.UtilityService_SubmitFIRSTQuote_ResponseType();
    wellpointComServiceUtility.SubmitFIRSTQuoteResponse_element resEle = new wellpointComServiceUtility.SubmitFIRSTQuoteResponse_element();
    wellpointComServiceUtility.Status sts = new wellpointComServiceUtility.Status();
    sts.StatusCode = 'Test Status Code';
    sts.StatusDesc = 'Test Status Description';
    resEle.Status = sts;
    resTyp.SubmitFIRSTQuoteResponse = resEle;
    response.put('response_x', resTyp);
  }
  
  
  static void init(){
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
  }
}