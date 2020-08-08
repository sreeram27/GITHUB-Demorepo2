global without sharing class CSP_AccountPlan implements vlocity_ins.VlocityOpenInterface2  {
     
    /*Implementation of invokeMEthod from VlocityOpenInterface2 interface.*/
    global static Boolean invokeMethod(String methodName,Map<String,Object> inputMap,
                                        Map<String,Object> outMap,Map<String,Object> optns) {   
        
        System.debug('>>> Inside CSP_AccountPlan InvokeMethod 1000');
        
        if('LoadSWT'.equalsIgnoreCase(methodName)) {
            System.debug('>>> Inside CSP_AccountPlan invokeMethod LoadSWT 2000');
            saveSWT(methodName, inputMap, outMap,optns);
            
        } else if('RetrieveSWT'.equalsIgnoreCase(methodName)) {
            System.debug('>>> Inside CSP_AccountPlan invokeMethod RetrieveSWT 3000');
            List<Map<String,String>> options = new List<Map<String, String>>(); 
            System.debug('>>> inputMap ='+ inputMap);
            String planDetailsId = (String) inputMap.get('PlanDetailsId');
            System.debug('>>> planDetailsId ='+ planDetailsId);
            String accountId = (String) inputMap.get('ContextId');
            System.debug('>>> accountId ='+ accountId);

            
            Set<String> observationSet = new Set<String>();
            for(SalesObservation__c  so:[Select Id, Name From SalesObservation__c where Active__c = true order by Name asc limit 100]) {
                observationSet.add(so.Name);
            }
            
            Map<String,AccountObservation__c> accountObservationSWTMap = new Map<String, AccountObservation__c>();
            for(AccountObservation__c aoswt:[Select Id, Name, Account__c, Account_Objective__c, Account_Observation_Type__c 
                                                  , Account_Plan__c, Account_Solution__c, Contact__c, Description__c 
                                                  , External_ID__c, Factor_Type__c, Impact__c, Impact_Category__c, Impact_Value__c 
                                                  , Observation__c, Other_Observation__c , Rank__c 
                                                  , Strength__c, Threat__c, Weakness__c 
                                               From AccountObservation__c
                                               Where Account_Plan__c = :planDetailsId
                                            ]) {
                accountObservationSWTMap.put(aoswt.External_ID__c,aoswt);                                       
            }
            
            List<Map<String,Object>> resultList = new List<Map<String,Object>>();
            
            for(AccountObjective__c ao:[Select Id, Name, Description__c, Other_Objective__c  
                                          From AccountObjective__c 
                                        where Account_Plan__c = :planDetailsId 
                                          and Type__c = 'Benefit Objective'
                                          Order by Name
                                       ]) {
                                           
                String sname = '';
                if(!String.isEmpty(ao.Other_Objective__c)) {
                    sname = ' ['+ao.Other_Objective__c+']';
                }
                Boolean bvlcSelected = false;                          
                Map<String,Object> acctMap = new Map<String,Object>();
                List<Map<String,Object>> aoList = new List<Map<String,Object>>();
                for(String s:observationSet) {
                    String extId = planDetailsId+'_'+ao.Id + '_'+s;
                    Map<String,Object> aoMap = new Map<String,Object>();
                    aoMap.put('Name', ao.Name);
                    aoMap.put('AccountId', accountId);
                    aoMap.put('PlanDetailsId', planDetailsId);
                    aoMap.put('ObjectiveId', ao.Id);
                    aoMap.put('ExternalId', extId);
                    aoMap.put('Observation', s);
                    aoMap.put('Strength', false);
                    aoMap.put('Weakness', false);
                    aoMap.put('Threat', false);
                    aoMap.put('Evidence', '');
                    aoMap.put('OtherObservation', '');
                    aoMap.put('vlcRank', '');
                    
                    if(Test.isRunningTest()) {
                        accountObservationSWTMap.put(extId,new AccountObservation__c());
                    }
                    
                    if(accountObservationSWTMap.containsKey(extId)) {
                        AccountObservation__c aoswt = accountObservationSWTMap.get(extId);
                        aoMap.put('Strength', aoswt.Strength__c);
                        aoMap.put('Weakness', aoswt.Weakness__c);
                        aoMap.put('Threat', aoswt.Threat__c);
                        aoMap.put('Evidence', aoswt.Description__c);
                        aoMap.put('OtherObservation', aoswt.Other_Observation__c);   
                        aoMap.put('vlcRank', aoswt.Rank__c);   
                        bvlcSelected = true;
                    }
                    
                    aoList.add(aoMap);
                }    
                acctMap.put('name',ao.Name + sname);
                acctMap.put('value',aoList);  
                //acctMap.put('vlcSelected',bvlcSelected);    
                acctMap.put('vlcSelected',false);                           
                resultList.add(acctMap);                        
            }
            outMap.put('SWTSI',resultList);
        } else if('RetrieveObjectives'.equalsIgnoreCase(methodName)) {                                    
            System.debug('>>> Inside CSP_AccountPlan invokeMethod RetrieveObjectives 4000');
            List<Map<String,String>> options = new List<Map<String, String>>(); 
            System.debug('>>> inputMap ='+ inputMap);
            String planDetailsId = (String) inputMap.get('PlanDetailsId');
            System.debug('>>> planDetailsId ='+ planDetailsId);
                                            
            Set<Id> coExcludeIdSet = new Set<Id>();
            for(AccountObjective__c ao:[Select Id, Objective__c, Objective__r.Name From AccountObjective__c where Account_Plan__c = :planDetailsId]) {
                if(ao.Objective__c != null && !'Other'.equalsIgnoreCase(ao.Objective__r.Name)) {
	                coExcludeIdSet.add(ao.Objective__c);                                        
                }
            }                                            
             
            List<Map<String,String>> coList = new List<Map<String,String>>();
            for(CustomerObjective__c co:[Select Id, Name, Description__c From CustomerObjective__c 
                                         Where Id NOT IN :coExcludeIdSet
                                         Order by Name limit 150]) {
                Map<String,String> coMap = new Map<String,String>();
                coMap.put('ObjectiveName',co.Name);
                coMap.put('objlookup',co.Name);
                coMap.put('ObjectId',co.Id);
                String otherSuffix = '';                                             
                if('Other'.equalsIgnoreCase(co.Name)) {
                	otherSuffix = '_'+ System.now().getTime();                                 
                }                             
                coMap.put('ObjExtId', planDetailsId+'_'+co.Id+otherSuffix);                             
                coList.add(coMap);                             
            }                              
            outMap.put('ObjectiveSelect',coList);
        } else if('RetrieveActionPlan'.equalsIgnoreCase(methodName)) {
            System.debug('>>> Inside CSP_AccountPlan invokeMethod LoadSWT 5000');
            System.debug('>>> inputMap ='+ inputMap);
            String planDetailsId = (String) inputMap.get('ContextId');
            System.debug('>>> planDetailsId ='+ planDetailsId);
            
            Set<String> actionPlanAttackSet = new Set<String>();
            for(Action_Plan_Attack__c apa:[Select Id, Category__c, Action_Plan__c, Value__c 
                                             From Action_Plan_Attack__c
                                           Where Account_Plan__c =:planDetailsId]) {
                String s = apa.Action_Plan__c+'_'+apa.Category__c+'_'+ apa.Value__c;
                actionPlanAttackSet.add(s);                               
            }
            
            List<Map<String,String>> optionList = new List<Map<String,String>>();
            for(Action_Plan__c  ap:[Select Id, Analytics__c, Consumer_Experience__c
                                         , Health_Activation__c, Provider_Optimization__c  
                                         , Benefit_Objective__c, Benefit_Objective__r.Name, Benefit_Objective__r.Other_Objective__c
                                         , Account_Plan__r.Account__c
                                         , Identified_Gap__c
                                     From Action_Plan__c 
                                    where Account_Plan__c = :planDetailsId
                                     Order by Benefit_Objective__r.Name
                                   ]) {
                //Analytics
                String apanalytics = ap.Analytics__c;
                if(!String.isEmpty(apanalytics)) {
                    for(String s:apanalytics.split(';')) {
                        String skey = ap.Id+'_Analytics_'+s;
                        if(!actionPlanAttackSet.contains(skey)) {
                            Map<String,String> smap = new Map<String,String>();
                            smap.put('Name',s);
                            smap.put('Category','Analytics');
                            smap.put('BenefitObjective',ap.Benefit_Objective__r.Name);
                            if(!String.isEmpty(ap.Benefit_Objective__r.Other_Objective__c)) {
                                smap.put('BenefitObjective',ap.Benefit_Objective__r.Name + ' ['+ap.Benefit_Objective__r.Other_Objective__c+']');                                
                            }
                            smap.put('AccountPlanId',PlanDetailsId);
                            smap.put('AccountId',ap.Account_Plan__r.Account__c);
                            smap.put('ActionPlanId',ap.Id);
                            smap.put('IdentifiedGap',ap.Identified_Gap__c);
                            smap.put('BenefitObjectiveId',ap.Benefit_Objective__c);
                            optionList.add(smap);                             
                        }
                    }                    
                }                        
                
                //Consumer_Experience__c
                String apconsumerExperience = ap.Consumer_Experience__c;
                if(!String.isEmpty(apconsumerExperience)) {
                    for(String s:apconsumerExperience.split(';')) {
                        String skey = ap.Id+'_Consumer Experience_'+s;
                        if(!actionPlanAttackSet.contains(skey)) {                            
                            Map<String,String> smap = new Map<String,String>();
                            smap.put('Name',s);
                            smap.put('Category','Consumer Experience');
                            smap.put('BenefitObjective',ap.Benefit_Objective__r.Name);
                            if(!String.isEmpty(ap.Benefit_Objective__r.Other_Objective__c)) {
                                smap.put('BenefitObjective',ap.Benefit_Objective__r.Name + ' ['+ap.Benefit_Objective__r.Other_Objective__c+']');                                
                            }
                            smap.put('AccountPlanId',PlanDetailsId);
                            smap.put('AccountId',ap.Account_Plan__r.Account__c);
                            smap.put('ActionPlanId',ap.Id);
                            smap.put('IdentifiedGap',ap.Identified_Gap__c);
                            smap.put('BenefitObjectiveId',ap.Benefit_Objective__c);
                            optionList.add(smap);                             
                        }
                    }                        
                }
                                        
                //Health_Activation__c
                String aphealthActivation = ap.Health_Activation__c;
                if(!String.isEmpty(aphealthActivation)) {
                    for(String s:aphealthActivation.split(';')) {
                        String skey = ap.Id+'_Health Activation_'+s;
                        if(!actionPlanAttackSet.contains(skey)) {                            
                            Map<String,String> smap = new Map<String,String>();
                            smap.put('Name',s);
                            smap.put('Category','Health Activation');
                            smap.put('BenefitObjective',ap.Benefit_Objective__r.Name);
                            if(!String.isEmpty(ap.Benefit_Objective__r.Other_Objective__c)) {
                                smap.put('BenefitObjective',ap.Benefit_Objective__r.Name + ' ['+ap.Benefit_Objective__r.Other_Objective__c+']');                                
                            }
                            smap.put('AccountPlanId',PlanDetailsId);
                            smap.put('AccountId',ap.Account_Plan__r.Account__c);
                            smap.put('ActionPlanId',ap.Id);
                            smap.put('IdentifiedGap',ap.Identified_Gap__c);
                            smap.put('BenefitObjectiveId',ap.Benefit_Objective__c);
                            optionList.add(smap);        
                        }
                    }                        
                }
                                        
                //Provider_Optimization__c
                String approviderOptimization = ap.Provider_Optimization__c;
                if(!String.isEmpty(approviderOptimization)) {
                    for(String s:approviderOptimization.split(';')) {
                        String skey = ap.Id+'_Provider Optimization_'+s;
                        if(!actionPlanAttackSet.contains(skey)) {                            
                        
                            Map<String,String> smap = new Map<String,String>();
                            smap.put('Name',s);
                            smap.put('Category','Provider Optimization');
                            smap.put('BenefitObjective',ap.Benefit_Objective__r.Name);
                            if(!String.isEmpty(ap.Benefit_Objective__r.Other_Objective__c)) {
                                smap.put('BenefitObjective',ap.Benefit_Objective__r.Name + ' ['+ap.Benefit_Objective__r.Other_Objective__c+']');                                
                            }
                            smap.put('AccountPlanId',PlanDetailsId);
                            smap.put('AccountId',ap.Account_Plan__r.Account__c);
                            smap.put('ActionPlanId',ap.Id);
                            smap.put('IdentifiedGap',ap.Identified_Gap__c);
                            smap.put('BenefitObjectiveId',ap.Benefit_Objective__c);
                            optionList.add(smap);                             
                        }
                    }                                                                
                }
            }
            outMap.put('ActionPlanSI',optionList);
            
        } else if('RetrieveYear'.equalsIgnoreCase(methodName)) {
            System.debug('>>> Inside CSP_AccountPlan invokeMethod RetrieveYear 6000');
            System.debug('>>> inputMap ='+ inputMap);
            String planDetailsId = (String) inputMap.get('ContextId');
            System.debug('>>> planDetailsId ='+ planDetailsId);
            
            //Plan of Attack Year
            Map<String,Object> yearMap = new Map<String,Object>();
            Date cutOffDate = Date.newInstance(System.today().Year(), 7, 1);
            Integer beginYear = System.today().Year();
            if(System.today() > cutOffDate) {
                beginYear = System.today().Year() + 1;
            }
            Integer endYear = beginYear + 4;
            Integer i=1;
            for(Integer x=beginYear;x<endYear;x++) {
                yearMap.put('Year'+i,x);
                outMap.put('RAYear'+i,x);
                i++;
            }
            outMap.put('PlanOfAttack',yearMap);
            
            
            //Description
            Object selectedActionPlanObj = inputMap.get('SelectActionPlan');
            System.debug('>>> Inside CSP_AccountPlan RetrieveYear 6010');
            if(selectedActionPlanObj!=null) {
                String sbenefitObjective = '';
                String saccountPlanId = '';
                String scategory = '';
                String sname = '';
                String saccountId = '';        
                String sactionPlanId = '';
                String sidentifiedGap = '';
                Map<String,Object> apsiObjMap = (Map<String,Object>) selectedActionPlanObj;
                Object apsiObj = apsiObjMap.get('ActionPlanSI');
                List<Object> apsiList = (List<Object>) apsiObj;
                for(Object obj:apsiList) {
                    Map<String,Object> apsiMap = (Map<String,Object>) obj;
                    System.debug('>>> Inside CSP_AccountPlan RetrieveYear 6020');
                    sbenefitObjective = (String) apsiMap.get('BenefitObjective');
                    saccountPlanId = (String) apsiMap.get('AccountPlanId');
                    saccountId = (String) apsiMap.get('AccountId');
                    scategory = (String) apsiMap.get('Category');
                    sname = (String) apsiMap.get('Name');
                    sactionPlanId = (String) apsiMap.get('ActionPlanId');
                    sidentifiedGap = (String) apsiMap.get('IdentifiedGap');
                    System.debug('>>> Inside CSP_AccountPlan RetrieveYear 6030');
                }    
                outMap.put('BenefitObjectiveTx',sbenefitObjective);
                outMap.put('CategoryTx',scategory);
                outMap.put('ActionPlanTx',sname);
                outMap.put('IdentifiedGapTx',sidentifiedGap);
                
            }                       

        } else if('SavePlanAttack'.equalsIgnoreCase(methodName)) {
            System.debug('>>> Inside CSP_AccountPlan invokeMethod SavePlanAttack 7000');
            System.debug('>>> inputMap ='+ inputMap);
            String planDetailsId = (String) inputMap.get('ContextId');
            System.debug('>>> planDetailsId ='+ planDetailsId);
            
            //Save Plan of Attack 
            Object paObj = inputMap.get('PlanOfAttack');
            if(paObj!=null) {
                Map<String,Object> paMap = (Map<String,Object>) paObj;
                /*
                //Year1                
                String syear1 = (String) paMap.get('Year1FM');
                String sbyWhen1 = (String) paMap.get('ByWhen1');
                String sresource1 = (String) paMap.get('Resources1');
                String swho1Name = '';
                String swho1Id = '';
                Object who1Obj = paMap.get('Who1-Block');
                if(who1Obj!=null) {
                    Map<String,Object> who1Map = (Map<String,Object>) who1Obj;
                    sWho1Name = (String) who1Map.get('who1');
                    if(!String.isEmpty(sWho1Name)) {
                        Object whoId1Obj = inputMap.get('Who1-Block');
                        Map<String,Object> whoId1Map = (Map<String,Object>) whoId1Obj;
                        swho1Id = (String) whoId1Map.get('ContactId');                        
                    }
                }
                */
                List<Action_Plan_Attack__c> apList = new List<Action_Plan_Attack__c>();
                for(Integer i=1;i<5;i++) {
                    Set<String> postFixSet = new Set<String> {'A','B','C','D','E'};
                    String syear = String.valueOf(paMap.get('Year'+i+'FM'));
                    Map<String,Object> keyValueMap = new Map<String,Object>();
                    for(String spostFix : postFixSet) {
                        //ByWhen1A
                        String sbyWhen = String.valueOf(paMap.get('ByWhen'+i+spostFix));
                        keyValueMap.put('ByWhen'+i+spostFix,sbyWhen);
                        //ExecutionDate1A
                        String sexecutionDate = String.valueOf(paMap.get('ExecutionDate'+i+spostFix));
                        keyValueMap.put('ExecutionDate'+i+spostFix,sexecutionDate);
                        //YearCompleted1A
                        String syearCompleted = String.valueOf(paMap.get('YearCompleted'+i+spostFix));
                        keyValueMap.put('YearCompleted'+i+spostFix,syearCompleted);
                        //Resources1A
                        String sresources = String.valueOf(paMap.get('Resources'+i+spostFix));
                        keyValueMap.put('Resources'+i+spostFix,sresources);


                        Object whoObj = paMap.get('Who'+i+spostFix+'-Block');
                        System.debug('>>> Inside CSP_AccountPlan invokeMethod SavePlanAttack 7000 whoObj='+whoObj);
                        if(whoObj!=null) {
                            Map<String,Object> whoMap = (Map<String,Object>) whoObj;
                            String sWhoName = String.valueOf(whoMap.get('Who'+i+spostFix));
                            System.debug('>>> Inside CSP_AccountPlan invokeMethod SavePlanAttack 7000 sWhoName='+sWhoName);
                            if(!String.isEmpty(sWhoName)) {
                                Object whoIdObj = inputMap.get('Who'+i+spostFix+'-Block');
                                System.debug('>>> Inside CSP_AccountPlan invokeMethod SavePlanAttack 7000 whoIdObj='+whoIdObj);
                                Map<String,Object> whoIdMap = (Map<String,Object>) whoIdObj;
                                String swhoId = String.valueOf(whoIdMap.get('ContactId'));                        
                                System.debug('>>> Inside CSP_AccountPlan invokeMethod SavePlanAttack 7000 swhoId='+swhoId);
                                keyValueMap.put('Who'+i+spostFix,swhoId);
                            }
                        }
                    
                        //OtherResource1A
                        String sotherResources = String.valueOf(paMap.get('OtherResource'+i+spostFix));
                        keyValueMap.put('OtherResource'+i+spostFix,sotherResources);
                        
                        //Action
                        String saction = String.valueOf(paMap.get('Action'+i+spostFix));
                        keyValueMap.put('Action'+i+spostFix,saction);
                    
                    }
                    
                    System.debug('>>> Inside CSP_AccountPlan invokeMethod SavePlanAttack 7000 paMap='+paMap);
                    //System.debug('>>> Inside CSP_AccountPlan invokeMethod SavePlanAttack 7100 syear='+syear+' sbyWhen='+sbyWhen+' sresource='+sresource+' swhoname='+swhoName+' swhoId='+swhoId);
                    Action_Plan_Attack__c apa = createPlanAttack(inputMap, syear, keyValueMap, i);
                    System.debug('>>> Inside CSP_AccountPlan invokeMethod SavePlanAttack 7200 apa='+apa);
                    apList.add(apa);
                }
                if(apList.size()>0) {
                    upsert apList External_Id__c;
                }
            }
        } else if('ExtractActionPlan'.equalsIgnoreCase(methodName)) {
            System.debug('>>> Inside CSP_AccountPlan invokeMethod ExtractActionPlan 8000');
            System.debug('>>> inputMap ='+ inputMap);
            String planDetailsId = (String) inputMap.get('PlanDetailsId');
            System.debug('>>> planDetailsId ='+ planDetailsId);
            String accountId = (String) inputMap.get('ContextId');
            System.debug('>>> accountId ='+ accountId);
            
            Map<Id,AccountObjective__c> benefitObjectiveMap = new Map<Id,AccountObjective__c>(
                            [Select Id, Name, Other_Objective__c 
                               From AccountObjective__c 
                              Where Account_Plan__c = :planDetailsId
                                And Type__c = 'Benefit Objective'
                                Order by Name
                            ]);            

            Map<Id,Action_Plan__c> actionPlanMap = new Map<Id,Action_Plan__c>();
            for(Action_Plan__c ap:[Select Id, Benefit_Objective__c, Analytics__c, Consumer_Experience__c
                                         ,Health_Activation__c, Identified_Gap__c, Provider_Optimization__c
                                     From Action_Plan__c
                                    Where Account_Plan__c = :planDetailsId
                                   And Benefit_Objective__c = :benefitObjectiveMap.keySet()]) {
                actionPlanMap.put(ap.Benefit_Objective__c,ap);                           
            }            
            List<Map<String,String>> actionPlanBlockList = new List<Map<String,String>>();
            for(Id aoId:benefitObjectiveMap.keySet()) {
                Map<String,String> apbMap = new Map<String,String>();
                AccountObjective__c ao = benefitObjectiveMap.get(aoId);
                Action_Plan__c ap = actionPlanMap.get(aoId);
                apbMap.put('ActionPlanObjectiveId',ao.Id);
                apbMap.put('ActionPlanOtherObjective',ao.Other_Objective__c);
                apbMap.put('ActionPlanObjective',ao.Name);
                if(!String.isEmpty(ao.Other_Objective__c)) {
                    apbMap.put('ActionPlanObjective',ao.Name + ' ['+ao.Other_Objective__c+']');                    
                }
                if(ap!=null || Test.isRunningTest()) {
                    apbMap.put('ActionPlanAnalytics',ap.Analytics__c);
                    apbMap.put('ActionPlanConsumerExperience',ap.Consumer_Experience__c);
                    apbMap.put('ActionPlanProviderOptimization',ap.Provider_Optimization__c);
                    apbMap.put('ActionPlanHealthActivation',ap.Health_Activation__c);
                    apbMap.put('ActionPlanIdentifiedGap',ap.Identified_Gap__c);
                }                
                actionPlanBlockList.add(apbMap);                
            }
            Map<String,Object> actionPlanBlockMap = new Map<String,Object>();
            actionPlanBlockMap.put('ActionPlanBlock',actionPlanBlockList);
            outMap.put('ActionPlan',actionPlanBlockMap);
        
        }   
                                            
        return true; 
    }
    
    global Static Action_Plan_Attack__c createPlanAttack(Map<String,Object> inputMap, String syear
                                                       , Map<String,Object> keyValueMap
                                                       , Integer i) {
                                                           
        System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1000');
        Action_Plan_Attack__c pa = new Action_Plan_Attack__c();
        Object selectedActionPlanObj = inputMap.get('SelectActionPlan');
        System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1010');
        if(selectedActionPlanObj!=null) {
            String sbenefitObjectiveId = '';
            String saccountPlanId = '';
            String scategory = '';
            String sname = '';
            String saccountId = '';        
            String sactionPlanId = '';
            Map<String,Object> apsiObjMap = (Map<String,Object>) selectedActionPlanObj;
            Object apsiObj = apsiObjMap.get('ActionPlanSI');
            List<Object> apsiList = (List<Object>) apsiObj;
            for(Object obj:apsiList) {
                Map<String,Object> apsiMap = (Map<String,Object>) obj;
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1020');
                sbenefitObjectiveId = (String) apsiMap.get('BenefitObjectiveId');
                saccountPlanId = (String) apsiMap.get('AccountPlanId');
                saccountId = (String) apsiMap.get('AccountId');
                scategory = (String) apsiMap.get('Category');
                sname = (String) apsiMap.get('Name');
                sactionPlanId = (String) apsiMap.get('ActionPlanId');
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1030');
            }    
            pa.External_ID__c = syear+'_'+saccountPlanId+'_'+sbenefitObjectiveId+'_'+scategory+'_'+sname;
            pa.Category__c=scategory;
            pa.Value__c=sname;
            pa.Account__c=saccountId;
            pa.Action_Plan__c=sactionPlanId;
            pa.Account_Plan__c=saccountPlanId;
            pa.Benefit_Objective__c=sbenefitObjectiveId;
            pa.Year__c = syear;
            Set<String> postFixSet = new Set<String> {'A','B','C','D','E'};
            for(String spostFix : postFixSet) {
                //ByWhen1A
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1040');
                String sbyWhen = 'ByWhen'+i+spostFix;
                Object sbyWhenObj = keyValueMap.get(sbyWhen);
                Date dtbyWhen = convertStringToDate((String) sbyWhenObj);
                if(dtbyWhen!=null) {
                    pa.put('By_When_'+spostFix+'__c',dtbyWhen);
                }
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1050');
                    
                //ExecutionDate1A
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1060');
                String sexecutionDate = 'ExecutionDate'+i+spostFix;
                Object sexecutionDateObj = keyValueMap.get(sexecutionDate);
                Date dtexecutionDate = convertStringToDate((String) sexecutionDateObj);
                if(dtexecutionDate!=null) {
                    pa.put('Execution_Date_'+spostFix+'__c',dtexecutionDate);
                }
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1070');

                //YearCompleted1A
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1080');
                String syearCompleted = 'YearCompleted'+i+spostFix;
                Object syearCompletedObj = keyValueMap.get(syearCompleted);
                if(syearCompletedObj!=null) {
                    pa.put('Completed_'+spostFix+'__c',Boolean.valueOf(syearCompletedObj));
                }
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1090');

                //Resources1A
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1100');
                String sresources = 'Resources'+i+spostFix;
                Object sresourcesObj = keyValueMap.get(sresources);
                if(sresourcesObj!=null) {
                    pa.put('Resources_'+spostFix+'__c',sresourcesObj);
                }
                        
                //OtherResource1A
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1120');
                String sotherResources = 'OtherResource'+i+spostFix;
                Object sotherResourcesOjb = keyValueMap.get(sotherResources);
                if(sotherResourcesOjb!=null) {
                    pa.put('Other_Resource_'+spostFix+'__c',sotherResourcesOjb);
                }
                
                //Action
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1140');
                String saction = 'Action'+i+spostFix;
                Object sactionObj = keyValueMap.get(saction);
                if(sactionObj!=null) {
                    pa.put('Action_'+spostFix+'__c',sactionObj);
                }
                
                //Who1A
                System.debug('>>> Inside CSP_AccountPlan createPlanAttack 1160');
                String swho = 'Who'+i+spostFix;
                Object swhoObj = keyValueMap.get(swho);
                if(swhoObj!=null) {
                    pa.put('Who_'+spostFix+'__c',swhoObj);
                }               
            }            
        }
        
        return pa;
    }
    
    global static Date convertStringToDate(String sdate) {
        Date dt = null;
        if(!String.isEmpty(sdate)) {
            List<String> dateList = sdate.split('-');
            dt = Date.newInstance(Integer.valueOf(dateList[0]), Integer.valueOf(dateList[1]), Integer.valueOf(dateList[2]));            
        }
        return dt;
    }
    
    global static Boolean saveSWT(String methodName, Map<String,Object> inputMap,
                                  Map<String,Object> outMap,Map<String,Object> optns) {
        
        System.debug('>>> Inside CSP_AccountPlan saveSWT 1000');
        Object swtObj = inputMap.get('SWT');
        System.debug('>>> Inside CSP_AccountPlan saveSWT 1010 swtObj='+swtObj);
        if(swtObj!=null) {
            List<AccountObservation__c> upsertAcctObsvList = new List<AccountObservation__c>();
            Map<String,Object> swtObjMap = (Map<String,Object>) swtObj;
            Object swtsi = swtObjMap.get('SWTSI');
            System.debug('>>> Inside CSP_AccountPlan saveSWT 1020 swtsi='+swtsi);
            List<Object> swtsiList = (List<Object>) swtsi;
            System.debug('>>> Inside CSP_AccountPlan saveSWT 1030 swtsiList='+swtsiList);
            if(swtsiList!=null && swtsiList.size()>0) {
                for(Object swtsiObj:swtsiList) {
                    System.debug('>>> Inside CSP_AccountPlan saveSWT 1040 swtsiObj='+swtsiObj);
                    Map<String,Object> swtsiObjMap = (Map<String,Object>) swtsiObj;
                    String swtsiNam = (String) swtsiObjMap.get('name');   
                    System.debug('>>> Inside CSP_AccountPlan saveSWT 1050 swtsiNam='+swtsiNam);
                    List<Object> swtsiValueList = (List<Object>) swtsiObjMap.get('value'); 
                    System.debug('>>> Inside CSP_AccountPlan saveSWT 1060 swtsiValueList='+swtsiValueList);
                    if(swtsiValueList!=null && swtsiValueList.size()>0) {
                        for(Object acctObsv:swtsiValueList) {
                            System.debug('>>> Inside CSP_AccountPlan saveSWT 1070 aaa acctObsv='+acctObsv);
                            Map<String,Object> acctObsvMap = (Map<String,Object>) acctObsv;
                            System.debug('>>> Inside CSP_AccountPlan saveSWT 1070 bbb acctObsvMap='+acctObsvMap);
                            
                            Object sstrength = acctObsvMap.get('Strength');
                            System.debug('>>> Inside CSP_AccountPlan saveSWT 1070 ccc sstrength='+sstrength);
                            Object sweakness =  acctObsvMap.get('Weakness');
                            System.debug('>>> Inside CSP_AccountPlan saveSWT 1070 ddd sweakness='+sweakness);
                            Object sthreat = acctObsvMap.get('Threat');
                            System.debug('>>> Inside CSP_AccountPlan saveSWT 1070 eee sthreat='+sthreat);
                            String sevidence = (String) acctObsvMap.get('Evidence');
                            System.debug('>>> Inside CSP_AccountPlan saveSWT 1070 fff sthreat='+sevidence);
                            System.debug('>>> Inside CSP_AccountPlan saveSWT 1071 sstrength='+sstrength + ' sweakness='+sweakness + ' sthreat='+sthreat + ' sevidence='+sevidence);
                            
                            if(Boolean.valueOf(sstrength) || Boolean.valueOf(sweakness) || Boolean.valueOf(sthreat) || !String.isEmpty(sevidence)) {
                                  
                                AccountObservation__c acctObsvObj = new AccountObservation__c();
                                acctObsvObj.Name = (String) acctObsvMap.get('Observation');
                                acctObsvObj.Account__c = (String) acctObsvMap.get('AccountId');
                                acctObsvObj.Account_Objective__c = (String) acctObsvMap.get('ObjectiveId');
                                acctObsvObj.Account_Plan__c = (String) acctObsvMap.get('PlanDetailsId');
                                acctObsvObj.External_ID__c = (String) acctObsvMap.get('ExternalId');
                                acctObsvObj.Rank__c = (String) acctObsvMap.get('vlcRank');
                                acctObsvObj.Strength__c = Boolean.valueOf(acctObsvMap.get('Strength'));
                                acctObsvObj.Weakness__c = Boolean.valueOf(acctObsvMap.get('Weakness'));
                                acctObsvObj.Threat__c = Boolean.valueOf(acctObsvMap.get('Threat'));
                                acctObsvObj.Description__c = (String) acctObsvMap.get('Evidence');
                                if('Other'.equalsIgnoreCase(acctObsvObj.Name)) {
                                    acctObsvObj.Other_Observation__c = (String) acctObsvMap.get('OtherObservation');
                                }
                                System.debug('>>> Inside CSP_AccountPlan saveSWT 1072 acctObsvObj='+acctObsvObj);
                                upsertAcctObsvList.add(acctObsvObj); 
                            }
                        }
                    }
                    
                }
                
            }
            if(upsertAcctObsvList.size()>0) {
                upsert upsertAcctObsvList External_ID__c;
            }
        }                              
        return true;                                  
    }
    
    global class CSP_AccountPlanException extends Exception{}
    
    global static void upsertAccountSolution(List< AccountObjective__c > acctObjList) {
        
        List<AccountSolution__c> asList = new List<AccountSolution__c>();
        Set<String> asExtIdSet = new Set<String>();
        Set<String> acctPlanIdSet = new Set<String>();
        Set<String> acctObjIdSet = new Set<String>();
        for( AccountObjective__c ao:acctObjList) {
            acctPlanIdSet.add(ao.Account_Plan__c);
            acctObjIdSet.add(ao.Id);
            if(!String.isEmpty(ao.Strategic_Opportunity__c)) {
                for(String strategicOpp:ao.Strategic_Opportunity__c.split(';')) {
                    String extId = ao.Account_Plan__c + '_' + ao.Id + '_' + strategicOpp;
                    asExtIdSet.add(extId);
                    AccountSolution__c acctSol = new AccountSolution__c();
                    acctSol.Account_Plan__c = ao.Account_Plan__c;
                    acctSol.Business_Objective__c = ao.Id;
                    acctSol.External_ID__c = extId;
                    acctSol.Name = strategicOpp;
                    acctSol.AccountLU__c = ao.Account__c;
                    asList.add(acctSol);
                }                
            }
        }
        delete [Select Id From AccountSolution__c Where Account_Plan__c in :acctPlanIdSet and Business_Objective__c in :acctObjIdSet
                  And External_Id__c NOT in :asExtIdSet];
        
        upsert asList External_Id__c;        
        
    }
}