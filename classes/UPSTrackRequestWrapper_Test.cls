@isTest
private class UPSTrackRequestWrapper_Test {
    @istest static void testBuildRequest() {
        String trackingNum = '111AAAA12315';
        String description = 'Test Description';
        String requestOption = '01';
        UPSTrackRequestWrapper rw = null;
        Test.startTest();
        String reqStr = UPSTrackRequestWrapper.buildTrackRequest(trackingNum, description, requestOption);
        rw = UPSTrackRequestWrapper.parse(reqStr);
        Test.stopTest();
        
        System.assert(rw != null);
        System.assertEquals(trackingNum, rw.Trackrequest.InquiryNumber);
        System.assertEquals(requestOption, rw.Trackrequest.Request.RequestOption);
        System.assertEquals(description, rw.TrackRequest.Request.TransactionReference.CustomerContext);
    }
}