public Class A193
{
public Account createAccount(String name)  //method to create account
{
//sai Add comment for Account A1
//saikumar Test1
Account a011111111111= new Account();
a011111111111.Name = name;

for(Account act: [select id,name,industry from account limit 50]){
    act.industry='Agriculture';
    update act;
}
return a011111111111;

//edit 22nd sai
}
}
