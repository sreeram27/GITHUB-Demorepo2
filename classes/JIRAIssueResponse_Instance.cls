//  Not used - can be deleted
public class JIRAIssueResponse_Instance {

	public class Status {
		public String self {get;set;} 
		public String description {get;set;} 
		public String iconUrl {get;set;} 
		public String name {get;set;} 
		public String id {get;set;} 

	}
	
	public class Type_Z {
		public String id {get;set;} 
		public String name {get;set;} 
		public String inward {get;set;} 
		public String outward {get;set;} 
		public String self {get;set;} 
    }
	
	public Response Response {get;set;} 

	public class Reporter {
		public String self {get;set;} 
		public String name {get;set;} 
		public String key {get;set;} 
		public String emailAddress {get;set;} 
		public String displayName {get;set;} 
		public Boolean active {get;set;} 
		public String timeZone {get;set;} 

	}
	
	public class CustomfieldClass {
		public String self {get;set;} 
		public String value {get;set;} 
		public String id {get;set;} 

	}
	
	public class OutwardIssue {
		public String id {get;set;} 
		public String key {get;set;} 
		public String self {get;set;} 
		public Fields fields {get;set;} 

	}
	
	public class Issuelinks {
		public String id {get;set;} 
		public String self {get;set;} 
		public Type_Z type_Z {get;set;} // in json: type
		public InwardIssue inwardIssue {get;set;} 
		public OutwardIssue outwardIssue {get;set;} 

	}
	
	public class Fields_Z {

		public Reporter assignee {get;set;} 
		public String description {get;set;} 
		public Project project {get;set;} 
		public String summary {get;set;} 
		public Status status {get;set;} 
		public Reporter reporter {get;set;} 
		public List<Issuelinks> issuelinks {get;set;} 
		public List<InwardIssue> subtasks {get;set;} 
		public Issuetype issuetype {get;set;} 
		public CustomfieldClass customfield_11500 {get;set;} 
		public String customfield_11439 {get;set;} 
		public String customfield_11462 {get;set;} 
		public String customfield_11485 {get;set;} 
		public List<CustomfieldClass> customfield_11509 {get;set;} 
		public String customfield_11517 {get;set;} 
		public String customfield_11518 {get;set;} 
		public String customfield_11519 {get;set;} 
		public String customfield_11542 {get;set;} 
		public String customfield_11545 {get;set;} 
		public String customfield_11544 {get;set;} 
		public String customfield_11547 {get;set;} 
		public String customfield_11560 {get;set;} 
		public String customfield_11561 {get;set;} 
		public String customfield_11562 {get;set;} 
		public String customfield_11583 {get;set;} 
		public String customfield_11601 {get;set;} 
		public String customfield_11602 {get;set;} 
		public String customfield_11606 {get;set;} 
		public String customfield_11607 {get;set;}  
		public String customfield_11667 {get;set;} 
		public String customfield_11679 {get;set;} 
		public String customfield_11697 {get;set;} 
		public String customfield_11698 {get;set;} 
		public String customfield_11700 {get;set;} 
		public String customfield_11707 {get;set;} 
		public List<CustomfieldClass> customfield_11724 {get;set;} 
		public String customfield_12200 {get;set;} 
		public String customfield_11552 {get;set;}
		public String customfield_15201 {get;set;}
		public String customfield_15200 {get;set;}
        public String customfield_14200 {get;set;}
        public String customfield_14201 {get;set;}
		/*public String customfield_12301 {get;set;} 
		public String customfield_11447 {get;set;} 
		public String customfield_11446 {get;set;} 
		public String customfield_11449 {get;set;} 
		public String customfield_11492 {get;set;} 
		public String customfield_11493 {get;set;} 
		public String customfield_11445 {get;set;}
		public CustomfieldClass customfield_11481 {get;set;} 
		public CustomfieldClass customfield_11483 {get;set;} 
		public CustomfieldClass customfield_11491 {get;set;} 
		public CustomfieldClass customfield_11495 {get;set;} 
		public CustomfieldClass customfield_11558 {get;set;} 
		public String customfield_12401 {get;set;} 
		public String customfield_13000 {get;set;} 
		public List<String> customfield_13121 {get;set;} 
		public String customfield_14108 {get;set;} 
		public List<CustomfieldClass> customfield_14318 {get;set;} 
		public List<CustomfieldClass> customfield_15105 {get;set;}*/

		public Object getValue(String param_name){
            //String retStr = '';
            if(param_name == 'assignee'){
                if(this.assignee != null) {
                    return this.assignee.displayName;
                }else {
                  return '';  
                } 
            } else if(param_name == 'status'){
                if(this.status != null){
                  return this.status.name ;  
                } else {
                    return '';
                }
            } else if (param_name == 'customfield_11509'){
                String retStr ='';
                if(this.customfield_11509 != null){
                for (CustomfieldClass cus11509: this.customfield_11509){
                    if(retStr.length()>0) {
                        retStr = retStr +','+cus11509.value;
                    } else {
                        retStr = cus11509.value;
                    }
                 
                }
                return retStr;
                } else {
                    return '';
                }
            }else if (param_name == 'customfield_11724'){
                String retStr ='';
                if(this.customfield_11724 != null){
                    return this.customfield_11724[0].value;
                /*for (CustomfieldClass cus11724: this.customfield_11724){
                    if(retStr.length()>0) {
                        retStr = retStr +','+cus11724.value;
                    } else {
                        retStr = cus11724.value;
                    }
                 
                }
                return retStr;*/
                    
                } else {
                    return '';
                }
            }
            String json_instance = Json.serialize(this);
            Map<String, Object> untyped_instance;
            untyped_instance= (Map<String, Object>)JSON.deserializeUntyped(json_instance);
            return untyped_instance.get(param_name);
            
    	}
	}
	
	public class Response {
		public String expand {get;set;} 
		public String id {get;set;} 
		public String self {get;set;} 
		public String key {get;set;} 
		public Fields_Z fields {get;set;} 

	}
	
	public class Project {
		public String self {get;set;} 
		public String id {get;set;} 
		public String key {get;set;} 
		public String name {get;set;} 

	}
	
	public class Fields {
		public String summary {get;set;} 
		public Status status {get;set;} 
		public Issuetype issuetype {get;set;} 

	}
	
	public class InwardIssue {
		public String id {get;set;} 
		public String key {get;set;} 
		public String self {get;set;} 
		public Fields fields {get;set;} 

	}
	
	public class Issuetype {
		public String self {get;set;} 
		public String id {get;set;} 
		public String description {get;set;} 
		public String iconUrl {get;set;} 
		public String name {get;set;} 
		public Boolean subtask {get;set;} 
		public Integer avatarId {get;set;} 

	}
}