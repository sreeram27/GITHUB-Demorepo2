({
    doInit : function(component) {
        var action = component.get("c.getFeeds");
        
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var feeds = a.getReturnValue();
                component.set("v.feeds", feeds);
            } else if (a.getState() === "ERROR") {
                console.log("oof");
            }
        });
        $A.enqueueAction(action);
    }
})