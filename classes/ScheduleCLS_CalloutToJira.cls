global class ScheduleCLS_CalloutToJira implements Schedulable{
    
    //public static final String  fields   =   'key,'+'assignee,'+'project,'+'summary,'+'created,'+'updated,'+'priority,'+'status';
    
    //public static final integer startAt  = 0;
    //public static final integer maxResults = 10;
    public static final string Sprints = label.Sprint_Number;
    
    public static final String username = label.JiraCallout_UserName;
    public static final String password = 	label.JiraCallout_Password;
    
    
    public Class JsonData1{
        public String total;
        public String maxResults;
        public String startAt;
        public List<String> issues;
    }
    
    global void Execute(SchedulableContext sc){
        get_Jira_Data();
    }
    
    
    global static void get_Jira_Issues(Integer NoOfIssuesInSprints){
        Integer StartNumber = 0;
        String status ;
        
        List<Jira_Issues__c> jiraIssuesList = new List<Jira_Issues__c>();
        
            for(Integer i =-100;i<=NoOfIssuesInSprints;i=i+100){
                startNumber = i + 100;
                
                Http http  = new Http();
        		HttpRequest req = new HttpRequest();
        
        		String auth_header = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept','application/json');
                req.setHeader('Authorization', auth_header);
                req.setHeader('X-Atlassian-Token', 'nocheck');
                
                req.setEndpoint('https://autorabit.atlassian.net/rest/api/2/search?jql=Sprint+in('+Sprints+')&fields=issuetype,project,customfield_10010,summary,customfield_10053,fixVersions,priority,assignee,status,creator&startAt='+startNumber+'&maxResults=-1');
        		req.setMethod('GET');
                system.debug(req);
                
                HttpResponse res = http.send(req);
                String AllIssues  = res.getBody();
                
                JSON2Apex DeserializedJiraData = new JSON2Apex();
                DeserializedJiraData = JSON2Apex.parse(AllIssues);
                
                if(DeserializedJiraData.Issues.size() >0){
                
                    for(Json2Apex.issues IssueInfo: DeserializedJiraData.issues){
                        
                        Jira_Issues__c JiraInfo = new Jira_Issues__c();
                        
                        JiraInfo.Issue_Key__c = IssueInfo.key;
                        
                        Json2Apex.Fields IssueFields = new  Json2Apex.Fields();
                        if(IssueInfo.fields != null){
                        	IssueFields = IssueInfo.fields;//IssueFields
                        }
                        
                        Json2Apex.Issuetype IssueTypeFields =new Json2Apex.Issuetype();
                        if(IssueFields.issuetype != null){
                            IssueTypeFields = IssueFields.issuetype; //IssueTYpe
                            if(IssueTypeFields.name != null ){
                                JiraInfo.IssueTypeName__c = IssueTypeFields.name;
                                if(IssueTypeFields.description != null){
                                	JiraInfo.IssueTypeDescription__c = IssueTypeFields.description;
                                }
                            }
                        }
                        
                        if(IssueFields.summary != null){
                            JiraInfo.Summary__c = IssueFields.summary; //Summary of the issue
                        }
                        
                        Json2Apex.Creator IssueCreatorData = new Json2Apex.Creator();
                        if(IssueFields.creator != null){
                            IssueCreatorData = IssueFields.creator; //IssueCreator
                            if(IssueCreatorData.displayName != null){
                                JiraInfo.Creator_Name__c = IssueCreatorData.displayName;
                            }
                        }
                        
                        Json2Apex.Project IssueProjectInfo = new Json2Apex.Project();
                        if(IssueFields.project != null){
                            IssueProjectInfo = IssueFields.project;//ProjectData
                            if(IssueProjectInfo.name != null){
                                JiraInfo.Project_Name__c = IssueProjectInfo.name;
                            }
                        }
                        
                        Json2Apex.ProjectCategory projectCategoryInfo = new Json2Apex.ProjectCategory();
                        if(IssueProjectInfo.projectCategory != null){
                        	projectCategoryInfo = IssueProjectInfo.projectCategory;//ProjectCategory
                        	if(projectCategoryInfo.name != null){
                                JiraInfo.Project_Category_Name__c = projectCategoryInfo.name;
                                if(projectCategoryInfo.description != null){
                                	JiraInfo.Project_Category_Description__c	 = projectCategoryInfo.description;
                                }
                            }
                        }
                        
                        Json2Apex.Reporter reporterInfo = new Json2Apex.Reporter();
                        if(IssueFields.reporter != null){
                            reporterInfo = IssueFields.reporter;//ReporterData
                            if(reporterInfo.displayName != null){
                                JiraInfo.Reporter_Name__c = reporterInfo.displayName;
                            }
                        }
                        
                       /* List<Json2Apex.FixVersions> fixversionList  = new List<Json2Apex.FixVersions>();
                        if(IssueFields.fixVersions.size()>0){
                            fixversionList = IssueFields.fixVersions;//FixVersionList
                            System.debug('coming here'+fixversionList);
                            for(Json2Apex.FixVersions fixversionInfo:fixversionList){
                                system.debug(fixversionInfo);
                                String versiondata =fixversionInfo.version ;
                                JiraInfo.Fix_Version__c += versiondata;
                            }
                        }*/
                        
                        
                        List<String> sprintNamesList = new List<String>();
                        
                        if(!IssueFields.customfield_10010.isEmpty()){
                            sprintNamesList = IssueFields.customField_10010;//Sprint data lying in the custom Field
                            for(String sprintName :sprintNamesList){
                                String Sequence = sprintName.SubstringBetween('id=',',');
                                String name = sprintName.substringBetween('name=', ',');
                                if(JiraInfo.Sprint_Names__c != null){
                                	JiraInfo.Sprint_Names__c += Sequence + ',';
                                }
                                else{
                                    JiraInfo.Sprint_Names__c = Sequence + ',';
                                }
                                
                                if(JiraInfo.Issue_Sprint_Name__c != null){
                                    JiraInfo.Issue_Sprint_Name__c += name + ','; 
                                }else{
                                    JiraInfo.Issue_sprint_Name__c = name + ',';
                                }
                            }
                            JiraInfo.Sprint_Names__c=JiraInfo.Sprint_Names__c.removeEnd(',');
                            JiraInfo.Issue_Sprint_Name__c = JiraInfo.Issue_Sprint_Name__c.removeEnd(',');
                        }
                       
                        
                       Json2Apex.Assignee assigneeInfo = new Json2Apex.Assignee();
                        if(IssueFields.assignee != null){
                        	assigneeInfo = IssueFields.assignee;//AssigneeInfo
                            if(assigneeInfo.displayName != null){
                                JiraInfo.Assignee_Name__c = assigneeInfo.displayName;
                            }
                        }	
                        
                        Json2Apex.Status statusInfo = new Json2Apex.Status();
                        if(IssueFields.status != null){
                            statusInfo  = IssueFields.status;//StatusData
                            if(statusInfo.name != null){
                                JiraInfo.Status__c = statusInfo.name;
                            }
                        }
                        
                        
                        
                        Json2Apex.StatusCategory statusCategoryInfo = new Json2Apex.StatusCategory();
                        if(statusInfo.statusCategory != null){
                            statusCategoryInfo = statusInfo.statusCategory;//StatusCategoryInfo
                            if(statusCategoryInfo.key != null){
                                JiraInfo.Status_Category__c=statusCategoryInfo.key;
                            }
                        }
                        
                        if(IssueFields.customfield_10053!= null){
                            JiraInfo.Story_Point__c = Decimal.valueOf(IssueFields.customfield_10053);
                        }
                        
                        Json2Apex.Priority priorityInfo = new Json2Apex.Priority();
                        if(IssueFields.priority != null){
                            priorityInfo =  IssueFields.priority;//priorityData
                            if(priorityInfo.name != null){
                                JiraInfo.Priority__c = priorityInfo.name;
                            }
                        }
                        
                        jiraIssuesList.add(JiraInfo);                    
                    }
                }
            }
        try{
            if(jiraIssuesList.size()>0){
                Upsert jiraIssuesList Issue_Key__c;
                status = 'Success';
            }
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
            status = 'Failed. The reason for Failure is'+ex.getMessage();
        }
        
        sendEmailafterCompletionofJiraExecution(status);
    }
    
    
    global Static void sendEmailafterCompletionofJiraExecution(string ResultOfExecution){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new list<string> {label.EmailID_For_GA_and_Jira};
        email.setToAddresses(toAddresses);
        email.setSenderDisplayName('Jira Schedule Class Exectuion Status');
        email.setSubject('Status'+' '+':'+ResultOfExecution);
        email.setPlainTextBody('Jira data  has been  successfully inserted and The following is the status of Execution of the class'+'Status'+' '+':'+ResultOfExecution +'  '+ 'DATE'+' '+':'+date.today());
        Messaging.sendEmail(new Messaging.singleEmailMessage[]{email});
    }
    
    
    
    @future(callout=true)
    global static void get_Jira_Data(){
        
        
        Http http  = new Http();
        HttpRequest req = new HttpRequest();
        
        String auth_header = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));
        //String url = EncodingUtil.urlEncode('','UTF-8');
        
        req.setHeader('Content-Type', 'application/json');
		req.setHeader('Accept','application/json');
		req.setHeader('Authorization', auth_header);
		req.setHeader('X-Atlassian-Token', 'nocheck');
        req.setEndpoint('https://autorabit.atlassian.net/rest/api/2/search?jql=Sprint+in('+Sprints+')&maxResults=0');
        req.setMethod('GET');
        
       HttpResponse res = http.send(req);
       String AllIssues  = res.getBody();
       JsonData1 deserializeddata = (JsonData1)json.deserialize(AllIssues, JsonData1.class);
        system.debug(deserializeddata);
        
        if(integer.valueof(deserializeddata.total)>0){
        	get_Jira_Issues(integer.valueof(deserializeddata.total));
        }
    }
    
}