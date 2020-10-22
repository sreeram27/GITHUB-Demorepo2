//Class Name : LGOrderImpactedProducts_Ctrl
//Where it is Used : LGOrderImpactedProducts_App,Vlocity Action (Impacted Product)
//Description : Used to populate Impacted_Products__c , Impacted_Products_Id__c and Impacted_Product_Types__c fields of Order

/**
 * @description LGOrderImpactedProducts_Ctrl
 */
public class LGOrderImpactedProducts_Ctrl
{
    
    //Init method to load QLIs 
    //params:
    //ordId : OrderId
    //quoteId : QuoteId of the Order
    /**
    * @description getQliOfCase
    * @param ordId
    * @param quoteId
    * @return dwrap
    */
    @AuraEnabled
    public static DataWrapper getQliOfCase(String ordId ,String quoteId){
        List<String> impacQliList = new List<String>();
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        List<Order> orderRecord;
        
        if(ordId != null)
        {
            //Domain URL for Page Redirect to Implementation Case
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ordId;
            orderRecord = new List<Order>([select id ,Impacted_Products__c,Impacted_Products_Id__c from Order where Id=:ordId]);
            System.debug('orderRecord'+orderRecord);
            if(orderRecord.size()>0)
            {
                System.debug('orderRecord[0].Impacted_Products_Id__c'+orderRecord[0].Impacted_Products_Id__c);
                if(orderRecord[0].Impacted_Products_Id__c !=null && orderRecord[0].Impacted_Products_Id__c.length() >0)
                {
                    impacQliList.addAll(orderRecord[0].Impacted_Products_Id__c.split(','));  
                }
            }
            if(quoteId!=null)
            {
                
               for(QuoteLineItem qli : [SELECT ProductStage__c,Id,Product2.Name,OppType__c,Product_Type__c,SFDCLegacyID__c 
                                         FROM QuoteLineItem WHERE QuoteId =:quoteId 
                                         AND
                                         (
                                             (ProductCategory__c ='Product' AND ParentQuoteLineItem__c = null and Product_Type__c != 'Medical') 
                                             OR 
                                             (ProductCategory__c='Plan' AND ParentQuoteLineItem__c != null AND Product_Type__c = 'Medical')
                                             OR
                                             (ProductCategory__c ='Product' AND ParentQuoteLineItem__c = null AND Product_Type__c = 'Medical' AND Product_SFDC_Legacy_ID__c != null) 
                                         )])
                {
                     qliList.add(qli);
                    }
                System.debug('qliList'+qliList);
                //Wrapper with FullRecordUrl, List with Impacted Qli Ids,QLI records of the Quote under given Order
                
                DataWrapper dwrap = new DataWrapper(
                    fullRecordURL,
                    qliList.size()>0 && qliList !=null  ? qliList : null,
                    impacQliList.size()>0 && impacQliList !=null ? impacQliList : null
                );
                System.debug('dwrap'+dwrap);
                return dwrap;
            }            
        }
        return null; 
    }
    
    //Impacted_Products_Id__c , Impacted_Products__c, 	Impacted_Product_Types__c fields of Order
    //QLI Ids that got Impacted
    //ordId = order Id
    /** 
     * @description updateQli
     * @param qliIdsList
     * @param ordId
     */
    @AuraEnabled
    public static void updateQli(List<String> qliIdsList,String ordId){
        List<Order> orderToBeUpdated = new List<Order>(); 
        Set<String> productTypeSet = new Set<String>();
        if(!qliIdsList.isEmpty() && qliIdsList !=null)
        {
            String prodId ='';
            String prodName='';
            String prodType = '';
            for(QuoteLineItem qli : [SELECT id,Product2.Name,Product2.Product_Type__c, QuoteId from QuoteLineItem where Id IN : qliIdsList]){
                prodName = prodName + qli.Product2.Name +','+'\n' ;
                prodId = prodId + qli.Id  +',' ;
                productTypeSet.add(qli.Product2.Product_Type__c);
            }
            prodId = prodId.removeEnd(',');
            prodName = prodName.removeEnd('\n');
            prodName = prodName.removeEnd(',');
            prodType = String.join(new List<String>(productTypeSet), ',');
            orderToBeUpdated.add(new Order(id=ordId,Impacted_Products_Id__c =prodId,Impacted_Products__c = prodName,Impacted_Product_Types__c = prodType)); 
        }
        else{
            String prodId ='';
            String prodName='';
            String prodType = '';
            orderToBeUpdated.add(new Order(id=ordId,Impacted_Products_Id__c =prodId,Impacted_Products__c = prodName,Impacted_Product_Types__c = prodType)); 
        }
        if(Schema.sObjectType.Order.isUpdateable() && !orderToBeUpdated.isEmpty() && orderToBeUpdated!=null){
            update orderToBeUpdated;
        }
    }
    
    
    public class DataWrapper{
        @AuraEnabled
        public List<QuoteLineItem> data;
        
        @AuraEnabled
        public String fullRecordURL;
        
        @AuraEnabled
        public List<String> qliId;
        
        DataWrapper(String fullRecordURL,List<QuoteLineItem> data,List<String> qliId){
            this.fullRecordURL = fullRecordURL;
            this.data = data;
            this.qliId = new List<String>(qliId);
        }
    }
}