@isTest
private class Implementation_Questionnaire_1_Test{
    @testSetup
    static void setupTestData(){
        test.startTest();
        List<Questionnaire_Implementation__c> questionnaire_implementation_Obj = new List<Questionnaire_Implementation__c>{
            new Questionnaire_Implementation__c(CreatedDate = DateTime.now(),  LastModifiedDate = DateTime.now()    , Time_taken_for__c='30', Company_Name__c='Test', Email__c='test@test.com', What_kind_of_testing_do_you_perform__c='Apex only', What_does_your_current_release_process__c='Test', X1_Which_Version_Control_System_is_used__c='GIT',X2_Which_tool_is_used_for_Project_Manage__c='JIRA',Plz_specify_other_ALM__c='',How_often_Data_Loader__c='Daily',X1_Any_ETL_tool_currently_being_used__c ='Test',How_Often__c='monthly',How_are_metadata_components_being_dep__c='Ant Scripts',Plz_specify_other_Metadata_components__c='',Typically_how_many_records_do_you_mi__c ='50',What_are_the_pain_points_during_the_d__c='Test',How_long_does_it_take_for_pre_post_de__c='30'),
                new Questionnaire_Implementation__c(CreatedDate = DateTime.now(),  LastModifiedDate = DateTime.now(), Time_taken_for__c='30', Company_Name__c='Test', Email__c='test@test.com', What_kind_of_testing_do_you_perform__c='Apex only', What_does_your_current_release_process__c='Test', X1_Which_Version_Control_System_is_used__c='GIT',X2_Which_tool_is_used_for_Project_Manage__c='JIRA',Plz_specify_other_ALM__c='',How_often_Data_Loader__c='Daily',X1_Any_ETL_tool_currently_being_used__c ='Test',How_are_metadata_components_being_dep__c='Ant Scripts',Plz_specify_other_Metadata_components__c='',How_Often__c='monthly',Typically_how_many_records_do_you_mi__c ='50',What_are_the_pain_points_during_the_d__c='Test',How_long_does_it_take_for_pre_post_de__c='30'),
                new Questionnaire_Implementation__c(CreatedDate = DateTime.now(),  LastModifiedDate = DateTime.now(), Time_taken_for__c='30', Company_Name__c='Test', Email__c='test@test.com', What_kind_of_testing_do_you_perform__c='Apex only', What_does_your_current_release_process__c='Test', X1_Which_Version_Control_System_is_used__c='GIT',X2_Which_tool_is_used_for_Project_Manage__c='JIRA',Plz_specify_other_ALM__c='',How_often_Data_Loader__c='Daily',X1_Any_ETL_tool_currently_being_used__c ='Test',How_are_metadata_components_being_dep__c='Ant Scripts',Plz_specify_other_Metadata_components__c='',How_Often__c='monthly',Typically_how_many_records_do_you_mi__c ='50',What_are_the_pain_points_during_the_d__c='Test',How_long_does_it_take_for_pre_post_de__c='30'),
                new Questionnaire_Implementation__c(CreatedDate = DateTime.now(),  LastModifiedDate = DateTime.now(), Time_taken_for__c='30', Company_Name__c='Test', Email__c='test@test.com', What_kind_of_testing_do_you_perform__c='Apex only', What_does_your_current_release_process__c='Test', X1_Which_Version_Control_System_is_used__c='GIT',X2_Which_tool_is_used_for_Project_Manage__c='JIRA',Plz_specify_other_ALM__c='',How_often_Data_Loader__c='Daily',X1_Any_ETL_tool_currently_being_used__c ='Test',How_are_metadata_components_being_dep__c='Ant Scripts',Plz_specify_other_Metadata_components__c='',How_Often__c='monthly',Typically_how_many_records_do_you_mi__c ='50',What_are_the_pain_points_during_the_d__c='Test',How_long_does_it_take_for_pre_post_de__c='30')
                };
                    Insert questionnaire_implementation_Obj;
        test.stopTest();
    }
    static testMethod void test_getQuestionnaire_UseCase1(){
        List<Questionnaire_Implementation__c> questionnaire_implementation_Obj  =  [SELECT CreatedDate,CreatedById,LastModifiedDate,LastModifiedById from Questionnaire_Implementation__c];
        System.assertEquals(true,questionnaire_implementation_Obj.size()>0);
        
        
        Implementation_Questionnaire_1 obj01 = new Implementation_Questionnaire_1(new ApexPages.StandardController(questionnaire_implementation_Obj[0]));
        obj01.quesObj = questionnaire_implementation_Obj[0];
        obj01.isclick = false;
        obj01.questionPage = false;
        obj01.attach = new Attachment();
        obj01.attach1 = new Attachment();
        obj01.companyName = 'test data';
        obj01.Emailval = 'test data';
        Implementation_Questionnaire_1.DeveloperChanges = 'test data';
        Implementation_Questionnaire_1.codebackup = 'test data';
        Implementation_Questionnaire_1.timeDevelopers = 'test data';
        Implementation_Questionnaire_1.Nooftime = 'test data';
        Implementation_Questionnaire_1.Timetakenforcommits = 'test data';
        Implementation_Questionnaire_1.mergeconflictsaddressed = 'test data';
        obj01.leadList = new List<Lead>();
        obj01.selectedUseCases = 'test data';
        obj01.selectedUseCasesDeployment = 'test data';
        obj01.selectedUseCasesDataLoader = 'test data';
        obj01.usedOrNot = 'test data';
        obj01.getQuestionnaire();
    }
    static testMethod void test_getVersionControl_UseCase1(){
        List<Questionnaire_Implementation__c> questionnaire_implementation_Obj  =  [SELECT CreatedDate,CreatedById,LastModifiedDate,LastModifiedById from Questionnaire_Implementation__c];
        System.assertEquals(true,questionnaire_implementation_Obj.size()>0);
        
        Implementation_Questionnaire_1 obj01 = new Implementation_Questionnaire_1(new ApexPages.StandardController(questionnaire_implementation_Obj[0]));
        obj01.quesObj = questionnaire_implementation_Obj[0];
        obj01.isclick = false;
        obj01.questionPage = false;
        obj01.attach = new Attachment();
        obj01.attach1 = new Attachment();
        obj01.companyName = 'test data';
        obj01.Emailval = 'test data';
        Implementation_Questionnaire_1.DeveloperChanges = 'test data';
        Implementation_Questionnaire_1.codebackup = 'test data';
        Implementation_Questionnaire_1.timeDevelopers = 'test data';
        Implementation_Questionnaire_1.Nooftime = 'test data';
        Implementation_Questionnaire_1.Timetakenforcommits = 'test data';
        Implementation_Questionnaire_1.mergeconflictsaddressed = 'test data';
        obj01.leadList = new List<Lead>();
        obj01.selectedUseCases = 'test data';
        obj01.selectedUseCasesDeployment = 'test data';
        obj01.selectedUseCasesDataLoader = 'test data';
        obj01.usedOrNot = 'test data';
        obj01.getVersionControl();
    }
    static testMethod void test_getSelUseCases_UseCase1(){
        List<Questionnaire_Implementation__c> questionnaire_implementation_Obj  =  [SELECT CreatedDate,CreatedById,LastModifiedDate,LastModifiedById from Questionnaire_Implementation__c];
        System.assertEquals(true,questionnaire_implementation_Obj.size()>0);
        
        Implementation_Questionnaire_1 obj01 = new Implementation_Questionnaire_1(new ApexPages.StandardController(questionnaire_implementation_Obj[0]));
        obj01.quesObj = questionnaire_implementation_Obj[0];
        obj01.isclick = false;
        obj01.questionPage = false;
        obj01.attach = new Attachment();
        obj01.attach1 = new Attachment();
        obj01.companyName = 'test data';
        obj01.Emailval = 'test data';
        Implementation_Questionnaire_1.DeveloperChanges = 'test data';
        Implementation_Questionnaire_1.codebackup = 'test data';
        Implementation_Questionnaire_1.timeDevelopers = 'test data';
        Implementation_Questionnaire_1.Nooftime = 'test data';
        Implementation_Questionnaire_1.Timetakenforcommits = 'test data';
        Implementation_Questionnaire_1.mergeconflictsaddressed = 'test data';
        obj01.leadList = new List<Lead>();
        obj01.selectedUseCases = 'test data';
        obj01.selectedUseCasesDeployment = 'test data';
        obj01.selectedUseCasesDataLoader = 'test data';
        obj01.usedOrNot = 'test data';
        obj01.getSelUseCases();
    }
    static testMethod void test_getSelUseCasesDeployment_UseCase1(){
        List<Questionnaire_Implementation__c> questionnaire_implementation_Obj  =  [SELECT CreatedDate,CreatedById,LastModifiedDate,LastModifiedById from Questionnaire_Implementation__c];
        System.assertEquals(true,questionnaire_implementation_Obj.size()>0);
        
        Implementation_Questionnaire_1 obj01 = new Implementation_Questionnaire_1(new ApexPages.StandardController(questionnaire_implementation_Obj[0]));
        obj01.quesObj = questionnaire_implementation_Obj[0];
        obj01.isclick = false;
        obj01.questionPage = false;
        obj01.attach = new Attachment();
        obj01.attach1 = new Attachment();
        obj01.companyName = 'test data';
        obj01.Emailval = 'test data';
        Implementation_Questionnaire_1.DeveloperChanges = 'test data';
        Implementation_Questionnaire_1.codebackup = 'test data';
        Implementation_Questionnaire_1.timeDevelopers = 'test data';
        Implementation_Questionnaire_1.Nooftime = 'test data';
        Implementation_Questionnaire_1.Timetakenforcommits = 'test data';
        Implementation_Questionnaire_1.mergeconflictsaddressed = 'test data';
        obj01.leadList = new List<Lead>();
        obj01.selectedUseCases = 'test data';
        obj01.selectedUseCasesDeployment = 'test data';
        obj01.selectedUseCasesDataLoader = 'test data';
        obj01.usedOrNot = 'test data';
        obj01.getSelUseCasesDeployment();
    }
    static testMethod void test_getSelUseCasesDataLoader_UseCase1(){
        List<Questionnaire_Implementation__c> questionnaire_implementation_Obj  =  [SELECT CreatedDate,CreatedById,LastModifiedDate,LastModifiedById from Questionnaire_Implementation__c];
        System.assertEquals(true,questionnaire_implementation_Obj.size()>0);
        
        Implementation_Questionnaire_1 obj01 = new Implementation_Questionnaire_1(new ApexPages.StandardController(questionnaire_implementation_Obj[0]));
        obj01.quesObj = questionnaire_implementation_Obj[0];
        obj01.isclick = false;
        obj01.questionPage = false;
        obj01.attach = new Attachment();
        obj01.attach1 = new Attachment();
        obj01.companyName = 'test data';
        obj01.Emailval = 'test data';
        Implementation_Questionnaire_1.DeveloperChanges = 'test data';
        Implementation_Questionnaire_1.codebackup = 'test data';
        Implementation_Questionnaire_1.timeDevelopers = 'test data';
        Implementation_Questionnaire_1.Nooftime = 'test data';
        Implementation_Questionnaire_1.Timetakenforcommits = 'test data';
        Implementation_Questionnaire_1.mergeconflictsaddressed = 'test data';
        obj01.leadList = new List<Lead>();
        obj01.selectedUseCases = 'test data';
        obj01.selectedUseCasesDeployment = 'test data';
        obj01.selectedUseCasesDataLoader = 'test data';
        obj01.usedOrNot = 'test data';
        obj01.getSelUseCasesDataLoader();
    }
    static testMethod void test_searchdata_UseCase1(){
        List<Questionnaire_Implementation__c> questionnaire_implementation_Obj  =  [SELECT CreatedDate,CreatedById,LastModifiedDate,LastModifiedById from Questionnaire_Implementation__c];
        System.assertEquals(true,questionnaire_implementation_Obj.size()>0);
        
        Implementation_Questionnaire_1 obj01 = new Implementation_Questionnaire_1(new ApexPages.StandardController(questionnaire_implementation_Obj[0]));
        obj01.quesObj = questionnaire_implementation_Obj[0];
        obj01.isclick = false;
        obj01.questionPage = false;
        obj01.attach = new Attachment();
        obj01.attach1 = new Attachment();
        obj01.companyName = 'test data';
        obj01.Emailval = 'test data';
        Implementation_Questionnaire_1.DeveloperChanges = 'test data';
        Implementation_Questionnaire_1.codebackup = 'test data';
        Implementation_Questionnaire_1.timeDevelopers = 'test data';
        Implementation_Questionnaire_1.Nooftime = 'test data';
        Implementation_Questionnaire_1.Timetakenforcommits = 'test data';
        Implementation_Questionnaire_1.mergeconflictsaddressed = 'test data';
        obj01.leadList = new List<Lead>();
        obj01.selectedUseCases = 'test data';
        obj01.selectedUseCasesDeployment = 'test data';
        obj01.selectedUseCasesDataLoader = 'test data';
        obj01.usedOrNot = 'test data';
        obj01.searchdata();
    }
    static testMethod void test_Save_UseCase1(){
        Questionnaire_Implementation__c ques=new Questionnaire_Implementation__c();
        List<Questionnaire_Implementation__c> questionnaire_implementation_Obj = [SELECT CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,X1_Which_Version_Control_System_is_used__c, Name_of_other_System__c, X2_Which_tool_is_used_for_Project_Manage__c,
                                                                                  Plz_specify_other_ALM__c, No_of_time__c,What_is_the_current_team_structure_w__c, Plz_specify_others__c,Developer_Changes_how_do_you_track__c,How_are_metadata_components_being_dep__c,Plz_specify_other_Metadata_components__c  from Questionnaire_Implementation__c];
        System.assertEquals(true,questionnaire_implementation_Obj.size()>0); 
        //   	 System.assertEquals(false, ApexPages.hasMessages(), 'Expected that there would be a page message after running the test');
        Implementation_Questionnaire_1 obj01 = new Implementation_Questionnaire_1(new ApexPages.StandardController(questionnaire_implementation_Obj[0]));
        PageReference pageRef = Page.ThankYouPage; // Add your VF page Name here
        Test.setCurrentPage(pageRef);
        obj01.quesObj = questionnaire_implementation_Obj[0];
        obj01.isclick = false;
        obj01.questionPage = false;
        obj01.attach = new Attachment();
        obj01.attach1 = new Attachment();
        obj01.companyName = 'test data';
        obj01.Emailval = 'test data';
        Implementation_Questionnaire_1.DeveloperChanges = 'test data';
        Implementation_Questionnaire_1.codebackup = 'test data';
        Implementation_Questionnaire_1.timeDevelopers = 'test data';
        Implementation_Questionnaire_1.Nooftime = 'test data';
        Implementation_Questionnaire_1.Timetakenforcommits = 'test data';
        Implementation_Questionnaire_1.mergeconflictsaddressed = 'test data';
        obj01.leadList = new List<Lead>();
        obj01.selectedUseCases = 'test data';
        obj01.selectedUseCasesDeployment = 'test data';
        obj01.selectedUseCasesDataLoader = 'test data';
        obj01.usedOrNot = 'test data';
        obj01.Save();
        system.assert(obj01.quesObj.Id != null);
        
        Test.StartTest(); 
        
        apexPages.Currentpage().getParameters().put('Id',obj01.quesObj.id);
        Implementation_Questionnaire_1 testAccPlan = new Implementation_Questionnaire_1();
        testAccPlan.shootLasers(5);
        testAccPlan.khootLasers(5);
        testAccPlan.BootLasers(5);
        testAccPlan.ChootLasers(5);
        //testAccPlan.save(); call all your function here
        Test.StopTest();
    }
    
}