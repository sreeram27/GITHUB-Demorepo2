/*
@Author : Accenture Offshore Dev team(Eagles)
@name : EmployeeAllocationTriggerHandler
@CreateDate : 01/22/2020
@Description : This is handler class for Employee Allocation Trigger "Trg_Allocation_Details"
*/
public with sharing class EmployeeAllocationTriggerHandler {
    
    /*
    * @Name : AccountTriggerHandler
    * @Description : Constructor of EmployeeAllocationTriggerHandler class 
    */
    public EmployeeAllocationTriggerHandler() {
    }
	
    /*
    * @Name : afterInsert
    * @Description : Process Employee_Allocation__c data at after insert event 
    * @Param : List of Employee_Allocation__c
    */
    public void onAfterInsert(List<Employee_Allocation__c>  employeeAllocationList){
        system.debug('Employee_Allocation__c Trigger On After Insert');
        EmployeeAllocationActions.processEmployeeAllocation(employeeAllocationList);        
	}
}