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
	* vX.X(Version)			Name
	* Date				    Explanation
	-----------------------------------------------------
	
 */
({
    // do Init Methood that loads and calls helper     
    doInit : function(component, event, helper) {
        helper.progressBarSetup(component, event, helper);
	}

})