/** This is a test class for AP28_BPD_Helper 
*/
@isTest
private class AP28_BPD_Helper_Test {
    private static final string NA ='Local Implementations'; 
    private static Profile profileNA = [select id from profile where name=: NA];
    private static final string SME ='SME'; 
    private static Profile profileNA1 = [select id from profile where name=: SME];
    private static User user = ANA_UTIL01_TestMethods.runAsUser(profileNA.id); 
    private static User user1 = ANA_UTIL01_TestMethods.runAsUser(profileNA1.id);
    
    //insert new PermissionSetAssignment(AssigneeId = user1.id, PermissionSetId = ps.Id );
    static testMethod void getGsListTest(){
        system.runAs(user1)
        {  
            test.startTest();
            /* Profile p = [SELECT Id FROM Profile WHERE Name='National Implementer']; 
User user = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', 
EmailEncodingKey='UTF-8', LastName='fghdfh', LanguageLocaleKey='en_US', 
LocaleSidKey='en_US', ProfileId = p.Id, 
TimeZoneSidKey='America/Los_Angeles', UserName='test2314@testorg.com');
insert user;
*/
            Account acc = new Account(Name = 'Test Acc',Anthem_Entity__c = 'Local/Large Group',Region__c='Central',
                                      Branding__c = 'UniCare',ApprovedByOutsourcing__c= true);
            insert Acc;
            //Account acc = ANA_UTIL01_TestMethods.createAccount(false); 
            //insert acc;
            //Creating Opportunity Records
            
            Opportunity oppty = ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
            insert(oppty);
            Quote qte = ANA_UTIL01_TestMethods.createQuote(false,oppty.Id);
            insert(qte);
            Product2 prod = ANA_UTIL01_TestMethods.createProduct(false);
            prod.Name = 'AIM: A La Carte';
            insert(prod);
            
            PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
            insert(pbe);
            
            QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.Id, pbe.id);
            qli.ProductStage__c='Sold';
            qli.Financing__c='JAA (Jointly Administered Arrangement)';
            insert qli;
            
            /* Group__c grp = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
grp1.ClaimSystem__c = 'NASCO';    
insert(grp1); */
            
            Group__c grp = new Group__c(Account__c=acc.id);
            grp.ClaimSystem__c='NASCO';
            grp.IsActive__c=true;
            insert(grp);
            
            qte.GroupNumber__c = grp.id;
            
            update qte;
            
            Order ord = new Order(Group_Name__c=grp.id,AccountId = acc.Id, EffectiveDate=System.today(),Tracking_Record_Exists__c= False,
                                  Status = 'Draft',Implementation_Case_Name__c = 'AIMTesting01', Discovery_Call_Desired__c ='Yes',
                                  Implementation_Status__c = 'Initiated', Implementation_Effective_Date__c=System.today(),
                                  Assigned_Implementer__c=user.id,QuoteId=qte.id);  
            insert ord;
            ord.Implementation_Status__c = 'Pending SME Review';
            Update ord;
            
            system.debug('@@@Ord'+ord);
            
            Implementation_Tracking__c imt = New Implementation_Tracking__c();
            imt.Group_Number__c = grp.id;
            imt.Implementation_Record_ID__c = ord.Id;
            imt.Account_Legal_Name__c =acc.id;
            insert imt;
            
            system.debug('Implementation_Tracking object inserted');
            Profile profileSME = [select id from profile where name= 'SME' LIMIT 1];
            system.debug('**-' + profileSME.id); 
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = profileSME.Id,
                              TimeZoneSidKey='America/Los_Angeles',     UserName='testpermissionsetuser121@testorg.com');
            // user.ProfileId =profileSME.Id;
            insert u;
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'EBA_SME'];
            PermissionSetAssignment assignment = new PermissionSetAssignment();
            assignment.AssigneeId = user1.Id;
            assignment.PermissionSetId = ps.Id;
            insert assignment;
            
            System.runAs(user1) {       
                BPD__c bpd = New BPD__c();
                // bpd.Implementation_Case_Record_ID__c =ord.id;
                bpd.Implementation_Tracking_ID__c = imt.Id;
                bpd.Is_Client_Approval_Needed__c = 'Yes';
                bpd.BPD_Status__c='Pending Response from ESR';
                // bpd.Name ='';
                insert bpd;
            }
            System.runAs(user1) {       
                BPD__c bpd = New BPD__c();
                // bpd.Implementation_Case_Record_ID__c =ord.id;
                bpd.Implementation_Tracking_ID__c = imt.Id;
                //bpd.Is_Client_Approval_Needed__c = 'Yes';
                bpd.BPD_Status__c='Pending Response from ESR';
                // bpd.Name ='';
                try
                {
                    insert bpd;
                }
                catch(Exception e){
                    
                }
            }
        }
    }        
}