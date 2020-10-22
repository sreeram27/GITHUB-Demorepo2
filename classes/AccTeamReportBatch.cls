/*
* Purpose: Batch Apex Class
* Version: 2.0
* 
* JIRA NUMBER    DATE           DEVELOPER    DESCRIPTION 
* ===========    ===========    =========    =======================================================
* XXXXX          XX-XXX-XXXX    Accenture    New Batch Class created
* XXXXX          26-Feb-2019    Chiru S      Updating code to process account text and lookup fields
*PRDCRM-33933    29-May-2019    Sharath KN   Added 5 new fields, error emails and optimised code to remove query from loop
*                21-Aug-2019    Chiru S      Adding new fields to the logic
*                31-Oct-2019    Chiru S      Updated code to include LG_Customer and LG_Prospect Record Types
*PRDCRM-47935    10-Dec-2019    Neha Prasad  Added 3 New fields "Voluntary_Enrollment_Consultant__c", "GRS_Account_Executive__c" and "GRS_ESR__c" to the logic
*/

global  class AccTeamReportBatch implements Database.Batchable<sobject> , Database.Stateful{    
    //Map<Id,Account> accountMap = new Map<Id,Account>();
    //Setting Headers for Excel File
    //String headerStr = 'Account Id,Account Executive,Account Manager,Specialty Sales Executive,ANA Specialty AME,ANA Specialty SD,Clinical RPh,Director Sales/AM,Implementer,Pharmacy Service Coordinator,RVP Underwriting,Rx Account Management Director,Rx Account Manager,Rx Sales Director,Sales Executive,Admin Sales/AM,SR Sales Consultant,Underwriter,VP \n';
    String headerStr = 'Account Id,Error \n';
    global Boolean isError = false;
    global String accountStr = headerStr;
    global Set<String> accRcdTyps = new Set<String>{Label.Customer, Label.Prospect, Label.LG_Customer, Label.LG_Prospect}; 
    
    global AccountRoles__c roles = AccountRoles__c.getValues('AccountTeamReport');
    DateTime lastRun = roles.LastRun__c;
    //Updated code to include LG_Customer and LG_Prospect Record types
    DateTime jobStartTime = DateTime.now();
    
    // Start Method
    global Database.Querylocator start (Database.BatchableContext BC) {
        //system.debug('Entered in Start Method');
        //System.debug('Last Run  '+ lastRun);
        return Database.getQueryLocator([
            SELECT AccountId, TeamMemberRole, Title, UserId, User.Name, IsDeleted 
            FROM AccountTeamMember where LastModifiedDate >= :lastRun 
            ORDER BY LastModifiedDate ASC
        ]); 
    }
    
    // Execute method
    global void execute (Database.BatchableContext BC, List<AccountTeamMember> teamMemberList) {        
        //System.debug('Entered in Execute Method');
        //System.debug('Accoun Team Member List Size : '+teamMemberList.size());
        Map<Id,Account> accountMap = new Map<Id,Account>();
        if(teamMemberList.size() > 0)
        {
            Set<Id> accIDs = new Set<Id>();
            for(AccountTeamMember teamMember: teamMemberList){
                accIDs.add(teamMember.AccountId);
            }
            Map<Id,Account> tempAccMap = new Map<Id,Account>([SELECT Id, 
                                                              Account_Executive__c, 
                                                              Account_Manager__c, 
                                                              AccountSpecialtySalesExecutive__c, 
                                                              ANASpecialtyAME__c, 
                                                              ANASpecialtySD__c, 
                                                              ClinicalRPh__c, 
                                                              DirectorSalesAccountManagement__c, 
                                                              Implementor__c, 
                                                              PharmacyServiceCoordinator__c, 
                                                              RVPUnderwriting__c, 
                                                              RxAccountManagementDirector__c,
                                                              RxAccountManager__c, 
                                                              RxSalesDirector__c, 
                                                              SalesExecutive__c, 
                                                              SalesAMAdmin__c, 
                                                              SRSalesConsultant__c, 
                                                              Underwriter__c, 
                                                              VP__c, 
                                                              EBA__c, 
                                                              Implementation_Manager__c, 
                                                              Account_Service_Coordinator__c, 
                                                              Account_service_representative__c, 
                                                              Specialty_Sales_Account_Manager__c, 
                                                              Specialty_Clinical_Account_Director__c,
                                                              AE_Support_Rep__c,
                                                              AM_Support_Rep__c,
                                                              Sales_Account_Representative__c,
                                                              SARAcctMgmt__c,
                                                              Client_Engagement_Consultant_SAR1__c,                                                               
                                                              Hws_Implementer__c, 
                                                              Chief_Client_Officer__c, 
                                                              Group_Service_Analyst__c, 
                                                              Chief_Growth_Officer__c,
                                                              Regional_Manager__c,
                                                              Strategic_Client_Advisor__c,
                                                              GRS_ESR__c,
                                                              GRS_Account_Executive__c,
                                                              Voluntary_Enrollment_Consultant__c
                                                              FROM Account WHERE Id IN: accIDs AND RecordType.DeveloperName IN:accRcdTyps]);
            for (AccountTeamMember teamMember: teamMemberList) {
                Account acc = tempAccMap.get(teamMember.AccountId);
                String roleName = teamMember.TeamMemberRole;
                boolean isDeleted = teamMember.IsDeleted;
                if(acc!=null)
                {
                    //Account which is already existed in the accountMap
                    if(accountMap.containsKey(acc.Id))
                    {
                        if (roleName.equalsIgnoreCase('Account Executive') && (acc.Account_Executive__c != teamMember.UserId)){
                            accountMap.get(acc.Id).Account_Executive__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Account Manager') && (acc.Account_Manager__c != teamMember.UserId)){
                            accountMap.get(acc.Id).Account_Manager__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Specialty Sales Executive') && (acc.AccountSpecialtySalesExecutive__c != teamMember.UserId)){
                            accountMap.get(acc.Id).AccountSpecialtySalesExecutive__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('ANA Specialty AME') && (acc.ANASpecialtyAME__c != teamMember.UserId)){
                            accountMap.get(acc.Id).ANASpecialtyAME__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('ANA Specialty SD') && (acc.ANASpecialtySD__c != teamMember.UserId)){
                            accountMap.get(acc.Id).ANASpecialtySD__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Clinical RPh') && (acc.ClinicalRPh__c != teamMember.UserId)){
                            accountMap.get(acc.Id).ClinicalRPh__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Director Sales/AM') && (acc.DirectorSalesAccountManagement__c != teamMember.UserId)){
                            accountMap.get(acc.Id).DirectorSalesAccountManagement__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Implementer') && (acc.Implementor__c != teamMember.UserId)){
                            accountMap.get(acc.Id).Implementor__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Pharmacy Service Coordinator') && (acc.PharmacyServiceCoordinator__c != teamMember.UserId)){
                            accountMap.get(acc.Id).PharmacyServiceCoordinator__c = teamMember.UserId; 
                        }
                        else if (roleName.equalsIgnoreCase('RVP Underwriting') && (acc.RVPUnderwriting__c != teamMember.UserId)){
                            accountMap.get(acc.Id).RVPUnderwriting__c = teamMember.UserId;
                        }           
                        else if (roleName.equalsIgnoreCase('Rx Account Management Director') && (acc.RxAccountManagementDirector__c != teamMember.UserId)){
                            accountMap.get(acc.Id).RxAccountManagementDirector__c= teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Rx Account Manager') && (acc.RxAccountManager__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).RxAccountManager__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Rx Sales Director') && (acc.RxSalesDirector__c != teamMember.UserId)){
                            accountMap.get(acc.Id).RxSalesDirector__c = teamMember.UserId; 
                        }
                        else if (roleName.equalsIgnoreCase('Sales Executive') && (acc.SalesExecutive__c != teamMember.UserId)){
                            accountMap.get(acc.Id).SalesExecutive__c = teamMember.UserId;  
                        }
                        else if (roleName.equalsIgnoreCase('Admin Sales/AM') && (acc.SalesAMAdmin__c != teamMember.UserId)){
                            accountMap.get(acc.Id).SalesAMAdmin__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('SR Sales Consultant') && (acc.SRSalesConsultant__c != teamMember.UserId)){
                            accountMap.get(acc.Id).SRSalesConsultant__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Underwriter') && (acc.Underwriter__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).Underwriter__c = teamMember.UserId; 
                        }
                        else if (roleName.equalsIgnoreCase('VP') && (acc.VP__c != teamMember.UserId)) { 
                            accountMap.get(acc.Id).VP__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('EBA') && (acc.EBA__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).EBA__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Implementation Manager') && (acc.Implementation_Manager__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).Implementation_Manager__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Account Service Coordinator') && (acc.Account_Service_Coordinator__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).Account_Service_Coordinator__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Account Service Representative') && (acc.Account_service_representative__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).Account_service_representative__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Specialty Sales Account Manager') && (acc.Specialty_Sales_Account_Manager__c != teamMember.User.Name)) {
                            accountMap.get(acc.Id).Specialty_Sales_Account_Manager__c = teamMember.User.Name;
                        }
                        else if (roleName.equalsIgnoreCase(Label.Specialty_Clinical_Account_Director) && (acc.Specialty_Clinical_Account_Director__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).Specialty_Clinical_Account_Director__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('AE Support Rep') && (acc.AE_Support_Rep__c != teamMember.User.Name)) {
                            accountMap.get(acc.Id).AE_Support_Rep__c = teamMember.User.Name;
                        }
                        else if (roleName.equalsIgnoreCase('AM Support Rep') && (acc.AM_Support_Rep__c != teamMember.User.Name)) {
                            accountMap.get(acc.Id).AM_Support_Rep__c = teamMember.User.Name;
                        }
                        else if (roleName.equalsIgnoreCase('Sales Account Representative') && (acc.Sales_Account_Representative__c != teamMember.User.Name)) {
                            accountMap.get(acc.Id).Sales_Account_Representative__c = teamMember.User.Name;
                        } 
                        else if (roleName.equalsIgnoreCase('Sales Account Rep - Acct Mgmt') && (acc.SARAcctMgmt__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).SARAcctMgmt__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Client Engagement Consultant/SAR') && (acc.Client_Engagement_Consultant_SAR1__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).Client_Engagement_Consultant_SAR1__c = teamMember.UserId;
                        }
                        
                        else if (roleName.equalsIgnoreCase('Hws Implementer') && (acc.Hws_Implementer__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).Hws_Implementer__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Chief Client Officer') && (acc.Chief_Client_Officer__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).Chief_Client_Officer__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Chief Growth Officer') && (acc.Chief_Growth_Officer__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).Chief_Growth_Officer__c = teamMember.UserId;
                        }
                        else if (roleName.equalsIgnoreCase('Group Service Analyst') && (acc.Group_Service_Analyst__c != teamMember.UserId)) {
                            accountMap.get(acc.Id).Group_Service_Analyst__c = teamMember.UserId;
                        } 
                        else if (roleName.equalsIgnoreCase('Regional Manager') && (acc.Regional_Manager__c != teamMember.User.Name)) {
                            accountMap.get(acc.Id).Regional_Manager__c = teamMember.User.Name;
                            } 
                        else if (roleName.equalsIgnoreCase('Strategic Client Advisor') && (acc.Strategic_Client_Advisor__c!= teamMember.User.Name)) {
                            accountMap.get(acc.Id).Strategic_Client_Advisor__c = teamMember.User.Name;
                        }
                        else if (roleName.equalsIgnoreCase(staticVariableClass.TEAM_ROLE_GRS_ACCOUNT_EXECUTIVE) && (acc.GRS_Account_Executive__c != teamMember.User.Name)) {
                            accountMap.get(acc.Id).GRS_Account_Executive__c = teamMember.User.Name;
                        }
                        else if (roleName.equalsIgnoreCase(staticVariableClass.TEAM_ROLE_GRS_ESR) && (acc.GRS_ESR__c != teamMember.User.Name)) {
                            accountMap.get(acc.Id).GRS_ESR__c = teamMember.User.Name;
                        }
                        else if (roleName.equalsIgnoreCase(staticVariableClass.TEAM_ROLE_VOLUNTARY_ENROLLMENT) && (acc.Voluntary_Enrollment_Consultant__c != teamMember.User.Name)) {
                            accountMap.get(acc.Id).Voluntary_Enrollment_Consultant__c = teamMember.User.Name;
                        }
                        
                    }
                                        
                    //New Account Which is not already in the accountMap
                    else
                    {
                        if (roleName.equalsIgnoreCase('Account Executive') && (acc.Account_Executive__c != teamMember.UserId)){acc.Account_Executive__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Account_Executive__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Account Manager') && (acc.Account_Manager__c != teamMember.UserId)){ acc.Account_Manager__c = teamMember.UserId; accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Account_Manager__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Specialty Sales Executive') && (acc.AccountSpecialtySalesExecutive__c != teamMember.UserId)){acc.AccountSpecialtySalesExecutive__c = teamMember.UserId; accountMap.put(acc.Id, acc); System.debug('Role:'+roleName+ ' changed from '+acc.AccountSpecialtySalesExecutive__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('ANA Specialty AME') && (acc.ANASpecialtyAME__c != teamMember.UserId)){ acc.ANASpecialtyAME__c = teamMember.UserId; accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.ANASpecialtyAME__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('ANA Specialty SD') && (acc.ANASpecialtySD__c != teamMember.UserId)){acc.ANASpecialtySD__c = teamMember.UserId;accountMap.put(acc.Id, acc); System.debug('Role:'+roleName+ ' changed from '+acc.ANASpecialtySD__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Clinical RPh') && (acc.ClinicalRPh__c != teamMember.UserId)){acc.ClinicalRPh__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.ClinicalRPh__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Director Sales/AM') && (acc.DirectorSalesAccountManagement__c != teamMember.UserId)){acc.DirectorSalesAccountManagement__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.DirectorSalesAccountManagement__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Implementer') && (acc.Implementor__c != teamMember.UserId)){ acc.Implementor__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Implementor__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Pharmacy Service Coordinator') && (acc.PharmacyServiceCoordinator__c != teamMember.UserId)){acc.PharmacyServiceCoordinator__c = teamMember.UserId;  accountMap.put(acc.Id, acc); System.debug('Role:'+roleName+ ' changed from '+acc.PharmacyServiceCoordinator__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('RVP Underwriting') && (acc.RVPUnderwriting__c != teamMember.UserId)){acc.RVPUnderwriting__c = teamMember.UserId; accountMap.put(acc.Id, acc); System.debug('Role:'+roleName+ ' changed from '+acc.RVPUnderwriting__c+ ' to '+teamMember.UserId);}           
                        else if (roleName.equalsIgnoreCase('Rx Account Management Director') && (acc.RxAccountManagementDirector__c != teamMember.UserId)){acc.RxAccountManagementDirector__c= teamMember.UserId; accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.RxAccountManagementDirector__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Rx Account Manager') && (acc.RxAccountManager__c != teamMember.UserId)){acc.RxAccountManager__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.RxAccountManager__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Rx Sales Director') && (acc.RxSalesDirector__c != teamMember.UserId)){acc.RxSalesDirector__c = teamMember.UserId;accountMap.put(acc.Id, acc); System.debug('Role:'+roleName+ ' changed from '+acc.RxSalesDirector__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Sales Executive') && (acc.SalesExecutive__c != teamMember.UserId)){ acc.SalesExecutive__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.SalesExecutive__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Admin Sales/AM') && (acc.SalesAMAdmin__c != teamMember.UserId)){ acc.SalesAMAdmin__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.SalesAMAdmin__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('SR Sales Consultant') && (acc.SRSalesConsultant__c != teamMember.UserId)){acc.SRSalesConsultant__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.SRSalesConsultant__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Underwriter') && (acc.Underwriter__c != teamMember.UserId)){acc.Underwriter__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Underwriter__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('VP') && (acc.VP__c != teamMember.UserId)){acc.VP__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.VP__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('EBA') && (acc.EBA__c != teamMember.UserId)){acc.EBA__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.EBA__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Account Service Coordinator') && (acc.Account_Service_Coordinator__c != teamMember.UserId)){acc.Account_Service_Coordinator__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Account_Service_Coordinator__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Account Service Representative') && (acc.Account_Service_Representative__c != teamMember.UserId)){acc.Account_Service_Representative__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Account_Service_Representative__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Specialty Sales Account Manager') && (acc.Specialty_Sales_Account_Manager__c != teamMember.User.Name)){acc.Specialty_Sales_Account_Manager__c = teamMember.User.Name;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Specialty_Sales_Account_Manager__c+ ' to '+teamMember.User.Name);}
                        else if (roleName.equalsIgnoreCase(Label.Specialty_Clinical_Account_Director) && (acc.Specialty_Clinical_Account_Director__c != teamMember.UserId)){acc.Specialty_Clinical_Account_Director__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Specialty_Clinical_Account_Director__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('AE Support Rep') && (acc.AE_Support_Rep__c != teamMember.User.Name)){acc.AE_Support_Rep__c = teamMember.User.Name;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.AE_Support_Rep__c+ ' to '+teamMember.User.Name);}
                        else if (roleName.equalsIgnoreCase('AM Support Rep') && (acc.AM_Support_Rep__c != teamMember.User.Name)){acc.AM_Support_Rep__c = teamMember.User.Name;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.AM_Support_Rep__c+ ' to '+teamMember.User.Name);}
                        else if (roleName.equalsIgnoreCase('Sales Account Representative') && (acc.Sales_Account_Representative__c != teamMember.User.Name)){acc.Sales_Account_Representative__c = teamMember.User.Name;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Sales_Account_Representative__c+ ' to '+teamMember.User.Name);}
                        else if (roleName.equalsIgnoreCase('Sales Account Rep - Acct Mgmt') && (acc.SARAcctMgmt__c != teamMember.UserId)){acc.SARAcctMgmt__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.SARAcctMgmt__c+ ' to '+teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Client Engagement Consultant/SAR') && (acc.Client_Engagement_Consultant_SAR1__c != teamMember.UserId)){acc.Client_Engagement_Consultant_SAR1__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Client_Engagement_Consultant_SAR1__c+ ' to '+teamMember.UserId);}             
                        else if (roleName.equalsIgnoreCase('Hws Implementer') && (acc.Hws_Implementer__c != teamMember.UserId)){acc.Hws_Implementer__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:' + roleName + ' changed from ' + acc.Hws_Implementer__c + ' to ' + teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Chief Client Officer') && (acc.Chief_Client_Officer__c != teamMember.UserId)){acc.Chief_Client_Officer__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:' + roleName + ' changed from ' + acc.Chief_Client_Officer__c + ' to ' + teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Chief Growth Officer') && (acc.Chief_Growth_Officer__c != teamMember.UserId)){acc.Chief_Growth_Officer__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:' + roleName + ' changed from ' + acc.Chief_Growth_Officer__c + ' to ' + teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Group Service Analyst') && (acc.Group_Service_Analyst__c != teamMember.UserId)){acc.Group_Service_Analyst__c = teamMember.UserId;accountMap.put(acc.Id, acc);System.debug('Role:' + roleName + ' changed from ' + acc.Group_Service_Analyst__c + ' to ' + teamMember.UserId);}
                        else if (roleName.equalsIgnoreCase('Regional Manager') && (acc.Regional_Manager__c != teamMember.User.Name)){acc.Regional_Manager__c = teamMember.User.Name;accountMap.put(acc.Id, acc);System.debug('Role:' + roleName + ' changed from ' + acc.Regional_Manager__c + ' to ' + teamMember.User.Name);}                    
                        else if (roleName.equalsIgnoreCase('Strategic Client Advisor') && (acc.Strategic_Client_Advisor__c != teamMember.User.Name)){acc.Strategic_Client_Advisor__c = teamMember.User.Name;accountMap.put(acc.Id, acc);System.debug('Role:' + roleName + ' changed from ' + acc.Strategic_Client_Advisor__c + ' to ' + teamMember.User.Name);}                    
                        else if (roleName.equalsIgnoreCase('GRS Account Executive') && (acc.GRS_Account_Executive__c != teamMember.User.Name)){acc.GRS_Account_Executive__c = teamMember.User.Name;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.GRS_Account_Executive__c+ ' to '+teamMember.User.Name);}
                        else if (roleName.equalsIgnoreCase('GRS ESR') && (acc.GRS_ESR__c != teamMember.User.Name)){acc.GRS_ESR__c = teamMember.User.Name;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.GRS_ESR__c+ ' to '+teamMember.User.Name);}
                        else if (roleName.equalsIgnoreCase('Voluntary Enrollment Consultant') && (acc.Voluntary_Enrollment_Consultant__c != teamMember.User.Name)){acc.Voluntary_Enrollment_Consultant__c = teamMember.User.Name;accountMap.put(acc.Id, acc);System.debug('Role:'+roleName+ ' changed from '+acc.Voluntary_Enrollment_Consultant__c+ ' to '+teamMember.User.Name);}
                    }
                    
                }                
            }
        }
        List<Account> accountsTobeUpdated = new List<Account>(accountMap.values());
        if(accountsTobeUpdated.size() > 0)
        {
            // update accountMap.values();
            Database.SaveResult[] sR =  Database.update(accountsTobeUpdated,false);
            for(Integer i=0;i<accountsTobeUpdated.size();i++){
                If(!sR[i].isSuccess()){
                    isError = true;
                    string errorMsg = '';
                    for(Database.Error error : sR[i].getErrors()){
                        errorMsg += ' ' + error.getMessage();
                    }
                    accountStr += accountsTobeUpdated[i].Id + ',' +  errorMsg + '\n';
                }
            }
        }
    }
    
    
    // Finish Method
    global void finish(Database.BatchableContext BC) {
        
        AsyncApexJob batchStatus = [Select Id, NumberOfErrors, Status, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
        if(isError == true || batchStatus.NumberOfErrors > 0){ 
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();Blob csvBlob = Blob.valueOf(accountStr);
            string csvname= 'Account Errors.csv';csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();String subject ='AccTeamReportBatch :'+batchStatus.Status;
            email.setSubject(subject);
            email.setToAddresses(new list<string>{System.label.Admin_Email});email.setPlainTextBody('AccTeamReportBatch has errors in Org - '+ UserInfo.getOrganizationId());
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            Messaging.SendEmailResult [] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }else{
            roles.LastRun__c =jobStartTime;
            update roles;
        }
    }
        
}