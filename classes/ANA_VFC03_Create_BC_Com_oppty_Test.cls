/**
@Author : Deloitte Dev team
@name : ANA_VFC03_Create_BC_Com_oppty_Test
@CreateDate :25-08-2017
@Description : This class is a test class for ANA_VFC03_Create_BC_Commission_oppty. 
*/
@isTest
private class ANA_VFC03_Create_BC_Com_oppty_Test {
    private static final string LOCALAMPROFILE='Local Sales';
    /*this method is for invoking the standardsetcontrollet defined VF page.*/
    private static  testmethod void invokeControllerTest()
    {
        Account testAccount = new Account(Name='Test BC Account');
        insert testAccount ;    
        
        Opportunity O = new Opportunity(Name = 'Test Opp', AccountID = testAccount.ID, StageName = 'Closed Won', 
                                        CloseDate = system.today() + 20);     
        insert O;                       
        PageReference pageRef = Page.ANA_VFP12_BC_Commission_oppty;
        pageRef.getParameters().put('id', String.valueOf(O.Id));
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new list<Opportunity>{O});
        ANA_VFC03_Create_BC_Commission_oppty vfbcc=new ANA_VFC03_Create_BC_Commission_oppty(ssc);
    }
}