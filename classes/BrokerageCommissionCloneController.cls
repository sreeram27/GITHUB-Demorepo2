/**
* @author: Ravideep(Vikings)
* @date: 05/24/2019
* @description: Server Side controller for lightning component cloneBrokerageCommission
* @history:  
*/
public class BrokerageCommissionCloneController{
    
    /*PRDCRM-   : Method to insert cloned record */
    @AuraEnabled
    public static string insertClonedRecord(Broker_Consultant_Commissions1__c bccomm) {
        List<Broker_Consultant_Commissions1__c> bcCommissionList = New List<Broker_Consultant_Commissions1__c>();
        system.debug('record--> ' + bccomm);
        string returnval ;
        
        if(bccomm != null){
            Database.saveresult srrecord = database.insert(bccomm,false);
            if (srrecord.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted record: ' + srrecord.getId());
                returnval =  srrecord.getId();
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : srrecord.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug( 'fields that affected this error: ' + err.getFields());
                        throw new AuraHandledException(err.getStatusCode() + ': ' + err.getMessage());  
                }
            }
        }
        system.debug(returnval);
        return returnval;
    }
    
     @AuraEnabled
    public static boolean getBrokerageCommissionSplitTotal(string recordId,decimal dccurrentBrokerageCommission) {
        boolean showWarning = false;
        List<Broker_Consultant_Commissions1__c> IncomingBCList = new List <Broker_Consultant_Commissions1__c>();
        List<Broker_Consultant_Commissions1__c> brokerageCommissionList = new List <Broker_Consultant_Commissions1__c>();
        decimal dcTotalBrokerageCommission = dccurrentBrokerageCommission;
        
        system.debug('dccurrentBrokerageCommission-->' + dccurrentBrokerageCommission);
        system.debug('recordId-->' + recordId); //id of opportunity passed from lightning component 
        
        /*querying all brokerage commission records associated with opportunity */
        if(!string.isempty(recordId)){
            brokerageCommissionList = [Select id,Brokerage_Commission_Split__c,Opportunity__c from Broker_Consultant_Commissions1__c where Opportunity__c =: recordId];
        }
        
        
        system.debug('brokerageCommissionList-->' + brokerageCommissionList);
        
        if(!brokerageCommissionList.isEmpty()){
            for(Broker_Consultant_Commissions1__c bc : brokerageCommissionList){
                if(bc.Brokerage_Commission_Split__c!=null){
                    if(dcTotalBrokerageCommission == null){
                        dcTotalBrokerageCommission = 0;
                    }
                    dcTotalBrokerageCommission = dcTotalBrokerageCommission + bc.Brokerage_Commission_Split__c;
                }
            }
        }
        
        system.debug('dcTotalBrokerageCommission-->' + dcTotalBrokerageCommission);
        if(dcTotalBrokerageCommission != null && dcTotalBrokerageCommission != 100){
            showWarning = true;
        }
        
        return showWarning;
    }
}