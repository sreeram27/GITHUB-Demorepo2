public with sharing class TriggerHelperUtility {
private static Boolean stopTrigger = true;
    
    public static void setStopTrigger(){
        stopTrigger = false;
    }
    
    public static void clearStopTrigger(){
        stopTrigger = true;
    }
    public static Boolean shouldRunTrigger() {
        return stopTrigger;
    }
}