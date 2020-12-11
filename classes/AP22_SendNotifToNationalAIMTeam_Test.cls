@isTest
Private class AP22_SendNotifToNationalAIMTeam_Test 
{ 
    static testMethod void Test_SendNotifToNationalAIMTeam()
    {
        List<String> sendTo = new List<String>();
        sendTo.add('test_email@anthem.com');
        
        test.startTest();
        string SYSADMINPROFILE = 'Admin'; 
        Account acc = ANA_UTIL01_TestMethods.createAccount(false); 
        insert(acc);
        Opportunity oppty = ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
        insert(oppty);
        Quote qte = ANA_UTIL01_TestMethods.createQuote(false,oppty.Id);
        insert(qte);
        Product2 prod = ANA_UTIL01_TestMethods.createProduct(false);
        prod.Name = 'AIM: A La Carte';
        insert(prod);
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
        insert(pbe);
        QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.Id, pbe.id);
        qli.ProductStage__c='Sold';
        insert qli;
        Group__c grp = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        grp.ClaimSystem__c = 'CLAIMSYSTEM';
        insert(grp);
        qte.GroupNumber__c = grp.id;
        
        string NATIONALSALESPROFILE='National Sales';
        Order ord1= new Order(AccountId = acc.Id, QuoteId = qte.Id, EffectiveDate=System.today(), Status = 'Draft', Implementation_Case_Name__c = 'AIMTesting01', Implementation_Status__c = 'Initiated',Implementation_Effective_Date__c=System.today(), AIM_Product_Sold_Or_Termed_Notification__c='Yes');
        insert ord1;
        
        AP22_SendNotifToNationalAIMTeam.firstRun = true;
        ord1.Implementation_Status__c = 'Pending SME Review';
        
        update ord1;
        test.stopTest();
        //End of Class
        
    }
}