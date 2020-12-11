/*
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * Name              LGHWAssociatePackageToPlans_Test 
     * Author            Deloitte offshore (Gladiators)
     * ModifiedBy		 Deloitte offshore (Gladiators)
     * Version			 v1.0
     * CreatedDate       18th November 2019
     * User Story        Association of package to multiple plans
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * @Description	     
     * This is a test class for LGHWAssociatePackageToPlansController and it tests negative and positive scenarios with bulk data.
     * 
     * -----------------------------------------------------------------------------------------------------------------------------------------------------------------
     * FUNCTIONAL TEST LOGIC
     * ----------------------------------------------------------------------------------------------------------------------------------------------------------------
     * 1 - lGAssociatePackageToPlansDataSetup() 
     * 			> TestSetup Method to create the required Test Data
     * 
     * 2 - associateExistingPkgTest()
     * 			> Check if the ivoke method returns value when attaching existing package to other medical plans
     * 
     * 3 - invokeMethodBuyUpTest()
     * 			> Checks if the invoke method returns value for Commercial buyUp flow and verify the result
     * 
     * 4 - invokeMethodClinicalTest()
     * 			> Checks if the invoke method returns value for Commercial Clinical flow and verify the result
     * 
     * 5 - asociateNewPackageNegativeTest()
     * 			>  Checks if the package id not attached for null inputs in New package flow
     *
 	 * 6 - asociateExistingPackageNegativeTest()
     * 			> Checks if the package id not attached for null inputs in existing package flow
     * 
     * 7 - exceptionBlockTest()
     * 			> Checks if the exceptions are handling properly.
     * 
     * Additional information
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * Changes
     * vX.X(Version)			Name
     * Date						Explanation
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    */
@isTest
public class LGHWAssociatePackageToPlans_Test {
    
