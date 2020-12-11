({
	doInit : function(component, event, helper) {
		helper.doInitHelper(component,event);
	},
    waiting : function(component, event, helper) {
    component.set("v.HideSpinner", true);
    },
    doneWaiting : function(component, event, helper) {
    component.set("v.HideSpinner", false);
    },
    handleOnChange : function(component,event,helper){
        component.set("v.showSaveCancelBtn",false);
        component.set('v.isNoneChecked',false);
    },
    handleCancel : function(component,event,helper){
        helper.doInitHelper(component,event);
        window.open(component.get('v.domainUrl'),'_top');
    },
    handleSave : function(component,event,helper){
        helper.handleSaveHelper(component,event);
    }
})