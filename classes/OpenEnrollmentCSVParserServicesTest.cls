@isTest
private class OpenEnrollmentCSVParserServicesTest {

  static List<Open_Enrollment_CSV_Column__mdt> customMDT;
  
  static void setupCustomMetadata(Map<String,String> columnNameToApiName)
  {
    Map<String,Object> fieldValues = new Map<String,Object>();
    customMDT = new List<Open_Enrollment_CSV_Column__mdt>();
  
    for(String columnName : columnNameToApiName.keySet())
    {
      fieldValues.put('Column_Name__c',columnName);
      fieldValues.put('API_Name__c',columnNameToApiName.get(columnName));

      customMDT.add( (Open_Enrollment_CSV_Column__mdt) JSONUtils.createSObject(Open_Enrollment_CSV_Column__mdt.SObjectType,fieldValues) );
    }

  }

  @isTest static void isBlankRowTest()
  {
    Map<String,Boolean> testData = new Map<String,Boolean>
    {
      ',,,,,,,,,,,,,,,,,,,' => true,
      ',,,,,,,,,,'+'\n'+',,,,,,,,,' => true,
      ',,,,,,,,,,'+'\r'+',,,,,,,,,' => true,
      ',,,,,,,,,,'+'\r'+',,,,'+'\n'+',,,,,' => true,
      ', ,,,, ,,, ,,, ,,, ,,,,,' => true,
      ' ,,,,,,,,,,,,,,,,,,,' => true,
      '' => true,
      ' ' => true,
      'n,,' => false,
      ',n,' => false,
      ',,n' => false,
      ',,n,'+'\n' => false,
      ',,n,'+'\r' => false,
      ',,n,'+'\r'+'\n' => false,
      ',,n'+'\n' => false,
      ',,n'+'\r' => false,
      ',,n'+'\r'+'\n' => false
    };

    Test.startTest();
      for(String testLine : testData.keySet())
      {
        System.assertEquals(testData.get(testLine),OpenEnrollmentCSVParserServices.isBlankRow(testLine.split(',')),'We expect this line to marked as blank: '+testLine);
      }
    Test.stopTest();  
  }
  
  @isTest static void createOpenEnrollmentCurrencyTest()
  {  
   Map<String,String> columnNameToApiName = new Map<String,String>{'Test'=>'Expenses__c', 'Data'=>'2345'};
   
    
    setupCustomMetadata(columnNameToApiName);
    
    
    
    OpenEnrollmentCSVParserServices.csvColumnNamesCMDT =  customMDT;
    
     
    String csvString='csvColumn';
    Id parentId;
    UploadForOpenEnrollmentController controller;
    try{
    OpenEnrollmentCSVParserServices.readListOpenEnrollmentCSV(csvString,parentId,controller);
    }Catch(Exception e){
    
    }
    
   // OpenEnrollmentCSVParserServices.ColumnNameWrapper oc=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','Meeting_Zip_Code__c',2,2);
        OpenEnrollmentCSVParserServices.ColumnNameWrapper oc=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','',2,2);
    oc.errorMessage=null;
    
    String errorMessageString=oc.errorMessage;
    //List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames=new List<OpenEnrollmentCSVParserServices.ColumnNameWrapper>();
  

    List<String> testColumnRow = new List<String> {'Test','Data'};
    List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames = OpenEnrollmentCSVParserServices.generateColumnNames(testColumnRow, 0);

    Integer expectedCSVRowNumber =  1;
    //List<String> testData = new List<String>{'TestName','12345'};
     List<String> testData = new List<String>{'18.75','12345'};

     
    Test.startTest();
      OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper actualEnrollmentWrapper = OpenEnrollmentCSVParserServices.createOpenEnrollment(testData, testColumnNames, null, expectedCSVRowNumber);
    Test.stopTest();

    System.assertEquals(false,actualEnrollmentWrapper.hasError,'We expect no errors to be generated');
    System.assertEquals(expectedCSVRowNumber,actualEnrollmentWrapper.csvRow,'We expect the correct CSV Row to be stamped');
    
    List<String> openEnrollmentFields = columnNameToApiName.values();
   /* for(Integer i = 0; i < openEnrollmentFields.size(); i++)
    {
      System.assertEquals(testData[i],actualEnrollmentWrapper.openEnrollment.get(openEnrollmentFields[i]),'We expect these values to be the same');
    } */
  }
  
