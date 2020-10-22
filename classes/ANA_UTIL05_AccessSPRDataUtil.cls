/*
@Author : Accenture Offshore Dev team
@name : ANA_UTIL05_AccessSPRDataUtil
@CreateDate :12-06-2017
@Description : This class updates the QuoteLineItem & Service Provide Request records.
*/
public with sharing class ANA_UTIL05_AccessSPRDataUtil {
    private static final string TRIGGER_NAME = 'ANA_QuoteLineItemsAfterUpdate';
    private static final string CLASS_NAME='ANA_UTIL05_AccessSPRDataUtil';
    /*This method is used to upsert the ServiceProviderRelationship records and retrn the record ids*/
    public static set<Id> upsertServiceProviderRecord(List<ServiceProviderRelationship__c> sprlist){
        set<Id> setsprids = new set<Id>();
        try{
            Database.upsertResult[] dbupset = Database.upsert(sprlist,false);
            for(Database.upsertResult result:dbupset){
                if(result.isSuccess()){setsprids.add(result.getId());}
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TRIGGER_NAME,LoggingLevel.ERROR);    
        }
        return setsprids;
    }
    /*This method is used to update the Quotelineitem records*/
    public static void updateQuotelineitem(List<QuotelineItem> listqlitems){
        try{
            Database.SaveResult[] dbres = database.update(listqlitems,false);
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,TRIGGER_NAME,LoggingLevel.ERROR);    
        }
    }
}