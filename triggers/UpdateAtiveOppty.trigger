trigger UpdateAtiveOppty on Opportunity (before insert) {  
    Set<Id> AccountidInOpportunity = new Set<Id> ();
  	for(opportunity op:trigger.new){
        op.Active_Oppty__c=true;
        //op.Last_Year_Quantity__c =op.TotalOpportunityQuantity;
      	AccountidInOpportunity.add(op.accountid);
    }
    
    List<Opportunity> optylist=[select id,Active_Oppty__c from opportunity where accountid IN: AccountidInOpportunity and Active_Oppty__c=true];
    List<Opportunity> newupdatelist=new List<Opportunity>();
    for(opportunity op:optylist){
        op.Active_Oppty__c=false;
        newupdatelist.add(op);
    }            
    update newupdatelist;
}