    @testSetup
    static void lGAssociatePackageToPlansDataSetup(){
        
        List<Account> listAccount = new List<Account>(TestDataFactory.createAccountSICList(1, staticVariableClass.AccountName, 
                                                        staticVariableClass.testAccBillingStreet, staticVariableClass.testAccBillingCity, 
                                                        staticVariableClass.testAccBillingState, staticVariableClass.testAccBillingPostalCode, 
                                                        staticVariableClass.testAccBillingCountry, staticVariableClass.AK));
        listAccount[0].Situs_State__c =  staticVariableClass.California;
        listAccount[0].RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Account).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGProspect).getRecordTypeId();
        listAccount[0].Anthem_Entity__c = staticVariableClass.Entity;
        listAccount[0].Mailing_Address_Same_as_Physical_Address__c = true;
        listAccount[0].Physical_County__c =staticVariableClass.GroupNum;
        insert listAccount;

        List<Opportunity> listOppty = new List<Opportunity>(TestDataFactory.createOpportunityList(1, staticVariableClass.OpportunityName,listAccount[0]));
        insert listOppty;
 
        Group__c oGrp=TestDataFactory.createGroup(listAccount[0].id,false);
        insert oGrp;
        
        List<Quote> listQuote=new List<Quote>(TestDataFactory.Quote(staticVariableClass.DNCStrPath,1,listOppty[0]));
        listQuote[0].GroupNumber__c=oGrp.id;
        insert listQuote;
        
        List<Product2> listMedicalProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemLifeProdName,1));
        listMedicalProd[0].Category__c = staticVariableClass.Product;
        
        List<Product2> listMedicalPlanProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.HPCCCODE_PRODUCT_NAME,1));
        listMedicalPlanProd[0].Category__c = staticVariableClass.Plan;
        
        List<Product2> listMedicalPlanProd1 = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        listMedicalPlanProd[0].Category__c = staticVariableClass.Plan;
        
        List<Product2> listMedicalPlanPkg = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AccountName,1));
        listMedicalPlanPkg[0].Category__c = staticVariableClass.Product;
        
        List<Product2> listMedicalPlanPgm = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AHG_PRODUCT_NAME,1));
        listMedicalPlanPgm[0].Category__c = staticVariableClass.PROGRAM;
        
        List<Product2> listClinicalProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.userFirstName,1));
        listClinicalProd[0].Category__c = staticVariableClass.Product;
        listClinicalProd[0].HPCC_Code__c = staticVariableClass.STD_PROD_TYPE;
        
        List<Product2> listClinicalPgm1 = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.userLastName,1));
        listClinicalPgm1[0].Category__c = staticVariableClass.PROGRAM;
        
        List<Product2> listClinicalPgm2 = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.userLastName+2,1));
        listClinicalPgm2[0].Category__c = staticVariableClass.PROGRAM;
        
        List<Product2> listClinicalPgm3 = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.userLastName+3,1));
        listClinicalPgm3[0].Category__c = staticVariableClass.PROGRAM;
        
        List<Product2> listClinicalPgm4 = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AHG_PRODUCT_NAME,1));
        listClinicalPgm3[0].Category__c = staticVariableClass.PROGRAM;
        
        List<Product2> listBuyUpProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        listBuyUpProd[0].Category__c = staticVariableClass.Product;
        listBuyUpProd[0].Minimum_Range__c = 1000;
        listBuyUpProd[0].NALGProdRecordType__c =staticVariableClass.COMMERCIAL_BUY_UPS;
        listBuyUpProd[0].ProductActive__c = true;
        
        insert new List<Product2>  {listMedicalPlanProd[0], listMedicalProd[0], listMedicalPlanProd1[0], listClinicalProd[0],listClinicalPgm1[0], 
                                    listClinicalPgm2[0], listClinicalPgm3[0], listBuyUpProd[0],listMedicalPlanPkg[0],listMedicalPlanPgm[0], listClinicalPgm4[0]};
        
        List<PricebookEntry> listpbe  = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listMedicalProd[0]));
        List<PricebookEntry> listpbe1 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listClinicalProd[0]));
        List<PricebookEntry> listpbe2 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listClinicalPgm1[0]));
        List<PricebookEntry> listpbe3 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listClinicalPgm2[0]));
        List<PricebookEntry> listpbe4 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listClinicalPgm3[0]));
        List<PricebookEntry> listpbe5 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listBuyUpProd[0]));
        List<PricebookEntry> listpbe6 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listMedicalPlanPkg[0]));
        List<PricebookEntry> listpbe7 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listMedicalPlanPgm[0]));
        List<PricebookEntry> listpbe8 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listClinicalPgm4[0]));
        List<PricebookEntry> listpbe9 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listMedicalPlanProd[0]));
        List<PricebookEntry> listpbe0 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listMedicalPlanProd1[0]));
   
        insert new List<PricebookEntry> {listpbe[0], listpbe1[0], listpbe2[0], listpbe3[0], listpbe4[0], listpbe5[0], listpbe6[0],
            							 listpbe7[0], listpbe8[0], listpbe9[0], listpbe0[0]};

        List<QuoteLineItem> listMedicalQliParent= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCStrPath, 1,listQuote[0],listMedicalProd[0], listpbe[0]));
        listMedicalQliParent[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        listMedicalQliParent[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listMedicalQliParent[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listMedicalQliParent[0].ProductStage__c= staticVariableClass.Sold;
        listMedicalQliParent[0].put('Upsell__c','');
        
        insert listMedicalQliParent;
        
        List<QuoteLineItem> listMedicalQliChild1= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc, 1,listQuote[0],listMedicalPlanProd[0], listpbe9[0]));
        listMedicalQliChild1[0].ParentQuoteLineItem__c = listMedicalQliParent[0].Id;
        listMedicalQliChild1[0].put('Upsell__c','');
        listMedicalQliChild1[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        listMedicalQliChild1[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild1[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild1[0].ProductStage__c= staticVariableClass.Sold;
        
        List<QuoteLineItem> listMedicalQliChild2= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc2, 1,listQuote[0],listMedicalPlanProd1[0], listpbe0[0]));
        listMedicalQliChild2[0].ParentQuoteLineItem__c = listMedicalQliParent[0].Id;
        listMedicalQliChild2[0].put('Upsell__c','');
        listMedicalQliChild2[0].Product_Term_Years_Left__c =staticVariableClass.Termone;
        listMedicalQliChild2[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild2[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild2[0].ProductStage__c= staticVariableClass.Sold;
        
        insert new List<QuoteLineItem>  {listMedicalQliChild1[0], listMedicalQliChild2[0] };
        
        List<QuoteLineItem> listMedicalQliPkgProd = new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc2, 1,listQuote[0],listMedicalPlanPkg[0], listpbe6[0]));
        listMedicalQliChild2[0].ParentQuoteLineItem__c = listMedicalQliChild1[0].Id;
        listMedicalQliChild2[0].put('Upsell__c','');
        listMedicalQliChild2[0].Product_Term_Years_Left__c =staticVariableClass.Termone;
        listMedicalQliChild2[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild2[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild2[0].ProductStage__c= staticVariableClass.Sold;
        
        insert new List<QuoteLineItem>  {listMedicalQliPkgProd[0]};
        
        List<QuoteLineItem> listMedicalQliPkgProg = new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc2, 1,listQuote[0],listMedicalPlanPgm[0], listpbe7[0]));
        listMedicalQliChild2[0].ParentQuoteLineItem__c = listMedicalQliPkgProd[0].Id;
        listMedicalQliChild2[0].put('Upsell__c','');
        listMedicalQliChild2[0].LG_Master_AHG__c = true;
        listMedicalQliChild2[0].RecordType__c = staticVariableClass.AHG_RECORDTYPE;
        listMedicalQliChild2[0].Product_Term_Years_Left__c =staticVariableClass.Termone;
        listMedicalQliChild2[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild2[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild2[0].ProductStage__c= staticVariableClass.Sold;
        
        insert new List<QuoteLineItem>  {listMedicalQliPkgProg[0]};
    }
   
    @isTest
	static void associateExistingPkgTest(){
	    Map<String,Object> mapInput     = new Map<String,Object>();
        Map<String,Object> mapOutput    = new Map<String,Object>();
        Map<String,Object> mapOptions   = new Map<String,Object>();
        String sMethodName              = staticVariableClass.ASSOCIATE_EXISTING_PKG;
        
        mapInput.put(staticVariableClass.PLAN_LIST,[select id,QuoteId,Quantity,UnitPrice,ProductStage__c, RecordType__c,OppType__c,Funding__c,Financing__c
                                                       from QuoteLineItem where ProductCategory__c=: staticVariableClass.Plan]);
        mapInput.put(staticVariableClass.CURRENT_PLAN,[select id,QuoteId,Quantity,UnitPrice,ProductStage__c, RecordType__c,OppType__c,Funding__c,Financing__c
                                                        from QuoteLineItem where ProductCategory__c=: staticVariableClass.Plan][0]);
        mapInput.put(staticVariableClass.PRODUCT_SELECTION, 
                       new Map<String, Object>{staticVariableClass.PARENT_PRODUCT
                          => new Map<String, Object>{staticVariableClass.SELECTED_PARENT_PRODUCT =>[select id from product2 where Name=:staticVariableClass.AccountName]}});
        Test.startTest();
            LGHWAssociatePackageToPlansController oPkgToPlan = new LGHWAssociatePackageToPlansController();
            System.assertNotEquals(true, oPkgToPlan.invokeMethod(sMethodName,mapInput,mapOutput,mapOptions),staticVariableClass.assertEquals);
        Test.stopTest();
	}
   
	@isTest
	static void invokeMethodBuyUpTest(){
	    Map<String,Object> mapInput     = new Map<String,Object>();
        Map<String,Object> mapOutput    = new Map<String,Object>();
        Map<String,Object> mapOptions   = new Map<String,Object>();
        String sMethodName              = staticVariableClass.ASSOCIATE_NEW_PKG;
        
        mapInput.put(staticVariableClass.PLAN_LIST,[select id,QuoteId,Quantity,UnitPrice,ProductStage__c, RecordType__c,OppType__c,Funding__c,Financing__c
                                                        from QuoteLineItem where ProductCategory__c=: staticVariableClass.Plan]);
        mapInput.put(staticVariableClass.COMMERCIAL_BUYUP_SELECTION,
                     		new Map<String,Object>{staticVariableClass.FINAL_PROGRAM_LIST => 
                                	[select id from product2 where Category__c=:staticVariableClass.PROGRAM]});  
        mapInput.put(staticVariableClass.PRODUCT_SELECTION, new Map<String, Object>{staticVariableClass.COMMERCIAL_SELECTIONS
                           => new Map<String, Object>{staticVariableClass.COMMERCIAL_FLOW => staticVariableClass.COMMERCIAL_BUY_UPS}}); 
        Test.startTest();
        LGHWAssociatePackageToPlansController oPkgToPlan = new LGHWAssociatePackageToPlansController();
        System.assertEquals(true, oPkgToPlan.invokeMethod(sMethodName,mapInput,mapOutput,mapOptions),staticVariableClass.assertEquals);
        for(QuoteLineItem oQli : [select id,HPCC_Code__c from QuoteLineItem where ProductCategory__c=: staticVariableClass.Plan]){
            System.assertEquals(null, oQli.HPCC_Code__c ,staticVariableClass.assertEquals);
        }
        Test.stopTest();
	}
   @isTest
	static void invokeMethodClinicalTest(){
	    Map<String,Object> mapInput     = new Map<String,Object>();
        Map<String,Object> mapOutput    = new Map<String,Object>();
        Map<String,Object> mapOptions   = new Map<String,Object>();
        String sMethodName              = staticVariableClass.ASSOCIATE_NEW_PKG;
        
        mapInput.put(staticVariableClass.PLAN_LIST, [select id,QuoteId,Quantity,UnitPrice,ProductStage__c, RecordType__c,OppType__c,Funding__c,Financing__c
                                                        		from QuoteLineItem where ProductCategory__c=: staticVariableClass.Plan]);
        mapInput.put(staticVariableClass.PRODUCT_SELECTION, new Map<String, Object>{staticVariableClass.COMMERCIAL_SELECTIONS
                           					=> new Map<String, Object>{staticVariableClass.COMMERCIAL_FLOW => staticVariableClass.COMMERCIAL_CLINICAL}}); 
        mapInput.put(staticVariableClass.COMMERCIAL_CLINICAL_NODE,
                     						new Map<String, Object>{staticVariableClass.PARENT_PRODUCT_ID => (String)[
                                                		SELECT Id from Product2 where Name =: staticVariableClass.userFirstName].Id});
        mapInput.put(staticVariableClass.FINAL_PROGRAM_LIST, [select id from product2 where Category__c=:staticVariableClass.PROGRAM]);
        mapInput.put(staticVariableClass.INCENTIVE_TYPE, new Map<String, Object>{staticVariableClass.INCENTIVE_TYPE_SELECT => staticVariableClass.INCENTIVE_TYPE_GC});  
        Test.startTest();
            LGHWAssociatePackageToPlansController oPkgToPlan = new LGHWAssociatePackageToPlansController();
        	System.assertEquals(true, oPkgToPlan.invokeMethod(sMethodName, mapInput, mapOutput, mapOptions), staticVariableClass.assertEquals);
        	for(QuoteLineItem oQli : [Select id,Incentive_Type__c from QuoteLineItem where ParentQuoteLineItem__c IN :
                                      [select id from QuoteLineItem where ProductCategory__c=: staticVariableClass.Plan]]){
                     System.assertEquals(staticVariableClass.INCENTIVE_TYPE_GC, oQli.Incentive_Type__c, staticVariableClass.assertEquals);
            }
        Test.stopTest();
	}
 	@isTest
	static void asociateNewPackageNegativeTest(){
	    Map<String,Object> mapInput     = new Map<String,Object>();
        Map<String,Object> mapOutput    = new Map<String,Object>();
        Map<String,Object> mapOptions   = new Map<String,Object>();
        String sMethodName              = staticVariableClass.ASSOCIATE_NEW_PKG;
        Test.startTest();
            LGHWAssociatePackageToPlansController oPkgToPlan = new LGHWAssociatePackageToPlansController();
            System.assertNotEquals(true, oPkgToPlan.invokeMethod(sMethodName,mapInput,mapOutput,mapOptions),staticVariableClass.assertNotEquals);
        	System.assertEquals(0,([select id from QuoteLineItem where ParentQuoteLineItem__c IN :
                                   	[select id from QuoteLineItem where ProductCategory__c=: staticVariableClass.Plan]]).size(),staticVariableClass.assertEquals);
        Test.stopTest();
	}
	@isTest
	static void asociateExistingPackageNegativeTest(){
	    Map<String,Object> mapInput     = new Map<String,Object>();
        Map<String,Object> mapOutput    = new Map<String,Object>();
        Map<String,Object> mapOptions   = new Map<String,Object>();
        String sMethodName              = staticVariableClass.ASSOCIATE_EXISTING_PKG;
         
        Test.startTest();
            LGHWAssociatePackageToPlansController oPkgToPlan = new LGHWAssociatePackageToPlansController();
            System.assertNotEquals(true, oPkgToPlan.invokeMethod(sMethodName,mapInput,mapOutput,mapOptions),staticVariableClass.assertNotEquals);
        	System.assertEquals(0,([select id from QuoteLineItem where ParentQuoteLineItem__c IN :
                                   	[select id from QuoteLineItem where ProductCategory__c=: staticVariableClass.Plan]]).size(),staticVariableClass.assertEquals);
        Test.stopTest();
	}
    @isTest
	static void exceptionBlockTest(){
	    Map<String,Object> mapInput        		= new Map<String,Object>();
        Map<String,Object> mapOutput       		= new Map<String,Object>();
        Map<String,Object> mapOptions         	= new Map<String,Object>();
        List<QuoteLineItem> listOldQliToDelete 	= new List<QuoteLineItem>();
        String sMethodName                  	= staticVariableClass.ASSOCIATE_NEW_PKG ;
        
        mapInput.put(staticVariableClass.PLAN_LIST,[select id,QuoteId,Quantity,UnitPrice,ProductStage__c, RecordType__c,OppType__c,Funding__c,Financing__c
                                                        from QuoteLineItem where ProductCategory__c=: staticVariableClass.Plan]);
        
        mapInput.put(staticVariableClass.PRODUCT_SELECTION, 
                       new Map<String, Object>{staticVariableClass.COMMERCIAL_SELECTIONS
                           => new Map<String, Object>{staticVariableClass.COMMERCIAL_FLOW => staticVariableClass.COMMERCIAL_BUY_UPS}}); 
        mapInput.put(staticVariableClass.COMMERCIAL_BUYUP_SELECTION,
                        new Map<String,Object>{staticVariableClass.FINAL_PROGRAM_LIST => [select id from product2 
                                                                                          where Category__c=:staticVariableClass.PROGRAM
                                                                                          and Name !=:staticVariableClass.AHG_PRODUCT_NAME]});
        delete([select id from PricebookEntry where product2id IN (select id from Product2 where Name =:staticVariableClass.userLastName)]);  
        Test.startTest();
            LGHWAssociatePackageToPlansController oPkgToPlan = new LGHWAssociatePackageToPlansController();
            System.assertEquals(true, oPkgToPlan.invokeMethod(sMethodName,mapInput,mapOutput,mapOptions),staticVariableClass.assertEquals);
        Test.stopTest();
	}
}