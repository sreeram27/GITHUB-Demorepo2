@isTest
public class P2AUpdateQliTest {
    
    static QuoteLineItem createData()
    {
       Account acc=IntegrationTestDataUtilty.createAccount(true); 
       
        Opportunity oppty=IntegrationTestDataUtilty.createOpportunity(acc.id, true);
        
        Group__c grp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        
        Quote qte=IntegrationTestDataUtilty.createQuote(oppty.Id, grp.id, true);
        
        Product2 prod=IntegrationTestDataUtilty.createProduct(true);
        prod.Contract_Code__c = '40QA';
        Database.update(prod);
        
        PricebookEntry pbe=IntegrationTestDataUtilty.createPricebookEntry(prod.id, true);
        QuoteLineItem qlitest = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, true);
       
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prod.Id;
        qli.P2AModified__c = 'Yes';
        qli.vlocity_ins__ContractCode__c = '40QA';
        System.debug(qli);
        Database.insert(qli); 
        
        return qli;
    }
     @isTest 
     static void testUpdateNo(){
   
		QuoteLineItem qli = createData();

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
         
        request.requestUri =System.URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/P2AUpdateQLI/'+ qli.Id;
        //request.httpMethod = 'PATCH';
        request.httpMethod = 'GET';
        request.params.put('modifiedFlag', 'N');
        request.params.put('qliId', qli.Id);
        request.addHeader('Content-Type', 'application/json');
        //request.requestBody = Blob.valueOf('{"modifiedFlag": "N"}');
        RestContext.request = request;
        RestContext.response = response;
         
        Test.startTest(); 
        P2AUpdateQli.UpdateQLI();
        Test.stopTest(); 
        
        System.assert(qli.Id != null);
        QuoteLineItem QliUpdated = [SELECT Id,P2AModified__c FROM QuoteLineItem WHERE Id=:qli.Id];
        System.debug(qliUpdated.P2AModified__c);
        System.assert(qliUpdated != null);
       System.assertEquals('No', qliUpdated.P2AModified__c);
    }  
	@isTest 
     static void testUpdateYes(){
   
		QuoteLineItem qli = createData();

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
         
        request.requestUri =System.URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/P2AUpdateQLI/'+ qli.Id;
       // request.httpMethod = 'PATCH';
        request.httpMethod = 'GET';
        request.params.put('modifiedFlag', 'Y');
        request.params.put('qliId', qli.Id);
        request.addHeader('Content-Type', 'application/json');
      //  request.requestBody = Blob.valueOf('{"modifiedFlag": "N"}');
        RestContext.request = request;
        RestContext.response = response;
         
        Test.startTest(); 
        P2AUpdateQli.UpdateQLI();
        Test.stopTest(); 
        
        System.assert(qli.Id != null);
        QuoteLineItem QliUpdated = [SELECT Id,P2AModified__c FROM QuoteLineItem WHERE Id=:qli.Id];
        System.debug(qliUpdated.P2AModified__c);
        System.assert(qliUpdated != null);
        System.assertEquals('Yes', qliUpdated.P2AModified__c);
    }  
		@isTest 
     static void testUpdateError(){
   
		QuoteLineItem qli = createData();

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
         
        request.requestUri =System.URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/P2AUpdateQLI/'+ qli.Id+'?modifiedFlag=N';
        //request.httpMethod = 'PATCH';
         request.httpMethod = 'GET';
        //request.params.put('modifiedFlag', 'Y');
        //request.params.put('qliId', qliId);
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestContext.response = response;
         
        Test.startTest(); 
        P2AUpdateQli.UpdateQLI();
        Test.stopTest(); 
        
        System.assert(qli.Id != null);
        QuoteLineItem QliUpdated = [SELECT Id,P2AModified__c FROM QuoteLineItem WHERE Id=:qli.Id];
        System.debug(qliUpdated.P2AModified__c);
        System.assert(qliUpdated != null);
       
    }  

}