/**************************************************************************************
Apex Class Name:  LGCarveOutTimeBatch_Test
Version     : -- 
Created Date    : --
* @Author: --
Modified By - Sharath KN - 12-Aug-2019 - Added Substage values for Vision,Dental and 'Life And Disability' objects in test data.  
*************************************************************************************/
@isTest
public class LGCarveOutTimeBatch_Test
{
    @testSetup public static void LGCarveOutTimeBatch_TestDataSetup() 
    {
        SIC__c SIC = new SIC__c(Name = staticVariableClass.SIC);
        Insert SIC;
        
        Account acc =new Account(
            RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
            Name = staticVariableClass.AccountName,Account_s_Suppress_Auto_Renewal__c = false,Anthem_Entity__c = staticVariableClass.Entity,
            Region__c= staticVariableClass.Region, Branding__c =staticVariableClass.UniCare,SIC__c = SIC.Id,Group_Size__c =staticVariableClass.size,
            Total_Employees__c =staticVariableClass.emp, HQ_State__c =staticVariableClass.AK, Situs_State__c = staticVariableClass.California,
            Mailing_Address_Same_as_Physical_Address__c = true, BillingStreet = 'Land Mark', BillingPostalCode = '636111',
            BillingCity = 'Banglore', BillingCountry = 'India', BillingState = 'Karnataka', Physical_County__c = '121');
        insert acc;
        
        list<Id> lstOpp= new list<Id>();
        
        Opportunity newOpp = new Opportunity(Name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name), 
                                             StageName = staticVariableClass.ClosedWon, AccountID = acc.id, CloseDate = ((system.TODAY())-95),                   
                                             RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId());
        
