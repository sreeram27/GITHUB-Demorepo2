/**********************************************************************************
Trigger Name : ContentDocumentLinkTrigger
Date Created : 5-August-2019
Created By   : Accenture Offshore
@description : Created for Document Upload Functionality
*************************************************************************************/
trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert,after update) {
    ContentDocumentLinkTriggerHandler handler = new ContentDocumentLinkTriggerHandler();
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate || Trigger.isInsert){
            handler.createCdLink(Trigger.new);
        }
    }
}