/*
Comment added by Vedha
Class : LGCreateRenewalOpportunityBatchTest
*/  
@isTest
private class LGCreateRenewalOpportunityBatchTest extends staticVariableClass 
{
    static testMethod void testMethodBatchRenewal() {
        Test.startTest();
        SIC__c sicIns = new SIC__c(name = staticVariableClass.SIC);
        insert sicIns;
        
        //New Account
        Account acc =new Account(
            RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
            Name = staticVariableClass.AccountName,
            Account_s_Suppress_Auto_Renewal__c = false,
            Anthem_Entity__c = staticVariableClass.Entity,
            Region__c= staticVariableClass.Region,
            Branding__c =staticVariableClass.UniCare,
            SIC__c = sicIns.Id,
            Group_Size__c =staticVariableClass.size,
            Total_Employees__c =staticVariableClass.emp,
            HQ_State__c =staticVariableClass.AK,
            Situs_State__c = staticVariableClass.California,
            Mailing_Address_Same_as_Physical_Address__c = true,
            BillingStreet = 'Land Mark',
            BillingPostalCode = '636111',
            BillingCity = 'Banglore',
            BillingCountry = 'India',
            BillingState = 'Karnataka',
            Physical_County__c = 'Banglore'
        );
        insert acc;
        
        List<Opportunity> lstOpp= new List<Opportunity>();
        
        Opportunity newOpp = new Opportunity(
            name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name),
            StageName = staticVariableClass.ClosedWon,
            AccountID = acc.id,
            CloseDate = ((system.TODAY())-95),                   
            recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId()                                    
        );
        
        insert newOpp;
        
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        Database.insert(grp);
        
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,newOpp.Id);
        qte.GroupNumber__c=grp.id;
        Database.insert(qte);
        
        AccountTeamMember accTeam= new AccountTeamMember(
            UserId = UserInfo.getUserId(),
            AccountID = acc.Id,
            TeamMemberRole = staticVariableClass.TeamMemberRole           
        );
        insert accTeam;
        
        Brokerage_and_Consultant1__c brokerInstance = new Brokerage_and_Consultant1__c(Opportunity__c = newOpp.Id);
        insert brokerInstance;
        
        //Added by Ranjith -- start 
        Pharmacy_Upsell_Details__c pud=new Pharmacy_Upsell_Details__c();
        pud.Account__c=acc.id;
        pud.Opportunity__c=newOpp.id;
        pud.Coverage_Code__c='codde567';
        pud.BPL__c='345676g';
        pud.Name='testname';
        insert pud;
        //Added by Ranjith -- End
 
        Product2 prod=ANA_UTIL01_TestMethods.createProduct(false);
        prod.name='Anthem Health Guide';
        Database.insert(prod);
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
        Database.insert(pbe);
        
        list<QuoteLineItem> qliList = new list<QuoteLineItem>();
        
        QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.Id, pbe.id);
        qli.Quantity =  123.0;
        qli.UnitPrice =12.0;
        qli.Product_Term_Years_Left__c ='5';
        qli.Discount_sharing__c = staticVariableClass.SoldRenewed;
        qli.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
        qli.ProductStage__c= staticVariableClass.Sold;       
        Database.insert(qli);
        
        QuoteLineItem qli1 = new QuoteLineItem(RecordType__c = 'ActWise HSA',Product2Id = prod.Id, QuoteId = qte.id ,Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = pbe.Id, 
                                               ProductStage__c = 'IGAP Sold',PLComplete__c=true,ParentQuoteLineItem__c=qli.id);
        
        //Added by Ranjith -- start
         HRA_Administration__c hraRec = new HRA_Administration__c();
         hraRec.Plan_Start_Date__c = Date.Today().addDays(1);
         hraRec.Plan_End_Date__c = Date.Today().addYears(1);
         hraRec.Claim_Run_Out_Date__c = Date.Today().addYears(1);
         hraRec.QLI__c =qli.id;
         insert hraRec;
        //Added by Ranjith -- End
        
        LG_Riders__c riderInstance = new LG_Riders__c();
        riderInstance.PORTFOLIO_YEAR__c = '2020';
        riderInstance.Effective_Date__c = Date.Today().addDays(1);
        riderInstance.End_Date__c = Date.Today().addYears(1);
        riderInstance.FundingValue__c = 'ASO-FI';
        riderInstance.GROUP_SIZE__c = 100;
        riderInstance.SEGMENT__c = 'LG';
        riderInstance.STATE__c = 'CA';
        riderInstance.VARIATION_NAME__c = 'Special Footwear/Hearing Aids (CA)';
        
        insert riderInstance;
        
        list<ProductSelectionDetail__c> prodSelList = new list<ProductSelectionDetail__c>();
        
        ProductSelectionDetail__c prodSel = new ProductSelectionDetail__c();
        prodSel.QuoteLineItem__c = qli.id;
        prodSel.Rider__c = riderInstance.Id;
        prodSel.LG_IsActiveRider__c = true;
        prodSel.Parent_QLI_Id__c = String.valueOf(qli.id);
        prodSelList.add(prodSel);
        
        insert prodSelList;
        
        Plan_Relationship__c plan = new Plan_Relationship__c();
        plan.Qli1__c=qli.Id;
        plan.Qli2__c =qli.id;
        insert plan;
        
        system.assertEquals(1, prodSelList.size(), staticVariableClass.assertEquals);
        
        //Test.startTest();
        LGCreateRenewalOpportunityBatch obj = new LGCreateRenewalOpportunityBatch();
        DataBase.executeBatch(obj,1); 
        Test.stopTest();
    }
}