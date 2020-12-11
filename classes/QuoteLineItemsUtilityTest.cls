/*
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * Name              QuoteLineItemsUtilityTest
     * Author            Deloitte offshore (Gladiators)
     * ModifiedBy        Deloitte offshore (Gladiators)
     * Version           v1.0
     * CreatedDate       16th March 2020
     * User Story        APEX CPU TIME LIMIT - ICR Generation ISSUE 
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * @Description      
     * This is a test class for QuoteLineItemsUtility and it tests negative and positive scenarios.
     * 
     * -----------------------------------------------------------------------------------------------------------------------------------------------------------------
     * FUNCTIONAL TEST LOGIC
     * ----------------------------------------------------------------------------------------------------------------------------------------------------------------
     * 1 - qliUtilityTestDataSetup() 
     *          > TestSetup Method to create the required Test Data
     * 
     * 2 - testCreateQliRec()
     *          > Checks if the code handles Update probability on Insert of Qli.
     * 
     * 3 - testUpdateQliRec()
     *          > Checks if the code handles Update probability on Update of Qli.
     * 
     * 4 - testUpdateQliRecNegative()
     *          > Checks if the negative scenario is handling properly.
     * 
     * 4 - testCasteLightRec()
     *          > Checks if the castlight functionality works.
     *
     * 4 - testCasteLightRecNegative()
     *          > Checks if the Negative scenarios are handling properly.
     *
     * 4 - testLHOLAndANAonQuoteRec()
     *          > Checks the logic of National Records.
     *
     * 4 - testLHOLAndANAonQuoteRecNegative()
     *          > Checks if the negative Scenarios are handling properly for National Accounts.
     *
     * Additional information
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * Changes
     * vX.X(Version)            Name
     * Date                     Explanation
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    */
@isTest
public class QuoteLineItemsUtilityTest{
    
