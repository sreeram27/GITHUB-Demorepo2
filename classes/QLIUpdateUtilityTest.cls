@isTest
public class QLIUpdateUtilityTest {
    @testSetup static void setup() {
        Id i=[SELECT DeveloperName, Id, SobjectType, IsActive FROM RecordType where SobjectType='Account' and DeveloperName='Brokerage'].Id;
        Account parentacc =new Account();
        parentacc.recordtypeid=i;
        parentacc.Name = 'test2';
        parentacc.Anthem_Entity__c = 'Local/Large Group';
        insert parentacc;
        
        Account acc1 = new Account(Name = 'test1',
                                   Region__c = 'West',
                                   Anthem_Entity__c = 'Local/Large Group',
                                   parentid=parentacc.id,NASCO_Contracting_Situs_State__c='60 CO',WGS_Contracting_Situs_State__c='CA California');
        
        insert acc1;
        
        system.assert(acc1.id!=null);
        
        Group__c g=new Group__c();
        g.name='test group';
        g.Account__c=acc1.id;
        insert g;
        system.assert(g.id!=null);
        Id recid=[SELECT DeveloperName, Id, SobjectType, IsActive FROM RecordType where SobjectType='Account' and DeveloperName='ServiceProvider'].Id;
        
        Account acc2 = new Account(Name = 'testcompetitor',
                                   Region__c = 'West',
                                   Anthem_Entity__c = 'Local/Large Group',
                                   recordtypeid=recid,Competitor__c=true,NASCO_Contracting_Situs_State__c='60 CO',WGS_Contracting_Situs_State__c='CA California');
        
        insert acc2;
        
        
        Brokerage_and_Consultant__c brokcons=new Brokerage_and_Consultant__c(Account__c=acc1.id,Brokerage__c=parentacc.id);
        insert brokcons;
        
        Opportunity opp1 = new Opportunity(Name = 'test opp',
                                           AccountId = acc1.id,
                                           StageName = 'Initiated',closedate=date.newInstance(2020, 01, 01));
        
        insert opp1;
        
        Product2 prod = new Product2(Category__c = 'Product', Name = 'Castlight - Buy Up Products',vlocity_ins__SubType__c='Other',
                                     IsActive = true,LOB__c='Medical',product_type__c='Health and Wellness',productActive__c = true);
        insert prod;
        
        Product2 parentProd1 = new Product2(Category__c = 'Product', Name = 'Castlight - Buy Up Products',vlocity_ins__SubType__c='Other',
                                            IsActive = true,LOB__c='Medical',productActive__c = true);
        insert parentProd1;
        
        Product2 prod1 = new Product2(Name = 'Castlight - Buy Up Products',vlocity_ins__SubType__c='Other',product_type__c='Medical',
                                      IsActive = true,LOB__c='Medical',vlocity_ins__ProductSpecId__c=prod.Id,
                                      Contract_code__c='3MU2',vlocity_ins__EffectiveDate__c = Date.today(),productActive__c = true);
        insert prod1;
        
        Product2 prod2 = new Product2(Name = 'Castlight - Buy Up Products',vlocity_ins__SubType__c='Other',product_type__c='Medical',
                                      IsActive = true,LOB__c='Medical',vlocity_ins__ProductSpecId__c=prod.Id,
                                      Contract_code__c='3MU3',vlocity_ins__EffectiveDate__c = Date.today(),productActive__c = true);
          insert prod2;
        Product2 prod4 = new Product2(Name = 'Castlight - Buy Up Products2',vlocity_ins__SubType__c='Other',
                                      IsActive = true,LOB__c='Medical',vlocity_ins__ProductSpecId__c=prod.Id,
                                      Contract_code__c='3MU3',vlocity_ins__EffectiveDate__c = Date.today(),productActive__c = true);
  
        insert prod4;
        
        Product2 prod3 = new Product2(Name = 'Castlight - Buy Up Products',vlocity_ins__SubType__c='Other',
                                      IsActive = true,LOB__c='Medical',vlocity_ins__ProductSpecId__c=parentProd1.Id,
                                      Contract_code__c='3MU6',vlocity_ins__EffectiveDate__c = Date.today(),productActive__c = true);
        insert prod3;
        
        
        system.assert(prod.id!=null);
        Id pricebookId = Test.getStandardPricebookId();
        
        
        PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                          Product2Id = prod.Id,
                                                          UnitPrice = 10000, IsActive = true);
        
