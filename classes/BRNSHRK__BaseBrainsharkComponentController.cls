/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class BaseBrainsharkComponentController {
    global String apiHost {
        get;
    }
    global String appHost {
        get;
    }
    global String authenticateUrl {
        get;
    }
    global Integer companyId {
        get;
    }
    global static String FILTER_AND_JOIN;
    global static String FILTER_DETAIL_ID;
    global static String FILTER_OR_JOIN;
    global static String OPPORTUNITY_RECORD_IDENTIFIER;
    global String returnUrl {
        get;
    }
    global String serverName {
        get;
    }
    global String sessionJson {
        get;
    }
    global String staticHost {
        get;
    }
    global BaseBrainsharkComponentController() {

    }
    @RemoteAction
    global static Map<String,String> createRelatedObjects(BRNSHRK.BrainsharkAPI.Session session, Id toEmailId, String messageBody, String pidString, String objId, List<BRNSHRK.SendEmailController.BrainsharkIntKeyPair> intKeys) {
        return null;
    }
    @AuraEnabled
    global static Map<String,Object> deleteComment(String commentId, String presentationId) {
        return null;
    }
    global static BRNSHRK.BrainsharkSearchResult filterBrainsharks(Map<String,String> miscParameters, String filters) {
        return null;
    }
    @AuraEnabled
    global static BRNSHRK.BrainsharkSearchResult filterBrainsharks(Map<String,String> miscParameters, String filters, String perPage) {
        return null;
    }
    @AuraEnabled
    global static String findStoredUserFilter() {
        return null;
    }
    @AuraEnabled
    global static Map<String,Object> getBrainsharkFilters(String searchtext) {
        return null;
    }
    @AuraEnabled
    global static Map<String,Object> getComments(String presentationId) {
        return null;
    }
    @AuraEnabled
    global static String getInstanceBaseUrl() {
        return null;
    }
    @RemoteAction
    global static List<BRNSHRK.SendEmailController.BrainsharkIntKeyPair> getIntegrationKeys(BRNSHRK.BrainsharkAPI.Session session, String toId, String objId, String pidString, Boolean sendViewReceipt) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.SendEmailController.BrainsharkUserEmail getObjectEmail(Id objectId) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.BrainsharkModels.ToEmailViewModel getToEmailList(Id recordId, Integer pageNumber, Integer recordsPerPage) {
        return null;
    }
    @AuraEnabled
    global static Boolean hasNameSpace() {
        return null;
    }
    @AuraEnabled
    global static Map<String,Object> postComment(String presentationId, String comment) {
        return null;
    }
    @AuraEnabled
    global static Map<String,Object> postRating(String presentationId, String rating) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.BrainsharkAPI.Session refreshSession() {
        return null;
    }
    @AuraEnabled
    global static String retrieveOppStageName(String recordId) {
        return null;
    }
    @AuraEnabled
    global static Map<String,Object> retrieveSearchConfiguration(Id recordId) {
        return null;
    }
    @AuraEnabled
    global static String retrieveUserBrainsharkId() {
        return null;
    }
    @AuraEnabled
    global static String retrieveUserId() {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static String saveUserFilter(String option) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static BRNSHRK.BrainsharkSearchResult searchBrainsharks(String searchType, String query) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static BRNSHRK.BrainsharkSearchResult searchBrainsharks(String searchType, String query, String perPage) {
        return null;
    }
    @AuraEnabled
    global static BRNSHRK.BrainsharkSearchResult searchBrainsharksWithAllFilters(List<String> filterIds, List<String> folderIds, List<String> authorIds, List<String> tagIds, String searchTerm, String perPage) {
        return null;
    }
    @AuraEnabled
    global static BRNSHRK.BrainsharkSearchResult searchBrainsharksWithFilters(List<String> filterIds, String searchTerm, String perPage) {
        return null;
    }
}
