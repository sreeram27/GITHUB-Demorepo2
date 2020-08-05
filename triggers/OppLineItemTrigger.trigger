trigger OppLineItemTrigger on OpportunityLineItem (before update) {
   if(TriggerRecursionHandler.flag){
    list<QuoteLineItem> QuoteLineItemsList = [SELECT Id, OpportunityLineItemId, 
                                              Quantity, of_Months__c 
                                              FROM QuoteLineItem 
                                              where OpportunityLineItemId in :Trigger.new];
    for(OpportunityLineItem olt:Trigger.new){
        for(QuoteLineItem qlt:QuoteLineItemsList){
            if(qlt.OpportunityLineItemId==olt.id){
                qlt.of_Months__c = olt.of_Months__c;
                qlt.Quantity = olt.Quantity;
                break;
            }
        }    
    }
    TriggerRecursionHandler.flag=false;
    update QuoteLineItemsList;
   }
}