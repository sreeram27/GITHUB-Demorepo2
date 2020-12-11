({
    doInit : function(component, event, helper) {
        component.set("v.showSpinner",true);
        helper.initializeComp(component);
    }, 
    
    closeModel : function(component, event, helper) {
        component.set("v.showWarningModal",false);
        component.set("v.showWarningResendModal",false);
    },
    
    resendMail :function(component, event, helper) {
        helper.sendMailHelper(component,event,'Resend');
    },
    sendMail : function(component, event, helper) {
        
        if(component.get("v.showResendEmailLink")){
            component.set("v.showWarningResendModal",true);
        }else{
            helper.sendMailHelper(component,event,'Send');
        }
    }
    
})