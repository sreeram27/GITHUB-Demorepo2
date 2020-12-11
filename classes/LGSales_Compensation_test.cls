/* *******************************************************
Class Name   : LGSales_Compensation_test
Date Created : 18-MAY-2018
Created By   : Deloitte USI
Description  : test class for LGSales_Compensation
********************************************************** */

@istest
private class LGSales_Compensation_test
{
    static testmethod void LGSales_Compensation_test(){
        Account acct = new Account(Name = staticVariableClass.DNCTstAcc);
        acct.Situs_State__c = staticVariableClass.DNCTstAccState;
        acct.Anthem_Entity__c= staticVariableClass.DNCTstEntity;
        //acct.BillingStreet = 'Salem';
        //acct.BillingPostalCode = '434343';
        //acct.BillingCity ='Salem';
        //acct.BillingCountry ='India';
        //acct.BillingState = 'Tamil Nadu';
        //acct.Physical_County__c = '122';
         acct.BillingStreet = staticVariableClass.testAccBillingStreet;
         acct.BillingPostalCode= staticVariableClass.testAccBillingPostalCode ;
         acct.BillingCity = staticVariableClass.testAccBillingCity ;
         acct.BillingCountry =  staticVariableClass.testAccBillingCountry ;
         acct.BillingState = staticVariableClass.testAccBillingState ;
         acct.Physical_County__c = staticVariableClass.testAccBillingCity;
        acct.Mailing_Address_Same_as_Physical_Address__c = true;
        acct.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();
        insert acct;
        
        //Opportunity opp = new Opportunity(Name='abc', AccountId = acct .id,StageName = '0', CloseDate = System.today());
        Opportunity opp = new Opportunity(Name=staticVariableClass.OpportunityName, AccountId = acct .id,StageName = staticVariableClass.OpportunityStageName, CloseDate = System.today());
        insert opp;
        
        Sales_Compensation__c slc = new Sales_Compensation__c(Opportunity__c = opp.id);
        insert slc;
        
                  
        PageReference pageRef = Page.LG_SalesCompStart;
        pageRef.getParameters().put('id', String.valueOf(slc.Id));
        Test.setCurrentPage(pageRef);
    
         ApexPages.StandardController sc = new ApexPages.StandardController(slc);
         LGSales_Compensation classExtn = new LGSales_Compensation(sc);
        classExtn.save();
        
    }
 }