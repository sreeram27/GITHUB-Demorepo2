/*
    Name               :    LGP2AIntegrationController 
    Description        :    Apex controller for Lightning Component - LGP2AHighRoadsCanvas to get the JSON and display values from the quote line object
    Created By         :    Arun Siddappa
*/
public class LGP2AIntegrationController {   
       public class ResponseWrapper {
        @AuraEnabled public String status;        
        @AuraEnabled public String statusMsg;
        @AuraEnabled public String attributeValue;        
        @AuraEnabled public String QuoteLineId;     
        @AuraEnabled public String GroupName;
        @AuraEnabled public String ProductName;     
        @AuraEnabled public String ProductStage;
        @AuraEnabled public String ProductContractCode;     
        @AuraEnabled public String GroupId;
        @AuraEnabled public String GroupSize;     
        @AuraEnabled public String AdministrativeType;
        @AuraEnabled public String FundingType;   
       }
    @AuraEnabled
    public static ResponseWrapper getQuoteDataForNavigation(Id quoteLineId, String sSource) {
        ResponseWrapper oResponseWrapper;
        LGP2AJSON oP2AJsonObj;
        String sEffectiveMonth;
        String sEffectiveDay;
        
    	try {
            List<QuoteLineItem> listQtLineItem = [SELECT Quote.Opportunity.Name, ProductStage__c,Quote.Id, Id,ClientName__c,EffectiveDate__c,ProductName__c,
                                                Quote.GrpNumber__c,Product2.Contract_Code__c, Quote.GroupSize__c, Benefit_Period__c, Funding__c, Quote.AccountId,
                                                Quote.Opportunity.Account.TotalNumberofUnionWorkers__c, HPCC_Code__c, Product2.HPCC_Code__c,
                                                State_Regular__c,HCR_Status__c
                                                FROM QuoteLineItem WHERE Id=:quoteLineId];//PRDCRM-50634 - GLD - 201.2 - Added State_Regular__c,HCR_Status__c
        	
        	oResponseWrapper    = new ResponseWrapper(); 
            if(listQtLineItem.size()>0 && !listQtLineItem.isEmpty()){
                
             	oP2AJsonObj 		= populateP2AJSON(listQtLineItem[0].Quote.Id,sSource);
            
                for (QuoteLineItem oQtLineItem : listQtLineItem){
                    
                    sEffectiveMonth = getEffectiveMonth(oQtLineItem.EffectiveDate__c.month());
                    sEffectiveDay = getEffectiveDay(oQtLineItem.EffectiveDate__c.day());
                    
                    oResponseWrapper.QuoteLineId = oQtLineItem.Id;
                    oResponseWrapper.ProductName = oQtLineItem.ProductName__c;
                    oResponseWrapper.ProductStage = oQtLineItem.ProductStage__c;
                    oResponseWrapper.ProductContractCode = oQtLineItem.Product2.Contract_Code__c;
                    oResponseWrapper.AdministrativeType =  getAdminType(oQtLineItem.Benefit_Period__c);
                    oResponseWrapper.FundingType = (oQtLineItem.Funding__c == staticVariableClass.FI || oQtLineItem.Funding__c == staticVariableClass.ASO)?oQtLineItem.Funding__c:'';
                    oResponseWrapper.GroupName = oQtLineItem.Quote.Opportunity.Name +' - '+(oQtLineItem.EffectiveDate__c).year()+'-'+sEffectiveMonth+'-'+sEffectiveDay;
                    oResponseWrapper.GroupId = oQtLineItem.Quote.GrpNumber__c;
                    oResponseWrapper.GroupSize = oQtLineItem.Quote.GroupSize__c;
                    
                    oP2AJsonObj.QuoteLineItems = new List<LGP2AJSON.QuoteLineItems>();
                    
                    LGP2AJSON.QuoteLineItems oJSONqtLineItem = new LGP2AJSON.QuoteLineItems();
                    oJSONqtLineItem.SFDCQuoteLineItemId = oQtLineItem.Id;
                    oJSONqtLineItem.CyPyAdministrativeType = getAdminType(oQtLineItem.Benefit_Period__c);
                    oJSONqtLineItem.GroupIdentifier = oQtLineItem.Quote.GrpNumber__c;
                    oJSONqtLineItem.GroupSize = oQtLineItem.Quote.GroupSize__c;            
                    oJSONqtLineItem.OpportunityEffectiveDate = (oQtLineItem.EffectiveDate__c).year()+'-'+sEffectiveMonth+'-'+sEffectiveDay;
                    oJSONqtLineItem.ProductContractCode = oQtLineItem.Product2.Contract_Code__c;
                    oJSONqtLineItem.QuoteLineItemStage = oQtLineItem.ProductStage__c;
                    oJSONqtLineItem.ImplementationRecordStatus = oQtLineItem.ProductStage__c;
                    oJSONqtLineItem.FundingType   = (oQtLineItem.Funding__c == staticVariableClass.FI || oQtLineItem.Funding__c == staticVariableClass.ASO)? oQtLineItem.Funding__c:'';
                    oJSONqtLineItem.hpccCode = oQtLineItem.HPCC_Code__c !=null? oQtLineItem.HPCC_Code__c: oQtLineItem.Product2.HPCC_Code__c;
                    if(sSource == staticVariableClass.MODIFY){//PRDCRM-50634 - GLD - 201.2 - Added 2 new parameters for Modify Button
                        oJSONqtLineItem.sStateRegulator = oQtLineItem.State_Regular__c;
                        oJSONqtLineItem.sHcrStatus = oQtLineItem.HCR_Status__c;
                    }
                    oP2AJsonObj.QuoteLineItems.add (oJSONqtLineItem);
                }   
            }  
            oResponseWrapper = getFinalResponse(oP2AJsonObj,oResponseWrapper);
        } catch(Exception ex){ 
            oResponseWrapper.status = (staticVariableClass.FAILED).toUpperCase() + ex.getMessage();
        }
        return oResponseWrapper;
    }
     /*
      Story :PRDCRM-51890 -GLD- Send parameters to P2A on Create CEP Case Button from QLI
      Team: Gladiators
    _________________________________________________________________________________________
    
    *@description: Method to prepare Payload for Manage CEP Case Vlocity Action
    _________________________________________________________________________________________
    
    *@param: quoteId - Quote Id on which the button is clicked - Id
    *@param: sSource - Origin name either CEP button or Modify or view  - String
    _________________________________________________________________________________________
    
    *@return: ResponseWrapper
    _________________________________________________________________________________________
    */
    @AuraEnabled
    public static ResponseWrapper getQuoteDataForCEPNavigation(Id quoteId, String sSource){
    
        ResponseWrapper oResponseWrapper;
        LGP2AJSON oP2AJsonObj;
        LGP2AJSON.ParentQli oParentqtLineItem ;
        LGP2AJSON.QuoteLineItems oJSONqtLineItem;
        String sEffectiveMonth;
        String sEffectiveDay;
        
        if(quoteId !=null){
            List<QuoteLineItem> listQlis = new List<QuoteLineItem>(
                [Select Id, EffectiveDate__c, QuoteId,ClientName__c,Product2.Market__c,Product2.Name,Benefit_Period__c, Product2.Product_Type__c, Quote.Opportunity.Account.TotalNumberofUnionWorkers__c, Quote.Account.Situs_State__c,
                   Quote.AccountId, Quote.GrpNumber__c, Quote.GroupSize__c, Quote.Opportunity.Name,
                     (SELECT Id, ParentQuoteLineItem__c, ProductStage__c, HPCC_Code__c, Product2.Name, Funding__c, 
                         State_Regular__c, HCR_Status__c, Product2.Contract_Code__c, EffectiveDate__c,Benefit_Period__c
                                 FROM Quote_Line_Items__r 
                                 WHERE Product_Type__c = :staticVariableClass.Medical
                                 AND ProductCategory__c=:staticVariableClass.Plan 
                                 AND ParentQuoteLineItem__c != null ) 
                                     FROM QuoteLineItem  
                                     WHERE QuoteId =: quoteId
                                     AND Product_Type__c =:staticVariableClass.Medical
                                     AND ProductCategory__c=:staticVariableClass.Product 
                                     AND ParentQuoteLineItem__c = null]);
                                     
            oP2AJsonObj = populateP2AJSON(quoteId,sSource);

            if(listQlis.size()>0 && !listQlis.isEmpty()){
                
                oResponseWrapper 	= new ResponseWrapper(); 
                oResponseWrapper.GroupId = listQlis[0].Quote.GrpNumber__c;
                oResponseWrapper.GroupSize = listQlis[0].Quote.GroupSize__c;
                
        		oP2AJsonObj.listParentQli = new List<LGP2AJSON.ParentQli>();
        		    
                for(QuoteLineItem oParentQli : listQlis){
                        oParentqtLineItem = new LGP2AJSON.ParentQli();
                        oParentqtLineItem.sParentQliId 	= oParentQli.Id;
                        oParentqtLineItem.sProductName 	=  oParentQli.Product2.Name;
                        oParentqtLineItem.sProductType 	= oParentQli.Product2.Product_Type__c;
                        oParentqtLineItem.sProductState = oParentQli.Product2.Market__c;
                        oParentqtLineItem.listChildQuoteLineItems = new List<LGP2AJSON.QuoteLineItems>();
        
                        for(QuoteLineItem oChildQli : oParentQli.Quote_Line_Items__r ){
                            
                                sEffectiveMonth 	= getEffectiveMonth(oChildQli.EffectiveDate__c.month());
                                sEffectiveDay 		= getEffectiveDay(oChildQli.EffectiveDate__c.day());
                    
                                oJSONqtLineItem = new LGP2AJSON.QuoteLineItems();
                                oJSONqtLineItem.SFDCQuoteLineItemId = oChildQli.Id;
                                oJSONqtLineItem.QuoteLineItemStage 	= oChildQli.ProductStage__c;
                                oJSONqtLineItem.ProductContractCode = oChildQli.Product2.Contract_Code__c;
                                oJSONqtLineItem.OpportunityEffectiveDate = (oParentQli.EffectiveDate__c).year()+'-'+sEffectiveMonth+'-'+sEffectiveDay;
                                oJSONqtLineItem.ImplementationRecordStatus = oChildQli.ProductStage__c;
                            	oJSONqtLineItem.GroupIdentifier = oParentQli.Quote.GrpNumber__c;
            					oJSONqtLineItem.GroupSize = oParentQli.Quote.GroupSize__c;
                                oJSONqtLineItem.CyPyAdministrativeType = getAdminType(oChildQli.Benefit_Period__c);
                                oJSONqtLineItem.FundingType = (oChildQli.Funding__c == staticVariableClass.FI || oChildQli.Funding__c == staticVariableClass.ASO)? oChildQli.Funding__c:'';
                                oJSONqtLineItem.hpccCode = oChildQli.HPCC_Code__c;
                                oJSONqtLineItem.sStateRegulator = oChildQli.State_Regular__c;
                                oJSONqtLineItem.sHcrStatus = oChildQli.HCR_Status__c;
                                 
                                oParentqtLineItem.listChildQuoteLineItems.add(oJSONqtLineItem);
                          }
                      oP2AJsonObj.listParentQli.add(oParentqtLineItem);
                }

                oResponseWrapper = getFinalResponse(oP2AJsonObj,oResponseWrapper);
            }
        }
        return oResponseWrapper !=null ? oResponseWrapper : null; 
    }
   
