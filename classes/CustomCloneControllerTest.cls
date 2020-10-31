@isTest
public class CustomCloneControllerTest {
	@TestSetup
    public static void setupTestConfig(){
        TestClassUtil.loadEnvironmentVariables();
    }
    public static testmethod void  testCaseClone(){
       Case c=(Case)TestClassUtil.getsObjectInstance(Schema.Case.sObjectType, new Map<Schema.sObjectField,Object>{Case.Subject => 'Test Subject'}, NULL);
       insert c;
       insert (CaseComment)TestClassUtil.getsObjectInstance(Schema.CaseComment.sObjectType, new Map<Schema.sObjectField,Object>{CaseComment.CommentBody => 'Test Body', CaseComment.ParentId => c.Id}, NULL);
       System.assertEquals(1,[select count() from Case]); 
       insert new EmailMessage(FromAddress = 'test@mail.org', Incoming = false, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 '+ApexUtil.getThreadId(c.Id), ParentId = c.Id); 
       Test.startTest();
       PageReference pageRef = Page.CustomClone;
       pageRef.getParameters().put('Id', c.Id);
       pageRef.getParameters().put('config', '1');
       Test.setCurrentPage(pageRef);
       CustomCloneController  controller = new CustomCloneController();
       controller.processConfigOptions(); 
       Test.stopTest(); 
       System.assertEquals(2,[select count() from Case]);
    }
}