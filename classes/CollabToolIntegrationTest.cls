/**
** Test Class : CollabToolIntegrationTest
**/
@isTest(SeeAllData=false)
public class CollabToolIntegrationTest{

public static testMethod void testmethod_insertParentChildQli() {

        Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
        
    try{   
    	insert acc1; 
        system.debug('-- Account : acc1.Id ---'+acc1.Id);
    }catch(DMLException e){
        system.debug('-- Account insertion failed -- '+e.getMessage());
    }
    
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc1.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),//system.TODAY(),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '51-99',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'Pending'
        );
 
      try{   
    	  insert cmgtest1; 
          System.debug('----cmgtest1' + cmgtest1);
       }catch(DMLException e){
         system.debug('-- Collab Migrated Group insertion failed -- '+e.getMessage());
       }
    
        //required fields null check        
        Collab_Migrated_Group__c cmgtest2 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c = null , 
                    Collab_AccountId__c = null , 
                    Migration_Date__c = null ,
                    Legacy_Claim_System__c = null , 
                    Legacy_Group_Number__c = null, 
                    WGS_Group_Number__c = null,
                    Account_Legal_Name__c = 'CDE Home', 
                    Situs_State__c = 'Alabama',  
                    Group_Size__c = '51-99',
                    Account_Manager__c = 'CDE123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
       try{
           insert cmgtest2;
           System.debug('----Collab Group migrated products ' + cmgtest2);
       }catch(DMLException e){
         system.debug('-- Collab Migrated Group required fields null insertion failed -- '+e.getMessage());
       }

        Group__c g1 = new Group__c( Account__c = acc1.Id,
                                    Name = cmgtest1.Legacy_Group_Number__c,//'test Group',
                                    ClaimSystem__c = cmgtest1.Legacy_Claim_System__c
                                  );

        try{
           insert g1;
           System.debug('---- Legacy Group record ' + g1);
        } catch(DMLException e){
         system.debug('-- Legacy Group record insertion failed -- '+e.getMessage());
        }
    
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Local').getRecordTypeId();

        Opportunity opp1 = new Opportunity(
                                            Name = 'test opp1',
                                            RecordTypeId = RecordTypeIdOpportunity,
                                            AccountId = acc1.Id,
                                            Closedate = cmgtest1.Migration_Date__c,
            								StageName = 'Closed Won'
                                          );

        try{
           insert opp1;
           System.debug('---- Opportunity record ' + opp1);
        } catch(DMLException e){
         system.debug('-- Opportunity record insertion failed -- '+e.getMessage());
        }
    
        Collab_Migrated_Group_Products__c cmgptest1 = new Collab_Migrated_Group_Products__c (
                                                              Collab_Migrated_Group__c = cmgtest1.Id,
                                                              Benefit_Period__c = 'Benefit Year',// N - Benefit Year, "Y = Calender Year
                                                              Contract_Code__c = '34EE', 
                                                              Funding_Type__c = 'Fully Insured', //Fully Insured, null
                                                              HPCC_Code__c = '', //null
                                                              Incentive_Type__c = '',//null 
                                                              LOB__c ='Medical',
            												  Group_Size__c = '12,500+'//'100-249'
                                                            );
        
         try{
           insert cmgptest1;
           System.debug('---- Collabtool migrated Group Records --- ' + cmgptest1);
        } catch(DMLException e){
          system.debug('-- Collabtool migrated Group record insertion failed -- '+e.getMessage());
        }       

        Product2 prod1 = new Product2(Name = 'Product- See Notes',
                                IsActive = true,
                                Contract_code__c= '34EE',
                                Plan_Type__c = 'Modified',
                                LOB__c='Medical',
                                productActive__c = true
                                );
        try{
           insert prod1;
           System.debug('---- Parent Product Records --- ' + prod1);
        } catch(DMLException e){
         system.debug('-- Parent Product record insertion failed -- '+e.getMessage());
        } 
    
    	System.debug(' Parent PRODUCT 1' + prod1);
        
        Product2 prod2 = new Product2(Name = 'Anthem Blue Access PPO HRAs Option E4-M',
                                IsActive = true,
                                vlocity_ins__ProductSpecId__c = prod1.Id,
                                Contract_code__c= '34EE',
                                vlocity_ins__SubType__c='Other',
                                Plan_Type__c = 'Modified',
                                LOB__c='Medical',
                                productActive__c = true
                                );

        try{
           insert prod2;
           System.debug('---- Child Product Records --- ' + prod2);
        } catch(DMLException e){
         system.debug('-- Child Product record insertion failed -- '+e.getMessage());
        } 
    
    	System.debug('Child PRODUCT 2' + prod2);
        

        Id pricebookId = Test.getStandardPricebookId();//IsStandard=true */
        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);
        try{
            update pb2;
            System.debug('---- Standard PriceBook Record --- ' + pb2);
        } catch(DMLException e){
           system.debug('-- Standard PriceBook Record failed -- '+e.getMessage());
        }
    
        PricebookEntry standardPriceBookEntry1 = new PricebookEntry( Pricebook2Id = pb2.Id,
                                                        Product2Id = prod1.Id, UnitPrice = 1, IsActive = true);

       try{ 
           insert standardPriceBookEntry1;
           System.debug('---- Standard PriceBookEntry - 1 Record --- ' + standardPriceBookEntry1);
       }catch(DMLException e){
           system.debug('-- Standard PriceBookEntry - 1 Record failed -- '+e.getMessage());
       }
    

        PricebookEntry standardPriceBookEntry2 = new PricebookEntry( Pricebook2Id = pb2.Id, 
                                                           Product2Id = prod2.Id, UnitPrice = 1, IsActive = true);
       try{ 
           insert standardPriceBookEntry2;
           System.debug('---- Standard PriceBookEntry - 2 Record --- ' + standardPriceBookEntry2);
       }catch(DMLException e){
           system.debug('-- Standard PriceBookEntry - 2 Record failed -- '+e.getMessage());
       }
    
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest();
    
    
        Account acc = [Select Id, Name , Group_Size__c, Situs_State__c from Account];
        system.debug('--- acc --'+acc);
        system.assertEquals('Unique ABC Home', acc.Name);
        system.assertEquals('51 - 99', acc.Group_Size__c);
        system.assertEquals('Ohio', acc.Situs_State__c); 
        system.assertEquals(1, [Select count() from Group__c where ClaimSystem__c = 'WGS 2.0']);// validating new WGS Group inserted
        system.assertEquals(1, [Select count() from Quote ]); 
    
        QuoteLineItem qli2 = [Select Id, Group_Size__c from QuoteLineItem where Group_Size__c = '1000+'];
        system.debug('--- qli2 ---'+qli2);
        system.assertEquals('1000+', qli2.Group_Size__c); 
        
}

