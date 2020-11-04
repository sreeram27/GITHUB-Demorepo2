/**********************************************************************************
Class Name :   LGA_AP_MyProfileController 
Date Created : 24-May-2019
Created By   : IDC Offshore
Description  : 1. This class is used in SGA_Ltng03_Quote_Omniscript.cmp (lightning component)
2. This class is used to fetch logged in user details.
Change History : 
*************************************************************************************/
public without sharing class LGA_AP_MyProfileController {
    
    @AuraEnabled
    /****************************************************************************************************
    Method Name : getUsersContactId
    Parameters  : None
    Return type : Strind
    Description : This method is used to fetch the logged in user contact id.
    ******************************************************************************************************/
    public static String getUsersContactId() {
        String strUrl = null;
        try{
            User usr = [SELECT Id, Name, ContactId From User WHERE Id=:UserInfo.getUserId() LIMIT 1];
            if(usr.ContactId!=null){
                strUrl = LGA_Constants.CONTACT_PREFIX+usr.ContactId;
            }else{
                strUrl = LGA_Constants.DETAIL_PREFIX+usr.Id;
            } 
        }catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, LGA_Constants.ORGID, LGA_Constants.APPLICATIONNAME, LGA_Constants.CLS_LGA_AP_MYPROFILECONTROLLER ,LGA_Constants.GETUSERSCONTACTID, LGA_Constants.BLANK, Logginglevel.ERROR); }
        return strUrl;
    }
}