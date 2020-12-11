({
	init : function(component, event, helper) {
		let action = component.get( "c.captureCeId" );
        
        action.setParams( { CeId : component.get( "v.recordId" ) } );
        
        action.setCallback( this, ( response ) => { 
            if( response.getState() === "SUCCESS" && 
            	response.getReturnValue() ) {
            	$A.get( "e.force:refreshView" ).fire();
        	}
        } );
        
        $A.enqueueAction( action );
	}
})