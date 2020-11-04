/*
@author         Accenture offshore
@Request        961
@date           29/06/2017
@name           ANA_QuoteLineItemApprBeforeUpdate_Test
@description    Test class to test ANA_QuoteLineItemApprovalBeforeUpdate which will updates the
              latest approval history comments on approval comments field.
*/
@isTest
private class ANA_QuoteLineItemApprBeforeUpdate_Test {
    private static final string NATIONALAMPROFILE='System Administrator'; 
    private static final string CLAIMSYSTEM= 'CS90';
    /*method to create test data*/
    static QuoteLineItem createData()
    {
        Account acc=ANA_UTIL01_TestMethods.createAccount(false); 
        Database.insert(acc);
        Opportunity oppty=ANA_UTIL01_TestMethods.createOpportunity(false,acc.id);
        Database.insert(oppty);
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(acc.id,false);
        grp.ClaimSystem__c=CLAIMSYSTEM;
        Database.insert(grp);
        Quote qte=ANA_UTIL01_TestMethods.createQuote(false,oppty.Id);
        qte.GroupNumber__c=grp.id;
        Database.insert(qte);
        Product2 prod=ANA_UTIL01_TestMethods.createProduct(false);
        prod.name='Anthem Health Guide';
        Database.insert(prod);
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
        Database.insert(pbe);
        QuoteLineItem qli= ANA_UTIL01_TestMethods.createQuoteLineItem(false,qte.Id, pbe.id);
        return qli;
    }
    /*Method to create QLI record, submitting for approval and approving the record to test the ANA_QuoteLineItemApprovalBeforeUpdate trigger functionality*/
    static testmethod void submitApprovalPositive(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1 ]; 
        User usr=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        usr.BypassValidation__c=True;
        usr.UserName='postest@anthem.com';
        system.runAs(usr){
            QuoteLineItem qli= createData();
            //qli.AHGProduct__c=true;
            qli.Funding__c='ASO';           
            qli.MedicalManagementPlatform__c='HRS/WMDS';
            qli.MembershipSplitBetweenAHGandNonAHG__c='No';
            qli.Members__c=52;
            qli.ClinicalDeliveryModel__c='IHM'; 
            qli.ServiceTier__c='AHG';
            qli.RecordType__c='AIM';            
            Database.insert(qli);
            QuoteLineItemApproval__c qlia=ANA_UTIL01_TestMethods.createQuoteLineItemApproval(QLI.id,1)[0];
            Database.insert(qlia);
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(qlia.id); 
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(result.isSuccess());
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setWorkitemId(newWorkItemIds.get(0));
            // Submit the request for approval
            Approval.ProcessResult result2 =  Approval.process(req2);
            // Verify the results
            System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
            System.assertEquals('Approved', result2.getInstanceStatus(),'Instance Status'+result2.getInstanceStatus());
        }
    }
 /*Method to test negative scenario by passing null values*/    
    static testmethod void submitApprovalNegative(){
        Profile profileNA = [select id from profile where name=:NATIONALAMPROFILE limit 1 ]; 
        User usr=ANA_UTIL01_TestMethods.runAsUser(profileNA.id);
        usr.UserName='negtest@anthem.com';
        usr.BypassValidation__c=True;
        system.runAs(usr){
            ANA_QuoteLineItemApprovalTrigger_Handler.updateApprovalComments(null, null);            
        }        
    }    
}