    @testSetup 
    static void qliUtilityTestDataSetup(){
        List<Account> listAccount = new List<Account>(TestDataFactory.createAccountSICList(1, staticVariableClass.AccountName, 
                                                                                           staticVariableClass.testAccBillingStreet, staticVariableClass.testAccBillingCity, 
                                                                                           staticVariableClass.testAccBillingState, staticVariableClass.testAccBillingPostalCode, 
                                                                                           staticVariableClass.testAccBillingCountry, staticVariableClass.AK));
        listAccount[0].Situs_State__c =  staticVariableClass.California;
        listAccount[0].Pooled_Non_Pooled__c = staticVariableClass.POOLED; 
        listAccount[0].RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Account).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGProspect).getRecordTypeId();
        listAccount[0].Anthem_Entity__c = staticVariableClass.Entity;
        listAccount[0].Mailing_Address_Same_as_Physical_Address__c = true;
        listAccount[0].Physical_County__c =staticVariableClass.GroupNum;
        listAccount[0].Anthem_Entity__c = staticVariableClass.Entity;
        insert listAccount;
        
        Account oNationalAcc = listAccount[0].clone();
        oNationalAcc.Name = staticVariableClass.userFirstName;
        oNationalAcc.Anthem_Entity__c = staticVariableClass.NATIONAL_ACCOUNTS;
        insert oNationalAcc;
        
        List<Opportunity> listOppty = new List<Opportunity>(TestDataFactory.createOpportunityList(1, staticVariableClass.OpportunityName,listAccount[0]));
        insert listOppty;
        
        Opportunity oNaOppty = listOppty[0].clone();
        oNaOppty.AccountId = oNationalAcc.Id;
        insert oNaOppty;
        
        Group__c oGrp=TestDataFactory.createGroup(listAccount[0].id,false);
        insert oGrp;
        
        Group__c oNaGrp = TestDataFactory.createGroup(oNationalAcc.id,false);
        insert oNaGrp;
        
        List<Quote> listqte=new List<Quote>(TestDataFactory.Quote(staticVariableClass.DNCStrPath,1,listOppty[0]));
        listqte[0].GroupNumber__c=oGrp.id;
        insert listqte;
        
        Quote oNaQte = listQte[0].clone();
        oNaQte.Name = staticVariableClass.userAlias;
        oNaQte.OpportunityId = oNaOppty.Id;
        insert oNaQte;
        
        List<Product2> listMedicalProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemLifeProdName,1));
        listMedicalProd[0].Category__c = staticVariableClass.Product;
        
        List<Product2> listMedicalPlanProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        listMedicalPlanProd[0].Category__c = staticVariableClass.Plan;
        
        List<Product2> listVisionPlan = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.OpportunityName,1));
        listVisionPlan[0].Category__c = staticVariableClass.Plan;
        listVisionPlan[0].Product_Type__c = staticVariableClass.Vision;
        
        List<Product2> listHwProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.HW_LIVE_HEALTH_ONLINE,1));
        listHwProd[0].Bundle__c = staticVariableClass.FIXED;
        listHwProd[0].Category__c = staticVariableClass.Product;
        
        insert new list<Product2>  {listMedicalPlanProd[0], listMedicalProd[0],listVisionPlan[0], listHwProd[0]};
            
        List<PricebookEntry> listProdPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listMedicalProd[0]));
        List<PricebookEntry> listPlanPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listMedicalPlanProd[0]));
        List<PricebookEntry> listVisionPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listVisionPlan[0]));
        List<PricebookEntry> listHwPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listHwProd[0]));
        insert new list<PricebookEntry> {listProdPbe[0] , listVisionPbe[0] , listHwPbe[0], listPlanPbe[0]};
            
        List<QuoteLineItem> listMedicalQliParent= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCStrPath, 1,listqte[0],listMedicalProd[0], listProdPbe[0]));
        listMedicalQliParent[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        listMedicalQliParent[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listMedicalQliParent[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listMedicalQliParent[0].ProductStage__c= staticVariableClass.Renewed;
        listMedicalQliParent[0].put('Upsell__c','');//As Assigning null to string will throw "String Hardcoded" error, "put" method is used.
        
        insert listMedicalQliParent;
        
        List<QuoteLineItem> listMedicalQliChild1= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc, 1,listqte[0],listMedicalPlanProd[0], listPlanPbe[0]));
        listMedicalQliChild1[0].ParentQuoteLineItem__c = listMedicalQliParent[0].Id;
        listMedicalQliChild1[0].put('Upsell__c','');
        listMedicalQliChild1[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        listMedicalQliChild1[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild1[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild1[0].ProductStage__c= staticVariableClass.Termed;
        
        List<QuoteLineItem> listMedicalQliChild2= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc2, 1,listqte[0],listMedicalPlanProd[0], listPlanPbe[0]));
        listMedicalQliChild2[0].ParentQuoteLineItem__c = listMedicalQliParent[0].Id;
        listMedicalQliChild2[0].put('Upsell__c','');
        listMedicalQliChild2[0].Product_Term_Years_Left__c =staticVariableClass.Termone;
        listMedicalQliChild2[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild2[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild2[0].ProductStage__c=staticVariableClass.InProgress;
        
        List<QuoteLineItem> listVisionQli= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc, 1,listqte[0],listVisionPlan[0], listVisionPbe[0]));
        listVisionQli[0].Product2ID = listVisionPlan[0].ID;
        listVisionQli[0].put('Upsell__c','');
        listVisionQli[0].Quantity =  staticVariableClass.QuantityOrPrice;
        listVisionQli[0].UnitPrice =  staticVariableClass.QuantityOrPrice;
        listVisionQli[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        listVisionQli[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listVisionQli[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listVisionQli[0].ProductStage__c= staticVariableClass.JEOPARDY;
        
        insert new list<QuoteLineItem>  {listMedicalQliChild1[0], listMedicalQliChild2[0],listVisionQli[0] };
    }
    
    @isTest
    static void testCreateQliRec(){
        
        List<Quote> listQte = new List<Quote>([select ID from Quote where Name=:staticVariableClass.DNCStrPath]);
        List<Product2> listProd = new List<Product2>([select ID from Product2 where Name=:staticVariableClass.AnthemLifeProdName]);
        List<PricebookEntry> listPriceBk = new List<PricebookEntry>([select ID from PricebookEntry where Product2.Id =: listProd[0].Id]);
        
        List<QuoteLineItem> listRenewedQli= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCStrPath, 1,listQte[0],listProd[0], listPriceBk[0]));
        listRenewedQli[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        listRenewedQli[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listRenewedQli[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listRenewedQli[0].ProductStage__c = staticVariableClass.Renewed;
        listRenewedQli[0].Members__c = 21;
        listRenewedQli[0].put('Upsell__c','');
        
        Test.startTest();
        
        QuoteLineItem oQliTermed = listRenewedQli[0].clone();
        oQliTermed.ProductStage__c = staticVariableClass.Termed;
        
        QuoteLineItem oQliInProgress = listRenewedQli[0].clone();
        oQliInProgress.ProductStage__c = staticVariableClass.InProgress;
        
        QuoteLineItem oQliJeopardy = listRenewedQli[0].clone();
        oQliJeopardy.ProductStage__c = staticVariableClass.JEOPARDY;
        
        insert new List<QuoteLineItem>{ listRenewedQli[0], oQliTermed, oQliInProgress, oQliJeopardy };
            
            for(QuoteLineItem oQli : [select id, Probability__c,ProductStage__c from QuoteLineItem ]){
                if(oQli.ProductStage__c == staticVariableClass.Renewed){
                    System.assertEquals(staticVariableClass.HUNDRED_PERCENT,oQli.Probability__c,staticVariableClass.assertEquals);
                }else if(oQli.ProductStage__c == staticVariableClass.Termed){
                    System.assertEquals(staticVariableClass.LgQliUpdateProdProbability,oQli.Probability__c,staticVariableClass.assertEquals);
                }else if(oQli.ProductStage__c == staticVariableClass.InProgress){
                    System.assertEquals(staticVariableClass.TEN_PERCENT,oQli.Probability__c,staticVariableClass.assertEquals);
                }else if(oQli.ProductStage__c == staticVariableClass.JEOPARDY){
                    System.assertEquals(staticVariableClass.FIFTY_PERCENT,oQli.Probability__c,staticVariableClass.assertEquals);
                }
            }
        
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateQliRec(){
        List<QuoteLineItem> listQliToUpdate = new List<QuoteLineItem>();
        for(QuoteLineItem oQli : [select id, Probability__c,ProductStage__c from QuoteLineItem ]){
            
            if(oQli.ProductStage__c == staticVariableClass.Renewed){
                oQli.ProductStage__c = staticVariableClass.Termed;
                listQliToUpdate.add(oQli);
            }else if(oQli.ProductStage__c == staticVariableClass.Termed){
                oQli.ProductStage__c = staticVariableClass.InProgress;
                listQliToUpdate.add(oQli);
            }else if(oQli.ProductStage__c == staticVariableClass.InProgress){
                oQli.ProductStage__c= staticVariableClass.JEOPARDY;
                listQliToUpdate.add(oQli);
            }else if(oQli.ProductStage__c == staticVariableClass.JEOPARDY){
                oQli.ProductStage__c = staticVariableClass.Renewed;
                listQliToUpdate.add(oQli);
            }
        }
        
        Test.startTest();
        if(listQliToUpdate.size()>0 && !listQliToUpdate.isEmpty()){
            Update listQliToUpdate;
        }
        
        for(QuoteLineItem oQli : [select id, Probability__c,ProductStage__c from QuoteLineItem ]){
            if(oQli.ProductStage__c == staticVariableClass.Renewed){
                System.assertEquals(staticVariableClass.HUNDRED_PERCENT,oQli.Probability__c,staticVariableClass.assertEquals);
            }else if(oQli.ProductStage__c == staticVariableClass.Termed){
                System.assertEquals(staticVariableClass.LgQliUpdateProdProbability,oQli.Probability__c,staticVariableClass.assertEquals);
            }else if(oQli.ProductStage__c == staticVariableClass.InProgress){
                System.assertEquals(staticVariableClass.TEN_PERCENT,oQli.Probability__c,staticVariableClass.assertEquals);
            }else if(oQli.ProductStage__c == staticVariableClass.JEOPARDY){
                System.assertEquals(staticVariableClass.FIFTY_PERCENT,oQli.Probability__c,staticVariableClass.assertEquals);
            }
        }
        Test.stopTest();
    }
     @isTest
    static void testUpdateQliRecNegative(){
        Test.startTest();
            for(QuoteLineItem oQli : [select id, Probability__c,ProductStage__c from QuoteLineItem ]){
                if(oQli.ProductStage__c == staticVariableClass.Renewed){
                    System.assertNotEquals(staticVariableClass.LgQliUpdateProdProbability,oQli.Probability__c,staticVariableClass.assertNotEquals);
                }else if(oQli.ProductStage__c == staticVariableClass.Termed){
                    System.assertNotEquals(staticVariableClass.HUNDRED_PERCENT,oQli.Probability__c,staticVariableClass.assertNotEquals);
                }else if(oQli.ProductStage__c == staticVariableClass.InProgress){
                    System.assertNotEquals(staticVariableClass.FIFTY_PERCENT,oQli.Probability__c,staticVariableClass.assertNotEquals);
                }else if(oQli.ProductStage__c == staticVariableClass.JEOPARDY){
                    System.assertNotEquals(staticVariableClass.TEN_PERCENT,oQli.Probability__c,staticVariableClass.assertNotEquals);
                }
            }
        Test.stopTest();
    }
    
    @isTest
    static void testCasteLightRec(){
      Test.startTest();
            List<QuoteLineItem> listQli = [Select id, Members__c from QuoteLineItem where ProductStage__c = : staticVariableClass.Renewed];
            listQli[0].Members__c = 45;
            Update listQli;
            QuoteLineItem oQli = [SELECT id, Members__c from QuoteLineItem where ProductStage__c = : staticVariableClass.Renewed];
            System.assertEquals(45,oQli.Members__c,staticVariableClass.assertEquals);
        Test.stopTest();
    }
     @isTest
    static void testCasteLightRecNegative(){
      Test.startTest();
            QuoteLineItem oQli = [SELECT id, Members__c from QuoteLineItem where ProductStage__c = : staticVariableClass.Renewed];
            System.assertNotEquals(45,oQli.Members__c,staticVariableClass.assertNotEquals);
        Test.stopTest();
    }
    
    @isTest
    static void testLHOLAndANAonQuoteRec(){
        
        List<Quote> listQte = new List<Quote>([select ID from Quote where Name=:staticVariableClass.userAlias]);
        List<Product2> listProd = new List<Product2>([select ID from Product2 where Name = : staticVariableClass.HW_LIVE_HEALTH_ONLINE]);
        List<Product2> listProdChild = new List<Product2>([select ID from Product2 where Name =: staticVariableClass.AnthemDentalProdName]);
        List<PricebookEntry> listPriceBk = new List<PricebookEntry>([select ID from PricebookEntry where Product2.Id =: listProd[0].Id]);   
        List<PricebookEntry> listPriceBkChild = new List<PricebookEntry>([select ID from PricebookEntry where Product2.Id =: listProdChild[0].Id]);
        
        Test.startTest();
        
            List<QuoteLineItem> listHwQli= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCStrPath, 1,listQte[0],listProd[0], listPriceBk[0]));
            listHwQli[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
            listHwQli[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
            listHwQli[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
            listHwQli[0].ProductStage__c = staticVariableClass.Sold;
            listHwQli[0].Probability__c = staticVariableClass.HUNDRED_PERCENT;
            listHwQli[0].Members__c = 21;
            listHwQli[0].put('Upsell__c','');
            insert listHwQli;
            
            List<QuoteLineItem> listHwQliChild = new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc, 1,listQte[0],listProdChild[0], listPriceBkChild[0]));
            listHwQliChild[0].ParentQuoteLineItem__c = listHwQli[0].Id;
            listHwQliChild[0].put('Upsell__c','');
            listHwQliChild[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
            listHwQliChild[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
            listHwQliChild[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
            listHwQliChild[0].ProductStage__c = staticVariableClass.Sold;
            listHwQliChild[0].Probability__c = staticVariableClass.HUNDRED_PERCENT;
            insert listHwQliChild;
            
            Quote oQte = [Select Id ,LHOL_Q__c FROM QUOTE WHERE ID = :listQte[0].Id LIMIT 1];
            System.assertEquals(staticVariableClass.UpsellYes, oQte.LHOL_Q__c, staticVariableClass.assertEquals);
            
            listHwQli[0].ProductStage__c = staticVariableClass.Renewed;
            update listHwQli;
            
            listHwQliChild[0].ProductStage__c = staticVariableClass.Renewed;
            update listHwQliChild;
            
            Quote oQteAfterUpdate = [Select Id ,LHOL_Q__c FROM QUOTE WHERE ID = :listQte[0].Id LIMIT 1];
            System.assertEquals(staticVariableClass.UpsellYes, oQteAfterUpdate.LHOL_Q__c, staticVariableClass.assertEquals);
        
        Test.stopTest();
     }
     @isTest
    static void testLHOLAndANAonQuoteRecNegative(){
        
        List<Quote> listQte = new List<Quote>([select ID from Quote where Name=:staticVariableClass.userAlias]);
        List<QuoteLineItem> listQli = [Select Id from QuoteLineItem where QuoteId = : listQte[0].Id];
        
        Test.startTest();
            delete listQli;
            Quote oQte = [Select Id ,LHOL_Q__c FROM QUOTE WHERE ID = :listQte[0].Id LIMIT 1];
            System.assertNotEquals(staticVariableClass.UpsellYes, oQte.LHOL_Q__c, staticVariableClass.assertEquals);
        Test.stopTest();
     }
}