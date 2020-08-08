trigger UpdateClosedDate on Defect__c (before update) {

    List<Defect__c> oldDef = new List<Defect__c>((Defect__c[])Trigger.old);
    List<Defect__c> newDef = new List<Defect__c>((Defect__c[])Trigger.new);  

    String  curStatus = newDef.get(0).Current_status__c;
    String  prevStatus = oldDef.get(0).Current_status__c;
    
    if(curStatus != null && curStatus.length()>=6){        
        curStatus = newDef.get(0).Current_status__c.substring(0,6); 
    }
    
    if(prevStatus != null && prevStatus.length()>=6){        
        prevStatus = oldDef.get(0).Current_status__c.substring(0,6);    
    }
    
    if(curStatus != null && curStatus.equalsIgnoreCase('CLOSED')){ //Check for Null done by Accenture-MCS Code Scan PRDCRM-44931
        newDef[0].Target_Completion_Date__c = null;
        if(prevStatus != null && newDef[0].Closed_Date__c != null && !prevStatus.equalsIgnoreCase('CLOSED')){ //Check for Null done by Accenture-MCS Code Scan PRDCRM-44931
            newDef[0].Closed_Date__c = datetime.now();
        }
    }
    
    if(curStatus != null && prevStatus != null && !curStatus.equalsIgnoreCase('CLOSED') & prevStatus.equalsIgnoreCase('CLOSED')){ //Check for Null done by Accenture-MCS Code Scan PRDCRM-44931
        newDef[0].Closed_Date__c = null;
    }
}