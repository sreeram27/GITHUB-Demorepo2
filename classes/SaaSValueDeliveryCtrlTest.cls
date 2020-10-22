/** 
 *  @Author : Accenture 
 *  @Description : Test class for SaaSCreateUserStoriesCtrl
 *  @Created Date : 11\06\2015
 * 
 *  Version History :
 *  Date              Changes 
 *  08\06\2015        created 
 *	12\11\2019		  modified
 *
 */
@isTest
public class SaaSValueDeliveryCtrlTest 
{
    //PRDCRM - 48684 : Tech Debt story(Test setup method to create test data) | 10th Dec, 2019 | Accenture - Panthers
	/**
    @description : Test setup method for test data creation
    */
	@testSetup static void dataSetup() {
        // Creating Release__c record
        Release__c rel = SaaSTestUtility.createRelease();
        
        // Creating Value_Delivery_Session__c record
        Value_Delivery_Session__c sessiom  = SaaSTestUtility.createValueDeliverySession(rel);
        
        //Creating Value_Delivery_User_Config__c custom settings values
        Value_Delivery_User_Config__c vdU = new Value_Delivery_User_Config__c();
        vdu.Name = Userinfo.getUserID();      
        vdu.Selected_Session__c= sessiom.id;
        insert vdu;
    }
    
    
    //PRDCRM - 48684 | Few modification done to to follow the SFDC test class best practices | 10th Dec, 2019 | Accenture - Panthers
    /**
    @description : Test method to to cover the SaaSLinkToQuestionCtrl class
    */
   @isTest
   static void validateSaaSValueDeliveryCtrl()
   {      
       Test.startTest(); 
       Release__c rel = [Select id from Release__c LIMIT 1];
       Value_Delivery_Session__c session = [Select id from Value_Delivery_Session__c LIMIT 1];       
       Value_Delivery_User_Config__c vdu =  Value_Delivery_User_Config__c.getInstance(Userinfo.getUserID());
              
       SaaSValueDeliveryCtrl vdc = new SaaSValueDeliveryCtrl();      
       vdc.getReleases();      
       vdc.updateValueDelSession();
       vdc.releaseID = rel.id;
       vdc.updateValueDelSession();       
       vdc.sessionID = session.id;//vdu.id;
       vdc.updateValueDelSession();       
       List<SelectOption> opt = vdc.getSession();
       vdc.updateValueDelSession();
       Value_Delivery_User_Config__c valueDeliveryObj =  Value_Delivery_User_Config__c.getInstance(Userinfo.getUserID());
       System.assertEquals(session.id, valueDeliveryObj.Selected_Session__c, 'Selected session id stored in custom settings is not matching');
       Test.stopTest();
   }
  
}