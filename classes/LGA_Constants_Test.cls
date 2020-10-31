/*******************************************************************************************
@class Name  : LGA_Constants_Test
@created By  : IDC Offshore
@createdDate : 09/12/2019
@description : This test class is for LGA_Constants
********************************************************************************************/
@istest 
public class LGA_Constants_Test {
    /*******************************************************************************************
@method Name  : myUnitTest
@description : This is test method for LGA_Constants
********************************************************************************************/
    static testMethod void myUnitTest() {
        LGA_Constants con = new LGA_Constants();
        System.assertEquals(LGA_Constants.CONTACT_PREFIX,LGA_Constants.CONTACT_PREFIX);
        System.assertEquals(LGA_Constants.DETAIL_PREFIX,LGA_Constants.DETAIL_PREFIX);
        System.assertEquals(LGA_Constants.APPLICATIONNAME,LGA_Constants.APPLICATIONNAME);
        System.assertEquals(LGA_Constants.CLS_LGA_AP_MYPROFILECONTROLLER,LGA_Constants.CLS_LGA_AP_MYPROFILECONTROLLER);
        System.assertEquals(LGA_Constants.ORGID,LGA_Constants.ORGID);
        System.assertEquals(LGA_Constants.GETUSERSCONTACTID,LGA_Constants.GETUSERSCONTACTID);
        System.assertEquals(LGA_Constants.BLANK,LGA_Constants.BLANK);
        System.assertEquals(LGA_Constants.CLS_LGA_FILEUPLOAD,LGA_Constants.CLS_LGA_FILEUPLOAD);
        System.assertEquals(LGA_Constants.SPACE,LGA_Constants.SPACE);
        System.assertEquals(LGA_Constants.WHERE_CLAUSE,LGA_Constants.WHERE_CLAUSE);
        System.assertEquals(LGA_Constants.CONDITION,LGA_Constants.CONDITION);
        System.assertEquals(LGA_Constants.ID,LGA_Constants.ID);
    }
}