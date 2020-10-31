/*
@Author : CDHP Dev Team 
@name : CDHP_ISG_Send_Opportunity
@CreateDate :06-29-2018
@Description : This class sends the opportunity data to ISG when CDHP Plans are selected and based on business rules
*/

public with sharing class CDHP_ISG_Send_Opportunity {    
    private set<Id> optyIdSet;    
	private set<Id> quoteIdSet; 	
    private set<string> stageNames;   
    private static final string ANA_CL_CHANGE_CANCELLED='Change Cancelled';
    private static final string ANA_CL_CHANGE_CONFIRMED='Change Confirmed';
    private static final string ANA_CL_CLOSED_WON='Closed Won';
    //US-33873/6789 Create CDHP Questionnaire record for Renewed Opportunities with "RenewalFinalized" as Stage
    private static final string ANA_CL_Renewal_Finalized = 'Renewal Finalized';
    private List<QuoteLineItem> RenewalLineItemList;
    private set<Id> renewalOptyIdSet;
    //US-33873 ends
    
    private static final string ANA_CL_CLOSED_DEAD='Closed Dead';
    private static final string ANA_CL_DTQ='DTQ';
    private static final string ANA_CL_CUSTOMER_TERMED='Customer Termed';   
    private static final string CLASS_NAME='CDHP_ISG_Send_Opportunity';
    private static final String SELECT_QLI = 'SELECT TECH_UpdateToInvoke__c FROM QuoteLineItem WHERE Quote.OpportunityId in : idSet1 AND Product2.Name'+ 
        ' like \'%CDHP%\' and ProductStage__c = \'Sold\' Order by CreatedDate DESC LIMIT 1000';
    private boolean qualifiedToSend;
    private List<QuoteLineItem> lineItemList = new List<QuoteLineItem>();    
    
    /* This method gets the Opportunities for which stageNames are as mentioned and gets those QuoteLineItem records related to these opportunities. */
    public void sendOpportunityData(String quoteId){
        system.debug('***********quoteId' + quoteId);
		//Commented old code - 38037, 38416, CDHP Functionality
       /* optyIdSet = new set<Id>();
        //US-33873/6789 Create CDHP Questionnaire record for Renewed Opportunities with "RenewalFinalized" as Stage
        renewalOptyIdSet = new set<Id>();
        //ends
        stageNames = new set<string>{ANA_CL_CLOSED_WON};        
            for(Opportunity newOpty:newList){ 
                System.debug('State - '+newOpty.Id +'---'+newOpty.StageName);
                if(newOpty.StageName == ANA_CL_CLOSED_WON){
                    optyIdSet.add(newOpty.Id);              
                }
                //US-33873/6789 
                //check for processed Renewal Opportunities
                if(newOpty.StageName == ANA_CL_Renewal_Finalized){
                    renewalOptyIdSet.add(newOpty.Id);              
                }
                //ends
            }           
        //Updating condition to add only if the Product is configured
        if(!optyIdSet.isEmpty()){
            lineItemList = [SELECT Id,Quote.OpportunityId 
                            FROM QuoteLineItem 
                            WHERE Quote.OpportunityId in : optyIdSet 
                            AND /*Product2.Name like '%Act Wise%'*/  
							/*Product2.QLIRecordType__c like '%ActWise%' 
                            AND (ProductStage__c = 'Sold' or ProductStage__c = 'Renewed' or ProductStage__c = 'IGAP Sold')
                            AND PLComplete__c = TRUE
                           ]; 
        }
        System.debug('*****************Items - '+lineItemList);
        //US-33873/6789 Create CDHP Questionnaire record for Renewed Opportunities with "RenewalFinalized" as Stage
        if(!renewalOptyIdSet.isEmpty()){
            //Updating condition to add only if the Product is configured
            RenewalLineItemList = [SELECT Id,Quote.OpportunityId 
                                   FROM QuoteLineItem 
                                   WHERE Quote.OpportunityId in : renewalOptyIdSet 
                                   AND (Quote.Opportunity.RecordType.Name = 'Renewal' OR Quote.Opportunity.RecordType.Name = 'Renewal Local')
                                   AND (ProductStage__c = 'Sold' or ProductStage__c = 'Renewed' or ProductStage__c = 'IGAP Sold')
                                   AND PLComplete__c = TRUE
                                  ];
            if(!renewalOptyIdSet.isEmpty()){
                //Add the Renewal Opportunity's QuoteLineItems		
                lineItemList.addAll(RenewalLineItemList);
            }
        }
        //ends */
		if(!String.isBlank(quoteId)){
				lineItemList = [SELECT Id,QuoteId,Quote.OpportunityId 
                            FROM QuoteLineItem 
                            WHERE QuoteId  =: quoteId 
							AND (Quote.Opportunity.StageName =: ANA_CL_CLOSED_WON OR Quote.Opportunity.StageName =: ANA_CL_Renewal_Finalized)
                            AND /*Product2.Name like '%Act Wise%'*/  Product2.QLIRecordType__c like '%ActWise%' 
                            AND (ProductStage__c = 'Sold' or ProductStage__c = 'Renewed' or ProductStage__c = 'IGAP Sold')
                            AND PLComplete__c = TRUE
                           ]; 
		}
        if(!lineItemList.isEmpty()){                
            checkTheQualifierSendToISG();
        } 
    } 
    /* This method sets the UpdateToInvoke technical date field to Current date on QuoteLineItem which are retrieved from the above method. */
    private void checkTheQualifierSendToISG(){  
        quoteIdSet = new set<Id>();  
		optyIdSet = new set<Id>();
        List<Id> lstQtId = new List<Id>();
        List<Id> lstOpptyId = new List<Id>();
        for(QuoteLineItem lineItem: lineItemList){
            quoteIdSet.add( lineItem.QuoteId); 
			optyIdSet.add(lineItem.Quote.OpportunityId);
        }
        system.debug('***********quoteIdSet' + quoteIdSet);
		system.debug('***********optyIdSet' + optyIdSet);
		
        
		lstQtId.addAll(quoteIdSet);
		lstOpptyId.addAll(optyIdSet);
		
		String quoteId = lstQtId[0];
		String opptyId = lstOpptyId[0];
		
		
        /*for (Id quoteId:quoteIdSet){
            CDHPIntegrationController.SendCDHPDetailsToISG(quoteId+'');
        }*/
		CDHPIntegrationController.SendCDHPDetailsToISG(quoteId, opptyId); // Passing only first index element assumming CDHP functionality is specific to Quote
    }   
}