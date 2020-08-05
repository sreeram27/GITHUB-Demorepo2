trigger QuoteLineItemTrigger on QuoteLineItem (before update) {
   
   if(TriggerRecursionHandler.flag){
    list<id> oppIdsList = new list<id>();
    for(QuoteLineItem qlt:Trigger.new){
        oppIdsList.add(qlt.OpportunityLineItemId);
    }
    list<OpportunityLineItem> OppLineItemsList =[SELECT Id,Quantity, of_Months__c 
                                                 FROM OpportunityLineItem 
                                                 where id in :oppIdsList]; 
    for(QuoteLineItem qlt:Trigger.new){
        for(OpportunityLineItem olt:OppLineItemsList){
            if(olt.id==qlt.OpportunityLineItemId){
               olt.Quantity = qlt.Quantity;
               olt.of_Months__c = qlt.of_Months__c;
               break; 
            }
        }
    }
    TriggerRecursionHandler.flag = false;
    update OppLineItemsList;
   }    
}