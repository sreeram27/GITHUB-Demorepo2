global class LGFixProductAttribJSONScheduler implements Schedulable{
    global void execute(SchedulableContext ctx) {
        
		executeBatchJob();
        
    }
    public void executeBatchJob(){
        Vlocity_ins.FixProductAttribJSONBatchJob a = new Vlocity_ins.FixProductAttribJSONBatchJob();
        Database.executeBatch(a,1);
    }
}