/*@author        Accenture offshore     
@date           21/05/2019
@name           Anthem_TestDataFactory
@description    Reusable Data Factory to generate Test Data */

@isTest
public class Anthem_TestDataFactory { 
    
    
    
    /**
@description : Method to generate Account
@return : Account with RecorTypeId.
@param :  recordTypeIdList 
*/
    public static List<Account> generateAccount (List<Id> recordTypeIdList ){
        SIC__c sicTest = new SIC__c (Name = 'TestSIC', SIC_Code__c = '32146');
        insert(sicTest);
        
        List<Account> accList= new List<Account>();
        
        Integer count = 0;
        
        for(Id recordTypeId: recordTypeIdList){
            Account acc = new Account(Name='Acc' + count,
                                      RecordTypeId = recordTypeId,
                                      BillingStreet = '333 South 7th Street',
                                      BillingPostalCode='19106',
                                      BillingState='CA',
                                      BillingCountry='United States',
                                      BillingCity='Philadelphia',
                                      Physical_County__c= 'California',      
                                      Mailing_Address_Same_as_Physical_Address__c=true,      
                                      Mailing_County__c='United States',
                                      Situs_State__c='California',
                                      Anthem_Entity__c = 'Local/Large Group',
                                      Region__c = 'Central',
                                      HQ_State__c = 'CA',
                                      Branding__c = 'Anthem Life',
                                      Group_Size__c  = '2001 - 3000',
                                      Total_Employees__c = 5,
                                      Eligible_Employees__c = 5,
                                      OffersEGRBenefits__c = 'No',
                                      WGS_MBU_Code__c = '66500000-COMMERCIAL MCS',
                                      //Vendor_Referral__c = 'N',//This field Vendor_Referral__c is not present in RUAT. Commented to deploy this class to RUAT.
                                      Submarket__c = 'Cincinnati',
                                      MBU_Codes__c = 'CA-EDCAMC-Education MCS BCC',
                                      Pooled_Non_Pooled__c = 'Pooled',
                                      SIC__c = sicTest.Id);
            accList.add(acc);
        }
        return accList;
    }
    
    
    /**
@description : Method to generate Opportunity
@return : Opportunity with RecordTypeId
@param :  oppoRecTypeList, parentAccId
*/    
    public static List<Opportunity> generateOpportunity (List<Id> oppoRecTypeList,Id parentAccId){
        
        List<Opportunity> oppList = new List<Opportunity>();
        Integer count = 0;
        for(Id recTypeId : oppoRecTypeList){
            
            Opportunity opp = new Opportunity(Name='Opp' + count,
                                              RecordTypeId= recTypeId,
                                              StageName='Prospecting',
                                              AccountId=parentAccId);
            opp.CloseDate=Date.newInstance(2019, 12, 9); 
            oppList.add(opp);
            count++;
            
        }
        return oppList;
    }    
    /**
@description : Method to generate Product
@return : Product2
*/    
    public static Product2 generateProduct2(){
        
        Product2 product = new Product2(Name='Acme',
                                        Product_Type__c = 'Medical',
                                        Category__c = 'Product',
                                        Contract_Code__c = '42AR',
                                        LOB__c = 'Medical', 
                                        Product_Family__c = 'ABA',
                                        IsActive = true);       
        return product;
    }
    
    /**
@description : Method to generate Product
@return : List<Product2>
@param :  productTypeList
*/    
    public static List<Product2> generateProduct2ByType(Map<String,Integer> productTypeMap){
        List<Product2> productList = new List<Product2>();
        Integer count = 0;
        for(String prodtype : productTypeMap.keySet()){
            count++;
            for(Integer ct = 0; ct < productTypeMap.get(prodtype); ct++){
                Product2 product = new Product2(Name='Acme product'+count,
                                                Product_Type__c = prodtype,
                                                Category__c = 'Product',
                                                Contract_Code__c = '42AR'+count,
                                                IsActive = true); 
                productList.add(product);
            }
        }
        
        
        
        Product2 medicalPlan = new Product2(Name='Acme Medical plan',
                                            Product_Type__c = 'Medical',
                                            Category__c = 'Plan',
                                            Contract_Code__c = '42AR'+count,
                                            LOB__c = 'Medical',
                                            IsActive = true); 
        
        productList.add(medicalPlan);
        return productList;
    }
    
