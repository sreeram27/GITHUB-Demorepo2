Public class Casehelper{

    public static Boolean runOnce = true;
    list<case> caselist = new list<case>();
    set<id> CaseId=new set<id>();
    
    public void onAfterUpdate(list<case> Caslist){
            Casehelper.runOnce = true;
         system.debug('Caslist>>>'+ Caslist);    
            
    for(Case cas:Caslist){
          if(Cas!=null){
            CaseId.add(Cas.Id);
        }
        system.debug('CaseId'+ CaseId);
    }
            
     if(CaseId != null){
     
         caselist = [SELECT Id,Description,experience__c,sales_areas_are_you_experienced_in__c,education_you_have_completed__c FROM Case WHERE Id =:CaseId]; 
     }
     system.debug('caselist'+ caselist);
    /*
    
       
    for(Case Cas: [SELECT Id,Description,experience__c,sales_areas_are_you_experienced_in__c,education_you_have_completed__c FROM Case WHERE Id in: Trigger.new]){
         system.debug('Exper1'+ Cas.experience__c);
        if(Cas != null && Cas.Description != null){
           Cas.experience__c = '10';
           caselist.add(Cas);
           recursive = true;

        }
       system.debug('Exper2'+ Cas.experience__c);
    }
    
    update caselist;
     system.debug('Exper2'+ caselist);*/
}
}