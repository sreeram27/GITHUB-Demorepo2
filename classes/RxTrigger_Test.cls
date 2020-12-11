/*@author       Partha(Vikings)
@date           07/19/2019
@name           RxTrigger_Test
@description    Test class for RxTrigger and RxTriggerHandler.
ModifiedBy Sharath KN on 18-Aug-2019 to cover trigger code which limits only one RX per Implementation Case
*/
@isTest
public class RxTrigger_Test {
 static testMethod void testMethod1() 
    {
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
        User user2 = new User(Alias = 'asf321', Email='standarduser@abc.com', EmailEncodingKey='UTF-8', LastName='song12', 
                            LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', 
                            UserName='test2314@abc.com');

        insert user2;
        
        Order ord = new Order(Group_Name__c=grp.id,AccountId = acc.Id,ID_Cards_Required__c='No', EffectiveDate=System.today(), Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes', Implementation_Status__c = 'Initiated', Implementation_Effective_Date__c=System.today(), Assigned_Implementer__c=user2.id,QuoteId=qte.id);
        insert ord;
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        insert ImpTrack;

        ID_Cards__c i= new ID_Cards__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '04 Approved');
        insert i;
        
        Test.stopTest();

        Issue_Control__c caseins = new Issue_Control__c(Implementation_Tracking_ID__c = ImpTrack.id);
        insert caseins;
        
        Rx__c rx = new Rx__c(Implementation_Tracking_ID__c = ImpTrack.id);
        insert rx;
        
        try{
        Rx__c rx1 = new Rx__c(Implementation_Tracking_ID__c = ImpTrack.id);
            insert rx1;
        }catch(exception e){}
        
     /*    try{
        Enrollment_and_Billing__c mem1 = new Enrollment_and_Billing__c(Implementation_Tracking_ID__c = ImpTrack.id);
        insert mem1;
        }
        catch(Exception ex){
        System.debug('Exception '+ex.getmessage());
        } */
        
        
    }
    
    }