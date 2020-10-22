@RestResource(urlMapping = '/CMStatusUpdateService/*')
global class CMStatusUpdateService {
    
    @HttpPost
    global static void updateResponseFromCM(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try{
            String cmResponseJson = req.requestBody.toString();
            CMStatusUpdateServiceHelper.CMUpdateStatusDetails  statusDetails = CMStatusUpdateServiceHelper.updateResponse(cmResponseJson);
            
            if(statusDetails.status == 'SUCCESS'){      
                res.statusCode = 200;
                res.responseBody = Blob.valueOf(statusDetails.statusMessage);
            }
            else{
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(statusDetails.statusMessage);  
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ex.getMessage());
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Exception occured: '+ex.getMessage());
        }
    }
}