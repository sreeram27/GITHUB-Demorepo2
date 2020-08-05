@isTest
global class Test_ScheduleCLS_CalloutToJira {
    global class Test_MockHttpResponseGenerator1 implements HTTPCalloutMock {
        global HttpResponse Respond(HttpRequest req1){
            HttpResponse res = new HttpResponse();
            if(req1.getEndpoint().contains('maxResults=0')){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"startAt": 0,"maxResults": 0,"total": 476,"issues": []}');
            }
            else if(req1.getEndpoint().contains('maxResults=-1')){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"expand": "names,schema","startAt": 0,"maxResults": 1,"total": 109,"issues": [{"expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields","id": "29914","self": "","key": "ARDX-268","fields": {"issuetype": {"self": "","id": "10003","description": "A user story. Created by JIRA Software - do not edit or delete.","iconUrl": "","name": "Story","subtask": false},"customfield_10010": ["com.atlassian.greenhopper.service.sprint.Sprint@4808895c[id=81,rapidViewId=15,state=CLOSED,name=ICMA-RC Sprint 9,goal=,startDate=2018-05-01T14:10:33.507Z,endDate=2018-05-31T15:10:00.000Z,completeDate=2018-07-23T17:58:31.853Z,sequence=81]"],"creator": {"self": "","accountId": "557058:454676d4-8893-47b2-8401-ae239a5e3501","avatarUrls": {},"displayName": "Prashanth Samudrala","active": true,"timeZone": "America/Los_Angeles","accountType": "atlassian"},"project": {"self": "","id": "10017","key": "ARDX","name": " AR-SalesForce DX","projectTypeKey": "software","simplified": false,"avatarUrls": {}},"reporter": {"self": "","accountId": "","avatarUrls": {},"displayName": "Prashanth Samudrala","active": true,"timeZone": "America/Los_Angeles","accountType": "atlassian"},"fixVersions": [],"assignee": null,"priority": {"self": "","iconUrl": "","name": "Low","id": "4"},"status": {"self": "","description": "","iconUrl": "","name": "Done","id": "10001","statusCategory": {"self": "","id": 3,"key": "done","colorName": "green","name": "Done"}}}}]}');
            }
            return res;
        }
        
    }
    
    
    @isTest
    public static void Test_ScheduleCalloutMethod(){
        
        Test.setMock(HttpCalloutMock.class, new Test_MockHttpResponseGenerator1());
        
        ScheduleCLS_CalloutToJira.get_Jira_Data();
        
    }
    
    @isTest
    public Static void Test_getJiraData(){
        
        Test.setMock(HttpCalloutMock.class, new Test_MockHttpResponseGenerator1());
        
        ScheduleCLS_CalloutToJira.get_Jira_Issues(1);
    }
    
}