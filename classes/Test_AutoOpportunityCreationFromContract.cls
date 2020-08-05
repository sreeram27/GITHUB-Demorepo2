@isTest
public class Test_AutoOpportunityCreationFromContract {
    @isTest
    public static void Method_AutoOpportunityCreation(){
        List<Account> accList  = new List<Account>();
       OpportunityLineItem ol = new OpportunityLineItem();
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        PricebookEntry pbID = [select Id, name from PricebookEntry where isActive = True limit 1];
        
       Account acc = new Account(Name= 'test',Primary_Email__c = 'test@gmail.com',  Business_Unit__c = 'AutoRABIT',Phone='123654789');
        accList.add(acc);
        insert accList;
        
        contact contactInfo = new Contact(LastName = 'Test xyz',Accountid = accList[0].id,Phone= '541154122',email = 'Test123@gmail.com');
        insert contactInfo;
        
        Opportunity oppInfo = new Opportunity(Contract_Type__c = 'Annual Contract',Name = 'TEST-New',Accountid = accList[0].id,contactid = contactinfo.Id,Competitors__c = 'Copado',Opportunity_Type_New_Renewal_Upsell__c= 'Renewal',StageName= 'Free POC',CloseDate=Date.newInstance(2020, 12, 9),Active_Oppty__c=True,Premium_Support__c='Yes',Plan_Details__c='Enterprise',Hosting_Type__c='Dedicated',   Tentative_Activation_Date__c =Date.newInstance(2020, 12, 9),Any_commitments_from_AR__c='Test');
        insert oppInfo;
        
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = oppInfo.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = pbEntry.UnitPrice
        );
        insert oli;
        
        Contract contractInfo  = new Contract(Account_ID__c = 'Axybecd28',AccountId = accList[0].id,Opportunity__c = oppinfo.id,	Contract_End_Date__c = system.today() + 90);
        insert contractInfo;
        
        
        Test.startTest();
        Database.executeBatch(new AutoOpportunityCreationFromContract());
        System.schedule('Test','0 0 * * * ?', new AutoOpportunityCreationFromContract());
        Test.stopTest();
    }
}