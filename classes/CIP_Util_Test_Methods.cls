/*
@Author : Arun Siddappa
@name : CIP_Util_Test_Methods 
@CreateDate :07-22-2017
@Description : This class is utlity class to support testing 
*/

public class CIP_Util_Test_Methods {
    public static Account testAccount;
    public static Group__c grp;
    public static Opportunity opty;
    public static Quote quote;
    public static ContentVersion contentVersion;
    public static ContentDocumentLink cdl;
    public static CIPIntegration__c createCIPIntegration(){
        CIPIntegration__c testCIPInt = new CIPIntegration__c();
        testCIPInt.CIP_SF_Org_URL__c = 'SGC';
        testCIPInt.Consumer_Key_For_Old_Org__c = 'ABC';
        testCIPInt.Consumer_Secret_For_Old_Org__c = 'SECREAT';
        testCIPInt.Password_For_Old_Org__c = 'SECREAT';
        testCIPInt.SessionURL__c = 'http://session';
        testCIPInt.User_Name_For_Old_Org__c = 'http://oldSFOrg';
        return testCIPInt;
    }
    public static Account CreateAccount(){
        List<RecordType> recList = [SELECT id FROM RECORDTYPE WHERE Name = 'Customer' AND sObjectType = 'Account'];
        testAccount = new Account(Name='TestCustoomer');        
        testAccount.RecordTypeId = recList[0].Id;
        testAccount.AccountNumber = '123456';
        testAccount.NumberOfEmployees = 123456;
        testAccount.Eligible_Employees__c = 123456;
        testAccount.HQ_State__c = 'NY';
        testAccount.Original_Effective_Date__c = Date.today();
        testAccount.Group_Size__c = '123456';
        testAccount.Region__c = '123456';
        testAccount.Branding__c = '123456';
        testAccount.Account_Name_DBA__c = '123456';
        testAccount.Website = 'http://123456.com';
        testAccount.BillingStreet = '123456 Main St';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = 'NY';
        testAccount.BillingPostalCode = '23233';
        testAccount.BillingCountry = 'HEN';
        testAccount.ShippingStreet = '123456 Main St';
        testAccount.ShippingCity = 'Cistt';
        testAccount.ShippingState = 'NY';
        testAccount.ShippingPostalCode='12312';
        testAccount.ShippingCountry='CNTY';        
        return testAccount;
    }
    public static Group__c CreateGroup(String accntId, String grpNumber){
        grp = new Group__c();
        grp.Account__c = accntId;
        grp.Name = grpNumber;
        return grp;
    }
    
    public static Opportunity CreateOpportunity (Account tstAccount){
        opty = new Opportunity();
        opty.Received_Date__c =Date.Today() ;
        opty.Accountid = tstAccount.id;
        opty.Name = 'testForSGC';
        opty.CloseDate = Date.Today().addDays(40);
        opty.stagename='Opportunity';
        return opty;
    }
    public static Quote CreateQuote(Account tstAccount,Opportunity opty, String grpNumberId){
        quote = new Quote();
        quote.name = 'Quote- TEST ACCOUNT';
        quote.GroupNumber__c = grpNumberId;
        quote.opportunityId = opty.id;
        return quote;
    }
    
    
    public static void createDocument(Quote qt)
    {   
        contentVersion = new ContentVersion(
        Title = 'ASF Document',
        PathOnClient = 'ASF.pdf',
        VersionData = Blob.valueOf('Test Content'),
        IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = qt.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
    }    
}