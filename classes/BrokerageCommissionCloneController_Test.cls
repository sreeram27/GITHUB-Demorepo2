/*@author       Ravideep(Vikings)
@date           06/06/2019
@name           BrokerageCommissionCloneController_Test
@description    Test class for BrokerageCommissionCloneController
*/
@isTest
public class BrokerageCommissionCloneController_Test {
 static testMethod void testMethod1(){
        
        SIC__c Sic = new SIC__c(Name = staticVariableClass.SIC);
        Insert SIC;
        
        Test.startTest();
        Account acc =new Account(RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),Name = staticVariableClass.AccountName,Account_s_Suppress_Auto_Renewal__c = false,Anthem_Entity__c = staticVariableClass.Entity,Region__c= staticVariableClass.Region,Branding__c =staticVariableClass.UniCare,SIC__c = SIC.Id,Group_Size__c =staticVariableClass.size,Total_Employees__c =staticVariableClass.emp,HQ_State__c =staticVariableClass.AK,Situs_State__c = staticVariableClass.California,Mailing_Address_Same_as_Physical_Address__c = true,BillingStreet = 'Land Mark',BillingPostalCode = '636111',BillingCity = 'Banglore',BillingCountry = 'India',BillingState = 'Karnataka',Physical_County__c = 'Banglore');
        insert acc;
        
        Account brAcc =new Account(RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Brokerage').getRecordTypeId(),Name = staticVariableClass.AccountName + '1',Account_s_Suppress_Auto_Renewal__c = false,Anthem_Entity__c = staticVariableClass.Entity,Region__c= staticVariableClass.Region,Branding__c =staticVariableClass.UniCare,SIC__c = SIC.Id,Group_Size__c =staticVariableClass.size,Total_Employees__c =staticVariableClass.emp,HQ_State__c =staticVariableClass.AK,Situs_State__c = staticVariableClass.California,Mailing_Address_Same_as_Physical_Address__c = true,BillingStreet = 'Test',BillingPostalCode = '1232',BillingCity = 'Test',BillingCountry = 'Test',BillingState = 'Test',Physical_County__c = 'Test',Tax_ID__c = '123456789');
        insert brAcc;
        
        
        Opportunity newOpp = new Opportunity(name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name),StageName = staticVariableClass.ClosedWon,AccountID = acc.id,CloseDate = ((system.TODAY())-95),recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId());
        insert newOpp;
    
        
        Contact con=ANA_UTIL01_TestMethods.createContact(true,brAcc.Id);        
        ContactRelationship__c cRel=ANA_UTIL01_TestMethods.createContactRelationship(false);
        cRel.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('ContactRelationship__c','LG Brokerage Consultant Relationship');
        cRel.Account__c=brAcc.Id;
        cRel.Contact__c=con.Id;
        database.insert(cRel);        
        Brokerage_and_Consultant1__c bcon= new Brokerage_and_Consultant1__c();
        bcon.Consultant__c=cRel.id;
        bcon.Brokerage__c=brAcc.Id;
        bcon.Account__c=brAcc.id;        
        database.insert(bcon);
        Broker_Consultant_Commissions1__c bccom=new Broker_Consultant_Commissions1__c(Brokerage_Commission_Split__c = 30,Opportunity__c = newOpp.id,BrokerageAndConsultant__c = bcon.id,Account__c = brAcc.id);
        BrokerageCommissionCloneController.insertClonedRecord(bccom);
        BrokerageCommissionCloneController.getBrokerageCommissionSplitTotal(newOpp.id,25);   
        Test.stopTest();
    }
    
    }