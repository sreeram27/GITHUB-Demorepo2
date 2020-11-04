/*************************************************************************
* @author Nikita Belov
* @company Bluewolf, an IBM Company
* @date 7/2016
* Lifte and shifted from COM1 - XMen
* Test scenarios for TravelResponseService and TravelResponseParser.
/**************************************************************************
 * Mod                      : 9/16/2019
 * @Author               : Mehaboob
 * @description        : Modified test class as part of PRDCRM-43038
***************************************************************************
* @Mod : 10/15/2019
* @Author : Mehaboob
* @description :  Modified test class as part of PRDCRM-43211
**************************************************************************
* @Mod : 10/30/2019
* @Author : Mehaboob
* @description :  Modified test class as part of PRDCRM-45610 and 43212
  @comment : added some parameters while calling createAccountSICList,createContact,createOpenEnrollment in this class to make the number of parameters similar
**************************************************************************/

@isTest
public class TravelResponseServiceTest {
    
    @testSetup
    static void testDataMethod () {     
        Test.setMock(HttpCalloutMock.class, New MockBingTravelResponse());
         
        //Insert account
        List<Account> accounts = new List<Account>();
        accounts =TestDataFactory.createAccountSICList(1,'Test Company Name','CA street','CA','CA State','12345','US','CAA');
        insert accounts; 
         
        //Insert Contact
        List<Contact> contactList=new List<Contact>();
        String recordTypeID=Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        contactList=TestDataFactory.createContact(1,'Tony','Test First',accounts[0],recordTypeID,'OE Coordinator','Central','tony_angle@msn.com',true,1,1);
        insert contactList;
        
        //Insert Open Enrollment Meeting 
        List<Open_Enrollment_Meetings__c> meetRecList=new List<Open_Enrollment_Meetings__c>();
        meetRecList=TestDataFactory.createOpenEnrollmentMeeting(1,'test Meeting',accounts[0],'Georgia',contactList[0],'ANC Vision','Commercial Medical','Yes','Test Performance comment','Renewal - Growth Opportunity','Sole Carrier','Test','3534353453','Business Casual');        
        insert meetRecList;
         
        //Insert Open Enrollment  
        List<SFDC_Volunteer_Event__c> eventsList = new List<SFDC_Volunteer_Event__c>();
        eventsList=TestDataFactory.createOpenEnrollment(2,'Test',meetRecList[0],'No',FALSE,'321 N Clark','Chicago','IL','60654','N/A','N/A',System.Today(),'Yes','Benefit Fair',100,true,'SUBMITTED','Yes',41.8882434,-87.6328535,true,false,false,accounts[0],'NEW REQUEST',contactList[0]);
        insert eventsList;
    }
    
