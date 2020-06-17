/*@author         Accenture
@date           23/05/2017
@name           ANA_AP03_QuoteLineItemApproval
@description    call an aproval process using apex  
*/
Global with sharing class ANA_AP03_QuoteLineItemApproval implements vlocity_ins.VlocityOpenInterface2{
    private static final string APPROVALNAME='Submitting request for approval.';
    public static final String CLASSNAME = ANA_AP03_QuoteLineItemApproval.class.getName();
    public static final String APPROVALMETHOD = 'submitApproval';
    public static final String RECALLMETHOD = 'recallApproval';
    public static final string REMOVED='Removed';
    public static final string CONTEXTID='ContextId';
    public static final string COMMENTS='Recalling';
    public static final string PENDING='Pending';
    public static final string APPROVED='Approved';
    public static final string NOTSTARTED='Not started';

    /*This method is a implementation from vlocity_ins.VlocityOpenInterface2. This gets the input from omniscript and pass it to submitApproval method*/
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,
                                Object> outMap,Map<String,Object> optns) {
                                    if(APPROVALMETHOD.equalsIgnoreCase(methodName))
                                    {
                                        System.Debug('AC39926: Inside invokemethod - Before calling submitApproval');
                                        submitApproval(inputMap, outMap, optns);
                                        System.Debug('AC39926: Inside invokemethod - After calling submitApproval');
                                    }
                                    if(RECALLMETHOD.equalsIgnoreCase(methodName))
                                    {
                                        recallApproval(inputMap, outMap, optns);
                                    }
                                    return true;
                                }
    
    /*Gets the QuoteLineItem id from omniscript. Gets the Quote Line Item Approval record id and submits for approval*/
    public void submitApproval(Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns)
    {
        System.Debug('AC39926: Inside submitApproval method');
        try
        {
            List<Map<String,String>> options1=new List<Map<String,String>>();            
            string rec=(string)input.get(CONTEXTID);           
            Id qLId = Id.valueOf(rec);
            If(qLId!=null)
            {
                System.Debug('AC39926: Inside submitApproval qLId = '+qLId);
                QuoteLineItemApproval__c qla=[Select Id from QuoteLineItemApproval__c where QuoteLineItem__c=:qLId limit 1];
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments(APPROVALNAME);
                req1.setObjectId(qla.Id);
                System.Debug('AC39926: Inside submitApproval: objectId = '+qla.Id);
                System.Debug('AC39926: Inside submitApproval: Comment = '+APPROVALNAME);
                Approval.ProcessResult result = Approval.process(req1);  
                System.Debug('AC39926: Inside submitApproval: After Processing = '+result);
                System.assert(result.isSuccess());
            }
        }
        catch(exception excn)
        {
            System.Debug('Error occured in Method:submitApproval: '+excn.getMessage());
            UTIL_LoggingService.logHandledException(excn, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
                                                    CLASSNAME, APPROVALMETHOD,null,LoggingLevel.ERROR); 
        }
    } 
    /*Recalling an approval process*/
    public void recallApproval(Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns)
    {        
        try{
            List<Map<String,String>> options1=new List<Map<String,String>>();            
            string rec=(string)input.get(CONTEXTID);           
            Id qLId = Id.valueOf(rec);
            If(qLId!=null)
            {
                QuoteLineItemApproval__c qla=[Select Id from QuoteLineItemApproval__c where QuoteLineItem__c=:qLId limit 1];
                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
                if(qla!=null)
                {
                    ProcessInstance procins=[select Id, Status from ProcessInstance where  TargetObjectId = :qla.Id ORDER BY CreatedDate desc   limit 1 ];
                    if(PENDING.equalsIgnoreCase(procins.Status))
                    {
                        ProcessInstanceWorkitem  workitem =[select Id from ProcessInstanceWorkitem where ProcessInstanceId = :procins.id];
                        if(workitem!=null)
                        {
                            pwr.setWorkitemId(workitem.id);
                            pwr.setAction(REMOVED);
                            pwr.setcomments(COMMENTS);
                            Approval.ProcessResult prt = Approval.process(pwr);
                            qla.Quote_Line_Item_Approval_Status__c=NOTSTARTED;
                            database.update(qla);
                            System.assert(prt.isSuccess());
                        }
                    }
                    else if(APPROVED.equalsIgnoreCase(procins.Status))
                    {
                        qla.Quote_Line_Item_Approval_Status__c=NOTSTARTED;
                        database.update(qla);
                    }
                }
            }
        }
        catch(Exception excn)
        {
            
            UTIL_LoggingService.logHandledException(excn, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
                                                    CLASSNAME, RECALLMETHOD,null,LoggingLevel.ERROR); 
        }
        
    }    
    
}