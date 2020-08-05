public class Implementation_Questionnaire_1 {
    
    //Variable Declaration
    public Questionnaire_Implementation__c quesObj{get;set;}
    public boolean isclick{get;set;}
    public boolean questionPage{get;set;}
    public Attachment attach {get;set;}
    public Attachment attach1 {get;set;}
    Public string companyName{get;set;}
    public string Emailval {get;set;}
    public static string DeveloperChanges{get;set;}
    public static string codebackup{get;set;}
    public static string timeDevelopers{get;set;}
    public static string Nooftime{get;set;}
    public static string Timetakenforcommits{get;set;}
    public static string mergeconflictsaddressed{get;set;}
    List<id> OptyIdlist = new list<id>();
    List<Lead> leadIdList = new List<LEad>();
    List<id> ContactEmail = new list<id>();
    List<Opportunity> opptyList = new List<Opportunity>();
    public List<Lead> leadList{get;set;}
    public String selectedUseCases{ get; set; }
    public String selectedUseCasesDeployment{ get; set;}
    public String selectedUseCasesDataLoader{ get; set;}
    public string usedOrNot {get;set;}
    
    Public Implementation_Questionnaire_1(){
        attach = new Attachment();
    } 
    Public Implementation_Questionnaire_1(ApexPages.StandardController stdController)
    {
        quesObj= new Questionnaire_Implementation__c();
        attach = new Attachment();
        attach1 = new Attachment();  
    }
    public Questionnaire_Implementation__c getQuestionnaire() {
        return quesObj;
    }
    public List<Selectoption> getVersionControl() {
        List<Selectoption> option = new List<Selectoption>();
        option.add(new Selectoption('None','None'));
        option.add(new Selectoption('Version Control Used','Version Control Used'));
        option.add(new Selectoption('Version Control Not Used','Version Control Not Used'));               
        return option;
    }   
    public List<Selectoption> getSelUseCases() {
        List<Selectoption> option = new List<Selectoption>();
        option.add(new Selectoption('Set up Production Baseline','Set up Production Baseline'));
        option.add(new Selectoption('Check-in Code/Declarative Changes to Version Control','Check-in Code/Declarative Changes to Version Control'));
        option.add(new Selectoption('Integrate work streams for GIT (Merge complete branches)','Integrate work streams for GIT (Merge complete branches)'));
        return option; 
    }
    public List<Selectoption> getSelUseCasesDeployment() {
        List<Selectoption> option = new List<Selectoption>();
        option.add(new Selectoption('Automated Deployments into Target Orgs','Automated Deployments into Target Orgs'));
        option.add(new Selectoption('Selectively deploy metadata into Orgs','Selectively deploy metadata into Orgs'));
        option.add(new Selectoption('Synchronize Orgs','Synchronize Orgs'));
        return option; 
    }
    public List<Selectoption> getSelUseCasesDataLoader() {
        List<Selectoption> option = new List<Selectoption>();
        option.add(new Selectoption('Migration of parent/child dependencies w/ filters','Migration of parent/child dependencies w/ filters'));
        option.add(new Selectoption('Incremental migration and data masking','Incremental migration and data masking'));
        option.add(new Selectoption('SCScheduling jobs and run as post-deployment activity','Scheduling jobs and run as post-deployment activity'));
        return option; 
    }
    
    //This method is to search for the Opportunity and lead if existing with the provided Email and Company.
    public void searchdata()
    {
        If(string.isnotempty(companyName)||string.isnotempty(Emailval))
        {
            leadList = [select id,name,company,email,isconverted,ConvertedOpportunityId from lead where (company = :companyName or email = :Emailval)];
            System.debug('leadList'+leadList);
            if(leadList.size()>0)
            {
                for(Lead leadObj : leadList)
                {
                    if(leadObj.isconverted == true)
                    {
                        OptyIdlist.add(leadObj.ConvertedOpportunityId);
                    }
                    else
                    {
                        leadIdList.add(leadObj);
                    }
                }
                opptyList = [select id,name,account.name,Contact_Name__r.name,Contact_Name__r.email from opportunity where id in : OptyIdlist];
            }  
        }
    }
    public void shootLasers(Integer numberOfShots) {
        for (Integer i = 0; i < numberOfShots; i++) {
            System.debug('PEW!');
        }
    }
    public void khootLasers(Integer numberOfShots) {
        for (Integer i = 0; i < numberOfShots; i++) {
            System.debug('PEW!');
        }
    }
    public void BootLasers(Integer numberOfShots) {
        for (Integer i = 0; i < numberOfShots; i++) {
            System.debug('PEW!');
        }
    }
    public void ChootLasers(Integer numberOfShots) {
        for (Integer i = 0; i < numberOfShots; i++) {
            System.debug('PEW!');
        }
    }
    //The below method is to save the information on submitting the implementation questionnaire form.
    public PageReference Save()
    {
        searchdata();
        isclick = true;
        Id LeadRecordTypeId = Schema.SObjectType.Questionnaire_Implementation__c.getRecordTypeInfosByName().get('Lead Questionnaire').getRecordTypeId();
        System.debug('LeadRecordTypeId'+LeadRecordTypeId);
        Id OptyTypeId = Schema.SObjectType.Questionnaire_Implementation__c.getRecordTypeInfosByName().get('Opportunity Questionnaire').getRecordTypeId();
        System.debug('OptyTypeId'+OptyTypeId);
        questionPage = true;                                
        
        //Map all the fields to the Questionnaire_Implementation__c Object.
        try {
            quesObj.Email__c = Emailval;
            quesObj.Company_Name__c = companyName;
            //Check if there is any Opportunity exisitng with Email or Company name 
            if(opptyList  !=null && opptyList.size()>0)
            {
                for(Opportunity oppObj : opptyList )
                {
                    if((string.isnotempty(companyName) && oppObj.Account.name.equalsIgnoreCase(companyName))||(string.isnotempty(Emailval) && oppObj.Contact_Name__r.email.equalsIgnoreCase(Emailval)))
                    {
                        quesObj.recordtypeId = OptyTypeId;
                        quesObj.OpportunityAcc__c = oppObj.accountid;
                    } 
                }
            }
            //Else check for the Lead
            else if(leadIdList!=null && leadIdList.size()>0)
            {
                for(lead leadobjvar: leadIdList)
                {
                    if((string.isnotempty(companyName) && leadobjvar.company.equalsIgnoreCase(companyName))||(string.isnotempty(Emailval) && leadobjvar.email.equalsIgnoreCase(Emailval)))
                    {
                        quesObj.recordtypeId = LeadRecordTypeId;
                        quesObj.Lead__c = leadobjvar.id;
                    }
                }
            }
            //Iserting into Implementation Questionnaire Object.
            quesObj.Select_use_VC__c=selectedUseCases;
            quesObj.Select_use_cases_to_evaluate_Dataloader__c=selectedUseCasesDataLoader;
            quesObj.Select_use_cases_for_Deployment__c=selectedUseCasesDeployment;
            System.debug('quesObj'+quesObj);  
            insert(quesObj);
            //Inserting the uploaded files as attachments on Implementation Questionnaire Object.
            if(attach.name!=null && attach.body!=null){
                attach.ParentId = quesObj.id;
                insert attach;
            }
            if(attach1.name!=null && attach1.body!=null){
                attach1.ParentId = quesObj.id;
                insert attach1;
            }
            
        } 
        //Catch the Exceptions if any
        catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        //Redirecting to "Thank you page" after submitting Implementation Questionnaire form.
        PageReference pg = page.ThankYouPage;
        pg.setRedirect(true);
        return pg;
        
    }


}