@IsTest public with sharing class BMSQuotingServiceSalesForceTest {
    
    @IsTest
    public static void testBMSQuotingServiceSalesForce() {
        User u = TestDataFactory.createUserData(1, 'System Administrator', '000000000')[0];
        insert u;
        
        System.runAs(u) {
            Account acc = TestDataFactory.createAccountSICList(1, 'Test Account', '1234 S. Address St.', 'Phoenix', 'AZ', '55555', 'United States', 'AZ')[0];
            acc.CHIPS_Account_Code__c = '12345';
            insert acc;
            
            Opportunity oppty = TestDataFactory.createOpportunityList(1, 'Test Opportunity',acc)[0];
            insert oppty;
            
            Product2 prod = TestDataFactory.createProduct('KEYCARE 500 (15/50/85/20%) CY',1)[0];
            //prod.Underwriting_Product_Code__c = 'KEYCARE 30 (15/40/75 OR 20%)';
            prod.Underwriting_Product_Code__c = 'KEYCARE 500 (15/50/85/20%) CY';
            
            insert prod;  
            
            OpportunityTeamMember OTM = TestDataFactory.createOpportunityTeam(1,oppty)[0];
            insert OTM;
            
            BMSQuotingServiceSalesForceTest bmsServTest = new BMSQuotingServiceSalesForceTest();
            bmsServTest.getQuotingRequest('SUCCESS');
            bmsServTest.getQuotingRequest('AGENT_NOT_FOUND');
            bmsServTest.getQuotingRequest('PROD_NOT_FOUND');
            bmsServTest.getQuotingRequest('ACCOUNT_NOT_FOUND');   
            bmsServTest.getQuotingRequest('ACCOUNT_EMPTY');
            bmsServTest.getQuotingRequest('REP_EMPTY');
            bmsServTest.getQuotingRequest('EXCEPTION');
        }
    }  
    public void getQuotingRequest(String testType){
        BMSQuotingServiceSalesForce.SendQuoteReq SendQuoteReq = new BMSQuotingServiceSalesForce.SendQuoteReq();
        BMSQuotingServiceSalesForce.GroupDetails GroupDetails = new BMSQuotingServiceSalesForce.GroupDetails();
        BMSQuotingServiceSalesForce.User User = new BMSQuotingServiceSalesForce.User();
        BMSQuotingServiceSalesForce.Dental Dental = new BMSQuotingServiceSalesForce.Dental();
        BMSQuotingServiceSalesForce.DentalProduct DentalProduct = new BMSQuotingServiceSalesForce.DentalProduct();
        BMSQuotingServiceSalesForce.DentalRating DentalRating = new BMSQuotingServiceSalesForce.DentalRating();
        BMSQuotingServiceSalesForce.BenefitRider[] BenefitRider = new BMSQuotingServiceSalesForce.BenefitRider[1];
        BMSQuotingServiceSalesForce.Option Option = new BMSQuotingServiceSalesForce.Option();
        BMSQuotingServiceSalesForce.FormulaRates FormulaRates = new BMSQuotingServiceSalesForce.FormulaRates();
        BMSQuotingServiceSalesForce.ZipInfo ZipInfo = new BMSQuotingServiceSalesForce.ZipInfo();
        BMSQuotingServiceSalesForce.MedicalFactors MedicalFactors = new BMSQuotingServiceSalesForce.MedicalFactors();
        BMSQuotingServiceSalesForce.SalesReps[] SalesReps = new  BMSQuotingServiceSalesForce.SalesReps[1];
        BMSQuotingServiceSalesForce.Members Members = new  BMSQuotingServiceSalesForce.Members();
        BMSQuotingServiceSalesForce.Brokers[] Brokers = new  BMSQuotingServiceSalesForce.Brokers[1];
        BMSQuotingServiceSalesForce.Benefits[] Benefits = new  BMSQuotingServiceSalesForce.Benefits[1];
        BMSQuotingServiceSalesForce.Presets Presets = new BMSQuotingServiceSalesForce.Presets();
        BMSQuotingServiceSalesForce.Rate[] Rates = new  BMSQuotingServiceSalesForce.Rate[6];
        BMSQuotingServiceSalesForce.Medical Medical = new BMSQuotingServiceSalesForce.Medical();
        BMSQuotingServiceSalesForce.Edition Edition = new BMSQuotingServiceSalesForce.Edition();
        BMSQuotingServiceSalesForce.MedicalProduct MedicalProduct = new BMSQuotingServiceSalesForce.MedicalProduct();
        BMSQuotingServiceSalesForce.Adjustment[] Adjustment = new BMSQuotingServiceSalesForce.Adjustment[1];
        BMSQuotingServiceSalesForce.SendQuoteResp sendResp = new BMSQuotingServiceSalesForce.SendQuoteResp();
        SalesReps[0] = new BMSQuotingServiceSalesForce.SalesReps();
        Brokers[0] = new BMSQuotingServiceSalesForce.Brokers();
        Benefits[0] = new BMSQuotingServiceSalesForce.Benefits();
        Rates[0] = new BMSQuotingServiceSalesForce.Rate();    
        Rates[1] = new BMSQuotingServiceSalesForce.Rate();
        Rates[2] = new BMSQuotingServiceSalesForce.Rate();
        Rates[3] = new BMSQuotingServiceSalesForce.Rate();
        Rates[4] = new BMSQuotingServiceSalesForce.Rate();
        Rates[5] = new BMSQuotingServiceSalesForce.Rate();
                    
        Brokers[0] = new BMSQuotingServiceSalesForce.Brokers();
        Adjustment[0] = new BMSQuotingServiceSalesForce.Adjustment();
        BenefitRider[0] = new BMSQuotingServiceSalesForce.BenefitRider();

        
        SendQuoteReq.User =  User;
        User.GroupDetails=GroupDetails;
        GroupDetails.Presets = Presets;
        GroupDetails.Benefits = Benefits;
        GroupDetails.Brokers = Brokers;
        GroupDetails.Members = Members;
        GroupDetails.SalesReps = SalesReps;       
        Rates[0].ageMin='33';
        Rates[0].ageMax='33';
        Rates[0].sex='M';
        Rates[0].coverage='S';
        Rates[0].rate='2030.00';       
        Rates[1].coverage='C';
        Rates[1].rate='2030.00';  
        Rates[2].coverage='D';
        Rates[2].rate='2030.00';  
        Rates[3].coverage='F';
        Rates[3].rate='2030.00';  
        Rates[4].coverage='K';
        Rates[4].rate='2030.00';  
        Rates[5].coverage='T';
        Rates[5].rate='2030.00';   
        Benefits[0].Rates = Rates;        
        Medical.Edition = Edition;
        Edition.MedicalProduct = MedicalProduct;
        MedicalProduct.description='525';
        MedicalProduct.selected='1';
        MedicalProduct.abbreviation='PPO';
        MedicalProduct.ratePlan='';
        MedicalProduct.Option = Option; 
        Benefits[0].Medical = Medical;       
        Benefits[0].type_x='Text';
        Benefits[0].allProduct='Text';
        Benefits[0].selected='Text';
        Benefits[0].stdess='Text';
        Benefits[0].amebaRating='Text';
        
        SalesReps[0].SalesRepID='ac00123';
        SalesReps[0].SalesRepName='Broker';
        Brokers[0].brokerID='ADSDS';
        Brokers[0].address1 = '';
        Brokers[0].city = '';
        Brokers[0].eMail='A394020200';
        Brokers[0].faxNumber = '';
        Brokers[0].brokerName = '';
        Brokers[0].phone = '';
        Brokers[0].state = '';
        Brokers[0].zip = '';     
        Members.retireeLives='0.0';
        Members.femaleEmpCovLives='0.0';
        Members.maleEmpCovLives='0.0';
        Members.femaleFamilyCovLives='0.0';
        Members.maleChildCovLives='0.0';
        Members.healthLives='20';
        Members.activeLives='20';
        Members.femaleChildCovLives='0';
        Members.maleSpouseCovLives='0.0';
        Members.maleFamilyCovLives='20';
        Members.cobraLives='20';
        Members.femaleSpouseCovLives='20';
        Members.totalLives='20';
        Members.totalMembership='20';
        Members.totalMembershipDental='0.0';
        Members.totalMembershipVision='0.0';
        Members.femaleEmpCovLivesDental='0.0';
        Members.maleEmpCovLivesDental='0.0';
        Members.femaleFamilyCovLivesDental='0.0';
        Members.maleChildCovLivesDental='0.0';
        Members.femaleChildCovLivesDental='0.0';
        Members.maleSpouseCovLivesDental='0.0';
        Members.maleFamilyCovLivesDental='0.0';
        Members.femaleSpouseCovLivesDental='0.0';
        Members.averageHealthAge='0.0';
        Members.averageDentalAge='0.0';
        Members.averageVisionAge='0.0';
        Members.censusType='0.0';
        Members.dentalLives='0.0';
        Members.employeeContractCount='20';
        Members.employeeChildContractCount='20';
        Members.employeeSpouseContractCount='20';
        Members.familyContractCount='20';
        Members.employeeContractDentalCount='0.0';
        Members.employeeSpouseContractDentalCount='0.0';
        Members.employeeChildContractDentalCount='0.0';
        Members.familyContractDentalCount='0.0';
        Members.familyChildrenContractDentalCount='0.0';
        Members.employeeChildrenContractCount='0.0';
        Members.dentalOutOfStateLives='0.0';
        Members.marketSegment='0.0';
        Members.employeeChildrenContractDentalCount='0.0';
        Members.dentalCensusType='0.0';
        GroupDetails.name='Text';
        GroupDetails.address='Text';
        GroupDetails.assocID='Text';
        GroupDetails.pid='Text';
        GroupDetails.parentPid='Text';
        GroupDetails.firstYearDental='Text';
        GroupDetails.vaGroupNumber='Text';        
        GroupDetails.city='Text';
        GroupDetails.state='Text';
        GroupDetails.countyCode='Text';
        GroupDetails.zip='Text';
        GroupDetails.groupContact='Text';
        GroupDetails.groupMarket='Text';
        GroupDetails.rateAs='Text';
        GroupDetails.sicCode='Text';
        GroupDetails.eMailAddress='Text';
        GroupDetails.wgsCaseNumber='Text'; 
        Adjustment[0].product = 'health';
        Adjustment[0].type_x = 'tentativeCMF';
        Adjustment[0].factor='2';
        GroupDetails.Presets = Presets;
        Presets.Adjustment = Adjustment;            
        ZipInfo.state = 'NY';
        GroupDetails.ZipInfo = ZipInfo;
        FormulaRates.premium = '1000';
        Dental.DentalProduct = DentalProduct;
        BenefitRider[0].description = 'Desc';
        BenefitRider[0].selected = 'Desc';
        BenefitRider[0].rate = 'Desc';
        BenefitRider[0].planType = 'Desc';
        BenefitRider[0].riderCode = 'Desc';
        Option.BenefitRider = BenefitRider;
        Option.selected='Desc';
        Option.pcpVisit='Desc';
        Option.specialistVisit='Desc';
        Option.inpatientCoins='Desc';
        Option.inpatientCopay='Desc';
        Option.outpatientCoins='Desc';
        Option.annualOOP='Desc';
        Option.hraAllocation='Desc';
        Option.rewards='Desc';
        Option.pharmacy='Desc'; 
        Option.outpatientCopay='Desc';
        MedicalFactors.FormulaRates = FormulaRates;
        Benefits[0].MedicalFactors = MedicalFactors;
        DentalRating.TotalMonthlyPremiumValue = '1.0';
        Benefits[0].DentalRating = DentalRating;
        Benefits[0].Dental = Dental;
        if(testType =='SUCCESS'){
            //Option.benefitCode='KC10RX1'; 
            option.benefitCode='KC500RX12CY';      
            //Option.description='KEYCARE 30 (15/40/75 OR 20%)';
             Option.description='KEYCARE 500 (15/50/85/20%) CY';
            SalesReps[0].SalesRep='000000000';
            GroupDetails.effectiveDate='2015-10-10';
            GroupDetails.accountCode='12345';
            sendResp = BMSQuotingServiceSalesForce.SendQuote(SendQuoteReq);  
            System.debug('sendResp - '+sendResp);
        }
        else
        if(testType =='AGENT_NOT_FOUND'){
            //Option.benefitCode='KC10RX1';       
            //Option.description='KEYCARE 10 (10/20/35/20%) CY';
            Option.benefitCode='KC500RX12CY';     
            
            Option.description='KEYCARE 500 (15/50/85/20%) CY';
            SalesReps[0].SalesRep='AB';
            GroupDetails.effectiveDate='2015-10-10';
            GroupDetails.accountCode='B5KDG';
            sendResp = BMSQuotingServiceSalesForce.SendQuote(SendQuoteReq);  
            System.debug('sendResp - '+sendResp);
        }else
        if(testType =='PROD_NOT_FOUND'){
            //Option.benefitCode='ASD10RX1';   
            Option.benefitCode='KC500RX12CY';     
            //Option.description='ASDKEYCARE 10 (10/20/35/20%) CY';
            Option.description='KEYCARE 500 (15/50/85/20%) CY';
            SalesReps[0].SalesRep='21';
            GroupDetails.effectiveDate='2015-10-10';
            GroupDetails.accountCode='B5KDG';
            sendResp = BMSQuotingServiceSalesForce.SendQuote(SendQuoteReq);  
            System.debug('sendResp - '+sendResp);
        }else
            if(testType =='ACCOUNT_NOT_FOUND'){
            //Option.benefitCode='KC10RX1';       
            //Option.description='KEYCARE 10 (10/20/35/20%) CY';
            Option.benefitCode='KC500RX12CY';     
            
            Option.description='KEYCARE 500 (15/50/85/20%) CY';
            SalesReps[0].SalesRep='21';
            GroupDetails.effectiveDate='2015-10-10';
            GroupDetails.accountCode='B5KDGAS';
            sendResp = BMSQuotingServiceSalesForce.SendQuote(SendQuoteReq);  
            System.debug('sendResp - '+sendResp);
        }else
            if(testType =='ACCOUNT_EMPTY'){
            //Option.benefitCode='KC10RX1';       
            //Option.description='KEYCARE 10 (10/20/35/20%) CY';
            Option.benefitCode='KC500RX12CY';     
            
            Option.description='KEYCARE 500 (15/50/85/20%) CY';
            SalesReps[0].SalesRep='21';
            GroupDetails.effectiveDate='2015-10-10';
            sendResp = BMSQuotingServiceSalesForce.SendQuote(SendQuoteReq);  
            System.debug('sendResp - '+sendResp);
        }else
            if(testType =='REP_EMPTY'){
            //Option.benefitCode='KC10RX1';       
            //Option.description='KEYCARE 10 (10/20/35/20%) CY';
            Option.benefitCode='KC500RX12CY';     
            
            Option.description='KEYCARE 500 (15/50/85/20%) CY';
            GroupDetails.effectiveDate='2015-10-10';
            GroupDetails.accountCode='B5KDG';
            sendResp = BMSQuotingServiceSalesForce.SendQuote(SendQuoteReq);  
            System.debug('sendResp - '+sendResp);
        }                            
    } 
    /*
        @IsTest
    public static void testdeleteQuote() {
        List<Opportunity> opps;
       List<Quote> q;
       List<Account> accs;
       
       accs = TestDataFactory.createAccountSICList(1, 'Test Account', '1234 S. Address St.', 'Phoenix', 'AZ', '55555', 'United States', 'AZ');
      
        insert accs;
        
        opps = TestDataFactory.createOpportunityList(1, 'Test Opportunity',accs[0]);
        insert opps;
        
            q= TestDataFactory.Quote('Test Opportunity',1,opps[0]);
        insert q; 
        BMSQuotingServiceSalesForceSupporting b=new BMSQuotingServiceSalesForceSupporting();
        b.deleteQuoteandQuoteLineItems(string.valueof(opps[0].id));
    }*/
}