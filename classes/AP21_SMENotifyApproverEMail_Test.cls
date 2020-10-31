/*
@author         Accenture offshore
@date           4/20/2018
@name           AP21_SMENotifyApproverEMail_Test
@description    This class is used to check the code coverage for AP21_SMENotifyApproverEMail .  
*/
@Istest
private class AP21_SMENotifyApproverEMail_Test {
    
static testMethod void SMENotifyApproverEMailTest() {
 
    test.startTest();
     Profile p = [SELECT Id FROM Profile WHERE Name='SME']; 
     User user = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', 
                      EmailEncodingKey='UTF-8', LastName='fghdfh', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='test2314@testorg.com');

    insert user;
    
    
    Profile p1 = [SELECT Id FROM Profile WHERE Name='Local Implementations']; 
     User user2 = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', 
                      EmailEncodingKey='UTF-8', LastName='fgasdhdfh', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p1.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='test23123we4@testorg.com');

    insert user2;
    


    Account acc = ANA_UTIL01_TestMethods.createAccount(false); 
    insert acc;
  
        //Creating Opportunity Records

        Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
        insert opty; 
        Group__c grp1 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp1.ClaimSystem__c = 'NASCO';
            insert(grp1);
       Group__c grp2 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp2.ClaimSystem__c = 'WGS 2.0';
            insert(grp2);  
        //System.debug('Opty is created' );
        Quote quoteRec = new Quote(Name = 'Test Quote',OpportunityId = opty.Id,GroupNumber__c=grp1.id);
        insert quoteRec;
        System.debug('Quote is created' );
        
        //Creating Group
        
 Order ord = new Order(Group_Name__c=grp1.id,AccountId = acc.Id, EffectiveDate=System.today(), 
                       Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes',
                       Implementation_Status__c = 'Initiated', Implementation_Effective_Date__c=System.today(),
                       Assigned_Implementer__c=user2.id,QuoteId=quoteRec.id
                      );      
 insert ord;
 
    
    
    
    List<SME_Approvals__c> smelist = new List<SME_Approvals__c>();
    SME_Approvals__c sme1= new SME_Approvals__c();
    sme1.SME_Approver__c=user.id;
    sme1.SME_Department__c='Group Services';
    sme1.Implementation_Record_ID__c = ord.Id;
    sme1.Selections_Report_Required__c ='Yes';
    sme1.Impact_to_HPCC__c ='Yes';
    sme1.Status__c ='Approved';
    smelist.add(sme1);              
    
    SME_Approvals__c sme2= new SME_Approvals__c();
    sme2.SME_Approver__c=user.id;
    sme2.SME_Department__c='Medical Benefits';
    sme2.Implementation_Record_ID__c = ord.Id;
    sme2.Selections_Report_Required__c ='Yes';
    sme2.Impact_to_HPCC__c ='Yes';
    sme2.Status__c ='Approved';
    sme2.Strings_Tables_Contract_Codes_Impacted__c ='Yes'; 
    smelist.add(sme2);
    
    SME_Approvals__c sme3= new SME_Approvals__c();
    sme3.SME_Approver__c=user.id;
    sme3.SME_Department__c='Health and Wellness Solutions';
    sme3.Implementation_Record_ID__c = ord.Id;
    sme3.Selections_Report_Required__c ='Yes';
    sme3.Comments__c='satya';   
    sme3.Impact_to_HPCC__c ='Yes';
    sme3.Status__c ='Approved';
    smelist.add(sme3);
 
    insert smelist;

    sme3.Selections_Report_Required__c='No';
    sme3.Impact_to_HPCC__c='No';
    update sme3; 
    
    sme1.Selections_Report_Required__c ='No';
    update sme1;
    
    sme1.Impact_to_HPCC__c ='No';
    update sme1;
    
    
    sme2.Strings_Tables_Contract_Codes_Impacted__c ='Yes'; 
    update sme2;
    
    
    
   List<String> strlist= new List<String>();
   String sendto1='test@gmail.com';
   strlist.add(sendto1);
    String subjectLine='Email test';
    String Salutation='Mr';
    String prirorValue ='Test';
    String newValue ='new test value';
    String hyperLink ='Emila testing Hyperlink';
    String mailBody='testing message suceesfully or not';
    AP21_SMENotifyApproverEMail.sendMailMethod(strlist, subjectLine, Salutation, prirorValue, newValue, hyperLink, mailBody);
    prirorValue =null;
    newValue=null;
    AP21_SMENotifyApproverEMail.sendMailMethod(strlist, subjectLine, Salutation, prirorValue, newValue, hyperLink, mailBody);    
  
