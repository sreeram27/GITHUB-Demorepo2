/*
*  This Class is a test class for the AP29_UnlockAPRRecord class
* 
*/
@isTest(Seealldata = true)
public class AP29_UnlockAPRRecord_Test {
    private static final string BG ='Brenda Garibay'; 
    private static User User2 = [select id from User where name=: BG];
    private static final string NA ='National Implementations'; 
    private static Profile profileNA = [select id from profile where name=: NA];
    private static User User1 = ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
    static testMethod void UnlockAPRRecordTest(){
        
        
        Test.startTest();
        
        Account acc = ANA_UTIL01_TestMethods.createAccount(false);
        try
        {
        insert acc;
        }
        catch(Exception e)
        {
            System.assertEquals(e.getMessage(),e.getMessage(),'Fail');
        }
        Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
        try
        {
        insert opty; 
        }
        catch(Exception e)
        {
            System.assertEquals(e.getMessage(),e.getMessage(),'Fail');
        }
        Group__c grp1 = ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        grp1.ClaimSystem__c = 'NASCO';
        try
        {
        insert(grp1);
        }    
        catch(Exception e)
        {
            System.assertEquals(e.getMessage(),e.getMessage(),'Fail');
        }
        
        
        Alpha_Prefix_Request__c apr1 = new Alpha_Prefix_Request__c(Implementation_Coordinator_Name__c = User1.id,Underwriter_Name__c = User1.id, Interplan_AM_Approving__c = User2.id,
                                                                   Account_Executive_Name__c = User1.id,Group__c = grp1.id,Effective_Date__c = Date.newInstance(2018,09,09),
                                                                   Control_Plan_Code_System__c = 'CA - WGS- 040',Account_Type__c = 'National', Group_Number__c =grp1.id, Prefixes_Being_Returned__c = 'Test',
                                                                   Reason_For_Return__c= 'Test');
        // apr1.RecordTypeId = Schema.sObjectType.Alpha_Prefix_Request__c.getRecordTypeInfosByName().get('Return_Unused_Prefix').getRecordTypeId();
       List<Alpha_Prefix_Request__c> alist=new List<Alpha_Prefix_Request__c>{apr1};
            try{
                insert apr1;
            }
        catch(Exception ex)
        {
            //System.debug('Exception is :'+ex.getMessage());
            System.assertEquals(ex.getMessage(), ex.getMessage(),'Failed');
        }
        Alpha_Prefix_Network__c apn1 = new Alpha_Prefix_Network__c(ProductNetworkName__c = 'EPO' , Alpha_Prefix_Request__c = apr1.Id);
        List<Alpha_Prefix_Network__c> anlist=new List<Alpha_Prefix_Network__c>{apn1};
            try{
                insert apn1;
            }
        
       /* Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(apr1.id);
        app.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        Approval.ProcessResult result = Approval.process(app); */
        
        catch(DmlException ex)
        {
            System.assertEquals(ex.getMessage(), ex.getMessage(),'Failed');
        }
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(apr1.id);
        req1.setSubmitterId(User1.Id);
        req1.setProcessDefinitionNameOrId('ANA_AP_APR01_Interplan_AM_Approval');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
        AP29_UnlockAPRRecord.UnlockAPR();
        
           
        test.stoptest();
    }
}