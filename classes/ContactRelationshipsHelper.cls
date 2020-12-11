/** Author       ::: Ranjith Kumar
**  Created      ::: 24th Feb 2020
**  Purpose      ::: To Implement the "Billing Contact" and "Group Administrator" functionality for Contact Relationship Object.
**  Version      ::: v1
**/

public class ContactRelationshipsHelper{
    
    /** Author       ::: Ranjith Kumar
    **  Created      ::: 24th Feb 2020
    **  Purpose      ::: To update "Billing_Contact__c" ,"Group_Admin__c" and "Biiling_Contact_and_Group_Admin__c" fields in Contact Relationship Object based on Contact Type field Values.
    **  Execution    ::: Before Insert and Before Update
    **/
    public static void updateContactTypeFields(List<ContactRelationship__c> conRelList,Map<Id,ContactRelationship__c> oldMap,boolean isInsert){
        for(ContactRelationship__c conRel : conRelList){
            if(isInsert || (!isInsert && oldMap.get(conRel.Id).Contact_Type__c!=conRel.Contact_Type__c)){
                if(!conRel.Contact_Type__c.contains('Billing Contact') && conRel.Contact_Type__c!=null && conRel.Contact_Type__c.contains('Group Administrator')){
                    conRel.Group_Admin__c=true;
                }
                if(conRel.Contact_Type__c!=null && !conRel.Contact_Type__c.contains('Group Administrator') && conRel.Group_Admin__c==true){
                    conRel.Group_Admin__c=false;
                }
                if(!conRel.Contact_Type__c.contains('Group Administrator') && conRel.Contact_Type__c!=null && conRel.Contact_Type__c.contains('Billing Contact')){
                    conRel.Billing_Contact__c=true;
                }
                if(conRel.Contact_Type__c!=null && !conRel.Contact_Type__c.contains('Billing Contact') && conRel.Billing_Contact__c==true){
                    conRel.Billing_Contact__c=false;
                }
                if(conRel.Contact_Type__c.contains('Group Administrator') && conRel.Contact_Type__c.contains('Billing Contact')){
                    conRel.Biiling_Contact_and_Group_Admin__c=true;
                }
                if((!conRel.Contact_Type__c.contains('Group Administrator') || !conRel.Contact_Type__c.contains('Billing Contact')) && conRel.Biiling_Contact_and_Group_Admin__c==true && conRel.Contact_Type__c!=null){
                    conRel.Biiling_Contact_and_Group_Admin__c=false;
                }
            }
        }
    }
    
}