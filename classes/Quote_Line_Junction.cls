/*
@Author : Chandrashekar Jangiti
@name : Quote_Line_Junction
@CreatedDate : 11/09/2019 
@Description : This class identifies the parent and child quote line items that are related through the junction object (plan_relationship__c)
@			   and deletes the junction object  
*/
public with sharing class Quote_Line_Junction {

    /*
	@method Name : deleteParentToChild
	@param : ParentQuoteLineItem the Set of ParentQuoteLineItem Ids
	@return type : void
	@method Description : This method identifies the parent and child quote line items that are related through the junction object (plan_relationship__c)
	@			          and deletes the related child quote line items and the junction object.   
	@last Modified Date: 11/07/19
	*/
    public Static void deleteParentToChild(Set<ID> ParentQuoteLineItem) {
        List<QuoteLineItem> deleteQuoteQli = new List<QuoteLineItem>();
        Set<Id> ActWiseChildQuote = new Set<Id>();
        Set<Id> Qli1 = new Set<Id>();
        Set<Id> Qli2 = new Set<Id>();

        List<QuoteLineItem> qliParent = [Select Id, LineNumber, ParentQuoteLineItem__c, ActWiseChildQuote__c from QuoteLineItem where ParentQuoteLineItem__c =: ParentQuoteLineItem OR id =: ParentQuoteLineItem];

        if (qliParent.Size() >= 0) {
            for (QuoteLineItem qi: qliParent) {
                if (qi.ActWiseChildQuote__c != null) {
                    ActWiseChildQuote.add(qi.ActWiseChildQuote__c);
                    Qli1.add(qi.id);
                }
            }

            if (ActWiseChildQuote.Size() >= 0) {
                List<QuoteLineItem> child = [Select LineNumber, Id, ParentQuoteLineItem__c, ActWiseChildQuote__c from QuoteLineItem where Id =: ActWiseChildQuote];

                for (QuoteLineItem q2: child) {
                    Qli2.add(q2.Id);
                }

                List<Plan_Relationship__c> plan = [Select Name, Id, Qli1__c, Qli2__c from Plan_Relationship__c where Qli2__c =: Qli2];
                List<id> planid = new List<id>();
                List<id> planid1 = new List<id>();
                if (plan.Size() == 1) {
                    for (Plan_Relationship__c pr: plan) {
                        planid.add(pr.id);
                        planid.add(pr.Qli1__c);
                        planid.add(pr.Qli2__c);
                    }

                    List<HRA_Administration__c> hraList = [select id, QLI__c from HRA_Administration__c where qli__c =: Qli2];

                    if (hraList.size() > 0) {
                        database.delete(hraList);
                    }
                    try {
                        if (planid.size() > 0) {
                            database.delete(planid, false);
                        }
                    }
                    Catch(Exception e) {
                        System.debug('Error is....... ' + e.getMessage());
                    }
                } else if (plan.Size() > 1) {
                    for (Plan_Relationship__c pr1: plan) {
                        if (QLI1.Contains(pr1.Qli1__c)) {
                            planid1.add(pr1.Qli1__c);
                            planid1.add(pr1.id);
                        }
                    }
                    try {
                        if (planid1.size() > 0) {
                            database.delete(planid1, false);
                        }
                    }
                    Catch(Exception e) {
                        System.debug('Error is....... ' + e.getMessage());
                    }
                }
            }
        }
    }
}