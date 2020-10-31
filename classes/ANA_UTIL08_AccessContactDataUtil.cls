/*
@Author : Accenture Offshore Dev team
@name : ANA_UTIL08_AccessContactDataUtil
@CreateDate :06-07-2017
@Description : This class updates the QuoteLineItem records.
*/
public with sharing class ANA_UTIL08_AccessContactDataUtil {
    public static Id accId;
	/* This method queries Contact records related to Account. */
    public static Contact[] queryContacts(string selectCONQuery){
        string queryStr = selectCONQuery;
        List<Contact> conLists; 
        conLists = Database.query(queryStr);
         return conLists;        
    }
}