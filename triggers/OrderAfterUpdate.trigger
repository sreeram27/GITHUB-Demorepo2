/*
@Author : Accenture Offshore Dev team
@name : OrderAfterUpdate Trigger
@CreateDate :25-04-2018
@Description : This trigger calls AP22_SendNotifToNationalAIMTeam_Handler on after update operations.
@Modifiedby : 1) Sharath KN - 04/09/2019 - To copy impacted Products value to corresponding Case Installation.
              2) Ravideep (Vikings) - 02/03/2020 - PRDCRM-49125 - Prevent ICR status to change to withdrawn if underwriting record stage is approved
*/
trigger OrderAfterUpdate on Order (after update,Before insert,Before update,After Insert) { // Updated LGSMERecordCreation for Impacted Product
    if(trigger.Isupdate && trigger.IsAfter){
        AP22_SendNotifToNationalAIMTeam_Handler.AfterOrderUpdate(Trigger.new,Trigger.oldMap);
        LGSMERecordCreation.populateAssignedImplementerValueOnIdCard(Trigger.new,Trigger.oldMap);
        if(checkRecursive_trgrecursive.runOnce())
        {
            LGSMERecordCreation.afterUpdate(Trigger.new,Trigger.newmap,Trigger.oldMap);
            LGSMERecordCreation.idCardStatusUpdate(Trigger.new,Trigger.oldMap);
            LGSMERecordCreation.smeRecordStatusUpdate(Trigger.new,Trigger.oldMap);
        }
        
        LG_OrderTriggerHandler OTH = new LG_OrderTriggerHandler();
        OTH.onAfterUpdate(trigger.New, trigger.Old, Trigger.NewMap, Trigger.OldMap);
    }
    
    if(trigger.Isupdate && trigger.IsBefore){
    
        AP22_SendNotifToNationalAIMTeam_Handler.BeforeInsertUpdate(Trigger.new,Trigger.oldMap);
        LG_OrderTriggerHandler OTH = new LG_OrderTriggerHandler();
        OTH.onBeforeUpdate(trigger.New,Trigger.OldMap);
        
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        ImplementationCaseHelper.updateIdCardsRequiredIfYes(Trigger.New);
        system.debug('@@AfterInsert');
        //PRDCRM-39662 -added below class for DC auto creation by Accenture-Raptors
        LGA_CreateDocumentChecklist.createDocumentsforImplCase(trigger.new);
        
    }
        
}