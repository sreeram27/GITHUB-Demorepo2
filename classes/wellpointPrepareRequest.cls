public class wellpointPrepareRequest {
    public static wellpointComServiceUtility.SubmitFIRSTQuoteRequest_element prepareRequest(SendToFirstController.RequestWrapper stfe) 
    {
     system.debug(stfe);
     
    wellpointComServiceUtility.SubmitFIRSTQuoteRequest_element submitReqElement = new wellpointComServiceUtility.SubmitFIRSTQuoteRequest_element();
    wellpointComServiceUtility.Account account =  new wellpointComServiceUtility.Account();
    wellpointComServiceUtility.Broker broker = new wellpointComServiceUtility.Broker();
    wellpointComServiceUtility.Opportunity opportunity = new wellpointComServiceUtility.Opportunity();
    wellpointComServiceUtility.Quote[] quotes = new wellpointComServiceUtility.Quote[1];
    system.debug(quotes.size());
    quotes[0] = new wellpointComServiceUtility.Quote();
      
    wellpointComServiceUtility.QuoteLineItem[] quoteLineItem = new wellpointComServiceUtility.QuoteLineItem[stfe.prod.size()];
    for(Integer i = 0; i < quoteLineItem.size(); i++){
      quoteLineItem[i] = new wellpointComServiceUtility.QuoteLineItem();
    } 
    
    wellpointComServiceUtility.Address address = new wellpointComServiceUtility.Address();
    
    /* Preparing Account Object - Static Values*/  
    /*  Account Name and Identifiers */
    account.AccountName = stfe.opp.Account.Name; //Required
    account.CS90GroupNumber = !stfe.groups.isEmpty() ? stfe.groups[0].Name : null; //Optional for New Business and Required for Renewals
    account.SICCode = stfe.opp.Account.SIC__r.SIC_Code__c; //Required
    /*  Account Primary Address*/
    address.StreetAddress = stfe.opp.Account.BillingStreet;
    address.StreetAddress2 = null;
    address.City = stfe.opp.Account.BillingCity;
    address.StateCode = stfe.opp.Account.BillingState;
    address.ZipCode = stfe.opp.Account.BillingPostalCode; //Required
    account.Address = address;
    /* Quote Details - Even though schema supports multiple quotes, only one quote will be send */
    quotes[0].QuoteId = stfe.prod[0].QuoteId; //Required : Sales System generated Id
    quotes[0].QuoteName = stfe.prod[0].Quote.Name;
    //quotes[0].QuoteName = stfe.lobs[0].Quote_Name__c; //Required : User Entered Value
    if(stfe.groups != null && !stfe.groups.isEmpty())
        quotes[0].Comments = stfe.groups[0].Comments__c; //Optional
    
    /*  QuoteLineItem - Selected Products and details */
    //quoteLineItem[0].ProductName = '500';
     for(Integer i = 0; i < quoteLineItem.size(); i++){
      //quoteLineItem[i].ProductName = stfe.prod[i].Product2.Name;
      quoteLineItem[i].ProductName = stfe.prod[i].Product2.underwriting_product_code__c;
      /*Required : Get the list of products from FIRST and load/match in to Sales System, 
                                only those products should be available for selection*/
      quoteLineItem[i].FundingType = stfe.prod[i].Funding__c; //default value: Fully Insured, drop down list, check with business
     }
    quotes[0].QuoteLineItem = quoteLineItem;
    /*  quoteLineItem[0].CommisionType = 'Commission_Type'; //Optional, Not needed, we just have the placeholder
      quoteLineItem[0].CommisionValue = 0;  //Optional
      quotes[0].QuoteLineItem = quoteLineItem; */
    
    
    /* Broker Properties : From ASCS*/
    broker.BrokerName = ''; 
    broker.BrokerStateTaxId = '';
    broker.BrokerageName = '';
        
    /* Opportunity Detail*/  
    /* Setting the Effective and End Date */
    
    opportunity.OpportunityId = ((String)stfe.opp.Id).subString(0, 15); // Required: Sales System generated Id
    //opportunity.OpportunityId = '1234567890';
    opportunity.OpportunityType = stfe.newRenewal;//stfe.opp.RecordType.Name; //Required, New Business or Renewal
    //opportunity.OpportunityType = 'R';
    //opportunity.AssignedUWLoginId = stfe.uwId; //Required
    opportunity.AssignedUWLoginId = stfe.uwId; //Required
    opportunity.AssignedUWName = stfe.uwName; //Optional: UW First Name & Last Name 
    //opportunity.AssignedSalesRepLoginId = 'SATEST9';//stfe.srId; //Required
    opportunity.AssignedSalesRepLoginId = stfe.srId; //Required
    opportunity.AssignedSalesRepName = stfe.srName; //Optional : From ASCS - Agent First Name & Last Name 
    //opportunity.GapPlanExistsIndicator = stfe.gapPlan; //Optional, Check with Business 
    //opportunity.GapPlanProposedIndicator = stfe.opp.GAP_Plan_Proposed__c; //Optional, Check with Business
    //opportunity.ReasonOutToBid = stfe.opp.Out_to_Bid_Reason__c; //Optional, Check with Business
    opportunity.LineOfBusiness = 'Medical'; //Required, Default is Medical, doesn't support speciality stfe.opp.Lines_of_Business__c
    opportunity.EffectiveDate = stfe.opp.CloseDate; //Required
    //Date effDt = stfe.opp.CloseDate;
    //Date expDt =  effDt.addYears(1);
    //opportunity.EndDate = expDt; //Optional : Effective Dt + 365 Days
    opportunity.RegionCode = 'NY'; //Required : hardcoded Value
    opportunity.Broker = broker;
    
    /* Adding Account, Opportunity and Quotes to the Request Entity*/  
      
    submitReqElement.Account = account;
    submitReqElement.Opportunity = opportunity;
    submitReqElement.Quote = quotes;
    
    return submitReqElement;
  }

 }