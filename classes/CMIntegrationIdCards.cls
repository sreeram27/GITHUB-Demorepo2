public class CMIntegrationIdCards {
    
	//The method will prepare the id card payload
    public static CMIntegrationRequest buildCMPayloadIdCard(Order od, String idCardType, List<String> suffixList,  CMIntegrationRequest.cls_eventMetaData eventMetaData) {
        
        CMIntegrationRequest jsonCMPayload = new CMIntegrationRequest();        
       // String eventType = CMIntegrationConstants.EVENT_TYPE_IDCARDREQUEST;
        jsonCMPayload.eventMetaData = eventMetaData;
        
        buildCustomerInfoIdCard(jsonCMPayload, od, idCardType, suffixList);
        
        return jsonCMPayload;
    }
    
    /*
        The method is used to populate the customerInfo section under Account info for Id Card
     */
    public static void buildCustomerInfoIdCard(CMIntegrationRequest jsonCMPayload, Order od, String idCardType, List<String> suffixList){
        
        CMIntegrationRequest.cls_accountInfo accountInfo = new CMIntegrationRequest.cls_accountInfo();
        jsonCMPayload.accountInfo = accountInfo;
        
        CMIntegrationRequest.cls_customerInfo customerInfo = new CMIntegrationRequest.cls_customerInfo();
        accountInfo.customerInfo = customerInfo;
        
        List<CMIntegrationRequest.cls_customers> customers = new List<CMIntegrationRequest.cls_customers>();
        accountInfo.customerInfo.customers = customers;
        CMIntegrationRequest.cls_customers customer = new CMIntegrationRequest.cls_customers();
        customers.add(customer);
        
        // ids section
        /*
        1.       Get account id from account related to implementation case and populate as salesforce id in customers/id section as below –
        a.       Source system –‘SFDC Com2’
        b.      Name -  check name on other payload
        c.       Value – account id
        */
        List<CMIntegrationRequest.cls_ids> ids = new List<CMIntegrationRequest.cls_ids>();
        customer.ids = ids;
        
        CMIntegrationRequest.cls_ids id1 = new CMIntegrationRequest.cls_ids();
        id1.sourceSystem = CMIntegrationConstants.SOURCE_SYSTEM_SFDCCOM2; // 'SFDC COM2'
        id1.name = CMIntegrationConstants.ID_NAME_ACCOUNTID; // 'accountID'
        id1.value = od.accountId;
        
        customer.ids.add(id1);
        
        /*
        2.   Get group record with claim system as WGS linked to current implementation case and populate wgs id in customers /id section as below –
        a.   sourceSystem – WGS
        b.   name – caseID
        c.   value – name field from group__c record
        */
        if (od.Claim_System__c == CMIntegrationConstants.CLAIM_SYSTEM_WGS) { // 'WGS 2.0'
            CMIntegrationRequest.cls_ids id2 = new CMIntegrationRequest.cls_ids();
            id2.sourceSystem = CMIntegrationConstants.SOURCE_SYSTEM_WGS; // 'WGS'
            id2.name = 'caseID';
            id2.value = od.Group_Name__r == null ? '' : od.Group_Name__r.name;
            customer.ids.add(id2);
        }
        // validate at higher level method if not WGS
        // else {
        //Return error message 'Invalid ID Card Request. ID Card request is supported only for WGS claim system';
        //}
        
        // Add global customer id at customer level for all transactions
        if (od.account != null && !String.isEmpty(od.account.Global_Customer_ID__c)) {
            
            CMIntegrationRequest.cls_ids id3 = new CMIntegrationRequest.cls_ids();
            id3.sourceSystem = CMIntegrationConstants.SOURCE_SYSTEM_CM; // 'CM'
            id3.name = CMIntegrationConstants.ID_NAME_GLOBALCUSTOMERID; // 'globalCustomerId'
            id3.value = od.account.Global_Customer_ID__c;
            customer.ids.add(id3);
        }
        
        // demographic section
        CMIntegrationRequest.cls_demographic demographic = new CMIntegrationRequest.cls_demographic();
        /*
        3.       Populate account name in demographic/organizationName/name field
        */
        demographic.organizationName = new CMIntegrationRequest.cls_organizationName();
        demographic.organizationName.name = od.account.name;
        customer.demographic = demographic;
        /*
            4.       Populate id card trigger section as below 
            Option 1 case level –
            Entity id :  name field from group__c record (same as in step 2)
            Entity Type : “customer”
            Option 2 suffix level:
            a.       Create multiple records for each suffix.
            */
        List<CMIntegrationRequest.cls_idCardsTrigger> idCardsTriggerList = new List<CMIntegrationRequest.cls_idCardsTrigger>();
        customer.idCardsTrigger = idCardsTriggerList;
        
        if (idCardType == CMIntegrationConstants.IDCARD_TYPE_CASE) {
            CMIntegrationRequest.cls_idCardsTrigger idCardsTrigger = new CMIntegrationRequest.cls_idCardsTrigger();
            idCardsTrigger.entityID = od.Group_Name__r.name;
            idCardsTrigger.entityType = 'customer';
            idCardsTriggerList.add(idCardsTrigger);
            
        } else if (idCardType == CMIntegrationConstants.IDCARD_TYPE_SUFFIX) {
            for(String suffix : suffixList) {
                CMIntegrationRequest.cls_idCardsTrigger idCardsTrigger = new CMIntegrationRequest.cls_idCardsTrigger();
                idCardsTrigger.entityID = suffix;
                idCardsTrigger.entityType = 'suffix';
                idCardsTriggerList.add(idCardsTrigger);
                
            }
        }
        /*else if (idCardType == CMIntegrationConstants.IDCARD_TYPE_ACCOUNT) {
            // TODO
            }*/
    }
    
}