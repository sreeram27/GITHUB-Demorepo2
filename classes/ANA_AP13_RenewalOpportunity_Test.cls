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
/*******************************************************************************************
@class Name  : ANA_AP13_RenewalOpportunity_Test
@created By  : IDC Offshore
@description : This test class is for ANA_AP13_RenewalOpportunity
********************************************************************************************/
@isTest
private class ANA_AP13_RenewalOpportunity_Test {
    
    private static final String OPPR = 'Opportunity';
    private static final String REBEWAL = 'Renewal';
    private static final String IGAPOPP = 'In Group Add Product';
    private static final String INITSTAG = 'Initiated';
    private static final string CLAIMSYSTEM= 'CS90';
    private static final string NATIONALAMPROFILE='National Sales';

/*******************************************************************************************
@method Name  : renewalOpportunityClone
@description : by using this method call the variables & methods from ANA_AP13_RenewalOpportunity class
********************************************************************************************/
    static testMethod void renewalOpportunityClone() {
        ANA_AP13_RenewalOpportunity opp = new ANA_AP13_RenewalOpportunity();
        List<Opportunity> listIgap = new List<Opportunity>();
        // TO DO: implement unit test
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user1=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user1){
            Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
            Database.insert(acc);
            Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            oppty.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,REBEWAL);
            oppty.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(oppty);
            
            Opportunity opptyIgap=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            opptyIgap.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,IGAPOPP);
            opptyIgap.ParentOppty__c = oppty.Id;
            opptyIgap.StageName = INITSTAG; 
            oppty.closedate = Date.newInstance( System.Today().year(), System.Today().month(), 5 );//system.today()+1;
            Database.insert(opptyIgap);
            listIgap.add(opptyIgap);
            system.debug('oppty.closedate'+oppty.closedate);
            Opportunity opptyNew=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            opptyNew.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,REBEWAL);
            opptyNew.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(opptyNew);
            
            Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp.ClaimSystem__c=CLAIMSYSTEM;
            Database.insert(grp);

            Quote qte=ANA_UTIL01_TestMethods.createQuote(false,oppty.Id);
            qte.OpportunityId = opptyIgap.id;
            Database.insert(qte);
            
            Quote qteIg=ANA_UTIL01_TestMethods.createQuote(false,oppty.Id);
            qteIg.GroupNumber__c=grp.id;
            qteIg.OpportunityId = oppty.id;
            Database.insert(qteIg);
            
            Quote qteIgap=ANA_UTIL01_TestMethods.createQuote(false,opptyIgap.Id);
            qteIgap.GroupNumber__c=grp.id;
            qteIgap.OpportunityId = opptyIgap.id;
            Database.insert(qteIgap);
            
            //listquote.add(qte);
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            prd.isActive = true;
            database.insert(prd);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            Quotelineitem qlItem = ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.id,pbe.id);
            qlItem.ProductStage__c = 'Renewed';
            database.insert(qlItem);
            Quotelineitem qlItemig = ANA_UTIL01_TestMethods.createQuoteLineItem(false,qteIg.id,pbe.id);
            qlItemig.ProductStage__c = 'Renewed';
            database.insert(qlItemig);
            Quotelineitem qlitemIgap = ANA_UTIL01_TestMethods.createQuoteLineItem(false,qteIgap.id,pbe.id);
            qlitemIgap.ProductStage__c = 'Renewed';
            database.insert(qlitemIgap);
            ANA_AP13_RenewalOpportunity c= new ANA_AP13_RenewalOpportunity();
            Map<String,Object> inputmap=new Map<String,Object>();
            Map<String,Object> outputmap=new Map<String,Object>();
            Map<String,Object> options=new Map<String,Object>();
            
            inputmap.put('NewOptyId',opptyNew.id);
            inputmap.put('OldOptyId',oppty.id);
            Boolean boo = c.invokeMethod('getRenewalOpportunity',inputmap,outputmap,options);
            c.invokeMethod('getRenewalOpportunity',inputmap,outputmap,options);
            system.assertEquals(True, boo,'Success');
            opp.igapOpporunityupdate(listIgap, oppty, opptyNew);
        }
    }

/*******************************************************************************************
@method Name  : renewalOpportunityCloneNonQuote
@description : Below method is useful for test the elseif quote line item record related with IGAP
********************************************************************************************/
    static testMethod void renewalOpportunityCloneNonQuote() {
        // TO DO: implement unit test
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user1=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user1){
            Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
            Database.insert(acc);
            Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            oppty.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,REBEWAL);
            oppty.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(oppty);
            
            Opportunity opptyIgap=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            opptyIgap.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,IGAPOPP);
            opptyIgap.ParentOppty__c = oppty.Id;
            opptyIgap.StageName = INITSTAG; 
            oppty.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(opptyIgap);
            
            Opportunity opptyNew=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            opptyNew.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,REBEWAL);
            opptyNew.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(opptyNew);
            
            Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp.ClaimSystem__c=CLAIMSYSTEM;
            Database.insert(grp);

            Quote qte=ANA_UTIL01_TestMethods.createQuote(false,oppty.Id);
            qte.GroupNumber__c=grp.id;
            qte.OpportunityId = opptyIgap.id;
            Database.insert(qte);
            
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            database.insert(prd);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            Quotelineitem qlItem = ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.id,pbe.id);
            qlItem.ProductStage__c = 'IGAP In Progress';
            database.insert(qlItem);
            
            ANA_AP13_RenewalOpportunity c= new ANA_AP13_RenewalOpportunity();
            Map<String,Object> inputmap=new Map<String,Object>();
            Map<String,Object> outputmap=new Map<String,Object>();
            Map<String,Object> options=new Map<String,Object>();
            
            inputmap.put('NewOptyId',opptyNew.id);
            inputmap.put('OldOptyId',oppty.id);
            Boolean boo = c.invokeMethod('getRenewalOpportunity',inputmap,outputmap,options);
            c.invokeMethod('getRenewalOpportunity',inputmap,outputmap,options);
            system.assertEquals(True, boo,'Success');
        }     
    }
    

