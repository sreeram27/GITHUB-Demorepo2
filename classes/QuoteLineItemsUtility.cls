/*
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Name              QuoteLineItemsUtility
* Author            Deloitte offshore (Gladiators)
* ModifiedBy        Deloitte offshore (Gladiators)
* CreatedDate       14th March 2020
* UsedBy            Triggers - ANA_QuoteLineItemsAfterCreate ,ANA_QuoteLineItemsAfterUpdate
* User Story        ICR Generation Issue
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @description used By Quote Line Item triggers to invoke the Insert and Update Functionalities which were handled by Process Builders.
* Process builders Involved are :-
*  > LG_ProbabilityUpdateOnStage
*  > LHOL Update Quote
*  > Reset CastLight Send Indicator for QLI update
*  > ANA_QLI01_UpdateChild_QLIs
* 
* Additional information
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Changes
* vX.X(Version)            Name
* Date                     Explanation
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
public class QuoteLineItemsUtility {
    
    /*
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
* @description Update Probability of Qli on Update and insert of a Quote Line Item Record Product_Stage (PB - LG_ProbabilityUpdateOnStage)
* -------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @param   mapNewQLI   Map<Id,QuoteLineItem>   Qli with changes
* @param   mapOldQLI   Map<Id,QuoteLineItem>   Old with old values
* @return  void
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/ 
    public static void lgUpdateProbability( List<QuoteLineItem> listNewQLI, Map<Id,QuoteLineItem> mapOldQLI){	
        
        for(QuoteLineItem oNewQli : listNewQLI){
            if(mapOldQLI != null && !mapOldQLI.isEmpty() && mapOldQLI.size()>0 && mapOldQLI.containsKey(oNewQli.Id)){
                if(oNewQli.AnthemEntityTransform__c == staticVariableClass.LOCAL && 
                   mapOldQLI.get(oNewQli.Id).ProductStage__c != oNewQli.ProductStage__c ){
                       updateProbability(oNewQli);
                   }
            }else if(oNewQli.AnthemEntityTransform__c == staticVariableClass.LOCAL){
                updateProbability(oNewQli);
            }
        }
    }
    /*
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
* @description Invoke CastLightProcessLogUpdate class to Update status on QLI Update and Insert(PB - Reset CastLight Send Indicator for QLI update)
* -------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @param   mapNewQLI   Map<Id,QuoteLineItem>   Qli with changes
* @param   mapOldQLI   Map<Id,QuoteLineItem>   Old with old values
* @return  void
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/ 
    public static void castlightIndicatorInsert( List<QuoteLineItem> listNewQLI, Map<Id,QuoteLineItem> mapOldQLI) {
        
        List<Id> listOppty = new List<Id>();
        try{
             String sProfName = [Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        
            if ( !String.isBlank(sProfName) && sProfName != staticVariableClass.API_USER){
                for(QuoteLineItem oNewQli : listNewQLI){
                    
                    if(mapOldQLI != null && !mapOldQLI.isEmpty() && mapOldQLI.size()>0 && mapOldQLI.containsKey(oNewQli.Id)){
                        if(oNewQli.ProductStage__c != mapOldQLI.get(oNewQli.Id).ProductStage__c ||
                           oNewQli.Members__c  != mapOldQLI.get(oNewQli.Id).Members__c ){
                               listOppty.add(oNewQli.OpportunityId__c);
                           }
                    }else{
                        listOppty.add(oNewQli.OpportunityId__c);	
                    }
                }
                if(listOppty.size()>0 && !listOppty.isEmpty()){
                    CastLightProcessLogUpdate.StatusUpdate(listOppty);
                }
            }   
        }catch(Exception oExcep){
            createExceptionLog(oExcep);
        }
           
    }
    
    /*
     * ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     *
     * @description Update LHOL Field on Quote on QLI insert (PB - LHOL Update Quote)
     * -------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * @param   listNewQli  List<QuoteLineItem>     New Qlis which are Inserted
     * @return  void
     * --------------------------------------------------------------------------------------------------------------------------------------------------------------------
     */
  public static void lHOLUpdateQuoteonAfterCreate(List<QuoteLineItem> listNewQli){
      
        Set<Id> setQuoteId = new Set<Id>();
        List<Quote> quoteToBeUpdated = new List<Quote>();
      try{
          for(QuoteLineItem oNewQli : listNewQli){
             if(    oNewQli.AnthemEntity__c == staticVariableClass.NATIONAL_ACCOUNTS && 
                    oNewQli.ProductName__c == staticVariableClass.HW_LIVE_HEALTH_ONLINE &&
                        (
                            oNewQli.ProductStage__c == staticVariableClass.Sold ||
                            oNewQli.ProductStage__c == staticVariableClass.IGAPSold ||
                            oNewQli.ProductStage__c == staticVariableClass.Renewed
                         ) && 
                    oNewQli .QuoteId != null
                         
                 ){
                        setQuoteId.add(oNewQli.QuoteId);
                  }
            }
         
         List<Quote> listQuoteToBeUpdated = new List<Quote> ();
          if(setQuoteID.size()>0 && !setQuoteID.isEmpty()){
              for (Quote oQuote : [Select Id ,Name, LHOL_Q__c FROM QUOTE WHERE ID IN :setQuoteID]){
                  if(oQuote.Name !=null){
                      oQuote.LHOL_Q__c = staticVariableClass.UpsellYes;
                      quoteToBeUpdated.add(oQuote);
                  }
              } 
          }
         if(!quoteToBeUpdated.isEmpty() && quoteToBeUpdated.size()>0){
              update quoteToBeUpdated;
         }
      }catch(Exception oExcep){
            createExceptionLog(oExcep);
        }
      }
    /*
     * ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     *
     * @description Update LHOL Field on Quote on QLI Update (PB - LHOL Update Quote)
     * -------------------------------------------------------------------------------------------------------------------------------------------------------------------
     * @param   mapNewQLI   Map<Id,QuoteLineItem>   Qli with changes
     * @param   mapOldQLI   Map<Id,QuoteLineItem>   Old with old values
     * @return  void
     * --------------------------------------------------------------------------------------------------------------------------------------------------------------------
     */
     
     public static void lHOLUpdateQuote( Map<Id,QuoteLineItem> mapNewQLI, Map<Id,QuoteLineItem> mapOldQLI ){
      
        Set<Id> setQuoteId = new Set<Id>();
        List<Quote> listQuoteToBeUpdated = new List<Quote> ();
         try{
             for(QuoteLineItem oNewQli : mapNewQLI.values()){
                 if(oNewQli.AnthemEntity__c == staticVariableClass.NATIONAL_ACCOUNTS &&
                     (oNewQli.ProductName__c != mapOldQLI.get(oNewQli.Id).ProductName__c ||
                      oNewQli.ProductStage__c  != mapOldQLI.get(oNewQli.Id).ProductStage__c)&& 
                      oNewQli .QuoteId != null 
                    ){
                        if(oNewQli.ProductName__c == staticVariableClass.HW_LIVE_HEALTH_ONLINE &&
                            (
                                oNewQli.ProductStage__c == staticVariableClass.Sold ||
                                oNewQli.ProductStage__c == staticVariableClass.IGAPSold ||
                                oNewQli.ProductStage__c == staticVariableClass.Renewed
                            ) 
                          ){
                            setQuoteId.add(oNewQli.QuoteId);
                           }
                	}
         	}
             if(setQuoteID.size()>0 && !setQuoteID.isEmpty()){
                 for (Quote oQuote : [Select Id ,LHOL_Q__c FROM QUOTE WHERE ID IN :setQuoteID]){
                   oQuote.LHOL_Q__c = staticVariableClass.UpsellYes;
                   listQuoteToBeUpdated.add(oQuote);
                }
             }
             if(!listQuoteToBeUpdated.isEmpty() && listQuoteToBeUpdated.size()>0){
                  update listQuoteToBeUpdated;
             }
         }catch(Exception oExcep){
            createExceptionLog(oExcep);
        } 
    }
    /*
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
* @description Stamp Stage and probability on child Qli based on values Parent Qli on update (PB - ANA_QLI01_UpdateChild_QLIs)
* -------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @param   mapNewQLI   Map<Id,QuoteLineItem>   Qli with changes
* @param   mapOldQLI   Map<Id,QuoteLineItem>   Old Qlis
* @return  void
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
    public static void anaQLI01UpdateChildQLIs( Map<Id,QuoteLineItem> mapNewQLI, Map<Id,QuoteLineItem> mapOldQLI ){
        
        List<QuoteLineItem> listChildToUpdate = new List<QuoteLineItem>();
        Set<Id> setQliId = new Set<Id>();
        try{
            for(QuoteLineItem oNewQli : mapNewQLI.values()){
                if( oNewQli.AnthemEntity__c == staticVariableClass.NATIONAL_ACCOUNTS  && 
                   oNewQli.ParentQuoteLineItem__c == null &&
                   (oNewQli.ProductStage__c != mapOldQLI.get(oNewQli.Id).ProductStage__c ||
                    oNewQli.Probability__c  != mapOldQLI.get(oNewQli.Id).Probability__c )
                  ){
                      setQliId.add(oNewQli.Id);
                  }
            }
            if(setQliId.size()>0 && !setQliId.isEmpty()){
                for(QuoteLineItem oParentQli : [SELECT Id,Product2.Bundle__c,
                                                (SELECT Id, Probability__c, ProductStage__c from Quote_Line_Items__r) 
                                                FROM QuoteLineItem 
                                                WHERE ParentQuoteLineItem__c =null
                                                AND Id IN: setQliId] 
                   ){
                       if(oParentQli.Product2.Bundle__c == staticVariableClass.FIXED){
                           for(QuoteLineItem oChildQli : oParentQli.Quote_Line_Items__r){
                               oChildQli.Probability__c = mapNewQLI.get(oParentQli.Id).Probability__c;
                               oChildQli.ProductStage__c = mapNewQLI.get(oParentQli.Id).ProductStage__c;
                               listChildToUpdate.add(oChildQli);
                           }
                       }
                   }
            }    
            if(listChildToUpdate.size()>0 && !listChildToUpdate.isEmpty()){
                Update listChildToUpdate;
            }
        }catch(Exception oExcep){
            createExceptionLog(oExcep);
        } 
    }
    
    /*
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
* @description  Stamp Stage and probability on child Qli based on values Parent Qli on Insert(PB - ANA_QLI01_UpdateChild_QLIs)
* -------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @param   listNewQli  List<QuoteLineItem>     New Qlis which are Inserted
* @return  void
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
    public static void anaQLI01UpdateChildQLIsOnAfterCreate( List<QuoteLineItem> listNewQli ){
        
        List<QuoteLineItem> listChildToUpdate = new List<QuoteLineItem>();
        Set<Id> setQliId = new Set<Id>();
        try{
            for(QuoteLineItem oNewQli : listNewQli){
                if( oNewQli.AnthemEntity__c == staticVariableClass.NATIONAL_ACCOUNTS && 
                   oNewQli.ParentQuoteLineItem__c == null && 
                   oNewQli.ProductStage__c != null && 
                   oNewQli.Probability__c  != null 
                  ){
                      setQliId.add(oNewQli.Id);
                  }
            }
        
            if(setQliId.size()>0 && !setQliId.isEmpty()){
                
                for(QuoteLineItem oParentQli : [SELECT Id,Product2.Bundle__c,Probability__c,ProductStage__c,
                                                (SELECT Id, Probability__c, ProductStage__c from Quote_Line_Items__r) 
                                                FROM QuoteLineItem 
                                                WHERE ParentQuoteLineItem__c =null
                                                AND Id IN: setQliId] 
                   ){
                       if(oParentQli.Product2.Bundle__c == staticVariableClass.FIXED){
                           for(QuoteLineItem oChildQli : oParentQli.Quote_Line_Items__r){
                               oChildQli.Probability__c = oParentQli.Probability__c;
                               oChildQli.ProductStage__c = oParentQli.ProductStage__c;
                               listChildToUpdate.add(oChildQli);
                           }
                       }
                   }
            }    
            if(listChildToUpdate.size()>0 && !listChildToUpdate.isEmpty()){
                Update listChildToUpdate;
            }
        }catch(Exception oExcep){
           createExceptionLog(oExcep);
        } 
    }
/*
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
* @description Change Qli Probability on Insert and update of a Quote Line Item Record  (PB - LG_ProbabilityUpdateOnStage)
* -------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @param   oNewQli  QuoteLineItem     New Qlis which are Inserted or updated
* @return  void
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
    private static void updateProbability(QuoteLineItem oNewQli){
        
                if(oNewQli.ProductStage__c == staticVariableClass.IGAPSold ||
                   oNewQli.ProductStage__c == staticVariableClass.Notrenewingincurrentperiod ||
                   oNewQli.ProductStage__c == staticVariableClass.Sold ||
                   oNewQli.ProductStage__c == staticVariableClass.Renewed){
                   oNewQli.Probability__c = staticVariableClass.HUNDRED_PERCENT;
           }else if(oNewQli.ProductStage__c == staticVariableClass.DEAD  || 
                    oNewQli.ProductStage__c == staticVariableClass.LgQliUpdateProdStage ||  
                    oNewQli.ProductStage__c == staticVariableClass.IGAP_DEAD ||
                    oNewQli.ProductStage__c == staticVariableClass.IGAP_LOST ||
                    oNewQli.ProductStage__c == staticVariableClass.LOST ||
                    oNewQli.ProductStage__c == staticVariableClass.TERMED){
                        oNewQli.Probability__c = staticVariableClass.LgQliUpdateProdProbability;   
            }else if(oNewQli.ProductStage__c == staticVariableClass.IGAP_IN_PROGRESS ||
                     oNewQli.ProductStage__c == staticVariableClass.InProgress){
                     oNewQli.Probability__c = staticVariableClass.TEN_PERCENT;
            }else if(oNewQli.ProductStage__c == staticVariableClass.JEOPARDY){
                     oNewQli.Probability__c = staticVariableClass.FIFTY_PERCENT;
            }
    }
   /*
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
* @description createExceptionLog creates Exception log record when an exception happens
* -------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @param   oExcep  Exception     exception instance
* @return  void
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/ 
    private static void createExceptionLog(Exception oExcep){
        ExceptionLog__c oExceptionlog = new ExceptionLog__c();
        oExceptionlog.ExceptionDetails__c = oExcep.getTypeName()+UTIL_ErrorConstants.COLON+oExcep.getMessage()+UTIL_ErrorConstants.ENTER+oExcep.getStackTraceString();
        oExceptionlog.OrgId__c = ANA_UTIL03_Constants.ORGID;
        oExceptionlog.Application__c = staticVariableClass.COMMERCIAL_SALES_STRING;
        oExceptionlog.ContextUser__c = UserInfo.getUserId();
        oExceptionlog.Severity__c = staticVariableClass.ERROR ;
        insert oExceptionlog;
    }
   
}