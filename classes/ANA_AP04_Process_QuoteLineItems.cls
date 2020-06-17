/*
@Author : Accenture Offshore Dev team
@name : ANA_AP04_Process_QuoteLineItems
@CreateDate :25-05-2017
@Description : This class updates Tech Date fiels on QuoteLineItem related to Opportunity via Quote.
*/
public with sharing class ANA_AP04_Process_QuoteLineItems {    
    private set<Id> optyIdSet;     
    private set<string> stageNames;   
    private static final string ANA_CL_CHANGE_CANCELLED='Change Cancelled';
    private static final string ANA_CL_CHANGE_CONFIRMED='Change Confirmed';
    private static final string ANA_CL_CLOSED_LOST='Closed Lost';
    private static final string ANA_CL_CLOSED_DEAD='Closed Dead';
    private static final string ANA_CL_DTQ='DTQ';
    private static final string ANA_CL_CUSTOMER_TERMED='Customer Termed';   
    private static final string CLASS_NAME='ANA_AP04_Process_QuoteLineItems';
    private static final String SELECT_QLI = 'SELECT TECH_UpdateToInvoke__c FROM QuoteLineItem WHERE \n'+
                                             'Quote.OpportunityId in : idSet1 Order by CreatedDate DESC LIMIT 1000';
    private List<QuoteLineItem> lineItemList;    
    /* This method gets the Opportunities for which stageNames are as mentioned and gets those QuoteLineItem records related to these opportunities. */
    public void persistLineItemData(List<Opportunity> newList,map<Id,Opportunity> oldMap){
        optyIdSet = new set<Id>();
        stageNames = new set<string>{ANA_CL_CHANGE_CANCELLED,ANA_CL_CLOSED_LOST,ANA_CL_CHANGE_CONFIRMED,
            ANA_CL_CLOSED_DEAD,ANA_CL_DTQ,ANA_CL_CUSTOMER_TERMED};        
                    for(Opportunity newOpty:newList){ 
                        if(newOpty.StageName != oldMap.get(newOpty.Id).StageName && stageNames.contains(newOpty.StageName)){
                            optyIdSet.add(newOpty.Id);              
                        }       
                    }           
                    ANA_UTIL02_AccessQLIDataUtil.idSet1 = optyIdSet;                                        
                    lineItemList = ANA_UTIL02_AccessQLIDataUtil.queryQuoteLineItems(SELECT_QLI);  
                    if(!lineItemList.isEmpty()){                
                            updateQuoteLineItems();
                        } 
    } 
    /* This method sets the UpdateToInvoke technical date field to Current date on QuoteLineItem which are retrieved from the above method. */
    private void updateQuoteLineItems(){        
            for(QuoteLineItem lineItem: lineItemList){
                lineItem.TECH_UpdateToInvoke__c = system.now();         
            }   
            ANA_UTIL02_AccessQLIDataUtil.updateQuoteLineItems(lineItemList); 
            validateCustomValidationsOnQuote(lineItemList);
            
    }
/*This method updates Quote Line Items.*/
    private void validateCustomValidationsOnQuote(List<QuoteLineItem> qItemList){
        Database.Update(qItemList);  
    }
   
}