Global class BatchCLS_LeadConversionReportData implements Database.Batchable<Sobject>{
    
    
    global database.queryLocator start(Database.BatchableContext Bc){
        String query = 'SELECT Id,DeveloperName FROM Report where DeveloperName = \'X2020_Pipeline_for_V2_Mktg_Dashboard_XSM\'';
        System.debug(query);
        return database.getQueryLocator(query);
    }
    
    
    global void Execute(Database.BatchableContext bc,List <Report> reportList){
        Map<String,decimal> CurrentReportDataMap = new Map<String,decimal>();
        List<LeadConversionReportData__c> LeadConversionDataList = new List<LeadConversionReportData__c>();
        
        DateTime dt = DateTime.now();
		String monthName = dt.format('MMMMM');
        
        List<LeadConversionReportData__c> LeadInfoLastMonth  =[SELECT ID,Name,CurrentMonthAmount__c FROM LeadConversionReportData__c WHERE CREATEDDATE =: (Date.today() -1).tostartOfMonth()];
            
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
        IF(LeadInfoLastMonth.size() > 0)
        {
            for(LeadConversionReportData__C leadInfo:LeadInfoLastMonth){
                for(String CurrentMonthStage:CurrentReportDataMap.keySet())
                {
                    if(CurrentMonthStage == leadInfo.Name){
                        LeadConversionReportData__c CurrentReportDataToBeInserted = new LeadConversionReportData__c();
                        CurrentReportDataToBeInserted.Name = CurrentMonthStage;
                        CurrentReportDataToBeInserted.Month__c = monthName;
                        CurrentReportDataToBeInserted.CurrentMonthAmount__c = CurrentReportDataMap.get(CurrentMonthStage);
                        CurrentReportDataToBeInserted.LastMonthAmount__c= leadInfo.CurrentMonthAmount__c;
                        LeadConversionDataList.add(CurrentReportDataToBeInserted);
                    }
                }
            }
        }
        ELSE{
            FOR(String CurrentMonthStage:CurrentReportDataMap.keySet())
            {
                LeadConversionReportData__c CurrentReportDataToBeInserted = new LeadConversionReportData__c();
                CurrentReportDataToBeInserted.Name = CurrentMonthStage;
                CurrentReportDataToBeInserted.Month__c = monthName;
                CurrentReportDataToBeInserted.CurrentMonthAmount__c = CurrentReportDataMap.get(CurrentMonthStage);
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