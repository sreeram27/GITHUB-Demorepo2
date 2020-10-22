/*******************************************************************************************
@Trigger Name  : LGA_IntErrorLog_Trg
@created By  : IDC Offshore
@createdDate : 11/19/2019
@description : This Trigger is used for updating the resolution fields on Integration Event Log 
               when changes are made in Integration Error Log 
********************************************************************************************/
trigger LGA_IntErrorLog_Trg on Integration_Error_Log__c (after update) {
    
    LGA_IntErrorLog_Trg_Handler handler = new LGA_IntErrorLog_Trg_Handler();
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            handler.calculateAvgResTime(trigger.new);
        }
    }

}