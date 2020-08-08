/*
 * Class Name: AnthemAPI
 * Current Version: 1.0
 * Created Date: October 2019
 * Author: Archima
 * Description: This class has code for sending an LG Application platform event to the event API.
 */
public with sharing class AnthemAPI {

    @future(callout=true)
    public static void postEvent(String lgApplicationJson) {
        LG_Application__e lgApplication = (LG_Application__e) JSON.deserialize(lgApplicationJson, LG_Application__e.class);

        EventRequest eventRequest = new EventRequest();
        eventRequest.eventName = lgApplication.Event_Name__c;
        eventRequest.eventCorrelation = new EventCorrelation();
        eventRequest.eventCorrelation.correlationId = lgApplication.Application_ID__c;
        eventRequest.eventCorrelation.vendorAppId = lgApplication.Application_ID__c;
        eventRequest.eventData = new EventData();
        eventRequest.eventData.lineOfBusiness = lgApplication.Line_of_Business__c;
        eventRequest.eventData.agentTins = new List<AgentTin>();
        eventRequest.eventData.agentTins.add(new AgentTin());
        eventRequest.eventData.agentTins[0].payeeTin = lgApplication.Payee_TIN__c;
        eventRequest.eventData.agentTins[0].writingTin = lgApplication.Writing_TIN__c;
        eventRequest.eventData.state = lgApplication.State__c;
        eventRequest.eventData.summary = lgApplication.Application_Status__c;
        eventRequest.timeStamp = APIApplication.formatDate(lgApplication.Application_Status_Modified__c, 'MM-dd-yyyy');

        postEvent(eventRequest);
    }
    
    public static void postEvent(EventRequest eventRequest) {
        LGJira2TokenDetail tokenDetail = new LGJiraUtility().AccessToken();

        Anthem_API_Settings__c anthemAPISettings = Anthem_API_Settings__c.getOrgDefaults();

        String endpoint = anthemAPISettings.Event_Endpoint__c;
        String authorization = 'Bearer ' + tokenDetail.access_token;
        String apiKey = (new LGJiraUtility()).apiKey;
        String body = JSON.serialize(eventRequest);

        System.debug('### ENDPOINT=' + endpoint);
        System.debug('### REQUEST=' + body);

        HttpRequest httpRequest = new HttpRequest();
		httpRequest.setTimeout(60 * 1000);
		httpRequest.setEndpoint(endpoint);
		httpRequest.setMethod('POST');
		httpRequest.setHeader('Accept', '*/*');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Authorization', authorization);
        httpRequest.setHeader('apikey', apiKey);
		httpRequest.setBody(body);

        HttpResponse httpResponse = new Http().send(httpRequest);

        System.debug('### STATUS CODE=' + httpResponse.getStatusCode());
        System.debug('### RESPONSE=' + httpResponse.getBody());

        if (httpResponse.getStatusCode() != 200) {
            EventErrorResponse eventErrorResponse = (EventErrorResponse) JSON.deserialize(httpResponse.getBody(), AnthemAPI.EventErrorResponse.class);
        }
    }


    public class EventRequest {

        public EventCorrelation eventCorrelation {get; set;}
        public EventData eventData {get; set;}
        public String eventName {get; set;}
        public String timeStamp {get; set;}

    }

    public class EventData {

        public List<AgentTin> agentTins {get; set;}
        public String lineOfBusiness {get; set;}
        public String state {get; set;}
        public String summary {get; set;}

    }
    
    public class AgentTin {

        public String parentTin {get; set;}
        public String payeeTin {get; set;}
        public String writingTin {get; set;}

    }

    public class EventCorrelation {

        public String correlationId {get; set;}
        public String vendorAppId {get; set;}

    }

    public class EventErrorResponse {

        public List<EventExcepton> exceptions {get; set;}

    }
    
    // NOTE: This class is purposefully misspelled with a missing "i"
    // because Apex doesn't allow classes with "Exception" in the name
    // that aren't extending the system Exception class.

    public class EventExcepton {

        public String type {get; set;}
        public String code {get; set;}
        public String message {get; set;}
        public String detail {get; set;}

    }

}