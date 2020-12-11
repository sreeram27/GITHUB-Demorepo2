({
	doInit : function(component, event, helper) {
		/*component.set('v.QuoteTablecolumns', [
                {label: 'Product Name', fieldName: 'Product2.Name', type: 'text'},
                {label: 'FIRST Product Code', fieldName: 'Product2.ProductCode', type: 'text'},
                {label: 'Funding Type', fieldName: 'Funding__c', type: 'text'}
            ]);*/
        var optyId = component.get("v.recordId");
        //helper.getQuoteData(component, optyId);
        
        helper.doCalloutToFIRST(component, optyId);
	}
})