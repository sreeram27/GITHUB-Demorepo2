/*
    Name        :   JIRAToSFDCSyncBatch
    Description :   Syncs JIRA issues of EWM project to salesforce objects. This is scheduled to run nightly
    Author      :   Deloitte
*/
public class JIRAToSFDCSyncBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable,Database.Stateful { 
    
    public String queryStr;
    public String JiraValue4Request;
    public String JiraValue4Instance;
    public String JiraValue4Subtask;
    public class ErrorResponse {
        public List<String> errorMessages;
        public Errors errors;
    }
    
    public class Errors {
  
    }
    Map<String, List<String>> issueTypeVSFieldsToQuery = new Map<String, List<String>>();
    
    public Map<Id, String> errorMap {get; set;}
    public Map<Id, SObject> IdToSObjectMap {get; set;}
     public Map<Id, String> successMap{get; set;}
    public Map<Id, SObject> SuccessIdToSObjectMap{get; set;}
    public Integer successcount=0;
    public Integer failurecount=0;
    //  Fields mappings are fetched from Custom Metadata : Field_Mapping__mdt
    public List<Field_Mapping__mdt> ITList = [Select DeveloperName, Type__c, Object_Type__c, JIRA_Field_Label__c, Jira_Field_API_Name__c, SFDC_Field_API__c, SFDC_Field_Label__c, SFDC_Object_API_Name__c, Default_Value__c, Value__c From Field_Mapping__mdt Where Type__c =: LGJiraValueSet.JIRA2SF AND SFDC_Object_API_Name__c =: LGJiraValueSet.ImplementationTracking];
    public List<Field_Mapping__mdt> MBList = [Select DeveloperName, Type__c, Object_Type__c, JIRA_Field_Label__c, Jira_Field_API_Name__c, SFDC_Field_API__c, SFDC_Field_Label__c, SFDC_Object_API_Name__c, Default_Value__c, Value__c From Field_Mapping__mdt Where Type__c =: LGJiraValueSet.JIRA2SF AND SFDC_Object_API_Name__c =: LGJiraValueSet.MedicalBenefit];
    
    public JIRAToSFDCSyncBatch() {
        errorMap=new Map<Id, String> ();
        IdToSObjectMap=new Map<Id, SObject>();
        successMap=new Map<Id, String> ();
        SuccessIdToSObjectMap=new Map<Id, SObject>();
        queryStr = 'Select Id,Status_At_EBA_Request_Level__c,Overall_Status__c, Name, JIRA_Request_ID__c From Implementation_Tracking__c where Overall_Status__c != \'Completed\' AND Overall_Status__c != \'Cancelled\' AND JIRA_Request_ID__c != null';
        //queryStr = 'Select Id,Status_At_EBA_Request_Level__c,Overall_Status__c, Name, JIRA_Request_ID__c From Implementation_Tracking__c where Overall_Status__c != \'Completed\' AND Overall_Status__c != \'Cancelled\' AND JIRA_Request_ID__c != null and Status_At_EBA_Request_Level__c !=\'Closed\'';
    
    }
    
    public JIRAToSFDCSyncBatch(String recId) {
        errorMap=new Map<Id, String> ();
        IdToSObjectMap=new Map<Id, SObject>();
         successMap=new Map<Id, String> ();
        SuccessIdToSObjectMap=new Map<Id, SObject>();
        queryStr = 'Select Id,Status_At_EBA_Request_Level__c,Overall_Status__c, Name, JIRA_Request_ID__c From Implementation_Tracking__c where Overall_Status__c != \'Completed\' AND Overall_Status__c != \'Cancelled\' AND JIRA_Request_ID__c != null AND id= \''+recId+'\'';
        //queryStr = 'Select Id,Status_At_EBA_Request_Level__c,Overall_Status__c, Name, JIRA_Request_ID__c From Implementation_Tracking__c where Overall_Status__c != \'Completed\' AND Overall_Status__c != \'Cancelled\' AND JIRA_Request_ID__c != null AND id= \''+recId+'\' and Status_At_EBA_Request_Level__c !=\'Closed\'';
    
    }
    
