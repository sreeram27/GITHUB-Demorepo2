/*
  @@ Author       ::: Ranjith Kumar
  @@ Created Date ::: 1/21/2020
   @@ Team         ::: Vikings(PRDCRM-49344)
  @@ Purpose      ::: Test class for UpdateOpprtunityRollupFieldsBatch.
*/
@isTest
public class UpdateOpprtunityRollupFieldsBatchTest{
    public static testmethod void testdata(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser111@testorg.com');
        insert u;
        
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
        List<Opportunity> opplist=new List<Opportunity>();
        
        Opportunity newOpp = new Opportunity(
            name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name),
            StageName = staticVariableClass.ClosedWon,
            AccountID = acc.id,
            CloseDate = ((system.TODAY())-95),
            Account_Manager__c=u.id,  
            Account_Executive__c=u.id,
            is_Updated_From_Batch__c=false,                    
            recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId()                                    
        );
        
        lstOpp.add(newOpp);
        
        Opportunity newOpp1 = new Opportunity(
            name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name),
            StageName = staticVariableClass.ClosedWon,
            AccountID = acc.id,
            CloseDate = ((system.TODAY())-95),
            Account_Manager__c=u.id,  
            Account_Executive__c=u.id,
            is_Updated_From_Batch__c=false,                      
            recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId()                                    
        );
        
        lstOpp.add(newOpp1);
        insert lstOpp;
        
        System.assertEquals(lstOpp[0].is_Updated_From_Batch__c,false);
        System.debug('---newOpp---'+newOpp);
        System.debug('---newOppAccount_Manager__c---'+newOpp.Account_Manager__c);
        System.debug('---newOppAccount_Manager__c---'+newOpp.Account_Executive__c);
        
        System.debug('---newOpp111Account_Manager__c---'+newOpp1.Account_Manager__c);
        System.debug('---newOpp1111Account_Manager__c---'+newOpp1.Account_Executive__c);
        
        StaticVariablesforOppTeamRoles.AccountManager='Account Manager';
        StaticVariablesforOppTeamRoles.AccountExecutive='Account Executive';
        StaticVariablesforOppTeamRoles.SpecialtySalesAccountManager='Specialty Sales Account Manager';
        StaticVariablesforOppTeamRoles.SpecialtySalesExecutive='Specialty Sales Executive';
        StaticVariablesforOppTeamRoles.SpecialtySalesSupport='Specialty Sales Support';
        StaticVariablesforOppTeamRoles.SpecialtyClinicalAccountDirector='Specialty Clinical Account Director';
        StaticVariablesforOppTeamRoles.GRSSalesSupport='GRS Sales Support';
        StaticVariablesforOppTeamRoles.GRSAccountManager='GRS Account Manager';
        StaticVariablesforOppTeamRoles.GRSUnderwriter='GRS Underwriter';
        StaticVariablesforOppTeamRoles.GRSAdministrator='GRS Administrator';
        StaticVariablesforOppTeamRoles.VP='VP';
        StaticVariablesforOppTeamRoles.SalesAccountRepresentative='Sales Account Representative';
        StaticVariablesforOppTeamRoles.Underwriter='Underwriter';
        StaticVariablesforOppTeamRoles.AccountServiceRepresentative='Account Service Representative';
        StaticVariablesforOppTeamRoles.DirectorSalesAM='Director Sales/AM';
        StaticVariablesforOppTeamRoles.GRSAccountExecutive='GRS Account Executive';
        StaticVariablesforOppTeamRoles.GRSESR='GRS ESR';
        StaticVariablesforOppTeamRoles.SalesAccountRepAcctMgmt='Sales Account Rep - Acct Mgmt';
        StaticVariablesforOppTeamRoles.VoluntaryEnrollmentConsultant='Voluntary Enrollment Consultant';
        
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Account Manager';
        opptm.UserId=UserInfo.getUserId();
        
        
        OpportunityTeamMember opptm1=new OpportunityTeamMember();
        opptm1.OpportunityId=newOpp1.id;
        opptm1.TeamMemberRole='Account Executive';
        opptm1.UserId=UserInfo.getUserId();
        
       
        List<OpportunityTeamMember> opptemlist=new List<OpportunityTeamMember>();
        opptemlist.add(opptm);
        opptemlist.add(opptm1);
        insert opptemlist;
        
        
         
        /*lstOpp[0].Account_Manager__c=opptemlist[0].UserId;   
        lstOpp[0].is_Updated_From_Batch__c=true; 
        lstOpp[1].Account_Executive__c=opptemlist[1].UserId;   
        lstOpp[1].is_Updated_From_Batch__c=true;      
        opplist.add(lstOpp[0]);
        opplist.add(lstOpp[1]);
        upsert opplist;*/
         
        System.assertEquals(opptemlist.size(),2);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Executive');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        //System.assertEquals(newOpp.Account_Manager__c,opptm.UserId);
        //System.assertEquals(opplist.size(),2);
        //System.assertEquals(opplist[0].is_Updated_From_Batch__c,true);
        
        
        
        
            
       Test.startTest();
       DataBase.BatchableContext bc;
            UpdateOpprtunityRollupFieldsBatch bat=new UpdateOpprtunityRollupFieldsBatch();
            bat.execute(bc,lstOpp);
            Id btid=DataBase.ExecuteBatch(bat);
        Test.stopTest();    
        
    }
}