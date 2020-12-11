/**********************************************************
@Author - Harish (X-Men)
@name - UploadForOpenEnrollmentControllerTest
@CreateDate - 06/03/2014
@Description - Test class to test the case scenarios for the class "UploadForOpenEnrollmentController".
@Version - 1.0
@reference - None
********************************************************/

@isTest 
private class UploadForOpenEnrollmentControllerTest {
    
    @testSetup static void setup() {
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        
        Open_Enrollment_Meetings__c oem = new Open_Enrollment_Meetings__c();
        oem.Name = 'TestMeeting';
        oem.Account__c = acc.Id;
        oem.Request_is_from__c = 'Commercial Medical';
        oem.Performance_Guarantees__c = 'No';
        oem.Cost_Center_Local__c = 'testCostCenterlocal';
        oem.Cost_Center_National__c = 'National - West - 5100167800';
        oem.Plan_Type__c = 'ANC - AD&D';
        oem.Client_Arrangement__c ='New Business';
        oem.Sole_Carrier_or_Multi_Carriers__c = 'Sole Carrier';
        oem.Dress_Code_for_Event__c ='Business Casual';
        oem.Client_Drivers_Issues_Risks__c ='No Risk';
        oem.Member_Customer_Service_Telephone__c = '1234567890';
        
        insert oem;
    }
    
    //Covers Negative Scenario
    public static testmethod void uploadOETestMethod() {
        
        Open_Enrollment_Meetings__c meet = new Open_Enrollment_Meetings__c();
        
        list<Open_Enrollment_Meetings__c> oem = new list<Open_Enrollment_Meetings__c>();
        oem = [SELECT Id,name FROM Open_Enrollment_Meetings__c Limit 1];
        meet = oem[0];
        
        Test.startTest();
        
        PageReference pageRef = Page.UploadForOpenEnrollment;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(meet); 
        UploadForOpenEnrollmentController uploadOE = new UploadForOpenEnrollmentController(sc);
        uploadOE.fileName = 'test.doc';
        uploadOE.fileBodyContents = String.valueOf(meet);
        uploadOE.fileRefreshPage();
        
        //Check for ApexPages.Message in Assert
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        
        // Check that the error message you are expecting is in pageMessages
        Boolean messageFound = false;

        for(ApexPages.Message message : pageMessages) {
            if(message.getSummary() == 'You can only upload csv files.'
                && message.getDetail() == 'You can only upload csv files.'
                && message.getSeverity() == ApexPages.Severity.ERROR) {
                messageFound = true;        
            }
        }
        
        System.assert(messageFound);
        
        Test.stopTest();
    }
    
    //Covers Positive Scenario
    public static testmethod void uploadOETestMethod1() {
        
        list<Open_Enrollment_Meetings__c> oem = new list<Open_Enrollment_Meetings__c>();
        oem = [SELECT Id,name FROM Open_Enrollment_Meetings__c Limit 1];
       
        
        Test.startTest();
        
        PageReference pageRef = Page.UploadForOpenEnrollment;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(oem[0]); 
        UploadForOpenEnrollmentController uploadOE = new UploadForOpenEnrollmentController(sc);
        //List<SFDC_Volunteer_Event__c> lstOe = uploadOE.openEnrollmentList;
        
        uploadOE.fileName = 'Upload.csv';
        uploadOE.fileBodyContents = String.valueOf('Upload.csv');
        uploadOE.fileRefreshPage();
        
        //List<OpenEnrollmentWrapper> enrollmentWrappers = new List<OpenEnrollmentWrapper>();
        List<String> testColumnRow = new List<String> {'Test','Data'};
        List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames = OpenEnrollmentCSVParserServices.generateColumnNames(testColumnRow, 0);
        Integer expectedCSVRowNumber =  1;
        List<String> testData = new List<String>{'TestName','12345'};
        OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper actualEnrollmentWrapper = OpenEnrollmentCSVParserServices.createOpenEnrollment(testData, testColumnNames, oem[0].Id, expectedCSVRowNumber);
        
        uploadOE.enrollmentWrappers = new List<OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper>{actualEnrollmentWrapper};
        uploadOE.insertRecords();
        
        
        Test.stopTest();
    }
}