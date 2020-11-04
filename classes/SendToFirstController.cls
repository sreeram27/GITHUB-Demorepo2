/*
    Name               :    SendToFirstController 
    Description        :    Apex controller for SendToFIRST lightning component. Validates the parameters required for 
                            the request and sends the validated request to FIRST
    Created By         :    Deloitte
*/
public class SendToFirstController {
    //    Request that holds necessary Account, Opportunity and Product information for the API request 
    public class RequestWrapper {
        public Opportunity opp;
        public Account acc;
        public List<QuoteLineItem> prod;
        public List<Group__c> groups;
        public String newRenewal;
        public String uwId;
        public String uwName; 
        public String srId;
        public String srName;
        public String gapPlan;
        public Date expDt;
    }
    
    //    Stores info to be shown on lightning component
    public class ResponseWrapper {
        @AuraEnabled public String status;
        @AuraEnabled public String statusMsg;
        @AuraEnabled public String accId;
        @AuraEnabled public String SICCode;
        @AuraEnabled public String opptyRTName;
        @AuraEnabled public QuoteLineItem[] qliList;
        @AuraEnabled public Opportunity oppty;
        @AuraEnabled public String UWLoginId;
        @AuraEnabled public String UWName;
        @AuraEnabled public String salesRepId;
        @AuraEnabled public String salesRepName;
        @AuraEnabled public String lob;
        @AuraEnabled public Date effectiveDate;
        @AuraEnabled public String regionCode = 'NY';
        
    }
    @AuraEnabled
    public static List<QuoteLineItem> getQuotes(Id OpptyId) {
        //Map<Id, QuoteLineItem> quoteLines = new Map<Id, QuoteLineItem>([select Id, ProcebookEntry.Product2.Name, Funding__c, ProcebookEntry.Product2.ProductCode From QuoteLineItem Where Quote.OpportunityId =: OpptyId]);
        return [select Id, Product2.Name,Product2.Underwriting_product_code__c, Funding__c, Product2.ProductCode, QuoteId, Quote.Name From QuoteLineItem Where Quote.OpportunityId =: OpptyId AND Funding__c = 'FI' AND Financing__c = 'Fully Insured' AND Product_type__c = 'Medical'];
    }
     @AuraEnabled
    public static Opportunity getRegion(Id OpptyId) {
        //Map<Id, QuoteLineItem> quoteLines = new Map<Id, QuoteLineItem>([select Id, ProcebookEntry.Product2.Name, Funding__c, ProcebookEntry.Product2.ProductCode From QuoteLineItem Where Quote.OpportunityId =: OpptyId]);
        Opportunity opp=[select Id, accountid,account.Situs_State__c,account.Anthem_Entity__c from opportunity where id=:OpptyId];
        return opp;
    }
   
