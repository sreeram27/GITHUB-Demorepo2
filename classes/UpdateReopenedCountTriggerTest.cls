@isTest
public class UpdateReopenedCountTriggerTest {
    
    static testmethod void updateReopenedCountTestMethod1(){
        Defect__c newDef = new Defect__c(Status__c = 'Failed Retest', Subject__c = 'efgh', Detailed_Description__c = 'New Test',Times_Reopened__c=0);
        insert(newDef);
        
        // Start | Adding Assert Check PRDCRM-44931
        List<Defect__c> listNewDef= [SELECT Id FROM Defect__c WHERE id =: newDef.id]; 
        System.assertEquals(1, listNewDef.size(),'Record Not Present'); 
        System.assertNotEquals(0, listNewDef.size(),'Record Not Present'); 
        // End | Adding Assert Check PRDCRM-44931
        
        newDef.Status__c = 'Expected Behaviour';
        update newDef;
        
        // Start | Adding Assert Check PRDCRM-44931
        List<Defect__c> listDefectsAfterUpdate = [SELECT Id, Status__c, Times_Reopened__c FROM Defect__c WHERE id =: newDef.id]; 
        Defect__c updatedDefect = listDefectsAfterUpdate[0];
        System.assertEquals(0, updatedDefect.Times_Reopened__c,'Times_Reopened__c increased by 1'); 
        System.assertNotEquals(1, updatedDefect.Times_Reopened__c,'Times_Reopened__c increased by 1'); 
        // End | Adding Assert Check PRDCRM-44931
    }
    
    static testmethod void updateReopenedCountTestMethod2(){
        Defect__c newDef2 = new Defect__c(Status__c = 'Closed', Subject__c = 'efgh', Detailed_Description__c = 'New Test');
        insert(newDef2);
        
        // Start | Adding Assert Check PRDCRM-44931
        List<Defect__c> listNewDef2= [SELECT Id FROM Defect__c WHERE id=:newDef2.id]; 
        System.assertEquals(1, listNewDef2.size(),'Record Not Present'); 
        System.assertNotEquals(0, listNewDef2.size(),'Record Not Present');  
        // End | Adding Assert Check PRDCRM-44931        
        
        newDef2.Status__c = 'Resolved';
        update newDef2;
        
        // Start | Adding Assert Check PRDCRM-44931
        List<Defect__c> listDefectsAfterUpdate = [SELECT Id, Status__c, Times_Reopened__c FROM Defect__c WHERE id =: newDef2.id]; 
        Defect__c updatedDefect = listDefectsAfterUpdate[0];
        System.assertEquals(null, updatedDefect.Times_Reopened__c,'Times_Reopened__c increased by 1'); 
        System.assertNotEquals(1, updatedDefect.Times_Reopened__c,'Times_Reopened__c increased by 1');  
        // End | Adding Assert Check PRDCRM-44931
    }
    
    static testmethod void updateReopenedCountTestMethod3(){
        Defect__c newDef2 = new Defect__c(Status__c = 'In Progress', Subject__c = 'efgh', Detailed_Description__c = 'New Test', Times_Reopened__c=11);
        insert(newDef2);
        
        // Start | Adding Assert Check PRDCRM-44931
        List<Defect__c> listNewDef2= [SELECT Id FROM Defect__c WHERE id=:newDef2.id]; 
        System.assertEquals(1, listNewDef2.size(),'Record Not Present'); 
        System.assertNotEquals(0, listNewDef2.size(),'Record Not present'); 
        // End | Adding Assert Check PRDCRM-44931
        
        newDef2.Status__c = 'RE-OPENED';
        newDef2.Retest_Status__c='Open';
        newDef2.Retesting_Comments__c = 'XYZ';
        update newDef2;
        
        // Start | Adding Assert Check PRDCRM-44931
        List<Defect__c> listDefectsAfterUpdate = [SELECT Id, Status__c, Times_Reopened__c FROM Defect__c WHERE id =: newDef2.id]; 
        Defect__c updatedDefect = listDefectsAfterUpdate[0];
        System.assertEquals(12, updatedDefect.Times_Reopened__c,'Times_Reopened__c did not increase by 1'); 
        System.assertNotEquals(11, updatedDefect.Times_Reopened__c,'Times_Reopened__c did not increase by 1'); 
        // End | Adding Assert Check PRDCRM-44931
    }
}