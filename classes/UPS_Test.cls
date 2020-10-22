@istest
private class UPS_Test {
     @isTest static void testGetTrackingNoError() {
         MultiRequestMock multiRequestMock = new MultiRequestMock();
         multiRequestMock.addRequestMock(UPS_Constants.UPS_ENDPOINT_URL, new UPSMockResponseGenerator.UPSSinglePackageSuccessResponse());
         multiRequestMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, TravelResponseServiceTest.getDefaultBingGeocodeMock());
         Test.setMock(HttpCalloutMock.class, multiRequestMock);
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        UPS.TrackingDetails tdRes = UPS.getTracking('1ZA692F70196635379');
        System.debug('$$$ tdRes---' + tdRes);
        
        System.assert(tdRes != null);
    }
    
    @isTest static void testUpdateOrderFulfillmentNoError() {
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(UPS_Constants.UPS_ENDPOINT_URL, new UPSMockResponseGenerator.UPSSinglePackageSuccessResponse());
        multiRequestMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, TravelResponseServiceTest.getDefaultBingGeocodeMock());
        Test.setMock(HttpCalloutMock.class, multiRequestMock);
        
        Account a = UPS_TestDataFactory.createAccount(true);
        Open_Enrollment_Meetings__c oem = UPS_TestDataFactory.createOEMeetings(1, a, true)[0];
        SFDC_Volunteer_Event__c oe = UPS_TestDataFactory.createOpenEnrollments(1, oem, true)[0];
        OE_Order__c oeOrder = UPS_TestDataFactory.createOrders(1, oe, true)[0];
        List<Order_Fulfillment__c> ofList= UPS_TestDataFactory.createOrderFulfillments(100, oeOrder, false);
        Id[] ofIds = new Id[]{};
        for(Order_Fulfillment__c ofx : ofList) {
            ofx.Tracking_Number__c = '1ZA692F70196635379';
        }
        insert ofList;
        
        for(Order_Fulfillment__c ofx : ofList) {
             ofIds.add(ofx.id);
        }
        Test.startTest();
            UPS.updateStatus(ofIds);  
        Test.stopTest();                                    
        
        List<Order_Fulfillment__c> updatedOfs = [SELECT Id, Status__c from Order_Fulfillment__c where id in :ofList and Status__c = 'DELIVERED'];
        System.assertEquals(ofList.size(), updatedOfs.size());      
    }
    
    @isTest static void testUpdateOrderFulfillmentWithError() {
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(UPS_Constants.UPS_ENDPOINT_URL,new UPSMockResponseGenerator.UPSErrorResponse());
        multiRequestMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, TravelResponseServiceTest.getDefaultBingGeocodeMock());
        Test.setMock(HttpCalloutMock.class, multiRequestMock);
        
        Account a = UPS_TestDataFactory.createAccount(true);
        Open_Enrollment_Meetings__c oem = UPS_TestDataFactory.createOEMeetings(1, a, true)[0];
        SFDC_Volunteer_Event__c oe = UPS_TestDataFactory.createOpenEnrollments(1, oem, true)[0];
        OE_Order__c oeOrder = UPS_TestDataFactory.createOrders(1, oe, true)[0];
        List<Order_Fulfillment__c> ofList= UPS_TestDataFactory.createOrderFulfillments(100, oeOrder, false);
        Id[] ofIds = new Id[]{};
        for(Order_Fulfillment__c ofx : ofList) {
            ofx.Tracking_Number__c = '1ZA692F70196635379';
        }
        insert ofList;
        
        for(Order_Fulfillment__c ofx : ofList) {
             ofIds.add(ofx.id);
        }
        Test.startTest();
            UPS.updateStatus(ofIds);  
        Test.stopTest();                                    
        
        List<Order_Fulfillment__c> updatedOfs = [SELECT Id, Status__c from Order_Fulfillment__c where id in :ofList and Location__c = :Label.UPS_Default_Error_Message];
        System.assertEquals(ofList.size(), updatedOfs.size());      
    }
    
    @isTest static void testAPILimitError() {
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(UPS_Constants.UPS_ENDPOINT_URL, new UPSMockResponseGenerator.UPSsinglePackageSuccessResponse());
        multiRequestMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, TravelResponseServiceTest.getDefaultBingGeocodeMock());
        Test.setMock(HttpCalloutMock.class, multiRequestMock);

        Account a = UPS_TestDataFactory.createAccount(true);

        Test.startTest();
        Open_Enrollment_Meetings__c oem = UPS_TestDataFactory.createOEMeetings(1, a, true)[0];

        SFDC_Volunteer_Event__c oe = UPS_TestDataFactory.createOpenEnrollments(1, oem, true)[0];
        OE_Order__c oeOrder = UPS_TestDataFactory.createOrders(1, oe, true)[0];
        List<Order_Fulfillment__c> ofList= UPS_TestDataFactory.createOrderFulfillments(101, oeOrder, false);
        Id[] ofIds = new Id[]{};
        for(Order_Fulfillment__c ofx : ofList) {
            ofx.Tracking_Number__c = '1ZA692F70196635379';
        }
        insert ofList;
        
        for(Order_Fulfillment__c ofx : ofList) {
             ofIds.add(ofx.id);
        }

        UPS.updateStatus(ofIds);  
        Test.stopTest();                                    
        
        List<Order_Fulfillment__c> updatedOfs = [SELECT Id, Status__c from Order_Fulfillment__c where Status__c = 'DELIVERED'];
        List<Order_Fulfillment__c> ofWithError = [SELECT Id, Status__c from Order_Fulfillment__c where id in :ofList and Location__c = :Label.UPS_Default_Error_Message];

        System.debug(ofWithError.size());

        System.assertEquals(0, updatedOfs.size());
        System.assertEquals(101, ofWithError.size());      
    }
   
    @isTest static void testOrderWithMultiplePackageResponse() {
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(UPS_Constants.UPS_ENDPOINT_URL, new UPSMockResponseGenerator.UPSMultiplePackageSuccessResponse());
        multiRequestMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, TravelResponseServiceTest.getDefaultBingGeocodeMock());
        Test.setMock(HttpCalloutMock.class, multiRequestMock);
        
        Account a = UPS_TestDataFactory.createAccount(true);
        Open_Enrollment_Meetings__c oem = UPS_TestDataFactory.createOEMeetings(1, a, true)[0];
        SFDC_Volunteer_Event__c oe = UPS_TestDataFactory.createOpenEnrollments(1, oem, true)[0];
        OE_Order__c oeOrder = UPS_TestDataFactory.createOrders(1, oe, true)[0];
        List<Order_Fulfillment__c> ofList= UPS_TestDataFactory.createOrderFulfillments(100, oeOrder, false);
        Id[] ofIds = new Id[]{};
        for(Order_Fulfillment__c ofx : ofList) {
            ofx.Tracking_Number__c = '1Z6F814F0323777546';
        }
        insert ofList;
        
        for(Order_Fulfillment__c ofx : ofList) {
             ofIds.add(ofx.id);
        }
        Test.startTest();
            UPS.updateStatus(ofIds);  
        Test.stopTest();                                    
        
        List<Order_Fulfillment__c> updatedOfs = [SELECT Id, Status__c from Order_Fulfillment__c where id in :ofList and Status__c = 'DELIVERED'];
        System.assertEquals(ofList.size(), updatedOfs.size());      
    }
}