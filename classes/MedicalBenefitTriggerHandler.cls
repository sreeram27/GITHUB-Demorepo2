/*
@Author : Partha (Vikings)
@name : RxTriggerHandler
@CreateDate : 19/07/2019
@Description : This is handler class for MedicalBenefitTrigger.
ModifiedBy Sharath KN on 18-Aug-2019 to limit only one Medical Benefit per Implementation Case
*/
public class MedicalBenefitTriggerHandler{  
    
    public Map<Id,Id> MapITIdToMedBenId = New Map<Id,Id>();
    public List<Issue_Control__c> CaseInstallationList = new List<Issue_Control__c>();
    public List<Issue_Control__c> CaseInstallationListToUpdate = new List<Issue_Control__c>();  
    public String local = staticVariableClass.Entity;
    
  
    /* PRDCRM-38796 :  This method Update the child case install record upon creation of med Benefit records*/ 
    public void updateMedBenOnCaseInstall(List<Medical_Benefit__c> newMedBenList){
        
        for(Medical_Benefit__c medBen: newMedBenList){           
            MapITIdToMedBenId.put(medBen.Implementation_Tracking_ID__c,medBen.Id);  /* PRDCRM-38796 : Retrieving implementation trackings Ids*/
        }
        
        system.debug('MapITIdToMedBenId---> ' + MapITIdToMedBenId);
        
        /* PRDCRM-38796 : Fetching case installation record related to implementation tracking record: Partha */
        if(!MapITIdToMedBenId.isEmpty()){
            CaseInstallationList = [select id,Name,Implementation_Tracking_ID__c,Medical_Benefits__c,Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c from Issue_Control__c where Implementation_Tracking_ID__c IN: MapITIdToMedBenId.keyset() and Implementation_Tracking_ID__r.Implementation_Record_ID__r.Account.Anthem_Entity__c =: local];
            
        }
        system.debug('CaseInstallationList---> ' + CaseInstallationList);
        
        
        /* PRDCRM-38796 :Iterating over case install records and relating Medical Benefit  Records  */
        if(!CaseInstallationList.isEmpty()){
            for(Issue_Control__c caseins : CaseInstallationList){
                if(MapITIdToMedBenId.get(caseins.Implementation_Tracking_ID__c) != null ){
                    caseins.Medical_Benefits__c = MapITIdToMedBenId.get(caseins.Implementation_Tracking_ID__c);
                    CaseInstallationListToUpdate.add(caseins);
                }
            }
            
        }
        
        system.debug('CaseInstallationListToUpdate---> ' + CaseInstallationListToUpdate);
        
        if(!CaseInstallationListToUpdate.isEmpty()){
            try{
                database.update(CaseInstallationListToUpdate,False);
            }
            catch(Exception ex){
                System.debug('Exception '+ex.getmessage());
            }
        }
        
    }
    
   /* Public void limitMBRecords(List<Medical_Benefit__c> mbList){
        Set<Id> implTrackIdS = new Set<Id>();
        Set<Id> implTrackIdSFinal = new Set<Id>();
        for(Medical_Benefit__c thisMB : mbList){
            implTrackIdS.add(thisMB.Implementation_Tracking_ID__c);
        }
        for(Medical_Benefit__c thisMB : [SELECT Id,Implementation_Tracking_ID__c FROM Medical_Benefit__c where Implementation_Tracking_ID__c in: implTrackIdS]){
            implTrackIdSFinal.add(thisMB.Implementation_Tracking_ID__c);
        }
        for(Medical_Benefit__c thisMB : mbList){
            if(implTrackIdSFinal.contains(thisMB.Implementation_Tracking_ID__c)){
                thisMB.addError(System.label.ErrorMedicalBenefit);
            }
        }
    }*/
}