global class Schedule_WeeklyLeadConversion implements Schedulable{
     global void execute(SchedulableContext sc){
         BatchCLS_WeaklyLeadConversion bwlc = new BatchCLS_WeaklyLeadConversion();
         database.executeBatch(bwlc);
     }
}