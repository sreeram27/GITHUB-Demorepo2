/**************************************************************************************
Apex Class Name:  SBCSOBActions
Version     : 1.0 
Created Date    : 11 September 2019
* @Author: X-men Offshore(Smita)
@description: class to trigger update SBC/SOB Request fields(Hpcc,Standard Contract Code,Plan Type,Funding Type,Custom Contract Code,Implementation ID)
US          : PRDCRM-42116,PRDCRM-45153,PRDCRM-43922,PRDCRM-46329
*************************************************************************************/
public with sharing class SBCSOBActions {
    
    public static boolean sbcCheck=false;
    
    
    /*@description :Method to get the quotelineitems*/  
    public static void updateSBC(List<SBC_SOB_Request__c> sbcList){
        
        Set<ID> sbcOpptyId=new Set<ID>();
        List<quotelineitem> quoteList=new List<quotelineitem>();
        List<String> productStageList=new List<String>();
        List<order> orderList=new List<order>();
        productStageList.add(UtilConstants.Igap_Sold_Stage);
        productStageList.add(UtilConstants.Renewed_Stage);
        productStageList.add(UtilConstants.Sold_Stage);
        productStageList.add(UtilConstants.In_Progress_Stage);
        productStageList.add(UtilConstants.Igap_In_Progress_Stage);
        productStageList.add(UtilConstants.Jeopardy_Stage);
        
        for(SBC_SOB_Request__c sbc :sbcList){
            
                sbcOpptyId.add(sbc.Opportunity__c);
            
        }
           
        quoteList=[select id,ProductLOB__c,Funding__c,Contract_Code_ASF__c,HPCC_Code__c,Contract_Codes__c,
                       Plan_Type__c,opportunity__c,OpportunityId__c,
                       Product2.LOB__c,QuoteId,quote.OpportunityId,ProductStage__c,Implementation_Status__r.Implementation_Record_ID__c 
                       from quotelineitem 
                       where quote.OpportunityId=:sbcOpptyId 
                       AND ProductLOB__c='Medical' AND ProductStage__c =:productStageList];
        
        
        orderList=fetchOrder(quoteList);
        updateSbcRequest(quoteList,sbcList,orderList);
        
    }
    
    /*@descriptioc: Method to fetch Order*/
    public static List<Order> fetchOrder(List<quotelineitem> quoteList){
        
        Set<ID> quoteId=new Set<ID>();
        List<order> orderList=new List<order>();
        
        for(QuoteLineItem qli :quoteList){
            quoteId.add(qli.QuoteId);
        } 
        
        orderList = [select id,ordernumber,QuoteId from order where QuoteId in :quoteId ];
        
        return orderList;
    }
    
    /*@description : Method to update SBC/SOB object*/
    public static void updateSbcRequest(List<quotelineitem> quoteList,List<SBC_SOB_Request__c> sbcList,List<order> orderList){
        
        List<SBC_SOB_Request__c> sbcRecordListUpdate=new List<SBC_SOB_Request__c>();
        
        String sbcHpccString='';
        String sbcContractCodeString='';
        String sbcPlanTypeString='';
        String sbcFundingString='';
        String sbcCustomContractCodeString='';
        String sbcImplementationString='';
        
        
        Id profileId = UserInfo.getProfileId();
        String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
        
        for(SBC_SOB_Request__c sbc :sbcList){
            
            if(sbc.Actual_SBC_Completion_Date__c==null || profileName==UtilConstants.Api_User || profileName ==UtilConstants.System_Admin || profileName ==UtilConstants.System_Administrator){
            
                for(QuoteLineItem qli :quoteList){
                
                if(qli.OpportunityId__c==sbc.Opportunity__c){
                    
                    
                    sbcHpccString=concatHpcc(qli.HPCC_Code__c,sbcHpccString);
                    sbcContractCodeString=concatContract(qli.Contract_Codes__c,sbcContractCodeString);
                    sbcPlanTypeString=concatPlanType(qli.Plan_Type__c,sbcPlanTypeString);
                    sbcFundingString=concatFunding(qli.Funding__c,sbcFundingString);
                    sbcCustomContractCodeString=concatCustomContract(qli.Contract_Code_ASF__c,sbcCustomContractCodeString);
                    
                }
            }   
            
            sbcImplementationString=concatImplementationId(sbcImplementationString,orderList);
            sbc.HPCC_Code__c=sbcHpccString;
            sbc.Contract_Code__c=sbcContractCodeString;
            sbc.Plan_Type__c=sbcPlanTypeString;
            sbc.Funding_Type__c=sbcFundingString;
            sbc.Custom_Contract_Code__c=sbcCustomContractCodeString;
            sbc.Opportunity_ICR_ID_s__c=sbcImplementationString;
            sbcRecordListUpdate.add(sbc);
            }
        }  
        
        sbcCheck=true;
    }
    
    /*@description : Method to Concatenate Hpcc Code on SBC/SOB Request object*/
    public static String concatHpcc(String hpccCode,String sbcHpccString){
        
        Set<String> hpccCodeSet=new Set<String>();
        String[] values = sbcHpccString.split(';');
        if(hpccCode!=null && !values.contains(hpccCode) && sbcHpccString!=null){
        sbcHpccString=(sbcHpccString!='')?(sbcHpccString+';'+hpccCode):(hpccCode);
        }
        
        return sbcHpccString;
    }  
    
    /*@description : Method to Concatenate Contract Code on SBC/SOB Request object*/
    public static String concatContract(String contractCode,String sbcContractCodeString){
        
        Set<String> contractCodeSet=new Set<String>();
        String[] values = sbcContractCodeString.split(';');
        if(contractCode!=null && !values.contains(contractCode) && sbcContractCodeString!=null){
        sbcContractCodeString=(sbcContractCodeString!='')?(sbcContractCodeString+';'+contractCode):(contractCode);
        }
        
        return sbcContractCodeString;
    } 
    
    /*@description : Method to Concatenate Plan Type on SBC/SOB Request object*/
    public static String concatPlanType(String planType,String sbcPlanTypeString){
        
        Set<String> planTypeSet=new Set<String>();
        String[] values = sbcPlanTypeString.split(';');
        if(planType!=null && ! values.contains(planType) &&  sbcPlanTypeString!=null){
        sbcPlanTypeString=(sbcPlanTypeString!='')?(sbcPlanTypeString+';'+planType):(planType);
        }
        
        return  sbcPlanTypeString;
    } 
    
    /*@description : Method to Concatenate Funding Type on SBC/SOB Request object*/
    public static String concatFunding(String fundingType,String sbcFundingString){
        
        Set<String> fundingTypeSet=new Set<String>();
        String[] values = sbcFundingString.split(';');
        if(fundingType!=null && ! values.contains(fundingType) &&  sbcFundingString!=null){
        sbcFundingString=(sbcFundingString!='')?(sbcFundingString+';'+fundingType):(fundingType);
        }
        
        return  sbcFundingString;
    }
    
    /*@description : Method to Concatenate Custom Contract Code on SBC/SOB Request object*/
    public static String concatCustomContract(String customContractCode,String sbcCustomContractCodeString){
        
        Set<String> customContractCodeSet=new Set<String>();
        String[] values = sbcCustomContractCodeString.split(';');
        if(customContractCode!=null && ! values.contains(customContractCode) &&  sbcCustomContractCodeString!=null){
        sbcCustomContractCodeString=(sbcCustomContractCodeString!='')?(sbcCustomContractCodeString+';'+customContractCode):(customContractCode);
        }
        
        return  sbcCustomContractCodeString;
    }
    
     /*@description : Method to Concatenate Implementation Case Id on SBC/SOB Request object*/
    private static String concatImplementationId(String sbcImplementationString,List<order> orderList){
        
         String[] values = sbcImplementationString.split(';');
         
         for(Order orderQuote : orderList){
             if(! values.contains(orderQuote.ordernumber) &&  sbcImplementationString!=null){
	           sbcImplementationString=(sbcImplementationString!='')?(sbcImplementationString+';'+orderQuote.ordernumber):(orderQuote.ordernumber);
              }
         }
        
        return  sbcImplementationString;
    }
    
}