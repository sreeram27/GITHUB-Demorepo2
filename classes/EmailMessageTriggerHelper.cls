public class EmailMessageTriggerHelper {
    public void checkAndCopyDescription(List<EmailMessage> lstMsg){
        Set<Id> setId = new Set<Id>();
        List<Case> lstCase = new List<Case>();
        Map<Id,String> mapIdDesc = new Map<Id,String>();
        for(EmailMessage em : lstMsg) {
            if(String.isNotBlank(em.TextBody)){
                setId.add(em.parentId);
                mapIdDesc.put(em.parentId,em.TextBody);
            }
        }
        
        if(setId.size()>0){
            for(Case c : [select id, description, Email_Description__c from case where ID in :setId]){
                if(String.isNotBlank(mapIdDesc.get(c.Id))) {
                    c.Email_Description__c = mapIdDesc.get(c.Id);
                    c.description = 'See Email Description Field for full email transcript.';
                    lstCase.add(c);
                }
            }
            if(!lstCase.isEmpty()) {
                update lstCase;
            }
        }
    }
    
     public void GetAndSaveTrimmedText(List<EmailMessage> lstMsg){
         for(EmailMessage em : lstMsg) {
             system.debug('Something');
            if(String.isNotBlank(em.TextBody) && (em.TextBody.length() >= 130000)) {
                em.TextBody = em.TextBody.substring(0,130000);
            }
         }
     }
}