/*
@Author : Accenture Offshore Dev team
@name : ANA_QuoteLineItemTrigger_Handler
@CreateDate : 30-05-2017 
@Description : This class process the child QuoteLineItems.
*/
public with sharing class ANA_QuoteLineItemTrigger_Handler{
    public static boolean isRecursiveupdate = false;
    public static final string AFTERCREATE_TRIGGER = 'ANA_QuoteLineItemsAfterCreate';
    public static final string AFTERUDPATE_TRIGGER = 'ANA_QuoteLineItemsAfterUpdate';
    public static final string AFTERDELETE_TRIGGER = 'ANA_QuoteLineItemsAfterDelete';
    public static final string BEFOREDELETE_TRIGGER = 'ANA_QuoteLineItemsBeforeDelete'; 
       
     /***************************************************************************************/
    /*This method process the child QLIs in afterCreate by calling processChildCount method.*/   
    public static void afterCreate(Map<Id,QuoteLineItem> newMap){                
           ANA_AP06_QLI_Process_ChildCount qliPCC = new ANA_AP06_QLI_Process_ChildCount();           
           qliPCC.processChildCount(newMap.values(),null,null,AFTERCREATE_TRIGGER);
           qliPCC.insertChildQLI(newMap.values(),null,null,AFTERCREATE_TRIGGER);
        /******Commented on 23/08/2017 as SericeProviderRelationship creation is not in scope.*******/
           //ANA_AP07_ServiceProviderRecord.serviceProviderRecordupsert(newMap);       
    }
   
    /******************************************************************************************/
    /*This method process the child QLIs in afterUpdate by calling processChildCount method.*/
    public static void afterUpdate(Map<Id,QuoteLineItem> newMap,Map<Id,QuoteLineItem> oldMap){
        system.debug('isRecursiveupdate============'+isRecursiveupdate);
        if(isRecursiveupdate) {
            return;
        }      
        isRecursiveupdate = true;
        ANA_AP06_QLI_Process_ChildCount qliPCC = new ANA_AP06_QLI_Process_ChildCount();
        qliPCC.processChildCount(newMap.values(),oldMap,null,AFTERUDPATE_TRIGGER);
        system.debug('###In qLI Handler');
        qliPCC.updateFlagOnOpty(newMap.values(),AFTERUDPATE_TRIGGER);
        QuoteLineItemActions.updateSBC(newMap,oldMap);
        /******Commented on 23/08/2017 as SericeProviderRelationship creation is not in scope.*******/
        //ANA_AP07_ServiceProviderRecord.serviceProviderRecordupsert(newMap);
    }
   /*****************************************************************************************/
    /*This method process the child QLIs in afterDelete by calling processChildCount method.*/
    public static void afterDelete(Map<Id,QuoteLineItem> oldMap){
        ANA_AP06_QLI_Process_ChildCount qliPCC = new ANA_AP06_QLI_Process_ChildCount();
        qliPCC.processChildCount(null,null,oldMap.values(),AFTERDELETE_TRIGGER);
        qliPCC.updateFlagForDelete(oldMap.values(),AFTERDELETE_TRIGGER);
    }
      /*****************************************************************************************/
      /*This method process the parent QLIs in beforeDelete by calling deleteChildQLI method.*/
     public static void beforeDelete(Map<Id,QuoteLineItem> oldMap){
       ANA_AP06_QLI_Process_ChildCount  qliPCC1 = new ANA_AP06_QLI_Process_ChildCount();
       qliPCC1.deleteQLIActwiseCompanionProduct(null,oldMap,oldMap.values(),BEFOREDELETE_TRIGGER);
       qliPCC1.deleteChildQLI(null,null,oldMap.values(),BEFOREDELETE_TRIGGER);
    }
 }