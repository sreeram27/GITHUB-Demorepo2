trigger UpdateReopenedCount on Defect__c (before update) {
    
    List<Defect__c> oldDef = new List<Defect__c>((Defect__c[])Trigger.old);
    List<Defect__c> newDef = new List<Defect__c>((Defect__c[])Trigger.new);
    
    
    String  curStatus = newDef.get(0).Current_status__c;
    String  prevStatus = oldDef.get(0).Current_status__c;
    Decimal reopenCount;
    
    if (oldDef.get(0).Times_Reopened__c <> null){
        reopenCount = oldDef.get(0).Times_Reopened__c;
    }
    
    else{
        reopenCount = 0;
    }
    if(curStatus != null && curStatus.length()>=9 ){        
        curStatus = newDef.get(0).Current_status__c.substring(0,9);       
    }
    
    if(prevStatus != null && prevStatus.length()>=9 ){        
        prevStatus = oldDef.get(0).Current_status__c.substring(0,9);            
    }
    
    if(curStatus != null && prevStatus !=null && curStatus.equalsIgnoreCase('RE-OPENED') & !prevStatus.equalsIgnoreCase('RE-OPENED')){ //Check for Null done by Accenture-MCS Code Scan PRDCRM-44931
        newDef[0].Times_Reopened__c = reopenCount + 1;  
    }
}