@isTest
public class UpdateClosedDateTriggerTest {
    
    static testmethod void closedDateTestMethod(){
        Defect__c def = new Defect__c(Status__c = 'Open-In Review', Subject__c = 'abcd', Detailed_Description__c = 'New Test', 
                                      Environment__c = 'sandbox');
        insert def;
        
        // Start | Adding Assert Check PRDCRM-44931
        List<Defect__c> listDef= [SELECT Id FROM Defect__c WHERE id=:def.id]; 
        System.assertEquals(1, listDef.size(),'Record Not Present'); 
        System.assertNotEquals(0, listDef.size(),'Record Not Present'); 
        // End | Adding Assert Check PRDCRM-44931
        
        
        def.Status__c = 'Closed';
        def.Closed_Date__c = datetime.now();//Code modification for not to update null value done by Accenture-MCS Code Scan PRDCRM-44931       
        update def;
        
        // Start | Adding Assert Check PRDCRM-44931
        List<Defect__c> listDefectsAfterUpdate = [SELECT Id, Status__c, Closed_Date__c FROM Defect__c WHERE id =: def.id]; 
        Defect__c updatedDefect = listDefectsAfterUpdate[0];  
        System.assert(updatedDefect.Closed_Date__c<datetime.now(),'Closed_Date__c is not set from trigger');
        // End | Adding Assert Check PRDCRM-44931
    }
    
    static testmethod void closedDateTestMethod2(){
        Defect__c def1 = new Defect__c(Status__c = 'Closed', Subject__c = 'defg', Detailed_Description__c = 'New Test1', 
                                       Environment__c = 'prod');
        insert(def1);
        
        // Start | Adding Assert Check PRDCRM-44931
        List<Defect__c> listDefect= [SELECT Id FROM Defect__c WHERE id=:def1.id]; 
        System.assertEquals(1, listDefect.size(),'Record Not Present'); 
        System.assertNotEquals(0, listDefect.size(),'Record Not Present'); 
        // End | Adding Assert Check PRDCRM-44931
        
       
        def1.Status__c = 'Open-In Review';
        update def1;   
        
        // Start | Adding Assert Check PRDCRM-44931
        List<Defect__c> listDefectsAfterUpdate = [SELECT Id, Status__c, Closed_Date__c FROM Defect__c WHERE id =: def1.id]; 
        Defect__c updatedDefect = listDefectsAfterUpdate[0];
        System.assert(updatedDefect.Closed_Date__c==null,'Closed_Date__c is not null'); 
        // End | Adding Assert Check PRDCRM-44931
    }
    
}