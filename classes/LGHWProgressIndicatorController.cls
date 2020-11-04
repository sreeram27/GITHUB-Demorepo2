/*
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name              LGHWProgressIndicatorController
 * @Author            Deloitte offshore (Gladiators)
 * @ModifiedBy        Deloitte offshore (Gladiators)
 * @CreatedDate       25th November 2019
 * @UsedBy            LGHWProgressIndicatorCmp (Lightning Component)
 * @User Story        HW Indicator - PRDCRM- 48531
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * @description used by LGHWProgressIndicatorCmp to show the Queueable Apex Status 
 * 
 * Additional information
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * Changes
 * vX.X(Version)            Name
 * Date                     Explanation
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
public with sharing class LGHWProgressIndicatorController{
       /**
        ________________________________________________________________________________________
         * @description This methood is used get AsyncApexJob Id and AsyncApexJob record if id not null
      _________________________________________________________________________________________
        *@param: sQuoteIdentifier- hold quoteId
       _________________________________________________________________________________________
    
        *@return: AsyncApexJob  - returns Object AsyncApexJob. 
      _________________________________________________________________________________________
     */
    @AuraEnabled
    public static AsyncApexJob getApexJobsStatus(String sQuoteIdentifier){
        List<AsyncApexJob> listCurrentApexJob ; 
        List<Quote> listCurrentQuote;
        if(sQuoteIdentifier != null){
            listCurrentQuote = new List<Quote>([Select Id, ApexAsyncJobId__c 
                                                			FROM Quote 
                                                			WHERE ID =: sQuoteIdentifier]);
          	if(listCurrentQuote.size()>0 && 
               !String.isBlank(listCurrentQuote[0].ApexAsyncJobId__c) && 
               listCurrentQuote[0].ApexAsyncJobId__c !=null){
                   
              		listCurrentApexJob = new List<AsyncApexJob>([SELECT Id, ApexClass.Name,Status,JobType 
                                                           					FROM AsyncApexJob 
                                                           					WHERE Id =: listCurrentQuote[0].ApexAsyncJobId__c]);
          	}
            if(listCurrentApexJob !=null && listCurrentApexJob.size()>0){
              return listCurrentApexJob[0];
          	}
        }
        return null;
    }
    
    /**
        ________________________________________________________________________________________
         * @description This methood is used get Exception log details.
       _________________________________________________________________________________________
        *@param: sJobIdentifier - String
       _________________________________________________________________________________________
    
        *@return: Integer - size of exception log 
      _________________________________________________________________________________________
     */
    @AuraEnabled
    public static Integer getExceptionLogDetails(String sJobIdentifier){
        List<ExceptionLog__c> listExcepLog;
        if(sJobIdentifier!=null){
            listExcepLog = new List<ExceptionLog__c>([SELECT Id, ApexAsyncJobId__c , ClassName__c, MethodName__c 
                                                      				FROM ExceptionLog__c 
                                                      				WHERE ApexAsyncJobId__c = :sJobIdentifier]);
        }
        if(!listExcepLog.isempty() && listExcepLog!=null){
            return listExcepLog.size();
        }
        return 0;
    }
}