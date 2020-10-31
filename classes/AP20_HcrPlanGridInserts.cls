/**
@Author : Accenture Offshore Dev team
@name : AP20_HcrPlanGridInserts
@CreateDate :4/9/2018
@Description :This class is called in InsertHCRplans Proccessbulder to insert hcr plan grids.
*/


/* class to insert the hcrs*/
global  class AP20_HcrPlanGridInserts {

  public static final string CLASS_NAME='AP20_HcrPlanGridInserts';
  public static final string TEST_CLASS='HcrPlanGridInserts_Test';
  public static final string ActivePlans='Yes';
  
  @InvocableMethod(label='Insert plans' description='inserts the plans related to parent id and return child ids')
  
  /* method to insert the hcrs*/
  global static void clonePlanGrids(List<processBuilderInput> requestParam) {
        try{ 
            List<String>groupNames = new List<String>();
            ID hcrID ;    
            for(processBuilderInput pbInput:requestParam){
                groupNames.add(pbInput.groupName);
                hcrID =pbInput.hcrId;
            }
     
            List<HCR_Plan_Grids__c> childPlans = new List<HCR_Plan_Grids__c>();
            List<HCR_Plan_Grids__c> clonedChildPlans = new List<HCR_Plan_Grids__c>();
              for(HCR__c hcr: [Select id,name,CreatedDate,(Select id, name,Active__c,Cancellation_Date__c,Date__c,Determination_By__c,Effective_Date__c,HCR__c,HCR_Plan_Status__c,HCR_Status__c,Plan__c,Plan_Number__c,Impacted_Packages_Suffixes__c  from HCR_Plan_Grids__r where Active__c =: ActivePlans) from HCR__c where Group__c IN : groupNames AND id != : hcrID ORDER By CreatedDate DESC Limit 1]){           
                  childPlans.addAll(hcr.HCR_Plan_Grids__r);
                }
               if(!childPlans.isEmpty()){
                    for(HCR_Plan_Grids__c planGrids: childPlans){
                        HCR_Plan_Grids__c clonedPlans = planGrids.clone();
                        clonedPlans.HCR__c=hcrID;
                        clonedChildPlans.add(clonedPlans);
                    }
                }   
            insert clonedChildPlans;    
        } catch(exception excp) { 
          system.debug('iam here');
           UTIL_LoggingService.logHandledException(excp,UtilConstants.ORGID,UtilConstants.APPNAME,CLASS_NAME,UtilConstants.CANCEL,TEST_CLASS,LoggingLevel.ERROR); 
        }
    }
 
 /* inner class to initialize invocabale variables for process builder*/  
   global class processBuilderInput{       
       @InvocableVariable(required=true)
        global ID hcrId;    
       @InvocableVariable(required=true)  
       global String groupName;   
   }
   
}