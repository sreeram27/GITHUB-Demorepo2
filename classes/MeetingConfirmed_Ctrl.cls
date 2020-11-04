/*************************************************************************************
Version     : 1.0 
@Author: Rahmath
Function    : Meeting confirmed Tab for community
US          : PRDCRM-41984
@description : Meeting confirmed Tab for community Open Enrollment
*************************************************************************************/

public with sharing class MeetingConfirmed_Ctrl{    

    @AuraEnabled
    /**
    * @description fetchVolPart     
    */
    public static String fetchVolPart() {
        /**
        * @description fetchVolPart method
        * @return String
        */
        List<id> lstVolEvTemp = new List<id>();
        lstVolEvTemp = getVolunteerEvent(true);
        
        List<WrapperopenEnrollment> wrapperEnrollmentList = new list<WrapperopenEnrollment>();
        if(!Schema.sObjectType.SFDC_Volunteer_Event__c.fields.id.isAccessible()||Schema.sObjectType.SFDC_Volunteer_Event__c.fields.id.isAccessible()) {  
            List<SFDC_Volunteer_Event__c> lstVolEve = [SELECT Id, 
                                                       Account_Name__c,
                                                       Date__C,
                                                       Session_1_Start_Time__c,
                                                       Session_1_End_Time__c,
                                                       Meeting_Street__c,
                                                       Meeting_City__c,
                                                       Meeting_State__c,
                                                       OE_Coordinator_Contact__r.Name,OE_Coordinator_Phone__c,
                                                       Account_Manager_Formula__c,
                                                       AM_Phone__c,SAR_AcctMgt__c,
                                                       SAR_Phone__c,
                                                       Client_Engagement_Consultant_SAR__c,
                                                       Client_Engagement_Consultant_SAR_Phone__c 
                                                       FROM SFDC_Volunteer_Event__c 
                                                       WHERE id IN :lstVolEvTemp];
            for (SFDC_Volunteer_Event__c temp:lstVolEve){
                WrapperopenEnrollment newWrapperEnrollment = new WrapperopenEnrollment();
                newWrapperEnrollment.accountName = temp.Account_Name__c;
                newWrapperEnrollment.meetingDate = temp.Date__c;
                newWrapperEnrollment.sessionStartTime = temp.Session_1_Start_Time__c;
                newWrapperEnrollment.sessionEndTime = temp.Session_1_End_Time__c;
                newWrapperEnrollment.meetingStreet = temp.Meeting_Street__c;
                newWrapperEnrollment.meetingCity = temp.Meeting_City__c;
                newWrapperEnrollment.meetingState = temp.Meeting_State__c;
                newWrapperEnrollment.oeCoordinatorName = temp.OE_Coordinator_Contact__r.Name;
                newWrapperEnrollment.oeCoordinatorPhoneNumber = temp.OE_Coordinator_Phone__c;
                newWrapperEnrollment.accountManger = temp.Account_Manager_Formula__c;
                newWrapperEnrollment.amPhone = temp.AM_Phone__c;
                newWrapperEnrollment.sarAccMgt = temp.SAR_AcctMgt__c;
                newWrapperEnrollment.sarPhone = temp.SAR_Phone__c;
                newWrapperEnrollment.clientEngagementConsultantSAR = temp.Client_Engagement_Consultant_SAR__c;
                newWrapperEnrollment.clientEngagementConsultantSARPhone = temp.Client_Engagement_Consultant_SAR_Phone__c;
                wrapperEnrollmentList.add(newWrapperEnrollment);
            }
        }
        return JSON.serialize(wrapperEnrollmentList);
        
    }    
   
    @AuraEnabled
    /**
    * @description fetchVolParts method    
    */ 
    public static String fetchVolParts() {
        /**
        * @description fetchVolParts method
        * @param
        * @return String fetchVolParts
        */ 
        List<id> lstVolEvTemp1 = new List<id>();
        lstVolEvTemp1 = getVolunteerEvent(false);
        
        List<WrapperopenEnrollment> wrapperEnrollmentList = new list<WrapperopenEnrollment>();
        if(!Schema.sObjectType.SFDC_Volunteer_Event__c.fields.id.isAccessible() || Schema.sObjectType.SFDC_Volunteer_Event__c.fields.id.isAccessible()) { 
            List<SFDC_Volunteer_Event__c> lstVolEved = [SELECT Account_Name__c,
                                                        Date__c,
                                                        Meeting_City__c ,
                                                        Meeting_State__c,
                                                        OE_Coordinator_Contact__r.Name,OE_Coordinator_Phone__c
                                                        FROM SFDC_Volunteer_Event__c WHERE id IN : lstVolEvTemp1];
            system.debug('==============================' + lstVolEved);
            
            
            for (SFDC_Volunteer_Event__c temp:lstVolEved){
                WrapperopenEnrollment newWrapperEnrollment = new WrapperopenEnrollment();
                newWrapperEnrollment.accountName = temp.Account_Name__c;
                newWrapperEnrollment.meetingDate = temp.Date__c;
                newWrapperEnrollment.meetingCity = temp.Meeting_City__c;
                newWrapperEnrollment.meetingState = temp.Meeting_State__c;
                newWrapperEnrollment.oeCoordinatorName = temp.OE_Coordinator_Contact__r.Name;
                newWrapperEnrollment.oeCoordinatorPhoneNumber = temp.OE_Coordinator_Phone__c;
                wrapperEnrollmentList.add(newWrapperEnrollment);
            }
        }
        return JSON.serialize(wrapperEnrollmentList);
    }
    
         private static List<Id> getVolunteerEvent(boolean isFilteredContent){
        List<id> lstVolEvTemp1 = new List<id>();
        if(!Schema.sObjectType.SFDC_Volunteer_Participant__c.fields.id.isAccessible()||Schema.sObjectType.SFDC_Volunteer_Participant__c.fields.id.isAccessible()) { 
            if(isFilteredContent == false){
              for(SFDC_Volunteer_Participant__c objVP : [   SELECT Volunteer_Event__c
                                                       FROM SFDC_Volunteer_Participant__c
                                                       WHERE  OE_Ambassador_Volunteer__r.Email = :UserInfo.getUserEmail()]) {
                                                           lstVolEvTemp1.add(objVP.Volunteer_Event__c);
                                                       }  
            }else{
                for(SFDC_Volunteer_Participant__c objVP : [   SELECT Volunteer_Event__c
                                                       FROM SFDC_Volunteer_Participant__c
                                                       WHERE  OE_Ambassador_Volunteer__r.Email = :UserInfo.getUserEmail()
                                                       AND Selected_For_Facilitator__c = true]) {
                                                           lstVolEvTemp1.add(objVP.Volunteer_Event__c);
                                                       }
            }
           
        }
        return lstVolEvTemp1;
    }
    
    
    /**
    * @description WrapperopenEnrollment class
    */
    public class WrapperopenEnrollment {
        String accountName{get;set;}
        String meetingCity{get;set;}
        String meetingState{get;set;}
        String oeCoordinatorName{get;set;}
        String oeCoordinatorPhoneNumber{get;set;}
        String sessionStartTime{get;set;}
        String sessionEndTime{get;set;}
        String meetingStreet{get;set;}
        String amPhone{get;set;}
        String sarAccMgt{get;set;}
        String sarPhone{get;set;}
        String accountManger{get;set;}
        String clientEngagementConsultantSAR{get;set;} 
        String clientEngagementConsultantSARPhone{get;set;}
        Date meetingDate{get;set;}
    }
    
}