Global class BatchCLS_WeaklyLeadConversion implements Database.Batchable<Sobject>{
    
    
    global database.queryLocator start(Database.BatchableContext Bc){
        String query = 'SELECT Id,DeveloperName FROM Report where DeveloperName = \'X2020_Pipeline_for_V2_Mktg_Dashboard_XSM\'';
        System.debug(query);
        return database.getQueryLocator(query);
    }
    
    
    global void Execute(Database.BatchableContext bc,List <Report> reportList){
        Map<String,decimal> CurrentReportDataMap = new Map<String,decimal>();
        List<WeeklyLeadConversionReport__c> LeadConversionDataList = new List<WeeklyLeadConversionReport__c>();
        
        //DateTime dt = DateTime.now();
		//String monthName = dt.format('MMMMM');
        
        List<WeeklyLeadConversionReport__c> LeadInfoLastWeek  =[SELECT ID,Name,CurrentWeekAmount__c FROM WeeklyLeadConversionReport__c WHERE CREATEDDATE =: (Date.today() -7)];
            
        String reportId = (String)reportList.get(0).get('Id');
            
        // Run a report synchronously
        Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);
            
        // Get the first down-grouping in the report
        Reports.Dimension dim = results.getGroupingsDown();
        System.debug(dim);
        for(Integer i = 0;i<dim.getGroupings().Size();i++)
        {
            
            Reports.GroupingValue GroupingVal = dim.getGroupings()[i];
            String factMapKey = groupingVal.getKey()  + '!T';
            Reports.ReportFactWithDetails factDetails =(Reports.ReportFactWithDetails)results.getFactMap().get(factMapKey);
            Reports.SummaryValue sumVal = factDetails.getAggregates()[0];
            CurrentReportDataMap.put((groupingVal.getValue()).toString(),(decimal)sumVal.getValue());
        
        }
        System.debug(CurrentReportDataMap);
        IF(LeadInfoLastWeek.size() > 0)
        {
            for(WeeklyLeadConversionReport__c leadInfo:LeadInfoLastWeek){
                for(String CurrentWeekStage:CurrentReportDataMap.keySet())
                {
                    if(CurrentWeekStage == leadInfo.Name){
                        WeeklyLeadConversionReport__c CurrentReportDataToBeInserted = new WeeklyLeadConversionReport__c();
                        CurrentReportDataToBeInserted.Name = CurrentWeekStage;
                        CurrentReportDataToBeInserted.DateOfTheStage__c = date.today();
                        CurrentReportDataToBeInserted.CurrentWeekAmount__c = CurrentReportDataMap.get(CurrentWeekStage);
                        CurrentReportDataToBeInserted.PreviousWeekAmount__c= leadInfo.CurrentWeekAmount__c;
                        LeadConversionDataList.add(CurrentReportDataToBeInserted);
                    }
                }
            }
        }
        ELSE{
            FOR(String CurrentWeekStage:CurrentReportDataMap.keySet())
            {
                WeeklyLeadConversionReport__c CurrentReportDataToBeInserted = new WeeklyLeadConversionReport__c();
                CurrentReportDataToBeInserted.Name = CurrentWeekStage;
                CurrentReportDataToBeInserted.DateOfTheStage__c = date.today();
                CurrentReportDataToBeInserted.CurrentWeekAmount__c = CurrentReportDataMap.get(CurrentWeekStage);
                LeadConversionDataList.add(CurrentReportDataToBeInserted);
            }
            
        }
        
        if(LeadConversionDataList.size() > 0)
        {
            Insert LeadConversionDataList;
        }
    }
    
    
    
    global void finish(Database.BatchableContext Bc)
    {
        
    }
}