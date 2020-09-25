({
    // Handle component initialization
    doInit : function(component, event, helper) {
        var type = component.get("v.type");
        var types = component.get("v.types");
       
        var action = component.get("c.getFeeds");
        
        
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var feeds = a.getReturnValue();
                component.set("v.feeds", feeds);
            } else if (a.getState() === "ERROR") {
                console.log("oof");
            }
        });
                
        component.set("v.options");
        $A.createComponent("forceChatter:feed", {"type": type}, function(feed) {
            var feedContainer = component.find("feedContainer");
            feedContainer.set("v.body", feed);
        });
      
    },

 
})