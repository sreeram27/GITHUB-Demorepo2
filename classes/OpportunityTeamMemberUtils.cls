/**
/** Author       ::: Ranjith Kumar
/** User Story   ::: PRDCRM-49344
/** Team Name    ::: Vikings
/** Purpose      ::: This is used for Opportunity and OpportunityTeamMember related functionality.If user removes the OpportunityTeamMember records to remove the associated Role field value in Parent.
/** Version      ::: v1.0
/** Created Date ::: 19-Jan-2020
**/

public class OpportunityTeamMemberUtils{

/** Author       ::: Ranjith Kumar
/** User Story   ::: PRDCRM-49344
/** Purpose      ::: If user removes the OpportunityTeamMember records to remove the associated Role field value in Parent.
/** Version      ::: v1.0
/** Created Date ::: 19-Jan-2020
**/
    public static void updateRolesInOpportunity(List<OpportunityTeamMember> oppTeamMemList,Map<Id,OpportunityTeamMember> oldMap,Boolean isDelete){
        Map<Id,Opportunity> oppMap=new Map<Id,Opportunity>();
        Map<Id,Opportunity> oppList=new Map<Id,Opportunity>();
        Set<Id> oppId=new Set<Id>();
        List<OpportunityTeamMember> oppTMemList=new List<OpportunityTeamMember>();
        for(OpportunityTeamMember oppTeamMem : oppTeamMemList){
            oppId.add(oppTeamMem.OpportunityId);
        }
        
        if(oppId.size()>0){
            oppMap.putAll([SELECT Id,Name,Account_Manager__c,Account_Executive__c,Specialty_Sales_Account_Manager__c,Specialty_Sales_Executive__c,Specialty_Sales_Support__c,Specialty_Clinical_Account_Director__c,GRS_Sales_Support__c,GRS_Account_Manager__c,GRS_Underwriter__c,GRS_Administrator__c,VP__c,Sales_Account_Representative__c,Underwriter__c,Account_Service_Representative__c,Director__c,GRS_Account_Executive__c,GRS_ESR__c,Sales_Account_Rep_Acct_Mgmnt__c,Voluntary_Enrollment_Consultant__c FROM Opportunity WHERE Id=:oppId]);
        }
        
        if(oppMap.size()>0){
            for(OpportunityTeamMember oppTeamMem : oppTeamMemList){
                if(oppMap.containsKey(oppTeamMem.OpportunityId)){
                    Opportunity opp=oppMap.get(oppTeamMem.OpportunityId);
                    if(isDelete){
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.AccountManager){
                            opp.Account_Manager__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.AccountExecutive){
                            opp.Account_Executive__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtySalesAccountManager){
                            opp.Specialty_Sales_Account_Manager__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtySalesExecutive){
                            opp.Specialty_Sales_Executive__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtySalesSupport){
                            opp.Specialty_Sales_Support__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtyClinicalAccountDirector){
                            opp.Specialty_Clinical_Account_Director__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSSalesSupport){
                            opp.GRS_Sales_Support__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSAccountManager){
                            opp.GRS_Account_Manager__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSUnderwriter){
                            opp.GRS_Underwriter__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSAdministrator){
                            opp.GRS_Administrator__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.VP){
                            opp.VP__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SalesAccountRepresentative){
                            opp.Sales_Account_Representative__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.Underwriter){
                            opp.Underwriter__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.AccountServiceRepresentative){
                            opp.Account_Service_Representative__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.DirectorSalesAM){
                            opp.Director__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSAccountExecutive){
                            opp.GRS_Account_Executive__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.GRSESR){
                            opp.GRS_ESR__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.SalesAccountRepAcctMgmt){
                            opp.Sales_Account_Rep_Acct_Mgmnt__c=null;
                        }
                        if(oppTeamMem.TeamMemberRole==StaticVariablesforOppTeamRoles.VoluntaryEnrollmentConsultant){
                            opp.Voluntary_Enrollment_Consultant__c=null;
                        }
                    }
                    if(!isDelete){
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.AccountManager && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.AccountManager){
                            opp.Account_Manager__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.AccountExecutive && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.AccountExecutive){
                            opp.Account_Executive__c=null;
                        }                       
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtySalesAccountManager && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.SpecialtySalesAccountManager){
                            opp.Specialty_Sales_Account_Manager__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtySalesExecutive && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.SpecialtySalesExecutive){
                            opp.Specialty_Sales_Executive__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtySalesSupport && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.SpecialtySalesSupport){
                            opp.Specialty_Sales_Support__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.SpecialtyClinicalAccountDirector && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.SpecialtyClinicalAccountDirector){
                            opp.Specialty_Clinical_Account_Director__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.GRSSalesSupport && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.GRSSalesSupport){
                            opp.GRS_Sales_Support__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.GRSAccountManager && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.GRSAccountManager){
                            opp.GRS_Account_Manager__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.GRSUnderwriter && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.GRSUnderwriter){
                            opp.GRS_Underwriter__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.GRSAdministrator && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.GRSAdministrator){
                            opp.GRS_Administrator__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.VP && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.VP){
                            opp.VP__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.SalesAccountRepresentative && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.SalesAccountRepresentative){
                            opp.Sales_Account_Representative__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.Underwriter && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.Underwriter){
                            opp.Underwriter__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.AccountServiceRepresentative && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.AccountServiceRepresentative){
                            opp.Account_Service_Representative__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.DirectorSalesAM && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.DirectorSalesAM){
                            opp.Director__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.GRSAccountExecutive && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.GRSAccountExecutive){
                            opp.GRS_Account_Executive__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.GRSESR && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.GRSESR){
                            opp.GRS_ESR__c=null;
                        }
                        if(oldMap.get(oppTeamMem.id).TeamMemberRole==StaticVariablesforOppTeamRoles.SalesAccountRepAcctMgmt && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.SalesAccountRepAcctMgmt){
                            opp.Sales_Account_Rep_Acct_Mgmnt__c=null;
                        }
                        if(oldMap.get(oppTeamMem.Id).TeamMemberRole==StaticVariablesforOppTeamRoles.VoluntaryEnrollmentConsultant && oppTeamMem.TeamMemberRole!=StaticVariablesforOppTeamRoles.VoluntaryEnrollmentConsultant){
                            opp.Voluntary_Enrollment_Consultant__c=null;
                        }
                    }
                    oppList.put(opp.id,opp);
                }
            }
        }
        
        if(oppList.size()>0){
            update oppList.values();
        }
    }

}