@isTest
private class ActWiseNONBControllerTest {
    
    static testMethod void myUnitTest(){
        
		List<QuoteLineItem> lstQli = new List<QuoteLineItem>();
        List<AccountTeamMember> lstAtm = new List<AccountTeamMember>();
        
        Test.startTest();
                       
        Id pricebookId = Test.getStandardPricebookId();
        
        Account acc=ANA_UTIL01_TestMethods.createAccount(false);    
        Database.insert(acc);
        
        Opportunity opp=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
        opp.StageName = 'Renewal Finalized';
        opp.Pricebook2Id=pricebookId;
        opp.Is_Renewed__c = true;   
        
        Database.insert(opp);
        
        Quote quote = new Quote();
        quote.Name = 'Test Quote 1';
        quote.OpportunityId = opp.Id;
        quote.Pricebook2Id = opp.Pricebook2Id;
        quote.CDHP_SF_Id_From_ISG__c = '123';
        Database.insert(quote); 
        
        PageReference pageRef = Page.ActWiseNONB;
        pageRef.getParameters().put('id', String.valueOf(quote.Id));
        Test.setCurrentPage(pageRef);        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quote);
        //ActWiseNONBController actWiseNONB = new ActWiseNONBController(sc);
        ActWiseNONBController myController = new ActWiseNONBController(sc);
        
