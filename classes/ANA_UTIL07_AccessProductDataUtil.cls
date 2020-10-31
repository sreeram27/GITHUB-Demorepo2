/*
@Author : Accenture Offshore Dev team
@name : ANA_UTIL07_AccessProductDataUtil
@CreateDate :04-07-2017
@Description : This class queries the child product(Programs) records.
*/
public with sharing class ANA_UTIL07_AccessProductDataUtil {
     public static Id prodid;
     public static Id parentQLI;
     public static set<Id> idSet5;
     public static set<Id> idSet6;
/* This method queries the product child records related to a parent product . */
    public static vlocity_ins__ProductChildItem__c[] queryProdChildItems(string selectPCIQuery){
        string queryStr = selectPCIQuery;
        List<vlocity_ins__ProductChildItem__c> progLists; 
        progLists = Database.query(queryStr);
         return progLists;        
    }
    /* This method queries the child product records. */
    public static vlocity_ins__ProductChildItem__c[] queryProdItems(string selectPCIQuery){
         return Database.query(selectPCIQuery);        
    }
        /* This method queries the product records. */
    public static Product2[] queryProds(string selectPCIQuery){
         return Database.query(selectPCIQuery);        
    }
    /* This method queries the PricebookEntry records. */
    public static map<Id,Id> queryPriceBookEntry(string selectPCIQuery){            
        map<Id,Id> prdPriceMap = new Map<Id,Id>();        
        for(PricebookEntry pbe: Database.query(selectPCIQuery)){
          prdPriceMap.put(pbe.Product2Id,pbe.Id);  
        }
        return prdPriceMap;        
    }
    /* This method queries the child product of a parent product . */
    public static QuoteLineItem[] queryChildProds(string selectCPQuery){
        string queryStr = selectCPQuery;
        List<QuoteLineItem> progLists; 
        progLists = Database.query(queryStr);
         return progLists;        
    }
}