    @AuraEnabled
    public static ResponseWrapper sendInfoToFIRST(Id opptyId) {
        ResponseWrapper res = new ResponseWrapper();
        res.qliList = getQuotes(opptyId);
        
        //    Queries all fields of Opportunity
        Opportunity oppty = (Opportunity)database.query(prepareQuery('Opportunity', opptyId));
        
        res.accId = oppty.AccountId;
        res.opptyRTName = oppty.RecordType.Name;
        res.oppty = oppty;
        res.effectiveDate = oppty.CloseDate;    
        
        try{
            //    Takes first 15 characters of the Opportunity Id. This is a needed for FIRST system to process the request
            String opporId = String.valueOf(oppty.Id).subString(0, 15);
            
            //    Renewal flag which is sent in the request
            String newRenewal;  
            if(oppty.RecordType.Name.contains('New Business Local') || oppty.RecordType.Name.contains('In Group Add Product Local')){
                newRenewal = 'N';
            }else if(oppty.RecordType.Name.contains('Renewal Local')){
                newRenewal = 'R';
            }
            List<OpportunityTeamMember> oppTeamMems;
            
            //    Query n check if there is any UnderWriter in Opportunity's team
            oppTeamMems = [SELECT UserId, Id, User.Name, User.FederationIdentifier, TeamMemberRole 
                            FROM OpportunityTeamMember
                            WHERE TeamMemberRole = 'Underwriter' AND 
                                  OpportunityID =: oppty.Id];
            
            String uwId, uwName, srId, srName;

            if(oppTeamMems.size() > 0){
                for(OpportunityTeamMember otm: oppTeamMems){
                    //    UnderWriter details
                    uwId = otm.User.FederationIdentifier;
                    uwName = otm.User.Name;

                    res.UWLoginId = uwId;
                    res.UWName = uwName;
                }
            }
            else {
                res.status = 'Failure';
                res.statusMsg = 'Validation Error: Team Member with Underwriter Role Not Found';
                
                return res;
            }
            User[] oppOwner = [SELECT Id,Name, FederationIdentifier FROM User WHERE Id =: oppty.OwnerId];
            
            if(oppOwner.size() > 0) {
                //    Sales Rep Details
                srId = oppOwner[0].FederationIdentifier;
                srName = oppOwner[0].Name;  
                
                res.salesRepId = srId;
                res.salesRepName = srName;
            }else{ 
                res.status = 'Failure';
                res.statusMsg = 'Validation Error: Opportunity Owner Not Found';
                
                return res;
            } 
            
            //    Billing Validation 
            if(oppty.Account.BillingPostalCode == null || oppty.Account.BillingStreet == null || oppty.Account.BillingCity == null) { 
                res.status = 'Failure';
                res.statusMsg = 'Validation Error: Address is Missing';
                
                return res;
            } 
            RequestWrapper reqWrapper = new RequestWrapper();
            reqWrapper.prod = getQuotes(oppty.Id);
            reqWrapper.opp = oppty;
            reqWrapper.newRenewal = newRenewal;
            reqWrapper.uwId = uwId;
            reqWrapper.uwName = uwName;
            reqWrapper.srId = srId;
            reqWrapper.srName = srName;
            reqWrapper.groups = [Select Id, Name, Comments__c From Group__c Where Account__c =: oppty.AccountId];
            
            //    Product(QuoteLineItems) validation
            if(reqWrapper.prod.isEmpty()) {
                res.status = 'Failure';
                res.statusMsg = 'Validation Error: No product with Funding Type of "FI - Fully Insured" and LOB as "Medical" found';
                
                return res;
            }
            
            //    Concatenates LOB values of the QuoteLineItems, which have ==> Funding = FI, Financing = Fully Insured
            //    This is displayed in the lightning component
            res.lob = '';
            for(QuoteLineItem qli : [Select Id, Product_type__c From QuoteLineItem Where Quote.OpportunityId =: oppty.Id AND Funding__c = 'FI' AND Financing__c = 'Fully Insured']) {
                if(qli.Product_type__c != null && !res.lob.contains(qli.Product_type__c + ','))//skips blank values and already added values
                    res.lob += qli.Product_type__c + ',';
            }
            res.lob = res.lob.removeEnd(',');
            
            //    Prepares request
            wellpointComServiceUtility.SubmitFIRSTQuoteRequest_element wpr = wellpointPrepareRequest.prepareRequest(reqWrapper);
            
            //    Prepares Header for the request
            wellpointComEsbContext.ContextType wcec = wellpointPrepareHeaderContext.prepareHeaderContextObject();
            
            //    Stores the response received from FIRST
            wellpointComServiceUtility.SubmitFIRSTQuoteResponse_element resEle;
            
            try{
                //    Sends request to FIRST
                resEle = wellpointSubmitFIRSTQuoteReqSrvCallOut.submitQuoteRequestToFIRST(wpr);
                String statusMsg = resEle.Status.StatusCode == 'Success' ? 'Success' : 'Failure';
                
                res.status = statusMsg;
                res.statusMsg = resEle.Status.StatusDesc;
                
                return res;
            }
            catch(Exception e){
                system.debug(e.getMessage());
                res.status = 'Failure';
                res.statusMsg = e.getMessage();
                
                return res;
            }
            
        }
        catch(Exception e){
            system.debug(e);
            res.status = 'Failure';
            res.statusMsg = e.getMessage();
            
            return res;
        }
        
    }
    
    //    Prepapres a query string with all the fields of the object queried. No changes are required even if new fields added to Opportunity. 
    //    This string query considers all fields of the object dynamically using describe calls
    public static String prepareQuery(String SobjectApiName, String recordId){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if(commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
        if(SobjectApiName == 'Opportunity')
            commaSepratedFields += ', RecordType.Name, Account.Name, Account.SIC__r.SIC_Code__c, Account.BillingPostalCode, Account.BillingStreet, Account.BillingState, Account.BillingCity ';
            
        String query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Id = \''+recordId+'\'';
        return query;
    }
}