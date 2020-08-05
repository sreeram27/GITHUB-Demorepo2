global with sharing class SchedularForBatchApexRenewalOppty implements Schedulable {
        
        global void execute(SchedulableContext sc) {
            
              AutoRenewalOfOppty d = new AutoRenewalOfOppty(); 
              database.executebatch(d, 10);
        }
        
         Public static void SchedulerMethod(){
             SchedularForBatchApexRenewalOppty s = new SchedularForBatchApexRenewalOppty();
             string con_exp= '0 0 * * * ?';
             System.schedule('updateAllOpptoday', con_exp, s);
         }
               
 }