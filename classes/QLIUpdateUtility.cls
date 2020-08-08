/**
* Utility class to insert the QLI records
* */
public without sharing class QLIUpdateUtility {
    
    static final String CATEGORY_TYPE = 'Product';
    
    /**
    * This method creates new quote line item record based on QLIId and deactivates
    * old record and returns the status.
    * */
    public QLIUpdateStatus updateQLIProduct(String QLIId, String contractCode) {
        QLIUpdateStatus status = new QLIUpdateStatus();
        System.Savepoint sp = Database.setSavepoint();
        try{
            
            if(QLIId!= null) {
                //get product based on contract id from Product2 object
                List<Product2> prodConRec = [Select id,Contract_code__c,name,vlocity_ins__ProductSpecId__c from Product2 
                                             where Contract_code__c=:contractCode and ProductActive__c=true and isActive = true order by vlocity_ins__EffectiveDate__c desc  LIMIT 1] ;
                system.debug('prodConRec>>:' + prodConRec);
                if(prodConRec.size()== 0 || prodConRec== null) {
                    status.StatusCode = 'Error';
                    status.StatusMessage= 'No active product found with contract code :' + contractCode;
                    return status;
                }
                Integer qliCount = [select count() from quotelineitem where id = :QLIId];
                if (qliCount ==0){
                    status.StatusCode = 'Error';
                    status.StatusMessage= 'No QuotelineItem record found with QLI Id :' + QLIId;
                    return status;
                }
                // Get the QLI record based on QLIId
                String QLIquery = getQLIFeildsToClone( QLIId,'QuoteLineItem');
                System.debug('QLI Id :' +QLIID);
                System.debug('QLI Query :' +QLIQuery);
                QuoteLineItem qliRec = (QuoteLineItem)Database.query(QLIquery);
                
                system.debug('qliRec parent:' + qliRec.ParentQuoteLineItem__c);
                // Check if QLI is parent QLI and has child QLIs associated to this QLI
                
                Integer childRecCounts = [Select count() from QuoteLineItem where ParentQuoteLineItem__c =:QLIId and 
                                         	product2.product_type__c = 'Medical'] ;
                if(childRecCounts > 0){
                    status.StatusCode = 'Error';
                    status.StatusMessage= 'Child record exists for given QLI Id :' + QLIId;
                    return status;
                    
                }
                if(qliRec.product2id ==prodConRec[0].id) {
                    status.StatusCode = 'Error';
                    status.StatusMessage= 'Quote Line record is already linked to contract code';
                    return status;                    
                }
                system.debug('qliRec****:' + qliRec);
                QuoteLineItem qliNewParent;
                QuoteLineItem qliCurrParentRec;
                List<QuoteLineItem> newProdParentList;
                //Find if a parent QLI for current quote record exist with productid 
               if(prodConRec[0].vlocity_ins__ProductSpecId__c!=null && 
                   qliRec.ParentQuoteLineItem__r.Product2.id!=prodConRec[0].vlocity_ins__ProductSpecId__c ){
                       newProdParentList = [SELECT id FROM QuoteLineItem 
                                            WHERE ProductCategory__c =: CATEGORY_TYPE 
                                            AND product2.id =: prodConRec[0].vlocity_ins__ProductSpecId__c 
                                            AND quoteId =: qliRec.quoteId LIMIT 2];
                       //Use this QLI as parent for new child qli else create new parent  
                       if(newProdParentList!= null && newProdParentList.size()==1){
                           qliNewParent = newProdParentList[0];
                       }else {
                           //Create new parent record with new parent product id which is identified based contract id 
                           if(qliRec.ParentQuoteLineItem__c!=null){
                               QLIquery = getQLIFeildsToClone( qliRec.ParentQuoteLineItem__c,'QuoteLineItem');
                               qliCurrParentRec = (QuoteLineItem)Database.query(QLIquery);
                               qliNewParent = qliCurrParentRec.clone(false, true);
                               
                           }else {
                               qliNewParent = qliRec.clone(false, true);
                           }
                           //get the price book entry id and set as product id
                           List<PricebookEntry> priceBookEntryforParent = [select id from PricebookEntry where Product2Id=:prodConRec[0].vlocity_ins__ProductSpecId__c];
                           qliNewParent.PricebookEntryId = priceBookEntryforParent[0].id;
                           qliNewParent.Product2Id=prodConRec[0].vlocity_ins__ProductSpecId__c;
                           //qliNewParent.Contract_Code__c = null;
                           qliNewParent.vlocity_ins__ContractCode__c = null;
                           qliNewParent.ParentQuoteLineItem__c = null;
                           system.debug('priceBookEntryforParent**********:' + priceBookEntryforParent);
                           insert qliNewParent;
                       }
                   } 
                
                system.debug('qliParent*********:' + qliNewParent);
                // Create QLI record and set the new product code and parent product id, if applicable
                QuoteLineItem qliReqClone = qliRec.clone(false, true);
                system.debug('qliReqClone*******Cloned rec:' + qliReqClone);
                //qliReqClone.SFDCLegacyID__c = null;
                //qliReqClone.ParentQuoteLineItem__c = null;
                //get price book entry for child prod/plan
                List<PricebookEntry> priceBookEntryforChild = [select id from PricebookEntry where 
                                                               Product2Id=: prodConRec[0].id];
                system.debug('qliReqClone*******priceBookEntryforChild[0].id:' + priceBookEntryforChild[0].id);
                qliReqClone.PricebookEntryId = priceBookEntryforChild[0].id;
                
                qliReqClone.Product2Id= prodConRec[0].id;
                if(qliNewParent!=null){
                    qliReqClone.ParentQuoteLineItem__c = qliNewParent.Id;
                }
                //create child QLI record
                insert qliReqClone;
                system.debug('qliReqClone************:' + qliReqClone);
             	//Get object and field name from custom settings and hook newly created QLI id for the obejcts
             	//added to custom settings
                for(QLI_Child_Objects__c currentObj : QLI_Child_Objects__c.getAll().values()){
                   updateQLILookUpForRelatedObjects(qliRec.id,qliReqClone.id,currentObj.Object_Name__c,currentObj.Field_Name__c);
                }
                  updateChildQLIs (QLIId,qliReqClone.id);
                //ID oldParentRecId = qliRec.ParentQuoteLineItem__c;
                if(qliRec!= null ){
                    delete qliRec;
                } 
                // Check if old parent record have any children. If old parent record does not have any children then delete old parent record
               if(qliCurrParentRec!= null){
                    Integer childCounts = [Select count() from QuoteLineItem where ParentQuoteLineItem__c =:qliCurrParentRec.Id] ;
                    if(childCounts== 0){
                        delete  qliCurrParentRec;
                    }
                }
                status.StatusCode='SUCCESS';
                status.StatusMessage='Record processed successfully. New QLI id is created– '+qliReqClone.Id+' of from parent QLI -('+qliRec.id+') record created';
            }            
        }catch(Exception ex){
            status.StatusCode='ERROR';
            status.StatusMessage='Error occured while creating QLI record: '+ ex.getMessage();
            Database.rollback(sp);
        }
        System.debug('status===>' + status);
        return status;
    }
    
    /**
    * Update New QLI id for related obejcts
    * **/
    public void updateQLILookUpForRelatedObjects(String qliIdOld, String qliIdNew,String objName,String fldName){
      
        String strQuery = 'SELECT Id, '+fldName+' FROM '+objName+' WHERE '+fldName+'=\''+qliIdOld+'\' LIMIT 5000';
        List<SObject> objList = Database.query(strQuery);
        system.debug('*********objList' + objList);
        if(objList!= null || objList.size()>0){
            for(SObject currProdSelection : objList){
                //currProdSelection.QuoteLineItem__c = qliIdNew;
                 currProdSelection.put(fldName,qliIdNew);
            }
        }
        if(objList.size()>0){
            update objList;
        }
    }
    
    /**
    * This method returns all active fields for given object.
    * **/
    public String getQLIFeildsToClone(String QLIId, String QuoteLineItem){
        String QLIFiles = '';
        
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(QuoteLineItem.toLowerCase()).getDescribe().Fields.getMap();
        List<string> fieldsList = new list<string>();
        
        if (fieldMap != null){
            for (Schema.SObjectField fld : fieldMap.values()){ 
                Schema.DescribeFieldResult fldname = fld.getDescribe(); 
                if (fldname.isCreateable()){ 
                    fieldsList.add(fldname.getName());
                }
            }
        }
        if (!fieldsList.isEmpty()){
            for (String st:fieldsList){
                QLIFiles += st + ',';
            }
            QLIFiles +='ParentQuoteLineItem__r.Product2.id';
            if (QLIFiles.endsWith(',')){
                QLIFiles = QLIFiles.substring(0,QLIFiles.lastIndexOf(','));
            }
        }
        return 'select ' + QLIFiles +' from ' + QuoteLineItem + ' where Id=\''+QLIId+ '\'';
    }
    
    //This class is to set the status and status message.
    public class QLIUpdateStatus {
        public String StatusCode{ get; set; }
        public String StatusMessage { get; set; } 
    }
    
     /**
      * This methods is to check the if the old QLI is parent for any and link the newly
      * created QLI id
      * */
     public void updateChildQLIs(Id oldQLIId,Id newQLIId){
        List<QuoteLineItem> parentQliList = [SELECT id FROM QuoteLineItem
                                             WHERE ParentQuoteLineItem__c =:oldQLIId] ;
        if(parentQliList!= null && parentQliList.size()>0){
            for(QuoteLineItem currentQLI:parentQliList){
                currentQLI.ParentQuoteLineItem__c= newQLIId;
            }
            system.debug('Updating H&W Parent***************' + parentQliList);
            if(parentQliList.size()>0){
                update parentQliList;
            }
        }
    }
}