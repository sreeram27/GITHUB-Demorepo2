global class ScheduleCls_LeadConversionReportData implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchCLS_LeadConversionReportData BLDR = new BatchCLS_LeadConversionReportData();
        database.executeBatch(BLDR);
    }
}