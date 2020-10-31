trigger CSP_AccountObjectiveAfterUpdate on AccountObjective__c (after update) {

    CSP_AccountPlan.upsertAccountSolution(Trigger.new);
}