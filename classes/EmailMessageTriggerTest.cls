@isTest
public class EmailMessageTriggerTest {
    @testsetup
    static void createTestData(){
        Account acc = new Account();
        acc.recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        acc.Name = 'Test Account';
        acc.Situs_State__c='ANA';
        acc.Branding__c='Anthem BCBS';
        insert acc;
        
        case cs = new case();
        cs.status = 'New';
        cs.Origin = 'Email';
        cs.AccountId = acc.id;
        insert cs;
        
         Opportunity newOpp = new Opportunity(
            name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' + acc.Name),
            StageName = staticVariableClass.ClosedWon,
            AccountID = acc.id,
            CloseDate = System.Date.today().toStartOfMonth(),                   
            recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId()                                    
        );
        
        insert newOpp;
        
        insert new CS_LG01_Start_Enrollment_Email_Footer__c(Name=acc.Situs_State__c + '_' + acc.Branding__c);
        EmailMEssage em =new EmailMEssage();
        em.incoming = true;
        em.ParentId= cs.id;
        em.RelatedToId=newOpp.Id;
        em.TextBody='Test Body';
        em.FromAddress='test1@gmail.com';
        em.subject=System.Label.LG01_Start_Enrollment_Email_Subject + ' ' + acc.Name + ' - ' + newOpp.CloseDate.format();
        insert em;
    }
    
    @isTest
    public static void testCheckAndCopyDescription(){
        list<case> csExpected = [select id, description, Email_Description__c from case];
        system.assertEquals('See Email Description Field for full email transcript.', csExpected[0].description);
        system.assertEquals('Test Body', csExpected[0].Email_Description__c);
    }
}