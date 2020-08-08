/**************************************************************************************
Apex Class Name:  OEAmbassadorVolunteerActions
Version       : 1.0 
* @Author     : X-men Offshore(Poonam)
@description  : As part of PRDCRM-43210 
@function     : class to trigger count of tally fields trigger
*************************************************************************************/

public with sharing class OEAmbassadorVolunteerActions{
    //Method to calculaye tally fields of OE Amb vol record based on contact fields
    public static void countTallyFields(List<SFDC_Volunteer_Participant__c> newOAVList, Map<Id, SFDC_Volunteer_Participant__c> oldOAVMap, Boolean isDelete,Boolean isInsert){        
        Map<Id, Id> oavConMap = new map<Id, Id>();
        List<Contact> finalContactListToUpdate = new List<Contact>();
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        Boolean conCheck = FALSE;
        List<Id> idList = new List<Id>();
        if(isDelete){
            for(SFDC_Volunteer_Participant__c oav : oldOAVMap.values()){
                idList.add(oav.OE_Ambassador_Volunteer__c);
            }
        }
       else
       {
           for (SFDC_Volunteer_Participant__c oav : newOAVList){
               idList.add(oav.OE_Ambassador_Volunteer__c);
           }
       }
       List<Contact> contactList = [Select Id, OE_Amb_Selected_Current_Year_Tally__c,OE_Amb_No_Thanks_Current_Year_Tally__c from Contact where Id IN : idList ];
       
       for(Contact con : contactList){
           if(!contactMap.containsKey(con.Id)){
               contactMap.put(con.id, con);
           }
       }
       
       if(!isDelete){
           if(!newOAVList.isEmpty()){
               conCheck = FALSE;
               for(SFDC_Volunteer_Participant__c oav : newOAVList){
                   if(!oavConMap.containsKey(oav.id)){
                       oavConMap.put(oav.id,oav.OE_Ambassador_Volunteer__c);
                   }
               }
               for(SFDC_Volunteer_Participant__c oav : newOAVList){
                   Contact newConMap = contactMap.get(oavConMap.get(oav.id));
                   Integer currentYear = Date.Today().Year();
                   Integer meetingDateYear = oav.Meeting_Date__c.year();
                   if (isInsert == FALSE){
                       if(oav.Selected_For_Facilitator__c == TRUE && currentYear == meetingDateYear && (oav.Selected_For_Facilitator__c != oldOAVMap.get(oav.Id).Selected_For_Facilitator__c)){
                           try{
                               newConMap.OE_Amb_Selected_Current_Year_Tally__c = newConMap.OE_Amb_Selected_Current_Year_Tally__c+1;
                           }
                           catch (System.NullPointerException e){
                               newConMap.OE_Amb_Selected_Current_Year_Tally__c = 1;
                           }
                           conCheck = TRUE;
                       }
                       else if(oav.Selected_For_Facilitator__c == FALSE && currentYear == meetingDateYear && (oav.Selected_For_Facilitator__c != oldOAVMap.get(oav.Id).Selected_For_Facilitator__c)){
                           try{
                               newConMap.OE_Amb_Selected_Current_Year_Tally__c = newConMap.OE_Amb_Selected_Current_Year_Tally__c-1;
                               if(newConMap.OE_Amb_Selected_Current_Year_Tally__c <= 0){
                                   newConMap.OE_Amb_Selected_Current_Year_Tally__c = 0;
                               }
                           }
                           catch (System.NullPointerException e){
                               newConMap.OE_Amb_Selected_Current_Year_Tally__c = 0;
                           }
                           //finalContactListToUpdate.add(newConMap);
                           conCheck=TRUE;
                       }
                   }
                   else if(isInsert == TRUE){
                       if(oav.Selected_For_Facilitator__c == TRUE && currentYear == meetingDateYear ){
                           try{
                               newConMap.OE_Amb_Selected_Current_Year_Tally__c = newConMap.OE_Amb_Selected_Current_Year_Tally__c+1;
                           }
                           catch (System.NullPointerException e){
                               newConMap.OE_Amb_Selected_Current_Year_Tally__c = 1;
                           }
                       // finalContactListToUpdate.add(newConMap);
                          conCheck = TRUE;
                       }
                   }
                   if(isInsert == FALSE){
                       if(oav.Thanks_but_No_Thanks__c == TRUE && currentYear == meetingDateYear && (oav.Thanks_but_No_Thanks__c != oldOAVMap.get(oav.Id).Thanks_but_No_Thanks__c)){
                           try{
                               newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c = newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c +1;
                           }
                           catch(System.NullPointerException e){
                               newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c = 1;
                           }
                       // finalContactListToUpdate.add(newConMap);
                        conCheck = TRUE;
                       }
                       else if(oav.Thanks_but_No_Thanks__c == FALSE && currentYear == meetingDateYear && (oav.Thanks_but_No_Thanks__c != oldOAVMap.get(oav.Id).Thanks_but_No_Thanks__c)){
                           try{
                               newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c = newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c -1;
                               if(newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c < 0){
                                   newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c = 0;
                               }
                           }
                           catch(System.NullPointerException e){
                               newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c = 0;
                           }
                       // finalContactListToUpdate.add(newConMap);
                        conCheck = TRUE;
                       }
                   }
                   else if(isInsert == TRUE){
                       if(oav.Thanks_but_No_Thanks__c == TRUE && currentYear == meetingDateYear ){
                           try{
                               newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c = newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c +1;
                           }
                           catch(System.NullPointerException e){
                               newConMap.OE_Amb_No_Thanks_Current_Year_Tally__c = 1;
                           }
                         //  finalContactListToUpdate.add(newConMap);
                           conCheck = TRUE;
                       }
                   }
                   if(conCheck = TRUE){
                       finalContactListToUpdate.add(newConMap);
                   }
               }
           }
          // Database.update(finalContactListToUpdate);
       }
       
    else{
           for(SFDC_Volunteer_Participant__c oav : oldOAVMap.values()){
               Contact oldConMap = contactMap.get(oldOAVMap.get(oav.Id).OE_Ambassador_Volunteer__c);
               Integer currentYear = Date.Today().Year();
               Integer meetingDateYear = oav.Meeting_Date__c.year();
               if(oldOAVMap.get(oav.Id).Selected_For_Facilitator__c == TRUE && currentYear == meetingDateYear ){
                   try{
                       oldConMap.OE_Amb_Selected_Current_Year_Tally__c = oldConMap.OE_Amb_Selected_Current_Year_Tally__c-1;
                       if(oldConMap.OE_Amb_Selected_Current_Year_Tally__c < 0){
                           oldConMap.OE_Amb_Selected_Current_Year_Tally__c = 0;
                       }
                   }catch(System.NullPointerException e){
                       oldConMap.OE_Amb_Selected_Current_Year_Tally__c = 0;
                   }
                  // finalContactListToUpdate.add(oldConMap);
                   conCheck = TRUE;
               }
              // finalContactListToUpdate.add(oldConMap);
               if(oldOAVMap.get(oav.Id).Thanks_but_No_Thanks__c == TRUE && currentYear == meetingDateYear ){
                   try{
                       oldConMap.OE_Amb_No_Thanks_Current_Year_Tally__c = oldConMap.OE_Amb_No_Thanks_Current_Year_Tally__c -1;
                       if(oldConMap.OE_Amb_No_Thanks_Current_Year_Tally__c < 0){
                           oldConMap.OE_Amb_No_Thanks_Current_Year_Tally__c = 0;
                       }
                   }catch(System.NullPointerException e){
                       oldConMap.OE_Amb_No_Thanks_Current_Year_Tally__c = 0;
                   }
                 //  finalContactListToUpdate.add(oldConMap);
                   conCheck = TRUE;
               }
             if(conCheck == TRUE){
                 finalContactListToUpdate.add(oldConMap); 
              }
           }
       }
       
       if(!finalContactListToUpdate.isEmpty()){
           Database.update(finalContactListToUpdate);
       }
   }
}