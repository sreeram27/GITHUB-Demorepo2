@isTest
public class RelatedRequestTriggerTest {
public static testMethod void recordBeforeInsert(){
    Test.startTest();
       Release__c rele = new Release__c();
       rele.Name = 'Test';
       Database.Insert(rele,false);  
        
       Request__c req0 = new Request__c(Release__c=rele.id);
        req0.Request_Type__c = 'Configuration';
        req0.Request_Title__c = 'Test';
        req0.Status__c = 'Identify: On-Hold Waiting on Client';
        Database.insert(req0);
    
        Question_Log__c ques = new Question_log__c ( Question__c = 'Test Question'
                                                        ,Sub_Capability__c='Access'
                                                        ,Industry__c ='Products'
                                                        ,Scope__c = 'Scope Phase'
                                                        ,Domain__c = 'Account Management'
                                                        );
      Database.insert(ques);
    List<Related_Request__c> recordList= new List<Related_Request__c>();
    Related_Request__c record1 = new Related_Request__c(Request__c=req0.Id,Question_Log__c=ques.Id);
    Database.insert(record1);
    recordList.add(record1);
    Related_Request__c record2 = new Related_Request__c(Request__c=req0.Id,Question_Log__c=ques.Id);
    recordList.add(record2);
    Database.SaveResult[] recSaveResult = Database.Insert(recordList, false);
    for(Database.SaveResult sr:recSaveResult){
       if(!sr.isSuccess())
          Database.Error err = sr.getErrors()[0];
    }
    Test.stopTest();
}
}