@isTest
public class JIRAIssueResponse_Instance_Test {

    @isTest static void JIRAIssueResponseInstanceTest()
    {
         Test.startTest();

        JIRAIssueResponse_Instance instance = new JIRAIssueResponse_Instance();
        instance.Response = new JIRAIssueResponse_Instance.Response();
        instance.Response.expand = 'expand';
        instance.Response.id = 'id';
        instance.Response.key = 'key';
        instance.Response.self = 'self';

        instance.Response.fields = new JIRAIssueResponse_Instance.Fields_Z();
        instance.Response.fields.description = 'description';
        instance.Response.fields.summary = 'summary';
        instance.Response.fields.reporter = new JIRAIssueResponse_Instance.Reporter();
        instance.Response.fields.subtasks = null;
        instance.Response.fields.customfield_11439 = 'description';
        instance.Response.fields.customfield_11439 = 'description';
        instance.Response.fields.customfield_11485 = 'description';
        instance.Response.fields.customfield_11517 = 'description';
        instance.Response.fields.customfield_11518 = 'description';
        instance.Response.fields.customfield_11519 = 'description';
        instance.Response.fields.customfield_11542 = 'description';
        instance.Response.fields.customfield_11545 = 'description';
        instance.Response.fields.customfield_11544 = 'description';
        instance.Response.fields.customfield_11547 = 'description';
        instance.Response.fields.customfield_11560 = 'description';
        instance.Response.fields.customfield_11561 = 'description';
        instance.Response.fields.customfield_11562 = 'description';
        instance.Response.fields.customfield_11583 = 'description';
        instance.Response.fields.customfield_11601 = 'description';
        instance.Response.fields.customfield_11602 = 'description';
        instance.Response.fields.customfield_11606 = 'description';
        instance.Response.fields.customfield_11607 = 'description';
        instance.Response.fields.customfield_11667 = 'description';
        instance.Response.fields.customfield_11679 = 'description';
        instance.Response.fields.customfield_11697 = 'description';
        instance.Response.fields.customfield_11698 = 'description';
        instance.Response.fields.customfield_11700 = 'description';
        instance.Response.fields.customfield_11707 = 'description';
        instance.Response.fields.customfield_12200 = 'description';
        instance.Response.fields.customfield_11552 = 'description';
        instance.Response.fields.customfield_15201 = 'description';
        instance.Response.fields.customfield_15200 = 'description';
        instance.Response.fields.customfield_14200 = 'description';
        instance.Response.fields.customfield_14201 = 'description';
        instance.Response.fields.customfield_11462 = 'description';
        instance.Response.fields.customfield_11509 = null;


        instance.Response.fields.assignee = new JIRAIssueResponse_Instance.Reporter();
        instance.Response.fields.assignee.self = 'self';
        instance.Response.fields.assignee.name = 'name';
        instance.Response.fields.assignee.key = 'key';
        instance.Response.fields.assignee.emailAddress = 'emailAddress';
        instance.Response.fields.assignee.displayName = 'displayName';
        instance.Response.fields.assignee.active = true;
        instance.Response.fields.assignee.timeZone = 'timeZone';


        instance.Response.fields.project = new JIRAIssueResponse_Instance.Project();
        instance.Response.fields.project.self = 'self';
        instance.Response.fields.project.name = 'name';
        instance.Response.fields.project.key = 'key';
        instance.Response.fields.project.id = 'id';


        instance.Response.fields.issuetype = new JIRAIssueResponse_Instance.Issuetype();
        instance.Response.fields.issuetype.self = 'self';
        instance.Response.fields.issuetype.name = 'name';
        instance.Response.fields.issuetype.id = 'id';
        instance.Response.fields.issuetype.description = 'description';
        instance.Response.fields.issuetype.iconUrl = 'iconUrl';
        instance.Response.fields.issuetype.subtask = true;
        instance.Response.fields.issuetype.avatarId = 1;

        
        instance.Response.fields.status = new JIRAIssueResponse_Instance.Status();
        instance.Response.fields.status.self = 'self';
        instance.Response.fields.status.name = 'name';
        instance.Response.fields.status.id = 'id';
        instance.Response.fields.status.description = 'description';
        instance.Response.fields.status.iconUrl = 'iconUrl';


        instance.Response.fields.subtasks = new List<JIRAIssueResponse_Instance.InwardIssue>();
        instance.Response.fields.subtasks.add(new JIRAIssueResponse_Instance.InwardIssue());
        instance.Response.fields.subtasks.get(0).id = 'id';
        instance.Response.fields.subtasks.get(0).key = 'key';
        instance.Response.fields.subtasks.get(0).self = 'self';
        instance.Response.fields.subtasks.get(0).fields = new JIRAIssueResponse_Instance.Fields();
        instance.Response.fields.subtasks.get(0).fields.summary = 'summary';
        instance.Response.fields.subtasks.get(0).fields.status = null;
        instance.Response.fields.subtasks.get(0).fields.issuetype = null;


        instance.Response.fields.customfield_11724 = new List<JIRAIssueResponse_Instance.CustomfieldClass>();
        instance.Response.fields.customfield_11724.add(new JIRAIssueResponse_Instance.CustomfieldClass());
        instance.Response.fields.customfield_11724.get(0).self = 'self';
        instance.Response.fields.customfield_11724.get(0).id = 'id';


        instance.Response.fields.issuelinks = new List<JIRAIssueResponse_Instance.Issuelinks>();
        instance.Response.fields.issuelinks.add(new JIRAIssueResponse_Instance.Issuelinks());
        instance.Response.fields.issuelinks.get(0).id = 'id';
        instance.Response.fields.issuelinks.get(0).self = 'self';
        instance.Response.fields.issuelinks.get(0).type_Z = new JIRAIssueResponse_Instance.type_Z();
        instance.Response.fields.issuelinks.get(0).type_Z.id = 'id';
        instance.Response.fields.issuelinks.get(0).type_Z.name = 'name';
        instance.Response.fields.issuelinks.get(0).type_Z.inward = 'inward';
        instance.Response.fields.issuelinks.get(0).type_Z.outward = 'outward';
        instance.Response.fields.issuelinks.get(0).type_Z.self = 'self';

        instance.Response.fields.issuelinks.get(0).inwardIssue = null;
        instance.Response.fields.issuelinks.get(0).outwardIssue = new JIRAIssueResponse_Instance.OutwardIssue();
        instance.Response.fields.issuelinks.get(0).outwardIssue.id = 'id';
        instance.Response.fields.issuelinks.get(0).outwardIssue.key = 'key';
        instance.Response.fields.issuelinks.get(0).outwardIssue.self = 'self';
        instance.Response.fields.issuelinks.get(0).outwardIssue.fields = null;

        Object obj = instance.Response.fields.getValue('customfield_11462');

        System.schedule('test', '0 0 * * * ?', new JIRAToSFDCSyncBatch());


        LGJira2IssueDetail details = new LGJira2IssueDetail();
        details.expand = 'expand';
        details.id = 'id';
        details.key = 'key';
        details.self = 'self';
        details.fields = new LGJira2IssueDetail.FieldDetails();
        details.fields.lastViewed = 'test';
        details.fields.subtasks = null;
        details.fields.customfield_11492 = 'test';
        details.fields.updated = 'test';
        details.fields.description = 'test';
        details.fields.customfield_12301 = 'test';
        details.fields.created = 'test';
        details.fields.customfield_14108 = 'test';
        details.fields.reporter = null;
        details.fields.customfield_13675 = null;
        details.fields.customfield_11487 = null;
        details.fields.watches = null;
        details.fields.customfield_11452 = null;
        details.fields.customfield_11454 = null;
        details.fields.customfield_11456 = null;
        details.fields.customfield_11455 = null;
        details.fields.created = null;
        details.fields.creator = null;
        details.fields.customfield_11639 = null;
        details.fields.customfield_11626 = null;
        details.fields.customfield_11609 = null;
        details.fields.customfield_13310 = null;
        details.fields.status = new LGJira2IssueDetail.CustomFieldClass();
        details.fields.status.self = 'self';
        details.fields.status.id = 'id';
        details.fields.status.description = 'description';
        details.fields.status.iconUrl = 'description';
        details.fields.status.subtask = 'description';
        details.fields.status.avatarId = 'description';
        details.fields.status.watchCount = 'description';
        details.fields.status.isWatching = 'description';
        details.fields.status.displayName = 'description';
        details.fields.status.timeZone = 'description';
        details.fields.status.active = false;

        LGJiraCreateIssueResponse res = new LGJiraCreateIssueResponse();
        res.Id = 'id';
        res.key = 'key';
        res.self = 'self';
        res.response = 'response';
         
        JiraIssueResponse_Instance.Response myres = new JiraIssueResponse_Instance.Response();
        myres.id = '123';
        myres.key = 'EWM-12345';
        myres.self = 'self link';
        myres.expand = 'issues,links';
        myres.fields = instance.Response.fields;
        
        JiraSearchIssueResponse response = new JiraSearchIssueResponse();
        response.expand = 'schema,names';
        response.maxResults = 500;
        response.startAt = 0;
        response.total = 500;
        List<JiraIssueResponse_Instance.Response> issues = new List<JiraIssueResponse_Instance.Response>();
        issues.add(instance.Response);
        response.issues = issues;
        
       
        Test.stopTest();

    }
}