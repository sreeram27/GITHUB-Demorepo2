/*
@Author : Partha (Vikings)
@Name : MedicalBenefitTrigger
@CreatedDate :- 19/07/2019
@Description : PRDCRM-38796 :: This trigger deals with Medical Benefit object events.
ModifiedBy Sharath KN on 18-Aug-2019 to limit only one Medical Benefit per Implementation Case
*/
trigger  MedicalBenefitTrigger on Medical_Benefit__c(before insert,after insert ) { 
    MedicalBenefitTriggerHandler cshandler = new MedicalBenefitTriggerHandler();

    if(trigger.isAfter){
        cshandler.updateMedBenOnCaseInstall(trigger.new);
    }
    
   /* if(trigger.isBefore && trigger.isInsert){
        cshandler.limitMBRecords(Trigger.New);
    }*/
}