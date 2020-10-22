/**
@author         Accenture offshore
@date           5/15/2019
@name           AP_LG01_EmailMessageTriggerHandler
@description    Called from trigger on Email Object to add errors on certain conditions.  
*/
public with sharing class AP_LG01_EmailMessageTriggerHandler{
   
    /** 
     * @description beforeInsertOrUpdate
     * @param newList
     */
     
   
    public static void beforeInsertOrUpdate(List<EmailMessage> newList)
    {
     
            
        System.debug('START -> TR_LG01_EmailMessageTrigger , event before insert' );
        List<Id> emailReletedToIdList = New List<Id>();
        for(EmailMessage emailMsg : newList)
        {
            if(emailMsg.RelatedToId != null){
            emailReletedToIdList.add(emailMsg.RelatedToId);
            } 
        }
        System.debug('RelateToId List size : ' + emailReletedToIdList.size());
       try{
        if(emailReletedToIdList.size() > 0)
        {   
            Map<ID,Opportunity> relatedOpporMap = new Map<ID,Opportunity>([Select Id,
                                                                   Account.Name,
                                                                   Account.Situs_State__c,
                                                                   Account.Branding__c,
                                                                   CloseDate 
                                                                   from Opportunity 
                                                                   where Id in : emailReletedToIdList]);
          
           
           for(EmailMessage emailMsg : newList)
        {
            String outgoingEmailSubject = emailMsg.Subject;
            if(relatedOpporMap.containsKey(emailMsg.RelatedToId)){
            Opportunity relatedOppId = relatedOpporMap.get(emailMsg.RelatedToId);
            String relatedOppAccountLegalName = relatedOppId.Account.Name;
            String relatedOppAccountSitusState = relatedOppId.Account.Situs_State__c;
            String relatedOppAccountBranding = relatedOppId.Account.Branding__c;
            String relatedOppCloseDate = relatedOppId.CloseDate.format();
            
            String subjectToCheckWith = System.Label.LG01_Start_Enrollment_Email_Subject + ' ' + 
                relatedOppAccountLegalName + ' - ' + relatedOppCloseDate;
                
                 if(outgoingEmailSubject != null && outgoingEmailSubject.equals(subjectToCheckWith)){                     
                     checkEmailMessageValidation(emailMsg,relatedOppAccountSitusState,relatedOppAccountBranding);
                 }
            
            }
       
        }   
        }
        }catch(Exception ex){
            System.debug('Exception in beforeInsertOrUpdate of AP_LG01_EmailMessageTrigger_Handler : ' + ex);
        }
       
    }    
    
    /** 
     * @description checkEmailMessageValidation
     * @param emailMsg
     * @param relatedOppAccountSitusState
     * @param relatedOppAccountBranding
     */
    
    public static void checkEmailMessageValidation(EmailMessage emailMsg,String relatedOppAccountSitusState, String relatedOppAccountBranding)
    {
     
      
            if(relatedOppAccountSitusState != null && relatedOppAccountBranding != null){
              String dataSetName = relatedOppAccountSitusState + '_' + relatedOppAccountBranding;
              System.debug('**dataSetName to retrieve CS: ' + dataSetName);
              CS_LG01_Start_Enrollment_Email_Footer__c footerCS = CS_LG01_Start_Enrollment_Email_Footer__c.getValues(dataSetName);
              System.debug('** footer CS : ' + footerCS);

                if(footerCS == null) {
                    emailMsg.addError(System.Label.LG01_Start_Enrollment_Email_validation_Msg);
                }
            }
    }
    
    
}