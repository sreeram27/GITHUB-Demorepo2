/*
@Author : Accenture Offshore Dev team
@name : ANA_UTIL10_AccessProductSelectionUtil
@CreateDate :4-09-2017
@Description : This class queries the Product selection records.
*/
public with sharing class ANA_UTIL10_AccessProductSelectionUtil{
    public static set<Id> idSet3;
/************************************************************************************/
/* This method queries the Product selection records related to Quotvia Quote. */
    public static ProductSelectionDetail__c[] queryProductSelections(string selectQLIQuery){
        string queryStr = selectQLIQuery;
        List<ProductSelectionDetail__c> prLists; 
        prLists= Database.query(queryStr);
        return prLists;        
    }
     /* This method deletes Product selection records */
    public static void deleteSelections(List<ProductSelectionDetail__c> products){
           database.delete(products,true);
           }
}