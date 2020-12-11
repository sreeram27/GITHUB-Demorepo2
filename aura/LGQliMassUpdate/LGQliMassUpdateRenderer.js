({
render : function(component, helper) {
    var ret = this.superRender();
     component.set("v.hideSpinner", true);
    return ret;
}
})