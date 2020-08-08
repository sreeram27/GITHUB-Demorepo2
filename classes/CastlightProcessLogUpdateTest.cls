@isTest(seealldata=true)
public class CastlightProcessLogUpdateTest {
    
    @isTest static void statusUpdateTest()
    {
        
        Test.startTest();
        List<Id> oppList = new List<Id>();
        Account acc1 = new Account(Name = 'test1',
                                   Region__c = 'West',
                                   Anthem_Entity__c = 'National Accounts');
        
        insert acc1;
        Opportunity opp1 = new Opportunity(CloseDate = system.today(),
                                           Name = 'test opp1',
                                           AccountId = acc1.id,
                                           StageName = 'Engage');
        insert opp1;
        oppList.add(opp1.Id);
        Opportunity opp2 = new Opportunity(CloseDate = system.today(),
                                           Name = 'test opp2',
                                           AccountId = acc1.id,
                                           StageName = 'Engage');
        insert opp2;
        oppList.add(opp2.Id);Group__c grp1 = new Group__c(Name='tet41',Account__c=acc1.id,ClaimSystem__c = 'NASCO');
        insert grp1;
        
        
        Group__c grp2 = new Group__c(Name='tet41',Account__c=acc1.id,ClaimSystem__c = 'WGS 2.0');
        insert grp2;  
        
        Pricebook2 standardPB = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 prb= new  Pricebook2(Name='Test',Description ='Price Book Products',IsActive = true);
        insert prb;
        Product2 prod = new Product2(Name = 'productName',isActive=true);
        insert prod;
        
        Product2 prodmed = new Product2(Name = 'Medical - POS',isActive=true);
        insert prodmed;
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, 
                                                          Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        Quote quoteRec = new Quote(Name = 'Test Quote',OpportunityId = opp1.Id,GroupNumber__c=grp1.id,Pricebook2Id = standardPB.Id);
        insert quoteRec;
        QuoteLineItem qli1 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli1);
        QuoteLineItem qli2 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli2);
        QuoteLineItem qli3 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli3);
        QuoteLineItem qli4 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli4);
        QuoteLineItem qli5 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli5);
        QuoteLineItem qli6 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli6);
        QuoteLineItem qli7 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli7);
        QuoteLineItem qli8 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli8);
        QuoteLineItem qli9 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli9);
        QuoteLineItem qli10 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli10);
        QuoteLineItem qli11 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli11);
        QuoteLineItem qli12 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli12);
        QuoteLineItem qli13 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli13);
        QuoteLineItem qli14 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli14);
        QuoteLineItem qli15 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli15);
        QuoteLineItem qli16 = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
        qliList.add(qli16);
        
        insert qliList;
        
        CSLT_Integration_Process_Log__c log = new CSLT_Integration_Process_Log__c();
        log.OpportunityId__c = opp1.Id;
        log.Send_update__c = false;
        
        insert log;
        
        CastlightProcessLogUpdate.StatusUpdate(oppList);
        Test.stopTest();
        
        List<CSLT_Integration_Process_Log__c> updatedLogList = [SELECT Send_Update__c from CSLT_Integration_Process_Log__c where OpportunityId__c IN :oppList];
        for(CSLT_Integration_Process_Log__c updatedLog : updatedLogList)
        {
            System.assertEquals(true,updatedLog.Send_update__c);            
        }
        
    }
    
}