/**************************************************************************************
Apex Class Name:  LGSMENotApproved_Test
Version     : -- 
Created Date    : --
* @Author: --
Modified By - Sharath KN - 12-Aug-2019 - Added Substage values for Vision,Dental and 'Life And Disability' objects in test data.  
*************************************************************************************/
@isTest
public class LGSMENotApproved_Test
{
    @testSetup public static void LGSMENotApproved_TestDataSetup() 
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
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Enrollment_and_Billing__c EB = new Enrollment_and_Billing__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
        InterPlan__c IP = new InterPlan__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '02 Work In Progress');
        Issue_Control__c IC = new Issue_Control__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '02 Work In Progress');
      
        Medical_Benefit__c med= new Medical_Benefit__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '04 Approved');
        First_Impressions__c fi= new First_Impressions__c(First_Impressions_Type__c='Medical',Implementation_Tracking_ID__c = ImpTrack.ID,Is_This_A_Standard_Or_Modified_Request__c='Standard',First_Impressions_Stage__c = '04 Approved');
        
        Rx__c Rx = new Rx__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
        SBC__c Sbc = new SBC__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
       

        Enrollment_and_Billing__c EB2 = EB.clone();
        InterPlan__c IP2 = IP.clone();
        Issue_Control__c IC2 = IC.clone();
        Medical_Benefit__c med2 = med.clone();
        First_Impressions__c fi2 = fi.clone();
        Rx__c Rx2 = Rx.clone();
        SBC__c Sbc2 = Sbc.clone();
        
        
        list<SObject> SMERecords_List = new list<SObject>{EB, EB2, IP, IP2, IC, IC2, med, med2, fi, fi2, Sbc, Sbc2, Rx, Rx2};
        
        insert SMERecords_List;
        
        test.startTest();
        LGSMENotApproved l=new LGSMENotApproved();
        Database.executebatch(l,1);
        test.stopTest();
    }
    
    public static  testMethod void method2()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
      
        Contracts__c Co = new Contracts__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
        ID_Cards__c i= new ID_Cards__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '04 Approved');
        Vision__c V = new Vision__c(Implementation_Tracking__c = ImpTrack.ID, Stage__c = '02 Work In Progress', Sub_Stage__c = '');
        Life_and_Disability__c LD = new Life_and_Disability__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '03 Pending Correction', Sub_Stage__c='');
        Dental_Complete__c D = new Dental_Complete__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '03 Pending Correction', Sub_Stage__c = '');
        Underwriting__c UW = new Underwriting__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '03 Pending Correction');
        
        Contracts__c Co2 = Co.clone();
        ID_Cards__c I2 = I.clone();
        Vision__c V2 = V.clone();
        Life_and_Disability__c LD2 = LD.clone();
        Dental_Complete__c D2 = D.clone();
        Underwriting__c UW2 = UW.clone();
     
        
        list<SObject> SMERecords_List = new list<SObject>{Co, Co2, I2, I, V2, V, LD2, LD, D2, D, UW2, UW};
        insert SMERecords_List;
    
        test.startTest();
        
        Database.executebatch(new LGSMENotApproved(),1);
        
        test.stopTest();
    
    }
    public static  testMethod void method3()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
      
        Contracts__c Co2 = new Contracts__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '');
        ID_Cards__c i2= new ID_Cards__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '');
        Vision__c V2 = new Vision__c(Implementation_Tracking__c = ImpTrack.ID, Stage__c = '', Sub_Stage__c = '');
        Life_and_Disability__c LD2 = new Life_and_Disability__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '', Sub_Stage__c = '');
        Dental_Complete__c D2 = new Dental_Complete__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '', Sub_Stage__c = '');
        Underwriting__c UW2 = new Underwriting__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '');
        
   
        list<SObject> SMERecords_List = new list<SObject>{Co2, I2, V2, LD2, D2,UW2};
        insert SMERecords_List;
  

        test.startTest();
        
        Database.executebatch(new LGSMENotApproved(),1);
        
        test.stopTest();
        
    }
     public static  testMethod void method4()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
      
       Enrollment_and_Billing__c EB2 = new Enrollment_and_Billing__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '');
        InterPlan__c IP2 = new InterPlan__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '');
        Issue_Control__c IC2 = new Issue_Control__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '');
      
        Medical_Benefit__c med2= new Medical_Benefit__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '');
        First_Impressions__c fi2= new First_Impressions__c(First_Impressions_Type__c='Medical',Implementation_Tracking_ID__c = ImpTrack.ID,Is_This_A_Standard_Or_Modified_Request__c='Standard',First_Impressions_Stage__c = '');
        
        Rx__c Rx2 = new Rx__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '');
        SBC__c Sbc2 = new SBC__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '');
   
        list<SObject> SMERecords_List = new list<SObject>{EB2, IP2, IC2, med2, fi2, Rx2, Sbc2};
        insert SMERecords_List;
  

        test.startTest();
        
        Database.executebatch(new LGSMENotApproved(),1);
        
        test.stopTest();
        
    }
     public static  testMethod void method5()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
         Vision__c V = new Vision__c(Implementation_Tracking__c = ImpTrack.ID, Stage__c = '02 Work In Progress', Sub_Stage__c = '');
        Life_and_Disability__c LD = new Life_and_Disability__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '03 Pending Correction', Sub_Stage__c = '');
      
        list<SObject> SMERecords_List = new list<SObject>{V,LD};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
     public static  testMethod void method6()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Life_and_Disability__c LD = new Life_and_Disability__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '03 Pending Correction', Sub_Stage__c = '');
         Enrollment_and_Billing__c EB = new Enrollment_and_Billing__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
      
        list<SObject> SMERecords_List = new list<SObject>{LD};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
    public static  testMethod void underwritingElseTest()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        Underwriting__c UW = new Underwriting__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '03 Pending Correction');
      
        list<SObject> SMERecords_List = new list<SObject>{UW};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
     public static  testMethod void eabElseTest()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
         Enrollment_and_Billing__c EB = new Enrollment_and_Billing__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
      
        list<SObject> SMERecords_List = new list<SObject>{EB};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
     public static  testMethod void interplanElseTest()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
        InterPlan__c IP = new InterPlan__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '02 Work In Progress');
       
      
        list<SObject> SMERecords_List = new list<SObject>{IP};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
    public static  testMethod void issueCtrlElseTest()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
       
        Issue_Control__c IC = new Issue_Control__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '02 Work In Progress');
      
        list<SObject> SMERecords_List = new list<SObject>{IC};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
     public static  testMethod void rXElseTest()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
       
        Rx__c Rx = new Rx__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
      
        list<SObject> SMERecords_List = new list<SObject>{Rx};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
     public static  testMethod void sbcElseTest()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
       
     
        SBC__c Sbc = new SBC__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
      
        list<SObject> SMERecords_List = new list<SObject>{Sbc};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
     public static  testMethod void contractElseTest()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
       
       Contracts__c Co = new Contracts__c(Implementation_Tracking_ID__c = ImpTrack.ID, Stage__c = '04 Approved');
      
        list<SObject> SMERecords_List = new list<SObject>{Co};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
       public static  testMethod void idCardElseTest()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
       
       ID_Cards__c idc= new ID_Cards__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '04 Approved');
      
        list<SObject> SMERecords_List = new list<SObject>{idc};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
     public static  testMethod void firstImpElseTest()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= true;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
   
        First_Impressions__c fi= new First_Impressions__c(First_Impressions_Type__c='Medical',Implementation_Tracking_ID__c = ImpTrack.ID,Is_This_A_Standard_Or_Modified_Request__c='Standard',First_Impressions_Stage__c = '04 Approved');
      
        list<SObject> SMERecords_List = new list<SObject>{fi};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
       public static  testMethod void medicalBenefitElseTest()
    {
        Order ord = [SELECT Id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' LIMIT 1];
        
        Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
        ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
        
        //ImpTrack.RecordTypeId1 = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('National NASCO and WGS').getRecordTypeId();
        ImpTrack.Implementation_Record_ID__c = ord.Id;
        ImpTrack.Engage_Medical_Benefits__c= false;
        insert ImpTrack;
        system.debug('ImpTrack.ID@@@:'+ImpTrack.ID);
        
       
       Medical_Benefit__c med= new Medical_Benefit__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '04 Approved');
      
        list<SObject> SMERecords_List = new list<SObject>{med};
        insert SMERecords_List;
        test.startTest();
        Database.executebatch(new LGSMENotApproved(),1);
        test.stopTest();
    }
      
}