/**
_____________________________________________________________________________________________________________

Change History: PRDCRM-44530 (Deloitte Offshore)
Description:    Added mcsRecordTypeId recordtype check to create MCS IMP Tracking record
Date:           06/12/2019
_____________________________________________________________________________________________________________
*/
trigger ImplementationTrackingTrigger on Implementation_Tracking__c (after insert) {
    
    
    Set<Id> OrderIds = new Set<Id>();
    
    //fetch the Local and JAA Record type Ids
    Id localRecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(Label.ImplementationTracking_Local).getRecordTypeId();
    Id jaaRecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(Label.ImplementationTracking_JAA).getRecordTypeId();
    Id mcsRecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(Label.ImplementationTracking_MCS).getRecordTypeId();
    
    List<Implementation_Tracking__c> ImplementationTrackingList = new List<Implementation_Tracking__c>();
    
    ImplementationTrackingList = [SELECT ID, RecordTypeID, Implementation_Record_ID__r.Implementation_Status__c, Implementation_Record_ID__c ,Implementation_Record_ID__r.ID_Cards_Required__c
                                  FROM Implementation_Tracking__c
                                  WHERE ID IN: trigger.new];

        if(ImplementationTrackingList.size()>0){
        for(Implementation_Tracking__c ImpTrack : ImplementationTrackingList) {
            
            
            if(
                //Start:44530
                (
                    ImpTrack.RecordTypeID == localRecordTypeId ||
                    ImpTrack.RecordTypeID == jaaRecordTypeId ||
                    ImpTrack.RecordTypeID == mcsRecordTypeId
                    
                ) 
                //End:44530
                && 
                ImpTrack.Implementation_Record_ID__r.ID_Cards_Required__c == staticVariableClass.UpsellYes && 
                ImpTrack.Implementation_Record_ID__r.Implementation_Status__c == staticVariableClass.PendingSmeReview
            ) {
                
                OrderIds.add(ImpTrack.Implementation_Record_ID__c); // Add Order Ids
            }
            
        }
    }
    
    if(!OrderIds.isEmpty()){
        LGSMERecordCreation.generateIDCards(OrderIds);
    }
}