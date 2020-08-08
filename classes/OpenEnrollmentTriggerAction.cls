/*************************************************************************************
    Version           : 1.0 
    @Author          : Mehaboob
    @description    :Open Enrollment Hnadler for updating stage status values
    @comment     : Created this class as part of Story PRDCRM-45610 and 43212
    OpenEnrollmentStageStatusTest is the test class for this Apex class 
    Created on : 10/30/2010               
    **************************************************************************************
    @mod : 11/11/2019
    @comment : modified class name to 'OpenEnrollmentTriggerAction'   as part of story PRDCRM-43213
    
    **************************************************************************************
    @mod : 1/20/2020
    @comment : modified this  class as per the updated sheet .related to PRDCRM- 50758
    
    *************************************************************************************/
    public with Sharing class OpenEnrollmentTriggerAction{
        
        
        /*
    @description : Method to update OE Stage Status 
    */
        public static void updateStageStatus(List<SFDC_Volunteer_Event__c> newOpenEnrollmentList, Map<Id, SFDC_Volunteer_Event__c> oldOpenEnrollmentMap,Boolean isInsert){
           
            
            for(SFDC_Volunteer_Event__c openEnrlment: newOpenEnrollmentList){
                
              System.debug('inside for loop ---'+openEnrlment.Recruitment_of_Facilitator_Needed__c);
                SFDC_Volunteer_Event__c oldOE =new SFDC_Volunteer_Event__c();
                //Checking for only updates 
                if(!isInsert){
                    if(oldOpenEnrollmentMap.size()>0 && oldOpenEnrollmentMap.containsKey(openEnrlment.ID)){ 
                        oldOE = oldOpenEnrollmentMap.get(openEnrlment.ID);
                    }
                }
                System.debug('OLDOE'+oldOE);
                
                
                //Updating Rush to true based on the meeting date 
                if((openEnrlment.Date__c!=null) && openEnrlment.Date__c<= System.TODAY()+13 && openEnrlment.Meeting_Stage__c=='SUBMITTED' && openEnrlment.Meeting_Stage__c!='DRAFT'){
                        openEnrlment.RUSH__c=true;
                }
                
                if(openEnrlment!=oldOE)
                {
                 //Stage status value updation goes below with various criteria 
                 if(openEnrlment.Date__c<=System.TODAY() + 13 && openEnrlment.Meeting_Stage__c=='SUBMITTED'){
                        
                        openEnrlment.Meeting_Stage__c=UtilConstants.STATUS_SUB_RUSH ;
                        openEnrlment.Meeting_Status__c=UtilConstants.STATUS_NEW_REQUEST; 
                        openEnrlment.RUSH__c =true;
                
                }
                
                
                else if(openEnrlment.Meeting_Cancelled__c==true && openEnrlment.Submit__c==true){
                        
                        openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_COMPLETE;
                        openEnrlment.Meeting_Status__c=UtilConstants.STATUS_COMPLETED_CANCELLED;
                
                }
                else if((openEnrlment.Reason_for_Update__c!='' && openEnrlment.Reason_for_Update__c!=null) && openEnrlment.Reason_for_Update__c!=oldOE.Reason_for_Update__c && openEnrlment.Submit__c==true && openEnrlment.Date__c<= System.TODAY() + 13){
                        
                        openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_UPDATED_RUSH;
                        
                }
                
                else if((openEnrlment.Reason_for_Update__c!='' && openEnrlment.Reason_for_Update__c!=null) && openEnrlment.Reason_for_Update__c!=oldOE.Reason_for_Update__c && openEnrlment.Submit__c==true && openEnrlment.Date__c>= System.TODAY() +13){
                        
                        openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_UPDATED;
                    
                
                }
                
                else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && openEnrlment.Materials_Needed__c==UtilConstants.NO_PROMO_OR_COLLATERAL_NEEDED  && openEnrlment.Facilitator_Being_Recruited__c==false 
                        && openEnrlment.Facilitator_Secured__c==true && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false&& openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==true && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==false && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                          
                          System.debug('Entered If'+openEnrlment.Recruitment_of_Facilitator_Needed__c);  
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_COMPLETE;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_COMPLETED_FAC_SEC_AND_MEETING_FEED_REC;
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && openEnrlment.Materials_Needed__c==UtilConstants.NO_PROMO_OR_COLLATERAL_NEEDED  && openEnrlment.Facilitator_Being_Recruited__c==false 
                        && openEnrlment.Facilitator_Secured__c==true && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==true 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==false && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                        
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_COMPLETE;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_COMPLETED_FAC_SEC_AND_FEED_NOT_REC_WITHIN_14_DAYS;
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && openEnrlment.Materials_Needed__c==UtilConstants.NO_PROMO_OR_COLLATERAL_NEEDED  && openEnrlment.Facilitator_Being_Recruited__c==false 
                        && openEnrlment.Facilitator_Secured__c==true && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==true && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==false && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                        
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_FAC_SEC_AND_WAITING_ON_FEED;
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && openEnrlment.Materials_Needed__c==UtilConstants.NO_PROMO_OR_COLLATERAL_NEEDED  && openEnrlment.Facilitator_Being_Recruited__c==true 
                        && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==false && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                        
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_FAC_BEING_RECR; 
                
                }else if((( openEnrlment.Date__c!=null) && openEnrlment.Date__c> System.TODAY()+13 &&  openEnrlment.RUSH__c==true )&& (openEnrlment.Meeting_Stage__c=='Submitted - Rush' || openEnrlment.Meeting_Stage__c=='Updated - Rush')){
                        
                        openEnrlment.Meeting_Stage__c=UtilConstants.STATUS_SUBMITTED;
                        openEnrlment.RUSH__c =false; 
                        
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==true && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==true && openEnrlment.Materials_Delivered__c==true 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                                            
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_COMPLETE;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_COMPLETED_UNABLE_TO_SEC_FAC_AND_MAT_DELIVERED; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==true && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==true && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                        
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_UNABLE_TO_SEC_FAC_ORDER_PLACED; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==true && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==true && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==true && openEnrlment.Materials_Delivered__c==true 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                                            
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_COMPLETE;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_COMPLETED_FAC_SEC_AND_MAT_DEL_AND_MEET_FEED_REC; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==true && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==true 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==true && openEnrlment.Materials_Delivered__c==true 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                                            
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_COMPLETE;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_COMPLETED_FAC_SEC_AND_MAT_DEL_AND_FEED_NOT_REC_WITHIN_14_DAYS; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==true && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==true && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==true && openEnrlment.Materials_Delivered__c==true 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                        
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_FAC_SEC_AND_MAT_DEL_AND_WAIT_ON_FEED; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==true && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==true && openEnrlment.Materials_Order_placed__c==false && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                        
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_UNABLE_TO_SEC_FAC_ORDER_ON_STANDBY; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==true && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==true && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==true && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                            
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_FAC_SEC_AND_ORDER_PLACED_AND_WAIT_ON_FEED; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && openEnrlment.Materials_Needed__c==UtilConstants.NO_PROMO_OR_COLLATERAL_NEEDED && openEnrlment.Facilitator_Being_Recruited__c==false 
                        && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==true && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==false && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                                
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_COMPLETE;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_COMPLETED_UNABLE_TO_SEC_FAC; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==true && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==true && openEnrlment.Materials_Order_placed__c==false && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                        
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_FAC_BEING_RECR_AND_ORDER_ON_STANDBY; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==true && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==true && openEnrlment.Materials_Delivered__c==true 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                        
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_FAC_BEING_RECR_AND_MAT_DELIVERED; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==true && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==true && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                        
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_FAC_BEING_RECR_AND_ORDER_PLACED; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_YES && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==true && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==true && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==true && openEnrlment.Materials_Order_placed__c==false && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                        
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_FAC_SEC_AND_WAIT_ON_FEED_AND_ORDER_ON_STANDBY; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_NO && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==true && openEnrlment.Materials_Order_placed__c==false && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                                                 
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_ORDER_ON_STANDBY; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_NO && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==true && openEnrlment.Materials_Delivered__c==true 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                                                
                           openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_COMPLETE;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_COMPLETED_MAT_DELIVERED; 
                
                }else if(openEnrlment.Recruitment_of_Facilitator_Needed__c==UtilConstants.REC_OF_FACILITATOR_NEEDED_NO && (openEnrlment.Materials_Needed__c==UtilConstants.PROMO_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.COLLATERAL_ONLY_NEEDED || openEnrlment.Materials_Needed__c==UtilConstants.PROMO_AND_COLLATERAL_NEEDED ) 
                        && openEnrlment.Facilitator_Being_Recruited__c==false && openEnrlment.Facilitator_Secured__c==false && openEnrlment.Unable_to_secure_facilitator__c==false && openEnrlment.Waiting_on_Feedback__c==false && openEnrlment.Feedback_Not_Received_Within_14_Days__c==false 
                        && openEnrlment.Facilitator_Feedback_Received__c==false && openEnrlment.Materials_Order_On_Standby__c==false && openEnrlment.Materials_Order_placed__c==true && openEnrlment.Materials_Delivered__c==false 
                        && openEnrlment.Meeting_Cancelled__c==false && openEnrlment.Submit__c==true ){
                            
                            openEnrlment.Meeting_Stage__c=UtilConstants.STAGE_INPROCESS;
                            openEnrlment.Meeting_Status__c=UtilConstants.STATUS_INPROCESS_ORDER_PLACED; 
                }

                System.debug('openEnrlment.Meeting_Stage__c'+openEnrlment.Meeting_Stage__c); 
            }   
            }
            
           
        } 
        
       
    }