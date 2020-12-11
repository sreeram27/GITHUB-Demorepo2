/*
 * @description This batch processes the WGS input data records and inserts QLIs with given contract codes if record is processed successfully
 * */
public without sharing class LoadQLIFromWGSData implements Database.Batchable<sObject>{
    
    static final String ERROR_CONST = 'Error';
    static final String SUCCESS_CONST = 'Success';
    static final String PENDING_CONST= 'Pending';
    static final String CLAIMSYS_CONST = 'WGS 2.0';
    static final String ANTHEMENT_CONST = 'Local/Large Group';
    static final String OPPRECTYPE_CONST = 'Renewal Local';
    static final String PRODCTCATG_CONST = 'Product';
    static final String QLIRECTYPE_CONST = 'LocalType';
    static final String QLISTAGE_CONST = 'In Progress';
    static final Boolean TRUE_CONST = True;
    static final Set<String> oppStagesList = new Set<String>{'Submitted', 'Initiated', 'Jeopardy', 'Submitted to Customer', 'Verbal Commitment', 'Quoting'};
    
    /*
     * @description Query for all WGS input data records with Pending status
     * @param Database.BatchableContext bc
     * @return Database.QueryLocator query locator
    */
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator([SELECT Id, WGS_Group_Number__c, Contract_Code__c, Benefit_Period__c,  
                                         Effective_Date__c, Financing__c, Funding_Type__c, Member_count__c, 
                                         Subscriber_count__c, Upsell_Flag__c, Status__c, Status_Message__c 
                                         FROM WGS_Sold_Contract_Codes__c 
                                         WHERE Status__c =: PENDING_CONST] );
    }

    /*
     * @description Pass one WGS input record at a time to execute the batch job
     * @param Database.BatchableContext bc
     * @param List<WGS_Sold_Contract_Codes__c> scope
     */
    public void execute(Database.BatchableContext bc, List<WGS_Sold_Contract_Codes__c> scope){
        //Execute one record at a time - Batchsize is 1
        processWGSInputData(scope[0]);     
    }
    /* 
     * @description Finish method of batch job 
     * @param Database.BatchableContext bc
     */ 
    public void finish(Database.BatchableContext bc){
      // Query the AsyncApexJob object to retrieve the current job's information.
    }
    
    private void setStatus(WGS_Sold_Contract_Codes__c wgsRec, String statusMsg){
        wgsRec.Status__c = ERROR_CONST;
        wgsRec.Status_Message__c = statusMsg;
        update wgsRec;  
    }
    /*
     * @description Process each WGS input record passed from the scope
     * @param WGS_Sold_Contract_Codes__c wgsRec
     */
    public void processWGSInputData(WGS_Sold_Contract_Codes__c wgsRec){
        
        Map<String, PriceBookEntry> pbeMap = new Map<String, PriceBookEntry>();
        List<QuoteLineItem> parentQLIList = new List<QuoteLineItem>();
        QuoteLineItem parentQLI;
        
        if(wgsRec.WGS_Group_Number__c == null || wgsRec.Contract_Code__c == null){
            setStatus(wgsRec, 'Missing WGS Group Number and/or Contract Code in WGS input data' );
            return;
        }
        
        //Get the wgs active groups with the input data group number
        List<Group__c> wgsGroupList = [SELECT Id, Name, ClaimSystem__c, Account__c 
                                       FROM Group__c 
                                       WHERE Name=: wgsRec.WGS_Group_Number__c 
                                       AND ClaimSystem__c =: CLAIMSYS_CONST   
                                       AND Anthem_Entity__c =: ANTHEMENT_CONST
                                       AND IsActive__c =: TRUE_CONST];
        
        if(wgsGroupList.size() == 0 || wgsGroupList.size() >1){
            if(wgsGroupList.size() == 0){
                setStatus(wgsRec, 'No active WGS Groups found with group number '+wgsRec.WGS_Group_Number__c);
            }
            else{
                setStatus(wgsRec, 'More than one active WGS Groups found with group number '+wgsRec.WGS_Group_Number__c);
            }
            return;
        }
        
        List<Opportunity> oppList = [SELECT Id, AccountId, CloseDate 
                                     FROM Opportunity
                                     WHERE AccountId =: wgsGroupList[0].Account__c 
                                     AND CloseDate =: wgsRec.Effective_Date__c 
                                     AND RecordTypeName__c =: OPPRECTYPE_CONST
                                     AND StageName IN : oppStagesList];
        
        if(oppList.size() == 0 || oppList.size() >1){
            if(oppList.size() == 0){
                setStatus(wgsRec, 'No Renewal Local Type Opportunity found for the related account '+wgsGroupList[0].Account__c+ ' and group number '+wgsRec.WGS_Group_Number__c);
            }
            else{
                setStatus(wgsRec, 'More than one Renewal Local Type Opportunities found for the related account '+wgsGroupList[0].Account__c+ ' and group number '+wgsRec.WGS_Group_Number__c); 
            }
            return;
        }
        
        //Get the related quotes under the renewal local opportunity for the wgs group related account
        List<Quote> quotesList = [SELECT Id, OpportunityId, PriceBook2Id 
                                  FROM Quote 
                                  WHERE OpportunityId =: oppList[0].Id 
                                  AND GroupNumber__c =:wgsGroupList[0].Id];
        
        if(quotesList.size() == 0 || quotesList.size() >1){
            if(quotesList.size() == 0){
                setStatus(wgsRec, 'No quote found under Renewal Local Type Opportunity for the related account '+wgsGroupList[0].Account__c + ' and group number '+wgsRec.WGS_Group_Number__c);
            }
            else{
                setStatus(wgsRec, 'More than one quotes found under Renewal Local Type Opportunity for the related account '+wgsGroupList[0].Account__c + ' and group number '+wgsRec.WGS_Group_Number__c);
            }
            return;
        }
        
        //Check if there exits a qli with the contract code from wgs input data 
        List<QuoteLineItem> qliList = [SELECT Id, QuoteId, Contract_Codes__c 
                                       FROM QuoteLineItem 
                                       WHERE QuoteId =:quotesList[0].Id 
                                       AND Contract_Codes__c =:wgsRec.Contract_Code__c];
        if(qliList.size() > 0){
            setStatus(wgsRec, 'QLI already exists for the contract code '+wgsRec.Contract_Code__c + ' and WGS group number '+wgsRec.WGS_Group_Number__c); 
            return;
        }
        
        //Get Product for the contract code in WGS input Data
        List<Product2> productList = [SELECT Id, Contract_Code__c, vlocity_ins__ProductSpecId__c, vlocity_ins__EffectiveDate__c
                                      FROM Product2 
                                      WHERE Contract_Code__c =: wgsRec.Contract_Code__c 
                                      AND IsActive =: TRUE_CONST 
                                      AND ProductActive__c =: TRUE_CONST 
                                      ORDER BY vlocity_ins__EffectiveDate__c DESC NULLS LAST 
                                      LIMIT 1];
        if(productList.size() == 0){
            setStatus(wgsRec, 'No matching Product found with the contract code '+wgsRec.Contract_Code__c);
            return;
        }
        
        List<PriceBookEntry> pbeList = [SELECT Id, Product2Id 
                                        FROM PriceBookEntry 
                                        WHERE (Product2Id =:productList[0].Id 
                                               OR Product2Id =:productList[0].vlocity_ins__ProductSpecId__c) 
                                        AND IsActive =: TRUE_CONST];
        
        System.debug('Product for given WGS input Contract Code: '+ productList[0].Id);
        System.debug('Parent Product for given WGS input Contract Code: '+ productList[0].vlocity_ins__ProductSpecId__c);   
        
        
        for(PriceBookEntry pbe: pbeList){
            pbeMap.put(pbe.Product2Id, pbe);
        }
        
        //Check if quote has a related Parent Product QLI record associated already
        
        if(productList[0].vlocity_ins__ProductSpecId__c != null){  
            parentQLIList = [SELECT Id, Product2Id, Members__c, Subscribers__c 
                             FROM QuoteLineItem 
                             WHERE QuoteId =:quotesList[0].Id 
                             AND Product2Id =:productList[0].vlocity_ins__ProductSpecId__c 
                             AND ProductCategory__c =:PRODCTCATG_CONST];
        }
        
        
        //If no Parent QLI is found, create a parent QLI based on Parent Product Id
        if(parentQLIList.size() ==0 && productList[0].vlocity_ins__ProductSpecId__c != null){
            parentQLI = new QuoteLineItem(QuoteId = quotesList[0].Id,
                                          Product2Id = productList[0].vlocity_ins__ProductSpecId__c, 
                                          PricebookEntryId = pbeMap.get(productList[0].vlocity_ins__ProductSpecId__c).Id,
                                          RecordType__c = QLIRECTYPE_CONST,
                                          ProductStage__c = QLISTAGE_CONST,
                                          OppType__c = OPPRECTYPE_CONST,
                                          UnitPrice = 1.00,
                                          Quantity = 1);
            
            Database.insert(parentQLI);
            
        }
        else if (parentQLIList.size() > 0){
            parentQLI = parentQLIList[0];  
        }
        
        QuoteLineItem childQLItoInsert = new QuoteLineItem(QuoteId = quotesList[0].Id,
                                                           Product2Id = productList[0].Id,
                                                           PricebookEntryId = pbeMap.get(productList[0].Id).Id,
                                                           ProductStage__c = QLISTAGE_CONST,
                                                           Probability__c = wgsRec.Funding_Type__c == 'FI'? '85%' :'95%',
                                                           ParentQuoteLineItem__c = parentQLI != null? parentQLI.Id: null,
                                                           OppType__c = OPPRECTYPE_CONST,
                                                           RecordType__c = QLIRECTYPE_CONST,
                                                           Funding__c = wgsRec.Funding_Type__c,
                                                           Benefit_Period__c = wgsRec.Benefit_Period__c,
                                                           Financing__c = wgsRec.Financing__c,
                                                           Members__c = wgsRec.Member_count__c,
                                                           Subscribers__c = wgsRec.Subscriber_count__c,
                                                           Upsell__c = wgsRec.Upsell_Flag__c,
                                                           UnitPrice = 1.00,
                                                           Quantity = 1);
        
        Database.insert(childQLItoInsert);
        
        if(parentQLI != null){
            List<AggregateResult> qliAggregateList = [SELECT Sum(Members__c) memCount, Sum(Subscribers__c) Subscribercnt 
                                                      FROM QuoteLineItem 
                                                      WHERE ParentQuoteLineItem__c =: parentQLI.Id ];
            
            List<QuoteLineItem> qliFundingTypes = [Select Funding__c, Financing__c 
                                                   FROM QuoteLineItem 
                                                   Where ParentQuoteLineItem__c =: parentQLI.Id 
                                                   ORDER BY Funding__c DESC 
                                                   LIMIT 1 ];
            
            parentQLI.Funding__c = qliFundingTypes[0].funding__c;
            parentQLI.Financing__c = qliFundingTypes[0].Financing__c;
            parentQLI.Probability__c = qliFundingTypes[0].funding__c == 'FI'? '85%' :'95%' ;
            parentQLI.Members__c = (Decimal)qliAggregateList[0].get('memCount');
            parentQLI.Subscribers__c = (Decimal)qliAggregateList[0].get('Subscribercnt');    
            update parentQLI;
        }
        
        wgsRec.QLI_ID_Created__c = childQLItoInsert.Id;
        wgsRec.Status__c = SUCCESS_CONST;
        wgsRec.Status_Message__c = 'QLI inserted for the contract from WGS data '+wgsRec.Contract_Code__c + ' and group number '+wgsRec.WGS_Group_Number__c;
        update wgsRec;
    }
}