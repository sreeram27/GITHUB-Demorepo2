public class Renewal_Page {
    Public Opportunity opp{set;get;}
    public String currentRecordId {get;set;}
    public List<Opportunity> opps { get; set; }
    
    list<OpportunityLineItem> oppLineItemsNewList = new list<OpportunityLineItem>();
    
    Public Renewal_Page(ApexPages.StandardController controller){
        opp=new opportunity();
        /*list<OpportunityLineItem> oppLineItems = [Select id,name from OpportunityLineItem where Opportunity.Id = :opp.Opportunity__c];
for(OpportunityLineItem oppLine : oppLineItems){
OpportunityLineItem LineItem = oppLine.clone();
oppLineItemsNewList.add(LineItem);
}*/
    }
    public PageReference  getDetails(){
        
        opportunity opportunity = new opportunity();
        
        if(opp.Opportunity__c != null)
        {
            ID recordId = opp.Opportunity__c;   
            DescribeSObjectResult describeResult = recordId.getSObjectType().getDescribe(); 
            
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );  
            
            String query =    ' SELECT ' +        String.join( fieldNames, ',' ) +    ' FROM ' +
                describeResult.getName() +    ' WHERE ' +         ' id = :recordId ' +    ' LIMIT 1 '   ;   
            
            // return generic list of sobjects or typecast to expected type
            List<SObject> records = Database.query( query );
            
            if(records.size() == 0)
            {
                return null;
            }
            opportunity = (opportunity)records[0].clone();
            opportunity.Name = opportunity.Name +' '+ 'Upsell';
            opportunity.StageName = 'Proposal';
            opportunity.Opportunity_Type_New_Renewal_Upsell__c = 'Upsell';
            insert opportunity;
            
            list<OpportunityLineItem> oppLineItems = [Select id,name,Quantity,UnitPrice,ProductCode,Product2Id,ListPrice,Discount,ServiceDate,
                                                      Subtotal,Description
                                                      from OpportunityLineItem where Opportunity.Id = :opp.Opportunity__c];
            for(OpportunityLineItem oppLine : oppLineItems){
                OpportunityLineItem LineItem = oppLine.clone();
                LineItem.OpportunityId = opportunity.Id;
                oppLineItemsNewList.add(LineItem);
            }
            insert oppLineItemsNewList;
            
            
            
            PageReference page = new pagereference('/'+opportunity.id + '/e?retURL=%2F' +opportunity.id );
            page.setRedirect(true);
            return page; 
        }
        
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select Opportunity'));
        return null;
    } 
    
}