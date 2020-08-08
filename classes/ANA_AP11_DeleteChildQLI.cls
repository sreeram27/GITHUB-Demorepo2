/*@author         Accenture
@date           30/06/2017
@name           ANA_AP11_DeleteChildQLI
@description    Used to delete child QLIs
*/
Global with sharing class ANA_AP11_DeleteChildQLI implements vlocity_ins.VlocityOpenInterface2{
    
    public static final String CLASSNAME = ANA_AP11_DeleteChildQLI.class.getName();
    public static final String DELETECHILDQLI = 'deleteChildQLI';
    public static final string CONTEXTID='ContextId';
    private User allowQLIdelete;
    /*This method is a implementation from vlocity_ins.VlocityOpenInterface2. This method is used to delete programs*/
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,
                                Object> outMap,Map<String,Object> optns) {
                                    if(DELETECHILDQLI.equalsIgnoreCase(methodName))
                                    {
                                        deleteChildQLI(inputMap, outMap, optns);
                                    }
                                    
                                    return true;
                                }
    
    /*Deletes the child quote line item i.e. Program*/
    public void deleteChildQLI(Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns)
    {
        allowQLIdelete = new User();
        allowQLIdelete = [SELECT AllowQLIDelete__c FROM User WHERE Id = :UserInfo.getUserId()];
        boolean IsAlredyTRUE =  allowQLIdelete.AllowQLIDelete__c;
        try
        {
            if(!IsAlredyTRUE){
                allowQLIdelete.AllowQLIDelete__c = true;
                update allowQLIdelete;
            }   
            Database.delete(new QuoteLineItem(Id=Id.valueOf((string)input.get(CONTEXTID))));
            
            if(!IsAlredyTRUE){
                allowQLIdelete.AllowQLIDelete__c = false;
                update allowQLIdelete;
            }
        }
        catch(exception excn)
        {
            UTIL_LoggingService.logHandledException(excn, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
                                                    CLASSNAME, DELETECHILDQLI,null,LoggingLevel.ERROR); 
        }
    } 
    
}