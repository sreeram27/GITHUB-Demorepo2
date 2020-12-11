public class LGJiraCreateIssueResponse{

    public String id{get;set;}
    public String key{get;set;}
    public String self{get;set;}
    public String response{get;set;}
    //public string code {get;set;}
    //public string detail {get;set;}
    //public string message {get;set;}
    
    public List<Exceptions> exceptions {get;set;} 
    
        public class Exceptions {
        public String type_Z {get;set;} // in json: type
        public String code {get;set;} 
        public String message {get;set;} 
        public String detail {get;set;} 

        
    }

}