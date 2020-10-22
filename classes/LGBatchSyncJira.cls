global class LGBatchSyncJira implements Database.Batchable<sObject>,   Database.AllowsCallouts, Schedulable,Database.Stateful {
    
    public List<String> reqBodyList = new List<String>();
    public String business_segment ;
    
    public List<Field_Mapping__mdt> mappingList = [Select DeveloperName, JIRA_Field_Label__c, SFDC_Field_API__c, SFDC_Field_Label__c, SFDC_Object_API_Name__c, Default_Value__c, Value__c From Field_Mapping__mdt Where Type__c =: LGJiraValueSet.SF2JIRA AND Object_Type__c = null LIMIT 10000];
    public List<State_mapping__mdt> stateList = [Select Jira_Sales_Market__c, SFDC_AnthemEntity__c, SFDC_ClaimSystem__c, SFDC_JAAIndicator__c, SFDC_Region__c, SFDC_SitusState__c From State_mapping__mdt  LIMIT 10000];
    public Map<Id, String> errorMap {get; set;}
    public Map<Id, SObject> IdToSObjectMap {get; set;}
    public Map<Id, String> successMap{get; set;}
    public Map<Id, SObject> SuccessIdToSObjectMap{get; set;}
    
    public Map<string, string> IdtoReqBodyMap{get; set;}
    public Integer successcount=0;
    public Integer failurecount=0;
    public boolean customQLI=false;
    public boolean ModifiedQLI=false;
    public boolean StandardQLI=false;
    
    public LGBatchSyncJira(String p_business_segment) {
        
        business_segment = p_business_segment;
        errorMap=new Map<Id, String> ();
        IdToSObjectMap=new Map<Id, SObject>();
        successMap=new Map<Id, String> ();
        SuccessIdToSObjectMap=new Map<Id, SObject>();
        IdtoReqBodyMap=new Map<string, string>();
    }
    public LGBatchSyncJira() {
        //business_segment = 'National';
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //global List<Order> start(Database.BatchableContext BC) {
        
        //Set<String> statusList = new Set<String>();
        //statusList.addAll(LGJiraValueSet.StatusSet);
        
        Set<String> implementationStatusList = new Set<String>();
        implementationStatusList.addAll(LGJiraValueSet.ImplementationStatusSet);
        
        Set<String> implementationTypeList = new Set<String>();
        implementationTypeList.addAll(LGJiraValueSet.ImplementationTypeSet);
        
        Set<String> claimSystemList = new Set<String>();
        claimSystemList.addAll(LGJiraValueSet.ClaimSystemsSet);
        
        String departmentValue = LGJiraValueSet.SME_Department;
        
        String q ;
        if (business_segment == 'National') {
            q = 'Select Id, AccountId, Account.Name, Account.Region__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.Anthem_Entity__c, Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, '+
                'Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, '+
                'Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c, '+
                'Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order '+ 
                'Where Id IN (Select Implementation_Record_ID__c From SME_Approvals__c Where SME_Department__c =: departmentValue) ' +
                'AND Implementation_Status__c NOT IN: implementationStatusList AND Implementation_Type__c IN: implementationTypeList ' +
                'AND Id IN (Select Implementation_Record_ID__c From Implementation_Tracking__c Where JIRA_Request_ID__c = null) '+
                'AND Account.Anthem_Entity__c ='+ '\'National Accounts\''  ;
            
        }else if(business_segment== 'LG')  {
            q = 'Select Id, AccountId, Account.Name, Account.Region__c, Account_Group_Size__c,Account.Eligible_Employees__c,Account.Anthem_Entity__c, Account.NASCO_Contracting_Situs_State__c, Assigned_Implementer__c, Assigned_Implementer__r.Name, '+
                'Account.WGS_Contracting_Situs_State__c, Additional_Comments__c, Applicable_Intake_Types__c, QuoteId, Quote.GroupNumber__c, Quote.GrpName__c, '+
                'Quote.TotalMembers__c, Quote.JAAIndicator__c, Quote.OpportunityId, Quote.Opportunity.CloseDate, Implementation_Effective_Date__c, Implementation_Status__c, '+
                'Implementation_Type__c, OrderNumber, Pre_Implementation_Type__c, Production_Date__c, CreatedDate,GroupId__c, Claim_system__c, Situs_State__c, LHOL__c From Order '+ 
                'Where Implementation_Status__c NOT IN: implementationStatusList AND Implementation_Type__c IN: implementationTypeList ' + 
                'AND Id IN (Select Implementation_Record_ID__c From Implementation_Tracking__c Where JIRA_Request_ID__c = null and Engage_Medical_Benefits__c = true) '+
                'AND Claim_System__c IN: claimSystemList AND Account.Anthem_Entity__c in ('+ '\'Local/Large Group\'' +',' + '\'Labor and Trust\'' +')' ;
            
            
        }
        
        
        
        return database.getQueryLocator(q);
        //return orderList;
    }
    
    global void execute(Database.BatchableContext BC, List<Order> orderList) { 
        
        Set<String> orderIdSet = new Set<String>();
        Set<String> accountIdSet = new Set<String>();
        Set<String> quoteIdSet = new Set<String>();
        Set<String> groupIdSet = new Set<String>();
        Map<String, String> orderIdMap = new Map<String, String>();
        List<Implementation_Tracking__c> ITIssueList = new List<Implementation_Tracking__c>();
        
        
        
        Map<Id, AccountTeamMember> accMemberMap = new Map<Id, AccountTeamMember>();
        Map<Id, QuoteLineItem> qliMap = new Map<Id, QuoteLineItem>(); 
        String EBASystem ;
        String EBAPlatform;
        //Map<Id, QuoteLineItem> lgltqliMap = new Map<Id, QuoteLineItem>(); 
        system.debug('show size 12333 ' + orderList.size());
        
        try
        {
            
            for (Order o: orderList) {
                
                accountIdSet.add(o.AccountId);
                quoteIdSet.add(o.QuoteId);
                groupIdSet.add(o.GroupId__c);
                orderIdMap.put(o.OrderNumber, o.Id);
                
            }
            
            
            List<AccountTeamMember> accMemberList = [Select Id, AccountId, User.Name From AccountTeamMember Where TeamMemberRole =: LGJiraValueSet.TeamMemberRole and AccountId IN: accountIdSet];
            
            for (AccountTeamMember at: accMemberList) {
                
                accMemberMap.put(at.AccountId, at);
            }
            
            List<QuoteLineItem> quoteItemList;
            
            if (orderList.get(0).Account.Anthem_Entity__c == LGJiraValueSet.NationalAccounts) {
                
                quoteItemList = [Select Id, Funding__c, ProductName__c, ProductStage__c,Plan_Type__c, Product2.Plan_Type__c, QuoteId From QuoteLineItem where ProductType__c =: LGJiraValueSet.Medical AND QuoteId IN: quoteIdSet];
                
            } else if (orderList.get(0).Account.Anthem_Entity__c == LGJiraValueSet.LargeGroup || orderList.get(0).Account.Anthem_Entity__c == LGJiraValueSet.Labor) {
                
                quoteItemList = [Select Id, Funding__c, ProductName__c, ProductStage__c,Plan_Type__c, Product2.Plan_Type__c,QuoteId From QuoteLineItem where Product_Type__c =: LGJiraValueSet.Medical AND QuoteId IN: quoteIdSet];
                List<EWM_System_Name_Mapping__mdt> EWMSysMdtList = [select EBA_Platform__c,EBA_System__c from EWM_System_Name_Mapping__mdt where Anthem_Entity__c =:orderList.get(0).Account.Anthem_Entity__c and Claim_System__c =:orderList.get(0).Claim_system__c and State__c =:orderList.get(0).Situs_State__c];
                if(EWMSysMdtList.size()>0)
                {
                    EBASystem = EWMSysMdtList[0].EBA_System__c;
                    EBAPlatform = EWMSysMdtList[0].EBA_Platform__c;
                }
                else
                {
                    EWMSysMdtList = [select EBA_Platform__c,EBA_System__c from EWM_System_Name_Mapping__mdt where Anthem_Entity__c =:orderList.get(0).Account.Anthem_Entity__c and Claim_System__c =:orderList.get(0).Claim_system__c and State__c =:LGJiraValueSet.NA];
                    EBASystem = EWMSysMdtList[0].EBA_System__c;
                    EBAPlatform = EWMSysMdtList[0].EBA_Platform__c;
                }
                
            }
            if(quoteItemList!=null)
            {
                for (QuoteLineItem qli: quoteItemList) {
                    
                    if (!qliMap.containsKey(qli.QuoteId)) {
                        qliMap.put(qli.QuoteId, qli);
                    }
                    if ((qli.Plan_Type__c == 'Custom' || qli.Product2.Plan_Type__c == 'Custom') && (qli.ProductStage__c=='Sold' || qli.ProductStage__c=='IGAP Sold' || qli.ProductStage__c=='Renewed'))
                    {
                        customQLI = true;
                    }
                    if ((qli.Plan_Type__c == 'Modified' || qli.Product2.Plan_Type__c == 'Modified') && (qli.ProductStage__c=='Sold' || qli.ProductStage__c=='IGAP Sold' || qli.ProductStage__c=='Renewed'))
                    {
                        ModifiedQLI= true;
                    }
                    if ((qli.Plan_Type__c == 'Standard' || qli.Product2.Plan_Type__c == 'Standard') && (qli.ProductStage__c=='Sold' || qli.ProductStage__c=='IGAP Sold' || qli.ProductStage__c=='Renewed'))
                    {
                        StandardQLI = true;
                    }
                }
            }
            
            
            
            
            for (Order orderItem: orderList) {
                
                LGJira2IssueDetail.FieldDetails fields = new LGJira2IssueDetail.FieldDetails();
                
                for (Field_Mapping__mdt mappingItem:mappingList){
                    
                    if (mappingItem.JIRA_Field_Label__c == LGJiraValueSet.IssueType) {
                        
                        if (orderItem.Implementation_Type__c == LGJiraValueSet.NewBusiness) {
                            
                            fields.put(mappingItem.DeveloperName, mappingItem.Default_Value__c, fields);  
                            
                        } else if (orderItem.Implementation_Type__c == LGJiraValueSet.Renewal || orderItem.Implementation_Type__c == LGJiraValueSet.ChangeRequest || orderItem.Implementation_Type__c == LGJiraValueSet.Term || orderItem.Implementation_Type__c == LGJiraValueSet.PreWork) {
                            
                            fields.put(mappingItem.DeveloperName, mappingItem.Value__c, fields); 
                        }
                        
                    }
                    
                    if (mappingItem.JIRA_Field_Label__c == LGJiraValueSet.Project) {
                        
                        fields.put(mappingItem.DeveloperName, mappingItem.Default_Value__c + ';' + mappingItem.Value__c, fields); 
                        
                    }
                    
                    if (mappingItem.JIRA_Field_Label__c == LGJiraValueSet.ReferenceType) {
                        
                        fields.put(mappingItem.DeveloperName, mappingItem.Default_Value__c, fields);
                        
                    }
                    
                    // get all the order field value
                    if (mappingItem.SFDC_Field_API__c != null && mappingItem.SFDC_Field_API__c != '') {
                        
                        fields.put(mappingItem.DeveloperName, String.valueOf(orderItem.get(mappingItem.SFDC_Field_API__c)), fields);
                        
                    }
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.SalesMarket) {
                        
                        for (State_mapping__mdt state: stateList) {
                            
                            if (orderItem.Account.Anthem_Entity__c == LGJiraValueSet.LargeGroup && orderItem.Account.Anthem_Entity__c == state.SFDC_AnthemEntity__c && orderItem.Situs_State__c == state.SFDC_SitusState__c && 
                                orderItem.Claim_system__c != LGJiraValueSet.NASCO) {
                                    
                                    if (state.SFDC_JAAIndicator__c != null && String.valueOf(orderItem.Quote.JAAIndicator__c) == state.SFDC_JAAIndicator__c) {
                                        
                                        fields.put(mappingItem.DeveloperName, state.Jira_Sales_Market__c, fields);
                                    } else if (state.SFDC_JAAIndicator__c == null) {
                                        
                                        fields.put(mappingItem.DeveloperName, state.Jira_Sales_Market__c, fields);
                                    }
                                    
                                } else if (orderItem.Account.Anthem_Entity__c == LGJiraValueSet.LargeGroup && orderItem.Account.Anthem_Entity__c == state.SFDC_AnthemEntity__c && state.SFDC_ClaimSystem__c == LGJiraValueSet.NASCO &&
                                           orderItem.Claim_system__c == LGJiraValueSet.NASCO && state.SFDC_JAAIndicator__c != null && String.valueOf(orderItem.Quote.JAAIndicator__c) == state.SFDC_JAAIndicator__c) {
                                               
                                               fields.put(mappingItem.DeveloperName, state.Jira_Sales_Market__c, fields);  
                                           } else if (orderItem.Account.Anthem_Entity__c == LGJiraValueSet.NationalAccounts && orderItem.Account.Anthem_Entity__c == state.SFDC_AnthemEntity__c && orderItem.Account.Region__c == state.SFDC_Region__c){
                                               
                                               
                                               fields.put(mappingItem.DeveloperName, state.Jira_Sales_Market__c, fields); 
                                           }
                            
                        }
                        
                    }
                    
                    //Setting System Field
                    if (mappingItem.JIRA_Field_Label__c == LGJiraValueSet.SystemValue) 
                    {
                        
                        if ( orderItem.Account.Anthem_Entity__c == LGJiraValueSet.NationalAccounts) 
                        { 
                            
                            if (orderItem.Claim_system__c == LGJiraValueSet.WGS2)
                            {
                                
                                if(orderItem.Quote.JAAIndicator__c)
                                {
                                    fields.put(mappingItem.DeveloperName, LGJiraValueSet.WGSJAA, fields);
                                }
                                else
                                {                                                                                         
                                    fields.put(mappingItem.DeveloperName, LGJiraValueSet.WPD, fields);
                                }
                            } else if (orderItem.Claim_system__c == LGJiraValueSet.NASCO) {
                                
                                if(orderItem.Quote.JAAIndicator__c)
                                {
                                    fields.put(mappingItem.DeveloperName, LGJiraValueSet.NASCOJAA, fields);
                                }
                                else
                                {
                                    fields.put(mappingItem.DeveloperName, LGJiraValueSet.NASCO, fields);
                                }
                            }
                        }
                        
                        if(orderItem.Account.Anthem_Entity__c == LGJiraValueSet.LargeGroup ||  orderItem.Account.Anthem_Entity__c == LGJiraValueSet.Labor)
                        {
                            
                            fields.put(mappingItem.DeveloperName, EBASystem, fields);
                        }
                    }
                    
                    
                    if (mappingItem.JIRA_Field_Label__c == LGJiraValueSet.EBAPlatform) {
                        if ( orderItem.Account.Anthem_Entity__c == LGJiraValueSet.NationalAccounts) {
                            
                            if (orderItem.Claim_system__c == LGJiraValueSet.NASCO) {
                                
                                fields.put(mappingItem.DeveloperName, orderItem.Claim_system__c, fields);  
                                
                            } else if (orderItem.Claim_system__c == LGJiraValueSet.WGS2) {
                                
                                fields.put(mappingItem.DeveloperName, LGJiraValueSet.WGS, fields);  
                            }
                        }
                        
                        //Added new code for Local/Labour
                        if(orderItem.Account.Anthem_Entity__c == LGJiraValueSet.LargeGroup ||  orderItem.Account.Anthem_Entity__c == LGJiraValueSet.Labor)
                        {
                            fields.put(mappingItem.DeveloperName, EBAPlatform, fields);
                        }
                    }
                    
                    // Funding field
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.Funding && qliMap.get(orderItem.QuoteId)!= null) {
                        
                        if (qliMap.get(orderItem.QuoteId).Funding__c == LGJiraValueSet.FundingASO) {
                            
                            fields.put(mappingItem.DeveloperName, qliMap.get(orderItem.QuoteId).Funding__c, fields); 
                        } else if (qliMap.get(orderItem.QuoteId).Funding__c == LGJiraValueSet.FundingFI) {
                            
                            fields.put(mappingItem.DeveloperName, LGJiraValueSet.NonRefunding, fields); 
                            
                        }
                        
                    }
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.AccLegalName) {
                        
                        fields.put(mappingItem.DeveloperName, orderItem.Account.Name, fields);  
                    }
                    
                    
                    
                    
                    // Group Type
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.AnthemEntity && orderItem.Account.Anthem_Entity__c == LGJiraValueSet.NationalAccounts) {
                        
                        fields.put(mappingItem.DeveloperName, LGJiraValueSet.National, fields);  
                    }
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.TotalMembers) {
                        
                        fields.put(mappingItem.DeveloperName, String.valueOf(orderItem.Quote.TotalMembers__c), fields); 
                    }
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.EligibleEmployees) {
                        fields.put(mappingItem.DeveloperName, String.valueOf(orderItem.Account.Eligible_Employees__c), fields); 
                    }
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.ContractType) {
                        if(customQLI)
                        {
                            fields.put(mappingItem.DeveloperName,LGJiraValueSet.Custom , fields);     
                        }
                        else if(ModifiedQLI)
                        {
                            fields.put(mappingItem.DeveloperName,LGJiraValueSet.Modified , fields);     
                        }
                        else if(StandardQLI)
                        {
                            fields.put(mappingItem.DeveloperName,LGJiraValueSet.Standard , fields);     
                        }
                        
                    }
                    
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.OppEffectiveDate && orderItem.Quote.Opportunity != null && orderItem.Quote != null) {
                        
                        fields.put(mappingItem.DeveloperName, String.valueOf(orderItem.Quote.Opportunity.CloseDate.addYears(1)), fields); 
                    }
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.RecordLink) {
                        
                        fields.put(mappingItem.DeveloperName, URL.getSalesforceBaseUrl().toExternalForm() + '/' + orderItem.Id, fields);  
                    }
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.AssignedImplementer) {
                        
                        fields.put(mappingItem.DeveloperName, orderItem.Assigned_Implementer__r.Name, fields);  
                    }
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.SentDate) {
                        
                        fields.put(mappingItem.DeveloperName, String.valueOf(system.now()), fields);  
                    }
                    
                    if (mappingItem.SFDC_Field_Label__c == LGJiraValueSet.User && accMemberMap.get(orderItem.AccountId) != null) {
                        
                        fields.put(mappingItem.DeveloperName, accMemberMap.get(orderItem.AccountId).User.Name, fields);  
                    }
                    
                    
                    
                    if (mappingItem.JIRA_Field_Label__c == LGJiraValueSet.Summary) {
                        
                        String newDateStr='';
                        
                        if(orderItem.Implementation_Effective_Date__c != null)
                        {
                            Datetime dT = orderItem.Implementation_Effective_Date__c;
                            dT = dT.addHours(dT.hour());
                            dT = dT.addMinutes(dT.minute());
                            dT = dT.addSeconds(dT.second());
                            
                            newDateStr =  dT.format('MM/dd/yyyy') ;
                            
                        }
                        
                        if (orderItem.Implementation_Type__c == LGJiraValueSet.NewBusiness) {
                            
                            fields.put(mappingItem.DeveloperName, orderItem.Account.Name + ' - ' + orderItem.Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryNewBusiness + orderItem.OrderNumber, fields); 
                            
                        } else if (orderItem.Implementation_Type__c == LGJiraValueSet.Renewal) {
                            
                            
                            fields.put(mappingItem.DeveloperName, orderItem.Account.Name + ' - ' + orderItem.Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryRenewal + orderItem.OrderNumber, fields);  
                            
                        } else if (orderItem.Implementation_Type__c == LGJiraValueSet.ChangeRequest) {
                            
                            fields.put(mappingItem.DeveloperName, orderItem.Account.Name + ' - ' + orderItem.Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryChange + orderItem.OrderNumber, fields);  
                            
                        } else if (orderItem.Implementation_Type__c == LGJiraValueSet.Term) {
                            
                            fields.put(mappingItem.DeveloperName, orderItem.Account.Name + ' - ' + orderItem.Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryTerm + orderItem.OrderNumber, fields);  
                            
                        }
                        else if (orderItem.Implementation_Type__c == LGJiraValueSet.PreWork) {
                            
                            fields.put(mappingItem.DeveloperName, orderItem.Account.Name + ' - ' + orderItem.Quote.GrpName__c + ' - ' + newDateStr + LGJiraValueSet.SummaryPreWork  + orderItem.OrderNumber, fields);  
                            
                        }
                    }
                    
                }
                
                string reqBody = '{"fields": ' + JSON.serialize(fields, true) + '}';
                
                system.debug('show issue string 12321 : ' + reqBody);
                
                reqBodyList.add(reqBody);
                
            }
            
            // Send preparing to send request
            LGJiraUtility jiraCtrler = new LGJiraUtility();
            Set<String> idSet = new Set<String>();
            Map<String, String> reqMap = new Map<String, String>();
            
            for (String reqItem: reqBodyList) {
                
                String idItem = orderIdMap.get(reqItem.substringBetween('"customfield_11445":"', '"'));
                idSet.add(idItem);
                reqMap.put(idItem, reqItem);
            }
            
            List<Implementation_Tracking__c> itList = [Select Implementation_Record_ID__c, JIRA_Request_ID__c From Implementation_Tracking__c Where Implementation_Record_ID__c IN: idSet];
            Map<String,Implementation_Tracking__c> itMap = new Map<String,Implementation_Tracking__c>();
            
            for (Implementation_Tracking__c it: itList) {
                itMap.put(it.Implementation_Record_ID__c, it);
            }
            
            for (String reqItemId: reqMap.keySet()) {
                
                if (itMap.containsKey(reqItemId) && itMap.get(reqItemId).JIRA_Request_ID__c != null) {
                    
                    //String updateIssueBody = jiraCtrler.ModifyIssue(itMap.get(reqItemId).JIRA_Request_ID__c, reqMap.get(reqItemId));
                    //system.debug('show update result : ' + updateIssueBody);
                    
                } else {
                    System.debug('reqItemTemp :'+reqMap.get(reqItemId));
                    LGJiraCreateIssueResponse createIssueRes = jiraCtrler.CreateIssue(reqMap.get(reqItemId));
                    
                    //system.debug('issue1 response : ' + reqBody);
                    system.debug(' ** show result : ' + createIssueRes);
                    
                    //createIssueRes.response != null &&  createIssueRes.response != 'null' 
                    
                    if(createIssueRes.response != null)
                    {
                        IdtoReqBodyMap.put(reqItemId,reqMap.get(reqItemId));
                        throw new CustomException(createIssueRes.response);
                        
                    }
                    if(createIssueRes.exceptions !=null)
                    {
                        IdtoReqBodyMap.put(reqItemId,reqMap.get(reqItemId));
                        throw new CustomException(createIssueRes.exceptions[0].message);
                        
                    }
                    
                    if (itMap.containsKey(reqItemId)) {
                        
                        if(createIssueRes.key!=null)
                        {
                            itMap.get(reqItemId).JIRA_Request_ID__c = createIssueRes.key;
                        }
                        else
                        {
                            IdtoReqBodyMap.put(reqItemId,reqMap.get(reqItemId));
                            throw new CustomException('There was an error while processing the request.The JIRA request id was not created');
                            
                        }
                        
                        
                        //itMap.get(reqItemId).show_error__c = String.valueOf(createIssueRes.errors);
                        ITIssueList.add(itMap.get(reqItemId));
                    } else {
                        
                        Implementation_Tracking__c issueItem = new Implementation_Tracking__c();
                        
                        issueItem.Implementation_Record_ID__c = reqItemId;
                        issueItem.JIRA_Request_ID__c = createIssueRes.key;
                        //issueItem.show_error__c = String.valueOf(createIssueRes.errors);
                        
                        ITIssueList.add(issueItem);
                        
                    }
                    
                }
            }
            
            jiraCtrler.UpdateTokenTable();
            upsert ITIssueList;
            successMap.put(orderList[0].id,'Success');
            SuccessIdToSObjectMap.put(orderList[0].id,orderList[0]);
            successcount++;
        }
        
        Catch(Exception ex)
        {
            
            errorMap.put(orderList[0].id,ex.getmessage());
            IdToSObjectMap.put(orderList[0].id,orderList[0]);
            system.debug('In Catch--->'+errorMap);
            system.debug('Exception Message In :'+ex.getLineNumber()+':'+ex.getMessage());
            
            failurecount++;
        }
    }
    
    global void execute(SchedulableContext ctx) {
        //System.debug('In schedulable job execute');
        
        LGBatchSyncJira nationalBS = new LGBatchSyncJira('National');
        Database.executeBatch(nationalBS,1);
        //System.debug('In schedulable job execute 1');
        LGBatchSyncJira lgBS = new LGBatchSyncJira('LG');
        Database.executeBatch(lgBS,1);
        //System.debug('In schedulable job execute 2');
        JIRAToSFDCSyncBatch_v2 JiraBS = new JIRAToSFDCSyncBatch_v2();
        Database.executeBatch(JiraBS, 1);
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('IdtoReqBodyMap:'+IdtoReqBodyMap);
        // send email here!
        //string body='';
        //String subject = 'JIRA to SFDC Sync Process Status';
        AsyncApexJob a = [SELECT id, ApexClassId,
                          JobItemsProcessed, TotalJobItems,
                          NumberOfErrors, CreatedBy.Email
                          FROM AsyncApexJob
                          WHERE id = :BC.getJobId()];
        if (business_segment=='National'){
            LGJiraProcessBatchStatus.CreateEmail(errorMap,a.JobItemsProcessed,'National-SFDC to JIRA Sync Process Status',successcount,failurecount,IdToSObjectMap,'order',successMap,SuccessIdToSObjectMap,IdtoReqBodyMap);
        } else if (business_segment=='LG'){
            LGJiraProcessBatchStatus.CreateEmail(errorMap,a.JobItemsProcessed,'LG-SFDC to JIRA Sync Process Status',successcount,failurecount,IdToSObjectMap,'order',successMap,SuccessIdToSObjectMap,IdtoReqBodyMap);
        }
        
        
    }
}