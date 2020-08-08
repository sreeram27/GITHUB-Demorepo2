/*
  @@ Author       ::: Ranjith Kumar
  @@ Created Date ::: 1/17/2020
  @@ Team         ::: Vikings(PRDCRM-49344)
  @@ Purpose      ::: To update all the existing Opportunities Role up Fields with the associated OpportunityTeamMember Roles.
*/
global class UpdateOpprtunityRollupFieldsBatch implements Database.Batchable<sObject>, Database.Stateful {
    private String query = null;
      
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        query='SELECT Id,Name,is_Updated_From_Batch__c,Account_Manager__c,Account_Executive__c,Specialty_Sales_Account_Manager__c,Specialty_Sales_Executive__c,';   
        query+='Specialty_Sales_Support__c,Specialty_Clinical_Account_Director__c,GRS_Sales_Support__c,GRS_Account_Manager__c,GRS_Underwriter__c,';
        query+='GRS_Administrator__c,VP__c,Sales_Account_Representative__c,Underwriter__c,Account_Service_Representative__c,Director__c,';
        query+='GRS_Account_Executive__c,GRS_ESR__c,Sales_Account_Rep_Acct_Mgmnt__c,Voluntary_Enrollment_Consultant__c,';
        query+='(SELECT Id,OpportunityId,TeamMemberRole,UserId,User.Name FROM OpportunityTeamMembers WHERE ';
        query+='TeamMemberRole IN (\'Account Manager\',\'Account Executive\',\'Specialty Sales Account Manager\',\'Specialty Sales Executive\',';
        query+='\'Specialty Sales Support\',\'Specialty Clinical Account Director\',\'GRS Sales Support\',\'GRS Account Manager\',\'GRS Underwriter\',';
        query+='\'GRS Administrator\',\'VP\',\'Sales Account Representative\',\'Underwriter\',\'Account Service Representative\',\'Director Sales/AM\',';
        query+='\'GRS Account Executive\',\'GRS ESR\',\'Sales Account Rep - Acct Mgmt\',\'Voluntary Enrollment Consultant\')) FROM Opportunity WHERE is_Updated_From_Batch__c=false';       
        system.debug(query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        Map<Id,Opportunity> oppList=new Map<Id,Opportunity>(); 
           
        for(Opportunity opp : scope){
            if(opp.is_Updated_From_Batch__c==false){
                for(OpportunityTeamMember oppTeamMem : opp.OpportunityTeamMembers){                                
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.AccountManager && opp.Account_Manager__c!=oppTeamMem.UserId){ opp.Account_Manager__c=oppTeamMem.UserId;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.AccountExecutive && opp.Account_Executive__c!=oppTeamMem.UserId){ opp.Account_Executive__c=oppTeamMem.UserId;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtySalesAccountManager && opp.Specialty_Sales_Account_Manager__c!=oppTeamMem.UserId){ opp.Specialty_Sales_Account_Manager__c=oppTeamMem.UserId;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtySalesExecutive && opp.Specialty_Sales_Executive__c!=oppTeamMem.UserId){ opp.Specialty_Sales_Executive__c=oppTeamMem.UserId;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtySalesSupport && opp.Specialty_Sales_Support__c!=oppTeamMem.UserId){ opp.Specialty_Sales_Support__c=oppTeamMem.UserId;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtyClinicalAccountDirector && opp.Specialty_Clinical_Account_Director__c!=oppTeamMem.UserId){ opp.Specialty_Clinical_Account_Director__c=oppTeamMem.UserId;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSSalesSupport && opp.GRS_Sales_Support__c!=oppTeamMem.User.Name){ opp.GRS_Sales_Support__c=oppTeamMem.User.Name;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSAccountManager && opp.GRS_Account_Manager__c!=oppTeamMem.User.Name){ opp.GRS_Account_Manager__c=oppTeamMem.User.Name;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSUnderwriter && opp.GRS_Underwriter__c!=oppTeamMem.User.Name){ opp.GRS_Underwriter__c=oppTeamMem.User.Name;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSAdministrator && opp.GRS_Administrator__c!=oppTeamMem.User.Name){ opp.GRS_Administrator__c=oppTeamMem.User.Name;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.VP && opp.VP__c!=oppTeamMem.UserId){ opp.VP__c=oppTeamMem.UserId;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SalesAccountRepresentative && opp.Sales_Account_Representative__c!=oppTeamMem.UserId){ opp.Sales_Account_Representative__c=oppTeamMem.UserId;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.Underwriter && opp.Underwriter__c!=oppTeamMem.UserId){ opp.Underwriter__c=oppTeamMem.UserId;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.AccountServiceRepresentative && opp.Account_Service_Representative__c!=oppTeamMem.UserId){ opp.Account_Service_Representative__c=oppTeamMem.UserId;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.DirectorSalesAM && opp.Director__c!=oppTeamMem.User.Name){ opp.Director__c=oppTeamMem.User.Name;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSAccountExecutive && opp.GRS_Account_Executive__c!=oppTeamMem.User.Name){ opp.GRS_Account_Executive__c=oppTeamMem.User.Name;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSESR && opp.GRS_ESR__c!=oppTeamMem.User.Name){ opp.GRS_ESR__c=oppTeamMem.User.Name;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SalesAccountRepAcctMgmt && opp.Sales_Account_Rep_Acct_Mgmnt__c!=oppTeamMem.User.Name){ opp.Sales_Account_Rep_Acct_Mgmnt__c=oppTeamMem.User.Name;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.VoluntaryEnrollmentConsultant && opp.Voluntary_Enrollment_Consultant__c!=oppTeamMem.User.Name){ opp.Voluntary_Enrollment_Consultant__c=oppTeamMem.User.Name;
                        }
                        opp.is_Updated_From_Batch__c=true;
                        oppList.put(opp.id,opp);                   
                }
            }
        }        
       
        if(oppList.size()>0){
            update oppList.values();
        }
        
    }
           
    global void finish(Database.BatchableContext BC){
    
    }
}