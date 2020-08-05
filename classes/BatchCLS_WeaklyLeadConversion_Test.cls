@isTest
public class BatchCLS_WeaklyLeadConversion_Test {
    @isTest(SeeAllData='true')
    public static void LeadConversionReportData_Method(){
        
        Opportunity opp = new Opportunity(Name='ApexTestOpp', StageName='stage',Probability = 95, CloseDate=system.today(),Amount = 950000);
        insert opp;
        
        WeeklyLeadConversionReport__c leadConversionInfo = new WeeklyLeadConversionReport__c(Name = 'stage',DateOfTheStage__c =Date.newInstance(2016, 12, 9) ,CurrentWeekAmount__c = 95000,PreviousWeekAmount__c= 53433);
        
        insert leadConversionInfo;
        //Test.setCreatedDate(leadConversionInfo.Id, (Date.today() -1).tostartOfMonth());
        System.debug(leadConversionInfo.CreatedDate);
        Test.startTest();
        BatchCLS_WeaklyLeadConversion WeeklyleadConversion = new BatchCLS_WeaklyLeadConversion();
        Database.executeBatch(WeeklyleadConversion);
        Test.stopTest();
        
    }
}