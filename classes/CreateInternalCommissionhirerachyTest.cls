@istest
public class CreateInternalCommissionhirerachyTest{
        Static Map<String,Object> inputMap  = new Map<string,Object>();
        Static Map<String,Object> inputMapvar  = new Map<string,Object>();
        Static Map<String,Object> outputMap = new Map<string,Object>();
        Static Map<String,Object> options = new Map<string,Object>();
        Static String Methodname = 'TestMethod';     
        
 @testSetup static void setup() {
        // Create common test accounts   
           
        List<AccountTeamMember> atmAMList = new List<AccountTeamMember>();
        Account acc = new Account();
        acc.name='TestAccountForICReportingHirerachy';
        insert acc;
	    atmAMList.add(new AccountTeamMember(UserId=UserInfo.getUserId(),TeamMemberRole='SR Sales Consultant',accountid=acc.id));     	
      	insert atmAMList;         	
    }
    @isTest static void testMethodForAccountTeam() {    
        List<AccountTeamMember> atmAMList = new List<AccountTeamMember>();
        Account acc = [SELECT Id FROM Account WHERE Name='TestAccountForICReportingHirerachy' LIMIT 1];   
        List<accountTeamMember> listofacm = [Select id,TeamMemberRole,UserId  from accountteammember where accountid =:acc.id];
        atmAMList.add(new AccountTeamMember(UserId=UserInfo.getUserId(),TeamMemberRole='Account manager',accountid=acc.id));     	
     	insert atmAMList;
        System.debug(listofacm);
        inputMap.put('AccountId',acc.id);     	
     	inputMap.put('SelectICTypeRequest',inputMapvar);
     	inputMapvar.put('SelectRequestType','Account Team');
        test.starttest();
        Boolean testvalue= CreateInternalCommissionhirerachy.invokeMethod(Methodname ,inputMap,outputMap,options);       
        test.stoptest();
        System.assertEquals(testvalue, true);
    }
    @isTest static void exceptionHandling(){
          Map<String,Object> inputMap1  = new Map<string,Object>();	
            Account acc = [SELECT Id FROM Account WHERE Name='TestAccountForICReportingHirerachy' LIMIT 1]; 	
          test.starttest();
         CreateInternalCommissionhirerachy.invokeMethod(Methodname ,inputMap1,outputMap,options);  	
          Integer i = [select count() from Internal_Commission_Reporting_Hierarchy__c where Account_Name__c = :acc.id];	
          test.stopTest();		
        System.assertEquals(i, 0);
    }
    @isTest static void testMethodForSalesTeam() {      
        Account acc = [SELECT Id FROM Account WHERE Name='TestAccountForICReportingHirerachy' LIMIT 1];     
        List<accountteammember> acmb =[Select id,TeamMemberRole,UserId  from accountteammember where accountid =:acc.id];        
        List<id> managerIDS = new List<id>();       
        for(accountteammember ac:acmb){                       
            if(ac.TeamMemberRole=='SR Sales Consultant' || ac.TeamMemberRole=='Account Executive'){
                managerIDS.add(ac.UserId);
         }}        
        List<user> userlist =[select id from user where id in :managerIDS];
        user usrreports = new user();  
        usrreports.LastName = 'Test Code';
        usrreports.Email = 'test@test.com';
        usrreports.Alias = 'Tcode';
        usrreports.Username = 'testInternalCommisionhirerachy@test.com';
        usrreports.CommunityNickname = 'test11232';
        usrreports.LocaleSidKey = 'en_US';
        usrreports.TimeZoneSidKey = 'GMT';
        usrreports.ProfileID = [select Id, Name from Profile where name ='System Administrator'][0].id;
        usrreports.LanguageLocaleKey = 'en_US';
        usrreports.EmailEncodingKey = 'UTF-8';
        insert usrreports;      
        user usr = new user();  
        usr.LastName = 'Test Code12';
        usr.Email = 'test@test.com12';
        usr.Alias = 'Tcode12';
        usr.Username = 'testInternalCommisionhirerachy@test.com12';
        usr.CommunityNickname = 'test12';
        usr.LocaleSidKey = 'en_US';
        usr.TimeZoneSidKey = 'GMT';
        usr.ProfileID = [select Id, Name from Profile where name ='System Administrator'][0].id;
        usr.LanguageLocaleKey = 'en_US';
        usr.EmailEncodingKey = 'UTF-8';
        usr.ReportsTo__c=usrreports.id;
        insert usr;          
        for(user u:userlist){
           u.ReportsTo__c = usr.id; 
        }        
        update userlist;       
        inputMap.put('AccountId',acc.id);     	
     	inputMap.put('SelectICTypeRequest',inputMapvar);
     	inputMapvar.put('SelectRequestType','Sales Team');
        test.starttest();
        CreateInternalCommissionhirerachy.invokeMethod(Methodname ,inputMap,outputMap,options);             
        Integer selfrec = [select count() from Internal_Commission_Reporting_Hierarchy__c where Account_Name__c = :acc.id and
                          	Account_Relationship_Type__c='self'];
        Integer indirectrec= [select count() from Internal_Commission_Reporting_Hierarchy__c where Account_Name__c = :acc.id 
                              and Account_Relationship_Type__c='indirect' ];
        Integer directrec = [select count() from Internal_Commission_Reporting_Hierarchy__c where Account_Name__c = :acc.id and
                            Account_Relationship_Type__c='direct'];
        test.stoptest();
        System.assertEquals(selfrec, 3);
        System.assertEquals(indirectrec, 1);
        System.assertEquals(directrec, 3);
    }
}