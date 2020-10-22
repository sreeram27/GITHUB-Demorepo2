/**********************************************************************************
Trigger Name :   LGA_ContentDocumentTrg
Date Created : 5-August-2019
Created By   : Accenture Offshore
*************************************************************************************/
trigger LGA_ContentDocumentTrg on ContentDocument (before Delete, after Update) {
    LGA_ContentDocumentTrg_Handler handler = new LGA_ContentDocumentTrg_Handler();
    If(Trigger.isBefore && Trigger.isDelete){
        system.debug('@@@@@ Hiii Inside: LGA_ConentDocumentTrg *****');
       // LGA_ContentDocumentTrg_Handler handler = new LGA_ContentDocumentTrg_Handler();
        handler.removeOrderFileDetails(Trigger.Old);
        
    }
        If(Trigger.isAfter && Trigger.isUpdate){
    system.debug('@@Inside beforeupdate');
    handler.updateOrderFileFields(Trigger.new);
        
    }
    
}