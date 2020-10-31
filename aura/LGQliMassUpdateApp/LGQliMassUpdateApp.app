<!--*
 * ______________________________________________________________________________________________________________________________________
 * Name              LGQliMassUpdateApp
 * Author            Deloitte offshore (Gladiators)
 * Version		 	 v1.0
 * CreatedDate       21st August 2019
 * Component		 LGQliMassUpdate
 * User Story        PRDCRM-41009-Plan Mass update 
 * ______________________________________________________________________________________________________________________________________
 * Description	     
 * Lightning App which holds lightning component to update multiple Quote Line Items of the specified Quote from Vlocity Action "Plan Update on Quote"
 * 
 * ________________________________________________________________________________________________________________________________________
 *
 * Additional information
 *______________________________________________________________________________________________________________________________________
 * Changes
 * vX.X(Version)			Name
 * Date						Explanation
 *_______________________________________________________________________________________________________________________________________
*/-->
<aura:application extends="force:slds">
     <aura:attribute name="Id" type="Id" access = "public"/>
     <c:LGQliMassUpdate quoteId="{!v.Id}"/>
</aura:application>