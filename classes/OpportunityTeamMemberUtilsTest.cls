/*
  @@ Author       ::: Ranjith Kumar
  @@ Created Date ::: 1/20/2020
  @@ Purpose      ::: Test class for OpportunityTeamMemberUtils.
*/
@isTest
public class OpportunityTeamMemberUtilsTest{
    public static testmethod void deleteTestData(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Account Manager';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Executive');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData1(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Account Executive';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Account Executive');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData11(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Specialty Sales Account Manager';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Specialty Sales Account Manager');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData12(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Specialty Sales Executive';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Specialty Sales Executive');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData13(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Specialty Sales Support';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Specialty Sales Support');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData14(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Specialty Clinical Account Director';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Specialty Clinical Account Director');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData15(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS Sales Support';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'GRS Sales Support');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData16(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS Account Manager';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'GRS Account Manager');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData17(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS Underwriter';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'GRS Underwriter');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData18(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS Administrator';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'GRS Administrator');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData19(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='VP';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'VP');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData121(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Sales Account Representative';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Sales Account Representative');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData122(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Underwriter';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Underwriter');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData123(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Account Service Representative';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Account Service Representative');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData124(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Director Sales/AM';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Director Sales/AM');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData125(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS Account Executive';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'GRS Account Executive');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData126(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS ESR';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'GRS ESR');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData127(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Sales Account Rep - Acct Mgmt';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Sales Account Rep - Acct Mgmt');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    public static testmethod void deleteTestData128(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Voluntary Enrollment Consultant';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        System.assertEquals(oppTeamMemList.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Voluntary Enrollment Consultant');
        
        delete oppTeamMemList.values();
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(oppTeamMemList.values(),null,true);
        Test.stopTest();    
        
    }

    
    public static testmethod void deleteTestData2(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Account Manager';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Executive';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Account Executive');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData3(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Account Executive';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Executive');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData31(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Specialty Sales Account Manager';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Specialty Sales Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData32(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Specialty Sales Executive';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Specialty Sales Executive');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    
    public static testmethod void deleteTestData33(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Specialty Sales Support';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Specialty Sales Supportr');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData34(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Specialty Clinical Account Director';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Specialty Clinical Account Director');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData35(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS Sales Support';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'GRS Sales Support');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData36(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS Account Manager';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'GRS Account Manager');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData37(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS Underwriter';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'GRS Underwriter');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData38(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Account Executive';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Executive');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData39(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS Administrator';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'GRS Administrator');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData30(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='VP';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'VP');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData311(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Sales Account Representative';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Sales Account Representative');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData312(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Underwriter';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Underwriter');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData313(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Account Service Representative';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Account Service Representative');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData314(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Director Sales/AM';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Director Sales/AM');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData315(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS Account Executive';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'GRS Account Executive');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData316(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='GRS ESR';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Sales Account Rep - Acct Mgmt');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData317(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Sales Account Rep - Acct Mgmt';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Sales Account Rep - Acct Mgmt');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
    
    public static testmethod void deleteTestData318(){
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
        
        Test.startTest();
        //inserting opportunity team roles
        OpportunityTeamMember opptm=new OpportunityTeamMember();
        opptm.OpportunityId=newOpp.id;
        opptm.TeamMemberRole='Voluntary Enrollment Consultant';
        opptm.UserId=UserInfo.getUserId();
        insert opptm;
        
        Map<Id,OpportunityTeamMember> oppTeamMemList=new Map<Id,OpportunityTeamMember>();
        oppTeamMemList.put(opptm.id,opptm);
        
        List<OpportunityTeamMember> opptmlist=new List<OpportunityTeamMember>();
        opptm.TeamMemberRole='Account Manager';
        update opptm;
        
        opptmlist.add(opptm);
        System.assertEquals(opptmlist.size(),1);
        System.assertnotEquals(opptm.TeamMemberRole,'Voluntary Enrollment Consultant');
        System.assertEquals(opptm.TeamMemberRole,'Account Manager');
        
            OpportunityTeamMemberHandler optmh=new OpportunityTeamMemberHandler();
            OpportunityTeamMemberUtils.updateRolesInOpportunity(opptmlist,oppTeamMemList,false);
        Test.stopTest();    
        
    }
}