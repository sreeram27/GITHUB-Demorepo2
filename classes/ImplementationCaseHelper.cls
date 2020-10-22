/* Author : Ranjith
// Created Date :8th July 2019 
// Purpose : To update "Id Cards Required" and "If yes, Please explain the Changes Made” Fields Based on Conditions (AC8 and AC9)
// Execution : After Insert
***/

public class ImplementationCaseHelper{
    public static void updateIdCardsRequiredIfYes(List<Order> ordlist){
        List<Order> ordupdateList=new List<Order>();
        for(Order ord : [SELECT Id,Name,AccountId,Account.Anthem_Entity__c,If_Yes_Please_Explain_IDCard_Requirement__c,ID_Cards_Required__c,Implementation_Type__c FROM Order WHERE Id IN : ordlist AND Implementation_Type__c='New Business' ]){

            if(ord.If_Yes_Please_Explain_IDCard_Requirement__c==null){
                ord.If_Yes_Please_Explain_IDCard_Requirement__c='New Business Requires ID Cards';
            }
            if(ord.ID_Cards_Required__c==null){
                ord.ID_Cards_Required__c='Yes';
            }
            ordupdateList.add(ord);
        }
        
        if(ordupdateList.size()>0){
            update ordupdateList;
        }
    }
}