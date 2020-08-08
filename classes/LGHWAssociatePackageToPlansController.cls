/*
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * Name              LGHWAssociatePackageToPlansController
 * Author            Deloitte offshore (Gladiators)
 * ModifiedBy        Deloitte offshore (Gladiators)
 * CreatedDate       18th November 2019
 * UsedBy            LG_Attach_H&W_Packages (OS) 
 * User Story        Associate multiple Plans with a new or existing H&W Package
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * @description used by LG_Attach_H&W_Packages Omniscript to attach new or existing package to multiple plans.
 * 
 * Additional information
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * Changes
 * vX.X(Version)            Name
 * Date                     Explanation
 * ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

global without sharing class LGHWAssociatePackageToPlansController implements vlocity_ins.VlocityOpenInterface2
{

    public static Map<Id,String> mapPlanVsPackageName       =   new Map<Id,String>();
        /*
    _________________________________________________________________________________________
    
    *@description: Implementation of invokeMethod from VlocityOpenInterface2 interface.
    _________________________________________________________________________________________
    
    *@param: methodName - hold the name of specified method - String
    *@param: inputMap - Whole JSON from Omniscript - Map<String,Object>
    *@param: outMap - Whole JSON to Omniscript - Map<String,Object>
    *@param: optns - Optional parameter - Map<String,Object>
    _________________________________________________________________________________________
    
    *@return: Boolean
    _________________________________________________________________________________________
    */
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        List<QuoteLineItem> listSelectedPlan = new List<QuoteLineItem>();
        List<Product2> listSelectedChildProd;
        List<Product2> listExistingPkgParent;
        QuoteLineItem oCurrentPlanQli;
        ParamsWrapper oWrap;
        Id commercialFlowTypeParentID;
        String sCommercialFlowType;
        String sIncentiveType = '' ;
        Boolean bReturnValue  = false ;
        try{
            if(methodName.equalsIgnoreCase(staticVariableClass.ASSOCIATE_EXISTING_PKG)){
                listExistingPkgParent = (Product2[])JSON.deserialize(JSON.serialize(((List<Object>)((Map<String, Object>)((Map<String, Object>) 
                                        inputMap.get(staticVariableClass.PRODUCT_SELECTION)).get(staticVariableClass.PARENT_PRODUCT)).get(staticVariableClass.SELECTED_PARENT_PRODUCT))), List<Product2>.class);
                oCurrentPlanQli       = (QuoteLineItem)JSON.deserialize(JSON.serialize(inputMap.get(staticVariableClass.CURRENT_PLAN)), QuoteLineItem.class);   
                for(QuoteLineItem oQli : (QuoteLineItem[])JSON.deserialize(JSON.serialize((List<Object>)inputMap.get(staticVariableClass.PLAN_LIST)), List<QuoteLineItem>.class)){
                    if(oCurrentPlanQli.Id != oQli.Id){
                        listSelectedPlan.add(oQli);
                    }
                }
                sIncentiveType = [SELECT id,Incentive_Type__c FROM QuoteLineItem WHERE product2.Id =: listExistingPkgParent[0].Id AND ParentQuoteLineItem__c = :oCurrentPlanQli.Id].Incentive_Type__c;
               
                listSelectedChildProd = (List<product2>)JSON.deserialize(JSON.serialize(((List<Object>)((Map<String, Object>)((Map<String, Object>) inputMap.get(staticVariableClass.PRODUCT_SELECTION)).
                                                        get(staticVariableClass.CHILD_BUNDLES)).get(staticVariableClass.CHILD_LIST))), List<Product2>.class);
               
                oWrap = new ParamsWrapper(listExistingPkgParent[0].Name == staticVariableClass.COMMERCIAL_BUY_UPS ? staticVariableClass.COMMERCIAL_BUY_UPS : staticVariableClass.COMMERCIAL_CLINICAL,
                                    listExistingPkgParent[0].Id, listSelectedChildProd != null ? listSelectedChildProd : null, listSelectedPlan != null ? listSelectedPlan : null, sIncentiveType);
                
            }else if(methodName.equalsIgnoreCase(staticVariableClass.ASSOCIATE_NEW_PKG)){
                listSelectedPlan = (QuoteLineItem[])JSON.deserialize(JSON.serialize(
                                                    (List<Object>)inputMap.get(staticVariableClass.PLAN_LIST)), List<QuoteLineItem>.class);
                sCommercialFlowType              =   (String)((Map<String, Object>)
                                                        ((Map<String, Object>) inputMap.get(staticVariableClass.PRODUCT_SELECTION)).
                                                                    get(staticVariableClass.COMMERCIAL_SELECTIONS)).get(staticVariableClass.COMMERCIAL_FLOW);
                if( sCommercialFlowType == staticVariableClass.COMMERCIAL_CLINICAL){
                    commercialFlowTypeParentID   = (Id)(((Map<String, Object>) inputMap.get(staticVariableClass.COMMERCIAL_CLINICAL_NODE)).
                                                                    get(staticVariableClass.PARENT_PRODUCT_ID));
                    listSelectedChildProd        = (Product2[])JSON.deserialize(JSON.serialize((List<Object>) 
                                                                    inputMap.get(staticVariableClass.FINAL_PROGRAM_LIST)), List<Product2>.class);
                    sIncentiveType               = (String)((Map<String, Object>) inputMap.get(staticVariableClass.INCENTIVE_TYPE)).
                                                                    get(staticVariableClass.INCENTIVE_TYPE_SELECT);
                 }else if(sCommercialFlowType == staticVariableClass.COMMERCIAL_BUY_UPS){
                    commercialFlowTypeParentID   = ([SELECT Id FROM Product2 WHERE  NALGProdRecordType__c =:staticVariableClass.COMMERCIAL_BUY_UPS 
                                                                                AND ProductActive__c = true LIMIT 1 ].Id);
                    listSelectedChildProd        = (Product2[])JSON.deserialize(JSON.serialize((List<Object>)((Map<String, Object>) inputMap.get(staticVariableClass.COMMERCIAL_BUYUP_SELECTION)).get(staticVariableClass.FINAL_PROGRAM_LIST)), List<Product2>.class);
                 
                 }
              oWrap = new ParamsWrapper(sCommercialFlowType, commercialFlowTypeParentID, listSelectedChildProd, listSelectedPlan,sIncentiveType);
            }
            associatePackageToPlan(JSON.serialize(oWrap));
            bReturnValue = true;
        }catch (Exception oExcn){
            ExceptionLog__c oExceptionlog = LGHWQuoteLineItemActions.createExceptionRecord(oExcn);
            oExceptionlog.ClassName__C    = staticVariableClass.CLASS_LG_ASSOCIATE_PACKAGE_TO_PLAN;
            oExceptionlog.MethodName__c   = staticVariableClass.ASSOCIATE_NEW_PKG;
            oExceptionlog.ApexTrigger__c  = null;
            insert oExceptionlog;
        }
        return bReturnValue;
    }
    /*
    _________________________________________________________________________________________
    
    *@description: Associates a H&W Package with multiple Plans .
    _________________________________________________________________________________________
    
    *@param: String format of ParamsWrapper instance.
    _________________________________________________________________________________________
    
    *@return: void
    _________________________________________________________________________________________
    */
    @future
    global static void associatePackageToPlan(String oWrapperIns){
        
        List<QuoteLineItem> listParentQlisToInsert          =   new List<QuoteLineItem>();
        List<QuoteLineItem> listQlisToInsertWithActiveAhg   =   new List<QuoteLineItem>();
        List<QuoteLineItem> listQlisToUpsertWithActiveAhg   =   new List<QuoteLineItem>();
        List<QuoteLineItem> listTotalQlisToInsert           =   new List<QuoteLineItem>();
        Map<Id, Id> mapPriceBookForProducts                 =   new Map<Id, Id>();
        Map<Id, String> mapProdHpccCode                     =   new Map<Id, String>();
        ParamsWrapper oAhgWrap;
        Savepoint oSavepnt                                  = Database.setSavepoint();
        try{
            ParamsWrapper oWrap                             =   (ParamsWrapper)JSON.deserialize(oWrapperIns, ParamsWrapper.class);
            Map<Id, QuoteLineItem> mapSelectedPlan          =   new Map<Id, QuotelineItem>(oWrap.listSelectedPlan);
            Map<Id, Product2> mapSelectedChildPrograms      =   new Map<Id, Product2>(oWrap.listSelectedChildPrograms);
            
            if(oWrap.listSelectedPlan != null && oWrap.listSelectedPlan.size() > 0){
                listParentQlisToInsert  = createParentQLIs(oWrap);
            }
            if(mapSelectedPlan != null && mapSelectedPlan.size() > 0){
                deleteOldPackage(mapSelectedPlan);
                oAhgWrap = (ParamsWrapper)JSON.deserialize(checkAhgProg(mapSelectedPlan), ParamsWrapper.class);
            }
            if(listParentQlisToInsert != null && listParentQlisToInsert.size() > 0){
                insert listParentQlisToInsert;
            }
            if(listParentQlisToInsert != null && listParentQlisToInsert.size() > 0 && mapSelectedChildPrograms != null && mapSelectedChildPrograms.size() > 0){
                mapPriceBookForProducts =  LGHWQuoteLineItemActions.getPricebookForProduct(mapSelectedChildPrograms.keySet());
                mapProdHpccCode         =  getHpccFromProduct(oWrap);
                for(QuoteLineItem oEachParent : listParentQlisToInsert){
                    for(Product2 oChildPgms   : mapSelectedChildPrograms.values()){
                            QuoteLineItem oChildQli          =   new QuoteLineItem();
                            oChildQli.Product2Id             =   oChildPgms.Id;
                            oChildQli.ParentQuoteLineItem__c =   oEachParent.Id;
                            oChildQli.QuoteId                =   oEachParent.QuoteId;
                            oChildQli.Quantity               =   oEachParent.Quantity;
                            oChildQli.UnitPrice              =   oEachParent.UnitPrice;
                            oChildQli.ProductStage__c        =   oEachParent.ProductStage__c;
                            oChildQli.Subscribers__c         =   oEachParent.Subscribers__c;
                            oChildQli.Members__c             =   oEachParent.Members__c;
                            oChildQli.HPCC_Code__c           =   (oWrap.sCommercialFlowType == staticVariableClass.COMMERCIAL_BUY_UPS) ? '' : (mapProdHpccCode !=null && mapProdHpccCode.size() >0) ? 
                                                                        mapProdHpccCode.get(oWrap.sCommercialFlowTypeParent) : '';
                            oChildQli.RecordType__c          =   oEachParent.RecordType__c;
                            oChildQli.Opptype__c             =   oEachParent.Opptype__c ;
                            oChildQli.Funding__c             =   oEachParent.Funding__c;
                            oChildQli.Financing__c           =   oEachParent.Financing__c;
                            oChildQli.Upsell__c              =   oEachParent.Upsell__c;
                            oChildQli.Reason__c              =   oEachParent.Reason__c;
                            oChildQli.Incentive_Type__c      =   oWrap.sIncentiveType;
                            oChildQli.PricebookEntryId       =   mapPriceBookForProducts.get(oChildPgms.Id);
                            
                           if(oAhgWrap.bContainsActiveAhg && oAhgWrap.bHasAhg){
                               listTotalQlisToInsert.add(oChildQli);
                           }else if(!oAhgWrap.bContainsActiveAhg && oAhgWrap.bHasAhg){
                               listQlisToUpsertWithActiveAhg.add(oChildQli);
                           }else if(oChildPgms.Name != staticVariableClass.AHG_PRODUCT_NAME && !oAhgWrap.bHasAhg){
                                listTotalQlisToInsert.add(oChildQli);
                           }else{
                                listQlisToInsertWithActiveAhg.add(oChildQli);
                           }
                        }//inner for 
                    }//outer for 
                if(listQlisToUpsertWithActiveAhg != null && listQlisToUpsertWithActiveAhg.size() > 0 && oAhgWrap.listAhgProdInOtherPlans != null && oAhgWrap.listAhgProdInOtherPlans.size() >0){
                       oAhgWrap.listAhgProdInOtherPlans[0].RecordType__c    = staticVariableClass.AHG_RECORDTYPE;
                       oAhgWrap.listAhgProdInOtherPlans[0].LG_Master_AHG__c = true;
                       listQlisToUpsertWithActiveAhg.add(oAhgWrap.listAhgProdInOtherPlans[0]);
                       listTotalQlisToInsert.addAll(listQlisToUpsertWithActiveAhg);
                }
                if(listQlisToInsertWithActiveAhg != null && listQlisToInsertWithActiveAhg.size() > 0){
                    listQlisToInsertWithActiveAhg[0].RecordType__c    = staticVariableClass.AHG_RECORDTYPE;
                    listQlisToInsertWithActiveAhg[0].LG_Master_AHG__c = true;
                    listTotalQlisToInsert.addAll(listQlisToInsertWithActiveAhg);
                }
                if(listTotalQlisToInsert != null  && listTotalQlisToInsert.size() > 0){
                    upsert listTotalQlisToInsert;
                }
                if(oWrap.listSelectedPlan != null && oWrap.listSelectedPlan.size() > 0){
                    updateMedicalPlans(oWrap);
                }    
            }
        }catch (Exception oExcn){
                Database.rollback(oSavepnt);
                ExceptionLog__c oExceptionlog = LGHWQuoteLineItemActions.createExceptionRecord(oExcn);
                oExceptionlog.ClassName__C    = staticVariableClass.CLASS_LG_ASSOCIATE_PACKAGE_TO_PLAN;
                oExceptionlog.MethodName__c   = staticVariableClass.ASSOCIATE_NEW_PKG;
                oExceptionlog.ApexTrigger__c  = null;
                insert oExceptionlog;
        }
    }
    /*
    _________________________________________________________________________________________
    
    *@description: Creates parent QLI List for given H&W Parent ID and Plans.
    _________________________________________________________________________________________
    
    *@param: String casted ParamsWrapper Instance
    _________________________________________________________________________________________
    
    *@return: List<QuoteLineItem>
    _________________________________________________________________________________________
    */
    public static List<QuoteLineItem> createParentQLIs( ParamsWrapper oWrap ) {
        List<QuoteLineItem> listPackageQlisToInsert     =   new List<QuoteLineItem>();
        Map<Id, Id> mapPriceBookForProducts             =   new Map<Id, Id>(LGHWQuoteLineItemActions.getPricebookForProduct(new Set<Id>{oWrap.sCommercialFlowTypeParent}));
        Map<Id, String> mapProdHpccCode                 =   new Map<Id, String>(getHpccFromProduct(oWrap));
        Map<Id, Product2> mapProdName                   =   new Map<Id, Product2>(getNameFromProduct(new Set<Id>{oWrap.sCommercialFlowTypeParent}));
        for(QuoteLineItem oEachPlan : oWrap.listSelectedPlan){
            QuoteLineItem oPackageQli             =   new QuoteLineItem();
            oPackageQli.Product2Id                =   oWrap.sCommercialFlowTypeParent;
            oPackageQli.ParentQuoteLineItem__c    =   oEachPlan.Id;
            oPackageQli.QuoteId                   =   oEachPlan.QuoteId;
            oPackageQli.Quantity                  =   oEachPlan.Quantity;
            oPackageQli.UnitPrice                 =   oEachPlan.UnitPrice;
            oPackageQli.ProductStage__c           =   oEachPlan.ProductStage__c;
            oPackageQli.Subscribers__c            =   oEachPlan.Subscribers__c;
            oPackageQli.Members__c                =   oEachPlan.Members__c;
            oPackageQli.HPCC_Code__c              =   (oWrap.sCommercialFlowType == staticVariableClass.COMMERCIAL_BUY_UPS) ? '' : (mapProdHpccCode != null && mapProdHpccCode.size()>0) ? 
                                                                    mapProdHpccCode.get(oWrap.sCommercialFlowTypeParent) : '';
            oPackageQli.RecordType__c             =   oEachPlan.RecordType__c;
            oPackageQli.Opptype__C                =   oEachPlan.OppType__c ;
            oPackageQli.Funding__c                =   oEachPlan.Funding__c;
            oPackageQli.Financing__c              =   oEachPlan.Financing__c;
            oPackageQli.Upsell__c                 =   oEachPlan.Upsell__c;
            oPackageQli.Reason__c                 =   oEachPlan.Reason__c;
            oPackageQli.Incentive_Type__c         =   oWrap.sIncentiveType;
            oPackageQli.PricebookEntryId          =   mapPriceBookForProducts.get(oWrap.sCommercialFlowTypeParent);
            listPackageQlisToInsert.add(oPackageQli);
            mapPlanVsPackageName.put(oEachPlan.Id,(mapProdName !=null && mapProdName.size()>0) ? mapProdName.get(oWrap.sCommercialFlowTypeParent).Name : '');
        }
       return listPackageQlisToInsert;
    }
    
     /*
    _________________________________________________________________________________________
    
    *@description: Get Name of H&W package
    _________________________________________________________________________________________
    
    *@param: prodId - Set of product Ids  Set<Id>
    _________________________________________________________________________________________
    
    *@return: Map<Id,Product2>
    _________________________________________________________________________________________
    */
    private static Map<Id,Product2> getNameFromProduct(Set<Id> prodId){
        if(prodId.size()>0 && prodId!=null){
            return(new Map<Id, product2>([Select id, Name from Product2 where ID IN:prodId]));
        }
        return null;
    }
    /*
   
    /*
    _________________________________________________________________________________________
    
    *@description: Get HPCC code of package
    _________________________________________________________________________________________
    
    *@param: prodId - Set of product Ids  Set<Id>
    _________________________________________________________________________________________
    
    *@return: Map<Id,Product_HPCC_Codes__c>
    _________________________________________________________________________________________
    */
    public static Map<Id, String> getHpccFromProduct( ParamsWrapper oWrap ){
        Map<Id, String> mapprodHpcc  =   new Map<Id, String>();
        for(Product_HPCC_Codes__c oProdHpcc : [Select id, HPCC_CODE__c,Package_Name__c,Parent_Id__c from Product_HPCC_Codes__c 
                                               														where Parent_Id__c =: oWrap.sCommercialFlowTypeParent
                                              														and Incentive_Type__c = : oWrap.sIncentiveType
                                              ]){
            mapprodHpcc.put(oProdHpcc.Parent_Id__c, oProdHpcc.HPCC_CODE__c);
        }
        return mapprodHpcc;
    }
    
    /*
    _________________________________________________________________________________________
    
    *@description: Delete old Package associated with all the plans selected
    _________________________________________________________________________________________
    
    *@param: selectedPlanMap - Set of selected Plan Ids     Map<Id, QuoteLineItem>
    _________________________________________________________________________________________
    
    *@return: void
    _________________________________________________________________________________________
    */
    public static void deleteOldPackage( Map<Id, QuoteLineItem> mapSelectedPlan ){
        Set<QuoteLineItem> listOldQliToDelete   =   new Set<QuoteLineItem>();
              for(QuoteLineItem oQli : [select Id,ParentQuoteLineItem__c from QuoteLineItem where ParentQuoteLineItem__r.ParentQuoteLineItem__c IN : mapSelectedPlan.keySet()]){
                    listOldQliToDelete.add(new QuoteLineItem(Id= oQli.Id));
                    listOldQliToDelete.add(new QuoteLineItem(Id= oQli.ParentQuoteLineItem__c));
            }  
        if(listOldQliToDelete != null && listOldQliToDelete.size() > 0){
          delete new List<QuoteLineItem>(listOldQliToDelete);
        }
    }
     /*
    _________________________________________________________________________________________
    
    *@description: Check if there is any AHG product present in the Quote Level and return a oWrapper 
    _________________________________________________________________________________________
    
    *@param: selectedPlanMap          - Map of selected Plans     Map<Id, QuoteLineItem>
    _________________________________________________________________________________________
    
    *@return: serialized oWrapper - string
    _________________________________________________________________________________________
    */
    public static String checkAhgProg( Map<Id, QuoteLineItem> mapSelectedPlan ){
        
        List<QuoteLineItem> listAhgQli ;
        ParamsWrapper oAhgWrap;
        String sAhgProdName                      = '%' + staticVariableClass.AHG_PRODUCT_NAME + '%';
        Boolean bHasAhg                          = false;
        Boolean bSelectedPlanbContainsActiveAhg  = false;
        
        
              listAhgQli = new List<QuoteLineItem>([Select Id, ProductName__c, RecordType__c, LG_Master_AHG__c, QuoteId, ParentQuoteLineItem__c,
                                                                              ParentQuoteLineItem__r.ParentQuoteLineItem__c FROM QuoteLineItem
                                                                              WHERE QuoteId =:mapSelectedPlan.values()[0].QuoteId 
                                                                              AND ProductName__c LIKE :sAhgProdName]);
              if(listAhgQli != null && listAhgQli.size() > 0){
                    bHasAhg  = true;
                    for(QuoteLineItem oEachQli: listAhgQli){
                        if(oEachQli.LG_Master_AHG__c == true){
                            bSelectedPlanbContainsActiveAhg = true; 
                        }
                    }
              }
           oAhgWrap = new ParamsWrapper( bSelectedPlanbContainsActiveAhg,listAhgQli.size() >0 ? listAhgQli : null, bHasAhg ); 
           return JSON.serialize( oAhgWrap );
     }
     /*
    _________________________________________________________________________________________
    
    *@description: updates Umbrella Plans with HPCC code and Package_has_been_attached__c fields
    _________________________________________________________________________________________
    
    *@param: String casted ParamsWrapper Instance
    _________________________________________________________________________________________
    
    *@return: void
    _________________________________________________________________________________________
    */
     public static void updateMedicalPlans( ParamsWrapper oWrap ) {
        List<QuoteLineItem> listParentQlisToUpdate      =   new List<QuoteLineItem>();
        Map<Id, String> mapProdHpccCode  				=   new Map<Id, String>(getHpccFromProduct(oWrap));
        Map<Id,QuoteLineItem> mapSelectedPlan           =   new Map<Id,QuoteLineItem>(oWrap.listSelectedPlan);
        
       for(QuoteLineItem oEachPlan : oWrap.listSelectedPlan){
            oEachPlan.Package_has_been_attached__c = staticVariableClass.UpsellYes;
            if(oWrap.sCommercialFlowType == staticVariableClass.COMMERCIAL_CLINICAL){
                oEachPlan.HPCC_Code__c       = (mapProdHpccCode !=null && mapProdHpccCode.size()>0) ? mapProdHpccCode.get(oWrap.sCommercialFlowTypeParent) : '';
                oEachPlan.HW_Package_Name__c = (mapPlanVsPackageName !=null && mapPlanVsPackageName.size()>0) ? mapPlanVsPackageName.get(oEachPlan.Id) : '';
            }else{
                oEachPlan.HPCC_Code__c       = '';
                oEachPlan.HW_Package_Name__c = (mapPlanVsPackageName !=null && mapPlanVsPackageName.size()>0) ? mapPlanVsPackageName.get(oEachPlan.Id) : '';
            }
            listParentQlisToUpdate.add(oEachPlan);
        }
        if(listParentQlisToUpdate != null && listParentQlisToUpdate.size() > 0){
            update listParentQlisToUpdate;
        }
   }
   /*
    _________________________________________________________________________________________
    *@name       : ParamsWrapper
    *@description: oWrapper class to hold the params sent to autoAssociation
    _________________________________________________________________________________________
    *@param:  List<Product2> listSelectedChildPrograms;
    *@param:  List<QuoteLineItem> listSelectedPlan;
    *@param:  List<QuoteLineItem> listAhgProdInOtherPlans;
    *@param:  String sIncentiveType;
    *@param:  String sCommercialFlowType;
    *@param:  String commercialFlowTypeParentID;
    *@param:  Boolean bContainsActiveAhg;
    *@param:  Boolean bHasAhg;
    _________________________________________________________________________________________
    
    *@return: null
    _________________________________________________________________________________________
    */
    
   public class ParamsWrapper{
        List<Product2> listSelectedChildPrograms;
        List<QuoteLineItem> listSelectedPlan;
        List<QuoteLineItem> listAhgProdInOtherPlans;
        String sIncentiveType;
        String sCommercialFlowType;
        String sCommercialFlowTypeParent;
        Boolean bContainsActiveAhg;
        Boolean bHasAhg;
        
       public ParamsWrapper(String sCommercialFlowType, String sCommercialFlowTypeParent, List<Product2> listSelectedChildPrograms, List<QuoteLineItem> listSelectedPlan,String sIncentiveType){
            this.sCommercialFlowType                 = sCommercialFlowType;
            this.sCommercialFlowTypeParent           = sCommercialFlowTypeParent;
            this.listSelectedChildPrograms           = new List<Product2>( listSelectedChildPrograms );
            this.listSelectedPlan                    = new List<QuoteLineItem>( listSelectedPlan );
            this.sIncentiveType                      = sIncentiveType;
        }
       public ParamsWrapper(Boolean bContainsActiveAhg, List<QuoteLineItem> listAhgProdInOtherPlans, Boolean bHasAhg){
            this.bContainsActiveAhg                 = bContainsActiveAhg;
            this.listAhgProdInOtherPlans            = new List<QuoteLineItem>(listAhgProdInOtherPlans);
            this.bHasAhg                            = bHasAhg;
        }
    }
}