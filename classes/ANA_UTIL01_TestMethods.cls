/*@author         Accenture
  @date           20/04/2017
  @name           ANA_UTIL01_TestMethods
  @description    Defining all the test class method object record dml perorm actions 
  Modification Log:
  ------------------------------------------------------------------------------------
  Developer                       Date                Description
  ------------------------------------------------------------------------------------
  Kishorekumar A                 --              By using this class defining separate method to perform dml operation on object record
  VIKINGS                        11/09/2019      Added methods to create Order, Implementation tracking and Case Istall
  */
public with sharing class ANA_UTIL01_TestMethods {
    private static final string SOLD='Sold';
    private static final String OPPR = 'Opportunity';
    private static final String ACCOUNT='Account';
    private static final String CONTACTREL='ContactRelationship__c';
    private static final string TESTNAME='Test';
    private static final string DOMAIN='@test.com'; 
    private static final string STAGE_NAME='Initiated';
    private static final string BUNDLE='Fixed';
    private static final string CHILD='5';
    private static final string RECORDTYPENAME ='LHOs';
    private static final string LINEOFBUSSINESS='Anthem Health Guide';
    private static final string FUNDINGTYPE = 'ASO';
    private static final string PAYMENTMETHOD = 'Flat Dollar-Annual';
    private static final string GROUPNUMBER = '45';
    private static final string PROD_FAMILY='License';   
    private static final string PROD_NAME='Integrated Health Model';
    private static final string CLASS_NAME='ANA_UTIL01_TestMethods';
    private static final String TEST_CLASS = 'TEST_CLASS';
    private static final string ALIAS='standt';
    private static final string USER_EMAIL='standarduser@testorg.com';
    private static final string EMAILENCODINGKEY='UTF-8';
    private static final string LASTNAME ='Testing';
    private static final string LANGUAGE_LOCALESIDKEY ='en_US';
    private static final string TIMEZONESIDKEY='America/Los_Angeles';
    private static final string USERNAME='nationalamuser@testorg.com';
    private static final string IMPL_STATUS = 'Draft';
    private static final string IMPL_CASENAME = 'AIMTesting01';
    private static final string IMPL_STATUS_CUSTOM = 'Ready for Imps';
     /*Inserting Account record  */
    public static Account createAccount(Boolean doInsert) { 
        Account acc;
        try{         
            acc=createAccounts(1,doInsert)[0];
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return acc;
    }   
    /*Inserting Account record  information based on parameter value otherwise it returns the record information*/
    public static List<Account> createAccounts(Integer numAccounts,Boolean doInsert) {
        List<Account> accounts = new List<Account>();
        Account acc;
        try{
            for(integer i = 0; i < numAccounts; i++){
                acc=new Account(Name=TESTNAME + i);
                Accounts.add(acc);
            }        
            if (doInsert){
                Database.SaveResult[] lsr = Database.insert(accounts,false);
            } 
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }           
        return accounts;
    }   
    /*This method creates Opportunity record.*/
   public static Opportunity createOpportunity(boolean doInsert,Id accId) {   
        Opportunity opty;
        try{  
            opty=createOpportunities(1,doInsert,accId)[0];
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return opty;
    }  
 /*This method creates multiple opportunity records.*/
public   static List<Opportunity> createOpportunities(Integer numOfopts,Boolean doInsert,Id accId ){
        List<Opportunity> optyList = new List<Opportunity>();
        Opportunity opp;
        try{
            for(integer i = 0; i < numOfopts; i++){
                opp=new Opportunity();
                opp.Name = TESTNAME+i;
              opp.AccountId = accId;
              opp.CloseDate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today().addDays(1);
              opp.StageName = STAGE_NAME;                
                optyList.add(opp);
            }        
            if (doInsert){
                Database.SaveResult[] lsr = Database.insert(optyList,false);
            } 
        } 
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return optyList;
    } 
    /*This method creates Quote record.*/
  public static Quote createQuote(boolean doInsert,Id oppid) {   
        Quote qte;
        try{  
            qte=createQuotes(1,doInsert,oppid)[0];
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return qte;
    }  
  /*This method creates multiple Quote records.*/
  public static List<Quote> createQuotes(Integer numQuotes,Boolean doInsert,Id oppid){
        List<Quote> quoteList = new List<Quote>();
    Quote qte;
        try{
            for(integer i = 0; i < numQuotes; i++){
                qte=new Quote();
                qte.Name=TESTNAME + i;
                qte.OpportunityId = oppid;
                qte.Pricebook2Id = Test.getStandardPricebookId();
                quoteList.add(qte);
            } 
      if (doInsert){
                Database.SaveResult[] lsr = Database.insert(quoteList,false);
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }           
        return quoteList;
    }  
/*This method creates Product.*/  
public static Product2 createProduct(boolean doInsert)  {
    Product2 prd;
  try{
        prd = new product2(name=PROD_NAME,Bundle__c= BUNDLE);
        prd.Family = PROD_FAMILY;
        if (doInsert){
            Database.SaveResult lsr = Database.insert(prd,false);
        }
  }
  catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
    } 
  return prd;
}
    /*This method creates PSD records */
    public static List<ProductSelectionDetail__c> createPSDRecord(List<QuoteLineItem> parentQLIList, Boolean doInsert){
        ProductSelectionDetail__c cpsd;
        Id devRecordTypeId = Schema.SObjectType.ProductSelectionDetail__c.getRecordTypeInfosByName().get(RECORDTYPENAME).getRecordTypeId();
        List<ProductSelectionDetail__c> productselections = new List<ProductSelectionDetail__c>();
         try{
                for(integer i = 0; i < parentQLIList.size(); i++){
                    cpsd = new ProductSelectionDetail__c(QuoteLineItem__c=parentQLIList[i].id,recordtypeid=devRecordTypeId,LHO_Components__c='Lactation');
                    productselections.add(cpsd);
                }
            if (doInsert){
                Database.SaveResult[] lsr = Database.insert(productselections,false);
            }   
       
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        } 
        return productselections;
    }
/*This method creates PriceBookEntry.*/
public static PricebookEntry createPricebookEntry(boolean doInsert,Id prdId){
    PricebookEntry pbe;
  try{
    pbe = new PricebookEntry(pricebook2id = Test.getStandardPricebookId(),
        product2id = prdId,unitprice=1.0,isActive=true);
        if (doInsert){
            Database.SaveResult lsr = Database.insert(pbe,false);
        }
  }
  catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
    } 
  return pbe;
}
/*This method creates QuoteLineItem record.*/
public static QuoteLineItem createQuoteLineItem(boolean doInsert,Id qteid,Id pbeid) {   
        QuoteLineItem qtli;
        try{  
            qtli=createQuoteLineItems(1,doInsert,qteid,pbeid)[0];
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return qtli;
    } 
/*This method creates multiple QuoteLineItem records.*/  
  public static List<QuoteLineItem> createQuoteLineItems(Integer lineItemCount,Boolean doInsert,Id qteid,Id pbeid){
        QuoteLineItem qli;
        List<QuoteLineItem> lineItemList = new List<QuoteLineItem>();
        try{           
            for(integer i = 0; i < lineItemCount; i++){
                qli = new QuoteLineItem(PricebookEntryId=pbeid,quoteid=qteid,Quantity=1,unitprice =1,TECH_OSIsMultiSelect__c=true);
                lineItemList.add(qli);
            }
      if (doInsert){
                Database.SaveResult[] lsr = Database.insert(lineItemList,false);
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        } 
        return lineItemList;
}
/*This method creates 
 Product.*/  
public static vlocity_ins__ProductChildItem__c createChildProduct(Id prdid,Id childprdid,boolean doInsert)  {
    vlocity_ins__ProductChildItem__c vprd;
  try{
        vprd = new vlocity_ins__ProductChildItem__c(vlocity_ins__ParentProductId__c=prdid,vlocity_ins__ChildProductId__c=childprdid);
        vprd.vlocity_ins__ChildLineNumber__c = CHILD;
        if (doInsert){
            Database.SaveResult lsr = Database.insert(vprd,false);
        }
  }
  catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
    } 
  return vprd;
}
/*This method creates QuoteLineItem records for list of Quotes.*/
    public static List<QuoteLineItem> createQuoteLineItem_ForQuote(Boolean doInsert,List<Quote>qteList,Id pbeid){
        QuoteLineItem qli;
        List<QuoteLineItem> lineItemList = new List<QuoteLineItem>();
        try{
                for(integer i = 0; i < qteList.size(); i++){
                    qli = new QuoteLineItem(PricebookEntryId=pbeid,quoteid=qteList[i].id,Quantity=1,unitprice =1,ProductStage__c=SOLD);
                    lineItemList.add(qli);
                }
        if (doInsert){
                Database.SaveResult[] lsr = Database.insert(lineItemList,false);
            }
        
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        } 
        return lineItemList;
    }
    
/*This method creates QuoteLineItem records for list of Quotes.*/
    public static List<QuoteLineItem> createQuoteLineItemRecord(Boolean doInsert,List<Quote>qteList,Id pbeid,Id accid){
        QuoteLineItem qli;
        List<QuoteLineItem> lineItemList = new List<QuoteLineItem>();
        try{
                for(integer i = 0; i < qteList.size(); i++){
                    qli = new QuoteLineItem(PricebookEntryId=pbeid,quoteid=qteList[i].id,Quantity=1,unitprice =1,ProductStage__c=SOLD,
                                            Competitor__c= accid);
                    lineItemList.add(qli);
                }
        if (doInsert){
                Database.SaveResult[] lsr = Database.insert(lineItemList,false);
            }
        
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        } 
        return lineItemList;
    }
    /*This method creates QLIs with parent QLI assignment*/
    public static List<QuoteLineItem> createChildQuoteLineItemsList(List<QuoteLineItem> parentQLIList,Boolean doInsert,List<Quote>qteList,Id pbeid){
        QuoteLineItem qli;
        List<QuoteLineItem> lineItemList = new List<QuoteLineItem>();
        try{
                for(integer i = 0; i < qteList.size(); i++){
                    qli = new QuoteLineItem(ParentQuoteLineItem__c=parentQLIList[i].id,PricebookEntryId=pbeid,quoteid=qteList[i].id,Quantity=1,unitprice =1);
                    lineItemList.add(qli);
                }
        if (doInsert){
                Database.SaveResult[] lsr = Database.insert(lineItemList,false);
            }
        
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        } 
        return lineItemList;
    }
     /*This method creates QLIs with parent QLI assignment*/
    public static List<QuoteLineItem> createChildQuoteLineItems(List<QuoteLineItem> parentQLIList,Boolean doInsert,Id qteid,Id pbeid){
        QuoteLineItem qli;
        List<QuoteLineItem> lineItemList = new List<QuoteLineItem>();
        try{
                for(integer i = 0; i < parentQLIList.size(); i++){
                    qli = new QuoteLineItem(ParentQuoteLineItem__c=parentQLIList[i].id,PricebookEntryId=pbeid,quoteid=qteid,Quantity=1,unitprice =1);
                    lineItemList.add(qli);
                }
        if (doInsert){
                Database.SaveResult[] lsr = Database.insert(lineItemList,false);
            }
        
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        } 
        return lineItemList;
    }
 /*This method creates QuoteLineItemApproval records. */
  public static List<QuoteLineItemApproval__c> createQuoteLineItemApproval(Id qliid,Integer lineItemCount){
        QuoteLineItemApproval__c qli;
        List<QuoteLineItemApproval__c> lineItemList = new List<QuoteLineItemApproval__c>();
        try{
            for(integer i = 0; i < lineItemCount; i++){
                qli = new QuoteLineItemApproval__c(QuoteLineItem__c=qliid);
                lineItemList.add(qli);
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        } 
        return lineItemList;
    } 
    /*This method create Contact record.*/
    public static Contact createContact(boolean doInsert,Id accId) {   
        Contact cntc;
        try{  
            cntc=createContacts(1,doInsert,accId)[0];
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return cntc;
    }  
    /*This method creates multiple contact records.*/
    public   static List<Contact> createContacts(Integer numOfContacts,Boolean doInsert,Id accId ){
        List<Contact> contactList = new List<Contact>();
        Contact contact;
        try{
            for( Integer index = 0; index < numOfContacts; index++ ){
                 contact= new Contact();
                contact.LastName = TESTNAME + index;
                contact.Email = TESTNAME + index + DOMAIN;
                if(accId!=null)
                {
                    contact.AccountId=accId;
                }
                contactList.add( contact );
            }
    
            if( doInsert ){
                Database.SaveResult[] lsr = Database.insert(contactList,false);
            }
        } 
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return contactList;
    }  
    /*Inserting Contact Relationship record  */
     public static ContactRelationship__c createContactRelationship(boolean doInsert) {  
         ContactRelationship__c ctRln;
        try{    
            ctRln = createContactRelationships(1,doInsert)[0];
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return ctRln;
    }   
    /*Inserting Brokerage and Consultant record  information based on parameter value otherwise returns the record information*/
    public   static List<ContactRelationship__c> createContactRelationships(Integer quantity, Boolean doInsert) {           
        List<ContactRelationship__c> contrels = new List<ContactRelationship__c>();
        ContactRelationship__c conre;
        try{
            for (Integer i = 0; i < quantity; i++) {
                conre = new ContactRelationship__c(
                    EndDate__c = system.today().addDays(1),
                    EffectiveDate__c = system.today().adddays(1)
                );
                contrels.add(conre);
            }
            if (doInsert) {
                Database.SaveResult[] lsr = Database.insert(contrels,false);
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return contrels;
    }    
    /*Inserting  Brokerage and Consultant record  */
    public  static Brokerage_and_Consultant__c createBrokerageAndConsultant(boolean doInsert) {
        Brokerage_and_Consultant__c brConsul;
        try{  
            brConsul= createBrokerageAndConsultants(1,doInsert)[0];
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return brConsul;
    }   
    /*Inserting Brokerage and Consultant record  information based on parameter value otherwise returns the record information*/
    public static List<Brokerage_and_Consultant__c> createBrokerageAndConsultants(Integer quantity,Boolean doInsert) {
        List<Brokerage_and_Consultant__c> brokerAndConsultants = new List<Brokerage_and_Consultant__c>();
        Brokerage_and_Consultant__c brokerAndConsultant;
        try{
            for (Integer i = 0; i < quantity; i++) {
                brokerAndConsultant = new Brokerage_and_Consultant__c();                
                brokerAndConsultants.add(brokerAndConsultant);
            }
    
            if (doInsert) {
                Database.SaveResult[] lsr = Database.insert(brokerAndConsultants,false);
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return brokerAndConsultants;
    }    
    /*Inserting SIC__c record*/
    public static SIC__c createSIC(boolean doInsert){
        SIC__c sic;
        try{
            sic=createSICs(1,doInsert)[0];
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return sic;
    }   
    /*Inserting multiple SIC__c records*/
    public static List<SIC__C> createSICs(Integer numofSICs,Boolean doInsert){
        List<SIC__C> sics = new List<SIC__C>();
        SIC__C sic;
        try{
            for(integer i = 0; i < numofSICs; i++){
                sic=new SIC__C(Name=TESTNAME + i);
                sics.add(sic);
            }
            if (doInsert){
                Database.SaveResult[] lsr = Database.insert(sics,false);
            }  
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }      
        return sics;
    }
/*creates the group record*/  
  public static Group__C createGroup(Id accId,Boolean doInsert){
        Group__C grp;
        try{
            grp=createGroups(accId,1,doInsert)[0];
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return grp;
    } 
  /*Creates the list of group records*/
public static List<Group__c> createGroups(Id accId,Integer numofgrps,Boolean doInsert){
        List<Group__c> grps= new List<Group__c>();
        Group__c grp;
        try{
            for(integer i = 0; i < numofgrps; i++){
                grp=new Group__c(Name=TESTNAME + i,Account__c=accId);
                grps.add(grp);
            }
            if (doInsert){
                Database.SaveResult[] lsr = Database.insert(grps,false);
            }  
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }      
        return grps;
    }    
    /*This method will return the Record type id from name*/
    public static Id getRecordTypeId(String ObjectName,String recTypeName){
        Id recTypeId;
        try{
            if(ObjectName!=null&&recTypeName!=null){
                if(ACCOUNT.equalsIgnoreCase(ObjectName)){
                    recTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
                }
                if(CONTACTREL.equalsIgnoreCase(ObjectName)){
                   recTypeId=Schema.SObjectType.ContactRelationship__c.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
                }
                if(OPPR.equalsIgnoreCase(ObjectName)){
                  recTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
                }
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return recTypeId;
    }      
    /*Inserting specific profile*/
    public static User runAsUser(Id profId){
        User usr=new User();
        try{ 
            usr=new User(alias = ALIAS, email=USER_EMAIL, 
                          emailencodingkey=EMAILENCODINGKEY, lastname=LASTNAME, languagelocalekey=LANGUAGE_LOCALESIDKEY, 
                          localesidkey=LANGUAGE_LOCALESIDKEY, profileid = profId, 
                          timezonesidkey=TIMEZONESIDKEY, username=USERNAME);
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return usr;
    }   
    
    /*This method creates ServiceProviderRelationship records */
    public static ServiceProviderRelationship__c createServiceProviderRelationshipRecord(Boolean doInsert,Id accid){
        ServiceProviderRelationship__c spr; 
        try{
            spr= new ServiceProviderRelationship__c();
            spr.EffectiveDate__c = system.today();
            spr.Account__c = accid;
            spr.Competitor__c = true;
            if (doInsert){
                Database.SaveResult lst = Database.insert(spr);
            } 
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);    
        }
        return spr;
    }
    /*This method updates the ParentQLI.*/
    public static List<QuoteLineItem> swapAssignParentToChildQLI(List<QuoteLineItem> childQliList, List<QuoteLineItem> parentQliList){
        List<QuoteLineItem> updateQliList = new List<QuoteLineItem>(); 
        QuoteLineItem qLI;
        for(Integer t = 0; t < childQliList.size();){
            qLI = childQliList.get(t);
            ++t;
            Integer cnt = parentQliList.size()-t;
            qLI.ParentQuoteLineItem__c = parentQliList.get(cnt).id;  
            updateQliList.add(qLI);
            }
        return updateQliList;
    }
    /*This method assigns parent QLi to the child QLI.*/
    public static List<ProductSelectionDetail__c> assignParentToChild(List<ProductSelectionDetail__c> PSDList, List<QuoteLineItem> parentQliList){
        List<ProductSelectionDetail__c> updatePsdList = new List<ProductSelectionDetail__c>(); 
        ProductSelectionDetail__c psd;
        for(Integer i = 0; i < PSDList.size();){
            psd = PSDList.get(i);
            ++i;
            Integer cnt = parentQliList.size()-i;
            psd.QuoteLineItem__c = parentQliList.get(cnt).id;  
            updatePsdList.add(psd);
            }
        return updatePsdList;
    }
    
    /*By using this method inserting Brokerage and Consultant Commissions record  information based on parameter value otherwise returns the record information*/
    public static list<Broker_Consultant_Commissions__c> createBrokerConsultantCommissions(Integer quantity,Boolean doInsert,ID Accid,ID bcid){
        List<Broker_Consultant_Commissions__c> brokerAndConsultantsComm = new List<Broker_Consultant_Commissions__c>();
        Broker_Consultant_Commissions__c bcc;
        for (Integer i = 0; i < quantity; i++) {
             bcc = new Broker_Consultant_Commissions__c(Account__c=Accid, BrokerageAndConsultant__c=bcid,
                Commission_Start_Date__c = system.today().addDays(1));
            bcc.Line_of_Business__c = LINEOFBUSSINESS;
            bcc.Funding_Type__c = FUNDINGTYPE;
            bcc.Payment_Method__c = PAYMENTMETHOD;
            bcc.Group_Numbers__c = GROUPNUMBER;
            brokerAndConsultantsComm.add(bcc);
        }
        if (doInsert) {
            Database.SaveResult[] lsr = Database.insert(brokerAndConsultantsComm,false);
        }
        return brokerAndConsultantsComm;
    }
    
    /*This method creates Order record.*/
    public static Order CreateOrder(Id groupId, Id accountId, Id assignImplementorId, Id quoteId){
        Order thisOrder = new Order();
        try{
            thisOrder.Group_Name__c=groupId;
            thisOrder.AccountId = accountId;
            thisOrder.EffectiveDate=System.today();
            thisOrder.Status = IMPL_STATUS;
            thisOrder.Implementation_Case_Name__c = IMPL_CASENAME;
            thisOrder.Implementation_Status__c = IMPL_STATUS_CUSTOM; 
            thisOrder.Implementation_Effective_Date__c=System.today();
            thisOrder.Assigned_Implementer__c=assignImplementorId;
            thisOrder.QuoteId=quoteId;
        }catch(exception ex){
            UTIL_LoggingService.logHandledException(ex, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);
        }
        return thisOrder;
    }
    
    /*This method creates Implementation Tracking*/
    public static Implementation_Tracking__c CreateImplTracking(Id implRecordId,Id recordTypeId, Id userId){
        Implementation_Tracking__c impltrack; 
        try{
            impltrack = new Implementation_Tracking__c();
            impltrack.Implementation_Record_ID__c = implRecordId;
            impltrack.recordTypeid = recordTypeId;
            implTrack.Assigned_Implementer_lookup__c = userId;
        }
         
        catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
        	CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);
        }
        
      return impltrack;  
    }
    
    /*This method creates Case Install*/
    public static Issue_Control__c CreateCaseInstall(String IC_Applicable ,Id implTrackId, String impactedProduct){
        Issue_Control__c caseInstall; 
        try{
            caseInstall = new Issue_Control__c();
            caseInstall.Is_Issue_Control_Applicable__c = IC_Applicable;
            caseInstall.Implementation_Tracking_ID__c = implTrackId;
            caseInstall.Impacted_Products__c = impactedProduct;
        }
         
        catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TEST_CLASS,LoggingLevel.ERROR);
        }
        
      return caseInstall;  
    }
    
    /*This Method is used for Nova Suite errors*/
    /* commenting below method since its not used anywhere in code base.
    public static void novaSuiteNonmethod(){
        createBrokerConsultantCommissions(null,null,null,null);
        assignParentToChild(null,null);
        swapAssignParentToChildQLI(null,null);
        createServiceProviderRelationshipRecord(null,null);
        runAsUser(null);
        getRecordTypeId(null,null);
        createGroups(null,null,null);
        createGroup(null,null);
        createSICs(null,null);
        createSIC(null);
        createBrokerageAndConsultants(null,null);
        createBrokerageAndConsultant(null);
        createContactRelationships(null,null);
        createContactRelationship(null);
        createContacts(null,null,null);
        createContact(null,null);
        createQuoteLineItemApproval(null,null);
        createChildQuoteLineItems(null,null,null,null);
        createChildQuoteLineItemsList(null,null,null,null);
        createQuoteLineItemRecord(null,null,null,null);
        createQuoteLineItem_ForQuote(null,null,null);
        createChildProduct(null,null,null);
        createQuoteLineItems(null,null,null,null);
        createQuoteLineItem(null,null,null);
        createPricebookEntry(null,null);
        createPSDRecord(null,null);
        createProduct(null);
        createQuotes(null,null,null);
        createQuote(null,null);
        createOpportunities(null,null,null);
        createOpportunity(null,null);
        createAccounts(null,null);
        createAccount(null);
        
    }*/
}