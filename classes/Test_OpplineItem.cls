@istest
public class Test_OpplineItem {
    
    
    static testmethod void  PopulateExtensiontest(){
        
        Date closeDt = Date.Today();
        
        date myDate = date.today();
        
        Account a2 = new Account(Name ='icrm testing acc');
        insert a2;
        
        opportunity oppr = new opportunity(Name='testing DIE 4/6/2015' ,  AccountId= a2.Id,StageName = 'Prospecting', 
                                           CloseDate = closeDt);
        insert oppr;
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = oppr.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 500
        );
        insert oli;
        System.debug('oli'+oli);
    }
}