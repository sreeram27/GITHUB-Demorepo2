trigger QuoteTrigger on Quote (after insert) {
    list<quote> quoteList = [SELECT Id, OpportunityId FROM Quote where id=:Trigger.new];
    list<attachment> newAttList = new list<attachment>();
    for(quote q:quoteList){
        id oppId = q.OpportunityId;
        list<attachment> attList = [SELECT Id, Body, Name, ParentId FROM Attachment where ParentId=:oppId and name like '%SOW%'];
        for(attachment attach:attList){
           attachment temp = new attachment();
           temp.ParentId = q.id;
           temp.name = attach.name;
           temp.body = attach.body;
           newAttList.add(temp);
        }
    }
    insert newAttList;
}