/*@author       Ravideep(Vikings)
@date           04/08/2019
@name           CaseInstallationTrigger_Test
@description    Test class for CaseInstallationTrigger and CaseInstallationTriggerHandler.
*/
@isTest
public class CaseInstallationTrigger_Test {
    static testMethod void testMethod1() 
    {
        //Test.startTest();
        SIC__c Sic = new SIC__c(Name = staticVariableClass.SIC);
        Insert SIC;
        
        Test.startTest();
        Account acc =new Account(RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),Name = staticVariableClass.AccountName,Account_s_Suppress_Auto_Renewal__c = false,Anthem_Entity__c = staticVariableClass.Entity,Region__c= staticVariableClass.Region,Branding__c =staticVariableClass.UniCare,SIC__c = SIC.Id,Group_Size__c =staticVariableClass.size,Total_Employees__c =staticVariableClass.emp,HQ_State__c =staticVariableClass.AK,Situs_State__c = staticVariableClass.California,Mailing_Address_Same_as_Physical_Address__c = true,BillingStreet = 'Land Mark',BillingPostalCode = '636111',BillingCity = 'Banglore',BillingCountry = 'India',BillingState = 'Karnataka',Physical_County__c = 'Banglore');
        insert acc;
        
        Opportunity newOpp = new Opportunity(name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name),StageName = staticVariableClass.ClosedWon,AccountID = acc.id,CloseDate = ((system.TODAY())-95),recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId());
        insert newOpp;
        
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        Database.insert(grp);
        
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,newOpp.Id);
        qte.GroupNumber__c=grp.id;
        Database.insert(qte);
        
        Product2 prod=ANA_UTIL01_TestMethods.createProduct(false);
        prod.name='Anthem Health Guide';
        Database.insert(prod);
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
        Database.insert(pbe);
        
        QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.Id, pbe.id);
        qli.Quantity =  123.0;
        qli.UnitPrice =12.0;
        qli.Product_Term_Years_Left__c ='5';
        qli.Discount_sharing__c = staticVariableClass.SoldRenewed;
        qli.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        qli.ProductStage__c= staticVariableClass.Sold;
        Database.insert(qli);
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Local Implementations']; 
        
        Order ord = new Order(Group_Name__c=grp.id,ID_Cards_Required__c='No' ,AccountId = acc.Id, EffectiveDate=System.today(), Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes', Implementation_Status__c = 'Initiated', Implementation_Effective_Date__c=System.today(),QuoteId=qte.id);
        insert ord;
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        insert ImpTrack;
        
        ID_Cards__c i= new ID_Cards__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '04 Approved');
        insert i;
        Test.stopTest();
        
        Enrollment_and_Billing__c mem = new Enrollment_and_Billing__c(Implementation_Tracking_ID__c = ImpTrack.id);
        insert mem;
        
        // PRDCRM-38796 : Associate RX and Medical Installation records to CI record when a new case installation is created - Partha
        Rx__c rx = new Rx__c(Implementation_Tracking_ID__c = ImpTrack.id);
        insert rx;
        
        Medical_Benefit__c mben = new Medical_Benefit__c(Implementation_Tracking_ID__c = ImpTrack.id);
        insert mben;
        
        Issue_Control__c caseins = new Issue_Control__c(Implementation_Tracking_ID__c = ImpTrack.id,Partial_Rates_Loaded__c=System.today());
        insert caseins;
        
        try{
            Issue_Control__c caseins1 = new Issue_Control__c(Implementation_Tracking_ID__c = ImpTrack.id,Partial_Rates_Loaded__c=System.today());
            insert caseins1;
        }
        catch(Exception ex){
            System.Assert(ex.getMessage().contains('Only one case Installation SME record is permitted per implementation case.'));
        }
     }
}