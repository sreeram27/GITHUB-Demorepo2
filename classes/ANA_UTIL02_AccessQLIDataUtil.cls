/*
@Author : Accenture Offshore Dev team
@name : ANA_UTIL02_AccessQLIDataUtil
@CreateDate :25-05-2017
@Description : This class updates the QuoteLineItem records.
*/
public with sharing class ANA_UTIL02_AccessQLIDataUtil{
    public static set<Id> idSet1;
    public static set<Id> idSet2;
    public static set<id> optyIdSet2;
    public static String AHG;
    public static String IHM;
    public static String SFA;
    public static String APRD;
    
    
    /************************************************************************************/
    /* This method queries the QuoteLineItem records related to Opportunities via Quote. */
    public static QuoteLineItem[] queryQuoteLineItems(string selectQLIQuery){
        string queryStr = selectQLIQuery;
        List<QuoteLineItem> qlLists; 
        qlLists = Database.query(queryStr);
         return qlLists;        
    }    
    
    /************************************************************************************/
    /* This method executes the aggregate query.*/
    public static AggregateResult[] callAggregateQuery(string selectQLIQuery){
        string queryStr = selectQLIQuery;
        List<AggregateResult> qlLists;
        qlLists = Database.query(queryStr);
        return qlLists;        
    }
    
    /************************************************************************************/
    /* This method updates QuoteLineItem records. */
    public static void updateQuoteLineItems(List<QuoteLineItem> lineItems){
           database.update(lineItems,true);
    }
    /************************************************************************************/
    /* This method deletes child QuoteLineItem records. */
    public static void deleteQuoteLineItems(List<QuoteLineItem> lineItem){
           database.delete(lineItem,true);
           }
    /************************************************************************************/
    /* This method inserts child QuoteLineItem records. */
    public static void insertQuoteLineItems(List<QuoteLineItem> lineItem){
           database.insert(lineItem,true);
           }
    
}