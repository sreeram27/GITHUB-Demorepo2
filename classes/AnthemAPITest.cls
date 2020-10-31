/*
 * Class Name: AnthemAPITest
 * Current Version: 1.0
 * Created Date: October 2019
 * Author: Archima
 * Description: This class has the unit tests for the AnthemAPI class.
 */
@isTest
private class AnthemAPITest {

    @isTest
    static void testPostEvent() {
        Anthem_API_Settings__c anthemAPISettings = Anthem_API_Settings__c.getOrgDefaults();
        anthemAPISettings.Event_Endpoint__c = 'https://test.com';
        upsert anthemAPISettings;

        LG_Application__e lgApplication = new LG_Application__e();
        lgApplication.Event_Name__c = 'APPLICATION_UPDATED';
        lgApplication.Application_ID__c = '123';
        lgApplication.Line_of_Business__c = 'LG';
        lgApplication.Payee_TIN__c = 'ABC';
        lgApplication.Writing_TIN__c = 'DEF';
        lgApplication.State__c = 'VA';
        lgApplication.Application_Status_Modified__c = Date.today();

        HttpResponse httpResponseToken = new HttpResponse();
        httpResponseToken.setBody(LGJiraUtilityMockTest.jiraSuccessResponse);
        httpResponseToken.setStatusCode(200);

        HttpResponse httpResponseEvent = new HttpResponse();
        httpResponseEvent.setStatusCode(200);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AnthemAPICalloutMock(new List<HttpResponse>{httpResponseToken, httpResponseEvent}));

        try {
            AnthemAPI.postEvent(JSON.serialize(lgApplication));
        } catch (Exception e) {
            System.assert(false, 'Exception should not have been thrown.');
        }
        
        Test.stopTest();
    }

    public class AnthemAPICalloutMock implements HttpCalloutMock {

        private List<HttpResponse> httpResponses = new List<HttpResponse>();
        private Integer httpResponseIndex = 0;


        public AnthemAPICalloutMock(List<HttpResponse> httpResponses) {
            this.httpResponses = httpResponses;
        }

        public HTTPResponse respond(HTTPRequest request) {
			return httpResponses[httpResponseIndex++];
		}

    }
    
}