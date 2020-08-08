/**
    *----------------------------------------------
    * @name              LGHWProgressIndicatorCmp
    * @author            Deloitte offshore (Gladiators)
    * @modifiedBy        Deloitte offshore (Gladiators)
    * @version           1.0
    * @CreatedDate       25th Nov,2019
    * @Usedby            Lightning Component LGHWProgressIndicatorCmp
    *------------------------------------------------
    * @Description
    This is used for calling helper from Controller for Future Indicator Job Status value update.
    *
    * Additional information
    *
    * Changes
    * vX.X(Version)         Name
    * Date                  Explanation
    -----------------------------------------------------
    
 */
({
    progressBarSetup:function(component,event,helper) {
        
        component.set('v.stepStatus', [
            { label: 'Not Started', value: 'Not Started' },
            { label: 'Queued', value:'Queued' },
            { label: 'Processing', value:'Processing'},
            { label: 'Completed', value: 'Completed'},
            { label: 'Failed', value: 'Failed' }
        ]);
        component.set('v.currentStatus','Not Started');
        this.callApexMethod(component,event,helper);
    },
    
    callApexMethod:function(component,event,helper) {
        var action = component.get('c.getApexJobsStatus'); 
        action.setParams({
            'sQuoteIdentifier': component.get('v.recordId')
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                if(result === null || result.Id === ''){
                    component.set('v.showProgress',false);
                }
                else if(result.Id != '' && result.Id != undefined){
                    if(result.Status != 'Completed'){
                        component.set('v.currentStatus','Processing');
                        this.pollApex(component,event,helper); 
                    }
                    else if(result.Status === 'Completed'){
                        this.callExceptionLog(component,event,helper,result.Id);
                    }
                }
            }
            else if(response.getState() === 'ERROR'){
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
    
    callExceptionLog : function(component,event,helper,sJobIdentifier){
     
        var actionExp = component.get('c.getExceptionLogDetails');
        actionExp.setParams(
            {
                'sJobIdentifier': sJobIdentifier
            });
        actionExp.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                if(response.getReturnValue() >0){
                    component.set('v.currentStatus','Failed');
                    this.doReloadPage(component,event,helper,sJobIdentifier);
                }else{
                    component.set('v.currentStatus','Completed');
                    this.doReloadPage(component,event,helper,sJobIdentifier);
                }
            }
            else if(response.getState() === 'ERROR'){
                let errors = response.getError();
                let message = 'Unknown error'; 
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.error(message);
            }
        });
        $A.enqueueAction(actionExp);
    },
    
    pollApex : function(component,event,helper) {
        const timeInterval = Number($A.get('$Label.c.HWFutureJobPollingTime'));
        window.setInterval(
            $A.getCallback(function() { 
                helper.callApexMethod(component,event,helper);
            }), timeInterval
        );   
    },
    
    doReloadPage : function(component,event,helper,sJobIdentifier){
        if(sessionStorage.getItem('QuoteIds') == null){
            var quoteIdArray =[];
            quoteIdArray.push((component.get('v.recordId')+','+sJobIdentifier));
            sessionStorage.setItem('QuoteIds',JSON.stringify(quoteIdArray));
            window.location.reload();
        }
        if(!(JSON.parse(sessionStorage.getItem('QuoteIds')).includes(component.get('v.recordId')+','+sJobIdentifier))){
            var index =  (JSON.parse(sessionStorage.getItem('QuoteIds'))).findIndex(function(x){
                return (x.split(',')[0] === component.get('v.recordId'));
            });
            var quoteVsjobArray = JSON.parse(sessionStorage.getItem('QuoteIds'));
            if(index != -1){
                quoteVsjobArray.splice(index,0,component.get('v.recordId')+','+sJobIdentifier);
            }else{
                quoteVsjobArray.push(component.get('v.recordId')+','+sJobIdentifier);
            }
            sessionStorage.setItem('QuoteIds',JSON.stringify(quoteVsjobArray));
            window.location.reload();
        }
    }
})