@isTest
global class test_Schedule_ZohoCalloutForTickets{
    public static  boolean bool = false;
    global class Test_MockHttpResponseGenerator1_zoho implements HTTPCalloutMock{
        global HttpResponse Respond(HttpRequest req1){
            HttpResponse res = new HttpResponse();
            system.debug(req1.getEndpoint());
            if(req1.getEndpoint().endsWith('token')){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"access_token":"1000.c514fd2c92d4cb38a35c559edb9adbf8.430c052a5c2b5c522d2fc23cc082149a","expires_in":3599,"token_type":"Bearer"}');
                res.setStatusCode(200);
             }
            else{
                if(bool==false){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"data":[{"id": "241415000032312687","ticketNumber": "24708","email": "baddigam@wharton.upenn.edu","subject": "Experience Bundle Changes Is not being deployed using CI JOB","status": "Review Pending","createdTime": "2020-04-14T13:37:21.000Z","modifiedTime": "2020-04-21T07:23:11.000Z","category": "AutoRABIT Issue","priority": "Medium","channel": "Web","classification": "CI Jobs","dueDate": "2020-04-28T17:30:00.000Z","responseDueDate": null,"closedTime": null,"assigneeId": "241415000000247013","cf": {"cf_ar_version": "20.1","cf_escalation_type": null},"department": {"id": "241415000000006907","name": "AutoRABIT"},"contact": {"firstName": "Akhilesh","lastName": "Reddy Baddigam","email": "baddigam@wharton.upenn.edu","phone": null,"type": null,"account": {"accountName": "wharton.upenn.edu"},"id": "241415000027237600"},"assignee": {"id": "241415000000247013","email": "eswar.n@autorabit.com","firstName": "Eswar Narayana","lastName": "Reddy"},"customerResponseTime": "2020-04-20T12:02:56.000Z"}]}');
                res.setStatusCode(200);
                bool=true;
            }
            }
            return res;
        }
    }
    
    
    
    @isTest
    public static void Test_ScheduleCalloutMethod(){
        
        Test.setMock(HttpCalloutMock.class, new Test_MockHttpResponseGenerator1_zoho());
        
        Schedule_ZohoCalloutForTickets.getAccesstokenFromZoho();
        
      }
    
    @isTest
    public static void Test_ScheduleCalloutMethod1(){
        
        Test.setMock(HttpCalloutMock.class, new Test_MockHttpResponseGenerator1_zoho());
        
        Schedule_ZohoCalloutForTickets.getZohoDataAndInsert('1000.c514fd2c92d4cb38a35c559edb9adbf8.430c052a5c2b5c522d2fc23cc082149a');
        
      }
    
    

}