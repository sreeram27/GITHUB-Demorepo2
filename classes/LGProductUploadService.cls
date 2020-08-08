/**
* Rest service to create Product,plans and attributes. This service will be invoked by external
* system
* */

@RestResource(urlMapping = '/LGProductUploadService/*')

global class LGProductUploadService {
    
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        try {
            
            
            String pmtJSONStr = RestContext.request.requestBody.toString();
            LGProductUploadServiceHelper prodloadHelper = new LGProductUploadServiceHelper();
           LGProductUploadServiceHelper.StatusDetails statusDetails=  prodloadHelper.loadProductData(pmtJSONStr);
            StatusDetails retStatus = new StatusDetails();
            if(statusDetails.statusCode == 0) {
            	retStatus.statusCode = 200;
                retStatus.statusMessage = statusDetails.statusMessage ;
            } else {
                retStatus.statusCode = 400; retStatus.statusMessage = statusDetails.statusMessage ;
            }
            //retStatus.statusMessage = 'Request processed successfully';
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(retStatus));
            res.addHeader('Content-Type', 'application/json');
        }
        Catch(Exception ex) {
            System.debug('Exception :'+ex.getMessage());
            System.debug('Exception :'+ex.getStackTraceString());
            res.statusCode = 200; StatusDetails retStatus = new StatusDetails();
            retStatus.statusCode = 500;retStatus.statusMessage = ex.getMessage(); res.responseBody = Blob.valueOf(JSON.serialize(retStatus));
            //res.responseBody = Blob.valueOf(String.valueOf(ex) + '\n\n' + ex.getStackTraceString());
        }
    }
    
    public class StatusDetails{
        public Integer statusCode{ get; set; }
        public String statusMessage { get; set; } 
        
    } 
    
}