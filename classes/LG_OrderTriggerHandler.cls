/**
@author Sharath KN (Vikings)
@createDate 04/09/2019
@description This is handler class for OrderAfterUpdate.
@Modified : 1) Ravideep(Vikings) -02/03/2020 - PRDCRM-49125 - Prevent ICR status to change to withdrawn if underwriting record stage is approved 
*/
public with sharing class LG_OrderTriggerHandler {  

public String local = staticVariableClass.Entity;
public static String grpSize = '51 - 99';

/*******************************************************************************************************
* @description Processes list of Orders to be processed for update trigger
* @param Accepts list of Orders and it's old map to be processed 
* @return Doesn't return anything
*/    
    public void onAfterUpdate(List<Order> newOrder, List<Order> oldOrder, Map<ID, Order> newOrderMap, Map<ID, Order> oldOrderMap){
        List<Id> orderIds = new List<Id>();
        for(Order thisOrder: newOrder){
            if(thisOrder.Impacted_Products__c != oldOrderMap.get(thisOrder.Id).Impacted_Products__c){
                orderIds.add(thisOrder.Id);
            }
        }
        if(orderIds.size()>0){
            LG_OrderTriggerHandler OTH = new LG_OrderTriggerHandler();
            OTH.updateImpProducts(orderIds);
        }
    }
    
/*******************************************************************************************************
* @description Processes list of Orders to be processed for before update trigger - PRDCRM-49125 - Ravideep(Vikings)
* @param Accepts list of Orders and it's old map to be processed 
* @return Doesn't return anything
*/  
    public void onBeforeUpdate(List<Order> newOrderList, Map<ID, Order> oldOrderMap){
        Set<Id> orderIds = new Set<Id>();
        for(Order thisOrder: newOrderList){
            if((thisOrder.Implementation_Status__c != oldOrderMap.get(thisOrder.Id).Implementation_Status__c) && (thisOrder.Implementation_Status__c ==staticVariableClass.WITHDRAWN)){
                orderIds.add(thisOrder.Id);
            }
        }
        if(!orderIds.isEmpty()){
            LG_OrderActions OrderAction = new LG_OrderActions();
            OrderAction.showErrorICRUpdate(orderIds,newOrderList);
        }
    }
        
/*******************************************************************************************************
* @description Updates the value from Order's Impacted Products field to corresponding Case Installation records
* @param Accepts list of Order Ids to be processed
* @return Doesn't return anything
*/
    public void updateImpProducts(List<Id> orderIdList){
        Map<Id,String> recordIdValue = new Map<Id,String>();
        List<Issue_Control__c> updateList = new List<Issue_Control__c>();
        for(Issue_Control__c thisIC : [SELECT id,Impacted_Products__c,Implementation_Tracking_ID__r.Implementation_Record_ID__r.Impacted_Products__c FROM Issue_Control__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c IN: orderIdList]){
            recordIdValue.put(thisIC.Id, thisIC.Implementation_Tracking_ID__r.Implementation_Record_ID__r.Impacted_Products__c);
        }
        if(recordIdValue.size()>0){
            for(Id thisId : recordIdValue.keyset()){
                Issue_Control__c thisIc = new Issue_Control__c();
                thisIc.Id = thisId;
                thisIc.Impacted_Products__c = recordIdValue.get(thisId);
                updateList.add(thisIc);
            }
        }
        if(updateList.size()>0){
          Database.update(updateList);
        }
    }
}