({
   /**
    * @author: Ravideep(Vikings)
	* @created date : 05/24/2019
	* @description: helper for cloneBrokerageConsultantCmp component 
	* @ history : 
    */
   saveRecHelper: function(component, event, helper) {
    debugger;
	component.set("v.showSpinner", true);
    console.log('field1---' + component.find("oppid").get("v.value"));
	component.set("v.bccomm.Opportunity__c", component.find("oppid").get("v.value"));
    component.set("v.bccomm.BrokerageAndConsultant__c", component.find("bac").get("v.value")); 
    component.set("v.bccomm.Payment_Method__c", component.find("paym").get("v.value")); 
	component.set("v.bccomm.Line_of_Business__c", component.find("lob").get("v.value"));
    component.set("v.bccomm.Commission_Dollar_Amount__c", component.find("cda").get("v.value")); 
    component.set("v.bccomm.Commission_Percentage__c", component.find("cmp").get("v.value")); 
	component.set("v.bccomm.Commission_Start_Date__c", component.find("csd").get("v.value"));
    component.set("v.bccomm.Group_Numbers__c", component.find("grpnum").get("v.value")); 
    component.set("v.bccomm.Commission_End_Date__c", component.find("ced").get("v.value")); 
	component.set("v.bccomm.Applies_to_only_a_portion_of_group__c", component.find("apply").get("v.value"));
	component.set("v.bccomm.Brokerage_Commission_Split__c", component.find("bcs").get("v.value")); 
    component.set("v.bccomm.Sub_Groups_Contract_Codes_Package_Code__c", component.find("sgrpcode").get("v.value")); 
	component.set("v.bccomm.Funding_Type__c", component.find("fundtype").get("v.value")); 
	var action = component.get("c.insertClonedRecord");	
	action.setParams({  bccomm : component.get("v.bccomm") });
	action.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS"){
            console.log('From server: ' + response.getReturnValue());
            component.set("v.newrecId",response.getReturnValue())
			component.set("v.showError",false);
			var recid = response.getReturnValue();
				if (recid !== undefined && recid!== null){
					//navigate to new record on successful save
					if(component.get("v.postSaveFlag") === true){
                        if(component.get("v.saveandnew") === false){
                        var navEvt = $A.get("e.force:navigateToSObject");
						navEvt.setParams({
							"recordId": recid,
							"slideDevName": "detail"
						});
						navEvt.fire();
                        }
                        else{	
                              
                                var evt = $A.get("e.force:navigateToComponent");
                                evt.setParams({
                                    componentDef : "c:cloneBrokerageCommission",
                                    componentAttributes: {
                                        saveandnew : true,
                                        prevrecId : component.get("v.recordId"),
                                        recordId : ''
                                    }
                                });
                                evt.fire();
                                
    					}
					}
					else{
                        	this.showWarningMessage(component,event,helper);
                            if(component.get("v.saveandnew") === false){
                                   setTimeout($A.getCallback(function() {$A.get("e.force:navigateToSObject").setParams({"recordId": recid,"slideDevName": "detail"}).fire();}), 1500);
                                }
                            else{
                                	setTimeout($A.getCallback(function() {$A.get("e.force:navigateToComponent").setParams({componentDef : "c:cloneBrokerageCommission",
                                           componentAttributes: {
                                                saveandnew : true,
                                               	prevrecId : component.get("v.recordId"),
                                                recordId : ''
                                            }
                                      }).fire();}),1500);
								}
                       }
               
                 } 
            }
			else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.errormsg",errors[0].message);
						component.set("v.showError",true);
						component.set("v.showSpinner", false);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        	
        });	
		$A.enqueueAction(action);
    },
	customCanecelHelper: function(component, event, helper) {
		if(component.get("v.saveandnew") === false){
			$A.get("e.force:closeQuickAction").fire();
		}
		else{
             $A.get("e.force:navigateToURL").setParams({"url": "/" + component.get("v.prevrecId") }).fire();
         }
	
	},
	showWarningMessage: function(component, event, helper) {	
       debugger;
			component.set("v.postSaveFlag", true);
        	var	dccurrentBrokerageCommission = component.find("bcs").get("v.value");
        	var opptyid = component.find("oppid").get("v.value");
        	console.log('dccurrentBrokerageCommission: '+ dccurrentBrokerageCommission);
			console.log('recid: '+ component.get("v.recordId"));
       		console.log('v.newrecId: '+ component.get("v.newrecId"));
			var action = component.get("c.getBrokerageCommissionSplitTotal");
            
                if(component.get("v.newrecId") !== undefined){
                    //alert('if1');
                    action.setParams({  recordId : component.find("oppid").get("v.value"), dccurrentBrokerageCommission : null});
                }
                else if(dccurrentBrokerageCommission === undefined || dccurrentBrokerageCommission === ''){
                    //alert('else1');
                    action.setParams({  recordId : component.find("oppid").get("v.value"), dccurrentBrokerageCommission : null});
                }
                else{
                    //alert('else');
                    action.setParams({  recordId : component.find("oppid").get("v.value") , dccurrentBrokerageCommission : dccurrentBrokerageCommission});
                }   
           if(opptyid !== null && opptyid !==undefined){
			action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('From server1: ' + response.getReturnValue());
				component.set("v.showWarning", response.getReturnValue());	
            }
			else{
				console.log('Unknown error: '+ state);
            }
        });
            $A.enqueueAction(action); 
      }
	},
})