    /**
     * @description :create custom settings . setting Google API key in Custom Setting 
    */
    public static void setGoogleAPIKey() {
        // create custom settings       
        API_keys__c customSettings = API_keys__c.getOrgDefaults();
        customSettings.Current_API__c = 'google';
        customSettings.Google_API_Key__c = 'googletestkey';
    insert customSettings;       

    }
    /**
     * @description :create custom settings . setting Bing API key in Custom Setting 
    */ 
    public static void setBingAPIKey() {
        // create custom settings       
        API_keys__c customSettings = API_keys__c.getOrgDefaults();
        customSettings.Current_API__c = 'bing';
        customSettings.Bing_API_Key__c = 'bingtestkey';
        insert customSettings;       
    }
    /**
     * @description : create custom settings .setting Bing API key in Custom Setting 
    */ 
    public static void setNoAPIKey() {
        // create custom settings       
        API_keys__c customSettings = API_keys__c.getOrgDefaults();
        customSettings.Current_API__c = 'qwerty';
        customSettings.Bing_API_Key__c = 'bingtestkey';
        insert customSettings;       
    }
    /**
     * @description : Google Response using address and distance for SUCCESS
     * @return GoogleTravelResponse
     * @param :addresses distance duration are passed to get the response 
    */
    public static TravelResponseService.GoogleTravelResponse createGoogleResponseSuccess(String destinationAddress, string originAddress, String distance, String duration){
        TravelResponseService.GoogleTravelResponse googleResponse = new TravelResponseService.GoogleTravelResponse();
        googleResponse.destination_addresses = new List<String>{destinationAddress};
        googleResponse.origin_addresses = new List<String>{originAddress};
        googleResponse.status=TravelResponseService.SUCCESS_STATUS;

        TravelResponseService.GoogleResultObject responseDistance = new TravelResponseService.GoogleResultObject(distance, 123);
        TravelResponseService.GoogleResultObject responseDuration = new TravelResponseService.GoogleResultObject(duration, 123);
        TravelResponseService.GoogleElementObject responseElements = new TravelResponseService.GoogleElementObject();
        responseElements.distance=responseDistance;
        responseElements.duration=responseDuration;
        responseElements.status=TravelResponseService.SUCCESS_STATUS;

        TravelResponseService.GoogleRowObject responseRow = new TravelResponseService.GoogleRowObject();
        responseRow.elements = new List<TravelResponseService.GoogleElementObject>{responseElements};

        googleResponse.rows = new List<TravelResponseService.GoogleRowObject>{ responseRow };

        return googleResponse;
    }
    /**
     * @description : Google Response using address and distance for ERROR
     * @return GoogleTravelResponse
     * @param :addresses and status are passed to get the response 
    */
    public static TravelResponseService.GoogleTravelResponse createGoogleResponseError(String destinationAddress, string originAddress, String status){
        TravelResponseService.GoogleTravelResponse googleResponse = new TravelResponseService.GoogleTravelResponse();
        googleResponse.destination_addresses = new List<String>{destinationAddress};
        googleResponse.origin_addresses = new List<String>{originAddress};
        googleResponse.status = status;
        googleResponse.rows = new List<TravelResponseService.GoogleRowObject>{};

        return googleResponse;    
    }
    /**
     * @description : Bing Response using address and distance for SUCCESS
     * @return BingTravelResponse
     * @param : distance and duration are passed to get the response 
    */
    public static TravelResponseService.BingTravelResponse createBingResponseSuccess(String distance, String duration){
        TravelResponseService.BingTravelResponse bingResponse = new TravelResponseService.BingTravelResponse();
        TravelResponseService.BingResource bingResource = new TravelResponseService.BingResource();
        bingResource.travelDistance = distance;
        bingResource.travelDuration = duration;
        TravelResponseService.BingResourceSet bingResourceSet = new TravelResponseService.BingResourceSet();
        bingResourceSet.resources = new List<TravelResponseService.BingResource> { bingResource};
        bingResponse.resourceSets = new List<TravelResponseService.BingResourceSet> { bingResourceSet };
        bingResponse.statusDescription = TravelResponseService.SUCCESS_STATUS;

        return bingResponse;
    }
    /**
     * @description : Bing Response using address and distance for ERROR
     * @return BingTravelResponse
     * @param :status is passed to create the Bing response 
    */
    public static TravelResponseService.BingTravelResponse createBingResponseError(String status){
        TravelResponseService.BingTravelResponse bingResponse = new TravelResponseService.BingTravelResponse();
        bingResponse.resourceSets = new List<TravelResponseService.BingResourceSet> {};
        bingResponse.statusDescription = status;

        return bingResponse;
    }
    /**
     * @description : Bing Travel Response using address and distance for SUCCESS
        * @return TravelResponseParser
        * @param :travelresponseparser records(results) are passed to create Bin travel response 
    */
    public static TravelResponseParser createBingTravelResponseSuccess(List<TravelResponseParser.Result> results){
        TravelResponseParser responseParser = new TravelResponseParser();
        
        
        List<TravelResponseParser.Destination> dstns=new List<TravelResponseParser.Destination>();
        TravelResponseParser.Resource reourceParser = new TravelResponseParser.Resource();
        reourceParser.aType='json type test';
        reourceParser.destinations=dstns;
        reourceParser.origins=dstns;
        reourceParser.errorMessage='Please select the valid value';
        
        
        responseParser.resourceSets = new List<TravelResponseParser.ResourceSet>{new TravelResponseParser.ResourceSet()};
        responseParser.resourceSets[0].resources = new List<TravelResponseParser.Resource>{new TravelResponseParser.Resource()};
        responseParser.resourceSets[0].resources[0].results = results;
        responseParser.statusDescription = TravelResponseService.SUCCESS_STATUS;

        return responseParser;

    }
    /**
     * @description : Bing GeoLocation Response using latitude and longitude for SUCCESS
     * @return LocationResponseParser
     * @param :latitude and longitude are passed to create  Bing GeoLocation response 
    */
    public static LocationResponseParser createBingGeoLocationResponseSuccess(Double latitude, Double longitude){
        LocationResponseParser responseParser = new LocationResponseParser();
        responseParser.statusDescription = TravelResponseService.SUCCESS_STATUS;
        responseParser.statusCode = 200;
        responseParser.resourceSets = new List<LocationResponseParser.ResourceSet>{new LocationResponseParser.ResourceSet()};
        responseParser.resourceSets[0].resources = new List<LocationResponseParser.Resource>{new LocationResponseParser.Resource()};
        responseParser.resourceSets[0].resources[0].geocodePoints = new List<LocationResponseParser.GeocodePoint>{new LocationResponseParser.GeocodePoint()};
        responseParser.resourceSets[0].resources[0].geocodePoints[0].coordinates = new List<Double>{latitude, longitude};

        return responseParser;
    }

