@isTest
public class LGP2AIntegrationController_Test
{
    private static List<QuoteLineItem> qliList = new List<QuoteLineItem>();
    @testSetup static void LGSMENotApproved_TestDataSetup() 
    {
        SIC__c SIC = new SIC__c(Name = staticVariableClass.SIC);
        Insert SIC;
        
        Account acc =new Account(
            RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
            Name = staticVariableClass.AccountName,Account_s_Suppress_Auto_Renewal__c = false,Anthem_Entity__c = staticVariableClass.Entity,
            Region__c= staticVariableClass.Region, Branding__c =staticVariableClass.UniCare,SIC__c = SIC.Id,Group_Size__c =staticVariableClass.size,
            Total_Employees__c =staticVariableClass.emp, HQ_State__c =staticVariableClass.AK, Situs_State__c = staticVariableClass.California,
            Mailing_Address_Same_as_Physical_Address__c = true, BillingStreet = 'Land Mark', BillingPostalCode = '636111',
            BillingCity = 'Banglore', BillingCountry = 'India', BillingState = 'Karnataka', Physical_County__c = '121');
        insert acc;
        
        list<Id> lstOpp= new list<Id>();
        
        Opportunity newOpp = new Opportunity(Name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name), 
        StageName = staticVariableClass.ClosedWon, AccountID = acc.id, CloseDate = ((system.TODAY())-95),                   
        RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId());
        
