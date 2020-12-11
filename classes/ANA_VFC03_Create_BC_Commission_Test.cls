/**
@Author : Accenture Offshore Dev team
@name : ANA_VFC03_Create_BC_Commission_Test
@CreateDate :25-08-2017
@Description : This class is a test class for ANA_VFC03_Create_BC_Commission. 
*/
@isTest
private class ANA_VFC03_Create_BC_Commission_Test {
    private static final string NATIONALAMPROFILE='National Sales';
    /*this method is for invoking the standardsetcontrollet defined VF page.*/
    private static  testmethod void invokeControllerTest()
    {
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1];       
        User user=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        system.runAs(user)
        {
            List<Account> accList=new List<Account>();
            Account testAccount = new Account(Name='Test BC Account');
            accList.add(testAccount);
            insert accList;                       
            PageReference pageRef = Page.ANA_VFP12_BrokerConsultant_Commission;
            pageRef.getParameters().put('id', String.valueOf(testAccount.Id));
            Test.setCurrentPage(pageRef); 
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(accList);
            ANA_VFC03_Create_BC_Commission vfbcc=new ANA_VFC03_Create_BC_Commission(ssc);
       }
    }
}