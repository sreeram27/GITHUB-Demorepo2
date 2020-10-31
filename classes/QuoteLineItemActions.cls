/**************************************************************************************
Apex Class Name:  QuoteLineItemActions
Version     : 1.0 
Created Date    : 11 December 2019
* @Author: X-men Offshore(Smita)
@description: Class to update SBC/SOB Request fields(Hpcc,Contract Code,Custom Contract Code,Plan Type,Funding Type) whenever 
              Quotelineitem fields(Hpcc,Contract Code,Custom Contract Code,Plan Type,Funding Type) are edited.
US          : PRDCRM-45634
*************************************************************************************/
public with sharing class QuoteLineItemActions {

  /*@description :Method to get the quotelineitems*/  
    public static void updateSBC(Map<Id,QuoteLineItem> newQuoteMap,Map<Id,QuoteLineItem> oldQuoteMap){
        
        Set<ID> quoteId=new Set<ID>();
        Set<ID> opptyId=new Set<ID>();
        List<quotelineitem> quoteList=new List<quotelineitem>();
        List<SBC_SOB_Request__c> sbcList=new List<SBC_SOB_Request__c>();
        List<order> orderList=new List<order>();
        List<String> productStage=new List<String>();
        Quotelineitem quoteOld=new Quotelineitem();
        
        productStage.add('IGAP Sold');
        productStage.add('Renewed');
        productStage.add('Sold');
        productStage.add('In Progress');
        productStage.add('IGAP In Progress');
        productStage.add('Jeopardy');
        
        for(QuoteLineItem quo :newQuoteMap.values()){
            quoteOld=oldQuoteMap.get(quo.id);
            if(quo.Plan_Type__c!=quoteOld.Plan_Type__c||quo.Funding__c!=quoteOld.Funding__c||quo.Contract_Codes__c!=quoteOld.Contract_Codes__c||quo.vlocity_ins__ContractCode__c!=quoteOld.vlocity_ins__ContractCode__c||quo.HPCC_Code__c!=quoteOld.HPCC_Code__c){
                    
                    quoteId.add(quo.id);
                    opptyId.add(quo.IC_OpportunityId__c);       
            }
            }
        
        if(quoteId.size()>0){
            
        quoteList=[select id,ProductLOB__c,Funding__c,Contract_Code_ASF__c,HPCC_Code__c,Contract_Codes__c,
                       Plan_Type__c,opportunity__c,OpportunityId__c,vlocity_ins__ContractCode__c,
                       Product2.LOB__c,quote.OpportunityId,ProductStage__c from quotelineitem 
                       where quote.OpportunityId=:opptyId
                       AND ProductLOB__c='Medical' AND ProductStage__c =:productStage];
        
        sbcList=[select id,Opportunity__c,Funding_Type__c,Custom_Contract_Code__c,HPCC_Code__c,Contract_Code__c,
                 Plan_Type__c,Actual_SBC_Completion_Date__c from SBC_SOB_Request__c where Opportunity__c=:opptyId];
        
        updateSbcRequest(quoteList,sbcList);
        }    
    }
    
    /*@description : Method to update SBC/SOB object*/
    private static void updateSbcRequest(List<quotelineitem> quoteList,List<SBC_SOB_Request__c> sbcList){
        
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
                    
                    sbcHpccString=SBCSOBActions.concatHpcc(qli.HPCC_Code__c,sbcHpccString);
                    sbcContractCodeString=SBCSOBActions.concatContract(qli.Contract_Codes__c,sbcContractCodeString);
                    sbcPlanTypeString=SBCSOBActions.concatPlanType(qli.Plan_Type__c,sbcPlanTypeString);
                    sbcFundingString=SBCSOBActions.concatFunding(qli.Funding__c,sbcFundingString);
                    sbcCustomContractCodeString=SBCSOBActions.concatCustomContract(qli.vlocity_ins__ContractCode__c,sbcCustomContractCodeString);
                }
            }
            sbc.HPCC_Code__c=sbcHpccString;
            sbc.Contract_Code__c=sbcContractCodeString;
            sbc.Plan_Type__c=sbcPlanTypeString;
            sbc.Funding_Type__c=sbcFundingString;
            sbc.Custom_Contract_Code__c=sbcCustomContractCodeString;
            sbcRecordListUpdate.add(sbc); 
        }  
      }  
        
       if(sbcRecordListUpdate.size()>0){
           
             update sbcRecordListUpdate;
        } 
    }
    
}