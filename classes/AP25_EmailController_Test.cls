/**
@Author : Accenture Offshore Dev team
@name : AP25_EmailController_Test
@CreateDate :2/27/2018
@Description :Test class for AP25_Email_Controller .
*/

@isTest 
private class AP25_EmailController_Test {
   
    static testMethod void validateEmailController2() {
             Profile p = [SELECT Id FROM Profile WHERE Name='ICE Sysadmin'];    
        List<AccountTeamMember> teamListAM = new List<AccountTeamMember>();
        List<AccountTeamMember> teamListAE = new List<AccountTeamMember>();
       
        
        // Create the Acounts
        List<Account> accList= new List<Account>();
        Account acc = new Account (Name='newaccount',Anthem_Entity__c ='National Accounts',Brand__c ='Uni care',Group_Size__c ='0 - 50',HQ_State__c = 'ak',Total_Employees__c =20);
        Account acc1 = new Account (Name='newaccount1',Anthem_Entity__c ='National Accounts',Brand__c ='Uni care',Group_Size__c ='0 - 50',HQ_State__c = 'ak',Total_Employees__c =20);
        accList.add(acc);
        accList.add(acc1);
        insert accList;
        
        
        User newUser = new User(lastname = 'Test',Alias = 'Test',TimeZoneSidKey = 'GMT',
                                LocaleSidKey = 'eu_ES',EmailEncodingKey = 'ISO-8859-1',
                                ProfileId = P.id ,LanguageLocaleKey = 'en_US',
                                userName='Test@Tri-ed.com',email='Test@Tri-ed.com');
        
        User newUser2 = new User(lastname = 'TestUser',Alias = 'TestUser',TimeZoneSidKey = 'GMT',
                                 LocaleSidKey = 'eu_ES',EmailEncodingKey = 'ISO-8859-1',
                                 ProfileId = P.id ,LanguageLocaleKey = 'en_US',
                                 userName='Test2@Tri-ed.com',email='Test2@Tri-ed.com');
        
      
        insert newUser2;
        insert newUser;
        system.debug('%%%%%%%%%%accList'+accList); 
        
        Order order1 = new Order();
        order1.AccountID= acclist[0].ID;
        order1.Implementation_Case_Name__c='sdfsdf';
        order1.Implementation_Status__c='Initiated'; 
        order1.Implementation_Effective_Date__c=system.today();
        order1.Discovery_Call_Desired__c='yes';
        order1.Are_there_changes_to_Group_Structure__c='yes';
        //order1.Final_Pre_Certification_Rules__c='CCMU';
        order1.Are_Broker_Commissions_to_be_paid__c='Yes';
        order1.Are_there_any_third_party_vendor_requir__c='Yes';
        order1.Are_there_changes_to_Eligibility__c='Yes';
        order1.Are_there_changes_to_COB__c='Yes';
        order1.Are_there_changes_to_Enrollment_Billing__c='Yes';
        order1.Changes_to_Elig_Vendor_or_File_Feed__c='Yes';
        order1.Added_plans_or_plans_changed_HCR_Status__c='Yes';
        order1.Does_Anthem_Produce_SBC_s__c='Yes';
        order1.Want_the_SBC_created_by_the_SBC_team__c='Yes';
        order1.Does_Anthem_Produce_Benefit_Booklets__c='Yes';
        order1.Does_This_Require_A_New_Benefit_Booklet__c='Yes';
        order1.Modification_to_existing_booklet__c='Yes';
        order1.Status='Draft';
        order1.EffectiveDate=System.Today()+1; 
        
        insert order1;
        Order order2 = new Order();
        order2.AccountID= acclist[0].ID;
        order2.Implementation_Case_Name__c='sdfsdf';
        order2.Implementation_Status__c='Initiated'; 
        order2.Implementation_Effective_Date__c=system.today();
        order2.Discovery_Call_Desired__c='yes';
        order2.Are_there_changes_to_Group_Structure__c='yes';
        //order1.Final_Pre_Certification_Rules__c='CCMU';
        order2.Are_Broker_Commissions_to_be_paid__c='Yes';
        order2.Are_there_any_third_party_vendor_requir__c='Yes';
        order2.Are_there_changes_to_Eligibility__c='Yes';
        order2.Are_there_changes_to_COB__c='Yes';
        order2.Are_there_changes_to_Enrollment_Billing__c='Yes';
        order2.Changes_to_Elig_Vendor_or_File_Feed__c='Yes';
        order2.Added_plans_or_plans_changed_HCR_Status__c='Yes';
        order2.Does_Anthem_Produce_SBC_s__c='Yes';
        order2.Want_the_SBC_created_by_the_SBC_team__c='Yes';
        order2.Does_Anthem_Produce_Benefit_Booklets__c='Yes';
        order2.Does_This_Require_A_New_Benefit_Booklet__c='Yes';
        order2.Modification_to_existing_booklet__c='Yes';
        order2.Status='Draft';
        order2.EffectiveDate=System.Today()+1; 
        insert order2;
        
               
        AP25_Email_Controller obj=  new AP25_Email_Controller();
        
        //Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('orderRecId', order1.id);    
        
        AccountTeamMember newTeam = new AccountTeamMember(AccountId = order1.AccountID,TeamMemberRole = 'Account Manager',UserId = newUser2.id);
        teamListAM.add(newTeam);
        AccountTeamMember newTeam1 = new AccountTeamMember(AccountId = order2.AccountID,TeamMemberRole = 'Account Executive',UserId = newUser.id);
        teamListAE.add(newTeam1);
        
        insert teamListAM;
        insert teamListAE;
      
        
        
        AP25_Email_Controller testobj=  new AP25_Email_Controller(); 
        List<QuoteLineItem> qlilist1 = testobj.getlstQLI();
        //User users= testobj.getUser(); 
        testobj.orderRecId = order1.Id;
        //testobj.AEDetails=teamListAE;
        //testobj.AMDetails=teamListAM;
       
       testobj.getAMDetails();
       testobj.getCurrUser();
         AP25_Email_Controller testobj1=  new AP25_Email_Controller(); 
        testobj1.orderRecId = order2.Id;
        testobj.getAEDetails();
         
        
        try{
            //throw new Email_Controller_Exception('testing');    
        }catch (Exception ex) {
           System.debug(ex.getMessage()); 
       }       
    }
    static testMethod void getAccImpl() {
        
        List<AccountTeamMember> teamListImp = new List<AccountTeamMember>();
        Profile p = [SELECT Id FROM Profile WHERE Name='ICE Sysadmin'];    
        User newUser3 = new User(lastname = 'Test2',Alias = 'Test2',TimeZoneSidKey = 'GMT',
                                 LocaleSidKey = 'eu_ES',EmailEncodingKey = 'ISO-8859-1',
                                 ProfileId = P.id ,LanguageLocaleKey = 'en_US',
                                 userName='Test3@Tri-ed.com',email='Test3@Tri-ed.com');
        insert newUser3; 
        List<Account> accList= new List<Account>();
        Account acc = new Account (Name='newaccount',Anthem_Entity__c ='National Accounts',Brand__c ='Uni care',Group_Size__c ='0 - 50',HQ_State__c = 'ak',Total_Employees__c =20);
        Account acc1 = new Account (Name='newaccount1',Anthem_Entity__c ='National Accounts',Brand__c ='Uni care',Group_Size__c ='0 - 50',HQ_State__c = 'ak',Total_Employees__c =20);
        accList.add(acc);
        accList.add(acc1);
        insert accList;
        Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
        insert opty; 
        
        AccountTeamMember newTeam2 = new AccountTeamMember(AccountId = opty.AccountID,TeamMemberRole = 'Implementer',UserId = newUser3.id);
        teamListImp.add(newTeam2);
        insert teamListImp;
        
        AP25_Email_Controller testobj2=  new AP25_Email_Controller();
        testobj2.orderRecId = opty.id;
        testobj2.getAccImpl();
    }
}