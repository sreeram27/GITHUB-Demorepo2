@isTest
global class Test_CLS_CalloutForGoogleAnalyticsData {
    
    global class Test_MockHttpResponseGenerator1 implements HTTPCalloutMock {
    	
        global HttpResponse Respond(HttpRequest req1){
            
            HttpResponse res = new HttpResponse();
            
            if(req1.getEndpoint().endsWith('token')){
                
        		res.setHeader('Content-Type', 'application/json');
        		res.setBody('{"access_token":"ya29.c.Ko4BwwfFLf7DMeffhmxRxdsQkWejKnoJxUijmA2n0Jj6themjZN2q0g1QnzaLSXVArWsl5WGBef68f6KZcTSASp_VHFeMepwbS3_-qLNmJHJPSjo7ZwCWo1fr9Hsv04_BsY_WyQwsjUf-xCuuC2xt0-hjRedBEnMmiHAPRHXd3aqjSCi4SbwDCJYmAwbxxJkjA","expires_in":3599,"token_type":"Bearer"}');
        		res.setStatusCode(200);
            } else if(req1.getEndpoint().contains('https://www.googleapis.com/analytics/v3/data')){
                
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"totalsForAllResults": {"ga:users": "1043","ga:newUsers": "816","ga:sessions": "1207","ga:bounceRate": "19.96685998342999","ga:avgsessionDuration": "93.18558409279204"},"rows":[["(none)","442","367","489","8.793456032719837","111.77096114519428"],["cpc","442","367","489","8.793456032719837","111.77096114519428"],["organic","442","367","489","8.793456032719837","111.77096114519428"],["referral","442","367","489","8.793456032719837","111.77096114519428"]]}');
                res.setStatusCode(200);
            }
            return res;
        	
    }
}
    
    
    
    
    @isTest
    public static void Test_ScheduleCalloutMethod(){
        
        Test.setMock(HttpCalloutMock.class, new Test_MockHttpResponseGenerator1());
        
        CLS_CalloutForGoogleAnalyticsData.get_access_token();
        
      }
    
   
}