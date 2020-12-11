/*@author         Accenture
@date           30/06/2017
@name           ANA_AP11_DeleteChildQLI_Test
@description    Test class to test the ANA_AP11_DeleteChildQLI class.
*/
@isTest
private class ANA_AP11_DeleteChildQLI_Test {
    private static final string NATIONALAMPROFILE='National Sales'; 
    private static final string CLAIMSYSTEM= 'CS90';
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
    /*This method will test the functionality of deleteChildQLI method in positive scenario*/
    static testmethod void deleteQLIPositive(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1 ]; 
        User usr=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        usr.UserName='postest@anthem.com';
        system.runAs(usr){
            QuoteLineItem qli= createData();
            qli.Funding__c='ASO';           
            qli.MedicalManagementPlatform__c='HRS/WMDS';
            qli.MembershipSplitBetweenAHGandNonAHG__c='No';
            qli.Members__c=52;
            qli.ClinicalDeliveryModel__c='IHM'; 
            qli.ServiceTier__c='AHG';
            qli.RecordType__c='AIM';            
            Database.insert(qli);
            Map<String,Object> inputmap=new Map<String,Object>();
            Map<String,Object> outputmap=new Map<String,Object>();
            Map<String,Object> options=new Map<String,Object>();
            String methodName='deleteChildQLI';           
            outputmap.put('error','OK');
            options.put('useQueueableApexRemoting',true); 
            inputmap.put('ContextId',qli.Id);
            ANA_AP11_DeleteChildQLI actct=new ANA_AP11_DeleteChildQLI();
            Boolean approvalRes= actct.invokeMethod(methodName,inputmap,outputmap,options);  
            system.assertEquals(true,approvalRes);  
            
        }
    }
    /*This method will test the deleteChildQLI in negative scenario*/
    static testmethod void delelteQLINegative()
    {
        Map<String,Object> inputmap=new Map<String,Object>();
        Map<String,Object> outputmap=new Map<String,Object>();
        Map<String,Object> options=new Map<String,Object>();
        String methodName='deleteChildQLI';           
        outputmap.put('error','OK');
        options.put('useQueueableApexRemoting',true); 
        inputmap.put('ContextId',null);
        ANA_AP11_DeleteChildQLI actct=new ANA_AP11_DeleteChildQLI();
        Boolean approvalRes= actct.invokeMethod(methodName,inputmap,outputmap,options); 
        system.assertEquals(true,approvalRes);  
    }
    
}