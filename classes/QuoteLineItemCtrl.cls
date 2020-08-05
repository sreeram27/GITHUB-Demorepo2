public class QuoteLineItemCtrl {
    public id qId{get;set;}
    public list<QuoteLineItem> quoteItemList{get;set;}
    public QuoteLineItemCtrl(){}
    public list<QuoteLineItem> getQuoteItemsList(){
       quoteItemList= new list<QuoteLineItem>();
       quoteItemList=[SELECT Id, Product2.Name,Product2.CreatedDate, 
                       ListPrice, UnitPrice,Total_Amount__c,of_Months__c,
                       Quantity, Discount_Given__c, 
                       Total_List_Price__c, QuoteId,createddate 
                       FROM QuoteLineItem 
                       where QuoteId=:qId];
       system.debug('---------------------------------------------------------------------'+[SELECT Id, Product2.Name, 
                       ListPrice, UnitPrice, 
                       Quantity, Discount_Given__c, of_Months__c,
                       Total_List_Price__c, QuoteId 
                       FROM QuoteLineItem 
                       where QuoteId=:qId]);                
       return quoteItemList;                
    }
}