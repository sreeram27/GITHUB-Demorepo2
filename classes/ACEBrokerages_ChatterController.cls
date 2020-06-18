public without sharing class ACEBrokerages_ChatterController {

    @AuraEnabled
    public static List<CollaborationGroup> getFeeds() {
        List<CollaborationGroup> feeds = 
            [SELECT Id,Name FROM CollaborationGroup  where name LIKE 'National Broker%' LIMIT 1];
        return feeds;
    } 
    
   
 
}