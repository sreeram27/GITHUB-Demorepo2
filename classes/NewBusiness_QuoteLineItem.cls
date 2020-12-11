/*
@Author : Karthik Keshavan
@name : NewBusiness_QuoteLineItem
@CreatedDate : 11/21/2019 
@Description : This class is the handler for the ANA_QuoteLineItemsAfterCreate trigger for the QLI insert and update conditions  
*/
public with sharing class NewBusiness_QuoteLineItem {
    /*
	@method Name : updateQuote
	@param : the list of Quote Line Items in trigger.new
	@return type : void
	@method Description : This method sets the Is_New_Business__c field on the Quote Line Item.   
	@last Modified Date: 12/04/19
	*/
    public static void updateQuote(list<QuoteLineItem> qliList){
        set<Id> quoteIds = new set<Id>();
        list<Quote> quoteListToBeUpdate = new list<Quote>();
        for(QuoteLineItem qli : qliList){
    			boolean isNewBusiness = false;
            if (qli.IsArea3__c && !qli.Is_New_Business__c ) {
                isNewBusiness = true;
            }
            if (qli.IsArea3__c && !qli.Is_New_Business__c && qli.Is_Existing_Product__c ){
                isNewBusiness = false;
            }
            if (qli.IsArea3__c  && !qli.Is_Existing_Product__c){
                isNewBusiness = true;
            }
            if (qli.Is_Existing_Product__c ){
                isNewBusiness = false;
            }             
            qli.Is_New_Business__c = isNewBusiness;
        }
    }
}