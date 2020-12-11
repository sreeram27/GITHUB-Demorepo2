//Lifted and shifted from COM1 - XMen
@isTest
global class MockBingTravelResponse implements HttpCalloutMock {
     private String body = '{"destination_addresses" : [ "Praha, Česká republika" ],"origin_addresses" : [ "Brno, Česká republika" ],"rows" : [{"elements" : [{"distance" : {"text" : "127 mil","value" : 204285},"duration" : {"text" : "2 hod, 4 min","value" : 7424},"status" : "OK"}]}],"status" : "OK"}';
    private HttpRequest respondArgument;
    private List<TravelResponseService.Point> origins = new List<TravelResponseService.Point>();
    private List<TravelResponseService.Point> destinations = new List<TravelResponseService.Point>();
    
    global HttpResponse respond(HttpRequest req) {
       // System.assertEquals('http://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?key=' + API_Keys__c.getOrgDefaults().Bing_API_Key__c, req.getEndpoint());
       //System.assertEquals('POST', req.getMethod());
        this.respondArgument = req;
    
        // create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        body = generateMockBody();
        res.setBody(body);
        res.setStatusCode(200);

        return res;
    }

    public String generateMockBody() {
        origins.add(new TravelResponseService.Point(00.000000, 11.000000));

        for(Integer i = 1; i <= 3; i++) {
            destinations.add(new TravelResponseService.Point(21.000000 * i, -87.000000));
        }

        TravelResponseService.BingTravelDistanceRequestBody testBody = new TravelResponseService.BingTravelDistanceRequestBody(origins, destinations);
        return JSON.serialize(testBody);
    }

    public HttpRequest getRespondArgument() {
        return respondArgument;
    }

    public TravelResponse generateMockResponse() {
        return new TravelResponse();
    }
}