/****************************************************************
Class Name   : DNCAttachmentCountOnDelete 
Date Created : 18-APR-2018
Created By   : Deloitte USI 
Description  : Trigger that fires on before delete of an attachment 
*****************************************************************/
trigger DNCAttachmentCountOnDelete on ContentDocument(before delete) {
   if(Trigger.isDelete) {
      if(DNC_AttachmentHandler.onAfterDeleteIsFirstRun) {
        DNC_AttachmentHandler.onAfterDeleteIsFirstRun = false;
          DNC_AttachmentHandler.onAfterDelete(Trigger.old);
      }
     }
}