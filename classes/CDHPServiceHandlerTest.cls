@isTest
public class CDHPServiceHandlerTest {
    static testMethod void testMethod1() {
        //System.debug('in testMethod1');
        List<RecordType> lstRcdType = [Select Id From RecordType Where Name =: 'Prospect' Limit 1];
        Account acc = new Account(Name = 'Test Account', RecordTypeId = lstRcdType[0].Id);
        Insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opp', AccountId = acc.id, StageName = 'Prospecting', CloseDate = system.today().toStartOfMonth());
        insert opp;
        Group__c grp=new Group__c(Account__c=acc.id,Account_Manager__c='Test');
        insert grp;
        Quote q=new quote(Name='Test', OpportunityId = opp.Id,GroupNumber__c=grp.Id);
        insert q; 
        
        CDHPService.CDHPFields cdhpSerFlds = new CDHPService.CDHPFields(); 
        CDHPService.StatusDetails StatusDetails1 =new CDHPService.StatusDetails();
        CDHPService.OpportunityDetails oppDetails1 = new CDHPService.OpportunityDetails();
        CDHPService.DocuSignDetails docsgn1 = new CDHPService.DocuSignDetails();
        CDHPService.GroupDetails grpDetails1 = new CDHPService.GroupDetails();      
        
        StatusDetails1.Status = 'Test';
        StatusDetails1.StatusMessage = 'Test';
        StatusDetails1.QuoteId = q.id;
        //StatusDetails1.QuoteId = null;
        Test.startTest();
        oppDetails1.SFORGOpportunityId = opp.Id; 
        oppDetails1.OptyName = 'Test Opportunity';
        oppDetails1.OptyEffectiveDate = System.today().toStartOfWeek() ;
        oppDetails1.OptyRecordType = 'New Business';
        oppDetails1.StageName = 'Prospecting';
        
        docsgn1.dsfs_Envelope_Name = 'DSX-100002';
        docsgn1.dsfs_Envelope_Status = 'Test DocuSign';
        docsgn1.dsfs_Sent_Date_Time = datetime.now().addDays(-5);
        docsgn1.dsfs_Sent_Age = 5;
        
        grpDetails1.EmployerName = 'Test Employer';
        grpDetails1.EmployerIdCaseNumber = '12345' ;
        
        cdhpSerFlds.StatusDetails = StatusDetails1;
        cdhpSerFlds.oppDetails = oppDetails1;
        cdhpSerFlds.docSignDetails = docsgn1;
        cdhpSerFlds.grpDetails = grpDetails1;
        
        List<CDHPService.CDHPFields> cdhpSerFldsList = new List<CDHPService.CDHPFields>();
        CDHPService.CDHPFields cdhpSerFlds2 = new CDHPService.CDHPFields(); 
        CDHPService.StatusDetails StatusDetails2 =new CDHPService.StatusDetails();
        CDHPService.OpportunityDetails oppDetails2 = new CDHPService.OpportunityDetails();
        CDHPService.DocuSignDetails docsgn2 = new CDHPService.DocuSignDetails();
        CDHPService.GroupDetails grpDetails2 = new CDHPService.GroupDetails();      
        
        StatusDetails2.Status = 'Test';
        StatusDetails2.StatusMessage = 'Test';
        StatusDetails2.QuoteId =null;
        
        
        oppDetails2.SFORGOpportunityId = opp.Id; 
        oppDetails2.OptyName = 'Test Opportunity';
        oppDetails2.OptyEffectiveDate = System.today().toStartOfWeek() ;
        oppDetails2.OptyRecordType = 'New Business';
        oppDetails2.StageName = 'Prospecting';
        
        docsgn2.dsfs_Envelope_Name = 'DSX-100002';
        docsgn2.dsfs_Envelope_Status = 'Test DocuSign';
        docsgn2.dsfs_Sent_Date_Time = datetime.now().addDays(-5);
        docsgn2.dsfs_Sent_Age = 5;
        
        grpDetails2.EmployerName = 'Test Employer';
        grpDetails2.EmployerIdCaseNumber = '12345' ;
        
        cdhpSerFlds2.StatusDetails = StatusDetails2;
        cdhpSerFlds2.oppDetails = oppDetails2;
        cdhpSerFlds2.docSignDetails = docsgn2;
        cdhpSerFlds2.grpDetails = grpDetails2;
        cdhpSerFldsList.add(cdhpSerFlds);
        cdhpSerFldsList.add(cdhpSerFlds2);
        cdhpSerFlds = CDHPServiceHandler.ProcessRequest(cdhpSerFldsList);
        
        Test.stopTest(); 
    }
    static testMethod void testMethod2(){
        List<RecordType> lstRcdType = [Select Id From RecordType Where Name =: 'Prospect' Limit 1];
        Account acc = new Account(Name = 'Test Account', RecordTypeId = lstRcdType[0].Id);
        Insert acc;
        List<RecordType> lstRcdTypeNewAcc = [Select Id From RecordType Where Name =: 'Brokerage'];
        system.debug('lstRcdTypeNewAcc---->'+lstRcdTypeNewAcc);
        Account acc1 = new Account(Name = 'Test Account', RecordTypeId = lstRcdTypeNewAcc[0].Id, Tax_Id__c='123456679',Cancel_Date__c=system.today().addDays(2));
        Insert acc1;
        Opportunity opp = new Opportunity(Name = 'Test Opp', AccountId = acc.id, StageName = 'Prospecting', CloseDate = system.today().toStartOfMonth());
        insert opp;
        Contact con = new Contact(lastname = 'Test');
        insert con;
        Contact con1 = new Contact(lastname = 'Test1');
        insert con1;
        
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        Group__c grp2=new Group__c(Account__c=acc.id,Account_Manager__c='Test');
        insert grp2;
        List<QuoteLineItem> qliListToInsert = new List<QuoteLineItem>();
        Quote q=new quote(Name='Test', OpportunityId = opp.Id, ContactId = con.id, Pricebook2Id = pricebookId, GroupNumber__c=grp2.id);
        insert q;
        System.debug('method2 q.id--->>'+q.id);
        QuoteLineItem qli1 = new QuoteLineItem(QuoteId = q.Id, Product2Id = prod.id, Quantity =1, UnitPrice=2, PricebookEntryId= standardPrice.id);
        qliListToInsert.add(qli1);
        QuoteLineItem qli2 = new QuoteLineItem(QuoteId = q.Id, Product2Id = prod.id, Quantity =1, UnitPrice=2, PricebookEntryId= standardPrice.id);
        qliListToInsert.add(qli2);
        QuoteLineItem qli3 = new QuoteLineItem(QuoteId = q.Id, Product2Id = prod.id, Quantity =1, UnitPrice=2, PricebookEntryId= standardPrice.id);
        qliListToInsert.add(qli3);
        QuoteLineItem qli4 = new QuoteLineItem(QuoteId = q.Id, Product2Id = prod.id, Quantity =1, UnitPrice=2, PricebookEntryId= standardPrice.id);
        qliListToInsert.add(qli4);
        QuoteLineItem qli5 = new QuoteLineItem(QuoteId = q.Id, Product2Id = prod.id, Quantity =1, UnitPrice=2, PricebookEntryId= standardPrice.id);
        qliListToInsert.add(qli5);
        QuoteLineItem qli6 = new QuoteLineItem(QuoteId = q.Id, Product2Id = prod.id, Quantity =1, UnitPrice=2, PricebookEntryId= standardPrice.id);
        qliListToInsert.add(qli6);
        
        insert qliListToInsert;
        ////Chandra's code
        //ContactRelationship__c cr1=new ContactRelationship__c(Contact__c=con.id,Account__c=acc.Id,IsActive__c=true,ASCS_Contract_Type__c='Test');
        //insert cr1;
        List<RecordType> lstRcdType12 = [Select Id From RecordType Where Name =: 'Consultant Contact' Limit 1];
        ContactRelationship__c contRel = new ContactRelationship__c(EndDate__c=System.today().addDays(2),RecordTypeId = lstRcdType12[0].Id,Account__c=acc1.Id,Contact__c=con1.Id,IsActive__c=true);
        insert contRel;
        Brokerage_and_Consultant__c bc1= new Brokerage_and_Consultant__c(Brokerage__c=acc1.id,Account__c=acc.id,BrokerageEndDate__c=system.today().addDays(2),Consultant__c=contRel.id,NameofBrokerage__c='Test');
        insert bc1;
        ////////////////////
        /* Required fields are missing: [PricebookEntryId, Quantity, UnitPrice, Product2Id]: [PricebookEntryId, Quantity, UnitPrice, Product2Id] */
        //33173 data
        List<HRA_Administration__c> lstHRA = new List<HRA_Administration__c>();
        HRA_Administration__c hra = new HRA_Administration__c(QLI__c=qliListToInsert[5].Id,Plan_Start_Date__c=System.today(),Plan_End_Date__c=System.today().addDays(3),HRA1_Group_Suffix__c='HRA',CapEE__c=12.00,CapEA__c=12.00,
                                                             CapEChild__c=12.00,CapEChildren__c=12.00,CapEFamily__c=12.00,AllocationEA__c=12.00,
                                                             Allocation_EChild__c=12.00,AllocationEChildren__c=12.00,AllocationEE__c=12.00,AllocationFamily__c=12.00,
                                                             Annual_Allocation_Tiers__c='2 Tier',Claim_Run_Out_Date__c=System.today().addDays(2),Debit_Card_Services__c='Medical;Dental',
                                                             Employee_Funds_Rollover_Next_Plan_Year__c='Percent',HRA_Funds_to_Employees_and_on_what_basis__c='No, Annually',
                                                             HRA_Funds_Pro_Rate_on_Entry_Date__c='Monthly',Health_Activities_Incentives__c='No',Health_Incentive_Type__c='Incentive HRA Only',Individual_Deductible_Amount__c=12.00,
                                                             If_Other_Please_Specify__c='123',Specialty__c='Dental (Debit Card);Vision (Debit Card)',Rollover_Cap_Tiers__c='2 Tier',Member_Responsibility_by_Claim__c='25%',Minimum_Rollover_Amount__c=12.00,Type_of_HRA__c='Auto-Pay Provider Only',HRA_Rollover__c='No',
                                                             Rollover_Different_Admin__c='Yes',UpfrontDedEE__c=12.00,UpFrontDedEA__c=12.00,UpfrontDedEChild__c=12.00,UpFrontDedEEChildren__c=12.00,
                                                             UpFrontDedFamily__c=12.00,Up_Front_Deductible_Tiers__c='2 Tier',HRA_Lites_Rollover__c='Yes');
        
        HRA_Administration__c hra1 = new HRA_Administration__c(QLI__c=qliListToInsert[1].Id,Plan_Start_Date__c=System.today(),Plan_End_Date__c=System.today().addDays(3),HRA1_Group_Suffix__c='HRA',CapEE__c=12.00,CapEA__c=12.00,
                                                             CapEChild__c=12.00,CapEChildren__c=12.00,CapEFamily__c=12.00,AllocationEA__c=12.00,
                                                             Allocation_EChild__c=12.00,AllocationEChildren__c=12.00,AllocationEE__c=12.00,AllocationFamily__c=12.00,
                                                             Annual_Allocation_Tiers__c='2 Tier',Claim_Run_Out_Date__c=System.today().addDays(2),Debit_Card_Services__c='Medical;Dental',
                                                             Employee_Funds_Rollover_Next_Plan_Year__c='Percent',HRA_Funds_to_Employees_and_on_what_basis__c='No, Annually',
                                                             HRA_Funds_Pro_Rate_on_Entry_Date__c='Monthly',Health_Activities_Incentives__c='No',Health_Incentive_Type__c='Incentive HRA Only',Individual_Deductible_Amount__c=12.00,
                                                             Rollover_Cap_Tiers__c='2 Tier',Member_Responsibility_by_Claim__c='25%',Minimum_Rollover_Amount__c=12.00,Type_of_HRA__c='Auto-Pay Provider Only',HRA_Rollover__c='No',
                                                             Covered_Services__c='Auto Pay Medical;	In Network Medical Deductible',HRA_Upfront_Deductible__c='Yes',Medical__c='Provider Pay;Member Pay (Debit Card)');
   
        
        lstHRA.add(hra);
        lstHRA.add(hra1);
        insert lstHRA;
        //
        CDHPService.CDHPFields cdhpSerFlds = new CDHPService.CDHPFields();
        CDHPService.StatusDetails StatusDetails1 =new CDHPService.StatusDetails();
        StatusDetails1.Status = 'Alegeus Completed';
        StatusDetails1.StatusMessage = 'Test';
        StatusDetails1.QuoteId = q.id;
        cdhpSerFlds.StatusDetails = StatusDetails1;
        
        
        /*
public CDHParDetails CDHPar{ get; set; }
public List<CDHPCommuterAccount> CDHPCommuterList{ get; set; }
public List<CDHPHSAAccount> CDHPHSAList { get; set; }
public List<CDHPFSAAccount> CDHPFSAList{ get; set; }
public List<CDHPHRARepeatingAccount> CDHPHRAList{ get; set; }
*/
        List<CDHPService.CDHPHRARepeatingAccount> CDHPHraList1 = new List<CDHPService.CDHPHRARepeatingAccount>();
        CDHPService.CDHPHRARepeatingAccount CDHPHra = new CDHPService.CDHPHRARepeatingAccount();
        CDHPHra.SF_Quote_Item_Id = qli6.id;
        CDHPHra.HRA_Embedded_Ded = true;
        CDHPHra.HRA_Plan_Start_Date = date.newInstance(2098, 12, 1);
        CDHPHra.HRA_Plan_End_Date = date.newInstance(2099, 12, 1);
        CDHPHra.HRA_Debit_Card_Dental_Services = true;
        CDHPHra.HRA_Debit_Card_Medical_Services = true;
        CDHPHra.HRA_Debit_Card_OTC_Services = true;
        CDHPHra.HRA_Debit_Card_Rx_Services = true;
        CDHPHra.HRA_Debit_Card_Vision_Services = true;
        CDHPHra.HRA_Employee_Funds_Rollover_Amounts = '132';
        CDHPHra.HRA_Health_Activities = 'Yes';
        CDHPHra.HRA_Prov_Pay_Med_w_Opt_Rx_Den_Vis_Deb_Cd = true;
        CDHPHra.HRA_ProvPay_Opt_DebCd_Dental_Option = true;
        CDHPHra.HRA_ProvPay_Opt_DebCd_Vision_Option = true;
        CDHPHra.HRA_ProvPay_Opt_DebCd_INN_Med_Coins = true;
        CDHPHra.HRA_ProvPay_Opt_DebCd_INN_Med_Copay = true;
        CDHPHra.HRA_ProvPay_Opt_DebCd_INN_Med_Ded = true;
        CDHPHra.HRA_ProvPay_Opt_DebCd_ONN_Med_Coins = true;
        CDHPHra.HRA_ProvPay_Opt_DebCd_ONN_Med_Copay = true;
        CDHPHra.HRA_ProvPay_Opt_DebCd_ONN_Med_Ded = true;
        CDHPHra.HRA_ProvPay_Opt_DebCd_Rx_Option = true;
        CDHPHra.HRA_ProvPay_Opt_DebCd_Medical = true;
        CDHPHra.Member_Pay_HRA_with_Debit_Card = true;
        CDHPHra.HRA_Terminated_Employees_Other_Value = '21';
        CDHPHra.Provider_Pay_Split_HRA = true;
		CDHPHra.HRA_Rollover_Offer = 'Yes';
        CDHPHraList1.add(CDHPHra);
        cdhpSerFlds.CDHPHRAList=CDHPHraList1;
        CDHPService.CDHPFSAAccount CDHPFSA = new CDHPService.CDHPFSAAccount();
        CDHPFSA.SF_Quote_Item_Id = qli3.id;
        CDHPFSA.FSA_Section_213_d_Plan = true;
        CDHPFSA.Limited_Purpose_FSA_Plan = true;
        CDHPFSA.Dependent_Care_FSA_Plan = true;
        List<CDHPService.CDHPFSAAccount> CDHPfsalst = new List<CDHPService.CDHPFSAAccount>();
        
        CDHPService.CDHPFSAAccount CDHPFSA1 = new CDHPService.CDHPFSAAccount();
        CDHPFSA1.SF_Quote_Item_Id = qli4.id;
        CDHPFSA1.FSA_Section_213_d_Plan = false;
        CDHPFSA1.Limited_Purpose_FSA_Plan = true;
        CDHPFSA1.Dependent_Care_FSA_Plan = true;  
        //List<CDHPService.CDHPFSAAccount> CDHPfsalst = new List<CDHPService.CDHPFSAAccount>();
        
        CDHPService.CDHPFSAAccount CDHPFSA2 = new CDHPService.CDHPFSAAccount();
        CDHPFSA2.SF_Quote_Item_Id = qli5.id;
        CDHPFSA2.FSA_Section_213_d_Plan = false;
        CDHPFSA2.Limited_Purpose_FSA_Plan = false;
        CDHPFSA2.Dependent_Care_FSA_Plan = true;  
        //List<CDHPService.CDHPFSAAccount> CDHPfsalst = new List<CDHPService.CDHPFSAAccount>();
        
        
        CDHPfsalst.add(CDHPFSA);
        CDHPfsalst.add(CDHPFSA1);
        CDHPfsalst.add(CDHPFSA2);
        cdhpSerFlds.CDHPFSAList = CDHPfsalst;
        
            
        CDHPService.CDHParDetails CDHPar1 = new CDHPService.CDHParDetails();
        CDHPar1.EmployerName = 'Test';
        CDHPar1.TaxId = 'Te123';
        CDHPar1.Employer_Contact_Name_1='M D K';
        CDHPar1.Employer_Contact_Phone_1 = '1235468790';
        CDHPar1.Employer_Contact_Email_1 = 'test@mail.com';
        CDHPar1.Member_Pay_HRA_with_Debit_Card = true;
        CDHPar1.Provider_Pay_Split_HRA = true;
        CDHPar1.Effective_Date = date.newInstance(2099, 12, 1);
        CDHPar1.HRA_Provider_Pay = true;
        CDHPar1.Prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay = true;
        CDHPar1.HRA_Rollover = true;
        
        //cdhpSerFlds.CDHPar= CDHPar1;
         List<CDHPService.CDHParDetails> lstpar1 = new List<CDHPService.CDHParDetails>();
        lstpar1.add(CDHPar1);
        cdhpSerFlds.CDHPar= CDHPar1;
        
        CDHPService.CDHPCommuterAccount comm1 = new CDHPService.CDHPCommuterAccount();
        comm1.Transit_Plan_Option = true;
        comm1.Parking_Plan_Option = true;
        comm1.SF_Quote_Item_Id = qli1.id;
        List<CDHPService.CDHPCommuterAccount> commList = new List<CDHPService.CDHPCommuterAccount>();
        commList.add(comm1);
        cdhpSerFlds.CDHPCommuterList = commList;
        
        
        CDHPService.CDHPHSAAccount hsa = new CDHPService.CDHPHSAAccount();
        hsa.HSA_Custodian='Test';
        hsa.SF_Quote_Item_Id = qli2.Id;
        
        List<CDHPService.CDHPHSAAccount> hsaList= new List<CDHPService.CDHPHSAAccount>();
        hsaList.add(hsa);
        cdhpSerFlds.CDHPHSAList = hsaList;
        
        /*
        testDataFactoryCDHP.createAccount();
        testDataFactoryCDHP.createOpp();
        testDataFactoryCDHP.createQuote();
        testDataFactoryCDHP.createProducts();
        testDataFactoryCDHP.createQuoteLineItem();
        StatusDetails1.QuoteId = testDataFactoryCDHP.lstQLItem[0].id;
        cdhpSerFlds2.StatusDetails = StatusDetails1;       
        testDataFactoryCDHP.createHRA();
        */
        //
        CDHPService.OpportunityDetails oppDetails1 = new CDHPService.OpportunityDetails();
        oppDetails1.SFORGOpportunityId = opp.Id; 
        oppDetails1.OptyName = 'Test Opportunity';
        oppDetails1.OptyEffectiveDate = System.today().toStartOfWeek() ;
        oppDetails1.OptyRecordType = 'New Business';
        oppDetails1.StageName = 'Prospecting';
        cdhpSerFlds.oppDetails = oppDetails1;
        
        
        List<CDHPService.CDHPFields> cdhpSerFldsList = new List<CDHPService.CDHPFields>();
        cdhpSerFldsList.add(cdhpSerFlds);
        //cdhpSerFldsList.add(cdhpSerFlds2);
        
        CDHPServiceHandler.BackSynch(cdhpSerFldsList);
        
        
    }
}