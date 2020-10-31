@isTest
private class UPS_Constants_Test {
    @isTest static void testGetUPSSettings() {
        Map<String, String> upsTrackSett = new Map<String, String>();
        for(UPS_Tracking_Settings__mdt sett : [SELECT DeveloperName, Value__c
                                                FROM UPS_Tracking_Settings__mdt]) {
            upsTrackSett.put(sett.DeveloperName.toUpperCase(), sett.Value__c);
        }
        
        Map<String, String> upsConsSett = new Map<String, String>();
        Integer batchSize= 0;
        Integer timeOut= 0;
        String userName = null;
        String password = null;
        String accesskey = null;
        String url = null;
        
        Test.startTest();
            upsConsSett = UPS_Constants.UPS_SETTINGS;
            batchSize = UPS_Constants.UPS_TRACKING_BATCH_SIZE;
            timeout = UPS_Constants.UPS_REQUEST_TIMEOUT;
            username = UPS_Constants.UPS_USERNAME;
            password = UPS_Constants.UPS_PASSWORD;
            accesskey = UPS_Constants.UPS_ACCESS_KEY;
            url = UPS_Constants.UPS_ENDPOINT_URL;
        Test.stopTest();
        
        System.assertEquals(upsTrackSett.size(), upsConsSett.size());
        if(upsTrackSett.get('UPS_TRACKING_BATCH_SIZE') != null) {
            System.assertEquals(Integer.valueOf(upsTrackSett.get('UPS_TRACKING_BATCH_SIZE')), batchSize);
        }
        else {
            System.assertEquals(0, batchSize);
        }
        if(upsTrackSett.get('UPS_REQUEST_TIMEOUT') != null) {
            System.assertEquals(Integer.valueOf(upsTrackSett.get('UPS_REQUEST_TIMEOUT')), timeout);
        }
        else {
            System.assertEquals(1000, timeout);
        }
        if(upsTrackSett.get('UPS_USERNAME') != null) {
            System.assertEquals(upsTrackSett.get('UPS_USERNAME'), username);
        }
        else {
            System.assertEquals('', username);
        }
        if(upsTrackSett.get('UPS_PASSWORD') != null) {
            System.assertEquals(upsTrackSett.get('UPS_PASSWORD'), password);
        }
        else {
            System.assertEquals('', password);
        }
        if(upsTrackSett.get('UPS_ENDPOINT_URL') != null) {
            System.assertEquals(upsTrackSett.get('UPS_ENDPOINT_URL'), url);
        }
        else {
            System.assertEquals('', url);
        }
        if(upsTrackSett.get('UPS_ACCESS_KEY') != null) {
            System.assertEquals(upsTrackSett.get('UPS_ACCESS_KEY'), accesskey);
        }
        else {
            System.assertEquals('', accesskey);
        }
        if(upsTrackSett.get('UPS_PASSWORD') != null) {
            System.assertEquals(upsTrackSett.get('UPS_PASSWORD'), password);
        }
        else {
            System.assertEquals('', password);
        }
        if(upsTrackSett.get('UPS_ENDPOINT_URL') != null) {
            System.assertEquals(upsTrackSett.get('UPS_ENDPOINT_URL'), url);
        }
        else {
            System.assertEquals('', url);
        }
        if(upsTrackSett.get('UPS_ACCESS_KEY') != null) {
            System.assertEquals(upsTrackSett.get('UPS_ACCESS_KEY'), accesskey);
        }
        else {
            System.assertEquals('', accesskey);
        }
        if(upsTrackSett.get('UPS_USERNAME') != null) {
            System.assertEquals(upsTrackSett.get('UPS_USERNAME'), username);
        }
        else {
            System.assertEquals('', username);
        }
        if(upsTrackSett.get('UPS_PASSWORD') != null) {
            System.assertEquals(upsTrackSett.get('UPS_PASSWORD'), password);
        }
        else {
            System.assertEquals('', password);
        }
        if(upsTrackSett.get('UPS_ENDPOINT_URL') != null) {
            System.assertEquals(upsTrackSett.get('UPS_ENDPOINT_URL'), url);
        }
        else {
            System.assertEquals('', url);
        }
        if(upsTrackSett.get('UPS_ACCESS_KEY') != null) {
            System.assertEquals(upsTrackSett.get('UPS_ACCESS_KEY'), accesskey);
        }
        else {
            System.assertEquals('', accesskey);
        }

    }    
}