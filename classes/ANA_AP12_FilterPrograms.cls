/*
@author         Accenture offshore
@date           30/06/2017
@name           ANA_AP12_FilterPrograms
@description    Used in vlocity omniscript to get a list of Available Programs.  
*/
Global without sharing class ANA_AP12_FilterPrograms implements vlocity_ins.VlocityOpenInterface2
{
    public static final String GETPROVIDERGROUPVALUES = 'getProviderGroupValues';
    public static final string NODENAME='filteredPrograms';
    public static final String FIXEDNODENAME='filteredFixedPrograms';
    public static final String CLASSNAME = ANA_AP12_FilterPrograms.class.getName();
    private static final String SELECT_PRODCHILD='SELECT vlocity_ins__ChildProductId__r.LOB__c, \n' +
                                                 'vlocity_ins__ChildProductId__r.QLIRecordType__c,vlocity_ins__ChildProductId__r.Name, \n' +
                                                 'vlocity_ins__ChildProductId__r.IsActive,vlocity_ins__ChildProductId__c from vlocity_ins__ProductChildItem__c \n'+
                                                 ' where vlocity_ins__ParentProductId__c =: prodid ORDER BY vlocity_ins__ChildProductId__r.Name ASC';
    private static final String SELECT_PROD='SELECT Product2Id from QuoteLineItem where ParentQuoteLineItem__c = :parentQLI';
    private static final String PRODID= 'ProdId';
    private static final String QLIID='QLIid';
    private static final String BUNDLE='Bundle';
    private static final String FIXED='Fixed';
    private static final String PRODSTG='ProdStage';
     /*Implementation of invokeMEthod from VlocityOpenInterface2 interface.*/
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,
                                Object> outMap,Map<String,Object> optns) {
                                    if(GETPROVIDERGROUPVALUES.equalsIgnoreCase(methodName))
                                    {
                                        getProviderGroupValues(inputMap, outMap, optns);
                                    }
                                    
                                    return true;
                                }
    /*Adds a list of provider group values along with other parameters to output map*/
    global  void  getProviderGroupValues(Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns)
    {
        try{
            Sobject sobj;            
            Id prodid = (Id)input.get(PRODID);
            Id parentQLI = (Id)input.get(QLIID);
            String bundle= (String)input.get(BUNDLE);
            String prodStage=(String)input.get(PRODSTG);
            set<Id> prodIdSet = new set<Id>();
            List<AvailabeProgramWrapper> wrapList = new List<AvailabeProgramWrapper>();
            ANA_UTIL07_AccessProductDataUtil.prodid=prodid; 
            ANA_UTIL07_AccessProductDataUtil.parentQLI=parentQLI;
            List<vlocity_ins__ProductChildItem__c> prodList = ANA_UTIL07_AccessProductDataUtil.queryProdChildItems(SELECT_PRODCHILD);
            List<QuoteLineItem> childProdList=ANA_UTIL07_AccessProductDataUtil.queryChildProds(SELECT_PROD);
            for(QuoteLineItem qli: childProdList){
                prodIdSet.add(qli.Product2Id);
            }         
            for(vlocity_ins__ProductChildItem__c prod:prodList) {               
                if(!prodIdSet.contains(prod.vlocity_ins__ChildProductId__c)){
                    wrapList.add(new AvailabeProgramWrapper(prod.vlocity_ins__ChildProductId__r.LOB__c,prod.vlocity_ins__ChildProductId__r.QLIRecordType__c,
                                                            prod.vlocity_ins__ChildProductId__r.Name,prod.vlocity_ins__ChildProductId__r.IsActive,prod.vlocity_ins__ChildProductId__c,false,false,prodStage)); 
                }                               
            }
            if(FIXED.equalsIgnoreCase(bundle)){
                outMap.put(FIXEDNODENAME,wrapList);
            }
            else{
                outMap.put(NODENAME,wrapList);
            }
        }
        catch(Exception excn){
            UTIL_LoggingService.logHandledException(excn, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
                                                    CLASSNAME, GETPROVIDERGROUPVALUES,null,LoggingLevel.ERROR);  
        }
    }
    /*Wrapper class used to construct provider group parameters to create Child Product Parametrs*/
    public without sharing class AvailabeProgramWrapper{
        private string LOB;
        private string QLIRecordType;
        private string Name;
        private Boolean IsActive;
        private string Id;
        private Boolean vlcSelected; 
        private Boolean vlcBundleStage;
        private String prodStage;
        /*Constructor for initializing variable programbundle value.*/
        public AvailabeProgramWrapper(string lb,string rc,string nme,boolean active,string pid,boolean selected,boolean bundlestage,String prdstg){
            LOB = lb;
            QLIRecordType = rc;
            Name = nme;
            IsActive = active;
            Id = pid;
            vlcSelected = selected;
            vlcBundleStage = bundlestage;
            prodStage=prdstg;
        }
    }
}