    /**
@description : Method to generate PriceBook
@return : Pricebook2Id
*/
    public static Id generatePricebookId() {
        Id pricebookId = Test.getStandardPricebookId();
        return pricebookId;
    }
    /**
@description : Method to generate PriceBookEntry
@return :PricebookEntry 
@param : productId, pricebookId
*/ 
    public static PricebookEntry generatePricebookEntry(Id productId,Id pricebookId){
        
        PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = pricebookId,
                                                           Product2Id = productId, 
                                                           UnitPrice = 1000,
                                                           IsActive = true);
        //UseStandardPrice=True);
        return pricebookEntry;
    }
    
    /**
@description : Method to generate Quote
@return : Quote
@param : quoteRecIdList, pricebookId, parentOppId
*/ 
    public static List<Quote> generateQuote(List<Id> quoteRecIdList, Id pricebookId, Id parentOppId,Id groupId){
        List<Quote> quoteList = new List<Quote>();
        Integer count = 0;
        for(Id quoteRecTypeId: quoteRecIdList){
            Quote quote = new Quote(Name='test quote' + (count+1),
                                    OpportunityId = parentOppId,
                                    Pricebook2Id = pricebookId,
                                    GroupNumber__c = groupId,
                                    Employee_Assistance_Program__c = LGA_Constants.TRUEVALUE,
                                    RecordTypeID = quoteRecTypeId);
            count++;
            quoteList.add(quote);
        }
        return quoteList;             
        
    }
    
    
    
    /**
@description : Method to generate Quote  ***Added By Raptors
@return : Quote
@param : quoteRecIdList, pricebookId, parentOppId
*/ 
    public static List<Quote> generateQuote(List<Id> quoteRecIdList, Id pricebookId, Id parentOppId){
        List<Quote> quoteList = new List<Quote>();
        Integer count = 0;
        for(Id quoteRecTypeId: quoteRecIdList){
            Quote quote = new Quote(Name='test quote' + count,
                                    OpportunityId = parentOppId,
                                    Pricebook2Id = pricebookId,
                                    Employee_Assistance_Program__c = LGA_Constants.TRUEVALUE);
            count++;
            quoteList.add(quote);
        }
        return quoteList;             
        
    }
    
    /**
@description : Method to createQuote
@return : Quote
@param : pricebookId, parentOppId
*/ 
    public static List<Quote> createQuote(Id pricebookId, Id parentOppId){
        List<Quote> quoteList = new List<Quote>();
        
        
        Quote quote = new Quote(Name='test quote',
                                OpportunityId = parentOppId,
                                Pricebook2Id = pricebookId,
                                Employee_Assistance_Program__c = LGA_Constants.TRUEVALUE);
        quoteList.add(quote);
        
        return quoteList;             
        
    }
    
    
    
    
    
    /**
@description : Method to generate QuoteLineItem
@return : List<QuoteLineItem>
@param : noOfQLIItems, product2Id, parentQuoteId, priceBookEntry
*/
    public static List<QuoteLineItem> generateSoldQuoteLineItem(Integer noOfQLIItems, Id product2Id,Id parentQuoteId, PricebookEntry priceBookEntry){
        List <QuoteLineItem> qlineItemList = new List<QuoteLineItem>();
        
        for(Integer i=0;i<noOfQLIItems;i++){    
            
            QuoteLineItem quoteLineItem = new QuoteLineItem(Product2Id=product2Id,
                                                            QuoteId=parentQuoteId,
                                                            PriceBookEntryID=priceBookEntry.Id,       
                                                            Quantity=4,
                                                            UnitPrice = priceBookEntry.UnitPrice, 
                                                            ProductStage__c = 'Sold',
                                                            Funding__c = LGA_Constants.QLI_FUNDING_ASO,
                                                            Financing__c = LGA_Constants.JAA_FUNDING,
                                                            CEP_Indicator__c = LGA_Constants.QLI_CEP_INDICATOR_YES);
            
            qlineItemList.add(quoteLineItem);
            
        }
        return qlineItemList;
    }
    
    /**
@description : Method to generate Tax_ID__c
@return : list<Tax_ID__c>
@param : taxIdList
*/
    public static list<Tax_ID__c> generateTax(List<Id> taxIdList){
        List<Tax_ID__c> taxList = new List<Tax_ID__c>();
        for(Id accountId : TaxIdList ){
            Tax_ID__c tax = new Tax_ID__c(Account__c=accountId);
            taxlist.add(tax);
        }
        return taxlist;
        
    }
    
    /**
@description : Method to generate Single Email Message
@return : EmailMessage object
@param : fromAddress,toAddress, subject, relatedToId
*/
    public static EmailMessage generateEmailMessage(String fromAddress, String toAddress, String subject) {
        
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.FromAddress = fromAddress;
        emailMessage.Incoming = true;
        emailMessage.ToAddress = toAddress ;
        emailMessage.Subject = subject;        
        // emailMessage.ReplyToEmailMessageId = relatedToId;//Commented By Prabir for test class coverage
        
        return emailMessage;
    }
    
    /**
@description : Method to create Application_Document_Config__c
@return : Application_Document_Config__c object
*/
    public static Application_Document_Config__c createApplicationDocumentConfig(){
        
        Application_Document_Config__c adc=new Application_Document_Config__c();
        adc.Document_Order__c = 01;
        adc.Document_Name__c = 'Test';
        adc.State__c = 'California';
        adc.Profiles__c = 'System Administrator';
        adc.Required__c = true;
        adc.Implementation_Type__c = 'New Business';
        //adc.Line_Of_Business__c = 'Medical';
        adc.Underwriter__c = true;
        adc.Inactive__c = LGA_Constants.FALSEVALUE;
        adc.Files_Parameter__c = 'ICR';
        
        return adc;
    }///This object Application_Document_Config__c is not present in RUAT. Commented to deploy this class to RUAT.
    
    /**
@description : Method to create Application_Document_Checklist__c
@return : Opportunity
*/
    public static Opportunity insertOpportunity(){
        Opportunity testOpp = new Opportunity( Name = 'My Test Opp',
                                              StageName = 'Prospecting',
                                              CloseDate = System.today().addDays(4));
        //insert  testOpp
        return testOpp;
    }
    
    /**
@description : Method to create Application_Document_Checklist__c
@return : Application_Document_Checklist__c
*/
    @IsTest
    public static vlocity_ins__Application__c createApplication() {
        
        
        List<Id> accRecordTypeList = new List<Id>();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();         
        accRecordTypeList.add(accountRecordTypeId);
        List<Account> accountList = Anthem_TestDataFactory.generateAccount(accRecordTypeList);
        
        insert accountList;
        System.assertEquals([Select count() From Account],1, 'Hiii Success!!!');
        
        List<Id> oppRecordTypeList = new List<Id>();
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business Local').getRecordTypeId();
        oppRecordTypeList.add(opportunityRecordTypeId);
        List<Opportunity> oppList = Anthem_TestDataFactory.generateOpportunity(oppRecordTypeList,accountList.get(0).Id);        
        
        insert oppList; 
        
        vlocity_ins__Application__c testApplication = new vlocity_ins__Application__c(name='Test Application',AccountLegalName__c=accountList.get(0).Id,
                                                                                      vlocity_ins__OpportunityId__c=oppList.get(0).Id);
        return testApplication;
    }
    
    /**
@description : Method to create Application_Document_Checklist__c
@return : List of Application_Document_Checklist__c object
@param : testAccId
*/
    public static Group__c createGroup(Id testAccId){
        Group__c grp = new Group__c();
        grp.Account__c = testAccId;
        grp.Name = '231465';
        grp.Employee_Category__c='Active';
        
        return grp;
    }
    
    /**
@description : Method to create Application_Document_Checklist__c
@return : List of Application_Document_Checklist__c object
@param : qliIds, accountId, quoteId, oppId
*/
    public static List<Order> generateImplementationCase(Id qliIds,Id accountId, Id quoteId, Id oppId){
        
        List<Order>impCaseList = new List<Order>(); 
        
        Order order = new Order();
        order.Impacted_Products_Id__c=qliIds;
        order.AccountId=accountId;
        order.QuoteId = quoteId;
        order.OpportunityId = oppId;
        //Date date=Date.parse('2019-06-30');
        order.EffectiveDate = Date.newInstance(2016, 30, 6);
        order.Status='Draft';
        impCaseList.add(order);
        
        return impCaseList;
    }
    
    
    /****************************************************************
@description : Method to create GroupPlanDesing
@return : List of GroupPlanDesing object
@param : qliIds, accountId, quoteId, oppId
**********************************************************************/
    public static List<Order> groupPlanImplementationCase(Id accountId, Id quoteId, Id oppId, Id grpId, Id qliIds){
        
        List<Order>impCaseList1 = new List<Order>(); 
        
        Order order = new Order();
        order.Impacted_Products_Id__c=qliIds;
        order.AccountId=accountId;
        order.QuoteId = quoteId;
        order.OpportunityId = oppId;
        order.Group_Name__c = grpId;
        //Date date=Date.parse('2019-06-30');
        order.EffectiveDate = Date.newInstance(2016, 30, 6);
        order.Status='Draft';
        impCaseList1.add(order);
        
        return impCaseList1;
    }
    
    /**
@description : Method to create createEmployeeClass
@return : List of Employee_Class__c object
@param : grpId,count
*/
    public static  List<Employee_Class__c> createEmployeeClass(Id grpId, Integer count){
        
        List<Employee_Class__c> eslist = new List<Employee_Class__c>();
        Employee_Class__c emp;
        for(Integer i=1; i<=count; i++){
            emp = new Employee_Class__c();
            emp.Employee_Class_Name__c ='TestEmpdes'+ i;
            emp.Employee_Class_Type__c = 'Salary Class';
            emp.Group__c=grpId;
            eslist.add(emp);
        }
        return eslist;
    }
    /***
@description : Method to create GroupPlanDesing
@return : List of GroupPlanDesing object
@param : grpId,testAccId
*/
    
    public static List<Group_Plan_Design__c> createGroupPlan(Id empid,Id qliid, Id grpId, Id testAccId,Id orderId){
        List<Group_Plan_Design__c> gpdlist = New List<Group_Plan_Design__c>();
        Group_Plan_Design__c gpd= new Group_Plan_Design__c();
        Group__c grp = new Group__c();
        grp.Id = grpId;
        grp.Employee_Category__c = 'Active';
        gpd.Employee_Class_Record_ID__c = empid;
        gpd.QuoteLineItem_Record_ID__c = qliid;
        //gpd.Implementation_Case__c=orderId;
        gpd.Group__c=grpId;
        gpd.Account_Legal_Name__c=testAccId;
        gpd.Employee_Category__c= grp.Employee_Category__c;
        gpdlist.add(gpd);
        
        
        //gpd.Employee_Status_Description__c='Desc Test';
        
        
        return gpdlist;
    }   
    
    
    
    /**
@description : Method to create Implementation Case
@return : List of Order object
@param : accountId, quoteId, oppId, tstuserId
*/
    public static List<Order> generateImplementationCase1(Id accountId, Id quoteId, Id oppId, Id tstuserId){
        List<Order>impCaseList = new List<Order>();         
        Order testimpl = new Order();
        //testimpl.Impacted_Products_Id__c=qliIds;
        testimpl.Implementation_Case_Name__c = 'Test IMPL';
        testimpl.AccountId = accountId;
        testimpl.Status = 'Draft';
        testimpl.Implementation_Effective_Date__c = date.newInstance(2018, 07, 30);
        testimpl.Discovery_Call_Desired__c = 'Yes';
        testimpl.Account_Manager__c = tstUserId;
        testimpl.User_Group__c = 'Local New Business Local';
        testimpl.Implementation_Type__c = 'New Business';
        testimpl.EffectiveDate = date.newInstance(2019, 07, 30);
        testimpl.QuoteId = quoteId;
        testimpl.OpportunityId = oppId;
        
        impCaseList.add(testimpl);
        
        return impCaseList;
    }
    
    
    
    /**
@description : Method to create Implementation Case ***Added by Raptors
@return : List of Order object
@param : accountId, quoteId, oppId
*/
    public static List<Order> generateImplementationCase(Id accountId, Id quoteId, Id oppId){
        List<Order>impCaseList = new List<Order>();         
        Order testimpl = new Order();
        //testimpl.Impacted_Products_Id__c=qliIds;
        testimpl.Implementation_Case_Name__c = 'Test IMPL';
        testimpl.AccountId = accountId;
        testimpl.Status = 'Draft';
        testimpl.Implementation_Effective_Date__c = date.newInstance(2018, 07, 30);
        testimpl.Discovery_Call_Desired__c = 'Yes';
        testimpl.User_Group__c = 'Local New Business Local';
        testimpl.Implementation_Type__c = 'New Business';
        testimpl.EffectiveDate = date.newInstance(2019, 07, 30);
        testimpl.QuoteId = quoteId;
        testimpl.OpportunityId = oppId;
        impCaseList.add(testimpl);
        return impCaseList;
    }
    
    
    /**
@description : Method to create Implementation Case
@return : List of Order object
@param : accountId, quoteId, oppId
*/
    public static List<Order> generateImplementationCase(String impactedProductIds,Id accountId, Id quoteId, Id oppId, Id groupId){
        List<Order>impCaseList = new List<Order>();         
        Order testimpl = new Order();
        testimpl.Implementation_Case_Name__c = 'Test IMPL';
        testimpl.AccountId = accountId;
        testimpl.Status = 'Draft';
        testimpl.Implementation_Effective_Date__c = date.newInstance(2018, 07, 30);
        testimpl.Discovery_Call_Desired__c = 'Yes';
        testimpl.User_Group__c = 'Local New Business Local';
        testimpl.Implementation_Type__c = 'New Business';
        testimpl.EffectiveDate = date.newInstance(2019, 07, 30);
        testimpl.QuoteId = quoteId;
        testimpl.Group_Name__c = groupId;
        testimpl.OpportunityId = oppId;
        testimpl.Impacted_Products_Id__c = impactedProductIds;
        
        impCaseList.add(testimpl);
        
        return impCaseList;
    }
    
    /**
@description : Method to Create Documrnt Checklist for Rate Sheet
@return : List of Documents
@Param:ord Id
**/
    public static List<Application_Document_Checklist__c> generateDocumentChecklist(String ordId){
        List<Application_Document_Checklist__c> adcsList = new List<Application_Document_Checklist__c>();
        Application_Document_Checklist__c dclist = new Application_Document_Checklist__c();
        dclist.Implementation_Case__c = ordId;
        dclist.Document_Name__c = 'Medical Abacus Final Rate Sheet';
        dclist.File_Name__c = 'MED-ABACUS-FINALRATES.xlsx';
        dclist.Underwriter__c = true;
        adcsList.add(dclist);
        return adcsList;
    } 
    
    /**
@description : Method to create ContentVersion 
@return : List of ContentVersion object
*/
    
    public static ContentVersion insertContentVersion(){
        
        //String myString1 = TESTADATA_CONSTANT;
        //Blob beforeblob=Blob.valueOf(myString1);
        ContentVersion cv = new ContentVersion();
        cv.Title = 'MED-ABACUS-FINALRATES.Xlsx';
        cv.PathOnClient ='test';
        //cv.VersionData =beforeblob; 
        return cv;
    } 
    /**
@description : Method to create ContentDocumentLink
@return : List of ContentDocumentLink object
@param : adcId, DocumentId
*/
    public static List<ContentDocumentLink> generateContentDocumentLink(String adcId, Id docId){
        List<ContentDocumentLink>cdLinkList =  new List<ContentDocumentLink>();
        ContentDocumentLink cdLink = new ContentDocumentLink();
        cdLink.ContentDocumentId = docId;
        cdLink.LinkedEntityId =adcId;
        cdLink.ShareType = 'V';
        cdLink.Visibility = 'AllUsers';
        cdLinkList.add(cdlink);
        return cdLinkList;
    }
    
    /**
@description : Method to create Application_Document_Checklist__c
@return : List of Application_Document_Checklist__c object
@param : configId, appId
*/
    public static List<Application_Document_Checklist__c> createAppDocumentCheckList(Id configId){
        List<Application_Document_Checklist__c> adcList = new List<Application_Document_Checklist__c>();
        Application_Document_Checklist__c adc = new Application_Document_Checklist__c();
        adc.Document_Name__c='Quote Proposal';
        adc.File_Name__c='Test1.docx';
        adc.File_Size__c = '12345';
        adc.Required__c=true;
        adc.Application_Document_Config__c=configId;
        adcList.add(adc);
        return adcList;
        
    }////This object Application_Document_Checklist__c is not present in RUAT. Commented to deploy this class to RUAT.
    
    /**
@description : Method to create Application_Document_Checklist__c
@return : List of Application_Document_Checklist__c object
@param : parentQuoteId, productList, pricebookEntry
*/
    public static List<QuoteLineItem> generateQuoteLineItemByProductList(Id parentQuoteId,List<Product2> productList,Id pricebookEntry){
        List <QuoteLineItem> qlineItemList = new List<QuoteLineItem>();
        
        for(Product2 prd:productList){
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            //quoteLineItem.ParentQuoteLineItem__c = ;
            quoteLineItem.QuoteId = parentQuoteId;
            quoteLineItem.Product2Id = prd.id;
            quoteLineItem.Quantity = 4; 
            quoteLineItem.PriceBookEntryID = pricebookEntry;
            quoteLineItem.UnitPrice = 1;
            quoteLineItem.Prefix__c = 'AB';
            qlineItemList.add(quoteLineItem);
        }
        return qlineItemList;
    }
    
    
    public static Map<String,Object> generateQLIProductsJSON (){
        
        
        
        List<Object> medPlanProductNameList = new List<Object>();
        List<Object> medProductNameList = new List<Object>();
        List<Object> dentalProductNameList = new List<Object>();
        List<Object> visionProductNameList = new List<Object>();
        
        List<Object> fsaProductNameList = new List<Object>();
        List<Object> eapProductNameList = new List<Object>();
        
        Map<String,Object> medicalPlanObj1 = new Map<String,Object>();
        medicalPlanObj1.put('ProductName', 'BlueClassic PPO 5 20-1000/3500-80% $15/50/70/30% Essential Rx');
        medicalPlanObj1.put('ProductContractCode', null);
        medicalPlanObj1.put('ParentQuoteLineItem', 'Anthem HealthKeepers HSA 1400NE/10%/3577');
        
        Map<String,Object> medicalPlanObj2 = new Map<String,Object>();
        medicalPlanObj2.put('ProductName', 'Anthem HSA 1400NE/10%/3575');
        medicalPlanObj2.put('ProductContractCode', null);
        medicalPlanObj2.put('ParentQuoteLineItem', 'Well Priority Blue Priority - WI POS HIA Plus Option E-CSV with Rx Option C2');
        
        medPlanProductNameList.add(medicalPlanObj1);
        medPlanProductNameList.add(medicalPlanObj2);
        
        Map<String,Object> dentalObj1 = new Map<String,Object>();
        dentalObj1.put('ProductName', 'Choice Dental');
        
        Map<String,Object> dentalObj2 = new Map<String,Object>();
        dentalObj2.put('ProductName', 'Consumer Choice PPO');
        
        dentalProductNameList.add(dentalObj1);
        dentalProductNameList.add(dentalObj2);
        
        Map<String,Object> medProdObj1 = new Map<String,Object>();
        medProdObj1.put('ProductName', 'Anthem HSA 1400NE/10%/3575');
        medProdObj1.put('ParentQuoteLineItem', 'Anthem HSA 1400NE/10%/3575');
        
        
        Map<String,Object> ldObj1 = new Map<String,Object>();
        ldObj1.put('ProductName', 'Voluntary STD - PTO Vacation/Sick-time');        
        
        Map<String,Object> visionObj1 = new Map<String,Object>();
        visionObj1.put('ProductName', 'Blue View Vision');
        
        Map<String,Object> fsaObj1 = new Map<String,Object>();
        fsaObj1.put('ProductName', 'Flexible Spending Account');
        
        Map<String,Object> eapObj1 = new Map<String,Object>();
        eapObj1.put('ProductName', 'EAP');
        
        Map<String,Object> inputMap = new Map < String, Object >();
        
        inputMap.put('MedicalPlanQLI', medPlanProductNameList);
        inputMap.put('MedicalProductQLI', medProdObj1);
        inputMap.put('VisionQLI', visionObj1);
        inputMap.put('DentalQLI', dentalProductNameList);
        inputMap.put('FSAQLI', fsaObj1);
        inputMap.put('EAPQLI', eapObj1);
        inputMap.put('LifeDisabilityQLI', ldObj1);
        
        return inputMap;
    }
    public static List<Release__c> generateRelease (List<String> strRelNames ){
        List<Release__c> lstRelease = new List<Release__c>();
        for(String relname : strRelNames)
        {
            Release__c rel = new Release__c();
            rel.Name = relName;
            lstRelease.add(rel);
        }
        return lstRelease;
    }
    
    public static Request__c generateRequest(Map<String,String> requestObjValue){
        Request__c request = new Request__c();
        request.Release__c = requestObjValue.get('Release__c');
        request.Request_Type__c = requestObjValue.get('Request_Type__c');
        request.Request_Title__c = requestObjValue.get('Request_Title__c');
        request.Status__c = requestObjValue.get('Status__c');
        request.Related_Request__c = requestObjValue.get('Related_Request__c');
        request.StopTime_Identify_New_Requirement__c = null;
        return request;
    }
    
    /**********************************************************************
@description : Method to create Release__c as apart of PRDCRM-44932
@return : List of Release__c object

******************************************************************************/
    public static Release__c releaseSaasCreate (){
        // List<Release__c> lstRelease = new List<Release__c>();
        Release__c rel= new Release__c ();   
        rel.Name = 'Test Release Data';
        //rel.Id = null;
        rel.Plan_Start_Date__c = System.today();
        rel.Release_Planned_End_Date__c= System.today() + 10;
        rel.Status__c = 'Red';
        rel.Description__c = 'Test description ';
        // rel.add(rel);
        // insert rel;
        return rel;
        
    }  
    /****************************************************************************
@description : Method to create Value_Delivery_Session__c as apart of PRDCRM-44932
@return : List of Value_Delivery_Session__c object
@param : relId
**************************************************************************************/
    public static List<Value_Delivery_Session__c> valueDeliverySaasCreate  (Id relId ){
        List<Value_Delivery_Session__c> lstVds = new List<Value_Delivery_Session__c>();
        
        Value_Delivery_Session__c vds= new Value_Delivery_Session__c();
        vds.Description__c = 'test delivery data';
        vds.End_Date__c = System.today() + 10; 
        vds.Start_Time__c=system.now();
        vds.Releases__c = relId;
        
        lstVds.add(vds);
        return lstVds;
        
    }  
    /********************************************************************************
@description : Method to create Value_Delivery_Session_Outcomes__c as apart of PRDCRM-44932
@return : List of Value_Delivery_Session_Outcomes__c object
@param : vdsId
**********************************************************************************************/
    public static List< Value_Delivery_Session_Outcomes__c> valueDeliverySessionCreate  (Id vdsId ){
        List<Value_Delivery_Session_Outcomes__c> lstobjVDSO = new List<Value_Delivery_Session_Outcomes__c>();
        
        Value_Delivery_Session_Outcomes__c objVDSO = new Value_Delivery_Session_Outcomes__c();
        objVDSO.Name = 'Test outcome Data';
        objVDSO.Phase__c = 'Design';
        objVDSO.Start_Date__c = system.today();
        objVDSO.End_Date__c = system.today()+10;
        objVDSO.Session_Outcome__c = 'Test data preparation';
        objVDSO.Value_Delivery_Session__c = vdsId; 
        lstobjVDSO.add(objVDSO);  
        return lstobjVDSO;
    }
    /*****************************************************************
@description : Method to create Value_Delivery_Key_Participants__c as apart of PRDCRM-44932
@return : List of Value_Delivery_Key_Participants__c object
@param : objVDSO
*****************************************************************************/
    public static List< Value_Delivery_Key_Participants__c> valueDeliveryKeyCreate  (Id objVDSO){
        List<Value_Delivery_Key_Participants__c> lstVdp = new List<Value_Delivery_Key_Participants__c>(); 
        Value_Delivery_Key_Participants__c  vdp = new Value_Delivery_Key_Participants__c(); 
        vdp.name = 'TestName';
        vdp.Role__c = 'TestRole';
        vdp.Participant_Type__c = 'Accenture Team';
        vdp.Comments__c ='Test Comment';
        vdp.Session_Outcomes__c = objVDSO;
        lstVdp.add(vdp);
        
        Value_Delivery_Key_Participants__c vd = new Value_Delivery_Key_Participants__c();
        vd.name = 'TestNewName';
        vd.Role__c = 'TestNewRole';
        vd.Participant_Type__c = 'Accenture Team';
        vd.Comments__c ='TestNew Comment';
        vd.Session_Outcomes__c = objVDSO;
        lstVdp.add(vd);
        return lstVdp;
    }
    /**************************************************************
@description : Method to create Value_Delivery_User_Config__c as apart of PRDCRM-44932
@return : List of Value_Delivery_User_Config__c object
@param : lstVdp
**************************************************************************/
    
    public static List< Value_Delivery_User_Config__c> valueDeliveryUserCreate  (Id lstVdp){
        List<Value_Delivery_User_Config__c> lstVdu = new List<Value_Delivery_User_Config__c>(); 
        Value_Delivery_User_Config__c vdU = new Value_Delivery_User_Config__c();
        vdu.Name = 'TestUser';      
        vdu.Selected_Session__c= lstVdp;
        lstVdu.add(vdu);
        return lstVdu;
    }
    /*****************************************************************
@description : Method to create Product2 
@return : Product2 object
@param : name,prodtype,category,conCode,active
*****************************************************************************/
    public static Product2 createProduct(String name, String prodtype, String category, String conCode, Boolean active){
        
        Product2 product = new Product2(Name= name,
                                        Product_Type__c = prodtype,
                                        Category__c = category,
                                        Contract_Code__c = conCode,
                                        IsActive = active); 
        
        return product;
        
    } 
    
    
    /*****************************************************************
@description : Method to create Group plan designs 
@return : Group Plan designs
@param : List<Id> qliIds, List<Id> empClassIds, Id accountId, Id groupId
*****************************************************************************/
    public static List<Group_Plan_Design__c> generateGroupPlanDesigns(List<Employee_Class__c> empClasses, List<QuoteLineItem> quoteLineItems, Id accountId, Id groupId){
        List<Group_Plan_Design__c> gpdToInsertList = new List<Group_Plan_Design__c>();
        for(QuoteLineItem qli : quoteLineItems){
            for(Employee_Class__c empClass : empClasses){
                Group_Plan_Design__c gpd = new Group_Plan_Design__c();  
                gpd.Employee_Class_Record_ID__c = empClass.Id;
                gpd.QuoteLineItem_Record_ID__c  = qli.Id;
                gpd.Group__c = groupId;
                gpd.Employee_Category__c = 'Active';
                gpd.Account_Legal_Name__c = accountId;
                gpd.Is_Active_Indicator__c = true;
                gpdToInsertList.add(gpd);
            }
        }
        
        return gpdToInsertList;
    } 
}