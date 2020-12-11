/*
@author         Accenture offshore
@Request        961
@date           29/06/2017
@name           ANA_QuoteLineItemApprovalTrigger_Handler
@description    This class is used in ANA_QuoteLineItemApprovalBeforeUpdate and has the logic to pull latest Approval Comment from Approval History and 
populate "Approval Comments" field on Quote Line Item Approval.
*/
public with sharing class ANA_QuoteLineItemApprovalTrigger_Handler {
    public static final String CLASSNAME = ANA_QuoteLineItemApprovalTrigger_Handler.class.getName();
    public static final String UPDATEAC='updateApprovalComments';
    public static final String PROCINSTQUERY='SELECT  status, CreatedDate, TargetObjectId, Id FROM ProcessInstance  where \n'+ 
                                          'TargetObjectId =:targetId and (status=\'Approved\' or status= \'Rejected\') order by  createddate desc limit 1';
    public static final String PROCINSTSTEPQUERY='SELECT stepstatus,Id, Comments, ProcessInstanceId FROM ProcessInstanceStep \n'+
                                                   'where ProcessInstanceId =: procInstId and (stepstatus=\'Approved\' or stepstatus=\'Rejected\') limit 1';
    private static final string APRVD='Approved';
    private static final string REJTD='Rejected';
    /*update the Approval Comments field with latest approval histroty comments*/
    public static void updateApprovalComments(List<QuoteLineItemApproval__c> newList,Map<Id,QuoteLineItemApproval__c> oldMap)
    {
        try
        {
            String stat=newList[0].Quote_Line_Item_Approval_Status__c;
            if((APRVD.equalsIgnoreCase(stat)||REJTD.equalsIgnoreCase(stat))&&stat!=oldMap.get(newList[0].Id).Quote_Line_Item_Approval_Status__c )
            {
                 ANA_UTIL06_AccessQLIADataUtil.targetId=Trigger.new[0].Id;
                ProcessInstance  prcInst=ANA_UTIL06_AccessQLIADataUtil.queryProcInst(PROCINSTQUERY)[0];
                if(prcInst!=null)
                {
                   ANA_UTIL06_AccessQLIADataUtil.procInstId=prcInst.Id;
                    ProcessInstanceStep procIStep=ANA_UTIL06_AccessQLIADataUtil.queryProcInstStep(PROCINSTSTEPQUERY)[0];
                    newList[0].ApprovalComments__c=procIStep.comments;
                }
            }
            
        }
        catch(Exception excn)
        {
            UTIL_LoggingService.logHandledException(excn, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, 
                                                    CLASSNAME, UPDATEAC,null,LoggingLevel.ERROR); 
        }
    }
}