        insert standardPrice;
        
        PricebookEntry standardPrice1 = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                           Product2Id = prod1.Id,
                                                           UnitPrice = 20000, IsActive = true);
        insert  standardPrice1;
        PricebookEntry standardPrice2 = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                           Product2Id = prod2.Id,
                                                           UnitPrice = 20000, IsActive = true);
        insert  standardPrice2;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        
        insert customPB;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = parentProd1.Id,
                                                 UnitPrice = 12000, IsActive = true);
        
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,
                                                 UnitPrice = 12000, IsActive = true);
        
        insert pbe2;

        Quote q1 = new Quote(Name = 'test Quote',
                             Pricebook2Id = pricebookId,
                             OpportunityId = opp1.Id,GroupNumber__c=g.id);
        
        insert q1;
        
        /* PricebookEntry pbeforQuote = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = q1.Id,
        UnitPrice = 12000, IsActive = true);
        
        insert pbeforQuote;*/
        
        system.assert(q1.id!=null);
        
        QuoteLineItem qli2 = new QuoteLineItem(Subscribers__c = 12, 
                                               Reason__c='Funding Type Change',
                                               Probability__c='15%',
                                               ProductStage__c='In Progress',
                                               Members__c = 10,
                                               QuoteId = q1.Id,
                                               Product2Id = prod1.Id,
                                               PricebookEntryId = standardPrice.Id,
                                               Quantity = 10,
                                               Unitprice = 10.00,Competitor__c=acc2.id,vlocity_ins__ContractCode__c='3MU2');
        insert qli2;
        
        QuoteLineItem qli1 = new QuoteLineItem(Subscribers__c = 13, 
                                               Reason__c='Funding Type Change',
                                               Probability__c='15%',
                                               ProductStage__c='In Progress',
                                               Members__c = 10,
                                               QuoteId = q1.Id,
                                               Product2Id = prod1.Id,
                                               PricebookEntryId = standardPrice.Id,
                                               Quantity = 10,
                                               ParentQuoteLineItem__c = qli2.id,
                                               Unitprice = 10.00,Competitor__c=acc2.id,vlocity_ins__ContractCode__c='3MU2');
        
        insert qli1;
        
        QuoteLineItem qli3 = new QuoteLineItem(Subscribers__c = 9, 
                                               Reason__c='Funding Type Change',
                                               Probability__c='15%',
                                               ProductStage__c='In Progress',
                                               Members__c = 10,
                                               QuoteId = q1.Id,
                                               Product2Id = prod2.Id,
                                               PricebookEntryId = standardPrice.Id,
                                               Quantity = 10,
                                               ParentQuoteLineItem__c = qli2.id,
                                               Unitprice = 10.00,Competitor__c=acc2.id,vlocity_ins__ContractCode__c='3MU3');
        
        insert qli3;
        QuoteLineItem qli4 = new QuoteLineItem(Subscribers__c = 10, 
                                               Reason__c='Funding Type Change',
                                               Probability__c='15%',
                                               ProductStage__c='In Progress',
                                               Members__c = 10,
                                               QuoteId = q1.Id,
                                               Product2Id = prod2.Id,
                                               PricebookEntryId = standardPrice.Id,
                                               Quantity = 10,
                                               SFDCLegacyID__c = 'TEMPID',
                                               Unitprice = 10.00,Competitor__c=acc2.id,vlocity_ins__ContractCode__c='3MU3',
                                               ParentQuoteLineItem__c = qli2.id);
        
        insert qli4;
        QuoteLineItem parentQLI = new QuoteLineItem(Subscribers__c = 6, 
                                                    Reason__c='Funding Type Change',
                                                    Probability__c='15%',
                                                    ProductStage__c='In Progress',
                                                    Members__c = 10,
                                                    QuoteId = q1.Id,
                                                    Product2Id = prod.Id,
                                                    PricebookEntryId = standardPrice.Id,
                                                    Quantity = 10,
                                                    SFDCLegacyID__c = 'TEMPID',
                                                    Unitprice = 10.00,Competitor__c=acc2.id);
        insert parentQLI;
        
        
        
        QuoteLineItem qli5 = new QuoteLineItem(Subscribers__c = 14, 
                                               Reason__c='Funding Type Change',
                                               Probability__c='15%',
                                               ProductStage__c='In Progress',
                                               Members__c = 10,
                                               QuoteId = q1.Id,
                                               Product2Id = prod2.Id,
                                               PricebookEntryId = standardPrice.Id,
                                               Quantity = 10,
                                               SFDCLegacyID__c = 'TEMPID',
                                               Unitprice = 10.00,Competitor__c=acc2.id,
                                               parentQuoteLineItem__C= parentQLI.id,vlocity_ins__ContractCode__c='3MU2');
        
        insert qli5;
        
         QuoteLineItem qli6 = new QuoteLineItem(Subscribers__c = 15, 
                                               Reason__c='Funding Type Change',
                                               Probability__c='15%',
                                               ProductStage__c='In Progress',
                                               Members__c = 10,
                                               QuoteId = q1.Id,
                                               Product2Id = prod.Id,
                                               PricebookEntryId = standardPrice.Id,
                                               Quantity = 10,
                                               SFDCLegacyID__c = 'TEMPID',
                                               Unitprice = 10.00,Competitor__c=acc2.id,
                                               ParentQuoteLineItem__c= parentQLI.id,vlocity_ins__ContractCode__c='3MU2');
        
        insert qli6;
        
         QuoteLineItem qli7 = new QuoteLineItem(Subscribers__c = 16, 
                                               Reason__c='Funding Type Change',
                                               Probability__c='15%',
                                               ProductStage__c='In Progress',
                                               Members__c = 10,
                                               QuoteId = q1.Id,
                                               Product2Id = prod.Id,
                                               PricebookEntryId = standardPrice.Id,
                                               Quantity = 10,
                                               SFDCLegacyID__c = 'TEMPID',
                                               Unitprice = 10.00,Competitor__c=acc2.id,
                                               ParentQuoteLineItem__c= qli6.id,vlocity_ins__ContractCode__c='3MU9');
        
        insert qli7;
        system.assert(qli1.id!=null); 
        
        QuoteLineItemRates__c rates = new QuoteLineItemRates__c (QuoteLineItem__c=qli5.id);
        insert rates;
        system.assert(rates.id!=null); 
        IntegrationTestDataUtilty.loadCustomSettings();
    }
     @isTest
    static void updateLegacyQLIProductWithParentQLITest()
    {
         QuoteLineItem qliRec = [select id,QuoteId,Contract_code__c,ParentQuoteLineItem__c from QuoteLineItem where ParentQuoteLineItem__c!= null and Subscribers__c = 9 LIMIT 1];
        QLIUpdateUtility qliutil = new QLIUpdateUtility();
        QLIUpdateUtility.QLIUpdateStatus QLIStatus = qliutil.updateQLIProduct(qliRec.Id,'3MU2');
        system.assert(QLIStatus.StatusCode=='SUCCESS'); 
           
    }
     @isTest
    static  void updateLegacyQLIProductWithoutParentQLITest()
    {
         QuoteLineItem qliRec = [select id,QuoteId,Contract_code__c,ParentQuoteLineItem__c from QuoteLineItem where Subscribers__c = 10 LIMIT 1];
        QLIUpdateUtility qliutil = new QLIUpdateUtility();
        QLIUpdateUtility.QLIUpdateStatus QLIStatus = qliutil.updateQLIProduct(qliRec.Id,'3MU2');
        system.assert(QLIStatus.StatusCode=='SUCCESS'); 
           
    }
     @isTest
    static  void updateLegacyQLIProductWithoutProdTest()
    {
         QuoteLineItem qliRec = [select id,QuoteId,Contract_code__c,ParentQuoteLineItem__c from QuoteLineItem where Subscribers__c = 10 LIMIT 1];
        QLIUpdateUtility qliutil = new QLIUpdateUtility();
        QLIUpdateUtility.QLIUpdateStatus QLIStatus = qliutil.updateQLIProduct(qliRec.Id,'Test');
        system.assert(QLIStatus.StatusCode=='ERROR'); 
        system.assert(QLIStatus.StatusMessage.contains('No active product found with contract code')); 
           
    }
     @isTest
    static  void updateLegacyQLIProductWithoutQLITest()
    {
        QuoteLineItem qliRec = [select id,QuoteId,Contract_code__c,ParentQuoteLineItem__c from QuoteLineItem where Subscribers__c = 10 LIMIT 1];
        QLIUpdateUtility qliutil = new QLIUpdateUtility();
        QLIUpdateUtility.QLIUpdateStatus QLIStatus = qliutil.updateQLIProduct('0QL54000000AivVGbd','3MU2');
        system.assert(QLIStatus.StatusCode=='ERROR'); 
        system.assert(QLIStatus.StatusMessage.contains('No QuotelineItem record found with QLI Id')); 
           
    }
     @isTest
    static  void updateLegacyQLIProductWithChildQLITest()
    {
         QuoteLineItem qliRec = [select id,QuoteId,Contract_code__c,ParentQuoteLineItem__c from QuoteLineItem where Subscribers__c = 12 LIMIT 1];
        QLIUpdateUtility qliutil = new QLIUpdateUtility();
        QLIUpdateUtility.QLIUpdateStatus QLIStatus = qliutil.updateQLIProduct(qliRec.Id,'3MU2');
        system.assert(QLIStatus.StatusCode=='ERROR'); 
        system.assert(QLIStatus.StatusMessage.contains('Child record exists for given QLI Id')); 
           												
    }
     @isTest
    static  void updateLegacyQLIProductWithLinkedContCodeTest()
    {
         QuoteLineItem qliRec = [select id,QuoteId,Contract_code__c,ParentQuoteLineItem__c from QuoteLineItem where Subscribers__c = 13 LIMIT 1];
        QLIUpdateUtility qliutil = new QLIUpdateUtility();
        QLIUpdateUtility.QLIUpdateStatus QLIStatus = qliutil.updateQLIProduct(qliRec.Id,'3MU2');
        system.assert(QLIStatus.StatusCode=='ERROR'); 
        system.assert(QLIStatus.StatusMessage.contains('Quote Line record is already linked to contract code')); 
           
    }
    
    @isTest
    static void testUpdateQliForProdSelection()
    {
         QuoteLineItem qliRec = [select id,QuoteId,vlocity_ins__ContractCode__c,Contract_code__c,ParentQuoteLineItem__c from QuoteLineItem where Subscribers__c = 14 LIMIT 1];
         List<QuoteLineItem> qliList = new List<QuoteLineItem>();
         qliList.add(qliRec);
         ANA_UTIL01_TestMethods.createPSDRecord(qliList,true);
          List<ProductSelectionDetail__c> prodSelectionQliList = [SELECT id,QuoteLineItem__c 
                                                                FROM ProductSelectionDetail__c
                                                               WHERE QuoteLineItem__c=:qliRec.Id LIMIT 1];
        System.debug('Prod Selection size details: '+prodSelectionQliList.size()+ prodSelectionQliList[0].QuoteLineItem__c);
        System.debug('QLI Actual Id Old :'+ qliRec.Id);
        QLIUpdateUtility qliutil = new QLIUpdateUtility();
        QLIUpdateUtility.QLIUpdateStatus QLIStatus = qliutil.updateQLIProduct(qliRec.Id,'3MU2');
        system.assert(QLIStatus.StatusCode=='SUCCESS'); 
    }
    
    @isTest
	static void testUpdateQliForRates()
    {
        QuoteLineItem qliRec = [select id,QuoteId,vlocity_ins__ContractCode__c,Contract_code__c,ParentQuoteLineItem__c from QuoteLineItem where Subscribers__c = 10 LIMIT 1];
        QLIUpdateUtility qliutil = new QLIUpdateUtility();
        QLIUpdateUtility.QLIUpdateStatus QLIStatus = qliutil.updateQLIProduct(qliRec.Id,'3MU6');
        system.assert(QLIStatus.StatusCode=='SUCCESS'); 
    }
    
    @isTest
	static void testUpdateParentQLIForChild()
    {
        QuoteLineItem qliRec = [select id,QuoteId,vlocity_ins__ContractCode__c,Contract_code__c,ParentQuoteLineItem__c from QuoteLineItem where Subscribers__c = 15 LIMIT 1];
        QLIUpdateUtility qliutil = new QLIUpdateUtility();
        QLIUpdateUtility.QLIUpdateStatus QLIStatus = qliutil.updateQLIProduct(qliRec.Id,'3MU6');
        system.assert(QLIStatus.StatusCode=='SUCCESS'); 
    }
}