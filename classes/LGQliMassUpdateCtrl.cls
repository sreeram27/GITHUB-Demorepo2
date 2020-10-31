/*
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * Name              LGQliMassUpdateCtrl
 * Author            Deloitte offshore (Gladiators)
 * ModifiedBy        Deloitte offshore (Gladiators)
 * CreatedDate       21st August 2019
 * UsedBy            LGQliMassUpdate (Lightning Component)
 * User Story        PRDCRM-41009-Plan Mass update 
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * @description Used by Lightning component to update multiple Quote Line Items.
 * 
 * 
 * Additional information
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * Changes
 * vX.X(Version)            Name
 * Date                     Explanation
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
public with sharing class LGQliMassUpdateCtrl  {
    /*
     * ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * @description Fetch the Plans Under the Quote 
     * 
     * -------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * @param  quoteId          Quote Id                            String
     * @return  DataWrapper     Wrapper with picklists and Qli data
     * --------------------------------------------------------------------------------------------------------------------------------------------------------------------
     */ 
    @AuraEnabled
    public static DataWrapper getAllQlis(String quoteId){
        
        List<QliDataWrapper> qliDataWrapperList = new List<QliDataWrapper>();
        List<DependentPickListValues> oppStagePickvalWapList = new List<DependentPickListValues>();
        List<DependentPickListValues> recReasonPickvalWapList = new List<DependentPickListValues>();
        List<PickListValues> planTypepickValLst= new List<PickListValues>();
        Map<String,List<QlichildData>> childDataMap = new Map<String,List<QlichildData>>();
        String sPooledNonPooled = '';
        String sSitusState = '';
        if(!String.isBlank(quoteId)){
            
            // Dynamic URL of Quote to return to Quote Page 
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + staticVariableClass.slash + quoteId;
            
            //Parent to Child Qli Mappings
            for ( QuoteLineItem qli : [SELECT Id,QuoteId,Product2.Name,ProductStage__c,Reason__c,Plan_Type__c,HPCC_Code__c,vlocity_ins__ContractCode__c,
                                        Contract_Codes__c,Contract_Code_ASF__c,Quote.Account.Pooled_Non_Pooled__c,Quote.Account.Situs_State__c,
                                        OppType__c,RecordType__c,ParentQuoteLineItem__c,ParentQuoteLineItem__r.Product2.Name,Product_Type__c,Product2.Plan_Type__c
                                        FROM QuoteLineItem 
                                        Where QuoteId =: quoteId 
                                        AND ( Product_Type__c = :staticVariableClass.Medical OR Product_Type__c =: staticVariableClass.Vision)
                                        AND ProductCategory__c=:staticVariableClass.Plan 
                                         Order By Product2.Name]){
                 //GLD-PRDCRM - 52626 : Plan Update Screen and Quote Plan Card Update                            
                 if(qli.Product_Type__c == staticVariableClass.Vision){
                     if(childDataMap.containsKey(staticVariableClass.VISION_PLANS)){
                         childDataMap.get(staticVariableClass.VISION_PLANS).add(new QlichildData(qli,false,false,false,false,false));
                     }else{
                        childDataMap.put(staticVariableClass.VISION_PLANS,new List<QlichildData>{ new QlichildData(qli,false,false,false,false,false) });
                     }
                 }else{
                    if(childDataMap.containsKey(qli.ParentQuoteLineItem__c+','+qli.ParentQuoteLineItem__r.Product2.Name)){
                        childDataMap.get(qli.ParentQuoteLineItem__c+','+qli.ParentQuoteLineItem__r.Product2.Name).add(new QlichildData(qli,false,false,false,false,false) );
                    }else{
                        childDataMap.put(qli.ParentQuoteLineItem__c+','+qli.ParentQuoteLineItem__r.Product2.Name,new List<QlichildData>{ new QlichildData(qli,false,false,false,false,false) });
                    }
                }
                //Gladiators - sprint 201.1 - PRDCRM : 50723
                sPooledNonPooled = sPooledNonPooled == '' ? qli.Quote.Account.Pooled_Non_Pooled__c : sPooledNonPooled;  
                sSitusState      = sSitusState == '' ? qli.Quote.Account.Situs_State__c : sSitusState;
             } 
            //Adding Parent and Child to Wrapper
            if(!childDataMap.isEmpty()){
                for(String prodName : childDataMap.keySet()){
                    //GLD-PRDCRM - 52626 : Plan Update Screen and Quote Plan Card Update   
                    if(prodName == staticVariableClass.VISION_PLANS){
                      qliDataWrapperList.add(new QliDataWrapper
                                             	(new ParentWrapper
                                                 	(null,staticVariableClass.VISION_PLANS,false),
                                                	 new List<QlichildData>(childDataMap.get(staticVariableClass.VISION_PLANS))
                                                )
                                            ); 
                    }else{
                       qliDataWrapperList.add(new QliDataWrapper
                                              	(new ParentWrapper
                                                 	(prodName.split(',')[0],prodName.split(',')[1],false),
                                                 	 new List<QlichildData>(childDataMap.get(prodName))
                                                )
                                             ); 
                    }
                }
            }
            
            // Plan type Picklist Values
            Schema.DescribeFieldResult fieldResult = QuoteLineItem.Plan_Type__c.getDescribe();
            if(!fieldResult.getPicklistValues().isEmpty() ){
                for( Schema.PicklistEntry pickListVal : fieldResult.getPicklistValues()){
                    //Gladiators - sprint 201.1 - PRDCRM : 50723
                    if(!(sPooledNonPooled == staticVariableClass.POOLED && 
                         sSitusState == staticVariableClass.California && 
                         pickListVal.getValue() == staticVariableClass.STANDARD)){
                        planTypepickValLst.add( new PickListValues(pickListVal.getLabel(),pickListVal.getValue()));
                    }
                }  
            }
            
            //Opptype -- Stage Picklist Values
            Map<String, List<String>> oppStagePickListVal =   getDependentPickVal(new QuoteLineItem(),staticVariableClass.OppType,staticVariableClass.ProductStage);
            
            if(!oppStagePickListVal.isEmpty()){
                for(String str: oppStagePickListVal.keySet()){
                    oppStagePickvalWapList.add(new DependentPickListValues(str,oppStagePickListVal.get(str)));
                } 
            }
            
            //Record Type--Reason Picklist values
            Map<String, List<String>> recReasonPickListVal =   getDependentPickVal(new QuoteLineItem(),staticVariableClass.RecordType,staticVariableClass.Reason);
            
            if(!recReasonPickListVal.isEmpty()){
                for(String str: recReasonPickListVal.keySet()){
                    recReasonPickvalWapList.add(new DependentPickListValues(str,recReasonPickListVal.get(str)));
                }
            }
            
            // Master Wrapper with all the picklist Values, Record URL and the Parent-child QLI Wrapper
            DataWrapper dataWrap = new DataWrapper
                (
                    fullRecordURL !=null ? fullRecordURL:'' ,
                    qliDataWrapperList.size()>0 ? qliDataWrapperList : null,
                    planTypepickValLst.size()>0 ? planTypepickValLst : null,
                    oppStagePickvalWapList.size()>0 ? oppStagePickvalWapList : null ,
                    recReasonPickvalWapList.size()>0 ? recReasonPickvalWapList : null 
                );
            return dataWrap;
        }
        return null;
    }
     /*
     * ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * @description update the Edited Quote Line Items
     *
     * -------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * @param  qliToUpdate      List of Quote Line Items to Udpate              List
     * @return  String          Validation Error if any else null
     * --------------------------------------------------------------------------------------------------------------------------------------------------------------------
     */

    @AuraEnabled
    public static String updateQli(List<QuoteLineItem> qliToUpdate){
        try{
            if(!qliToUpdate.isEmpty()){
             update qliToUpdate;
        }
        }catch(DMLException exp){
            return exp.getMessage();
        }
        return null;
    }
     /*
     * -----------------------------------------------------------------------------------------------------------------------------------------------------------
     * @description Fetches Dependent Picklist Values
     *
     * -----------------------------------------------------------------------------------------------------------------------------------------------------------
     * @param  obj                          List of Quote Line Items to Udpate                          sObject
     * @param  ctrlField                    Controlling Field Name                                      String
     * @param   deptField                   Dependent field name                                        String
     * @return  Map<String, List<String>>   Map of Controlling and dependent fields('xyz',List<String>) 
     * -----------------------------------------------------------------------------------------------------------------------------------------------------------
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getDependentPickVal(sObject obj,String ctrlField, String deptField){
        return  LGQliGetDependentPicklistValues.getDependentMap(obj,ctrlField,deptField);
    }
    /*
    * @description Master Wrapper
    */ 
    public class DataWrapper{
        
        @AuraEnabled
        public List<PickListValues> planTypePickListVal;
        
        @AuraEnabled
        public List<DependentPickListValues> oppStagePickvalWapList;
        
        @AuraEnabled
        public List<DependentPickListValues> recReasonPickvalWapList;
        
        @AuraEnabled
        public List<QliDataWrapper> qliDataWrapperList;
        
        @AuraEnabled
        public String domainUrl;
        /**
        * @description DataWrapper Constructor
        */
        DataWrapper(String domUrl,List<QliDataWrapper> qliDataWrapperList,List<PickListValues> planTypePickListVal ,List<DependentPickListValues> oppStagePicklist,List<DependentPickListValues> recReasonPickList){
            this.domainUrl = domUrl; 
            this.qliDataWrapperList = new List<QliDataWrapper>(qliDataWrapperList);
            this.planTypePickListVal = new List<PickListValues> (planTypePickListVal);
            this.oppStagePickvalWapList = new List<DependentPickListValues>(oppStagePicklist);
            this.recReasonPickvalWapList = new List<DependentPickListValues>(recReasonPickList);
        }
    }
    /**
    * @description plan type picklist Wrapper
    */ 
    public class PickListValues{
        @AuraEnabled
        public String label;
        @AuraEnabled 
        public String value;
       /**
        * @description PickListValues Constructor
        */
        PickListValues(String label , String value){
            this.label = label;
            this.value = value;
        }
    }
   /**
    * @description Dependent Picklist Wrapper
    */
    public class DependentPickListValues{
        @AuraEnabled
        public String label;
        @AuraEnabled 
        public List<String> value;
       /**
        * @description DependentPickListValues Constructor
        */
        DependentPickListValues(String label , List<String> value){
            this.label = label;
            this.value = new List<String>(value);
        }
    }
   /**
    * @description Parent - Child Qli Data Wrapper
    */    
    public class QliDataWrapper {
        
        @AuraEnabled
        public ParentWrapper parentdata;
        
        @AuraEnabled
        public List<QlichildData> data;
        /**
        * @description QliDataWrapper Constructor
        */
        QliDataWrapper(ParentWrapper parentData , List<QlichildData> data){
            this.parentData = parentData;
            this.data = new List<QlichildData>(data);
        }
    }
    /*
    * @description  Wrapper to hold child Qli data and their associated properties for UI design
    */
    public class QlichildData{
        @AuraEnabled
        public QuoteLineItem qli;
        
        @AuraEnabled
        public Boolean colorStage;
        
        @AuraEnabled
        public Boolean colorReason;
        
        @AuraEnabled
        public Boolean colorPlanType;
        
        @AuraEnabled
        public Boolean colorHpcc;
        
        @AuraEnabled
        public Boolean colorCustomCont;
        
        /**
        * @description QlichildData Constructor
        */
        QlichildData(QuoteLineItem qli,Boolean colorStage,Boolean colorReason,Boolean colorPlanType,Boolean colorHpcc,Boolean colorCustomCont){
            this.qli = qli;
            this.colorStage = colorStage;
            this.colorReason =colorReason;
            this.colorPlanType =colorPlanType;
            this.colorHpcc =colorHpcc;
            this.colorCustomCont =colorCustomCont;
        }
    }
    /*
    * @description Wrapper to hold details for Expand - collapse functionality 
    */
    public class ParentWrapper {
        
        @AuraEnabled
        public String parentId;
        
        @AuraEnabled
        public String parentName;
        
        @AuraEnabled
        public Boolean isOpen;
        /**
        * @description ParentWrapper Constructor
        */
        ParentWrapper(String parentId,String parentName , Boolean isOpen){
            this.parentId = parentId;
            this.parentName = parentName;
            this.isOpen = isOpen;
        }
    }
}