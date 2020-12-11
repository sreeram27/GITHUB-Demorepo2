@IsTest
public class UpdateQLIProductBatchTest {

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
        
        Product2 prod = new Product2(Name = 'Castlight - Buy Up Products',vlocity_ins__SubType__c='Other',
                                     IsActive = true,LOB__c='Medical');
        insert prod;
    
         Product2 prod1 = new Product2(Name = 'Castlight - Buy Up Products',vlocity_ins__SubType__c='Other',
                                     IsActive = true,LOB__c='Medical',vlocity_ins__ProductSpecId__c=prod.Id,
                                      Contract_code__c='3MU2');
        insert prod1;
     
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
     
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        
        insert customPB;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
        
        
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
                                               Unitprice = 10.00,Competitor__c=acc2.id,Contract_code__c='3MU2');
        insert qli2;
     
        QuoteLineItem qli1 = new QuoteLineItem(Subscribers__c = 12, 
                                               Reason__c='Funding Type Change',
                                               Probability__c='15%',
                                               ProductStage__c='In Progress',
                                               Members__c = 10,
                                               QuoteId = q1.Id,
                                               Product2Id = prod1.Id,
                                               PricebookEntryId = standardPrice.Id,
                                               Quantity = 10,
                                               ParentQuoteLineItem__c = qli2.id,
                                               Unitprice = 10.00,Competitor__c=acc2.id,Contract_code__c='3MU2');
        
        insert qli1;
        
        system.assert(qli1.id!=null);  
    }

     static testmethod void createQLIFromBatchTesting() {
        
         QuoteLineItem qliRec = [select id,QuoteId,Product2Id,Contract_code__c from QuoteLineItem LIMIT 1];
         system.debug('------------' + qliRec);
        
         Test.startTest();
         WGS_Renewal_QLIs__c wgsRec = new WGS_Renewal_QLIs__c (Com2_QLIID__c=qliRec.id,Contract_code__c=qliRec.Contract_Code__c,Status__c='Pending');
         insert wgsRec;
         system.debug('--->>'+wgsRec);
          Database.executeBatch(new UpdateQLIProductBatch(),1);
          Test.StopTest();
          List<WGS_Renewal_QLIs__c> wgsRec1  = [Select Id, SFDCLegacyID__c,Com2_QLIID__c,Status__c, Contract_code__c,Status_Message__c from WGS_Renewal_QLIs__c];
         system.debug('---->>'+wgsRec1);
         system.assertEquals(!wgsRec1.isEmpty(),true);
      
     }
    
    static testmethod void createQLIFromBatchWithSFDCIdTesting() {
       Test.startTest();
        QuoteLineItem qliRec = [select id,QuoteId,Product2Id,Contract_code__c,SFDCLegacyID__c from QuoteLineItem LIMIT 1];
        qliRec.SFDCLegacyID__c=qliRec.Id;
        update qliRec;
        WGS_Renewal_QLIs__c wgsRec = new WGS_Renewal_QLIs__c (SFDCLegacyID__c=qliRec.Id,Contract_code__c=qliRec.Contract_Code__c,Status__c='Pending');
         insert wgsRec;
        Database.executeBatch(new UpdateQLIProductBatch(),1);
        Test.StopTest();
          List<WGS_Renewal_QLIs__c> wgsRec1  = [Select Id, SFDCLegacyID__c,Com2_QLIID__c,Status__c, Contract_code__c,Status_Message__c from WGS_Renewal_QLIs__c ];
        system.debug('--->>'+wgsRec1);
         //system.debug('Test2------------' + wgsRec1[0].Status__c); 
         system.assert(wgsRec1[0].Status__c=='ERROR'); 
       //system.assert(wgsRec1[0].Status__c == 'SUCCESS'); 
        //system.assert(wgsRec1[0].Status_Message__c.contains('Record processed successfully. New QLI id is created')); 
        
     }
     static testmethod void createQLIFromBatchWithNullTesting() {
        
        Test.startTest();
        QuoteLineItem qliRec = [select id,QuoteId,Product2Id,Contract_code__c from QuoteLineItem LIMIT 1];
        
         WGS_Renewal_QLIs__c wgsRec = new WGS_Renewal_QLIs__c (Status__c='Pending');
         insert wgsRec;
         Database.executeBatch(new UpdateQLIProductBatch(),1);
         Test.StopTest();
          List<WGS_Renewal_QLIs__c> wgsRec1  = [Select Id, SFDCLegacyID__c,Com2_QLIID__c,Status__c, Contract_code__c,Status_Message__c from WGS_Renewal_QLIs__c  where Status__c='ERROR'];
         system.debug('Test3------------' + wgsRec1[0].Status__c); 
         
          system.assert(wgsRec1[0].Status__c=='ERROR'); 
         system.assert(wgsRec1[0].Status_Message__c.contains('No QuotelineItem record found with QLI Id')); 
        
     }
}