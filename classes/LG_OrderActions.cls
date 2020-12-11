/**
@author Ravideep Singh (Vikings)
@createDate 02/04/2020
@description This is action class for implementation case(order).
@Modified : 1) Ravideep(Vikings) -02/04/2020 - PRDCRM-49125 - Prevent ICR status to change to withdrawn if underwriting record stage is approved 
*/
public with sharing class LG_OrderActions {  

public String local = staticVariableClass.Entity;

/*******************************************************************************************************
* @description Errors out ICR record if related Underwriting record has status 'Approved'-PRDCRM-49125 - Ravideep(Vikings)
* @param Accepts list of Order Ids to be processed and trigger.new
* @return Doesn't return anything
*/

    public void showErrorICRUpdate(Set<Id> orderIds,List<Order> newOrderList){
        Set<Id> errorOrderIds = new Set<Id>();
        List<Underwriting__c> underwritingList = new List<Underwriting__c>();
        
        /*
        getting all underwriting records that are grandchildren of ICR records being inserted
        */
        underwritingList = [SELECT id,Stage__c,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c FROM Underwriting__c WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c IN: orderIds and Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local];
        
        if(!underwritingList.isEmpty()){
            system.debug('underwritingList-> ' + underwritingList);
            for(Underwriting__c uwr : underwritingList){
                if(uwr.stage__c != null && uwr.stage__c == staticVariableClass.APPROVED){
                    errorOrderIds.add(uwr.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                }
                
            }
        }
        /*
            setting error message for all ICR records that are associated to a UW record with stgage approved
        */
        
        if(!errorOrderIds.isEmpty()){
            
            system.debug('errorOrderIds-> ' + errorOrderIds);
            for(order thisOrder : newOrderList ){
                if(errorOrderIds.contains(thisOrder.id)){
                    thisOrder.addError(staticVariableClass.UNDERWRITING_ERROR);
                }
            }
        }
    }
}