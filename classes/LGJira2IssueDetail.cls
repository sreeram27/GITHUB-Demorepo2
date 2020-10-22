public class LGJira2IssueDetail{
    //public Boolean IsSandbox {get;set;}
    public String expand{get;set;}
    public String id{get;set;}
    public String self{get;set;}
    public String key{get;set;}
    public FieldDetails fields{get;set;}
    //IsSandbox = [Select IsSandbox, InstanceName From Organization].isSandbox;
    public class FieldDetails{
        
        //lastViewed time 
        public String lastViewed{get;set;}
        
        //subtasks
        public List<String> subtasks{get;set;}
        
        // issue type
        public CustomFieldClass issuetype{get;set;}
        
        
        //EBA Request ECD
        public String customfield_11561{get;set;}
        
        //Grp Renewal Date
        public String customfield_12401{get;set;}
        
        //CS90
        public CustomFieldClass customfield_11500{get;set;}
        
        //MembershipCount
        public String customfield_11492{get;set;}
        
        //ACES - PPO
        public CustomFieldClass customfield_11491{get;set;}
        
        
        //Account Executive
        public String customfield_11493{get;set;}
        
        // reporter
        public CustomFieldClass reporter{get;set;}
        
        
        // LHOL
        public CustomFieldClass customfield_11495{get;set;}
        
        
        // yes 1
        public CustomFieldClass customfield_13675{get;set;}
        
        
        // Reference Type - project
        public CustomFieldClass customfield_11481{get;set;}
        
        
        // group type
        public CustomFieldClass customfield_11483{get;set;}
        
        
        //Receipt Date
        public String customfield_11485{get;set;}
        
        //Funding Type development environment
        public List<CustomFieldClass> customfield_15105{get;set;}
        
        //Funding Type production environment
        public List<CustomFieldClass> customfield_14100{get;set;}
        
        //Have all tables been promoted?
        public List<String> customfield_11487{get;set;}
        
        //watches
        public CustomFieldClass watches{get;set;}
        
        
        //updated time
        public String updated{get;set;}
        
        //description
        public String description{get;set;}
        
        //Have all issue logs been replied to and closed?
        public List<String> customfield_11452{get;set;}
        
        //Implementations Coordinator Lead
        public String customfield_12301{get;set;}
        
        //Has group Eligibility been moved into production?
        public List<String> customfield_11454{get;set;}
        
        //1. Have all issue logs been replied to and closed?
        public List<String> customfield_11456{get;set;}
        
        //Have CSRs been moved to Load Status?
        public List<String> customfield_11455{get;set;}
        
        //Implementation SF Link
        public String customfield_11447{get;set;}
        
        //Implementation SF Log #
        public String customfield_11446{get;set;}
        
        //Effective Date
        public String customfield_11449{get;set;}
        
        //created time
        public String created{get;set;}
        
        //Corporate Receipt Date in development environment
        public String customfield_13000{get;set;}
        
        //Corporate Receipt Date in production environment
        public String customfield_12606{get;set;}
        
        //Sales Market in development environment
        public List<CustomFieldClass> customfield_14318{get;set;}
        
        //Sales Market in production environment
        public List<CustomFieldClass> customfield_13600{get;set;}
        
        
        //status
        public CustomFieldClass status{get;set;}
        
        
        // creator
        public CustomFieldClass creator{get;set;}
        
        
        //Yes
        public CustomFieldClass customfield_11639{get;set;}
        
        
        //Normal
        public CustomFieldClass customfield_11626{get;set;}
        
        // Initial
        public List<CustomFieldClass> customfield_11609{get;set;}
        
        //Elaine Patterson
        public CustomFieldClass customfield_13310{get;set;}
        
        
        // project
        public CustomFieldClass project{get;set;}
        
        
        public String summary{get;set;}
        
        //Group Number/Case in development environment
        public List<String> customfield_13121{get;set;}
        
        //Group Number/Case in production environment
        public List<String> customfield_12800{get;set;}
        
        //State in development environment
        public String customfield_14108{get;set;}
        
        //State in production environment
        public String customfield_13402{get;set;}
        
        //record Id
        public String customfield_11445{get;set;}
        
        //Maintenance type
        public CustomFieldClass customfield_11558{get;set;}
        
        //Group Size for Sandbox
        public List<CustomFieldClass> customfield_16500{get;set;}
        //Group Size for Production
        public List<CustomFieldClass> customfield_14800{get;set;}
        
        //Plan Type
        public CustomFieldClass customfield_11672{get;set;}
        
        
        //Eligible Employees for Sandbox
        public String customfield_16615{get;set;}
        
        //Eligible Employees for Production
        public String customfield_14801{get;set;}
        
        public void put(String name, String value, FieldDetails fieldClass) {
            
            Organization org = [Select IsSandbox, InstanceName From Organization LIMIT 1];
            boolean IsSandbox = org.IsSandbox;
            If(Test.isRunningTest()){
                IsSandbox = true;
            }
            
            
            if (name == 'issuetype') {
                
                CustomFieldClass issuetype = new CustomFieldClass();
                issuetype.name = value;
                fieldClass.issuetype = issuetype;
            }
            if (name == 'customfield_11561' && value != null && value != '') {
                customfield_11561 = value;
            }
            if (name == 'customfield_11558' && value != LGJiraValueSet.NewBusiness) {
                
                CustomFieldClass customfield_11558 = new CustomFieldClass();
                if (value == LGJiraValueSet.Renewal) {
                    
                    customfield_11558.value = value;
                    
                } else if (value == LGJiraValueSet.ChangeRequest) {
                    
                    customfield_11558.value = LGJiraValueSet.JiraChangeRequest;
                }
                 else if (value == LGJiraValueSet.Term) {
                    
                    customfield_11558.value = LGJiraValueSet.JiraChangeRequest;
                    
                }
                else if (value == LGJiraValueSet.PreWork) {
                    
                    customfield_11558.value = LGJiraValueSet.JiraChangeRequest;
                    
                }
                
                fieldClass.customfield_11558 = customfield_11558;
                
            }
            if (name == 'customfield_12401' && value != null && value != '') {
                customfield_12401 = value;
            }
            if (name == 'customfield_11500' && value != null && value != '' && value != 'null') {
                
                CustomFieldClass customfield_11500 = new CustomFieldClass();
                customfield_11500.value = value;
                fieldClass.customfield_11500 = customfield_11500;
            }
            
            //Group Size for sandbox
            if(IsSandbox==true)
            {
            if (name == 'customfield_16500' && value != null && value != '' && value != 'null') {
                    
                    CustomFieldClass customfield_16500 = new CustomFieldClass();
                if(value =='1 - 50')
                {
                    customfield_16500.value = '1-50';
                }
                else if (value == '51 - 99')
                {
                    customfield_16500.value = '51-99';
                }
                else if (value == '100 - 249')
                {
                    customfield_16500.value = '100-249';
                }
                else if (value == '250 - 499')
                {
                    customfield_16500.value = '250-499';
                }
                else if (value == '500 - 999')
                {
                    customfield_16500.value = '500-999';
                }
                else if (value == '1000+')
                {
                    customfield_16500.value = '1000+';
                }
                    
                    fieldClass.customfield_16500= new List<CustomFieldClass>();
                    fieldClass.customfield_16500.add(customfield_16500);
                }   
            }
            
            //Group Size for Production
            else
            {
                if (name == 'customfield_14800' && value != null && value != '' && value != 'null') {
                    
                    CustomFieldClass customfield_14800 = new CustomFieldClass();
                if(value =='1 - 50')
                {
                    customfield_14800.value = '1-50';
                }
                else if (value == '51 - 99')
                {
                    customfield_14800.value = '51-99';
                }
                else if (value == '100 - 249')
                {
                    customfield_14800.value = '100-249';
                }
                else if (value == '250 - 499')
                {
                    customfield_14800.value = '250-499';
                }
                else if (value == '500 - 999')
                {
                    customfield_14800.value = '500-999';
                }
                else if (value == '1000+')
                {
                    customfield_14800.value = '1000+';
                }
                    
                    fieldClass.customfield_14800= new List<CustomFieldClass>();
                    fieldClass.customfield_14800.add(customfield_14800);
                }
            }
            //Eligible Employees for Sandbox
            if(IsSandbox==true)
            {
                
            if (name == 'customfield_16615' && value != null && value != '') {
              customfield_16615 = value;
            }
            }
            //Eligible Employees for Sandbox
            else
            {
                if (name == 'customfield_14801' && value != null && value != '') {
              customfield_14801 = value;
            }
                
            }
            
            //Plan Type
            if (name == 'customfield_11672' && value != null && value != '' && value != 'null') {
                    
                    CustomFieldClass customfield_11672 = new CustomFieldClass();
                	customfield_11672.value = value;
                fieldClass.customfield_11672 = customfield_11672;
            }
            
            /*if (name == 'customfield_13207') {
customfield_13207 = value;
}*/
            if (name == 'customfield_11492' && value != null && value != '') {
                customfield_11492 = value;
            }
            if (name == 'customfield_11491' && value != null && value != '') {
                
                CustomFieldClass customfield_11491 = new CustomFieldClass();
                customfield_11491.value = value;
                fieldClass.customfield_11491 = customfield_11491;
            }
            if (name == 'customfield_11493' && value != null && value != '') {
                customfield_11493 = value;
            }
            if (name == 'customfield_11495' && value != null && value != '' && value != 'null') {
                
                CustomFieldClass customfield_11495 = new CustomFieldClass();
                
                customfield_11495.value = value;
                
                fieldClass.customfield_11495 = customfield_11495;
            }
            if (name == 'customfield_11481' && value != null && value != '') {
                
                CustomFieldClass customfield_11481 = new CustomFieldClass();
                customfield_11481.value = value;
                fieldClass.customfield_11481 = customfield_11481;
            }
            if (name == 'customfield_11483' && value != null && value != '') {
                
                CustomFieldClass customfield_11483 = new CustomFieldClass();
                customfield_11483.value = value;
                fieldClass.customfield_11483 = customfield_11483;
            }
            if (name == 'customfield_11485' && value != null && value != '') {
                customfield_11485 = value;
            }
            /* funding type,jira field name in development envoronment: customfield_15105 */
            
            /*below code is only for development environment*/
            
            if(IsSandbox==true)
            {
                if (name == 'customfield_15105' && value != null && value != '' && value != 'null') {
                    
                    CustomFieldClass customfield_15105 = new CustomFieldClass();
                    customfield_15105.value = value;
                    fieldClass.customfield_15105 = new List<CustomFieldClass>();
                    fieldClass.customfield_15105.add(customfield_15105);
                }
            }/*end comment for funding type in development environment*/
            
            
            /* funding type,jira field name in production envoronment: customfield_14100 */
            
            /*below code is only for production environment*/
            else
            {
                if (name == 'customfield_14100' && value != null && value != '' && value != 'null') {
                    
                    CustomFieldClass customfield_14100 = new CustomFieldClass();
                    customfield_14100.value = value;
                    fieldClass.customfield_14100 = new List<CustomFieldClass>();
                    fieldClass.customfield_14100.add(customfield_14100);
                }   
                
            }/*end comment for funding type in production*/
            
            /*   if (name == 'customfield_15105' && value != null && value != '' && value != 'null') {

CustomFieldClass customfield_15105 = new CustomFieldClass();
customfield_15105.value = value;
fieldClass.customfield_15105 = new List<CustomFieldClass>();
fieldClass.customfield_15105.add(customfield_15105);
}
*/
            if (name == 'description' && value != null && value != '') {
                description = value;
            }
            if (name == 'customfield_12301' && value != null && value != '') {
                customfield_12301 = value;
            }
            if (name == 'customfield_11447' && value != null && value != '') {
                customfield_11447 = value;
            }
            if (name == 'customfield_11446' && value != null && value != '') {
                customfield_11446 = value;
            }
            if (name == 'customfield_11449' && value != null && value != '') {
                customfield_11449 = value;
            }
            
            /* state,jira field name in development envoronment: customfield_14108 */
            
            /*below code is only for development environment*/
            if(IsSandbox==true)
            {
                if (name == 'customfield_14108' && value != null && value != '') {
                    customfield_14108 = value;
                }
            }/*end comment for state in development environment*/
            
            /* state,jira field name in production envoronment: customfield_13402 */
            
            /*below code is only for production environment*/
            else
            {
                if (name == 'customfield_13402' && value != null && value != '') {
                    customfield_13402 = value;
                }
                
                
            }/*end comment for state in production environment*/
            
            /* Corporate Receipt Date,jira field name in development envoronment: customfield_13000 */
            
            /*below code is only for development environment*/
            
            if(IsSandbox==true)
            {
                if (name == 'customfield_13000' && value != null && value != '') {
                    customfield_13000 = value;
                }
            }/*end comment for Corporate Receipt Date in development environment*/
            
            
            /* Corporate Receipt Date,jira field name in production envoronment: customfield_12606 */
            
            /*below code is only for production environment*/
            else
            {
                if (name == 'customfield_12606' && value != null && value != '') {
                    customfield_12606 = value;
                }
                
            }/*end comment for Corporate Receipt Date in production environment*/
            
            /* Sales Market,jira field name in development envoronment: customfield_14318 */
            
            /*below code is only for development environment*/
            if(IsSandbox==true)
            {
                if (name == 'customfield_14318') {
                    
                    CustomFieldClass customfield_14318 = new CustomFieldClass();
                    customfield_14318.value = value;
                    fieldClass.customfield_14318 = new List<CustomFieldClass>();
                    fieldClass.customfield_14318.add(customfield_14318);
                }
            }/*end comment for Sales Market in development environment*/
            
            /* Sales Market,jira field name in production envoronment: customfield_13600 */
            
            /*below code is only for production environment*/
            else
            {
                if (name == 'customfield_13600') {
                    
                    CustomFieldClass customfield_13600 = new CustomFieldClass();
                    customfield_13600.value = value;
                    fieldClass.customfield_13600 = new List<CustomFieldClass>();
                    fieldClass.customfield_13600.add(customfield_13600);
                }
                
            }/*end comment for Sales Market in production environment*/
            
            if (name == 'customfield_11445' && value != null && value != '') {
                customfield_11445 = value;
            }
            if (name == 'project') {
                List<String> subString = value.split(';');
                CustomFieldClass project = new CustomFieldClass();
                if (subString.size() == 2) {
                    project.name = subString.get(0);
                    project.key = subString.get(1);
                }
                fieldClass.project = project;
            }
            if (name == 'summary' && value != null && value != '') {
                summary = value;
            }
            
            /* Group Name/Number or Case,jira field name in development envoronment: customfield_13121 */
            
            /*below code is only for development environment*/
            
            if(IsSandbox==true)
            {
                if (name == 'customfield_13121' && value != null && value != '') {
                    List<String> customfield_13121 = new List<String>();
                    customfield_13121.add(value);
                    fieldClass.customfield_13121 = customfield_13121;
                }
            }   /*end comment for Group Name/Number or Case in development environment*/
            
            
            /* Group Name/Number or Case,jira field name in production envoronment: customfield_12800 */
            
            /*below code is only for production environment*/
            else
            {
                
                if (name == 'customfield_12800' && value != null && value != '') {
                    List<String> customfield_12800 = new List<String>();
                    customfield_12800.add(value);
                    fieldClass.customfield_12800 = customfield_12800;
                }
            }   /*end comment for Group Name/Number or Case in production environment*/
            
            
        }
        
    }
    
    public class CustomFieldClass{
        
        public String self{get;set;}
        public String value{get;set;}
        public String id{get;set;}
        public String key{get;set;}
        public String name{get;set;}
        public String description{get;set;}
        public String iconUrl{get;set;}
        public String subtask{get;set;}
        public String avatarId{get;set;}
        public String watchCount{get;set;}
        public String isWatching{get;set;}
        //public Urls avatarUrls{get;set;}
        //public Category projectCategory{get;set;}
        //public Category statusCategory{get;set;}
        
        
        public String displayName{get;set;}
        public Boolean active{get;set;}
        public String timeZone{get;set;}
        
        
    }
    
    /*public class Urls{

public String 48x48{get;set;}
public String 24x24{get;set;}
public String 16x16{get;set;}
public String 32x32{get;set;}

}

public class Category{

public String self{get;set;}
public String id{get;set;}
public String name{get;set;}
public String key{get;set;}
public String colorName{get;set;}

}*/
    
}