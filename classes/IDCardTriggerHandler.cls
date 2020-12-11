/*
@Author : Rahul(Vikings)
@CreateDate : 08/20/2019
@description : Handler for ID card Object
*/
public with sharing class IDCardTriggerHandler{
    /*
    @description :Method is invoked on before update event
    @name :onBeforeUpdate
    @param :trigger.new
    */
    Public Static Void onBeforeInsert(List<ID_Cards__c> listIDCardsNew){
       IDCardActions.populateIDcardAssignedImplementer(listIDCardsNew);
       IDCardActions.populateCaseInstMembership(listIDCardsNew); // This is added by Ranjith 
    }
    
}