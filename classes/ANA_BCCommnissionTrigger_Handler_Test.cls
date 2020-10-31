/*@author        :Accenture 
@date         :  27/09/2017
@name         :  ANA_BrokerConCommnissionTrigger_Handler_Test
@description  : This class is a  test class for ANA_BrokerConCommnissionTrigger_Handler  
*/
@isTest
private class ANA_BCCommnissionTrigger_Handler_Test
{
  private Static List<Broker_Consultant_Commissions__c> bcclist= new List<Broker_Consultant_Commissions__c>();
    private static final string NATIONALSALESPROFILE='National Sales';
    /*This method will create Account ,ContactRelationship,BrokerageConsultant,BrokerConsultantCommissions__c and tests the positive scenario.*/
    static testMethod void  BccTestPositive()
    {
        Profile profileNA = [select id from profile where name=:NATIONALSALESPROFILE limit 1];
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user){
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Brokerage');
            database.insert(brAcc);
            ContactRelationship__c crp=ANA_UTIL01_TestMethods.createContactRelationship(false);
            crp.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('ContactRelationship__c','Consultant Contact');
            crp.Account__c=brAcc.id;
            database.insert(crp);            
            Brokerage_and_Consultant__c bac=ANA_UTIL01_TestMethods.createBrokerageAndConsultant(false);
            bac.Brokerage__c=brAcc.id;
            bac.Account__c=brAcc.id;
            bac.Consultant__c=crp.id;
            database.insert(bac);
            bcclist= ANA_UTIL01_TestMethods.createBrokerConsultantCommissions(1,false,brAcc.id,bac.id);      
            database.insert(bcclist);
        }
    }
    /*This method will create Account ,ContactRelationship,BrokerageConsultant,BrokerConsultantCommissions__c and tests the negative scenario.*/
    static testMethod void  BccTestNegative()
    {
        Profile profileNA = [select id from profile where name=:NATIONALSALESPROFILE limit 1];
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user){
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Brokerage');
            database.insert(brAcc);
            ContactRelationship__c crp=ANA_UTIL01_TestMethods.createContactRelationship(false);
            crp.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('ContactRelationship__c','Consultant Contact');
            crp.Account__c=brAcc.id;
            database.insert(crp);            
            Brokerage_and_Consultant__c bac=ANA_UTIL01_TestMethods.createBrokerageAndConsultant(false);
            bac.Brokerage__c=brAcc.id;
            bac.Account__c=brAcc.id;
            bac.Consultant__c=crp.id;
            database.insert(bac);
            bcclist= ANA_UTIL01_TestMethods.createBrokerConsultantCommissions(0,false,brAcc.id,bac.id);      
            database.insert(bcclist);
        }
    }
    /*This method created bulk Account ,ContactRelationship,BrokerageConsultant,BrokerConsultantCommissions__c and inserts those records.*/
    static testMethod void  BccTestBulk()
    {
        Profile profileNA = [select id from profile where name=:NATIONALSALESPROFILE limit 1];
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user){
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Brokerage');
            database.insert(brAcc);
            ContactRelationship__c crp=ANA_UTIL01_TestMethods.createContactRelationship(false);
            crp.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('ContactRelationship__c','Consultant Contact');
            crp.Account__c=brAcc.id;
            database.insert(crp);            
            Brokerage_and_Consultant__c bac=ANA_UTIL01_TestMethods.createBrokerageAndConsultant(false);
            bac.Brokerage__c=brAcc.id;
            bac.Account__c=brAcc.id;
            bac.Consultant__c=crp.id;
            database.insert(bac);
            bcclist= ANA_UTIL01_TestMethods.createBrokerConsultantCommissions(200,false,brAcc.id,bac.id);      
            database.insert(bcclist);
        }
    }
}