/*******************************************************************************************
@method Name  : renewalOpportunitycatch
@description : Below method is useful for test the catch block
********************************************************************************************/
    static testMethod void renewalOpportunitycatch(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user1=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user1){
            try{
                Test.starttest(); 
                Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
                Database.insert(acc);
                Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(false,null);
                oppty.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,REBEWAL);
                oppty.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
                Database.insert(oppty);
                Quote qins = new Quote();
                database.insert(qins);
                Quotelineitem qlins = new Quotelineitem();
                database.insert(qlins);
                system.assert(oppty.closedate>System.today());
                Test.stopTest();
            }catch(DMLException e) {
                system.debug('Exception has occured'+e.getMessage());
            } catch(exception excn){
                system.debug('Exception has occured'+excn.getMessage());
            }
        }
        
    }
    
    /*by using this method call the variables & methods from ANA_AP13_RenewalOpportunity class*/
/*******************************************************************************************
@method Name  : renewalOpportunity
@description : by using this method call the variables & methods from ANA_AP13_RenewalOpportunity class
********************************************************************************************/
    static testMethod void renewalOpportunity(){
        ANA_AP13_RenewalOpportunity opp = new ANA_AP13_RenewalOpportunity();
        list<Opportunity> listIgap = new list<Opportunity>();
        // TO DO: implement unit test
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];
        User user1=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user1){
            Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
            Database.insert(acc);
            Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            oppty.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,REBEWAL);
            oppty.closedate = Date.newInstance( System.Today().year()-1, System.Today().month(), 5 );//system.today()-1;
            Database.insert(oppty);
            
            Opportunity opptyIgap=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            opptyIgap.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,IGAPOPP);
            opptyIgap.ParentOppty__c = oppty.Id;
            opptyIgap.StageName = INITSTAG; 
            oppty.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(opptyIgap);
            listIgap.add(opptyIgap);
            
            Opportunity opptyNew=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            opptyNew.RecordTypeId=ANA_UTIL01_TestMethods.getRecordTypeId(OPPR,REBEWAL);
            opptyNew.closedate = Date.newInstance( System.Today().year()+1, System.Today().month(), 5 );//system.today()+1;
            Database.insert(opptyNew);
            
            Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp.ClaimSystem__c=CLAIMSYSTEM;
            Database.insert(grp);

            Quote qte=ANA_UTIL01_TestMethods.createQuote(false,oppty.Id);
            qte.OpportunityId = opptyIgap.id;
            Database.insert(qte);
            
            Quote qteIg=ANA_UTIL01_TestMethods.createQuote(false,oppty.Id);
            qteIg.GroupNumber__c=grp.id;
            qteIg.OpportunityId = oppty.id;
            Database.insert(qteIg);
            
            Quote qteIgap=ANA_UTIL01_TestMethods.createQuote(false,opptyIgap.Id);
            qteIgap.GroupNumber__c=grp.id;
            qteIgap.OpportunityId = opptyIgap.id;
            Database.insert(qteIgap);
            
            Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
            prd.isActive = true;
            database.insert(prd);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
            database.insert(pbe);
            Quotelineitem qlItem = ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.id,pbe.id);
            qlItem.ProductStage__c = 'Renewed';
            database.insert(qlItem);
            Quotelineitem qlItemig = ANA_UTIL01_TestMethods.createQuoteLineItem(false,qteIg.id,pbe.id);
            qlItemig.ProductStage__c = 'Renewed';
            database.insert(qlItemig);
            Quotelineitem qlItemigap = ANA_UTIL01_TestMethods.createQuoteLineItem(false,qteIgap.id,pbe.id);
            qlItemigap.ProductStage__c = 'Renewed';
            database.insert(qlItemigap);
            ANA_AP13_RenewalOpportunity c= new ANA_AP13_RenewalOpportunity();
            Map<String,Object> inputmap=new Map<String,Object>();
            Map<String,Object> outputmap=new Map<String,Object>();
            Map<String,Object> options=new Map<String,Object>();
            
            inputmap.put('NewOptyId',opptyNew.id);
            inputmap.put('OldOptyId',oppty.id);
            Boolean boo = c.invokeMethod('getRenewalOpportunity',inputmap,outputmap,options);
            c.invokeMethod('getRenewalOpportunity',inputmap,outputmap,options);
            system.assertEquals(True, boo,'Success');
            
            Date effectdate = Date.newInstance(System.Today().year(), System.Today().month(), 5);
            opp.igapOpporunityupdate(listIgap, oppty, opptyNew);
            opp.opportuityStageUpdate(effectdate);
        }
    }
}