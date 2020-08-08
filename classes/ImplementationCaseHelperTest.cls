/* Author : Ranjith
// Created Date :22ndJuly 2019 
// Purpose : This is the code coverage class for "ImplementationCaseHelper" class
// Code Coverage :100%
***/
@isTest
public class ImplementationCaseHelperTest{
    public static testmethod void impcasetestdata(){
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
        
        List<Id> lstOpp= new List<Id>();
        
        Opportunity newOpp = new Opportunity(Name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name), 
        StageName = staticVariableClass.ClosedWon, AccountID = acc.id, CloseDate = ((system.TODAY())-95),                   
        RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId());
        
        INSERT newOpp;
        
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        insert grp;
        
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,newOpp.Id);
        qte.GroupNumber__c=grp.id;
        insert qte;
                
        Product2 DentalProd=ANA_UTIL01_TestMethods.createProduct(false);
        DentalProd.name='Anthem Dental';
        DentalProd.Product_Type__c = 'Dental';

        Product2 VisionProd = DentalProd.Clone();
        VisionProd.Product_Type__c = 'Vision';

        Product2 LifeProd = DentalProd.Clone();
        LifeProd.Product_Type__c = 'Life';

        Product2 DisabilityProd = DentalProd.Clone();
        DisabilityProd.Product_Type__c = 'Life';
        
        insert new list<Product2>{DentalProd, VisionProd, LifeProd, DisabilityProd};
        
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false, DentalProd.id);
        PricebookEntry pbe2=ANA_UTIL01_TestMethods.createPricebookEntry(false, VisionProd.id);
        PricebookEntry pbe3=ANA_UTIL01_TestMethods.createPricebookEntry(false, LifeProd.id);
        PricebookEntry pbe4=ANA_UTIL01_TestMethods.createPricebookEntry(false, DisabilityProd.id);
        insert new list<PricebookEntry>{pbe, pbe2, pbe3, pbe4};
        
        QuoteLineItem DentalQLI= ANA_UTIL01_TestMethods.createQuoteLineItem(false, qte.Id, pbe.id);
        DentalQLI.Quantity =  123.0;
        DentalQLI.UnitPrice =12.0;
        DentalQLI.Product_Term_Years_Left__c ='5';
        DentalQLI.Discount_sharing__c = staticVariableClass.SoldRenewed;
        DentalQLI.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        DentalQLI.ProductStage__c= staticVariableClass.Sold;
        DentalQLI.Product2ID = DentalProd.ID;
        DentalQLI.Upsell__c = '';
        

        QuoteLineItem VisionQLI = DentalQLI.clone();
        VisionQLI.Product2ID = VisionProd.ID;
        VisionQLI.Upsell__c = '';
        VisionQLI.Quantity = 1.0;
        VisionQLI.UnitPrice = 1.0;
        VisionQLI.Product_Term_Years_Left__c = '1';
        VisionQLI.Discount_sharing__c = staticVariableClass.SoldRenewed;
        VisionQLI.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
         VisionQLI.ProductStage__c= staticVariableClass.Sold;
        
        

        QuoteLineItem LifeQLI = DentalQLI.clone();
        LifeQLI.Product2ID = LifeProd.ID;
        LifeQLI.Upsell__c = '';
        LifeQLI.Quantity = 1.0;
        LifeQLI.UnitPrice = 1.0;
        LifeQLI.Product_Term_Years_Left__c = '1';
        LifeQLI.Discount_sharing__c = staticVariableClass.SoldRenewed;
        LifeQLI.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
         LifeQLI.ProductStage__c= staticVariableClass.Sold;
        

        QuoteLineItem DisabilityQLI = DentalQLI.clone();
        DisabilityQLI.Product2ID = DisabilityProd.ID;
        DisabilityQLI.Upsell__c = '';
        DisabilityQLI.Quantity = 1.0;
        DisabilityQLI.UnitPrice = 1.0;
        DisabilityQLI.Product_Term_Years_Left__c = '1';
        DisabilityQLI.Discount_sharing__c = staticVariableClass.SoldRenewed;
        DisabilityQLI.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
         DisabilityQLI.ProductStage__c= staticVariableClass.Sold;

        QuoteLineItem DentalQLI2 = DentalQLI.clone();
        DentalQLI2.Upsell__c = 'No';
        DentalQLI2.Quantity = 1.0;
        DentalQLI2.UnitPrice = 1.0;
        DentalQLI2.Product_Term_Years_Left__c = '1';
        DentalQLI2.Discount_sharing__c = staticVariableClass.SoldRenewed;
        DentalQLI2.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
         DentalQLI2.ProductStage__c= staticVariableClass.Sold;
        QuoteLineItem VisionQLI2 = VisionQLI.clone();
        VisionQLI2.Upsell__c = 'No';
         VisionQLI2.Quantity = 1.0;
        VisionQLI2.UnitPrice = 1.0;
        VisionQLI2.Product_Term_Years_Left__c = '1';
        VisionQLI2.Discount_sharing__c = staticVariableClass.SoldRenewed;
        VisionQLI2.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
         VisionQLI2.ProductStage__c= staticVariableClass.Sold;
        QuoteLineItem LifeQLI2 = LifeQLI.clone();
        LifeQLI2.Upsell__c = 'No';
        LifeQLI2.Quantity = 1.0;
        LifeQLI2.UnitPrice = 1.0;
        LifeQLI2.Product_Term_Years_Left__c = '1';
        LifeQLI2.Discount_sharing__c = staticVariableClass.SoldRenewed;
        LifeQLI2.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
         LifeQLI2.ProductStage__c= staticVariableClass.Sold;
        QuoteLineItem DisabilityQLI2 = DisabilityQLI.clone();
        DisabilityQLI2.Upsell__c = 'No';
         DisabilityQLI2.Quantity = 1.0;
        DisabilityQLI2.UnitPrice = 1.0;
        DisabilityQLI2.Product_Term_Years_Left__c = '1';
        DisabilityQLI2.Discount_sharing__c = staticVariableClass.SoldRenewed;
        DisabilityQLI2.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
         DisabilityQLI2.ProductStage__c= staticVariableClass.Sold;
        
        QuoteLineItem DentalQLI3 = DentalQLI.clone();
        DentalQLI3.Upsell__c = 'Yes';
        DentalQLI3.Quantity = 1.0;
        DentalQLI3.UnitPrice = 1.0;
        DentalQLI3.Product_Term_Years_Left__c = '1';
        DentalQLI3.Discount_sharing__c = staticVariableClass.SoldRenewed;
        DentalQLI3.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
         DentalQLI3.ProductStage__c= staticVariableClass.Sold;
        QuoteLineItem VisionQLI3 = VisionQLI.clone();
        VisionQLI3.Upsell__c = 'Yes';
        VisionQLI3.Quantity = 1.0;
        VisionQLI3.UnitPrice = 1.0;
        VisionQLI3.Product_Term_Years_Left__c = '1';
        VisionQLI3.Discount_sharing__c = staticVariableClass.SoldRenewed;
        VisionQLI3.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        QuoteLineItem LifeQLI3 = LifeQLI.clone();
        LifeQLI3.Upsell__c = 'Yes';
        LifeQLI3.Quantity = 1.0;
        LifeQLI3.UnitPrice = 1.0;
        LifeQLI3.Product_Term_Years_Left__c = '1';
        LifeQLI3.Discount_sharing__c = staticVariableClass.SoldRenewed;
        LifeQLI3.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        QuoteLineItem DisabilityQLI3 = DisabilityQLI.clone();
        DisabilityQLI3.Upsell__c = 'Yes';
        DisabilityQLI3.Quantity = 1.0;
        DisabilityQLI3.UnitPrice = 1.0;
        DisabilityQLI3.Product_Term_Years_Left__c = '1';
        DisabilityQLI3.Discount_sharing__c = staticVariableClass.SoldRenewed;
        DisabilityQLI3.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        
        test.startTest();
        insert new list<QuoteLineItem>  {   DentalQLI, VisionQLI, LifeQLI, DisabilityQLI, 
                                            DentalQLI2, VisionQLI2, LifeQLI2, DisabilityQLI2, 
                                            DentalQLI3, VisionQLI3, LifeQLI3, DisabilityQLI3
                                        };
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Local Implementations']; 
        User user2 = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='fgasdhdfh', 
                            LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', 
                            UserName='test23123we4@testorg.com');

        insert user2;
    
        Order ord = new Order(User_Group__c='Local New Business',Implementation_Type__c='New Business',Group_Name__c=grp.id,AccountId = acc.Id, EffectiveDate=System.today(), Status = 'Draft',
                            Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes', Implementation_Status__c = 'Ready for Imps', 
                            Implementation_Effective_Date__c=System.today(), Assigned_Implementer__c=user2.id,QuoteId=qte.id,Impacted_Products_Id__c=DentalQLI.id+','+VisionQLI.id+','+LifeQLI.id+','+DisabilityQLI.id+','+DentalQLI2.id+','+VisionQLI2.id+','+LifeQLI2.id+','+DisabilityQLI2.id+','+DentalQLI3.id+','+VisionQLI3.id+','+LifeQLI3.id+','+DisabilityQLI3.id);

        insert ord;
        
        ord.If_Yes_Please_Explain_IDCard_Requirement__c='New Business Requires ID Cards';
        ord.ID_Cards_Required__c='Yes';
        update ord;
        
        
        test.stopTest();
    }
}