public with sharing class ContactRelationshipHandler{

    public ContactRelationshipHandler(){
    }
    
    public static void beforeInsert(List<ContactRelationship__c> conRelList){
        ContactRelationshipsActions.updateContactTypeFields(conRelList,null,true);
    }
    
    public static void beforeUpdate(List<ContactRelationship__c> conRelList,Map<Id,ContactRelationship__c> oldMap){
        ContactRelationshipsActions.updateContactTypeFields(conRelList,oldMap,false);
    }
      
    
}