public static testMethod void testmethod_noCom2AccountRecordFound() {
        
     Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '1000+',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
        
        try{
           insert acc1; 
           system.debug('-- acc1.Id ---'+acc1.Id);
        }catch(DMLException e){
           system.debug('-- Account Record insertion failed -- '+e.getMessage());
        }
        
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   '001xa000003FFlo',
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),//system.TODAY(),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '1000+',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
        try{
         insert cmgtest1;
         System.debug('----cmgtest1' + cmgtest1);
        }catch(DMLException e){
           system.debug('-- Collab Migrated Group Record insertion failed -- '+e.getMessage());
        }
    
        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);
        try{
           update pb2;
           System.debug('----pb2' + pb2);
        }catch(DMLException e){
           system.debug('-- Pricebook2 Record insertion failed -- '+e.getMessage());
        }
    
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest();
    
        Account com2Acc = [Select Id, Name , Group_Size__c, Situs_State__c from Account];
        system.debug('--- com2Acc --'+com2Acc);
    
        // validate Com2 Account record
        system.assertEquals(0, [Select count() from Account where Id = :cmgtest1.Com2_Account_Id__c]);
}
    
    
public static testMethod void testmethod_noContractCodeRecordsFromCollab() {
        Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '100 - 249',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
       try{  
            insert acc1;
            System.debug('---- Account Record --- ' + acc1);
       }catch(DMLException e){
           system.debug('-- Account Record failed -- '+e.getMessage());
       }    
        
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc1.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),//system.TODAY(),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '100-249',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
        try{ 
              insert cmgtest1;
              System.debug('----cmgtest1' + cmgtest1);
        }
        catch(DMLException e){
           system.debug('-- Collbtool Group Record insertion failed -- '+e.getMessage());
       } 

        Account acc2 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc2',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
       try{  
            insert acc2;
            System.debug('---- Account Record --- ' + acc2);
       }catch(DMLException e){
           system.debug('-- Account Record failed -- '+e.getMessage());
       }  
    
        Collab_Migrated_Group__c cmgtest2 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc2.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),//system.TODAY(),
                    Legacy_Claim_System__c = 'XYZ' , 
                    Legacy_Group_Number__c = 'L22222', 
                    WGS_Group_Number__c = 'W33333',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '51-99',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
        try{ 
              insert cmgtest2;
              System.debug('----cmgtest2' + cmgtest2);
        }
        catch(DMLException e){
           system.debug('-- Collbtool Group Record insertion failed -- '+e.getMessage());
       }     

         Collab_Migrated_Group_Products__c cmgptest1 = new Collab_Migrated_Group_Products__c (
                                                              Collab_Migrated_Group__c = cmgtest2.Id,
                                                              Benefit_Period__c = 'Benefit Year',// N - Benefit Year, "Y = Calender Year
                                                              Contract_Code__c = '34EE', 
                                                              Funding_Type__c = 'Fully Insured', //Fully Insured, null
                                                              HPCC_Code__c = '', //null
                                                              Incentive_Type__c = '',//null 
                                                              LOB__c ='M'
                                                            );
        
         try{
           insert cmgptest1;
           System.debug('---- Collabtool migrated Group Records --- ' + cmgptest1);
        } catch(DMLException e){
          system.debug('-- Collabtool migrated Group record insertion failed -- '+e.getMessage());
        } 
    
        Group__c g1 = new Group__c( Account__c = acc1.Id,
                                      ClaimSystem__c = 'ABC',
                                      Name = 'L11111'
                                  );
        try{
         insert g1;
         System.debug('----g1' + g1);
        }catch(DMLException e){
           system.debug('-- Group Record insertion failed -- '+e.getMessage());
        }
    
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Local').getRecordTypeId();

        Opportunity opp1 = new Opportunity(
                                            Name = 'test opp1',
                                            RecordTypeId = RecordTypeIdOpportunity,
                                            AccountId = acc1.Id,
                                            Closedate = cmgtest1.Migration_Date__c,
            								StageName = 'Closed Won'
                                          );

        try{
           insert opp1;
           System.debug('---- Opportunity record ' + opp1);
        } catch(DMLException e){
         system.debug('-- Opportunity record insertion failed -- '+e.getMessage());
        }    

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);
        try{
            update pb2;
            System.debug('---- Standard PriceBook Record --- ' + pb2);
        } catch(DMLException e){
           system.debug('-- Standard PriceBook Record failed -- '+e.getMessage());
        }
    
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest();
        
        // select from contract code recrods from Collabtool
        system.assertEquals(0, [Select count() from Collab_Migrated_Group_Products__c where Collab_Migrated_Group__c = :cmgtest1.Id]);
}
    
