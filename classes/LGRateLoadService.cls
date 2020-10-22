/**
* This service is to update the rates at QLI level
* */
@RestResource(urlMapping = '/LGRateLoadService/*')
global class LGRateLoadService {
    
    
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        try {
            String pmtJSONStr = RestContext.request.requestBody.toString();
            
           //String pmtJSONStr = sampleReqForRates();
            system.debug('pmtJSONStr--------->' + pmtJSONStr);
            LGRateLoadServiceHelper ratesHelper = new LGRateLoadServiceHelper();
            LGRateRequest serviceReq= (LGRateRequest)JSON.deserialize(pmtJSONStr, LGRateRequest.class);
            LGRateLoadServiceHelper.StatusDetails statusDetails = ratesHelper.updateRates(serviceReq);
            System.debug('statusDetails**:' + statusDetails);
            StatusDetails serviceStatus = new StatusDetails();
            if(statusDetails.statusCode == 0) {
                serviceStatus.statusCode = 200;
                serviceStatus.statusMessage = statusDetails.statusMessage ;
            } else {
                serviceStatus.statusCode = 400; serviceStatus.statusMessage = statusDetails.statusMessage ;
            }
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(serviceStatus));
            res.addHeader('Content-Type', 'application/json');
        }
        Catch(Exception ex) {
            System.debug('Exception :'+ex.getMessage());
            System.debug('Exception :'+ex.getStackTraceString());
            
        }
    }
    
    public class StatusDetails{
        public Integer statusCode{ get; set; }
        public String statusMessage { get; set; } 
        
    } 
  /*  public static String sampleReq(){
   
         String json=			'{'+
		'  "groupName": "Rosetta CO",'+
		'  "requestedBy": "SFDC_User_Name",'+
		'  "effectiveDate": "2019-01-01",'+
		'  "environment": "DEV",'+
		'  "sfOpportunityId": "00654000007DZzC",'+
		'  "sourceSystem": "ABACUS",'+
		'  "customerMasterKey": "E&B Customer Master Id",'+
		'  "caseNumber": "123456",'+
		'  "sourceRecordId": "SourceRecordIdentifier",'+
		'  "sfOpportunityType": "New Business",'+
		'  "rateInfo": ['+
		'    {'+
		'      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
		'      "rateIdentifier": "RATE_ID_1",'+
		'      "contractCode": "99Y2",'+
		'      "classCode": "Hourly",'+
		'      "employmentCategoryCode": "ACTSB",'+
		'      "productCategory": "MEDICAL",'+
		'      "productName": "Blue Advantage HMO",'+
		'      "commissionLevel": "10",'+
		'      "commissionType": "PSPM",'+
		'      "single": 703.2,'+
		'      "twoParty": 1547.04,'+
		'      "eeChild": 1265.76,'+
		'      "family": 2179.92,'+
		'      "eeChildren": 1265.76,'+
		'      "medicareElgSpouseL65": 703.2,'+
		'      "medicareElgSpouseChildL65": 1476.72,'+
		'      "embeddedVision": 1.6'+
		'    }'+
		'  ]'+
		'}';	
        return json;
        
    }
    
    public static String sampleReqForRates(){
        String json='{'+
		'  "groupName": "Rosetta CO",'+
		'  "requestedBy": "SFDC_User_Name",'+
		'  "effectiveDate": "2019-01-01",'+
		'  "environment": "DEV",'+
		'  "sfOpportunityId": "00654000007DZzC",'+
		'  "sourceSystem": "ABACUS",'+
		'  "customerMasterKey": "E&B Customer Master Id",'+
		'  "caseNumber": "123456",'+
		'  "sourceRecordId": "SourceRecordIdentifier",'+
		'  "sfOpportunityType": "New Business",'+
		'  "fileName": "MEDICAL_FINALRATES.XLSX",'+
		'  "fileVersion": "1", '+
		' "rateInfo": ['+
		'    {'+
		'      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
		'      "rateIdentifier": "RATE_ID_1",'+
		'      "contractCode": "3V1K",'+
		'      "classCode": "Hourly",'+
		'      "employmentCategoryCode": "ACTSB",'+
		'      "productCategory": "MEDICAL",'+
		'      "productName": "Blue Advantage HMO",'+
		'      "commissionLevel": "10",'+
		'      "commissionType": "PSPM",'+
		'      "single": 703.2,'+
		'      "twoParty": 1547.04,'+
		'      "eeChild": 1265.76,'+
		'      "family": 2179.92,'+
		'      "eeChildren": 1265.76,'+
		'      "medicareElgSpouseL65": 703.2,'+
		'      "medicareElgSpouseChildL65": 1476.72,'+
		'      "embeddedVision": 1.6'+
		'    },'+
		'    {'+
		'      "sfdcQuoteLineItemId": "18CHARALPHANUMERIC",'+
		'      "rateIdentifier": "RATE_ID_2",'+
		'      "contractCode": "3V1K",'+
		'      "classCode": "Hourly",'+
		'      "employmentCategoryCode": "ACTSB",'+
		'      "productCategory": "MEDICAL",'+
		'      "productName": "Blue Advantage HMO",'+
		'      "commissionLevel": "10",'+
		'      "commissionType": "PSPM",'+
		'      "single": 703.2,'+
		'      "twoParty": 1547.04,'+
		'      "eeChild": 1265.76,'+
		'      "family": 2179.92,'+
		'      "eeChildren": 1265.76,'+
		'      "medicareElgSpouseL65": 703.2,'+
		'      "medicareElgSpouseChildL65": 1476.72,'+
		'      "embeddedVision": 1.6'+
		'    }'+
		'  ]'+
		'}';
        return json;
        
    }*/
}