/*
@Author : Accenture Offshore Dev team
@name : ANA_AP06_QLI_Process_ChildCount
@CreateDate : 20-06-2017
@Description : This class process the child QuoteLineItems and updates the Program Lines field of QLI.
*/
public with sharing class ANA_AP10_ProductSelectionCount {    
    private Static final string CLASS_NAME = 'ANA_AP10_Product_Selection_Count';
    private Static final string PARENTQUOTELINEITEM = 'QuoteLineItem__c';
    private Static final string CHILDCOUNT = 'childCount';
    private Set<Id> qliParentIdSet;
    private map<Id,QuoteLineItem> liUpdateMap;
    private List<AggregateResult> agrrList;
    private QuoteLineItem lineItem;
    private static final String SELECT_QLI_PARENT = 'SELECT count(id) childCount,QuoteLineItem__c FROM \n'+
                                                    'ProductSelectionDetail__c WHERE QuoteLineItem__c in :idSet1 \n'+
                                                    'GROUP BY QuoteLineItem__c LIMIT 1000';
    
    /**************************************************************************************************/
    /*This method is used to capture parent QLI and process the count of child QLI for each parent QLI.*/
    public void processChildCount (List<ProductSelectionDetail__c> newList,map<Id,ProductSelectionDetail__c> oldMap,List<ProductSelectionDetail__c> oldList,string triggerName){          
        qliParentIdSet = new Set<Id>();
        liUpdateMap = new map<Id,QuoteLineItem>();        
        try{
            /*create*/
            if((oldList == null) && (oldMap == null)){
                for(ProductSelectionDetail__c newQLI:newList){
                        if((newQLI.QuoteLineItem__c != null)){
                        qliParentIdSet.add(newQLI.QuoteLineItem__c);
                    }
                }               
            }
            /*delete*/
            else if((newlist == null)){
                for(ProductSelectionDetail__c oldQLI:oldList){
                    if((oldQLI.QuoteLineItem__c != null)){                
                        qliParentIdSet.add(oldQLI.QuoteLineItem__c);
                    }
                }
            }
            /*update*/
            else{
                for(ProductSelectionDetail__c newQLI:newList){
                        if((newQLI.QuoteLineItem__c != null && newQLI.QuoteLineItem__c != oldMap.get(newQLI.Id).QuoteLineItem__c)){                      
                        qliParentIdSet.add(newQLI.QuoteLineItem__c);
                    }
                }
            }            
            if(!qliParentIdSet.isEmpty()){
                persistLineItems();
            }
        }           
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
            CLASS_NAME, ANA_UTIL03_Constants.CANCEL,triggerName,LoggingLevel.ERROR);
        }
    }
       
     /**************************************************************************************************/
    /*This method updates the ProductSelections__c field of Product Selection Detail with the count of its child.*/
    private void persistLineItems(){        
        ANA_UTIL02_AccessQLIDataUtil.idSet1 = qliParentIdSet;
        agrrList = ANA_UTIL02_AccessQLIDataUtil.callAggregateQuery(SELECT_QLI_PARENT);       
        for(AggregateResult result :agrrList){
            lineItem = new QuoteLineItem(Id=(Id)result.get(PARENTQUOTELINEITEM));
            lineItem.ProductSelections__c = (Integer)result.get(CHILDCOUNT);
            liUpdateMap.put(lineItem.Id,lineItem);
        }
           if(liUpdateMap.size() < qliParentIdSet.size()){
            for(Id pId: qliParentIdSet){
                if(liUpdateMap.get(pId) == null){
                    lineItem = new QuoteLineItem(Id = pId);
                    lineItem.ProductSelections__c = 0;
                    liUpdateMap.put(lineItem.Id,lineItem);
                }         
            }
        }        
        if(!liUpdateMap.isEmpty()) {
            ANA_UTIL02_AccessQLIDataUtil.updateQuoteLineItems(liUpdateMap.values());
        }
    }
}