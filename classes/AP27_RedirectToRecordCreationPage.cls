public class AP27_RedirectToRecordCreationPage {
    @AuraEnabled
    public static Map<String,String> getGsList(Id recId) {	
	    system.debug('!!!recId'+recId);
		String sObjName = recId.getSObjectType().getDescribe().getName();
        string childSObjName='';
        string rectid='';
		Map<String,String> objectRectypIdMap = new Map<String,String>();
        system.debug('!!!sObjName'+sObjName);
		if(sObjName=='Group_Services__c'){
            Group_services__c   GsList = [SELECT Id,Claim_System__c  FROM Group_services__c WHERE Id =:recId LIMIT 1];
            System.debug('Groupservice id' + GsList.Id);   
            if(GsList.Claim_System__c == 'NASCO')
            {
                rectid = label.GroupServicesRepeatNasco;
            }
            else IF(GsList.Claim_System__c == 'WGS 2.0')
            {
                 rectid = label.GroupServicesRepeatWGS;
                 system.debug('im in wgs rectid'+rectid);   
            } else{
                
                rectid = label.GroupServicesRepeatNasco;
            }
            childSObjName='Group_Services_Repeatable__c';
		   	objectRectypIdMap.put(childSObjName,rectid);
			
        }else if(sObjName=='Implementation_Coordinator__c'){ 
            Implementation_Coordinator__c   IcdList = [SELECT Id,Claim_System__c  FROM Implementation_Coordinator__c WHERE Id =:recId LIMIT 1];
            System.debug('Groupservice id' + IcdList.Id);   
            if(IcdList.Claim_System__c == 'NASCO')
            {
                rectid = label.ImplCoordinatorRepNASCO;
            }
            else IF(IcdList.Claim_System__c == 'WGS 2.0')
            {
                rectid = label.ImplCoordinatorRepWGS;
            }else{
                
                rectid = label.ImplCoordinatorRepNASCO;
            }
            childSObjName='Implementation_Coordinator_Repeatable__c';
		    objectRectypIdMap.put(childSObjName,rectid);
		}
      return objectRectypIdMap;
    }
}