test.stopTest();
}
    
    static testMethod void SMENotifyApproverEMailTest2(){
    
        
   test.startTest();       
     Profile p = [SELECT Id FROM Profile WHERE Name='SME']; 
     User user = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', 
                      EmailEncodingKey='UTF-8', LastName='fghdfh', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='test2314@testorg.com');

    insert user;
    
    
    Profile p1 = [SELECT Id FROM Profile WHERE Name='Local Implementations']; 
     User user2 = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', 
                      EmailEncodingKey='UTF-8', LastName='fgasdhdfh', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p1.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='test23123we4@testorg.com');

    insert user2;
 
 Account acc = ANA_UTIL01_TestMethods.createAccount(false); 
        acc.Anthem_Entity__c='National Accounts';
        insert acc ;
        
  Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
        insert opty; 
        Group__c grp1 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp1.ClaimSystem__c = 'NASCO';
            insert(grp1);
       Group__c grp2 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp2.ClaimSystem__c = 'WGS 2.0';
            insert(grp2);  
        //System.debug('Opty is created' );
        Quote quoteRec = new Quote(Name = 'Test Quote',OpportunityId = opty.Id,GroupNumber__c=grp1.id);
        insert quoteRec;
        System.debug('Quote is created' );
                  
        
 Order ord = new Order(Group_Name__c=grp1.id,AccountId = acc.Id, EffectiveDate=System.today(), 
                       Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes',
                       Implementation_Status__c = 'Initiated', Implementation_Effective_Date__c=System.today(),
                       Assigned_Implementer__c=user2.id 
                      );      
 insert ord;
      Id RecTypeId=Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();  
      Implementation_Tracking__c trackRec = new Implementation_Tracking__c(
     
        Implementation_Record_ID__c =ord.id,
        Group_Number__c=grp1.id,  
        Account_Legal_Name__c=acc.id,
         RecordTypeId=RecTypeId
      );
       
   //  insert trackRec;
    
    List<SME_Approvals__c> smelist = new List<SME_Approvals__c>();
    SME_Approvals__c sme1= new SME_Approvals__c();
    sme1.SME_Approver__c=user.id;
    sme1.SME_Department__c='Group Services';
    sme1.Implementation_Record_ID__c = ord.Id;
    sme1.Selections_Report_Required__c ='Yes';
    sme1.Impact_to_HPCC__c ='Yes';
    sme1.Status__c ='Approved';
    smelist.add(sme1);              
    
    SME_Approvals__c sme2= new SME_Approvals__c();
    sme2.SME_Approver__c=user.id;
    sme2.SME_Department__c='Medical Benefits';
    sme2.Implementation_Record_ID__c = ord.Id;
    sme2.Selections_Report_Required__c ='Yes';
    sme2.Impact_to_HPCC__c ='Yes';
    sme2.Status__c ='Approved';
      
    sme2.Strings_Tables_Contract_Codes_Impacted__c ='Yes'; 
    smelist.add(sme2);
    
    SME_Approvals__c sme3= new SME_Approvals__c();
    sme3.SME_Approver__c=user.id;
    sme3.SME_Department__c='Health and Wellness Solutions';
    sme3.Implementation_Record_ID__c = ord.Id;
    sme3.Selections_Report_Required__c ='Yes';
    sme3.Comments__c='satya';   
    sme3.Impact_to_HPCC__c ='Yes';
    sme3.Status__c ='Approved';
    smelist.add(sme3);
        
    SME_Approvals__c sme4= new SME_Approvals__c();
    sme4.SME_Approver__c=user.id;
    sme4.SME_Department__c='ID Cards';
    sme4.Implementation_Record_ID__c = ord.Id;
    sme4.Selections_Report_Required__c ='Yes';
    sme4.Comments__c='satya';   
    sme4.Impact_to_HPCC__c ='Yes';
    sme4.Status__c ='Approved';
    smelist.add(sme4);   
  
    insert smelist;
           
    sme2.Strings_Tables_Contract_Codes_Impacted__c ='No'; 
    sme2.Status__c ='Approved with Deviations';
    sme2.Comments__c='satya';
    update sme2;
    
    sme4.Status__c ='Approved with Deviations';
    update sme4 ; 
    
     system.debug('%%%%%%%sme4'+sme4); 
   test.stopTest(); 
    }
        
    static testMethod void SMENotifyApproverEMailTest3() {
  test.startTest();  
     Profile p = [SELECT Id FROM Profile WHERE Name='SME']; 
     User user = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', 
                      EmailEncodingKey='UTF-8', LastName='fghdfh', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='test2314@testorg.com');

    insert user;
    
    
    Profile p1 = [SELECT Id FROM Profile WHERE Name='Local Implementations']; 
     User user2 = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', 
                      EmailEncodingKey='UTF-8', LastName='fgasdhdfh', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p1.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='test23123we4@testorg.com');

    insert user2;
    


    Account acc = ANA_UTIL01_TestMethods.createAccount(false); 
    insert acc;
  
        //Creating Opportunity Records

        Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
        insert opty; 
        Group__c grp1 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp1.ClaimSystem__c = 'NASCO';
            insert(grp1);
       Group__c grp2 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp2.ClaimSystem__c = 'WGS 2.0';
            insert(grp2);  
        //System.debug('Opty is created' );
        Quote quoteRec = new Quote(Name = 'Test Quote',OpportunityId = opty.Id,GroupNumber__c=grp2.id);
        insert quoteRec;
        System.debug('Quote is created' );
        
        //Creating Group
        
 Order ord = new Order(Group_Name__c=grp2.id,AccountId = acc.Id, EffectiveDate=System.today(), 
                       Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes',
                       Implementation_Status__c = 'Initiated', Implementation_Effective_Date__c=System.today(),
                       Assigned_Implementer__c=user2.id,QuoteId=quoteRec.id
                      );      
 insert ord;
 
    
    
    
    List<SME_Approvals__c> smelist = new List<SME_Approvals__c>();
    SME_Approvals__c sme1= new SME_Approvals__c();
    sme1.SME_Approver__c=user.id;
    sme1.SME_Department__c='Group Services';
    sme1.Implementation_Record_ID__c = ord.Id;
    sme1.Selections_Report_Required__c ='Yes';
    sme1.Impact_to_HPCC__c ='Yes';
    sme1.Status__c ='Approved';
    smelist.add(sme1);              
    
    SME_Approvals__c sme2= new SME_Approvals__c();
    sme2.SME_Approver__c=user.id;
    sme2.SME_Department__c='Medical Benefits';
    sme2.Implementation_Record_ID__c = ord.Id;
    sme2.Selections_Report_Required__c ='Yes';
    sme2.Impact_to_HPCC__c ='Yes';
    sme2.Status__c ='Approved';
    sme2.Strings_Tables_Contract_Codes_Impacted__c ='Yes'; 
    smelist.add(sme2);
    
    SME_Approvals__c sme3= new SME_Approvals__c();
    sme3.SME_Approver__c=user.id;
    sme3.SME_Department__c='Health and Wellness Solutions';
    sme3.Implementation_Record_ID__c = ord.Id;
    sme3.Selections_Report_Required__c ='Yes';
    sme3.Comments__c='satya';   
    sme3.Impact_to_HPCC__c ='Yes';
    sme3.Status__c ='Approved';
    smelist.add(sme3);
 
    insert smelist;

    sme3.Selections_Report_Required__c='No';
    sme3.Impact_to_HPCC__c='No';
    update sme3; 
    
    sme2.Selections_Report_Required__c ='No';
    update sme2;
    
    sme2.Impact_to_HPCC__c ='No';
    update sme2;

    
   List<String> strlist= new List<String>();
   String sendto1='test@gmail.com';
   strlist.add(sendto1);
    String subjectLine='Email test';
    String Salutation='Mr';
    String prirorValue ='Test';
    String newValue ='new test value';
    String hyperLink ='Emila testing Hyperlink';
    String mailBody='testing message suceesfully or not';
    AP21_SMENotifyApproverEMail.sendMailMethod(strlist, subjectLine, Salutation, prirorValue, newValue, hyperLink, mailBody);
    prirorValue =null;
    newValue=null;
    AP21_SMENotifyApproverEMail.sendMailMethod(strlist, subjectLine, Salutation, prirorValue, newValue, hyperLink, mailBody);   
 test.stopTest(); 
  }
  
}