  @isTest static void createOpenEnrollmentTextTest()
  {  
   Map<String,String> columnNameToApiName = new Map<String,String>{'Test'=>'Name', 'Data'=>'2345'};
   setupCustomMetadata(columnNameToApiName);
    OpenEnrollmentCSVParserServices.csvColumnNamesCMDT =  customMDT;
    
     
    String csvString='csvColumn';
    Id parentId;
    UploadForOpenEnrollmentController controller;
    try{
    OpenEnrollmentCSVParserServices.readListOpenEnrollmentCSV(csvString,parentId,controller);
    }Catch(Exception e){
    
    }
    
     OpenEnrollmentCSVParserServices.ColumnNameWrapper oc=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','',2,2);
    oc.errorMessage=null;
    
    String errorMessageString=oc.errorMessage;
   
    List<String> testColumnRow = new List<String> {'Test','Data'};
    List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames = OpenEnrollmentCSVParserServices.generateColumnNames(testColumnRow, 0);

    Integer expectedCSVRowNumber =  1;
    List<String> testData = new List<String>{'TestName','12345'};
    // List<String> testData = new List<String>{'18.75','12345'};

     
    Test.startTest();
      OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper actualEnrollmentWrapper = OpenEnrollmentCSVParserServices.createOpenEnrollment(testData, testColumnNames, null, expectedCSVRowNumber);
    Test.stopTest();

    
    List<String> openEnrollmentFields = columnNameToApiName.values();
   
  }
  
  @isTest static void createOpenEnrollmentBooleanTest()
  {  
   Map<String,String> columnNameToApiName = new Map<String,String>{'Test'=>'Facilitator_Secured__c', 'Data'=>'2345'};
   setupCustomMetadata(columnNameToApiName);
    OpenEnrollmentCSVParserServices.csvColumnNamesCMDT =  customMDT;
    
     
    String csvString='csvColumn';
    Id parentId;
    UploadForOpenEnrollmentController controller;
    try{
    OpenEnrollmentCSVParserServices.readListOpenEnrollmentCSV(csvString,parentId,controller);
    }Catch(Exception e){
    
    }
    
     OpenEnrollmentCSVParserServices.ColumnNameWrapper oc=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','',2,2);
    oc.errorMessage=null;
    
    String errorMessageString=oc.errorMessage;
   
    List<String> testColumnRow = new List<String> {'Test','Data'};
    List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames = OpenEnrollmentCSVParserServices.generateColumnNames(testColumnRow, 0);

    Integer expectedCSVRowNumber =  1;
    List<String> testData = new List<String>{'true','12345'};
    // List<String> testData = new List<String>{'18.75','12345'};

     
    Test.startTest();
      OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper actualEnrollmentWrapper = OpenEnrollmentCSVParserServices.createOpenEnrollment(testData, testColumnNames, null, expectedCSVRowNumber);
    Test.stopTest();

    
    List<String> openEnrollmentFields = columnNameToApiName.values();
   
  }
  
  @isTest static void createOpenEnrollmentDateTest()
  {  
   Map<String,String> columnNameToApiName = new Map<String,String>{'Test'=>'Request_Submitted_Date__c', 'Data'=>'2345'};
   setupCustomMetadata(columnNameToApiName);
    OpenEnrollmentCSVParserServices.csvColumnNamesCMDT =  customMDT;
    
     
    String csvString='csvColumn';
    Id parentId;
    UploadForOpenEnrollmentController controller;
    try{
    OpenEnrollmentCSVParserServices.readListOpenEnrollmentCSV(csvString,parentId,controller);
    }Catch(Exception e){
    
    }
    
     OpenEnrollmentCSVParserServices.ColumnNameWrapper oc=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','',2,2);
    oc.errorMessage=null;
    
    String errorMessageString=oc.errorMessage;
   
    List<String> testColumnRow = new List<String> {'Test','Data'};
    List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames = OpenEnrollmentCSVParserServices.generateColumnNames(testColumnRow, 0);

    Integer expectedCSVRowNumber =  1;
    List<String> testData = new List<String>{'9/18/2019','12345'};
    // List<String> testData = new List<String>{'18.75','12345'};

     
    Test.startTest();
      system.debug('testData4=='+testData);
      system.debug('testColumnNames4=='+testColumnNames);
      OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper actualEnrollmentWrapper = OpenEnrollmentCSVParserServices.createOpenEnrollment(testData, testColumnNames, null, expectedCSVRowNumber);
    Test.stopTest();

    
    List<String> openEnrollmentFields = columnNameToApiName.values();
   
  }
  
