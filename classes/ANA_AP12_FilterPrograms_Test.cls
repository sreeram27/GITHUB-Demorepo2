/*@author:         Accenture
@date :          03/07/2017
@name :          ANA_AP12_FilterPrograms_Test
@description :   Test class to test the ANA_AP12_FilterPrograms class.
*/
@isTest
private class ANA_AP12_FilterPrograms_Test {
	private static final string NATIONALAMPROFILE='National Sales'; 
    private static final string CLAIMSYSTEM= 'CS90';
    /*This method will create test data for parent QLI.*/
    static QuoteLineItem createParentData()
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
        prod.name='Anthem Parent Product';
        Database.insert(prod);
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
        Database.insert(pbe);
        QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.Id, pbe.id);
        qli.Product2Id=prod.id;
        Database.insert(qli);
        return qli;
    }
    /*This method will create test data for child product.*/
	static QuoteLineItem createChildData()
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
        Product2 cpd1=ANA_UTIL01_TestMethods.createProduct(false);
        cpd1.name='Anthem Child Product1';
        Database.insert(cpd1);
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,cpd1.id);
        Database.insert(pbe);
        QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.Id, pbe.id);
        qli.Product2Id=cpd1.id;
        database.insert(qli);
        return qli;
    }
    /*This method will test the functionality of insertChildQLI method in positive scenario*/
    static testmethod void insertQLIPositive(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1 ]; 
        User usr=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        usr.UserName='postest@anthem.com';
        system.runAs(usr){
            QuoteLineItem qli= createParentData();
			QuoteLineItem childQli= createChildData();
			vlocity_ins__ProductChildItem__c vlcpc= new vlocity_ins__ProductChildItem__c();
            vlcpc.Name='Anthem Child Product1';
            vlcpc.vlocity_ins__ChildProductId__c=childQli.Product2Id;
            vlcpc.vlocity_ins__ChildLineNumber__c='1';
            vlcpc.vlocity_ins__ParentProductId__c =qli.Product2Id;            
            Database.insert(vlcpc);
            Map<String,Object> inputmap=new Map<String,Object>();
            Map<String,Object> outputmap=new Map<String,Object>();
            Map<String,Object> options=new Map<String,Object>();
            String methodName='getProviderGroupValues';           
            outputmap.put('error','OK');
            options.put('useQueueableApexRemoting',true); 
            inputmap.put('QLIid',qli.Id);
            inputmap.put('ProdId',qli.Product2Id);
            inputmap.put('Bundle','Fixed');
            ANA_AP12_FilterPrograms actct=new ANA_AP12_FilterPrograms();
            Boolean approvalRes= actct.invokeMethod(methodName,inputmap,outputmap,options);  
            system.assertEquals(true,approvalRes); 
             inputmap.put('Bundle','Variable');
            ANA_AP12_FilterPrograms vfp=new ANA_AP12_FilterPrograms();
            Boolean varRes= vfp.invokeMethod(methodName,inputmap,outputmap,options);  
            system.assertEquals(true,varRes); 
        }
    }
    /*This method will test the insertChildQLI in negative scenario*/
    static testmethod void insertChildQLINegative()
    {
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1 ]; 
        User usr=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        usr.UserName='postest@anthem.com';
    	system.runAs(usr){
        Map<String,Object> inputmap=new Map<String,Object>();
        Map<String,Object> outputmap=new Map<String,Object>();
        Map<String,Object> options=new Map<String,Object>();
        String methodName='getProviderGroupValues';           
        outputmap.put('error','OK');
        options.put('useQueueableApexRemoting',true); 
        inputmap.put('ProdId','null');
        inputmap.put('QLIid','null');
        ANA_AP12_FilterPrograms fpNt=new ANA_AP12_FilterPrograms();
        Boolean approvalRes= fpNt.invokeMethod(methodName,inputmap,outputmap,options);
        system.assertEquals(true,approvalRes);  
    	}   
    }
}