        insert newOpp;
        
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        insert grp;
        
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,newOpp.Id);
        qte.GroupNumber__c=grp.id;
        insert qte;
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Local Implementations']; 
        User user2 = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='fgasdhdfh', 
                              LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', 
                              UserName='test23123we4@testorg.com');
        
        insert user2;
        
        Order ord = new Order(Group_Name__c=grp.id,AccountId = acc.Id, EffectiveDate=System.today(), Status = 'Draft',
                              Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes', 
                              Implementation_Status__c = 'Ready for Imps', Implementation_Effective_Date__c=System.today(), 
                              Assigned_Implementer__c=user2.id,QuoteId=qte.id);

        test.startTest();
        
        insert ord;
        ord.Implementation_Status__c = 'Pending SME Review';
        update ord;
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        
        insert ImpTrack;
        
        
        test.stopTest();
    }
    @isTest static void testMethod1()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Enrollment_and_Billing__c EB = new Enrollment_and_Billing__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
       
        Enrollment_and_Billing__c EB2 = EB.clone();
       
        
        list<SObject> SMERecords_List = new list<SObject>{EB, EB2};
        
        insert SMERecords_List;
        Pending_correction__c PC1 = new Pending_correction__c( Implementation_Case__c = ord.id, Enrollment_and_Billing__c = EB.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
       
        list<SObject> PCRecords_List = new list<SObject>{PC1};
         test.startTest();
        insert PCRecords_List;
       
        LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
        Database.executebatch(p,1);
        
 
        test.stopTest();
        
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    @isTest static void testMethod2()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        InterPlan__c IP = new InterPlan__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '02 Work In Progress');
        //Issue_Control__c IC = new Issue_Control__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '02 Work In Progress');
       
        InterPlan__c IP2 = IP.clone();
       // Issue_Control__c IC2 = IC.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{IP, IP2};
        
        insert SMERecords_List;
       
       Pending_correction__c PC2 = new Pending_correction__c( Implementation_Case__c = ord.id, InterPlan__c = IP.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC2};
         test.startTest();
        insert PCRecords_List;
       
       
        test.stopTest();
        
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
   @isTest static void testMethod3()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Issue_Control__c IC = new Issue_Control__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '02 Work In Progress');
       
        Issue_Control__c IC2 = IC.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{IC, IC2};
        
        insert SMERecords_List;
       
      Pending_correction__c PC3 = new Pending_correction__c( Implementation_Case__c = ord.id, Issue_Control__c = IC.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC3};
         test.startTest();
        insert PCRecords_List;
       
        
             test.stopTest();
              LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    @isTest static void testMethod4()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Medical_Benefit__c med= new Medical_Benefit__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '04 Approved');
       
        Medical_Benefit__c med2 = med.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{med, med2};
        
        insert SMERecords_List;
       
     Pending_correction__c PC4 = new Pending_correction__c( Implementation_Case__c = ord.id, Medical_Benefits__c = med.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        list<SObject> PCRecords_List = new list<SObject>{PC4};
         test.startTest();
        insert PCRecords_List;
       
      
        test.stopTest();
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    @isTest static void testMethod5()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
       First_Impressions__c fi= new First_Impressions__c(First_Impressions_Type__c='Medical',Implementation_Tracking_ID__c = ImpTrack.ID,Is_This_A_Standard_Or_Modified_Request__c='Standard',First_Impressions_Stage__c = '04 Approved');
       
        First_Impressions__c fi2 = fi.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{fi, fi2};
        
        insert SMERecords_List;
       
      Pending_correction__c PC5 = new Pending_correction__c( Implementation_Case__c = ord.id, FI_Id__c = fi.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC5};
         test.startTest();
        insert PCRecords_List;
       
      
        test.stopTest();
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    @isTest static void testMethod6()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Rx__c Rx = new Rx__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
       
        Rx__c Rx2 = Rx.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{Rx, Rx2};
        
        insert SMERecords_List;
        
         LGCarveOutTimeBatch p1 = new LGCarveOutTimeBatch();
         Database.executebatch(p1,1);
       
     Pending_correction__c PC6 = new Pending_correction__c( Implementation_Case__c = ord.id, Rx__c = Rx.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC6};
         test.startTest();
        insert PCRecords_List;
       
      
        test.stopTest();
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    @isTest static void testMethod7()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        SBC__c Sbc = new SBC__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
       
        SBC__c Sbc2 = Sbc.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{Sbc, Sbc2};
        
        insert SMERecords_List;
       
     Pending_correction__c PC7 = new Pending_correction__c( Implementation_Case__c = ord.id, SBC__c = Sbc.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC7};
         test.startTest();
        insert PCRecords_List;
       
       
        test.stopTest();
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    @isTest static void testMethod8()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Contracts__c Co = new Contracts__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
       
        Contracts__c Co2 = Co.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{Co, Co2};
        
        insert SMERecords_List;
       
      Pending_correction__c PC8 = new Pending_correction__c( Implementation_Case__c = ord.id, Contracts__c = Co.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC8};
         test.startTest();
        insert PCRecords_List;
       
      
        test.stopTest();
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    @isTest static void testMethod9()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        ID_Cards__c I = new ID_Cards__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '04 Approved');
       
        ID_Cards__c I2 = I.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{I, I2};
        
        insert SMERecords_List;
       
      Pending_correction__c PC9 = new Pending_correction__c( Implementation_Case__c = ord.id, ID_Cards__c = I.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC9};
         test.startTest();
        insert PCRecords_List;
       
     
        test.stopTest();
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    @isTest static void testMethod10()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Vision__c V = new Vision__c(Implementation_Tracking__c = ImpTrack.ID, Stage__c = '02 Work In Progress');
       
        Vision__c V2 = V.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{V, V2};
        
        insert SMERecords_List;
       
      Pending_correction__c PC10 = new Pending_correction__c( Implementation_Case__c = ord.id, Vision__c = V.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC10};
         test.startTest();
        insert PCRecords_List;
       
     
        test.stopTest();
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    @isTest static void testMethod11()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Life_and_Disability__c LD = new Life_and_Disability__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '03 Pending Correction', Sub_Stage__c = '');
       
        Life_and_Disability__c LD2 = LD.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{LD, LD2};
        
        insert SMERecords_List;
       
      Pending_correction__c PC11 = new Pending_correction__c( Implementation_Case__c = ord.id, Life_and_Disability__c = LD.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC11};
         test.startTest();
        insert PCRecords_List;
       
     
        test.stopTest();
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    @isTest static void testMethod12()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Dental_Complete__c D = new Dental_Complete__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '03 Pending Correction', Sub_Stage__c = '');
       
        Dental_Complete__c D2 = D.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{D, D2};
        
        insert SMERecords_List;
       
      Pending_correction__c PC12 = new Pending_correction__c( Implementation_Case__c = ord.id, Dental_Complete__c = D.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC12};
         test.startTest();
        insert PCRecords_List;
       
      
        test.stopTest();
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
        
        LGCarveOutResetBatchFlag m = new LGCarveOutResetBatchFlag(new Set<Id>{ord.Id});
        m.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(m,1);
    }
    @isTest static void testMethod13()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Underwriting__c UW = new Underwriting__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '03 Pending Correction');
       
        Underwriting__c UW2 = UW.clone();
        
        list<SObject> SMERecords_List = new list<SObject>{UW, UW2};
        
        insert SMERecords_List;
       
      Pending_correction__c PC13 = new Pending_correction__c( Implementation_Case__c = ord.id, Underwriting__c = UW.Id,Pending_Correction_Stage__c = 'Pending Correction Action',Ready_for_SMEs_Date_Completed__c = system.now() - 10,Pending_Response_From_SMEs_Date_Complete__c = system.now());
        
        list<SObject> PCRecords_List = new list<SObject>{PC13};
         test.startTest();
        insert PCRecords_List;
       
      test.stopTest();
         LGCarveOutTimeBatch p = new LGCarveOutTimeBatch();
         Database.executebatch(p,1);
         LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
         q.errorMap.put(ord.Id, 'Error Occoured');
        Database.executebatch(q,1);
    }
    
    @isTest static void testMethod14()
    {
       
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        ord.Tracking_Record_Exists__c = false;
        ord.Carve_Out_Process_Records__c = false;
         test.startTest();
        update ord;
        test.stopTest();
        Set<Id> ordId = new Set<Id>();
        ordId.add(ord.Id);
        
        
        LGCarveOutTimeBatch p = new LGCarveOutTimeBatch(ordId);
        Database.executebatch(p,1);
        
        LGCarveOutResetBatchFlag q = new LGCarveOutResetBatchFlag();
        q.errorMap.put(ord.Id, 'Error Occoured');
        
        Database.executebatch(q,1);
        
    }
    
    
}