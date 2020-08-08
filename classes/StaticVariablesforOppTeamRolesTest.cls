@isTest
public class StaticVariablesforOppTeamRolesTest{
    public static testmethod void testdata(){
        StaticVariablesforOppTeamRoles.AccountManager='Account Manager';
        StaticVariablesforOppTeamRoles.AccountExecutive='Account Executive';
        StaticVariablesforOppTeamRoles.SpecialtySalesAccountManager='Specialty Sales Account Manager';
        StaticVariablesforOppTeamRoles.SpecialtySalesExecutive='Specialty Sales Executive';
        StaticVariablesforOppTeamRoles.SpecialtySalesSupport='Specialty Sales Support';
        StaticVariablesforOppTeamRoles.SpecialtyClinicalAccountDirector='Specialty Clinical Account Director';
        StaticVariablesforOppTeamRoles.GRSSalesSupport='GRS Sales Support';
        StaticVariablesforOppTeamRoles.GRSAccountManager='GRS Account Manager';
        StaticVariablesforOppTeamRoles.GRSUnderwriter='GRS Underwriter';
        StaticVariablesforOppTeamRoles.GRSAdministrator='GRS Administrator';
        StaticVariablesforOppTeamRoles.VP='VP';
        StaticVariablesforOppTeamRoles.SalesAccountRepresentative='Sales Account Representative';
        StaticVariablesforOppTeamRoles.Underwriter='Underwriter';
        StaticVariablesforOppTeamRoles.AccountServiceRepresentative='Account Service Representative';
        StaticVariablesforOppTeamRoles.DirectorSalesAM='Director Sales/AM';
        StaticVariablesforOppTeamRoles.GRSAccountExecutive='GRS Account Executive';
        StaticVariablesforOppTeamRoles.GRSESR='GRS ESR';
        StaticVariablesforOppTeamRoles.SalesAccountRepAcctMgmt='Sales Account Rep - Acct Mgmt';
        StaticVariablesforOppTeamRoles.VoluntaryEnrollmentConsultant='Voluntary Enrollment Consultant';
        
        System.assertEquals(StaticVariablesforOppTeamRoles.VoluntaryEnrollmentConsultant,'Voluntary Enrollment Consultant');
        System.assertEquals(StaticVariablesforOppTeamRoles.AccountManager,'Account Manager');
        System.assertEquals(StaticVariablesforOppTeamRoles.AccountExecutive,'Account Executive');
        System.assertEquals(StaticVariablesforOppTeamRoles.GRSSalesSupport,'GRS Sales Support');
    }
}