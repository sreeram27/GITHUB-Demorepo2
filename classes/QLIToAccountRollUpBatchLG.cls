/**************************************************************************************
Class Name:   
Version     : 1.0 
Created Date    : 5 June 2019
@Author: Partha Baruah ,Legato 
@UStory: PRDCRM-35604    
Function    : Batch to update account from QLI records (Rollup the funding type to account)
Modified by Sharath KN : PRDCRM - 41143 : 27/11/2019
*************************************************************************************/

Global class QLIToAccountRollUpBatchLG implements Database.Batchable<sObject>,Database.Stateful {
    
    
    global AccountRoles__c roles = AccountRoles__c.getValues('QLIToAccountRollUpBatchLG'); //Custom setting to store the last run datetime
    DateTime lastRun = roles.LastRun__c; // Holds the date when this batch was run last time   
    DateTime jobStartTime = DateTime.now(); 
    LG_Op_Helper__mdt m=[select LG_Field_Value__c from LG_Op_Helper__mdt where DeveloperName='Opp_LG_Record_Types']; // Contains list of relevant opp R/C types: New Business Local;Renewal Local;In Group Add Product Local;In Group Change Local
    
    List<String> OppRecordTypeList=m.LG_Field_Value__c.split(';'); 
    
    list <RecordType> recordtypeIdList= [Select Id From RecordType where sobjecttype = 'Opportunity' and name in:OppRecordTypeList];         
    global String Query = 'Select Id,Funding__c,ProductStage__c, QuoteID,Quote.Opportunity.Accountid,Quote.Opportunityid from QuoteLineItem where ProductLOB__c=\'Medical\' AND lastmodifieddate >: lastRun AND Quote.Opportunity.recordType.id in:recordtypeIdList ORDER BY Quote.Opportunityid ALL ROWS';
    
    
    /**
    * Start method : Queries on the list of QLIs of Medical Line of Biz (LOB) for certain LG opty recordTypes                   * 
    * @Date:   5 June 2019
    * @Author: Partha Baruah
    
    */ 
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(Query);
    }
    
    /**
    //Execute Method : update 'account medical funding type' field on accounts  related to recently modified QLIs of latest opportunities on the account *
    
    */ 
    global void execute(Database.BatchableContext bc, List<QuoteLineItem> scope){
        
        Set<Id> accIdSet = new Set<Id>();
        Map<id, List<QuoteLineItem>> mapAccIdQLIs =new map<id,List<QuoteLineItem>>();
        Map<id, List<QuoteLineItem>> mapAccIdQLIsDel =new map<id,List<QuoteLineItem>>(); // to store only ac id and qlis deleted 
        
        for (QuoteLineItem qli : scope) {
            accIdSet.add(qli.Quote.Opportunity.Accountid); 
        }
        
        map<id,id> mapAccIdLatestOppId = new map<id,id>(); // map of all account ids and ALL latest opportunities(even if the opty is not grand parent to the QLIs modified
        set<id>LatestGPOppIds=new set <id>();  // to store only latest opportunities that are Grand Parent(GP) to the current QLIs modified
        LG_Op_Helper__mdt mdt1= [select LG_Field_Value__c from LG_Op_Helper__mdt where DeveloperName='QLIToAccountBatchInnerQuery'];
        List<String> stagesList=mdt1.LG_Field_Value__c.split(';');
        for(Account ac: [select id ,(select id from opportunities WHERE StageName IN: stagesList order by CloseDate DESC limit 1) from account where id in :accIdSet])
        {
            if(!ac.opportunities.isEmpty())
                mapAccIdLatestOppId.put(ac.id, ac.opportunities[0].id);                
        }
        system.debug('latestAccidOppId'+mapAccIdLatestOppId);
        
        
        for (QuoteLineItem qli : scope) {
            if (qli.Quote.Opportunityid==mapAccIdLatestOppId.get(qli.Quote.Opportunity.Accountid)) {                        
                LatestGPOppIds.add(qli.Quote.Opportunityid);
            }           
        }   
        
        
        list <QuoteLineItem> qliList = [select Id,Funding__c,ProductStage__c, IsDeleted, Quote.Opportunity.Accountid,Quote.Opportunityid from QuoteLineItem where Quote.Opportunityid in:LatestGPOppIds AND ProductLOB__c='Medical' ALL ROWS]; // To store QLIs from the latest (based on close date/effective date)opportunities only
        
        
        for(QuoteLineItem qli :qliList){
            
            if(qli.isDeleted==false){
                if(!mapAccIdQLIs.containsKey(qli.Quote.Opportunity.Accountid)){                             
                    mapAccIdQLIs.put(qli.Quote.Opportunity.Accountid, new List<QuoteLineItem>{qli} );   
                }
                else {
                    mapAccIdQLIs.get(qli.Quote.Opportunity.Accountid).add(qli);
                }
            }
            
            else{
                if(!mapAccIdQLIsDel.containsKey(qli.Quote.Opportunity.Accountid)){                             
                    mapAccIdQLIsDel.put(qli.Quote.Opportunity.Accountid, new List<QuoteLineItem>{qli} );   
                }
                else {
                    mapAccIdQLIsDel.get(qli.Quote.Opportunity.Accountid).add(qli);
                }
            } 
        }
        
        
        system.debug('mapAccIdQLIs****'+mapAccIdQLIs); 
        system.debug('mapAccIdQLIsDel***'+mapAccIdQLIsDel);
        List<Account> accList= new List<Account>();
        List<Account> accListDel= new List<Account>();
        
        if(!mapAccIdQLIs.isEmpty()){
            accList=[select id,Account_Medical_Funding_Type__c from account where id in :mapAccIdQLIs.keyset() ];  
        }
        if(!mapAccIdQLIsDel.isEmpty()){
            accListDel=[select id,Account_Medical_Funding_Type__c from account where id in :mapAccIdQLIsDel.keyset() AND Id NOT in:mapAccIdQLIs.keyset()]; 
        }
        
        LG_Op_Helper__mdt mdtSold= [select LG_Field_Value__c from LG_Op_Helper__mdt where DeveloperName='Product_Stages_Sold'];
        LG_Op_Helper__mdt mdtInProg= [select LG_Field_Value__c from LG_Op_Helper__mdt where DeveloperName='Product_Stages_In_Progress'];
        LG_Op_Helper__mdt mdtLost=[select LG_Field_Value__c from LG_Op_Helper__mdt where DeveloperName='Product_Stages_Lost'];
        
        List<String> ProdSoldStagesList=mdtSold.LG_Field_Value__c.split(';');   
        List<String> ProdInProgStagesList=mdtInProg.LG_Field_Value__c.split(';');   
        List<String> ProdLostStagesList=mdtLost.LG_Field_Value__c.split(';');   
        
        //system.debug('Sold Stages'+ProdSoldStagesList);
        
        set<string> fundingTypeSetSold= new set <string>();  // Set that contains Funding Type for Sold Products
        set<string> fundingTypeSetInProg= new set <string> (); // Set that contains Funding Type for IN Progress Products
        set<string> fundingTypeSetLost= new set <string>(); // Set that contains Funding Type for Lost Products
        boolean allNAs;
        
        
        for ( Account acc : accList) {
            
            allNAs = true;
            fundingTypeSetSold.clear();
            fundingTypeSetInProg.clear();
            fundingTypeSetLost.clear(); 
            if(mapAccIdQLIs.get(acc.Id).size()>0){                        
                for(QuoteLineItem qli:mapAccIdQLIs.get(acc.Id)){
                    if (qli.Funding__c != 'N/A'){
                        allNAs = false; 
                    }  
                    
                    if( ProdSoldStagesList.contains(qli.ProductStage__c) )  // checks if qli.ProductStage__c=='Sold'OR 'IGAP Sold' OR 'Renewed'OR 'Not renewing in Current Period'                    
                    {
                        fundingTypeSetSold.add(qli.Funding__c);
                    }
                    else if(ProdInProgStagesList.contains(qli.ProductStage__c))// checks if qli.ProductStage__c=='In Progress'OR 'IGAP In Progress' OR 'Jeopardy'   
                    {
                        fundingTypeSetInProg.add(qli.Funding__c);
                    }
                    else if(ProdLostStagesList.contains(qli.ProductStage__c))//checks if qli.ProductStage__c=='Termed' OR 'Lost' OR 'Dead'|| OR 'IGAP Dead'OR 'IGAP Lost'OR 'Declined to Quote'
                    {
                        fundingTypeSetLost.add(qli.Funding__c);
                    }
                    

                }
                    system.debug('SolDFundingTypes'+fundingTypeSetSold);
                    system.debug('InProgFundingTypes'+fundingTypeSetInProg);
                    system.debug('LostFundingTypes'+fundingTypeSetLost);
                    
                    if (allNAs) {
                        acc.Account_Medical_Funding_Type__c='N/A';                  
                    }
                    else if(!fundingTypeSetSold.isEmpty()){
                        if( fundingTypeSetSold.contains('ASO/FI')||(fundingTypeSetSold.contains('ASO') && fundingTypeSetSold.contains('FI')))
                        {
                            acc.Account_Medical_Funding_Type__c='ASO/FI';     
                        }
                        else if(fundingTypeSetSold.contains('ASO')){
                            acc.Account_Medical_Funding_Type__c='ASO'; 
                        }
                        else if(fundingTypeSetSold.contains('FI')){
                            acc.Account_Medical_Funding_Type__c='FI'; 
                        }
                        else if(fundingTypeSetSold.contains('N/A')){
                            acc.Account_Medical_Funding_Type__c='N/A'; 
                        }
                    }               
                    else if(!fundingTypeSetInProg.isEmpty()){
                        if( fundingTypeSetInProg.contains('ASO/FI')||(fundingTypeSetInProg.contains('ASO') && fundingTypeSetInProg.contains('FI')))
                        {
                            acc.Account_Medical_Funding_Type__c='ASO/FI';     
                        }
                        else if(fundingTypeSetInProg.contains('ASO')){
                            acc.Account_Medical_Funding_Type__c='ASO'; 
                        }
                        else if(fundingTypeSetInProg.contains('FI')){
                            acc.Account_Medical_Funding_Type__c='FI'; 
                        }
                        else if(fundingTypeSetInProg.contains('N/A')){
                            acc.Account_Medical_Funding_Type__c='N/A'; 
                        }
                    }               
                    else if(!fundingTypeSetLost.isEmpty()){
                        if( fundingTypeSetLost.contains('ASO/FI')||(fundingTypeSetLost.contains('ASO') && fundingTypeSetLost.contains('FI')))
                        {
                            acc.Account_Medical_Funding_Type__c='ASO/FI';     
                        }
                        else if(fundingTypeSetLost.contains('ASO')){
                            acc.Account_Medical_Funding_Type__c='ASO'; 
                        }
                        else if(fundingTypeSetLost.contains('FI')){
                            acc.Account_Medical_Funding_Type__c='FI'; 
                        } 
                        else if(fundingTypeSetLost.contains('N/A')){
                            acc.Account_Medical_Funding_Type__c='N/A'; 
                        }                             
                    }
            }
        }
        
        if(accListDel.size()>0){
            for(Account acc : accListDel){
                if (!mapAccIdQLIsDel.isEmpty() && mapAccIdQLIsDel.get(acc.Id).size()>0){
                    system.debug('inElseFunding');
                    acc.Account_Medical_Funding_Type__c=null;
                }   
            }
            accList.addAll(accListDel);
        }
        database.update(accList,false);
    }
    
    global void finish(Database.BatchableContext bc){
        
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems from AsyncApexJob where Id = :bc.getJobId()];        
        
        if(a.Status == 'Completed') {
            roles.LastRun__c =jobStartTime;
            update roles;        
        }
    }
}