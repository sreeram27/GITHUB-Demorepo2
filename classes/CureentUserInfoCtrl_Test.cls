@isTest
public class CureentUserInfoCtrl_Test {
    @testSetup static void CurrentUserInfoCtrl_TestDataSetup() 
    {
        Profile p1 = [SELECT Id FROM Profile WHERE Name='National Sales']; 
        User user1 = new User(Alias = 'asfsaf', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='fgasdhdfh', 
                            LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', 
                            UserName='test23123we4@testorg.com');

        insert user1;
    
        Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
        Database.insert(acc);
        contact con = new Contact();
        con.LastName = 'testname';
        con.Email = 'test23123we4@testorg.com';
        if(acc.Id!=null)
        {
            con.AccountId=acc.Id;
        }
        insert con;
        
         Organization env = [select name, IsSandbox from Organization where Id = '00DS0000003EdxnMAC'];
     
    }
   @isTest static void launchbutton()
    {
        contact ocon = CurrentUserInfoCtrl.fetchContact();
       
                
    }
    @isTest static void orgCheck()
    {
        
        CurrentUserInfoCtrl.fetchOrg();
        
    }
}