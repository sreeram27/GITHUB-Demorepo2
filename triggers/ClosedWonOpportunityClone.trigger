trigger ClosedWonOpportunityClone on Opportunity (before insert) {

    for (Opportunity o : Trigger.new) {

       if (o.isClone() && o.IsWon == true ) {

            
            
            if ( o.Contract_End_Date__c != null) {
            Integer RenewalYear = o.Contract_End_Date__c.year();
             o.Name = o.Name + ' Renewal ' + RenewalYear;
            }
            else { o.Name = o.Name + ' Renewal ' + System.Today().year() ;
            }
            o.StageName = 'Propose';
            o.Opportunity_Type_New_Renewal_Upsell__c = 'Renewal';
            o.CloseDate = System.Today()+90;
            o.Partner_Sourced__c = 'Rep Attributed';
            o.SDR__c = 'No SDR Involved';
            if(o.Contract_Start_Date__c != null) 
            {o.Contract_Start_Date__c = o.Contract_Start_Date__c.addYears(1);}
            else {o.Contract_Start_Date__c = o.Contract_Start_Date__c;}
            if(o.Contract_End_Date__c != null)
            {o.Contract_End_Date__c = o.Contract_End_Date__c.addYears(1);} 
            else {o.Contract_End_Date__c = o.Contract_End_Date__c;}                     
            } 

      }

}