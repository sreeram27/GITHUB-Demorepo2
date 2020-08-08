/*
@Author : Rahul(Vikings)
@CreateDate : 08/20/2019
@description : Handles ID card Actions
@name :IDCardActions
*/
public with sharing class IDCardActions{
    /*
    @description :populates Assigned Implementer when stage is changed to Pending Card Review.Jira ID: 39701
    @name :populateIDcardAssignedImplementer
    @param :trigger.new
    */
    public Static Void populateIDcardAssignedImplementer(List<ID_Cards__c> listIDCardsNew){
        List<ID_Cards__c> idCardList = new List<ID_Cards__c>();
        Set<ID> implementationTrackingID = new Set<ID>();
        Map<ID,Implementation_Tracking__c> trackingMap;
        
            for(ID_Cards__c idcard:listIDCardsNew){
                if(idcard.Implementation_Case_Name__c!=null){
                    idCardList.add(idcard);
                    implementationTrackingID.add(idcard.Implementation_Tracking_ID__c);
                }
            }
            
            if(!implementationTrackingID.isEmpty()){
                trackingMap= new Map<ID,Implementation_Tracking__c>([SELECT Implementation_Record_ID__r.Assigned_Implementer__c  from Implementation_Tracking__c  where ID IN :implementationTrackingID]);
            }
            
            for(ID_Cards__c varIdCard:idCardList){
                if(trackingMap.containsKey(varIdCard.Implementation_Tracking_ID__c)){ 
                    varIdCard.Assigned_Implementer__c=trackingMap.get(varIdCard.Implementation_Tracking_ID__c).Implementation_Record_ID__r.Assigned_Implementer__c;
                }
            } 
       }
       
    /** Author       ::: Ranjith Kumar
    **  Purpose      ::: To tie up with Case Installation and membership in ID Cards.
    **  Created Date ::: 17th Feb 2020
    ** Execution     ::: Before Insert.
    **/
    public static void populateCaseInstMembership(List<ID_Cards__c> idCardsList){
        Set<Id> impltrackingId=new Set<Id>();
        List<ID_Cards__c> idCardsnewList=new List<ID_Cards__c>();
        Id localRecordTypeId = Schema.SObjectType.ID_Cards__c.getRecordTypeInfosByName().get('Local').getRecordTypeId();
        
        for(ID_Cards__c idcard : idCardsList){
            if(idcard.Implementation_Tracking_ID__c!=null && idcard.RecordTypeId==localRecordTypeId){
                impltrackingId.add(idcard.Implementation_Tracking_ID__c);
                idCardsnewList.add(idcard);
            }
        }
        
        Map<Id,Issue_Control__c> casInstMap=new Map<Id,Issue_Control__c>();
        Map<Id,Enrollment_and_Billing__c> membMap=new Map<Id,Enrollment_and_Billing__c>();
        if(impltrackingId.size()>0){
            for(Issue_Control__c csinst : [SELECT Id,Name,Implementation_Tracking_ID__c FROM Issue_Control__c WHERE Implementation_Tracking_ID__c=:impltrackingId]){
                casInstMap.put(csinst.Implementation_Tracking_ID__c,csinst);
            }
            
            for(Enrollment_and_Billing__c memb : [SELECT Id,Name,Implementation_Tracking_ID__c FROM Enrollment_and_Billing__c WHERE Implementation_Tracking_ID__c=:impltrackingId]){
                membMap.put(memb.Implementation_Tracking_ID__c,memb);
            }
        }
        
        if(idCardsnewList.size()>0){
            for(ID_Cards__c idcard : idCardsnewList){
                if(casInstMap.containsKey(idcard.Implementation_Tracking_ID__c)){
                    idcard.Case_Installation__c=casInstMap.get(idcard.Implementation_Tracking_ID__c).Id;
                }
                if(membMap.containsKey(idcard.Implementation_Tracking_ID__c)){
                    idcard.Membership__c=membMap.get(idcard.Implementation_Tracking_ID__c).id;
                }
            }
        }
        
    }
    
}