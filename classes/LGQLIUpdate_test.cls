/* ***************************************************************************
Class Name   : LGQLIUpdate_test
Date Created : 09-MAY-2018
Created By   : Deloitte USI
Description  : Test Class for LGQLIUpdate
******************************************************************************* */
@isTest
public class LGQLIUpdate_test {
    
    static testMethod void testMethodQLIUpdate() 
    {
        SIC__c Sic = new SIC__c(Name = staticVariableClass.SIC);
        Insert SIC;
        
        Account acc =new Account(
            RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
            Name = staticVariableClass.AccountName,
            Account_s_Suppress_Auto_Renewal__c = false,
            Anthem_Entity__c = staticVariableClass.Entity,
            Region__c= staticVariableClass.Region,
            Branding__c =staticVariableClass.UniCare,
            SIC__c = SIC.Id,
            Group_Size__c =staticVariableClass.size,
            Total_Employees__c =staticVariableClass.emp,
            HQ_State__c =staticVariableClass.AK,
            Situs_State__c = staticVariableClass.California,
            Mailing_Address_Same_as_Physical_Address__c = true,
            //BillingStreet = 'Land Mark',
            //BillingPostalCode = '636111',
            //BillingCity = 'Banglore',
            //BillingCountry = 'India',
            //BillingState = 'Karnataka',
            //Physical_County__c = 'Banglore'
            BillingStreet = staticVariableClass.testAccBillingStreet,
            BillingPostalCode= staticVariableClass.testAccBillingPostalCode ,
            BillingCity = staticVariableClass.testAccBillingCity ,
            BillingCountry =  staticVariableClass.testAccBillingCountry ,
            BillingState = staticVariableClass.testAccBillingState ,
            Physical_County__c = staticVariableClass.testAccBillingCity
        );
        
        Test.startTest();
        insert acc;
        
        List<Id> lstOpp= new List<Id>();
        
        Opportunity newOpp = new Opportunity(
            name=  (String.valueOf(system.today().year() + 1) + staticVariableClass.NewBusinessLocal  + acc.Name),
            StageName = staticVariableClass.ClosedWon,
            AccountID = acc.id,
            CloseDate = ((system.TODAY())-95),                   
            recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId()                                    
        );
        
        INSERT newOpp;
        lstOpp.add(newOpp.id);
        
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        Database.insert(grp);
        // insert(grp);
        
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,newOpp.Id);
        qte.GroupNumber__c=grp.id;
        Database.insert(qte);
        // insert(qte);
        
        Product2 prod=ANA_UTIL01_TestMethods.createProduct(false);
        //prod.name='Anthem Health Guide';
        prod.name=staticVariableClass.testProdName;
        Database.insert(prod);
        // insert(prod);
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
        Database.insert(pbe);
        // insert(pbe);
        
        QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.Id, pbe.id);
        qli.Quantity =  123.0;
        qli.UnitPrice =12.0;
        qli.Product_Term_Years_Left__c =staticVariableClass.NumericFive;
        qli.Discount_sharing__c = staticVariableClass.SoldRenewed;
        qli.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        qli.ProductStage__c= staticVariableClass.Sold;
       // qli.Are_you_looking_for_HMO_plans_support__c='No';
       // qli.How_many_are_expected_within_HMO_policy__c = 1;
       //qli.Is_HMO_a_Gatekeeper_or_Open_Access__c = 'Gatekeeper';
        Database.insert(qli);
        //  insert(qli);
        
        
        
        LGQLIUpdate.QLIUpdate(lstOpp);
        
        Test.stopTest();
    }
    
    
}