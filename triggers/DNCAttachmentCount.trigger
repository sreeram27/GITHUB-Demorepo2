/****************************************************************
Class Name   : DNCAttachmentCount 
Date Created : 18-APR-2018
Created By   : Deloitte USI
Description  : Trigger that fires on insert of an attachment 
*****************************************************************/
trigger DNCAttachmentCount on ContentDocumentLink(after insert) {
  if(Trigger.isAfter) {
    if(Trigger.isInsert) {
      if(DNC_AttachmentHandler.onAfterInsertIsFirstRun) {
        DNC_AttachmentHandler.onAfterInsertIsFirstRun = false;
          DNC_AttachmentHandler.onAfterInsert(Trigger.new);
      }
      }
    }
}