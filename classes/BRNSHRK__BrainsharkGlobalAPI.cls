/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BrainsharkGlobalAPI {
    @AuraEnabled
    global static BRNSHRK.BrainsharkGlobalAPI.Session getActiveUserSession(String secureToken) {
        return null;
    }
    @AuraEnabled
    global static String getApiHost(String secureToken) {
        return null;
    }
    @AuraEnabled
    global static String getAppHost(String secureToken) {
        return null;
    }
    @AuraEnabled
    global static String getLoginDirectory(String secureToken) {
        return null;
    }
    @AuraEnabled
    global static String getSlideSharkHost(String secureToken) {
        return null;
    }
    @AuraEnabled
    global static String getStaticAssetURL(String secureToken) {
        return null;
    }
    @AuraEnabled
    global static String getStaticHost(String secureToken) {
        return null;
    }
    @AuraEnabled
    global static BRNSHRK.BrainsharkGlobalAPI.User getUser(String secureToken, BRNSHRK.BrainsharkGlobalAPI.Session sess, Id user, Boolean sessionRefreshed) {
        return null;
    }
    @AuraEnabled
    global static String getUserPreference(String secureToken, Id userId, Integer key, String defaultValue) {
        return null;
    }
    @AuraEnabled
    global static BRNSHRK.BrainsharkGlobalAPI.Session getUserSession(String secureToken, Id userId, String username, String password) {
        return null;
    }
    @AuraEnabled
    global static Boolean hasUserSession(String secureToken, Id userId) {
        return null;
    }
    @AuraEnabled
    global static void saveUserSettings(String secureToken, Id userId) {

    }
    @AuraEnabled
    global static void setUserPreference(String secureToken, Id userId, Integer key, String value) {

    }
global class Session {
    global String FirstName {
        get;
        set;
    }
    global Long Id {
        get;
        set;
    }
    global Boolean isAdmin {
        get;
        set;
    }
    global Boolean isAuthor {
        get;
        set;
    }
    global String Key {
        get;
        set;
    }
    global String LastName {
        get;
        set;
    }
    global Long LastVisitDate {
        get;
        set;
    }
    global String Token {
        get;
        set;
    }
    global Long UId {
        get;
        set;
    }
    global Session() {

    }
}
global class User {
    global Long Id {
        get;
        set;
    }
    global User() {

    }
}
}