        insert newOpp;
        
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        insert grp;
        
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,newOpp.Id);
        qte.GroupNumber__c=grp.id;
        insert qte;
        
        Product2 prd=ANA_UTIL01_TestMethods.createProduct(false);
        database.insert(prd);
        
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prd.id);
        database.insert(pbe);
        
        list<Quote> qteList=new list<Quote>{qte};
        qliList.addAll(ANA_UTIL01_TestMethods.createQuoteLineItem_ForQuote(false,qteList,pbe.id)); 
        qliList.get(0).Benefit_Period__c = 'Calendar Year';
        database.insert(qliList);

        List<QuoteLineItem> quoteLineItemList = ANA_UTIL01_TestMethods.createQuoteLineItemRecord(true,qteList,pbe.id,acc.id);
       	
        ////PRDCRM-50634 - GLD - 201.2 - adding two extra parameters for Modify button
        List<Product2> listMedicalProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemLifeProdName,1));
        listMedicalProd[0].Category__c = staticVariableClass.Product;
        
        insert listMedicalProd;
        
        //PRDCRM-51890 - Send parameters to P2A on Create CEP Case Button from QLI
        List<Product2> listMedicalChildProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        listMedicalChildProd[0].Category__c = staticVariableClass.Plan;
        
        insert listMedicalChildProd;
        
        List<QuoteLineItem> listMedicalQliParent= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.AnthemLifeProdName, 1,qteList[0],listMedicalProd[0], pbe));
        listMedicalQliParent[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        listMedicalQliParent[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listMedicalQliParent[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listMedicalQliParent[0].ProductStage__c= staticVariableClass.Sold;
        listMedicalQliParent[0].put('Upsell__c','');
        listMedicalQliParent[0].State_Regular__c = staticVariableClass.STATE_REGULATOR;
        listMedicalQliParent[0].HCR_Status__c = staticVariableClass.HCR_STATUS;
        
        insert listMedicalQliParent;
        
        //PRDCRM-51890 - Send parameters to P2A on Create CEP Case Button from QLI
        List<QuoteLineItem> listMedicalQliChild= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.AnthemLifeProdName, 1,qteList[0],listMedicalChildProd[0], pbe));
        listMedicalQliChild[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        listMedicalQliChild[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        listMedicalQliChild[0].ProductStage__c= staticVariableClass.Sold;
        listMedicalQliChild[0].put('Upsell__c','');
        listMedicalQliChild[0].State_Regular__c = staticVariableClass.STATE_REGULATOR;
        listMedicalQliChild[0].HCR_Status__c = staticVariableClass.HCR_STATUS;
        listMedicalQliChild[0].ParentQuoteLineItem__c = listMedicalQliParent[0].Id;
        
        insert listMedicalQliChild;

    }
    
    @isTest static void checkFlow()
    {
        ID QLIId = [select ID from QuoteLineItem limit 1].Id;
        LGP2AIntegrationController.ResponseWrapper.getQuoteDataForNavigation(QLIId,staticVariableClass.VIEW_STRING);
        LGP2AJSON.parse('{"menu":{"id": "file","value": "File"}}');
    }

    @isTest static void ANA_UTIL01_Exception_Test()
    {

       
        ANA_UTIL01_TestMethods.createServiceProviderRelationshipRecord(null,null);
        ANA_UTIL01_TestMethods.runAsUser(null);
        ANA_UTIL01_TestMethods.getRecordTypeId(null,null);
        ANA_UTIL01_TestMethods.createGroups(null,null,null);
        ANA_UTIL01_TestMethods.createGroup(null,null);
        ANA_UTIL01_TestMethods.createSICs(null,null);
        ANA_UTIL01_TestMethods.createSIC(null);
        ANA_UTIL01_TestMethods.createBrokerageAndConsultants(null,null);
        ANA_UTIL01_TestMethods.createBrokerageAndConsultant(null);
        ANA_UTIL01_TestMethods.createContactRelationships(null,null);
        ANA_UTIL01_TestMethods.createAccounts(null,null);
        ANA_UTIL01_TestMethods.createOpportunity(null,null);
        ANA_UTIL01_TestMethods.createOpportunities(null,null,null);
        ANA_UTIL01_TestMethods.createQuote(null,null);
        ANA_UTIL01_TestMethods.createQuotes(null,null,null);
        ANA_UTIL01_TestMethods.createProduct(null);
        ANA_UTIL01_TestMethods.createPSDRecord(null,null);
        ANA_UTIL01_TestMethods.createPricebookEntry(null,null);
        ANA_UTIL01_TestMethods.createQuoteLineItem(null,null,null);
        ANA_UTIL01_TestMethods.createQuoteLineItems(null,null,null,null);
        ANA_UTIL01_TestMethods.createChildProduct(null,null,null);
        ANA_UTIL01_TestMethods.createQuoteLineItem_ForQuote(null,null,null);
        ANA_UTIL01_TestMethods.createQuoteLineItemRecord(null,null,null,null);
        ANA_UTIL01_TestMethods.createChildQuoteLineItemsList(null,null,null,null);
        ANA_UTIL01_TestMethods.createChildQuoteLineItems(null,null,null,null);
        ANA_UTIL01_TestMethods.createQuoteLineItemApproval(null,null);
        ANA_UTIL01_TestMethods.createContact(null,null);
        ANA_UTIL01_TestMethods.createContacts(null,null,null);
        ANA_UTIL01_TestMethods.createContactRelationship(null);
    }
    @isTest static void checkNegativeFlow()//Pratibha added this for testclassfix
    {
        ID QLIId = [select ID,Benefit_Period__c from QuoteLineItem limit 1].Id;
        test.startTest();
        LGP2AIntegrationController.ResponseWrapper oResponse = LGP2AIntegrationController.ResponseWrapper.getQuoteDataForNavigation(QLIId,staticVariableClass.VIEW_STRING);
        LGP2AJSON.parse('{"menu":{"id": "file","value": "File"}}');
        System.assertEquals(staticVariableClass.Sold, oResponse.ProductStage,staticVariableClass.assertEquals );
        test.stopTest();
    }
    //PRDCRM-50634 - GLD - 201.2 - adding two extra parameters for Modify button
    @isTest 
    static void checkP2AForModifyButton(){
        ID qliId = [SELECT ID,State_Regular__c,HCR_Status__c,Benefit_Period__c 
                    					FROM QuoteLineItem 
                    					WHERE Product2.Name=:staticVariableClass.AnthemLifeProdName].Id;
        Test.startTest();
        LGP2AIntegrationController.ResponseWrapper oResponse = LGP2AIntegrationController.ResponseWrapper.getQuoteDataForNavigation(qliId,staticVariableClass.MODIFY);
        System.assertEquals(staticVariableClass.HCR_STATUS, LGP2AJSON.parse(oResponse.attributeValue).QuoteLineItems[0].sHcrStatus,staticVariableClass.assertEquals);
        System.assertEquals(staticVariableClass.STATE_REGULATOR, LGP2AJSON.parse(oResponse.attributeValue).QuoteLineItems[0].sStateRegulator,staticVariableClass.assertEquals);
        Test.stopTest();
    }
    
    //PRDCRM-51890 -GLD- Send parameters to P2A on Create CEP Case Button from QLI
    @isTest 
    static void checkGetQuoteDataForCEPNavigation(){
        
        List<QuoteLineItem> listQli = new List<QuoteLineItem>([select ID,QuoteId,Benefit_Period__c,Quote.Opportunity.Account.TotalNumberofUnionWorkers__c from QuoteLineItem limit 1]);
        test.startTest();
            LGP2AIntegrationController.ResponseWrapper oResponse = LGP2AIntegrationController.ResponseWrapper.getQuoteDataForCEPNavigation(listQli[0].QuoteId,staticVariableClass.CEP_CASE);
            System.assertEquals(listQli[0].QuoteId, LGP2AJSON.parse(oResponse.attributeValue).SFDCQuoteId,staticVariableClass.assertEquals );
        	System.assertEquals(listQli[0].Quote.Opportunity.Account.TotalNumberofUnionWorkers__c, LGP2AJSON.parse(oResponse.attributeValue).totalNoOfUnionWorkers,staticVariableClass.assertEquals );
        test.stopTest();
    }
    //PRDCRM-51890 -GLD- Send parameters to P2A on Create CEP Case Button from QLI
    @isTest 
    static void checkGetQuoteDataForCEPNavigationNegative(){
        
        test.startTest();
            LGP2AIntegrationController.ResponseWrapper oResponse = LGP2AIntegrationController.ResponseWrapper.getQuoteDataForCEPNavigation(null,staticVariableClass.CEP_CASE);
            System.assertEquals(null, oResponse ,staticVariableClass.assertEquals );
        test.stopTest();
    }
}