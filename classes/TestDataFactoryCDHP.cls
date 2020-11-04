//***************************************************//
// Created By : Suresh Parishwad
// Reason : To cover CDHP Button Functionality 
// TestDataFactory
// Name : testDataFactoryCDHP
// *************************************************//

@isTest
Public class TestDataFactoryCDHP{
    public static List<Account> lstAcc;
    public static List<Contact> lstCont;
    public static List<Brokerage_and_Consultant__c> lstBrokerConsult;
    public static List<Opportunity> lstOpp;
    public static List<Quote> lstQuote;
    public static List<Product2> lstProduct;
    public static List<PricebookEntry> lstPBEntry;
    public static List<QuoteLineItem> lstQLItem;
    public static List<HRA_Administration__c> lstHRA;
    
    public static Id standardPB;
    //Create test Account record
    public static void createAccount(){
       
        lstAcc = new List<Account>();
        
        List<RecordType> lstRcdType = [Select Id From RecordType Where Name =: 'Brokerage' Limit 1];
        
        Account acc = new Account(Cancel_Date__c = System.today().addDays(2),Name = 'Test Account', RecordTypeId = lstRcdType[0].Id);
        
        lstAcc.add(acc);
        
        Account acc1 = new Account(Cancel_Date__c = System.today().addDays(2),Name = 'Test Account1', RecordTypeId = lstRcdType[0].Id);
        lstAcc.add(acc1);
        
        Account acc2 = new Account(Cancel_Date__c = System.today().addDays(2),Name = 'Test Account2', RecordTypeId = lstRcdType[0].Id);
        lstAcc.add(acc2);
        
        insert lstAcc;
        system.debug('lstAcc' +lstAcc);
    }
    public static void createContact(){
        lstCont = new List<Contact>();
        Contact ct = new Contact(AccountId=lstAcc[0].Id,FirstName='test',LastName='Test',Phone='0123456789',Email='Test@test.com',Primary_Contact__c=true,IsActive1__c=true);
        Contact ct1 = new Contact(AccountId=lstAcc[0].Id,FirstName='test',LastName='Test',Phone='0123456789',Email='Test@test.com',Primary_Contact__c=true,IsActive1__c=true);
        Contact ct2 = new Contact(AccountId=lstAcc[0].Id,FirstName='test',LastName='Test',Phone='0123456789',Email='Test@test.com',Primary_Contact__c=true,IsActive1__c=true);
        lstCont.add(ct);
        lstCont.add(ct1);
        lstCont.add(ct2);
        
        insert lstCont;
        
        List<RecordType> lstRcdType = [Select Id From RecordType Where Name =: 'Consultant Contact' Limit 1];
        ContactRelationship__c contRel = new ContactRelationship__c(EndDate__c=System.today().addDays(2),RecordTypeId = lstRcdType[0].Id,IsActive__c=true,Account__c=lstAcc[0].Id,Contact__c=lstCont[0].Id);
        insert contRel;
        
        
        system.debug('contRel '+[Select id,RecordType.name,CONTCANCEL__c,Account__r.Id from ContactRelationship__c where id =: contRel.Id]);
        system.debug('account '+lstAcc[0].Id);
        
        
        lstBrokerConsult = new List<Brokerage_and_Consultant__c>();
        
        
        Brokerage_and_Consultant__c bc1 = new Brokerage_and_Consultant__c(ConsultantEndDate__c=System.today().addDays(2),Brokerage__c=lstAcc[0].Id,Account__c = lstAcc[0].Id,Consultant__c=contRel.Id,NameofBrokerage__c='test');
        Brokerage_and_Consultant__c bc2 = new Brokerage_and_Consultant__c(ConsultantEndDate__c=System.today().addDays(3),Brokerage__c=lstAcc[0].Id,Account__c = lstAcc[0].Id,Consultant__c=contRel.Id,NameofBrokerage__c='test1');
        Brokerage_and_Consultant__c bc3 = new Brokerage_and_Consultant__c(ConsultantEndDate__c=System.today().addDays(4),Brokerage__c=lstAcc[0].Id,Account__c = lstAcc[0].Id,Consultant__c=contRel.Id,NameofBrokerage__c='test2');
		lstBrokerConsult.add(bc1);
        lstBrokerConsult.add(bc2);
        lstBrokerConsult.add(bc3);
        
        system.debug('lstBrokerConsult '+lstBrokerConsult);
      
        
        insert lstBrokerConsult;
        
        
    }
    public static void createOpp(){
        lstOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity(AccountId = lstAcc[0].Id,Name = 'Test Opp', StageName = 'Initiated',CloseDate = System.today().toStartOfMonth());
        lstOpp.add(opp);
        
        Opportunity opp1 = new Opportunity(AccountId = lstAcc[1].Id,Name = 'Test Opp', StageName = 'Initiated',CloseDate = System.today().toStartOfMonth());
        lstOpp.add(opp1);
        
        Opportunity opp2 = new Opportunity(AccountId = lstAcc[2].Id,Name = 'Test Opp', StageName = 'Initiated',CloseDate = System.today().toStartOfMonth());
        lstOpp.add(opp2);
        
        insert lstOpp;
        system.debug('lstOpp' +lstOpp);
        
    }
    public static void createQuote(){
        lstQuote = new List<Quote>();
        
        standardPB = Test.getStandardPricebookId();
        
        Quote qt = new Quote(Name = 'Test Quote', OpportunityId = lstOpp[0].Id, Pricebook2Id = standardPB);
        
        Quote qt1 = new Quote(Name = 'Test Quote1', OpportunityId = lstOpp[0].Id, Pricebook2Id = standardPB);
        
        Quote qt2 = new Quote(Name = 'Test Quote2', OpportunityId = lstOpp[1].Id, Pricebook2Id = standardPB);
        
        Quote qt3 = new Quote(Name = 'Test Quote3', OpportunityId = lstOpp[2].Id, Pricebook2Id = standardPB);
        
        Quote qt4 = new Quote(Name = 'Test Quote1', OpportunityId = lstOpp[0].Id, Pricebook2Id = standardPB);
        
        lstQuote.add(qt);
        lstQuote.add(qt1);
        lstQuote.add(qt2);
        lstQuote.add(qt3);
        lstQuote.add(qt4);
        
        insert lstQuote;
    } 
    
    /////
    public static String returnCreateQuote(){
       String id1=lstQuote[0].id;
        
        return id1;
    } 
    public static String returnCreateQuote1(){
       String id1=lstQuote[1].id;
        
        return id1;
    }
    public static String returnCreateQuote2(){
       String id1=lstQuote[4].id;
        
        return id1;
    }
    
    public static void createQuoteLineItem(){
        lstQLItem = new List<QuoteLineItem>();
        
        
        QuoteLineItem qlt = new QuoteLineItem(FSA_Plan_Options__c= 'Dependent Care FSA Plan;FSA Section 213d Plan',RecordType__c = 'ActWise HRA', Product2Id = lstProduct[1].Id, QuoteId = lstQuote[0].id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[2].Id, ProductStage__c = 'Sold',PLComplete__c=true);
        QuoteLineItem qlt4 = new QuoteLineItem(FSA_Plan_Options__c= 'Dependent Care FSA Plan;FSA Section 213d Plan',RecordType__c = 'ActWise HRA',Product2Id = lstProduct[1].Id, QuoteId = lstQuote[1].id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[2].Id, ProductStage__c = 'IGAP Sold',PLComplete__c=true);
        QuoteLineItem qlt5 = new QuoteLineItem(FSA_Plan_Options__c= 'Dependent Care FSA Plan;FSA Section 213d Plan',RecordType__c = 'ActWise HRA',Product2Id = lstProduct[1].Id, QuoteId = lstQuote[4].id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[2].Id, ProductStage__c = 'IGAP Sold',PLComplete__c=true);
        QuoteLineItem qlt1 = new QuoteLineItem(FSA_Plan_Options__c= 'Dependent Care FSA Plan;FSA Section 213d Plan',RecordType__c = 'ActWise HSA',Product2Id = lstProduct[1].Id, QuoteId = lstQuote[0].id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[2].Id, ProductStage__c = 'IGAP Sold',PLComplete__c=true);
        QuoteLineItem qlt2 = new QuoteLineItem(FSA_Plan_Options__c= 'Dependent Care FSA Plan;Limited Purpose FSA Plan',RecordType__c = 'ActWise FSA',Product2Id = lstProduct[1].Id, QuoteId = lstQuote[0].id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[2].Id, ProductStage__c = 'IGAP Sold',PLComplete__c=true);
        QuoteLineItem qlt3 = new QuoteLineItem(FSA_Plan_Options__c= 'Dependent Care FSA Plan;Limited Purpose FSA Plan',RecordType__c = 'ActWise Commuter',Product2Id = lstProduct[1].Id, QuoteId = lstQuote[0].id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = lstPBEntry[2].Id, ProductStage__c = 'IGAP Sold');
        
        lstQLItem.add(qlt);
        lstQLItem.add(qlt1);
        lstQLItem.add(qlt2);
        lstQLItem.add(qlt3);
        lstQLItem.add(qlt4);
        lstQLItem.add(qlt5);
        insert lstQLItem;
        
    }
    public static void createProducts(){
        lstProduct = new List<Product2>();
        lstPBEntry = new List<PricebookEntry>();
        
        
        //Pricebook2 standardPB = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        
        Pricebook2 prb= new Pricebook2(Name='Standard Price Book 2009',Description ='Price Book 2009 Products',IsActive = true);
        insert prb;
        
        Product2 pr = new Product2(Name='Medical ActWise HRA',IsActive=true,QLIRecordType__c='ActWise HRA');
        lstProduct.add(pr);
       // insert pr;
        
        Product2 pr1 = new Product2(Name='Medical ActWise HSA',IsActive=true,QLIRecordType__c='ActWise HSA');
        lstProduct.add(pr1);
        insert lstProduct;
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB, Product2Id = pr.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        //insert standardPrice;
        lstPBEntry.add(standardPrice);
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = prb.Id, Product2Id = pr.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        lstPBEntry.add(pbe);
        
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = standardPB, Product2Id = pr1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        lstPBEntry.add(pbe1);
        
        insert lstPBEntry;
        
    }
    public static void createSessionData(){
        CDHPISGIntegrationSettings__c cdhpSession = new CDHPISGIntegrationSettings__c();
        cdhpSession.Consumer_Key__c = '3MVG97wqanbUM37J7SuKYO4Fktc69Aj2ogoqoYJXm6ne1_Iiq85Zg9hDYjSo29p3vqNFCfm1PmB95FSxg2Y3m';
        cdhpSession.Consumer_Secret__c = 'EA4A33AFB1C9E28C2F70995F8F4169E93ACA05C9E7133C1C669C43B83D6331C1';
        cdhpSession.ISG_SF_Org_URL__c = '';
        cdhpSession.ISGURL__c = 'https://ind--foaqa.my.salesforce.com/';
        cdhpSession.Password__c = 'Passwordfoaqa1';
        cdhpSession.Session_URL__c = 'https://test.salesforce.com/services/oauth2/token';
        cdhpSession.User_Name__c = 'michaeldildar.khan@legatohealth.com.foaqa';
        
        insert cdhpSession;
        
    }
    public static void createHRA(){
        lstHRA = new List<HRA_Administration__c>();
        HRA_Administration__c hra = new HRA_Administration__c(QLI__c=lstQLItem[0].Id,Plan_Start_Date__c=System.today(),Plan_End_Date__c=System.today().addDays(3),HRA1_Group_Suffix__c='HRA',CapEE__c=12.00,CapEA__c=12.00,
                                                             CapEChild__c=12.00,CapEChildren__c=12.00,CapEFamily__c=12.00,AllocationEA__c=12.00,
                                                             Allocation_EChild__c=12.00,AllocationEChildren__c=12.00,AllocationEE__c=12.00,AllocationFamily__c=12.00,
                                                             Annual_Allocation_Tiers__c='2 Tier',Claim_Run_Out_Date__c=System.today().addDays(2),Debit_Card_Services__c='Medical;Dental;OTC;Pharmacy;Vision',
                                                             Has_Individual_Deductible__c=true,Employee_Funds_Rollover_Next_Plan_Year__c='Percent',HRA_Funds_to_Employees_and_on_what_basis__c='No, Annually',
                                                             HRA_Funds_Pro_Rate_on_Entry_Date__c='Monthly',Health_Activities_Incentives__c='No',Health_Incentive_Type__c='Incentive HRA Only',Individual_Deductible_Amount__c=12.00,
                                                             If_Other_Please_Specify__c='123',Specialty__c='Dental (Debit Card);Vision (Debit Card)',Rollover_Cap_Tiers__c='2 Tier',Member_Responsibility_by_Claim__c='25%',Minimum_Rollover_Amount__c=12.00,Type_of_HRA__c='Auto-Pay Provider Only',HRA_Rollover__c='No',
                                                             Rollover_Different_Admin__c='Yes',UpfrontDedEE__c=12.00,UpFrontDedEA__c=12.00,UpfrontDedEChild__c=12.00,UpFrontDedEEChildren__c=12.00,
                                                             UpFrontDedFamily__c=12.00,Up_Front_Deductible_Tiers__c='2 Tier',HRA_Lites_Rollover__c='Yes');
        
        HRA_Administration__c hra1 = new HRA_Administration__c(QLI__c=lstQLItem[4].Id,Plan_Start_Date__c=System.today(),Plan_End_Date__c=System.today().addDays(3),HRA1_Group_Suffix__c='HRA',CapEE__c=12.00,CapEA__c=12.00,
                                                             CapEChild__c=12.00,CapEChildren__c=12.00,CapEFamily__c=12.00,AllocationEA__c=12.00,
                                                             Allocation_EChild__c=12.00,AllocationEChildren__c=12.00,AllocationEE__c=12.00,AllocationFamily__c=12.00,
                                                             Annual_Allocation_Tiers__c='2 Tier',Claim_Run_Out_Date__c=System.today().addDays(2),Debit_Card_Services__c='Medical;Dental',NonSplit_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;In Network Coinsurance;Out of Network Medical Deductible;Out of Network Coinsurance;Rx',
                                                             Has_Individual_Deductible__c=true,Employee_Funds_Rollover_Next_Plan_Year__c='Percent',HRA_Funds_to_Employees_and_on_what_basis__c='No, Annually',Split_Percentage_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays;Rx',
                                                             HRA_Funds_Pro_Rate_on_Entry_Date__c='Monthly',Health_Activities_Incentives__c='No',Health_Incentive_Type__c='Incentive HRA Only',Individual_Deductible_Amount__c=12.00,
                                                             Rollover_Cap_Tiers__c='2 Tier',Member_Responsibility_by_Claim__c='25%',Minimum_Rollover_Amount__c=12.00,Type_of_HRA__c='Auto-Pay Provider Only',HRA_Rollover__c='No',
                                                             Covered_Services__c='Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays;Rx',HRA_Upfront_Deductible__c='No',HRA_Split_Percentage__c = 'Yes',Medical__c='Provider Pay;Member Pay (Debit Card)');
   		HRA_Administration__c hra2 = new HRA_Administration__c(QLI__c=lstQLItem[5].Id,Plan_Start_Date__c=System.today(),Plan_End_Date__c=System.today().addDays(3),HRA1_Group_Suffix__c='HRA',CapEE__c=12.00,CapEA__c=12.00,
                                                             CapEChild__c=12.00,CapEChildren__c=12.00,CapEFamily__c=12.00,AllocationEA__c=12.00,
                                                             Allocation_EChild__c=12.00,AllocationEChildren__c=12.00,AllocationEE__c=12.00,AllocationFamily__c=12.00,
                                                             Annual_Allocation_Tiers__c='2 Tier',Claim_Run_Out_Date__c=System.today().addDays(2),Debit_Card_Services__c='Medical;Dental',NonSplit_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;In Network Coinsurance;Out of Network Medical Deductible;Out of Network Coinsurance;Rx',
                                                             Has_Individual_Deductible__c=true,Employee_Funds_Rollover_Next_Plan_Year__c='Percent',HRA_Funds_to_Employees_and_on_what_basis__c='No, Annually',Split_Percentage_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays;Rx',
                                                             HRA_Funds_Pro_Rate_on_Entry_Date__c='Monthly',Health_Activities_Incentives__c='No',Health_Incentive_Type__c='Incentive HRA Only',Individual_Deductible_Amount__c=12.00,
                                                             Rollover_Cap_Tiers__c='2 Tier',Member_Responsibility_by_Claim__c='25%',Minimum_Rollover_Amount__c=12.00,Type_of_HRA__c='Auto-Pay Provider Only',HRA_Rollover__c='No',
                                                             Covered_Services__c='Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays,Rx',HRA_Upfront_Deductible__c='No',HRA_Split_Percentage__c = 'No',Medical__c='Provider Pay;Member Pay (Debit Card)');
   
        
        //test Data for checkMultipleHRARecords method on CreateCDHPQuestionnaire class
        HRA_Administration__c hra3 = new HRA_Administration__c(QLI__c=lstQLItem[0].Id,Plan_Start_Date__c=System.today(),Plan_End_Date__c=System.today().addDays(3),HRA1_Group_Suffix__c='HRA',CapEE__c=12.00,CapEA__c=12.00,
                                                             CapEChild__c=12.00,CapEChildren__c=12.00,CapEFamily__c=12.00,AllocationEA__c=12.00,
                                                             Allocation_EChild__c=12.00,AllocationEChildren__c=12.00,AllocationEE__c=12.00,AllocationFamily__c=12.00,
                                                             Annual_Allocation_Tiers__c='2 Tier',Claim_Run_Out_Date__c=System.today().addDays(2),Debit_Card_Services__c='Medical;Dental',NonSplit_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;In Network Coinsurance;Out of Network Medical Deductible;Out of Network Coinsurance;Rx',
                                                             Has_Individual_Deductible__c=true,Employee_Funds_Rollover_Next_Plan_Year__c='Percent',HRA_Funds_to_Employees_and_on_what_basis__c='No, Annually',Split_Percentage_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays;Rx',
                                                             HRA_Funds_Pro_Rate_on_Entry_Date__c='Monthly',Health_Activities_Incentives__c='No',Health_Incentive_Type__c='Incentive HRA Only',Individual_Deductible_Amount__c=12.00,
                                                             Rollover_Cap_Tiers__c='2 Tier',Member_Responsibility_by_Claim__c='25%',Minimum_Rollover_Amount__c=12.00,Type_of_HRA__c='Member Pay (debit card) Only',HRA_Rollover__c='No',
                                                             Covered_Services__c='Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays,Rx',HRA_Upfront_Deductible__c='Yes',HRA_Split_Percentage__c = 'No',Medical__c='Provider Pay;Member Pay (Debit Card)');
   
        HRA_Administration__c hra4 = new HRA_Administration__c(QLI__c=lstQLItem[0].Id,Plan_Start_Date__c=System.today(),Plan_End_Date__c=System.today().addDays(3),HRA1_Group_Suffix__c='HRA',CapEE__c=12.00,CapEA__c=12.00,
                                                             CapEChild__c=12.00,CapEChildren__c=12.00,CapEFamily__c=12.00,AllocationEA__c=12.00,
                                                             Allocation_EChild__c=12.00,AllocationEChildren__c=12.00,AllocationEE__c=12.00,AllocationFamily__c=12.00,
                                                             Annual_Allocation_Tiers__c='2 Tier',Claim_Run_Out_Date__c=System.today().addDays(2),Debit_Card_Services__c='Medical;Dental',NonSplit_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;In Network Coinsurance;Out of Network Medical Deductible;Out of Network Coinsurance;Rx',
                                                             Has_Individual_Deductible__c=true,Employee_Funds_Rollover_Next_Plan_Year__c='Percent',HRA_Funds_to_Employees_and_on_what_basis__c='No, Annually',Split_Percentage_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays;Rx',
                                                             HRA_Funds_Pro_Rate_on_Entry_Date__c='Monthly',Health_Activities_Incentives__c='No',Health_Incentive_Type__c='Incentive HRA Only',Individual_Deductible_Amount__c=12.00,
                                                             Rollover_Cap_Tiers__c='2 Tier',Member_Responsibility_by_Claim__c='25%',Minimum_Rollover_Amount__c=12.00,Type_of_HRA__c='Member Pay (debit card) Only',HRA_Rollover__c='No',
                                                             Covered_Services__c='Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays,Rx',HRA_Upfront_Deductible__c='Yes',HRA_Split_Percentage__c = 'YEs',Medical__c='Provider Pay;Member Pay (Debit Card)');
   
        HRA_Administration__c hra5 = new HRA_Administration__c(QLI__c=lstQLItem[0].Id,Plan_Start_Date__c=System.today(),Plan_End_Date__c=System.today().addDays(3),HRA1_Group_Suffix__c='HRA',CapEE__c=12.00,CapEA__c=12.00,
                                                             CapEChild__c=12.00,CapEChildren__c=12.00,CapEFamily__c=12.00,AllocationEA__c=12.00,
                                                             Allocation_EChild__c=12.00,AllocationEChildren__c=12.00,AllocationEE__c=12.00,AllocationFamily__c=12.00,
                                                             Annual_Allocation_Tiers__c='2 Tier',Claim_Run_Out_Date__c=System.today().addDays(2),Debit_Card_Services__c='Medical;Dental',NonSplit_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;In Network Coinsurance;Out of Network Medical Deductible;Out of Network Coinsurance;Rx',
                                                             Has_Individual_Deductible__c=true,Employee_Funds_Rollover_Next_Plan_Year__c='Percent',HRA_Funds_to_Employees_and_on_what_basis__c='No, Annually',Split_Percentage_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays;Rx',
                                                             HRA_Funds_Pro_Rate_on_Entry_Date__c='Monthly',Health_Activities_Incentives__c='No',Health_Incentive_Type__c='Incentive HRA Only',Individual_Deductible_Amount__c=12.00,
                                                             Rollover_Cap_Tiers__c='2 Tier',Member_Responsibility_by_Claim__c='25%',Minimum_Rollover_Amount__c=12.00,Type_of_HRA__c='Provider Pay Medical with Optional Rx/Dental/Vision Debit Card',HRA_Rollover__c='No',
                                                             Covered_Services__c='Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays,Rx',HRA_Upfront_Deductible__c='Yes',HRA_Split_Percentage__c = 'Yes',Medical__c='Provider Pay;Member Pay (Debit Card)');
   
        
         HRA_Administration__c hra6 = new HRA_Administration__c(QLI__c=lstQLItem[0].Id,Plan_Start_Date__c=System.today(),Plan_End_Date__c=System.today().addDays(3),HRA1_Group_Suffix__c='HRA',CapEE__c=12.00,CapEA__c=12.00,
                                                             CapEChild__c=12.00,CapEChildren__c=12.00,CapEFamily__c=12.00,AllocationEA__c=12.00,
                                                             Allocation_EChild__c=12.00,AllocationEChildren__c=12.00,AllocationEE__c=12.00,AllocationFamily__c=12.00,
                                                             Annual_Allocation_Tiers__c='2 Tier',Claim_Run_Out_Date__c=System.today().addDays(2),Debit_Card_Services__c='Medical;Dental',NonSplit_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;In Network Coinsurance;Out of Network Medical Deductible;Out of Network Coinsurance;Rx',
                                                             Has_Individual_Deductible__c=true,Employee_Funds_Rollover_Next_Plan_Year__c='Percent',HRA_Funds_to_Employees_and_on_what_basis__c='No, Annually',Split_Percentage_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays;Rx',
                                                             HRA_Funds_Pro_Rate_on_Entry_Date__c='Monthly',Health_Activities_Incentives__c='No',Health_Incentive_Type__c='Incentive HRA Only',Individual_Deductible_Amount__c=12.00,
                                                             Rollover_Cap_Tiers__c='2 Tier',Member_Responsibility_by_Claim__c='25%',Minimum_Rollover_Amount__c=12.00,Type_of_HRA__c='Provider Pay Medical with Optional Rx/Dental/Vision Debit Card',HRA_Rollover__c='No',
                                                             Covered_Services__c='Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays,Rx',HRA_Upfront_Deductible__c='Yes',HRA_Split_Percentage__c = 'Yes',Medical__c='Provider Pay;Member Pay (Debit Card)');
   
        HRA_Administration__c hra7 = new HRA_Administration__c(QLI__c=lstQLItem[0].Id,Plan_Start_Date__c=System.today(),Plan_End_Date__c=System.today().addDays(3),HRA1_Group_Suffix__c='HRA',CapEE__c=12.00,CapEA__c=12.00,
                                                             CapEChild__c=12.00,CapEChildren__c=12.00,CapEFamily__c=12.00,AllocationEA__c=12.00,
                                                             Allocation_EChild__c=12.00,AllocationEChildren__c=12.00,AllocationEE__c=12.00,AllocationFamily__c=12.00,
                                                             Annual_Allocation_Tiers__c='2 Tier',Claim_Run_Out_Date__c=System.today().addDays(2),Debit_Card_Services__c='Medical;Dental',NonSplit_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;In Network Coinsurance;Out of Network Medical Deductible;Out of Network Coinsurance;Rx',
                                                             Has_Individual_Deductible__c=true,Employee_Funds_Rollover_Next_Plan_Year__c='Percent',HRA_Funds_to_Employees_and_on_what_basis__c='No, Annually',Split_Percentage_Covered_Services__c = 'Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays;Rx',
                                                             HRA_Funds_Pro_Rate_on_Entry_Date__c='Monthly',Health_Activities_Incentives__c='No',Health_Incentive_Type__c='Incentive HRA Only',Individual_Deductible_Amount__c=12.00,
                                                             Rollover_Cap_Tiers__c='2 Tier',Member_Responsibility_by_Claim__c='25%',Minimum_Rollover_Amount__c=12.00,Type_of_HRA__c='Auto-Pay Provider Only',HRA_Rollover__c='No',
                                                             Covered_Services__c='Auto Pay Medical;In Network Medical Deductible;Out of Network Medical Deductible;In Network Coinsurance;Out of Network Coinsurance;In Network Copays;Out of Network Copays,Rx',HRA_Upfront_Deductible__c='No',HRA_Split_Percentage__c = 'Yes',Medical__c='Provider Pay;Member Pay (Debit Card)');
   
        lstHRA.add(hra);
        lstHRA.add(hra1);
        lstHRA.add(hra2);
        lstHRA.add(hra3);
        lstHRA.add(hra4);
        lstHRA.add(hra5);
        lstHRA.add(hra6);
        lstHRA.add(hra7);
        insert lstHRA;
    }
    
   
}