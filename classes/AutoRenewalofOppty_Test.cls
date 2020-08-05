@isTest
public class AutoRenewalofOppty_Test {
    public static testMethod void testRunAs(){       
        try{
            Account acc = new Account(Name='Test');
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'Test - Con';
            con.Email = 'tets@test.com';
            insert con;
            
            Pricebook2 pbk1 = new Pricebook2();
            pbk1.Name='Test Pricebook Entry 1';
            pbk1.Description='Test Pricebook Entry 1';
            pbk1.isActive=true;
            insert pbk1;
            
            //get standard pricebook
            Pricebook2  standardPb = [select id, name, isActive from Pricebook2 limit 1];
            
            Product2 prd1 = new Product2();
            prd1.Name='Test Product Entry 1';
            prd1.Description='Test Product Entry 1';
            prd1.productCode = 'ABC';
            prd1.isActive = true;
            insert prd1;
            
            
            PricebookEntry pbe1 = new PricebookEntry();
            pbe1.Product2ID=prd1.id;
            pbe1.Pricebook2ID=standardPb.id;
            pbe1.UnitPrice=50;
            pbe1.isActive=true;
            //insert pbe1;
            
            
            Opportunity opp1 = new Opportunity();
            opp1.Name='Opp1';
            opp1.StageName='Closed Won';
            opp1.CloseDate=Date.today()-275;
            opp1.Opportunity_Type_New_Renewal_Upsell__c = 'Renewal';
            opp1.Partner_Sourced__c = 'No';
            opp1.Pricebook2Id = pbe1.Pricebook2Id;
            opp1.AccountId = acc.id;
            opp1.ContactId = con.Id;
            insert opp1;
            
            /*
OpportunityLineItem lineItem1 = new OpportunityLineItem ();
lineItem1.OpportunityID = opp1.id;
lineItem1.PriceBookEntryID=pbe1.id; 
lineItem1.quantity=4;
lineItem1.totalprice=200;
insert lineItem1;

list<Opportunity> test = [select id,Name,CloseDate,AccountId,StageName,(select id,Name,pricebookEntryId,Product2.Renewal_Product__c,Product2.Id,Product2.IsActive,Quantity,UnitPrice,OpportunityId from OpportunityLineItems) from opportunity WHERE CloseDate = LAST_N_DAYS:275 AND (StageName = 'Closed Won' OR StageName = 'Closed Won - Implementation Incomplete')]; 
system.debug('Test::'+test.size());*/
            
            
            test.starttest();
            database.executeBatch(new AutoRenewalOfOppty()) ;
            
            SchedularForBatchApexRenewalOppty.SchedulerMethod();
            
            SchedularForBatchApexRenewalOppty sh1 = new SchedularForBatchApexRenewalOppty();
            
            String sch = '0 0 * * * ?'; system.schedule('Test Territory Check', sch, sh1);
            test.stoptest();
            
        }
        
        catch(exception e)
        {
            system.debug('Test::'+e);
        }
        
        
    }
}