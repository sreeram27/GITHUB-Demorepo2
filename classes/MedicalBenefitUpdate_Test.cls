@isTest
public class MedicalBenefitUpdate_Test
{
@isTest static void testMethod1()
{
SIC__c SIC = new SIC__c(Name = staticVariableClass.SIC);
        Insert SIC;
Account acc =new Account(
            RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
            Name = staticVariableClass.AccountName,Account_s_Suppress_Auto_Renewal__c = false,Anthem_Entity__c = staticVariableClass.Entity,
            Region__c= staticVariableClass.Region, Branding__c =staticVariableClass.UniCare,SIC__c = SIC.Id,Group_Size__c =staticVariableClass.size,
            Total_Employees__c =staticVariableClass.emp, HQ_State__c =staticVariableClass.AK, Situs_State__c = staticVariableClass.California,
            Mailing_Address_Same_as_Physical_Address__c = true, BillingStreet = 'Land Mark', BillingPostalCode = '636111',
            BillingCity = 'Banglore', BillingCountry = 'India', BillingState = 'Karnataka', Physical_County__c = '121');
        insert acc;

 Opportunity newOpp = new Opportunity(Name=(String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name), 
                                             StageName = staticVariableClass.ClosedWon, AccountID = acc.id, CloseDate = ((system.TODAY())-95),                   
                                             RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId());
        
        insert newOpp;
        
        
Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        insert grp;
        
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,newOpp.Id);
        qte.GroupNumber__c=grp.id;
        insert qte;
        
                Profile p1 = [SELECT Id FROM Profile WHERE Name='Local Implementations']; 
        User user2 = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='fgasdhdfh', 
                              LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', 
                              UserName='test23123we4@testorg.com');
        
        insert user2;

       List<Id> ordlist=new List<Id>();
        Order ord = new Order(Group_Name__c=grp.id,AccountId = acc.Id, EffectiveDate=System.today(), Status = 'Draft',
                              Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes', 
                              Implementation_Status__c = 'Ready for Imps', Implementation_Effective_Date__c=System.today(), 
                              Assigned_Implementer__c=user2.id,QuoteId=qte.id);

      test.startTest();
        
        insert ord;
        ordlist.add(ord.id);

        MedicalBenefitUpdate.StatusUpdate(ordlist);
        test.stoptest();
       
}
}