   @isTest
    public static void testGoogleResponseServiceCorrect() {
        setGoogleAPIKey();

        TravelResponseService.GoogleTravelResponse responseBody = createGoogleResponseSuccess('Praha, Česká republika','Brno, Česká republika' , '127 mi', '2 hours, 4 min' );
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SingleRequestMock(200, TravelResponseService.SUCCESS_STATUS,JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));

        test.startTest();               
        TravelResponseService.GoogleTravelResponse testResult = (TravelResponseService.GoogleTravelResponse)TravelResponseService.getResponse('Brno Czech republic','Prague Czech republic');
        test.stopTest();     

        System.assertEquals(responseBody.rows[0].elements[0].distance.text, testResult.rows[0].elements[0].distance.text,'distance response');
        System.assertEquals(responseBody.rows[0].elements[0].duration.text, testResult.rows[0].elements[0].duration.text,'duration response');
        System.assertEquals(responseBody.getDistanceMatrix().distance, testResult.getDistanceMatrix().distance,'distance matrix');
        System.assertEquals(responseBody.getDistanceMatrix().duration, testResult.getDistanceMatrix().duration,'duration matrix');  
    }
    
    @isTest
    public static void testGoogleResponseServiceInvalidRequest() {
        setGoogleAPIKey();
        // Set mock callout class
        String errorMsg= 'INVALID_REQUEST';
        TravelResponseService.GoogleTravelResponse responseBody = createGoogleResponseError('Praha, Česká republika','Brno, Česká republika' , errorMsg );
        Test.setMock(HttpCalloutMock.class, new SingleRequestMock(200, TravelResponseService.SUCCESS_STATUS,JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));

        test.startTest();
        try {
            TravelResponseService.TravelResponse testResult = TravelResponseService.getResponse('','Prague Czech republic');
            System.assert(false, 'An exception expected');
        } catch(Exception e) {
           System.assertEquals(TravelResponseService.ERROR_MESSAGE_LABEL+errorMsg, e.getMessage(),'Travel response service error'); 
        }

        test.stopTest();
               
    }

    @isTest
    public static void testResponseService404Error() {
        // Set mock callout class
        String errorMsg= 'PAGE NOT FOUND';
        Test.setMock(HttpCalloutMock.class, new SingleRequestMock(404, errorMsg, '', new Map<String, String> {'Content-Type'=> 'application/json'} ));

        test.startTest();
        try {
            TravelResponseService.TravelResponse testResult = TravelResponseService.getResponse('','Prague Czech republic');
            System.assert(false, 'An exception expected');
        } catch(Exception e) {
            System.assertEquals(TravelResponseService.ERROR_SERVER_CONNECTION+errorMsg, e.getMessage(),'Travel response service server connection error'); 
        }

        test.stopTest();
               
    }
    
    @isTest
    public static void testGoogleResponseServiceNotFound() {
        setGoogleAPIKey();
        // Set mock callout class
        String errorMsg='NOT_FOUND';
        TravelResponseService.GoogleTravelResponse responseBody = createGoogleResponseSuccess('Praha, Česká republika','Brno, Česká republika' , '127 mi', '2 hours, 4 min' );
        responseBody.rows[0].elements[0].status = errorMsg;
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new SingleRequestMock(200, TravelResponseService.SUCCESS_STATUS,JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));

        test.startTest();
        try {
            TravelResponseService.TravelResponse testResult = TravelResponseService.getResponse('jhgf','Prague Czech republic');
            System.assert(false, 'An exception expected');
        } catch(Exception e) {
           System.assertEquals(TravelResponseService.ERROR_MESSAGE_LABEL+errorMsg, e.getMessage(),'Travel response service error Not found'); 
        }

        test.stopTest();
               
    }

    @isTest
    public static void testBingResponseServiceCorrect() {
        setBingAPIKey();

        TravelResponseService.BingTravelResponse responseBody = createBingResponseSuccess( '127.121234',  '7440');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SingleRequestMock(200, TravelResponseService.SUCCESS_STATUS,JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));

        test.startTest();               
        TravelResponseService.BingTravelResponse testResult = (TravelResponseService.BingTravelResponse)TravelResponseService.getResponse('Brno Czech republic','Prague Czech republic');
        test.stopTest();
        
        System.assertEquals(responseBody.resourceSets[0].resources[0].travelDistance, testResult.resourceSets[0].resources[0].travelDistance,'resourceSet travel distance ');
        System.assertEquals(responseBody.resourceSets[0].resources[0].travelDuration, testResult.resourceSets[0].resources[0].travelDuration,'resourceSet travel duration ');
        System.assertEquals(responseBody.getDistanceMatrix().distance, testResult.getDistanceMatrix().distance,'Distance Matrix distance');
        System.assertEquals(responseBody.getDistanceMatrix().duration, testResult.getDistanceMatrix().duration,'Distance Matrix duration');      
    }

    @isTest
    public static void testBingResponseServiceInvalidRequest() {
        setBingAPIKey();
        // Set mock callout class
        String errorMsg= 'INVALID_REQUEST';
        TravelResponseService.BingTravelResponse responseBody = createBingResponseError(errorMsg );
        Test.setMock(HttpCalloutMock.class, new SingleRequestMock(200, TravelResponseService.SUCCESS_STATUS,JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));

        test.startTest();
        try {
            TravelResponseService.TravelResponse testResult = TravelResponseService.getResponse('','Prague Czech republic');
            System.assert(false, 'An exception expected');
        } catch(Exception e) {
           System.assertEquals(TravelResponseService.ERROR_MESSAGE_LABEL+errorMsg, e.getMessage(),'Travel response service Invalid request'); 
        }

        test.stopTest();
               
    }

    @isTest
    public static void testNoAPISelectionResponseServiceCorrect() {
        setNoAPIKey();

        TravelResponseService.BingTravelResponse responseBody = createBingResponseSuccess( '127.678',  '7440');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SingleRequestMock(200, TravelResponseService.SUCCESS_STATUS,JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));

        test.startTest();               
        TravelResponseService.BingTravelResponse testResult = (TravelResponseService.BingTravelResponse)TravelResponseService.getResponse('Brno Czech republic','Prague Czech republic');
        test.stopTest();
        
        System.assertEquals(responseBody.resourceSets[0].resources[0].travelDistance, testResult.resourceSets[0].resources[0].travelDistance,'resourceSet travel distance NO API');
        System.assertEquals(responseBody.resourceSets[0].resources[0].travelDuration, testResult.resourceSets[0].resources[0].travelDuration,'resourceSet travel duration NO API');
        System.assertEquals(responseBody.getDistanceMatrix().distance, testResult.getDistanceMatrix().distance,'distance matrix distance');
        System.assertEquals(responseBody.getDistanceMatrix().duration, testResult.getDistanceMatrix().duration,'distance matrix duration');  
    }
    /**
     * @description : Bing Geocode Mock 
     * @return SingleRequestMock
    */
    public static SingleRequestMock getDefaultBingGeocodeMock(){
        LocationResponseParser responseBody = createBingGeoLocationResponseSuccess(10.0.doubleValue(),10.0.doubleValue());
        return new SingleRequestMock(200, 'OK',JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} );
    }
    
    @isTest
    public static void testBingResponseServiceMockBing() {
       //setBingAPIKey();

        //TravelResponseService.BingTravelResponse responseBody = createBingResponseSuccess( '127.121234',  '7440');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockBingTravelResponse());

        test.startTest();               
        TravelResponseService.BingTravelResponse testResult = (TravelResponseService.BingTravelResponse)TravelResponseService.getResponse('Brno Czech republic','Prague Czech republic');
        test.stopTest();
        
        //System.assertEquals(MockBingTravelResponse.resourceSets[0].resources[0].travelDistance, testResult.resourceSets[0].resources[0].travelDistance);
        //System.assertEquals(responseBody.resourceSets[0].resources[0].travelDuration, testResult.resourceSets[0].resources[0].travelDuration);
        //System.assertEquals(responseBody.getDistanceMatrix().distance, testResult.getDistanceMatrix().distance);
        //System.assertEquals(responseBody.getDistanceMatrix().duration, testResult.getDistanceMatrix().duration);      
    }
    
    
   // @isTest
    static void testSendLocationRequest(){
        setBingAPIKey();
        Test.setMock(HttpCalloutMock.class, new MockTravelResponse());
        Account acctRec = [Select id, Name from Account where Name='Test Company Name'];       
        Contact conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                           from Contact where Email='tony_angle@msn.com'];        
        // Insert new meeting        
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where Account__c=:acctRec.Id]; 
         List<SFDC_Volunteer_Event__c> oeRec = [Select id, name,meeting_Street__c,
                                               meeting_city__c,meeting_state__c,
                                                Meeting_Zip_Code__c, 
                                                Location__latitude__s, Location__longitude__s from SFDC_Volunteer_Event__c where OE_Grouping__c=: meetRec.Id];
        
         

        test.startTest();               
         TravelResponseService.sendLocationRequest(oeRec);
        test.stopTest();      
                
    }
    @isTest
    Static void testMultiMock(){
        List<TravelResponseParser.Result> results = new List<TravelResponseParser.Result>();
        final Integer NUM_EVENTS_TO_CREATE = 3;

      /*  for(Integer i = 0; i < NUM_EVENTS_TO_CREATE; i++){
            TravelResponseParser.Result result = new TravelResponseParser.Result();
            result.travelDistance = 100;
            result.travelDuration = 100;
            results.add(result);
        }  */
            TravelResponseParser.Result result = new TravelResponseParser.Result();
            result.travelDistance = 100;
            result.travelDuration = 100;
            results.add(result);
            
            TravelResponseParser.Result result2 = new TravelResponseParser.Result();
            result2.travelDistance = null;
            result2.travelDuration = 100;
            results.add(result2);
            
            TravelResponseParser.Result result3 = new TravelResponseParser.Result();
            result3.travelDistance = 100;
            result3.travelDuration = 100;
            results.add(result3);
 
        TravelResponseParser responseParser = TravelResponseServiceTest.createBingTravelResponseSuccess(results);
        LocationResponseParser responseBody = TravelResponseServiceTest.createBingGeoLocationResponseSuccess(10.0.doubleValue(),10.0.doubleValue());
          
        MultiRequestMock multiMock = new MultiRequestMock();

        multiMock.addRequestMock(TravelResponseService.BING_DISTANCE_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseParser), new Map<String, String> {'Content-Type'=> 'application/json'}));
        multiMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));
        Test.setMock(HttpCalloutMock.class, multiMock);    
       // TravelResponseParser.DistanceMatrix test = new TravelResponseParser.DistanceMatrix (); 
        Test.startTest();
        //TravelResponseParser.getDistanceMatrix(100, 110);
        Test.stopTest();


    }   
    
    @isTest
     public static Void getTravelDistance(){

         TravelResponseServiceTest.setGoogleAPIKey();
         TravelResponseService.TravelResponse responseBody = TravelResponseServiceTest.createGoogleResponseSuccess('Atlanta', 'Chicago', '150', '7550');
        LocationResponseParser responseBodyLocation = TravelResponseServiceTest.createBingGeoLocationResponseSuccess(10.0.doubleValue(),10.0.doubleValue());
         MultiRequestMock multiMock = new MultiRequestMock();

         multiMock.addRequestMock(TravelResponseService.GOOGLE_ENDPOINT, new SingleRequestMock(400, 'INVALID_RESPONSE',JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'}));
         multiMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseBodyLocation), new Map<String, String> {'Content-Type'=> 'application/json'} ));
         Test.setMock(HttpCalloutMock.class, multiMock);
         
     }
    @isTest
    static void getTravelResponse(){
        
         Test.setMock(HttpCalloutMock.class, new MockBingTravelResponse());
         List<TravelResponseService.Point> origins = new List<TravelResponseService.Point>();
         List<TravelResponseService.Point> destinations = new List<TravelResponseService.Point>();              

          origins.add(new TravelResponseService.Point( 40.712776, -74.005974));               
          destinations.add(new TravelResponseService.Point(41.878113, -87.629799));
        Test.startTest();
        TravelResponseService.sendRequest(origins, destinations);
        Test.stopTest();
        
    }
    @isTest
    static void getGenerateURLs(){
        setBingAPIKey();
        Test.setMock(HttpCalloutMock.class, new MockBingTravelResponse());       
       // Account acctRec = [Select id, Name from Account where Name='Test Company Name'];       
         Account acctRec = [Select id, Name from Account LIMIT 1];       
         Contact conQuery = [Select id, name, Email, Region_Location__c, bilingual__c
                           from Contact where Email='tony_angle@msn.com'];        
        // Insert new meeting        
        Open_Enrollment_Meetings__c meetRec= [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where Account__c=:acctRec.Id]; 
         List<SFDC_Volunteer_Event__c> oeRec = [Select id, name,meeting_Street__c,
                                               meeting_city__c,meeting_state__c,
                                                Meeting_Zip_Code__c, 
                                                Location__latitude__s, Location__longitude__s from SFDC_Volunteer_Event__c where OE_Grouping__c=: meetRec.Id];
        
         List<Map<String, String>> testlistOfParameterMaps = new List<Map<String, String>>();
       

            for(SFDC_Volunteer_Event__c openEnrollment : oeRec){
                Map<string, string> parameterMap = new Map<String,String>{
                'countryRegion' => 'US',
                'adminDistrict' => openEnrollment.meeting_state__c,
                'locality' => openEnrollment.meeting_city__c,
                'postalCode' => openEnrollment.Meeting_Zip_Code__c ,
                'addressLine' => openEnrollment.meeting_Street__c,
                'key' => API_Keys__c.getOrgDefaults().Bing_API_Key__c   
            };

                testlistOfParameterMaps.add(parameterMap);
            }
        String bingUrl = 'http://dev.virtualearth.net/REST/v1/Locations?';       
       TravelResponseService.sendLocationRequest(oeRec);
       
                 
    }
   
    @isTest
    Static void testDistanceMatrix(){
       Test.setMock(HttpCalloutMock.class, new MockBingTravelResponse());
         List<TravelResponseService.Point> origins = new List<TravelResponseService.Point>();
         List<TravelResponseService.Point> destinations = new List<TravelResponseService.Point>();  
        TravelResponseParser.ResourceSet tstRS = new TravelResponseParser.ResourceSet ();
       String json = '{'+
    '   \"authenticationResultCode\":\"ValidCredentials\",'+
    '   \"brandLogoUri\":\"http:\\/\\/dev.virtualearth.net\\/Branding\\/logo_powered_by.png\",'+
    '   \"copyright\":\"Copyright  Corporation.\",'+
    '   \"resourceSets\":['+
    '      {'+
    '         \"estimatedTotal\":1,'+
    '         \"resources\":['+
    '            {'+
    '               \"__type\":\"Location:http:\\/\\/schemas.microsoft.com\\/search\\/local\\/ws\\/rest\\/v1\",'+
    '               \"bbox\":['+
    '                  47.636257744012461,'+
    '                  -122.13735364288299,'+
    '                  47.643983179153814,'+
    '                  -122.12206713944467'+
    '               ],'+
    '               \"name\":\"1 Microsoft Way, Redmond, WA 98052\",'+
    '               \"point\":{'+
    '                  \"type\":\"Point\",'+
    '                  \"coordinates\":['+
    '                     47.640120461583138,'+
    '                     -122.12971039116383'+
    '                  ]'+
    '               },'+
    '               \"confidence\":\"High\",'+
    '               \"entityType\":\"Address\",'+
    '               \"geocodePoints\":['+
    '                  {'+
    '                     \"type\":\"Point\",'+
    '                     \"coordinates\":['+
    '                        47.640120461583138,'+
    '                        -122.12971039116383'+
    '                     ],'+
    '                     \"calculationMethod\":\"InterpolationOffset\",'+
    '                     \"usageTypes\":['+
    '                        \"Display\"'+
    '                     ]'+
    '                  }'+
    '               ],'+
    '               \"matchCodes\":['+
    '                  \"Good\"'+
    '               ]'+
    '            }'+
    '         ]'+
    '      }'+
    '   ],'+
    '   \"statusCode\":200,'+
    '   \"statusDescription\":\"OK\",'+
    '   \"traceId\":\"b0b1286504404eafa7e7dad3e749d570\"'+
    '}';
        
       
        //tstRS = '{\"resourceSets\": {\"Test\",\"resources\":\"Test1\",\"results\":[{\"travelDistance\":10.01,\"travelDuration\":11.0,\"totalWalkDuration\":10.0}]}}';
       // tstRS='{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        
            //Double travelDistanceDouble = resourceSets[0].resources[0].results[destinationIndex].travelDistance;
            //Double travelDurationDouble = resourceSets[0].resources[0].results[destinationIndex].travelDuration;
            //Double travelWalkDurationDouble = resourceSets[0].resources[0].results[destinationIndex].totalWalkDuration;

          
        Test.startTest();
        origins.add(new TravelResponseService.Point( 40.712776, -74.005974));               
          destinations.add(new TravelResponseService.Point(41.878113, -87.629799));
         TravelResponseParser testParser = TravelResponseParser.parse(json);
        System.JSONParser parser = System.JSON.createParser(json);
        //TravelResponseParser.ResourceSet tst = Json;
        //tstRS = (TravelResponseParser.ResourceSet)testParser;
        
        TravelResponseParser.Destination des=new TravelResponseParser.Destination();
        des.latitude=93.023;
        des.longitude=95.025;
        //TravelResponseParser.arrayOfDestinations(parser);
        TravelResponseParser.Destination des2=new TravelResponseParser.Destination(parser);
        
        List<TravelResponseParser.Destination> destinationList= new List<TravelResponseParser.Destination>();
        
        final Integer NUM_EVENTS_TO_CREATE = 3;

        for(Integer i = 0; i < NUM_EVENTS_TO_CREATE; i++){
            TravelResponseParser.Destination destinationCreate= new TravelResponseParser.Destination();
            destinationCreate.latitude= 100;
            destinationCreate.longitude= 100;
            destinationList.add(destinationCreate);
        }
        
      
       // TravelResponseParser responseParser = TravelResponseServiceTest.createBingTravelResponseSuccess(destinationList);
       
       String json2 = 'test';
       
       System.JSONParser parser2 = System.JSON.createParser(json2);
       try{
       TravelResponseParser.arrayOfDestinations(parser2);
       }Catch(JSONException je){
        System.debug('exception goes '+je.getMessage());
       }
        
        
        
        TravelResponseService.TravelResponse tstResponse = TravelResponseService.sendRequest(origins, destinations);
       // String distance = tstResponse.getDistanceMatrix(11,12).distance;
        

        Test.stopTest();
          
    }
    
     @isTest
    Static void testTravelResponse(){
        Test.setMock(HttpCalloutMock.class, New MockTravelResponse());
        
        
        List <TravelResponse.ElementObject> tst = new List<TravelResponse.ElementObject>();        
        TravelResponseParser tRP = new TravelResponseParser();
        
        String test1 = tRP.getError(10, 11);
    
    }
    
    //Classes from OEAMBSignup Controller
     @isTest
    public static Void getTravelDistanceCorrectResponse() {

        TravelResponseServiceTest.setGoogleAPIKey();
        TravelResponseService.TravelResponse responseBody = TravelResponseServiceTest.createGoogleResponseSuccess('Atlanta', 'Chicago', '150', '7550');
        LocationResponseParser responseBodyLocation = TravelResponseServiceTest.createBingGeoLocationResponseSuccess(10.0.doubleValue(),10.0.doubleValue());
        MultiRequestMock multiMock = new MultiRequestMock();

        multiMock.addRequestMock(TravelResponseService.GOOGLE_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'}));
        multiMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseBodyLocation), new Map<String, String> {'Content-Type'=> 'application/json'} ));
        Test.setMock(HttpCalloutMock.class, multiMock);

        OEAmbSignupController controller = new OEAmbSignupController(); 
        //Account acctRec = createAccount();
        //Account acctRec = [Select id, Name from Account where Name='Test Company Name'];
        Account acctRec = [Select id, Name from Account LIMIT 1]; 
        Open_Enrollment_Meetings__c meetRec = [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where Account__c=:acctRec.Id];
        List<SFDC_Volunteer_Event__c> evntRec = [Select id, name, OE_Grouping__c, Meeting_Street__c, Meeting_City__c,
                                                Meeting_State__c,Meeting_Zip_Code__c from SFDC_Volunteer_Event__c 
                                                where OE_Grouping__c=: meetRec.Id];           
        
        // create new contact       
        controller.personContact = TestingUtils.createContacts(1, acctRec.Id, true)[0];
        controller.selectedMeeting = evntRec[0];  

        test.startTest();
        controller.getTravelDistance();
        test.stopTest();
    }
    @isTest
    public static Void openTheSearch(){
        Test.startTest();
        TravelResponseService.TravelResponse responseBody = TravelResponseServiceTest.createGoogleResponseSuccess('Atlanta', 'Chicago', '150', '7550');
         Test.setMock(HttpCalloutMock.class, New SingleRequestMock(200, TravelResponseService.SUCCESS_STATUS,JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));
        
        OEAmbSignupController controller = new OEAmbSignupController();
        controller.openSearch();
        Test.stopTest();
    }
    
    @isTest
    public static void getRelatedMeetingsForDistanceTest() {
        List<TravelResponseParser.Result> results = new List<TravelResponseParser.Result>();
        
        final Integer NUM_EVENTS_TO_CREATE = 3;

        for(Integer i = 0; i < NUM_EVENTS_TO_CREATE; i++){
            TravelResponseParser.Result result = new TravelResponseParser.Result();
            result.travelDistance = 100;
            result.travelDuration = 100;
            result.destinationIndex=0;
            result.totalWalkDuration=100;
            result.originIndex=0;
            results.add(result);
        }
        
        TravelResponseParser.Result result2 = new TravelResponseParser.Result();
            
            results.add(result2);
        
      
        TravelResponseParser responseParser = TravelResponseServiceTest.createBingTravelResponseSuccess(results);
        
        
        
        LocationResponseParser responseBody = TravelResponseServiceTest.createBingGeoLocationResponseSuccess(10.0.doubleValue(),10.0.doubleValue());

        MultiRequestMock multiMock = new MultiRequestMock();

        multiMock.addRequestMock(TravelResponseService.BING_DISTANCE_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseParser), new Map<String, String> {'Content-Type'=> 'application/json'}));
        multiMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, new SingleRequestMock(200, 'OK',JSON.serialize(responseBody), new Map<String, String> {'Content-Type'=> 'application/json'} ));
        Test.setMock(HttpCalloutMock.class, multiMock);

        OEAmbSignupController controller = new OEAmbSignupController();
        //Account acctRec = [Select id, Name from Account where Name='Test Company Name'];
        Account acctRec = [Select id, Name from Account LIMIT 1]; 
        Open_Enrollment_Meetings__c meetRec = [Select id, Name,Source__c,OE_Coordinator_Contact__c,
                                              Plan_Type__c, Account__C from Open_Enrollment_Meetings__c
                                              Where Account__c=:acctRec.Id];
        
        List<SFDC_Volunteer_Event__c> evntRecs = [Select id, name, Meeting_Street__c, Meeting_City__c,
                                                Meeting_State__c,Meeting_Zip_Code__c  from SFDC_Volunteer_Event__c where Name='Test1'];    
        controller.personContact = TestingUtils.createContacts(1, acctRec.Id, true)[0];

        Test.startTest();
        ApexPages.currentpage().getParameters().put('meetingID', evntRecs[0].Id);
        controller.isConsultant = false;
        controller.selectMeeting();
        Test.stopTest();
        List<OEAmbSignupController.RelatedMeetingWrapper> relatedMeetingWrappers = controller.meetingWrappers;
        System.assertEquals(1, relatedMeetingWrappers.size(), 'relatedMeetingWrapper count should be one less than total meetings created');
    } 
}