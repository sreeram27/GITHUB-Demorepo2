({
    init: function (component, event, helper) {
        helper.fetchData(component,event, helper);
    },
    saveChange : function(component,event,helper){
        helper.saveChangeHelper(component,event);
    },
    handleSave: function (component, event, helper) {
        helper.handleSaveHelper(component,event);
    },
    resetQli : function(component,event,helper){
        component.set('v.hideSpinner', true);
        helper.fetchData(component,event, helper);
        component.set('v.requiredStageReason',0);
        component.set('v.requiredStageReasonList',[]);
        component.set('v.isAdminError',false);
        component.set('v.isError',false);
    },
    backToQuote : function(component,event,helper){
        window.open(component.get('v.domainUrl'),'_top');
    },
    showChild : function(component,event,helper){
        helper.showChildHelper(component,event);
    }
})