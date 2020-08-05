public class zoho_Json2Apex {
    
    public List<Data> data;
    
    public class Data{
        public String id;
        public String ticketNumber;
        public String email;
        public String subject;
        public String status;
        //public String statusType;
        public String resolution;
        public String classification;
        public String createdTime;
        public String category;
        public String priority;
        public String channel;
        public String dueDate;
        public String closedTime;
        public String modifiedTime;
        public String responseDueDate;
        public Department department;
        public Contact contact;
        public Assignee assignee;
        public Cf  cf;
        public String customerResponseTime;
    }

    public Class Cf{
        public String cf_ar_version;
        public String cf_escalation_type;
    }
	    
    public Class Department{
        public String id;
        public String name;
    }
    public Class Contact{
        public String firstName;
        public String lastName;
        public String email;
        public Account account;
        public String phone;
    }
    public Class Assignee{
        public String firstName;
        public String lastName;
        public String email;
        public String id;
    }
    
    public Class Account{
        public String accountName;
    }
    
    public static zoho_Json2Apex parse(String json){
        return (zoho_Json2Apex) System.JSON.deserialize(json,zoho_Json2Apex.class);
    }
}