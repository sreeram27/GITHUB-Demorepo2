//***************************************************//
// Created By : Suresh Parishwad
// Reason : To cover CDHP Button Functionality
// CDHPHttpCalloutMock to cover CDHP functionality
// *************************************************//

@isTest
global class CDHPHttpCalloutMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        
        HttpResponse response = new HttpResponse();
        //response.setHeader('Content-Type', 'application/json');
        //response.setBody('{"StatusDetails":{"Status":"SUCCESS","cdhpQuoteIDS":{"0Q02F000000BPhCSAW":"a8N2a0000004fTEEAY"}},"quoteProdHRA":{}}');
        //response.setStatusCode(200);
        String jsonStr = getStr();
            jsonStr = ' '+jsonStr+' ';
            response.setBody(jsonStr);
            response.setStatusCode(200);
        return response; 
    }
    global String getStr(){
        CDHPISGRestAPIClient.CDHPFields cdhpISg = new CDHPISGRestAPIClient.CDHPFields();
        
        
        Map<String,CDHPISGRestAPIClient.CDHPFields> cdhpIsgMap = new Map<String,CDHPISGRestAPIClient.CDHPFields>();
        CDHPISGRestAPIClient.CDHPFields cdhpFields = new CDHPISGRestAPIClient.CDHPFields();
        CDHPISGRestAPIClient.UserDetails UserDetails = new CDHPISGRestAPIClient.UserDetails();
        UserDetails.UserRole = 'System Administrator';
        UserDetails.eMail = 'test@test.com';
        UserDetails.UserRole = 'test';
        UserDetails.UserRole = 'test';
        
        cdhpFields.UserDetails = UserDetails;
        cdhpFields.ORGName = 'COM2';
        
        CDHPISGRestAPIClient.GroupDetails grpDetails = new CDHPISGRestAPIClient.GroupDetails();
        grpDetails.SFAccountId = testDataFactoryCDHP.lstAcc[0].Id;
        grpDetails.NumberOfEligibleEmpl = 1200.00;
        grpDetails.EmployerName = 'Test_Account_01a';
        grpDetails.Brand = 'Anthem BCBS';
        
        cdhpFields.GroupDetails = grpDetails;
        
        CDHPISGRestAPIClient.OpportunityDetails opp = new CDHPISGRestAPIClient.OpportunityDetails();
        opp.OpportunityOwner = 'test';
        opp.SFORGOpportunityId = testDataFactoryCDHP.lstOpp[0].Id;
        opp.OptyRecordType = 'In Group Add Product';
        opp.OptyName = '2019 Opportunity In Group Add Product-Test_Account_01a';
        opp.OptyEffectiveDate = Date.valueOf('2019-01-01');
        cdhpFields.OpportunityDetails = opp;
        
        CDHPISGRestAPIClient.ProductDetails prodDtls = new  CDHPISGRestAPIClient.ProductDetails();
        List<CDHPISGRestAPIClient.ProductDetails> lstProd = new List<CDHPISGRestAPIClient.ProductDetails>();
        prodDtls.Estimated_Number_of_Participants = '22';
        prodDtls.Funding = 'ASO';
        prodDtls.HRA_Account_Type = true;
        prodDtls.HRA_Plan_Start_Date = Date.valueOf('2019-04-30');
        prodDtls.Estimated_Number_of_Participants = '22';
        prodDtls.Parking_Plan_Option = false;
        prodDtls.ProdName = 'Medical - Act Wise CD';
        prodDtls.QuoteId = testDataFactoryCDHP.lstQuote[0].Id;
        prodDtls.SFORGQuoteLineId = testDataFactoryCDHP.lstQLItem[0].Id;
        prodDtls.Transit_Plan_Option = false;
        lstProd.add(prodDtls);
        
        cdhpFields.ProductDetails = lstProd;
        
        
        CDHPISGRestAPIClient.HRAProductDetails hraProd = new  CDHPISGRestAPIClient.HRAProductDetails();
        List<CDHPISGRestAPIClient.HRAProductDetails> lstHRAProd = new List<CDHPISGRestAPIClient.HRAProductDetails>();
        hraProd.HRA1_Group_Suffix = 'HRA01';
        //hraProd.Funding = '2 Tier';
        hraProd.HRA_Annual_Alloc_Amt_Employee = 500.00;
        hraProd.HRA_Annual_Alloc_Amt_Emp_Adult = 500.00;
        hraProd.HRA_Annual_Alloc_Amt_Emp_Child = 500.00;
        hraProd.HRA_Annual_Alloc_Amt_Emp_Children = 500.00;
        hraProd.HRA_Annual_Alloc_Amt_Family = 500.00;
        hraProd.HRA_Claim_Run_Out_Date = Date.valueOf('2019-05-10');
        hraProd.HRA_Funding_Pro_Rate = 'Not Pro-Rated/Incentive Only HRA';
        hraProd.HRA_Fund_Allocation = 'No, Annually';
        
        hraProd.HRA_Health_Activities = '2 Tier';
        hraProd.HRA_Member_Responsibility_by_Claim = '25';
        hraProd.HRA_Plan_End_Date = Date.valueOf('2019-05-01');
        hraProd.HRA_Rollover_Date_recommend_3_months = Date.valueOf('2019-07-29');
        hraProd.HRA_Rollover_Offer = 'No';
        hraProd.HRA_Termed_Emp_Claims_Run_out_Deadline = '90 Days (Standard)';
        hraProd.HRA_Unused_rollovrfund_diff_Adm_last_yr = 'No';
        hraProd.HRA_Upfront_Deductible_Tier_Selection = '2 Tier';
        lstHRAProd.add(hraProd);
        
        CDHPISGRestAPIClient.StatusDetails stat = new CDHPISGRestAPIClient.StatusDetails();
        stat.Status = 'SUCCESS';
        stat.StatusMessage = 'SUCCESS';
        stat.CDHPParentId = 'a8N0v000000Cb4dEAC';
        Map<String,String> mapCDHP = new Map<String,String>();
        mapCDHP.put(testDataFactoryCDHP.lstQuote[0].Id,'a8N0v000000Cb4dEAC');
        stat.cdhpQuoteIDS = mapCDHP;
        
        cdhpFields.StatusDetails = stat;
        cdhpISg.StatusDetails = stat;

        cdhpFields.HRAProductDetails = lstHRAProd;
        
        cdhpIsgMap.put(testDataFactoryCDHP.lstQuote[0].Id,cdhpFields);
        cdhpISg.quoteProdHRA = cdhpIsgMap;
        return System.JSON.serialize(cdhpISg, true);
        
    }
}