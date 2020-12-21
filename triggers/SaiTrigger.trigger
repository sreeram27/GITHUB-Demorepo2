trigger SaiTrigger on Account (before insert) {

    for(Account a2: Trigger.New) {

        a2.Description = 'Account Description for this Ac Modified';

    }

}