/*******************************************************************************************
@ class Name  : LGA_CreateDocumentChecklist_Test
@ created By  : IDC Offshore
@ createdDate : 8/01/2019
@ description : This test class is for LGA_CreateDocumentChecklist
********************************************************************************************/
@isTest(SeeAllData=false)
public with sharing class LGA_CreateDocumentChecklist_Test {
    
    /*******************************************************************************************
@ method Name  : testcreateDocChecklist
@ description : This is test method for LGA_CreateDocumentChecklist
********************************************************************************************/
    @isTest(SeeAllData=false)
    public static void testcreateDocChecklist(){
        LGA_CreateDocumentChecklist createDc = new LGA_CreateDocumentChecklist();
        List<Order> newOrderLst = new List<Order>();    
        Try{
            /***User Creation***/
            User testUser = Util02_TestData.createUser();
            //testUser.ProfileName__c = 'System Administrator';
            system.debug('@@@testUser'+testUser);
            System.runAs(testUser){
                /***Account Record Creation***/
                Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(LGA_Constants.LGPROSPECT_ACC_RECORDTYPE).getRecordTypeId();
                List<Id> accRecordTypeList = new List<Id>();
                accRecordTypeList.add(accRecordTypeId);
                List<Account> testAccList = new List<Account>();
                testAccList.addAll(Anthem_TestDataFactory.generateAccount(accRecordTypeList));
                testAccList[0].Is_this_Group_subject_to_ERISA__c = LGA_Constants.ERISA;
                database.insert(testAccList);
                system.debug('**testAcc**'+testAccList);
                
                /***Opportunity record creation***/
                Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(LGA_Constants.NEWBUSINESS_OPP_RECORDTYPE).getRecordTypeId();
                List<Id> oppRecordTypeList = new List<Id>();
                oppRecordTypeList.add(oppRecordTypeId);
                List<Opportunity> testOppList = new List<Opportunity>();
                testOppList.addAll(Anthem_TestDataFactory.generateOpportunity(oppRecordTypeList,testAccList[0].Id));
                database.insert(testOppList);
                
                //Creating Group__c
                Group__c grp = Anthem_TestDataFactory.createGroup(testAccList[0].Id);
                database.insert(grp);
                
                //Creating Product
                Id prdRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
                Product2 product = Anthem_TestDataFactory.generateProduct2();  
                product.recordtypeId = prdRecordTypeId ;
                product.Name = 'Optional Voluntary Test123 HRA';
                Database.insert(product, false);  
                Product2 product3 = Anthem_TestDataFactory.generateProduct2();  
                product3.recordtypeId = prdRecordTypeId ;
                product3.Name = '';
                Database.insert(product3, false);  
                Product2 productNew = Anthem_TestDataFactory.generateProduct2(); 
                productNew.recordtypeId = prdRecordTypeId ;
                productNew.Category__c = 'Plan';
                Database.insert(productNew, false);     
                
                //Creating PriceBook entry
                Id priceBookId = Anthem_TestDataFactory.generatePricebookId();
                PricebookEntry priceBookEntry = Anthem_TestDataFactory.generatePricebookEntry(product.Id,priceBookId);
                Database.insert(priceBookEntry, false);
                
                Id priceBookId3 = Anthem_TestDataFactory.generatePricebookId();
                PricebookEntry priceBookEntry3 = Anthem_TestDataFactory.generatePricebookEntry(product3.Id,priceBookId3);
                Database.insert(priceBookEntry3, false);
                
                Id priceBookIdNew = Anthem_TestDataFactory.generatePricebookId();
                PricebookEntry priceBookEntryNew = Anthem_TestDataFactory.generatePricebookEntry(productNew.Id,priceBookIdNew);
                Database.insert(priceBookEntryNew, false);
                
                
                
                /***Quote record creation***/            
                List<Id> quoteRecIdList = new List<Id>();
                Id largeGroupQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get(LGA_Constants.LARGEGRP_QUOTE).getRecordTypeId();         
                quoteRecIdList.add(largeGroupQuoteRecordTypeId);
                List<Quote> quoteList = Anthem_TestDataFactory.generateQuote(quoteRecIdList, priceBookId, testOppList[0].Id);
                quoteList[0].GroupNumber__c = grp.Id;
                Database.insert(quoteList, false);
                system.debug('@@@@@quoteList' + quoteList);
                system.debug('@@@@@quoteList' + quoteList[0].Id);
                
                
                
                /// 2nd Quote Creation
                List<Id> quoteRecIdList2 = new List<Id>();
                Id largeGroupQuoteRecordTypeIdNew= Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('LargeGroupQuote').getRecordTypeId();         
                quoteRecIdList2.add(largeGroupQuoteRecordTypeIdNew);
                List<Quote> quoteList2 = Anthem_TestDataFactory.generateQuote(quoteRecIdList2, priceBookIdNew, testOppList[0].Id);
                quoteList2[0].GroupNumber__c = grp.Id;
                Database.insert(quoteList2, false);
                system.debug('@@@@@quoteList' + quoteList2);
                system.debug('@@@@@quoteList' + quoteList2[0].Id);
                
                /***QuoteLineItem record creation***/
                List<QuoteLineItem> quoteLineItemTest = new List<QuoteLineItem>();
                quoteLineItemTest.addAll(Anthem_TestDataFactory.generateSoldQuoteLineItem(3, product.Id, quoteList[0].Id, priceBookEntry));
                quoteLineItemTest.addAll(Anthem_TestDataFactory.generateSoldQuoteLineItem(3, product.Id, quoteList[0].Id, priceBookEntry3));
                Database.insert(quoteLineItemTest, false);
                
                List<QuoteLineItem> quoteLineItemTest2 = new List<QuoteLineItem>();
                quoteLineItemTest2.addAll(Anthem_TestDataFactory.generateSoldQuoteLineItem(3, productNew.Id, quoteList2[0].Id, priceBookEntryNew));
                Database.insert(quoteLineItemTest2, false);
                system.debug('@@@@@@@quoteLineItemTest2: ' + quoteLineItemTest2[0].ProductCategory__c);
                
                /***Application Document Config***/
                
                Application_Document_Config__c new1 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new1.Product_Category__c= LGA_Constants.PRODUCT;
                new1.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                new1.Line_Of_Business__c = LGA_Constants.MEDICAL_LOB;
                new1.Additional_Checks__c = true;
                database.insert(new1);
                system.debug('new1'+new1);  
                
                Application_Document_Config__c new51 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new51.Product_Category__c= LGA_Constants.PRODUCT;
                new51.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                new51.Line_Of_Business__c = LGA_Constants.MEDICAL_LOB;
                new51.Additional_Checks__c = true;
                new51.Product_Family__c = LGA_Constants.PRDFAMILY;
                new51.Files_Parameter__c = LGA_Constants.LOB;
                database.insert(new51);
                system.debug('new51'+new51);  
                
                Application_Document_Config__c new5 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new5.Files_Parameter__c = LGA_Constants.LOB;
                new5.Product_Category__c= LGA_Constants.PRODUCT;
                new5.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                new5.Line_Of_Business__c = LGA_Constants.MEDICAL_LOB;
                database.insert(new5);
                system.debug('new5'+new5); 
                
                Application_Document_Config__c new6 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new6.Files_Parameter__c = LGA_Constants.QLI;
                new6.Product_Category__c= LGA_Constants.PRODUCT;
                new6.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                new6.Line_Of_Business__c = LGA_Constants.MEDICAL_LOB;
                database.insert(new6);
                system.debug('new6'+new6); 
                
                Application_Document_Config__c new7 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new7.Files_Parameter__c = LGA_Constants.QLI;
                new7.Product_Category__c= LGA_Constants.PRODUCT;
                new7.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                database.insert(new7);
                system.debug('new7'+new7); 
                
                Application_Document_Config__c new8 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new8.Files_Parameter__c = LGA_Constants.QLI;
                new8.Product_Category__c= LGA_Constants.PRODUCT;
                new8.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                database.insert(new8);
                system.debug('new8'+new8); 
                
                Application_Document_Config__c new9 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new9.Files_Parameter__c = LGA_Constants.QLI;
                new9.Product_Category__c= LGA_Constants.PRODUCT;
                new9.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                new9.Line_Of_Business__c = LGA_Constants.MEDICAL_LOB;
                new9.Document_Name__c = LGA_Constants.DOCNAMELARGE;
                database.insert(new9);
                system.debug('new9'+new9); 
                
                Application_Document_Config__c new19 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new19.Files_Parameter__c = LGA_Constants.QLI;
                new19.Product_Category__c= LGA_Constants.PRODUCT;
                new19.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                new19.Line_Of_Business__c = LGA_Constants.MEDICAL_LOB;
                new19.Document_Name__c = LGA_Constants.DOCNAMELARGE;
                new19.Required__c = LGA_Constants.FALSEVALUE;
                database.insert(new19);
                system.debug('new9'+new19); 
                
                Application_Document_Config__c new20 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new20.Files_Parameter__c = LGA_Constants.QLI;
                new20.Product_Category__c= LGA_Constants.PRODUCT;
                new20.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                new20.Line_Of_Business__c = LGA_Constants.MEDICAL_LOB;
                new20.Document_Name__c = LGA_Constants.DOCNAMELARGE;
                new20.Underwriter__c = LGA_Constants.FALSEVALUE;
                database.insert(new20);
                system.debug('new9'+new20); 
                
                Application_Document_Config__c new2 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new2.Required__c = false;
                new2.Underwriter__c = false;
                database.insert(new2);
                system.debug('@@@new2'+new2); 
                
                Application_Document_Config__c new3 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                new3.Product_Category__c= LGA_Constants.PRODUCT;
                new3.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                
                database.insert(new3);
                system.debug('new3'+new3); 
                
                Application_Document_Config__c adc4= Anthem_TestDataFactory.createApplicationDocumentConfig();
                adc4.ERISA_Qualified__c= LGA_Constants.ERISA;
                adc4.Product_Category__c= LGA_Constants.PRODUCT;
                adc4.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                adc4.Additional_Checks__c = true;
                database.insert(adc4);
                
                Application_Document_Config__c adc15= Anthem_TestDataFactory.createApplicationDocumentConfig();
                adc15.Pooled_Non_Pooled__c= LGA_Constants.POOLED;
                adc15.Product_Category__c= LGA_Constants.PRODUCT;
                adc15.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                adc15.Additional_Checks__c = true;
                database.insert(adc15);
                
                Application_Document_Config__c adc16 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                adc16.Employee_Assistance_Program__c= LGA_Constants.TRUEVALUE;
                adc16.Product_Category__c= LGA_Constants.PRODUCT;
                adc16.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                adc16.Additional_Checks__c = true;
                database.insert(adc16);
                
                
                Application_Document_Config__c adc17 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                adc17.CEP_Indicator__c = LGA_Constants.QLI_CEP_INDICATOR_YES;
                adc17.Product_Category__c= LGA_Constants.PRODUCT;
                adc17.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                adc17.Additional_Checks__c = true;
                database.insert(adc17);
                
                Application_Document_Config__c adc22 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                adc22.Product_Name__c = LGA_Constants.VOLUNTARY_PRODUCT + ','+ LGA_Constants.SUPPLEMENTAL_PRODUCT ;
                adc22.Product_Category__c= LGA_Constants.PRODUCT;
                adc22.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                adc22.Additional_Checks__c = true;
                database.insert(adc22);
                
                Application_Document_Config__c adc23 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                adc23.Financing__c = LGA_Constants.JAA_FUNDING;
                adc23.Product_Category__c= LGA_Constants.PRODUCT;
                adc23.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                adc23.Additional_Checks__c = true;
                database.insert(adc23);
                
                Application_Document_Config__c adc24 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                adc24.Financing__c = LGA_Constants.JAA_FUNDING;
                adc24.Product_Category__c= LGA_Constants.PRODUCT;
                adc24.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                adc24.Additional_Checks__c = true;
                database.insert(adc24);
                
                Application_Document_Config__c adc27 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                adc27.Financing__c = LGA_Constants.JAA_FUNDING;
                adc27.Product_Category__c= LGA_Constants.PRODUCT;
                adc27.Product_Family__c = LGA_Constants.PRD_FAMILY;
                adc27.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD; 
                adc27.Additional_Checks__c = true;
                database.insert(adc27);
                
                Application_Document_Config__c adc25 = Anthem_TestDataFactory.createApplicationDocumentConfig();
                adc25.Financing__c = LGA_Constants.JAA_FUNDING;
                adc25.Product_Category__c = LGA_Constants.PRODUCT;
                adc25.Funding__c = LGA_Constants.QLI_FUNDING_ASO;
                adc25.Product_Stage__c = LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                adc25.Additional_Checks__c = true;
                database.insert(adc25);
                
                Application_Document_Config__c adc10= Anthem_TestDataFactory.createApplicationDocumentConfig();
                adc10.Line_Of_Business__c = LGA_Constants.MEDICAL_LOB;
                adc10.Funding__c= LGA_Constants.QLI_FUNDING_ASO;
                adc10.Product_Category__c= LGA_Constants.PRODUCT;
                adc10.Product_Stage__c= LGA_Constants.QLI_PRODUCT_STAGE_SOLD;
                adc10.Additional_Checks__c = true;
                database.insert(adc10);
                                

                /***Implementation record creation***/
                Id ordRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get(LGA_Constants.NEWBIS_IMPLTYPE).getRecordTypeId();
                List<Order> testimplList = Anthem_TestDataFactory.generateImplementationCase(testAccList[0].Id, quoteList[0].Id, testOppList[0].Id);
                testimplList[0].RecordTypeId = ordRecordTypeId;
                database.insert(testimplList); 
                system.assert(testimplList.size()>0, 'Success');
                
            }
        }
        Catch (Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
    }
}