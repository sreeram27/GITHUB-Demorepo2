/***************************************************************
* Purpose:  Assign OE Coordinator based on Anthem Entity ,Region,Situs State
* Mod:      5 August 2019
* Author:   Mehaboob
* Story :   PRDCRM-37974
***************************************************************
Modifications 
@Author :Mehaboob
@description : added oem.Submarket__c!='Strategic' for Situs State California where Submarket as Strategic
@Story :   PRDCRM-43854
@comment : Modified as part of PRDCRM-43854
***************************************************************/

public with sharing class OpenEnrollmentMeetingsHandler{

    //@comment : method to assign the OE Coordinator based on Entity,Region ,Situs State.
    public static void assignOECoordinator(List<Open_Enrollment_Meetings__c> newOEMList, String openEnrollmentAccountID){
        
        Id facRecTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        
        //returns list of OE Coordinators
        List<Contact> conList=[Select Id,Account.Id,Facilitator_Type__c,RecordType.Name, Region_Location__c from Contact where Account.Id=: openEnrollmentAccountID AND Facilitator_Type__c='OE Coordinator' AND Region_Location__c!=NULL AND RecordTypeID=:facRecTypeID];
        
        for(Open_Enrollment_Meetings__c oem:newOEMList){ 
            
            for(Contact con:conList){
                
                
                //National Accounts  : OE Coordinator for Anthem Entity National Accounts
                if( oem.Anthem_Entity__c==Label.National_Accounts_AE && (con.Region_Location__c!=NULL && con.Region_Location__c!='') && con.Region_Location__c.contains(oem.Account_Region__c) ){
                        oem.OE_Coordinator_Contact__c=con.Id;
                    }
                
                //Local/Large Group : : OE Coordinator for Anthem Entity Local/Large Group
                else if((oem.Anthem_Entity__c==Label.Local_Large_Group_AE) && (con.Region_Location__c!=NULL && con.Region_Location__c!='') && oem.Situs_State__c==Label.Situs_State_California && oem.Submarket__c==Label.Strategic_California && con.Region_Location__c.contains(Label.Strategic_Accounts)){
                        oem.OE_Coordinator_Contact__c=con.Id;
                    } 
                    
                //Local/Large Group : : OE Coordinator for Anthem Entity Local/Large Group for non Strategic    
                else if((oem.Anthem_Entity__c==Label.Local_Large_Group_AE) && (con.Region_Location__c!=NULL && con.Region_Location__c!='')  && con.Region_Location__c.contains(oem.Situs_State__c) && oem.Submarket__c!=Label.Strategic_California){
                        oem.OE_Coordinator_Contact__c=con.Id;
                    }
                
                //Labor and Trust : OE Coordinator for Anthem Entity Labor and Trust
                else if( (con.Region_Location__c!=NULL && con.Region_Location__c!='') && oem.Anthem_Entity__c==Label.Labor_and_Trust_AE && con.Region_Location__c.contains(Label.Labor_Accounts) ){
                        oem.OE_Coordinator_Contact__c=con.Id;
                }
            }
        }  
    }
}