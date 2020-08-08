<aura:application extends="force:slds">
    <!--//-GLD-PRDCRM-51890 - Send parameters to P2A on Create CEP Case Button from QLI -Added QuoteID-->
    <aura:attribute name="QuoteId" type="Id" access = "public"/>
    <aura:attribute name="QuoteLineId" type="Id" access = "public"/> 
    <aura:attribute name="Source" type="String" access = "public"/>
    <c:LGP2AHighRoadsCanvas QuoteLineId="{!v.QuoteLineId}" QuoteId="{!v.QuoteId}" Source="{!v.Source}"/>
</aura:application>