({
    fetchAccHelper : function(component, event, helper) {
        
        component.set('v.mycolumns', [
            {label: 'Account Name', fieldName: 'accountName', type: 'text',sortable :true},
           {label: 'Meeting Date', fieldName: 'meetingDate', type: 'text',sortable :true},
            
            {label: 'Start', fieldName: 'sessionStartTime', type: 'text',sortable :true},
            {label: 'End', fieldName: 'sessionEndTime', type: 'text',sortable :true},
            {label: 'Street', fieldName: 'meetingStreet', type: 'text',sortable :true},
            {label: 'City', fieldName: 'meetingCity', type: 'text',sortable :true},
            {label: 'State', fieldName: 'meetingState', type: 'text ',sortable :true},
            /*{label: 'OE Coordinator', fieldName: 'OE_Coordinator_Contact__c', type: 'text '},
            {label: 'OE Corrdinator Phone', fieldName: 'OE_Coordinator_Phone__c', type: 'text '},*/
            {label: 'Account Manager', fieldName: 'accountManger', type: 'text',sortable :true},
            {label: 'AM Phone', fieldName: 'amPhone', type: 'text',sortable :true},
            {label: 'SAR Acct Mg', fieldName: 'sarAccMgt', type: 'text',sortable :true},
            {label: 'SAR Phone', fieldName: 'sarPhone', type: 'text',sortable :true},
            {label: 'Client Eng', fieldName: 'clientEngagementConsultantSAR', type: 'text',sortable :true},
            {label: 'Client Eng Phone', fieldName: 'clientEngagementConsultantSARPhone', type: 'text',sortable :true}
            
            
            ]);
        var action = component.get("c.fetchVolPart");
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