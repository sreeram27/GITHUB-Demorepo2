({
    doInitHelper : function(component,event) {
        var action = component.get("c.getQliOfCase");
        action.setParams({
            "ordId" : component.get("v.Id"),
            "quoteId" : component.get("v.QuoteId")
          // "ordId" : '80154000000LLPxAAO',
         //  "quoteId" : '0Q0540000004mHgCAI'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result){
                    component.set('v.result',result);
                    if(result.data){
                        var dataFromResult =[];
                        for(var i=0;i<result.data.length;i++){
                            var dupindex =  (result.qliId).findIndex(function(element){
                                return (element === result.data[i].Id);
                            });
                            if(dupindex > -1){
                                dataFromResult.push({
                                    "item": result.data[i],
                                    "IsImpacted" : true
                                }); 
                            }
                            else{
                                dataFromResult.push({
                                    "item": result.data[i],
                                    "IsImpacted" : false
                                }); 
                            }
                        }
                        component.set('v.data',dataFromResult); 
                        this.sortBy(component,'IsImpacted');
                    }
                    component.set('v.domainUrl',response.getReturnValue().fullRecordURL);
                }
                else{
                    component.set('v.isError',true);
                     component.set("v.HideSpinner", false);
                }   
            }  
            else if(response.getState() === "ERROR"){
                let errors = response.getError();
                let message = 'Unknown error'; 
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.error(message);
            }
        });
        $A.enqueueAction(action);
    },
    handleSaveHelper : function(component,event){
        var data = component.get('v.data');
        var qliIdList = component.get('v.qliIdsList');
        var action = component.get("c.updateQli");
        for(var i=0;i<data.length;i++){
            if(data[i].IsImpacted == true){
                qliIdList.push(data[i].item.Id)
            }
        }
        console.log('qliIdsList'+qliIdList);
        if(qliIdList.length == 0){
        component.set('v.isNoneChecked',true);
        component.set("v.showSaveCancelBtn",true);
            return;
        }
        else{
             component.set('v.isNoneChecked',false);
             action.setParams({
            "qliIdsList" : component.get('v.qliIdsList'),
            "ordId" : component.get('v.Id')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.showSaveCancelBtn',true);
                window.open(component.get('v.domainUrl'),'_top');
            }
            else if(response.getState() === "ERROR"){
                let errors = response.getError();
                let message = 'Unknown error'; 
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.error(message);
            }
        });
        
          $A.enqueueAction(action);
        }
      
    },
    sortBy: function(component, field) {
        var records = component.get("v.data");
        var sortField ='IsImpacted';
        var sortAsc = true;
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.data", records);
    }
})