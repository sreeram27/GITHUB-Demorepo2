<aura:application extends="force:slds">
     <aura:attribute name="Id" type="String"/>
    <aura:attribute name="QuoteId" type="String"/>
    <c:LGOrderImpactedProducts Id="{!v.Id}" QuoteId="{!v.QuoteId}"/>
</aura:application>