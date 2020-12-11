@isTest
public class LGHWQuoteLineItemActionsTest{
    @testSetup 
    static void lGQuoteLineItemCreate() {
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
        grp.ClaimSystem__c = '';
        insert grp;
        
        List<Quote> qte=new List<Quote>(TestDataFactory.Quote(staticVariableClass.DNCStrPath,1,opptyList[0]));
        qte[0].GroupNumber__c=grp.id;
        insert qte;
        
        List<Product2> planProd= new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        planProd[0].Product_Type__c = '';
        planProd[0].Category__c= staticVariableClass.Plan ;
        insert planProd;
        List<PricebookEntry> planPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, planProd[0]));
        insert planPbe ;
        
        List<Product2> parentProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        parentProd [0].Product_Type__c = '';
        parentProd [0].Category__c= staticVariableClass.Product; 
        parentProd [0].Funding_Type__c = staticVariableClass.FUNDING_TYPE;
        parentProd [0].Group_Size_Range__c = staticVariableClass.GROUP_SIZE_51_99;
        insert parentProd ;
        
        List<PricebookEntry> parentProdPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, parentProd [0]));
        insert parentProdPbe ;
        
        List<Product2> childProd= new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,2));
        childProd[0].Product_Type__c = '';
        childProd[0].Category__c= staticVariableClass.Product;
        childProd[0].Funding_Type__c = staticVariableClass.FUNDING_TYPE;
        childProd[0].Group_Size_Range__c = staticVariableClass.GROUP_SIZE_51_99;
        
        childProd[1].Name= staticVariableClass.AHG_PRODUCT_NAME;
        childProd[1].Product_Type__c = '';
        childProd[1].Category__c= staticVariableClass.Product;
        childProd[1].Funding_Type__c = staticVariableClass.FUNDING_TYPE;
        childProd[1].Group_Size_Range__c = staticVariableClass.GROUP_SIZE_51_99;
        
        insert childProd;
        
        List<PricebookEntry> childProdPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, childProd[0]));
        insert childProdPbe ;
        List<PricebookEntry> childProdPbe1 = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, childProd[1]));
        insert childProdPbe1 ;
        
        vlocity_ins__TriggerSetup__c objSetup = new vlocity_ins__TriggerSetup__c();
        objSetup = TestDataFactory.createTriggerSetup(objSetup);
        objSetup.Name=staticVariableClass.QLI_TRIGGERNAM_AFTERINSERT;
        insert objSetup;
         
        Product_HPCC_Codes__c objProHPCC = new Product_HPCC_Codes__c();
        objProHPCC = TestDataFactory.createProductHPCCCodes(objProHPCC ,parentProd[0].id );
        objProHPCC.PackageEffDt__c=Date.newinstance(system.today().year(),system.today().month(),1);
        insert objProHPCC;
         
         vlocity_ins__ProductChildItem__c objProdChildItem= new vlocity_ins__ProductChildItem__c();
         objProdChildItem =TestDataFactory.createProdChildItem(objProdChildItem,parentProd[0].Id,childProd[0].Id);
         insert objProdChildItem;
         
         vlocity_ins__ProductChildItem__c objProdChildItemAHG  = new vlocity_ins__ProductChildItem__c();
         objProdChildItemAHG  =TestDataFactory.createProdChildItem(objProdChildItemAHG  ,parentProd[0].Id,childProd[1].Id);
         insert objProdChildItemAHG;
    }
    @isTest 
    static void insertQLI(){ 
        Quote quo = [Select Id FROM Quote Limit 1];
        Product2 prod = [Select Id From Product2 Limit 1];
        PricebookEntry priceBook = [Select Id FROM PricebookEntry Limit 1];
        Test.startTest();
        //Inserting Plan QLIs
        
        List<QuoteLineItem> planQLI= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCStrPath,1,quo,prod,priceBook));
        planQLI[0].Quantity =   staticVariableClass.QuantityOrPrice;
        planQLI[0].UnitPrice = staticVariableClass.QuantityOrPrice;
        planQLI[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        planQLI[0].ProductStage__c= staticVariableClass.InProgress ;
        planQLI[0].Product2ID = prod.ID;
        planQLI[0].HPCC_Code__c = staticVariableClass.HPCCCODE ;
        planQLI[0].put(staticVariableClass.UPSELL,'');
        insert planQLI;
        
        Test.stopTest();
        List<QuoteLineItem> lstpackageQLI = [Select Id,ParentQuoteLineItem__c FROM QuoteLineItem WHERE ParentQuoteLineItem__c =: planQLI[0].Id];
        system.assertEquals(lstpackageQLI.size(), 1, ' Embeded HW Package got created');
         
    }
    
    @isTest 
    static void exceptionQLI(){ 
        Test.startTest();
        
        Exception exe =  new DMLException('My DML EXCEPTION');
        ExceptionLog__c  exe1 =  LGHWQuoteLineItemActions.createExceptionRecord(exe);
        exe1.ClassName__C = staticVariableClass.CLASS_LG_QUOTE_LINE_ITEM;
        exe1.MethodName__c=staticVariableClass.CREATE_HWPACKAGE_PROGRAMS_FUTURE;
        exe1.ApexTrigger__c=staticVariableClass.QLI_AFTER_INSERT_TRIGGER;
        insert exe1;  
        
        Test.stopTest();
        List<ExceptionLog__c>   oExeLog = [Select Id,ExceptionDetails__c  FROM ExceptionLog__c WHERE ID =: exe1.Id];
        system.assertEquals(oExeLog[0].ExceptionDetails__c.contains('System.DmlException:My DML EXCEPTION'), true, 'Exception Generated');
    }
    @isTest 
    static void insertQLINegativeTest(){ 
        Quote quo = [Select Id FROM Quote Limit 1];
        Product2 prod = [Select Id From Product2 Limit 1];
        PricebookEntry priceBook  = [Select Id FROM PricebookEntry Limit 1];
        Product_HPCC_Codes__c objProHpcc = [Select Id,HPCC_Code__c FROM Product_HPCC_Codes__c Limit 1];
        objProHpcc.HPCC_Code__c = 'CO';
        update objProHpcc; 
        Test.startTest();
        //Inserting Plan QLIs
        
        List<QuoteLineItem> planQLI= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCStrPath,1,quo,prod,priceBook));
        planQLI[0].Quantity =   staticVariableClass.QuantityOrPrice;
        planQLI[0].UnitPrice = staticVariableClass.QuantityOrPrice;
        planQLI[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        planQLI[0].ProductStage__c= staticVariableClass.InProgress ;
        planQLI[0].Product2ID = prod.ID;
        planQLI[0].HPCC_Code__c = staticVariableClass.HPCCCODE ;
        planQLI[0].put(staticVariableClass.UPSELL,'');
        insert planQLI;
        
        Test.stopTest();
        List<QuoteLineItem> lstpackageQLI = [Select Id,ParentQuoteLineItem__c FROM QuoteLineItem WHERE ParentQuoteLineItem__c =: planQLI[0].Id];
        system.assertEquals(lstpackageQLI.size(), 0, ' Embeded HW Package not created');
    }
    
    @isTest 
    static void insertQLIforNewAHG(){ 
        Quote quo = [Select Id FROM Quote Limit 1];
        Product2 prod = [Select Id From Product2 Limit 1];
        PricebookEntry priceBook = [Select Id FROM PricebookEntry Limit 1];
        Test.startTest();
        //Inserting Plan QLIs
        
        List<QuoteLineItem> planQLI= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCStrPath,1,quo,prod,priceBook));
        planQLI[0].Quantity =   staticVariableClass.QuantityOrPrice;
        planQLI[0].UnitPrice = staticVariableClass.QuantityOrPrice;
        planQLI[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        planQLI[0].ProductStage__c= staticVariableClass.InProgress ;
        planQLI[0].Product2ID = prod.ID;
        planQLI[0].HPCC_Code__c = staticVariableClass.HPCCCODE ;
        planQLI[0].put(staticVariableClass.UPSELL,'');
        insert planQLI;
        
        Test.stopTest();
        List<QuoteLineItem> lstpackageQLI = [Select Id,ProductName__c FROM QuoteLineItem WHERE 
                                             ParentQuoteLineItem__r.ParentQuoteLineItem__c =: planQLI[0].Id 
                                             And ProductName__c=: staticVariableClass.AHG_PRODUCT_NAME ];
        system.assertEquals(lstpackageQLI.size(), 1, 'AHG Product got Created');
    }
}