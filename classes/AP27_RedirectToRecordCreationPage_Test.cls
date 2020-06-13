/* This is a test class for AP27_RedirectToRecordCreationPage 
*/

@isTest
private class AP27_RedirectToRecordCreationPage_Test {

private static final string NA ='Local Implementations'; 
private static Profile profileNA = [select id from profile where name=: NA];
private static User user = ANA_UTIL01_TestMethods.runAsUser(profileNA.id);  
    
 
static testMethod void getGsListTestGroupServices(){

/*User user = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', 
              EmailEncodingKey='UTF-8', LastName='fghdfh', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='test2314@testorg.com');
 insert user;*/
 system.runAs(user)
        {  
            test.startTest();
            
            Account acc = new Account(Name = 'Test Acc',Anthem_Entity__c = 'National Accounts',Region__c='Central',
                              Branding__c = 'UniCare',ApprovedByOutsourcing__c= true);
            insert Acc;
            //Account acc = ANA_UTIL01_TestMethods.createAccount(false); 
            //insert acc;
            //Creating Opportunity Records
            
            Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
            insert opty; 
            
            Quote qte = ANA_UTIL01_TestMethods.createQuote(true,opty.Id);
            //insert(qte);
            
            Product2 prod = ANA_UTIL01_TestMethods.createProduct(false);
            prod.Name = 'AIM: A La Carte';
            insert(prod);
            
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
            insert(pbe);
            
            QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(true,qte.Id, pbe.id);
            qli.ProductStage__c='Sold';
            qli.Financing__c='JAA (Jointly Administered Arrangement)';
            update qli;
            
           /* Group__c grp1 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            grp1.ClaimSystem__c = 'NASCO';    
            insert(grp1); */
            
            Group__c grp1 = new Group__c(Account__c=acc.id);
            grp1.ClaimSystem__c='NASCO';
            grp1.IsActive__c=true;
            insert(grp1);
            
            Group__c grp2 = new Group__c(Account__c=acc.id);
            grp2.ClaimSystem__c='WGS 2.0';
            grp2.IsActive__c=true;
            insert(grp2);
            
           
            
            
            qte.GroupNumber__c = grp1.id;
            qte.GroupNumber__c = grp2.id;
         
            update qte;
            
            Order ord = new Order(Group_Name__c=grp2.id,AccountId = acc.Id, EffectiveDate=System.today(), 
            Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes',
            Implementation_Status__c = 'Initiated', Implementation_Effective_Date__c=System.today(),
            Assigned_Implementer__c=user.id,QuoteId=qte.id);  
            insert ord;
 
            system.debug('!!!sord'+ord);
 
           // Implementation_Tracking__c imt = New Implementation_Tracking__c(Account_Legal_Name__c=acc.Id,Group_Number__c=grp3.id,Implementation_Record_ID__c=ord.Id);
            Implementation_Tracking__c imt = New Implementation_Tracking__c();
            imt.Group_Number__c = grp1.id;
            imt.Implementation_Record_ID__c = ord.Id;
            insert imt;
            Implementation_Tracking__c imt1 = New Implementation_Tracking__c();
            imt1.Group_Number__c = grp2.id;
            imt1.Implementation_Record_ID__c = ord.Id;
            insert imt1;
            system.debug('Implementation_Tracking object inserted');
 
            Group_services__c gs = new Group_services__c(Is_Benefit_Updates_Applicable__c= 'Yes',Is_CDHP_Applicable__c= 'Yes', Is_Eligibility_Applicable__c= 'Yes', 
               Is_GS_General_Information_Applicable__c = 'Yes',Is_Group_Structure_Applicable__c = 'Yes', Is_Group_Updates_Applicable__c ='Yes',
               Is_HPCC_Updates_Applicable__c = 'Yes', Is_Group_Services_Migration_Applicable__c= 'Yes',
               Is_Tables_Data_Sets_Misc_Applicable__c= 'Yes',Implementation_Tracking_ID__c=imt.id,Is_This_A_COBRA_Only_File__c='Yes',Production_Enrollment_File_Status__c='Yes');
               insert gs;
             Group_services__c gs1 = new Group_services__c(Is_Benefit_Updates_Applicable__c= 'Yes',Is_CDHP_Applicable__c= 'Yes', Is_Eligibility_Applicable__c= 'Yes', 
               Is_GS_General_Information_Applicable__c = 'Yes',Is_Group_Structure_Applicable__c = 'Yes', Is_Group_Updates_Applicable__c ='Yes',
               Is_HPCC_Updates_Applicable__c = 'Yes', Is_Group_Services_Migration_Applicable__c= 'Yes',
               Is_Tables_Data_Sets_Misc_Applicable__c= 'Yes',Implementation_Tracking_ID__c=imt1.id,Is_This_A_COBRA_Only_File__c='Yes',Production_Enrollment_File_Status__c='Yes');
               insert gs1;
              system.debug('Group_services object inserted');
      // user.BypassValidation__c = true;
          

         
 
           AP27_RedirectToRecordCreationPage.getGsList(gs.id);
           AP27_RedirectToRecordCreationPage.getGsList(gs1.id);

  
            test.stopTest();
            system.assert(true); 
            
        }
}




static testMethod void getGsListTestNewImplCordACESGroup(){


 system.runAs(user)
        {  
            test.startTest();
            
            Account acc = new Account(Name = 'Test Acc',Anthem_Entity__c = 'National Accounts',Region__c='Central',
                              Branding__c = 'UniCare',ApprovedByOutsourcing__c= true);
            insert Acc;
            //Account acc = ANA_UTIL01_TestMethods.createAccount(false); 
            //insert acc;
            //Creating Opportunity Records
            
            Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
            insert opty; 
            
            Quote qte = ANA_UTIL01_TestMethods.createQuote(true,opty.Id);
            //insert(qte);
            
            Product2 prod = ANA_UTIL01_TestMethods.createProduct(false);
            prod.Name = 'AIM: A La Carte';
            insert(prod);
            
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
            insert(pbe);
            
            QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(true,qte.Id, pbe.id);
            qli.ProductStage__c='Sold';
            qli.Financing__c='JAA (Jointly Administered Arrangement)';
            update qli;
           
            
            Group__c grp1 = new Group__c(Account__c=acc.id);
            grp1.ClaimSystem__c='ACES';
            grp1.IsActive__c=true;
            insert(grp1);
            
            
            
            qte.GroupNumber__c = grp1.id;
           
         
            update qte;
            
            Order ord = new Order(Group_Name__c=grp1.id,AccountId = acc.Id, EffectiveDate=System.today(), 
            Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes',
            Implementation_Status__c = 'Initiated', Implementation_Effective_Date__c=System.today(),
            Assigned_Implementer__c=user.id,QuoteId=qte.id);  
            insert ord;
 
            system.debug('!!!sord'+ord);
 
           // Implementation_Tracking__c imt = New Implementation_Tracking__c(Account_Legal_Name__c=acc.Id,Group_Number__c=grp3.id,Implementation_Record_ID__c=ord.Id);
            Implementation_Tracking__c imt = New Implementation_Tracking__c();
            imt.Group_Number__c = grp1.id;
            imt.Implementation_Record_ID__c = ord.Id;
            insert imt;
          
            
                      system.debug('Implementation_Tracking object inserted');
 
            Group_services__c gs = new Group_services__c(Is_Benefit_Updates_Applicable__c= 'Yes',Is_CDHP_Applicable__c= 'Yes', Is_Eligibility_Applicable__c= 'Yes', 
               Is_GS_General_Information_Applicable__c = 'Yes',Is_Group_Structure_Applicable__c = 'Yes', Is_Group_Updates_Applicable__c ='Yes',
               Is_HPCC_Updates_Applicable__c = 'Yes', Is_Group_Services_Migration_Applicable__c= 'Yes',
               Is_Tables_Data_Sets_Misc_Applicable__c= 'Yes',Implementation_Tracking_ID__c=imt.id,Is_This_A_COBRA_Only_File__c='Yes',Production_Enrollment_File_Status__c='Yes');
               insert gs;
           
              system.debug('Group_services object inserted');
      // user.BypassValidation__c = true;
          
Id recordTypeId12 = Schema.SObjectType.Implementation_Coordinator__c.getRecordTypeInfosByName().get('JAA National And Local NASCO').getRecordTypeId();
            
Implementation_Coordinator__c icc = new Implementation_Coordinator__c(recordTypeId=recordTypeId12,
    Is_Advantage_Networks_Applicable__c= 'Yes',Is_AHG_Applicable__c= 'Yes',Is_CDH_Applicable__c= 'Yes',
                                 Is_Group_Structure_Applicable__c= 'Yes',Is_Medical_Benefits_Applicable__c= 'Yes',Is_Pharmacy_Applicable__c= 'Yes',
                                 Is_SME_Area_Status_Applicable__c= 'Yes',Is_SSCRs_Applicable__c= 'Yes',Is_Status_Details_Applicable__c= 'Yes',Implementation_Tracking_ID__c=imt.id);
                        
insert icc;

 
           AP27_RedirectToRecordCreationPage.getGsList(gs.id);
           AP27_RedirectToRecordCreationPage.getGsList(icc.id);
           

  
            test.stopTest();
            system.assert(true); 
            
        }
}


static testMethod void getGsListTestImplCord(){

/*User user = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', 
              EmailEncodingKey='UTF-8', LastName='fghdfh', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='test2314@testorg.com');
 insert user;*/
 system.runAs(user)
        {  
            test.startTest();
            
            Account acc = new Account(Name = 'Test Acc',Anthem_Entity__c = 'National Accounts',Region__c='Central',
                              Branding__c = 'UniCare',ApprovedByOutsourcing__c= true);
            insert Acc;
            //Creating Opportunity Records
            
            Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
            insert opty; 
            
            Quote qte = ANA_UTIL01_TestMethods.createQuote(true,opty.Id);
            
            Product2 prod = ANA_UTIL01_TestMethods.createProduct(false);
            prod.Name = 'AIM: A La Carte';
            insert(prod);
            
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
            insert(pbe);
            
            QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(true,qte.Id, pbe.id);
            qli.ProductStage__c='Sold';
            qli.Financing__c='JAA (Jointly Administered Arrangement)';
            update qli;
            
            Group__c grp1 = new Group__c(Account__c=acc.id);
            grp1.ClaimSystem__c='NASCO';
            grp1.IsActive__c=true;
            insert(grp1);
            
            Group__c grp2 = new Group__c(Account__c=acc.id);
            grp2.ClaimSystem__c='WGS 2.0';
            grp2.IsActive__c=true;
            insert(grp2);
            
           
            
            
            qte.GroupNumber__c = grp1.id;
            qte.GroupNumber__c = grp2.id;
         
            update qte;
            
            Order ord = new Order(Group_Name__c=grp2.id,AccountId = acc.Id, EffectiveDate=System.today(), 
            Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes',
            Implementation_Status__c = 'Initiated', Implementation_Effective_Date__c=System.today(),
            Assigned_Implementer__c=user.id,QuoteId=qte.id);  
            insert ord;
 
            system.debug('!!!sord'+ord);
 
           // Implementation_Tracking__c imt = New Implementation_Tracking__c(Account_Legal_Name__c=acc.Id,Group_Number__c=grp3.id,Implementation_Record_ID__c=ord.Id);
            Implementation_Tracking__c imt = New Implementation_Tracking__c();
            imt.Group_Number__c = grp1.id;
            imt.Implementation_Record_ID__c = ord.Id;
            insert imt;
            Implementation_Tracking__c imt1 = New Implementation_Tracking__c();
            imt1.Group_Number__c = grp2.id;
            imt1.Implementation_Record_ID__c = ord.Id;
            insert imt1;
            system.debug('Implementation_Tracking object inserted');
 
           
          
Id recordTypeId12 = Schema.SObjectType.Implementation_Coordinator__c.getRecordTypeInfosByName().get('JAA National And Local NASCO').getRecordTypeId();
            
Implementation_Coordinator__c icc = new Implementation_Coordinator__c(recordTypeId=recordTypeId12,
    Is_Advantage_Networks_Applicable__c= 'Yes',Is_AHG_Applicable__c= 'Yes',Is_CDH_Applicable__c= 'Yes',
                                 Is_Group_Structure_Applicable__c= 'Yes',Is_Medical_Benefits_Applicable__c= 'Yes',Is_Pharmacy_Applicable__c= 'Yes',
                                 Is_SME_Area_Status_Applicable__c= 'Yes',Is_SSCRs_Applicable__c= 'Yes',Is_Status_Details_Applicable__c= 'Yes',Implementation_Tracking_ID__c=imt1.id);
                        
insert icc;
Implementation_Coordinator__c icc1 = new Implementation_Coordinator__c(recordTypeId=recordTypeId12,
    Is_Advantage_Networks_Applicable__c= 'Yes',Is_AHG_Applicable__c= 'Yes',Is_CDH_Applicable__c= 'Yes',                                 Is_Group_Structure_Applicable__c= 'Yes',Is_Medical_Benefits_Applicable__c= 'Yes',Is_Pharmacy_Applicable__c= 'Yes',
                                 Is_SME_Area_Status_Applicable__c= 'Yes',Is_SSCRs_Applicable__c= 'Yes',Is_Status_Details_Applicable__c= 'Yes',Implementation_Tracking_ID__c=imt.id);
                        
insert icc1;
         
 
          
           AP27_RedirectToRecordCreationPage.getGsList(icc.id);
            AP27_RedirectToRecordCreationPage.getGsList(icc1.id);

  
            test.stopTest();
            system.assert(true); 
            
        }
}

}