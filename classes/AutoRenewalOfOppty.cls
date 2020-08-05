global class AutoRenewalOfOppty implements Database.Batchable<SObject>, Database.Stateful{
    
    String query = 'select id,Name,Renewal_Date_Cntrct_End_Date_90_Days__c,OwnerId,Contract_Start_Date__c,Contract_End_Date__c,CloseDate,AccountId,StageName,(select id,Name,pricebookEntryId,Product2.Id,Product2.IsActive,Quantity,UnitPrice,OpportunityId from OpportunityLineItems) from opportunity WHERE Renewal_Date_Cntrct_End_Date_90_Days__c = Today AND (StageName = \'Closed Won\' OR StageName = \'Closed Won - Implementation Incomplete\' ) '; 
    List<OpportunityLineitem> newopplines = new List<OpportunityLineitem>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {      
       system.debug('Test:'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> scope)
    {
        // process each batch of records
        set<id> productids = new set<id>();
        //Hold All Opportunity Lineitems
        List<OpportunityLineItem> OppoLines =new List<OpportunityLineItem>();
        Map<id,Opportunity> oppsmap = new Map<id,Opportunity>();
        
        for(Opportunity O: Scope)
        {
            	Integer Year = Date.Today().Year();
               
            	//Create New Renewal Opportunity 
                Opportunity OpportunityRenewal = New opportunity (Name = o.Name + ' Renewal' + '-' + Year,StageName = 'Proposal', OwnerId = o.OwnerId,CloseDate = o.CloseDate + 364, Contract_End_Date__c= o.Contract_End_Date__c + 364, Contract_Start_Date__c = o.Contract_Start_Date__c + 364,AccountId = o.AccountId, Opportunity_Type_New_Renewal_Upsell__c = 'Renewal',Parent_Opportunity__c = o.Id  );
               /* OpportunityRenewal.Name = o.Name + ' Renewal' + '-' + Year;
                OpportunityRenewal.StageName = 'Proposal';
                OpportunityRenewal.CloseDate = o.CloseDate + 364;
                OpportunityRenewal.AccountId = o.AccountId;
            	OpportunityRenewal.Opportunity_Type_New_Renewal_Upsell__c = 'Renewal';
                OpportunityRenewal.Parent_Opportunity__c = o.Id;*/
                oppsmap.put(o.id,OpportunityRenewal);
                OppoLines.addAll(o.OpportunityLineItems);
        }
        try{
            System.debug(''+oppsmap.Values());
            //Insert Old Opportunity
            insert oppsmap.Values(); 
            for(OpportunityLineitem OL:OppoLines)
            {
                if(OL.Product2.IsActive != False){
                    OpportunityLineitem o =new OpportunityLineitem(OpportunityId =oppsmap.get(OL.OpportunityId).id,UnitPrice=OL.UnitPrice,Quantity=OL.Quantity,PricebookEntryId =OL.PricebookEntryId );
                    newopplines.add(o);
                }
            }
            Insert newopplines;
            system.debug('newopplines::'+newopplines);
        }
        catch(Exception e){
            System.debug(''+e);
        }
        Map<id,id> Pricebookids = new Map<id,id>();
        for(PricebookEntry pe : [SELECT Id, Product2Id FROM PricebookEntry WHERE Product2Id IN : productids])
        {
            Pricebookids.put(pe.Product2Id,pe.id);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('list to be deleted size  :: '+newopplines.size());
        if(!newopplines.isEmpty())
        {
          
        }
    }
}