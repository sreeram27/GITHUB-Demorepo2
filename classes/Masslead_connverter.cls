public class Masslead_connverter {
    public List<Lead> selectedItems{get;set;}
    public Lead lc{get;set;} 
    public Task leadTask{get;set;}
    public Contact con{get;set;}
    public Account acc{get;set;}
    public Boolean sendEmailBox {get;set;}
    Public List<String> selectednames ;
    Public List<String> selectedopps ;
    
    public String accountName {get;set;}
    public String opportunityName {get;set;}
    
    public Boolean isEditable {get;set;}
    public String oppOption {get;set;}
    public List<SelectOption> oppOptions {get;set;}
    public String taskOption {get;set;}
    public List<SelectOption> taskOptions {get;set;}
    public String accOption {get;set;}
    public List<SelectOption> accOptions {get;set;}
    public String errorMessages {get;set;}
    List<Database.LeadConvertResult> lcr;
    
    
    
    public Masslead_connverter(ApexPages.StandardSetController controller) {
        selectedItems = controller.getSelected();
        selectednames= new List<String>();
        selectedopps= new List<String>();
        lc = new Lead();
        
        leadTask = new Task();
        con = new Contact();
        sendEmailBox = false;
        opportunityName = '';
        acc = new Account();
        con.AccountId = acc.Id;
        errorMessages = '';
        
        
        if (selectedItems.size() <= 0)
        {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select at least one lead to convert.'));
            isEditable = false;
        }
        else if (selectedItems.size() > 100)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select fewer than 100 leads to convert.'));
            isEditable = false;
        }
        else
        {   
            
            for(Lead s: selectedItems ){
                accountName = s.Company;
                selectednames.add(accountName);
                System.debug('accountName'+accountName);
                opportunityName = accountName;
                selectedopps.add(opportunityName);
                System.debug('opportunityName'+opportunityName);
                
                try
                {
                    User usr = [select Id from User where Id=:selectedItems[0].OwnerId];	
                    acc.OwnerId =  selectedItems[0].OwnerId;
                    System.debug('acc.OwnerId'+acc.OwnerId);
                }
                catch (Exception ex)
                {
                    acc.OwnerId = UserInfo.getUserId();
                } 
            } 
    
        }
    }
    
    public PageReference convertLeads()
    {
        Database.LeadConvert ltc = new database.LeadConvert();
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        
        List<Account> newAccounts=new List<Account>();
        For(String  accnames : selectednames ){
            System.debug('accnames:'+accnames);
            Account acc1 = new Account();
            acc1.Name = accnames;
            System.debug('acc1.Name'+  acc1.Name);
            acc1.Phone = selectedItems[0].Phone;
            acc1.BillingCity = selectedItems[0].City;
            acc1.BillingCountry = selectedItems[0].Country;
            acc1.BillingPostalCode = selectedItems[0].PostalCode;
            acc1.BillingState = selectedItems[0].State;
            acc1.BillingStreet = selectedItems[0].Street;
            acc1.Fax = selectedItems[0].Fax;
            acc1.Rating = selectedItems[0].Rating;
            acc1.NumberOfEmployees = selectedItems[0].NumberOfEmployees;
            acc1.Website = selectedItems[0].Website;
            acc1.Business_Unit__c=selectedItems[0].Business_Unit__c;
            acc1.Company_URL__c=selectedItems[0].Company_URL__c;
            acc1.Other_Product_Interests__c=selectedItems[0].Other_Product_Interests__c;
            acc1.Partner_Margin__c=selectedItems[0].Partner_Margin__c;
            acc1.Partner_Name__c=selectedItems[0].Partner_Name__c;
            acc1.Partner_Type__c=selectedItems[0].Partner_Type__c;
            acc1.Time_Zone__c=selectedItems[0].Time_Zone__c;
            
            if (acc.OwnerId != null)
            {
                acc1.OwnerId = acc.OwnerId;
            }
            con.AccountId = acc1.Id;
            newAccounts.add(acc1);
            
        }
        
        System.debug('newAccounts'+newAccounts);
        
        for (Lead myLead : selectedItems  )
        {
            ltc = new database.Leadconvert();
            ltc.setConvertedStatus(convertStatus.MasterLabel);
            ltc.setLeadId(myLead.Id);
            ltc.setAccountId(con.AccountId); 
            ltc.setSendNotificationEmail(sendEmailBox);
            if (acc.OwnerId != null)
            {
                ltc.setOwnerId(acc.OwnerId);
            }    
            System.debug('ltc'+ltc);
            leadsToConvert.add(ltc);
            
        }
        
        try{			
            String retUrl = Apexpages.currentPage().getParameters().get('retUrl');
            lcr = Database.convertLead(leadsToConvert);
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Lead are Converted Successfully.' ));
            return new PageReference(retUrl);
            
           }
        catch(Exception ex)
        {
            errorMessages += ex.getMessage();
            if (errorMessages.contains('RECORD_IN_USE_BY_WORKFLOW'))
            {
                String[] findRow = errorMessages.split('row');
                String[] findRowNum = findRow[1].split(';');
                Integer i = Integer.valueOf(findRowNum[0]);	
                errorMessages += '\n Cannot convert the following lead: ' + selectedItems[i].FirstName + ' ' +
                    selectedItems[i].LastName + ' with Id ' + selectedItems[i].Id;		
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessages));
            return null;
        }
    }
    
    public PageReference cancel()
    {
        String retUrl = Apexpages.currentPage().getParameters().get('retUrl');
        if (retUrl == '')
        {
            return new PageReference('/');
        }
        else
        {
            return new PageReference(retUrl);
        }
        
    }
    
}