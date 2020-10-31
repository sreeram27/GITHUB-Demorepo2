({
    //Init function to get initial data
    fetchData: function (component,event,helper) {
        var action = component.get("c.getAllQlis");
        action.setParams({
            "quoteId" : component.get("v.quoteId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var ctrlDeptPickVal =[];
            if (state === "SUCCESS") {
                var dataWrap = response.getReturnValue();
                if(dataWrap){
                    //Sorting of QLI DATA
                    if(dataWrap.qliDataWrapperList.length>0){
                        dataWrap.qliDataWrapperList.sort(function(element1, element2){
                            var element1Name=element1.parentdata.parentName.toLowerCase(), element2Name=element2.parentdata.parentName.toLowerCase()
                            if (element1Name < element2Name)
                                 return -1 
                            if (element1Name > element2Name)
                                    return 1
                                    return 0 
                        })
                        component.set("v.dataWrapList",dataWrap.qliDataWrapperList);
                        component.set("v.result",dataWrap);
                        component.set("v.resultOriginalCopy",dataWrap);
                        sessionStorage.setItem("resultOriginalCopy", JSON.stringify(dataWrap));
                        component.set("v.hideSpinner", false);
                    }else{
                        component.set("v.isError",true);
                        component.set("v.hideSpinner", false);
                    }
                    component.set("v.domainUrl",dataWrap.domainUrl); 
                }else{
                    component.set("v.isError",true);
                    component.set("v.hideSpinner", false);
                }
            }else if(response.getState() === "ERROR"){
                let errors = response.getError();
                let message = "Unknown error"; 
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                    component.set("v.isAdminError",true);
                    component.set("v.adminErrorMsg",message);
                    component.set("v.hideSpinner", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    //On Change Handler when value is changed
    saveChangeHelper : function(component,event){
        
        component.set("v.isAdminError",false);
        component.set("v.showSaveCancelBtn",false);
        var index = event.target.getAttribute("data-value");
        var parentIndex = event.target.getAttribute("data-parentVal");
        var changedRows = component.get("v.changedRows");
        var resultObj= JSON.parse(sessionStorage.getItem("resultOriginalCopy"));
        var dataitem = component.get("v.dataWrapList")[parentIndex].data[index];
        var dupindex =  (changedRows).findIndex(function(element){
            return (element.Id === dataitem.qli.Id);
        });
        if (dupindex > -1) {
            changedRows.splice(dupindex,1);
            changedRows.push(dataitem.qli);
            this.changeColor(component,resultObj,index,event,parentIndex);
        }else{
            changedRows.push(dataitem.qli);
            this.changeColor(component,resultObj,index,event,parentIndex);
        }
        component.set('v.changedRows',changedRows);
    },
    //Highlight functionality when value changes
    changeColor : function(component,resultObj,index,event,parentIndex){
        
        var targetName = event.getSource().get("v.name");
        var dataItem = component.get("v.dataWrapList")[parentIndex].data[index];
        var stageVal = $A.get("$Label.c.LGStageForMandatotyReason")
        var resultIndex =  (resultObj.qliDataWrapperList[parentIndex].data).findIndex(function(element){
            return (element.qli.Id === dataItem.qli.Id);
        });   
        
        if(targetName == $A.get("$Label.c.LGStageName") && resultIndex > -1){
            if(((resultObj.qliDataWrapperList[parentIndex].data[index].qli.ProductStage__c == "NONE" || resultObj.qliDataWrapperList[parentIndex].data[index].qli.ProductStage__c == undefined)
                 && dataItem.qli.ProductStage__c == "")
               || resultObj.qliDataWrapperList[parentIndex].data[index].qli.ProductStage__c === dataItem.qli.ProductStage__c){
                dataItem.colorStage = false;
                $A.util.removeClass(event.target, "changeGreen");
            }else{
                dataItem.colorStage = true;
                $A.util.addClass(event.target, "changeGreen");
            }
        }else if(targetName == $A.get("$Label.c.LGStageReasonName") && resultIndex > -1){
            if(((resultObj.qliDataWrapperList[parentIndex].data[index].qli.Reason__c == "NONE" || resultObj.qliDataWrapperList[parentIndex].data[index].qli.Reason__c == undefined)
                && dataItem.qli.Reason__c == "")
               || resultObj.qliDataWrapperList[parentIndex].data[index].qli.Reason__c === dataItem.qli.Reason__c){
                dataItem.colorReason = false;
                $A.util.removeClass(event.target, "changeGreen");
            }else{
                dataItem.colorReason = true;
                $A.util.addClass(event.target, "changeGreen");
            }
        } else if(targetName == $A.get("$Label.c.LGPlanTypeName") && resultIndex > -1){
                if(((resultObj.qliDataWrapperList[parentIndex].data[index].qli.Plan_Type__c == "NONE" || resultObj.qliDataWrapperList[parentIndex].data[index].qli.Plan_Type__c == undefined)
                    && dataItem.qli.Plan_Type__c == "")
                   ||resultObj.qliDataWrapperList[parentIndex].data[index].qli.Plan_Type__c === dataItem.qli.Plan_Type__c){
                    dataItem.colorPlanType = false;
                    $A.util.removeClass(event.target, "changeGreen");
                }else{
                    dataItem.colorPlanType = true;
                    $A.util.addClass(event.target, "changeGreen");
                }
            }else if(targetName == $A.get("$Label.c.LGHpccCodeName") && resultIndex > -1){
                    if(String(resultObj.qliDataWrapperList[parentIndex].data[index].qli.HPCC_Code__c) === dataItem.qli.HPCC_Code__c){
                        $A.util.removeClass(event.target, "changeGreen");
                        dataItem.colorHpcc = false;
                    }else{
                        dataItem.colorHpcc = true;
                        $A.util.addClass(event.target, "changeGreen");
                    }
                }else if(targetName == $A.get("$Label.c.LGCustomContractCodeName") && resultIndex > -1){
                        if(String(resultObj.qliDataWrapperList[parentIndex].data[index].qli.vlocity_ins__ContractCode__c) === dataItem.qli.vlocity_ins__ContractCode__c){
                            dataItem.colorCustomCont = false;
                            $A.util.removeClass(event.target, "changeGreen");
                        }else{
                            dataItem.colorCustomCont = true;
                            $A.util.addClass(event.target, "changeGreen");
                        }
                    }
         // Show error when Reason not selected.
           var reasonList = component.get("v.requiredStageReasonList");
    if(resultObj.qliDataWrapperList[parentIndex].data[index].qli.ProductStage__c != dataItem.qli.ProductStage__c )
    {
        
        if(stageVal.includes(dataItem.qli.ProductStage__c) 
            && 
            (
                (dataItem.qli.Reason__c == "NONE" || dataItem.qli.Reason__c == "" || dataItem.qli.Reason__c == undefined )
            )
        )
        {
            var dupindex =  (reasonList).findIndex(function(element){ return (element === dataItem.qli.Id); });  
            if(dupindex <= -1)
            {
                reasonList.push(dataItem.qli.Id);
                component.set("v.requiredStageReasonList",reasonList);
                component.set("v.requiredStageReason",component.get("v.requiredStageReasonList").length);
            }
    
        }else if(stageVal.includes(dataItem.qli.ProductStage__c) && (dataItem.qli.Reason__c != null || dataItem.qli.Reason__c != "NONE"))
            {
                var dupindex =  (reasonList).findIndex(function(element){ return (element === dataItem.qli.Id); });  
                if (dupindex > -1) 
                {
                    reasonList.splice(dupindex,1);
                    component.set("v.requiredStageReasonList",reasonList);
                    component.set("v.requiredStageReason",component.get("v.requiredStageReasonList").length);
                }
            }else if(!stageVal.includes(dataItem.qli.ProductStage__c)){
            var dupindex =  (reasonList).findIndex(function(element){ return (element === dataItem.qli.Id); });  
                if (dupindex > -1) 
                {
                    reasonList.splice(dupindex,1);
                    component.set("v.requiredStageReasonList",reasonList);
                    component.set("v.requiredStageReason",component.get("v.requiredStageReasonList").length);
                }
        }
       
    }else if(resultObj.qliDataWrapperList[parentIndex].data[index].qli.ProductStage__c === dataItem.qli.ProductStage__c)
    {
        if(stageVal.includes(dataItem.qli.ProductStage__c) && (dataItem.qli.Reason__c == 'NONE' || dataItem.qli.Reason__c == "" || dataItem.qli.Reason__c == undefined))
        {
            var dupindex =  (reasonList).findIndex(function(element){ return (element === dataItem.qli.Id); });  
            if(dupindex <= -1)
            {
                reasonList.push(dataItem.qli.Id);
                component.set("v.requiredStageReasonList",reasonList);
                component.set("v.requiredStageReason",component.get("v.requiredStageReasonList").length);
            }
        
        }else if(stageVal.includes(dataItem.qli.ProductStage__c) && (dataItem.qli.Reason__c != "NONE" || dataItem.qli.Reason__c != ""))
        {
            var dupindex =  (reasonList).findIndex(function(element){ return (element === dataItem.qli.Id); });  
                if (dupindex > -1) 
                {
                    reasonList.splice(dupindex,1);
                    component.set("v.requiredStageReasonList",reasonList);
                    component.set("v.requiredStageReason",component.get("v.requiredStageReasonList").length);
                }
        } else if(!stageVal.includes(dataItem.qli.ProductStage__c))
        {
            var dupindex =  (reasonList).findIndex(function(element){ return (element === dataItem.qli.Id); });  
                if (dupindex > -1) 
                {
                    reasonList.splice(dupindex,1);
                    component.set("v.requiredStageReasonList",reasonList);
                    component.set("v.requiredStageReason",component.get("v.requiredStageReasonList").length);
                }
        }
    }
             component.get("v.dataWrapList")[parentIndex].data.splice(index,1,dataItem);
    },
    // Open child grid on click of parent
    showChildHelper : function(component,event){
        
        var clickedParent = event.target.getAttribute("data-value"); 
        var parentIndex = event.target.getAttribute("data-index");
        component.set("v.clickedParent",clickedParent);
        var dataItem = component.get("v.dataWrapList");
        if(clickedParent == dataItem[parentIndex].parentdata.parentId)
        {
            var isOpen = dataItem[parentIndex].parentdata.isOpen;
            dataItem[parentIndex].parentdata.isOpen = !isOpen;
            component.set("v.dataWrapList",dataItem);
        }
    },
    // Save handler on click of save button
    handleSaveHelper : function(component,event){
 
        if(component.get("v.requiredStageReason") == 0){
        var action = component.get("c.updateQli");
        action.setParams({"qliToUpdate" : component.get("v.changedRows")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var returnVal = response.getReturnValue();
                if(returnVal == null || returnVal==""){
                    window.open(component.get("v.domainUrl"),"_top");
                }else{
                    component.set("v.isAdminError",true);
                    if(returnVal.includes($A.get("$Label.c.LGValidationFromProcessBuilder"))){
                    	component.set("v.adminErrorMsg",returnVal.substring(returnVal.lastIndexOf($A.get("$Label.c.LGValidationException"))+34,returnVal.lastIndexOf('..')+1));
                    }else{
                        component.set("v.adminErrorMsg",returnVal.substring(returnVal.lastIndexOf($A.get("$Label.c.LGValidationException"))+34,returnVal.lastIndexOf('.')+1));
                    }
                }
            }else if(response.getState() === "ERROR"){
                var errorMessage = response.getReturnValue();
                let errors = response.getError();
                let message = "Unknown error"; 
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                    component.set("v.isAdminError",true);
                    component.set("v.adminErrorMsg",errorMessage == ""? message : errorMessage );
                }
            }
        });
        $A.enqueueAction(action); 
          }
    }
})