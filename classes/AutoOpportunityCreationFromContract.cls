global class AutoOpportunityCreationFromContract implements Database.Batchable<Sobject>,Database.stateful,schedulable {
    
    global Date Dateafter90days = System.today() + 90;
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new AutoOpportunityCreationFromContract()); 
    } 
    
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        
        return Database.getQueryLocator('Select id,Contract_End_Date__c,Contract_Start_date_Custom_Field__c,Opportunity__c from contract where contract_End_Date__c=: Dateafter90days And contract_End_Date__c != null');
    }
    
    global void execute(Database.BatchableContext bc, List<Contract> scope){
        
        Map<id,Contract> OppMap = new Map<id,Contract>();
        set<id> productids = new set<id>();
        List<Opportunity> oppListToBeRenewed  = new List<Opportunity>();
        List<OpportunityLineItem> OppoLines =new List<OpportunityLineItem>();
        Map<id,Opportunity> oppsmap = new Map<id,Opportunity>();
        List<OpportunityLineitem> newopplines = new List<OpportunityLineitem>();
        
        
        Integer Year = Date.Today().Year();
        
        if(scope.size() > 0 ){
            for(Contract cntrctInfo : Scope){
                OppMap.Put(cntrctInfo.Opportunity__c,cntrctInfo);
            }
            
            oppListToBeRenewed = [select id,Name,Renewal_Date_Cntrct_End_Date_90_Days__c,OwnerId,Contract_Start_Date__c,Contract_End_Date__c,CloseDate,AccountId,StageName,(select id,Name,pricebookEntryId,Product2.Id,Product2.IsActive,Quantity,UnitPrice,OpportunityId from OpportunityLineItems) from opportunity where id IN:OppMap.keySet()];
            
            for(Opportunity O: oppListToBeRenewed){
                
                Opportunity OpportunityRenewal = New opportunity (ownerid =System.label.Automatic_Opportunity_Owner_id,contract_Type__c = 'Co-Term Contract',Name = o.Name + ' Renewal' + '-' + Year,StageName = 'Proposal',CloseDate = o.CloseDate + 364, Contract_End_Date__c= oppMap.get(o.id).contract_End_Date__c + 364, Contract_Start_Date__c =oppMap.get(o.id).Contract_Start_date_Custom_Field__c + 364,AccountId = o.AccountId, Opportunity_Type_New_Renewal_Upsell__c = 'Renewal',Parent_Opportunity__c = o.Id  );
                
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
       
            
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}