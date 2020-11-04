@IsTest
public class LGJira2IssueDetail_Test {
    
    static testMethod void testParse() {
        
        LGJira2IssueDetail l=new LGJira2IssueDetail();
        l.expand='renderedFields,names,schema,operations,editmeta,changelog,versionedRepresentations';
        l.id='100800';
        l.self='https://jiraewm-dev.anthem.com/rest/api/2/issue/100800';
        l.key='EWM-48013';
        LGJira2IssueDetail.FieldDetails fields=new LGJira2IssueDetail.FieldDetails();
        fields.lastViewed='today';
        fields.customfield_11492='12';
        List<string>subtsk=new List<string>();
        subtsk.add('test');
        fields.subtasks=subtsk;
        l.fields=fields;
        System.assert(fields != null);
        LGJira2IssueDetail.CustomFieldClass cfcls=new LGJira2IssueDetail.CustomFieldClass();
        List<LGJira2IssueDetail.CustomFieldClass> cfcllist=new List<LGJira2IssueDetail.CustomFieldClass>();
        cfcls.self='https://jiraewm-dev.anthem.com/rest/api/2/issue/100800';
        cfcls.id='EWM-48013';
        cfcls.key = 'test key';
        cfcls.description='test';
        cfcls.iconUrl='test';
        cfcls.subtask='test';
        cfcls.avatarId='test';
        cfcls.watchCount='test';
        cfcls.isWatching='test';
        cfcls.displayName='test';
        cfcls.active=true;
        cfcls.timeZone='test';
        System.assert(cfcls != null);
        //cfcllist.add(cfcllist);
        fields.reporter=cfcls;
        fields.customfield_13675=cfcls;
        fields.customfield_11483=cfcls;
        fields.watches=cfcls;
        fields.updated='test';
        fields.description='test';
        fields.customfield_12301='test';
        //fields.customfield_14100=cfcllist;
        fields.customfield_11487=subtsk;
        fields.customfield_11452=subtsk;
        fields.customfield_11454=subtsk;
        fields.customfield_11456=subtsk;
        fields.customfield_11455=subtsk;
        fields.customfield_12606='test';
        fields.status=cfcls;
        fields.creator=cfcls;
        fields.customfield_11639=cfcls;
        fields.customfield_11626=cfcls;
        fields.customfield_13310=cfcls;
        fields.customfield_13121=subtsk;
        fields.customfield_12800=subtsk;
        fields.customfield_14108='test';
        fields.customfield_13402='test';
        fields.customfield_14100=cfcllist;
        fields.customfield_13600=cfcllist;
        fields.customfield_11609=cfcllist;
        fields.customfield_14800=cfcllist;
        fields.customfield_14801='test';
        fields.created='test';
        System.assert(fields != null);
        
        
    }
    static testMethod void testPut(){
        LGJira2IssueDetail l=new LGJira2IssueDetail();
        LGJira2IssueDetail.FieldDetails fields=new LGJira2IssueDetail.FieldDetails();
        fields.put('issuetype','issuetype',fields);
        fields.put('customfield_11561','customfield_11561',fields);
        fields.put('customfield_11558','Renewal',fields);
        fields.put('customfield_11558','Change Request Off Cycle',fields);
        fields.put('customfield_11558','Term',fields);
        fields.put('customfield_11558','Pre Work',fields);
        fields.put('customfield_12401','customfield_12401',fields);
        fields.put('customfield_11500','customfield_11500',fields);
        fields.put('customfield_11492','customfield_11492',fields);
        fields.put('customfield_11491','customfield_11491',fields);
        fields.put('customfield_11493','customfield_11493',fields);
        fields.put('customfield_11495','customfield_11495',fields);
        fields.put('customfield_11481','customfield_11481',fields);
        fields.put('customfield_11483','customfield_11483',fields);
        fields.put('customfield_11485','customfield_11485',fields);
        fields.put('customfield_15105','customfield_15105',fields);
        fields.put('customfield_14100','customfield_14100',fields);
        fields.put('description','description',fields);
  		fields.put('customfield_12301','customfield_12301',fields);        
        fields.put('customfield_11447','customfield_11447',fields);        
        fields.put('customfield_11446','customfield_11446',fields);        
        fields.put('customfield_11449','customfield_11449',fields);        
        fields.put('customfield_14108','customfield_14108',fields);        
        fields.put('customfield_13402','customfield_13402',fields);        
        fields.put('customfield_13000','customfield_13000',fields);        
        fields.put('customfield_12606','customfield_12606',fields);
        fields.put('customfield_13600','customfield_13600',fields);
        fields.put('customfield_14318','customfield_14318',fields);
        fields.put('customfield_11445','customfield_11445',fields);
        fields.put('project','project;project',fields);
        fields.put('summary','summary',fields);
        fields.put('customfield_13121','customfield_13121',fields);
        fields.put('customfield_12800','customfield_12800',fields);
        fields.put('customfield_16500','1 - 50',fields);
        fields.put('customfield_14800','customfield_14800',fields);
        fields.put('customfield_16615','customfield_16615',fields);
        fields.put('customfield_14801','customfield_14801',fields);
        fields.put('customfield_11672','customfield_11672',fields);
        System.assert(fields != null);
    }
    
    static testMethod void testPut51to99(){
        LGJira2IssueDetail l=new LGJira2IssueDetail();
        LGJira2IssueDetail.FieldDetails fields=new LGJira2IssueDetail.FieldDetails();
        fields.put('customfield_16500','51 - 99',fields);
    }
    static testMethod void testPut100to249(){
        LGJira2IssueDetail l=new LGJira2IssueDetail();
        LGJira2IssueDetail.FieldDetails fields=new LGJira2IssueDetail.FieldDetails();
        fields.put('customfield_16500','100 - 249',fields);
    }
    static testMethod void testPut250to499(){
        LGJira2IssueDetail l=new LGJira2IssueDetail();
        LGJira2IssueDetail.FieldDetails fields=new LGJira2IssueDetail.FieldDetails();
        fields.put('customfield_16500','250 - 499',fields);
    }
    static testMethod void testPut500to999(){
        LGJira2IssueDetail l=new LGJira2IssueDetail();
        LGJira2IssueDetail.FieldDetails fields=new LGJira2IssueDetail.FieldDetails();
        fields.put('customfield_16500','500 - 999',fields);
    }
    static testMethod void testPut1000(){
        LGJira2IssueDetail l=new LGJira2IssueDetail();
        LGJira2IssueDetail.FieldDetails fields=new LGJira2IssueDetail.FieldDetails();
        fields.put('customfield_16500','1000+',fields);
    }
     
}