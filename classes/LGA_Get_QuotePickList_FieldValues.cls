/**
* @File Name          : LGA_Get_QuotePickList_FieldValues.cls
* @Description        : 
* @Author             : Accenture OffShore 
* @Group              : Raptors
* @Modification Log   : 
* Ver       Date            Author      		    Modification
* 1.0    2/13/2020     Accenture OffShore         Initial Version
**/
global  with sharing class LGA_Get_QuotePickList_FieldValues implements vlocity_ins.VlocityOpenInterface2 {
    
    /**
* @description 
* @author ChangeMeIn@UserSettingsUnder.SFDoc | 2/13/2020 
* @param methodName 
* @param inputMap 
* @param outMap 
* @param optns 
* @return Boolean 
**/
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String,Object > outMap, Map < String, Object > optns) {
        system.debug('@@@@@@@@@@@ enter into method');
        if(LGA_Constants.GETPICKVAL.equalsIgnoreCase(methodName)){
            system.debug('@@@@@@@@@@@ enter into method');
            getPicklistValues(inputMap, outMap, optns);
        }
        return true;   
    }
    
    
    /**
* @description 
* @author ChangeMeIn@UserSettingsUnder.SFDoc | 2/13/2020 
* @param input 
* @param outMap 
* @param optns 
* @return void 
**/
    global void getPicklistValues (Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns){
        
        system.debug('@@@@@@@@@@@ enter into method');
        List<String> fundingValues = new List<String>();
        List<String> hsaValues = new List<String>();
        List<String> benfitValues = new List<String>();
        
        Schema.DescribeFieldResult fieldResult1 = QuoteLineItem.Funding__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult1.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            fundingValues.add(pickListVal.getLabel());
        }
        Schema.DescribeFieldResult fieldResult2 = QuoteLineItem.HSABankingPartner__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult2.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple1){
            hsaValues.add(pickListVal.getLabel());
        }
        Schema.DescribeFieldResult fieldResult3 = QuoteLineItem.Benefit_Period__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult3.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple2){
            benfitValues.add(pickListVal.getLabel());
        }         
        
        outMap.put(LGA_Constants.FUNDVAL,fundingValues);
        outMap.put(LGA_Constants.HSAVALUES,hsaValues);
        outMap.put(LGA_Constants.BENEFIRVALS,benfitValues);
        
        
    }
}