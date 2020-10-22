/**
* Batch class name: CollabToolIntegration
* Batch Job should pick any records in status PENDING
* once records processed successfully, update the status as SUCCESS
* on ERROR, status should be updated as ERROR
* 1) to update legacy group data 
* 2) create new WGS records in COM2
* 3) Create New Quote Record linked to WGS Group record
* 4) Create Medical quote line item record under new Quote record for each Medical products sold based on contract code on Product Order Form
* 5) Terminate Legacy Medical Quote line items migrated from Com1
**/
global class CollabToolIntegration implements Database.Batchable<sObject>, Database.Stateful{
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.batchableContext BC) {
        String status = 'PENDING';
        
        /*query to fetch data from Collab_Migrated_Group, Collab_Migrated_Group_Products */
        
        return Database.getQueryLocator('Select Id, Com2_Account_Id__c, Collab_AccountId__c, Migration_Date__c,' +
                                        'Legacy_Claim_System__c , Legacy_Group_Number__c , WGS_Group_Number__c, '+
                                        ' Account_Legal_Name__c, Situs_State__c,  Group_Size__c, ' +
                                        ' Account_Manager__c, Status__c, Status_Message__c ' +
                                        'from Collab_Migrated_Group__c where Status__c = :status'
        );
    }
    
    global void execute(Database.BatchableContext BC, List<Collab_Migrated_Group__c> scope){   
        for (Collab_Migrated_Group__c cmg : scope){
            processMigratedGroup(cmg);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed!');
        
        AsyncApexJob job = [SELECT  Id, Status, ApexClassId, 
                            NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
    } 
    
    public void processMigratedGroup(Collab_Migrated_Group__c cmgrec){
        List<String> contractCodeList = new List<String>();//List of Contract code
        Quote quoteinsert;
        Map<String,Product2> prodMap = new Map<String, product2>();
        Set<String> contCodeSet = new Set<String>();
        
        Map<String,PricebookEntry> pbeMap = new Map<String, PriceBookEntry>();
        Map<String,PricebookEntry> parentPbeMap = new Map<String, PriceBookEntry>();
        
        Set<String> prodIdSet = new Set<String>();//Product Id Set
        Set<String> parentProdIDSet = new Set<String>();//Parent Product Id Set
        
        Map<String,QuoteLineItem> parentProdidQLIMap = new Map<String,QuoteLineItem>();
        
        List<Account> accListToUpdate = new List<Account>();
        String accGrpSize;
        
        ID oppId;
        String oppName;
        Date oppEffDate;
        
        Pricebook2 pb2 = [select Id, Name, IsActive from PriceBook2 where IsStandard=True LIMIT 1];
        
        /* 
        * Validate all mandatory input fields in data received from Collab tool
        * 	Collab account id
        *   Com2 account id
        *   both group numbers
        *   legacy claim system
        *   contract codes
        .......
        if any of the mandatory fields missing in input data, then set the status code = 'ERROR' and Status message
        */
        
        if( cmgrec.Com2_Account_Id__c == null || cmgrec.Collab_AccountId__c == null ||
           cmgrec.Legacy_Claim_System__c == null ||cmgrec.Legacy_Group_Number__c == null 
           || cmgrec.WGS_Group_Number__c == null ||  cmgrec.Migration_Date__c == null)
        {
            cmgrec.Status__c = 'ERROR';
            cmgrec.Status_Message__c = 'Collabtool mendatory fields missing, Com2 Account Id'+ cmgrec.Com2_Account_Id__c +
                'Collabtool Account Id' + cmgrec.Collab_AccountId__c + 
                'Claim system' + cmgrec.Legacy_Claim_System__c + 
                'Legacy Group number'+cmgrec.Legacy_Group_Number__c+ 
                'WGS Group number'+cmgrec.WGS_Group_Number__c+ 
                'Migration date'+cmgrec.Migration_Date__c;
            database.update(cmgrec);
            system.debug('--- Collabtool mendatory fields missing ---'+cmgrec);
            return; 
        }
        
        /* fetch Com2 account data */
        List<Account> com2Accs = [select Id, Name , Group_Size__c, Situs_State__c 
                            from Account where Id = :Id.valueOf(cmgrec.Com2_Account_Id__c)];
        
        if (com2Accs != null && com2Accs.size() ==1 ){ 
            /*update all the fields of Account */
            system.debug('-- update the Com2 account data ---'+com2Accs);
            system.debug('--- cmgrec.Migration_Date__c' +cmgrec.Migration_Date__c);
            system.debug('--- cmgrec.Legacy_Group_Number__c ---'+cmgrec.Legacy_Group_Number__c);
            system.debug('--- cmgrec.WGS_Group_Number__c ---'+cmgrec.WGS_Group_Number__c);
        
            if(String.isNotBlank(cmgrec.Group_Size__c) && cmgrec.Group_Size__c.split('-').size() == 2) {
               accGrpSize = cmgrec.Group_Size__c == '250-999' ? '' : (cmgrec.Group_Size__c.split('-')[0] + ' - ' + cmgrec.Group_Size__c.split('-')[1]);
            }else
            {
                accGrpSize = cmgrec.Group_Size__c;
            }
            
           if( (cmgrec.Account_Legal_Name__c != null && cmgrec.Account_Legal_Name__c != com2Accs[0].Name)|| 
               (accGrpSize != null && accGrpSize != com2Accs[0].Group_Size__c) ||
               (cmgrec.Situs_State__c != null && cmgrec.Situs_State__c != com2Accs[0].Situs_State__c)
             )
           {
               com2Accs[0].Name = cmgrec.Account_Legal_Name__c;
               com2Accs[0].Group_Size__c = accGrpSize;
               com2Accs[0].Situs_State__c = cmgrec.Situs_State__c;
               accListToUpdate.add(com2Accs[0]);
           }
           system.debug('--- com2Accs[0].Name ---'+com2Accs[0].Name);
            
            /* Query to validate Legacy group record */
            List<Group__c> grpRecList = [select Id, Name, Account_legal_Name__c, ClaimSystem__c from Group__c 
                                         where Account__c = :com2Accs[0].Id 
                                         and (Name = :cmgrec.Legacy_Group_Number__c OR Name = :cmgrec.WGS_Group_Number__c)];
            
            system.debug('--- Group records : GrpRec ---:' + grpRecList);
            
            /*Validation for WGS Group Claim system and exit with error */
            String legacyGrpNum ;
            String wgsGrpNum ;
            String wgsGrpNumNotInCollab ;
            
            if(grpRecList != null && grpRecList.size()>0){
                for(Group__c eachGrpRec: grpRecList ){
                    if(eachGrpRec.ClaimSystem__c == cmgrec.Legacy_Claim_System__c && eachGrpRec.name == cmgrec.Legacy_Group_Number__c ){
                        legacyGrpNum=eachGrpRec.name;
                        system.debug('--->> legacyGrpNum 1 ---' +legacyGrpNum);
                    } else if(eachGrpRec.ClaimSystem__c == 'WGS 2.0' && eachGrpRec.name == cmgrec.WGS_Group_Number__c ){
                        wgsGrpNum = eachGrpRec.name;
                        system.debug('--->> wgsGrpNum 2 ---' +wgsGrpNum);
                    } else if(eachGrpRec.ClaimSystem__c == 'WGS 2.0' && eachGrpRec.name != cmgrec.WGS_Group_Number__c){
                        wgsGrpNumNotInCollab=eachGrpRec.name;
                        system.debug('--->> wgsGrpNumNotInCollab 2 :' +wgsGrpNumNotInCollab);
                        system.debug('--->> eachGrpRec.name 2 :' +eachGrpRec.name);
                    }
                }
                system.debug('--->> legacyGrpNum 2 ---' +legacyGrpNum);
                system.debug('--->wgsGrpNum 3 ---'+wgsGrpNum);
                system.debug('---> wgsGrpNumNotInCollab 3 ---'+wgsGrpNumNotInCollab);
                if(legacyGrpNum==null){
                    cmgrec.Status__c = 'ERROR';
                    cmgrec.Status_Message__c = 'Legacy Group number record not found in com2:'+ cmgrec.Legacy_Group_Number__c;
                    database.update(cmgrec);
                    return;
                }
                
                if(wgsGrpNum!= null ||wgsGrpNumNotInCollab != null ){
                    cmgrec.Status__c = 'ERROR';
                    cmgrec.Status_Message__c = 'WGS Group number record already exist in com2:'+wgsGrpNum+' '+wgsGrpNumNotInCollab ;
                    database.update(cmgrec);
                    return;
                }
            }else {
                cmgrec.Status__c = 'ERROR';
                cmgrec.Status_Message__c = 'Group record not found in Com2 for Account Id'+ com2Accs[0].Id ;
                database.update(cmgrec);
                return;
            }
            
            
            List<Opportunity> opptlist = [Select Id, Name, AccountId, Closedate, Opportunity_Renewal_Date__c, RecordTypeName__c, Pricebook2ID
                                          from Opportunity 
                                          where AccountId =:com2Accs[0].Id  
                                          and AnthemEntity__c = 'Local/Large Group' 
                                          and RecordTypeName__c = 'Renewal Local' 
                                          and Closedate = :cmgrec.Migration_Date__c ];
            
            system.debug('-- opptlist fetched ---'+opptlist);
            /* validate if opptlist is not null and only one opportunity retrieved. If opptlist is null or more than one oppportunity exist then 
            * set error status
            * Validate the renewal opportunity exist in com2 for effective date received from Collab tool, if not found log an error 
            */
            if ( opptlist != null && opptlist.size() == 1 ){    
                system.debug('-- opptlist ---'+opptlist);
                system.debug('-- opptlist[0].Name ---'+opptlist[0].Name);
                
                oppId = opptlist[0].id;
                oppName = opptlist[0].Name;
                oppEffDate = opptlist[0].Closedate;
                // Create Quote record with WGS group number and opportunityId
                
            }//Oppotunity  if - end
            else if ( opptlist.size() >1 || opptlist.size() == 0)//verify to include
            {
                cmgrec.Status__c = 'ERROR';
                cmgrec.Status_Message__c = 'no renewal opportunity or more than one opportunity found for Com2 account Id'+ cmgrec.Com2_Account_Id__c + ' and migration date '+ cmgrec.Migration_Date__c;
                database.update(cmgrec);
                return;
            } // end of Opp check
        }else {
            cmgrec.Status__c = 'ERROR';
            cmgrec.Status_Message__c = 'No Com2 Account record found for account id:'+ cmgrec.Com2_Account_Id__c;
            database.update(cmgrec);
            return;
        }          
        
        //Query to get child records from Collab_Migrated_Group_Products__c
        List<Collab_Migrated_Group_Products__c> cmgpreclist =  [Select Id, name ,Benefit_Period__c , Contract_Code__c , Funding_Type__c , 
                                                                      HPCC_Code__c , Incentive_Type__c , LOB__c, Group_Size__c 
                                                                from Collab_Migrated_Group_Products__c 
                                                                where Collab_Migrated_Group__c  =:cmgrec.Id
                                                               ];
        
        system.debug('--- Contract code records - Collab_Migrated_Group_Products__c : cmgpreclist ---:' + cmgpreclist); 
        
        
        if( cmgpreclist != null && cmgpreclist.size() > 0 ){
            
            for ( Collab_Migrated_Group_Products__c cmgp : cmgpreclist ){
                
                if( cmgp.Contract_Code__c != null ){
                    
                    contCodeSet.add(cmgp.Contract_Code__c);
                              
                }else {
                    cmgrec.Status__c = 'ERROR';
                    cmgrec.Status_Message__c = 'Contract code is missing for Collab tool product data' ;
                    database.update(cmgrec);
                    return;                          
                }//end of Product.Contract code check
                
            }//end-for loop of child record
            List<Product2> prodRecList = [Select Id, Name, Contract_code__c, Plan_Type__c, vlocity_ins__ProductSpecId__c 
                                           from Product2 
                                            where Contract_code__c= :contCodeSet and LOB__c = 'Medical' 
                                         ];  
            system.debug('--- prodRecList ---:' + prodRecList); 
            
            if(prodRecList!= null ||prodRecList.size()>0 ){
                
                for(Product2 eachProd :prodRecList ){
                    prodMap.put(eachProd.Contract_Code__c,eachProd);
                    
                    prodIdSet.add(eachProd.id);
                    System.debug('prodIdSet ' + prodIdSet);
                    
                    System.debug('---- eachProd.vlocity_ins__ProductSpecId__c --- ' + eachProd.vlocity_ins__ProductSpecId__c);
                    
                    if(eachProd.vlocity_ins__ProductSpecId__c != null) {
 						 parentProdIDSet.add(eachProd.vlocity_ins__ProductSpecId__c);
                         prodIdSet.add(eachProd.vlocity_ins__ProductSpecId__c);
                    }
                    
                }
            }
            System.debug('---> parentProdIDSet ' + parentProdIDSet);
            system.debug('---> final prodIdSet: '+prodIdSet);
            
            for ( Collab_Migrated_Group_Products__c cmgp : cmgpreclist ){
                if(!prodMap.containsKey(cmgp.Contract_Code__c)){
                    cmgrec.Status__c = 'ERROR';
                    cmgrec.Status_Message__c = 'No product record found for contract code: ' +cmgp.Contract_Code__c;
                    database.update(cmgrec);
                    return;
                }  
            }
            
            /*Select Parent and child Pricbook entry for product2 record to create QLI*/
            
            System.debug('pb2 ' + pb2);
            List<PriceBookEntry> pbeList = [Select Id, Pricebook2Id , Product2Id  from PricebookEntry 
                                            where Product2Id = :prodIdSet 
                                            and Pricebook2Id  = :pb2.id] ; 
            
            System.debug('pbeList ' + pbeList);
            
            for(PriceBookEntry pbe: pbeList){
                pbeMap.put(pbe.Product2Id, pbe);
            }        
            
        }
        else{
            cmgrec.Status__c = 'ERROR';
            cmgrec.Status_Message__c = 'No contract code records received from collab data';
            database.update(cmgrec);
            return;
            
        }

        //Create WGS Group Record
        Group__c grpinsert = new Group__c(Account__c  = cmgrec.Com2_Account_Id__c,
                                          ClaimSystem__c = 'WGS 2.0',
                                          Name = cmgrec.WGS_Group_Number__c,
                                          Collab_Account_ID__c = cmgrec.Collab_AccountId__c,
                                          IsActive__c = True 
                                         );
        database.insert(grpinsert);   
        system.debug('--- Group insert ---'+grpinsert);
        
        //Create Quote Record
        quoteinsert = new Quote( Name = oppName,
                                 OpportunityId = oppId,
                                 GroupNumber__c = grpinsert.Id,
                                 PriceBook2Id = pb2.Id
                               );
        database.insert(quoteinsert);
        system.debug('--- Quote insert ---'+grpinsert);
        
        List<QuoteLineItem> insertChildQLIList = new List<QuoteLineItem>();
        List<QuoteLineItem> insertParentQLIList = new List<QuoteLineItem>();
        
        
        /* create parent QuoteLineItems */
        system.debug('-- parentProdIDSet-2 --'+parentProdIDSet);
        
        for ( String parentProdId : parentProdIDSet ){
            system.debug('--pbeMap--'+pbeMap);
            system.debug('--- parentProdId ---'+parentProdId);
            system.debug('-- pbeMap.get(parentProdId).id ---'+pbeMap.get(parentProdId));
            
            QuoteLineItem  parentqliInsert = new QuoteLineItem ( QuoteId = quoteinsert.Id,                                                                    
                                                          		 Product2Id = parentProdId,
                                                          		 PricebookEntryId = pbeMap.get(parentProdId).id,
                                                                 RecordType__c = 'LocalType',//default value for Local LG
                                                                 ProductStage__c = 'In Progress',
                                                                 Quantity = 1,
                                                                 Unitprice = 1.00
                                                               );
            insertParentQLIList.add(parentqliInsert);
            
        }
        database.insert(insertParentQLIList);
        system.debug('--- Parent QLI insert---'+insertParentQLIList);
        
        for( QuoteLineItem parentQli: insertParentQLIList ){
             parentProdidQLIMap.put(parentQli.product2Id, parentQli);
        }
        
        
        /* create Child QuoteLineItems */
        // Funding__c: Collab tool : Fully Insured,  ASO
        //             Com2 : ASO ,FI , ASO/FI, N/A 
        // if funding type = FI set financing__c = Fully Insured , if Funding type = ASO , financing = Administrative Services Only
        // If plan_type__c = 'Modified' then update HCR_Status to 'Non-Grandfathered'
        system.debug('--pbeMap--' +pbeMap);
        
        system.debug('--prodMap--'+prodMap);
        
        system.debug('--parentProdidQLIMap---'+parentProdidQLIMap);
        
        String fundingType;
        String grpSize;
        
        for ( Collab_Migrated_Group_Products__c cmgp : cmgpreclist ){
            
            system.debug('--pbeMap.get(prodMap.get(cmgp.Contract_Code__c).id)--' +pbeMap.get(prodMap.get(cmgp.Contract_Code__c).id));
            system.debug('--prodMap.get(cmgp.Contract_Code__c)---'+prodMap.get(cmgp.Contract_Code__c));
            system.debug('--parentProdidQLIMap.get(prodMap.get(cmgp.Contract_Code__c).vlocity_ins__ProductSpecId__c)---'+parentProdidQLIMap.get(prodMap.get(cmgp.Contract_Code__c).vlocity_ins__ProductSpecId__c));
            system.debug('---- prodMap.get(cmgp.Contract_Code__c).Plan_Type__c ----'+prodMap.get(cmgp.Contract_Code__c).Plan_Type__c);
            
            if (cmgp.Funding_Type__c == 'Fully Insured' ){
                fundingType = 'FI';
            }else if (cmgp.Funding_Type__c == 'ASO' ){
                 fundingType = 'ASO';
            }
            
            QuoteLineItem  childqliInsert = new QuoteLineItem (QuoteId = quoteinsert.Id,                                                                    
                                                          Product2Id = prodMap.get(cmgp.Contract_Code__c).Id,
                                                          PricebookEntryId = pbeMap.get(prodMap.get(cmgp.Contract_Code__c).id).id,
                                                          vlocity_ins__ParentItemId__c = parentProdidQLIMap.get(prodMap.get(cmgp.Contract_Code__c).vlocity_ins__ProductSpecId__c).id,
                                                          ParentQuoteLineItem__c = parentProdidQLIMap.get(prodMap.get(cmgp.Contract_Code__c).vlocity_ins__ProductSpecId__c).id,
                                                          RecordType__c = 'LocalType',//default value for Local LG
                                                          Upsell__c = 'No',
                                                          ProductStage__c = 'In Progress',
                                                          Funding__c = fundingType,
                                                          Benefit_Period__c = cmgp.Benefit_Period__c,
                                                          HPCC_Code__c = cmgp.HPCC_Code__c,
                                                          Incentive_Type__c = cmgp.Incentive_Type__c,
                                                          Group_Size__c = (cmgp.Group_Size__c != null && ( cmgp.Group_Size__c == '1,000-12,499'|| cmgp.Group_Size__c == '12,500+'))? '1000+' :  (cmgp.Group_Size__c != null && cmgp.Group_Size__c.split('-').size() == 2) ? (cmgp.Group_Size__c.split('-')[0] + ' - ' + cmgp.Group_Size__c.split('-')[1]) : cmgp.Group_Size__c,
                                                          Quantity = 1,
                                                          Unitprice = 1.00,
                                                          Plan_type__c =  prodMap.get(cmgp.Contract_Code__c).Plan_Type__c,
                                                          Financing__c = fundingType == 'FI' ? 'Fully Insured' : fundingType == 'ASO' ? 'Administrative Services Only' : '' ,
                                                          HCR_Status__c = prodMap.get(cmgp.Contract_Code__c).Plan_Type__c == 'Modified' ? 'Nongrandfathered' : ''
                                                          );
            
            insertChildQLIList.add(childqliInsert);
            
        }
                
        database.insert(insertChildQLIList);
        system.debug('--- Child QLI insert---'+insertChildQLIList);
        
        //term all the Medical QLIs for the opportunity.
        List<QuoteLineItem> legacyMedicalQLIList = new List<QuoteLineItem>();
        List<QuoteLineItem> legacyMedicalQLIListToUpdate = new List<QuoteLineItem>();
        
        legacyMedicalQLIList = [Select id,ProductStage__c, TermDate__c,Reason__c from QuoteLineItem 
                                where quote.Opportunity.id =:oppId 
                                and Product_Type__c = 'Medical'
                                and ClaimsPlatform__c != 'WGS 2.0' 
                                and ProductStage__c in ('IGAP In Progress', 'In Progress', 'IGAP Sold','Jeopardy','Renewed','Sold')  ];
        
        if(!legacyMedicalQLIList.isEmpty()){
            for(QuoteLineItem legacyQli : legacyMedicalQLIList)
            {
                system.debug('--- legacyQli update ---'+legacyMedicalQLIList);
                system.debug('--- legacyQli update - oppEffDate ---'+oppEffDate);
                
                legacyQli.ProductStage__c = 'Termed';
                legacyQli.TermDate__c = oppEffDate;
                legacyQli.Reason__c = 'System Migration';
                
                legacyMedicalQLIListToUpdate.add(legacyQli);
            }
            
        }
        if (legacyMedicalQLIListToUpdate.size() > 0){
            update legacyMedicalQLIListToUpdate;
        }

        //Update the account  
        if (accListToUpdate.size() > 0){
            update accListToUpdate;
        }
        system.debug('--- accListToUpdate ---'+accListToUpdate);
        
        cmgrec.Status__c = 'SUCCESS';
        cmgrec.Status_Message__c = 'Record Processed Successfully';
        
        database.update(cmgrec);
       
    }//end of method :processMigratedGroup
    
}