/**
* TravelResponseService is used to make a callout to Google API Distance for calculating a distance between two addresses.
* 
* @author Nikita Belov
* @company Bluewolf, an IBM Company
* @date 7/2016
*
*/

public with sharing class TravelResponseService {

    public static final String ERROR_MESSAGE_LABEL = 'A Server Error has occured: ';
    public static final String ERROR_SERVER_CONNECTION = 'A Communication Error has occured: ';
    public static final String SUCCESS_STATUS = 'OK';
    public static final String ERROR_MSG = 'Callout to Bing Location API returned with statusCode ';
    public static String BING_DISTANCE_ENDPOINT = 'http://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix';
    public static String GOOGLE_ENDPOINT = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    public static String BING_LOCATION_ENDPOINT = 'http://dev.virtualearth.net/REST/v1/Locations';

  // makes callout to Maps Distance API
  public static TravelResponse getResponse(String origins, String destinations) {
        String api=API_Keys__c.getOrgDefaults().Current_API__c;
        if('Google'.equalsIgnoreCase(api)){
            return new GoogleTravelRequest().sendRequest(origins,destinations);
        } else if('Bing'.equalsIgnoreCase(api)) {
            return new BingTravelRequest().sendRequest(origins,destinations);
        } else {
            return new BingTravelRequest().sendRequest(origins,destinations);
        }
    }

    public static TravelResponse sendRequest(List<Point> origins, List<Point> destinations) {
        return new BingTravelDistanceRequest().sendRequest(origins, destinations);
    }

    public static void sendLocationRequest(List<SFDC_Volunteer_Event__c> openEnrollments) {
        new BingTravelRequest().sendLocationRequest(openEnrollments);
    }

    @future(callout=true)
    public static void sendGetRequests(List<String> generatedUrls, String serializedOpenEnrollments){

        List<SFDC_Volunteer_Event__c> updatedMeetings = new List<SFDC_Volunteer_Event__c>();
        for(SFDC_Volunteer_Event__c meeting: (List<SFDC_Volunteer_Event__c>)System.JSON.deserialize(serializedOpenEnrollments, List<SFDC_Volunteer_Event__c>.class)){
            updatedMeetings.add(new SFDC_Volunteer_Event__c(Id = meeting.Id));
        }       

        List<LocationResponseParser> locationResponses = new List<LocationResponseParser>();

        String sResponse = '';

        for(String url : generatedUrls) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            HttpResponse res = new http().send(req);
            LocationResponseParser responseResult = LocationResponseParser.parse(res.getBody());
            locationResponses.add(responseResult);
        }

        List<SFDC_Volunteer_Event__c> meetingsToUpdateWithLocations = new List<SFDC_Volunteer_Event__c>();

        for(Integer i = 0; i < locationResponses.size(); i++) {
            System.debug('Location Response-->'+locationResponses[i]);
            if(locationResponses[i].authenticationResultCode != Null){

            updatedMeetings[i].Location__latitude__s = locationResponses[i].resourceSets[0].resources[0].geocodePoints[0].coordinates[0];
            updatedMeetings[i].Location__Longitude__s = locationResponses[i].resourceSets[0].resources[0].geocodePoints[0].coordinates[1];
            updatedMeetings[i].Error_Log__c = ' ';
            }
        }

        update updatedMeetings;

    }
    
    public abstract class TravelRequest {

        public string generateUrl(String url, Map<string,string> parameterMap) {
            // create valid URL
            PageReference myURL = new PageReference(url);
            for(String key: parameterMap.keySet()){         
                myURL.getParameters().put(key, parameterMap.get(key));
            }
            return myURL.getUrl();  
        }

        public List<String> generateUrls(String url, List<Map<String, String>> listOfParameterMaps) {

            List<PageReference> myURLs = new List<PageReference>();

            for(Map<String, String> parameterMap : listOfParameterMaps) {
                PageReference myURL = new PageReference(url);
                for(String key: parameterMap.keySet()){         
                    myURL.getParameters().put(key, parameterMap.get(key));
                }

                myURLs.add(myURL);
            }

            List<String> stringUrls = new List<String>();
            for(PageReference p : myURLs) {
                stringUrls.add(p.getUrl());
            }

            return stringUrls;
        }

        public abstract TravelResponse sendRequest(String origins, String destinations);
        
        public TravelResponse sendGetRequest(String url, Type dataType){
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');   
            HttpResponse res = new http().send(req);

            if(String.isNotBlank(res.getBody()) && res.getStatusCode() < 300){
                TravelResponse result = (TravelResponse) System.JSON.deserialize(res.getBody(), dataType);

                if(String.isBlank(result.getError()) ){
                    return result;
                }else{
                    throw new TravelResponseException(ERROR_MESSAGE_LABEL + result.getError());  
                }

            } else {
                throw new TravelResponseException(ERROR_SERVER_CONNECTION + res.getStatus());  
            }
        }
    }

    public class GoogleTravelRequest extends TravelRequest {

        public override TravelResponse sendRequest(String origins, String destinations){
            Map<string, string> parameterMap = new Map<String,String>{
                'units' => 'imperial',
                'language' => 'en',
                'origins' => origins,
                'destinations' => destinations,
                'key'=> API_Keys__c.getOrgDefaults().Google_API_Key__c
            };
            String googleUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json?';
            String generatedUrl = generateUrl(googleUrl, parameterMap);
            return sendGetRequest(generatedUrl, GoogleTravelResponse.class);      
        }

    }

    public class BingTravelRequest extends TravelRequest {

        public override TravelResponse sendRequest(String origins, String destinations){
            Map<string, string> parameterMap = new Map<String,String>{
                'travelMode' => 'Driving',
                'waypoint.1' => destinations,
                'waypoint.0' => origins,
                'distanceUnit' => 'mi',
                'key' => API_Keys__c.getOrgDefaults().Bing_API_Key__c
            };

            String bingUrl = 'http://dev.virtualearth.net/REST/v1/Routes?';
            String generatedUrl = generateUrl(bingUrl, parameterMap);
            return sendGetRequest(generatedUrl, BingTravelResponse.class);
        }

        public void sendLocationRequest(List<SFDC_Volunteer_Event__c> openEnrollments) {

            List<Map<String, String>> listOfParameterMaps = new List<Map<String, String>>();

            for(SFDC_Volunteer_Event__c openEnrollment : openEnrollments){
                Map<string, string> parameterMap = new Map<String,String>{
                'countryRegion' => 'US',
                'adminDistrict' => openEnrollment.Meeting_State__c,
                'locality' => openEnrollment.Meeting_City__c,
                'postalCode' => openEnrollment.Meeting_Zip_Code__c ,
                'addressLine' => openEnrollment.Meeting_Street__c,
                'key' => API_Keys__c.getOrgDefaults().Bing_API_Key__c       
            };

                listOfParameterMaps.add(parameterMap);
            }

            String bingUrl = 'http://dev.virtualearth.net/REST/v1/Locations?';
            String setJsonResponse = '&output=json';
            List<String> generatedUrls = generateUrls(bingUrl, listOfParameterMaps);
            String serializedOpenEnrollments = JSON.serialize(openEnrollments);
            sendGetRequests(generatedUrls, serializedOpenEnrollments);
        }

    }

     public class BingTravelDistanceRequest {

            public TravelResponseParser result;

            public TravelResponse sendRequest(List<Point> origins, List<Point> destinations){

            BingTravelDistanceRequestBody distanceRequestBody = new BingTravelDistanceRequestBody(origins, destinations);

            String bingUrl = 'http://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?key=' + API_Keys__c.getOrgDefaults().Bing_API_Key__c;
            return sendPostRequest(bingUrl, BingTravelResponse.class, JSON.serialize(distanceRequestBody));
        }

        public TravelResponse sendPostRequest(String url, Type dataType, String body){
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('POST');  
            req.setBody(body);
            HttpResponse res = new http().send(req);

            if(String.isNotBlank(res.getBody()) && res.getStatusCode() < 300){

             result = TravelResponseParser.parse(res.getBody());

            } else {
                throw new TravelResponseException(ERROR_SERVER_CONNECTION + res.getStatus());  
            }

            return result;
        }

    }

    public class Point {
        public Decimal latitude;
        public Decimal longitude;

        public Point(Decimal lat, Decimal longitude){
            this.latitude = lat;
            this.longitude = longitude;
        }
    }

    public class BingTravelDistanceRequestBody {

        public List<Point> origins;
        public List<Point> destinations;
        public String travelMode;
        public String distanceUnit;

        public BingTravelDistanceRequestBody(List<Point> origins, List<Point> destinations){
            travelMode = 'driving';
            this.origins = origins;
            this.destinations = destinations;
            this.distanceUnit = 'mi';
        }
    }

    public class TravelResponseException extends Exception {}

    abstract public class TravelResponse {

        public DistanceMatrix getDistanceMatrix() {
            return getDistanceMatrix(0,0);
        }

        public abstract DistanceMatrix getDistanceMatrix(Integer originIndex, Integer destinationIndex);

        public String getError() {
            return getError(0,0);
        }

        public abstract String getError(Integer originIndex, Integer destinationIndex);

    }

    public class GoogleTravelResponse extends TravelResponse {
        public List<String> destination_addresses;
        public List<String> origin_addresses;
        public List<GoogleRowObject> rows;
        public String status; // added for storing response status

        public override DistanceMatrix getDistanceMatrix(Integer originIndex, Integer destinationIndex) {
            String distance = rows[originIndex].elements[destinationIndex].distance.text.replace('mi', 'Miles');
            String duration = rows[originIndex].elements[destinationIndex].duration.text;
            return new DistanceMatrix(distance, duration );
        }

        public override String getError(Integer originIndex, Integer destinationIndex) {

            if(status == SUCCESS_STATUS){
                if(rows[originIndex].elements[destinationIndex].status == SUCCESS_STATUS ){
                    return '';
                }else{
                    return rows[originIndex].elements[destinationIndex].status;
                }
            }else{
                return status;
            }
        }

    }

    public class GoogleElementObject {
        public GoogleResultObject distance {get; set;}
        public GoogleResultObject duration {get; set;}
        public String status;
    }

    public class GoogleResultObject {
        public String text {get; set;}
        public Integer value {get; set;}
        
        public GoogleResultObject(String text, Integer value) {
            this.text = text;
            this.value = value;
        }
    }

    public class GoogleRowObject {
        public List<GoogleElementObject> elements {get; set;}
    }    

    public class BingTravelResponse extends TravelResponse{
        public List<BingResourceSet> resourceSets;
        public String statusDescription;

        public override DistanceMatrix getDistanceMatrix(Integer originIndex, Integer destinationIndex) {
            String distance = Decimal.valueOf(resourceSets[0].resources[0].travelDistance).setscale(2) + ' Miles';
            Integer totalSeconds = Integer.valueOf(resourceSets[0].resources[0].travelDuration);
            Integer hours = (Integer)Math.floor(totalSeconds/(60*60));
            Integer minutes = (Integer)Math.ceil((totalSeconds - (hours * 60 * 60) )/ 60 );
            String timeString = '';

            timeString+=hours>0 ? hours + ' hour'+ (hours>1 ? 's' : '') : '';
            timeString+=hours>0 && minutes>0 ? ', ' : '';
            timeString+=minutes>0 ? minutes + ' minute'+ (minutes>1 ? 's': ''): '';

            String duration = timeString;
            return new DistanceMatrix(distance, duration);
        }

        public override String getError(Integer originIndex, Integer destinationIndex) {
            if(statusDescription == SUCCESS_STATUS){        
                return '';
            }else{
                return statusDescription;
            }
        }

    }

    public class BingResourceSet {
        public List<BingResource> resources;
    }

    public class BingResource {
        public String travelDistance;
        public String travelDuration;
    }
  
    public class DistanceMatrix{
        public String distance;
        public String duration;

        public DistanceMatrix(String distance, String duration){
            this.distance = distance;
            this.duration = duration;
        }
    }

}