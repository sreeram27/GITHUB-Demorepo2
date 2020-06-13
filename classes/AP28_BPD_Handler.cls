/*
@author         Accenture offshore
@date           9/7/2018
@name           AP28_BPD_Helper
@description    Called from trigger on BPD object to add errors.  
*/

public with sharing class AP28_BPD_Handler{
    public static void BeforeInsertOrUpdate(List<BPD__c >newList){ 
        AP28_BPD_Helper.addError(newList);
    }   
}