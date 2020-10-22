/** 
 *  @Author : Accenture 
 *  @Description : Test Class for Controller class for SaaSQuestionLogListViewCtrl  
 *  @Created Date : 16\06\2015
 * 
 *  Version History :
 *  Date              Changes 
 *  16\06\2015        created 
 *	12\11\2019		  modified
 *
 */
@isTest 
public class SaaSLinkToQuestionCtrlTest
{
    //PRDCRM - 48684 : Tech Debt story(Test setup method to create test data) | 10th Dec, 2019 | Accenture - Panthers
    /**
    @description : Test setup method for test data creation
    */
	@testSetup static void dataSetup() {
        // Creating Question_Log__c record
		SaaSTestUtility.createSaaSQuestion();
        
        //Creating Request__c records
        SaaSTestUtility.createRequest();
        SaaSTestUtility.createRequest();  
    }
    
    //PRDCRM - 48684 | Few modification done to increase the code coverage | 10th Dec, 2019 | Accenture - Panthers
    /**
    @description : Test method to to cover the SaaSLinkToQuestionCtrl class
    */
    @isTest
    static void validateLinkToQuestionLog() 
    {
        Test.startTest(); 
        Boolean bool;
                
        Question_Log__c questionObj = [Select Id, Submitter__c, Question__c, Scope__c, Domain__c, recordTypeID from Question_Log__c LIMIT 1];
        SaaSLinkToQuestionCtrl ctrlObj = new SaaSLinkToQuestionCtrl(new ApexPages.StandardController(questionObj ));
        List<SaaSLinkToQuestionCtrl.RequestWrapper> wraplst = ctrlObj.getrequestWrapLst();
        ctrlObj.previous();
        ctrlObj.next();
        ctrlObj.first();
        ctrlObj.last();
        
        bool = ctrlObj.hasNext;
        bool = ctrlObj.hasPrevious;
        wraplst.get(0).checked = true ;
        wraplst.get(1).checked = true ;
        
        wraplst.get(1).checked = false;
        ctrlObj.updateSelectedRequest();
        List<SaaSLinkToQuestionCtrl.RequestWrapper> listSelectedElements = ctrlObj.getSelectedElement();
        System.assertEquals(1, listSelectedElements.size(), 'Selected element size is not matching');
        ctrlObj.linkToRequest();
        List<Related_Request__c> listRelatedReq = [Select Id from Related_Request__c where Question_Log__c=: questionObj.Id] ;
        System.assertEquals(1, listRelatedReq.size(), 'Selected element size is not matching');
        
        wraplst.get(0).checked = false;
        wraplst.get(1).checked = false;
        ctrlObj.updateSelectedRequest();
        List<SaaSLinkToQuestionCtrl.RequestWrapper> listSelectedElements1 = ctrlObj.getSelectedElement();
        System.assertEquals(0, listSelectedElements1.size(), 'Selected element size is not matching');        
        ctrlObj.linkToRequest();
        System.assertEquals(0, ctrlObj.selectedrequestWrapLst.size(), 'Selected element size is not matching');
        Test.stopTest();   
    }
    
}