({
    sendOppData : function(component,fromBtn) {
        // PRDCRM-38037       
        var action = component.get("c.sendOpportunityData");
        action.setParams({
            quoteId : component.get("v.recordId")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Your Request has beed Submitted Successfully.',
                    duration:'5000',
                    type: 'success',
                });
                toastEvent.fire();
                if(fromBtn == component.get("v.forCreate")){
                    setTimeout(function(){ 
                        window.location.reload();
                    },3000);
                }
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    },
    
    initializeComp : function(component) {
        var action = component.get("c.initController");
        action.setParams({
            quoteId : component.get("v.recordId")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showTheCreatUpdateLink", response.getReturnValue().showCreatUpdate);
                component.set("v.showTheViewLink", response.getReturnValue().showViewLink);
                component.set("v.CDHP_SF_Id_From_ISG", response.getReturnValue().CDHP_SF_Id_ISG);
                component.set("v.showWarning", response.getReturnValue().showWarning_IC); 
                component.set("v.showSendEmailLink", response.getReturnValue().showSendEmailLink); 
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    },
    
    navigateToCDHPOmni : function(component,event) {
        var temp = 3000;
        
        if(component.get("v.fromBtn") == 'Update'){
            this.sendOppData(component,component.get("v.forUpdate")); 
        }else{
            temp = 10;
        }
        setTimeout(function(){ 
            var url = $A.get("$Label.c.CDHPISGLink_Part1")+component.get("v.CDHP_SF_Id_From_ISG")+$A.get("$Label.c.CDHPISGLink_Part2")
            window.open(url,"_blank");
        },temp);
        component.set("v.showWarningModal",false);
    }
})