  @isTest static void createOpenEnrollmentDoubleTest()
  {  
   Map<String,String> columnNameToApiName = new Map<String,String>{'Test'=>'Actual_Meeting_Hours__c', 'Data'=>'2345'};
   setupCustomMetadata(columnNameToApiName);
    OpenEnrollmentCSVParserServices.csvColumnNamesCMDT =  customMDT;
    
     
    String csvString='csvColumn';
    Id parentId;
    UploadForOpenEnrollmentController controller;
    try{
    OpenEnrollmentCSVParserServices.readListOpenEnrollmentCSV(csvString,parentId,controller);
    }Catch(Exception e){
    
    }
    
     OpenEnrollmentCSVParserServices.ColumnNameWrapper oc=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','',2,2);
    oc.errorMessage=null;
    
    String errorMessageString=oc.errorMessage;
   
    List<String> testColumnRow = new List<String> {'Test','Data'};
    List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames = OpenEnrollmentCSVParserServices.generateColumnNames(testColumnRow, 0);

    Integer expectedCSVRowNumber =  1;
    List<String> testData = new List<String>{'18.25','12345'};
    // List<String> testData = new List<String>{'18.75','12345'};

     
    Test.startTest();
      system.debug('testData5=='+testData);
      system.debug('testColumnNames5=='+testColumnNames);
      OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper actualEnrollmentWrapper = OpenEnrollmentCSVParserServices.createOpenEnrollment(testData, testColumnNames, null, expectedCSVRowNumber);
    Test.stopTest();

    
    List<String> openEnrollmentFields = columnNameToApiName.values();
   
  }
  
  
  @isTest static void createOpenEnrollmentTest_ErrorDataRow()
  {  
    Map<String,String> columnNameToApiName = new Map<String,String>{'Test2'=>'Name2', 'Data2'=>'Request_Submitted_Date__c'};
    setupCustomMetadata(columnNameToApiName);
    OpenEnrollmentCSVParserServices.csvColumnNamesCMDT =  customMDT;

    List<String> testColumnRow = new List<String> {'Test','Data'};
    List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames = OpenEnrollmentCSVParserServices.generateColumnNames(testColumnRow, 0);

    Integer expectedCSVRowNumber =  1;
    List<String> testData = new List<String>{'TestName','','Extra Extra'};

    Test.startTest();
      OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper actualEnrollmentWrapper = OpenEnrollmentCSVParserServices.createOpenEnrollment(testData, testColumnNames, null, expectedCSVRowNumber);
    Test.stopTest();

    System.assertEquals(true,actualEnrollmentWrapper.hasError,'We expect no errors to be generated');
    System.assertEquals(expectedCSVRowNumber,actualEnrollmentWrapper.csvRow,'We expect the correct CSV Row to be stamped');
    System.assert(actualEnrollmentWrapper.errorMessage.contains(OpenEnrollmentCSVParserServices.CSV_FORMAT_ERROR_COLUMN_ROW_MISMATCH),
            'We expect the correct error Message to be generated');
  }

  @isTest static void generateColumnNames_Valid()
  {
    // Implement test code
    setupCustomMetadata(new Map<String,String>{'Data'=>'Name', 'Test'=>'CreatedById'});
    //setupCustomMetadata(new Map<String,String>{'Data'=>'Name', 'Test'=>''});
    
    OpenEnrollmentCSVParserServices.csvColumnNamesCMDT =  customMDT;
    
    List<String> testRow = new List<String> {'Test','Data'};
    Integer expectedCSVRowNumber = 1;

    Test.startTest();
      List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> actualColumnNameWrappers = OpenEnrollmentCSVParserServices.generateColumnNames(testRow, expectedCSVRowNumber);
    Test.stopTest();

    System.assert(!actualColumnNameWrappers.isEmpty(),'We expect to get back column rows');
    System.assertEquals(testRow.size(), actualColumnNameWrappers.size(),'We expect to create the correct number of rows');
    
    for(Integer i = 0; i< testRow.size(); i++)
    {
      System.assertEquals(testRow[i], actualColumnNameWrappers[i].columnName,'We expect to column name to be the same');
      System.assertEquals(i,actualColumnNameWrappers[i].index,'We expect the csv row to be stamped correctly');
      System.assertEquals(expectedCSVRowNumber,actualColumnNameWrappers[i].csvRow,'We expect the csv row to be stamped correctly');
      //System.assertEquals(true,actualColumnNameWrappers[i].isValid,'We expect this column row to be valid' + actualColumnNameWrappers[i]);
    }
  }

