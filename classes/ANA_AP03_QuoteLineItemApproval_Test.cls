/**
@Author : Accenture Offshore Dev team
@name : ANA_AP03_QuoteLineItemApproval_Test
@CreateDate :05-05-2017
@Description : This class is test class for ANA_AP01_AccountContactList class. 
checks for positive and negative cases.
*/
@isTest
private class ANA_AP03_QuoteLineItemApproval_Test {
    private static final string NATIONALAMPROFILE='National Sales'; 
    private static final string CLAIMSYSTEM= 'CS90';
    /* @testSetup
static void setup() {       
Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
Database.insert(acc);
Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(acc.id, false);
Date dte=System.today();
oppty.CloseDate=Date.newInstance(dte.year(), dte.month()+1, 5);
Database.insert(oppty);
Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
grp.ClaimSystem__c='CS90';
Database.insert(grp);
Quote qte=ANA_UTIL01_TestMethods.createQuote(oppty.Id, 1)[0];
qte.GroupNumber__c=grp.id;
Database.insert(qte);
QuoteLineItem QLI= ANA_UTIL01_TestMethods.createQuoteLineItem(qte.Id, 1)[0];
Database.insert(QLI);
QuoteLineItemApproval__c qlia=ANA_UTIL01_TestMethods.createQuoteLineItemApproval(QLI.id,1)[0];
Database.insert(qlia);     
}*/
    /*This method will create test data*/
    static QuoteLineItem createData()
    {
        Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
        Database.insert(acc);
        Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
        Database.insert(oppty);
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        grp.ClaimSystem__c=CLAIMSYSTEM;
        Database.insert(grp);
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,oppty.Id);
        qte.GroupNumber__c=grp.id;
        Database.insert(qte);
        Product2 prod=ANA_UTIL01_TestMethods.createProduct(false);
        prod.name='Anthem Health Guide';
        Database.insert(prod);
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
        Database.insert(pbe);
        QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.Id, pbe.id);
        return qli;
    }
    /*This method will test the functionality of submitApproval in positive scenario*/
     static testmethod void submitApprovalPositive(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1 ]; 
        User usr=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        usr.BypassValidation__c=True;
        usr.UserName='postest@anthem.com';
        system.runAs(usr){
            QuoteLineItem qli= createData();
            //qli.AHGProduct__c=true;
            qli.Funding__c='ASO';           
            qli.MedicalManagementPlatform__c='HRS/WMDS';
            qli.MembershipSplitBetweenAHGandNonAHG__c='No';
            qli.Members__c=52;
            qli.ClinicalDeliveryModel__c='IHM'; 
            qli.ServiceTier__c='AHG';
            qli.RecordType__c='AIM';            
            Database.insert(qli);
            QuoteLineItemApproval__c qlia=ANA_UTIL01_TestMethods.createQuoteLineItemApproval(QLI.id,1)[0];
            Database.insert(qlia);
            Map<String,Object> inputmap=new Map<String,Object>();
            Map<String,Object> outputmap=new Map<String,Object>();
            Map<String,Object> options=new Map<String,Object>();
            String methodName='submitApproval';           
            outputmap.put('error','OK');
            options.put('useQueueableApexRemoting',true); 
            inputmap.put('ContextId',qli.Id);
            ANA_AP03_QuoteLineItemApproval actct=new ANA_AP03_QuoteLineItemApproval();
            Boolean approvalRes= actct.invokeMethod(methodName,inputmap,outputmap,options);  
            system.assertEquals(true,approvalRes);  
            methodName='recallApproval';
            Boolean recallRes= actct.invokeMethod(methodName,inputmap,outputmap,options);  
        }
    }
    /*This method will test the functionality of submitApproval in negative scenario*/
    static testmethod void submitApprovalNegative(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1 ]; 
        User usr=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        usr.UserName='negtest@anthem.com';
        usr.BypassValidation__c=True;
        system.runAs(usr){
            QuoteLineItem qli= createData();        
            Database.insert(qli);
            QuoteLineItemApproval__c qlia=ANA_UTIL01_TestMethods.createQuoteLineItemApproval(qli.id,1)[0];
            Database.insert(qlia);
            Map<String,Object> inputmap=new Map<String,Object>();
            Map<String,Object> outputmap=new Map<String,Object>();
            Map<String,Object> options=new Map<String,Object>();
            String methodName='submitApproval';           
            outputmap.put('error','OK');
            options.put('useQueueableApexRemoting',true); 
            inputmap.put('ContextId',QLI.Id);
            ANA_AP03_QuoteLineItemApproval actct=new ANA_AP03_QuoteLineItemApproval();
            Boolean actual= actct.invokeMethod(methodName,inputmap,outputmap,options);
            system.assertEquals(true,actual);
            methodName='recallApproval';           
            outputmap.put('error','OK');
            options.put('useQueueableApexRemoting',true); 
            inputmap.put('ContextId',QLI.Id);
            ANA_AP03_QuoteLineItemApproval recact=new ANA_AP03_QuoteLineItemApproval();
            Boolean recal= recact.invokeMethod(methodName,inputmap,outputmap,options);
            system.assertEquals(true,recal);
        }
    }
}