    /*
      Story :PRDCRM-51890 --GLD- Send parameters to P2A on Create CEP Case Button from QLI
      Team: Gladiators
    _________________________________________________________________________________________
    
    *@description: Method to populate P2AJSON
    _________________________________________________________________________________________
    
    *@param: quoteId - Quote Id
    *@param: sSource - Source of Button click
    _________________________________________________________________________________________
    
    *@return: LGP2AJSON
    _________________________________________________________________________________________
    */
    private static LGP2AJSON populateP2AJSON( Id quoteId, String sSource ){
        LGP2AJSON oP2AJsonObj = new LGP2AJSON();
        
        List<Quote> listQte = new List<Quote>([SELECT Id, AccountId, Opportunity.Account.TotalNumberofUnionWorkers__c, GrpNumber__c, GroupSize__c, Opportunity.Account.Name
                                                        FROM Quote
                                                        WHERE Id= :quoteId]);
        
        if(listQte.size()>0 && !listQte.isEmpty()){
            oP2AJsonObj.sfdcAccountId = listQte[0].AccountId;
            oP2AJsonObj.GroupName = listQte[0].Opportunity.Account.Name;
            oP2AJsonObj.totalNoOfUnionWorkers = Integer.ValueOf(listQte[0].Opportunity.Account.TotalNumberofUnionWorkers__c);
            oP2AJsonObj.RequestedBy = UserInfo.getName();
            oP2AJsonObj.SFDCQuoteId =listQte[0].Id;
            oP2AJsonObj.ENVIRONMENT =  URL.getSalesforceBaseUrl().toExternalForm();
            
            if(sSource == staticVariableClass.CEP_CASE){
                oP2AJsonObj.GroupNumber = listQte[0].GrpNumber__c;
            	oP2AJsonObj.GroupSize = listQte[0].GroupSize__c;
            }
            if(sSource == staticVariableClass.VIEW_STRING){
                    oP2AJsonObj.Action = staticVariableClass.VIEW_STRING;
            }
        }
        return oP2AJsonObj !=null ? oP2AJsonObj : null;
    }
    /*
      Story :PRDCRM-51890 --GLD- Send parameters to P2A on Create CEP Case Button from QLI
      Team: Gladiators
    _________________________________________________________________________________________
    
    *@description: gets Admin Type based on Benefit Period 
    _________________________________________________________________________________________
    
    *@param: sBenefitPeriod - Benefit Period from QLI - String
    _________________________________________________________________________________________
    
    *@return: String
    _________________________________________________________________________________________
    */
    private static String getAdminType(String sBenefitPeriod){
        if (sBenefitPeriod!= null && sBenefitPeriod.contains(staticVariableClass.BENEFIT)){
            return 'PY';
        }
        else if (sBenefitPeriod!= null && sBenefitPeriod.contains(staticVariableClass.CALENDAR)){
            return 'CY';
        }
        return null;
    }
    /*
      Story :PRDCRM-51890 --GLD- Send parameters to P2A on Create CEP Case Button from QLI
      Team: Gladiators
    _________________________________________________________________________________________
    
    *@description: getsEffectiveMonth with proper integer format
    _________________________________________________________________________________________
    
    *@param: iEffectiveMonth - Month - Integer
    _________________________________________________________________________________________
    
    *@return: String
    _________________________________________________________________________________________
    */
    private static String getEffectiveMonth(Integer iEffectiveMonth){
        return (iEffectiveMonth < 10 ? ('0'+ String.valueOf(iEffectiveMonth)) : String.valueOf(iEffectiveMonth));
    }
    /*
      Story :PRDCRM-51890 --GLD- Send parameters to P2A on Create CEP Case Button from QLI
      Team: Gladiators
    _________________________________________________________________________________________
    
    *@description: getsEffectiveDay with proper integer format
    _________________________________________________________________________________________
    
    *@param: iEffectiveDay - Day - Integer

    _________________________________________________________________________________________
    
    *@return: String
    _________________________________________________________________________________________
    */
    private static String getEffectiveDay(Integer iEffectiveDay){
        return (iEffectiveDay < 10 ? ('0'+ String.valueOf(iEffectiveDay)) : String.valueOf(iEffectiveDay));
    }
     /*
      Story :PRDCRM-51890 - Send parameters to P2A on Create CEP Case Button from QLI
      Team: Gladiators
    _________________________________________________________________________________________
    
    *@description: get Final Response
    _________________________________________________________________________________________
    
    *@param: oP2AJsonObj - P2A JSON values for Payload
    *@param: oResponseWrapper - response wrapper for lightning screen

    _________________________________________________________________________________________
    
    *@return: ResponseWrapper
    _________________________________________________________________________________________
    */
    
    private static ResponseWrapper getFinalResponse(LGP2AJSON oP2AJsonObj, ResponseWrapper oResponseWrapper){
        
         if(oP2AJsonObj != null){
                    String sJsonToHR = LGP2AJSON.parse(oP2AJsonObj);
                    oResponseWrapper.attributeValue = sJsonToHR;  
                    oResponseWrapper.status = (staticVariableClass.CreateGrpSUCCESS).toUpperCase();
        }
        return oResponseWrapper;
    }
}