({
	doInitHelper : function(component, event) {
		component.set('v.recordId', component.get("v.pageReference").state.id);
		console.log(component.get('v.recordId'));
	}
})