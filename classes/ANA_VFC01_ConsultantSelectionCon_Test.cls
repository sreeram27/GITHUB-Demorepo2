/**
@Author : Accenture Offshore Dev team
@name : ANA_VFC01_ConsultantSelectionCon_Test
@CreateDate :05-05-2017
@Description : This class is a test class for ANA_VFC01_ConsultantSelectionController. Which will test the functionality of the class.
This has the logic to test create consultant picklist and prepopulating values on VF and saving the Broker_Consultant_Commissions__c record.
@Version <1.0>
*/
@isTest
private class ANA_VFC01_ConsultantSelectionCon_Test {
    private static final string NATIONALAMPROFILE='National Sales';
    /*this method will create records and tests the createOptions method.*/
    private static  testmethod void createOptionsTest()
    {
        Profile profileNA = [select id,name from profile where name=:NATIONALAMPROFILE limit 1];       
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
            //bcon.Contact_Relationship__c=cRel.id;
            bcon.Brokerage__c=brAcc.Id;
            bcon.Account__c=brAcc.id;        
            database.insert(bcon);        
            PageReference pageRef = Page.ANA_VFP01_ConsultantSelection;
            pageRef.getParameters().put('id', brAcc.Id);
            Test.setCurrentPage(pageRef);        
            List<Broker_Consultant_Commissions__c> bcc= new List<Broker_Consultant_Commissions__c>();        
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(bcc);
            ANA_VFC01_ConsultantSelectionController cSelCon = new ANA_VFC01_ConsultantSelectionController(ssc);
            cSelCon.selectedConsultant=bcon.Id;
            cSelCon.redirectToCreate();
            cSelCon.saveBCC();
            cSelCon.cancel();
            cSelCon.getRelatedConsultant();
            cSelCon.getCreate();
            cSelCon.getSave();
            cSelCon.getCancel();
            List<SelectOption> optns=cSelCon.consultantOptions;
                    
            system.assertEquals(NATIONALAMPROFILE,profileNA.Name);
        }        
    }
    private static  testmethod void coverCatch()
    {
        List<Brokerage_and_Consultant__c> bacList;
        bacList=ANA_UTIL04_AccessBCDataUtil.queryBCrecords('Test');
    }
    /*this method will test the saveBCC method negative case i.e. it throws excetion on saveBC method*/
    private static testmethod void saveBCCNegative()
    {
        Profile profileNA = [select id,name from profile where name=:NATIONALAMPROFILE limit 1];       
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user)
        {
            Account brAcc=ANA_UTIL01_TestMethods.createAccount(false);
            brAcc.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId('Account','Brokerage');
            database.insert(brAcc); 
            List<Broker_Consultant_Commissions__c> bccs= new List<Broker_Consultant_Commissions__c>();
            Broker_Consultant_Commissions__c bcc= new Broker_Consultant_Commissions__c();
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(bccs);
            ANA_VFC01_ConsultantSelectionController cSelCon = new ANA_VFC01_ConsultantSelectionController(ssc);
            cSelCon.bcc=bcc;
            cSelCon.saveBCC();
            cSelCon.redirectToCreate();
            cSelCon.cancel();
            bcc.Account__C=brAcc.Id;
            
            system.assertEquals(NATIONALAMPROFILE,profileNA.Name);
        }
    }    
}