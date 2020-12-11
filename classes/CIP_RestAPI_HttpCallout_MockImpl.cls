/*
@Author : Arun Siddappa
@name : CIP_RestAPI_HttpCallout_MockImpl 
@CreateDate :07-20-2017
@Description : This class is to mock up REST API Calls. There are two calls being made, one is to get the session and another one is to push the quote data over to old org 
*/
@isTest
    global class    CIP_RestAPI_HttpCallout_MockImpl implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {        
            HttpResponse res = new HttpResponse();
            if(req.getEndpoint().contains('CIPFromSales')){        
            String jsonStr = getJsonStr();
            jsonStr = ' '+jsonStr+'}';
            res.setBody(jsonStr);
            res.setStatusCode(200);
        }
        else if(req.getEndpoint().equals('http://session')){        
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{  "id": "SESSION_ID",  "issued_at": "1473300402605",  "instance_url": "http://sf.com",  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciO",  "signature": "SF_SIGNATURE"}');
            res.setStatusCode(200);
        }
        return res;
    }
    global String getJsonStr(){
        CIP_RestAPI_Client_Handler.CIPFields cipFlds = new CIP_RestAPI_Client_Handler.CIPFields();
        cipFlds.name='RET_VALUE';
        cipFlds.recType='RET_VALUE';
        cipFlds.topic='RET_VALUE';
        cipFlds.Status='RET_VALUE';
        cipFlds.ErrorCode='RET_VALUE';
        cipFlds.Message='RET_VALUE';
        cipFlds.CIPId='RET_VALUE';
        cipFlds.fileContent='RET_VALUE';
        cipFlds.fileName='RET_VALUE';
        cipFlds.ParentId='RET_VALUE';
        cipFlds.AccountName='RET_VALUE';
        cipFlds.AccountNumber='RET_VALUE';
        cipFlds.SIC='RET_VALUE';
        cipFlds.Total_Employees='RET_VALUE';
        cipFlds.Total_Eligibles='RET_VALUE';
        cipFlds.HQ_State='RET_VALUE';
        cipFlds.Original_Effective_Date='RET_VALUE';
        cipFlds.RecordType='RET_VALUE';
        cipFlds.AnthemEntity='RET_VALUE';
        cipFlds.Group_Size='RET_VALUE';
        cipFlds.Region='RET_VALUE';
        cipFlds.Branding='RET_VALUE';
        cipFlds.Duns_Number='RET_VALUE';
        cipFlds.Segment ='RET_VALUE';
        cipFlds.Website='RET_VALUE';
        cipFlds.BillingAddress='RET_VALUE';
        cipFlds.ShippingAddress='RET_VALUE';           
        cipFlds.GroupNumber='GRP_NUM_SUCCESS';
        cipFlds.GroupNumberSFDCId='RET_VALUE';
        cipFlds.OpportunityId='RET_VALUE';     
        cipFlds.OpportunityEffectiveDate='RET_VALUE';                 
        cipFlds.OpportunityName='RET_VALUE';  
        cipFlds.OpportunityReceivedDt='RET_VALUE';  
        cipFlds.OpportunityType='RET_VALUE';  
        cipFlds.BillingStreet='RET_VALUE';
        cipFlds.BillingCity='RET_VALUE';
        cipFlds.BillingState='RET_VALUE';
        cipFlds.BillingPostalCode='RET_VALUE';    
        cipFlds.BillingCountry='RET_VALUE';    
        cipFlds.ShippingStreet='RET_VALUE';
        cipFlds.ShippingCity='RET_VALUE';
        cipFlds.ShippingState='RET_VALUE';
        cipFlds.ShippingPostalCode='RET_VALUE';    
        cipFlds.ShippingCountry='RET_VALUE';    
        cipFlds.DivisionName='RET_VALUE';
        cipFlds.UseDivisionNameAsGroupName=true;
        cipFlds.ClaimSystem='RET_VALUE';    
        cipFlds.MemberCount='RET_VALUE'; 
        return System.JSON.serialize(cipFlds, true);   
    }
    
}