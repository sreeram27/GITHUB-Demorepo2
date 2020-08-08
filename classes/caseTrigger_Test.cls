@isTest
public class caseTrigger_Test{
    @isTest
    public static void testMethod1(){
        
        case cs0 = new case();
        cs0.status = 'New';
        cs0.Origin = 'Email';
        cs0.Mailbox_Origin__c = 'test@gmail.com;test123@gmail.com';
        insert cs0;
        
        Mailbox_Origin_Emails__c moe = new Mailbox_Origin_Emails__c();
        moe.Name = 'test@gmail.com';
        moe.Mailbox_origin_Name__c = 'test@gmail.com';
        insert moe;
        
        Test.startTest();
        
        case cs = new case();
        cs.status = 'New';
        cs.Origin = 'Email';
        cs.Mailbox_Origin__c = 'test@gmail.com;test123@gmail.com';
        insert cs;
        
        case cs1 = new case();
        cs1.status = 'New';
        cs1.Origin = 'Email';
        cs1.Mailbox_Origin__c = '';
        insert cs1;
        
        Test.stopTest();
        
    }
}