/**
@author         Accenture offshore
@date           5/15/2019
@name           APLG_01_OpportunityQuoteLineItemEmail
@description    OpportunityQuoteLineItemEmail.  
*/
public with sharing class APLG_01_OpportunityQuoteLineItemEmail {
    
/**
@description    opporId.  
*/
    
    public Id opporId {get;set;}
/**
@description    accId.  
*/
    public Id accId {get;set;}
/**
@description    accSitusCode.  
*/    
    public String accSitusCode {get;set;}
/**
* @description    accBranding.  
*/    
    public String accBranding {get;set;}
    
   
        
     /**
     * @description getQuoteLineItemsByOpprId
     * @return getQuoteLineItemsByOpprId
     */
    public List<QuoteLineItem> getQuoteLineItemsByOpprId(){
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        try{
        quoteLineItems = [SELECT Id, Quote.OpportunityId,ProductName__c 
                                              FROM QuoteLineItem where Quote.OpportunityId = :opporId
                                              and ProductStage__c = 'Sold'];
        }catch(Exception ex){
            System.debug('Exception in getQuoteLineItemsByOpprId of APLG_01_OpportunityQuoteLineItemEmail : ' + ex);
        }
        return quoteLineItems;
    }
    
     /**
     * @description CS_LG01_Start_Enrollment_Email_Footer__c getDynamicFooter
     * @return CS_LG01_Start_Enrollment_Email_Footer__c getDynamicFooter
     */
    
     public CS_LG01_Start_Enrollment_Email_Footer__c getDynamicFooter(){
         
         CS_LG01_Start_Enrollment_Email_Footer__c footerCS = null;
         try{
         if(accSitusCode != null && accBranding != null){
          footerCS = CS_LG01_Start_Enrollment_Email_Footer__c.getValues(accSitusCode + '_' + accBranding);
         }
         }catch(Exception ex){
            System.debug('Exception in getDynamicFooter of APLG_01_OpportunityQuoteLineItemEmail : ' + ex);
        }
        return footerCS;
    }
    
     /**
     * @description Tax_ID__c getTaxIdsByAccountId
     * @return Tax_ID__c getTaxIdsByAccountId
     */   
    
    public Tax_ID__c getTaxIdsByAccountId(){
        List<Tax_ID__c> taxIds = new List<Tax_ID__c>();
      	Tax_ID__c taxIdObj = null;
          try{
        taxIds = [SELECT Tax_ID__c FROM Tax_ID__c 
                                              where Account__r.Id = :accId ORDER BY LastModifiedDate DESC LIMIT 1];
       
        if(taxIds.size() == 1 ){
            taxIdObj = taxIds[0];
             System.debug('Last Modified Tax Id :' + taxIdObj.Tax_ID__c + ' for Account id : ' + accId);
        }
          }catch(Exception ex){
            System.debug('Exception in getTaxIdsByAccountId of APLG_01_OpportunityQuoteLineItemEmail : ' + ex);
        }
        return taxIdObj;
    }

}