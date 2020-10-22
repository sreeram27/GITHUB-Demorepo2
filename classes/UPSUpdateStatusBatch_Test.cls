@isTest
private class UPSUpdateStatusBatch_Test {
    @istest static void testBatch() {
        Account a = UPS_TestDataFactory.createAccount(true);
        Open_Enrollment_Meetings__c oem = UPS_TestDataFactory.createOEMeetings(1, a, true)[0];
        SFDC_Volunteer_Event__c oe = UPS_TestDataFactory.createOpenEnrollments(1, oem, true)[0];
        OE_Order__c oeOrder = UPS_TestDataFactory.createOrders(1, oe, true)[0];
        List<Order_Fulfillment__c> ofList = UPS_TestDataFactory.createOrderFulfillments(100, oeOrder, false);
        for(Order_Fulfillment__c ofx : ofList) {
            ofx.Location__c = Label.UPS_Status_Update_Pending;
            ofx.Tracking_Number__c = '1Z6F814F0323777546';
        }
        insert ofList;

        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(UPS_Constants.UPS_ENDPOINT_URL, new UPSMockResponseGenerator.UPSSinglePackageSuccessResponse());
        multiRequestMock.addRequestMock(TravelResponseService.BING_LOCATION_ENDPOINT, TravelResponseServiceTest.getDefaultBingGeocodeMock());
        Test.setMock(HttpCalloutMock.class, multiRequestMock);
        Test.startTest();
        Database.executeBatch(new UPSUpdateStatusBatch(), 100);
        Test.stopTest();
        
        List<Order_Fulfillment__c> updatedOf = [SELECT Id from Order_Fulfillment__c WHERE Id in :ofList AND Status__c = 'DELIVERED'];
        System.assertEquals(100, updatedOf.size());
    }
    
     @isTest static void testSchedBatch() {
        Test.startTest();
            UPSUpdateStatusBatch upsBatch = new UPSUpdateStatusBatch();
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            System.schedule('test_schedule_run', CRON_EXP, upsBatch);   
        Test.stopTest();
    }
}