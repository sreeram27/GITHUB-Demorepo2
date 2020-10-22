/*
    Name               :    LGP2AHighRoadsCanvas.JS 
    Description        :    JS to get the data from controller and assign it to lightning component attributes
    Created By         :    Arun Siddappa
*/
({
    doInit : function(component, event, helper) {
         var action;
        //-GLD-PRDCRM-51890 - Send parameters to P2A on Create CEP Case Button from QLI
         if(component.get("v.Source") === $A.get("$Label.c.CEP_Case") ){
            action = component.get("c.getQuoteDataForCEPNavigation");
            action.setParams({
                "quoteId": component.get("v.QuoteId"),
                "sSource": component.get("v.Source")
            });
        }
        else{
            component.set("v.QuoteLineIdFromSF",component.get("v.QuoteLineId"));
            // Get a reference to the getWeather() function defined in the Apex controller
            action = component.get("c.getQuoteDataForNavigation");
            action.setParams({
                "quoteLineId": component.get("v.QuoteLineId"),
                "sSource": component.get("v.Source")
            });
        }
        action.setCallback(this, function(response) {
             if(response.getState() === "SUCCESS" && response.getReturnValue()!=null){
                component.set("v.attributeValue", response.getReturnValue().attributeValue);
                component.set("v.QuoteLineId", response.getReturnValue().QuoteLineId);
                component.set("v.GroupName", response.getReturnValue().GroupName);
                component.set("v.ProductName", response.getReturnValue().ProductName);
                component.set("v.ProductStage", response.getReturnValue().ProductStage);
                component.set("v.ProductContractCode", response.getReturnValue().ProductContractCode);
                component.set("v.GroupId", response.getReturnValue().GroupId);
                component.set("v.GroupSize", response.getReturnValue().GroupSize);
                component.set("v.AdministrativeType", response.getReturnValue().AdministrativeType);
            	//console.log('Response - '+response.getReturnValue().attributeValue); needed for testing purpose
             }
        }); 
        // Invoke the service
         $A.enqueueAction(action);
    }
})