/**
@Author : Accenture Offshore Dev team
@name : ANA_AP17_Create_BC_Commissions_Test 
@CreateDate :23-08-2017
@Description : This class is test class for ANA_AP17_Create_BC_Commissions class. 
checks for positive and negative scenarios.
*/
@isTest
private class ANA_AP17_Create_BC_Commissions_Test {
	private static final string NATIONALAMPROFILE='National Sales';
    /*This method is for Positive test scenario.*/
    private static testmethod void testPositive()
    {
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];       
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user)
        {
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Brokerage');
            database.insert(brAcc);
            Contact con=ANA_UTIL01_TestMethods.createContact(true,brAcc.Id);        
            ContactRelationship__c cRel=ANA_UTIL01_TestMethods.createContactRelationship(false);
            cRel.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('ContactRelationship__c','Consultant Contact');
            cRel.Account__c=brAcc.Id;
			cRel.Contact__c=con.Id;
            database.insert(cRel);        
            Brokerage_and_Consultant__c bcon= ANA_UTIL01_TestMethods.createBrokerageAndConsultant(false);
            bcon.Consultant__c=cRel.id;
            bcon.Brokerage__c=brAcc.Id;
            bcon.Account__c=brAcc.id;        
            database.insert(bcon);
            Broker_Consultant_Commissions__c bccom=new Broker_Consultant_Commissions__c();
            ANA_AP17_Create_BC_Commissions.createSelectOptions(brAcc.id);
            ANA_AP17_Create_BC_Commissions.searchDB('Brokerage_and_Consultant__c','Name','Id',1,'Name','0','SearchByName','BrokerConsult',brAcc.id);
            ANA_AP17_Create_BC_Commissions.searchDB('Brokerage_and_Consultant__c','Name','Id',1,'Id',bcon.id,'SearchById','BrokerConsult',brAcc.id);
            ANA_AP17_Create_BC_Commissions.searchDB('Brokerage_and_Consultant__c','Name','Id',1,'Name',brAcc.name,'SearchByName','',brAcc.id);
            ANA_AP17_Create_BC_Commissions.searchDB('Brokerage_and_Consultant__c','Name','Id',1,'Id',brAcc.id,'SearchById','',brAcc.id);
            ANA_AP17_Create_BC_Commissions.saveBRRecord(brAcc.id,bcon.id,bccom);
            ANA_AP17_Create_BC_Commissions.getPickListValues();
        }
    }
    /*This method is for Negative test scenario.*/
     private static testmethod void testNegative()
    {
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];       
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user)
        {
            ANA_AP17_Create_BC_Commissions.createSelectOptions(null);
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Brokerage');
            database.insert(brAcc);                                 
            Brokerage_and_Consultant__c bcon= ANA_UTIL01_TestMethods.createBrokerageAndConsultant(false);
            bcon.Brokerage__c=brAcc.Id;
            bcon.Account__c=brAcc.id;        
            database.insert(bcon);
            ANA_AP17_Create_BC_Commissions.saveBRRecord(brAcc.id,bcon.id,null);

        }
    }
}