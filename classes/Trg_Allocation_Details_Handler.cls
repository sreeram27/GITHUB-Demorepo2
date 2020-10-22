/*
@Author : Accenture Offshore Dev team(Eagles)
@name : Trg_Allocation_Details_Handler
@CreateDate : 01/22/2020
@Description : This is handler class for Employee Allocation Trigger "trg_Allocation_Details"
*/
public class Trg_Allocation_Details_Handler {
	
    /*
    * @Name : afterInsert
    * @Description : Process Employee_Allocation__c data at after insert event 
    * @Param : List of Employee_Allocation__c
    */
    public static void afterInsert(List<Employee_Allocation__c>  employeeAllocationList){
        
        List<Allocation_Details__c> allDtlsLst = new List<Allocation_Details__c>();
        //PRDCRM-1109 | Date:21st Jan 2020 | Modified by Accenture(Eagles)| Commenting this line as it is not used anywhere
        //List<Employee_Allocation__c> empAllLst = new List<Employee_Allocation__c>();
        List<Vacation__c> vacLst = new List<Vacation__c>();
        List<Holiday_List__c> holidyLst = Holiday_List__c.getAll().values();
        
        //Start | PRDCRM-1109 | Date:21st Jan 2020 | Added by Accenture(Eagles)| Added to maintain a map of Allocation Id and Employee Country to get corresponding country for an Employee Allocation
        Set<String> setEmpId = new Set<String>();
        for (Employee_Allocation__c ora : employeeAllocationList) {
            setEmpId.add(ora.Employee_Name__c);
        }
        List<Employee__c> listEmps = new List<Employee__c>();
        if(!setEmpId.isEmpty())
        {
            listEmps = [Select id, Country__C from Employee__c WHERE ID IN:setEmpId];
        }
        
        Map<String, String> mapAllocationCountries = new Map<String, String>();
        for (Employee_Allocation__c ora : employeeAllocationList) {
            if(!listEmps.isEmpty())
            {
                for(Employee__c emp : listEmps)
                {
                    if(ora.Employee_Name__c == emp.id)
                    {
                        mapAllocationCountries.put(ora.id, emp.Country__c);	
                        break;
                    }
                }	
            }				
        }
        //End | PRDCRM-1109
        
        for (Employee_Allocation__c ora : employeeAllocationList) {
            //PRDCRM-1109 | Date:21st Jan 2020 | Modified by Accenture(Eagles)| Commenting this line as it is not used anywhere
            //empAllLst.add(ora);
            integer j = 0;
            Integer currentYear = Date.today().year();
            Date startdateoftheyear = Date.newInstance(currentYear, 1, 1);
            Date enddateoftheyear = Date.newInstance(currentYear, 12, 31);
            
            
            for(integer i=0; i<53; i++){
             
                Allocation_Details__c ald = new Allocation_Details__c();
                Vacation__c vc = new Vacation__c();
                Date myDate = startdateoftheyear + j;
                j= j+7;
                Date weekStart = myDate.toStartofWeek()+1;
                Integer periousYear =weekStart.year();
                if(periousYear == currentYear){
                    ald.Employee_Allocation_Details__c = ora.Id;                  
                    ald.Weekly_Start_Date__c = weekStart;          
                    allDtlsLst.add(ald);
                }   
            }
              
            //Start | PRDCRM-1109 | Date:21st Jan 2020 | Added by Accenture(Eagles)| Commented to remove SOQL inside for loop
            //String country =[Select id, Country__C from Employee__c WHERE ID =:ora.Employee_Name__c].Country__c;//Commented to remove SOQL inside for loop
            
            //Start | PRDCRM-1109 | Date:21st Jan 2020 | Added by Accenture(Eagles)| To get the country from the map
            String country = mapAllocationCountries.get(ora.id);
            if(!holidyLst.isempty()){
                for(Holiday_List__c el: holidyLst){
                    if(el.Country__c == country){
                        Vacation__c vac = new Vacation__c();
                        vac.Name = el.Name;
                        vac.Contact__c = ora.Employee_Name__c;
                        vac.Start_Date__c = el.Date_of_Holiday__c;
                        vac.End_Date__c = el.Date_of_Holiday__c; 
                        System.debug('vacation list is >>>>>>');     
                        vacLst.add(Vac);       
                        
                        System.debug('vacLst is as follwos>>>'+vacLst);             
                    }
                }
            }
        }
        
         if (allDtlsLst.isEmpty() == false) {
            upsert allDtlsLst;
        }
        if(!vacLst.isempty()){
            Upsert vacLst;
        }
    }
}