({
    doCalloutToFIRST : function(component, opptyId) {
     
        var action = component.get("c.getRegion");
        action.setParams({ OpptyId : opptyId });
        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") 
            {
                
                //alert("From server: " + JSON.stringify(response.getReturnValue()));
                
                //--------second controller Starts--------------
                
                if(response.getReturnValue().Account.Situs_State__c=='New York' && response.getReturnValue().Account.Anthem_Entity__c =='Local/Large Group')
                {
                    var action1 = component.get("c.sendInfoToFIRST");
                    console.log('entered into init method');
                    action1.setParams({"opptyId": opptyId});
                    
                    action1.setCallback(this, function(response) {
                        console.log('status : '+response.getState());
                        console.log('response : '+response.getReturnValue());
                        
                        if(response.getReturnValue().status == 'Failure') {
                            component.set("v.severity", "error");
                            component.set("v.title", "Error");
                        }
                        else {
                            component.set("v.severity", "confirm");
                            component.set("v.title", "Success");
                        }
                        component.set("v.accountId", response.getReturnValue().accId);
                        component.set("v.quoteLines", response.getReturnValue().qliList);
                        component.set("v.msg", response.getReturnValue().statusMsg);
                        component.set("v.lob", response.getReturnValue().lob);
                        component.set("v.UWLoginId", response.getReturnValue().UWLoginId);
                        component.set("v.UWName", response.getReturnValue().UWName);
                        component.set("v.salesRepId", response.getReturnValue().salesRepId);
                        component.set("v.salesRepName", response.getReturnValue().salesRepName);
                        component.set("v.effectiveDate", response.getReturnValue().effectiveDate);
                        
                    });
                    $A.enqueueAction(action1);
                    
                }
                else
                {
                        component.set("v.severity", "error");
                         component.set("v.title", "Error");
                         component.set("v.msg",'This functionality is available only for New York region');

                    
                }
                
                
                
            }
        });
        
        $A.enqueueAction(action);
        
    }
})