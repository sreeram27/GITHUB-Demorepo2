({
    doInit : function(component, event, helper) { 
        var pathArray = window.location.href;  
        var url = new URL(pathArray);
		var parentID = url.searchParams.get("c__id");
        //alert(parentID);
        component.set("v.gsParentID",parentID); 
        //Helper function - fetchrecordtypeID called for interaction with server
        helper.fetchrecordtypeid(component, event, helper);
    }
    
})