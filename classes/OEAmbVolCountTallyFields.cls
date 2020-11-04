/**************************************************************************************
Apex Class Name:  OEAmbVolCountTallyFields
Version     : 1.0 
Created Date    : 24 April 2019
* @Author: X-men Offshore
Function    : class to trigger count of tally fields trigger
US          : PRDCRM-30730
*************************************************************************************/
public class OEAmbVolCountTallyFields {
 
    
   public static void countTallyFields(List<SFDC_Volunteer_Participant__c> newOAVList, Map<Id, SFDC_Volunteer_Participant__c> oldOAVMap, Boolean isDelete,Boolean isInsert){        
        Map<Id, Id> mapOAVCon =  new map<Id, Id>();
        List<Contact> FinalContactListToUpdate=new List<Contact>();
        Map<Id, Contact> mapCon = new Map<Id, Contact>();
        
        Boolean conCheck=FALSE;
           
        System.debug('isInsert value is '+isInsert);
        List<Id> listIds = new List<Id>();
        if(isDelete){
        for (SFDC_Volunteer_Participant__c childObj : oldOAVMap.values()) {
          listIds.add(childObj.OE_Ambassador_Volunteer__c);
         }
        }else{
            
            for (SFDC_Volunteer_Participant__c childObj : newOAVList) {
            listIds.add(childObj.OE_Ambassador_Volunteer__c);
         }
        }
        System.debug('my list Ids'+ listIds.Size()+''+listIds);  
        
         List<Contact> ConList =  [Select Id, OE_Amb_Selected_Current_Year_Tally__c,OE_Amb_No_Thanks_Current_Year_Tally__c from Contact where Id IN : listIds ];
         System.debug('my ConList are'+ ConList.size()+''+ConList );
        
        for(Contact o : ConList){
            if(!mapCon.containsKey(o.Id)){
                mapCon.put(o.id, o);
            }
        }
        System.debug('my mapCon are'+ mapCon.size()+''+mapCon);
        
        
        if(!isDelete){
            
            if(!newOAVList.isEmpty()){
                conCheck=FALSE;
                for(SFDC_Volunteer_Participant__c oav : newOAVList){
                    if(!mapOAVCon.containsKey(oav.id)){
                        mapOAVCon.put(oav.id,oav.OE_Ambassador_Volunteer__c);
                    }
                }
               System.debug('my mapOAVCon valueee'+ mapOAVCon.size()+''+mapOAVCon);
                for(SFDC_Volunteer_Participant__c oav : newOAVList){
                    Contact occ = mapCon.get(mapOAVCon.get(oav.id));
                    Integer currentYear = Date.Today().Year();
                    Integer meetingDateYear = oav.Meeting_Date__c.year(); 
                    System.debug('my currentYear '+currentYear+'Meeting_Date__c year value '+ currentYear );
                  //  System.debug('old value of checkbox select '+oldOAVMap.get(oav.Id).Selected_For_Facilitator__c +''+'new value is'+oav.Selected_For_Facilitator__c);
                    
                  if (isInsert==FALSE)  {
                    if(oav.Selected_For_Facilitator__c==TRUE && currentYear==meetingDateYear && (oav.Selected_For_Facilitator__c!=oldOAVMap.get(oav.Id).Selected_For_Facilitator__c)){
                        System.debug('my amb valueee'+occ.OE_Amb_Selected_Current_Year_Tally__c+'Me count'+occ.OE_Amb_Selected_Current_Year_Tally__c);
                        System.debug('my insert staus'+oav.Selected_For_Facilitator__c);
                        
                        
                       // system.debug('occ valueee : '+occ.OE_Amb_Selected_Current_Year_Tally__c);
                        try {
                          occ.OE_Amb_Selected_Current_Year_Tally__c = occ.OE_Amb_Selected_Current_Year_Tally__c+1;
                          }catch (System.NullPointerException e) {
                         occ.OE_Amb_Selected_Current_Year_Tally__c = 1;
                        }
                        
                       // FinalContactListToUpdate.add(occ);
                       conCheck=TRUE;
                    } else if(oav.Selected_For_Facilitator__c==FALSE && currentYear==meetingDateYear && (oav.Selected_For_Facilitator__c!=oldOAVMap.get(oav.Id).Selected_For_Facilitator__c)){
                        System.debug('status : '+oav.Selected_For_Facilitator__c);
                        
                        system.debug('occcccccc valueee : '+occ.OE_Amb_Selected_Current_Year_Tally__c);
                        
                        try {
                        occ.OE_Amb_Selected_Current_Year_Tally__c = occ.OE_Amb_Selected_Current_Year_Tally__c-1;
                          if(occ.OE_Amb_Selected_Current_Year_Tally__c<=0){
                              occ.OE_Amb_Selected_Current_Year_Tally__c=0;
                          }
                       } catch (System.NullPointerException e) {
                         occ.OE_Amb_Selected_Current_Year_Tally__c = 0;
                        }
                       // FinalContactListToUpdate.add(occ);
                        conCheck=TRUE;
                    }
                }   
                else if(isInsert==TRUE){
                    if(oav.Selected_For_Facilitator__c==TRUE && currentYear==meetingDateYear ){
                        System.debug('my amb valueee'+occ.OE_Amb_Selected_Current_Year_Tally__c+'Me count'+occ.OE_Amb_Selected_Current_Year_Tally__c);
                        System.debug('my insert staus'+oav.Selected_For_Facilitator__c);
                        
                        
                       // system.debug('occ valueee : '+occ.OE_Amb_Selected_Current_Year_Tally__c);
                        try {
                          occ.OE_Amb_Selected_Current_Year_Tally__c = occ.OE_Amb_Selected_Current_Year_Tally__c+1;
                          }catch (System.NullPointerException e) {
                         occ.OE_Amb_Selected_Current_Year_Tally__c = 1;
                        }
                        
                       // FinalContactListToUpdate.add(occ);
                       conCheck=TRUE;
                    } 
                }
                    
                 
                if (isInsert==FALSE){                    
                     if(oav.Thanks_but_No_Thanks__c==TRUE && currentYear==meetingDateYear && (oav.Thanks_but_No_Thanks__c!=oldOAVMap.get(oav.Id).Thanks_but_No_Thanks__c)){
                        System.debug('my amb valueee'+occ.OE_Amb_No_Thanks_Current_Year_Tally__c +'Me count'+occ.OE_Amb_No_Thanks_Current_Year_Tally__c );
                        System.debug('my insert staus'+oav.Thanks_but_No_Thanks__c);
                        
                        
                       // system.debug('occ valueee : '+occ.OE_Amb_No_Thanks_Current_Year_Tally__c );
                        try {
                          occ.OE_Amb_No_Thanks_Current_Year_Tally__c  = occ.OE_Amb_No_Thanks_Current_Year_Tally__c +1;
                          }catch (System.NullPointerException e) {
                         occ.OE_Amb_No_Thanks_Current_Year_Tally__c  = 1;
                        }
                        
                       // FinalContactListToUpdate.add(occ);
                        conCheck=TRUE;
                    }else if(oav.Thanks_but_No_Thanks__c==FALSE && currentYear==meetingDateYear && (oav.Thanks_but_No_Thanks__c!=oldOAVMap.get(oav.Id).Thanks_but_No_Thanks__c)){
                        System.debug('status : '+oav.Thanks_but_No_Thanks__c);
                        
                        system.debug('occcccccc valueee : '+occ.OE_Amb_No_Thanks_Current_Year_Tally__c );
                        try {
                        occ.OE_Amb_No_Thanks_Current_Year_Tally__c  = occ.OE_Amb_No_Thanks_Current_Year_Tally__c -1;
                        if(occ.OE_Amb_No_Thanks_Current_Year_Tally__c<0){
                            occ.OE_Amb_No_Thanks_Current_Year_Tally__c=0;
                        }
                        }catch (System.NullPointerException e) {
                         occ.OE_Amb_No_Thanks_Current_Year_Tally__c = 0;
                        }
                       // FinalContactListToUpdate.add(occ);
                        conCheck=TRUE;
                    }
                }else if(isInsert==TRUE){
                    if(oav.Thanks_but_No_Thanks__c==TRUE && currentYear==meetingDateYear ){
                        System.debug('my amb valueee'+occ.OE_Amb_No_Thanks_Current_Year_Tally__c +'Me count'+occ.OE_Amb_No_Thanks_Current_Year_Tally__c );
                        System.debug('my insert staus'+oav.Thanks_but_No_Thanks__c);
                        
                        try {
                          occ.OE_Amb_No_Thanks_Current_Year_Tally__c  = occ.OE_Amb_No_Thanks_Current_Year_Tally__c +1;
                          }catch (System.NullPointerException e) {
                         occ.OE_Amb_No_Thanks_Current_Year_Tally__c  = 1;
                        }
                        
                       // FinalContactListToUpdate.add(occ);
                        conCheck=TRUE;
                    }
                } 

                
                    IF( conCheck=TRUE){
                      FinalContactListToUpdate.add(occ);
                    }
                
                    
                }
            }       
           // Database.update(FinalContactListToUpdate);
        }else {
           System.debug('del : '+isDelete);
            for(SFDC_Volunteer_Participant__c oav : oldOAVMap.values()){
                Contact occ = mapCon.get(oldOAVMap.get(oav.Id).OE_Ambassador_Volunteer__c); 
                Integer currentYear = Date.Today().Year();
                Integer meetingDateYear = oav.Meeting_Date__c.year(); 
                system.debug('occcc : '+occ.OE_Amb_Selected_Current_Year_Tally__c);
               If(oldOAVMap.get(oav.Id).Selected_For_Facilitator__c==TRUE && currentYear==meetingDateYear ){
                       System.debug('my amb valueee'+occ.OE_Amb_Selected_Current_Year_Tally__c+'Me count'+occ.OE_Amb_Selected_Current_Year_Tally__c);
                       System.debug('my insert staus'+oldOAVMap.get(oav.Id).Selected_For_Facilitator__c);
                    try{
                       occ.OE_Amb_Selected_Current_Year_Tally__c = occ.OE_Amb_Selected_Current_Year_Tally__c-1;
                       if(occ.OE_Amb_Selected_Current_Year_Tally__c<0){
                           occ.OE_Amb_Selected_Current_Year_Tally__c=0;
                       }
                    }catch (System.NullPointerException e) {
                         occ.OE_Amb_Selected_Current_Year_Tally__c  = 0;
                        }
                       //FinalContactListToUpdate.add(occ);
                       conCheck=TRUE;
                }
               // FinalContactListToUpdate.add(occ);
               
               If(oldOAVMap.get(oav.Id).Thanks_but_No_Thanks__c==TRUE && currentYear==meetingDateYear ){
                        System.debug('status : '+oldOAVMap.get(oav.Id).Thanks_but_No_Thanks__c);
                        
                        system.debug('occcccccc valueee : '+occ.OE_Amb_No_Thanks_Current_Year_Tally__c );
                      try{  
                        occ.OE_Amb_No_Thanks_Current_Year_Tally__c  = occ.OE_Amb_No_Thanks_Current_Year_Tally__c -1;
                         if(occ.OE_Amb_No_Thanks_Current_Year_Tally__c<0){
                             occ.OE_Amb_No_Thanks_Current_Year_Tally__c=0;
                         }
                      }catch (System.NullPointerException e) {
                         occ.OE_Amb_No_Thanks_Current_Year_Tally__c  = 0;
                        }
                       // FinalContactListToUpdate.add(occ);
                        conCheck=TRUE;
                    }
                    
             if(conCheck==TRUE){       
               FinalContactListToUpdate.add(occ); 
              }     
            }
            
        }
        
        if(!FinalContactListToUpdate.isEmpty()){
            Database.update(FinalContactListToUpdate);
        }
}       


 


}