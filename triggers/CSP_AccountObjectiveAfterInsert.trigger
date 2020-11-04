trigger CSP_AccountObjectiveAfterInsert on AccountObjective__c (after insert) {

    CSP_AccountPlan.upsertAccountSolution(Trigger.new);
}