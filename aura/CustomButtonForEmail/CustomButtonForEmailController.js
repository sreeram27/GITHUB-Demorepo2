({
	openActionWindow : function(component, event, helper) {      
      var staticLabel = $A.get("$Label.c.EmailTemplate");
      window.open( location.protocol + "//" + location.hostname + (location.port && ":" + location.port) + '/_ui/core/email/author/EmailAuthor?isdtp=mn&template_id=' + staticLabel +'&p3_lkid='+component.get("v.recordId"),'popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes');
    } 
})