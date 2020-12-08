trigger AccountTrigger1 on Account (before insert) {

    for(Account a2: Trigger.New) {

        a2.Description = 'Account Description for this AccountTrigger1119876541111';
    }  
}