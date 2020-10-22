/*
* @author : Legato Health Technologies LLP
* @Date   : 27 - November - 2019
* @Description : Test Class for CMStatusUpdateService
* 
*/ 
@isTest
public class CMStatusUpdateServiceTest {
    
    
    
    static testmethod void cmAccountStructureUpdateTest(){
        
        
        //Msg with 1 WGS group, 1 compass group , each with 1 suffix
        String msg = '{"eventMetaData":{"userId":"ac04840","sourceSystemId":"CM","trackingId":"1212ABC","eventType":"addCustomer"},'
					   +'"responseMsg":[{"globalCustomerId":"98981234","accountID":"<<AccountID>>","statusCode":"SUCCESS","statusMsg":"CustomerInstalled-PreviewReady-orMaintainceCompleted",'
					   +'"systemID":"CM","responseDetails":{"accountInfo":{"customerInfo":{"customers":[{"ids":[{"sourceSystem":"CM","name":"globalCustomerId","value":"CMGID123"},{"sourceSystem":"SFDCCOM2","name":"accountId","value":"<<AccountID>>"}],'
					   +'"subGroups":[{"TargetSystem":"WGS","TargetSystemId":"W22222","groupNumber":"W22222","sfgroupNumber":"<<WGSSuffixId1>>","groupSuffixId":"M001"},'
					   +'{"TargetSystem":"COMPASS","TargetSystemId":"C22222","groupNumber":"C22222","sfgroupNumber":"<<CompassSuffixId1>>","groupSuffixId":"C002"}]}]},'
					   +'"accountBillGroups":[{"ids":[{"sourceSystem":"CM","name":"billGroupId","value":"CMBG001"},{"sourceSystem":"CM","name":"globalCustomerId","value":"CMBG001"},{"sourceSystem":"SFDCCOM2","name":"sfdcBillGroupId","value":"<<SFDCBillGroupID1>>"}],'
					   +'"billConfig":{"billLevelParameters":[{"sourceSystem":"WGS","sequence":"1","billLevel1":"W22222","billLevel2":"M001","billLevel3":"Any","billLevel4":"Any","billGroupId":"Any","effectiveDate":"9999-12-31","expirationDate":"9999-12-31","contractCD":"","productName":"","productType":""},'
					   +'{"sourceSystem":"compass","sequence":"2","billLevel1":"C22222","billLevel2":"C002","billLevel3":"","billLevel4":"","billGroupId":"","effectiveDate":"2019-11-05","expirationDate":"9999-12-31","contractCD":"","productName":"","productType":""}],'
					   +'"billDates":{"paidToDate":"9999-12-31","billToDate":"9999-12-31"}}}]}}}]}';
        
        //CMResponse cmresponse = (CMResponse)JSON.deserialize(msg,CMResponse.class);
        
        
        Account acc1 = IntegrationTestDataUtilty.createAccount(true);
        Opportunity opt1 = IntegrationTestDataUtilty.createOpportunity(acc1.Id,true);
        Group__c Grp1 = IntegrationTestDataUtilty.createGroup(acc1.Id,false);
        Grp1.Name = 'TBD';
        insert Grp1;
        Quote qt = IntegrationTestDataUtilty.createQuote(opt1.Id, Grp1.Id, true);
        Order icr = IntegrationTestDataUtilty.createImplCase(qt.id, acc1.Id,true);
        Implementation_Tracking__c itrac = IntegrationTestDataUtilty.createImplTracking(icr.id, acc1.Id,true);
        Group_plan_design__c gpd1 = IntegrationTestDataUtilty.createGrpPlanDesign(Grp1.id, null,null, true);
        Group_plan_design__c gpd2 = IntegrationTestDataUtilty.createGrpPlanDesign(Grp1.id, null,null, true);
        Invoices_Local__c il = IntegrationTestDataUtilty.createInvoice(acc1.Id,null, grp1.id, true);

        
       
        
        //Insreting Integration Event Log
        Integration_Event_Log__c iel = new Integration_Event_Log__c();
        iel.Tracking_ID__c = '1212ABC';
        iel.System_Name__c = 'SFDCCOM2';
        iel.Event_type__c = 'Add';
        iel.Implementation_Case__c =icr.id;
        iel.Status__c = 'SUCCESS';
        insert iel;
        
        //Invoices_Local__c il2 = new Invoices_Local__c();
        //il2.Account_Legal_Name__c =acc1.Id;
        //il2.Group__c = g1.Id;
        //insert il2;
        msg = msg.replace('<<AccountID>>', acc1.id);
        msg = msg.replace('<<WGSSuffixId1>>',gpd1.id);
        msg = msg.replace('<<CompassSuffixId1>>',gpd2.id);
        msg = msg.replace('<<SFDCBillGroupID1>>',il.id);
        System.debug(msg);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CMStatusUpdateService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        CMStatusUpdateService.updateResponseFromCM();
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
        List<Group__c> g2list = [Select id,name from Group__c where name = 'C22222'];
        Grp1 = [Select id,name from Group__c where id = :Grp1.id];
        gpd1 = [Select id, group_suffix__c,CBP_Bill_Group_ID__c from group_plan_design__c where id = :gpd1.id];
        gpd2 = [Select id, group_suffix__c,CBP_Bill_Group_ID__c from group_plan_design__c where id = :gpd2.id];
        il =   [Select id, CBP_Bill_Group_ID__c from Invoices_Local__c where id = :il.id];
        List<Integration_Event_Log__c> ielList =  [Select id from Integration_Event_Log__c where System_Name__c ='CM'  ];
        System.assertEquals(ielList.Size(),1);
        System.assertEquals(g2list.Size(),1);
        System.assertEquals(Grp1.Name,'W22222');
        System.assertEquals(gpd1.Group_Suffix__c,'M001');
        System.assertEquals(gpd2.Group_Suffix__c,'C002');
        System.assertEquals(gpd1.CBP_Bill_Group_ID__c,'CMBG001');
        System.assertEquals(gpd2.CBP_Bill_Group_ID__c,'CMBG001');
        System.assertEquals(il.CBP_Bill_Group_ID__c,'CMBG001');
        //System.assertEquals(gpd2.CBP_Bill_Group_ID__c,'CMBG001');
    }
    static testmethod void cmMaintTransactionStatusUpdateTest(){
        
        
        //Msg with 1 WGS group, 1 compass group , each with 1 suffix
        String msg = '{"eventMetaData":{"userId":"ac04840","sourceSystemId":"CM","trackingId":"1212ABC","eventType":"Maintenance"},'
					   +'"responseMsg":[{"globalCustomerId":"98981234","accountID":"<<AccountID>>","statusCode":"SUCCESS","statusMsg":"CustomerInstalled-PreviewReady-orMaintainceCompleted",'
					   +'"systemID":"CM","responseDetails":{"accountInfo":{"customerInfo":{"customers":[{"ids":[{"sourceSystem":"CM","name":"globalCustomerId","value":"CMGID123"},{"sourceSystem":"SFDCCOM2","name":"accountId","value":"<<AccountID>>"}],'
					   +'"subGroups":[{"TargetSystem":"WGS","TargetSystemId":"W22222","groupNumber":"W22222","sfgroupNumber":"<<WGSSuffixId1>>","groupSuffixId":"M001"},'
					   +'{"TargetSystem":"COMPASS","TargetSystemId":"C22222","groupNumber":"C22222","sfgroupNumber":"<<CompassSuffixId1>>","groupSuffixId":"C002"}]}]},'
					   +'"accountBillGroups":[{"ids":[{"sourceSystem":"CM","name":"billGroupId","value":"CMBG001"},{"sourceSystem":"CM","name":"globalCustomerId","value":"CMBG001"},{"sourceSystem":"SFDCCOM2","name":"sfdcBillGroupId","value":"<<SFDCBillGroupID1>>"}],'
					   +'"billConfig":{"billLevelParameters":[{"sourceSystem":"WGS","sequence":"1","billLevel1":"W22222","billLevel2":"M001","billLevel3":"Any","billLevel4":"Any","billGroupId":"Any","effectiveDate":"9999-12-31","expirationDate":"9999-12-31","contractCD":"","productName":"","productType":""},'
					   +'{"sourceSystem":"compass","sequence":"2","billLevel1":"C22222","billLevel2":"C002","billLevel3":"","billLevel4":"","billGroupId":"","effectiveDate":"2019-11-05","expirationDate":"9999-12-31","contractCD":"","productName":"","productType":""}],'
					   +'"billDates":{"paidToDate":"9999-12-31","billToDate":"9999-12-31"}}}]}}}]}';
        
        //CMResponse cmresponse = (CMResponse)JSON.deserialize(msg,CMResponse.class);
        
        
        Account acc1 = IntegrationTestDataUtilty.createAccount(true);
        Opportunity opt1 = IntegrationTestDataUtilty.createOpportunity(acc1.Id,true);
        Group__c Grp1 = IntegrationTestDataUtilty.createGroup(acc1.Id,false);
        Grp1.Name = 'TBD';
        insert Grp1;
        Quote qt = IntegrationTestDataUtilty.createQuote(opt1.Id, Grp1.Id, true);
        Order icr = IntegrationTestDataUtilty.createImplCase(qt.id, acc1.Id,false);
        icr.Maintenance_Reason_Customer_Master__c = 'Add new Product (Medical/Specialty only)';
        insert icr;
        Implementation_Tracking__c itrac = IntegrationTestDataUtilty.createImplTracking(icr.id, acc1.Id,true);
        Group_plan_design__c gpd1 = IntegrationTestDataUtilty.createGrpPlanDesign(Grp1.id, null,null, true);
        Group_plan_design__c gpd2 = IntegrationTestDataUtilty.createGrpPlanDesign(Grp1.id, null,null, true);
        Invoices_Local__c il = IntegrationTestDataUtilty.createInvoice(acc1.Id,null, grp1.id, true);
     
        //Insreting Integration Event Log
        Integration_Event_Log__c iel = new Integration_Event_Log__c();
        iel.Tracking_ID__c = '1212ABC';
        iel.System_Name__c = 'SFDCCOM2';
        iel.Event_type__c = 'Maintenance';
        iel.Implementation_Case__c =icr.id;
        iel.Status__c = 'SUCCESS';
        insert iel;
        
        //Invoices_Local__c il2 = new Invoices_Local__c();
        //il2.Account_Legal_Name__c =acc1.Id;
        //il2.Group__c = g1.Id;
        //insert il2;
        msg = msg.replace('<<AccountID>>', acc1.id);
        msg = msg.replace('<<WGSSuffixId1>>',gpd1.id);
        msg = msg.replace('<<CompassSuffixId1>>',gpd2.id);
        msg = msg.replace('<<SFDCBillGroupID1>>',il.id);
        System.debug(msg);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CMStatusUpdateService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        CMStatusUpdateService.updateResponseFromCM();
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
        List<Group__c> g2list = [Select id,name from Group__c where name = 'C22222'];
        Grp1 = [Select id,name from Group__c where id = :Grp1.id];
        gpd1 = [Select id, group_suffix__c,CBP_Bill_Group_ID__c from group_plan_design__c where id = :gpd1.id];
        gpd2 = [Select id, group_suffix__c,CBP_Bill_Group_ID__c from group_plan_design__c where id = :gpd2.id];
        il =   [Select id, CBP_Bill_Group_ID__c from Invoices_Local__c where id = :il.id];
        List<Integration_Event_Log__c> ielList =  [Select id from Integration_Event_Log__c where System_Name__c ='CM'  ];
        System.assertEquals(ielList.Size(),1);
        System.assertEquals(g2list.Size(),1);
        System.assertEquals(Grp1.Name,'W22222');
        System.assertEquals(gpd1.Group_Suffix__c,'M001');
        System.assertEquals(gpd2.Group_Suffix__c,'C002');
        System.assertEquals(gpd1.CBP_Bill_Group_ID__c,'CMBG001');
        System.assertEquals(gpd2.CBP_Bill_Group_ID__c,'CMBG001');
        System.assertEquals(il.CBP_Bill_Group_ID__c,'CMBG001');
        //System.assertEquals(gpd2.CBP_Bill_Group_ID__c,'CMBG001');
    }
    static testmethod void cmGroupNumberUpdateErrorTest(){
        
        // Test if Group number already exist for group record in Salesforce
        //Msg with 1 WGS group, 1 compass group , each with 1 suffix
        String msg = '{"eventMetaData":{"userId":"ac04840","sourceSystemId":"CM","trackingId":"1212ABC","eventType":"addCustomer"},'
					   +'"responseMsg":[{"globalCustomerId":"98981234","accountID":"<<AccountID>>","statusCode":"SUCCESS","statusMsg":"CustomerInstalled-PreviewReady-orMaintainceCompleted",'
					   +'"systemID":"CM","responseDetails":{"accountInfo":{"customerInfo":{"customers":[{"ids":[{"sourceSystem":"CM","name":"globalCustomerId","value":"CMGID123"},{"sourceSystem":"SFDCCOM2","name":"accountId","value":"<<AccountID>>"}],'
					   +'"subGroups":[{"TargetSystem":"WGS","TargetSystemId":"W22222","groupNumber":"W22222","sfgroupNumber":"<<WGSSuffixId1>>","groupSuffixId":"M001"},'
					   +'{"TargetSystem":"COMPASS","TargetSystemId":"C22222","groupNumber":"C22222","sfgroupNumber":"<<CompassSuffixId1>>","groupSuffixId":"C002"}]}]},'
					   +'"accountBillGroups":[{"ids":[{"sourceSystem":"CM","name":"billGroupId","value":"CMBG001"},{"sourceSystem":"CM","name":"globalCustomerId","value":"CMBG001"},{"sourceSystem":"SFDCCOM2","name":"sfdcBillGroupId","value":"<<SFDCBillGroupID1>>"}],'
					   +'"billConfig":{"billLevelParameters":[{"sourceSystem":"WGS","sequence":"1","billLevel1":"W22222","billLevel2":"M001","billLevel3":"Any","billLevel4":"Any","billGroupId":"Any","effectiveDate":"9999-12-31","expirationDate":"9999-12-31","contractCD":"","productName":"","productType":""},'
					   +'{"sourceSystem":"compass","sequence":"2","billLevel1":"C22222","billLevel2":"C002","billLevel3":"","billLevel4":"","billGroupId":"","effectiveDate":"2019-11-05","expirationDate":"9999-12-31","contractCD":"","productName":"","productType":""}],'
					   +'"billDates":{"paidToDate":"9999-12-31","billToDate":"9999-12-31"}}}]}}}]}';
        
        //CMResponse cmresponse = (CMResponse)JSON.deserialize(msg,CMResponse.class);
        
        
        Account acc1 = IntegrationTestDataUtilty.createAccount(true);
        Opportunity opt1 = IntegrationTestDataUtilty.createOpportunity(acc1.Id,true);
        Group__c Grp1 = IntegrationTestDataUtilty.createGroup(acc1.Id,false);
        Grp1.Name = 'TestGroup';
        insert Grp1;
        Quote qt = IntegrationTestDataUtilty.createQuote(opt1.Id, Grp1.Id, true);
        Order icr = IntegrationTestDataUtilty.createImplCase(qt.id, acc1.Id,true);
        Implementation_Tracking__c itrac = IntegrationTestDataUtilty.createImplTracking(icr.id, acc1.Id,true);
        Group_plan_design__c gpd1 = IntegrationTestDataUtilty.createGrpPlanDesign(Grp1.id, null,null, true);
        Group_plan_design__c gpd2 = IntegrationTestDataUtilty.createGrpPlanDesign(Grp1.id, null,null, true);
        Invoices_Local__c il = IntegrationTestDataUtilty.createInvoice(acc1.Id,null, grp1.id, true);

        
       
        
        //Insreting Integration Event Log
        Integration_Event_Log__c iel = new Integration_Event_Log__c();
        iel.Tracking_ID__c = '1212ABC';
        iel.System_Name__c = 'SFDCCOM2';
        iel.Event_type__c = 'Add';
        iel.Implementation_Case__c =icr.id;
        iel.Status__c = 'SUCCESS';
        insert iel;
        
        //Invoices_Local__c il2 = new Invoices_Local__c();
        //il2.Account_Legal_Name__c =acc1.Id;
        //il2.Group__c = g1.Id;
        //insert il2;
        msg = msg.replace('<<AccountID>>', acc1.id);
        msg = msg.replace('<<WGSSuffixId1>>',gpd1.id);
        msg = msg.replace('<<CompassSuffixId1>>',gpd2.id);
        msg = msg.replace('<<SFDCBillGroupID1>>',il.id);
        System.debug(msg);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CMStatusUpdateService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        CMStatusUpdateService.updateResponseFromCM();
        Test.stopTest();
        System.assertEquals(400, res.statusCode);
    }
    static testmethod void cmGroupSuffixUpdateErrorTest(){
        
        // Test if Group number already exist for group record in Salesforce
        //Msg with 1 WGS group, 1 compass group , each with 1 suffix
        String msg = '{"eventMetaData":{"userId":"ac04840","sourceSystemId":"CM","trackingId":"1212ABC","eventType":"addCustomer"},'
					   +'"responseMsg":[{"globalCustomerId":"98981234","accountID":"<<AccountID>>","statusCode":"SUCCESS","statusMsg":"CustomerInstalled-PreviewReady-orMaintainceCompleted",'
					   +'"systemID":"CM","responseDetails":{"accountInfo":{"customerInfo":{"customers":[{"ids":[{"sourceSystem":"CM","name":"globalCustomerId","value":"CMGID123"},{"sourceSystem":"SFDCCOM2","name":"accountId","value":"<<AccountID>>"}],'
					   +'"subGroups":[{"TargetSystem":"WGS","TargetSystemId":"W22222","groupNumber":"W22222","sfgroupNumber":"<<WGSSuffixId1>>","groupSuffixId":"M001"},'
					   +'{"TargetSystem":"COMPASS","TargetSystemId":"C22222","groupNumber":"C22222","sfgroupNumber":"<<CompassSuffixId1>>","groupSuffixId":"C002"}]}]},'
					   +'"accountBillGroups":[{"ids":[{"sourceSystem":"CM","name":"billGroupId","value":"CMBG001"},{"sourceSystem":"CM","name":"globalCustomerId","value":"CMBG001"},{"sourceSystem":"SFDCCOM2","name":"sfdcBillGroupId","value":"<<SFDCBillGroupID1>>"}],'
					   +'"billConfig":{"billLevelParameters":[{"sourceSystem":"WGS","sequence":"1","billLevel1":"W22222","billLevel2":"M001","billLevel3":"Any","billLevel4":"Any","billGroupId":"Any","effectiveDate":"9999-12-31","expirationDate":"9999-12-31","contractCD":"","productName":"","productType":""},'
					   +'{"sourceSystem":"compass","sequence":"2","billLevel1":"C22222","billLevel2":"C002","billLevel3":"","billLevel4":"","billGroupId":"","effectiveDate":"2019-11-05","expirationDate":"9999-12-31","contractCD":"","productName":"","productType":""}],'
					   +'"billDates":{"paidToDate":"9999-12-31","billToDate":"9999-12-31"}}}]}}}]}';
        
        //CMResponse cmresponse = (CMResponse)JSON.deserialize(msg,CMResponse.class);
        
        
        Account acc1 = IntegrationTestDataUtilty.createAccount(true);
        Opportunity opt1 = IntegrationTestDataUtilty.createOpportunity(acc1.Id,true);
        Group__c Grp1 = IntegrationTestDataUtilty.createGroup(acc1.Id,false);
        Grp1.Name = 'TBD';
        insert Grp1;
        Quote qt = IntegrationTestDataUtilty.createQuote(opt1.Id, Grp1.Id, true);
        Order icr = IntegrationTestDataUtilty.createImplCase(qt.id, acc1.Id,true);
        Implementation_Tracking__c itrac = IntegrationTestDataUtilty.createImplTracking(icr.id, acc1.Id,true);
        Group_plan_design__c gpd1 = IntegrationTestDataUtilty.createGrpPlanDesign(Grp1.id, null,null, false);
        gpd1.Group_Suffix__c = 'G001';
        insert gpd1;
        Group_plan_design__c gpd2 = IntegrationTestDataUtilty.createGrpPlanDesign(Grp1.id, null,null, true);
        Invoices_Local__c il = IntegrationTestDataUtilty.createInvoice(acc1.Id,null, grp1.id, true);

        
       
        
        //Insreting Integration Event Log
        Integration_Event_Log__c iel = new Integration_Event_Log__c();
        iel.Tracking_ID__c = '1212ABC';
        iel.System_Name__c = 'SFDCCOM2';
        iel.Event_type__c = 'Add';
        iel.Implementation_Case__c =icr.id;
        iel.Status__c = 'SUCCESS';
        insert iel;
        
        //Invoices_Local__c il2 = new Invoices_Local__c();
        //il2.Account_Legal_Name__c =acc1.Id;
        //il2.Group__c = g1.Id;
        //insert il2;
        msg = msg.replace('<<AccountID>>', acc1.id);
        msg = msg.replace('<<WGSSuffixId1>>',gpd1.id);
        msg = msg.replace('<<CompassSuffixId1>>',gpd2.id);
        msg = msg.replace('<<SFDCBillGroupID1>>',il.id);
        System.debug(msg);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CMStatusUpdateService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        CMStatusUpdateService.updateResponseFromCM();
        Test.stopTest();
        System.assertEquals(400, res.statusCode);
    }
    static testmethod void cmIDCardUpdateTest(){
        
        String msg = '{"eventMetaData":{"userId":"ac04840","sourceSystemId":"CM","trackingId":"1212ABC","eventType":"IDCardRequest"},'
					  +'"responseMsg":[{"globalCustomerId":"98981234","accountID":"<<AccountID>>","statusCode":"SUCCESS","statusMsg":"CustomerInstalled-PreviewReady-orMaintainceCompleted","systemID":"CM",'
					  +'"responseDetails":{"accountInfo":{"customerInfo":{"customers":[{"ids":[{"sourceSystem":"CM","name":"globalCustomerId","value":"CMGID123"},'
					  +'{"sourceSystem":"SFDCCOM2","name":"accountId","value":"<<AccountID>>"}],"miscellaneousInfo":{"idcards":{"triggereddate":"2019-01-01"}}}]}}}}]}';
        
        //CMResponse cmresponse = (CMResponse)JSON.deserialize(msg,CMResponse.class);
        
        
        
        
        Account acc1 = IntegrationTestDataUtilty.createAccount(true);
        Opportunity opt1 = IntegrationTestDataUtilty.createOpportunity(acc1.Id,true);
        Group__c Grp1 = IntegrationTestDataUtilty.createGroup(acc1.Id,true);
        Quote qt = IntegrationTestDataUtilty.createQuote(opt1.Id, Grp1.Id, true);
        Order icr = IntegrationTestDataUtilty.createImplCase(qt.id, acc1.Id,true);
        Implementation_Tracking__c itrac = IntegrationTestDataUtilty.createImplTracking(icr.id, acc1.Id,true);
        
        Id_cards__c idCard = IntegrationTestDataUtilty.createIdCards(itrac.id, true);
        System.debug('Id card record'+idCard.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
        
        //Insreting Integration Event Log
        Integration_Event_Log__c iel = new Integration_Event_Log__c();
        iel.Tracking_ID__c = '1212ABC';
        iel.System_Name__c = 'SFDCCOM2';
        iel.Event_type__c = 'IDCardRequest';
        iel.Implementation_Case__c =icr.id;
        iel.Status__c = 'SUCCESS';
        insert iel;
        //Inserting Group Plan Design
        msg = msg.replace('<<AccountID>>', acc1.id);
        //msg = msg.replace('<<WGSSuffixId1>>',gpd1.id);
        //msg = msg.replace('<<CompassSuffixId1>>',gpd2.id);
        //msg = msg.replace('<<SFDCBillGroupID1>>',il.id);
        System.debug(msg);
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CMStatusUpdateService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        CMStatusUpdateService.updateResponseFromCM();
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
        List<ID_Cards__c> idCardList = [Select id,ID_Cards_Triggered__c from Id_cards__c where id  = :idCard.id];
        System.debug(idCardList.size());
        System.assertEquals(idCardList.Size(),1);
        System.debug(idCardList[0].ID_Cards_Triggered__c);
        System.assertEquals(idCardList[0].ID_Cards_Triggered__c,Date.valueOf('2019-01-01 00:00:00'));
    }
    static testmethod void cmStatusUpdateEventErrorLogTest(){
        String msg = '{"eventMetaData":{"userId":"af53352","sourceSystemId":"CM","trackingId":"1212ABC","eventType":"addCustomer","masterId":"12345","subTrackingId":"12345"},'
					+'"responseMsg":[{"globalCustomerId":"","accountID":"123","statusCode":"FAILURE","statusMsg":"CustomerAddFailed","systemID":"CM","responseDetails":'
					+'{"listOfErrorCodes":[{"category":"Functional","errorCode":"409","bindingField":"globalCustomerId","entityName":"parentCustomer","errorMessage":"ParentCustomerAlreadyExistwithOrganizationName.Name[SASIone6],OrganizationName.dbaName[Richm22]WithCustomerId7571"},'
					+'{"category":"Functional","errorCode":"409","bindingField":"CustomerId","entityName":"Customer","errorMessage":"ChildCustomerAlreadyExistChildCustomerID[7572]withOrganizationName.Name[Cogz781],OrganizationName.dbaName[Coiz778]WithParentCustomerId7571"},'
					+'{"category":"Functional","errorCode":"409","bindingField":"billGroupId","entityName":"BillGroup","errorMessage":"AccountBillGroupAlreadyExistAccountBillGroupID[7188]withOrganizationName.Name[K11242],OrganizationName.dbaName[T112g4B]AssociatedwiththeparentCustomeridnum7571"},'
					+'{"category":"Functional","errorCode":"409","bindingField":"id","entityName":"product","errorMessage":"DuplicatProductwithcntractID[4TN3]"},'
					+'{"category":"Functional","errorCode":"800","bindingField":"groupSuffixBillAssignment","entityName":"customerInfo","errorMessage":"NoBillGroupAssigned.[arrayofthegroupsuffix]"}]}}]}';
        
        
        
        Account acc1 = IntegrationTestDataUtilty.createAccount(true);
        Opportunity opt1 = IntegrationTestDataUtilty.createOpportunity(acc1.Id,true);
        Group__c Grp1 = IntegrationTestDataUtilty.createGroup(acc1.Id,true);
        Quote qt = IntegrationTestDataUtilty.createQuote(opt1.Id, Grp1.Id, true);
        Order icr = IntegrationTestDataUtilty.createImplCase(qt.id, acc1.Id,true);
        Integration_Event_Log__c iel = new Integration_Event_Log__c();
        iel.Tracking_ID__c = '1212ABC';
        iel.System_Name__c = 'SFDCCOM2';
        iel.Event_type__c = 'IDCardRequest';
        iel.Implementation_Case__c =icr.id;
        iel.Status__c = 'SUCCESS';
        insert iel;
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CMStatusUpdateService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        
        CMStatusUpdateService.updateResponseFromCM();
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
        List<Integration_Event_Log__c> ielList = [Select id from Integration_Event_Log__c where id != :iel.id] ;
        List<Integration_Error_Log__c> ieErrorLogList = [Select id from Integration_Error_Log__c where Integration_Event_Log__c = :ielList[0].id];
        System.assertEquals(ielList.Size(),1);
        System.assertEquals(ieErrorLogList.Size(),5);
         
    }
    static testmethod void invalidPayloadFormatTest(){
        
        String msg = '{"eventMetaData":{"userId":"af53352","sourceSystemId":"CM","trackingId":"1212","eventType":"addCustomer","masterId":"12345","subTrackingId":"12345"},"responseMsg":[]}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CMStatusUpdateService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        
        CMStatusUpdateService.updateResponseFromCM();
        Test.stopTest();
        System.assertEquals(400, res.statusCode);
        
    }
    static testmethod void invalidSystemNameTest(){
       
        String msg = '{"eventMetaData":{"userId":"af53352","sourceSystemId":"CM","trackingId":"1212ABC","eventType":"IDCardRequest","masterId":"12345","subTrackingId":"12345"},'
            +'"responseMsg":[{"globalCustomerId":"","accountID":"123","statusCode":"FAILURE","statusMsg":"CustomerAddFailed",'
            +'"systemID":"CMInvalidSystemName123123123123123123123123123123123123123123123"}]}';
       
        Account acc1 = IntegrationTestDataUtilty.createAccount(true);
        Opportunity opt1 = IntegrationTestDataUtilty.createOpportunity(acc1.Id,true);
        Group__c Grp1 = IntegrationTestDataUtilty.createGroup(acc1.Id,true);
        Quote qt = IntegrationTestDataUtilty.createQuote(opt1.Id, Grp1.Id, true);
        Order icr = IntegrationTestDataUtilty.createImplCase(qt.id, acc1.Id,true);
        Integration_Event_Log__c iel = new Integration_Event_Log__c();
        iel.Tracking_ID__c = '1212ABC';
        iel.System_Name__c = 'SFDCCOM2';
        iel.Event_type__c = 'IDCardRequest';
        iel.Implementation_Case__c =icr.id;
        iel.Status__c = 'SUCCESS';
        insert iel;
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CMStatusUpdateService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        
        CMStatusUpdateService.updateResponseFromCM();
        Test.stopTest();
        System.assertEquals(400, res.statusCode);
        
    }
    static testmethod void jSONParseExceptionTest(){
        
        String msg = '{test:test}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CMStatusUpdateService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        CMStatusUpdateService.updateResponseFromCM();
        Test.stopTest();
        System.assertEquals(400, res.statusCode);
        
    }
    static testmethod void blankResponsePayloadTest(){
        
        String msg = '';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CMStatusUpdateService/*';
        req.httpMethod = 'POST';
        //req.requestBody = Blob.valueof(msg);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        CMStatusUpdateService.updateResponseFromCM();
        Test.stopTest();
        System.assertEquals(400, res.statusCode);
        
    }
   
}