@isTest
public class IDCardActions_Test
{
    @testSetup static void idCardRecordCreation_TestDataSetup() 
    {
        Sic__c Sic = new Sic__c(Name = staticVariableClass.SIC);
        Insert Sic;
        
        Account acc =new Account
            (
                RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Account).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGProspect).getRecordTypeId(),
                Name = staticVariableClass.AccountName,Account_s_Suppress_Auto_Renewal__c = false,Anthem_Entity__c = staticVariableClass.Entity,
                Region__c= staticVariableClass.Region, Branding__c =staticVariableClass.UniCare,SIC__c = SIC.Id,Group_Size__c =staticVariableClass.size,
                Total_Employees__c =staticVariableClass.emp, HQ_State__c =staticVariableClass.AK, Situs_State__c = staticVariableClass.California,
                Mailing_Address_Same_as_Physical_Address__c = true, BillingStreet = staticVariableClass.testAccBillingStreet, 
                BillingPostalCode = staticVariableClass.testAccBillingPostalCode,BillingCity =staticVariableClass.testAccBillingCity, 
                BillingCountry = staticVariableClass.testAccBillingCountry, BillingState = staticVariableClass.testAccBillingState, Physical_County__c =staticVariableClass.GroupNum
            );
        insert acc;
        
        List<Id> lstOpp= new List<Id>();
        
        Opportunity newOpp = new Opportunity(Name=  (String.valueOf(system.today().year() + 1) + staticVariableClass.NewBusinessLocalhyphen + acc.Name), 
                                             StageName = staticVariableClass.ClosedWon, AccountID = acc.id, CloseDate = ((system.TODAY())-95),                   
                                             RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Opportunity).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.NewBusinessLocal).getRecordTypeId());
        INSERT newOpp;
        
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        insert grp;
        
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,newOpp.Id);
        qte.GroupNumber__c=grp.id;
        insert qte;
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name= :staticVariableClass.LocalImplementations]; 
        User user2 = new User(Alias = staticVariableClass.userAlias, Email=staticVariableClass.userEmail, EmailEncodingKey=staticVariableClass.userEmailEncodingKey, LastName=staticVariableClass.userLastName, 
                              LanguageLocaleKey=staticVariableClass.userLocaleSidKey, LocaleSidKey=staticVariableClass.userLocaleSidKey, ProfileId = p1.Id, TimeZoneSidKey=staticVariableClass.userTimeZoneSidKey, 
                              UserName=staticVariableClass.userUsername);
        insert user2;
        
        Order ord = new Order(Group_Name__c=grp.id,AccountId = acc.Id, EffectiveDate=System.today(), Status = staticVariableClass.Draft,User_Group__c =staticVariableClass.LocalNewBusiness,
                              Implementation_Case_Name__c = staticVariableClass.AIMTesting03, Discovery_Call_Desired__c =staticVariableClass.UpsellYes, Implementation_Status__c = staticVariableClass.ReadyforImps, 
                              Implementation_Effective_Date__c=System.today(), Assigned_Implementer__c=user2.id,QuoteId=qte.id);
        
        insert new list<Order>{ord};
     }

     @isTest static void populateIDcardAssignedImplementerTestMethod() {
        
        Test.startTest();
        
        //List For ID card 
        List<ID_Cards__c> idCardList1 = new List<ID_Cards__c>();
        List<ID_Cards__c> idCardList = new List<ID_Cards__c>();
        
        //Set for ID card
        Set<ID> idCardIDSet = new Set<ID>();
       
       //Fetch User
        List<User> userList =[Select id from User where email =:staticVariableClass.userEmail LIMIT 1];
       
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
        
        for(Integer i=0;i<=10;i++){
        ID_Cards__c idCard= new ID_Cards__c(Implementation_Tracking_ID__c = localImpTrack.ID,Stage__c = UtilConstants.PENDING_CARD_NOT_STARTED_01);
        idCardList.add(idCard);
        }
        if(!idCardList.isEmpty()){
            insert idCardList;
        }
        
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
}