    //  Start method of the batch, which queries all Implementation Tracking records and sends to execute method in chunks for processing 
    public Database.QueryLocator start(Database.BatchableContext BC) { 
        
        //String q = 'Select Id, Name, JIRA_Request_ID__c From Implementation_Tracking__c where Id = \'a6pW00000007YqWIAU\' AND Overall_Status__c != \'Completed\' AND Overall_Status__c != \'Cancelled\' AND JIRA_Request_ID__c != null';
        //String q = 'Select Id, Name, JIRA_Request_ID__c From Implementation_Tracking__c where Id = \'a6pW00000007XSTIA2\' AND Overall_Status__c != \'Completed\' AND Overall_Status__c != \'Cancelled\' AND JIRA_Request_ID__c != null';
        
        String q = queryStr;
        

        return Database.getQueryLocator(q);
    }
    
    //  Execute method: fetches detais, linked issues and subTasks of linked issues from JIRA and updates the same into salesforce objects(Implementation Tracking anf Medical Benefits objects)
    public void execute(Database.BatchableContext BC, List<Implementation_Tracking__c> scope) {
        
        List<Medical_Benefit__c> updateMBList = new List<Medical_Benefit__c>();
        List<Medical_Benefit__c> MBItemList = new List<Medical_Benefit__c>();
        List<String> issueLinks = new List<String>();
        LGJiraUtility jiraCtrler = new LGJiraUtility();
        savepoint sp;
       
        try
        {
        String responseStr;
        
       if(!test.isrunningtest())
        {
            HttpResponse resp = jiraCtrler.GetIssue(scope[0].JIRA_Request_ID__c, true);
            if(resp.getStatusCode() != 200) {
                String responseBody = resp.getBody();
                
                ErrorResponse errResp = (ErrorResponse)JSON.deserialize(responseBody, ErrorResponse.class);
                
                throw new CustomException(errResp.errorMessages[0]);
            } else {
                responseStr = '{"Response" : ' + resp.getBody() +'}';
            }
        }
        else
        {
           
            responseStr = '{"Response" : ' + JiraValue4Request  +'}';
        }
        JIRAIssueResponse_Instance parsedResp = (JIRAIssueResponse_Instance)JSON.deserialize(responseStr, JIRAIssueResponse_Instance.class);//JIRAIssueResponse_Instance.parse(resp);

        String issueType;

        if (parsedResp.Response.fields.customfield_11500 != null) {
            issueType = parsedResp.Response.fields.customfield_11500.value;
        }

        system.debug(Logginglevel.ERROR, '---- show issueType ---- : ' + issueType);
        
        //  Get Linked Issues 
        Set<JIRAIssueResponse_Instance> issueLinksResp = new Set<JIRAIssueResponse_Instance>();
        List<JIRAIssueResponse_Instance> subTaskResp = new List<JIRAIssueResponse_Instance>();
        Map<String, List<String>> subTaskIdsMap = new Map<String, List<String>>();
        Map<String, List<JIRAIssueResponse_Instance>> subTaskMap = new Map<String, List<JIRAIssueResponse_Instance>>();
        Map<String, Medical_Benefit__c> MBMap = new Map<String, Medical_Benefit__c>();
        
        Map<String, Date> BCSDatemap = new Map<String, Date>();
        Map<String, Date> BCECDmap = new Map<String, Date>();
        Map<String, Date> BCACDmap = new Map<String, Date>();
        Map<String, Date> BEPDatemap = new Map<String, Date>();
        Map<String, Date> BTSDatemap = new Map<String, Date>();
        Map<String, Date> BTACDmap = new Map<String, Date>();
        

        system.debug(Logginglevel.ERROR, '------show Main issue reslut JSON: ------' + parsedResp);
        system.debug(parsedResp.response.fields.issuelinks);
        for(JIRAIssueResponse_Instance.IssueLinks IL : parsedResp.response.fields.issuelinks) {
            system.debug(IL.outwardIssue);
            issueLinks.add(IL.outwardIssue.key);
        }
        system.debug(Logginglevel.ERROR, '------issue links----------'+issueLinks);

        
        MBItemList = [Select EPID_s_Assigned__c,Id, JIRA_Request_ID__c, Benefit_Coding_Start_Date__c, EPID_Product_Config_Submission_Date__c, 
                    Benefit_Coding_ACD__c, Benefit_Coding_ECD__c, Auto_Adjudication_ACD__c, EPID_Product_Config_Approval_Date__c, 
                    Benefit_Testing_ACD__c, Auto_Adjudication_Required__c, Blue_Exchange_Production_Date__c, Benefit_Testing_Start_Date__c, 
                    Clean_Paperwork__c, Auto_Adjudication_ECD__c From Medical_Benefit__c Where JIRA_Request_ID__c IN: issueLinks]; //
        /*
        MBItemList = [Select EPID_s_Assigned__c,Id, JIRA_Request_ID__c, Benefit_Coding_Start_Date__c, EPID_Product_Config_Submission_Date__c, 
                    Benefit_Coding_ACD__c, Benefit_Coding_ECD__c, Auto_Adjudication_ACD__c, EPID_Product_Config_Approval_Date__c, 
                    Benefit_Testing_ACD__c, Auto_Adjudication_Required__c, Blue_Exchange_Production_Date__c, Benefit_Testing_Start_Date__c, 
                    Auto_Adjudication_ECD__c From Medical_Benefit__c Where JIRA_Request_ID__c IN: issueLinks]; //
       */
            
        for (Medical_Benefit__c mpItem : MBItemList) {

            MBMap.put(mpItem.JIRA_Request_ID__c, mpItem);
        }
        

        //  Fetch info of linked issues from JIRA
        for(String issueId : issueLinks) {
          String responseStrlinkedIssue;
          //HttpResponse resp;
            //HttpResponse resplinkedIssue= jiraCtrler.GetIssue(issueId,true);
            if(!test.isrunningtest())
            {
                HttpResponse resplinkedIssue= jiraCtrler.GetIssue(issueId,true);
                if(resplinkedIssue.getStatusCode() != 200) {
                    String responseBody = resplinkedIssue.getBody();
            
                    ErrorResponse errResp = (ErrorResponse)JSON.deserialize(responseBody, ErrorResponse.class);
            
                    throw new CustomException(errResp.errorMessages[0]);
                } else {
                    responseStrlinkedIssue = '{"Response" : ' + resplinkedIssue.getBody() +'}';
                }
            } else {

                
                responseStrlinkedIssue= '{"Response" : ' + JiraValue4Instance  +'}';
            }
            //JIRAIssueResponse_Instance res = JIRAIssueResponse_Instance.parse(instanceRes); 
            
            JIRAIssueResponse_Instance res = (JIRAIssueResponse_Instance)JSON.deserialize(responseStrlinkedIssue, JIRAIssueResponse_Instance.class);
            
            issueLinksResp.add(res);
            
            List<String> subTaskIds = new List<String>();
            //  Collect SubTask Ids into a map
            //for(JIRAIssueResponse_Instance.IssueLinks il : res.Response.fields.issuelinks)
            //    subTaskIds.add(il.inwardIssue.key);
            
            /*for(JIRAIssueResponse_Instance.InwardIssue subTask : res.Response.fields.subtasks)
            	subTaskIds.add(subTask.key);
            */
            
            //Logic to Exclude Issue Log Sub Task Type
            for(JIRAIssueResponse_Instance.InwardIssue subTask : res.Response.fields.subtasks)
            {
                System.debug('Subtask Type : '+subTask.fields.issuetype.name);
                if(subTask.fields.issuetype.name != LGJiraValueSet.EWMIssueLog)
                {
                 subTaskIds.add(subTask.key);
                }
            }
                
            
            subTaskIdsMap.put(issueId, subTaskIds);
            system.debug(Logginglevel.ERROR, '------sub tasks single----------'+subTaskIdsMap);
        }
        
        system.debug(Logginglevel.ERROR, '------sub tasks----------'+subTaskIdsMap);
        
        
        
        for(String keyId : subTaskIdsMap.keySet()) {

            subTaskResp = new List<JIRAIssueResponse_Instance>();
            List<Date> bcsdList = new List<Date>();
            List<Date> ecdList = new List<Date>(); 
            List<Date> acdList = new List<Date>();
            List<Date> bepdList = new List<Date>();
            List<Date> btsdList = new List<Date>();
            List<Date> btacdList = new List<Date>();

            for (String issueId : subTaskIdsMap.get(keyId)) {
                
                 String responseStrlinkedIssueTask;
                 
                 
                //HttpResponse resplinkedIssueTask = jiraCtrler.GetIssue(issueId,true);
                if(!test.isrunningtest())
                {
                	HttpResponse resplinkedIssueTask = jiraCtrler.GetIssue(issueId,true);
                    if(resplinkedIssueTask.getStatusCode() != 200) {
                        String responseBody = resplinkedIssueTask.getBody();
                        
                        ErrorResponse errResp = (ErrorResponse)JSON.deserialize(responseBody, ErrorResponse.class);
                        
                        throw new CustomException(errResp.errorMessages[0]);
                    } else {
                        responseStrlinkedIssueTask = '{"Response" : ' + resplinkedIssueTask.getBody() +'}';
                    }
                } else {
            
                    responseStrlinkedIssueTask= '{"Response" : ' + JiraValue4Subtask  +'}';
                }
              
              
                //system.debug(Logginglevel.ERROR, '------Instance JSON----------'+instanceRes);
                //JIRAIssueResponse_Instance res = JIRAIssueResponse_Instance.parse(instanceRes); 
                JIRAIssueResponse_Instance res = (JIRAIssueResponse_Instance)JSON.deserialize(responseStrlinkedIssueTask, JIRAIssueResponse_Instance.class);

                Object bcsd;
                Object ecd;
                Object acd;
                Object bepd;
                Object btsd;
                Object btacd;


                if (issueType == LGJiraValueSet.WGS) {
                    //Benefit Coding Start Date WGS
                    bcsd = res.response.fields.getValue('customfield_11667');

                    //Benefit Coding ECD WGS
                    ecd = res.response.fields.getValue('customfield_11679');

                    //Benefit Coding ACD WGS
                    acd= res.response.fields.getValue('customfield_11462');

                } else if (issueType == LGJiraValueSet.NASCO) {

                    //Benefit Coding Start Date Nasco
                    bcsd = res.response.fields.getValue('customfield_11602');

                    //Benefit Coding ECD Nasco
                    ecd = res.response.fields.getValue('customfield_11601');

                    //Benefit Coding ACD Nasco
                    acd = res.response.fields.getValue('customfield_11542');

                    //Blue Exchange Production Date Nasco
                    bepd = res.response.fields.getValue('customfield_11583');

                    //Benefit Testing Start Date Nasco
                    btsd = res.response.fields.getValue('customfield_11607');

                    //Benefit Testing ACD Nasco
                    btacd = res.response.fields.getValue('customfield_11606');

                }
                if (bcsd != null) {
                    bcsdList.add(Date.valueOf(String.valueOf(bcsd)));
                }

                if (ecd != null) {
                    ecdList.add(Date.valueOf(String.valueOf(ecd)));
                }

                if (acd != null) {
                    acdList.add(Date.valueOf(String.valueOf(acd)));
                }

                if (bepd != null) {
                    bepdList.add(Date.valueOf(String.valueOf(bepd)));
                }

                if (btsd != null) {
                    btsdList.add(Date.valueOf(String.valueOf(btsd)));
                }

                if (btacd != null) {
                    btacdList.add(Date.valueOf(String.valueOf(btacd)));
                }

                subTaskResp.add(res);
            }


        
            subTaskMap.put(keyId, subTaskResp);

            if (!bcsdList.isEmpty()) {
                //LGJiraSortDate sortItem = new LGJiraSortDate(bcsdList);
                bcsdList.sort();
                BCSDatemap.put(keyId, bcsdList.get(0));
            }

            if (!ecdList.isEmpty()) {
                //LGJiraSortDate sortItem = new LGJiraSortDate(ecdList);

                ecdList.sort();
                if (issueType == LGJiraValueSet.WGS) {
                    
                    BCECDmap.put(keyId, ecdList.get(0));
                } else if (issueType == LGJiraValueSet.NASCO) {

                    BCECDmap.put(keyId, ecdList.get(ecdList.size()-1));
                }
            }

            if (!acdList.isEmpty()) {
                //LGJiraSortDate sortItem = new LGJiraSortDate(acdList);
                acdList.sort();
                BCACDmap.put(keyId, acdList.get(acdList.size()-1));
            }

            if (!bepdList.isEmpty()) {
                //LGJiraUtility.SortDate sortItem = jiraCtrler.SortDate(bepdList);
                BEPDatemap.put(keyId, bepdList.get(0));
            }

            if (!btsdList.isEmpty()) {
                //LGJiraSortDate sortItem = new LGJiraSortDate(btsdList);
                btsdList.sort();
                BTSDatemap.put(keyId, btsdList.get(0));
            }

            if (!btacdList.isEmpty()) {
                //LGJiraSortDate sortItem = new LGJiraSortDate(btacdList);
                btacdList.sort();
                BTACDmap.put(keyId, btacdList.get(btacdList.size()-1));
            }

            system.debug(Logginglevel.ERROR, '------show bcsdList ------ ** '+BCSDatemap);
            system.debug(Logginglevel.ERROR, '------show ecdList ------ ** '+BCECDmap);
            system.debug(Logginglevel.ERROR, '------show acdList ------ ** '+BCACDmap);
            //system.debug(Logginglevel.ERROR, '------show bepdList ------ ** '+BCACDmap);
            system.debug(Logginglevel.ERROR, '------show btsdList ------ ** '+BTSDatemap);
            system.debug(Logginglevel.ERROR, '------show btacdList ------ ** '+BTACDmap);


        }


        system.debug(Logginglevel.ERROR, '------show issue links reslut JSON: ------'+issueLinksResp);
        system.debug(Logginglevel.ERROR, '------show sub task reslut JSON: ------'+subTaskResp);
        //  Store parent issue info into Implementation Tracking object
        for (Field_Mapping__mdt fieldItem: ITList) {

            if (fieldItem.Default_Value__c == null || issueType == fieldItem.Default_Value__c) {

                Object obj = parsedResp.response.fields.getValue(fieldItem.Jira_Field_API_Name__c);

                if (obj != null) {

                    system.debug(Logginglevel.ERROR, '------show field value : ------'+fieldItem.Jira_Field_API_Name__c + ' ** ' + obj);
                    

                    if (fieldItem.Object_Type__c == 'text') {

                        scope[0].put(fieldItem.SFDC_Field_API__c, String.valueOf(obj));

                    } else if (fieldItem.Object_Type__c == 'date') {

                        scope[0].put(fieldItem.SFDC_Field_API__c, Date.valueOf(String.valueOf(obj)));

                    } else if (fieldItem.Object_Type__c == 'reporter') {

                        String reporterStr = String.valueOf(obj).substringBetween('displayName=', ', emailAddress');

                        scope[0].put(fieldItem.SFDC_Field_API__c, reporterStr);

                    } else if (fieldItem.Object_Type__c == 'status') {

                        String statusStr = String.valueOf(obj).substringBetween('name=', ', self=');
                        scope[0].put(fieldItem.SFDC_Field_API__c, statusStr);

                    } else if (fieldItem.Object_Type__c == 'picklist') {

                        String picklistStr = String.valueOf(obj).substringBetween(', value=', '})');
                        scope[0].put(fieldItem.SFDC_Field_API__c, picklistStr);
                    
                    } else if (fieldItem.Object_Type__c == 'Decimal') {
                      
                      string percentremove=obj.tostring().trim();
                         
                      
                      if(obj.tostring().contains('%'))
                      {
                        percentremove=obj.tostring().remove('%'); //22.1
                      }
                      else if(obj.tostring().contains('Percent'))
                      {
                          percentremove=obj.tostring().remove('Percent');
                      }
                       else if(obj.tostring().contains('percent'))
                      {
                          percentremove=obj.tostring().remove('percent');
                      }
                        system.debug(Logginglevel.ERROR, '---- show reslut 12321 Decimal : '+ percentremove + '  ---- ' + percentremove.isnumeric());
                        //Pattern numberFormat = Pattern.Compile('^[1-9]\\d*(\\.\\d+)?$'); //checks whether it is a no or not which includes decimal as well
                         //Matcher numberMatch = numberFormat.matcher(percentremove.trim());
                        if(percentremove.trim().isnumeric())
                        {
                            //string percentremove=obj.tostring().remove('%');
                            
                            scope[0].put(fieldItem.SFDC_Field_API__c, Decimal.valueOf(percentremove.trim()));
                            
                        }
                        
                         /*
                        else if(percentremove.trim().contains('.') && numberMatch.Matches())
                        {
                             scope[0].put(fieldItem.SFDC_Field_API__c, Decimal.valueOf(percentremove.trim()));
                        }*/
                        

                        //scope[0].put(fieldItem.SFDC_Field_API__c, Decimal.valueOf(String.valueOf(obj)));
                    }

                } else {

                    scope[0].put(fieldItem.SFDC_Field_API__c, null);
                }

                //system.debug(Logginglevel.ERROR, '---- show reslut 12321 : ---- ' + obj);
            }

        }
        system.debug(Logginglevel.ERROR, '---- show update IT list reslut : ---- ' + scope[0]);
         sp = database.setsavepoint();
        update scope[0];

        //  Update Linked Issues info to child object of Implementation Tracking
        
        for (JIRAIssueResponse_Instance issueItem: issueLinksResp) {

            Medical_Benefit__c newMB;

            if (MBMap.get(issueItem.response.key) != null) {

                newMB = MBMap.get(issueItem.response.key);
                newMB.JIRA_Request_ID__c = issueItem.response.key;
            } else {

                newMB = new Medical_Benefit__c();
                newMB.JIRA_Request_ID__c = issueItem.response.key;
            }

            newMB.Implementation_Tracking_ID__c = scope[0].Id;

            for (Field_Mapping__mdt fieldItem: MBList) {

                if (fieldItem.Default_Value__c == null || issueType == fieldItem.Default_Value__c) {

                    Object obj = issueItem.response.fields.getValue(fieldItem.Jira_Field_API_Name__c);
                    
                    system.debug(Logginglevel.ERROR, '---- show MB Issue Key reslut : ---- ' + fieldItem.Jira_Field_Label__c + ' : ' + fieldItem.SFDC_Field_API__c + ' ** ' + obj);
                    

                    

                    if (obj != null) {

                        //system.debug(Logginglevel.ERROR, '------show field value : ------'+fieldItem.Jira_Field_API_Name__c + ' ** ' + obj);
                        
                        

                        if (fieldItem.Object_Type__c == 'text') {

                            if (fieldItem.Jira_Field_API_Name__c == 'summary') {
                                if(String.valueOf(obj).indexOfIgnoreCase('Pkg', 0) !=-1) {

                                    Integer pos = String.valueOf(obj).indexOfIgnoreCase('Pkg', 0) + 3;
                                    String summaryStr = String.valueOf(obj).substring(pos);

                                    newMB.put(fieldItem.SFDC_Field_API__c, summaryStr);
                                } else {

                                    newMB.put(fieldItem.SFDC_Field_API__c, null);
                                }
                                
                            } else {

                                newMB.put(fieldItem.SFDC_Field_API__c, String.valueOf(obj));
                            }

                        } else if (fieldItem.Object_Type__c == 'date') {

                            system.debug('fieldItem.Jira_Field_API_Name__c   : '+fieldItem.Jira_Field_API_Name__c);
                            newMB.put(fieldItem.SFDC_Field_API__c, Date.valueOf(String.valueOf(obj)));

                        /*} else if (fieldItem.Object_Type__c == 'reporter') {

                            String reporterStr = String.valueOf(obj).substringBetween('displayName=', ', emailAddress');

                            newMB.put(fieldItem.SFDC_Field_API__c, reporterStr);

                        } else if (fieldItem.Object_Type__c == 'status') {

                            String statusStr = String.valueOf(obj).substringBetween('name=', ', self=');
                            newMB.put(fieldItem.SFDC_Field_API__c, statusStr);*/

                        } else if (fieldItem.Object_Type__c == 'picklist') {

                            String picklistStr = String.valueOf(obj).substringBetween(', value=', '})');
                            newMB.put(fieldItem.SFDC_Field_API__c, picklistStr);
                        }



                        
                    } else {

                        newMB.put(fieldItem.SFDC_Field_API__c, null);

                    }

                    if (fieldItem.SFDC_Field_API__c == 'Benefit_Coding_Start_Date__c') {

                        newMB.put(fieldItem.SFDC_Field_API__c, BCSDatemap.get(issueItem.response.key));
                        
                    }

                    if (fieldItem.SFDC_Field_API__c == 'Benefit_Coding_ECD__c') {

                        newMB.put(fieldItem.SFDC_Field_API__c, BCECDmap.get(issueItem.response.key));
                        
                    }

                    if (fieldItem.SFDC_Field_API__c == 'Benefit_Coding_ACD__c') {

                        newMB.put(fieldItem.SFDC_Field_API__c, BCACDmap.get(issueItem.response.key));
                        
                    }

                    if (fieldItem.SFDC_Field_API__c == 'Blue_Exchange_Production_Date__c') {

                        newMB.put(fieldItem.SFDC_Field_API__c, BEPDatemap.get(issueItem.response.key));
                        
                    }

                    if (fieldItem.SFDC_Field_API__c == 'Benefit_Testing_Start_Date__c') {

                        newMB.put(fieldItem.SFDC_Field_API__c, BTSDatemap.get(issueItem.response.key));
                        
                    }

                    if (fieldItem.SFDC_Field_API__c == 'Benefit_Testing_ACD__c') {

                        newMB.put(fieldItem.SFDC_Field_API__c, BTACDmap.get(issueItem.response.key));
                        
                    }

                    

                    //system.debug(Logginglevel.ERROR, '---- show reslut 12321 : ---- ' + obj);
                }
            }

            system.debug(Logginglevel.ERROR, '---- show reslut 12321 newMB : ---- ' + newMB);
            updateMBList.add(newMB);

        }

        system.debug(Logginglevel.ERROR, '---- show update MB list reslut 12321 : ---- ' + updateMBList);
        upsert updateMBList;
       successMap.put(scope[0].id,'Success');
        SuccessIdToSObjectMap.put(scope[0].id,scope[0]);
          successcount++;
            System.debug('Number of Callouts : '+Limits.getCallouts());
    }
    Catch(Exception ex)
    {
        errorMap.put(scope[0].id,ex.getmessage());
        IdToSObjectMap.put(scope[0].id,scope[0]);
        system.debug('In Catch--->'+errorMap);
        system.debug('Line no-->'+ex.getStackTraceString().replace('\n',' | ')+' | '+ex.getMessage().replace('\n',' '));
        if(sp!=null)
        {
        database.rollback(sp);
        }
        failurecount++;
    }
    }
    
