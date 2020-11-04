/**
    * @description  This class act as Handler to Trigger of Quote Line Item.
    * @author       Deloitte offshore
    * @date         25/09/2019
    * @name         LGHWQuoteLineItemActions
    ______________________________________________________________________________________________________________
    ______________________________________________________________________________________________________________
 */
public with sharing class LGHWQuoteLineItemActions{
    /**
     * @description This methood is used to identify Plans and then process further.
     * @param  newQLI List of new QuoteLineItem
     */
    public static void createHWPackagePrograms ( List<QuoteLineItem> newQLI) {
    try{
        //Check if we have Custom Setting Trigger Switch Record 
        vlocity_ins__TriggerSetup__c triggerRecord = vlocity_ins__TriggerSetup__c.getValues('QuoteLineItemAfterInsert');
        if(triggerRecord != null && triggerRecord.vlocity_ins__IsTriggerOn__c){
             //Logic to Insert  Packages
            Map<String,List<QuoteLineItem>> mapOfCombinationStringVsQuoteLineItem= new Map<String,List<QuoteLineItem>>();
            Set<Id> setQuoteLineIds = new Set<Id>();
            for(QuoteLineItem oQLI : newQLI){
                if(oQLI.ProductCategory__c.equals(staticVariableClass.Plan)){
                    String sQLICombination = oQLI.HPCC_Code__c.toLowerCase()+oQLI.Funding__c+oQLI.Situs_State_Abbrev__c+String.valueOf(oQLI.OpportunityEffectiveDate__c.year());
                    setQuoteLineIds.add(oQLI.Id);
                    if(!mapOfCombinationStringVsQuoteLineItem.containsKey(sQLICombination)){
                        mapOfCombinationStringVsQuoteLineItem.put(sQLICombination, new List<QuoteLineItem>{oQLI});
                    }
                    else{
                        mapOfCombinationStringVsQuoteLineItem.get(sQLICombination).add(oQLI);
                    }
                }
            }
            if (mapOfCombinationStringVsQuoteLineItem != null &&  mapOfCombinationStringVsQuoteLineItem.size()>0 && !setQuoteLineIds.isEmpty()){   
                createHWPackageProgramsFuture(JSON.serializePretty(mapOfCombinationStringVsQuoteLineItem),setQuoteLineIds);
            }
        }
    }   catch (Exception excn){
            ExceptionLog__c exceptionlog = createExceptionRecord(excn);
            exceptionLog.ClassName__C = staticVariableClass.CLASS_LG_QUOTE_LINE_ITEM;
            exceptionLog.MethodName__c=staticVariableClass.CREATE_HW_PACKAGE_PROGRAMS;
            exceptionLog.ApexTrigger__c=staticVariableClass.QLI_AFTER_INSERT_TRIGGER;
            insert exceptionLog;
        }
}
    /**
     * @description This methood is used as future methood to create Packages and Programs.
     * @param  sMapofCombinedStringvsQLI String form of map serialized 
     * @param  setQuoteLineIds Set of QuoteLineItem Ids
     */
    @future
    public static void createHWPackageProgramsFuture(String sMapofCombinedStringvsQLI, Set<Id> setQuoteLineIds){
       // creating a save point so that we can roll back all the changes in case of Exception.
       Savepoint sp = Database.setSavepoint();
       try{
        Map<String,List<QuoteLineItem>> mapOfCombinationStringVsQuoteLineItem= (map<String,List<QuoteLineItem>>)System.JSON.deserialize(sMapofCombinedStringvsQLI,map<String,List<QuoteLineItem>>.class);
        Set<Id > setParentIds = new Set<Id>();
        Map<String, Integer> mapOfGrpsizeVsGrpTopValue = new Map<String, Integer>{staticVariableClass.GROUP_SIZE_0_50 => 50, staticVariableClass.GROUP_SIZE_51_99 => 99, 
        staticVariableClass.GROUP_SIZE_100_249 => 249,staticVariableClass.GROUP_SIZE_250_499=> 499,
        staticVariableClass.GROUP_SIZE_500_999=> 999,staticVariableClass.GROUP_SIZE_1000=> 1000};
        Map<String,String> mapOfQLIIdvsGrpTopSize = createMapOfGrpsizeVsTopValue (setQuoteLineIds);
        
        Map<Id,Product_HPCC_Codes__c> mapOfQLIWithProdHPPC = new Map<Id,Product_HPCC_Codes__c>();
        List<QuoteLineItem> listFinalQLI= new List<QuoteLineItem>();
        Map<Id,List<String>> mapOfParentIdvsIncentiveType = new Map<Id,List<String>>();
        for (Product_HPCC_Codes__c oHPCC: Product_HPCC_Codes__c.getall().values()){
              String sHPCCCombination= oHPCC.HPCC_Code__c.toLowerCase()+oHPCC.Funding_Type__c+oHPCC.State__c+String.valueOf(oHPCC.PackageEffDt__c.year());
            if(mapOfCombinationStringVsQuoteLineItem.containsKey(sHPCCCombination) && mapOfCombinationStringVsQuoteLineItem.get(sHPCCCombination)!= null
             &&  mapOfCombinationStringVsQuoteLineItem.get(sHPCCCombination).size()>0 && mapOfQLIIdvsGrpTopSize != null){
                for(QuoteLineItem oQLI : mapOfCombinationStringVsQuoteLineItem.get(sHPCCCombination)) {
                    if(Integer.Valueof(oHPCC.Minimum__c) <= mapOfGrpsizeVsGrpTopValue.get(mapOfQLIIdvsGrpTopSize.get(oQLI.Id))){
                        mapOfQLIWithProdHPPC.put( oQLI.Id, oHPCC);
                        setParentIds.add(oHPCC.Parent_Id__c);
                        listFinalQLI.add(oQLI );
                        if(!mapOfParentIdvsIncentiveType.containsKey(oHPCC.Parent_Id__c)){
                            mapOfParentIdvsIncentiveType.put( oHPCC.Parent_Id__c, 
                            new List<String>{oHPCC.Incentive_Type__c});
                        }
                        else{
                            mapOfParentIdvsIncentiveType.get(oHPCC.Parent_Id__c).add(oHPCC.Incentive_Type__c); 
                        }
                    }
                }
              
            }
        }
        List<QuoteLineItem> listChildQLI;
        List<QuoteLineItem>  listPackageQLI = new List<QuoteLineItem>();
        if(getPricebookForProduct(setParentIds) != null && mapOfQLIWithProdHPPC != null){
           listPackageQLI= createPackageForQLI(mapOfQLIWithProdHPPC,listFinalQLI,getPricebookForProduct(setParentIds));
        }
        listChildQLI = hwProgFetch(setParentIds,mapOfParentIdvsIncentiveType,listPackageQLI);  
        Set<Id> setQuoteIds = new Set<Id>();
        Set<Id> setPlanIds = new Set<Id>();
        for (QuoteLineItem oPlanQLI: listChildQLI){
                setQuoteIds.add(oPlanQLI.Quoteid);
                setPlanIds.add(oPlanQLI.Id);
        }
        Map<Id,Map<Id,List<QuoteLineItem>>> mapOfPlanVsMapOfPackageVsProg = createMapOfPlanvsPackagevsProg(setPlanIds);
        if(!setQuoteIds.isEmpty()){
            checkForAHGPrograms (setQuoteIds,mapOfPlanVsMapOfPackageVsProg); }

       }catch(Exception excn){
            Database.RollBack(sp);
            ExceptionLog__c exceptionlog = createExceptionRecord(excn);
            exceptionLog.ClassName__C = staticVariableClass.CLASS_LG_QUOTE_LINE_ITEM;
            exceptionLog.MethodName__c=staticVariableClass.CREATE_HWPACKAGE_PROGRAMS_FUTURE;
            exceptionLog.ApexTrigger__c=staticVariableClass.QLI_AFTER_INSERT_TRIGGER;
            insert exceptionLog;
        }
    }
    
    /**
     * @description This Methood is used to form a Map for Groupsize and Top value
     * @param  setQuoteLineIds Set of QuoteLineIds
     * @return mapOfQLIIdvsGrpTopSize Map of String ,String for groupsize vs Topvalue 
     */
     public static Map<String,String> createMapOfGrpsizeVsTopValue (Set<Id> setQuoteLineIds){
     Map<String,String> mapOfQLIIdvsGrpTopSize = new Map<String,String>();    
     if(Schema.sObjectType.QuoteLineItem.isAccessible()){
            for(QuoteLineItem oEachQLI : [Select Id , QuoteId, Quote.GroupSize__c FROM QuoteLineItem Where Id IN: setQuoteLineIds ]){
                mapOfQLIIdvsGrpTopSize.put( oEachQLI.Id,oEachQLI.Quote.GroupSize__c);
            }
        }
        return mapOfQLIIdvsGrpTopSize;
    }

    /**
     * @description This methood is used to create a Map of ProductId and PriceBookId whenever Invoked using ProductId.
     * @param  setProductId Set of Products Id
     * @return mapOfProductVsPricebook  map of product vs pricebook
     */
    public static Map<Id,Id> getPricebookForProduct(Set<Id> setProductId){
        Map<Id,Id> mapOfProductVsPricebook = new Map<Id,Id>();
      
        If(setProductId !=null && setProductId.size()>0 &&   Schema.sObjectType.PricebookEntry.isAccessible()){
            for(Pricebookentry oPbe : [Select Id,Product2Id FROM PricebookEntry where Product2Id IN :setProductId AND IsActive=TRUE]){
                   mapOfProductVsPricebook.put(oPbe.Product2Id, oPbe.Id);
                }
            }
        return mapOfProductVsPricebook;
    }

    /**
     * @description This Methood is used to create PackageQLI.
     * @param mapOfQLIvsHpccCode Map of Id vs Product_HPCC_Codes__c codes
     * @param listFinalQLI List of QLI to be created 
     * @param mapOfProdIdVsPricebookId  Map Id,Id to store prodId against PricebookId 
     * @return listPackageQLI List of QuoteLineItem
     */


    public static List<QuoteLineItem> createPackageForQLI(Map<Id,Product_HPCC_Codes__c> mapOfQLIvsHpccCode, List<QuoteLineItem> listFinalQLI, Map<Id,Id> mapOfProdIdVsPricebookId ){
        List<QuoteLineItem>  listPackageQLI = new List<QuoteLineItem>();
        for(QuoteLineItem oQLI : listFinalQLI) {
            if (mapOfQLIvsHpccCode.containskey(oQLI.id)
                && mapOfQLIvsHpccCode.get(oQLI.id) != null
                && Schema.sObjectType.QuoteLineItem.isAccessible()
                && mapOfProdIdVsPricebookId.containsKey (mapOfQLIvsHpccCode.get(oQLI.Id).Parent_Id__c))
            {

                QuoteLineItem oPackageQLI = new QuoteLineItem();
                oPackageQLI.PricebookEntryId= mapOfProdIdVsPricebookId.get(mapOfQLIvsHpccCode.get(oQLI.Id).Parent_Id__c);
                oPackageQLI.Quantity= oQLI.Quantity;
                oPackageQLI.UnitPrice = oQLI.UnitPrice;
                oPackageQLI.QuoteId = oQLI.QuoteId;
                oPackageQLI.ProductStage__c=oQLI.ProductStage__c;
                oPackageQLI.HPCC_Code__c=oQLI.HPCC_Code__c;
                oPackageQLI.Product2Id = mapOfQLIvsHpccCode.get(oQLI.Id).Parent_Id__c;
                oPackageQLI.ParentQuoteLineItem__c = oQLI.id;
                oPackageQLI.RecordType__c= oQLI.RecordType__c;
                oPackageQLI.Opptype__C = oQLI.Opptype__C ;
                oPackageQLI.Funding__c = oQLI.Funding__c;
                oPackageQLI.Financing__c = oQLI.Financing__c;
                oPackageQLI.Members__c = oQLI.Members__c;
                oPackageQLI.Subscribers__c= oQLI.Subscribers__c;
                oPackageQLI.Upsell__c= oQLI.Upsell__c;
                oPackageQLI.Reason__c = oQLI.Reason__c;
                oPackageQLI.Incentive_Type__c=mapOfQLIvsHpccCode.get(oQLI.Id).Incentive_Type__c;
                listPackageQLI.add(oPackageQLI);
            }
        }
        if(!listPackageQLI.isEmpty() && Schema.sObjectType.QuoteLineItem.isCreateable()){
            insert  listPackageQLI;
        }
        return  listPackageQLI;  
       
    }

    /**
     * @description This methood used fetch Programs and Create Program.
     * @param setParentIds Set of Id of setParentIds
     * @param mapOfParentIdvsIncentiveType mapOfParentId vs Incentive Type
     * @param listPackageQLI  list of package.
     * @return listChildQLI  list of program QLIs.
    */
    public static List<QuoteLineItem> hwProgFetch(Set<Id> setParentIds, Map<Id,List<String>> mapOfParentIdvsIncentiveType, List<QuoteLineItem>listPackageQLI){
        List<QuoteLineItem>listChildQLI;
        Map<String,List<vlocity_ins__ProductChildItem__c>> mapOfParentIdVsProdChild = new Map<String,List<vlocity_ins__ProductChildItem__c>>();
        List<vlocity_ins__ProductChildItem__c> listFilteredProductChild= getFilteredProductChildList(setParentIds,mapOfParentIdvsIncentiveType);
        Set<Id> setProductChildParentId = new Set<Id>();
        for(vlocity_ins__ProductChildItem__c oEachProdChild : listFilteredProductChild ) {
            setProductChildParentId.add(oEachProdChild.vlocity_ins__ChildProductId__c);
            if(!mapOfParentIdVsProdChild.containsKey(oEachProdChild.vlocity_ins__ParentProductId__c)) {
                mapOfParentIdVsProdChild.put(oEachProdChild.vlocity_ins__ParentProductId__c,new List<vlocity_ins__ProductChildItem__c>{oEachProdChild});
            }
            else{
                mapOfParentIdVsProdChild.get(oEachProdChild.vlocity_ins__ParentProductId__c).add(oEachProdChild); 
            }
        }
        if (getPricebookForProduct(setProductChildParentId) != null){
            listChildQLI = createProgramForQLI(getPricebookForProduct(setProductChildParentId),listPackageQLI,mapOfParentIdVsProdChild);
        }
        return listChildQLI;
    }

     /**
     * @description This Methood is used to get Filtered Junction Object List to create Programs on basis of Incentive type
     * @param setParentIds Set of setParentIds
     * @param mapOfParentIdvsIncentiveType map of ID and list of string 
     * @return listFilteredProductChild List of vlocity_ins__ProductChildItem__c
     */

    public static List<vlocity_ins__ProductChildItem__c> getFilteredProductChildList(Set<Id> setParentIds, Map<Id,List<String>> mapOfParentIdvsIncentiveType){
        List<vlocity_ins__ProductChildItem__c> listFilteredProductChild = new List<vlocity_ins__ProductChildItem__c>();
        if(Schema.sObjectType.vlocity_ins__ProductChildItem__c.isAccessible()){
            for( vlocity_ins__ProductChildItem__c oProdChild : [SELECT id, vlocity_ins__ChildProductId__c, 
                                                                        vlocity_ins__ChildProductId__r.Name,
                                                                        vlocity_ins__ParentProductId__c,vlocity_ins__ParentProductId__r.Name,
                                                                        Incentive_Type_NA__c,Incentive_Type_GC__c,Incentive_Type_AD__c 
                                                                        FROM vlocity_ins__ProductChildItem__c 
                                                                        WHERE vlocity_ins__ParentProductId__c IN : setParentIds]){
                if(mapOfParentIdvsIncentiveType.containskey(oProdChild.vlocity_ins__ParentProductId__c)  &&
                    (mapOfParentIdvsIncentiveType.get(oProdChild.vlocity_ins__ParentProductId__c).contains (oProdChild.Incentive_Type_NA__c)
                    ||mapOfParentIdvsIncentiveType.get(oProdChild.vlocity_ins__ParentProductId__c).contains (oProdChild.Incentive_Type_GC__c)
                    ||mapOfParentIdvsIncentiveType.get(oProdChild.vlocity_ins__ParentProductId__c).contains (oProdChild.Incentive_Type_AD__c)
                    )) {
                        listFilteredProductChild.add(oProdChild); 
                } 
            }   
        }
        return listFilteredProductChild;
     }

    /**
     * @description This Methood is used to create Program QLI.
     * @param mapOfProdIdVsPricebookId  map of Id,Id.
     * @param listPackageQLI List of PackageQLI.
     * @param mapOfParentIdVsProdChild map of parentId vs List of productChildItem.
     * @return listChildQLI List of QuoteLineItems.
     */
    public static List<QuoteLineItem> createProgramForQLI(Map<Id,Id> mapOfProdIdVsPricebookId, List<QuoteLineItem> listPackageQLI, 
                                                          Map<String,List<vlocity_ins__ProductChildItem__c>>mapOfParentIdVsProdChild){
        List<QuoteLineItem> listChildQLI = new List<QuoteLineItem>();
        for(QuoteLineItem oParentQLI :  listPackageQLI) {  
            if(mapOfParentIdVsProdChild.containskey(oParentQLI.Product2Id) && mapOfParentIdVsProdChild.get(oParentQLI.Product2Id) != null 
                && mapOfParentIdVsProdChild.get(oParentQLI.Product2Id).size()>0
                && Schema.sObjectType.QuoteLineItem.isAccessible()) {
                for (vlocity_ins__ProductChildItem__c  oProdChild : mapOfParentIdVsProdChild.get(oParentQLI.Product2Id)) {
                   
                    QuoteLineItem oProgQLI = new QuoteLineItem();
                    oProgQLI.PricebookEntryId= mapOfProdIdVsPricebookId.get(oProdChild.vlocity_ins__ChildProductId__c);
                    oProgQLI.Quantity= oParentQLI.Quantity;
                    oProgQLI.UnitPrice = oParentQLI.UnitPrice;
                    oProgQLI.QuoteId = oParentQLI.QuoteId;
                    oProgQLI.ProductStage__c = oParentQLI.ProductStage__c;
                    oProgQLI.HPCC_Code__c= oParentQLI.HPCC_Code__c;
                    oProgQLI.Product2Id = oProdChild.vlocity_ins__ChildProductId__c;
                    oProgQLI.ParentQuoteLineItem__c = oParentQLI.id;
                    oProgQLI.RecordType__c= oParentQLI.RecordType__c;
                    oProgQLI.Opptype__C = oParentQLI.Opptype__C ;
                    oProgQLI.Funding__c = oParentQLI.Funding__c;
                    oProgQLI.Financing__c = oParentQLI.Financing__c;
                    oProgQLI.Members__c = oParentQLI.Members__c;
                    oProgQLI.Subscribers__c= oParentQLI.Subscribers__c;
                    oProgQLI.Upsell__c= oParentQLI.Upsell__c;
                    oProgQLI.Reason__c = oParentQLI.Reason__c;
                    listChildQLI.add(oProgQLI);
                }   
            }   
        }
        if(!listChildQLI.isEmpty() && Schema.sObjectType.QuoteLineItem.isCreateable()){
            insert listChildQLI;
        }
        return listChildQLI;
    }

    /**
     * @description This methood is used to create a Map of Plan vs package vs programs 
     * @param setPlanId Set of planId
     * @return mapOfPlanVsMapOfPackageVsProg map of mapOfPlanVsMapOfPackageVsProg
     */
     public static Map<Id,Map<Id,List<QuoteLineItem>>> createMapOfPlanvsPackagevsProg (Set<Id> setPlanId){
        Map<Id,Map<Id,List<QuoteLineItem>>> mapOfPlanVsMapOfPackageVsProg = new Map<Id,Map<Id,List<QuoteLineItem>>>();
        Map<Id,List<QuoteLineItem>> mapOfPackageIdvsListofProg ;
        for(QuoteLineItem oQli : [Select Id,ParentQuoteLineItem__c,ParentQuoteLineItem__r.ParentQuoteLineItem__c FROM 
                                    QuoteLineItem WHERE Id IN : setPlanId]){
                mapOfPackageIdvsListofProg= new Map<Id,List<QuoteLineItem>>();
                if(!mapOfPackageIdvsListofProg.containsKey(oQli.ParentQuoteLineItem__c)){
                    mapOfPackageIdvsListofProg.put(oQli.ParentQuoteLineItem__c, new List<QuoteLineItem>{oQli});
                }else{
                    mapOfPackageIdvsListofProg.get(oQli.ParentQuoteLineItem__c).add(oQli);
                }
                mapOfPlanVsMapOfPackageVsProg.put(oQli.ParentQuoteLineItem__r.ParentQuoteLineItem__c,mapOfPackageIdvsListofProg);
        }
        return mapOfPlanVsMapOfPackageVsProg;

     }
    
    /**
     * @description This methood used check AHG Programs.
     * @param setQuoteId Set of Id of Quotes
     * @param mapPlanvsPkgProg Map of plan vs package vs programlist
     */
    public static void checkForAHGPrograms (Set<Id> setQuoteId, Map<Id,Map<Id,List<QuoteLineItem>>> mapPlanvsPkgProg){
        Set< Id > setExistingAHGIds = new Set< Id >();
        Set< Id > setNewAHGIds = new Set< Id >();
        List< QuoteLineItem > listNewAHGIQLI = new List< QuoteLineItem >();
        List< QuoteLineItem > listUpdatedQLIPlan = new List< QuoteLineItem > ();
        
        for (QuoteLineItem eachProgQLI : [Select Id,ProductName__c,LG_Master_AHG__c,QuoteId,
                                          ParentQuoteLineItem__c,ParentQuoteLineItem__r.ParentQuoteLineItem__c 
                                          FROM QuoteLineItem WHERE QuoteId IN :setQuoteId]){
            
            if (eachProgQLI.ProductName__c.contains(staticVariableClass.AHG_PRODUCT_NAME) && eachProgQLI.LG_Master_AHG__c == true ){
                setExistingAHGIds.add(eachProgQLI.Id);
            }
            if (eachProgQLI.ProductName__c.contains(staticVariableClass.AHG_PRODUCT_NAME) && eachProgQLI.LG_Master_AHG__c == false ){
                setNewAHGIds.add(eachProgQLI.Id);  
            }
        }
        if(Schema.sObjectType.QuoteLineItem.isAccessible()){
            if(setNewAHGIds!= null && setNewAHGIds.size()>0){
                listNewAHGIQLI =[Select id,LG_Master_AHG__c,RecordType__c FROM QuoteLineItem WHERE Id IN : setNewAHGIds ORDER BY LastModifiedDate DESC LIMIT 1];}
        }
        //Intial Plans Update
        if(mapPlanvsPkgProg != null ){
            listUpdatedQLIPlan = getUpdatedPlanListToUpdate(mapPlanvsPkgProg);
        }
        //AHG Update Logic 
        if ( setExistingAHGIds.size() == 0 &&  listNewAHGIQLI.size() == 1 ){
            QuoteLineItem oProgQLI = new QuoteLineItem(Id = listNewAHGIQLI[0].Id);
            oProgQLI.LG_Master_AHG__c = True;
            oProgQLI.RecordType__c=staticVariableClass.AHG_RECORDTYPE;
            listUpdatedQLIPlan.add(oProgQLI );
        }
        if (!listUpdatedQLIPlan.isEmpty() && Schema.sObjectType.QuoteLineItem.isUpdateable()){
            update listUpdatedQLIPlan;
        }
    }
    /**
     * @description This Methood is used to get updated Plan List
     * @param mapPlanvsPkgProg map of plan vs map of package vs list of QLI .
     * @return listUpdatedQLIPlan List of QuoteLineItem.
     */
    public static List<QuoteLineItem> getUpdatedPlanListToUpdate(Map<Id,Map<Id,List<QuoteLineItem>>> mapPlanvsPkgProg ){
        List<QuoteLineItem> listUpdatedQLIPlan = new List<QuoteLineItem>();
        Map<Id,List<QuoteLineItem>> mapOfPkgIdvsProg;
        for (QuoteLineItem oQLI :[Select Id , Package_has_been_attached__c,HW_Package_Name__c ,
                                  (select id,ProductName__c from Quote_Line_Items__r) 
                                  FROM QuoteLineItem WHERE Id IN : mapPlanvsPkgProg.keyset()]){
                mapOfPkgIdvsProg = mapPlanvsPkgProg.get(oQLI.Id);           
                for(Id eachId : mapOfPkgIdvsProg.keyset()){
                    if (mapOfPkgIdvsProg.get(eachId)!= null && mapOfPkgIdvsProg.get(eachId).size()>0){
                            oQLI.Package_has_been_attached__c = 'AutoAssociated';
                            oQLI.HW_Package_Name__c= oQLI.Quote_Line_Items__r[0].ProductName__c;   
                    }else{
                            oQLI.Package_has_been_attached__c = staticVariableClass.UpsellNo;
                         }
                    listUpdatedQLIPlan.add(oQLI);
                }
            }
        return listUpdatedQLIPlan;
    }
    /**
     * @description This methood is used to return  a exception record when called.
     * @param excep (Exception)
     * @return exceptionLog  (ExceptionLog__c object)
    */
    public static ExceptionLog__c  createExceptionRecord(Exception excep){
        ExceptionLog__c exceptionLog = new ExceptionLog__c();
        exceptionLog.ExceptionDetails__c = excep.getTypeName()+UTIL_ErrorConstants.COLON+excep.getMessage()+UTIL_ErrorConstants.ENTER+excep.getStackTraceString();
        exceptionLog.OrgId__c = ANA_UTIL03_Constants.ORGID;
        exceptionLog.Application__c = staticVariableClass.COMMERCIAL_SALES_STRING;
        exceptionLog.ContextUser__c = UserInfo.getUserId();
        exceptionLog.Severity__c = staticVariableClass.ERROR ;
        return  exceptionLog ;
    }
}