@isTest
public with sharing class ICR_ContentDocument_Trigger_Test {
     @TestSetup static void Setup(){

      // Test data setup
        // Creation of test data
        
            Account acc = new Account(
                RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
                Name = 'TestAccount',
                Account_s_Suppress_Auto_Renewal__c = false,
                Anthem_Entity__c = staticVariableClass.Entity,
                Region__c= staticVariableClass.Region,
                Branding__c =staticVariableClass.UniCare,
                Group_Size__c =staticVariableClass.size,
                Total_Employees__c =staticVariableClass.emp,
                HQ_State__c =staticVariableClass.AK,
                Situs_State__c = staticVariableClass.California,
                Mailing_Address_Same_as_Physical_Address__c = true,
                BillingStreet = '70 Elm Road ',
                BillingPostalCode = 'RM176L9',
                BillingCity = 'Grays',
                BillingCountry = 'United Kingdom',
                BillingState = 'Essex',
                Physical_County__c = 'London');
                database.insert(acc);
            
            
            Opportunity newOpp = new Opportunity(
                name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name),
                StageName = staticVariableClass.ClosedWon,
                AccountID = acc.id,CloseDate = ((system.TODAY())-95),
                recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId());
                database.insert(newOpp);
        
            
            Group__c grp = new Group__c(Name='GroupTest' ,Account__c=acc.Id);//ANA_UTIL01_TestMethods.createGroup(acc.id,false);
            Database.insert(grp);

            Quote qt = new Quote();  //ANA_UTIL01_TestMethods.createQuote(false,newOpp.Id);
             qt.Name='QuoteTest';
             qt.OpportunityId = newOpp.id;
             qt.Pricebook2Id = System.Test.getStandardPricebookId();
             qt.GroupNumber__c=grp.id;
             Database.insert(qt);
                    
            Product2 prod2 = new Product2(); //ANA_UTIL01_TestMethods.createProduct(false);
            prod2.name='Anthem Health Guide';
            Database.insert(prod2);
          
            PricebookEntry pbook = new PricebookEntry(pricebook2id = System.Test.getStandardPricebookId(),
             product2id = prod2.Id,unitprice=1.0,isActive=true);// ANA_UTIL01_TestMethods.createPricebookEntry(false,prod2.id);
            Database.insert(pbook);
            
            /*QuoteLineItem qli = new QuoteLineItem();//ANA_UTIL01_TestMethods.createQuoteLineItem(false,qt.Id, pbook.id);
                qli.PricebookEntryId=pbook.id;
                qli.quoteid= qt.id;
                qli.Competitor__c= acc.id;
               qli.Quantity =  123.0;
            qli.UnitPrice =12.0;
            qli.Product_Term_Years_Left__c ='5';
            qli.Discount_sharing__c = staticVariableClass.SoldRenewed;
            qli.EPHC_Enhanced_Personal_Health_Care__c = staticVariableClass.SoldRenewed;
            qli.ProductStage__c= staticVariableClass.Sold;
            Database.insert(qli);*/
            
            Profile prof = [SELECT Id FROM Profile WHERE Name='Local Implementations' Limit 50000]; 
            User user2 = new User(
                                Alias = 'jd321', 
                                Email='johndoe@abc.com', 
                                EmailEncodingKey='UTF-8', 
                                LastName='Doe', 
                                LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', 
                                ProfileId = prof.Id, TimeZoneSidKey='America/Los_Angeles', 
                                UserName='johndoe@abc.com');
    
           // insert user2;
            
            Order ord = new Order(
                    Group_Name__c=grp.id,
                    AccountId = acc.Id,
                    ID_Cards_Required__c='No', 
                    EffectiveDate=System.today(), 
                    Status = 'Draft',
                    Implementation_Case_Name__c = 'AIMTesting01', 
                    Discovery_Call_Desired__c ='Yes', 
                    Implementation_Status__c = 'Initiated', 
                    Implementation_Effective_Date__c=System.today(), 
                    Assigned_Implementer__c=user2.id,
                    QuoteId=qt.id,
                    Initial_Enrollment_Submission_Type__c = 'Census'
                    //Ongoing_Enrollment_Submission_Type__c  = 'Manual Move from NASC'
                     );
                    database.insert(ord); 
           
            
            /*Implementation_Tracking__c ImpTrack = new Implementation_Tracking__c();
            ImpTrack.RecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get('Local NASCO and WGS').getRecordTypeId();
            ImpTrack.Implementation_Record_ID__c = ord.Id;
            insert ImpTrack;
    
            ID_Cards__c i= new ID_Cards__c(Implementation_Tracking_ID__c = ImpTrack.ID,Stage__c = '04 Approved');
            insert i;*/
             
           }
    
    
         @isTest static void contentDocTest(){
            
            ContentVersion cv = new ContentVersion();
            cv.Title = 'TestFinalSheets';
            cv.PathOnClient = 'Test Final Rate Sheets.xlsx';
            cv.VersionData = Blob.valueOf('Test Content Data');
            cv.IsMajorVersion = true;
            database.insert(cv); 
             
            System.Test.startTest();
            List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id limit 1];
         
            List<ContentDocument> doc = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 50000];
             List<Order>ord1 = [SELECT id FROM Order WHERE Implementation_Case_Name__c = 'AIMTesting01' Limit 50000];
            
           
            ContentDocumentLink cdl = new ContentDocumentLink();
             if(ord1.size() > 0){
                cdl.LinkedEntityId = ord1[0].id;
                }
            if(doc.size() > 0){
                cdl.ContentDocumentId = doc[0].Id;
                }
            cdl.shareType = 'I';
            cdl.Visibility = 'AllUsers';
            
            database.insert(cdl);
    
    
    
            //query the inserted record
            List<ContentDocument>contDoc = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 50000];
            List<ContentDocumentLink> icrData =[SELECT id,shareType,Visibility,LinkedEntityId FROM ContentDocumentLink where ContentDocumentId =:contDoc[0].id Limit 50000];
            //List<Account> acc = [Select id from Account where name ='TestAccount'];
 
           
           // Verify that the ICR or orderId
            Set<Id>orderId = ICRContentDocumentTriggerHandler.getOrderId(icrData);
            System.assertEquals(orderId.size(), 1,'Order Set is empty');
            ICRContentDocumentTriggerHandler.accountContentDocumentLink(orderId);                     
            //Verify the list of document
            List<ContentDocumentLink> icrData2 =[Select id,shareType,Visibility,LinkedEntityId from ContentDocumentLink where LinkedEntityId =:orderId LIMIT 10000];
            System.assert(icrData2.size() > 0);
             
            List<String>accId = ICRContentDocumentTriggerHandler.getAccountId(orderId );
           // Verify that the AccountId
           System.assertEquals(accId.size(), 1,'AccountId List is empty');
              
            // Verify that the Contentdocument has been linked to the Account 
         
           //Verify that the trigger ran 
            System.assertEquals(ICRContentDocumentTriggerHandler.isRun, false,'The ICRtrigger did not run');
           
            System.Test.stopTest();
                      
    }

}