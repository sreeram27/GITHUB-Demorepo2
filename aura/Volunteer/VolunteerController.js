/*****
 * ------------------------------------------------------------------------------------------------------------------------------
 * Name   VolunteerController
 * Author  Sreeman Jannu
 * CreatedDate  05/18/2019
 * Used by       VolunteerCmp
 * -----------------------------------------------------------------------------------------------------------------------------
 * Description     
 * This control will construct Dynamic url based on the login user and opens new window
 * ---------------------------------------------------------------------------------------------------------------------------
 */
({
	openActionWindow : function(component, event, helper) {
		      
        var action = component.get("c.fetchContact");   
        var strURL = $A.get("$Label.c.OE_Site_URL");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.userInfo", response.getReturnValue());
                var emailID = component.get("v.userInfo.Email");
                var ambId = component.get("v.userInfo.OE_AMB_FacilitatorID__c");               
                
                if(ambId != null && emailID != null ){
                    //Dynamic URL
                    //get organization
                    //var environment = component.get("v.name"); --> Commented - picking the URL from label.
                    var URL=strURL+ambId+"&Email="+emailID;                        
                    /* -- Commented IF condition - The link will be picked from the label - OE_Site_URL - XMen  
                    if (environment == 'sandbox') {     
                                var URL = "http://commstg-wellpoint.cs94.force.com/OpenEnrollment?facID="+ambId+"&Email="+emailID;
                                
                    }
                    else{
                        var URL = "http://wellpoint.force.com/OpenEnrollment?facID="+ambId+"&Email="+emailID;        
                        }*/
                   window.open(URL);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
        
        
	}
    ,
    doInit: function(component, event, helper) {
        // Set the attribute value. 
        // You could also fire an event here instead.
         var action = component.get("c.fetchOrg");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.name", response.getReturnValue())
                }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    }

})