/**
Description: This is the helper class for ambassadorVolunteer trigger on OE Ambassador Volunteers object
Created Date: 13/02/2019
Last Modified Date : 13/02/2019
**/
public class ambassadorVolunteerHelper{

public static void contactCalMethod(list<SFDC_Volunteer_Participant__c> volPartLst){
        list<string> participantLst = new list<string>();
        list<string> enrollmentLst =  new list<string>();
        map<id,set<string>> prtEnrolmntMap = new map<id,set<string>>(); 
        map<id,id> meetGrpngMap = new map<id,id>();
        map<id,id> enrolAccMap = new map<id,id>();
        map<id,integer> prtTotal = new map<id,integer>();  
        map<id,id> accPartiLst = new map<id,id>();
        for(SFDC_Volunteer_Participant__c volPart:volPartLst){
            if(volPart.Volunteer_Event__c !=null && volPart.OE_Ambassador_Volunteer__c !=null){
                    participantLst.add(volPart.OE_Ambassador_Volunteer__c);
                    enrollmentLst.add(volPart.Volunteer_Event__c);
                    enrolAccMap.put(volPart.Volunteer_Event__r.OE_Grouping__c,volPart.Volunteer_Event__r.account__c);    
                       system.debug('--->'+volPart.Volunteer_Event__r.OE_Grouping__c);
                }
            }
        for(SFDC_Volunteer_Event__c meetingLst: [select id,OE_Grouping__c from SFDC_Volunteer_Event__c where id IN:enrollmentLst]){
                meetGrpngMap.put(meetingLst.OE_Grouping__c,meetingLst.id);
        }    
             list<string> meetingGrpLst = new list<string>();
         for(SFDC_Volunteer_Participant__c partLst:[select id,OE_Ambassador_Volunteer__c,Volunteer_Event__c,Volunteer_Event__r.OE_Grouping__c,Thanks_but_No_Thanks__c,Volunteer_Event__r.account__c from SFDC_Volunteer_Participant__c where OE_Ambassador_Volunteer__c IN:participantLst]){
                integer i;
                if(trigger.isInsert){
                    i=2;
                }
                else{
                    i=1;
                }
                set<string> participantSet = new set<string>();
                system.debug('--->'+enrollmentLst+'--->'+partLst.Volunteer_Event__r.OE_Grouping__c);
                if(enrollmentLst.contains(partLst.OE_Ambassador_Volunteer__c) && accPartiLst.containsKey(partLst.Volunteer_Event__r.OE_Grouping__c)){
                    i = prtTotal.get(partLst.OE_Ambassador_Volunteer__c);
                    prtTotal.put(partLst.OE_Ambassador_Volunteer__c,i+1);
                
                }
                else{
                    // participantSet.add(partLst.Volunteer_Event__c);
                    if(meetGrpngMap.containsKey(partLst.Volunteer_Event__r.OE_Grouping__c)){
                    enrollmentLst.add(partLst.OE_Ambassador_Volunteer__c);
                    //prtEnrolmntMap.put(partLst.OE_Ambassador_Volunteer__c,participantSet);
                    prtTotal.put(partLst.OE_Ambassador_Volunteer__c,i);
                    accPartiLst.put(partLst.Volunteer_Event__r.OE_Grouping__c,partLst.OE_Ambassador_Volunteer__c);
                    //  enrolAccMap.put(partLst.OE_Ambassador_Volunteer__c,enrollmentLst);
                    }
                }
         }
         system.debug('--->'+accPartiLst);
         for(SFDC_Volunteer_Participant__c volumePart:volPartLst){
             if(prtTotal != null){
                 if(prtTotal.get(volumePart.OE_Ambassador_Volunteer__c) > 1){
                     volumePart.Volunteered_for_1_meeting_in_group__c = true;
                 }
                 else{
                     volumePart.Volunteered_for_1_meeting_in_group__c = false;
                 }
             }
         }   
        
    }
}