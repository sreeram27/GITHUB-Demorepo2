/**
@author         Accenture offshore
@date           5/15/2019
@name           APLG_01_OpportunityEmailTemplate_CC
@description    Opportunity Email Template custom controller to fetch related Account Tax Id, Sold QLI and Dynamic email template footer.  
*/
public with sharing class APLG_01_OpportunityEmailTemplate_CC {
    
/**
@description    opporId.  
*/
    
    public Id opporId {get;set;}
/**
@description    accId.  
*/
    public Id accId {get;set;}
/**
@description    sAccSitusCode.  
*/    
    public String sAccSitusCode {get;set;}
/**
* @description    sAccBranding.  
*/    
    public String sAccBranding {get;set;}
    
   
        
     /**
     * @description getQuoteLineItemsByOpprId
     * @return List<QuoteLineItem>
     */
    public List<QuoteLineItem> getQuoteLineItemsByOpprId(){
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        try{
        quoteLineItems = [SELECT Id, Quote.OpportunityId,ProductName__c 
                                              FROM QuoteLineItem where Quote.OpportunityId = :opporId
                                              and ProductStage__c = 'Sold'];
        }catch(Exception ex){
            System.debug('Exception in APLG_01_OpportunityEmailTemplate_CC of APLG_01_OpportunityQuoteLineItemEmail : ' + ex);
        }
        return quoteLineItems;
    }
    
     /**
     * @description getDynamicFooter retrieves correct footer content from CS_LG01_Start_Enrollment_Email_Footer__c custom settings
     *              based on related Account's Situs state and Branding value
     * @return CS_LG01_Start_Enrollment_Email_Footer__c 
     */
    
     public CS_LG01_Start_Enrollment_Email_Footer__c getDynamicFooter(){
         
         CS_LG01_Start_Enrollment_Email_Footer__c footerCS = null;
         try{
         if(sAccSitusCode != null && sAccBranding != null){
          footerCS = CS_LG01_Start_Enrollment_Email_Footer__c.getValues(sAccSitusCode + '_' + sAccBranding);
         }
         }catch(Exception ex){
            System.debug('Exception in getDynamicFooter of APLG_01_OpportunityEmailTemplate_CC : ' + ex);
        }
        return footerCS;
    }
    
     /**
     * @description  getTaxIdsByAccountId fetches last modified Tax Id record from related parent account
     * @return Tax_ID__c
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
            System.debug('Exception in getTaxIdsByAccountId of APLG_01_OpportunityEmailTemplate_CC : ' + ex);
        }
        return taxIdObj;
    }

}