/*
@Author : Accenture Offshore Dev team
@name : ANA_AP06_QLI_Process_ChildCount
@CreateDate : 30-05-2017
@Description : This class process the child QuoteLineItems and updates the Program Lines field of QLI.
*/
public with sharing class ANA_AP06_QLI_Process_ChildCount {    
    private Static final string CLASS_NAME = 'ANA_AP06_QLI_Process_ChildCount';
    private Static final string PARENTQUOTELINEITEM = 'ParentQuoteLineItem__c';
    private Static final string CHILDCOUNT = 'childCount';
    private Static final string FIXED = 'Fixed';
    private static final String EMPTY=''; 
    private static final String IHM='Integrated Health Model';
    private static final String AHG='Other-Anthem Health Guide';
    private static final String SFA='Submitted For Approval';
    private static final String APRD='Approved';
    private static final String NSTD='Not started';
    private static final String RJTD='Rejected';
    private Set<Id> qliParentIdSet;
    private Set<Id> parentQliSet;
    private Set<Id> optyIdSet;
    private map<Id,QuoteLineItem> parentProdMap;    
    private map<Id,QuoteLineItem> liUpdateMap;
    private List<AggregateResult> agrrList;
    private List<AggregateResult> countList;
    private List<QuoteLineItem> childList;
    private List<Opportunity> OptyUpdateList;
    private List<ProductSelectionDetail__c> childSelections;
    private List<AlternateNetwork__c> childNetworks;
    private List<PricebookEntry> priceBooks;
    private List<Opportunity> optyList;
    private QuoteLineItem lineItem;
    private set<Id> optyHasAHGSet;
    
    
    private static final String SELECT_QLI_PARENT = 'SELECT count(id) childCount,ParentQuoteLineItem__c FROM \n'+
        'QuoteLineItem WHERE ParentQuoteLineItem__c in :idSet1 \n'+
        'GROUP BY ParentQuoteLineItem__c LIMIT 1000';
    private static final String SELECT_QLI_CHILD = 'SELECT ID FROM QuoteLineItem\n'+
        'WHERE ParentQuoteLineItem__c in :idSet2 LIMIT 1000';
    private static final String SELECT_PRODUCT_CHILD = 'SELECT ID FROM ProductSelectionDetail__c\n'+
        'WHERE QuoteLineItem__c in :idSet3 LIMIT 1000';                                             
    private static final String SELECT_NETWORK_CHILD = 'SELECT ID FROM AlternateNetwork__c\n'+
        'WHERE QuoteLineItem__c in :idSet4 LIMIT 1000';
    private static final String SELECT_CHILD_PRODUCT = 'SELECT vlocity_ins__ChildProductId__c,vlocity_ins__ParentProductId__c\n'+
        'FROM vlocity_ins__ProductChildItem__c\n'+
        'WHERE vlocity_ins__ParentProductId__c in :idSet5 LIMIT 1000';
    private static final String SELECT_PRICE_BOOKID = 'SELECT ID,Product2Id FROM PricebookEntry\n'+
        'WHERE Product2Id in :idSet5 LIMIT 1000';
    private static final String SELECT_PRODUCTS = 'select id,Bundle__c from Product2\n'+
        'where id In:idSet6 LIMIT 1000';   
    private static final String SELECT_AHGPRODS_COUNT='SELECT OpportunityId__c,HasAHG__c FROM QuoteLineItem WHERE \n'+
        '(Product2.Name=:AHG OR Product2.Name=:IHM)\n'+
        ' AND (ProductLineApprovalStatus__c=:SFA OR ProductLineApprovalStatus__c=:APRD) AND Quote.OpportunityId in :optyIdSet2';
    
    
    /**************************************************************************************************/
    /*This method is used to capture parent QLI and process the count of child QLI for each parent QLI.*/
    public void processChildCount (List<QuoteLineItem> newList,map<Id,QuoteLineItem> oldMap,List<QuoteLineItem> oldList,string triggerName){          
        qliParentIdSet = new Set<Id>();
        liUpdateMap = new map<Id,QuoteLineItem>();        
        try{
            /*create*/
            if((oldList == null) && (oldMap == null)){
                for(QuoteLineItem newQLI:newList){
                    if((newQLI.ParentQuoteLineItem__c != null)){
                        qliParentIdSet.add(newQLI.ParentQuoteLineItem__c);
                        
                    }
                }
            }
            /*delete*/
            else if((newlist == null)){
                for(QuoteLineItem oldQLI:oldList){
                    if((oldQLI.ParentQuoteLineItem__c != null)){                
                        qliParentIdSet.add(oldQLI.ParentQuoteLineItem__c);
                    }
                }
            }
            /*update*/
            else{
                for(QuoteLineItem newQLI:newList){
                    if(newQLI.ParentQuoteLineItem__c != null ){                     
                        qliParentIdSet.add(newQLI.ParentQuoteLineItem__c);
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
    /*This method captures all the deleted parent QLI's.*/
    public void deleteChildQLI(List<QuoteLineItem> newList,map<Id,QuoteLineItem> oldMap,List<QuoteLineItem> oldList,string triggerName){
        parentQliSet = new Set<Id>();
        try{
            /*delete*/
            if((newlist == null)){
                for(QuoteLineItem oldQLI:oldList){
                    if((oldQLI.ParentQuoteLineItem__c == null)){                
                        parentQliSet.add(oldQLI.Id);
                    }
                }
            }
            
            if(!parentQliSet.isEmpty()){
                deleteLineItems();
                deleteProductSelections();
                deleteAlternateNetworks();
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
                                                    CLASS_NAME, ANA_UTIL03_Constants.CANCEL,triggerName,LoggingLevel.ERROR);
        }
    }
    /**************************************************************************************************/
    /*This method is used to capture parent QLI and process the count of child QLI for each parent QLI.*/
    public void insertChildQLI(List<QuoteLineItem> newList,map<Id,QuoteLineItem> oldMap,List<QuoteLineItem> oldList,string triggerName){
        parentProdMap = new map<Id,QuoteLineItem>();
        set<id> setqliids=new set<Id>();
        map<id,Product2> mapprod = new map<id,Product2>();
        try{
            /*Create*/
            if((oldList == null) && (oldMap == null)){
                for(QuoteLineItem newQLI:newList){
                    setqliids.add(newQLI.Product2id);
                }
                if(!setqliids.isEmpty()){
                    ANA_UTIL07_AccessProductDataUtil.idSet6 = setqliids;
                    for(product2 pid:ANA_UTIL07_AccessProductDataUtil.queryProds(SELECT_PRODUCTS)){
                        mapprod.put(pid.id,pid);
                    }
                }
                for(QuoteLineItem newQLI:newList){
                    if(newQLI.TECH_OSIsMultiSelect__c && (String.isBlank(newQLI.ParentQuoteLineItem__c)) && !mapprod.isEmpty() && mapprod.containskey(newQLI.Product2id) && FIXED.equalsIgnoreCase(mapprod.get(newQLI.Product2id).Bundle__c)){
                        parentProdMap.put(newQLI.Product2Id,newQLI);
                    }
                }
            }
            if(!parentProdMap.isEmpty()){
                insertLineItems();
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
                                                    CLASS_NAME, ANA_UTIL03_Constants.CANCEL,triggerName,LoggingLevel.ERROR);
        }
    }
    /**************************************************************************************************/
    /*This method updates the ProgamLines__c field of parent QLI with the count of its child.*/
    private void persistLineItems(){        
        ANA_UTIL02_AccessQLIDataUtil.idSet1 = qliParentIdSet;
        agrrList = ANA_UTIL02_AccessQLIDataUtil.callAggregateQuery(SELECT_QLI_PARENT);     
        for(AggregateResult result :agrrList){
            lineItem = new QuoteLineItem(Id=(Id)result.get(PARENTQUOTELINEITEM));
            lineItem.ProgramLines__c = (Integer)result.get(CHILDCOUNT);
            liUpdateMap.put(lineItem.Id,lineItem);
        }
        if(liUpdateMap.size() < qliParentIdSet.size()){
            for(Id pId: qliParentIdSet){
                if(liUpdateMap.get(pId) == null){
                    lineItem = new QuoteLineItem(Id = pId);
                    lineItem.ProgramLines__c = 0;
                    liUpdateMap.put(lineItem.Id,lineItem);
                }         
            }
        }        
        if(!liUpdateMap.isEmpty()) {
            ANA_UTIL02_AccessQLIDataUtil.updateQuoteLineItems(liUpdateMap.values());
        }
    }
    /**************************************************************************************************/
    /*This method deletes the child QLI's for which parent QLI's are deleted.*/ 
    private void deleteLineItems(){
        ANA_UTIL02_AccessQLIDataUtil.idSet2 = parentQliSet;
        childList = ANA_UTIL02_AccessQLIDataUtil.queryQuoteLineItems(SELECT_QLI_CHILD);             
        if(!childList.isEmpty()){                
            ANA_UTIL02_AccessQLIDataUtil.deleteQuoteLineItems(childList);
        } 
    }
    /**************************************************************************************************/
    /*This method deletes the child Product Selections records for which parent QLI's are deleted.*/ 
    private void deleteProductSelections(){
        ANA_UTIL10_AccessProductSelectionUtil.idSet3 = parentQliSet;
        childSelections = ANA_UTIL10_AccessProductSelectionUtil.queryProductSelections(SELECT_PRODUCT_CHILD);  
        if(!childSelections.isEmpty()){                
            ANA_UTIL10_AccessProductSelectionUtil.deleteSelections(childSelections);
        } 
    }
    /**************************************************************************************************/
    /*This method deletes the child Alternate Network records for which parent QLI's are deleted.*/      
    private void deleteAlternateNetworks(){
        ANA_UTIL11_AccessAlternateNetworkUtil.idSet4 = parentQliSet;
        childNetworks = ANA_UTIL11_AccessAlternateNetworkUtil.queryAlternateNetworks(SELECT_NETWORK_CHILD);  
        if(!childNetworks.isEmpty()){                
            ANA_UTIL11_AccessAlternateNetworkUtil.deleteNetworks(childNetworks);
        } 
    }
    /**************************************************************************************************/
    /*This method inserts the child QuoteLineItem records for which parent QLI's are updated with TECH_OSIsMultiSelect field.*/  
    private void insertLineItems(){
        map<Id,List<Id>> parentChildPrdMap = new map<Id,List<Id>>();
        QuoteLineItem qli;
        List<QuoteLineItem> childProdList = new List<QuoteLineItem>();
        set<Id> childProdSet = new set<Id>();
        
        ANA_UTIL07_AccessProductDataUtil.idSet5 = parentProdMap.keyset();
        for(vlocity_ins__ProductChildItem__c pci: ANA_UTIL07_AccessProductDataUtil.queryProdItems(SELECT_CHILD_PRODUCT)){
            if(!parentChildPrdMap.containsKey(pci.vlocity_ins__ParentProductId__c)){
                parentChildPrdMap.put(pci.vlocity_ins__ParentProductId__c,new List<Id>{pci.vlocity_ins__ChildProductId__c});
                childProdSet.add(pci.vlocity_ins__ChildProductId__c);
            }               
            else{
                parentChildPrdMap.get(pci.vlocity_ins__ParentProductId__c).add(pci.vlocity_ins__ChildProductId__c);
                childProdSet.add(pci.vlocity_ins__ChildProductId__c);
            }               
        }       
        if(!childProdSet.isEmpty()){
            ANA_UTIL07_AccessProductDataUtil.idSet5 = childProdSet;
            map<Id,Id> prdPriceBookMap = ANA_UTIL07_AccessProductDataUtil.queryPriceBookEntry(SELECT_PRICE_BOOKID);
            for(Id ParentPrdId:parentChildPrdMap.keyset()){
                for(Id childPrdId:parentChildPrdMap.get(ParentPrdId)){
                    qli = new QuoteLineItem();
                    qli.PricebookEntryId = prdPriceBookMap.get(childPrdId);
                    qli.Product2Id = childPrdId;
                    qli.ParentQuoteLineItem__c = parentProdMap.get(ParentPrdId).Id;
                    qli.QuoteId = parentProdMap.get(ParentPrdId).QuoteId;
                    qli.ProductStage__c = parentProdMap.get(ParentPrdId).ProductStage__c;
                    qli.Reason__c = parentProdMap.get(ParentPrdId).Reason__c;
                    qli.Probability__c = parentProdMap.get(ParentPrdId).Probability__c;
                    qli.TermDate__c = parentProdMap.get(ParentPrdId).TermDate__c;
                    qli.OppType__c = parentProdMap.get(ParentPrdId).OppType__c;
                    qli.Quantity = parentProdMap.get(ParentPrdId).Quantity;
                    qli.UnitPrice = parentProdMap.get(ParentPrdId).UnitPrice;
                    childProdList.add(qli);
                }
                
            }
        }
        
        if(!childProdList.isEmpty()){
            ANA_UTIL02_AccessQLIDataUtil.insertQuoteLineItems(childProdList);  
        }            
    }
    
    /**************************************************************************************************/
    /*This method updates flag on Opportunity for AHG and IHM products when qli is deleted.*/
    public void updateFlagForDelete (List<QuoteLineItem> oldQliLst,string triggerName){
        optyIdSet=new Set<Id>();        
        optyHasAHGSet = new set<Id>();
        childList = new List<QuoteLineItem>();
        OptyUpdateList=new List<Opportunity>();
        try{
            for(QuoteLineItem oldQli:oldQliLst){
                if((AHG.equalsIgnoreCase(oldQli.ProductName__c) || IHM.equalsIgnoreCase(oldQli.ProductName__c)) && 
                   (SFA.equalsIgnoreCase(oldQli.ProductLineApprovalStatus__c) || APRD.equalsIgnoreCase(oldQli.ProductLineApprovalStatus__c))){
                       optyIdSet.add(oldQli.OpportunityId__c);
                   }
            }                
            if(!optyIdSet.isEmpty()){                    
                getOptysToUpdate();                                       
                if(!OptyUpdateList.isEmpty()){
                    database.update(OptyUpdateList);
                }
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
                                                    CLASS_NAME, ANA_UTIL03_Constants.CANCEL,triggerName,LoggingLevel.ERROR);
        }
    }
    
    /************************************************************************************************************/    
    /*This method updates flag on Opportunity for AHG and IHM products*/
    public void updateFlagOnOpty(List<QuoteLineItem> newQliLst,string triggerName){    
        optyIdSet=new Set<Id>();        
        optyHasAHGSet = new set<Id>();
        childList = new List<QuoteLineItem>();
        OptyUpdateList=new List<Opportunity>();
        try{ 
            optyUpdateList=new List<Opportunity>();            
            for(QuoteLineItem newQli:newQliLst){
                if((AHG.equalsIgnoreCase(newQli.ProductName__c) || IHM.equalsIgnoreCase(newQli.ProductName__c)) && 
                   (SFA.equalsIgnoreCase(newQli.ProductLineApprovalStatus__c) || APRD.equalsIgnoreCase(newQli.ProductLineApprovalStatus__c)) && (!newQli.HasAHG__c)){ 
                       OptyUpdateList.add(new Opportunity(Id=newQli.OpportunityId__c,HasAHG__c=true)); 
                   }
                else if ((AHG.equalsIgnoreCase(newQli.ProductName__c) || IHM.equalsIgnoreCase(newQli.ProductName__c)) && 
                         (NSTD.equalsIgnoreCase(newQli.ProductLineApprovalStatus__c) || RJTD.equalsIgnoreCase(newQli.ProductLineApprovalStatus__c))){                                 
                             optyIdSet.add(newQli.OpportunityId__c);
                         }
            }            
            if(!optyIdSet.isEmpty()){
                getOptysToUpdate();
            }
            if(!OptyUpdateList.isEmpty()){
                database.update(OptyUpdateList);
            }
        }
        catch(Exception excp){
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
                                                    CLASS_NAME, ANA_UTIL03_Constants.CANCEL,triggerName,LoggingLevel.ERROR);
        }
    }
    
    /************************************************************************************************************/
    /*This is a Helper method to update flag on Opportunity for AHG and IHM products*/
    public void getOptysToUpdate(){
        ANA_UTIL02_AccessQLIDataUtil.optyIdSet2=optyIdSet;
        ANA_UTIL02_AccessQLIDataUtil.AHG=AHG;
        ANA_UTIL02_AccessQLIDataUtil.IHM=IHM;
        ANA_UTIL02_AccessQLIDataUtil.SFA=SFA;
        ANA_UTIL02_AccessQLIDataUtil.APRD=APRD;     
        childList=ANA_UTIL02_AccessQLIDataUtil.queryQuoteLineItems(SELECT_AHGPRODS_COUNT);                    
        for(QuoteLineItem qliRec: childList){
            optyHasAHGSet.add(qliRec.OpportunityId__c);
        }                                      
        for(Id optyId: optyIdSet){                      
            if(!optyHasAHGSet.contains(optyId)){
                OptyUpdateList.add(new Opportunity(Id=optyId,HasAHG__c=false));                         
            }                
        }       
    }   
    
    /**************************************************************************************************/
    /*This method captures all the deleted ActWise Companion for HRA/HSA */
    public void deleteQLIActwiseCompanionProduct(List<QuoteLineItem> newList,map<Id,QuoteLineItem> oldMap,List<QuoteLineItem> oldList,string triggerName){
        System.debug('--- deleteQLIActwiseCompanionProduct oldMap='+oldMap);
        try {
            if(oldMap != null && oldMap.size() > 0) {
                Set<Id> quoteIdSet = new Set<Id>();
                for(QuoteLineItem qli:oldMap.values()) {
                    quoteIdSet.add(qli.QuoteId);
                }            
                delete [Select Id From QuoteLineItem where QuoteId in :quoteIdSet And (ActWise_ParentQuoteLineItem__r.ParentQuoteLineItem__c in :oldMap.keySet() OR ActWise_ParentQuoteLineItem__c in :oldMap.keySet()) And ActWiseChildQuote__c = null];
            }
        } catch(Exception excp){
            System.debug('--- deleteQLIActwiseCompanionProduct Exception'+excp);
            
            UTIL_LoggingService.logHandledException(excp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
                                                    CLASS_NAME, ANA_UTIL03_Constants.CANCEL,triggerName,LoggingLevel.ERROR);
        }
    }    
}