    public void finish(Database.BatchableContext BC) {

        //LGJiraSendRequestBatch nestBatch = new LGJiraSendRequestBatch(issueLinks); 
        //database.executeBatch(nestBatch, 1);
        system.debug('errorMap---->'+errorMap);
        system.debug('errorMap size---->'+errorMap.isempty());

          string body='';
        //String subject = 'JIRA to SFDC Sync Process Status';
        AsyncApexJob a = [SELECT id, ApexClassId,
                       JobItemsProcessed, TotalJobItems,
                       NumberOfErrors, CreatedBy.Email
                       FROM AsyncApexJob
                       WHERE id = :BC.getJobId()];
                       
       LGJiraProcessBatchStatus.CreateEmail(errorMap,a.JobItemsProcessed,'JIRA to SFDC Sync Process Status',successcount,failurecount,IdToSObjectMap,'Implementation_Tracking__c',successMap,SuccessIdToSObjectMap,null);
          
    }
        
    public void execute(System.SchedulableContext sc) {
        Database.executeBatch(new JIRAToSFDCSyncBatch(), 1);
    } 
    
    /*public JSON2Apex fetchIssueDetail(String issueType, String issueId) {
        JSON2Apex resp = (new LGJiraUtility()).GetIssue(issueId);
        
        return resp;
    }*/
}