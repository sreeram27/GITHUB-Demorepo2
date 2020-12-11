({
    fetchAccHelper : function(component, event, helper) {
        
        component.set('v.mycolumns', [
                {label: 'Account Name', fieldName: 'accountName', type: 'text',sortable :true},
            {label: 'Meeting Date', fieldName: 'meetingDate', type: 'text',sortable :true},
            {label: 'City', fieldName: 'meetingCity', type: 'text',sortable :true},
            {label: 'State', fieldName: 'meetingState', type: 'text ',sortable :true},
            {label: 'OE Coordinator', fieldName: 'oeCoordinatorName', type: 'text',sortable :true},
            {label: 'OE Corrdinator Phone', fieldName: 'oeCoordinatorPhoneNumber', type: 'text',sortable :true}
            
            ]);
        var action = component.get("c.fetchVolParts");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.acctList", JSON.parse(response.getReturnValue()));
                
                console.log("v.acclis66t==="+response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    sortData: function (cmp, fieldName, sortDirection) {
       // cmp.set("v.sortedBy", event.getParam("fieldName"));
   // cmp.set("v.sortedDirection", event.getParam("sortDirection"));
        var data = cmp.get("v.acctList");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.acctList", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})