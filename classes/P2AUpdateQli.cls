@RestResource(urlMapping = '/P2AUpdateQLI/*')

global class P2AUpdateQli {
    
    @HttpGet
    global static void updateQLI() {
        RestRequest req = RestContext.request;
        RestResponse res = new RestResponse();
        res = RestContext.response;
        String retMessage = '';
        
        try {
            String qliId=req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            //Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestbody.tostring());
            //String p1 = req.params
            String p1 = req.params.get('modifiedFlag');
            
            QuoteLineItem qli = [select Id, P2AModified__c from QuoteLineItem where Id= :qliId];
            if(p1 == 'Y'){
                qli.P2AModified__c = 'Yes';
            }
            else if(p1 == 'N'){
                qli.P2AModified__c = 'No';
            }
            update qli;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('QLI status Updated successfully : '+p1 +' QLI id: '+ qliId);
            retMessage = 'QLI status Updated successfully : '+p1 +' QLI id: '+ qliId;
        }
        Catch(Exception ex) {
            System.debug('Exception :'+ex.getMessage());
            System.debug('Exception :'+ex.getStackTraceString());
            res.statusCode = 500; 
            res.responseBody = Blob.valueOf('Error:'+ex.getMessage());
            retMessage = 'Error:'+ex.getMessage();
        }
        //return retMessage;
        //return 'Test Return message from service';
    }
    
}