public static testMethod void testmethod_wgsGroupExist() {
        
     Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '1000+',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
        
        try{
           insert acc1; 
           system.debug('-- acc1.Id ---'+acc1.Id);
        }catch(DMLException e){
           system.debug('-- Account Record insertion failed -- '+e.getMessage());
        }
        
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc1.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),//system.TODAY(),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '1000+',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
        try{
         insert cmgtest1;
         System.debug('----cmgtest1' + cmgtest1);
        }catch(DMLException e){
           system.debug('-- Collab Migrated Group Record insertion failed -- '+e.getMessage());
        }
    
        Group__c g1 = new Group__c( Account__c = acc1.Id,
                                      ClaimSystem__c = 'WGS 2.0',
                                      Name = 'W22222'
                                  );
        try{
         insert g1;
         System.debug('----g1' + g1);
        }catch(DMLException e){
           system.debug('-- Group Record insertion failed -- '+e.getMessage());
        }
        //insert matching Legacy Group record
        Group__c g2 = new Group__c( Account__c = acc1.Id,
                                      ClaimSystem__c = 'ABC',
                                      Name = 'L11111'
                                  );
        try{
         insert g2;
         System.debug('----g2' + g2);
        }catch(DMLException e){
           system.debug('-- Group Record insertion failed -- '+e.getMessage());
        }
    
        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);
        try{
           update pb2;
           System.debug('----pb2' + pb2);
        }catch(DMLException e){
           system.debug('-- Pricebook2 Record insertion failed -- '+e.getMessage());
        }
    
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest();
    
        Account acc2 = [Select Id, Name , Group_Size__c, Situs_State__c from Account];
        system.debug('--- acc2 --'+acc2);
    
        // validate WGS Group exists
        system.assertEquals(1, [Select count() from Group__c where Name = 'W22222' and ClaimSystem__c = 'WGS 2.0' ]);
}

    public static testMethod void testmethod_legacyGroupNotFound() {
        
     Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
        
        try{
           insert acc1; 
           system.debug('-- acc1.Id ---'+acc1.Id);
        }catch(DMLException e){
           system.debug('-- Account Record insertion failed -- '+e.getMessage());
        }
        
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc1.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),//system.TODAY(),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '51 - 99',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
        try{
         insert cmgtest1;
         System.debug('----cmgtest1' + cmgtest1);
        }catch(DMLException e){
           system.debug('-- Collab Migrated Group Record insertion failed -- '+e.getMessage());
        }
    
        Group__c g1 = new Group__c( Account__c = acc1.Id,
                                      ClaimSystem__c = 'ABC',
                                      Name = 'W22222'
                                  );
        try{
         insert g1;
         System.debug('----g1' + g1);
        }catch(DMLException e){
           system.debug('-- Group Record insertion failed -- '+e.getMessage());
        }
    
        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);
        try{
           update pb2;
           System.debug('----pb2' + pb2);
        }catch(DMLException e){
           system.debug('-- Pricebook2 Record insertion failed -- '+e.getMessage());
        }
    
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest();
    
        // validate Legacy Group not exists
        system.assertEquals('Legacy Group number record not found in com2:L11111', [Select Status_message__c from Collab_Migrated_Group__c ].Status_Message__c);
}
    public static testMethod void testmethod_wgsGroupNotInCollab() {
        
     Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
        
        try{
           insert acc1; 
           system.debug('-- acc1.Id ---'+acc1.Id);
        }catch(DMLException e){
           system.debug('-- Account Record insertion failed -- '+e.getMessage());
        }
        
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc1.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),//system.TODAY(),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '51 - 99',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
        try{
            insert cmgtest1;
            System.debug('----cmgtest1' + cmgtest1);
        } catch(DMLException e){
            system.debug('-- Collab Migrated Group Record insertion failed -- '+e.getMessage());
        }
            
        Group__c g1 = new Group__c( Account__c = acc1.Id,
                                      ClaimSystem__c = 'WGS 2.0',
                                      Name = 'L11111'
                                  );
        try{
             insert g1;
             System.debug('----g1' + g1);
        }catch(DMLException e){
           system.debug('-- Group Record insertion failed -- '+e.getMessage());
        }

        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);
        try{
           update pb2;
           System.debug('----pb2' + pb2);
        }catch(DMLException e){
           system.debug('-- Pricebook2 Record insertion failed -- '+e.getMessage());
        }
    
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest();
        
        Collab_Migrated_Group__c c1 =  [Select Status__c, Status_Message__c from Collab_Migrated_Group__c];
        system.assertEquals('ERROR', c1.Status__c , 'wgsGrpNumNotInCollab');
        
}

