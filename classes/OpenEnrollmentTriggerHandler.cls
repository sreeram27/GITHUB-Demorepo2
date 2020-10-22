/*************************************************************************************
Version     : 1.0 
@Author: Rahmath
Function    : Trigger Handler for Open enrollment object
@description :Trigger Handler for Open enrollment object
*************************************************************************************/
public with Sharing class OpenEnrollmentTriggerHandler {
        /*
        * @description updateMeetingCommHistory method
        * @param newRecords
        * @param oldMap
        */
    
    public static void updateMeetingCommHistory(List<SFDC_Volunteer_Event__c> newRecords, Map<Id, SFDC_Volunteer_Event__c> oldMap){
        
        String sComments = null;
        DateTime myDateTime = System.now();
        String formatted = myDateTime.formatGMT('MM-dd-yyyy\' - \'HH:mm:ss');
        
        for(SFDC_Volunteer_Event__c objSVE : newRecords){
            
            SFDC_Volunteer_Event__c objOldRec = oldMap.get(objSVE.id);            
            if(objSVE.Meeting_Comments__c== objOldRec.Meeting_Comments__c){
              continue;  
            } 
            sComments = objOldRec.Meeting_Comments__c + ' - ' + Userinfo.getFirstName() + ' ' + Userinfo.getLastName() + ' - ' + formatted;
            
            if(String.isBlank(objSVE.Meeting_Comments_History__c)){
              objSVE.Meeting_Comments_History__c  = sComments;    
            }else{
              objSVE.Meeting_Comments_History__c  = sComments + '\n' + objSVE.Meeting_Comments_History__c;  
            }
                
        }
    }
    
    ///Added - DK - 17-Jul
    

        /*
        * @description verifyLocation method
        * @param newRecords
        * @param oldRecords
        * @return List<SFDC_Volunteer_Event__c>
        */
    
    
  public static List<SFDC_Volunteer_Event__c> verifyLocation(List<SFDC_Volunteer_Event__c> newRecords, Map<Id, SFDC_Volunteer_Event__c> oldRecords){

    List<SFDC_Volunteer_Event__c> updatedAddresses = new List<SFDC_Volunteer_Event__c>();
    for(SFDC_Volunteer_Event__c event : newRecords){
      if(isAddressChanged(event, oldRecords.get(event.Id))){
        updatedAddresses.add(event);
      }
    }

    return updatedAddresses;
  }
        /**
        * @description updateChangedAddresses method
        * @param updatedMeetings
        */
  
    public static void updateChangedAddresses(List<SFDC_Volunteer_Event__c> updatedMeetings) {
    List<SFDC_Volunteer_Event__c> meetingsToUpdateWithLocations = new List<SFDC_Volunteer_Event__c>();

    TravelResponseService.sendLocationRequest(updatedMeetings);
  }
        /*
        * @description isAddressChanged method
        * @param newMeeting
        * @param oldMeeting
        * @return boolean
        */
    
    
  public static boolean isAddressChanged(SFDC_Volunteer_Event__c newMeeting, SFDC_Volunteer_Event__c oldMeeting){
    return ((newMeeting.Location__latitude__s == null && newMeeting.Location__longitude__s == null) || newMeeting.Meeting_Street__c != oldMeeting.Meeting_Street__c || newMeeting.Meeting_City__c != oldMeeting.Meeting_City__c || newMeeting.Meeting_State__c != oldMeeting.Meeting_State__c || newMeeting.Meeting_Zip_Code__c != oldMeeting.Meeting_Zip_Code__c);
  }
        /*
        * @description checkUpdateCount method
        * @param newRecords
        * @return Boolean
        */
    
    
  public static Boolean checkUpdateCount(List<SFDC_Volunteer_Event__c> newRecords) {
    return (newRecords.size() > 100);
  }
  
   
    
}