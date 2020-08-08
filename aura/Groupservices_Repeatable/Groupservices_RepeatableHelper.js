({
    // Function to fetch data from server called in initial loading of page
    fetchrecordtypeid : function(component, event, helper) {
        var action = component.get("c.getGsList");
        var GroupservicesId = component.get("v.gsParentID"); 
        //alert('GroupservicesId'+GroupservicesId);
        // Setting parameters for server method
        action.setParams({
            recId: GroupservicesId
        });
        // Callback function to get the response
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                // Getting the recordtype from response and storing in js variable
                var objRecordTypeMap = response.getReturnValue(); 
                component.set("v.gsrRecTypeID ",RecordType);
                var RecordType ;
                var objectName;
                var fieldname;
                for (var key in objRecordTypeMap) {
                    // check if the property/key is defined in the object itself, not in parent
                    if (objRecordTypeMap.hasOwnProperty(key)) {   
                        RecordType=objRecordTypeMap[key]; 
                        objectName=key;
                        //alert('RecordType'+RecordType); 
                        //alert('objectName'+objectName); 
                    }
                }
                
                //alert('objectNameout'+objectName); 
                
                if(objectName === 'Implementation_Coordinator_Repeatable__c'){
                    //alert('im here11');
                   var createRecordEventGS = $A.get("e.force:createRecord"); 				
                   createRecordEventGS.setParams({
                        "entityApiName":objectName, 
                        "recordTypeId":RecordType,
                        "defaultFieldValues": {
                          "Implementation_Coordinator_Tracking_ID__c" :component.get("v.gsParentID")
                        } 
                    }); 
                createRecordEventGS.fire();   					
                }else if(objectName === 'Group_Services_Repeatable__c'){
                   //alert('im here');
					var createRecordEventIC = $A.get("e.force:createRecord"); 
                    createRecordEventIC.setParams({
                        "entityApiName":objectName, 
                        "recordTypeId":RecordType,
                        "defaultFieldValues": {
                            "Group_Services_Tracking_ID__c" :component.get("v.gsParentID")
                        } 
                    });                     
				 createRecordEventIC.fire(); 
				}  
            }
            else {      
                alert('Error in getting data');
            }
        });  
        $A.enqueueAction(action);
    }

})