public static testMethod void testmethod_multipleOppTest() {   

        Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
        try{
           insert acc1; 
           system.debug('-- acc1.Id ---'+acc1.Id);
        }catch(DMLException e){
           system.debug('-- Account Record insertion failed -- '+e.getMessage());
        }
        
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc1.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '51 - 99',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
        try{
            insert cmgtest1;
            System.debug('----cmgtest1' + cmgtest1);
        } catch(DMLException e){
            system.debug('-- Collab Migrated Group Record insertion failed -- '+e.getMessage());
        }  
    
        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);
        try{
           update pb2;
           System.debug('----pb2' + pb2);
        }catch(DMLException e){
           system.debug('-- Pricebook2 Record insertion failed -- '+e.getMessage());
        }
        
        Group__c g1 = new Group__c( Account__c = acc1.Id,
                                    Name = cmgtest1.Legacy_Group_Number__c,
                                    ClaimSystem__c = cmgtest1.Legacy_Claim_System__c
                                  );

        try{
             insert g1;
             System.debug('----g1' + g1);
        }catch(DMLException e){
           system.debug('-- Group Record insertion failed -- '+e.getMessage());
        }
    
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Local').getRecordTypeId();

        Opportunity opp1 = new Opportunity(
                                            Name = 'test opp1',
                                            RecordTypeId = RecordTypeIdOpportunity,
                                            AccountId = acc1.Id,
                                            Closedate = cmgtest1.Migration_Date__c,
            								StageName = 'Closed Won'
                                          );

        try{
             insert opp1;
             System.debug('----opp1' + opp1);
        }catch(DMLException e){
           system.debug('-- Opportunity-1 Record insertion failed -- '+e.getMessage());
        }
    
        Opportunity opp2 = new Opportunity(
                                            Name = 'test opp2',
                                            RecordTypeId = RecordTypeIdOpportunity,
                                            AccountId = acc1.Id,
                                            Closedate = cmgtest1.Migration_Date__c,
            								StageName = 'Closed Won'
                                          );

        try{
             insert opp2;
             System.debug('----opp1' + opp2);
        }catch(DMLException e){
           system.debug('-- Opportunity-1 Record insertion failed -- '+e.getMessage());
        }
    
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest(); 
        
        system.assertNotEquals(1, [Select count() from Opportunity], 'more than one opportunity found' );
}
    public static testMethod void testmethod_noContractForChildrecodTest() {
        
        Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
        
        try{
           insert acc1; 
           system.debug('-- acc1.Id ---'+acc1.Id);
        }catch(DMLException e){
           system.debug('-- Account Record insertion failed -- '+e.getMessage());
        }
        
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc1.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '51 - 99',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
        try{
            insert cmgtest1;
            System.debug('----cmgtest1' + cmgtest1);
        } catch(DMLException e){
            system.debug('-- Collab Migrated Group Record insertion failed -- '+e.getMessage());
        }        
   
              Group__c g1 = new Group__c( Account__c = acc1.Id,
                                    Name = cmgtest1.Legacy_Group_Number__c,//'test Group',
                                    ClaimSystem__c = cmgtest1.Legacy_Claim_System__c//OR 'WGS 2.0'
                                  );

        try{
             insert g1;
             System.debug('----g1' + g1);
        }catch(DMLException e){
           system.debug('-- Group Record insertion failed -- '+e.getMessage());
        }
    
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Local').getRecordTypeId();

        Opportunity opp1 = new Opportunity(
                                            Name = 'test opp1',
                                            RecordTypeId = RecordTypeIdOpportunity,
                                            AccountId = acc1.Id,
                                            Closedate = cmgtest1.Migration_Date__c,
            								StageName = 'Closed Won'
                                          );

        try{
             insert opp1;
             System.debug('----opp1' + opp1);
        }catch(DMLException e){
           system.debug('-- Opportunity-1 Record insertion failed -- '+e.getMessage());
        }

        Collab_Migrated_Group_Products__c cmgptest1 = new Collab_Migrated_Group_Products__c (
                                                              Collab_Migrated_Group__c = cmgtest1.Id,
                                                              Benefit_Period__c = 'Benefit Year',
                                                              Contract_Code__c = null,
            												  Funding_Type__c = 'Fully Insured',
                                                              HPCC_Code__c = '', 
                                                              Incentive_Type__c = '',
                                                              LOB__c ='M'
                                                            );
        
        try{
            insert cmgptest1;
            System.debug('----cmgptest1' + cmgptest1);
        } catch(DMLException e){
            system.debug('-- Collab Migrated Group Products Record insertion failed -- '+e.getMessage());
        }

        Id pricebookId = Test.getStandardPricebookId();
        
        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);
        try{
           update pb2;
           System.debug('----pb2' + pb2);
        }catch(DMLException e){
           system.debug('-- Pricebook2 Record insertion failed -- '+e.getMessage());
        }
    
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest();  
        
        System.assertEquals(null, cmgptest1.Contract_Code__c);
}
    
    public static testMethod void testmethod_noProductForContractTest() {
        
        Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
        
        try{
           insert acc1; 
           system.debug('-- acc1.Id ---'+acc1.Id);
        }catch(DMLException e){
           system.debug('-- Account Record insertion failed -- '+e.getMessage());
        }
        
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc1.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '51 - 99',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
        try{
            insert cmgtest1;
            System.debug('----cmgtest1' + cmgtest1);
        } catch(DMLException e){
            system.debug('-- Collab Migrated Group Record insertion failed -- '+e.getMessage());
        } 
    
        Group__c g1 = new Group__c( Account__c = acc1.Id,
                                    Name = cmgtest1.Legacy_Group_Number__c,//'test Group',
                                    ClaimSystem__c = cmgtest1.Legacy_Claim_System__c//OR 'WGS 2.0'
                                  );

        try{
             insert g1;
             System.debug('----g1' + g1);
        }catch(DMLException e){
           system.debug('-- Group Record insertion failed -- '+e.getMessage());
        }
    
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Local').getRecordTypeId();

        Opportunity opp1 = new Opportunity(
                                            Name = 'test opp1',
                                            RecordTypeId = RecordTypeIdOpportunity,
                                            AccountId = acc1.Id,
                                            Closedate = cmgtest1.Migration_Date__c,
            								StageName = 'Closed Won'
                                          );

        try{
             insert opp1;
             System.debug('----opp1' + opp1);
        }catch(DMLException e){
           system.debug('-- Opportunity-1 Record insertion failed -- '+e.getMessage());
        }

    
        Collab_Migrated_Group_Products__c cmgptest1 = new Collab_Migrated_Group_Products__c (
                                                              Collab_Migrated_Group__c = cmgtest1.Id,
                                                              Benefit_Period__c = 'Benefit Year',
                                                              Contract_Code__c = '34EE', 
                                                              Funding_Type__c = 'Fully Insured', 
                                                              HPCC_Code__c = '', 
                                                              Incentive_Type__c = '', 
                                                              LOB__c ='M'
                                                            );
        
        try{
            insert cmgptest1;
            System.debug('----cmgptest1' + cmgptest1);
        } catch(DMLException e){
            system.debug('-- Collab Migrated Group Products Record insertion failed -- '+e.getMessage());
        }

        Product2 prod1 = new Product2(Name = 'Product- See Notes',
                                IsActive = true,
                                Contract_code__c= '34RR', //cmgptest1.Contract_Code__c,
                                Plan_Type__c = 'Modified',
                                LOB__c='Medical',
                                productActive__c = true
                                );
        try{
        	insert prod1;
    		System.debug(' PRODUCT 1' + prod1);
        }catch(DMLException e){
            system.debug('-- Product Record insertion failed -- '+e.getMessage());
        }
        
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);

        try{
           update pb2;
           System.debug('----pb2' + pb2);
        }catch(DMLException e){
           system.debug('-- Pricebook2 Record insertion failed -- '+e.getMessage());
        }
        
        PricebookEntry standardPriceBookEntry1 = new PricebookEntry( Pricebook2Id = pb2.Id,
                                                        Product2Id = prod1.Id,
                                                        UnitPrice = 10000, IsActive = true);

        try{ 
       		insert standardPriceBookEntry1;
            System.debug('standardPriceBookEntry1 ' + standardPriceBookEntry1);	
        }catch(DMLException e){
           system.debug('-- standardPriceBookEntry1 Record insertion failed -- '+e.getMessage());
        }  
        
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest(); 
        
       System.assertEquals('No product record found for contract code: 34EE',[Select Status_message__c from Collab_Migrated_Group__c].Status_Message__c);
	   system.assertNotEquals('cmgptest1.Contract_Code__c','34RR');
}
    
