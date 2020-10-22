/*
@Author : Accenture Offshore Dev team
@name : ANA_UTIL11_AccessAlternateNetworkUtil
@CreateDate :4-09-2017
@Description : This class queries the Alternate Network records.
*/
public with sharing class ANA_UTIL11_AccessAlternateNetworkUtil{
public static set<Id> idSet4;
    /************************************************************************************/
    /* This class queries the Alternate Network records. */
    public static AlternateNetwork__c[] queryAlternateNetworks(string selectQLIQuery){
        string queryStr = selectQLIQuery;
        List<AlternateNetwork__c> alternateNetworks; 
        alternateNetworks= Database.query(queryStr);
        return alternateNetworks;        
    }
  /* This method deletes Alternate Network records */
    public static void deleteNetworks(List<AlternateNetwork__c> networks){
           database.delete(networks,true);
           }  
}