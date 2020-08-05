trigger OnAccountUpdate on Account (After Update) {
    
    if(trigger.isAfter){
        if(trigger.isUpdate){
           AccountHandler.CreateContractFortheOpportunity(trigger.new);
            
        }
    }
}