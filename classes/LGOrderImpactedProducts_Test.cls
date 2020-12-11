@isTest
public class LGOrderImpactedProducts_Test {
    
    @testSetup
    public static void testSetUpMethod(){
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
        VisionProd.name='Anthem Vision';
        VisionProd.Product_Type__c = 'Vision';
        
        Product2 LifeProd = DentalProd.Clone();
        LifeProd.name='Anthem LifeProd';
        LifeProd.Product_Type__c = 'Life';
        
        Product2 MedicalProd = DentalProd.Clone();
        MedicalProd.Product_Type__c = 'Medical';
        
        Product2 MedicalProdLegacy = DentalProd.Clone();
        MedicalProd.Product_Type__c = 'Medical';
        
        insert new list<Product2>{DentalProd, VisionProd, LifeProd, MedicalProd,MedicalProdLegacy};
            
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false, DentalProd.id);
        PricebookEntry pbe2=ANA_UTIL01_TestMethods.createPricebookEntry(false, VisionProd.id);
        PricebookEntry pbe3=ANA_UTIL01_TestMethods.createPricebookEntry(false, LifeProd.id);
        PricebookEntry pbe4=ANA_UTIL01_TestMethods.createPricebookEntry(false, MedicalProd.id);
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
        
        
        QuoteLineItem MedicalQLI = DentalQLI.clone();
        MedicalQLI.Product2ID = MedicalProd.ID;
        MedicalQLI.Upsell__c = '';
        MedicalQLI.Quantity = 1.0;
        MedicalQLI.UnitPrice = 1.0;
        MedicalQLI.Product_Term_Years_Left__c = '1';
        MedicalQLI.Discount_sharing__c = staticVariableClass.SoldRenewed;
        MedicalQLI.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        MedicalQLI.ProductStage__c= staticVariableClass.Sold;
        
        
        QuoteLineItem MedicalQLILeg = DentalQLI.clone();
        MedicalQLILeg.Product2ID = MedicalProdLegacy.ID;
        MedicalQLILeg.Upsell__c = '';
        MedicalQLILeg.Quantity = 1.0;
        MedicalQLILeg.UnitPrice = 1.0;
        MedicalQLILeg.Product_Term_Years_Left__c = '1';
        MedicalQLILeg.Discount_sharing__c = staticVariableClass.SoldRenewed;
        MedicalQLILeg.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        MedicalQLILeg.ProductStage__c= staticVariableClass.Sold;
        
        QuoteLineItem MedicalQLI2 = DentalQLI.clone();
        MedicalQLI2.ParentQuoteLineItem__c = MedicalQLI.Id;
        MedicalQLI2.Upsell__c = 'No';
        MedicalQLI2.Quantity = 1.0;
        MedicalQLI2.UnitPrice = 1.0;
        MedicalQLI2.Product_Term_Years_Left__c = '1';
        MedicalQLI2.Discount_sharing__c = staticVariableClass.SoldRenewed;
        MedicalQLI2.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        MedicalQLI2.ProductStage__c= staticVariableClass.Sold;
        
        test.startTest();
        insert new list<QuoteLineItem>  {   DentalQLI, VisionQLI, LifeQLI, MedicalQLI, 
            MedicalQLI2
            };
                
                Profile p1 = [SELECT Id FROM Profile WHERE Name='Local Implementations']; 
        User user2 = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='fgasdhdfh', 
                              LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', 
                              UserName='test23123we4@testorg.com');
        
        insert user2;
        
        Order ord = new Order(Group_Name__c=grp.id,AccountId = acc.Id, EffectiveDate=System.today(), Status = 'Draft',
                              Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes', Implementation_Status__c = 'Ready for Imps', 
                              Implementation_Effective_Date__c=System.today(), Assigned_Implementer__c=user2.id,QuoteId=qte.id);
        
        
        insert new list<Order>{ord};
    }
    
    @isTest
    public static void testGetQliOfCase()
    {
        List<Order> ord = new List<Order>([select id,QuoteId from Order where Implementation_Case_Name__c='AIMTesting01']);
        test.startTest();
        if(ord.size()>0){
            LGOrderImpactedProducts_Ctrl.getQliOfCase(ord[0].Id,ord[0].QuoteId);
        }
        test.stopTest();
    }
    @isTest
    public static void testGetQliOfCaseWithIMP()
    {
        List<Order> ord = new List<Order>([select id,QuoteId from Order where Implementation_Case_Name__c='AIMTesting01']);
        List<QuoteLineItem> qli = new List<QuoteLineItem>([select id, Product2.Name from QuoteLineItem where Product2.Name='Anthem LifeProd']);
        ord[0].Impacted_Products_Id__c = qli[0].Id;
        test.startTest();
        update ord[0];
        if(ord.size()>0){
            LGOrderImpactedProducts_Ctrl.getQliOfCase(ord[0].Id,ord[0].QuoteId);
        }
        test.stopTest();
    }
    
    @isTest
    public static void testUpdateQli()
    {
        
        Map<String,QuoteLineItem> qliIds = new Map<String,QuoteLineItem>([select id from QuotelineItem where Upsell__c = 'yes' OR Upsell__c = 'No']);
        List<Order> ord = new List<Order>([select id,QuoteId from Order where Implementation_Case_Name__c='AIMTesting01']);
        List<String> qliIdList = new List<String>();
        qliIdList.addAll(qliIds.keySet());
        test.startTest();
        if(!qliIdList.isEmpty() && qliIdList!=null)
        {
            
            
            LGOrderImpactedProducts_Ctrl.updateQli(qliIdList,ord[0].Id);
        }
        else
        {
            System.debug('Not Updated');
            //LGOrderImpactedProducts_Ctrl.updateQli(qliIdList,ord[0].Id);
        }
        test.stopTest();
        
    }
    @isTest
    public static void testUpdateQliNull()
    {
        List<Order> ord = new List<Order>([select id,QuoteId from Order where Implementation_Case_Name__c='AIMTesting01']);
        List<String> qliIdList = new List<String>();
        test.startTest();
        LGOrderImpactedProducts_Ctrl.updateQli(qliIdList,ord[0].Id);
        test.stopTest();
    }
    
    @isTest
    public static void testGetQliOfCaseOrdIdNull()
    {
        
        List<String> qliIdList = new List<String>();
        test.startTest();
        LGOrderImpactedProducts_Ctrl.getQliOfCase(null,null);
        test.stopTest();
    }
}