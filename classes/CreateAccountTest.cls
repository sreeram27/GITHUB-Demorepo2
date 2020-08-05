@istest
public class CreateAccountTest{
static testmethod void CreateAccTest(){
CreateAccount acc = new CreateAccount();
 Account ac = acc.CreateRecord('name');
}
}