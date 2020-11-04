/*
@Author : Accenture Offshore Dev team(Eagles)
@name : Trg_Allocation_Details
@CreateDate : 01/22/2020
@Description : This trigger gets executed after Employee Allocation record gets created.
*/
trigger Trg_Allocation_Details on Employee_Allocation__c (After Insert) {
    EmployeeAllocationTriggerHandler handler = new EmployeeAllocationTriggerHandler();
    if( Trigger.isInsert ){
        if(Trigger.isAfter){
            handler.onAfterInsert(trigger.New);//Logic has been moved to handler class "EmployeeAllocationTriggerHandler"   
        }
    }
}