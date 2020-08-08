public class JiraSearchIssueResponse {

		public String expand {get;set;} 
		public Integer startAt {get;set;} 
		public Integer maxResults {get;set;} 
		public Integer total {get;set;} 
		public List<JiraIssueResponse_Instance.Response> issues {get;set;} 

}