@isTest
public class BatchCLS_LeadConversionReportData_Test {
    @isTest(SeeAllData='true')
    public static void LeadConversionReportData_Method(){
        
        Opportunity opp = new Opportunity(Name='ApexTestOpp', StageName='stage',Probability = 95, CloseDate=system.today(),Amount = 950000);
        insert opp;
        
        LeadConversionReportData__c leadConversionInfo = new LeadConversionReportData__c(Name = 'stage',Month__c = 'January',CurrentMonthAmount__c = 95000,LastMonthAmount__c= 53433);
        
        insert leadConversionInfo;
        //Test.setCreatedDate(leadConversionInfo.Id, (Date.today() -1).tostartOfMonth());
        System.debug(leadConversionInfo.CreatedDate);
        Test.startTest();
        BatchCLS_LeadConversionReportData leadConversionReportData = new BatchCLS_LeadConversionReportData();
        Database.executeBatch(leadConversionReportData);
        Test.stopTest();
        
    }
}