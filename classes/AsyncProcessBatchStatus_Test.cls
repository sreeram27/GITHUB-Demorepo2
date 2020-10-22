@isTest
public class AsyncProcessBatchStatus_Test {
   
   
        static testmethod void sendEmailTest(){
          Map<Id,string> errorMap=new Map<Id,string>();
          Map<Id, SObject> IdToSObjectMap=new Map<Id, SObject>();
            Map<Id,string> successMap=new Map<Id,string>();
          Map<Id, SObject> SuccessIdToSObjectMap=new Map<Id, SObject>();
          
         
        
          Order o = new Order();
           

        
        
        
          IdToSObjectMap.put('01pd0000002X4iG',o);
          errorMap.put('01pd0000002X4iG','test');
          SuccessIdToSObjectMap.put('01pd0000002X4iG',o);
          successMap.put('01pd0000002X4iG','Success');
       AsyncProcessBatchStatus.CreateEmail(errorMap,5,'testing',2,3,IdToSObjectMap,'order',successMap,SuccessIdToSObjectMap);

       
    }
          static testmethod void sendEmailTestImplementationTracking(){
          Map<Id,string> errorMap=new Map<Id,string>();
          Map<Id, SObject> IdToSObjectMap=new Map<Id, SObject>();
            Map<Id,string> successMap=new Map<Id,string>();
          Map<Id, SObject> SuccessIdToSObjectMap=new Map<Id, SObject>();
          Implementation_Tracking__c i=new Implementation_Tracking__c();
          IdToSObjectMap.put('01pd0000002X4iG',i);
          errorMap.put('01pd0000002X4iG','test');
           SuccessIdToSObjectMap.put('01pd0000002X4iG',i);
          successMap.put('01pd0000002X4iG','Success');
       AsyncProcessBatchStatus.CreateEmail(errorMap,5,'testing',2,3,IdToSObjectMap,'Implementation_Tracking__c',successMap,SuccessIdToSObjectMap);

       
    }

   
}