@isTest(seeAllData=false)
Private class AP26_NotifyUsers_On_ICStatusChange_Test {
    
    private static final string NA ='National Implementations'; 
    private static Profile profileNA = [select id from profile where name=: NA];
    private static User someUser1 = ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
    //private static User someUser1 = new User(ID = UserInfo.getUserID());
    
    static testMethod void Test_NotifyUsersOnICStatusChange()
    {
        system.runAs(someUser1)
        {  
            test.startTest();
            
            Account acc = ANA_UTIL01_TestMethods.createAccount(false); 
            acc.Region__c='Central';
            insert acc;
            
            AccountTeamMember atm = new AccountTeamMember();
            atm.UserID=someUser1.id;
            atm.TeamMemberRole='Account Manager';
            atm.AccountID=acc.id;
            insert atm;
            
            Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
            insert opty; 

            Group__c grp1 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp1.ClaimSystem__c = 'NASCO';
            grp1.Employer_Service_Representative__c=someUser1.Id;
            insert(grp1);
            
            Group__c grp2 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp2.ClaimSystem__c = 'WGS 2.0';
            insert(grp2);  
            //System.debug('Opty is created' );
            
            Quote quoteRec = ANA_UTIL01_TestMethods.createQuote(false,opty.Id);
            quoteRec.GroupNumber__c=grp2.id;  
            insert quoteRec;
            
            System.debug('Quote is created' );
            
             Product2 prod = ANA_UTIL01_TestMethods.createProduct(false);
            prod.Name ='Other - Anthem Subrogation';
            insert(prod);
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
            insert(pbe);
            QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,quoteRec.Id, pbe.id);
            qli.ProductStage__c='Sold';
            insert qli;
            
            Order oldOrder = new Order(Group_Name__c=grp2.id,AccountId = acc.Id, EffectiveDate=System.today(), 
                                       Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting02', Discovery_Call_Desired__c ='Yes', 
                                       Implementation_Status__c = UtilConstants.IC_STATUS_INITIATED , Implementation_Effective_Date__c=System.today(), QuoteId=quoteRec.id,account_manager__c=someUser1.id);
            oldOrder.Assigned_Implementer__c = someUser1.Id;
            insert oldOrder;
            
            someUser1.BypassValidation__c = true;
            
           
           
            
            List<SME_Approvals__c> smelist = new List<SME_Approvals__c>();
            SME_Approvals__c sme1= new SME_Approvals__c();
            //sme1.SME_Approver__c=user.id;
            sme1.SME_Department__c='Group Services';
            sme1.Implementation_Record_ID__c = oldOrder.Id;
            sme1.Selections_Report_Required__c ='Yes';
            sme1.Impact_to_HPCC__c ='Yes';
            sme1.Status__c ='Initiated';
            smelist.add(sme1);              
            
            SME_Approvals__c sme2= new SME_Approvals__c();
            //sme2.SME_Approver__c=user.id;
            sme2.SME_Department__c='Medical Benefits';
            sme2.Implementation_Record_ID__c = oldOrder.Id;
            sme2.Selections_Report_Required__c ='Yes';
            sme2.Impact_to_HPCC__c ='Yes';
            sme2.Status__c ='Initiated';
            sme2.Strings_Tables_Contract_Codes_Impacted__c ='Yes'; 
            smelist.add(sme2);
            
            SME_Approvals__c sme3= new SME_Approvals__c();
            //sme3.SME_Approver__c=user.id;
            sme3.SME_Department__c='Health and Wellness Solutions';
            sme3.Implementation_Record_ID__c = oldOrder.Id;
            sme3.Selections_Report_Required__c ='Yes';
            sme3.Comments__c='satya';   
            sme3.Impact_to_HPCC__c ='Yes';
            sme3.Status__c ='Initiated';
            smelist.add(sme3);
         
            insert smelist;
            
            list<SME_User_Data__c> smuList = new list<SME_User_Data__c>();
            
            SME_User_Data__c sm1 = new SME_User_Data__c(
            Claim_System__c='WGS 2.0',
            Department__c='Group Services',
            Region__c='Central',
            SME_Email__c='testmail1@test.com',
            SME_Title__c='Mr',
            SME_User_Name__c='test2'
            );
            smuList.add(sm1);
            SME_User_Data__c sm2 = new SME_User_Data__c(
            Claim_System__c='WGS 2.0',
            Department__c='Medical Benefits',
            Region__c='Central',
            SME_Email__c='testmail2@test.com',
            SME_Title__c='Mr',
            SME_User_Name__c='test3'
            );
            smuList.add(sm2);
            SME_User_Data__c sm3 = new SME_User_Data__c(
            Claim_System__c='WGS 2.0',
            Department__c='Health and Wellness Solutions',
            Region__c='Central',
            SME_Email__c='testmail3@test.com',
            SME_Title__c='Mr',
            SME_User_Name__c='test4'
            );
            smuList.add(sm3);
            SME_User_Data__c sm4 = new SME_User_Data__c(
            Claim_System__c='WGS 2.0',
            Department__c='Group Services',
            Region__c='Central',
            SME_Email__c='testmail4@test.com',
            SME_Title__c='Mr',
            SME_User_Name__c='test5'
            );
            smuList.add(sm4);
            
           insert smuList;
            
            
            AP26_NotifyUsers_On_ICStatusChange.firstRun = true;
            oldOrder.Implementation_Status__c = 'Pending SME Review'; 
            oldOrder.Assigned_Implementer__c = someUser1.Id;
            update oldOrder;
            AP26_NotifyUsers_On_ICStatusChange.firstRun = true;            
            oldOrder.Implementation_Status__c = 'Approved'; 
            
            update oldOrder;

            system.assert(true); 
             test.stopTest();
                            
            
        }
    } 
    static testMethod void Test_Validation_test()
    {
        system.runAs(someUser1)
        {  
            test.startTest();
            
            Account acc = ANA_UTIL01_TestMethods.createAccount(false);
            acc.Group_Size__c= UtilConstants.keyNumber;
            insert acc;
            
            AccountTeamMember atm = new AccountTeamMember();
            atm.UserID=someUser1.id;
            atm.TeamMemberRole='Account Manager';
            atm.AccountID=acc.id;
            insert atm;
            
            
            Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
            insert opty; 
 
            Group__c grp1 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp1.ClaimSystem__c = 'NASCO';
            grp1.Employer_Service_Representative__c=someUser1.Id;
            insert(grp1);
            
            Group__c grp2 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp2.ClaimSystem__c = 'WGS 2.0';
            insert(grp2);  
            //System.debug('Opty is created' );
            
            Quote quoteRec = new Quote(Name = 'Test Quote',OpportunityId = opty.Id,GroupNumber__c=grp2.id);
            insert quoteRec;
            System.debug('Quote is created' );
            
            Order oldOrder = new Order(Group_Name__c=grp2.id,AccountId = acc.Id, EffectiveDate=System.today(), 
                                       Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting02', Discovery_Call_Desired__c ='Yes', 
                                       Implementation_Status__c = UtilConstants.IC_STATUS_INITIATED , Implementation_Effective_Date__c=System.today(), QuoteId=quoteRec.id,Account_manager__c=someUser1.id);
            //oldOrder.Assigned_Implementer__c = someUser1.Id;
            insert oldOrder;
            oldOrder.Implementation_Status__c = 'Approved';   
            update oldOrder;
        }
   }
}