@isTest
public class AccountHandler_Test {
    @isTest
    Public static void CreateContractTest_Method(){
        
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
        
        Opportunity oppInfo = new Opportunity(Contract_Type__c = 'Annual Contract',Name = 'TEST-New',Accountid = accList[0].id,contactid = contactinfo.Id,Competitors__c = 'Copado',Opportunity_Type_New_Renewal_Upsell__c= 'New Logo',StageName= 'Free POC',CloseDate=Date.newInstance(2020, 12, 9),Active_Oppty__c=True,Premium_Support__c='Yes',Plan_Details__c='Enterprise',Hosting_Type__c='Dedicated',   Tentative_Activation_Date__c =Date.newInstance(2020, 12, 9),Any_commitments_from_AR__c='Test');
        insert oppInfo;
        
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = oppInfo.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = pbEntry.UnitPrice
        );
        insert oli;
        
       
        
        Opportunity updatableoppInfo = [select id,Current_Subs__c, stageName,Professional_Services_hours__c from Opportunity where id = : oppInfo.id];
        
        updatableoppInfo.stageName = 'Closed Won';
        UpdatableOppInfo.Professional_Services_hours__c = 10;
        UpdatableOppInfo.Current_Subs__c = 15;
        Update updatableoppInfo;
        
        
        Opportunity oppInfo1 = new opportunity(Contract_Type__c = 'Annual Contract',Active_Oppty__c=True,Name = 'TEST-New 1',Accountid = accList[0].id,contactid = contactinfo.Id,Competitors__c = 'Copado',Opportunity_Type_New_Renewal_Upsell__c = 'New Logo',StageName= 'Free POC',CloseDate=Date.newInstance(2020, 12, 9),Premium_Support__c='Yes',Plan_Details__c='Enterprise',Hosting_Type__c='Dedicated',   Tentative_Activation_Date__c =Date.newInstance(2020, 12, 9),Any_commitments_from_AR__c='Test');
        insert oppInfo1;
        
        OpportunityLineItem oli1 = new OpportunityLineItem(
            OpportunityId = oppInfo1.Id,
            Quantity = 10,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = pbEntry.UnitPrice
        );
        insert oli1;
        
        
        Opportunity updatableoppInfo1 = [select id,Accountid, stageName,Current_Subs__c,Professional_Services_hours__c from Opportunity where id = : oppInfo1.id];
        updatableoppInfo1.stageName = 'Closed Won';
        updatableoppInfo1.Current_Subs__c = 10;
        updatableoppInfo1.Professional_Services_hours__c = 12; 
        Update updatableoppInfo1;
        
        Contract contractinfo = new Contract(accountid=updatableoppInfo1.AccountId,Account_ID__c='1232145',Opportunity__c=updatableoppInfo.Id,Total_AR_Subs_Closed_Won__c = 12);
        insert contractInfo;
        
        List<Account> accountList = [select id,name from account where id = :updatableoppInfo1.AccountId];
        Update accountList;
        
        
        
        
    }
}