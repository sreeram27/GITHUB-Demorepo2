/**
* MockTravelResponse is used for testing TravelResponseService.
*
* @author Nikita Belov
* @company Bluewolf, an IBM Company
* @date 7/2016
* Lifted and shifted from COM1 - XMen
*/
@isTest
global class MockTravelResponse implements HttpCalloutMock {
     private String body = '{"destination_addresses" : [ "Praha, Česká republika" ],"origin_addresses" : [ "Brno, Česká republika" ],"rows" : [{"elements" : [{"distance" : {"text" : "127 mil","value" : 204285},"duration" : {"text" : "2 hod, 4 min","value" : 7424},"status" : "OK"}]}],"status" : "OK"}';
    private Exception exc;
    private HttpRequest respondArgument;
    
    public MockTravelResponse withException(Exception exc) {
        this.exc = exc;
        return this;
    } 
    
    public MockTravelResponse withBody(String body) {
        this.body = body;
        return this;
    }
    
    global HttpResponse respond(HttpRequest req) {
        this.respondArgument = req;
        
        if (exc != null) {
            throw exc;
        }
        
        // create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(body);
        return res;
    }
    
    public HttpRequest getRespondArgument() {
        return respondArgument;
    }
}