/*****************************************************************************************
Controller Name  : LGA_Ltng_Quote_Omniscript
Created Date     : 27-May-2019
Created By       : IDC Offshore
Description      : This javascript controller for LGA_Ltng_Quote_Omniscript (LGA project)
*******************************************************************************************/
({
	gotoACAEnrollURL : function(component, event, helper) {
        window.location.href = '../../broker/s/enrollnow';
	},
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
   openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   } 
    
})