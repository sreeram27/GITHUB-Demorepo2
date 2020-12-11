@isTest
public class MultiRequestMock implements HttpCalloutMock {
	Map<String, HttpCalloutMock> requests;

	public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
		this.requests = requests;
	}
	public MultiRequestMock(){
		this.requests = new Map<String,HttpCalloutMock>();
	}

	public HTTPResponse respond(HTTPRequest req) {
		HttpCalloutMock mock = requests.get(req.getEndpoint());
		if(mock == null){
			//try without parameters
			PageReference ref = new PageReference(req.getEndpoint());
			ref.getParameters().clear();
			mock = requests.get(ref.getUrl());
		}
		if(mock == null){
			for(String endpoint : requests.keySet()){
				if(req.getEndpoint().contains(endpoint)){
					mock = requests.get(endpoint);
				}
			}
		}
		if(mock == null){
			System.assert(false, 'MultiRequestMock Error: Unable to find Request with endpoint of ' 
				+ req.getEndpoint() + ' Make sure you have set up your mock data correctly');
		}
		return mock.respond(req);
	}

	public void addRequestMock(String url, HttpCalloutMock mock) {
		requests.put(url, mock);
	}
}