public static testMethod void testmethod_fundingTypeASO() {   

        Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
        
        try{
           insert acc1; 
           system.debug('-- acc1.Id ---'+acc1.Id);
        }catch(DMLException e){
           system.debug('-- Account Record insertion failed -- '+e.getMessage());
        }
        
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc1.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),//system.TODAY(),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '100 - 249',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
        try{
            insert cmgtest1;
            System.debug('----cmgtest1' + cmgtest1);
        } catch(DMLException e){
            system.debug('-- Collab Migrated Group Record insertion failed -- '+e.getMessage());
        }
    
        Group__c g1 = new Group__c( Account__c = acc1.Id,
                                    Name = cmgtest1.Legacy_Group_Number__c,
                                    ClaimSystem__c = cmgtest1.Legacy_Claim_System__c
                                  );

        try{
             insert g1;
             System.debug('----g1' + g1);
        }catch(DMLException e){
           system.debug('-- Group Record insertion failed -- '+e.getMessage());
        }
    
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Local').getRecordTypeId();

        Opportunity opp1 = new Opportunity(
                                            Name = 'test opp1',
                                            RecordTypeId = RecordTypeIdOpportunity,
                                            AccountId = acc1.Id,
                                            Closedate = cmgtest1.Migration_Date__c,
            								StageName = 'Closed Won'
                                          );

        try{
             insert opp1;
             System.debug('----opp1' + opp1);
        }catch(DMLException e){
           system.debug('-- Opportunity-1 Record insertion failed -- '+e.getMessage());
        }

        Collab_Migrated_Group_Products__c cmgptest1 = new Collab_Migrated_Group_Products__c (
                                                              Collab_Migrated_Group__c = cmgtest1.Id,
                                                              Benefit_Period__c = 'Benefit Year',// N - Benefit Year, "Y = Calender Year
                                                              Contract_Code__c = '34EE', 
                                                              Funding_Type__c = 'ASO', 
                                                              Group_Size__c = '1,000-12,499',
                                                              HPCC_Code__c = 'HM21', 
                                                              Incentive_Type__c = 'Debit Card', 
                                                              LOB__c ='M'
                                                            );
        
        try{
            insert cmgptest1;
            System.debug('----cmgptest1' + cmgptest1);
        } catch(DMLException e){
            system.debug('-- Collab Migrated Group Products Record insertion failed -- '+e.getMessage());
        }

        Product2 prod1 = new Product2(Name = 'Product- See Notes',
                                IsActive = true,
                                Contract_code__c= cmgptest1.Contract_Code__c,
                                Plan_Type__c = 'Modified',
                                LOB__c='Medical',
                                productActive__c = true
                                );
        try{
        	insert prod1;
    		System.debug(' PRODUCT 1' + prod1);
        }catch(DMLException e){
            system.debug('-- Product Record insertion failed -- '+e.getMessage());
        }
        
        Product2 prod2 = new Product2(Name = 'Anthem Blue Access PPO HRAs Option E4-M',
                                IsActive = true,
                                vlocity_ins__ProductSpecId__c = prod1.Id,
                                Contract_code__c= cmgptest1.Contract_Code__c,
                                vlocity_ins__SubType__c='Other',
                                Plan_Type__c = 'Modified',
                                LOB__c='Medical',
                                vlocity_ins__EffectiveDate__c = Date.today(),
                                productActive__c = true
                                );

        try{
        	insert prod2;
    		System.debug(' PRODUCT 2' + prod2);
        }catch(DMLException e){
            system.debug('-- Product Record insertion failed -- '+e.getMessage());
        }      

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);
        try{
           update pb2;
           System.debug('----pb2' + pb2);
        }catch(DMLException e){
           system.debug('-- Pricebook2 Record insertion failed -- '+e.getMessage());
        }
        
        PricebookEntry standardPriceBookEntry1 = new PricebookEntry( Pricebook2Id = pb2.Id,
                                                        Product2Id = prod1.Id,
                                                        UnitPrice = 10000, IsActive = true);

        try{ 
       		insert standardPriceBookEntry1;
            System.debug('standardPriceBookEntry1 ' + standardPriceBookEntry1);	
        }catch(DMLException e){
           system.debug('-- standardPriceBookEntry1 Record insertion failed -- '+e.getMessage());
        }
    
    	System.debug('standardPriceBookEntry1 ' + standardPriceBookEntry1);	
        
        PricebookEntry standardPriceBookEntry2 = new PricebookEntry( Pricebook2Id = pb2.Id, 
                                                           Product2Id = prod2.Id,
                                                           UnitPrice = 20000, IsActive = true);
        try{ 
       		insert standardPriceBookEntry2;
            System.debug('standardPriceBookEntry2 ' + standardPriceBookEntry2);	
        }catch(DMLException e){
           system.debug('-- standardPriceBookEntry2 Record insertion failed -- '+e.getMessage());
        }

        Quote q1 = new Quote(
                        Name = Opp1.Name, 
                        Pricebook2Id = pb2.Id, 
                        OpportunityId = opp1.Id,
                        GroupNumber__c = g1.Id); 

        try{ 
       		insert q1;
            System.debug('q1 ' + q1);	
        }catch(DMLException e){
           system.debug('-- q1 Record insertion failed -- '+e.getMessage());
        }
    
        
         QuoteLineItem parentQli = new QuoteLineItem( 
                                                 QuoteId = q1.Id,
                                                 Product2Id = prod2.Id,//Parent product
                                                 PricebookEntryId = standardPriceBookEntry1.Id,
                                                 ProductStage__c='In Progress',
                                                 Quantity = 1,
                                                 Unitprice = 10.00
                                             );

        try{ 
       		insert parentQli;
            System.debug('parentQli :' + parentQli);	
        }catch(DMLException e){
           system.debug('-- parentQli Record insertion failed -- '+e.getMessage());
        }
    
         QuoteLineItem childQli = new QuoteLineItem( 
                                            QuoteId = q1.Id,
                                            Product2Id = prod1.Id,
                                            PricebookEntryId = standardPriceBookEntry2.Id,
             								vlocity_ins__ParentItemId2__c = parentQli.Id,
                                            RecordType__c = 'LocalType',
                                            Plan_type__c = 'Modified',
                                            Upsell__c = 'No',
                                            ProductStage__c = 'In Progress',
                                            Funding__c = cmgptest1.Funding_Type__c,
                                            Financing__c = cmgptest1.Funding_Type__c == 'FI' ? 'Fully Insured' : cmgptest1.Funding_Type__c == 'ASO' ? 'Administrative Services Only' : '' ,
                                            Benefit_Period__c = cmgptest1.Benefit_Period__c,
                                            Group_Size__c = (cmgptest1.Group_Size__c == '1,000-12,499'|| cmgptest1.Group_Size__c == '12,500+') ? '1000+' : cmgptest1.Group_Size__c,
                                            HPCC_Code__c = cmgptest1.HPCC_Code__c,
                                            Incentive_Type__c = cmgptest1.Incentive_Type__c,
                                            Quantity = 1,
                                            Unitprice = 1.00
                                            );

        try{ 
       		insert childQli;
            System.debug('childQli :' + childQli);	
        }catch(DMLException e){
           system.debug('-- childQli Record insertion failed -- '+e.getMessage());
        }
    
    
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest();
    
        System.assertEquals('1000+', childQli.Group_Size__c);
        System.assertEquals('Modified', childQli.Plan_type__c);
        System.assertEquals('HM21', childQli.HPCC_Code__c);
        System.assertEquals('Debit Card', childQli.Incentive_Type__c);
        System.assertEquals('Administrative Services Only', childQli.Financing__c);
}
    
    
public static testMethod void testmethod_termMedicalQliRecord() {   

        Account acc1 = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West'
                                );
        
        try{
           insert acc1; 
           system.debug('-- acc1.Id ---'+acc1.Id);
        }catch(DMLException e){
           system.debug('-- Account Record insertion failed -- '+e.getMessage());
        }
    
        Collab_Migrated_Group__c cmgtest1 = new Collab_Migrated_Group__c(
                    Com2_Account_Id__c =   acc1.Id ,
                    Collab_AccountId__c = '001xa000003EIlo', 
                    Migration_Date__c = Date.newInstance(2019, 07, 01),//system.TODAY(),
                    Legacy_Claim_System__c = 'ABC' , 
                    Legacy_Group_Number__c = 'L11111', 
                    WGS_Group_Number__c = 'W22222',
                    Account_Legal_Name__c = 'Unique ABC Home', 
                    Situs_State__c = 'Ohio',  
                    Group_Size__c = '51-99',
                    Account_Manager__c = 'ABC123',
                    Status__c = 'PENDING',
                    Status_Message__c = ''
        );
        
         try{
            insert cmgtest1;
            System.debug('----cmgtest1' + cmgtest1);
        } catch(DMLException e){
            system.debug('-- Collab Migrated Group Record insertion failed -- '+e.getMessage());
        }
    
        Group__c g1 = new Group__c( Account__c = acc1.Id,
                                    Name = cmgtest1.Legacy_Group_Number__c,//'test Group',
                                    ClaimSystem__c = cmgtest1.Legacy_Claim_System__c//OR 'WGS 2.0'
                                  );

        try{
             insert g1;
             System.debug('----g1' + g1);
        }catch(DMLException e){
           system.debug('-- Group Record insertion failed -- '+e.getMessage());
        }
    
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Local').getRecordTypeId();

        Opportunity opp1 = new Opportunity(
                                            Name = 'test opp1',
                                            RecordTypeId = RecordTypeIdOpportunity,
                                            AccountId = acc1.Id,
                                            Closedate = cmgtest1.Migration_Date__c,
            								StageName = 'Closed Won'
                                          );

         try{
             insert opp1;
             System.debug('----opp1' + opp1);
        }catch(DMLException e){
           system.debug('-- Opportunity-1 Record insertion failed -- '+e.getMessage());
        }

    
        Collab_Migrated_Group_Products__c cmgptest1 = new Collab_Migrated_Group_Products__c (
                                                              Collab_Migrated_Group__c = cmgtest1.Id,
                                                              Benefit_Period__c = 'Benefit Year',// N - Benefit Year, "Y = Calender Year
                                                              Contract_Code__c = '34EE', 
                                                              Funding_Type__c = 'ASO', 
                                                              HPCC_Code__c = '', //null
                                                              Incentive_Type__c = '',//null 
                                                              LOB__c ='Medical',
                                                              Group_Size__c = '12,500+'
                                                            );
        
        try{
            insert cmgptest1;
            System.debug('----cmgptest1' + cmgptest1);
        } catch(DMLException e){
            system.debug('-- Collab Migrated Group Products Record insertion failed -- '+e.getMessage());
        }
        

        System.assertNotEquals(null, cmgptest1);

        Product2 prod1 = new Product2(Name = 'Product- See Notes',
                                IsActive = true,
                                Contract_code__c= cmgptest1.Contract_Code__c,
                                Plan_Type__c = 'Modified',
                                Category__c = 'Plan',
                                LOB__c='Medical',
                                Product_Type__c = 'Medical',
                                //vlocity_ins__ProductSpecId__c = 'Other',
                                productActive__c = true
                                );
        try{
        	insert prod1;
    		System.debug(' PRODUCT 1' + prod1);
        }catch(DMLException e){
            system.debug('-- Product Record insertion failed -- '+e.getMessage());
        }
        
        Product2 prod2 = new Product2(Name = 'Anthem Blue Access PPO HRAs Option E4-M',
                                IsActive = true,
                                vlocity_ins__ProductSpecId__c = prod1.Id,
                                Contract_code__c= cmgptest1.Contract_Code__c,
                                vlocity_ins__SubType__c='Other',
                                Plan_Type__c = 'Modified',
                                LOB__c='Medical',
                                Product_Type__c = 'Medical',
                                vlocity_ins__EffectiveDate__c = Date.today(),
                                productActive__c = true
                                );
        try{
        	insert prod2;
    		System.debug(' PRODUCT 2' + prod2);
        }catch(DMLException e){
            system.debug('-- Product Record insertion failed -- '+e.getMessage());
        }    

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 pb2 = new Pricebook2(Id = Test.getstandardPricebookId() , 
                                        isActive = true);
        try{
           update pb2;
           System.debug('----pb2' + pb2);
        }catch(DMLException e){
           system.debug('-- Pricebook2 Record insertion failed -- '+e.getMessage());
        }
        
        PricebookEntry standardPriceBookEntry1 = new PricebookEntry( Pricebook2Id = pb2.Id,
                                                        Product2Id = prod1.Id,
                                                        UnitPrice = 10000, IsActive = true);

        try{ 
       		insert standardPriceBookEntry1;
            System.debug('standardPriceBookEntry1 ' + standardPriceBookEntry1);	
        }catch(DMLException e){
           system.debug('-- standardPriceBookEntry1 Record insertion failed -- '+e.getMessage());
        }
        
        PricebookEntry standardPriceBookEntry2 = new PricebookEntry( Pricebook2Id = pb2.Id, 
                                                           Product2Id = prod2.Id,
                                                           UnitPrice = 20000, IsActive = true);
        try{
        	insert  standardPriceBookEntry2;
            System.debug('standardPriceBookEntry2 ' + standardPriceBookEntry2);	
        }catch(DMLException e){
           system.debug('-- standardPriceBookEntry2 Record insertion failed -- '+e.getMessage());
        }
           
        Quote q1 = new Quote(
                        Name = Opp1.Name, //'2019 Opportunity for update',
                        Pricebook2Id = pb2.Id, //Test.getStandardPricebookId(),
                        OpportunityId = opp1.Id,
                        GroupNumber__c = g1.Id); //cmgtest1.WGS_Group_Number__c); reverify

        try{
            insert q1;
            System.debug('Quote - q1 :' + q1);
        }catch(DMLException e){
           system.debug('-- Quote Record insertion failed -- '+e.getMessage());
        }
        
         QuoteLineItem parentQli = new QuoteLineItem( 
                                                 QuoteId = q1.Id,
                                                 Product2Id = prod2.Id,//Parent product
                                                 PricebookEntryId = standardPriceBookEntry1.Id,
                                                 ProductStage__c='IGAP In Progress',
                                                 Quantity = 1,
                                                 Unitprice = 10.00
                                             );

        try{
            insert parentQli;
            System.debug(' parentQli :' + parentQli);
        }catch(DMLException e){
           system.debug('-- Parent QLI Record insertion failed -- '+e.getMessage());
        }
       
    
        Test.startTest();

        CollabToolIntegration ctInte = new CollabToolIntegration();
    
        Database.executeBatch(ctInte);

        Test.stopTest();
    
    QuoteLineItem termedqliItem = [Select Id,ProductStage__c,Reason__c, TermDate__c from QuoteLineItem where  ProductStage__c = 'Termed'];

    System.assertEquals( 'Termed' ,termedqliItem.ProductStage__c );
    System.assertEquals( 'System Migration' ,termedqliItem.Reason__c );
    System.assertEquals( opp1.Closedate ,termedqliItem.TermDate__c );

}    

}