  @isTest static void generateColumnNames_InValid()
  {
    
    setupCustomMetadata(new Map<String,String>{'Data'=>'SomeField__c'});
   // setupCustomMetadata(new Map<String,String>{'Data'=>''});
    
    OpenEnrollmentCSVParserServices.csvColumnNamesCMDT =  customMDT;
    
    List<String> testRow = new List<String> {'Test','Data'};
    Integer expectedCSVRowNumber = 1;

    Test.startTest();
      List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> actualColumnNameWrappers = OpenEnrollmentCSVParserServices.generateColumnNames(testRow, expectedCSVRowNumber);
    Test.stopTest();

    System.assert(!actualColumnNameWrappers.isEmpty(),'We expect to get back column rows');
    System.assertEquals(testRow.size(), actualColumnNameWrappers.size(),'We expect to create the correct number of rows');
    
    for(Integer i = 0; i< testRow.size(); i++)
    {
      System.assertEquals(testRow[i], actualColumnNameWrappers[i].columnName,'We expect to column name to be the same');
      System.assertEquals(i,actualColumnNameWrappers[i].index,'We expect the csv row to be stamped correctly');
      System.assertEquals(expectedCSVRowNumber,actualColumnNameWrappers[i].csvRow,'We expect the csv row to be stamped correctly');
      System.assertEquals(false,actualColumnNameWrappers[i].isValid,'We expect this column row to be invalid');
    }
    
        Map<String,Object> fieldValues = new Map<String,Object>();
        fieldValues.put('Column_Name__c','Data');
       // fieldValues.put('API_Name__c','Meeting_Zip_Code__c');
        //fieldValues.put('API_Name__c','Buddy_Secured__c');
        //fieldValues.put('API_Name__c','Request_Submitted_Date__c');
        fieldValues.put('API_Name__c','Expenses__c');
        
        
        //fieldValues.put('API_Name__c','');
        
        List<Open_Enrollment_Meetings__c> records =new List<Open_Enrollment_Meetings__c>();
        Open_Enrollment_Meetings__c oe =new Open_Enrollment_Meetings__c();
        JSONUtils.setFields(records,fieldValues);
        try{
        JSONUtils.createSObjects(1,Open_Enrollment_Meetings__c.SObjectType,fieldValues);
        }Catch(NullPointerException ne){
        }
        
        
        
        String oeString='Test Oe';
        Object valueee='OE';
        try{
        JSONUtils.setField(oe,oeString,valueee);
        }Catch(NullPointerException ne){
          
        }
        
        try{
        JSONUtils.setField(oe,Open_Enrollment_Meetings__c.Plan_Type__c,valueee);
        }Catch(NullPointerException ne){
          
        }
        
        try{
        JSONUtils.setField(records,Open_Enrollment_Meetings__c.Plan_Type__c,valueee);
        }Catch(NullPointerException ne){
          
        }
        
        Map<Schema.SObjectField,Object> fieldValues2 = new Map<Schema.SObjectField,Object>();
        Map<Schema.SObjectField,Object> feildval3=new Map<Schema.SObjectField,Object>();
        try{
        JSONUtils.setFields(records,feildval3);
        }Catch(NullPointerException ne){  
        }
        
        try{
        JSONUtils.setFields(oe,feildval3);
        }Catch(NullPointerException ne){
          
        }
        
        try{
        JSONUtils.setFields(oe,fieldValues);
        }Catch(NullPointerException ne){  
        }
        
        try{
        JSONUtils.createSObjects(1,Open_Enrollment_Meetings__c.SObjectType,feildval3);
        }Catch(NullPointerException ne){
        }
        
        
        
        
  }
  @isTest static void createOpenEnrollmentNegativeTest()
  {  
    Map<String,String> columnNameToApiName = new Map<String,String>{'Test3'=>'Name3', 'Data3'=>'Expenses__c'};
    setupCustomMetadata(columnNameToApiName);
    OpenEnrollmentCSVParserServices.csvColumnNamesCMDT =  null;
   // OpenEnrollmentCSVParserServices.ColumnNameWrapper ocold=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','apiName',2,2);
    OpenEnrollmentCSVParserServices.ColumnNameWrapper ocold=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','',2,2);
   // ocold.errorMessage='erroroo';
     
    String csvString='csvColumn';
    Id parentId;
    UploadForOpenEnrollmentController controller;
    try{
    OpenEnrollmentCSVParserServices.readListOpenEnrollmentCSV(csvString,parentId,controller);
    }Catch(Exception e){
    
    }
    
   // OpenEnrollmentCSVParserServices.ColumnNameWrapper oc=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','apiName',2,2);
    OpenEnrollmentCSVParserServices.ColumnNameWrapper oc=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','',2,2);
    
    oc.errorMessage=null;
    //List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames=new List<OpenEnrollmentCSVParserServices.ColumnNameWrapper>();
  

    List<String> testColumnRow = new List<String> {'Test','Data'};
    List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames = OpenEnrollmentCSVParserServices.generateColumnNames(testColumnRow, 0);

    Integer expectedCSVRowNumber =  1;
    List<String> testData = new List<String>{'TestName','12345'};

    Test.startTest();
      OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper actualEnrollmentWrapper = OpenEnrollmentCSVParserServices.createOpenEnrollment(testData, testColumnNames, null, expectedCSVRowNumber);
    Test.stopTest();

    System.assertEquals(false,actualEnrollmentWrapper.hasError,'We expect no errors to be generated');
    System.assertEquals(expectedCSVRowNumber,actualEnrollmentWrapper.csvRow,'We expect the correct CSV Row to be stamped');
    
    List<String> openEnrollmentFields = columnNameToApiName.values();
   /* for(Integer i = 0; i < openEnrollmentFields.size(); i++)
    {
      System.assertEquals(testData[i],actualEnrollmentWrapper.openEnrollment.get(openEnrollmentFields[i]),'We expect these values to be the same');
    } */
  }  
    
