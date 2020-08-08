@isTest
public class CaseTriggerTest{
    @isTest
    public static void testMethod1(){
        List<Case> caseListInsert = new List<Case>();
		List<Case> caseListInsert1 = new List<Case>();
		List<Mailbox_Origin_Emails__c> mailboxEmailList = new List<Mailbox_Origin_Emails__c>();
		for(Integer i=0; i<200; i++){
			caseListInsert.add(new Case(Status = 'New', Origin = 'Email', Mailbox_Origin__c = 'test' + i + '@gmail.com;test123' + i + '@gmail.com'));
			mailboxEmailList.add(new Mailbox_Origin_Emails__c(Name = 'test' + i + 'gmail.com', Mailbox_origin_Name__c = 'test' + i + 'gmail.com'));
		}
        caseListInsert.add(new Case(Status = 'New', Origin = 'Email', Mailbox_Origin__c = ''));

		case cs0 = new case();
        cs0.status = 'New';
        cs0.Origin = 'Email';
        cs0.Mailbox_Origin__c = 'test@gmail.com;test123@gmail.com';
        caseListInsert.add(cs0);
        
        Mailbox_Origin_Emails__c moe = new Mailbox_Origin_Emails__c();
        moe.Name = 'test@gmail.com';
        moe.Mailbox_origin_Name__c = 'test@gmail.com';
        mailboxEmailList.add(moe);
        
        Test.startTest();
        insert caseListInsert;
		insert mailboxEmailList;
        case cs = new case();
        cs.status = 'New';
        cs.Origin = 'Email';
        cs.Mailbox_Origin__c = 'test@gmail.com;test123@gmail.com';
        caseListInsert1.add(cs);
        
        case cs1 = new case();
        cs1.status = 'New';
        cs1.Origin = 'Email';
        cs1.Mailbox_Origin__c = '';
        caseListInsert1.add(cs1);
		
		insert caseListInsert1;
        system.debug('caseListInsert1'+caseListInsert1);
        Test.stopTest();
		List<Case> caseRetrieve = new List<Case>([SELECT Id, Mailbox__c FROM Case]);
		system.debug('caseRetrieve'+caseRetrieve[0].Mailbox__c);
		system.assertEquals(caseListInsert1.size(), 2);
		system.assertEquals(caseRetrieve.size(), 204);
        
    }
    
    @isTest
    public static void testMethodRemoveAccount(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        case cs = new case();
        cs.status = 'New';
        cs.Origin = 'Email';
        cs.AccountId = acc.id;
        insert cs;
        system.debug('cs '+cs);
    }
}