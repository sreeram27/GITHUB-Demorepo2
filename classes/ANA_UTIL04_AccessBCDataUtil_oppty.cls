/*
@Author : 
@name : ANA_UTIL04_AccessBCDataUtil_oppty
@CreateDate :
@Description : This class queries the Brokerage and Consultant records at the opportunity level.
*/
public with sharing class ANA_UTIL04_AccessBCDataUtil_oppty{
    private static final string CLASS_NAME='ANA_UTIL04_AccessBCDataUtil_oppty';
     public static String OpportunityId;
    /* This method queries the QuoteLineItem records related to Opportunities via Quote. */
    public static Brokerage_and_Consultant1__c[] queryBCrecords(string selectBCQuery){   
    string queryBCStr = selectBCQuery;
    List<Brokerage_and_Consultant1__c> bcLists;       
        try{ 
            bcLists = Database.query(queryBCStr);           
        }
        catch(Exception excp){ UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, CLASS_NAME, ANA_UTIL03_Constants.CANCEL,null,LoggingLevel.ERROR);    
        }
        return bcLists;        
    }   
}