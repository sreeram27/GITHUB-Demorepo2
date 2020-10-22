/*
@Author : Accenture Offshore Dev team
@name : ANA_UTIL04_AccessBCDataUtil
@CreateDate :30-05-2017
@Description : This class queries the Brokerage and Consultant records.
*/
public with sharing class ANA_UTIL04_AccessBCDataUtil{
	private static final string CLASS_NAME='ANA_UTIL04_AccessBCDataUtil';
	 public static String accountId;
	/* This method queries the QuoteLineItem records related to Opportunities via Quote. */
    public static Brokerage_and_Consultant__c[] queryBCrecords(string selectBCQuery){   
    string queryBCStr = selectBCQuery;
	List<Brokerage_and_Consultant__c> bcLists;       
        try{ 
            bcLists = Database.query(queryBCStr);           
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,null,LoggingLevel.ERROR);    
        }
        return bcLists;        
    }	
}