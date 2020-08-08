public class UPS_Constants {
    
    public static String UPS_USERNAME {
        get {
            if(UPS_USERNAME == null) {
                UPS_USERNAME = '';
                if(UPS_SETTINGS.get('UPS_USERNAME') != null) {
                    UPS_USERNAME = UPS_SETTINGS.get('UPS_USERNAME');
                }
            }
            return UPS_USERNAME;
        }
    }
    
    public static String UPS_PASSWORD {
        get {
            if(UPS_PASSWORD == null) {
                UPS_PASSWORD = '';
                if(UPS_SETTINGS.get('UPS_PASSWORD') != null) {
                    UPS_PASSWORD = UPS_SETTINGS.get('UPS_PASSWORD');
                }
            }
            return UPS_PASSWORD;
        }
    }
    
    public static String UPS_ENDPOINT_URL {
        get {
            if(UPS_ENDPOINT_URL== null) {
                UPS_ENDPOINT_URL = '';
                if(UPS_SETTINGS.get('UPS_ENDPOINT_URL') != null) {
                    UPS_ENDPOINT_URL= UPS_SETTINGS.get('UPS_ENDPOINT_URL');
                }
            }
            return UPS_ENDPOINT_URL;
        }
    }
    
    public static String UPS_ACCESS_KEY {
        get {
            if(UPS_ACCESS_KEY == null) {
                UPS_ACCESS_KEY = '';
                if(UPS_SETTINGS.get('UPS_ACCESS_KEY') != null) {
                    UPS_ACCESS_KEY= UPS_SETTINGS.get('UPS_ACCESS_KEY');
                }
            }
            return UPS_ACCESS_KEY;
        }
    }
    
    public static Integer UPS_TRACKING_BATCH_SIZE {
        get {
            if(UPS_TRACKING_BATCH_SIZE == null) {
                UPS_TRACKING_BATCH_SIZE = 0;
                if(UPS_SETTINGS.get('UPS_TRACKING_BATCH_SIZE') != null) {
                    try {
                        UPS_TRACKING_BATCH_SIZE = Integer.valueOf(UPS_SETTINGS.get('UPS_TRACKING_BATCH_SIZE'));
                    } catch (Exception e) {}
                }
            }
            return UPS_TRACKING_BATCH_SIZE;
        }
    }
    
    public static Integer UPS_REQUEST_TIMEOUT {
        get {
            if(UPS_REQUEST_TIMEOUT == null) {
                UPS_REQUEST_TIMEOUT = 1000;
                if(UPS_SETTINGS.get('UPS_REQUEST_TIMEOUT') != null) {
                    try {
                        UPS_REQUEST_TIMEOUT = Integer.valueOf(UPS_SETTINGS.get('UPS_REQUEST_TIMEOUT'));
                    } catch (Exception e) {}
                }
            }
            return UPS_REQUEST_TIMEOUT;
        }
    }
       
    public static Map<String, String> UPS_SETTINGS {
        get {
            if(UPS_SETTINGS == null) {
                UPS_SETTINGS = new Map<String, String>();
                for(UPS_Tracking_Settings__mdt sett : [SELECT DeveloperName, Value__c
                                                FROM UPS_Tracking_Settings__mdt]) {
                    UPS_SETTINGS.put(sett.DeveloperName.toUpperCase(), sett.Value__c);
                }
            }
            return UPS_SETTINGS;
        }
    }
}