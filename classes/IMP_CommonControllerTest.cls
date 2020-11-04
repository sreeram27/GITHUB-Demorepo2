/**
  * @author        Indra Lugina
  * @date          10/22/2018
  * @description   Test Class for IMP Common class
  */

@isTest
private class IMP_CommonControllerTest {
    
    static testMethod void testCommonController() {
		
        Test.startTest();
        	PageReference pg = Page.IMP_Common;
        	pg.getParameters().put('osSubType','IC-Revisions');
        	Test.setCurrentPage(pg);

         	IMP_CommonController controller = new IMP_CommonController();
        	String result = controller.osSubType;
        	System.assertEquals(result,'IC-Revisions');
    	Test.stopTest();
    }
}