        //create a product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true,
            QLIRecordType__c = 'ActWise'       
        );
        insert prod; 
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id =  pricebookId ,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        //create quote line items
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli.ProductStage__c='Sold';
        qli.PLComplete__c =true;
        qli.PricebookEntryId=pbEntry.Id;
        qli.Quantity =1; 
        qli.UnitPrice=1000;
        qli.RecordType__c = 'Anthem Blue Access PPO HSA';
        qli.IsthisRenewalOpportunityCloned__c = false;
        qli.Is_New_Business__c = true;
        
        
        lstQli.add(qli);
        insert lstQli;
        system.assert(myController.getProducts() == null);
                
        QuoteLineItem qli1 = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli1.ProductStage__c='Sold';
        qli1.PLComplete__c =true;
        qli1.PricebookEntryId=pbEntry.Id;
        qli1.Quantity =1; 
        qli1.UnitPrice=1000;
        qli1.RecordType__c = 'ActWise HSA';
        qli1.Is_Existing_Product__c = false; 
        qli1.Is_New_Business__c = true;   
        qli.IsthisRenewalOpportunityCloned__c = false;
        lstQli.add(qli1);//insert qli
        
        QuoteLineItem qli2 = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli2.ProductStage__c='Sold';
        qli2.PLComplete__c =true;
        qli2.PricebookEntryId=pbEntry.Id;
        qli2.Quantity =1; 
        qli2.UnitPrice=1000;
        qli2.RecordType__c = 'ActWise HRA';
        lstQli.add(qli2);//insert qli
        
    	QuoteLineItem qli3 = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli3.ProductStage__c='Sold';
        qli3.PLComplete__c =true;
        qli3.PricebookEntryId=pbEntry.Id;
        qli3.Quantity =1; 
        qli3.UnitPrice=1000;
        qli3.RecordType__c = 'ActWise FSA';
        lstQli.add(qli3);//insert qli
        
    	QuoteLineItem qli4 = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli4.ProductStage__c='Sold';
        qli4.PLComplete__c =true;
        qli4.PricebookEntryId=pbEntry.Id;
        qli4.Quantity =1; 
        qli4.UnitPrice=1000;
        qli.RecordType__c = 'ActWise Commuter';
        lstQli.add(qli4);//insert qli
        
        QuoteLineItem qli5 = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli5.ProductStage__c='Sold';
        qli5.PLComplete__c =true;
        qli5.PricebookEntryId=pbEntry.Id;
        qli5.Quantity =1; 
        qli5.UnitPrice=1000;
        qli5.RecordType__c = 'Benefits Admin: ActWise FSA';
        qli5.FSA_Plan_Options__c = 'Dependent Care FSA Plan';
        lstQli.add(qli5);//insert qli
        
        QuoteLineItem qli6 = new QuoteLineItem(QuoteId = quote.Id,Product2Id = prod.Id);    
        qli6.ProductStage__c='Sold';
        qli6.PLComplete__c =true;
        qli6.PricebookEntryId=pbEntry.Id;
        qli6.Quantity =1; 
        qli6.UnitPrice=1000;
        qli6.RecordType__c = 'ActWise FSA';
        qli6.FSA_Plan_Options__c = 'Dependent Care FSA Plan;FSA Section 213d Plan;Limited Purpose FSA Plan';
        lstQli.add(qli6);//insert qli
        
        database.upsert(lstQli); 
        
        //create user for account team member
        Profile p = [Select Id from Profile where Name='System Administrator' limit 1]; 
    	User u = new User(	Alias = 'sysadmin', 
							Email='mytestuser1@testorg.com', 
        					EmailEncodingKey='UTF-8', 	
							LastName='Testing', 
							LanguageLocaleKey='en_US', 
        					LocaleSidKey='en_US', 	
							ProfileId = p.Id, 
        					TimeZoneSidKey='America/Los_Angeles', 
							UserName='mytestuser1@testorg.com');
        
        insert u;
                
        //create account team member
        AccountTeamMember atm = new AccountTeamMember(AccountId=acc.Id, UserId = u.Id, 
                                                      AccountAccessLevel = 'Read', ContactAccessLevel = 'Read', 
                                                      OpportunityAccessLevel = 'Read', CaseAccessLevel = 'Read',
                                                      TeamMemberRole = 'Sales Support Specialist');
        lstAtm.add(atm);
        
        insert lstAtm;
        system.assert(myController.getMembers().size() == 0);
        
        AccountTeamMember atm1 = new AccountTeamMember(AccountId=acc.Id, UserId = u.Id, 
                                                      AccountAccessLevel = 'Read', ContactAccessLevel = 'Read', 
                                                      OpportunityAccessLevel = 'Read', CaseAccessLevel = 'Read',
                                                      TeamMemberRole = 'Account Executive');
        lstAtm.add(atm1);
        
        AccountTeamMember atm2 = new AccountTeamMember(AccountId=acc.Id, UserId = u.Id, 
                                                      AccountAccessLevel = 'Read', ContactAccessLevel = 'Read', 
                                                      OpportunityAccessLevel = 'Read', CaseAccessLevel = 'Read',
                                                      TeamMemberRole = 'Sales Account Rep - Acct Mgmt');
        lstAtm.add(atm2);
        
        AccountTeamMember atm3 = new AccountTeamMember(AccountId=acc.Id, UserId = u.Id, 
                                                      AccountAccessLevel = 'Read', ContactAccessLevel = 'Read', 
                                                      OpportunityAccessLevel = 'Read', CaseAccessLevel = 'Read',
                                                      TeamMemberRole = 'Account Manager');
        lstAtm.add(atm3);
        
        upsert lstAtm;        
        
        system.assert(myController != null);	
        system.assert(quote != null);
        system.assert(myController.getProducts().size() !=0);    
                
        if(myController.getMembers() !=null) {
            for (AccountTeamMember member : myController.getMembers()) {
                if(member.TeamMemberRole == 'Account Manager' || 
                   member.TeamMemberRole == 'Account Executive' ||
                   member.TeamMemberRole == 'Sales Account Rep - Acct Mgmt') {
                       
                   system.assert(true);   	  
                }
                else {
                    system.assert(false);
                }
            }
        }
        
        if(myController.getProducts().size()>0) {
            
            for (QuoteLineItem item : myController.getProducts()) {
                if (item.RecordType__c.contains('ActWise HRA')) {
                    system.assert(myController.isHRA);
                }
                if (item.RecordType__c.contains('ActWise HSA')) {
                    system.assert(myController.isHSA);
                }
                if (item.RecordType__c.contains('ActWise Commuter')) {
                    system.assert(myController.isCommuter);
                }
                if (item.RecordType__c.contains('ActWise FSA') /*|| item.RecordType__c == 'Benefits Admin: ActWise FSA'*/) {
                    system.assert(myController.isFSA);
                    if (item.FSA_Plan_Options__c != null) {
                                     
                    	if (item.FSA_Plan_Options__c.contains('Dependent Care FSA Plan')) {
                    		system.assert(myController.isDCFSA);                      
                        }
                    	if (item.FSA_Plan_Options__c.contains('FSA Section 213d Plan')) {
                    		 system.assert(myController.isFSA);
                   		} 
                    	if (item.FSA_Plan_Options__c.contains('Limited Purpose FSA Plan')) {
                    		system.assert(myController.isLPFSA);
                    	}    
                	}
            	}
        	}
        }
        
                
        Test.stopTest();
    }    
}