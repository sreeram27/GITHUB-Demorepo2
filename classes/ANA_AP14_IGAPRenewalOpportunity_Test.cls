/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ANA_AP14_IGAPRenewalOpportunity_Test {
    
    private static final String OPPR = 'Opportunity';
    private static final String REBEWAL = 'Renewal';
    private static final String IGAPOPP = 'In Group Add Product';
    private static final String INITSTAG = 'Initiated';
    private static final string NATIONALAMPROFILE='National Sales';
    /*This method is used to call the methods & variables from IGAP opportunity cloning components */
    static testMethod void iGAPRenewalOpportunity() {
        // TO DO: implement unit test
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user1=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user1){
            Test.starttest();
            Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
            Database.insert(acc);
            Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            oppty.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,REBEWAL);
            oppty.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(oppty);
            
            Opportunity opptyigap=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            opptyigap.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,IGAPOPP);
            opptyigap.ParentOppty__c = oppty.Id;
            opptyigap.StageName = INITSTAG; 
            oppty.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(opptyigap);
            Test.stopTest();
            ANA_AP14_IGAPRenewalOpportunity.getOpportunityids(oppty);
            System.assertEquals(oppty.Id, opptyigap.ParentOppty__c);
        }   
    }
}