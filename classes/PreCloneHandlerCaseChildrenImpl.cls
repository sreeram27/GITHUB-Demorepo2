public class PreCloneHandlerCaseChildrenImpl extends PreCloneChildHandlerBase{
    public override List<sObject> preCloneChildProcessor(List<sObject> childElements) {
        List<sObject> lstUpdatedElements=new List<sObject>();
        String threadIdentifierRegex=System.Label.Email_To_Case_Thread_Id_Regex;
        for(Integer i=childElements.size()-1 ; i >=0 ; i--){
            if(childElements[i] instanceOf EmailMessage){
                EmailMessage email = (EmailMessage)childElements[i];
                email.ThreadIdentifier =ApexUtil.getThreadId(email.ParentId);
                email.HtmlBody=String.isNotBlank(email.HtmlBody) ?  email.HtmlBody.replaceAll(threadIdentifierRegex,email.ThreadIdentifier) : email.HtmlBody;
                email.TextBody=String.isNotBlank(email.TextBody) ?  email.TextBody.replaceAll(threadIdentifierRegex,email.ThreadIdentifier) : email.TextBody;
                email.Subject =String.isNotBlank(email.Subject)  ?   email.Subject.replaceAll(threadIdentifierRegex,email.ThreadIdentifier) : email.Subject;
                email.ValidatedFromAddress =NULL;
                childElements.remove(i);
                lstUpdatedElements.add(email);
            }
        }
        childElements.addAll(lstUpdatedElements);
        return childElements; 
    } 
}