/**
@Author : Deloitte Dev Team
@name : ANA_AP17_Create_BC_Com_oppty_Test 
@CreateDate :04-02-2018
@Description : This class is test class for ANA_AP17_Create_BC_Commissions_oppty class. 
checks for positive and negative scenarios.
*/
@isTest
private class ANA_AP17_Create_BC_Com_oppty_Test {
    private static final string LOCALAMPROFILE='Local Sales';
    private static final String REBEWAL = 'New Business Local';
    private static final String OPPR = 'Opportunity';
    
    
    private static account createAccountData(string str)
    {
        
        account acc =new Account(RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),Name = str,Mailing_Address_Same_as_Physical_Address__c = true,BillingStreet = str,BillingPostalCode = str,BillingCity = str,BillingCountry = str,BillingState = str,Physical_County__c = str);
        system.debug('acc1: ' + acc);
        return acc;
        
    }
    /*This method is for Positive test scenario.*/
    private static testmethod void testPositive()
    {
        Profile profileLG = [select id from profile where name=:LOCALAMPROFILE limit 1];       
        User user=ANA_UTIL01_TestMethods.runAsUser(profileLG.id);
        user.Rep_ID_Code__c = '12345';
        system.runAs(user)
        {
            test.starttest();
            Account acc=createAccountData('Test 1');
            system.debug('acc2: ' + acc);
            Database.insert(acc);
            Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            oppty.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,REBEWAL);
            oppty.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(oppty);
        
            Account brAcc=createAccountData('Test 2');
            brAcc.RecordTypeId= Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Brokerage').getRecordTypeId();
            brAcc.Tax_ID__c = '123456789';
            system.debug('acc3: ' + brAcc);
            database.insert(brAcc);
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
            
            Broker_Consultant_Commissions1__c bccom=new Broker_Consultant_Commissions1__c(Brokerage_Commission_Split__c = 30,Opportunity__c = oppty.id,BrokerageAndConsultant__c = bcon.id,Account__c = brAcc.id);
            insert bccom;
            ANA_AP17_Create_BC_Commissions_oppty.createSelectOptions(oppty.id);
            ANA_AP17_Create_BC_Commissions_oppty.searchDB('Brokerage_and_Consultant1__c','Name','Id',1,'Name','0','SearchByName','BrokerConsult',oppty.id);
            ANA_AP17_Create_BC_Commissions_oppty.searchDB('Brokerage_and_Consultant1__c','Name','Id',1,'Id',bcon.id,'SearchById','BrokerConsult',oppty.id);
            ANA_AP17_Create_BC_Commissions_oppty.searchDB('Brokerage_and_Consultant1__c','Name','Id',1,'Name',oppty.name,'SearchByName','',oppty.id);
            ANA_AP17_Create_BC_Commissions_oppty.searchDB('Brokerage_and_Consultant1__c','Name','Id',1,'Id',oppty.id,'SearchById','',oppty.id);
            ANA_AP17_Create_BC_Commissions_oppty.saveBRRecord(oppty.id,bcon.id,bccom);
            ANA_AP17_Create_BC_Commissions_oppty.getPickListValues();
            ANA_AP17_Create_BC_Commissions_oppty.getBrokerageCommissionSplitTotal(oppty.id,30);
            
            test.stoptest();
        }
        
    }
    /*This method is for Negative test scenario.*/
    private static testmethod void testNegative()
    {
        Profile profileLG = [select id from profile where name=:LOCALAMPROFILE limit 1];       
        User user=ANA_UTIL01_TestMethods.runAsUser(profileLG.id);
        user.Rep_ID_Code__c = '12345';
        system.runAs(user)
        {
            Account acc=createAccountData('Test 3');
            Database.insert(acc);
            Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            oppty.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,REBEWAL);
            oppty.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(oppty);
            
            
            ANA_AP17_Create_BC_Commissions_oppty.createSelectOptions(null);
            Account brAcc=createAccountData('Test 4');
            brAcc.RecordTypeId=brAcc.RecordTypeId= Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Brokerage').getRecordTypeId();
            brAcc.Tax_ID__c = '123456789';
            database.insert(brAcc);                                 
            Brokerage_and_Consultant1__c bcon= new Brokerage_and_Consultant1__c();
            bcon.Brokerage__c=brAcc.Id;
            bcon.Account__c=brAcc.id;        
            database.insert(bcon);
            ANA_AP17_Create_BC_Commissions_oppty.saveBRRecord(oppty.id,bcon.id,null);
        }
    }
}