@isTest(SeeAllData=false)
private class JIRAToSFDCSyncBatchTest {
    
    @isTest static void test_method_one() {
    
     Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'Local/Large Group');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = system.today(),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        //LHOL_Q__c = 'true',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        Implementation_Tracking__c it = new Implementation_Tracking__c();
        it.JIRA_Request_ID__c = 'EWM-00000';
        it.Overall_Status__c = 'On Hold';
        it.Implementation_Record_ID__c=o1.id;
        insert it;


        Test.startTest();

        JIRAToSFDCSyncBatch lgBS = new JIRAToSFDCSyncBatch();

        lgBS.JiraValue4Request = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"NASCO", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"NASCO", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"NASCO JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"NASCO"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
            
        lgBS.JiraValue4Instance = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"NASCO", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request pkg 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"NASCO", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 }, "customfield_11509": [{ "self": "https://jiraewm-dev.anthem.com/rest/api/2/customFieldOption/11687", "value": "Yes", "id": "11687" }], '+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"NASCO JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"NASCO"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - PKG 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
            

        /*'{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                                '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"NASCO", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request pkg 001",' +
                                '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"NASCO", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                                '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"NASCO JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                                '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                                '"customfield_11500":{"value":"NASCO"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11509":", value=Yes})", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
           */     

        lgBS.JiraValue4Subtask = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"NASCO", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"NASCO", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"NASCO JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"NASCO"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
        

        Database.executeBatch(lgBS, 1);

        Test.stopTest();

        
    }
    
    @isTest static void test_method_two() {
        
        
           Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'Local/Large Group');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = system.today(),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        //LHOL_Q__c = 'true',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        
        
        Implementation_Tracking__c it = new Implementation_Tracking__c();
        it.JIRA_Request_ID__c = 'EWM-11111';
        it.Overall_Status__c = 'On Hold';
         it.Implementation_Record_ID__c=o1.id;
        insert it;


        Test.startTest();

        JIRAToSFDCSyncBatch lgBS = new JIRAToSFDCSyncBatch();

        lgBS.JiraValue4Request = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11560": "20", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
            
        lgBS.JiraValue4Instance = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                                '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                                '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                                '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                                '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                                '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "customfield_11439":"pkg 12321", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - pkg 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
                

        lgBS.JiraValue4Subtask = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
        


        Database.executeBatch(lgBS, 1);
           
        Test.stopTest();

    }
    
    @isTest static void test_method_three() {
    
     Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'Local/Large Group');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = system.today(),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        //LHOL_Q__c = 'true',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        
        Implementation_Tracking__c it = new Implementation_Tracking__c();
        it.JIRA_Request_ID__c = 'EWM-11111';
        it.Overall_Status__c = 'On Hold';
        it.Implementation_Record_ID__c=o1.id;
        insert it;


        Test.startTest();

        JIRAToSFDCSyncBatch lgBS = new JIRAToSFDCSyncBatch();

        lgBS.JiraValue4Request = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11560": "20%", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
            
        lgBS.JiraValue4Instance = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                                '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                                '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                                '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                                '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                                '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "customfield_11439":"pkg 12321", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - pkg 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
                

        lgBS.JiraValue4Subtask = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
        


        Database.executeBatch(lgBS, 1);
           
        Test.stopTest();

    }

    @isTest static void test_method_four() {
        
        Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'Local/Large Group');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = system.today(),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        //LHOL_Q__c = 'true',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        
        
        Implementation_Tracking__c it = new Implementation_Tracking__c();
        it.JIRA_Request_ID__c = 'EWM-11111';
        it.Overall_Status__c = 'On Hold';
         it.Implementation_Record_ID__c=o1.id;
        insert it;


        Test.startTest();

        JIRAToSFDCSyncBatch lgBS = new JIRAToSFDCSyncBatch();

        lgBS.JiraValue4Request = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11560": "percent 20", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
            
        lgBS.JiraValue4Instance = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                                '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                                '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                                '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                                '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                                '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "customfield_11439":"pkg 12321", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - pkg 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
                

        lgBS.JiraValue4Subtask = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
        


        Database.executeBatch(lgBS, 1);
           
        Test.stopTest();

    }

    @isTest static void test_method_five() {
        
        
        Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'Local/Large Group');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = system.today(),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        //LHOL_Q__c = 'true',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        
        
        Implementation_Tracking__c it = new Implementation_Tracking__c();
        it.JIRA_Request_ID__c = 'EWM-11111';
        it.Overall_Status__c = 'On Hold';
        it.Implementation_Record_ID__c=o1.id;
        insert it;


        Test.startTest();

        JIRAToSFDCSyncBatch lgBS = new JIRAToSFDCSyncBatch(It.Id);

        lgBS.JiraValue4Request = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11560": "Percent20", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
            
        lgBS.JiraValue4Instance = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                                '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                                '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                                '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                                '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                                '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "customfield_11439":"pkg 12321", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - pkg 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
                

        lgBS.JiraValue4Subtask = '{"id":"test","key": "EWM-00000","fields":{ "issuelinks":[    { "id":"70751","type":{"id":"10201","name":"Parent","inward":"is a child of", "outward":"Is a parent for"}, "outwardIssue":{   "id":"94777", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001", "status":{ "description":"", "name":"01-Intake", "id":"10105", "statusCategory":{   "key":"new", "colorName":"blue-gray", "name":"To Do"' +
                        '} }, "issuetype":{   "self":"https://jiraewm-dev.anthem.com/rest/api/2/issuetype/10179", "id":"10179", "description":"",  "name":"WGS", "subtask":false, "avatarId":10512 } } }  }, {  "id":"70752","type":{  "id":"10201", "name":"Parent", "inward":"is a child of", "outward":"Is a parent for" }, "outwardIssue":{  "id":"94778", "key":"EWM-00000", "fields":{   "summary":"Test New Request 001",' +
                        '"status":{  "description":"","name":"02-Document Requirements", "id":"10107","statusCategory":{  "id":4,"key":"indeterminate", "colorName":"yellow", "name":"In Progress"  } }, "issuetype":{  "id":"10179", "description":"", "name":"WGS", "subtask":false,  "avatarId":10512 } } } } ], "issuetype":{  "id":"10184", "description":"", "name":"EBA", "subtask":false, "avatarId":10520 },'+
                        '"customfield_11562":"2018-04-04", "customfield_11561":"2018-03-28", "customfield_12401":"2019-03-28", "customfield_11491":{ "value":"WGS JAA", "id":"11674" }, "customfield_11493":"Yu Xia", "reporter":{  "name":"AC04840", "key":"ac04840", "emailAddress":"Kishore.Agrawal@anthem.com", "displayName":"Agrawal, Kishore K.", "active":true, "timeZone":"America/New_York" }, "customfield_11495":{   "value":"Yes", "id":"11677" }, "customfield_13675":{   "value":"Yes",  "id":"58040" },' +
                        '"customfield_11481":{   "value":"Sales Force", "id":"11621" }, "customfield_11485":"2018-04-03", "customfield_14500":1, "updated":"2018-04-03T22:19:13.000-0400", "customfield_12301":"Sam Adam", "customfield_11446":"00000719", "customfield_11449":"2018-03-28", "created":"2018-03-01T16:57:19.000-0500", "customfield_13000":"2018-03-28", "assignee":{  "name":"SteveLt", "key":"stevelt", "displayName":"Stevenson", "active":true, "timeZone":"America/New_York" }, "customfield_11445":"00000719", "status":{  "name":"In Progress" }, "customfield_11663":null, "customfield_11609":[  {  "value":"Initial"} ], "customfield_13310":{ "value":"Elaine Patterson" },' +
                        '"customfield_11500":{"value":"WGS"}, "customfield_11606":"2018-03-28", "customfield_11679":"2018-03-28", "customfield_11607":"2018-03-28", "customfield_11583":"2018-03-28", "customfield_11542":"2018-03-28", "customfield_11462":"2018-03-28", "customfield_11602":"2018-03-28", "customfield_11601":"2018-03-28", "project":{ "id":"10004", "key":"EWM", "name":"EBA Work Management"  }, "summary":"Test JIRA 1 - test Group_LG New Business CA 1 - 3/27/2018 - New Business - 00000719", "customfield_13121":[ "Test JIRA 1" ], "customfield_13125":"  <value>Test JIRA 1</value>", "customfield_11667":"2018-03-01", "subtasks":[{"key":"EWM-00000","fields": {"issuetype": {"name": "NASCO Benefit Coding Subtask"}}}] } }';
        


        Database.executeBatch(lgBS, 1);
           
        Test.stopTest();

    }

    @isTest static void test_method_six() {
        
        Account acc1 = new Account(Name = 'test1',
                                Region__c = 'West',
                                Anthem_Entity__c = 'Local/Large Group');
        
        insert acc1;
        
        Group__c g1 = new Group__c(ClaimSystem__c = 'WGS 2.0',
                            Name = 'test Group',
                            Account__c = acc1.Id);

        insert g1;
        
        Product2 prod = new Product2(Name = 'Health and Wellness - Live Health Online',
                                IsActive = true,
                                vlocity_ins__Type__c = 'Medical');

        insert prod;
           Id pricebookId = Test.getStandardPricebookId();
           
         PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, 
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 10000, IsActive = true);

        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);

        insert customPB;
        
       

        Opportunity opp1 = new Opportunity(CloseDate = system.today(),
                                        Name = 'test opp',
                                        AccountId = acc1.id,
                                        StageName = 'Initiated');

        insert opp1;

        Quote q1 = new Quote(JAAIndicator__c = true,
                        Name = 'test Quote',
                        Pricebook2Id = customPB.Id,
                        OpportunityId = opp1.Id,GroupNumber__c = g1.Id);

        insert q1;
        
    Order o1 = new Order(Implementation_Effective_Date__c = system.today(),
                        Implementation_Status__c = 'Initiated',
                        Implementation_Type__c = 'New Business',
                        User_Group__c = 'Local New Business',
                        Production_Date__c = system.today(),
                        EffectiveDate = system.today(),
                        Status = 'Draft',
                        //LHOL_Q__c = 'true',
                        AccountId = acc1.Id,
                        QuoteId = q1.Id,
                        OpportunityId = opp1.Id);

        insert o1;
        
        
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                                                    UnitPrice = 12000, IsActive = true);
        
        insert pbe;
        
         QuoteLineItem qli1 = new QuoteLineItem(Funding__c = 'ASO', 
                                            QuoteId = q1.Id,
                                            Product2Id = prod.Id,
                                            Members__c = 10,
                                            PricebookEntryId = pbe.Id,
                                            Quantity = 10,
                                            Unitprice = 10.00);

        insert qli1;
        

        Implementation_Tracking__c it = new Implementation_Tracking__c();
        it.JIRA_Request_ID__c = 'EWM-11111';
        it.Overall_Status__c = 'On Hold';
        it.Implementation_Record_ID__c=o1.id;
        insert it;

        Test.startTest();

        JIRAIssueResponse_Instance instance = new JIRAIssueResponse_Instance();
        instance.Response = new JIRAIssueResponse_Instance.Response();
        instance.Response.expand = 'expand';
        instance.Response.id = 'id';
        instance.Response.key = 'key';
        instance.Response.self = 'self';

        instance.Response.fields = new JIRAIssueResponse_Instance.Fields_Z();
        instance.Response.fields.description = 'description';
        instance.Response.fields.summary = 'summary';
        instance.Response.fields.reporter = new JIRAIssueResponse_Instance.Reporter();
        instance.Response.fields.subtasks = null;
        instance.Response.fields.customfield_11439 = 'description';
        instance.Response.fields.customfield_11439 = 'description';
        instance.Response.fields.customfield_11485 = 'description';
        instance.Response.fields.customfield_11517 = 'description';
        instance.Response.fields.customfield_11518 = 'description';
        instance.Response.fields.customfield_11519 = 'description';
        instance.Response.fields.customfield_11542 = 'description';
        instance.Response.fields.customfield_11545 = 'description';
        instance.Response.fields.customfield_11544 = 'description';
        instance.Response.fields.customfield_11547 = 'description';
        instance.Response.fields.customfield_11560 = 'description';
        instance.Response.fields.customfield_11561 = 'description';
        instance.Response.fields.customfield_11562 = 'description';
        instance.Response.fields.customfield_11583 = 'description';
        instance.Response.fields.customfield_11601 = 'description';
        instance.Response.fields.customfield_11602 = 'description';
        instance.Response.fields.customfield_11606 = 'description';
        instance.Response.fields.customfield_11607 = 'description';
        instance.Response.fields.customfield_11667 = 'description';
        instance.Response.fields.customfield_11679 = 'description';
        instance.Response.fields.customfield_11697 = 'description';
        instance.Response.fields.customfield_11698 = 'description';
        instance.Response.fields.customfield_11700 = 'description';
        instance.Response.fields.customfield_11707 = 'description';
        instance.Response.fields.customfield_12200 = 'description';
        instance.Response.fields.customfield_11552 = 'description';
        instance.Response.fields.customfield_15201 = 'description';
        instance.Response.fields.customfield_15200 = 'description';
        instance.Response.fields.customfield_11462 = 'description';
        instance.Response.fields.customfield_11509 = null;


        instance.Response.fields.assignee = new JIRAIssueResponse_Instance.Reporter();
        instance.Response.fields.assignee.self = 'self';
        instance.Response.fields.assignee.name = 'name';
        instance.Response.fields.assignee.key = 'key';
        instance.Response.fields.assignee.emailAddress = 'emailAddress';
        instance.Response.fields.assignee.displayName = 'displayName';
        instance.Response.fields.assignee.active = true;
        instance.Response.fields.assignee.timeZone = 'timeZone';


        instance.Response.fields.project = new JIRAIssueResponse_Instance.Project();
        instance.Response.fields.project.self = 'self';
        instance.Response.fields.project.name = 'name';
        instance.Response.fields.project.key = 'key';
        instance.Response.fields.project.id = 'id';


        instance.Response.fields.issuetype = new JIRAIssueResponse_Instance.Issuetype();
        instance.Response.fields.issuetype.self = 'self';
        instance.Response.fields.issuetype.name = 'name';
        instance.Response.fields.issuetype.id = 'id';
        instance.Response.fields.issuetype.description = 'description';
        instance.Response.fields.issuetype.iconUrl = 'iconUrl';
        instance.Response.fields.issuetype.subtask = true;
        instance.Response.fields.issuetype.avatarId = 1;

        
        instance.Response.fields.status = new JIRAIssueResponse_Instance.Status();
        instance.Response.fields.status.self = 'self';
        instance.Response.fields.status.name = 'name';
        instance.Response.fields.status.id = 'id';
        instance.Response.fields.status.description = 'description';
        instance.Response.fields.status.iconUrl = 'iconUrl';


        instance.Response.fields.subtasks = new List<JIRAIssueResponse_Instance.InwardIssue>();
        instance.Response.fields.subtasks.add(new JIRAIssueResponse_Instance.InwardIssue());
        instance.Response.fields.subtasks.get(0).id = 'id';
        instance.Response.fields.subtasks.get(0).key = 'key';
        instance.Response.fields.subtasks.get(0).self = 'self';
        instance.Response.fields.subtasks.get(0).fields = new JIRAIssueResponse_Instance.Fields();
        instance.Response.fields.subtasks.get(0).fields.summary = 'summary';
        instance.Response.fields.subtasks.get(0).fields.status = null;
        instance.Response.fields.subtasks.get(0).fields.issuetype = null;


        instance.Response.fields.customfield_11724 = new List<JIRAIssueResponse_Instance.CustomfieldClass>();
        instance.Response.fields.customfield_11724.add(new JIRAIssueResponse_Instance.CustomfieldClass());
        instance.Response.fields.customfield_11724.get(0).self = 'self';
        instance.Response.fields.customfield_11724.get(0).id = 'id';


        instance.Response.fields.issuelinks = new List<JIRAIssueResponse_Instance.Issuelinks>();
        instance.Response.fields.issuelinks.add(new JIRAIssueResponse_Instance.Issuelinks());
        instance.Response.fields.issuelinks.get(0).id = 'id';
        instance.Response.fields.issuelinks.get(0).self = 'self';
        instance.Response.fields.issuelinks.get(0).type_Z = new JIRAIssueResponse_Instance.type_Z();
        instance.Response.fields.issuelinks.get(0).type_Z.id = 'id';
        instance.Response.fields.issuelinks.get(0).type_Z.name = 'name';
        instance.Response.fields.issuelinks.get(0).type_Z.inward = 'inward';
        instance.Response.fields.issuelinks.get(0).type_Z.outward = 'outward';
        instance.Response.fields.issuelinks.get(0).type_Z.self = 'self';

        instance.Response.fields.issuelinks.get(0).inwardIssue = null;
        instance.Response.fields.issuelinks.get(0).outwardIssue = new JIRAIssueResponse_Instance.OutwardIssue();
        instance.Response.fields.issuelinks.get(0).outwardIssue.id = 'id';
        instance.Response.fields.issuelinks.get(0).outwardIssue.key = 'key';
        instance.Response.fields.issuelinks.get(0).outwardIssue.self = 'self';
        instance.Response.fields.issuelinks.get(0).outwardIssue.fields = null;

        Object obj = instance.Response.fields.getValue('customfield_11462');

        System.schedule('test', '0 0 * * * ?', new JIRAToSFDCSyncBatch());


        LGJira2IssueDetail details = new LGJira2IssueDetail();
        details.expand = 'expand';
        details.id = 'id';
        details.key = 'key';
        details.self = 'self';
        details.fields = new LGJira2IssueDetail.FieldDetails();
        details.fields.lastViewed = 'test';
        details.fields.subtasks = null;
        details.fields.customfield_11492 = 'test';
        details.fields.updated = 'test';
        details.fields.description = 'test';
        details.fields.customfield_12301 = 'test';
        details.fields.created = 'test';
        details.fields.customfield_14108 = 'test';
        details.fields.reporter = null;
        details.fields.customfield_13675 = null;
        details.fields.customfield_11487 = null;
        details.fields.watches = null;
        details.fields.customfield_11452 = null;
        details.fields.customfield_11454 = null;
        details.fields.customfield_11456 = null;
        details.fields.customfield_11455 = null;
        details.fields.created = null;
        details.fields.creator = null;
        details.fields.customfield_11639 = null;
        details.fields.customfield_11626 = null;
        details.fields.customfield_11609 = null;
        details.fields.customfield_13310 = null;
        details.fields.status = new LGJira2IssueDetail.CustomFieldClass();
        details.fields.status.self = 'self';
        details.fields.status.id = 'id';
        details.fields.status.description = 'description';
        details.fields.status.iconUrl = 'description';
        details.fields.status.subtask = 'description';
        details.fields.status.avatarId = 'description';
        details.fields.status.watchCount = 'description';
        details.fields.status.isWatching = 'description';
        details.fields.status.displayName = 'description';
        details.fields.status.timeZone = 'description';
        details.fields.status.active = false;

        LGJiraCreateIssueResponse res = new LGJiraCreateIssueResponse();
        res.Id = 'id';
        res.key = 'key';
        res.self = 'self';
        res.response = 'response';
           
        Test.stopTest();

    }
}