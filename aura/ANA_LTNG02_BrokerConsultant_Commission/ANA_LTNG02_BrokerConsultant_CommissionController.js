({
  	doInit : function(component, event, helper) { 
        helper.initCallServer(component, event, helper);
    },    
    clickNext : function(component, event, helper) {             
        component.set("v.selectBR", false);
        helper.setFundingType(component);
    },    
	goToAccount : function(component, event, helper) {        
         window.location.href = '/'+ component.get('v.accId');     
    },
    setAccount : function(component, event, helper) {
         var seAcc = event.getParam("selectedAcc");
         component.set("v.selBConsultantItem", null);
         component.set("v.accId",seAcc.val);
         console.log('seAcc:'+JSON.stringify(seAcc)); 
		 console.log('val:'+seAcc.val);         
    },  
    goPreviousNext : function(component, event, helper) {      
	 component.set("v.selectBR", true);        
     component.find("selectConsultant").set("v.options",  component.get("v.consultantValues"));
    },
	saveNewBR : function(component, event, helper){ 
        helper.saveRecordBR(component, event, helper);
    }
})