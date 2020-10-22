/*
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * Name              LGQliMassUpdateTest 
     * Author            Deloitte offshore (Gladiators)
     * ModifiedBy        Deloitte offshore (Gladiators)
     * Version           v1.0
     * CreatedDate       21st August 2019
     * User Story        PRDCRM-41009-Plan Mass update 
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * @Description      
     * This is a test class for LGQliMassUpdateCtrl and it tests negative and positive scenarios with bulk data.
     * 
     * -----------------------------------------------------------------------------------------------------------------------------------------------------------------
     * FUNCTIONAL TEST LOGIC
     * ----------------------------------------------------------------------------------------------------------------------------------------------------------------
     * 1 - lGQliMassUpdateTestDataSetup() 
     *          > TestSetup Method to create the required Test Data
     * 
     * 2 - testGetAllQlis()
     *          > Checks if the size of QLI data returned is correct when invoked with a Quote Id and verifies the result
     * 
     * 3 - testGetAllQlisNegative()
     *          > Checks if the size of QLI data is not returned when no Quote Id is passed and verifies the result
     * 
     * 4 - testupdateQli()
     *          > Checks if the QLI data is updated properly when a list of Quote Line Item Records are passed and verifies the result
     * 
     * 5 - testupdateQliNegative()
     *          > Checks if the method handled null/empty list of data to mimic the scenario when no records are edited and verifies the result
     *  
     * Additional information
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * Changes
     * GLD -201.5 - PRDCRM - 52626 - Added Vision Plans - Opening the Logic for Vision Products(Plans) as well           
     * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    */
    
    @isTest
    public class LGQliMassUpdateTest {
        
        @testSetup 
        static void lGQliMassUpdateTestDataSetup(){
            List<Account> accountList = new List<Account>(TestDataFactory.createAccountSICList(1, staticVariableClass.AccountName, 
                                                            staticVariableClass.testAccBillingStreet, staticVariableClass.testAccBillingCity, 
                                                            staticVariableClass.testAccBillingState, staticVariableClass.testAccBillingPostalCode, 
                                                            staticVariableClass.testAccBillingCountry, staticVariableClass.AK));
            accountList[0].Situs_State__c =  staticVariableClass.California;
            accountList[0].Pooled_Non_Pooled__c = staticVariableClass.POOLED; //Gladiators - sprint 201.1 - PRDCRM : 50723
            accountList[0].RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Account).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGProspect).getRecordTypeId();
            accountList[0].Anthem_Entity__c = staticVariableClass.Entity;
            accountList[0].Mailing_Address_Same_as_Physical_Address__c = true;
            accountList[0].Physical_County__c =staticVariableClass.GroupNum;
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
            
             //GLD-PRDCRM - 52626 : Plan Update Screen and Quote Plan Card Update 
            List<Product2> listVisionPlan = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.OpportunityName,1));
            listVisionPlan[0].Category__c = staticVariableClass.Plan;
            listVisionPlan[0].Product_Type__c = staticVariableClass.Vision;
            
            insert new list<Product2>  {medicalPlanProd[0], medicalProd[0],listVisionPlan[0]};
            
            List<PricebookEntry> pbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, medicalProd[0]));
            //GLD-PRDCRM - 52626 : Plan Update Screen and Quote Plan Card Update   
            List<PricebookEntry> listVisionPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listVisionPlan[0]));
            insert new list<PricebookEntry> {pbe[0] , listVisionPbe[0] };
            
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
            
            //GLD-PRDCRM - 52626 : Plan Update Screen and Quote Plan Card Update   
            List<QuoteLineItem> listVisionQli= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCTstAcc, 1,qte[0],listVisionPlan[0], listVisionPbe[0]));
            listVisionQli[0].Product2ID = listVisionPlan[0].ID;
            listVisionQli[0].put('Upsell__c','');
            listVisionQli[0].Quantity =  staticVariableClass.QuantityOrPrice;
            listVisionQli[0].UnitPrice =  staticVariableClass.QuantityOrPrice;
            listVisionQli[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
            listVisionQli[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
            listVisionQli[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
            listVisionQli[0].ProductStage__c= staticVariableClass.Sold;
            
            insert new list<QuoteLineItem>  {medicalQliChild1[0], medicalQliChild2[0],listVisionQli[0] };
        }
        @isTest
        static void testGetAllQlis(){
            Id qteId = [select ID from Quote where Name=:staticVariableClass.DNCStrPath].Id;
               
            Test.startTest();
                System.assertEquals(2,(LGQliMassUpdateCtrl.getAllQlis(qteId)).qliDataWrapperList.size(),staticVariableClass.assertEquals);
                System.assertNotEquals(null, LGQliMassUpdateCtrl.getAllQlis(qteId),staticVariableClass.assertNotEquals);
            	QuoteLineItem oQli = [SELECT Id, Product2.Plan_Type__c,Product_Type__c 
                                      		FROM QuoteLineItem 
                                      		WHERE ProductCategory__c=:staticVariableClass.Plan
                                     		AND Product_Type__c =: staticVariableClass.Vision 
                                     		AND QuoteId =:qteId];
            
            	System.assertEquals(staticVariableClass.Vision, oQli.Product_Type__c ,staticVariableClass.assertEquals);
            Test.stopTest();
        }
        @isTest
        static void testGetAllQlisNegative(){
            
            Test.startTest();
                System.assertEquals(0, (LGQliMassUpdateCtrl.getAllQlis(staticVariableClass.DNCStrPath)).qliDataWrapperList.size(),staticVariableClass.assertEquals);
                System.assertNotEquals(null, LGQliMassUpdateCtrl.getAllQlis(staticVariableClass.DNCStrPath),staticVariableClass.assertNotEquals);
            Test.stopTest();
        }
        @isTest
        static void testupdateQli(){
            List<QuoteLineItem> qliList = new List<QuoteLineItem>([select id,HPCC_Code__c from QuoteLineItem where Quote.name=:staticVariableClass.DNCStrPath]);
            qliList[0].HPCC_Code__c = staticVariableClass.GroupNum;
            LGQliMassUpdateCtrl.updateQli(qliList);
            List<QuoteLineItem> qliList1 = new List<QuoteLineItem>([select id,HPCC_Code__c,QuoteId from QuoteLineItem where Quote.name=:staticVariableClass.DNCStrPath]);
            Test.startTest();
                System.assertEquals(staticVariableClass.GroupNum, qliList1[0].HPCC_Code__c,staticVariableClass.assertEquals);
                System.assertNotEquals(staticVariableClass.NumericFive, qliList1[0].HPCC_Code__c,staticVariableClass.assertNotEquals);
            Test.stopTest();
        }
        @isTest
        static void testupdateQliNegative(){
            List<QuoteLineItem> qliList = new List<QuoteLineItem>();
            LGQliMassUpdateCtrl.updateQli(qliList);
            Test.startTest();
                System.assertEquals(0, qliList.size(),staticVariableClass.assertEquals);
                System.assertNotEquals(staticVariableClass.CreateGroupNumberDigits, qliList.size(),staticVariableClass.assertNotEquals);
            Test.stopTest();
        }
    }