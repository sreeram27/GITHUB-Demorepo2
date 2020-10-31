({
    fetchAcc : function(component, event, helper) {
        helper.fetchAccHelper(component, event, helper);
    },
     updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        
        helper.sortData(cmp, fieldName, sortDirection);
    }
})