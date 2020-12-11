/**
@Author : Accenture Offshore Dev team
@name : AP25_Email_Controller 
@CreateDate :2/27/2018
@Description :Controller Class for Retreiving Dynamic Details for Email Template.
*/

/*Controller Class for Retreiving Dynamic Details for Email Template */
public with sharing class AP25_Email_Controller {
    
    public Id orderRecId{get;set;}
    public String accExecutive{get;set;}
    public Set<String> ProdStages {get;set;}
    
    /* Class Constuctor */
    public AP25_Email_Controller(){
        ProdStages = new Set<String>{UtilConstants.IGAP_Lost, UtilConstants.IGAP_Dead, UtilConstants.Lost, UtilConstants.Dead};
            //GetCurrentUser();
            }
    
    /* Method to retreive User Details  */  
    public User getCurrUser() {
        User curUser;
        try {
            curUser = [SELECT id, email, username, usertype,firstname, lastname, phone, title,
                       street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax from USER
                       WHERE id = :UserInfo.getUserId() limit 1];
        }
        catch(Exception ex) {
            //System.debug(ex.getMessage());
            UTIL_LoggingService.logHandledException(ex,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.ap25_Email_Controller,UtilConstants.getCurrUser1,UtilConstants.triggerName1,LoggingLevel.ERROR); 
        }
        
        return curUser;
    }
    
    /* Method to retreive Product Names with their corresponding stages details    */
    public List<QuoteLineItem> getLstQLI() {
        
        List<QuoteLineItem> lstQLI;
        try {
            lstQLI = [SELECT Id,ProductName__c,ProductStage__c,Renewed_with_Changes__c FROM Quotelineitem WHERE ProductStage__c NOT in : ProdStages AND QuoteID IN 
                      (select Quoteid from Order where Id = :orderRecId) limit 100];
        
           //system.debug('*************lstQLI'+lstQLI);
           
           } 
        
         
        
        catch(Exception ex) {
            //System.debug(ex.getMessage());
            UTIL_LoggingService.logHandledException(ex,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.ap25_Email_Controller,UtilConstants.getLstQLI1,UtilConstants.triggerName2,LoggingLevel.ERROR); 
        }
        return lstQLI;  
    }    
    /* Method to retreive Account Executive Details    */
    public string getAEDetails() {    
        try {        
            for(AccountTeamMember tempAccRole : [SELECT Id, Account.Name, User.firstname, User.lastname, TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole =: UtilConstants.Account_Executive AND AccountId IN (Select AccountId from Order where Id= :orderRecId) limit 100]) {
                if(tempAccRole.TeamMemberRole.equalsIgnoreCase(UtilConstants.Account_Executive)){
                    accExecutive =  tempAccRole.User.firstname + UtilConstants.Space +tempAccRole.User.lastname  ;   
                }     
            }  
        }
        catch(Exception ex) {
            //System.debug(ex.getMessage());
            UTIL_LoggingService.logHandledException(ex,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.ap25_Email_Controller,UtilConstants.getAEDetails1,UtilConstants.triggerName3,LoggingLevel.ERROR); 
        }
        return accExecutive ;
    } 
    /* Method to retreive Account Manager Details    */
    public string getAMDetails() {
        string csvManagers = ''; 
        try {        
            for(AccountTeamMember tempAccRole : [SELECT Id, Account.Name,User.firstname, User.lastname, TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole =: UtilConstants.Account_Manager AND AccountId IN (Select AccountId from Order where Id= :orderRecId) limit 100]) 
            {
                if(tempAccRole.TeamMemberRole.equalsIgnoreCase(UtilConstants.Account_Manager)) {
                    csvManagers +=  tempAccRole.User.firstname + UtilConstants.Space + tempAccRole.User.lastname + UtilConstants.COMMA + UtilConstants.Space;   
                }
            } 
            //if not managers, don't remove comma to avoid out of bounds error. 
            if(!String.isEmpty(csvManagers)){
                csvManagers = csvManagers.substring(0, csvManagers.length() - 2);
            }   
        }
        catch(Exception ex) {
            //System.debug(ex.getMessage());
            UTIL_LoggingService.logHandledException(ex,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.ap25_Email_Controller,UtilConstants.getAMDetails1,UtilConstants.triggerName4,LoggingLevel.ERROR); 
        }
        return csvManagers;
    }
 
    
     /* Method to retreive Account Manager Details    */
    public string getAccImpl() {
       //system.debug('$$$$$$$$$Im Here');
        
        string csvManagers = ''; 
        try {        
            for(AccountTeamMember tempAccRole : [SELECT Id, Account.Name,User.firstname, User.lastname, TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole =:UtilConstants.implementer AND AccountId IN (Select AccountId from Opportunity where Id= :orderRecId) limit 1]) 
            {
                if(tempAccRole.TeamMemberRole.equalsIgnoreCase(UtilConstants.implementer)) {
                    csvManagers +=  tempAccRole.User.firstname + UtilConstants.Space + tempAccRole.User.lastname + UtilConstants.COMMA + UtilConstants.Space;   
                }
            } 
            //if not managers, don't remove comma to avoid out of bounds error. 
            if(!String.isEmpty(csvManagers)){
                csvManagers = csvManagers.substring(0, csvManagers.length() - 2);
            }   
        
          //system.debug('$$$csvManagers'+csvManagers);
        
        }
        catch(Exception ex) {
            //System.debug(ex.getMessage());
            UTIL_LoggingService.logHandledException(ex,UtilConstants.ORGID,UtilConstants.APPNAME,UtilConstants.ap25_Email_Controller,UtilConstants.getAMDetails1,UtilConstants.triggerName4,LoggingLevel.ERROR); 
        }
        return csvManagers;
    }
 
}