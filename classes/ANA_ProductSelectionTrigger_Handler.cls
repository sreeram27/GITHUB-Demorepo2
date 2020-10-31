/*
@Author : Accenture Offshore Dev team
@name : ANA_QuoteLineItemTrigger_Handler
@CreateDate : 20-06-2017
@Description : This class process the child QuoteLineItems.
*/
public with sharing class ANA_ProductSelectionTrigger_Handler{
    public static boolean isRecursiveupdate = false;
    public static final string AFTERCREATE_TRIGGER = 'ANA_ProductSelectionDetailAfterCreate';
    public static final string AFTERUDPATE_TRIGGER = 'ANA_ProductSelectionDetailAfterUpdate';
    public static final string AFTERDELETE_TRIGGER = 'ANA_ProductSelectionDetailAfterDelete'; 
       
     /**************************************************************************************/
    /*This method process the child QLIs in afterCreate by calling processChildCount method.*/   
    public static void afterCreate(Map<Id,ProductSelectionDetail__c> newMap){                  
           ANA_AP10_ProductSelectionCount qliPCC = new ANA_AP10_ProductSelectionCount();           
           qliPCC.processChildCount(newMap.values(),null,null,AFTERCREATE_TRIGGER);        
    }
   
    /******************************************************************************************/
    /*This method process the child QLIs in afterUpdate by calling processChildCount method.*/
    public static void afterUpdate(Map<Id,ProductSelectionDetail__c> newMap,Map<Id,ProductSelectionDetail__c> oldMap){
        if(isRecursiveupdate) {
            return;
        }      
        isRecursiveupdate = true;
        ANA_AP10_ProductSelectionCount qliPCC = new ANA_AP10_ProductSelectionCount();
        qliPCC.processChildCount(newMap.values(),oldMap,null,AFTERUDPATE_TRIGGER);       
    }
   
    /*****************************************************************************************/
    /*This method process the child QLIs in afterDelete by calling processChildCount method.*/
    public static void afterDelete(Map<Id,ProductSelectionDetail__c> oldMap){
        ANA_AP10_ProductSelectionCount qliPCC = new ANA_AP10_ProductSelectionCount();
        qliPCC.processChildCount(null,null,oldMap.values(),AFTERDELETE_TRIGGER);
    }
}