({
    /**
    * @author: Ravideep(Vikings)
	* @created date : 05/24/2019
	* @description: controller for cloneBrokerageConsultantCmp component 
	* @ history : 
    */
    
    saveRec : function(component, event, helper) {
		console.log('bsplitbeforesave ' + component.find("bcs").get("v.value"));
        component.set("v.saveandnew",false);
		helper.saveRecHelper(component,event,helper);
	},
	saveAndNewRec : function(component, event, helper) {
		console.log('bsplitbeforesave ' + component.find("bcs").get("v.value"));
		component.set("v.saveandnew",true);
		helper.saveRecHelper(component,event,helper);
	},
	customCancel : function(component, event, helper) {
		helper.customCanecelHelper(component,event,helper);
	},
	handleValueChange : function(component,event,helper){
            console.log('bsplit%--> ' + component.find("bcs").get("v.value"));
            component.set("v.bccomm.Brokerage_Commission_Split__c", component.find("bcs").get("v.value")); 
            helper.showWarningMessage(component, event, helper);
    	
    },
})