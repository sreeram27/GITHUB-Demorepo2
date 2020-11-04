/*
_________________________________________________________________________________________

@author         Deloitte offshore
@date           03/24/2018
@name           Test_DeleteQLI
@description    This is the test class for DeleteQLI and it tests negative and positive scenarios. 
_________________________________________________________________________________________
*/
@isTest
private class Test_DeleteQLI
{
    private static final String GET_QLI = staticVariableClass.DeleteQliGETQLI;
    private static final String GET_QLI_PLANS = staticVariableClass.DeleteQliGETQLIPlans;
    private static final String SPLIT_RECORD_SELECTION = staticVariableClass.DeleteQliSPLITRECORDSELECTION;
    private static final String QLI_PROD_LIST = staticVariableClass.DeleteQliQLIPRODLIST;
    private static final String QLI_ID = staticVariableClass.DeleteQliQLIID;
    private static final String CREATE_GROUP_QUOTEID  = staticVariableClass.CreateGrpQUOTEID;
    
    @testSetup 
    static void lGQliMassUpdateTestDataSetup(){
        List<Account> accountList = new List<Account>(TestDataFactory.createAccountSICList(1, staticVariableClass.AccountName, 
                                                        staticVariableClass.testAccBillingStreet, staticVariableClass.testAccBillingCity, 
                                                        staticVariableClass.testAccBillingState, staticVariableClass.testAccBillingPostalCode, 
                                                        staticVariableClass.testAccBillingCountry, staticVariableClass.AK));
        accountList[0].Situs_State__c =  staticVariableClass.California;
        accountList[0].RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Account).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGProspect).getRecordTypeId();
        accountList[0].Anthem_Entity__c = staticVariableClass.Entity;
        accountList[0].Mailing_Address_Same_as_Physical_Address__c = true;
        accountList[0].Physical_County__c =staticVariableClass.GroupNum;
         accountList[0].Group_Size__c = staticVariableClass.GROUP_SIZE_0_50;
        insert accountList;

        List<Opportunity> opptyList = new List<Opportunity>(TestDataFactory.createOpportunityList(1, staticVariableClass.OpportunityName,accountList[0]));
        insert opptyList;
 
        Group__c grp=TestDataFactory.createGroup(accountList[0].id,false);
        insert grp;
        
        List<Quote> qte=new List<Quote>(TestDataFactory.Quote(staticVariableClass.DNCStrPath,1,opptyList[0]));
        qte[0].GroupNumber__c=grp.id;
        insert qte;
        
        List<Product2> medicalProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemLifeProdName,1));
        medicalProd[0].Category__c = staticVariableClass.Product;
        
        List<Product2> medicalPlanProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        medicalPlanProd[0].Category__c = staticVariableClass.Plan;
        
        insert new List<Product2>  {medicalPlanProd[0], medicalProd[0] };
        
        List<PricebookEntry> pbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, medicalProd[0]));
        insert pbe;
        
        List<QuoteLineItem> medicalQliParent= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCStrPath, 1,qte[0],medicalProd[0], pbe[0]));
        medicalQliParent[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        medicalQliParent[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        medicalQliParent[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        medicalQliParent[0].ProductStage__c= staticVariableClass.Sold;
        medicalQliParent[0].put('Upsell__c','');//As Assigning null to string will throw "String Hardcoded" error, "put" method is used.
        
        insert medicalQliParent;
        
        List<QuoteLineItem> medicalQliChild1= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc, 1,qte[0],medicalPlanProd[0], pbe[0]));
        medicalQliChild1[0].ParentQuoteLineItem__c = medicalQliParent[0].Id;
        medicalQliChild1[0].put('Upsell__c','');
        medicalQliChild1[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        medicalQliChild1[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        medicalQliChild1[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        medicalQliChild1[0].ProductStage__c= staticVariableClass.Sold;
        
        List<QuoteLineItem> medicalQliChild2= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc2, 1,qte[0],medicalPlanProd[0], pbe[0]));
        medicalQliChild2[0].ParentQuoteLineItem__c = medicalQliParent[0].Id;
        medicalQliChild2[0].put('Upsell__c','');
        medicalQliChild2[0].Product_Term_Years_Left__c =staticVariableClass.Termone;
        medicalQliChild2[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        medicalQliChild2[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        medicalQliChild2[0].ProductStage__c= staticVariableClass.Sold;
        
        insert new List<QuoteLineItem>  {medicalQliChild1[0], medicalQliChild2[0] };
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name =: staticVariableClass.SYSTEM_ADMIN LIMIT 1];
        User userInstance = new User(LastName = staticVariableClass.userLastName, FirstName=staticVariableClass.userFirstName, 
                            Alias = staticVariableClass.userAlias,Email = staticVariableClass.userEmail, 
                            Username = staticVariableClass.userUsername, ProfileId = profileId.id, 
                            TimeZoneSidKey = staticVariableClass.userTimeZoneSidKey, 
                            LanguageLocaleKey = staticVariableClass.userLanguageLocaleKey, 
                            EmailEncodingKey = staticVariableClass.userEmailEncodingKey, 
                            LocaleSidKey = staticVariableClass.userLocaleSidKey,AllowQLIDelete__c = true);
        insert userInstance;
    }
    
    @isTest
    static void testExectueFlow(){
        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> inputMapValue = new Map<String,Object>();
        
        List<QuoteLineItem> qliList = [select id,HPCC_Code__c from QuoteLineItem 
                                                            where Quote.name=: staticVariableClass.DNCStrPath and 
                                                            Product2.Category__c =: staticVariableClass.Product limit 1];
                                                            
        System.assertEquals(1, qliList.size(), staticVariableClass.assertEquals);
        
        test.startTest();
        
            if(!qliList.isEmpty()) {
                inputMapValue.put(QLI_PROD_LIST, new List<Object>{new Map<String, Object>{QLI_ID => qliList[0].Id}});
                inputMap.put(CREATE_GROUP_QUOTEID, [select ID from Quote where Name=:staticVariableClass.DNCStrPath].Id);
                inputMap.put(SPLIT_RECORD_SELECTION, inputMapValue);
                
                List<User> userList = [select Id, Name, AllowQLIDelete__c, ProfileId,Profile.Name from User where AllowQLIDelete__c = true limit 1];
                
                System.assertEquals(1, userList.size(), staticVariableClass.assertEquals);
                
                system.runAs(userList[0]) {
                    System.assertEquals(true, new DeleteQLI().invokeMethod(GET_QLI, inputMap, outMap, null), staticVariableClass.assertEquals);
                    System.assertEquals(true, new DeleteQLI().invokeMethod(GET_QLI_PLANS,inputMap, outMap, null), staticVariableClass.assertEquals);
                }
                
                userList[0].AllowQLIDelete__c = false;
                update userList;
                
                system.runAs(userList[0]) {
                    System.assertEquals(true, new DeleteQLI().invokeMethod(GET_QLI, inputMap, outMap, null), staticVariableClass.assertEquals);
                }
            }
            
        test.stopTest();
    }
    
    @isTest
    static void testExectueNegativeFlow(){
        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> inputMapValue = new Map<String,Object>();
        
        test.startTest();
        
            List<User> userList = [select Id, Name, AllowQLIDelete__c, ProfileId,Profile.Name from User where AllowQLIDelete__c = true limit 1];
            
            System.assertEquals(1, userList.size(), staticVariableClass.assertEquals);
            
            system.runAs(userList[0]) {
                System.assertNotEquals(false, new DeleteQLI().invokeMethod(GET_QLI, inputMap, outMap, null), staticVariableClass.assertNotEquals);
                System.assertNotEquals(false, new DeleteQLI().invokeMethod(GET_QLI_PLANS,inputMap, outMap, null), staticVariableClass.assertNotEquals);
            }
            
            userList[0].AllowQLIDelete__c = false;
            update userList;
            
            system.runAs(userList[0]) {
                System.assertNotEquals(false, new DeleteQLI().invokeMethod(GET_QLI, inputMap, outMap, null), staticVariableClass.assertNotEquals);
            }
            
        test.stopTest();
    }
}