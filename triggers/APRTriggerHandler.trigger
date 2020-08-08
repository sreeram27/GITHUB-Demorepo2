trigger APRTriggerHandler on Alpha_Prefix_Request__c (before update,after insert, after update) 
{
	for(Alpha_Prefix_Request__c newApr : trigger.New)
	{
        if(Trigger.isBefore)
        {
            if(Trigger.isUpdate)
            {
                AP29_UnlockAPRRecord.UnlockAPR();    
            }
        }
    }
   
    If(Trigger.isAfter)
    {
      if(Trigger.isInsert)
      {
         AlphaPrefixRequestTriggerHandler.afterInsertCall();
      }
       if(Trigger.isUpdate)
      {
         AlphaPrefixRequestTriggerHandler.afterUpdateCall();
      }
    }  
}