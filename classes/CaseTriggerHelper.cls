public with sharing class CaseTriggerHelper {
    public void updateMailBox(List<Case> lstCase) {
        List<Mailbox_Origin_Emails__c> mailsList = Mailbox_Origin_Emails__c.getall().values();
        
        if(!mailsList.isEmpty()) {
            Map<String,String> mails = new Map<String,String>();
            for(Mailbox_Origin_Emails__c m:mailsList){
                mails.put(m.Mailbox_origin_Name__c.toUpperCase(),m.Mailbox_Value__c);
            }
            for(case cs : lstCase) {
                List<String> allEmail = new List<String>();
                if(cs.Mailbox_Origin__c != null) {
                    List<String> mailBoxOriginMails = cs.Mailbox_Origin__c.split('; ');
                    String mbMail = ';';
                    for(String mbo:mailBoxOriginMails) {
                        String mailWithoutSemiColon = mbo.split(';').get(0).toUpperCase();
                      
                        if(mails.containsKey(mailWithoutSemiColon.toUpperCase()) && (allEmail.isEmpty() || (!allEmail.Contains(mails.get(mailWithoutSemiColon))))) {
                            
                            mbMail =  mbMail + mails.get(mailWithoutSemiColon)  + '; '  ;
                            allEmail.add(mails.get(mailWithoutSemiColon));
                        }
                    }
                    mbMail = mbMail.removeEnd(';');
                    cs.Mailbox__c = mbMail;   
                } else{
                    cs.Mailbox__c = '';
                }
            }
        } else{
            for(case cs : lstCase){
                cs.Mailbox__c = '';
            }
        }
    } 
    
    public void removeAccountContact(List<Case> caseList, Map<Id,Case> mapIdCase) {
        system.debug('mapIdCase '+mapIdCase);
        set<string> accIdSet = new set<string>();
        for(Case cs : caseList){
            if(NULL != cs.AccountId)
                accIdSet.add(cs.AccountId);
        }
        if(accIdSet.size()>0){
            Map<Id,Account> mapAcc = new Map<id,Account>([select id, Name from Account where id in :accIdSet]);        
            for(Case cs:caseList){
                Account acc = mapAcc.get(cs.AccountId);
                if(NULL != acc  && acc.Name == Label.AccountAnthemAssociates){
                    cs.AccountId = null;
                    cs.ContactId = null;
                }
            }
        }
    }
    
   
}