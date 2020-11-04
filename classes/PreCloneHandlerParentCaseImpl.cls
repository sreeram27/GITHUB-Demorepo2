public class PreCloneHandlerParentCaseImpl extends PreCloneParentHandlerBase{
    public override sObject preCloneParentProcessor(sObject param) {
        param.put('Email_Description__c',NULL);
        return param;
    }
}