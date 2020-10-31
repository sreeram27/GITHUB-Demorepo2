({
    initializeComp : function(component) {
        var action = component.get("c.initController");
        action.setParams({
            quoteId : component.get("v.recordId")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showWarning", response.getReturnValue().showWarning_IC); 
                component.set("v.showSendEmailLink", response.getReturnValue().showSendEmailLink); 
                component.set("v.showResendEmailLink", response.getReturnValue().showResendEmailLink);
                component.set("v.showResendWarning",response.getReturnValue().showResendWarning);
                component.set("v.showBtn",response.getReturnValue().showBtn);
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    },
    
    sendMailHelper : function(component,event,fromBtn){
        var action = component.get("c.sendProductEmail");
        action.setParams({
            quoteId : component.get("v.recordId"),
            fromBtn : fromBtn
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showWarningResendModal",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Email has been sent successfully.',
                    duration:'5000',
                    type: 'success',
                });
                toastEvent.fire();
                setTimeout(function(){ window.location.reload(); }, 3000);
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    }
})