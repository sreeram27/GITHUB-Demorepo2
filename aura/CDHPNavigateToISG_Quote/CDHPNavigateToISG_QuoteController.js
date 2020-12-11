({
    sendAndViewData : function(component, event, helper) {
        component.set("v.showSpinner",true);
        helper.initializeComp(component);
        component.set("v.fromBtn","Update");
        setTimeout(function(){ 
            if(component.get("v.showWarning")){
                component.set("v.showWarningModal",true);
            }else{
                helper.sendOppData(component,component.get("v.forUpdate"));
                setTimeout(function(){ 
                    var url = $A.get("$Label.c.CDHPISGLink_Part1")+component.get("v.CDHP_SF_Id_From_ISG")+$A.get("$Label.c.CDHPISGLink_Part2")
                    window.open(url,"_blank");
                }, 3000);
            }
            component.set("v.showSpinner",false);
        }, 2000);
    },
    sendOpportunity : function(component, event, helper) {
        component.set("v.showSpinner",true);
        helper.sendOppData(component,component.get("v.forCreate")); //PRDCRM-38037
    },
    doInit : function(component, event, helper) {
        component.set("v.showSpinner",true);
        helper.initializeComp(component);
    },
    
    closeModel : function(component, event, helper) {
        component.set("v.showWarningModal",false);
    },
    
    view : function(component, event, helper) {    
        component.set("v.showSpinner",true);
        helper.initializeComp(component);
        component.set("v.fromBtn","View");
        setTimeout(function(){ 
            if(component.get("v.showWarning")){
                component.set("v.showWarningModal",true);
            }else{
                var url = $A.get("$Label.c.CDHPISGLink_Part1")+component.get("v.CDHP_SF_Id_From_ISG")+$A.get("$Label.c.CDHPISGLink_Part2")
                window.open(url,"_blank");
            }
            component.set("v.showSpinner",false);
        }, 2000);
    },
    
    submitDetails : function(component, event, helper) {
        helper.navigateToCDHPOmni(component,event);
    },
    
    sendMail : function(component, event, helper) {
        var action = component.get("c.sendProductEmail");
        action.setParams({
            quoteId : component.get("v.recordId")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Email has been sent successfully.',
                    duration:'5000',
                    type: 'success',
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    }
    
})