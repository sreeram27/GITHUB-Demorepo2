/*
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Name              LGSMERecordCreation_Test 
* Author            Deloitte offshore (Gladiators)
* ModifiedBy        Deloitte offshore (Gladiators)
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @Description      
* This is a test class for LGSMERecordCreation and it tests negative and positive scenarios with bulk data.
* 
* -----------------------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* ----------------------------------------------------------------------------------------------------------------------------------------------------------------
* 1 - lGSmeRecordCreationTestDataSetup() 
*          > TestSetup Method to create the required Test Data
* 
* 2 - stampSmeReviewDateTest()
*          > Stamps impacted product field on SME objects of given orders
* 
* 3 - stampSmeReviewDateNegativeTest()
*          > Checks if the method is handling null Order IDs 
* 
* 4 - idCardStatusUpdateTest()
*          > Update review status of ID card Records to Approved
* 
* 5 - idCardStatusUpdateNegativeTest()
*          > Updates review status of ID card records to Partial Approved
*
* 6 - populateAssignedImplementerValueOnIdCardTest()
*          > Changes the assigned implementor of order to different user.
*
* 7 - populateAssignedImplementerValueOnIdCardNegativeTest
*          > Checks if the code can handle the change of the assigned implementor of order to same user.
*
* 8 - renewalImpTypeTest
*       > Checks if the changes to the assigned implementor of order to different user works for Renewal Imp Type.
*
* Additional information
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Changes
*      
* GLD              30th Sept            Refactored the entire code as per the user story(PRDCRM-42372)
* GLD              28th Feb             Added Accident and critical illness QLIs and method opportunityIgapSoldTest( PRDCRM:50840)
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
@isTest
public class LGSMERecordCreation_Test
{
    @testSetup 
    static void lGSmeRecordCreationTestDataSetup() 
    {    
        List<User> user1= new List<User>(TestDataFactory.createUserData(1, staticVariableClass.LocalImplementations,null));
        user1[0].Email = staticVariableClass.userEmail;
        insert user1;
        
        List<User> user2= new List<User>(TestDataFactory.createUserData(1, staticVariableClass.LocalImplementations, null));
        user2[0].Email = staticVariableClass.userEmail+staticVariableClass.DNCStrShareType;
        insert user2;
        
        System.RunAs(user1[0]){
        
        List<Account> accountList = new List<Account>(TestDataFactory.createAccountSICList(1, staticVariableClass.AccountName, 
                                                                                           staticVariableClass.testAccBillingStreet, staticVariableClass.testAccBillingCity, 
                                                                                           staticVariableClass.testAccBillingState, staticVariableClass.testAccBillingPostalCode, 
                                                                                           staticVariableClass.testAccBillingCountry, staticVariableClass.AK));
        accountList[0].Situs_State__c =  staticVariableClass.California;
        accountList[0].RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Account).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGProspect).getRecordTypeId();
        accountList[0].Anthem_Entity__c = staticVariableClass.Entity;
        accountList[0].Mailing_Address_Same_as_Physical_Address__c = true;
        accountList[0].Physical_County__c =staticVariableClass.GroupNum;
        insert accountList;
        
        List<Opportunity> opptyList = new List<Opportunity>(TestDataFactory.createOpportunityList(1, staticVariableClass.OpportunityName,accountList[0]));
        opptyList[0].CloseDate=Date.newInstance(2019, 12, 9);
            opptyList[0].StageName='Prospecting';
            insert opptyList;
        
        Group__c grp=TestDataFactory.createGroup(accountList[0].id,false);
        grp.ClaimSystem__c = '';
        insert grp;
        
        List<Quote> qte=new List<Quote>(TestDataFactory.Quote(staticVariableClass.DNCStrPath,1,opptyList[0]));
        qte[0].GroupNumber__c=grp.id;
        insert qte;
        
        List<Product2> dentalProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        dentalProd[0].Product_Type__c = staticVariableClass.Dental;
        
        List<Product2> visionProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        visionProd[0].Product_Type__c = staticVariableClass.Vision;
        
        
        List<Product2> lifeProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemLifeProdName,1));
        lifeProd[0].Product_Type__c = staticVariableClass.Life;
        
        List<Product2> disabilityProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        disabilityProd[0].Product_Type__c = staticVariableClass.Disability;
            
        List<Product2> listAccProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        listAccProd[0].Product_Type__c = staticVariableClass.ACCIDENT;
        
        List<Product2> listHospIndemnityProd = new List<Product2>(TestDataFactory.createProduct(staticVariableClass.AnthemDentalProdName,1));
        listAccProd[0].Product_Type__c = staticVariableClass.HOSPITAL_INDEMNITY;
        
        insert new list<Product2>{dentalProd[0], visionProd[0], lifeProd[0], disabilityProd[0], listAccProd[0],listHospIndemnityProd[0]};
            
        List<PricebookEntry> dentPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, dentalProd[0]));
        List<PricebookEntry> visPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, visionProd[0]));
        List<PricebookEntry> lifePbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, lifeProd[0]));
        List<PricebookEntry> disabilityPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, disabilityProd[0]));
        List<PricebookEntry> listAccidentPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listAccProd[0]));
        List<PricebookEntry> listHospIndemnityPbe = new List<PricebookEntry>(TestDataFactory.PricebookEntry(1, listHospIndemnityProd[0]));
        
        insert new list<PricebookEntry>{dentPbe[0], visPbe[0], lifePbe[0], disabilityPbe[0],listAccidentPbe[0],listHospIndemnityPbe[0]};
            
        List<QuoteLineItem> dentalQli= new List<QuoteLineItem>(TestDataFactory.QuoteLineItem(staticVariableClass.DNCStrPath, 1,qte[0],dentalProd[0], dentPbe[0]));
        dentalQli[0].Quantity =   staticVariableClass.QuantityOrPrice;
        dentalQli[0].UnitPrice = staticVariableClass.QuantityOrPrice;
        dentalQli[0].Product_Term_Years_Left__c = staticVariableClass.Termone;
        dentalQli[0].Discount_sharing__c = staticVariableClass.SoldRenewed;
        dentalQli[0].EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        dentalQli[0].ProductStage__c= staticVariableClass.Sold;
        dentalQli[0].Product2ID = dentalProd[0].ID;
        dentalQli[0].put('Upsell__c','');
        
        QuoteLineItem visionQli = dentalQli[0].clone();
        visionQli.Product2ID = visionProd[0].ID;
        visionQli.put('Upsell__c','');
        visionQli.Quantity =  staticVariableClass.QuantityOrPrice;
        visionQli.UnitPrice =  staticVariableClass.QuantityOrPrice;
        visionQli.Product_Term_Years_Left__c = staticVariableClass.Termone;
        visionQli.Discount_sharing__c = staticVariableClass.SoldRenewed;
        visionQli.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        visionQli.ProductStage__c= staticVariableClass.Sold;
        
        QuoteLineItem lifeQli = dentalQli[0].clone();
        lifeQli.Product2ID = lifeProd[0].ID;
        lifeQli.put('Upsell__c','');
        lifeQli.Quantity =  staticVariableClass.QuantityOrPrice;
        lifeQli.UnitPrice =  staticVariableClass.QuantityOrPrice;
        lifeQli.Product_Term_Years_Left__c =staticVariableClass.Termone;
        lifeQli.Discount_sharing__c = staticVariableClass.SoldRenewed;
        lifeQli.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        lifeQli.ProductStage__c= staticVariableClass.Sold;
        
        QuoteLineItem disabilityQli1 = dentalQli[0].clone();
        disabilityQli1.Product2ID = disabilityProd[0].ID;
        disabilityQli1.put('Upsell__c','');
        disabilityQli1.Quantity =  staticVariableClass.QuantityOrPrice;
        disabilityQli1.UnitPrice =  staticVariableClass.QuantityOrPrice;
        disabilityQli1.Product_Term_Years_Left__c = staticVariableClass.Termone;
        disabilityQli1.Discount_sharing__c = staticVariableClass.SoldRenewed;
        disabilityQli1.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        disabilityQli1.ProductStage__c= staticVariableClass.Sold;
        
        QuoteLineItem disabilityQli = dentalQli[0].clone();
        disabilityQli.Product2ID = disabilityProd[0].ID;
        disabilityQli.put('Upsell__c','');
        disabilityQli.Quantity = staticVariableClass.QuantityOrPrice;
        disabilityQli.UnitPrice =  staticVariableClass.QuantityOrPrice;
        disabilityQli.Product_Term_Years_Left__c = staticVariableClass.Termone;
        disabilityQli.Discount_sharing__c = staticVariableClass.SoldRenewed;
        disabilityQli.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        disabilityQli.ProductStage__c= staticVariableClass.Sold;
        
        /*QuoteLineItem dentalQli2 = dentalQli[0].clone();
        dentalQli2.Upsell__c =  staticVariableClass.UpsellNo;
        dentalQli2.Quantity =  staticVariableClass.QuantityOrPrice;
        dentalQli2.UnitPrice =  staticVariableClass.QuantityOrPrice;
        dentalQli2.Product_Term_Years_Left__c = staticVariableClass.Termone;
        dentalQli2.Discount_sharing__c = staticVariableClass.SoldRenewed;
        dentalQli2.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        dentalQli2.ProductStage__c= staticVariableClass.Sold;
        
        QuoteLineItem visionQli2 = visionQli.clone();
        visionQli2.Upsell__c = staticVariableClass.UpsellNo;
        visionQli2.Quantity =  staticVariableClass.QuantityOrPrice;
        visionQli2.UnitPrice =  staticVariableClass.QuantityOrPrice;
        visionQli2.Product_Term_Years_Left__c = staticVariableClass.Termone;
        visionQli2.Discount_sharing__c = staticVariableClass.SoldRenewed;
        visionQli2.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        visionQli2.ProductStage__c= staticVariableClass.Sold;
        
        QuoteLineItem lifeQli2 = lifeQli.clone();
        lifeQli2.Upsell__c = staticVariableClass.UpsellNo;
        lifeQli2.Quantity =  staticVariableClass.QuantityOrPrice;
        lifeQli2.UnitPrice =  staticVariableClass.QuantityOrPrice;
        lifeQli2.Product_Term_Years_Left__c = staticVariableClass.Termone;
        lifeQli2.Discount_sharing__c = staticVariableClass.SoldRenewed;
        lifeQli2.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        lifeQli2.ProductStage__c= staticVariableClass.Sold;
        
        QuoteLineItem disabilityQli2 = disabilityQli.clone();
        disabilityQli2.Upsell__c = staticVariableClass.UpsellNo;
        disabilityQli2.Quantity =  staticVariableClass.QuantityOrPrice;
        disabilityQli2.UnitPrice = staticVariableClass.QuantityOrPrice;
        disabilityQli2.Product_Term_Years_Left__c = staticVariableClass.Termone;
        disabilityQli2.Discount_sharing__c = staticVariableClass.SoldRenewed;
        disabilityQli2.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        disabilityQli2.ProductStage__c= staticVariableClass.Sold;
        
        QuoteLineItem dentalQli3 = dentalQli[0].clone();
        dentalQli3.Upsell__c = staticVariableClass.UpsellYes;
        dentalQli3.Quantity =  staticVariableClass.QuantityOrPrice;
        dentalQli3.UnitPrice =  staticVariableClass.QuantityOrPrice;
        dentalQli3.Product_Term_Years_Left__c = staticVariableClass.Termone;
        dentalQli3.Discount_sharing__c = staticVariableClass.SoldRenewed;
        dentalQli3.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        dentalQli3.ProductStage__c= staticVariableClass.Sold;
        
        QuoteLineItem visionQli3 = visionQli.clone();
        visionQli3.Upsell__c = staticVariableClass.UpsellYes;
        visionQli3.Quantity =  staticVariableClass.QuantityOrPrice;
        visionQli3.UnitPrice = staticVariableClass.QuantityOrPrice;
        visionQli3.Product_Term_Years_Left__c = staticVariableClass.Termone;
        visionQli3.Discount_sharing__c = staticVariableClass.SoldRenewed;
        visionQli3.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        
        QuoteLineItem lifeQli3 = lifeQli.clone();
        lifeQli3.Upsell__c = staticVariableClass.UpsellYes;
        lifeQli3.Quantity =  staticVariableClass.QuantityOrPrice;
        lifeQli3.UnitPrice =  staticVariableClass.QuantityOrPrice;
        lifeQli3.Product_Term_Years_Left__c = staticVariableClass.Termone;
        lifeQli3.Discount_sharing__c = staticVariableClass.SoldRenewed;
        lifeQli3.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        
        QuoteLineItem disabilityQli3 = disabilityQli.clone();
        disabilityQli3.Upsell__c = staticVariableClass.UpsellYes;
        disabilityQli3.Quantity =  staticVariableClass.QuantityOrPrice;
        disabilityQli3.UnitPrice = staticVariableClass.QuantityOrPrice;
        disabilityQli3.Product_Term_Years_Left__c = staticVariableClass.Termone;
        disabilityQli3.Discount_sharing__c = staticVariableClass.SoldRenewed;
        disabilityQli3.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;*/
        
        //GLD - PRDCRM:50840 - Auto create L&D SME for Supplemental Health Products
        QuoteLineItem oAccidentQli = dentalQli[0].clone();
        oAccidentQli.Product2ID = listAccidentPbe[0].ID;
        oAccidentQli.put('Upsell__c','');
        oAccidentQli.Quantity =  staticVariableClass.QuantityOrPrice;
        oAccidentQli.UnitPrice =  staticVariableClass.QuantityOrPrice;
        oAccidentQli.Product_Term_Years_Left__c = staticVariableClass.Termone;
        oAccidentQli.Discount_sharing__c = staticVariableClass.SoldRenewed;
        oAccidentQli.put('Line_of_Business__c','');
        oAccidentQli.put('Network__c','');
        oAccidentQli.put('Involvement_Type__c','');
            
        QuoteLineItem oHospIndemnityQli = dentalQli[0].clone();
        oHospIndemnityQli.Product2ID = listHospIndemnityProd[0].ID;
        oHospIndemnityQli.put('Upsell__c','');
        oHospIndemnityQli.Quantity =  staticVariableClass.QuantityOrPrice;
        oHospIndemnityQli.UnitPrice =  staticVariableClass.QuantityOrPrice;
        oHospIndemnityQli.Product_Term_Years_Left__c = staticVariableClass.Termone;
        oHospIndemnityQli.ProductStage__c= staticVariableClass.IGAPSold;
        oHospIndemnityQli.put('Line_of_Business__c','');
        oHospIndemnityQli.put('Network__c','');
        oHospIndemnityQli.put('Involvement_Type__c','');
        
        insert new list<QuoteLineItem> {   
            dentalQli[0], visionQli, lifeQli, disabilityQli 
                };
                   /* dentalQli[0], visionQli, lifeQli, disabilityQli,disabilityQli1, 
                dentalQli2, visionQli2, lifeQli2, disabilityQli2, 
                dentalQli3, visionQli3, lifeQli3, disabilityQli3*/
                    
        List<Order> ord = new List<Order>(TestDataFactory.createOrder(1,grp.id,accountList[0].Id,user1[0].id,qte[0].id));
        
        Order ord2 = ord[0].clone();
        ord2.Implementation_Case_Name__c = staticVariableClass.AIMTesting02;
        
        Order ord3 = ord[0].clone();
        ord3.Implementation_Case_Name__c = staticVariableClass.AIMTesting03;
       
        ord[0].RecordTypeId = ord2.RecordTypeId = ord3.RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Order).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGChangeRequestOffCycle).getRecordTypeId();
        ord[0].Implementation_Type__c = staticVariableClass.ChangeRequestOffCycle;
        ord2.Implementation_Type__c = staticVariableClass.NewBusiness;
        ord3.Implementation_Type__c = staticVariableClass.ChangeRequestOffCycle;
        ord3.ID_Cards_Required__c = staticVariableClass.UpsellYes;
        ord3.If_Yes_Please_Explain_IDCard_Requirement__c =staticVariableClass.AccountName ;
        ord3.COMPLETE_PAPERWORK_RECEIVED_IN_IMPL__c = System.today();
        insert new list<Order>{ord[0], ord2,ord3};
        Id recTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(staticVariableClass.LocalNASCOandWGS).getRecordTypeId();
        List<Implementation_Tracking__c> localImpTrack = new List<Implementation_Tracking__c>(TestDataFactory.createTracking(1,recTypeId,ord3.Id));
        insert localImpTrack;
        
        List<Life_and_Disability__c> lifeRecList = (TestDataFactory.createLifeSme(1,localImpTrack[0].ID));
        lifeRecList[0].Stage__c = staticVariableClass.WorkInProgress;
        insert lifeRecList;
        
        List<Vision__c> visionRecList = (TestDataFactory.createVisionSme(1,localImpTrack[0].ID));
        visionRecList[0].Stage__c = staticVariableClass.WorkInProgress;
        insert visionRecList;
            
        /*List<Dental_Complete__c> dentalRecList =(TestDataFactory.createDentalSme(1,localImpTrack[0].ID));
        dentalRecList[0].Stage__c = staticVariableClass.WorkInProgress;
            dentalRecList[0].Is_Dental_DDS_Detail_Applicable__c = 'Yes';
            dentalRecList[0].DDS_Enrollment_Load_Date__c = System.today();
            dentalRecList[0].DDS_Group_Load_Date__c = System.today();
            dentalRecList[0].Underwriting_Comments__c ='N/A';
        insert dentalRecList;*/
        List<ID_Cards__c> idCardRecList = (TestDataFactory.createIdCard(1,localImpTrack[0].ID));
        insert idCardRecList;
        /*
        RX__c thisRX = new RX__c();
            thisRX.Implementation_Tracking_ID__c = localImpTrack[0].ID;
            thisRX.Stage__c = staticVariableClass.WorkInProgress;
            insert thisRX;*/
                        
        }
    }
    
    @isTest 
    static void stampSmeReviewDateTest()
    {
        Order ordNB = [SELECT Id,Implementation_Status__c,Implementation_Type__c FROM Order WHERE Implementation_Case_Name__c =: staticVariableClass.AIMTesting01 LIMIT 1];
        Quote quo = [select ID from Quote limit 1];
        
        Test.startTest();
        Order ordCROC = [SELECT Id,Implementation_Status__c,Implementation_Type__c FROM Order WHERE Implementation_Case_Name__c =: staticVariableClass.AIMTesting02 LIMIT 1];
        ordNB.Implementation_Status__c = ordCROC.Implementation_Status__c = staticVariableClass.PendingSmeReview;
        ordNB.COMPLETE_PAPERWORK_RECEIVED_IN_IMPL__c = ordCROC.COMPLETE_PAPERWORK_RECEIVED_IN_IMPL__c = System.today();
        update new list<Order>{ordCROC, ordNB};
        LGSMERecordCreation.stampSmeReviewDate(new set<ID>{ordNB.Id, ordCROC.Id}, new set<ID>{quo.Id});
        system.assertEquals(ordCROC.Implementation_Status__c, staticVariableClass.PendingSmeReview, staticVariableClass.assertEquals);
        Test.stopTest();
    }
    
    @isTest 
    static void stampSmeReviewDateNegativeTest()
    {
        Test.startTest();
        Order ord = new Order();
        LGSMERecordCreation.stampSmeReviewDate(new set<ID>{ord.Id}, new set<ID>{ord.Id});
        System.assertEquals(null, ord.Id,staticVariableClass.assertEquals);
        Test.stopTest();
    }
    
    @isTest 
    static void idCardStatusUpdateTest(){
        
        List<Order> ordList = new List<Order>([SELECT Id,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1]);
        
        Test.startTest();
        ordList[0].ID_Card_Review_Status__c =UtilConstants.APPROVED_ID_CARD_REVIEW_STATUS;
        update ordList;
        system.assertEquals(UtilConstants.APPROVED_ID_CARD_REVIEW_STATUS,ordList[0].ID_Card_Review_Status__c, staticVariableClass.assertEquals);
        Test.stopTest();
    }
    @isTest 
    static void idCardStatusUpdateNegativeTest(){
        
        List<Order> ordList = new List<Order>([SELECT Id,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1]);
        
        Test.startTest();
        ordList[0].ID_Card_Review_Status__c =UtilConstants.PARTIAL_APPROVED_IDCARD_REVIEW_STATUS;
        ordList[0].ID_Card_Reject_Reason__c =staticVariableClass.DNCStrTitle;
        update ordList;
        system.assertEquals(UtilConstants.PARTIAL_APPROVED_IDCARD_REVIEW_STATUS,ordList[0].ID_Card_Review_Status__c, staticVariableClass.assertEquals);
        Test.stopTest();
    }
    @isTest 
    static void populateAssignedImplementerValueOnIdCardTest(){
        
        List<Order> ordList = new List<Order>([SELECT Id,Assigned_Implementer__c,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1]);
        List<User> userList = new List<User>([SELECT id from user where email = :staticVariableClass.userEmail+staticVariableClass.DNCStrShareType LIMIT 1]);
        
        Test.startTest();
        ordList[0].Assigned_Implementer__c=userList[0].id;
        update ordList; 
        system.assertEquals( userList[0].Id,ordList[0].Assigned_Implementer__c, staticVariableClass.assertEquals);
        Test.stopTest();   
    }
    @isTest 
    static void populateAssignedImplementerValueOnIdCardNegativeTest(){
        
        List<Order> ordList = new List<Order>([SELECT Id,Assigned_Implementer__c,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1]);
        List<User> userList = new List<User>([SELECT id from user where email = :staticVariableClass.userEmail LIMIT 1]);
        
        Test.startTest();
        ordList[0].Assigned_Implementer__c=userList[0].id;
        update ordList; 
        system.assertEquals(userList[0].Id,ordList[0].Assigned_Implementer__c, staticVariableClass.assertEquals);
        Test.stopTest();   
    }
    @isTest 
    static void smeRecordStatusUpdateTest(){
        
        List<User> userList = new List<User>([SELECT id from USER WHERE email =:staticVariableClass.userEmail]);
        List<Order> ordList = new List<Order>([SELECT Id,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1]);
        List<Vision__c> visionRecList = new List<Vision__c>([SELECT id,Stage__c,Implementation_Case_Name__c, Implementation_Tracking__c from Vision__c where Stage__c =: UtilConstants.Declined_05]);
        system.assertEquals(0,visionRecList.size(), staticVariableClass.assertEquals);
        Test.startTest();
        
        System.runAs(userList[0]) {
            ordList[0].Implementation_Status__c =UtilConstants.IC_STATUS_WITHDRAWN;
            update ordList;
        }
        List<Vision__c> visionRecList1 = new List<Vision__c>([SELECT id,Stage__c,Implementation_Case_Name__c, Implementation_Tracking__c from Vision__c where Stage__c =: UtilConstants.Declined_05]);
        system.assertEquals(1,visionRecList1.size(), staticVariableClass.assertEquals);
        Test.stopTest();
    }
    @isTest 
    static void smeRecordStatusUpdateNegativeTest(){
        
        List<User> userList = new List<User>([SELECT id from USER WHERE email =:staticVariableClass.userEmail]);
        List<Order> ordList = new List<Order>([SELECT Id,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1]);
        system.assertEquals(1,userList.size(), staticVariableClass.assertEquals);
        Test.startTest();
        
        System.runAs(userList[0]) {
            ordList[0].Implementation_Status__c =staticVariableClass.PendingSmeReview;
            ordList[0].COMPLETE_PAPERWORK_RECEIVED_IN_IMPL__c = System.today();
            ordList[0].ID_Cards_Required__c='No';
            update ordList;
            system.assertEquals(staticVariableClass.PendingSmeReview,ordList[0].Implementation_Status__c, staticVariableClass.assertEquals);
            Test.stopTest();
        }
    }
     @isTest 
    static void renewalImpTypeTest(){
        
        List<Opportunity> listOppty    = new List<Opportunity>([SELECT ID,recordTypeId from Opportunity LIMIT 1]);
        List<Order> listOrd        = new List<Order>([SELECT Id,Assigned_Implementer__c,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1]);
        List<User> listUser       = new List<User>([SELECT id from user where email = :staticVariableClass.userEmail LIMIT 1]);
        
        Test.startTest();
        listOppty[0].recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(staticVariableClass.RenewalLocal1).getRecordTypeId();
        update listOppty;
        listOrd[0].User_Group__c= staticVariableClass.LOCAL_RENEWAL;
        listOrd[0].Implementation_Type__c = staticVariableClass.RENEWAL;
        listOrd[0].Assigned_Implementer__c= listUser[0].id;
        update listOrd; 
        system.assertEquals(listUser[0].Id,listOrd[0].Assigned_Implementer__c, staticVariableClass.assertEquals);
        Test.stopTest();   
    }
     @isTest 
    static void  opportunityIgapSoldTest(){
        
        List<Opportunity> listOppty    = new List<Opportunity>([SELECT ID,recordTypeId from Opportunity LIMIT 1]);
        List<Order> listOrd        = new List<Order>([SELECT Id,Assigned_Implementer__c,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1]);
        List<User> listUser       = new List<User>([SELECT id from user where email = :staticVariableClass.userEmail LIMIT 1]);
        Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(staticVariableClass.IGAPLocal).getRecordTypeId();
        Test.startTest();
            listOppty[0].recordTypeId = recTypeId;
            update listOppty;
            listOrd[0].User_Group__c= staticVariableClass.LOCAL_RENEWAL;
            listOrd[0].Implementation_Type__c = staticVariableClass.RENEWAL;
            listOrd[0].Assigned_Implementer__c= listUser[0].id;
            Update listOrd;
        Test.stopTest();   
        List<Opportunity> listOpptyAfterUpdate    = new List<Opportunity>([SELECT ID,recordTypeId from Opportunity LIMIT 1]);
        System.assertEquals(listOpptyAfterUpdate[0].recordTypeId, recTypeId, staticVariableClass.assertEquals);
    }
}