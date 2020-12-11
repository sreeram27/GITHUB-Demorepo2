/*
@Author : CDHP Team
@name : CDHP_OpportunityAfterUpdate
@CreateDate :25-05-2017
@Description : This trigger fires when Opportunity gets updated.
*/
trigger CDHP_OpportunityAfterUpdate on Opportunity (after update) {   

/* This method Create Apllication/Update Application Based on Opportunity Stage  ----> Added for userstory:  PRDCRM-35832 by Prabir Mohanty  21-06-2019 */         
    // Added checks on : 10th Feb, 2020   //
    for(Opportunity Opp : Trigger.Old){
        if(trigger.newMap.get(Opp.Id).StageName != opp.StageName ){
            LGA_Opportunity_Trigger_Handler handler = New LGA_Opportunity_Trigger_Handler(Trigger.New);
            handler.createUpdateApplication(Trigger.New, Trigger.oldmap);    
        }
    }    
            
}