@isTest
public class IDCardActionsTest
{
    @testSetup 
    static void idCardRecordCreation_TestDataSetup() 
    {
        
        Sic__c Sic = new Sic__c(Name = staticVariableClass.SIC);
        Insert Sic;
        
        // Account creation
        List<Account> acc = new List<Account>(TestDataFactory.createAccountSICList(1, staticVariableClass.AccountName,staticVariableClass.testAccBillingStreet, staticVariableClass.testAccBillingCity,staticVariableClass.testAccBillingState, staticVariableClass.testAccBillingPostalCode,staticVariableClass.testAccBillingCountry, staticVariableClass.AK));
        acc[0].Situs_State__c =  staticVariableClass.California;
        acc[0].RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Account).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGProspect).getRecordTypeId();
        acc[0].Physical_County__c = staticVariableClass.California;
        acc[0].ShippingStreet = '';
        acc[0].ShippingState  = '';
        acc[0].ShippingPostalCode  = '';
        acc[0].ShippingCountry  = '';
        acc[0].ShippingCity  = '';
        acc[0].Mailing_Address_Same_as_Physical_Address__c = true;
        insert acc;
        
        //Querying the created Accounts
        List<Account> accList = [Select id from account];
        System.assertEquals(1, accList.size(),'The Account list size is one');
        
        // Opportunity Creation
        List<Opportunity> opptyList = new List<Opportunity>(TestDataFactory.createOpportunityList( 1,staticVariableClass.OpportunityName,acc[0]));
        opptyList[0].RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Opportunity).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.NewBusinessLocal).getRecordTypeId();
        insert opptyList;
        
        //Querying the created Opportunities
        List<opportunity> opptyList1 =[Select id from opportunity];
        System.assertEquals(1, opptyList1.size(),'The Opportunity list size is one');
        
        // Group Creation
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc[0].id,false);
        insert grp;
        
        // Quote Creation
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,opptyList1[0].Id);
        qte.GroupNumber__c=grp.id;
        insert qte;
        
        // Profile Creation
        Profile p1 = [SELECT Id,name FROM Profile WHERE Name= :staticVariableClass.LocalImplementations]; 
        
        // User Creation
        List<User> userList = TestDataFactory.createUserData(1,staticVariableClass.LocalImplementations,'1234');
        userList[0].Email=staticVariableClass.userEmail;
        insert userList;
        
        // Order Creation
        Order ord = new Order(Group_Name__c=grp.id,AccountId = acc[0].Id, EffectiveDate=System.today(), Status = staticVariableClass.Draft,User_Group__c =staticVariableClass.LocalNewBusiness,
                              Implementation_Case_Name__c = staticVariableClass.AIMTesting03, Discovery_Call_Desired__c =staticVariableClass.UpsellYes, Implementation_Status__c = staticVariableClass.ReadyforImps, 
                              Implementation_Effective_Date__c=System.today(), Assigned_Implementer__c=userList[0].id,QuoteId=qte.id);
        insert ord;
      
    }
    
    @isTest 
    static void populateIDcardAssignedImplementerTestMethod() {
        
        Test.startTest();
        
        //List For ID card 
        List<ID_Cards__c> idCardList1 = new List<ID_Cards__c>();
        List<ID_Cards__c> idCardList = new List<ID_Cards__c>();
        
        //Set for ID card
        Set<ID> idCardIDSet = new Set<ID>();
        
        //Fetch User
        List<User> userList =[Select id from User where email =:staticVariableClass.userEmail LIMIT 1];
        
        // Checking size of user 
        System.assertEquals(1, userList.size(),'The User list size is one');
        
        // Fetch the parent Order Record
        List<Order> ordList = [SELECT Id,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1];
        ordList[0].Assigned_Implementer__c=userList[0].id;
        update ordList;
        
        // Update the Order record status
        ordList[0].Implementation_Status__c = staticVariableClass.PendingSmeReview;
        ordList[0].Implementation_Status__c = 'YES';  
        update ordList;
        
        // Create LOCAL Implementation Tracking and it related Records
        Implementation_Tracking__c localImpTrack = new Implementation_Tracking__c();
        localImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(staticVariableClass.LocalNASCOandWGS).getRecordTypeId();
        localImpTrack.Implementation_Record_ID__c = ordList[0].Id;
        insert localImpTrack;
        
        for(Integer i=1;i<=10;i++){
            ID_Cards__c idCard= new ID_Cards__c(Implementation_Tracking_ID__c = localImpTrack.ID,Stage__c = UtilConstants.PENDING_CARD_NOT_STARTED_01);
            idCardList.add(idCard);
        }
        
        if(!idCardList.isEmpty()){
            insert idCardList;
        }
        
        //Checking Size of ID card Record list
        System.assertEquals(10, idCardList.size(),'The User list size is 10');
        
        for(ID_Cards__c idCard1:idCardList){
            idCard1.Stage__c= UtilConstants.PENDING_CARD_REVIEW_04;
            idCardIDSet.add(idCard1.id);
        }
        if(!idCardList.isEmpty()){
            update idCardList;
        }
        
        if(!idCardIDSet.isEmpty()){
            idCardList1=[SELECT Assigned_Implementer__c from ID_Cards__c where id IN :idCardIDSet ];
        }
        
        for(ID_Cards__c idCard2:idCardList1){
            //This Assert statement verifies if Assigned Implementer got populated in ID card record or not
            System.assertEquals(idCard2.Assigned_Implementer__c,userList[0].id);
        }
        
        Test.stopTest();
    } 
    
    @isTest 
    static void populateIDcardsUpdatesTestMethod() {
        
        Test.startTest();
        
        //List For ID card 
        List<ID_Cards__c> idCardList1 = new List<ID_Cards__c>();
        List<ID_Cards__c> idCardList = new List<ID_Cards__c>();
        
        //Set for ID card
        Set<ID> idCardIDSet = new Set<ID>();
        
        //Fetch User
        List<User> userList =[Select id from User where email =:staticVariableClass.userEmail LIMIT 1];
        
        // Checking size of user 
        System.assertEquals(1, userList.size(),'The User list size is one');
        
        // Fetch the parent Order Record
        List<Order> ordList = [SELECT Id,Implementation_Status__c,Implementation_Type__c,ID_Cards_Required__c FROM Order WHERE Implementation_Case_Name__c = :staticVariableClass.AIMTesting03 LIMIT 1];
        ordList[0].Assigned_Implementer__c=userList[0].id;
        update ordList;
        
        // Update the Order record status
        ordList[0].Implementation_Status__c = staticVariableClass.PendingSmeReview;
        ordList[0].Implementation_Status__c = 'YES';  
        update ordList;
        
        // Create LOCAL Implementation Tracking and it related Records
        Implementation_Tracking__c localImpTrack = new Implementation_Tracking__c();
        localImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(staticVariableClass.LocalNASCOandWGS).getRecordTypeId();
        localImpTrack.Implementation_Record_ID__c = ordList[0].Id;
        insert localImpTrack;
        
        Issue_Control__c  csInstall=new Issue_Control__c ();
        //csInstall.Name='testcase Install';
        csInstall.Implementation_Tracking_ID__c =localImpTrack.Id;
        insert csInstall;
        
        Enrollment_and_Billing__c  enrmem=new Enrollment_and_Billing__c();
        //enrmem.Name='test membership';
        enrmem.Implementation_Tracking_ID__c =localImpTrack.Id;
        insert enrmem;
        
        Id localRecordTypeId = Schema.SObjectType.ID_Cards__c.getRecordTypeInfosByName().get('Local').getRecordTypeId();
        
        for(Integer i=1;i<=10;i++){
            ID_Cards__c idCard= new ID_Cards__c(Implementation_Tracking_ID__c = localImpTrack.ID,Case_Installation__c=csInstall.Id,Membership__c=enrmem.Id,RecordTypeId=localRecordTypeId,Stage__c = UtilConstants.PENDING_CARD_NOT_STARTED_01);
            idCardList.add(idCard);
        }
        
        if(!idCardList.isEmpty()){
            insert idCardList;
        }
        
        //Checking Size of ID card Record list
        System.assertEquals(10, idCardList.size(),'The User list size is 10');
        
        System.assertEquals(idCardList[0].Case_Installation__c,csInstall.Id);
        System.assertEquals(idCardList[0].Membership__c,enrmem.Id);
       
        
        Test.stopTest();
    } 
}