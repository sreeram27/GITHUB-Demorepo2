({
	EUSR_Recordtype: function(component){
        debugger;
         var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        //alert('recordtypename::::'+recordTypeId);
		var action = component.get("c.EUSR_Recordtypes");
        action.setParams({
            recTypeId:recordTypeId
        });
        action.setCallback(this, function(response){
            debugger;
                var recTyeName= response.getReturnValue();
            //alert('recTyeNameact:::'+recTyeName);
                if(recTyeName == 'User Access Request'){
                    component.set("v.variable1", true);
				}
            else if(recTyeName == 'Existing User Access Change'){
                    component.set("v.variable1", true);
				}
            else if(recTyeName == 'User Deactivation Request'){
                    component.set("v.variable1", true);
				}
            
                else
                {
                    component.set("v.variable1", false); 
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url":'/lightning/o/Support_Request__c/new?nooverride=1&useRecordTypeCheck=1&navigationLocation=MRU_LIST&backgroundContext=%2Flightning%2Fo%2FSupport_Request__c%2Flist%3FfilterName%3DRecent&recordTypeId='+recordTypeId
                    });
                    urlEvent.fire();
                    
                }
            
        });
	 $A.enqueueAction(action);
    },
    
    handleClick: function(cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/lightning/o/Support_Request__c/list?filterName=Recent'
        });
        urlEvent.fire();
    }
})