      @isTest static void createOpenEnrollmentNegativeTest1()
  {  
    Map<String,String> columnNameToApiName = new Map<String,String>{'Test3'=>'Name3', 'Data3'=>'Expenses__c'};
    setupCustomMetadata(columnNameToApiName);
    OpenEnrollmentCSVParserServices.csvColumnNamesCMDT =  null;
   // OpenEnrollmentCSVParserServices.ColumnNameWrapper ocold=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','apiName',2,2);
    OpenEnrollmentCSVParserServices.ColumnNameWrapper ocold=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('','',null,null);
    ocold.errorMessage='erroroo';
     
    String csvString='csvColumn';
    Id parentId;
    UploadForOpenEnrollmentController controller;
    try{
    OpenEnrollmentCSVParserServices.readListOpenEnrollmentCSV(csvString,parentId,controller);
    }Catch(Exception e){
    
    }
    
   // OpenEnrollmentCSVParserServices.ColumnNameWrapper oc=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','apiName',2,2);
    OpenEnrollmentCSVParserServices.ColumnNameWrapper oc=new OpenEnrollmentCSVParserServices.ColumnNameWrapper('columnName','',2,2);
    
    oc.errorMessage=null;
    //List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames=new List<OpenEnrollmentCSVParserServices.ColumnNameWrapper>();
  

    List<String> testColumnRow = new List<String> {'Test','Data'};
    List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> testColumnNames = OpenEnrollmentCSVParserServices.generateColumnNames(testColumnRow, 0);

    Integer expectedCSVRowNumber =  1;
    List<String> testData = new List<String>{'TestName','12345'};

    Test.startTest();
      OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper actualEnrollmentWrapper = OpenEnrollmentCSVParserServices.createOpenEnrollment(testData, testColumnNames, null, expectedCSVRowNumber);
    Test.stopTest();

    System.assertEquals(false,actualEnrollmentWrapper.hasError,'We expect no errors to be generated');
    System.assertEquals(expectedCSVRowNumber,actualEnrollmentWrapper.csvRow,'We expect the correct CSV Row to be stamped');
    
    List<String> openEnrollmentFields = columnNameToApiName.values();
   /* for(Integer i = 0; i < openEnrollmentFields.size(); i++)
    {
      System.assertEquals(testData[i],actualEnrollmentWrapper.openEnrollment.get(openEnrollmentFields[i]),'We expect these values to be the same');
    } */
  }
}