@isTest
global class CastLightHttpResponseSuccessMockTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        //res.setBody('{"Accounts": [{"RenewalDate":null,"ParentAccountName":"test2","Opportunities":[{"OppStage":"Initiated","OpportunityProducts":[{"ProductName":"Castlight - Buy Up Products","ProdSubscribers":"12","ProdStage":"In Progress","ProdReason":"Funding Type Change","ProdProbability":"15%","ProdMembers":"10","ProdLOB":"Medical","CompetitorName":null}],"OpportunityID":"0065B00000AKc8yQAD","OppEffectiveDate":"2018-07-17","OppDescription":null,"CSLT_StageName":"test","CSLT_OpportunityID":"0065B00000AKc8yQAD","CSLT_CloseDate":null}],"Member":"","DUNSNUmber":null,"DirectorofSalesAM_Phone":null,"DirectorofSalesAM_Email":null,"DirectorofSalesAM":null,"CSLT_Open_Enrollment_Type":"Active","CSLT_Open_Enrollment_Start_Date":"2018-01-01","CSLT_Open_Enrollment_End_Date":null,"CSLT_AccountOwnerName":null,"CSLT_AccountOwnerEmail":null,"ConsultantFirm":null,"BillingStreet":null,"BillingState":null,"BillingPostalCode":null,"BillingCountry":null,"BillingCity":null,"AnthemORGID":"Com2","AcctExecPhone":null,"AcctExecEmail":null,"AcctExec":null,"AccountWebSite":null,"AccountType":"Local/Large Group","AccountRegion":"West","AccountName":"test1","AccountID":"0015B00000TM0tGQAT"}]}');
        res.setBody('{"statusmessage":"All Data Processed","statuscode":"200"}');
        res.setStatusCode(200);
        return res;
    }
}