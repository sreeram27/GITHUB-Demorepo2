/**
@Author : Accenture Offshore Dev team
@name : InternalhirerachyTesting
@CreateDate :2/11/2019
@Description :This class creates 'Role Hirerachy of AccountMangers or AccountEXecutives of an accountteam which is associated with Internal
              commission. It is called From InternalCommision Omniscript
*/ 
global without sharing class CreateInternalCommissionhirerachy implements vlocity_ins.VlocityOpenInterface2{ 
    public static List<id>useridList = new List<id>(); 
    public static set<Internal_Commission_Reporting_Hierarchy__c> icrHirerachyRec = new set<Internal_Commission_Reporting_Hierarchy__c>();
    public static Map<id,String> accountTeamMemberRole  = new Map<id,String>();         
    public static list<Internal_Commission_Reporting_Hierarchy__c>  icrHirerachyReclist = new  list<Internal_Commission_Reporting_Hierarchy__c>();
   
    /*Implementation of invokeMEthod from VlocityOpenInterface2 interface.*/
    global static Boolean invokeMethod(String methodName,Map<String,Object> inputMap,Map<String,Object> outMap,
                                       Map<String,Object> optns){
        hirerachyrec(inputMap, outMap, optns);           
        return true;                                      
    }
    /*
    Method Name: hirerachyrec
    Method Signature:public  static void hirerachyrec(Map<String,Object> inputMap, Map<String,
                                   Object> outMap,Map<String,Object> optns)
    Method Return Type: void
    Method Description: This method is Get accountID from Omniscript from where it builds hirerachy for accountManager or 
                        Accountexecutives
    */
    
    public  static void hirerachyrec(Map<String,Object> inputMap, Map<String,
                                   Object> outMap,Map<String,Object> optns){
                                   
     try{
        Id accountId= String.valueof(inputMap.get('AccountId'));            
            Map<String,Object> icRequestType = (Map<String,Object>) inputMap.get('SelectICTypeRequest');        
        List<id> userlistid = new List<id>();
        List<accountteammember> acmb = [Select id,TeamMemberRole,UserId  from accountteammember where accountid =:accountId];       
        List<id> managerIDS = new List<id>();                 
        System.debug(String.Valueof(inputMap.get('OpportunityType')));
         /* If account Team is Selected at omniscript we shall collect all the account managers/executives in that account team*/         
         if((String.Valueof(inputMap.get('OpportunityType')) =='Renewal') || (String.Valueof(inputMap.get('OpportunityType')) =='In Group Add Product')){     
            for(accountteammember acc:acmb){                       
                if(acc.TeamMemberRole=='Account Manager' || acc.TeamMemberRole=='Account Executive'){
                    managerIDS.add(acc.UserId);
                }           
                accountTeamMemberRole.put(acc.UserId,acc.TeamMemberRole);
        }}
        else if((String.Valueof(icRequestType.get('SelectRequestType')) =='Account Team')){
            for(accountteammember acc:acmb){                       
                if(acc.TeamMemberRole=='Account Manager' || acc.TeamMemberRole=='Account Executive'){
                    managerIDS.add(acc.UserId);
                }           
                accountTeamMemberRole.put(acc.UserId,acc.TeamMemberRole);
        }}
        /* If account Team is Not Selected at omniscript we shall collect all the Sales managers/RVP in that account team*/ 
        else{
            for(accountteammember acc:acmb){                       
                if(acc.TeamMemberRole=='Sales Executive' || acc.TeamMemberRole=='SR Sales Consultant'){
                    managerIDS.add(acc.UserId);
                }           
                accountTeamMemberRole.put(acc.UserId,acc.TeamMemberRole);                               
        }} 
         
         /* Only The AccountManagers/Executives whose reportsto field is not null are processed here*/          
         List<user> userdetails = [select id,ReportsTo__c from user where id in :managerIDS and ReportsTo__c!=null];   
             for(user u:userdetails){
                    userlistid.add(u.id);    
                    CreatelistForhirerachy(u);                                                       
                    userlistid.addAll(calluserfunction(u.ReportsTo__c,u.id));             
                      for(Integer i =0; i<=userlistid.size();i++){                 
                         for(Integer j=i+2;j<=userlistid.size()-1;j++){ 
                              Internal_Commission_Reporting_Hierarchy__c icindirect = new Internal_Commission_Reporting_Hierarchy__c();                                                    
                              icindirect.Role__c = accountTeamMemberRole.get(userlistid[i]);                        
                              icindirect.Reports_To__c=userlistid.get(j);
                              icindirect.User__c=userlistid.get(i);
                              icindirect.Account_Relationship_Type__c ='InDirect';                      
                              icrHirerachyRec.add(icindirect);
                          }
                        }                                                  
                     userlistid.clear();
                     useridList.clear();   
             } 
                icrHirerachyReclist.addAll(icrHirerachyRec );   
            for(Internal_Commission_Reporting_Hierarchy__c  ic:icrHirerachyReclist){
                ic.Account_Name__c=accountId;
            }
            insert  icrHirerachyReclist ; 
       }
       catch(exception e){
           System.debug(e.getLinenumber()+e.getMessage());
       }                                           
    }
    /*
    Method Name: CreatelistForhirerachy
    Method Signature: public static void CreatelistForhirerachy(user u )
    Method Return Type: void
    Method Description: This method is Called from mutilple places (hirerachyrec,calluserfunction) which majorly takes
                        User records as input and create self and direct releationship records 
    */
       
    public static void CreatelistForhirerachy(user u ){
            Internal_Commission_Reporting_Hierarchy__c ic = new Internal_Commission_Reporting_Hierarchy__c(); 
            Internal_Commission_Reporting_Hierarchy__c ic1 = new Internal_Commission_Reporting_Hierarchy__c();                  
            ic.Role__c =  accountTeamMemberRole.get(u.id);
            ic.Reports_To__c = u.ReportsTo__c;
            ic.User__c=u.id; 
            ic.Account_Relationship_Type__c ='Direct';
            icrHirerachyRec.add(ic);  
            ic1.Role__c =  accountTeamMemberRole.get(u.id);
            ic1.Reports_To__c  = u.id;
            ic1.Account_Relationship_Type__c ='self';
            ic1.User__c=u.id; 
            icrHirerachyRec.add(ic1);      
    }  
    
    /*
    Method Name: calluserfunction
    Method Signature:public static List<Id> calluserfunction(ID userid, ID Uid)
    Method Return Type: List<Id>
    Method Description: This method is Recursive Method that is called for each accountexecutive and get the hirerachy list for that
                        account executive and returned list is used to create indirect releationship in hirerachyrec Method and this method
                        it self create self and direct releationship records.
    */          
    public static List<Id> calluserfunction(ID userid, ID Uid){           
        Map<id,List<id>> hirerachyMap = new Map<id,List<id>>();             
        User u = [select id,ReportsTo__c from user where id =:userid];                 
        if(u.id != null && u.ReportsTo__c != null){
            if(u.ReportsTo__c !=null){                  
                useridList.add(u.id); 
                CreatelistForhirerachy(u);                                                            
                calluserfunction(u.ReportsTo__c,Uid);                                 
            }         
        }
        else{                                                                   
            useridList.add(u.id);
            hirerachyMap.put(Uid,useridList);
            CreatelistForhirerachy(u);    
            return useridList;
        }        
        return useridList;
    }    
}